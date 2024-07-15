trigger TaskTrigger on Task (before insert,before update,after update,after insert,after delete) {
    TriggerService__mdt triggerService = TriggerService__mdt.getInstance(ConstantUtility.TASK_TRIGGER);
    if(triggerService.Active__c == true){
    if(trigger.isBefore){
        if(trigger.isInsert){
            TaskTriggerHandler.IsBeforeInsert(Trigger.new);
            
        }else if(trigger.isUpdate){
            TaskTriggerHandler.IsBeforeUpdate(Trigger.new, Trigger.oldMap);
            TaskTriggerHandler.IsBeforeUpdateForValidation(Trigger.new, Trigger.oldMAp);
            TaskTriggerHandler.IsBeforeTaskUpdate(Trigger.new, Trigger.oldMap);
            //TaskTriggerHandler.minimumTwoFPRequireforTaskClosure(Trigger.new);//Gaurav Kumar (05-Oct-2023)
			TaskTriggerHandler.checkCampaignFeedbackTaskBeforeUpdate(Trigger.new,Trigger.oldMap); // Added by Rajat on 18
        }
    }else if(trigger.isAfter){
        if(trigger.isInsert){
            
        }else if(trigger.isUpdate){
            TaskTriggerHandler.minimumTwoFPRequireforTaskClosure(Trigger.new);//Gaurav Kumar (05-Oct-2023)
        }
    }
    }
}