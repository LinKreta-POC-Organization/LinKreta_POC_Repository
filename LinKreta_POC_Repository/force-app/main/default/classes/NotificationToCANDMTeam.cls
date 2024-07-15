public class NotificationToCANDMTeam {
    @InvocableMethod
    public static void sendNotification(List<ActionRequest> getInfo){
        Set<String> groupNames = new Set<String>();
        groupNames.add('C_M_Team');
        Set<String> userIds =getGroup(groupNames);
        Account ClientObj = [SELECT Id,OwnerId,Name FROM Account WHERE Id=:getInfo[0].ClientId];
        User UserObj = [select id,name from user where id =: ClientObj.OwnerId];
        // userIds.add(ClientObj.OwnerId);
        
        
        if(userIds !=null){
            
            String subject = UserObj.Name + ' assigned you a task ';
            String messageBody  = 'Review ' + ClientObj.Name +' greylist request ';	
            
            GenericNotification.sendNotification(getInfo[0].TaskId.Id, userIds,messageBody,subject);
        }
        
    }
    public static Set<String>  getGroup(Set<String> groupNames){
        List<User> groupMember =[SELECT Id, Name, IsActive FROM User 
                                 WHERE IsActive =true AND Id IN  
                                 (SELECT UserOrGroupId FROM GroupMember  WHERE Group.DeveloperName =:groupNames)];
        Set<String> userIds = new Set<String>();
        for(User  usr: groupMember){
            userIds.add(usr.Id);
        }
        return userIds;
        
        
    }
    public class ActionRequest{
        @InvocableVariable
        public Id ClientId;
        @InvocableVariable
        public Task TaskId;
        
    }
    
}