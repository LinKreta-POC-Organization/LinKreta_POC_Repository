public with sharing class KeyAlertAndDevelopmentForClietController {
    @AuraEnabled(cacheable=true)
    public static List<Client_News__c> getClientNews(String clientId){
        return [SELECT Id, Name , IQ_KEY_DEV_HEADLINE__c,IQ_KEY_DEV_TYPE__c,Key_Development_Date__c,Alert__c, Case_Number__c,convictedDirectors__c,remarks_details__c,severity__c From Client_News__c Where Client__c =:clientId];
    }
    public KeyAlertAndDevelopmentForClietController() {

    }
}