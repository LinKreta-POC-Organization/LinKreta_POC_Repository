/* 
     Written By: Bhanwar Singh
     Created Date: 1/12/2023
     Last Modified By : Bhanwar Singh
     Last Modified Date : 27-04-23
     Description : This class is used to find data from MCA. 
     Variable Used in Method : - 
       searchString : - Company Name from LWC component.
       mcaId : - Company MCA Id
*/

public class newClientDataFromMCA {
    @AuraEnabled
    public static  Map<String,String> newClientCompanySearchByName(String searchString){
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        MCA__mdt  entitySearch = [SELECT x_karza_key__c, URL__c ,Label FROM MCA__mdt Where Label = 'Entity Search API' Limit 1];
        req.setEndpoint(entitySearch.URL__c);
       
        req.setMethod('POST');
        req.setHeader('Content-Type','application/json');
        req.setHeader('x-karza-key',entitySearch.x_karza_key__c);
        
        String reqBody = '{"id":"","filter":{"name":"'+searchString+'","email":"","domain":"","domainSearch":false,"address":"","contact":"","fatherName":"","dateOfInception":""},"entitySearch":true,"nameMatch":true,"nameMatchThreshold":true,"temporaryKid":false,"sources":["mca", "mca_director", "pan", "gst", "iec", "tan", "epf", "udyam", "udyog_aadhaar", "lin", "lei","startup_recognition"]}';
        req.setTimeout(30000);
        System.debug('resp.getBody() --->'+reqBody);
        req.setBody(reqBody);

        HttpResponse resp = http.send(req);        
		// InputRequests respoApex=(InputRequests) System.JSON.deserialize(resp.getBody(), InputRequests.class);
        System.debug('resp.getBody() --->'+resp.getBody());
        Map<String,String> listCompany = new Map<String,String>();
        
        try{
            mcaEntitySearchWrapperMain respoApex=(mcaEntitySearchWrapperMain) System.JSON.deserialize(resp.getBody(), mcaEntitySearchWrapperMain.class);
            System.debug('respoApex size : ' + respoApex.result.size());
            Integer iterationCount = respoApex.result.size() < 20 ? respoApex.result.size() : 20; 
            for(Integer i=0;i<iterationCount;i++){
                String str;
                //System.debug('Result : ' + respoApex.result[i]);
                //System.debug('Location : ' + respoApex.result[i].location);
                if(respoApex.result != null){
                    if(respoApex.result[i] != null ){
                        if(respoApex.result[i].location != Null){
                            str = respoApex.result[i].name + ' $$$$ ' +respoApex.result[i].location;
                        }
                        else{
                            str = respoApex.result[i].name;
                        }
                    }
                    
                }
                
                listCompany.put(respoApex.result[i].kid+'$$$$'+respoApex.result[i].entityId,str);
            }
        }
        Catch(Exception e){
            ErrorLogCreater_cls.apexDebugLoggerForAPICallout(e, 'newClientDataFromMCA' , 'newClientCompanySearchByName' , '' , reqBody,resp.getBody(), entitySearch.URL__c );
        }
        
           
        System.debug(listCompany);    
        return listCompany;
    }
    @AuraEnabled
    public static List<String> newClientCompanySearchEnityData(String mcaId){
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        MCA__mdt  entitySearch = [SELECT x_karza_key__c, URL__c ,Label FROM MCA__mdt Where Label = 'Entity Profile - DataBase API' Limit 1];
        req.setEndpoint(entitySearch.URL__c);
       
        req.setMethod('POST');
        req.setHeader('Content-Type','application/json');
        req.setHeader('x-karza-key',entitySearch.x_karza_key__c);
        
        String reqBody = '{"id":"'+mcaId+'","template":"karza_test"}';
        req.setTimeout(50000);
        req.setBody(reqBody);
        List<String> results = new List<String>(); 
        HttpResponse resp;
		// InputRequests respoApex=(InputRequests) System.JSON.deserialize(resp.getBody(), InputRequests.class);
        try{
            resp = http.send(req); 
            String respBody = resp.getBody();
            	
            respBody=respBody.replace('state_', 'state');
            respBody=respBody.replace('wageYearMonth_', 'wageYearMonth');	
            mcaEntityDataBaseWrapper respoApex=(mcaEntityDataBaseWrapper) System.JSON.deserialize(respBody, mcaEntityDataBaseWrapper.class);
            String regAdd = null;
            String status = '';
            String city;
            String state;
            String pin;
            if(respoApex.Result.statutoryRegistration.Lei.size()>0 ){
                if(respoApex.Result.statutoryRegistration.Lei[0].headquartersAddress.addressLine1 != Null){
                    regAdd = respoApex.Result.statutoryRegistration.Lei[0].headquartersAddress.addressLine1;
                }
                if(respoApex.Result.statutoryRegistration.Lei[0].headquartersAddress.addressLine2 != Null){
                    regAdd =regAdd + ' '+ respoApex.Result.statutoryRegistration.Lei[0].headquartersAddress.addressLine2;
                }
                status = respoApex.Result.statutoryRegistration.Lei[0].entityStatus;
                city = respoApex.Result.statutoryRegistration.Lei[0].headquartersAddress.city;
                state = respoApex.Result.statutoryRegistration.Lei[0].headquartersAddress.region;
                pin = respoApex.Result.statutoryRegistration.Lei[0].headquartersAddress.pincode;
            }
            
            if(regAdd != null) 
            {
                results.add(regAdd);
            }
            else{
                results.add(' ');
            }
            
            if(status != null)
            {
                results.add(status);//1
            }
            else{
                results.add(' ');
            }
            
           
            String symbol ='';
            String price = '';
            if(respoApex.Result.statutoryRegistration.ExchangeInformation.NseSecurity.size()>0){
                symbol = respoApex.Result.statutoryRegistration.ExchangeInformation.NseSecurity[0].symbol;
                price=newClientDataFromMCA.newClientCompanyClosingPrice(symbol);
            }
            
            if(symbol != null)
            {
                results.add(symbol);//2
            }
            else{
                results.add(' ');
            }
            String countryofINC = '';
            if(respoApex.Result.statutoryRegistration.mca.size()>0){
                countryofINC = respoApex.Result.statutoryRegistration.mca[0].countryOfIncorporation;
            }
            
            if(countryofINC != null)
            {
                results.add(countryofINC);//3
            } else{
                results.add(' ');
            }
            String domParent;
             if(respoApex.Result.statutoryRegistration.Lei.size()>0 ){
                 domParent = respoApex.Result.statutoryRegistration.Lei[0].dparentName;
             }
            if(domParent != null)
            {
                results.add(domParent);//4
            }
            else{
                results.add(' ');
            }

			String isin;            
            if(respoApex.Result.statutoryRegistration.ExchangeInformation.BseSecurity.size()>0){
                isin = respoApex.Result.statutoryRegistration.ExchangeInformation.BseSecurity[0].isin;
            }
            
             
            if(isin != null)
            {
                results.add(isin);//5
            }
            else{
                results.add(' ');
            }
            if(respoApex.Result.statutoryRegistration.Lei.size()>0){
                String ultParent = respoApex.Result.statutoryRegistration.Lei[0].uparentName;
                if(ultParent != null)
                {
                    results.add(ultParent);//6
                }
                else{
                    results.add(' ');
                }
            }
            else{
                    results.add(' ');
            }
            
            String dateofINC = respoApex.Result.profile.dateOfIncorporation;
            if(dateofINC != null)
            {
                results.add(dateofINC);//7
            }
            else{
                results.add(' ');
            }
            String classZ = respoApex.Result.profile.entityClass;
            if(classZ != null)
            {
                results.add(classZ); //8
            }
            else{
                results.add(' ');
            }
            String listingStatus = '';
            if(respoApex.Result.statutoryRegistration.mca.size()>0){
                listingStatus = respoApex.Result.statutoryRegistration.mca[0].listingStatus;
            }
            
            if(listingStatus != null)
            {
                results.add(listingStatus);//9
            }else{
                results.add(' ');
            }
            
            String industry = respoApex.Result.profile.industry;
            
            if(industry != null)
            {
                results.add(industry);//10
            }
            else{
                results.add(' ');
            }
            String email = respoApex.Result.profile.email;
            
            if(email != null)
            {
                results.add(email);//11
            }
            else{
                results.add(' ');
            }
            String contact = respoApex.Result.profile.contact;
            
            if(contact != null)
            {
                results.add(contact);//12
            }
            else{
                results.add(' ');
            }
            List<String> contactsBODandKMP = newClientDataFromMCA.newClientBODMCA(resp.getBody());
            
            if(contactsBODandKMP[0] != null)
            {
                results.add(contactsBODandKMP[0]);//13 BOD
            }
            else{
                results.add(' ');
            }
            string fyearMCA = System.Label.MCAFinancialYear;
            results.add(fyearMCA); //14

            String website = null;
            if(respoApex.Result.statutoryRegistration.Epf.size()>0){
                website =  respoApex.Result.statutoryRegistration.Epf[0].emailDomain;
            }
                
            
            if(website != null)
            {
                results.add(website);//15
            }
            else{
                results.add(' ');
            }
            if(city != null)
            {
                results.add(city);//16
            }
            else{
                results.add(' ');
            }
            if(state != null)
            {
                List<State__c> stateList = [Select Id, Code__c, Country_code__c,StateCode__c, Name  From State__c Where Name=:state AND StateCode__c != Null];
                if(stateList.size()>0){
                    results.add(stateList[0].StateCode__c);
                }
                else{
                    results.add(state);
                }
                //17
            }
            else{
                results.add(' ');
            }
            if(pin != null)
            {
                results.add(pin);//18
            }
            else{
                results.add(' ');
            }
            if(contactsBODandKMP[1] != null)
            {
                results.add(contactsBODandKMP[1]);//19 KMP
            }
            else{
                results.add(' ');
            }
            if(contactsBODandKMP[2] != null)
            {
                results.add(contactsBODandKMP[2]);//20 CEO
            }
            else{
                results.add(' ');
            }
            if(contactsBODandKMP[3] != null)
            {
                results.add(contactsBODandKMP[3]);//21 Chairman
            }
            else{
                results.add(' ');
            }
            if(price!=''){
                results.add(price);//22 Price
            }else{
                results.add(' ');
            }
            //23-08 About 
            String typeCompany = respoApex.Result.profile.type;
            if(typeCompany!=''){
                results.add(typeCompany);//23 
            }else{
                results.add(' ');
            }
            if( respoApex.Result.statutoryRegistration.gst.Size()>0){
                Integer count=0;
                Set<String> gstCountry = new Set<String>();
                Set<String> gstCountry2 = new Set<String>();
                for(integer x=0;x<respoApex.Result.statutoryRegistration.gst.Size();x++){
                    gstCountry.add(respoApex.Result.statutoryRegistration.gst[x].state);
                    count = count+respoApex.Result.statutoryRegistration.gst[x].branches.size();
                    system.debug('gst state --->'+gstCountry +' '+respoApex.Result.statutoryRegistration.gst[x].state);
                }
                String sInteger = String.valueOf(gstCountry.Size());
                results.add(sInteger);
                results.add(String.valueOf(count));
            }
            else{
                results.add(' ');//24 
                results.add(' ');//25
            }
            if(dateofINC!=''){
                Integer currentYear = System.today().year();
                Integer foundedYear = Integer.valueOf(dateofINC.split('-')[2]);
                foundedYear = currentYear-foundedYear;
                results.add(String.valueOf(foundedYear)); //26
            }   
            else{
                results.add('0');
            }
            Integer maxYear=0;
            Integer employeeCount =0;
            Integer thisYear=0;
            for(Integer i=0;i<respoApex.Result.statutoryRegistration.Epf.size();i++){
                if(respoApex.Result.statutoryRegistration.Epf[i].employeeCounts.size()>0){
                    Integer Index =respoApex.Result.statutoryRegistration.Epf[i].employeeCounts.size() -1;
                    thisYear = Integer.valueOf(respoApex.Result.statutoryRegistration.Epf[i].employeeCounts[Index].wageYearMonth);
                    if(thisYear>maxYear){
                        employeeCount =0;
                        employeeCount = respoApex.Result.statutoryRegistration.Epf[i].employeeCounts[Index].employeeCount;
                        maxYear = thisYear;
                    }else if(thisYear==maxYear){
                        employeeCount=employeeCount+respoApex.Result.statutoryRegistration.Epf[i].employeeCounts[Index].employeeCount;
                    }
                }
            }
            System.debug(employeeCount+'   '+maxYear);
            if(String.valueOf(employeeCount)!=''){
                results.add(String.valueOf(employeeCount));//27
            }else{
                results.add(' ');
            }
            if(String.valueOf(maxYear)!=''){
                results.add(String.valueOf(maxYear));//28
            }else{
                results.add(' ');
            }
            
            String pan ='';
            String sharedupCapital='';
            if(respoApex.Result.statutoryRegistration.mca.size()>0)
            {
                sharedupCapital = respoApex.Result.statutoryRegistration.mca[0].paidUpCapital;
                
            }
            System.debug('sharedupCapital : ' + sharedupCapital);

            if(String.isNotBlank(sharedupCapital)){
                results.add(sharedupCapital); //29
            }else{
                results.add('0');
            }
            
            
            for(Integer i=0;i<respoApex.Result.profile.pans.size();i++){
                if(i==0){
                    pan =respoApex.Result.profile.pans[i];
                }
                else{
                    pan = pan+' , '+respoApex.Result.profile.pans[i];
                }
            }
            results.add(pan); //30
            if(isin!=''){
                results.add('BSE');//31
            }
            else{
                results.add(' ');//31
            }
            if(state !=''){
                results.add(state);//31
            }
            else{
                results.add(' ');
            }
            String constitutionType = respoApex.Result.profile.constitutionOfBusiness;
            if(constitutiontype!=''){
                results.add(constitutiontype);
            }else{
                results.add(' ');
            }
            String registeredAddress = respoApex.Result.profile.registeredAddress;
            if(registeredAddress!=''){
                results.add(registeredAddress);
            }else{
                results.add(' ');
            }
            
        }
        catch(Exception e){
            system.debug(e.getMessage()+'  '+e.getLineNumber());
            ErrorLogCreater_cls.apexDebugLoggerForAPICallout(e, 'newClientDataFromMCA' , 'newClientCompanySearchEnityData' , '' , reqBody,resp.getBody(), entitySearch.URL__c );
        }
        system.debug(results);
        for(String str : results){
            System.debug(str);
        }
        return results;
    }
    public static List<string> newClientBODMCA(String respBody){
        String bod = '';
        String kmp = '';
        String ceo = '';
        String chairman = '';
        try{
            mcaEntityDataBaseWrapper respoApex=(mcaEntityDataBaseWrapper) System.JSON.deserialize(respBody, mcaEntityDataBaseWrapper.class);
            
            
            //bod = respoApex.Result.Management.Current[0].name + ' (' +respoApex.Result.Management.Current[0].designation+' Email:- ' +respoApex.Result.Management.Current[0].email+')' ;
            for(integer i=0;i<respoApex.Result.Management.Current.Size();i++){
                if(respoApex.Result.Management.Current[i].designation=='DIRECTOR' || respoApex.Result.Management.Current[i].designation=='WHOLETIME DIRECTOR' ||respoApex.Result.Management.Current[i].designation=='MANAGING DIRECTOR' ||respoApex.Result.Management.Current[i].designation=='CEO AND MANAGING DIRECTOR' ){
                    if(bod!=''){
                        bod = bod +' , ' + respoApex.Result.Management.Current[i].name + ' (' +respoApex.Result.Management.Current[i].designation+' Email:- ' +respoApex.Result.Management.Current[i].email+')';
                    }
                    else{
                        bod = respoApex.Result.Management.Current[i].name + ' (' +respoApex.Result.Management.Current[i].designation+' Email:- ' +respoApex.Result.Management.Current[i].email+')';
                    }
                }
                else{
                    if(kmp!=''){
                        kmp = kmp +' , ' + respoApex.Result.Management.Current[i].name + ' (' +respoApex.Result.Management.Current[i].designation+' Email:- ' +respoApex.Result.Management.Current[i].email+')';
                    }
                    else{
                        kmp = respoApex.Result.Management.Current[i].name + ' (' +respoApex.Result.Management.Current[i].designation+' Email:- ' +respoApex.Result.Management.Current[i].email+')';
                    }
                    
                }
                if(respoApex.Result.Management.Current[i].designation.contains('CEO')){
                    ceo = respoApex.Result.Management.Current[i].name;
                }
                if(respoApex.Result.Management.Current[i].designation.contains('CHAIRMAN')){
                    chairman = respoApex.Result.Management.Current[i].name;
                }
                
            }
            for(integer i=1;i<respoApex.Result.Management.former.Size();i++){
                if(respoApex.Result.Management.former[i].designation=='DIRECTOR' || respoApex.Result.Management.former[i].designation=='WHOLETIME DIRECTOR' ||respoApex.Result.Management.former[i].designation=='MANAGING DIRECTOR' ||respoApex.Result.Management.former[i].designation=='CEO AND MANAGING DIRECTOR' ){
                    if(bod!=''){
                        bod = bod +' , ' + respoApex.Result.Management.former[i].name + ' (' +respoApex.Result.Management.former[i].designation+' Email:- ' +respoApex.Result.Management.former[i].email+')';
                    }
                    else{
                        bod = respoApex.Result.Management.former[i].name + ' (' +respoApex.Result.Management.former[i].designation+' Email:- ' +respoApex.Result.Management.former[i].email+')';
                    }
                }
                else{
                    if(kmp!=''){
                        kmp = kmp +' , ' + respoApex.Result.Management.former[i].name + ' (' +respoApex.Result.Management.former[i].designation+' Email:- ' +respoApex.Result.Management.former[i].email+')';
                    }
                    else{
                        kmp = respoApex.Result.Management.former[i].name + ' (' +respoApex.Result.Management.former[i].designation+' Email:- ' +respoApex.Result.Management.former[i].email+')';
                    }
                    
                }
                if(respoApex.Result.Management.former[i].designation.contains('CEO')){
                    ceo = respoApex.Result.Management.former[i].name;
                }
                if(respoApex.Result.Management.former[i].designation.contains('CHAIRMAN')){
                    chairman = respoApex.Result.Management.former[i].name;
                }
                
            }
            
        }
        Catch(Exception e){
            ErrorLogCreater_cls.apexDebugLoggerForAPICallout(e, 'newClientDataFromMCA' , 'EntityProfileDataBaseAPI' , '' , '',respBody, '' );
        }
        List<String> result = new List<String>();
        if(bod != null)
            {
                result.add(bod);//0
            }
            else{
                result.add(' ');
            }
        if(kmp != null)
            {
                result.add(kmp);//
            }
            else{
                result.add(' ');
            }
        if(ceo != null)
            {
                result.add(ceo);//0
            }
            else{
                result.add(' ');
            }
        if(chairman != null)
            {
                result.add(chairman);//
            }
            else{
                result.add(' ');
            }
            
        return result;
    }
    
    // MCA Entity Profile URL for Address and Directors
    @AuraEnabled
    public static  void newClientCompanySearchEnityProfile(String mcaId){
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        MCA__mdt  entitySearch = [SELECT x_karza_key__c, URL__c ,Label FROM MCA__mdt Where Label = 'Entity Profile' Limit 1];
        req.setEndpoint(entitySearch.URL__c);
       
        req.setMethod('POST');
        req.setHeader('Content-Type','application/json');
        req.setHeader('x-karza-key',entitySearch.x_karza_key__c);
        
        String reqBody = '{"entityId":"'+mcaId+'","consent":"y"}';
        req.setTimeout(30000);
        req.setBody(reqBody);

        HttpResponse resp = http.send(req);        
		// InputRequests respoApex=(InputRequests) System.JSON.deserialize(resp.getBody(), InputRequests.class);
        System.debug('resp.getBody() --->'+resp.getBody());
        MCAEntityProfileWrapper_cls respoApex=(MCAEntityProfileWrapper_cls) System.JSON.deserialize(resp.getBody(), MCAEntityProfileWrapper_cls.class);
        //System.debug(respoApex.Result.Management.Current[1].name);
        System.debug(respoApex);
    }
    
    
    @AuraEnabled
    public static List<String> newClientGST(String mcaId){
        List<String> results = new List<String>();
        String data;
        String fyeardata;
        String dataIncome;
        String fyeardataIncome;
        try{ 
            Http http = new Http();
            HttpRequest req = new HttpRequest();
            MCA__mdt  entitySearch = [SELECT x_karza_key__c, URL__c ,Label FROM MCA__mdt Where Label = 'GST Profile' Limit 1];
            req.setEndpoint(entitySearch.URL__c);
           
            req.setMethod('POST');
            req.setHeader('Content-Type','application/json');
            req.setHeader('x-karza-key',entitySearch.x_karza_key__c);
            
            String reqBody = '{"id":"'+mcaId+'","name":"","email":"","domain":"","address":"","contact":""}';
            req.setTimeout(30000);
            req.setBody(reqBody);
    
            HttpResponse resp = http.send(req);        
            // InputRequests respoApex=(InputRequests) System.JSON.deserialize(resp.getBody(), InputRequests.class);
            System.debug('resp.getBody() --->'+resp.getBody());
            String respBody = resp.getBody();
            if(resp.getStatusCode()== 200 ){
                
                respBody = respBody.replace('isEmailInvalid_', 'isEmailInvalid');
                respBody = respBody.replace('panType_', 'panType');
                respBody = respBody.replace('stateAbbreviation_', 'stateAbbreviation');
                respBody = respBody.replace('isDomainInvalid_', 'isDomainInvalid');
                respBody = respBody.replace('isAddressQualityPoor_', 'isAddressQualityPoor');
                respBody = respBody.replace('isEmailDisposable_', 'isEmailDisposable');
                respBody = respBody.replace('stateCode_', 'stateCode');
                respBody = respBody.replace('state_', 'state');
                respBody = respBody.replace('natureOfCoreBusinessActivity_', 'natureOfCoreBusinessActivity');
                System.debug(respBody);
                MCAWrapperForGSTProfileAPI respoApex=(MCAWrapperForGSTProfileAPI) System.JSON.deserialize(respBody, MCAWrapperForGSTProfileAPI.class);
            	System.debug(respoApex.Result[0].aggregateTurnovers.size());
                if(respoApex.Result[0].aggregateTurnovers.size()>0){
                    Integer index = respoApex.Result[0].aggregateTurnovers.size()-1;
                    data = respoApex.Result[0].aggregateTurnovers[index].turnover;
                    fyeardata=respoApex.Result[0].aggregateTurnovers[index].financialYear;
                }
                if(respoApex.Result[0].grossTotalIncomes.size()>0){
                    Integer index = respoApex.Result[0].grossTotalIncomes.size()-1;
                    dataIncome = respoApex.Result[0].grossTotalIncomes[index].income;
                    fyeardataIncome=respoApex.Result[0].grossTotalIncomes[index].financialYear;
                }
            }
            
            
        }
        catch(Exception e){
            System.debug(e.getMessage()+e.getLineNumber());
        }
        if(data !=''){
            results.add(data);
        }else{
            results.add('');
        }
        if(fyeardata !=''){
            results.add(fyeardata);
        }else{
            results.add('');
        }
        if(dataIncome !=''){
            results.add(dataIncome);
        }else{
            results.add('');
        }
        if(fyeardataIncome !=''){
            results.add(fyeardataIncome);
        }else{
            results.add('');
        }
        system.debug(results);
        return results;
    }
    
    @AuraEnabled
    public static List<String> newClientCompanySearchCorpFinanceData(String mcaId){
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        String reqBody='';
        String responseBody='';
        MCA__mdt  entitySearch = [SELECT x_karza_key__c, URL__c ,Label FROM MCA__mdt Where Label = 'Corp Financial Data' Limit 1];
        List<String> listCorpFinance = new List<String>();
        try {
            req.setEndpoint(entitySearch.URL__c);
            req.setMethod('POST');
            req.setHeader('Content-Type','application/json');
            req.setHeader('x-karza-key',entitySearch.x_karza_key__c);
            string fyearMCA = System.Label.MCAFinancialYear;
            reqBody = '{"entityId":"'+mcaId+'","financialYear":["'+fyearMCA+'"],"financialType":"both","noOfYearsToMerge":"1","consent":"y"}';
            req.setBody(reqBody);
            System.debug(reqBody);
            HttpResponse resp = http.send(req);        
            // InputRequests respoApex=(InputRequests) System.JSON.deserialize(resp.getBody(), InputRequests.class);
            System.debug('resp.getBody() --->'+resp.getBody());
            System.debug('resp statuscode --->'+resp.getStatusCode());
            responseBody = resp.getBody();
            if(String.isNotBlank(responseBody)){
                mcaCorpFinanceWrapper respoApex=(mcaCorpFinanceWrapper) System.JSON.deserialize(resp.getBody(), mcaCorpFinanceWrapper.class);
                System.debug('respoApex new : ' + respoApex);
                System.debug('totalAssets 1 : ' + respoApex.Result);
                System.debug('totalAssets 2 : ' + respoApex.Result.Financial);
                
                if(respoApex.statusCode == 200){
                    String totalAssets = (respoApex.Result.Financial != null) ? respoApex.Result.Financial[0].Data.Current.BalanceSheet.Assets.totalAssets : '';
                    String totalCurrentAssets = respoApex.Result.Financial[0].Data.Current.BalanceSheet.Assets.totalCurrentAssets != null ? respoApex.Result.Financial[0].Data.Current.BalanceSheet.Assets.totalCurrentAssets : '';
                    String currentLiabilties = respoApex.Result.Financial[0].Data.Current.BalanceSheet.EquityLiabilities.currentLiabilties != null ? respoApex.Result.Financial[0].Data.Current.BalanceSheet.EquityLiabilities.currentLiabilties : '';
                    String nonCurrentFinancialLiabilities = respoApex.Result.Financial[0].Data.Current.BalanceSheet.EquityLiabilities.nonCurrentFinancialLiabilities != null ? respoApex.Result.Financial[0].Data.Current.BalanceSheet.EquityLiabilities.nonCurrentFinancialLiabilities : '';
                    String totalEquity = respoApex.Result.Financial[0].Data.Current.BalanceSheet.EquityLiabilities.totalEquity != null ? respoApex.Result.Financial[0].Data.Current.BalanceSheet.EquityLiabilities.totalEquity : '';
                    String totalLiabilities = respoApex.Result.Financial[0].Data.Current.BalanceSheet.EquityLiabilities.totalLiabilities != null ? respoApex.Result.Financial[0].Data.Current.BalanceSheet.EquityLiabilities.totalLiabilities : '';
                    String totalDilutedEarningsLossPerShare = respoApex.Result.Financial[0].Data.Current.ProfitAndLoss.totalDilutedEarningsLossPerShare != null ? respoApex.Result.Financial[0].Data.Current.ProfitAndLoss.totalDilutedEarningsLossPerShare : '';
                    String totalRev = respoApex.Result.Financial[0].Data.Current.ProfitAndLoss.Revenue.totalRev != null ? respoApex.Result.Financial[0].Data.Current.ProfitAndLoss.Revenue.totalRev : '';
                    String currentAuditior = respoApex.Result.Financial[0].Data.AuditorProfile[0].nameOfAuditor != null ? respoApex.Result.Financial[0].Data.AuditorProfile[0].nameOfAuditor : '';
                    Decimal value = 0;
                    if(totalAssets!=''){
                        value = Decimal.valueOf(totalAssets)/100000;
                        System.debug(value);
                        totalAssets = String.valueOf(value);
                        listCorpFinance.add(totalAssets);
                    }
                    else{
                        listCorpFinance.add('');
                    }
                    if(totalCurrentAssets!=''){
                        value = Decimal.valueOf(totalCurrentAssets)/100000;
                        totalCurrentAssets = String.valueOf(value);
                        listCorpFinance.add(totalCurrentAssets);
                    }
                    else{
                        listCorpFinance.add('');
                    }
                    if(currentLiabilties!=''){
                        value = Decimal.valueOf(currentLiabilties)/100000;
                        currentLiabilties = String.valueOf(value);
                        listCorpFinance.add(currentLiabilties);
                    }
                    else{
                        listCorpFinance.add('');
                    }
                    if(nonCurrentFinancialLiabilities!=''){
                        value = Decimal.valueOf(nonCurrentFinancialLiabilities)/100000;
                        nonCurrentFinancialLiabilities = String.valueOf(value);
                        listCorpFinance.add(nonCurrentFinancialLiabilities);
                    }
                    else{
                        listCorpFinance.add('');
                    }
                    if(totalEquity!=''){
                        value = Decimal.valueOf(totalEquity)/100000;
                        totalEquity = String.valueOf(value);
                        listCorpFinance.add(totalEquity);
                    }
                    else{
                        listCorpFinance.add('');
                    }if(totalLiabilities!=''){
                        value = Decimal.valueOf(totalLiabilities)/100000;
                        totalLiabilities = String.valueOf(value);
                        listCorpFinance.add(totalLiabilities);
                    }
                    else{
                        listCorpFinance.add('');
                    }if(totalDilutedEarningsLossPerShare!=''){
                        value = Decimal.valueOf(totalDilutedEarningsLossPerShare)/100000;
                        totalDilutedEarningsLossPerShare = String.valueOf(value);
                        listCorpFinance.add(totalDilutedEarningsLossPerShare);
                    }
                    else{
                        listCorpFinance.add('');
                    }if(totalRev!=''){
                        value = Decimal.valueOf(totalRev)/100000;
                        totalRev = String.valueOf(value);
                        listCorpFinance.add(totalRev);
                    }
                    else{
                        listCorpFinance.add('');
                    }
                    if(currentAuditior!=''){
                        
                        listCorpFinance.add(currentAuditior);
                    }
                    else{
                        listCorpFinance.add('');
                    }
                    listCorpFinance.add(fyearMCA);
                    System.debug(listCorpFinance);
                }
                //System.debug('total Assets 3 : ' + respoApex.Result.Financial[0].Data.Current.BalanceSheet.Assets.totalAssets );
                
            }
            
            // ErrorLogCreater_cls.apexDebugLoggerForAPICallout(null,'newClientDataFromMCA','newClientCompanySearchCorpFinanceData',null,reqBody,responseBody,entitySearch.URL__c);
        }
        catch(Exception ex){
            ErrorLogCreater_cls.apexDebugLoggerForAPICallout(ex,'newClientDataFromMCA','newClientCompanySearchCorpFinanceData',null,reqBody,responseBody,entitySearch.URL__c);
        }
        return listCorpFinance;
    }
    @AuraEnabled
    public static List<String> newClientCompanySearchFinanceData(String mcaId){
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        MCA__mdt  entitySearch = [SELECT x_karza_key__c, URL__c ,Label FROM MCA__mdt Where Label = 'Financial Summary' Limit 1];
        req.setEndpoint(entitySearch.URL__c);
        
       
        req.setMethod('POST');
        req.setHeader('Content-Type','application/json');
        req.setHeader('x-karza-key',entitySearch.x_karza_key__c);
        string fyearMCA = System.Label.MCAFinancialYear;
        String reqBody = '{"consent":"Y","entityId":"'+mcaId+'","financialYear":["'+fyearMCA+'"],"financialType":"both"}';
        req.setTimeout(30000);
        req.setBody(reqBody);
        List<String> listCorpFinance = new List<String>();
        HttpResponse resp = http.send(req);        
		// InputRequests respoApex=(InputRequests) System.JSON.deserialize(resp.getBody(), InputRequests.class);
        System.debug('resp.getBody() --->'+resp.getBody());
        mcaFinanceWrapper respoApex=(mcaFinanceWrapper) System.JSON.deserialize(resp.getBody(), mcaFinanceWrapper.class);
        System.debug('respoApex mca : ' + respoApex);
        if(respoApex.Result.Standalone != null && respoApex.Result != null){
            
            String profitLoss = respoApex.Result.Standalone[0].Data.CurrentFinancialSummary.IncomeState.profitLoss;
            String ebit = respoApex.Result.Standalone[0].Data.CurrentFinancialSummary.IncomeState.ebit;
            String ebitda = respoApex.Result.Standalone[0].Data.CurrentFinancialSummary.IncomeState.ebitda;
            String revenuefromOperations = respoApex.Result.Standalone[0].Data.CurrentFinancialSummary.IncomeState.revenuefromOperations;
            try{
                Decimal value =0;
                if(profitLoss!=Null){
                    value = Decimal.valueOf(profitLoss)/100000;
                    profitLoss = String.valueOf(value);
                    listCorpFinance.add(profitLoss);
                }
                else{
                    listCorpFinance.add('0');
                }
                if(ebit!=Null){
                    value = Decimal.valueOf(ebit)/100000;
                    ebit = String.valueOf(value);
                    listCorpFinance.add(ebit);
                }else{
                    listCorpFinance.add('0');
                }
                if(ebitda!=Null){
                    value = Decimal.valueOf(ebitda)/100000;
                    ebitda = String.valueOf(value);
                    listCorpFinance.add(ebitda);
                }else{
                    listCorpFinance.add('0');
                }
                if(revenuefromOperations!=Null){
                    value = Decimal.valueOf(revenuefromOperations)/100000;
                    revenuefromOperations = String.valueOf(value);
                    listCorpFinance.add(revenuefromOperations);
                }else{
                    listCorpFinance.add('0');
                }
            
            }
            catch(Exception e){

            }
        }
        else{
            listCorpFinance.add('0');
            listCorpFinance.add('0');
            listCorpFinance.add('0');
            listCorpFinance.add('0');

        }
        system.debug(listCorpFinance);
        return listCorpFinance;
    }
    @AuraEnabled
    public static String newClientCompanyCrossDirectorShipCurrentData(String mcaId){
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        MCA__mdt  entitySearch = [SELECT x_karza_key__c, URL__c ,Label FROM MCA__mdt Where Label = 'Common Director' Limit 1];
        req.setEndpoint(entitySearch.URL__c);
        
       
        req.setMethod('POST');
        req.setHeader('Content-Type','application/json');
        req.setHeader('x-karza-key',entitySearch.x_karza_key__c);
        
        String reqBody = '{"id":"'+mcaId+'","directorship":"cross"}';
        req.setTimeout(30000);
        req.setBody(reqBody);
        HttpResponse resp;
        String dir='';
		try{
        resp = http.send(req);        
		// InputRequests respoApex=(InputRequests) System.JSON.deserialize(resp.getBody(), InputRequests.class);
        System.debug('resp.getBody() --->'+resp.getBody());
        mcaCrossDirCurrentWrapper respoApex=(mcaCrossDirCurrentWrapper) System.JSON.deserialize(resp.getBody(), mcaCrossDirCurrentWrapper.class);
        for(Integer x=0;x<respoApex.Result.size();x++){
            dir = dir+respoApex.Result[x].entityId+'  ';
            
            
            for(Integer i=0;i<10;i++){
                dir = dir +'  '+ respoApex.Result[0].Directors[i].name + '(' + respoApex.Result[0].Directors[i].dateOfAppointment.split('T')[0] +') ;  ';
            	}
            dir =dir+'                 ';
        	}
        }
        catch(Exception e){

        }
        System.debug(dir);
        return dir;
    }
    @AuraEnabled
    public static List<String> clientGroupNameFromMCAAnnualReturn(String mcaId){
        
        List<String> result = new List<String>();
        
        try{
         Http http = new Http();
        HttpRequest req = new HttpRequest();
        MCA__mdt  entitySearch = [SELECT x_karza_key__c, URL__c ,Label FROM MCA__mdt Where Label = 'Corp Docs - Annual' Limit 1];
        req.setEndpoint(entitySearch.URL__c);
       
        req.setMethod('POST');
        req.setHeader('Content-Type','application/json');
        req.setHeader('x-karza-key',entitySearch.x_karza_key__c);
		string fyearMCA = System.Label.MCAFinancialYear;        
        String reqBody = '{"consent":"Y","entityId":"'+mcaId+'","financialYear":["'+fyearMCA+'"]}';
        req.setTimeout(30000);
        req.setBody(reqBody);

        HttpResponse resp;
        resp  = http.send(req);  
            System.debug(resp.getBody());
        CorpDocsAnnualMCAWrapper respoApex=(CorpDocsAnnualMCAWrapper) System.JSON.deserialize(resp.getBody(), CorpDocsAnnualMCAWrapper.class);
        
            for(integer i=0;i<respoApex.Result.annualReturn.size();i++){
           
            String companyName;
            for(Integer k=0;k<respoApex.Result.annualReturn[i].Data.subsidiariesList.size();k++){
                if(respoApex.Result.annualReturn[i].Data.subsidiariesList[k].holdingSubsidiaryAssociateJointVenture == 'Holding Company'){
                    if(respoApex.Result.annualReturn[i].Data.subsidiariesList[k].namecompany != ''){
                        companyName=respoApex.Result.annualReturn[i].Data.subsidiariesList[k].namecompany;
                        
                    }
                }
                
            	}
                if(companyName!='')
                {
                    result.add(companyName);
                }else{
                        result.add('');
                    }
                if(respoApex.Result.annualReturn[i].Data.businessActivitiesList.size()>0){
                    if(respoApex.Result.annualReturn[i].Data.businessActivitiesList[0].descriptionOfMainActivityGroup !=''){
                        result.add(respoApex.Result.annualReturn[i].Data.businessActivitiesList[0].descriptionOfMainActivityGroup);
                    }
                    else{
                        result.add('');
                    }
                    if(respoApex.Result.annualReturn[i].Data.businessActivitiesList[0].descriptionOfBusinessActivity !=''){
                        result.add(respoApex.Result.annualReturn[i].Data.businessActivitiesList[0].descriptionOfBusinessActivity);
                    } else{
                        result.add('');
                    }
                }
        	}
            
            }
        catch(exception e){
            System.debug('error in Investor'+e.getMessage()+e.getLineNumber());
        }
        System.debug(result);
        return result;
    }
    @AuraEnabled
    public static String newClientCompanyCrossDirectorShipFormerData(String mcaId){
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        MCA__mdt  entitySearch = [SELECT x_karza_key__c, URL__c ,Label FROM MCA__mdt Where Label = 'Common Director' Limit 1];
        req.setEndpoint(entitySearch.URL__c);
       
        req.setMethod('POST');
        req.setHeader('Content-Type','application/json');
        req.setHeader('x-karza-key',entitySearch.x_karza_key__c);
        
        String reqBody = '{"id":"'+mcaId+'","directorship":"past"}';
        req.setTimeout(30000);
        req.setBody(reqBody);
        HttpResponse resp;
        String dir='';
        try{
        resp = http.send(req);        
		// InputRequests respoApex=(InputRequests) System.JSON.deserialize(resp.getBody(), InputRequests.class);
        System.debug('resp.getBody() --->'+resp.getBody());
        mcaCrossDirFormerWrapper respoApex=(mcaCrossDirFormerWrapper) System.JSON.deserialize(resp.getBody(), mcaCrossDirFormerWrapper.class);
        for(Integer x=0;x<respoApex.Result.size();x++){
            dir = dir+respoApex.Result[x].entityId+'  ';
            
             System.debug(respoApex.Result[x].FormerDirectors.size());
            for(Integer i=0;i<respoApex.Result[x].FormerDirectors.size();i++){
                dir = dir +'  '+ respoApex.Result[x].FormerDirectors[i].name + '(' + respoApex.Result[x].FormerDirectors[i].tenureEndDate.split('T')[0] +') ; ';
            }
            dir =dir+'                 ';
        }
            
        
        }
        catch(Exception e){
            System.debug(e.getMessage()+'  '+e.getLineNumber());
        }
        System.debug(dir);
        return dir;
    }
     
    //start MCA Loader: code is added by Biplow sarkar | 10-10-2023
    @AuraEnabled
    public static List<Client_News__c> newClientAlertsDataAura(String mcaId , String obj , Id recordId){
        return newClientAlertsData(mcaId,obj,recordId);
    }

    @future(callout=true)
    public static void newClientAlertsDataFuture(String mcaId , String obj , Id recordId){
        newClientAlertsData(mcaId,obj,recordId);
    }
    //End MCA Loader

    public static List<Client_News__c> newClientAlertsData(String mcaId , String obj , Id recordId){
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        MCA__mdt  alerts = [SELECT x_karza_key__c, URL__c ,Label FROM MCA__mdt Where Label = 'Alerts' Limit 1];
        req.setEndpoint(alerts.URL__c);
       
        req.setMethod('POST');
        req.setHeader('Content-Type','application/json');
        req.setHeader('x-karza-key',alerts.x_karza_key__c);
        
        
        String reqBody = '{"id":"'+mcaId+'"}';
        req.setBody(reqBody);

        HttpResponse resp = http.send(req);        
		// InputRequests respoApex=(InputRequests) System.JSON.deserialize(resp.getBody(), InputRequests.class);
        System.debug('resp.getBody() --->'+resp.getBody());
        string responseBody = resp.getBody();
        mcaAlertsWrapper respoApex=(mcaAlertsWrapper) System.JSON.deserialize(resp.getBody(), mcaAlertsWrapper.class);
        List<Client_News__c> cNewslist = new List<Client_News__c>();
        try{
            for(Integer i=0 ; i<respoApex.result.alerts.alertList.size();i++){
                Client_News__c clientNews = new Client_News__c();
                if(respoApex.result.alerts.alertList[i].exists == true){
                    String lab = respoApex.result.alerts.alertList[i].alert;
                   List<Data_Dictionary_Alert__mdt> dataAlerts = [SELECT Id, Label, Header__c, Alert_Description__c FROM Data_Dictionary_Alert__mdt Where Label =: lab Limit 1];
                    if(dataAlerts.size()>0){
                        clientNews.Name = dataAlerts[0].Header__c;
                        clientNews.Alert__c = dataAlerts[0].Header__c;
                        clientNews.remarks_details__c = dataAlerts[0].Alert_Description__c;
                        clientNews.severity__c = respoApex.result.alerts.alertList[i].severity;
                        if(obj == 'Lead'){
                            clientNews.New_Client__c = recordId;
                        }else{
                            clientNews.Client__c = recordId;
                        }
                        clientNews.ExternalDataSource__c = 'MCA';
                        cNewslist.add(clientNews);
                    }
                }
                
            }
            //ErrorLogCreater_cls.apexDebugLoggerForAPICallout(null,'newClientDataFromMCA','newClientAlertsData',null,reqBody,responseBody,alerts.URL__c); 
        }
        catch(exception ex){
            ErrorLogCreater_cls.apexDebugLoggerForAPICallout(ex,'newClientDataFromMCA','newClientAlertsData',null,reqBody,responseBody,alerts.URL__c); 
        }
        system.debug(cNewslist);
        insert cNewslist;
        return cNewslist;
        
    }
    @AuraEnabled
    public static void newClientAlertsDataCourtCaseAura(String mcaId , String obj , Id recordId){
        newClientAlertsDataCourtCase(mcaId,obj,recordId);
    }

    @future(callout=true)
    public static void nnewClientAlertsDataCourtCaseFuture(String mcaId , String obj , Id recordId){
        newClientAlertsDataCourtCase(mcaId,obj,recordId);
    }
    
    public static void newClientAlertsDataCourtCase(String mcaId , String obj , Id recordId){
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        MCA__mdt  alerts = [SELECT x_karza_key__c, URL__c ,Label FROM MCA__mdt Where Label = 'SFIO Convicted Directors' Limit 1];
        req.setEndpoint(alerts.URL__c);
        string nameofCompany;
        if(obj == 'Lead'){
            List<Lead> leadList = new List<Lead>([SELECT Id, Company From Lead where Id =: recordId]);
            nameofCompany = leadList[0].Company;
        }
        req.setMethod('POST');
        req.setHeader('Content-Type','application/json');
        req.setHeader('x-karza-key',alerts.x_karza_key__c);
        
        
        String reqBody = '{"name":"'+nameofCompany+'","courtCaseNumber":"","kid":""}';
        req.setBody(reqBody);

        HttpResponse resp = http.send(req);        
		// InputRequests respoApex=(InputRequests) System.JSON.deserialize(resp.getBody(), InputRequests.class);
        System.debug('resp.getBody() --->'+resp.getBody()+'reqBody'+reqBody);
        
        List<Client_News__c> cNewslist = new List<Client_News__c>();
        try{
            alertsDataCourtCaseWrapper respoApex=(alertsDataCourtCaseWrapper) System.JSON.deserialize(resp.getBody(), alertsDataCourtCaseWrapper.class);
        
            for(Integer i=0 ; i<respoApex.result.size();i++){
                Client_News__c clientNews = new Client_News__c();
                //clientNews.convictedDirectors__c =  respoApex.result[i].convictedDirectors;  
                //respoApex.result[i].convictedDirectors.remove(null);
                clientNews.convictedDirectors__c = string.join(respoApex.result[i].convictedDirectors,',');
                clientNews.Case_Number__c = respoApex.result[i].courtCaseNumber;
                 if(obj == 'Lead'){
                        clientNews.New_Client__c = recordId;
                    }else{
                        clientNews.Client__c = recordId;
                    }
                    clientNews.ExternalDataSource__c = 'MCA';
                    cNewslist.add(clientNews);
            }
        }
        catch(exception e){
            System.debug(e.getMessage()+'   '+e.getLineNumber());
        }
        system.debug(cNewslist);
        insert cNewslist;
        
    }
    @AuraEnabled
    public static String newClientCompanyClosingPrice(String symbol){
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        MCA__mdt  entitySearch = [SELECT x_karza_key__c, URL__c ,Label FROM MCA__mdt Where Label = 'Closing Price' Limit 1];
        req.setEndpoint(entitySearch.URL__c);
        
       
        req.setMethod('POST');
        req.setHeader('Content-Type','application/json');
        req.setHeader('x-karza-key',entitySearch.x_karza_key__c);
        
        String reqBody = '{"id":"","securityCode":"","symbol":"'+symbol+'","fromDate":"","toDate":"","instrument":"Equity","exchange":"NSE"}';
        req.setBody(reqBody);
        String result;
        HttpResponse resp;
        try{
            resp = http.send(req);        
            // InputRequests respoApex=(InputRequests) System.JSON.deserialize(resp.getBody(), InputRequests.class);
            System.debug('resp.getBody() --->'+resp.getBody());
            MCAWrapperForClosingPrice respoApex=(MCAWrapperForClosingPrice) System.JSON.deserialize(resp.getBody(), MCAWrapperForClosingPrice.class);
            if(respoApex.Result.size()>0){
                result = respoApex.Result[0].closingPrice;
            }
            
        }
        catch(Exception e){

        }
       return result;
    }
    
    
}