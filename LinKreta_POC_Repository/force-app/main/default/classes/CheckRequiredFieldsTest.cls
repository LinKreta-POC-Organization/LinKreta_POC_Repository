/*
* @Name: CheckRequiredFieldTest
* @Author: Bhavishya Basantwani
* @Date: 9-dec-23 
*/

@isTest
public class CheckRequiredFieldsTest {
    @testSetup static void dataCreation() {
        Id KeyAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Key Account').getRecordTypeId();
        Id clientRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Client').getRecordTypeId();
        Id gtCLientRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('GT Client Group').getRecordTypeId();
        Account acc = TestDataFactory.createAccountRecord();
        acc.Name = 'Bhavi Basant';
        acc.Status__c = 'Pending Verification';
        acc.RecordTypeId = clientRecordTypeId;
        acc.ClientAddress__City__s = 'Jaipur';
        acc.ClientAddress__CountryCode__s = 'IN';
        acc.ClientAddress__PostalCode__s = '789'; 
        acc.ClientAddress__StateCode__s = 'AS';
        acc.ClientAddress__Street__s = 'test,test';
        insert acc; 
        
        
        AccountTeamMember CTMFirst = TestDataFactory.createAccountTeamMember(acc.Id);
        // CTMFirst.TeamMemberRole = 'Key Account – CSL';
        CTMFirst.AccountId = acc.Id;
        CTMFirst.ContactAccessLevel = 'Read';
        CTMFirst.CaseAccessLevel = 'Edit'; 
        CTMFirst.OpportunityAccessLevel = 'Edit';
        CTMFirst.AccountAccessLevel = 'Read';
        AccountTeamMember CTMSeond = TestDataFactory.createAccountTeamMember(acc.Id);
        CTMseond.TeamMemberRole = 'Solution Expert';
        CTMseond.ContactAccessLevel = 'Read';
        CTMseond.CaseAccessLevel = 'Edit';
        CTMseond.OpportunityAccessLevel = 'Edit';
        CTMseond.AccountAccessLevel = 'Read';
        
        insert CTMFirst;
        insert CTMSeond;
        
        
        
        Account KeyAcc = TestDataFactory.createAccountRecord();
        KeyAcc.Name = 'Test';
        KeyAcc.RecordTypeId = KeyAccountRecordTypeId;
        KeyAcc.Client_Category__c = 'GX - Platinum';
        KeyAcc.Client_Sub_Category__c = 'Gx - Gold';
        KeyAcc.Channel_Type__c ='Audit Client';
        KeyAcc.Segment__c = 'Government';
        KeyAcc.Industry__c ='Agriculture';
        insert KeyAcc;
        
        AccountTeamMember CTMFifth = TestDataFactory.createAccountTeamMember(KeyAcc.Id);
        CTMFifth.AccountId = KeyAcc.Id;
        CTMFifth.TeamMemberRole = 'Key Account – CSL';
        CTMFifth.ContactAccessLevel = 'Read';
        CTMFifth.CaseAccessLevel = 'Edit';
        CTMFifth.OpportunityAccessLevel ='Edit';
        CTMFifth.AccountAccessLevel = 'Read';
        insert CTMFifth;
        
        Account GtAcc = TestDataFactory.createAccountRecord();
        GtAcc.RecordTypeId = gtCLientRecordTypeId;
        GtAcc.Key_Account_360__c = KeyAcc.Id;
        insert GtAcc;
        
        Account acc1 = TestDataFactory.createAccountRecord();
        acc1.RecordTypeId = clientRecordTypeId;
        acc1.Status__c = 'Pending Verification';
        acc1.GT_Client_Group__c = GtAcc.Id;
        acc1.ClientAddress__City__s = 'Jaipur';
        acc1.ClientAddress__CountryCode__s = 'IN';
        acc1.ClientAddress__PostalCode__s = '789'; 
        acc1.ClientAddress__StateCode__s = 'AS';
        acc1.ClientAddress__Street__s = 'test,test';
        acc1.Key_Account__c = True;
        insert acc1;
        
        
        
        
        
        
        
        
        
    }
    @isTest static void requiredFieldTest() {
        
        Test.StartTest(); 
        Id KeyAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Key Account').getRecordTypeId();
        Id clientRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Client').getRecordTypeId();
        Id gtCLientRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('GT Client Group').getRecordTypeId();
        
        Account KeyAcc1 = TestDataFactory.createAccountRecord();
        KeyAcc1.Name = 'Test1';
        KeyAcc1.RecordTypeId = KeyAccountRecordTypeId;
        KeyAcc1.Client_Category__c = 'GX - Platinum';
        KeyAcc1.Client_Sub_Category__c = 'GX - Gold';
        KeyAcc1.Channel_Type__c ='Audit Client';
        KeyAcc1.Segment__c = 'Government';
        KeyAcc1.Industry__c ='Agriculture';
        insert KeyAcc1;
        
        AccountTeamMember CTMSix = TestDataFactory.createAccountTeamMember(KeyAcc1.Id);
        CTMSix.AccountId = KeyAcc1.Id;
        CTMSix.TeamMemberRole = 'Key Account – CSL';
        CTMSix.ContactAccessLevel = 'Read';
        CTMSix.CaseAccessLevel = 'Edit';
        CTMSix.OpportunityAccessLevel = 'Edit';
        CTMSix.AccountAccessLevel = 'Read';
        AccountTeamMember CTMSeven = TestDataFactory.createAccountTeamMember(KeyAcc1.Id);
        CTMSeven.AccountId = KeyAcc1.Id;
        CTMSeven.TeamMemberRole = 'Key Account – Co-CSL';
        CTMSeven.ContactAccessLevel = 'Read';
        CTMSeven.CaseAccessLevel = 'Edit';
        CTMSeven.OpportunityAccessLevel = 'Edit';
        CTMSeven.AccountAccessLevel = 'Read';
        
        insert CTMSix;
        insert CTMSeven;
        
        /* Account GtAcc1 = TestDataFactory.createAccountRecord();
GtAcc1.RecordTypeId = gtCLientRecordTypeId;
GtAcc1.Key_Account_360__c = KeyAcc1.Id;
insert GtAcc1;

Account acc2 = TestDataFactory.createAccountRecord();
acc2.RecordTypeId = clientRecordTypeId;
acc2.Status__c = 'Pending Verification';
acc2.GT_Client_Group__c = GtAcc1.Id;
acc2.Key_Account__c = True;
acc2.ClientAddress__City__s = 'Jaipur';
acc2.ClientAddress__CountryCode__s = 'IN';
acc2.ClientAddress__PostalCode__s = '789'; 
acc2.ClientAddress__StateCode__s = 'AS';
acc2.ClientAddress__Street__s = 'test,test';
insert acc2; */
        
        
        
        List<Account> listOfAccount =  [SELECT Id,Name FROM Account where recordTypeId =: clientRecordTypeId] ;
        
        LIst<Id> listOfIds = new List<Id>();        
        for(Account acc : listOfAccount){
            listOfIds.add(acc.Id);   
        }
        
        CheckRequiredFields.requiredField(listOfIds);
        System.assertEquals(2 , listOfIds.size() , 'successfull');
        Test.StopTest();
    }
    
    
    
}