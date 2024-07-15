@isTest 
private class TaskTriggerHandlerTest {
    @testSetup static void createData(){
       /* Test.startTest();
        Job_TestDataFactory.Wrapper enquiryAndJob = Job_TestDataFactory.createJob();
        Test.stopTest();
       */
        User user1 = Job_TestDataFactory.createUserRecord('EM0001','partner','testjob@gamil.com');
        user1.FirstName = 'Linkreta';
        user1.LastName = 'GT';
        insert user1;
        
        Entity_Type_Master__c entityTypeMasterRec = TestDataFactory.createEntityTypeMaster();
        INSERT entityTypeMasterRec;
        List<Account> accountList =new List<Account>();

        Account keyAccount = TestDataFactory.createAccountRecord();
        keyAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Key Account').getRecordTypeId();
        keyAccount.VerrifiedByDSTeam__c = false;
        keyAccount.DS_Team_Approval_Status__c ='Pending with DS';
        keyAccount.Segment__c = 'Government';
        keyAccount.Sub_Segment__c = 'Government';
        accountList.add(keyAccount);
        Account gtClientGroupAccoount = TestDataFactory.createAccountRecord();
        gtClientGroupAccoount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('GT_Client_Group').getRecordTypeId();
        accountList.add(gtClientGroupAccoount);       

        Account acc = TestDataFactory.createAccountRecord();
        acc.Country_Corridor__c = 'Afghanistan';
        acc.Corridor__c ='NA';
        acc.Status_DS_Team_Remark_Status__c = 'Pending';
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Client').getRecordTypeId();
        acc.DS_Team_Approval_Status__c ='Pending with DS';
        acc.GT_Client_Group__c = accountList[1].Id;
        acc.Website ='WWW.google.com';
        acc.Industry__c ='Agriculture';
        //acc.SubIndustry__c ='Agricultural productss';
        acc.Status__c ='Active';
        acc.ClientAddress__Street__s = 'test,test';
        acc.ClientAddress__City__s ='test';
        acc.ClientAddress__PostalCode__s ='12345';
        acc.ClientAddress__StateCode__s ='CT' ;
        acc.ClientAddress__CountryCode__s =  'IN';
       
        accountList.add(acc);
        Insert accountList;
        Lead leadObj = TestDataFactory.createLeadRecord();
        insert leadObj;
       
     /*   
        Job_Execution_Team__c job_execution_teamObj = new Job_Execution_Team__c(
            CurrencyIsoCode = 'INR',
            //Emp_Code__c = userRecord.EMP_ID__c,
            Grade__c = 'C1(AM)',
            Job__c = enquiryAndJob.job.Id,
            Rate__c = '10000',
            Active__c = true);
        insert job_execution_teamObj;

        List<String> eventNameList=new List<string>();
        // eventNameList.add('Pre Closure Checklist');
     //   eventNameList.add('CX Internal Meeting');
        // eventNameList.add('CX External Meeting');
        // eventNameList.add('Internal Kick-off Meeting');
        // eventNameList.add('Client Kick-off Meeting');
        
        List<Event> eventToInsert = new List<Event>();
        for(String eventRecord:eventNameList){        
            Event eventObj = new Event();
            eventObj.Subject = eventRecord;
            // eventObj.WhoId = enquiryAndJob.enquiry.ContactId;
            eventObj.Type = eventRecord;
            eventObj.DurationInMinutes = 10;
            eventObj.ActivityDateTime = System.Now();
            eventObj.WhatId = enquiryAndJob.job.id;
            eventToInsert.add(eventObj);
        }
        insert eventToInsert;
     */   
        List<String> taskNameList=new List<string>();
        taskNameList.add('Enrichment of Segmentation Details of New Client');
        taskNameList.add('New Client Owner based on NSL discussion');
        taskNameList.add('NSL Discussion Pending');
        taskNameList.add('Next steps & actions discussed with NSL');
        taskNameList.add('Client Engagement');
        taskNameList.add('Client Take-On Preparation Deck');
        taskNameList.add('Client Council Takeaways');
    /*    taskNameList.add('Pre Closure Checklist');
        taskNameList.add('CX Internal Meeting');
        taskNameList.add('CX External Meeting');
        taskNameList.add('Internal Kick-off Meeting');
        taskNameList.add('Client Kick-off Meeting');
       */ List<Task> taskToInsert = new List<Task>();
        for(String taskRecord:taskNameList){
            Task tskObj = new Task();
            tskObj.Subject = taskRecord;
            tskObj.Type = taskRecord;
            //  tskObj.ownerId = grpObj.Id;
            tskObj.WhatId = accountList[0].id;
            tskObj.ReminderDateTime = System.now()+10;
            tskObj.Comments__c = 'test comments';
            taskToInsert.add(tskObj);
        }
        insert taskToInsert; 
        
        System.debug('taskToInsert==>'+taskToInsert);
        
    }
    
    @isTest static void testIsBeforeInsert(){
        Test.startTest();
        List<Task> tskObj = [Select id from task];
        Test.stopTest();
    } 
    
    
    
    @isTest static void testRetrictTaskCreation(){
        Test.startTest();
        Lead leadObj = [Select id from Lead limit 1];
        Task tskObj = [Select id,ReminderDateTime,Type from task where type = 'Client Engagement' limit 1];
        System.debug('tskObjtestRetrictTaskCreation==>'+tskObj);
        tskObj.WhatId = null;
        tskObj.WhoId = leadObj.Id;
        update tskObj;
        List<Task> taskToUpdate = new List<Task>();
        taskToUpdate.add(tskObj);
        TaskTriggerHandler.retrictTaskCreation(taskToUpdate);
        Test.stopTest();
    }
    
    @isTest static void testCanNotEditReminderSet(){
        Test.startTest();
        Map<Id,Task> oldTaskMap  = new Map<Id,Task>();
        Task tskObj = [Select id,ReminderDateTime,Type from task where type = 'Client Engagement' limit 1];
        List<Task> taskToUpdate = new List<Task>();
        tskObj.ReminderDateTime = System.now()+16;
        update tskObj;
        taskToUpdate.add(tskObj);
        oldTaskMap.put(tskObj.Id,tskObj);
        TaskTriggerHandler.canNotEditReminderSet(taskToUpdate , oldTaskMap);
        Test.stopTest();
    }
    
    @isTest static void IsBeforeUpdate(){
        Test.startTest();
        List<Task> tskObj = [Select id,Subject,Type,Status,WhatId from task];
        List<Event> lstEventObj = [Select id,Subject,Type,Status__c,Meeting_notes__c,Meeting_agenda__c, WCGTStatus__c from Event];
        List<Event> eventToUpdate = new List<Event>();
        for(Event evnt : lstEventObj){
            evnt.Meeting_notes__c = 'Test Meet';
            evnt.Meeting_agenda__c = 'Test Meet';
            evnt.Status__c = 'Completed';
            evnt.WCGTStatus__c = 'Success';
            eventToUpdate.add(evnt);
        }
        update eventToUpdate;
      /*  
        Job__c jobObj = [Select id from Job__c];
        List<Task> taskToUpdate = new List<Task>();
        for(Task task : tskObj){
            if(  task.Type == 'CX Internal Meeting' ){
                task.Status = 'Completed';
                task.WhatId = jobObj.Id;
                taskToUpdate.add(task);
            }
        }
        update taskToUpdate;
*/
        Test.stopTest();
    } 
    
    @isTest  static void testIsBeforeUpdateForValidation(){
        Test.startTest();
        List<Event> lstEventObj = [Select id,Subject,Type,Status__c,Meeting_notes__c,Meeting_agenda__c, WCGTStatus__c from Event];
        List<Event> eventToUpdate = new List<Event>();
        for(Event evnt : lstEventObj){
            evnt.Meeting_notes__c = 'Test Meet';
            evnt.Meeting_agenda__c = 'Test Meet';
            evnt.Status__c = 'Completed';
            evnt.WCGTStatus__c = 'Success';
            eventToUpdate.add(evnt);
        }
        update eventToUpdate;
        
       // Job__c jobObj = [Select id from Job__c];
        List<Account> accountList =[SELECT Id,RecordTypeId FROM Account];
        Task tskObj = new Task();
        tskObj.Subject = 'Client';
        tskObj.Type = 'Client';
        //  tskObj.ownerId = grpObj.Id;
        tskObj.WhatId = accountList[0].id;
        tskObj.ReminderDateTime = System.now()+10;
        tskObj.Comments__c = 'test comments';
        insert tskObj;
        
        Group g = [Select Id from Group where type = 'Queue' AND DeveloperName = 'C_M_Team_Queue' limit 1];
        System.debug('Group==>'+g.Id);
        
        GroupMember gm = [Select id,UserorGroupId  from GroupMember where GroupId =: g.id limit 1];
        System.debug('Group==>'+gm.UserorGroupId);
        
        // User queueUser = [Select id from user where Id=:gm.UserorGroupId];
        // System.debug('queueUser==>'+queueUser);
        
        //  Task tskObj = [Select id,ReminderDateTime,Type,OwnerId from task where type = 'CX Internal Meeting' limit 1];
        //  System.debug('tskObj==>'+tskObj);
        tskObj.OwnerId = g.Id;
        update tskObj;
        //  System.runAs ( queueUser) {
        tskObj.Status = 'Completed';
        try{
            update tskObj; 
        }catch(Exception e){
            //  System.assertEquals(error, response.outputRecordCollection.size(), 'OutputRecordCollection size should be 5');    
        }
        
        //   }
        Test.stopTest();
    }
    
        @isTest  static void getSObjectName(){
        Test.startTest();
            List<Account> accountList =[SELECT Id,RecordTypeId FROM Account];
            Set<Id> accIds = new Set<Id>();
            for(account acc : accountList){
                accIds.add(acc.Id);
            }
            TaskTriggerHandler.getSObjectName(accIds);
        Test.stopTest();
        }
    
    @isTest  static void beforeUpdate(){
        Test.startTest();
        List<Account> accountList =[SELECT Id,RecordTypeId FROM Account];
        Task tskObj = new Task();
        tskObj.Subject = 'camp';
        tskObj.Type = 'Campaign Feedback';
        tskObj.Status = 'Open';
        tskObj.WhatId = accountList[0].id;
        tskObj.ReminderDateTime = System.now()+10;
        tskObj.Comments__c = 'test comments';
        insert tskObj;
        tskObj.Status = 'Completed';
        update tskObj;
        Test.stopTest();
        }
}