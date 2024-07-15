public class TaskService {
    public static List<Task> getTaskByCampaignIds(Set<String> campaignIds){
        List<Task> taskList = new List<Task>();
        if(campaignIds.size() > 0){
            taskList = [SELECT ID,WhatId,Subject,Status,ActivityDate FROM Task WHERE WhatId IN :campaignIds AND Type = 'Campaign Feedback'];
        }
        return taskList;
    }
}