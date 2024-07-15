/*
* Author : Gaurav Kumar
* Date : 22/12/2022
* Description : Scheduled class for ActivityOnContactBatch
*/

global class ScheduledActivityOnContactBatch implements Schedulable {
    global void execute(SchedulableContext sc){
        Database.executeBatch(new ActivityOnContactBatch());
    }
}