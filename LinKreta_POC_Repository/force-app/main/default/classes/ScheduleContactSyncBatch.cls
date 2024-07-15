global class ScheduleContactSyncBatch implements Schedulable {
    global void execute(SchedulableContext sc){
        Database.executeBatch(new Batch_SyncClientContactTeam());
    }
}