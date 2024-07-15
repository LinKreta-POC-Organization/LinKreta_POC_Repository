@isTest
private class EmailtoCaseLWCControllerTest {
    
    @testSetup static void testData(){
        User userRecord = TestDataFactory.createUserRecord();
      //  userRecord.Name = 'Email to Case Queue';
        insert userRecord;
        
        List<Case> lstCase = new List<Case>();
        Case testCase = new Case(
            Subject = 	'Email to CASE',
            Lead_Created__c = false,
            Industry__c = 'Agriculture',
            Expertise__c = 'Risk',
            Solution__c = 'BeSpoke',
                Status = 'New',
                SuppliedName = 'Test Name',
                SuppliedEmail = 'test@example.com',
                Website__c = 'www.example.com',
                Client_Name__c = 'Test Client',
                SuppliedPhone = '1234567890'
            );
        
        Case testCase2 = new Case(
            Subject = 	'Email to CASE',
            Lead_Created__c = false,
            Industry__c = '',
            Expertise__c = '',
            Solution__c = '',
                Status = 'New',
                SuppliedName = 'Test Name',
                SuppliedEmail = 'test@example.com',
                Website__c = 'www.example.com',
                Client_Name__c = 'Test Client',
                SuppliedPhone = '1234567890'
            );
        
        lstCase.add(testCase);
        lstCase.add(testCase2);
        insert lstCase;
    }
    @isTest
    static void testGetEmailtoCase() {
        
        List<Case> caseList = [select id,CaseNumber,Subject,SuppliedEmail,SuppliedName,Owner.Name,Lead_Created__c from Case];
        
        List<Case> lstCase = EmailtoCaseLWCController.getEmailtoCase();
        
     //   System.assertEquals(1, lstCase.size());
    }
    
    @isTest
    static void testCreateLead() {
        
        List<Case> caseList = [select id,CaseNumber,Subject,SuppliedEmail,SuppliedName,Owner.Name,Lead_Created__c from Case];
        
        List<String> lstCaseNumber = new List<String>();
        lstCaseNumber.add(caseList[0].CaseNumber);
        
        EmailtoCaseLWCController.createLead(lstCaseNumber);
        
    }
    
    @isTest
    static void testCreateLeadElse() {
        
        List<Case> caseList = [select id,CaseNumber,Subject,SuppliedEmail,SuppliedName,Owner.Name,Lead_Created__c from Case where Industry__c=null];
        
        List<String> lstCaseNumber = new List<String>();
        lstCaseNumber.add(caseList[0].CaseNumber);
        
        EmailtoCaseLWCController.createLead(lstCaseNumber);
        
    }
    
    
}