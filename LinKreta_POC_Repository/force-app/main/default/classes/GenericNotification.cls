/*
AUTHOR                   : Deepak joshi
VERSION                  : 1
MODIFICATION DATE        : 31 July 2023
PROJECT NAME / TICKET #  : GT
DESCRIPTION              : GenericNotification

AUTHOR                   :
VERSION                  :2
MODIFICATION DATE        : 
PROJECT NAME / TICKET #  : 
DESCRIPTION              : 
*/
public  class GenericNotification {
     /**
     * 
    * @description 
    * @author Deepak Joshi | 31 July 2023
    * @param objectId 
    * @param recipientIds 
    * @param emailTemplate 
    **/
    public static void  SendEmail(String objectId, Set<String> recipientIds ,EmailTemplate emailTemplate){
        try{
            System.debug('recipientIds  '+recipientIds);
            List<String> sendingTo = new  List<String>(recipientIds);
            Messaging.SingleEmailMessage email = Messaging.renderStoredEmailTemplate(emailTemplate.Id, UserInfo.getUserId(), objectId);
            email.setTargetObjectId(UserInfo.getUserId());
            email.setTreatTargetObjectAsRecipient(false);
            email.setToAddresses(sendingTo);
           // email.setBccSender(false);
            email.setSaveAsActivity( false );
            email.setTemplateId(emailTemplate.Id);
            //email.setTargetObjectId(objectId);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
        }
        catch(emailException e){
            System.debug(' error SendEmail: ' + e);
        }
    }
    /**
     * 
    * @description 
    * @author Deepak Joshi | 31 July 2023
    * @param objectId 
    * @param recipientIds 
    * @param emailTem 
    **/
    public static void sendNotification(String objectId, Set<String> recipientIds ,EmailTemplate emailTem){
        Set<String> activeRecipients = getActiveUsers(recipientIds);
        List<CustomNotificationType> notificationType = [SELECT Id,Mobile, Desktop FROM CustomNotificationType WHERE Mobile =true AND Desktop = true LIMIT 1];
        if(!notificationType.isEmpty()){
            Messaging.CustomNotification notification = new Messaging.CustomNotification();
            notification.setTitle(emailTem.Subject);
            notification.setBody(emailTem.Subject);
            notification.setTargetId(objectId);
            notification.setNotificationTypeId(notificationType[0].Id);
            notification.send(activeRecipients);
        }
    }
     /**
     * 
    * @description 
    * @author Deepak Joshi | 31 July 2023
    * @param objectId 
    * @param recipientIds 
    * @param body 
    * @param title 
    **/
    public static void sendNotification(String objectId, Set<String> recipientIds, String body ,String title){
        Set<String> activeRecipients = getActiveUsers(recipientIds);
        List<CustomNotificationType> notificationType = [SELECT Id,Mobile, Desktop FROM CustomNotificationType WHERE Mobile =true AND Desktop = true LIMIT 1];
        if(!notificationType.isEmpty()){
            Messaging.CustomNotification notification = new Messaging.CustomNotification();
            notification.setTitle(title);
            notification.setBody(body);
            notification.setTargetId(objectId);
            notification.setNotificationTypeId(notificationType[0].Id);
            notification.send(activeRecipients);
        }
    }

    // Suraj Kumar(03-04-2024) : This method is used to get the active users from a set of user ids.    
    public static Set<String> getActiveUsers(Set<String> recipientIds){
        Set<String> activeRecipients = new Set<String>();
        for(User user : [SELECT Id, Name, isActive FROM User WHERE Id IN : recipientIds ]){
            if(user.isActive){
                activeRecipients.add(user.Id);
            }
        }
        return activeRecipients; 
    }
    
}