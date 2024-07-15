@isTest
private class ScheduleContactSyncBatchTest {
    @isTest
    static void testScheduleContactSyncBatch() {
        // Ensure the schedulable class is allowed to run
        Test.startTest();

        // Schedule the Contact Sync Batch job
        String cronExp = '0 0 18 * * ? *'; // Set your desired schedule
        System.schedule('ScheduleContactSyncBatch', cronExp, new ScheduleContactSyncBatch());
       // Database.executeBatch(ScheduleContactSyncBatch, 200);
        Test.stopTest();

        // To test the batch job, you can either wait for it to run automatically based on the schedule
        // or manually execute it. For manual execution, you can use the following code:

        // Batch_SyncClientContactTeam batchInstance = new Batch_SyncClientContactTeam();
        // Database.executeBatch(batchInstance, 200);

        // Wait for the batch job to complete (you may need to adjust the time depending on your batch size)
        // Test.startTest();
        // Test.stopTest();

    }
}