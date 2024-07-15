@isTest
public class NotificationToCANDMTeamTest {

     @testSetup static void dataCreation() {
         
        Account acc = TestDataFactory.createAccountRecord();
        insert acc;
         
        Task t = TestDataFactory.createTaskRecord();
        t.OwnerId = UserInfo.getUserId();
        t.Subject='Donni';
        t.Status='Not Started';
        t.Priority='Normal';
        insert t; 
     }
    @isTest static void SendNotificationTest() {
        List<Account> listOfAccount =  [SELECT Id,Name FROM Account];
        List<Task> listOfTask = [SELECT Id,OwnerId,Subject,Status FROM Task];
        List<NotificationToCANDMTeam.ActionRequest> listOfResp = new List<NotificationToCANDMTeam.ActionRequest>();
        NotificationToCANDMTeam.ActionRequest ResObj = new NotificationToCANDMTeam.ActionRequest();
     	ResObj.ClientId = listOfAccount[0].Id;
        ResObj.TaskId = listOfTask[0];
        listOfResp.add(ResObj);
        
        NotificationToCANDMTeam.sendNotification(listOfResp);
        System.assertEquals(1 , listOfTask.size() , 'successfull');
        
    }
}