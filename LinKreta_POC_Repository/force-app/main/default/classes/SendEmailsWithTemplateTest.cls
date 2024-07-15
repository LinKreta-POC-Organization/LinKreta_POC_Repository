@isTest
public class SendEmailsWithTemplateTest {
    @isTest static void testPicklist(){
        List<SendEmailsWithTemplate.processEmailRequest> emailRequests = new List<SendEmailsWithTemplate.processEmailRequest>();
        Account gtClientGroupAccoount = TestDataFactory.createAccountRecord();
        gtClientGroupAccoount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('GT_Client_Group').getRecordTypeId();
        insert gtClientGroupAccoount ; 
        Account acc = TestDataFactory.createAccountRecord();
        
        acc.Country_Corridor__c = 'Afghanistan';
        acc.Corridor__c ='NA';
        acc.Status_DS_Team_Remark_Status__c = 'Pending';
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Client').getRecordTypeId();
        acc.DS_Team_Approval_Status__c ='Pending with DS';
        acc.GT_Client_Group__c = gtClientGroupAccoount.Id;
        acc.Website ='WWW.google.com';
        acc.Segment__c = 'Government';
        //acc.Industry__c ='Auto & Auto Components';
        //acc.SubIndustry__c ='Auto & Auto Components';
        insert acc;
        
        Profile existingProfile = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
        User userRecord = new User();
        userRecord.EMP_ID__c = 'EM0012344';
        userRecord.Designation__c = 'Manager';
        userRecord.Expertise__c = 'Risk';
        userRecord.FirstName = 'Test';
        userRecord.Username = 'demo.test@GrandT.com';
        userRecord.LastName ='user 1';
        userRecord.Email = 'Test@gmail.com';
        userRecord.Alias ='tu1';
        userRecord.Also_a_Job_Manager__c =True;
        userRecord.TimeZoneSidKey ='Asia/Kolkata';
        userRecord.LocaleSidKey ='en_IN';
        userRecord.EmailEncodingKey ='UTF-8';
        userRecord.ProfileId =existingProfile.Id;
        userRecord.LanguageLocaleKey ='en_US';
        insert userRecord;  
        SendEmailsWithTemplate.processEmailRequest emailRec = new SendEmailsWithTemplate.processEmailRequest();
        emailRec.whatId = acc.ID;
        emailRec.emailTemplateName = 'Email_Template_for_No_Activity_on_Client_Contact';
        emailRec.emailAddressesList = new List<String>{userRecord.Email};
            emailRequests.add(emailRec);
        SendEmailsWithTemplate.sendMail(emailRequests);
            
    }
}