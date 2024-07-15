@isTest
public class GenericNotificationTest {
    @isTest
    Static void testNotification(){
        Id clientRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Client').getRecordTypeId();
        Account acc1 = TestDataFactory.createAccountRecord();
        acc1.Name = 'Deepak Sir';
        acc1.RecordTypeId = clientRecordTypeId;
        acc1.Status__c = 'Active';
        // acc1.GT_Client_Group__c = GtAcc.Id;
        acc1.ClientAddress__City__s = 'Jaipur';
        acc1.ClientAddress__CountryCode__s = 'IN';
        acc1.ClientAddress__PostalCode__s = '789'; 
        acc1.ClientAddress__StateCode__s = 'AS';
        acc1.ClientAddress__Street__s = 'test,test';
        //acc1.Key_Account__c = True;
        insert acc1;
        Set<String> recepientsId = new Set<String>();
        recepientsId.add(Userinfo.getUserId());
        
        Test.StartTest();
        EmailTemplate emailTem  = [Select Id,name,subject,body from EmailTemplate Limit 1];
        GenericNotification.SendEmail(acc1.Id , recepientsId , emailTem);
        GenericNotification.sendNotification(acc1.Id , recepientsId , emailTem);
        GenericNotification.sendNotification(acc1.Id, recepientsId, 'Test', 'title');
        Test.StopTest();
    }
    
}