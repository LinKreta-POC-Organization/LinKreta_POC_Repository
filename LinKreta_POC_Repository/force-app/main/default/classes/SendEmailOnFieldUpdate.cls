/*
* @Name: SendEmailToCTM
* @Author: Bhavishya Basantwani
* @Description: This class is used for Send Email and Notification on Field Update of Client.
* @Date: 31-July-23
*/
public class SendEmailOnFieldUpdate {
    
    @InvocableMethod()
    public Static void FieldUpdate(List<ActionRequest> getInfo){
        system.debug('getInfo'+getInfo);
        system.debug('innn');
        List<String> fieldChanges = new List<String>();
        // Checking For Fields Not Equal To prior record and collect thier Label 
        if(getInfo[0].PriorRecord.Name != getInfo[0].PresentRecord.Name){
            SObjectField field = Schema.getGlobalDescribe().get('Account').getDescribe().fields.getMap().get('Name');
            fieldChanges.add(field.getDescribe().getLabel());
        }
        
        if(getInfo[0].PriorRecord.ParentId != getInfo[0].PresentRecord.ParentId){
            SObjectField field = Schema.getGlobalDescribe().get('Account').getDescribe().fields.getMap().get('ParentId');
            fieldChanges.add(field.getDescribe().getLabel());
        }
        if(getInfo[0].PriorRecord.GT_Client_Group__c != getInfo[0].PresentRecord.GT_Client_Group__c){
            SObjectField field = Schema.getGlobalDescribe().get('Account').getDescribe().fields.getMap().get('GT_Client_Group__c');
            fieldChanges.add(field.getDescribe().getLabel());
        }
        if(getInfo[0].PriorRecord.Key_Account_360__c != getInfo[0].PresentRecord.Key_Account_360__c){
            SObjectField field = Schema.getGlobalDescribe().get('Account').getDescribe().fields.getMap().get('Key_Account_360__c');
            fieldChanges.add(field.getDescribe().getLabel());
        }
        if(getInfo[0].PriorRecord.CSL__c != getInfo[0].PresentRecord.CSL__c){
            SObjectField field = Schema.getGlobalDescribe().get('Account').getDescribe().fields.getMap().get('CSL__c');
            fieldChanges.add(field.getDescribe().getLabel());
        }
        if(getInfo[0].PriorRecord.CoCSL__c != getInfo[0].PresentRecord.CoCSL__c){
            SObjectField field = Schema.getGlobalDescribe().get('Account').getDescribe().fields.getMap().get('CoCSL__c');
            fieldChanges.add(field.getDescribe().getLabel());
        }
        if(getInfo[0].PriorRecord.Client_reason_if_inactive__c != getInfo[0].PresentRecord.Client_reason_if_inactive__c){
            SObjectField field = Schema.getGlobalDescribe().get('Account').getDescribe().fields.getMap().get('Client_reason_if_inactive__c');
            fieldChanges.add(field.getDescribe().getLabel());
        }
        if(getInfo[0].PriorRecord.LegalEntityType__c != getInfo[0].PresentRecord.LegalEntityType__c){
            SObjectField field = Schema.getGlobalDescribe().get('Account').getDescribe().fields.getMap().get('LegalEntityType__c');
            fieldChanges.add(field.getDescribe().getLabel());
        }
        if(getInfo[0].PriorRecord.Domestic_Ultimate_Owner__c != getInfo[0].PresentRecord.Domestic_Ultimate_Owner__c){
            SObjectField field = Schema.getGlobalDescribe().get('Account').getDescribe().fields.getMap().get('Domestic_Ultimate_Owner__c');
            fieldChanges.add(field.getDescribe().getLabel());
        }
        if(getInfo[0].PriorRecord.Global_Ultimate_Owner__c != getInfo[0].PresentRecord.Global_Ultimate_Owner__c){
            SObjectField field = Schema.getGlobalDescribe().get('Account').getDescribe().fields.getMap().get('Global_Ultimate_Owner__c');
            fieldChanges.add(field.getDescribe().getLabel());
        }
        if(getInfo[0].PriorRecord.Client_Category__c != getInfo[0].PresentRecord.Client_Category__c){
            SObjectField field = Schema.getGlobalDescribe().get('Account').getDescribe().fields.getMap().get('Client_Category__c');
            fieldChanges.add(field.getDescribe().getLabel());
        }
        // if(getInfo[0].PriorRecord.GSTIN__c != getInfo[0].PresentRecord.GSTIN__c){
        //     SObjectField field = Schema.getGlobalDescribe().get('Account').getDescribe().fields.getMap().get('GSTIN__c');
        //     fieldChanges.add(field.getDescribe().getLabel());
        // }
        if(getInfo[0].PriorRecord.Client_Account_Sub_Category__c != getInfo[0].PresentRecord.Client_Account_Sub_Category__c){
            SObjectField field = Schema.getGlobalDescribe().get('Account').getDescribe().fields.getMap().get('Client_Account_Sub_Category__c');
            fieldChanges.add(field.getDescribe().getLabel());
        }
        if(getInfo[0].PriorRecord.AccountType__c != getInfo[0].PresentRecord.AccountType__c){
            SObjectField field = Schema.getGlobalDescribe().get('Account').getDescribe().fields.getMap().get('Client_Category__c');
            fieldChanges.add(field.getDescribe().getLabel());
        }
        if(getInfo[0].PriorRecord.ClientStatus__c != getInfo[0].PresentRecord.ClientStatus__c){
            SObjectField field = Schema.getGlobalDescribe().get('Account').getDescribe().fields.getMap().get('ClientStatus__c');
            fieldChanges.add(field.getDescribe().getLabel());
        }
        if(getInfo[0].PriorRecord.Entity_Type_Master__c != getInfo[0].PresentRecord.Entity_Type_Master__c){
            SObjectField field = Schema.getGlobalDescribe().get('Account').getDescribe().fields.getMap().get('Entity_Type_Master__c');
            fieldChanges.add(field.getDescribe().getLabel());
        }
        // String FinalfieldChangesString ;
        string fieldChangesString;
        set<String> setOfIds = new set<String>();
        set<String> activeUserIds = new set<String>();
        system.debug('fieldchange'+fieldChanges);
        if(fieldChanges.size()>0){
            String notificationTypeApiName = 'NewClientOwnerChanged';
            // Added by Rajat for Email Template related changes
            Map<Id,String> mapUserIdWithName = new Map<Id,String>();
            List<User> userList = [SELECT ID,Name FROM USER WHERE isActive = true AND ID IN: getInfo[0].RecipentId];
            if(userList.size() > 0){
                for(User usr : userList){
                    mapUserIdWithName.put(usr.Id,usr.Name);
                }
            }
            List<Messaging.SingleEmailMessage> emailList = new List<Messaging.SingleEmailMessage>();
            Messaging.SingleEmailMessage mail = Messaging.renderStoredEmailTemplate(getInfo[0].TemlateId, getInfo[0].recipentid[0],  getInfo[0].PriorRecord.Id);
            for(ActionRequest accReqObj : getInfo){
                For(integer i=0 ; i<accReqObj.RecipentId.size(); i++){
                    Messaging.SingleEmailMessage objMail = new Messaging.SingleEmailMessage();
                    string[] to = new string[] {accReqObj.EmailAddress[i]};
                    objMail.setToAddresses(to);
                    String body = mail.getHtmlBody();
                    String Subject = mail.getSubject();
                    fieldChangesString = string.join(fieldChanges,',');
                    body = body.replace('{fields.name}',fieldChangesString);
                    if(mapUserIdWithName.containsKey(accReqObj.RecipentId[i])){
                        body = body.replace('[Name]',mapUserIdWithName.get(accReqObj.RecipentId[i]));
                    }
                    objMail.setHtmlBody(body);
                    objMail.setSubject(Subject);
                    List<OrgWideEmailAddress> orgWideEmails =  [SELECT Id, Address, DisplayName FROM OrgWideEmailAddress WHERE DisplayName = 'Linkreta' LIMIT 1];
                    if(orgWideEmails != null){
                        objMail.setOrgWideEmailAddressId(orgWideEmails[0].Id);
                    }
                    objMail.setSaveAsActivity(false);
                    emailList.add(objMail);
                    setOfIds.add(accReqObj.recipentid[i]);
                }
            }
            
            Messaging.SendEmailResult[] results = Messaging.sendEmail(emailList);
            system.debug('resultsresults'+results);
            
            CustomNotificationType notificationType = 
                [SELECT Id, DeveloperName 
                 FROM CustomNotificationType 
                 WHERE DeveloperName='NewClientOwnerChanged'];
            
            String NotificationAndTitle = 'There has been a change in the '+ fieldChangesString + ' for ' + getInfo[0].PriorRecord.Name;
            Messaging.CustomNotification notification = new Messaging.CustomNotification();
            
            // Set the contents for the notification
            notification.setTitle(NotificationAndTitle);
            notification.setBody(NotificationAndTitle);
            
            // Set the notification type and target
            notification.setNotificationTypeId(notificationType.Id);
            notification.setTargetId(getInfo[0].PriorRecord.Id);
            
            // Actually send the notification


            for (User userObj : [SELECT Id, Name, isActive FROM User WHERE isActive = true AND Id IN : setOfIds]) {
                activeUserIds.add(userObj.Id);
            }
            
            if (activeUserIds != null && activeUserIds.size() > 0) {
                System.debug('activeUserIds : ' + activeUserIds);
                notification.send(activeUserIds);
            }
            
            
        }
    }
    
    public class ActionRequest{
        @InvocableVariable
        public string TemlateId;
        @InvocableVariable
        public List<string> RecipentId;
        @InvocableVariable
        public List<string> EmailAddress;
        @InvocableVariable
        public string UserName;
        @InvocableVariable
        public Account PriorRecord;
        @InvocableVariable
        public Account PresentRecord;    
    }
}