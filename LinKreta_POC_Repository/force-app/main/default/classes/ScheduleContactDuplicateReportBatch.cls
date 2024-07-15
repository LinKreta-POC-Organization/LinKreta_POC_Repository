global class ScheduleContactDuplicateReportBatch implements Schedulable {
    global void execute(SchedulableContext sc){
        Database.executeBatch(new Batch_SendContactDuplicateReport());
    }
}