/*AUTHOR                   : Deepak Joshi
VERSION                  : 1
MODIFICATION DATE        : 10 August 2023
PROJECT NAME / TICKET #  : GT
DESCRIPTION              : Account RequestTrigger

AUTHOR                   :
VERSION                  :1
MODIFICATION DATE        : 
PROJECT NAME / TICKET #  : 
DESCRIPTION              : 
*/
trigger AccountRequestTrigger on Account_Requests__c (before insert, before update) {
    TriggerService__mdt triggerServiceObj = TriggerService__mdt.getInstance('AccountRequestTrigger');
    if(triggerServiceObj.Active__c == true){
    //Before Event
        if(Trigger.isBefore) {
            //Before Insert Event
            if(Trigger.isInsert) {
            }
            if(Trigger.isUpdate){
                AccountRequestTriggerHelper.isBeforeUpdate(Trigger.new, Trigger.oldMap);
            }
        }
    }
}