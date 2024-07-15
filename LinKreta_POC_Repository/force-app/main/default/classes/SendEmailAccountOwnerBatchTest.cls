@isTest
Private class SendEmailAccountOwnerBatchTest {
    
    public static testMethod void test(){
        
        User us = TestDataFactory.createUserRecord();
        Insert us;
        
        List<Account> lstAcc = new List<Account>();
        Account acc = TestDataFactory.createAccountRecordDetailed();
        acc.OwnerId = us.Id;
        Insert acc;
        
        lstAcc.add(acc);
        
        Test.startTest();
        SendEmailAccountOwnerBatch obj = new SendEmailAccountOwnerBatch();
        DataBase.executeBatch(obj); 
        Test.stopTest();
    }
    
}