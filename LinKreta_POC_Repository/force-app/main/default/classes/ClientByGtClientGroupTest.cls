/*
* @Name: ClientByGtClientGroupTest
* @Author: Bhavishya Basantwani
* @Date: 9-dec-23 
*/

@isTest
public class ClientByGtClientGroupTest {
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
        GtAcc1.Name = 'Name22';
        GtAcc1.RecordTypeId = gtCLientRecordTypeId;
        GtAcc.Key_Account_360__c = KeyAcc.Id;
        insert GtAcc1;
        
        Id UserId = UserInfo.getUserId() ;
        
        Account acc = TestDataFactory.createAccountRecord();
        
        acc.RecordTypeId = clientRecordTypeId;
        //acc.CSL__c = UserId;
        //acc.CoCSL__c = UserId;
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
        //acc1.GSTIN__c = '0090067788';
        acc1.Client_reason_if_inactive__c = 'test';
        //acc1.GSTIN__c = '12345';
        acc1.ClientStatus__c = 'Active';
        acc1.GT_Client_Group__c = GtAcc1.Id;
        acc1.ClientAddress__City__s = 'Jaipur';
        acc1.ClientAddress__CountryCode__s = 'IN';
        acc1.ClientAddress__PostalCode__s = '789'; 
        acc1.ClientAddress__StateCode__s = 'AS';
        acc1.ClientAddress__Street__s = 'test,test';
        //acc1.AccountType__c = 'Key Account';
        
        insert acc1;
        
        /*  AccountTeamMember CTMFirst = TestDataFactory.createAccountTeamMember(acc.Id);
AccountTeamMember CTMSeond = TestDataFactory.createAccountTeamMember(acc.Id);
CTMseond.TeamMemberRole = 'Solution Expert';


insert CTMFirst;
insert CTMSeond;*/
    }
    
    @isTest static void getRecordTest() {
        Id clientRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Client').getRecordTypeId();
        system.debug('clientRecordTypeId'+clientRecordTypeId);
        Id gtCLientRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('GT Client Group').getRecordTypeId();        
        Id KeyAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Key Account').getRecordTypeId();
        
        List<Account> listOfAccountKey =  [SELECT Id,Name FROM Account Where RecordTypeId =:  KeyAccountRecordTypeId];
        List<Account> listOfAccountGtClient =  [SELECT Id,Name FROM Account Where RecordTypeId =: gtCLientRecordTypeId ];
        
       Map<String,List<Account>> MapOfClients =  ClientByGtClientGroup.getRecord(listOfAccountKey[0].Id);
       List<Account> listOfReturnAccount =  ClientByGtClientGroup.getRecordFilter(listOfAccountKey[0].Id,listOfAccountGtClient[0].Name);
        
        System.assertEquals(1 , MapOfClients.Size() , 'successfull');
        System.assertEquals(1 , listOfAccountKey.Size() , 'successfull');
    }
    
    
}