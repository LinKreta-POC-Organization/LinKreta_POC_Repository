/* Author : Muskan Soni
 *  Created Date: 8/11/2023
 * Class : AccountSyncToWCGTBatch
*/
@istest
public class AccountSyncToWCGTBatchTest {
   @istest
    public static void AccountSyncToWCGTBatchTest(){
         Test.setMock(HttpCalloutMock.class, new SalesforceToWCGTMockCallout());
        Account gtClientGroupAccoount = TestDataFactory.createAccountRecord();
        gtClientGroupAccoount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('GT_Client_Group').getRecordTypeId();
        insert gtClientGroupAccoount ;
        
        Account keyAccoount = TestDataFactory.createAccountRecord();
        keyAccoount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Key_Account').getRecordTypeId();
        //insert keyAccoount ;
        
        List<Account> accList = new List<Account>();
        for(integer i=0;i<40;i++){
            Account acc = TestDataFactory.createAccountRecord();
            acc.Country_Corridor__c = 'Afghanistan';
            acc.Corridor__c ='NA';
            acc.Status_DS_Team_Remark_Status__c = 'Pending';
            acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Client').getRecordTypeId();
            acc.DS_Team_Approval_Status__c ='Pending with DS';
            acc.GT_Client_Group__c = gtClientGroupAccoount.Id;
            acc.Website ='WWW.google.com';
            acc.Industry__c ='Sports';
            acc.SubIndustry__c ='Fitness facilities';
            accList.add(acc);
        }
        insert accList;
        List<Account> accList2 = new List<Account>();
        Set <Id> accIDSet = new Set <Id> ();
        for(Account accObj :accList){
            Account acc = new Account(Id = accObj.Id,DS_Team_Approval_Status__c ='DS Approved');
            accIDSet.add(accObj.Id);
            accList2.add(acc);
        }
        //update accList2;
        
        Database.executeBatch(new AccountSyncToWCGTBatch(accIDSet,'Update'),40);
    }
}