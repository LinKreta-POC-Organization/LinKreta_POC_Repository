/*
* @Name: ReusableLookupControllerTest
* @Author: Bhavishya Basantwani
* @Date: 9-dec-23 
*/
@isTest
public class ReusableLookupControllerTest {
    
    @testSetup static void dataCreation() {
        Id clientRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Client').getRecordTypeId();
        system.debug('clientRecordTypeId'+clientRecordTypeId);
        Id gtCLientRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('GT Client Group').getRecordTypeId();        
        Id KeyAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Key Account').getRecordTypeId();
        
        Account KeyAcc = TestDataFactory.createAccountRecord();
        KeyAcc.RecordTypeId = KeyAccountRecordTypeId;
        // KeyAcc.Client_Category__c = 'Key Account - GX';
        // KeyAcc.Client_Sub_Category__c = 'Gx - Gold';
        KeyAcc.Channel_Type__c ='Audit Client';
        KeyAcc.Segment__c = 'Government';
        KeyAcc.Industry__c ='Agriculture';
        insert KeyAcc;
        
        AccountTeamMember CTMFifth = TestDataFactory.createAccountTeamMember(KeyAcc.Id);
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
        
        Account GtAcc1 = TestDataFactory.createAccountRecord();
        GtAcc1.Name = 'Name55';
        GtAcc1.RecordTypeId = gtCLientRecordTypeId;
        GtAcc.Key_Account_360__c = KeyAcc.Id;
        insert GtAcc1;
        
        Id UserId = UserInfo.getUserId() ;
        
        Account acc = TestDataFactory.createAccountRecord();
        
        acc.RecordTypeId = clientRecordTypeId;
        //acc.GSTIN__c = '00900';
        acc.Client_reason_if_inactive__c = 'testtttttt';
        acc.ClientStatus__c = 'Inactive';
        acc.GT_Client_Group__c = GtAcc.Id;
        acc.ClientAddress__City__s = 'Jaipur';
        acc.ClientAddress__CountryCode__s = 'IN';
        acc.ClientAddress__PostalCode__s = '789'; 
        acc.ClientAddress__StateCode__s = 'AS';
        acc.ClientAddress__Street__s = 'test,test';
        
        //acc.AccountType__c = 'Key Account';
        
        insert acc;
        
        Account acc1 = TestDataFactory.createAccountRecord();
        acc1.Name = 'Name44';
        acc1.RecordTypeId = clientRecordTypeId;
        acc1.CSL__c = UserId;
        acc1.CoCSL__c = UserId;
       // acc1.GSTIN__c = '0090067788';
        acc1.Client_reason_if_inactive__c = 'test';
       // acc1.GSTIN__c = '12345';
        acc1.ClientStatus__c = 'Active';
        acc1.GT_Client_Group__c = GtAcc1.Id;
        acc1.ClientAddress__City__s = 'Jaipur';
        acc1.ClientAddress__CountryCode__s = 'IN';
        acc1.ClientAddress__PostalCode__s = '789'; 
        acc1.ClientAddress__StateCode__s = 'AS';
        acc1.ClientAddress__Street__s = 'test,test';
        //acc1.AccountType__c = 'Key Account';
        
        insert acc1;
        
        Contact con1 = TestDataFactory.createContactRecord();
        con1.FirstName = 'BHavi';
        con1.LastName = 'Basant';
        con1.AccountId = acc1.Id;
        con1.Client_Location__Street__s = 'test,test';
        con1.Client_Location__City__s  ='test';
        con1.Client_Location__PostalCode__s = '12345';
        con1.Client_Location__StateCode__s = 'CT';
        con1.Client_Location__CountryCode__s = 'IN';
        insert con1;
        
        Contact con = TestDataFactory.createContactRecord();
        con.FirstName = 'BHavi1';
        con.LastName = 'Basant2';
        con.AccountId = acc.Id;
        con.Client_Location__Street__s = 'test,test';
        con.Client_Location__City__s  ='test';
        con.Client_Location__PostalCode__s = '12345';
        con.Client_Location__StateCode__s = 'CT';
        con.Client_Location__CountryCode__s = 'IN';
        insert con;
    }
    
    @isTest static void fetchRecordsTest() {
        Id clientRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Client').getRecordTypeId();
        system.debug('clientRecordTypeId'+clientRecordTypeId);
        Id gtCLientRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('GT Client Group').getRecordTypeId();        
        Id KeyAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Key Account').getRecordTypeId();
        // List<ReusableLookupController.SearchWrapper> listOfResp = new List<ReusableLookupController.SearchWrapper>();
        ReusableLookupController.SearchWrapper ResObj = new ReusableLookupController.SearchWrapper();
        List<Account> listOfAccountKey =  [SELECT Id,Name FROM Account Where RecordTypeId =:  KeyAccountRecordTypeId];
        List<Account> listOfAccountClient =  [SELECT Id,Name FROM Account Where RecordTypeId =:  clientRecordTypeId];
        
        
        ResObj.objectApiName = 'Account';
        ResObj.fieldApiName = 'Name';
        ResObj.otherFieldApiName = 'Status__c';
        ResObj.searchString = 'Client';
        ResObj.parentRecordId = listOfAccountKey[0].Id;
        ResObj.selectedRecordId = listOfAccountKey[0].Id;
        ResObj.filter = 'CLient';
        
        ReusableLookupController.fetchRecords(ResObj,listOfAccountClient[0].Id ,listOfAccountKey[0].Id);
        ReusableLookupController.RecentRecords(ResObj, listOfAccountClient[0].Id ,listOfAccountKey[0].Id);
    }
    
    @isTest static void fetchRecordsTest1() {
        Id clientRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Client').getRecordTypeId();
        system.debug('clientRecordTypeId'+clientRecordTypeId);
        Id gtCLientRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('GT Client Group').getRecordTypeId();        
        Id KeyAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Key Account').getRecordTypeId();
        // List<ReusableLookupController.SearchWrapper> listOfResp = new List<ReusableLookupController.SearchWrapper>();
        ReusableLookupController.SearchWrapper ResObj = new ReusableLookupController.SearchWrapper();
        List<Account> listOfAccountKey =  [SELECT Id,Name FROM Account Where RecordTypeId =:  KeyAccountRecordTypeId];
        List<Account> listOfAccountClient =  [SELECT Id,Name FROM Account Where RecordTypeId =:  clientRecordTypeId];
        
        
        ResObj.objectApiName = 'Contact';
        ResObj.fieldApiName = 'Name';
        ResObj.searchString = listOfAccountClient[0].Name;
        
        
        ReusableLookupController.fetchRecords(ResObj,listOfAccountClient[0].Id ,listOfAccountKey[0].Id);
        ReusableLookupController.RecentRecords(ResObj, listOfAccountClient[0].Id ,listOfAccountKey[0].Id);
        System.assertEquals(1 , listOfAccountKey.Size() , 'successfull');
    }
}