/*
AUTHOR                   : Prashant Bansal
CREATED DATE             : 18-May-2024
PROJECT NAME / TICKET #  : EA Partner Login Functionality
DESCRIPTION
Trigger on EAPartnerLogin_Mapper__c Object
*/
trigger EAPartnerLogin_MapperTrigger on EAPartnerLogin_Mapper__c (before insert, before update, before Delete) {
    if(trigger.isBefore) {
        if(trigger.isInsert) {
            EAPartnerLogin_MapperTriggerHandler.handleBeforeInsert(trigger.new);
        }
        if(trigger.isDelete) {
            EAPartnerLogin_MapperTriggerHandler.handleBeforeDelete(trigger.old);
        }
    }
    if(trigger.isBefore) {
        if(trigger.isUpdate) {
            EAPartnerLogin_MapperTriggerHandler.handleBeforeUpdate(trigger.oldMap, trigger.new);
        }
    }
    
}