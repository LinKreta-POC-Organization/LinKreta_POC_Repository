/*Created Date :-8/11/2023
 * Class :- AccountUpdateAndSyncNameTest
*/
@istest
public class AccountUpdateAndSyncNameTest {
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
        acc.Industry__c ='Tech';
        acc.SubIndustry__c ='Internet software & services';
     	acc.Status__c    = 'Active';
        insert acc;
        
    }
    @istest
     public static void invocableTest(){
       List <Account> accList =[select id from Account];
       List <Id> accIDList = new List <Id> ();
        for(Account accObj :accList){
            accIDList.add(accObj.id);
        }
         test.startTest();
         AccountUpdateAndSyncName.invocable(accIDList);
         test.stopTest();
       
    }
}