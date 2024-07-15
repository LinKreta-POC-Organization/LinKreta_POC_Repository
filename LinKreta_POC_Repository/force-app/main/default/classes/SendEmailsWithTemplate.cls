/* 
Written By: Rakesh Kumar
Created Date: 09 Jan 2024
Last Modified Date : 09 Jan 2024
Description : This class is used to send Email using Email Templates. 
*/
public class SendEmailsWithTemplate {
    @InvocableMethod(Label='SendEmailsWithTemplate')
    public static void sendMail(List<processEmailRequest> emailReq){
        System.debug('emailReq : ' + emailReq);
        try{
            if(emailReq != null && emailReq.size() > 0){
                if(String.isNotBlank(emailReq[0].whatId) && String.isNotBlank(emailReq[0].emailTemplateName) && emailReq[0].emailAddressesList!=null){
                    List<Messaging.SingleEmailMessage> emailMessages = new List<Messaging.SingleEmailMessage>();
                    List<OrgWideEmailAddress> orgWideEmails = [SELECT Id, Address, DisplayName FROM OrgWideEmailAddress WHERE DisplayName = 'Linkreta' LIMIT 1];
                    List<EmailTemplate> temp = [SELECT Id,Body,HtmlValue FROM EmailTemplate WHERE DeveloperName =: emailReq[0].emailTemplateName Limit 1];
                    system.debug('temp:'+temp);
                    Messaging.SingleEmailMessage mail = Messaging.renderStoredEmailTemplate(temp[0].Id,UserInfo.getUserId(),emailReq[0].whatId);
                    if(orgWideEmails != null){
                        mail.setOrgWideEmailAddressId(orgWideEmails[0].Id);
                    }
                        mail.setTargetObjectId(UserInfo.getUserId());
                        mail.setTreatTargetObjectAsRecipient(false);
                        mail.setTemplateId(temp[0].Id); 
                        mail.setWhatId(emailReq[0].whatId);
                        mail.setToAddresses(emailReq[0].emailAddressesList);
                    system.debug('getHtmlBody:'+mail.getHtmlBody());
                    mail.setSaveAsActivity(false);
                    Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{mail});
                    system.debug('mail:'+mail);
                }
            }
        }catch(Exception e){
            system.debug('Email Failed :'+e.getLineNumber()+e.getMessage());
            ErrorLogCreater_cls.apexDebugLogger(e, 'SendEmailsWithTemplate', 'sendMail', null);
        }
    }
        
        public class processEmailRequest{
            @InvocableVariable
            public String whatId;
            @InvocableVariable
            public String emailTemplateName;
            @InvocableVariable
            public List<String> emailAddressesList;
        }
}