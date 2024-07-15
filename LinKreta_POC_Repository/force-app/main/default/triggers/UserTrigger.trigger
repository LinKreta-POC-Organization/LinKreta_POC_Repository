trigger UserTrigger on User (before insert, before update, after insert, after update) {
    TriggerService__mdt triggerService = TriggerService__mdt.getInstance(ConstantUtility.UserTrigger);
    if(triggerService.Active__c == true){
        if(Trigger.isAfter){
            if(Trigger.isUpdate){
                List<User> usersList = new List<User>();
                for(User user : Trigger.new){
                if((user.Successor_User__c != ((Map<Id, User>)Trigger.oldMap).get(user.Id).Successor_User__c) && user.Successor_User__c != null){
                        usersList.add(user);
                    }
                }
                
                if(!usersList.isEmpty()){
                    for(User user : usersList){
                        Database.executeBatch( new UserExit_Batch (user ) );
                    }
                }

                UserTriggerHelper.removeInactiveUsers(Trigger.new);
                
            }
        }
    }
    
}