trigger ClientContactDirectoryTrigger on Client_Contact_Directory__c (before insert,before update, after insert, after update) {
    TriggerService__mdt triggerService = TriggerService__mdt.getInstance('ClientContactDirectoryTrigger');
    if(triggerService.Active__c == true){        
        if(Trigger.isAfter){
            if(Trigger.isInsert){
                //Added by Rakesh, 22-05-24
                //Used to Share Records with the Partner's EA.
                ClientContactDirectoryTriggerHandler.insertClientContactDirList(Trigger.new);
            }
            
            if(Trigger.isUpdate){
                //Added by Rakesh, 22-05-24
                //Used to Share Records with the Partner's EA.
                    ClientContactDirectoryTriggerHandler.updateClientContactDirList(Trigger.new,Trigger.oldMap);
            }
        }
    }
}