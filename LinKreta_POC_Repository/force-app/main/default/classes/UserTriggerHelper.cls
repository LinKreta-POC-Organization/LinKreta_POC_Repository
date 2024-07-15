/*
    Created by : Suraj Kumar
    Date : 09-11-2023
    Description : This class is used to remove the Inactive user from all the public groups and queues in the system.
*/

public class UserTriggerHelper {
    public static void removeInactiveUsers(List<User> userList){
        // Set of user Ids which need to be removed from all the public groups/queues.
        Set<Id> userIdsForRemoval = new Set<Id>();
        
        for(User user : userList){
            if(user.isActive != ((Map<Id, User>)Trigger.oldMap).get(user.Id).isActive  && user.isActive == false){
                userIdsForRemoval.add(user.Id);
            }
        }
        
        if(!userIdsForRemoval.isEmpty()){
            System.debug('usersToBeRemoved --> ' + userIdsForRemoval);
            removeInactiveUsersFromGroups(userIdsForRemoval);
        }
        
    }
    @TestVisible
    private static void removeInactiveUsersFromGroups(Set<Id> userIds) {
        // Retrieving inactive group/queue members 
        List<GroupMember> groupMembersToBeRemoved = [SELECT Id FROM GroupMember WHERE UserOrGroupId IN :userIds];
        
        if(!groupMembersToBeRemoved.isEmpty()){
            System.debug('groupMembersToBeRemoved --> ' + groupMembersToBeRemoved);
            delete groupMembersToBeRemoved;
        }
        
    }
    
}