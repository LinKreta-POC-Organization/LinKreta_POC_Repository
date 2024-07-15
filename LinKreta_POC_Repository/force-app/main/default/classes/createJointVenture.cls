/* 
     Written By: Bhanwar Singh
     Created Date: 2/23/2023
     Last Modified By : Bhanwar Singh
     Last Modified Date : 12-04-23
     Description : This class is used to create Joint Venture For New Client and Client Object.
     Variable Used : - 
       clientId : - New Client /Client Record Id 
       companyID : - CAPIQ ID of Client (Company)
       obj : - Which Object is used like Client or New Client
*/
public class createJointVenture {
    public static void deleteOldJV(Id clientId ,String companyID ,String obj){
        if(obj == 'Lead'){
            List<Joint_Venture__c> listJVtoDelete = new List<Joint_Venture__c>([Select Id From Joint_Venture__c Where New_Client__c =: clientId AND ExternalDataSource__c = 'CapIQ' Limit 10000]);
            delete listJVtoDelete;
            createJointVenture.createJointVentureFromCAPIQ(clientId ,companyID ,obj);
        }
        
        else if(obj == 'Account'){
            List<Joint_Venture__c> listJVtoDelete = new List<Joint_Venture__c>([Select Id From Joint_Venture__c Where Client__c =: clientId AND ExternalDataSource__c = 'CapIQ' Limit 10000]);
            delete listJVtoDelete;
            createJointVenture.createJointVentureFromAccountCAPIQ(clientId ,companyID ,obj);
        }
        else{
            createJointVenture.createJointVentureFromCAPIQ(clientId ,companyID ,obj);
        }
    }
    @Future(callout =true)
    public static Void createJointVentureFromCAPIQFuture(Id clientId ,String companyID ,String obj){
        createJointVentureFromCAPIQ(clientId,companyID,obj);
    }
    @AuraEnabled
    public static void createJointVentureFromCAPIQAura(Id clientId ,String companyID ,String obj){
         createJointVentureFromCAPIQ(clientId,companyID,obj);
    }
    @Future(callout =true)
    public static Void createJointVentureFromAccountCAPIQ(Id clientId ,String companyID ,String obj){
        createJointVentureFromCAPIQ(clientId,companyID,obj);
    }
    public static void createJointVentureFromCAPIQ(Id clientId ,String companyID ,String obj)
    {
        
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setMethod('POST');
        CapIQ__mdt capIq = [SELECT Id, UserName__c, Password__c, EndPointURL__c  FROM CapIQ__mdt Limit 1];
        req.setEndpoint(capIq.EndPointURL__c);
        Blob headerValue = Blob.valueOf  (capIq.UserName__c + ':' + capIq.Password__c);
        String authorizationHeader = 'BASIC ' + EncodingUtil.base64Encode(headerValue);
        req.setHeader('Authorization',authorizationHeader);
        req.setHeader('Content-Type','application/json');
        String reqBody = '{"inputRequests": [{"function":"GDSHE","mnemonic":"IQ_TRANSACTION_LIST_MA","identifier":"'+companyID+'","properties": {"startRank":"1","endRank":"30"}}]}';
        req.setBody(reqBody);
        
        HttpResponse resp = http.send(req); 
        clientNewIqWrapper respoApex=(clientNewIqWrapper) System.JSON.deserialize(resp.getBody(), clientNewIqWrapper.class);
        
        List<Joint_Venture__c> listjVnt = new List<Joint_Venture__c>();
        try{
            for(Integer i=0;i<respoApex.GDSSDKResponse[0].Rows.Size();i++)
            {
                Joint_Venture__c jVnt = new Joint_Venture__c();  
                List<String> listreturn =   new List<String>();
                listreturn = createJointVenture.jointVentureFeature(respoApex.GDSSDKResponse[0].Rows[i].Row[0]);
                jVnt.Features__c = listreturn[0];
                String nameofCompany = listreturn[1];
                if(nameofCompany.length() > 79){
                    nameofCompany = nameofCompany.substring(0, 79);
                }
                jVnt.Name = nameofCompany;
                if(obj == 'Lead'){
                    jVnt.new_client__c = clientId;
                } 
                jVnt.ExternalDataSource__c = 'CapIQ';
                listjVnt.add(jVnt);
            }
        }
        catch(Exception e){
   			ErrorLogCreater_cls.apexDebugLoggerForAPICallout(e, 'createJointVenture' , 'createJointVentureFromCAPIQ' , '' , reqBody,resp.getBody(), capIq.EndPointURL__c );
        }
        System.debug(listjVnt);
        insert listjVnt;
    }  
    public static List<String> jointVentureFeature(String iqTransictionId){
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setMethod('POST');
        CapIQ__mdt capIq = [SELECT Id, UserName__c, Password__c, EndPointURL__c  FROM CapIQ__mdt Limit 1];
        req.setEndpoint(capIq.EndPointURL__c);
        Blob headerValue = Blob.valueOf  (capIq.UserName__c + ':' + capIq.Password__c);
        String authorizationHeader = 'BASIC ' + EncodingUtil.base64Encode(headerValue);
        req.setHeader('Authorization',authorizationHeader);
        req.setHeader('Content-Type','application/json');
        String reqBody = '{"inputRequests": [{"function":"GDSP","mnemonic":"IQ_TR_SFEATURES","identifier":"'+iqTransictionId+'"},{"function":"GDSP","mnemonic":"IQ_TR_TARGETNAME","identifier":"'+iqTransictionId+'"}]}';
        req.setBody(reqBody);
        //System.debug(reqBody);
        HttpResponse resp = http.send(req); 
        clientNewIqWrapper respoApex=(clientNewIqWrapper) System.JSON.deserialize(resp.getBody(), clientNewIqWrapper.class);
        //System.debug(respoApex.GDSSDKResponse[1]);
        List<String> listreturn =   new List<String>();
        listreturn.add(respoApex.GDSSDKResponse[0].Rows[0].Row[0]);
        listreturn.add(respoApex.GDSSDKResponse[1].Rows[0].Row[0]);
        return listreturn;
    }
    
    
}