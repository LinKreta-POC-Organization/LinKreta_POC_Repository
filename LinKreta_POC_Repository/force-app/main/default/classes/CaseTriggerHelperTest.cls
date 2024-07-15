@isTest
private class CaseTriggerHelperTest {
    
    @isTest
    static void testUpdateStatusOnCase() {
        
        List<Case> testCases = new List<Case>();
        for (Integer i = 0; i < 5; i++) {
            Case testCase = new Case(Status = 'New');
            testCase.Industry__c = 'Agriculture';
            testCase.SuppliedName = 'Test Name';
            testCase.SuppliedEmail = 'test@example.com';
            testCase.Website__c = 'www.example.com';
            testCase.Client_Name__c = 'Test Client';
            testCase.SuppliedPhone = '1234567890';
            testCase.Country_Code__c = 'Algeria (+213)';
            testCases.add(testCase);
        }
        
        Test.StartTest();
        insert testCases;
        update testCases;
        CaseTriggerHelper.updateStatusOnCase(testCases);
        Test.StopTest();
        for (Case testCase : testCases) {
            System.assertEquals('In Progress', testCase.Status);
        }
    }
    
    @isTest
    static void testAfterUpdateMethod() {
        
        List<Case> testCases = new List<Case>();
        for (Integer i = 0; i < 2; i++) {
            Case testCase = new Case(
                Status = 'New',
                Industry__c = 'Agriculture',
                SuppliedName = 'Test Name',
                SuppliedEmail = 'test@example.com',
                Website__c = 'www.example.com',
                Client_Name__c = 'Test Client',
                SuppliedPhone = '1234567890',
                Country_Code__c = 'Algeria (+213)'
            );
            testCases.add(testCase);
        }
        
        
        Test.startTest();
        insert testCases;
        update testCases;
        CaseTriggerHelper.afterUpdateMethod(testCases);
        Test.stopTest();
        
      //  List<Lead> insertedLeads = [SELECT Id FROM Lead];
     //   System.assertNotEquals(5, insertedLeads.size());
    }
}