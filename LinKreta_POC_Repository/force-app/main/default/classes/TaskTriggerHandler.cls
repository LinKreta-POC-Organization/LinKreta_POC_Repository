/*

CreatedBy :Rohitash Mourya
Create Date: 17-APR-2023
Last Modified Date: 17-APR-2023
Description:This class is used for updating created by name for system generated task's
*/
public class TaskTriggerHandler {
    public static void IsBeforeInsert(List<Task> taskList){
        try{
            user linkretaUser=[Select id,Name from User where Name='Linkreta GT' Limit 1];
            List<String> taskNameList=new List<string>();
            taskNameList.add('Enrichment of Segmentation Details of New Client');
            taskNameList.add('New Client Owner based on NSL discussion');
            taskNameList.add('NSL Discussion Pending');
            taskNameList.add('Next steps & actions discussed with NSL');
            taskNameList.add('Client Engagement');
            taskNameList.add('Client Take-On Preparation Deck');
            taskNameList.add('Client Council Takeaways');
            for(Task taskRecord:taskList){
                System.debug('taskRecord subject : ' + taskRecord.Subject + ' and Id : ' + taskRecord.Id);
                System.debug('linkretaUser id : ' + linkretaUser.Id );
                if(taskNameList.contains(taskRecord.Subject) && linkretaUser.Id != Null){
                    taskRecord.CreatedById=linkretaUser.Id;
                }
            }
        }catch(exception e){
            
        }
    }
    
    //Gaurav Kumar(28-Aug-2023)
    //Description:This method is used for validate the non admin profile user not edit Reminder Set
    public static void canNotEditReminderSet(List<Task> newTaskList,Map<Id,Task> oldTaskMap){
        List<Profile> PROFILE = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1];
        String MyProflieName = PROFILE[0].Name;
        System.debug('My Proflie Name :'+MyProflieName);
        for(Task tsk : newTaskList){
            System.debug('My Proflie Name :'+tsk.ReminderDateTime);
            if(tsk.ReminderDateTime !=oldTaskMap.get(tsk.Id).ReminderDateTime && MyProflieName !='System Administrator'){
                tsk.addError(System.Label.SFDX_Reminder_Set_Not_Modify);
            }
        }
    }
    
    /*  
CreatedBy :Rohitash Mourya
Last Modified Date: 31-JULY-2023
Description: Task will only be completed when related job's celebration event is added to MOM
Test Class : TaskTriggerHandler_Test
*/
    
    public static void IsBeforeUpdate(List<Task> taskList, Map<Id,Task>oldMap){
        //Start SFDC-[Phase-1]: code is added by Biplow sarkar | 03-04-2024
        /*
        system.debug('taskList:: '+taskList);
        Map<Id,List<Task>> whatIdTaskMap = new Map<Id,List<Task>>();
        Map<Id,String> mapTskIdToSubject = new Map<Id,String>(); // Added by Rajat for Job
        Map<Id,Task> mapTskIdToTask = new Map<Id,Task>(); // Added by Rajat for Job
        List<Id> momOrEventAbsentTaskIds = new List<Id>(); // Added by Rajat for Job
        List<Id> momOrEventPresentTaskIds = new List<Id>(); // Added by Rajat for Job
        Map<Id,String> mapTskIdToType = new Map<Id,String>(); // Added by Rakesh for Job
        for (Task task: taskList) {
            //if(oldMap.get(task.Id).Status != task.Status && task.Status == 'Completed' ){
            if(oldMap.get(task.Id).Status != task.Status && task.Status == 'Completed' ){
                if(task.WhatId != null){  
                    if(task.Subject == 'Pre Closure Checklist' || task.Type == 'CX Internal Meeting' || task.Type == 'CX External Meeting'|| task.type == 'Internal Kick-off Meeting' || task.type == 'Client Kick-off Meeting'){
                        if(whatIdTaskMap.containsKey(task.WhatId)){
                            whatIdTaskMap.get(task.WhatId).add(task);
                        }
                        else{
                            whatIdTaskMap.put(task.WhatId, new List<Task>{task}); 
                        }
                    }
                    // Added by Rajat for Job : Start 
                    if(task.Type == 'CX Internal Meeting' || task.Type == 'CX External Meeting'|| task.type == 'Internal Kick-off Meeting' || task.type == 'Client Kick-off Meeting'){
                        mapTskIdToSubject.put(task.Id,task.Type);
                        mapTskIdToType.put(task.Id,task.Type); 
                        mapTskIdToTask.put(task.Id,task);
                    }
                    System.debug('mapTskIdToType-->'+mapTskIdToType);
                    // Added by Rajat for Job : End 
                }
                system.debug('whatIdTaskMap:: '+whatIdTaskMap);
            }
        }
        List<Id> jobIds = getSObjectName(whatIdTaskMap.keySet());
        List<Id> momAbsentjobIds = new List<Id>();
        
        if(jobIds.size() > 0){
            for(Event event : [SELECT Id,Meeting_Agenda__c, WCGTStatus__c, WhatId FROM Event WHERE isChild = False AND WhatId In : jobIds AND (Type =: 'Celebration Event' or Type =: 'Unveil Event')]){
                if(String.isBlank(event.Meeting_Agenda__c) == True){
                    momAbsentjobIds.add(event.WhatId);
                    system.debug('whatIdTaskMap:: '+whatIdTaskMap);
                }
            }
             Added by Rajat for Job : Start 
            if(mapTskIdToSubject.keySet().size() > 0 && whatIdTaskMap.keySet().size() > 0){
                system.debug('mapTskIdToSubject:'+mapTskIdToSubject);
                List<Event> evnts = [SELECT Id, WCGTStatus__c,Type,WhatId,Subject,Meeting_notes__c FROM Event WHERE WhatId IN : jobIds AND Type IN :mapTskIdToSubject.values()];
                if(evnts != null && evnts.size() > 0){
                    system.debug('evnts:'+evnts);
                    for(Event evt : evnts){
                        if(whatIdTaskMap.containsKey(evt.WhatId)){
                            for(Task tsk : whatIdTaskMap.get(evt.WhatId)){
                                if(tsk.Type != null && evt.Type == tsk.Type && String.isBlank(evt.Meeting_notes__c)){
                                    momOrEventAbsentTaskIds.add(tsk.Id);
                                }else if(tsk.Type != null && evt.Type == tsk.Type && String.isNotBlank(evt.Meeting_notes__c)){
                                    momOrEventPresentTaskIds.add(tsk.Id);
                                }
                            }   
                        }
                    }
                }
                system.debug('momOrEventPresentTaskIds:'+momOrEventPresentTaskIds);
                system.debug('momOrEventAbsentTaskIds:'+momOrEventAbsentTaskIds);
                List<Id> allTsks = new List<Id>();
                if(momOrEventAbsentTaskIds.size() > 0){
                    allTsks.addAll(momOrEventAbsentTaskIds);
                }
                if(momOrEventPresentTaskIds.size() > 0){
                    allTsks.addAll(momOrEventPresentTaskIds);
                }
                if(allTsks.size() > 0){
                    for(Id tsk : allTsks){
                        if(mapTskIdToTask.containsKey(tsk)){
                            if(momOrEventAbsentTaskIds.contains(tsk)){
                                mapTskIdToTask.get(tsk).addError('Please add Minutes of Meeting to '+mapTskIdToTask.get(tsk).Type+' before completing the Task.');
                            }else if(!momOrEventPresentTaskIds.contains(tsk)){
                                System.debug('1-->');
                                mapTskIdToTask.get(tsk).addError('Please schedule a '+mapTskIdToTask.get(tsk).Type+'and add Minutes of Meeting before completing the Task.');
                            }
                        }
                    }
                }else{
                    for(Task tsk : mapTskIdToTask.values()){
                        tsk.addError('Please schedule a '+tsk.Type+' and add Minutes of Meeting before completing the Task.');
                    }
                }
            }
            // Added by Rajat for Job : End 
        }
        for (Task task: taskList) {
            if(momAbsentjobIds.contains(task.WhatId)){
                system.debug('task.subject:: '+task.subject);
                task.addError('Please add Event Takeaways before completing the Task.');
            }
        }
*/
        //End SFDC-[Phase-1]: code is added by Biplow sarkar | 03-04-2024
    }
    
    // CreatedBy :Rakesh Kumar
    //     Last Modified Date: 19-Sep-2023
    //        Description: Task will only be completed in a sequence
    
    public static void IsBeforeTaskUpdate(List<Task> taskList, Map<Id,Task>oldMap){
        //Start SFDC-[Phase-1]: code is added by Biplow sarkar | 03-04-2024
        /*
        system.debug('taskList:: '+taskList);
        Set<id> jobIds = new Set<id>();
        Set<id> jobIdsForInternalTask = new Set<id>();
        Set<id> jobIdsForExternalTask = new Set<id>();
        for (Task task: taskList) {
            if(oldMap.get(task.Id).Status != task.Status && task.Status == 'Completed' && task.subject == 'Add Job Team Member'){
                jobIds.add(task.WhatId);
            }else if(oldMap.get(task.Id).Status != task.Status && task.Status == 'Completed' && task.subject == 'Setup a Internal Kickoff Meeting' ){
                jobIdsForInternalTask.add(task.WhatId);
            }else if(oldMap.get(task.Id).Status != task.Status && task.Status == 'Completed' && task.subject == 'Setup a Client Kickoff Meeting'){
                jobIdsForExternalTask.add(task.WhatId);
            }
        }
        System.debug('jobIdsForInternalTask=>'+jobIdsForInternalTask);
        System.debug('jobIdsForExternalTask=>'+jobIdsForExternalTask);
        if(jobIdsForInternalTask!=null || jobIdsForExternalTask!=null){
            Set<Id> jobIdRelatedToTask = new Set<Id>();
            Set<Id> jobIdRelatedToTask2 = new Set<Id>();
            for(Task openTasks : [SELECT id,Status,whatId,Subject FROM Task where Status !='Completed' AND Subject = 'Add Job Team Member' AND WhatId IN : jobIdsForInternalTask]){
                System.debug('openTasks=Subject >'+openTasks.Subject);
                if(openTasks.Subject=='Add Job Team Member'){
                    jobIdRelatedToTask.add(openTasks.whatId);
                } 
            }  
            for(Task clientOpenTasks : [SELECT id,Status,whatId,Subject FROM Task where Status !='Completed' AND Subject = 'Setup a Internal Kickoff Meeting' AND WhatId IN : jobIdsForExternalTask]){
                System.debug('clientOpenTasks=Subject >'+clientOpenTasks.Subject);
                if(clientOpenTasks.Subject=='Setup a Internal Kickoff Meeting'){
                    jobIdRelatedToTask2.add(clientOpenTasks.whatId);
                } 
            } 
            
            System.debug('jobIdRelatedToTask2== >'+jobIdRelatedToTask2);
            System.debug('jobIdRelatedToTask=>'+jobIdRelatedToTask);
            for (Task task: taskList) {
                if(jobIdRelatedToTask2.contains(task.whatId)){
                    System.debug('1');
                    Task.addError('Please Complete Setup a Internal Kickoff Meeting Task First');
                } 
                else if(jobIdRelatedToTask.contains(task.whatId)){
                    System.debug('2');
                    Task.addError('Please Complete Add Job Team Members Task First');
                }  
            }
        }
        if(jobIds!=null){
            List<Job_Execution_Team__c> jobTeamMemberList = [SELECT id,Job__c FROM Job_Execution_Team__c WHERE Job__c IN : jobIds];
            
            Set<Id> jobIdRelatedToJobTeam = new Set<Id>();
            for(Job_Execution_Team__c jobTeam : jobTeamMemberList){
                jobIdRelatedToJobTeam.add(jobTeam.Job__c);
            }
            for (Task task: taskList) {
                if(jobIds.contains(task.WhatId)){
                    if(!jobIdRelatedToJobTeam.contains(task.WhatId)){
                        Task.addError('Please Add Job Execution Team Members');
                    }
                }
            }
        }
        */
        //End SFDC-[Phase-1]: code is added by Biplow sarkar | 03-04-2024
    }
    /* Added by Rakesh for Job : End */   
    
    
    
    // Added By Bhavishya Basantwani
    // This Method is used For restrict to add CO-CSl and CSL In Account Only In CLient Record Type (CO-CSl and CSl Is Added In CLient record Type Record With automation From Key Account Record Type)
    public static void IsBeforeUpdateForValidation(List<Task> taskListNew , Map<id,Task> taskListOld){
        Map<Id,Task> MapOfTask = new  Map<Id,Task>();
        set<Id> setOfQueueId = new set<Id>();
        User loggedInUser = [SELECT ID, PartnerLogin_UserID__c FROM User  WHERE Id =: UserInfo.getUserId() Limit 1];// Added by Suresh Gupta 03 Nov 2023 for EA functionality
        for(Task objOfTask : taskListNew){
            if(objOfTask.Status != taskListOld.get(objOfTask.Id).status && objOfTask.Subject != 'Next steps & actions discussed with NSL' && objOfTask.Subject != 'Client Council Takeaways' &&  
               objOfTask.Subject != 'Client Take-On Preparation Deck' 
               && objOfTask.Subject != 'Client Engagement' && objOfTask.Subject != 'New Client Owner based on NSL discussion'
               && objOfTask.Subject != 'Enrichment of Segmentation Details of New Client' 
               && objOfTask.subject != 'NSL Discussion Pending'
               //Added by Rakesh [22-11-2023]
               //Start SFDC-[Phase-1]: code is added by Biplow sarkar | 03-04-2024
        /*
               && objOfTask.subject != 'Add Job Team Member'
*/
        //End SFDC-[Phase-1]: code is added by Biplow sarkar | 03-04-2024
            /*  && objOfTask.subject != 'Setup a Internal Kickoff Meeting'
              && objOfTask.subject != 'Setup a Client Kickoff Meeting'
               && objOfTask.subject != 'Create Quip Engagement Document'
            */  
               //Added by bhavika [22-11-2023]
               //Start SFDC-[Phase-1]: code is added by Biplow sarkar | 03-04-2024
        /*
               && objOfTask.subject != 'Upload Final Resignation Letter'
               && objOfTask.subject != 'Fill the resignation checklist in quip'
*/
        //End SFDC-[Phase-1]: code is added by Biplow sarkar | 03-04-2024
        ){
                   
                   system.debug('In if of User');
                   String assignString = String.valueof(objOfTask.OwnerId);
                   String startId = assignString.substring(0,3);
                   if(startId == '005'){
                       system.debug('in Start Id ');
                       system.debug('objOfTask.OwnerId'+objOfTask.OwnerId);
                       system.debug('UserInfo.getUserId()'+UserInfo.getUserId());
                        if(objOfTask.OwnerId != UserInfo.getUserId() && objOfTask.OwnerId !=loggedInUser.PartnerLogin_UserID__c){
                           system.debug('in Check owner id');
                           objOfTask.addError('you cannot mark task as complete');
                       }
                   }
                   else{
                       setOfQueueId.add(objOfTask.OwnerId);
                       // MapOfTask.put(objOfTask.Id,objOfTask);
                   }
               }
        }
        
        if(setOfQueueId.size()>0){
            set<Id> setOfGroupIds = new set<Id>();
            List<GroupMember> listOfGroupMember = [select Id,UserOrGroupId,GroupId FROM GroupMember where UserOrGroupId =: UserInfo.getUserId() AND GroupId IN: setOfQueueId];
            for(GroupMember gm : listOfGroupMember){
                setOfGroupIds.add(gm.GroupId);
            }
            system.debug('setOfGroupIds'+setOfGroupIds);
            for(Task objOfTask : taskListNew){
                if(objOfTask.Status != taskListOld.get(objOfTask.Id).status && objOfTask.Subject != 'Next steps & actions discussed with NSL'
                   && objOfTask.Subject != 'Client Council Takeaways' &&  objOfTask.Subject != 'Client Take-On Preparation Deck' 
                   && objOfTask.Subject != 'Client Engagement' && objOfTask.Subject != 'New Client Owner based on NSL discussion' 
                   && objOfTask.Subject != 'Enrichment of Segmentation Details of New Client' && objOfTask.subject != 'NSL Discussion Pending'
                  //Added by bhavika [22-11-2023]
                   && objOfTask.Subject != 'Upload Final Resignation Letter'
                   && objOfTask.subject != 'Fill the resignation checklist in quip'){

                       
                       system.debug('In if of User');
                       String assignString = String.valueof(objOfTask.OwnerId);
                       String startId = assignString.substring(0,3);
                       if(startId != '005'){
                           system.debug('in Start Id ');
                           if(!setOfGroupIds.contains(objOfTask.OwnerId) && !setOfGroupIds.contains(loggedInUser.PartnerLogin_UserID__c)){
                               system.debug('in Check owner id');
                               objOfTask.addError('you cannot mark task as complete');
                           }
                       }
                   }
            }
        }
    }
    // End By Bhavishya
    public static List<Id> getSObjectName(Set<Id> taskWhatIds){
        List<Id> jobIds = new List<Id>();
        for(Id whatId : taskWhatIds){
            system.debug('whatId:: '+whatId);
            String sObjName = whatId.getSObjectType().getDescribe().getName();
            if(sObjName == 'Job__c'){
                jobIds.add(whatId) ;
            }
        }
        return jobIds;
    }
    
    //Gaurav Kumar (12-Sep-2023)
    public static void retrictTaskCreation(List<Task> taskList){
        Map<Id, Task> leadToTaskMap = new Map<Id, Task>();
        for(Task task : taskList){
            if(task.whoId != null && String.valueOf(task.whoId.getSObjectType()) == 'Lead'){
                leadToTaskMap.put(task.whoId, task);
            } 
        }
        
        for(Lead lead : [SELECT Id, Name, Status FROM Lead WHERE Id IN : leadToTaskMap.keySet()]){
            if(lead.Status == 'Accept Client' || lead.status == 'NotAccept'){
                leadToTaskMap.get(lead.Id).addError('You are not authorized to create task on Accepted/Non-Accepted New Client');
            }
        }
    }
    
    
    //Gaurav Kumar (05-Oct-2023)
    public static void minimumTwoFPRequireforTaskClosure(List<Task> taskList){
        //Start SFDC-[Phase-1]: code is added by Biplow sarkar | 03-04-2024
        /*
        Map<Id, Task> oppToTaskMap = new Map<Id, Task>();
        for(Task task : taskList){
            if(task.WhatId != null && String.valueOf(task.WhatId.getSObjectType()) == 'Opportunity' && task.Subject =='Addition of finding partner' && task.Status == 'Complete' ){
                oppToTaskMap.put(task.WhatId, task);
            } 
        }
        
        for(Opportunity opp : [SELECT Id, Name,(SELECT Id FROM OpportunityTeamMembers) FROM Opportunity WHERE Id IN : oppToTaskMap.keySet()]){
            if(opp.OpportunityTeamMembers.size()<2){
                oppToTaskMap.get(opp.Id).addError('Please add Minimum 2 Finding Partner for task complete');
            }
        }
        */
        //End SFDC-[Phase-1]: code is added by Biplow sarkar | 03-04-2024
    }
    // Added by Rajat for Campaign Feedback Task validation on 18/10/2023
    public static void checkCampaignFeedbackTaskBeforeUpdate(List<Task> taskList,Map<Id,Task> oldMap){
        //Start SFDC-[Phase-1]: code is added by Biplow sarkar | 03-04-2024
        /*
        try{
            Map<Id, Task> campToTaskMap = new Map<Id, Task>();
            Set<Id> campIds = new Set<Id>();
            List<Campaign> updCampaign = new List<Campaign>();
            for(Task task : taskList){
                if(oldMap.get(task.Id).Status != task.Status && task.Status == 'Completed'){
                    if(task.Type == 'Campaign Feedback'){
                        campToTaskMap.put(task.WhatId,task);
                        campIds.add(task.WhatId);
                    }
                }
            }
            if(campIds.size() > 0 && campToTaskMap.keySet().size() > 0){
                List<Campaign> campList = [SELECT Id,Campaign_Feedback__c FROM Campaign WHERE ID IN :campIds];
                if(campList.size() > 0){
                    for(Campaign cmp : campList){
                        if(String.isBlank(cmp.Campaign_Feedback__c)){
                            campToTaskMap.get(cmp.Id).addError('Please fill Campaign Feedback before completing this task.');
                        }else if(String.isNotBlank(cmp.Campaign_Feedback__c) && cmp.Closure_Status__c == 'Approved'){
							updCampaign.add(new Campaign(ID = cmp.Id,Status = 'Closed'));                            
                        }  
                    }
                }
                if(updCampaign.size() > 0){
                    update updCampaign;
                }
            }
        }catch(Exception e){
            system.debug('Exception e:'+e.getLineNumber()+' '+e.getMessage());
        }
*/
        //End SFDC-[Phase-1]: code is added by Biplow sarkar | 03-04-2024
    }
}