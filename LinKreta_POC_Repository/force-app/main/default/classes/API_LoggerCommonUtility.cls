/**
 * @description       : Ceration on API Logger
 * @author            : Deepak Joshi
 * @last modified on  : 11-07-2023
 * @last modified by  : Deepak Joshi
**/
public  class API_LoggerCommonUtility { 
     /**
 * @description 
 * @author Deepak Joshi | 11-07-2023
 
 **/
    public static API_Logger__c createAPILogger(Id recordId,String request,String response,String status,String className,String endPoint,Decimal statusCode){
        System.debug('Endpoint in logger class : ' + endpoint);
        API_Logger__c  logger = new API_Logger__c();
        logger.Request__c = request;
        logger.Response__c = response;
        logger.Status__c = status;
        logger.Class_Name__c = className;
        logger.End_Point__c = endPoint;
        logger.Record_Id__c =recordId;
        logger.Status_Code__c = statusCode;
       
        return logger;

    }
    /**
 * @description 
 * @author Deepak Joshi | 11-07-2023
 
 **/

 // Added by Rakesh
 public static API_Logger__c createAPILogger(Id recordId,String request,String response,String status,String className,String token){
    API_Logger__c  logger = new API_Logger__c();
    logger.Request__c = request;
    logger.Response__c = response;
    logger.Status__c = status;
    logger.Class_Name__c = className;
    logger.Record_Id__c =recordId;
   logger.Token__c =token;
    return logger;

}
    
    // Added by Rajat
    public static API_Logger__c createAPILogger(String recordId ,String request,String response,String status,String className,String endPoint,Decimal statusCode,String message/*,String parentId*/){
        API_Logger__c  logger = new API_Logger__c();
        logger.Record_Id__c =recordId;
        logger.Request__c = request;
        logger.Response__c = response;
        logger.Status__c = status;
        logger.Class_Name__c = className;
        logger.End_Point__c = endPoint;
        logger.Status_Code__c = statusCode;
        logger.Message__c = message;
       	//logger.Parent__c  = parentId;
        logger.isSuccess__c = statusCode == 200 ? true : false;
        return logger;
    }
    // Added by Deepak Joshi
    public static API_Logger__c createAPILogger(String recordId ,String request,String response,String status,String className,String endPoint,Decimal statusCode,String message,String parentId){
        API_Logger__c  logger = new API_Logger__c();
        logger.Record_Id__c =recordId;
        logger.Request__c = request;
        logger.Response__c = response;
        logger.Status__c = status;
        logger.Class_Name__c = className;
        logger.End_Point__c = endPoint;
        //logger.Status_Code__c = statusCode;

        try {
            Map<String, Object> deserialized = (Map<String, Object>)JSON.deserializeUntyped(response);
            System.debug('statusCode-- '+String.valueOf(deserialized.get('statusCode')));
            if(deserialized.get('statusCode') != null){
                logger.Status_Code__c = Decimal.valueOf(String.valueOf(deserialized.get('statusCode')));
            }
        } catch (Exception e) {
            logger.Status_Code__c = 101;
        } 
       
        logger.Message__c = message;
       	logger.Parent__c  = parentId;
        logger.isSuccess__c = logger.Status_Code__c == 200 ? true : false;
        return logger;
    }
    
    // ADDED BY RAJAT 
    public static void sendSyncFailedEmail(List<API_Logger__c> apiList){
        try{
            if(apiList.size() > 0){
                EmailTemplate et = [SELECT Id,Subject, Body FROM EmailTemplate WHERE DeveloperName =: ConstantUtility.SYNC_FAILED_EMAIL_TEMPLATE];
                //List<User> usr = [SELECT Id,Email FROM User WHERE Email = 'rajat.s@techmatrixconsulting.com' AND isActive = true LIMIT 1];
                String emailRecipient = System.Label.Retry_API_Recipient;
                List<User> usr = [SELECT Id,Email FROM User WHERE Email =: emailRecipient AND isActive = true LIMIT 1];
                OrgWideEmailAddress orgWideEmails =  [SELECT Id, Address, DisplayName FROM OrgWideEmailAddress WHERE DisplayName = 'Linkreta' LIMIT 1];
                List<Messaging.SingleEmailMessage> emailMessages = new List<Messaging.SingleEmailMessage>(); 
                for(API_Logger__c api : apiList){
                    if(usr.size() > 0){
                        Messaging.SingleEmailMessage emailMessageRequest = Messaging.renderStoredEmailTemplate(et.Id,usr[0].Id,api.Id);            
                        emailMessageRequest.setToAddresses(new list<string>{usr[0].Email});
                        if(orgWideEmails != null){
                            emailMessageRequest.setOrgWideEmailAddressId(orgWideEmails.Id);
                        }
                        emailMessageRequest.setSaveAsActivity(false);
                        emailMessages.add(emailMessageRequest);
                    }
                }
                if(!emailMessages.isEmpty()){
                    Messaging.sendEmail(emailMessages);
                }
            }
        }catch(Exception e){
            system.debug('Exception:'+e.getLineNumber()+' '+e.getMessage());
        }
    }
}