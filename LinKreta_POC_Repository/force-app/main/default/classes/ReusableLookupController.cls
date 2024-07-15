/*
* @Name: ReusableLookupController
* @Author: Bhavishya Basantwani
* @Description: This class is used for LWC to retrieve the data of Account And Realted Conatct.
* @Date: 24-August-23
*/
public with sharing class ReusableLookupController {
    @AuraEnabled
    
    // This Methord Is used for Fetch Searched Records
    public static List<ResultWrapper> fetchRecords(SearchWrapper inputWrapper , string accId , string keyAccountId) {
        String filterCriteria ;
        String recordTypee = 'Bill_To_Client' ;
        system.debug('keyAccountId'+keyAccountId);
        String fieldsToQuery = 'SELECT Id, ';
        if(string.isNotBlank(inputWrapper.fieldApiName)){
            fieldsToQuery = fieldsToQuery + inputWrapper.fieldApiName;
        }
        if(string.isNotBlank(inputWrapper.otherFieldApiName)){
            fieldsToQuery = fieldsToQuery + ', ' + inputWrapper.otherFieldApiName;
        }
        String query = fieldsToQuery + ' FROM '+ inputWrapper.objectApiName;
        
        if(inputWrapper != null && inputWrapper.objectApiName == 'Contact'){
            filterCriteria = inputWrapper.fieldApiName + ' LIKE ' + '\'' + String.escapeSingleQuotes(inputWrapper.searchString.trim()) + '%\' and accountId =: accId LIMIT 10';
        }
        
        else{
            
            filterCriteria = inputWrapper.fieldApiName + ' LIKE ' + '\'' + String.escapeSingleQuotes(inputWrapper.searchString.trim()) + '%\' AND Key_Account_Id__c =: keyAccountId  AND RecordType.DeveloperName != \'Bill_To_Client\' LIMIT 10 ';
            
        }
        if(String.isNotBlank(inputWrapper.selectedRecordId)) {
            query += ' WHERE Id = \''+ inputWrapper.selectedRecordId + '\'';
        }else if(String.isNotBlank(inputWrapper.parentFieldApiName) && String.isNotBlank(inputWrapper.parentRecordId)){
            query += ' WHERE '+ inputWrapper.parentFieldApiName+ ' = \''+ inputWrapper.parentRecordId + '\'';
            query += ' AND ' + filterCriteria;
        } 
        else {
            query += ' WHERE '+ filterCriteria;
            system.debug('query'+query);
        }
        List<ResultWrapper> returnWrapperList = new List<ResultWrapper>();
        for(SObject s : Database.query(query)) {
            ResultWrapper wrap = new ResultWrapper();
            wrap.mainField = (String)s.get(inputWrapper.fieldApiName);
            wrap.subField = (String)s.get(inputWrapper.otherFieldApiName);
            wrap.id = (String)s.get('id');
            returnWrapperList.add(wrap);
        }
        return returnWrapperList;   
    }
    
    @AuraEnabled
    //This Methord is used for fetch 5 recent record 
    public static List<ResultWrapper> RecentRecords(SearchWrapper inputWrapper , string accId , string keyAccountId) {
       System.debug('keyAccountId'+keyAccountId);
        //RecordType.DeveloperName != recordTypee AND
        String recordTypee = 'Bill_To_Client' ;
        String query ;
        if(inputWrapper.objectApiName == 'Contact'){
            query = 'select Id,Name from '  + inputWrapper.objectApiName + ' Where accountId =: accId Order By LastModifiedDate  Desc limit 5';
        }
        else{
            query = 'select Id,Name from '  + inputWrapper.objectApiName + ' Where Key_Account_Id__c =: keyAccountId  AND RecordType.DeveloperName != \'Bill_To_Client\'  Order By LastModifiedDate  Desc limit 5 ';
        }
        system.debug('query'+query);
        list<sobject> listOfRecentRecords = Database.query(query);
        List<ResultWrapper> returnWrapperList = new List<ResultWrapper>();
        for(Sobject s : listOfRecentRecords) {
            ResultWrapper wrap = new ResultWrapper();
            wrap.mainField = (String)s.get(inputWrapper.fieldApiName);
            // wrap.subField = (String)s.get(inputWrapper.otherFieldApiName);
            wrap.id = (String)s.get('id');
            returnWrapperList.add(wrap);
        }
        return returnWrapperList;
    }
    
    
    public class ResultWrapper{
        @AuraEnabled public String mainField{get;set;}
        @AuraEnabled public String subField{get;set;}
        @AuraEnabled public String id{get;set;}
    }
    
    public class SearchWrapper {
        @AuraEnabled public String objectApiName{get;set;}
        @AuraEnabled public String fieldApiName{get;set;}
        @AuraEnabled public String otherFieldApiName{get;set;}
        @AuraEnabled public String searchString{get;set;}
        @AuraEnabled public String selectedRecordId{get;set;}
        @AuraEnabled public String parentRecordId{get;set;}
        @AuraEnabled public String parentFieldApiName{get;set;}
        @AuraEnabled public String filter{get;set;}
    }
}