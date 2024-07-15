/*
    NAME                     : SendEmailOnClientContactUpdate
    AUTHOR                   : Suraj Kumar
    VERSION                  : 1
    CREATED DATE             : 28-08-2023
    PROJECT NAME / TICKET #  : GS345-288

    DESCRIPTION
    This is a Flow Invocable class created to send email and notification on update of any field on client contact

*/

/*
 * UPDATE
    NAME                     : SendEmailOnClientContactUpdate
    AUTHOR                   : Rajat
    VERSION                  : 1
    UPDATE DATE              : 07-02-2024
    PROJECT NAME / TICKET #  : GS345-288

    DESCRIPTION
    Changed due to changes done for Email Templates Correction.

*/


public class SendEmailOnClientContactUpdate {
    @InvocableMethod
    public static void getUpdatedFields(List<EmailRequest> requestObj){
        System.debug('requestObj : ' + requestObj);
        Map<String, String> fieldMap = new Map<String, String>();    
        for (Schema.SObjectField field : Contact.sObjectType.getDescribe().fields.getMap().values()) { 
            fieldMap.put(String.valueOf(field), field.getDescribe().getLabel() );     
        }
        System.debug('Fields : ' + fieldMap);
        
        String fieldChanges;
        for(String field : fieldMap.keySet()){
            if(fieldMap.get(field) != ConstantUtility.contactLastModifiedDate && fieldMap.get(field) != ConstantUtility.systemModstamp && fieldMap.get(field) != ConstantUtility.contactLastActivityTime && fieldMap.get(field) != 'Client Name'
              && fieldMap.get(field) != ConstantUtility.clicktoviewClientContact && fieldMap.get(field) != ConstantUtility.contactLastModifiedByID && fieldMap.get(field) != ConstantUtility.IntroHiveLastUpdateTime && fieldMap.get(field) != ConstantUtility.ContactWCGTId && fieldMap.get(field) != ConstantUtility.LinkedInProfile && fieldMap.get(field) != ConstantUtility.TopRelationshipStrength && fieldMap.get(field) != ConstantUtility.TopConnectedColleague && fieldMap.get(field) != ConstantUtility.CorporateRelationshipStrength && fieldMap.get(field) != ConstantUtility.DepartmentClassification && fieldMap.get(field) != ConstantUtility.FindIntroductions && fieldMap.get(field) != ConstantUtility.LastInteraction && fieldMap.get(field) != ConstantUtility.LastInteractionType && fieldMap.get(field) != ConstantUtility.LastModifiedFromIntrohiveBy && fieldMap.get(field) != ConstantUtility.PopulatedbyIntrohive && fieldMap.get(field) != ConstantUtility.IntrohiveIntroCount && fieldMap.get(field) != ConstantUtility.CreatedFromIntrohiveBy && fieldMap.get(field) != ConstantUtility.TitleCategory && fieldMap.get(field) != ConstantUtility.UpdatedbyIntrohive && fieldMap.get(field) != ConstantUtility.IntrohiveLinkedInURL){
                if(requestObj[0].PresentRecord.get(field) != requestObj[0].PriorRecord.get(field)){
                    if(String.isBlank(fieldChanges)){
                        fieldChanges = fieldMap.get(field);
                    }
                    else{
                        fieldChanges = fieldChanges + ', ' + fieldMap.get(field);
                    }
                    
                }
            }
        }
        System.debug('fieldChanges : ' + fieldChanges);
        //System.debug('Owner Name:'+requestObj[0].PresentRecord.get('OwnerId'));
        if(String.isNotBlank(fieldChanges)){
            List<Contact> presContact = [SELECT Id,OwnerId,Owner.Name,AccountId,Account.Key_Account__c FROM Contact WHERE Id =: requestObj[0].PresentRecord.Id];
            
            List<Messaging.SingleEmailMessage> listEmailMessage = new List<Messaging.SingleEmailMessage>();
            List<EmailTemplate> emailTemp = [SELECT ID FROM EmailTemplate WHERE DeveloperName = 'Email_Template_for_Field_Update_on_Client_Contact'];
            Messaging.SingleEmailMessage emailMessage = Messaging.renderStoredEmailTemplate(emailTemp[0].Id,UserInfo.getUserId(),presContact[0].Id);
            List<OrgWideEmailAddress> orgWideEmails = [SELECT Id, Address, DisplayName FROM OrgWideEmailAddress WHERE DisplayName = 'Linkreta' LIMIT 1];
            if(orgWideEmails != null){
                emailMessage.setOrgWideEmailAddressId(orgWideEmails[0].Id);
            }
            system.debug('Email Address:'+requestObj[0].EmailAddress);
            //requestObj[0].EmailAddress.add('rajat.s@techmatrixconsulting.com');
            emailMessage.setToAddresses(requestObj[0].EmailAddress);
        	emailMessage.setSaveAsActivity(false);  
			String body = emailMessage.getHtmlBody().replace('[Recipeint User]','Client Contact Relationship Team');
			body = body.replace('[Field]',fieldChanges);
			emailMessage.setHtmlBody('');
            emailMessage.setHtmlBody(body);	
			listEmailMessage.add(emailMessage);
            
            //Check if Account is Key Account then send Notification to CSL
            /*if(presContact[0].AccountId != null && presContact[0].Account.Key_Account__c == true){
                List<AccountTeamMember> accTeam = [SELECT ID,UserID,User.Name,User.Email FROM AccountTeamMember WHERE AccountId =:presContact[0].AccountId AND TeamMemberRole = 'Key Account – CSL'];
                if(accTeam.size() > 0){
                    Messaging.SingleEmailMessage emailMessage2 = Messaging.renderStoredEmailTemplate(emailTemp[0].Id,accTeam[0].UserId,presContact[0].Id);
                    if(orgWideEmails != null){
                        emailMessage2.setOrgWideEmailAddressId(orgWideEmails[0].Id);
                    }
                    emailMessage2.setToAddresses(new List<String>{accTeam[0].User.Email});
                    emailMessage2.setSaveAsActivity(false);  
                    String body2 = emailMessage2.getHtmlBody().replace('[Recipeint User]',accTeam[0].User.Name);
                    body2 = body2.replace('[Field]',fieldChanges);
                    emailMessage2.setHtmlBody('');
                    emailMessage2.setHtmlBody(body2);	
                    listEmailMessage.add(emailMessage2);
                }
            }*/
			
			try{
                Messaging.sendEmail(listEmailMessage);
            }
            catch(Exception e){
                System.debug('Error message : ' + e.getMessage() + ' in line : ' + e.getLineNumber());
            }
			
            /*
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            email.setToAddresses(requestObj[0].EmailAddress);
            email.setSenderDisplayName('Linkreta GT');
            email.setSubject('Field Updated on Client Contact');
            String body = 'Dear Client Contact Relationship Team and '+presContact[0].Owner.Name+', <br><br> ';
            body += 'This is to notify you that there has been an update on Client Contact in the "' +  fieldChanges + ' ". Please make a note of the following changes. <br><br> ';
            body += 'Please click on the following link to view the change on LinKreta <br> ' + recordURL + ' <br><br> ';
            body += 'Note:- This is a system generated email. Please do not reply to this mail.';
            email.setHtmlBody(body);
            try{
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
            }
            catch(Exception e){
                System.debug('Error message : ' + e.getMessage() + ' in line : ' + e.getLineNumber());
            }*/
            
            
            // For Notification 
            String recordURL = System.Label.Org_URL+'lightning/r/Contact/' + requestObj[0].PresentRecord.Id + '/view';
            Messaging.CustomNotification notification = new Messaging.CustomNotification();
            notification.setBody('Dear Client Contact Relationship Team and '+presContact[0].Owner.Name+', \n  This is to notify you that there has been an update on Client Contact in the "' + fieldChanges + 
                                 '". Please make a note of the following changes. \n\n  Please click on the following link to view the change on LinKreta \n' + recordURL + ' \n .');
            notification.setTitle('Field Updated on Client Contact');
            notification.setTargetId(requestObj[0].PresentRecord.Id);
            notification.setNotificationTypeId(requestObj[0].NotificationId);
            Set<String> notificationRecipients =new Set<String>();
            for(String st : requestObj[0].RecipientId){
                notificationRecipients.add(st);
            }
            try{
                notification.send(notificationRecipients);
            }
            catch(Exception e){
                System.debug('Error message : ' + e.getMessage() + ' in line : ' + e.getLineNumber());
            }
        }
    }
        
    public class EmailRequest{
        @InvocableVariable
        public String NotificationId;
        @InvocableVariable
        public List<string> RecipientId;
        @InvocableVariable
        public List<string> EmailAddress;
        @InvocableVariable
        public string UserName;
        @InvocableVariable
        public Contact PriorRecord;
        @InvocableVariable
        public Contact PresentRecord;    
    }
        
}