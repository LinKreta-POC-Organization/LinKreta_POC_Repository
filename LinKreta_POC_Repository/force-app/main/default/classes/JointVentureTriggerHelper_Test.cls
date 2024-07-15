/*
CreatedBy :Rakesh Kumar
Class - JointVentureTriggerHelper
Coverage - 
*/
@isTest
private class JointVentureTriggerHelper_Test {
    @isTest
    static void testcreateEnquiryJointVenture() {
        
        Account accRecord = TestDataFactory.createAccountRecord();
        accRecord.Status__c = 'Active';
        Insert accRecord;
     //  IntegratedEnquiry__c InEnqRecord = TestDataFactory.createIntegratedEnquiryRecord();
      //  Insert InEnqRecord;
    //    SolutionPL__c solutionRecord=new SolutionPl__c(LOV__c = 'NA');
    //    Insert solutionRecord;
        
     //   ExpertisePL__c expertiseRecord=new ExpertisePL__c(Solution__c = solutionRecord.Id, LOV__c = 'NA');
     //   Insert expertiseRecord;
        
    //    SubExpertisePL__c subExpertiseRecord=new SubExpertisePL__c(LOV__c = 'NA', Expertise__c = expertiseRecord.Id);
    //    Insert subExpertiseRecord;
    //    SME_PL__c smeLURecord = new SME_PL__c(Sub_Expertise_PL__c = subExpertiseRecord.Id);
    //    INSERT smeLURecord;
        
     //   List<Opportunity> EnqRecord = new List<Opportunity>();
      //  EnqRecord = TestDataFactory.createEnquiryRecord(accRecord.Id,InEnqRecord.Id,smeLURecord.Id);
      //  Insert EnqRecord;
        List<Id> lstId = new List<Id>();
       // for(Opportunity oppId : EnqRecord){
       //     lstId.add(oppId.Id);
       // }
        
       List<Joint_Venture__c> lstJointVenture = new  List<Joint_Venture__c>();
        Joint_Venture__c joint_ventureObj = new Joint_Venture__c(
            Name = 'KPMG',
            CurrencyIsoCode = 'INR',
            Client__c = accRecord.Id,
            ExternalDataSource__c = 'None');
        lstJointVenture.add(joint_ventureObj);
        insert joint_ventureObj;
        
     //   Insert new Enquiry_Joint_Venture__c(
       //                 Joint_Venture__c = joint_ventureObj.Id,
         //               Enquiry__c = lstId[0]);
                 
        try{
            Test.startTest();
        JointVentureTriggerHelper.createEnquiryJointVenture(lstJointVenture);
        Test.stopTest();
        }catch(Exception e){
            
        }
        

    }
    
    
}