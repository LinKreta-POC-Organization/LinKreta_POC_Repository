/*Author : Muskan Soni
 * Created Date : 8/11/2023
 * Class :AccountService
*/
@istest
public class AccountServiceTest {
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
        //acc.SubIndustry__c ='Auto & Auto Components';
        insert acc;
     }
    @istest
    public static void getGTClientGroupTest(){
      List <Account> GTClientList = [select id from Account];
      Set <Id> GTClientIdSet = new Set <Id> ();
        for(Account accObj :GTClientList){
            GTClientIdSet.add(accObj.id);
        }
        Set <Id> emptySet = new Set <Id> ();
        test.startTest();
        AccountService.getGTClientGroup(GTClientIdSet);
        AccountService.getKeyAccount(GTClientIdSet);
        AccountService.getClientAccount(GTClientIdSet);
        test.stopTest();
    }
    
/*    @istest
    public static void handleException(){
      Set <Id> GTClientIdSet = new Set <Id> ();
        for(Integer i=0;i<3;i++){
            GTClientIdSet.add('12'+i);
        }
        System.debug('GTClientIdSet-->'+GTClientIdSet);
        Set <Id> emptySet = new Set <Id> ();
        test.startTest();
        AccountService.getGTClientGroup(emptySet);
        AccountService.getKeyAccount(GTClientIdSet);
        AccountService.getClientAccount(GTClientIdSet);
        test.stopTest();
    }
 */   

}