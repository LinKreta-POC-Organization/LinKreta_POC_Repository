@isTest
public class Batch_SendContactDuplicateReportTest {
    @isTest
    public static void testSendEmailToClientAndContactTeam() {
        // Create test data
        Account testAccount = new Account(Name = 'Test Account');
        testAccount.is_Address_filled__c = false;
        insert testAccount;
        
        User testUser = TestDataFactory.createUserRecord();
        insert testUser;
        
        Contact testContact = TestDataFactory.createContact();
        testContact.is_Address_filled__c = false;
        testContact.AccountId = testAccount.Id;
        testContact.Last_Activity_Date_Time__c = System.today() - 31;
        insert testContact;
        
        Client_Contact_Relationship_Team__c testRelationshipTeam = TestDataFactory.createContactTeam(UserInfo.getUserId());
        testRelationshipTeam.Client_Contact__c = testContact.Id;
        testRelationshipTeam.User__c = testUser.Id;
        insert testRelationshipTeam;
        System.debug('testRelationshipTeam -->' + testRelationshipTeam);
        
        Test.startTest();
        
        //Batch_SendContactDuplicateReportHandler.sendEmailToClientAndContactTeam(new List<Contact>{testContact}, new List<String> emailRecipients);
        
        // Start the batch execution
        
        System.debug('contacts in test --> ' + [SELECT Id, AccountId, Last_Activity_Date_Time__c FROM Contact WHERE AccountId != null AND Last_Activity_Date_Time__c = LAST_N_DAYS : 30]);
        Batch_SendContactDuplicateReport objBatchClass = new Batch_SendContactDuplicateReport();
        Database.executeBatch(objBatchClass);
        
        String cronExp = '0 0 9 * * ?'; 
        ScheduleContactDuplicateReportBatch objScheduleClass = new ScheduleContactDuplicateReportBatch();
        String jobId = System.schedule('Test Schedule', cronExp, objScheduleClass);
        
        Test.stopTest();
        
        
    }
    
    @isTest
    static void testQuery() {
        Test.startTest();
        
        String query = Batch_SendContactDuplicateReportHandler.getQuery();
        
        Test.stopTest();
        
        
    }
}