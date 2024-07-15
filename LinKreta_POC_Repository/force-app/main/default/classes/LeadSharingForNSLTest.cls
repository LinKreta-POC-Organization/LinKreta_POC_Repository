@isTest
private class LeadSharingForNSLTest {

    @isTest
    static void testLeadRecordSharingToNSL() {
        // Create a test user to represent the Industry Leader
        User industryLeaderUser = TestDataFactory.createUserRecord();
        insert industryLeaderUser;

        // Create a test lead record
        Lead testLead = new Lead(
            FirstName = 'Test',
            LastName = 'Lead',
            Company = 'Tata Communications',
            Industry_Leader__c = industryLeaderUser.Id,
            Industry__c ='Banking'
        );
        insert testLead;

        // Create a map of old Lead records for the test lead
        Map<Id, Lead> oldLeadMap = new Map<Id, Lead>{ testLead.Id => new Lead(Industry_Leader__c = null) };

        // Call the method from the main class
        Test.startTest();
        leadSharingForNSL.leadRecordSharingToNSL(new List<Id>{ testLead.Id }, oldLeadMap);
        Test.stopTest();
        
    }

    @isTest
    static void testLeadRecordSharingToSectorCordinator() {
        // Create a test user to represent the Industry Business Partner
        User businessPartnerUser = TestDataFactory.createUserRecord();
        businessPartnerUser.FirstName = 'Business';
        businessPartnerUser.LastName = 'Partner';
        
        insert businessPartnerUser;

        // Create a test lead record
        Lead testLead = new Lead(
            FirstName = 'Test',
            LastName = 'Lead',
            Industry_Business_Partner__c = businessPartnerUser.Id,
            Company ='test nsal'
        );
        insert testLead;

        // Create a map of old Lead records for the test lead
        Map<Id, Lead> oldLeadMap = new Map<Id, Lead>{ testLead.Id => new Lead(Industry_Business_Partner__c = null) };

        // Call the method from the main class
        Test.startTest();
        leadSharingForNSL.leadRecordSharingToSectorCordinator(new List<Id>{ testLead.Id }, oldLeadMap);
        Test.stopTest();

        
    }
}