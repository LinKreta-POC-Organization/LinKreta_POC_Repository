/* 
     Written By: Bhanwar Singh
     Created Date: 22-03-23
     Last Modified By : Bhanwar Singh
     Last Modified Date : 12-04-23
     Description : This is Used as A Wrapper For MCA Entity 
     
*/
public class createInvestors {
    public static void deleteOldInv(Id clientId ,String companyID ,String obj){
        if(obj == 'Lead'){
            List<Investor__c> listinvtoDelete = new List<Investor__c>([Select Id From Investor__c Where New_Client__c =: clientId AND ExternalDataSource__c = 'CapIQ' Limit 10000]);
            delete listinvtoDelete;
            createInvestors.createInvestorsFromCAPIQ(clientId ,companyID ,obj);
        }
        else if(obj == 'Account'){
            List<Investor__c> listinvtoDelete = new List<Investor__c>([Select Id From Investor__c Where Client__c =: clientId AND ExternalDataSource__c = 'CapIQ' Limit 10000]);
            delete listinvtoDelete;
            createInvestors.createInvestorsFromAccountCAPIQ(clientId ,companyID ,obj);
        }
        else{
            createInvestors.createInvestorsFromCAPIQ(clientId ,companyID ,obj);
        }
    }
    @Future(callout =true)
    public static Void createInvestorsFromCAPIQFuture(Id clientId ,String companyID ,String obj){
        createInvestorsFromCAPIQ(clientId,companyID,obj);
    }
    @AuraEnabled
    public static void createInvestorsFromCAPIQAura(Id clientId ,String companyID ,String obj){
         createInvestorsFromCAPIQ(clientId,companyID,obj);
    }
    @Future(callout =true)
    public static Void createInvestorsFromAccountCAPIQ(Id clientId ,String companyID ,String obj){
        createInvestorsFromCAPIQ(clientId,companyID,obj);
    }
    public static void createInvestorsFromCAPIQ(Id clientId ,String companyID ,String obj)
    {
        
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        
        CapIQ__mdt capIq = [SELECT Id, UserName__c, Password__c, EndPointURL__c FROM CapIQ__mdt Limit 1];
         req.setEndpoint(capIq.EndPointURL__c);
        req.setMethod('POST');
        Blob headerValue = Blob.valueOf  (capIq.UserName__c + ':' + capIq.Password__c);
        
        String authorizationHeader = 'BASIC ' + EncodingUtil.base64Encode(headerValue);
        req.setHeader('Authorization',authorizationHeader);
        req.setHeader('Content-Type','application/json');
        
       
        String reqBody = '{"inputRequests": [{"function":"GDSHE","mnemonic":"IQ_INVESTORS_CURR","identifier":"'+companyID
        +'", "properties": {"startRank":"1","endRank":"20"}},{"function":"GDSHE","mnemonic":"IQ_INVESTORS_CURR_STAKE","identifier":"'+  companyID
        + '","properties": {"startRank":"1","endRank":"20"}},{"function":"GDSHE","mnemonic":"IQ_INVESTORS_CURR_TRANSACTION_ID","identifier":"' + companyID
        +'", "properties": {"startRank":"1","endRank":"20"}}]}';
        req.setBody(reqBody);
 
        HttpResponse resp = http.send(req); 
        clientNewIqWrapper respoApex=(clientNewIqWrapper) System.JSON.deserialize(resp.getBody(), clientNewIqWrapper.class);
        List<Investor__c> listinv = new List<Investor__c>();
        try{
            for(Integer i=0;i<respoApex.GDSSDKResponse[0].Rows.size() ;i++)
            {
            if(respoApex.GDSSDKResponse[0].Rows[i].Row!=NULL){
                System.debug('respoApex.GDSSDKResponse[0].Rows[i].Row' + respoApex.GDSSDKResponse[0].Rows[i].Row);
                System.debug('Company'+ respoApex.GDSSDKResponse[0].Rows[i].Row[0]+'Percentage '+ respoApex.GDSSDKResponse[1].Rows[i].Row[0]+'Transiction Id'+ respoApex.GDSSDKResponse[2].Rows[i].Row[0]);
                Investor__c inv = new Investor__c ();
                if(respoApex.GDSSDKResponse[0].Rows[i].Row[0] != 'Data Unavailable'){
                    inv.Name =  respoApex.GDSSDKResponse[0].Rows[i].Row[0];
                    inv.Investor_Percentage_of_Shares_held__c = respoApex.GDSSDKResponse[1].Rows[i].Row[0];
                    inv.Transaction_IDs__c = respoApex.GDSSDKResponse[2].Rows[i].Row[0];
                    inv.ExternalDataSource__c = 'CapIQ';
                    if(obj == 'Lead')
                    {
                        inv.New_Client__c = clientId;
                    }
                    else
                    {
                        inv.Client__c = clientId;
                    }
                    listinv.add(inv);
                }
                    
            }
            else{
                i=30;
            }
               
            }
        }
        catch(Exception e){
   			System.debug('List exception fired');         
        }
        insert listinv;
    }

    //start MCA Loader: code is added by Biplow sarkar | 10-10-2023
    @AuraEnabled
    public static void createInvestorsFromMCAAura(Id clientId,String mcaId, String obj){
        createInvestorsFromMCA(clientId,mcaId,obj);
    }

    @future(callout=true)
    public static void createInvestorsFromMCAFuture(Id clientId,String mcaId, String obj){
        createInvestorsFromMCA(clientId,mcaId,obj);
    }
    //End MCA Loader

    public static void createInvestorsFromMCA(Id clientId,String mcaId, String obj)
    {
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        MCA__mdt  entitySearch = [SELECT x_karza_key__c, URL__c ,Label FROM MCA__mdt Where Label = 'Corp Details ShareHolder' Limit 1];
        req.setEndpoint(entitySearch.URL__c);
       
        req.setMethod('POST');
        req.setHeader('Content-Type','application/json');
        req.setHeader('x-karza-key',entitySearch.x_karza_key__c);
        
        String reqBody = '{"entityId":"'+mcaId+'","consent":"y"}';
        req.setTimeout(30000);
        req.setBody(reqBody);

        HttpResponse resp;
        List<Investor__c> listinv = new List<Investor__c>();
        string responseBody;
        try {
            resp  = http.send(req);        
            responseBody = resp.getBody();
            System.debug('responseBody --->'+responseBody);
            MCACorpInvestorWrapper_cls respoApex=(MCACorpInvestorWrapper_cls) System.JSON.deserialize(resp.getBody(), MCACorpInvestorWrapper_cls.class);
            for(Integer i=0;i<respoApex.Result.ShareHolders.size();i++){
                Investor__c inv = new Investor__c();
                inv.Name = respoApex.Result.ShareHolders[i].name;
                String invper = respoApex.Result.ShareHolders[i].percentageOfHoldingByShares;
                List<String> spliters;
                if(invper !='Data Unavailable'){
                    try{
                        spliters = invper.split('\\.');
                        invper = spliters[0]+'.';
                        spliters = spliters[1].split('');
                        invper = invper+spliters[0]+spliters[1];     
                        }catch(Exception e){
                        
                       }
                }
                inv.Investor_Percentage_of_Shares_held__c = invper;
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
            //ErrorLogCreater_cls.apexDebugLoggerForAPICallout(null,'createInvestors','createInvestorsFromMCA',null,reqBody,responseBody,entitySearch.URL__c);
        }
        catch(Exception e){
            ErrorLogCreater_cls.apexDebugLoggerForAPICallout(e,'createInvestors','createInvestorsFromMCA',null,reqBody,responseBody,entitySearch.URL__c);
        }
        System.debug(listinv);
        insert listinv;
        
    }
     public static void deleteOldInvMCA(Id clientId ,String companyID ,String obj){
        if(obj == 'Lead'){
            List<Investor__c> listinvtoDelete = new List<Investor__c>([Select Id From Investor__c Where New_Client__c =: clientId AND ExternalDataSource__c = 'MCA' Limit 10000]);
            delete listinvtoDelete;
            List<Joint_Venture__c> listJVtoDelete = new List<Joint_Venture__c>([Select Id From Joint_Venture__c Where New_Client__c =: clientId AND ExternalDataSource__c = 'MCA' Limit 10000]);
            delete listJVtoDelete;
            List<Subsidiary__c> listSubtoDelete = new List<Subsidiary__c>([Select Id From Subsidiary__c Where New_Client__c =: clientId AND ExternalDataSource__c = 'MCA' Limit 10000]);
            delete listSubtoDelete;
            List<Client_News__c> listClientNewstoDelete = new List<Client_News__c>([Select Id From Client_News__c Where New_Client__c =: clientId AND ExternalDataSource__c = 'MCA' Limit 10000]);
            System.debug(listClientNewstoDelete);
            delete listClientNewstoDelete;
        }
        //createInvestors.createInvestorsFromMCAAnnualReturn(clientId ,companyID ,obj);
        createInvestors.createInvestorsFromMCA(clientId ,companyID ,obj);
    }

    //Start MCA loader: code is added by Biplow sarkar | 10-10-2023
    @future(callout=true)
    public static void createInvestorsFromMCAAnnualReturnFuture(Id clientId,String mcaId, String obj){
        createInvestorsFromMCAAnnualReturn(clientId,mcaId,obj);
    }

    @AuraEnabled
    public static void createInvestorsFromMCAAnnualReturnAura(Id clientId,String mcaId, String obj){
        createInvestorsFromMCAAnnualReturn(clientId,mcaId,obj);
    }
    //End MCA loader

    public static void createInvestorsFromMCAAnnualReturn(Id clientId,String mcaId, String obj){
        system.debug('createInvestorsFromMCAAnnualReturn   Callout Done');
        
        List<Investor__c> listinv = new List<Investor__c>();
        List<Subsidiary__c> listsub = new List<Subsidiary__c>();
        List<Joint_Venture__c> listjuv = new List<Joint_Venture__c>();
        string responseBody ='';
        String reqBody ='';
        string  entityURL = ''; 
        try{
            Http http = new Http();
            HttpRequest req = new HttpRequest();
            MCA__mdt  entitySearch = [SELECT x_karza_key__c, URL__c ,Label FROM MCA__mdt Where Label = 'Corp Docs - Annual' Limit 1];
            entityURL = entitySearch.URL__c;
            req.setEndpoint(entitySearch.URL__c);
            
            req.setMethod('POST');
            req.setHeader('Content-Type','application/json');
            req.setHeader('x-karza-key',entitySearch.x_karza_key__c);
            string fyearMCA = System.Label.MCAFinancialYear;        
            reqBody = '{"consent":"Y","entityId":"'+mcaId+'","financialYear":["'+fyearMCA+'"]}';
            req.setTimeout(30000);
            req.setBody(reqBody);
            
            HttpResponse resp;
            resp  = http.send(req);        
            responseBody = resp.getBody();   
            System.debug('responseBody ---> '+responseBody);
            CorpDocsAnnualMCAWrapper respoApex=(CorpDocsAnnualMCAWrapper) System.JSON.deserialize(resp.getBody(), CorpDocsAnnualMCAWrapper.class);
            System.debug('respoApex.Result : ' + respoApex.Result);
            
            if(respoApex.Result.annualReturn != null && respoApex.Result.annualReturn.size() != 0){
                for(integer i=0;i<respoApex.Result.annualReturn.size();i++){
                    System.debug('Size of Investor --> '+respoApex.Result.annualReturn[i].Data.listOfForeignInvestors.size());
                    if(respoApex.Result.annualReturn[i].Data.listOfForeignInvestors != null && respoApex.Result.annualReturn[i].Data.listOfForeignInvestors.size() > 0){
                        for(Integer j=0;j<respoApex.Result.annualReturn[i].Data.listOfForeignInvestors.size();j++){
                            Investor__c inv = new Investor__c();
                            inv.Name = respoApex.Result.annualReturn[i].Data.listOfForeignInvestors[j].name;
                            inv.Location__c = respoApex.Result.annualReturn[i].Data.listOfForeignInvestors[j].countryOfIncorporation;
                            inv.Investor_Percentage_of_Shares_held__c = respoApex.Result.annualReturn[i].Data.listOfForeignInvestors[j].percentageOfSharesHeld;
                            inv.ExternalDataSource__c = 'MCA';
                            if(obj =='Lead'){
                                inv.New_Client__c = clientId;
                            }
                            else{
                                inv.Client__c = clientId;
                            }
                            listinv.add(inv);
                        }
                    }
                    
                    System.debug('Size of Subsidiary --> '+respoApex.Result.annualReturn[i].Data.subsidiariesList.size());
                    if(respoApex.Result.annualReturn[i].Data.subsidiariesList != null && respoApex.Result.annualReturn[i].Data.subsidiariesList.size() > 0){
                        for(Integer k=0;k<respoApex.Result.annualReturn[i].Data.subsidiariesList.size();k++){
                            if(respoApex.Result.annualReturn[i].Data.subsidiariesList[k].holdingSubsidiaryAssociateJointVenture == 'Subsidiary'){
                                Subsidiary__c sub = new Subsidiary__c();
                                sub.Name = respoApex.Result.annualReturn[i].Data.subsidiariesList[k].namecompany;
                                sub.percentage_of_shares__c = respoApex.Result.annualReturn[i].Data.subsidiariesList[k].percentageOfSharesHeld;
                                sub.ExternalDataSource__c = 'MCA';
                                if(obj =='Lead'){
                                    sub.New_Client__c = clientId;
                                }
                                else{
                                    sub.Client__c = clientId;
                                }
                                listsub.add(sub);
                            }
                            if(respoApex.Result.annualReturn[i].Data.subsidiariesList[k].holdingSubsidiaryAssociateJointVenture == 'Joint Venture'){
                                Joint_Venture__c juv = new Joint_Venture__c();
                                juv.Name = respoApex.Result.annualReturn[i].Data.subsidiariesList[k].namecompany;
                                juv.percentage_of_shares__c = respoApex.Result.annualReturn[i].Data.subsidiariesList[k].percentageOfSharesHeld;
                                juv.ExternalDataSource__c = 'MCA';
                                if(obj =='Lead'){
                                    juv.New_Client__c = clientId;
                                }
                                else{
                                    juv.Client__c = clientId;
                                }
                                listjuv.add(juv);
                            }
                        }
                    }
                }                
            }
            
            //ErrorLogCreater_cls.apexDebugLoggerForAPICallout(null,'createInvestors','createInvestorsFromMCAAnnualReturn',null,reqBody,responseBody,entityURL);
            
        }
        catch(exception e){
            ErrorLogCreater_cls.apexDebugLoggerForAPICallout(e,'createInvestors','createInvestorsFromMCAAnnualReturn',null,reqBody,responseBody,entityURL);
            System.debug('error in Investor'+e.getMessage());
        }
        if(listsub.Size()>0){
            insert listsub;
        }
        if(listinv.Size()>0){
            insert listinv;
        }
        if(listjuv.Size()>0){
            insert listjuv;
        }
    }
}