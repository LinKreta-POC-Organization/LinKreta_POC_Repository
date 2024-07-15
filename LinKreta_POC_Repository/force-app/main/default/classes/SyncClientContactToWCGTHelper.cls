/*
    Created by : Suraj Kumar
    Date : 05-09-2023
    Description : This class is used to send Client Contact details to WCGT on creation or updation. 
*/

public class SyncClientContactToWCGTHelper {
    
    public static String getQuery(){
        String query = 'SELECT Id, Name, MiddleName, Last_Modified_By_for_WCGT__c, Last_Modified_By_for_WCGT__r.USER_ID__c, AccountId, Account.Name, Account.DS_Team_Approval_Status__c, Account.Client_s_Headquarter__Street__s, MobilePhone, Email,Designation__c, RelationshipOffice__c, CreatedBy.EMP_ID__c,LastModifiedBy.EMP_ID__c,Owner.EMP_ID__c, Contact_status__c, Salutation, FirstName, LastName, RelationshipOffice__r.Location_Id__c,  Client_Location__Street__s, Client_Location__City__s,  toLabel(Client_Location__StateCode__s), Client_Location__PostalCode__s,toLabel(Client_Location__CountryCode__s), LastModifiedById, LastModifiedBy.USER_ID__c,Owner.USER_ID__c,WcgtId__c,CreatedBy.USER_ID__c, Account.Client_s_Headquarter__City__s, toLabel(Account.Client_s_Headquarter__CountryCode__s), Account.Client_s_Headquarter__PostalCode__s, toLabel(Account.Client_s_Headquarter__StateCode__s) FROM Contact WHERE Id IN : contactIds' ;
        return query;
    }
    
    
    public Static List<API_Logger__c> syncClientContactToWCGT( Contact clientContact, String Flag ){
        
        try{
            List<Api_Logger__c> apiLoggerList = new List<Api_Logger__c>();
            WCGTEndPoint__mdt metaRecord = WCGTEndPoint__mdt.getInstance('Client_Contact_Insert');
            
            Http http = new Http();
            HttpRequest req = new HttpRequest();
            // String token = SalesforceToWCGTAccess.getAuthenticationToken();
            SalesforceToWCGTAccess.TokenResponse tokenResp = SalesforceToWCGTAccess.getAuthentication(clientContact.Id);
            apiLoggerList.add(tokenResp.apiLog);
            String endpoint = metaRecord.URL__c + '?stoken=' + tokenResp.token;
            req.setEndpoint(endpoint);
            req.setMethod('POST');
            req.setHeader('Content-Type','application/json');        
            
            // Get Request Wrapper from Helper Class
            String reqBody = salesforceToWCGTHelper.getClientContactRequestBody(clientContact, Flag);
            System.debug('reqBody -->' + reqBody);            
            req.setBody(reqBody);
            
            HttpResponse resp;
            resp = http.send(req);
            System.debug('resp -->'+resp);
            System.debug('resp Body -->'+resp.getBody());
            API_Logger__c apiLog = API_LoggerCommonUtility.createAPILogger(clientContact.Id,reqBody,resp.getBody(),resp.getStatus(),'SyncClientContactToWCGTHelper',endpoint,resp.getStatusCode(),null,null);
            apiLoggerList.add(apiLog);

            if (!apiLoggerList.isEmpty()) {
                return apiLoggerList;
            } else {
                return null;
            }
            
        }
        catch(Exception e){
            System.debug('Error: ' + e.getMessage() + ' in line : ' + e.getLineNumber());
            ErrorLogCreater_cls.apexDebugLogger(e, 'SyncClientContactToWCGTHelper' , 'syncClientContactToWCGT' , clientContact.Id );
            return null;
            //ErrorLogCreater_cls.apexDebugLoggerForAPICallout(e, 'SyncClientContactToWCGTHelper' , 'syncClientContactToWCGT' , '' , reqBody,resp.getBody(), 'https://uat360.wcgt.in/GTSF/api/BDActivity/Insert' );
        }
    }
}