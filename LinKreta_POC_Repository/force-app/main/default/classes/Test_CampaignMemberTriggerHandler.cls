@isTest
public class Test_CampaignMemberTriggerHandler {
	@isTest
    public static void test_isBeforeDelete(){
        User u = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
            LastName = 'last',
            Email = 'puser000@amamama.com',
            Username = 'puser000@amamama.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US'
        );
        INSERT u;
        Campaign cmp = new Campaign();
        cmp.Name = 'Test Campaign';
        cmp.Activation_Status__c = 'Approved';
        cmp.IsActive = true;
        cmp.Status = 'Design';
        cmp.Campaign_Feedback__c = 'Not';
        
        System.runAs(u) {
            insert cmp;
        }
        
        Account testAccount = TestDataFactory.createAccountRecord();
        insert testAccount;
        
        Contact contactRecord = TestDataFactory.createContact();
        contactRecord.FirstName = 'test contact';
        contactRecord.LastName = 'test contact';
        contactRecord.AccountId = testAccount.Id;
        contactRecord.Linkedin_URL__c = 'www.google.com';
        contactRecord.MobilePhone = '9876543210';
        contactRecord.Email = 'test@gmail.com';
        contactRecord.Designation__c = 'CEO';
        contactRecord.Salutation = 'Mr.';
        contactRecord.pi__campaign__c = 'Pratham campaign';
        contactRecord.Client_Location__City__s = 'TEST';
        contactRecord.Client_Location__CountryCode__s = 'US';
        contactRecord.Client_Location__PostalCode__s = '121002';
        contactRecord.Client_Location__StateCode__s = 'AL';
        contactRecord.Client_Location__Street__s = 'Test, street';
        contactRecord.Pick_Record__c = false;
        contactRecord.BOD_Flag__c = 'NO';
        contactRecord.is_Address_filled__c = false;
        contactRecord.Client_Contact_Record_Type__c = 'Client';
        insert contactRecord;

        Profile pro = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User u1 = new user();
        u1.LastName = 'Testclassra Code';
        u1.Email = 'test@test.com';
        u1.Alias = 'Tcode';
        u1.Username = 'testclasshhhy@test.com';
        u1.CommunityNickname = 'test12';
        u1.LocaleSidKey = 'en_US';
        u1.TimeZoneSidKey = 'GMT';
        u1.ProfileId = pro.Id;
        u1.LanguageLocaleKey = 'en_US';
        u1.EmailEncodingKey = 'UTF-8';
        insert u1;
        
        Lead obj1 = new Lead();
        obj1.LastName = 'Test Test';
        obj1.FirstName = 'vijay';
        //obj1.IndustryLeaderApprovalStatus__c = 'Approved'; // Phase-1
        obj1.Status = 'Accept Client';
        //obj1.CCApprovalStatus__c = 'Approved'; //Phase-1
        obj1.CountryCode__c = 'India (+91)';
        obj1.OnNewStage__c = 2323;
        obj1.Expertise_LT__c = 'Human Capital Consulting';
        obj1.SMEG_LT__c = 'Cyber';
        obj1.Region__c = 'North';
        //obj1.IL_ApprovalRejectionRecommendation__c = 'fgnc'; //Phase-1
        obj1.Company = 'Cloud Analogy';
        obj1.Industry_Leader__c = u1.Id;
        obj1.Industry__c = 'Banking';
        obj1.Email = 'test@gmail.com';
        obj1.IsLead__c = True;
        obj1.MobilePhone = '1234567891';
        obj1.Formerly_Known_As__c = 'Rajat';
        insert obj1;
        
        List<CampaignMember> cmList = new List<CampaignMember>();
        CampaignMember cm = new CampaignMember();
        cm.CampaignId = cmp.Id;
        cm.ContactId = contactRecord.Id;
        cmList.add(cm);

        CampaignMember cm1 = new CampaignMember();
        cm1.CampaignId = cmp.Id;
        cm1.LeadId = obj1.Id;
        cmList.add(cm1);
        try{
            insert cmList;
        }catch(Exception e){
            system.debug('ex:'+e);
        }
       
        
        delete cm;
    }
}