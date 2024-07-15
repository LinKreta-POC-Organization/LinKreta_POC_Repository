/*
Created by : Suraj Kumar
Date : 03-09-2023
Description : This class is used to send Client Contact Relationship Team details whenever they are created or updated to WCGT
*/

public class SyncClientContactTeamHandler {
    public static WCGTEndpoint__mdt WCGTApi = WCGTEndpoint__mdt.getInstance('Client_Contact_Team');
    
    public static String getQuery(){
        //String query = 'SELECT Id, Name, CreatedDate, LastModifiedDate, Client_Contact__c FROM Client_Contact_Relationship_Team__c WHERE (CreatedDate = TODAY OR LastModifiedDate = Today) AND Client_Contact__r.WCGTId__c  != null AND Client_Contact__r.Id =  \'' +'0031s000019WiQVAA0'+'\'';
        String query = 'SELECT Id, Name, CreatedDate, LastModifiedDate, Client_Contact__c FROM Client_Contact_Relationship_Team__c WHERE (CreatedDate = TODAY OR LastModifiedDate = Today) AND Client_Contact__r.WCGTId__c  != null';
        system.debug('query:'+Database.query(query));
        return query;
    }
    
    public static void getRelationshipTeamMembers(Set<Id> clientContactIds){
        // This map will contain contact Id corresponding to RequestWrapper
        Map <Id, RequestWrapper> contactToWrapperMap = new Map<Id, RequestWrapper>();
        
        // This map will contain Contact corresponding to the list of it's related Contact Relationship Team records.
        Map<Contact, List<Client_Contact_Relationship_Team__c>> contactToRelationshipTeamMap = new Map<Contact, List<Client_Contact_Relationship_Team__c>>();    
        
        
        // This loop is used to fill contactToRelationshipTeamMap
        for(Contact con : [SELECT Id, WCGTId__c, LastModifiedBy.EMP_ID__c,LastModifiedBy.USER_ID__c ,(SELECT Id, User__c, User__r.EMP_ID__c FROM Client_Contact_Relationship_Team__r) FROM Contact WHERE ID IN :clientContactIds ]){
            contactToRelationshipTeamMap.put(con, con.Client_Contact_Relationship_Team__r);
        }
        
        // This loop fills contactToWrapperMap which contains contactId corresponding to requestWrapper which will be used for HTTP Callout.
        for(Contact contact : contactToRelationshipTeamMap.keySet()){
            String empId;
            for(Client_Contact_Relationship_Team__c teamMember : contactToRelationshipTeamMap.get(contact)){
                if(teamMember.User__r.EMP_ID__c != null){
                    empId = (empId == Null ? teamMember.User__r.EMP_ID__c : empId) + ', ' + teamMember.User__r.EMP_ID__c;
                }
            }
            
            RequestWrapper reqObj = new RequestWrapper();
            reqObj.sContactWCGTID = contact.WCGTId__c;
            reqObj.sStatus = '1';
            reqObj.sUserId = (contact.LastModifiedBy.USER_ID__c != null) ? contact.LastModifiedBy.USER_ID__c : 'US000407';
            reqObj.sEMPID = empId == Null ? Null : empId;
            contactToWrapperMap.put(contact.Id, reqObj);
        }
        
        List<API_Logger__c> apiLoggerList = new List<API_Logger__c>();
        
        if(!contactToWrapperMap.values().isEmpty()){
            
            // This loop is calling contactTeamCallout method which is used to send contact team record to WCGT
            for(Id contactId : contactToWrapperMap.keySet()){
                API_Logger__c apiLoggerObj = SyncClientContactTeamHandler.contactTeamCallout(contactId, contactToWrapperMap.get(contactId));
                apiLoggerList.add(apiLoggerObj);
            }
        }
        
        if(!apiLoggerList.isEmpty()){
            Database.insert(apiLoggerList);
        }
    }
    
    // This method which is used to send contact team record to WCGT
    public static API_Logger__c contactTeamCallout(Id contactId, RequestWrapper requestObj){
        
        // Below defined variables are used for API Logger.
        String requestBody;
        String responseBody;
        String responseStatus;
        Decimal reponseStatusCode;
        API_Logger__c apiLoggerObj;
        
        try{
            
            System.debug('requestObj in JSON : ' + JSON.serialize(requestObj));
            
            if(String.isNotBlank(requestObj.sContactWCGTID) && String.isNotBlank(requestObj.sUserId) && String.isNotBlank(requestObj.sStatus) && String.isNotBlank(requestObj.sEMPID)){
                
                requestBody = JSON.serialize(requestObj);
                Http http = new Http();
                HttpRequest request = new HttpRequest();
                String token = SalesforceToWCGTAccess.getAuthenticationToken();
                String endpoint = WCGTApi.URL__c + '?stoken=' + token;
                request.setEndpoint(endpoint);
                request.setMethod('POST');
                request.setHeader('Content-Type','application/json'); 
                request.setBody(requestBody);
                
                // Sending the POST request to WCGT
                
                HttpResponse response = http.send(request);
                responseBody = response.getBody();
                responseStatus = response.getStatus();
                reponseStatusCode = response.getStatusCode();
                System.debug('Body : ' + responseBody);
                System.debug('Respone status : ' + response.getStatus());
                apiLoggerObj = API_LoggerCommonUtility.createAPILogger(contactId, requestBody, responseBody, responseStatus, 'SyncClientContactTeamHandler', WCGTApi.URL__c, reponseStatusCode);
            }
            return apiLoggerObj;
        }
        catch(exception e){
            ErrorLogCreater_cls.apexDebugLoggerForAPICallout(e,'SyncClientContactTeamHandler','contactTeamCallout', contactId, requestBody, responseBody, WCGTApi.URL__c);
            return null;
        } 
        
    }
    
    // This wrapper class is used to define request body for API Callout to WCGT.
    public class RequestWrapper {
        
        public String sContactWCGTID;
        public String sEMPID;
        public String sUserId;
        public String sStatus;
    }
    
}