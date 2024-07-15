/*
    Created by : Suraj Kumar
    Date : 03-09-2023
    Description : This class is scheduled to run daily evening and send Client Contact Relationship Team details whenever they are created or 
    updated to WCGT.
*/

global class Batch_SyncClientContactTeam implements Database.Batchable<SObject>, Database.AllowsCallouts{
    global Database.QueryLocator start(Database.BatchableContext bc){
        return Database.getQueryLocator(SyncClientContactTeamHandler.getQuery());
    }
    
    global void execute(Database.BatchableContext bc, List<Client_Contact_Relationship_Team__c> relationshipTeamList){
        try{
            Set<Id> clientContactIds = new Set<Id>();
            for(Client_Contact_Relationship_Team__c teamMember : relationshipTeamList){
                if(teamMember.Client_Contact__c != null){
                    clientContactIds.add(teamMember.Client_Contact__c );
                }
            }
            
            if(!clientContactIds.isEmpty()){
                SyncClientContactTeamHandler.getRelationshipTeamMembers(clientContactIds);
            }
            
        }
        catch(Exception e){
            System.debug('Exception : ' + e.getMessage() + ' in Line : ' + e.getLineNumber());
        }
    }
    
    global void finish(Database.BatchableContext bc){
        
    }
}