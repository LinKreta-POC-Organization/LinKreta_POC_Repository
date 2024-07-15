trigger GTCompetitorTrigger on GT_competitor__c (before insert, before update) {
    if (Trigger.isInsert || Trigger.isUpdate) {
        if (Trigger.isBefore) {
          //  GTCompetitorTriggerHandler.handleCompetitorRecords(Trigger.new);
        }
    }
}