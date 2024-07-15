@isTest
public class LockNewClientRecordTest {
    @testSetup 
    static void dataCreation() { 
        Lead leadRecord =  TestDataFactory.createLeadRecord();
        leadRecord.Industry_Leader__c =UserInfo.getUserId();
        leadRecord.Industry__c ='Banking';
        leadRecord.Status = 'NotAccept';
        leadRecord.Reject_Reason__c = 'No response';
        insert leadRecord;

    }
    @isTest static void ClientNewSearch(){
       lead leadObj = [SELECT Id FROM Lead LIMIT 1];
        LockNewClientRecord.lockNewClientRecord(new List<Id>{leadObj.Id});
        
    }
    
}