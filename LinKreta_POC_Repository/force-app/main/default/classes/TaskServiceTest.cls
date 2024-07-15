@isTest 
public  class TaskServiceTest {
    @testSetup static void dataCreation() {
        Campaign cmp = new Campaign();
        cmp.Name = 'Test Campaign';
        cmp.Activation_Status__c = 'Approved';
        cmp.IsActive = true;
        cmp.Status = 'Design';
        insert cmp;

        Task task =new Task();
        task.WhatId = cmp.Id;
        insert task;

    }
    @isTest static void testInvocable(){
        Campaign cmp =[SELECT Id FROM Campaign LIMIT 1];
        TaskService.getTaskByCampaignIds(new SET<String>{cmp.Id});
    }
}