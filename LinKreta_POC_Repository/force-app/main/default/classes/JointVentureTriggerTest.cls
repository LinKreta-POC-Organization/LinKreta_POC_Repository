@isTest
public class JointVentureTriggerTest {
    @isTest
    public static void unitTest1(){
        Test.setMock(HttpCalloutMock.class, new ELControllerTest_Mock());
        Account accountRecord = TestDataFactory.createAccountRecord(); 
        accountRecord.Status__c = 'Active';   
        insert accountRecord; 
		        
     //   IntegratedEnquiry__c IntegratedEnquiryRecord = TestDataFactory.createIntegratedEnquiryRecord();   
      //  insert IntegratedEnquiryRecord;
    /*    
        SolutionPL__c solution = new SolutionPl__c(LOV__c = 'NA');
        Insert solution;
        ExpertisePL__c expertise = new ExpertisePL__c(Solution__c = solution.Id, LOV__c = 'NA');
        Insert expertise;
        SubExpertisePL__c subExpertise = new SubExpertisePL__c(LOV__c = 'NA', Expertise__c = expertise.Id);
        Insert subExpertise;
        SME_PL__c smeLU = new SME_PL__c(Sub_Expertise_PL__c = subExpertise.Id);
        INSERT smeLU;  
*/
	//	list<opportunity> oppList = TestDataFactory.createEnquiryRecord(accountRecord.id,IntegratedEnquiryRecord.id,smeLU.id);       
    //    insert oppList;
        
        
        Joint_Venture__c jvObj = new Joint_Venture__c(Name = 'Test JV 1',Client__c = accountRecord.Id);
        insert jvObj;
    }
}