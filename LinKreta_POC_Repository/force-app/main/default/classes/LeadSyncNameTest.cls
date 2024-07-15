@isTest
public class LeadSyncNameTest {
	@isTest
    public static void invocableTest(){
        Profile pro = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User u = new user();
        u.LastName = 'Testclassra Code';
        u.Email = 'test@test.com';
        u.Alias = 'Tcode';
        u.Username = 'testclasshhhy@test.com';
        u.CommunityNickname = 'test12';
        u.LocaleSidKey = 'en_US';
        u.TimeZoneSidKey = 'GMT';
        u.ProfileId = pro.Id;
        u.LanguageLocaleKey = 'en_US';
        u.EmailEncodingKey = 'UTF-8';
        insert u;
        
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
       // obj1.IL_ApprovalRejectionRecommendation__c = 'fgnc'; //Phase-1
        obj1.Company = 'Cloud Analogy';
        obj1.Industry_Leader__c = u.Id;
        obj1.Industry__c = 'Banking';
        obj1.Email = 'test@gmail.com';
        obj1.IsLead__c = True;
        obj1.MobilePhone = '1234567891';
        obj1.Formerly_Known_As__c = 'Rajat';
        insert obj1;
        
        LeadSyncName.invocable(new List<Id>{obj1.Id});
        
    }
}