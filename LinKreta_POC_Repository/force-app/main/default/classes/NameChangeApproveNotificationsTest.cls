/*
AUTHOR                   : Deepak joshi
VERSION                  : 1
MODIFICATION DATE        : 3 oct 2023
PROJECT NAME / TICKET #  : GT
DESCRIPTION              : NameChangeApproveNotifications test class
*/
@isTest
public  class NameChangeApproveNotificationsTest {
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
        //acc.Industry__c ='Auto & Auto Components';
        //acc.SubIndustry__c ='Auto & Auto Components';
        insert acc;
        Lead leadRecord = TestDataFactory.createLeadRecord();
        insert leadRecord;

        List<Account_Requests__c> accountRequestsList = new List<Account_Requests__c>();
        Account_Requests__c accountRequestsRecordForApproval  = TestDataFactory.createAccountRequests();
        accountRequestsRecordForApproval.client__c= acc.Id;
        accountRequestsRecordForApproval.Status__c =  ConstantUtility.APPROVED;
        accountRequestsRecordForApproval.New_Client__c = leadRecord.Id;
        accountRequestsList.add(accountRequestsRecordForApproval);
        Account_Requests__c accountRequestsRecordForSubmit   = TestDataFactory.createAccountRequests();
        accountRequestsRecordForSubmit.client__c= acc.Id;
        accountRequestsRecordForSubmit.Status__c =  ConstantUtility.SUBMITTED;
        accountRequestsRecordForSubmit.New_Client__c = leadRecord.Id;
        accountRequestsList.add(accountRequestsRecordForSubmit);
      
        insert accountRequestsList;

    }
    @isTest static void testAccountinvocableApproval() {
        List<Account_Requests__c> accountRequestObj =  [SELECT Id,Client__c, New_Client__c,Status__c FROM Account_Requests__c];
        NameChangeApproveNotifications.invocable(new List<Id>{accountRequestObj[0].Id} );
        System.assertEquals(ConstantUtility.APPROVED ,accountRequestObj[0].Status__c);

    }
    @isTest static void testAccountinvocableSubmit() {
        List<Account_Requests__c> accountRequestObj =  [SELECT Id,Client__c, New_Client__c,Status__c FROM Account_Requests__c];
        NameChangeApproveNotifications.invocable(new List<Id>{accountRequestObj[1].Id} );
        Set<String> grpNameSet = new Set<String>{'C_M_Team'};
        NameChangeApproveNotifications.getGroup(grpNameSet);
        System.assertEquals(ConstantUtility.SUBMITTED,accountRequestObj[1].Status__c);

    }
    
}