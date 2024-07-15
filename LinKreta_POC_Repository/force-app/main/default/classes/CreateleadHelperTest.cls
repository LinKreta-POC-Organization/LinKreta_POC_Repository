@isTest
public class CreateleadHelperTest {
    
    @isTest
    public static void testCreateLeadMethod(){
        
        User user = TestDataFactory.createUserRecord();
        insert user;
        List<string> expertiseMasterId = new List<string>();
        ExpertiseMaster__c expertisemasterObj = new ExpertiseMaster__c(
            Name = 'Advisory',
            CurrencyIsoCode = 'INR',
            Mid__c = 'ADV',
            LOV_Id__c = 'SL000009');
        insert expertisemasterObj;
        expertiseMasterId.add(expertisemasterObj.Id);
        System.debug('expertiseMasterId-->'+expertiseMasterId);
        
        Lead leadObj1 = TestDataFactory.createLeadRecord();
        leadObj1.FirstName = 'Test';
        leadObj1.Email = 'Test@gmail.com';
        leadObj1.MobilePhone = '9999999999';
        leadObj1.LastName = 'TMC';
        leadObj1.Industry__c = 'Agriculture';
        leadObj1.Industry_Leader__c = user.Id;
        leadObj1.OwnerId = user.Id;
        leadObj1.Category__c = 'Hot';
        leadObj1.Status = 'Client Take-On PreWork';
        leadObj1.Company = 'TMC';
        leadObj1.CountryCode__c ='India (+91)';
        leadObj1.MobilePhone = '1234567891';
      //  leadObj1.capIQId__c = '1234';
      //  leadObj1.MCA_ID__c = '1234';
        leadObj1.External_Database_Source__c = 'CapIQ';
        
        //Database.SaveResult lsr = Database.insert(leadObj1,false);
        //Insert leadObj1;
        String str = JSON.serialize(leadObj1); 
       
        Account internationalAccount = new Account(Name = leadObj1.Company , IsClientGTMemberFirm__c = true);
        insert internationalAccount; 
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new LeadTriggerHandlerMockOutTest());
        CreateleadHelper.Createlead(str,expertiseMasterId);
        CreateleadHelper.findDuplicateAccount(leadObj1.Company);
        Test.stopTest();
    }
   
    @isTest
    public static void testCreateLeadMethod1(){
        
        User user = TestDataFactory.createUserRecord();
        user.LastName = 'Testclassra Code';
        insert user;
        
        List<string> expertiseMasterId = new List<string>();
        ExpertiseMaster__c expertisemasterObj = new ExpertiseMaster__c(
            Name = 'Advisory',
            CurrencyIsoCode = 'INR',
            Mid__c = 'ADV',
            LOV_Id__c = 'SL000009');
        insert expertisemasterObj;
        expertiseMasterId.add(expertisemasterObj.Id);
        
        Lead leadObj = TestDataFactory.createLeadRecord();
        leadObj.LastName = 'TMC';
        leadObj.Industry__c = 'Agriculture';
        leadObj.Industry_Leader__c = user.Id;
        leadObj.OwnerId = user.Id;
        leadObj.Category__c = 'Hot';
        leadObj.Status = 'Client Take-On PreWork';
        leadObj.Company = 'TMC';
        leadObj.CountryCode__c ='India (+91)';
        leadObj.Email = 'test@gmail.com';
        leadObj.MobilePhone = '1234567891';
        
        Database.SaveResult lsr = Database.insert(leadObj,false);
        String str = JSON.serialize(lsr); 
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new LeadTriggerHandlerMockOutTest());
        CreateleadHelper.Createlead(str,expertiseMasterId);
        CreateleadHelper.findDuplicateAccount(leadObj.Company);
        Test.stopTest();
    }

}