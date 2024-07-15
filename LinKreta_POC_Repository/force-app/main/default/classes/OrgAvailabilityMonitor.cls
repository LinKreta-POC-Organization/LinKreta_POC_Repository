public with sharing class OrgAvailabilityMonitor {
    
    @AuraEnabled(cacheable=true)
    public static List<OrgAvailabilityMonitor__c> getOrgAvailabilityMonitors() {

        return [SELECT Id, Name, Portfolio_Name__c, Feature_Name__c, Monitoring_URL__c FROM OrgAvailabilityMonitor__c WITH SECURITY_ENFORCED ORDER BY Portfolio_Name__c, Name, Feature_Name__c ];
        
    }

}