/*
* @Name: DuplicateRemoveTest
* @Author: Bhavishya Basantwani
* @Date: 9-dec-23 
*/
@isTest
public class DuplicateRemoveTest {
    
    @testSetup static void dataCreation() {
        Id KeyAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Key Account').getRecordTypeId();
        
        
        Account KeyAcc = TestDataFactory.createAccountRecord();
        KeyAcc.Name = 'Test';
        KeyAcc.RecordTypeId = KeyAccountRecordTypeId;
        KeyAcc.Client_Category__c = 'GX - Platinum';
        KeyAcc.Client_Sub_Category__c = 'Gx - Gold';
        KeyAcc.Channel_Type__c ='Audit Client';
        KeyAcc.Segment__c = 'Government';
        KeyAcc.Industry__c ='Agriculture';
        insert KeyAcc;
        
        Account KeyAcc1 = TestDataFactory.createAccountRecord();
        KeyAcc1.Name = 'Test1';
        KeyAcc1.RecordTypeId = KeyAccountRecordTypeId;
        KeyAcc1.Client_Category__c = 'GX - Platinum';
        KeyAcc1.Client_Sub_Category__c = 'Gx - Gold';
        KeyAcc1.Channel_Type__c ='Audit Client';
        KeyAcc1.Segment__c = 'Mid Market';
        KeyAcc1.Industry__c ='Agriculture';
        insert KeyAcc1;
        
        Account KeyAcc2 = TestDataFactory.createAccountRecord();
        KeyAcc2.Name = 'Test2';
        KeyAcc2.RecordTypeId = KeyAccountRecordTypeId;
        KeyAcc2.Client_Category__c = 'GX - Platinum';
        KeyAcc2.Client_Sub_Category__c = 'Gx - Gold';
        KeyAcc2.Channel_Type__c ='Audit Client';
        KeyAcc2.Segment__c = 'Digital Natives';
        KeyAcc2.Industry__c ='Agriculture';
        insert KeyAcc2;
        
    }
    
    @isTest static void RemovetEST() {
        List<Account> listOfAccount =  [SELECT Id,Name,segment__c FROM Account];
        
        List<DuplicateRemove.ActionRequest> listOfResp = new List<DuplicateRemove.ActionRequest>();
        DuplicateRemove.ActionRequest ResObj = new DuplicateRemove.ActionRequest();
        ResObj.ListOfRecords = listOfAccount;
        ResObj.NameOfFields = 'Id,Name,Segment__c';
        ResObj.NameOfObject = 'Account';
        ResObj.respectiveField = 'Segment__c';
        
        listOfResp.add(ResObj);
        List<DuplicateRemove.ActionResponce> listOfreturnString = DuplicateRemove.Remove(listOfResp);
        System.assertEquals(3 , listOfreturnString[0].ListObj.size() , 'successfull');
        System.assertEquals(3 , listOfAccount.size() , 'successfull');
    }
}