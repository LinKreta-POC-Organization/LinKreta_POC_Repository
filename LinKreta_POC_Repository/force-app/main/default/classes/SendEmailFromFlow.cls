/*
CreatedBy : Rajat
Description : Send email to teams and users. This class is called from multiple flows.
Test Class - SendEmailInvocable_Test
*/
public class SendEmailFromFlow {
    public static OrgWideEmailAddress orgWideEmails{get;set;}
    public SendEmailFromFlow(){
        orgWideEmails = [SELECT Id, Address, DisplayName FROM OrgWideEmailAddress WHERE DisplayName = 'Linkreta' LIMIT 1];
    }
    // private static OrgWideEmailAddress getOrgWideEmail(String orgName){
    //     List<OrgWideEmailAddress> orgWideEmails;
    //     if(String.isNotBlank(orgName)){
    //         orgWideEmails =  [SELECT Id, Address, DisplayName FROM OrgWideEmailAddress WHERE DisplayName = 'Linkreta' LIMIT 1];
    //     }else{
    //         orgWideEmails =[SELECT Id, Address, DisplayName FROM OrgWideEmailAddress WHERE DisplayName = 'Linkreta' LIMIT 1];
    //     }
        
    //     if( orgWideEmails.size() > 0){
    //         return orgWideEmails.get(0);
    //     }
    //     return null;
        
    // }
    
    @TestVisible
    private static Id getContact(){
        Contact con = new Contact(LastName = 'Test',FirstName = 'First Test', Email = 'default@invalid.com',
                                 is_Address_filled__c  = false);
        insert con;
        return con.Id;
    }
    
    @TestVisible
    private static void deleteContact(Id contactid){
        delete new Contact(Id = contactid);
    }
    
    private static EmailTemplate getEmailTemplate(String emailTemplateName){
        system.debug('emailTemplateName::@@@ '+emailTemplateName);
        List<EmailTemplate> emailTemplates = new List<EmailTemplate>([SELECT Id, Name, DeveloperName 
                                                                      FROM EmailTemplate 
                                                                      WHERE DeveloperName =: emailTemplateName ]); 
        system.debug('emailTemplates.get(0):: '+emailTemplates.get(0));
        return emailTemplates.isEmpty() ? null : emailTemplates.get(0);
    }
    @InvocableMethod(label = 'Send Email From Flow')
    public static void sendEmails(List<InputWrapper> inputWrappers){
        
        system.debug('inputWrappers:%%%%: '+inputWrappers);
        // OrgWideEmailAddress orgWideEmailAddress = getOrgWideEmail(null);
        system.debug('inputWrappers.get(0).emailTemplateName:%%%%: '+inputWrappers.get(0).emailTemplateName);
        
        
        EmailTemplate emailTemplate = getEmailTemplate(inputWrappers.get(0).emailTemplateName);
        if(emailTemplate == null){
            return;
        }
        Messaging.SingleEmailMessage emailMessage = Messaging.renderStoredEmailTemplate(emailTemplate.Id,inputWrappers.get(0).recipientIds[0],inputWrappers.get(0).whatId);            
        if(orgWideEmails != null){
            emailMessage.setOrgWideEmailAddressId(orgWideEmails.Id);
        }
        system.debug('inputWrappers.get(0).recipientIds:: '+inputWrappers.get(0).recipientIds);
        emailMessage.setToAddresses(inputWrappers.get(0).recipientIds);
        emailMessage.setSaveAsActivity(false);
        List<Messaging.SingleEmailMessage> emailMessages = new List<Messaging.SingleEmailMessage>{emailMessage};   
            List<Messaging.SendEmailResult> sendEmailResults = Messaging.sendEmail(emailMessages,false);
        system.debug('sendEmailResults ::'+sendEmailResults);      
        system.debug('inputWrappers.get(0).whatId ::'+inputWrappers.get(0).whatId);    
    }
    public class InputWrapper{
        @InvocableVariable
        public List<Id> recipientIds;
        @InvocableVariable
        public String emailTemplateName;
        @InvocableVariable
        public String whatId;
    }
}