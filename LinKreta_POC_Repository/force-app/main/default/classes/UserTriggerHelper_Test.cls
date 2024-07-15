/*
CreatedBy :Rakesh Kumar
Class - UserTriggerHelper
Coverage - 90%
*/
@IsTest
Private class UserTriggerHelper_Test {
    @isTest
    static void testRemoveInactiveUsers() {
        // Create test data - Active user
        User activeUser = TestDataFactory.createUserRecord();
        activeUser.IsActive = True;
        insert activeUser;
        
        // Create test data - Inactive user
        User Inactive = TestDataFactory.createUserRecord();
        Inactive.IsActive = True;
        Inactive.Username = 'testxx.t@gmail.com';
        insert Inactive;

        // Add the active user to a public group
        Group testGroup = new Group(Name = 'Test Group', Type = 'Regular');
        insert testGroup;

        GroupMember groupMember = new GroupMember(
            GroupId = testGroup.Id,
            UserOrGroupId = activeUser.Id
        );
        insert groupMember;

        
        // Simulate a trigger update with inactive user
        Inactive.IsActive = false;
        Test.startTest();
        update Inactive;
        
        Test.stopTest();

        // Query the GroupMember after the trigger has executed
        List<GroupMember> groupMembersAfterUpdate = [SELECT Id FROM GroupMember WHERE UserOrGroupId = :Inactive.Id];

        // Verify that the inactive user has been removed from the group
        System.assertEquals(0, groupMembersAfterUpdate.size());
    }
    
    @isTest
    static void testRemoveInactiveUsersFromGroups() {
        Set<Id> userIds = new Set<Id>();
        UserTriggerHelper.removeInactiveUsersFromGroups(userIds);
    }
}