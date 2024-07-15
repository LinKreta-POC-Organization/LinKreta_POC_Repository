/* 
     Written By: Bhanwar Singh
     Created Date: 2/23/2023
     Last Modified By : Bhanwar Singh
     Last Modified Date : 12-04-23
     Description : This class is used to create Subsidiarys For New Client and Client Object.
     Variable Used : - 
       clientId : - New Client /Client Record Id 
       companyID : - CAPIQ ID of Client (Company)
       obj : - Which Object is used like Client or New Client
*/
public class createSubsidiarys {
    public static void deleteOldSubsidiarys(Id clientId ,String companyID ,String obj){
        if(obj == 'Lead'){
            List<Subsidiary__c> listinvtoDelete = new List<Subsidiary__c>([Select Id From Subsidiary__c Where New_Client__c =: clientId AND ExternalDataSource__c = 'CapIQ' Limit 10000]);
            delete listinvtoDelete;
            createSubsidiarys.createSubsidiarysFromCAPIQ(clientId ,companyID ,obj);
        }
        else if(obj == 'Account'){
            List<Subsidiary__c> listinvtoDelete = new List<Subsidiary__c>([Select Id From Subsidiary__c Where Client__c =: clientId AND ExternalDataSource__c = 'CapIQ' Limit 10000]);
            delete listinvtoDelete;
            createSubsidiarys.createSubsidiarysFromAccountCAPIQ(clientId ,companyID ,obj);
        }
        else{
            createSubsidiarys.createSubsidiarysFromCAPIQ(clientId ,companyID ,obj);
        }
        
    }
    public static Void createSubsidiarysFromCAPIQFuture(Id clientId ,String companyID ,String obj){
        createSubsidiarysFromCAPIQ(clientId,companyID,obj);
    }
    @AuraEnabled
    public static List<Subsidiary__c> createSubsidiarysFromCAPIQAura(Id clientId ,String companyID ,String obj){
        return createSubsidiarysFromCAPIQ(clientId,companyID,obj);
    }
    @Future(callout =true)
    public static Void createSubsidiarysFromAccountCAPIQ(Id clientId ,String companyID ,String obj){
        createSubsidiarysFromCAPIQ(clientId,companyID,obj);
    }
    public static List<Subsidiary__c> createSubsidiarysFromCAPIQ(Id clientId ,String companyID ,String obj)
    {
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        CapIQ__mdt capIq = [SELECT Id, UserName__c, Password__c, EndPointURL__c  FROM CapIQ__mdt Limit 1];
         req.setEndpoint(capIq.EndPointURL__c);
        req.setMethod('POST');
        Blob headerValue = Blob.valueOf  (capIq.UserName__c + ':' + capIq.Password__c);
        String authorizationHeader = 'BASIC ' + EncodingUtil.base64Encode(headerValue);
        req.setHeader('Authorization',authorizationHeader);
        req.setHeader('Content-Type','application/json');
        //System.debug(capIq.UserName__c + ':' + capIq.Password__c);
       
        String reqBody = '{"inputRequests": [{"function":"GDSHV","mnemonic":"IQ_COMPANY_CORP_TREE","identifier":"'+companyID+'","properties": {"startRank":"1","endRank":"30"}}]}';
        req.setBody(reqBody);
        System.debug(reqBody);
        HttpResponse resp = http.send(req); 
        
        List<Subsidiary__c> listsub = new List<Subsidiary__c>();
        try{
            clientNewIqWrapper respoApex=(clientNewIqWrapper) System.JSON.deserialize(resp.getBody(), clientNewIqWrapper.class);
        	List<String> capIQIds = new List<String>();
            List<String> nameOfCompanies = new List<String>();
            for(Integer i=0;i<respoApex.GDSSDKResponse[0].Rows.size();i++)
            {
                //Subsidiary__c sub = new Subsidiary__c();   
                if(respoApex.GDSSDKResponse[0].Rows[i].Row[2] == 'CurrentSubsidiary' && respoApex.GDSSDKResponse[0].Rows[i].Row[3] == '2'){
                    System.debug(respoApex.GDSSDKResponse[0].Rows[i].Row[2]);
                    System.debug(respoApex.GDSSDKResponse[0].Rows[i].Row[3]);
                
                    if(respoApex.GDSSDKResponse[0].Rows[i].Row[0]!=NULL){
                        capIQIds.add(respoApex.GDSSDKResponse[0].Rows[i].Row[0]);   
                    }
                    if(capIQIds.size()>450){
                        nameOfCompanies.addall(createSubsidiarys.companyNamebyCapIq(capIQIds));
                        System.debug(nameOfCompanies);
                        capIQIds.clear();
                    }
            	}
                
                   
                
            }
            if(!capIQIds.isEmpty()){
               
                nameOfCompanies.addall(createSubsidiarys.companyNamebyCapIq(capIQIds));
                    System.debug(nameOfCompanies);
                    capIQIds.clear();
            }
            if(nameOfCompanies.Size()>0){
               
                
                for(String name:nameOfCompanies){
                    Subsidiary__c sub = new Subsidiary__c();  
                    if(name.length()>79){
                        sub.Name = name.substring(0, 79);
                    }
                    else{
                        sub.Name = name;
                    }
                    if(obj=='Lead'){
                        sub.new_client__c = clientId;
                    }else{
                        sub.Client__c = clientId;
                    }
                    listsub.add(sub);
                }
                
            }
        }
        catch(Exception e){
            System.debug(e.getMessage());
            System.debug('** Test error  '+e);
            System.debug('** Test error  '+e.getLinenumber());
   			ErrorLogCreater_cls.apexDebugLoggerForAPICallout(e, 'createSubsidiarys' , 'createSubsidiarysFromCAPIQ' , '' , reqBody,resp.getBody(), capIq.EndPointURL__c );
        }
        System.debug(listsub);
        insert listsub;
        return listsub;
    }
    public static List<String> companyNamebyCapIq(List<String> companyId)
    {
        List<String> nameOfCompany = new List<String>();
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        CapIQ__mdt capIq = [SELECT Id, UserName__c, Password__c, EndPointURL__c  FROM CapIQ__mdt Limit 1];
         req.setEndpoint(capIq.EndPointURL__c);
        req.setMethod('POST');
        Blob headerValue = Blob.valueOf  (capIq.UserName__c + ':' + capIq.Password__c);
        String authorizationHeader = 'BASIC ' + EncodingUtil.base64Encode(headerValue);
        req.setHeader('Authorization',authorizationHeader);
        req.setHeader('Content-Type','application/json');
        //System.debug(capIq.UserName__c + ':' + capIq.Password__c);
        
        String reqBody = '';
        if(companyId.size()>1){
            reqBody = '{"inputRequests": [{"function":"GDSP","mnemonic":"IQ_COMPANY_NAME","identifier":"IQ'+companyId[0]+'"},';
            for(integer index=1;index<companyId.size();index++){
                if(index!=companyId.size()-1){
                    reqBody =reqBody+'{"function":"GDSP","mnemonic":"IQ_COMPANY_NAME","identifier":"IQ'+companyId[index]+'"},';
                }else{
                    reqBody =reqBody+'{"function":"GDSP","mnemonic":"IQ_COMPANY_NAME","identifier":"IQ'+companyId[index]+'"}]}';
                }
            }
        }else{
            reqBody = '{"inputRequests": [{"function":"GDSP","mnemonic":"IQ_COMPANY_NAME","identifier":"IQ'+companyId[0]+'"}]}';
        
        }
        req.setBody(reqBody);
 		HttpResponse resp;
        
        //System.debug(companyName);
        try{
            resp = http.send(req); 
        clientNewIqWrapper respoApex=(clientNewIqWrapper) System.JSON.deserialize(resp.getBody(), clientNewIqWrapper.class);
        String companyName = respoApex.GDSSDKResponse[0].Rows[0].Row[0];
            for(integer index=0;index<respoApex.GDSSDKResponse.size();index++){
                if(respoApex.GDSSDKResponse[index].Rows[0].Row[0]!='Data Unavailable'){
                    nameOfCompany.add(respoApex.GDSSDKResponse[index].Rows[0].Row[0]);
                }
                
            }
            return nameOfCompany;
        }catch(Exception e){
            System.debug('** Test error  '+e);
            System.debug('** Test Line  '+e.getLinenumber());
            ErrorLogCreater_cls.apexDebugLoggerForAPICallout(e, 'createSubsidiarys' , 'companyNamebyCapIq' , '' , reqBody,resp.getBody(), capIq.EndPointURL__c );
            return nameOfCompany;
        }
    }
    
    @future(callout=true)
    public static void createInvestorsFromMCA(Id clientId,String mcaId, String obj)
    {
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        MCA__mdt  entitySearch = [SELECT x_karza_key__c, URL__c ,Label FROM MCA__mdt Where Label = 'MCA Schedule' Limit 1];
        req.setEndpoint(entitySearch.URL__c);
       string fyearMCA = System.Label.MCAFinancialYear;        
        req.setMethod('POST');
        req.setHeader('Content-Type','application/json');
        req.setHeader('x-karza-key',entitySearch.x_karza_key__c);
        
        String reqBody = '{"consent":"Y","entityId":"'+mcaId+'","financialType":"standalone","financialYear":["'+fyearMCA+'"],"schType":["shareholdingPattern"]}';
        req.setTimeout(30000);
        req.setBody(reqBody);

        HttpResponse resp;
        List<Investor__c> listinv = new List<Investor__c>();
        try {
            resp  = http.send(req);        
            MCAwrapperForMCASchedules respoApex=(MCAwrapperForMCASchedules) System.JSON.deserialize(resp.getBody(), MCAwrapperForMCASchedules.class);
            if(respoApex.Result.standalone.size()>0 ){
                    for(Integer i=0;i<respoApex.Result.standalone.size();i++){
                        
                        for(integer j=0;j<respoApex.Result.standalone[i].Data.ShareholdingPattern.sharesHeldByHoldingCompany.Size();j++){
                            Investor__c inv = new Investor__c();
                            inv.Name = respoApex.Result.standalone[i].Data.ShareholdingPattern.sharesHeldByHoldingCompany[j].nameOfShareholder;
                            inv.Investor_Percentage_of_Shares_held__c = String.valueOf(respoApex.Result.standalone[i].Data.ShareholdingPattern.sharesHeldByHoldingCompany[j].percentageOfSharesHeld);
                            if(obj == 'Lead')
                            {
                                inv.New_Client__c = clientId;
                            }
                            else{
                                    inv.Client__c = clientId;
                                }
                            inv.ExternalDataSource__c = 'MCA';
                           listinv.add(inv);
                        }
                    }
                }
            
        }
        catch(Exception e){
            System.debug('** Test error  '+e);
            System.debug('** Test Line  '+e.getLinenumber());
            
        }
        System.debug(listinv);
        insert listinv;
        
    }
    
}