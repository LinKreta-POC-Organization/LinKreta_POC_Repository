public class SalesforceToWCGTAccess {
    public static string getAuthenticationToken(){
        WCGT_Access_User__mdt userCred = WCGT_Access_User__mdt.getInstance('Admin');
        String token = '';
        system.debug('userCred:'+userCred);
        if(userCred !=  null){
            Http http = new Http();
            HttpRequest req = new HttpRequest();
            req.setEndpoint(userCred.End_Point__c);
           //req.setEndpoint('https://wcgt360.wcgt.in/GTSF/api/TokenAuthenticate');
            req.setMethod('POST'); 
            req.setHeader('Content-Type','application/json');
            String reqBody = JSON.serialize(getBody(userCred));
            system.debug('reqBody:'+reqBody);
            req.setBody(reqBody);
            req.setTimeout(120000);
            HttpResponse resp;
            try{
                resp = http.send(req);
                System.debug('resp -->'+resp);
                System.debug('resp Body -->'+resp.getBody());
                API_Logger__c apiLog = API_LoggerCommonUtility.createAPILogger('',reqBody,resp.getBody(),resp.getStatus(),'SalesforceToWCGTAccess',userCred.End_Point__c,resp.getStatusCode(),null,null);
                system.debug('apiLog:'+apiLog);
                //INSERT apiLog;
                if(resp != null){
                    Map<String, Object> deserialized = (Map<String, Object>)JSON.deserializeUntyped(resp.getBody());
                    if(deserialized.get('statusCode') == 200){
                        Map<String, Object> data = (Map<String, Object>)deserialized.get('data');
                        token = String.valueOf(data.get('stoken'));
                    }
                }
            }
            catch(Exception e){
                //ErrorLogCreater_cls.apexDebugLoggerForAPICallout(e, 'salesforceToWCGT' , 'sendBDActivity' , '' , reqBody,resp.getBody(), 'https://uat360.wcgt.in/GTSF/api/BDActivity/Insert' );
            	system.debug('Error:'+e.getMessage()+' '+e.getLineNumber());
            }
        }
        return token;
    }

    // Added by Suraj on 14-05-2024 to insert the API logger for Authentication API. Created the method same as above as the earlier method is referenced in many areas, so creating a new method for Phase 1 API callouts.

    public static TokenResponse getAuthentication(String recordId){
        WCGT_Access_User__mdt userCred = WCGT_Access_User__mdt.getInstance('Admin');
        String token = '';
        TokenResponse objResponse = new TokenResponse();
        System.debug('userCred-->'+userCred);

        if(userCred !=  null){
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint(userCred.End_Point__c);
            request.setMethod('POST'); 
            request.setHeader('Content-Type','application/json');
            String requestBody = JSON.serialize(getBody(userCred));
            System.debug('requestBody-->'+requestBody);
            request.setBody(requestBody);
            request.setTimeout(120000);
            HttpResponse response;
            try{
                response = http.send(request);
                System.debug('response -->'+response);
                System.debug('response Body -->'+response.getBody());
                API_Logger__c apiLogger = API_LoggerCommonUtility.createAPILogger(recordId,requestBody,response.getBody(),response.getStatus(),'SalesforceToWCGTAccess',userCred.End_Point__c,response.getStatusCode(),null,null);

                system.debug('apiLogger:'+apiLogger);
                objResponse.apiLog = apiLogger;

                if(response != null){
                    Map<String, Object> deserializedData = (Map<String, Object>)JSON.deserializeUntyped(response.getBody());
                    if(deserializedData.get('statusCode') == 200){
                        Map<String, Object> data = (Map<String, Object>)deserializedData.get('data');
                        token = String.valueOf(data.get('stoken'));
                        objResponse.token  = token;
                    }
                }
            }
            catch(Exception e){
                String errorMessage = e.getMessage() + ', Stack Trace : ' + e.getStackTraceString();
            	system.debug('Error:'+e.getMessage()+' '+e.getLineNumber());
            	system.debug('Exception stacktrack:'+e.getStackTraceString());
                objResponse.apiLog.Message__c = e.getMessage();
                objResponse.apiLog.Record_Id__c = recordId;
            }
        }
        objResponse.token = token;
        System.debug('objResponse --> ' + objResponse);
        return objResponse;
    }
    public static authContentWrp getBody(WCGT_Access_User__mdt userCred){
        try{
            authContentWrp wrpBody = new authContentWrp();
            if(userCred != null){
                wrpBody.USERNAME = userCred.Username__c;
                wrpBody.PASSWORD = userCred.Password__c;
            }
            return wrpBody;
        }catch(Exception e){
            system.debug('Error:'+e.getMessage()+' '+e.getLineNumber());
            return null;
        }
    }
    public class authContentWrp{
        public String USERNAME;
        public String PASSWORD;
    }

    public class TokenResponse {
        public string token {get;set;}
        public API_Logger__c apiLog ;
        public TokenResponse(){
            apiLog = new API_Logger__c();
        }
    }
}