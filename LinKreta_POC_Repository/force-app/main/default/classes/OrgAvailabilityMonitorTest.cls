@isTest
private with sharing class OrgAvailabilityMonitorTest {

    @isTest static void testGetOrgAvailabilityMonitors() {

        // Create some test data
        List<OrgAvailabilityMonitor__c> orgAvailabilityMonitors = new List<OrgAvailabilityMonitor__c>();

        for (Integer i = 0; i < 10; i++) {
            orgAvailabilityMonitors.add(new OrgAvailabilityMonitor__c(Feature_Name__c = 'Feature Name: ' + i, 
                                                                        Monitoring_URL__c = 'Monitoring_URL_' + i + '.html', 
                                                                        Name = 'Program Name ' + i, 
                                                                        Portfolio_Name__c = 'Portfolio Name ' + i));
        }

        insert orgAvailabilityMonitors;

        // Invoke the method to test
        List<OrgAvailabilityMonitor__c> result = OrgAvailabilityMonitor.getOrgAvailabilityMonitors();

        // Verify the result
        System.assertEquals(10, result.size(), 'The number of Org Availability Monitors should be 10');

        for (Integer i = 0; i < 10; i++) {
            System.assertEquals(orgAvailabilityMonitors[i].Id, result[i].Id, 'The OrgAvailabilityMonitor Id should match');
            System.assertEquals(orgAvailabilityMonitors[i].Feature_Name__c, result[i].Feature_Name__c, 'The Feature_Name__c should match');
            System.assertEquals(orgAvailabilityMonitors[i].Monitoring_URL__c, result[i].Monitoring_URL__c, 'The Monitoring_URL__c should match');
            System.assertEquals(orgAvailabilityMonitors[i].Name, result[i].Name, 'The Program Name should match');
            System.assertEquals(orgAvailabilityMonitors[i].Portfolio_Name__c, result[i].Portfolio_Name__c, 'The Portfolio_Name__c should match');
        }
    }
}