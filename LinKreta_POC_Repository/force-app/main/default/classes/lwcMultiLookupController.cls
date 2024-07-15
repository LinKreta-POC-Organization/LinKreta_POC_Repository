/*  Suraj Kumar
Date : 04-03-2023
Description : Used in multiLookup LWC Component
last modified by:Rohitash Mourya
last modified date:15/05/2023
*/

public without sharing class lwcMultiLookupController {
    
    @AuraEnabled(cacheable=true)
    public static List<SObJectResult> getResults(String ObjectName, String fieldName, String value, List<String> selectedRecId, Boolean isEnquiry) {
        List<SObJectResult> sObjectResultList = new List<SObJectResult>();
        system.debug(fieldName+'-------------'+ObjectName+'---++----------'+value+'====='+selectedRecId);
        if(selectedRecId == null){
            selectedRecId = new List<String>();
        }
        
        if(String.isNotEmpty(value)) {
            
            if(!isEnquiry){
                //changes start by Rohitash(15/05/23) for soql injection issue
                String query = 'Select Id,'+string.escapeSingleQuotes(fieldName)+' FROM '+string.escapeSingleQuotes(ObjectName)+' WHERE '+string.escapeSingleQuotes(fieldName)+' LIKE \'%' + string.escapeSingleQuotes(value.trim()) + '%\' and ID NOT IN: selectedRecId AND isActive = true AND UserType = \'' + string.escapeSingleQuotes('Standard')  + '\' LIMIT 100';            
                system.debug('Query -- ' + query);
                
                for(sObject so : Database.Query(query)) {
                    String fieldvalue = (String)so.get(fieldName);
                    sObjectResultList.add(new SObjectResult(fieldvalue, so.Id,ObjectName));
                }
                
                
            } else {
                String query = 'Select Id,'+string.escapeSingleQuotes(fieldName)+' FROM '+string.escapeSingleQuotes(ObjectName)+' WHERE '+string.escapeSingleQuotes(fieldName)+' LIKE \'%' + string.escapeSingleQuotes(value.trim()) + '%\' and ID NOT IN: selectedRecId AND isActive = true AND UserType = \'' + string.escapeSingleQuotes('Standard')  + '\'  LIMIT 100';            
                system.debug(query);
                
                for(sObject so : Database.Query(query)) {
                    String fieldvalue = (String)so.get(fieldName);
                    sObjectResultList.add(new SObjectResult(fieldvalue, so.Id,ObjectName));
                }
                
                String queryContact = 'Select Id,'+string.escapeSingleQuotes(fieldName)+' FROM Contact WHERE '+string.escapeSingleQuotes(fieldName)+' LIKE \'%' + string.escapeSingleQuotes(value.trim()) + '%\' and ID NOT IN: selectedRecId AND Contact_status__c != \'Inactive\' LIMIT 100';            
                system.debug(queryContact);
                for(sObject so : Database.Query(queryContact)) {
                    String fieldvalue = (String)so.get(fieldName);
                    sObjectResultList.add(new SObjectResult(fieldvalue, so.Id,'Contact'));
                }
            }
        }
        
        return sObjectResultList;
    }
    
    @AuraEnabled(cacheable=true)
    public static List<showSelectedAttendesWrapper> getSelectedAttendees(Id eventId){
        List<EventRelation> evRelationList = [SELECT Id, RelationId, EventId FROM EventRelation WHERE RelationId != null AND EventId =: eventId];
        Event event = [SELECT Id, OwnerId, Actual_Attendees__c FROM Event WHERE Id=: eventId];
        System.debug('Actual_Attendees__c : ' + event.Actual_Attendees__c);
        
        List<String> attendeesNames;
        if(event.Actual_Attendees__c != null){
            attendeesNames = event.Actual_Attendees__c.split(',');
        }
        else{
            attendeesNames = new List<String>();
        }
        
        System.debug('attendeesNames : ' + attendeesNames);
        System.debug('usersYUpdated : ' + [SELECT Id, Name FROM User where Name In : attendeesNames]);
        Set<Id> userIds = new Set<Id>();
        
        for(EventRelation evRelation : evRelationList){
            userIds.add(evRelation.RelationId);
        }
        List<showSelectedAttendesWrapper> wrapperList = new List<showSelectedAttendesWrapper>();
        List<User> userList = [SELECT Id,IsActive, Name FROM User where 
        (Id IN : userIds OR Id =: event.OwnerId OR Name In : attendeesNames) AND IsActive =true];
        List<Contact> contactList = [select id,Name from Contact where id IN:userIds];
        for(User userObj: userList){
            showSelectedAttendesWrapper wrap = new showSelectedAttendesWrapper();
            wrap.recId = userObj.id;
            wrap.recName = userObj.Name;
            wrapperList.add(wrap);
        }
        for(Contact contObj: contactList){
            showSelectedAttendesWrapper wrap = new showSelectedAttendesWrapper();
            wrap.recId = contObj.id;
            wrap.recName = contObj.Name;
            wrapperList.add(wrap);
        }
        System.debug('userList : ' + wrapperList);
        if(!wrapperList.isEmpty()){
            return wrapperList;
        }
        else{
            return null;
        }
        
    }
    
    @AuraEnabled
    public static void updateAttendees(Id eventId, String attendeesIds){
        Event event = [SELECT Id, AttendeesId__c,Actual_Attendees__c, Subject,OwnerId  FROM Event WHERE Id =: eventId];
        String employeeIds = '';
        
        List<String> idList = attendeesIds.split(',');
        String attendeeNames = '';
        List<User> userList =  [SELECT Id, Name, EMP_ID__c FROM User WHERE Id IN : idList ];
        for(User user :userList){
            System.debug('empId : ' + user.EMP_ID__c);
            
            if(attendeeNames == ''){
                attendeeNames += user.Name;
                
            }
            else{
                attendeeNames += ',' + user.Name;
            }
            if(String.isNotBlank(user.EMP_ID__c) && user.Id != event.OwnerId){
                if(employeeIds == ''){
                    employeeIds += user.EMP_ID__c;
                }
                else{
                    employeeIds += ', ' + user.EMP_ID__c;
                }
            }
            
            System.debug('employeeIds : ' + employeeIds);
        }
        
        List<Contact> contactList = [select id from Contact where id IN: idList]; 
        List<EventRelation> eventRelationRecodList = [Select id, RelationId from EventRelation where EventId =: eventId]; 
        List<EventRelation> eventrelationList = new List<EventRelation>();
        Map<string, string> mapOfEventRelation = new Map<string, string>();
        for(EventRelation recorObj : eventrelationList){
            if(!mapOfEventRelation.containsKey(recorObj.RelationId)){
                mapOfEventRelation.put(recorObj.RelationId, recorObj.Id);
            }
        }
        
        if(!contactList.isEmpty()){
            for(Contact contObj : contactList){
                if(!mapOfEventRelation.containsKey(contObj.Id)){
                    EventRelation erObj = new EventRelation();
                    erObj.EventId = eventId;
                    erObj.RelationId = contObj.id;
                    eventrelationList.add(erObj);
                    mapOfEventRelation.put(contObj.Id,contObj.Id);
                }
            }
        }
        
        if(!userList.isEmpty()){
            event.AttendeesId__c = employeeIds;
        }
        event.Actual_Attendees__c = attendeeNames;
        System.debug('event : ' + event);
        update event;
        try{
            if(!eventrelationList.isEmpty()){
                Database.insert(eventrelationList, true);
            }
        }
        catch(Exception e){
            ErrorLogCreater_cls.apexDebugLogger(e, 'lwcMultiLookupController', 'ShowErrorofEvent', null);
        }
    }
    
    public class SObjectResult {
        @AuraEnabled
        public String recName;
        @AuraEnabled
        public Id recId;
        @AuraEnabled
        public string objectName;
        
        public SObJectResult(String recNameTemp, Id recIdTemp, string recObjectName) {
            recName = recNameTemp;
            recId = recIdTemp;
            objectName = recObjectName;
        }
        public SObJectResult() {
            
        }
    }
    public class showSelectedAttendesWrapper{
        @AuraEnabled
        public String recId {get;set;}
        
        @AuraEnabled
        public String recName {get;set;}
    }
}