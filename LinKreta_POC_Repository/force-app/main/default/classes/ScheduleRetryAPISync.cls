global class ScheduleRetryAPISync implements Schedulable{
	global void execute(SchedulableContext sc){
        String cron = '0 0 0/2 1/1 * ? *';
        Database.executeBatch(new RetrySyncAPIBatch(),50);
    }
}