/* 
     Written By: Bhanwar Singh
     Created Date: 2/23/2023
     Last Modified By : Bhanwar Singh
     Last Modified Date : 12-04-23
     Description : This class is used to create Client News (Key Development and Alerts) For New Client and Client Object.
     Variable Used : - 
       clientId : - New Client /Client Record Id 
       companyID : - CAPIQ ID of Client (Company)
       obj : - Which Object is used like Client or New Client
*/
public class createClientNews {
    public static void deleteOldClientNews(Id clientId ,String companyID ,String obj){
        if(obj == 'Lead'){
            List<Client_News__c> listinvtoDelete = new List<Client_News__c>([Select Id From Client_News__c Where New_Client__c =: clientId AND ExternalDataSource__c = 'CapIQ' Limit 10000]);
            System.debug(listinvtoDelete);
            delete listinvtoDelete;
            createClientNews.createClientNewsFromCAPIQ(clientId ,companyID ,obj);
        }
        if(obj == 'Account'){
            List<Client_News__c> listinvtoDelete = new List<Client_News__c>([Select Id From Client_News__c Where Client__c =: clientId AND ExternalDataSource__c = 'CapIQ' Limit 10000]);
            System.debug(listinvtoDelete);
            delete listinvtoDelete;
            createClientNews.createClientNewsFromAccountCAPIQ(clientId ,companyID ,obj);
        }
        else{
            createClientNews.createClientNewsFromCAPIQ(clientId ,companyID ,obj);
        }
       
    }
    @Future(callout =true)
    public static Void createClientNewsFromCAPIQFuture(Id clientId ,String companyID ,String obj){
        createClientNewsFromCAPIQ(clientId,companyID,obj);
    }
    @AuraEnabled
    public static void createClientNewsFromCAPIQAura(Id clientId ,String companyID ,String obj){
         createClientNewsFromCAPIQ(clientId,companyID,obj);
    }
    @Future(callout =true)
    public static Void createClientNewsFromAccountCAPIQ(Id clientId ,String companyID ,String obj){
        createClientNewsFromCAPIQ(clientId,companyID,obj);
    }
    public static void createClientNewsFromCAPIQ(Id clientId ,String companyID , String obj){
        
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        CapIQ__mdt capIq = [SELECT Id, UserName__c, Password__c, EndPointURL__c  FROM CapIQ__mdt Limit 1];
         req.setEndpoint(capIq.EndPointURL__c);
        req.setMethod('POST');
        Blob headerValue = Blob.valueOf  (capIq.UserName__c + ':' + capIq.Password__c);
        String authorizationHeader = 'BASIC ' + EncodingUtil.base64Encode(headerValue);
        req.setHeader('Authorization',authorizationHeader);
        req.setHeader('Content-Type','application/json');
        
        Date dateToday = date.today();

        Date sixMonthsAgo = dateToday.addMonths(-6);
        
        Integer myMonth = sixMonthsAgo.month();
        Integer myDay = sixMonthsAgo.day();
        Integer myYear = sixMonthsAgo.year();
        
        String dateSixMonthago = String.valueOf(myMonth)+'/'+String.valueOf(myDay)+'/'+String.valueOf(myYear);
        myMonth = dateToday.month();
        myDay = dateToday.day();
        myYear = dateToday.year();
        String todayDate = String.valueOf(myMonth)+'/'+String.valueOf(myDay)+'/'+String.valueOf(myYear);
        String reqBody = '{"inputRequests": [{"function":"GDSHE","mnemonic":"IQ_KEY_DEV_ID","identifier":"'+companyID+'","properties": {"startDate":"'+dateSixMonthago+'","endDate":"'+todayDate+'","keyDevFilter" : "C2"}},'+
            '{"function":"GDSHE","mnemonic":"IQ_KEY_DEV_ID","identifier":"'+companyID+'","properties": {"startDate":"'+dateSixMonthago+'","endDate":"'+todayDate+'","keyDevFilter" : "C12"}},'+
            '{"function":"GDSHE","mnemonic":"IQ_KEY_DEV_ID","identifier":"'+companyID+'","properties": {"startDate":"'+dateSixMonthago+'","endDate":"'+todayDate+'","keyDevFilter" : "C5"}},'+
            '{"function":"GDSHE","mnemonic":"IQ_KEY_DEV_ID","identifier":"'+companyID+'","properties": {"startDate":"'+dateSixMonthago+'","endDate":"'+todayDate+'","keyDevFilter" : "C15"}},'+
            '{"function":"GDSHE","mnemonic":"IQ_KEY_DEV_ID","identifier":"'+companyID+'","properties": {"startDate":"'+dateSixMonthago+'","endDate":"'+todayDate+'","keyDevFilter" : "C13"}},'+
            //'{"function":"GDSHE","mnemonic":"IQ_KEY_DEV_ID","identifier":"'+companyID+'","properties": {"startDate":"'+dateSixMonthago+'","endDate":"'+todayDate+'","keyDevFilter" : "C11"}},'+
            '{"function":"GDSHE","mnemonic":"IQ_KEY_DEV_ID","identifier":"'+companyID+'","properties": {"startDate":"'+dateSixMonthago+'","endDate":"'+todayDate+'","keyDevFilter" : "C10"}},'+
            //'{"function":"GDSHE","mnemonic":"IQ_KEY_DEV_ID","identifier":"'+companyID+'","properties": {"startDate":"'+dateSixMonthago+'","endDate":"'+todayDate+'","keyDevFilter" : "C9"}},'+
            '{"function":"GDSHE","mnemonic":"IQ_KEY_DEV_ID","identifier":"'+companyID+'","properties": {"startDate":"'+dateSixMonthago+'","endDate":"'+todayDate+'","keyDevFilter" : "C6"}},'+
            '{"function":"GDSHE","mnemonic":"IQ_KEY_DEV_ID","identifier":"'+companyID+'","properties": {"startDate":"'+dateSixMonthago+'","endDate":"'+todayDate+'","keyDevFilter" : "C4"}},'+
            '{"function":"GDSHE","mnemonic":"IQ_KEY_DEV_ID","identifier":"'+companyID+'","properties": {"startDate":"'+dateSixMonthago+'","endDate":"'+todayDate+'","keyDevFilter" : "C1"}},'+
            '{"function":"GDSHE","mnemonic":"IQ_KEY_DEV_ID","identifier":"'+companyID+'","properties": {"startDate":"'+dateSixMonthago+'","endDate":"'+todayDate+'","keyDevFilter" : "C3"}},'+
            '{"function":"GDSHE","mnemonic":"IQ_KEY_DEV_ID","identifier":"'+companyID+'","properties": {"startDate":"'+dateSixMonthago+'","endDate":"'+todayDate+'","keyDevFilter" : "C7"}},'+
            '{"function":"GDSHE","mnemonic":"IQ_KEY_DEV_ID","identifier":"'+companyID+'","properties": {"startDate":"'+dateSixMonthago+'","endDate":"'+todayDate+'","keyDevFilter" : "C8"}}'+']}';

		
		req.setBody(reqBody);
        System.debug('reqBody ---> '+reqBody);
        List<Client_News__c> cNewslist = new List<Client_News__c>();
        HttpResponse resp = http.send(req); 
        System.debug('resbody '+resp.getBody());
        clientNewIqWrapper respoApex=(clientNewIqWrapper) System.JSON.deserialize(resp.getBody(), clientNewIqWrapper.class);
        try{
            for(Integer j=0; j<respoApex.GDSSDKResponse.size() ;j++){
                try{
                    for(Integer i=0;i<respoApex.GDSSDKResponse[j].Rows.size() ;i++){
               
				          Client_News__c news = new Client_News__c();
                   
                if(respoApex.GDSSDKResponse[j].Rows[i].Row[0] != 'Data Unavailable'){
                    news = createClientNews.createClientNewsDataFromCAPIQ(respoApex.GDSSDKResponse[j].Rows[i].Row[0],clientId,obj);
                    news.ExternalDataSource__c = 'CapIQ';
                    cNewslist.add(news);       
                }
                   }
                }	
                Catch(Exception e)
                {
                    
                }
            }
        }
        catch(Exception e){
   			System.debug('List exception fired');         
        }
        System.debug(cNewslist);
        insert cNewslist;
    }
    public static Client_News__c createClientNewsDataFromCAPIQ(String keyDevId , Id clientId ,String obj)
    {
        
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        CapIQ__mdt capIq = [SELECT Id, UserName__c, Password__c, EndPointURL__c  FROM CapIQ__mdt Limit 1];
         req.setEndpoint(capIq.EndPointURL__c);
        req.setMethod('POST');
        Blob headerValue = Blob.valueOf  (capIq.UserName__c + ':' + capIq.Password__c);
        String authorizationHeader = 'BASIC ' + EncodingUtil.base64Encode(headerValue);
        Client_News__c cNews = new Client_News__c ();
        req.setHeader('Authorization',authorizationHeader);
        req.setHeader('Content-Type','application/json');
        String reqBody = '{"inputRequests":[{"function":"GDSP","mnemonic":"IQ_KEY_DEV_TYPE", "identifier":"'+keyDevId+'"},{"function":"GDSP","mnemonic":"IQ_KEY_DEV_DATE","identifier":"'+keyDevId+'"},{"function":"GDSP","mnemonic":"IQ_KEY_DEV_HEADLINE","identifier":"'+keyDevId+'"}]}';
        req.setBody(reqBody);
        HttpResponse resp = http.send(req); 
        clientNewIqWrapper respoApex=(clientNewIqWrapper) System.JSON.deserialize(resp.getBody(), clientNewIqWrapper.class);
        
        try{
            cNews.Name = respoApex.GDSSDKResponse[0].Rows[0].Row[0];
            cNews.IQ_KEY_DEV_TYPE__c = respoApex.GDSSDKResponse[0].Rows[0].Row[0];
            
            //cNews.Key_Development_Date__c = respoApex.GDSSDKResponse[1].Rows[0].Row[0];
            cNews.IQ_KEY_DEV_HEADLINE__c = respoApex.GDSSDKResponse[2].Rows[0].Row[0];
            cNews.ExternalDataSource__c = 'CapIQ';
            string dsting = respoApex.GDSSDKResponse[1].Rows[0].Row[0];
            List<String> dlist = dsting.split(' ');
            List<String> datelist = dlist[0].split('/');
            cNews.Key_Development_Date__c  = date.parse(datelist[1]+'/'+datelist[0]+'/'+datelist[2]);
            if(obj == 'Lead')
            {
                cNews.New_Client__c = clientId;
            }
            else{
                cNews.Client__c = clientId;
            }
        }
        catch(Exception e){
   			System.debug('List exception fired' + e.getMessage());         
        }
        //System.debug(cNews);
        return cNews;
    }
    
    
        
}