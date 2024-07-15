/*
Created by : Suraj Kumar
Date : 05-09-2023
Description : This class is used to send Client Contact details to WCGT on creation or updation. 
*/

public class BatchSyncClientContactToWCGT implements Database.Batchable<sObject>, Database.Stateful, Database.AllowsCallouts {
    Set<Id> contactIds = new Set<Id>();
    public Map<Id, String> contactIdtoFlagMap = new Map<Id, String>();
        
    public BatchSyncClientContactToWCGT(Map<Contact, String> contactMap) {
        for(Contact con : contactMap.keySet()){
            System.debug('data>>' + con.Id + contactMap.get(con));
            this.contactIdtoFlagMap.put(con.Id, contactMap.get(con));
            this.contactIds.add(con.Id);
        }
        
    }

    
    public Database.QueryLocator start(Database.BatchableContext context) {
        // Query the records based on the provided IDs
        return Database.getQueryLocator(SyncClientContactToWCGTHelper.getQuery());
    }
    
    public void execute(Database.BatchableContext BC, List<Contact> clientContacts) {  
        System.debug('contactIdtoFlagMap >>> '+ contactIdtoFlagMap);
        
        List<API_Logger__c> apiLoggerList = new List<API_Logger__c>();
        
        for(Contact con : clientContacts){
            System.debug('flag' + contactIdtoFlagMap.get(con.Id));
            if(contactIdtoFlagMap.containsKey(con.Id)){
                List<API_Logger__c> contactApiLogs = SyncClientContactToWCGTHelper.syncClientContactToWCGT(con, contactIdtoFlagMap.get(con.Id));
                if(contactApiLogs != null){
                    apiLoggerList.addAll(contactApiLogs);
                }
            }
            
        }
        if(!apiLoggerList.isEmpty()){
            System.debug('apiLoggerList' + apiLoggerList);
            Database.insert(apiLoggerList);
        }
        
    }   
    
    public void finish(Database.BatchableContext BC){
        
    }
}