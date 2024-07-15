/*
AUTHOR                   : Deepak joshi
VERSION                  : 1
MODIFICATION DATE        : 3 oct 2023
PROJECT NAME / TICKET #  : GT
DESCRIPTION              : AccountRequestTriggerHelper test class
*/
@isTest
public class AccountRequestTriggerHelperTest {
    @testSetup static void dataCreation() {
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
        acc.Industry__c ='Transportation & Logistics';
       // acc.SubIndustry__c ='Transportation & Logistics';
        insert acc;
        Lead leadRecord = TestDataFactory.createLeadRecord();
        insert leadRecord;

        List<Account_Requests__c> accountRequestsList = new List<Account_Requests__c>();
        
        Account_Requests__c accountRequestsRecordForAccount  = TestDataFactory.createAccountRequests();
        accountRequestsRecordForAccount.client__c= acc.Id;
        accountRequestsRecordForAccount.Status__c =  ConstantUtility.SUBMITTED;
        accountRequestsList.add(accountRequestsRecordForAccount);


        Account_Requests__c accountRequestsRecordForlead  = TestDataFactory.createAccountRequests();
        accountRequestsRecordForlead.Status__c =  ConstantUtility.SUBMITTED;
        accountRequestsRecordForlead.New_Client__c = leadRecord.Id;
        accountRequestsList.add(accountRequestsRecordForlead);
        insert accountRequestsList;

        
        
    }
    @isTest static void testAccount(){
        List<Account_Requests__c> accountReqList = [SELECT Id FROM Account_Requests__c];
        Approval.ProcessSubmitRequest app = new Approval.ProcessSubmitRequest();
        app.setObjectId(accountReqList[0].id);
        app.setProcessDefinitionNameOrId(ConstantUtility.DS_APPROVAL_PROCESS);
        app.setComments('Approv');
        Approval.ProcessResult result = Approval.process(app);
        accountReqList[0].Status__c = ConstantUtility.APPROVED;
        update accountReqList[0];
        System.assertEquals(ConstantUtility.APPROVED ,accountReqList[0].Status__c);


    }
    @isTest static void testLead(){
        List<Account_Requests__c> accountReqList = [SELECT Id FROM Account_Requests__c];
        Approval.ProcessSubmitRequest app = new Approval.ProcessSubmitRequest();
        app.setObjectId(accountReqList[1].id);
        app.setProcessDefinitionNameOrId(ConstantUtility.CNM_APPROVAL_PROCESS);
        app.setComments('Approv');

        Approval.ProcessResult result = Approval.process(app);
        accountReqList[1].Status__c = ConstantUtility.APPROVED;
        update accountReqList[1];
        System.assertEquals(ConstantUtility.APPROVED ,accountReqList[1].Status__c);

    }
    
}