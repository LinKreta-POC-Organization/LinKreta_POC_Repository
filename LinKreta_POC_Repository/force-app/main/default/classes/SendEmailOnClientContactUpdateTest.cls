@isTest
public class SendEmailOnClientContactUpdateTest {
    
    @isTest
    public static void SendEmailOnClientContactUpdate() {
        
        Contact priorContact = TestDataFactory.createContact();
        priorContact.OwnerId = userInfo.getUserId();
        priorContact.Linkedin_URL__c ='WWW.google.com';
        priorContact.Client_Location__Street__s = 'test,test';
        priorContact.Client_Location__City__s ='test';
        priorContact.Client_Location__PostalCode__s ='12345';
        priorContact.Client_Location__StateCode__s ='CT' ;
        priorContact.Client_Location__CountryCode__s =  'IN';
        
        Contact presentContact = TestDataFactory.createContact2();
        presentContact.OwnerId = userInfo.getUserId();
        presentContact.Linkedin_URL__c ='WWW.google.com';
        presentContact.Client_Location__Street__s = 'test,test';
        presentContact.Client_Location__City__s ='test';
        presentContact.Client_Location__PostalCode__s ='12345';
        presentContact.Client_Location__StateCode__s ='CT' ;
        presentContact.Client_Location__CountryCode__s =  'IN';
        insert presentContact;
        
        SendEmailOnClientContactUpdate.EmailRequest emailRequest = new SendEmailOnClientContactUpdate.EmailRequest();
        emailRequest.NotificationId = 'TestNotificationId';
        emailRequest.RecipientId = new List<String>{ 'TestRecipientId' };
        emailRequest.EmailAddress = new List<String>{ 'test@example.com' };
        emailRequest.UserName = 'TestUser';
        emailRequest.PriorRecord = priorContact;
        emailRequest.PresentRecord = presentContact;

        List<SendEmailOnClientContactUpdate.EmailRequest> emailRequests = new List<SendEmailOnClientContactUpdate.EmailRequest>{ emailRequest };

        Test.startTest();
        SendEmailOnClientContactUpdate.getUpdatedFields(emailRequests);
        Test.stopTest();
        
    }
}