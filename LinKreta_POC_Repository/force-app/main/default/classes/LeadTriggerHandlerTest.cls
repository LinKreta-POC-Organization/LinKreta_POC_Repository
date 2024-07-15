@isTest
public class LeadTriggerHandlerTest {
  @TestSetup
    static void dataCreation() { 
        GenericMockClass mock= new GenericMockClass (200,'success','{"statusCode":"200","statusMsg":"Record inserted Successfully","data":""}');
        Test.setMock(HttpCalloutMock.class,mock);
        List<Lead> leadList = new List<Lead>();
        Lead leadRecord =  TestDataFactory.createLeadRecord();
        leadRecord.Industry_Leader__c =UserInfo.getUserId();
        leadRecord.Industry__c ='Banking';
        leadRecord.Status = 'NotAccept';
        leadRecord.Reject_Reason__c = 'No response';
        leadRecord.Reject_Reason__c = 'No response';
        leadRecord.Email ='Test32@233test.com';
        leadRecord.CountryCode__c ='India (+91)';
        leadList.add(leadRecord);
        /*Lead leadRecord1 =  TestDataFactory.createLeadRecord();
        leadRecord1.Industry_Leader__c =UserInfo.getUserId();
        leadRecord1.Industry__c ='Banking';
        leadRecord1.LeadSource='Manual';
        leadRecord1.Channel__c  ='Client Referral';
        leadRecord1.IsPardot__c='Pardot';
        leadRecord1.pi__campaign__c ='Test campaignObj';
        leadList.add(leadRecord1);*/
       
        insert leadList;

        Campaign  campaignObj = TestDataFactory.createCampaign();
        campaignObj.Name ='Test campaignObj';
        insert campaignObj;

    } 
    @isTest static void testUpdate(){
        Test.startTest();
        GenericMockClass mock= new GenericMockClass (200,'success','{"statusCode":"200","statusMsg":"Record inserted Successfully","data":""}');
        Test.setMock(HttpCalloutMock.class,mock);
        Lead leadObj = [SELECT Id FROM Lead LIMIT 1];  
        //leadObj.IndustryLeaderApprovalStatus__c ='Approved'; //Phase-1
        leadObj.WCGTStatus__c = 1;
        update leadObj;
        Test.stopTest();    
         
     } 
     @isTest static void testUpdate1(){
        Test.startTest();
        GenericMockClass mock= new GenericMockClass (200,'success','{"statusCode":"200","statusMsg":"Record inserted Successfully","data":""}');
        Test.setMock(HttpCalloutMock.class,mock);
        Lead leadObj = [SELECT Id FROM Lead LIMIT 1];  
        leadObj.Category__c ='Cold';
        update leadObj;   
        Test.stopTest(); 
         
     } 
     @isTest static void testUpdate2(){
        Test.startTest();
        GenericMockClass mock= new GenericMockClass (200,'success','{"statusCode":"200","statusMsg":"Record inserted Successfully","data":""}');
        Test.setMock(HttpCalloutMock.class,mock);
        Lead leadObj = [SELECT Id FROM Lead LIMIT 1];  
       // leadObj.IndustryLeaderApprovalStatus__c ='Approved'; //Phase-1
        leadObj.WCGTStatus__c = null;
        update leadObj;   
        Test.stopTest(); 
         
     } 
     @isTest static void testUpdatePardot(){
        Test.startTest();
        GenericMockClass mock= new GenericMockClass (200,'success','{"statusCode":"200","statusMsg":"Record inserted Successfully","data":""}');
        Test.setMock(HttpCalloutMock.class,mock);
        Lead leadObj = [SELECT Id FROM Lead LIMIT 1];  
        leadObj.IsPardot__c='Pardot';
        leadObj.pi__campaign__c ='Test campaignObj';
        update leadObj;   
        Test.stopTest(); 
         
     } 
     @isTest static void testUpdate3(){
        Test.startTest();
        GenericMockClass mock= new GenericMockClass (200,'success','{"statusCode":"200","statusMsg":"Record inserted Successfully","data":""}');
        Test.setMock(HttpCalloutMock.class,mock);
        Lead leadObj = [SELECT Id FROM Lead LIMIT 1];  
        leadObj.Status ='Accept Client';
        //leadObj.CCApprovalStatus__c ='Approved';
        update leadObj;   
        Test.stopTest(); 
         
     } 
     @isTest static void testUpdate4(){
        Test.startTest();
        GenericMockClass mock= new GenericMockClass (200,'success','{"statusCode":"200","statusMsg":"Record inserted Successfully","data":""}');
        Test.setMock(HttpCalloutMock.class,mock);
        Contact contactObj = TestDataFactory.createContactRecord();
        contactObj.Contact_status__C = 'Active';
        insert contactObj;
        System.Debug('** Test contactObj   '+contactObj);
       // IntegratedEnquiry__c intg =  TestDataFactory.createIntegratedEnquiryRecord();
        //intg.ClientContact__c = contactObj.Id;
      //  insert intg ;
       
        //System.Debug('** Test intg   '+intg);
        Lead leadRecord1 =  TestDataFactory.createLeadRecord();
        leadRecord1.Industry_Leader__c =UserInfo.getUserId();
        leadRecord1.Industry__c ='Banking';
        leadRecord1.LeadSource='Manual';
        leadRecord1.Channel__c  ='Client Referral';
        leadRecord1.IsPardot__c='Pardot';
        leadRecord1.pi__campaign__c ='Test campaignObj';
        leadRecord1.ClientContact__c = contactObj.Id;
        leadRecord1.CountryCode__c ='India (+91)';
        insert leadRecord1;
        System.Debug('** Test leadRecord1   '+leadRecord1);
        //  IntegratedEnquiry__c ie = [SELECT Id,Name,ClientContact__c FROM IntegratedEnquiry__c WHERE ClientContact__c=:leadRecord1.ClientContact__c LIMIT 1];
        //System.Debug('** Test ie   '+ie);
       
        Campaign  campaignObj = TestDataFactory.createCampaign();
        campaignObj.Name ='Test campaignObj';
        insert campaignObj;
        Test.stopTest();
         
     } 

     @isTest static void testUpdateCapIQId(){
        Test.startTest();
        GenericMockClass mock= new GenericMockClass (200,'success','{"statusCode":"200","statusMsg":"Record inserted Successfully","data":""}');
        Test.setMock(HttpCalloutMock.class,mock);
        Lead leadObj =  TestDataFactory.createLeadRecord();
        leadObj.Industry_Leader__c =UserInfo.getUserId();
        leadObj.Industry__c ='Banking';
        leadObj.Status = 'NotAccept';
        leadObj.Reject_Reason__c = 'No response';
        leadObj.Reject_Reason__c = 'No response';
        leadObj.Email ='Test32@233test.com';
        leadObj.capIQId__c='IQ314677034';
        leadObj.External_Database_Source__c = 'CapIQ'; 
        leadObj.CountryCode__c ='India (+91)';
        insert leadObj;
        leadObj.capIQId__c='IQ707966458';
        
        update leadObj;
        Test.stopTest();           
     } 
     @isTest static void testUpdateEntityId(){
        Test.startTest();
        GenericMockClass mock= new GenericMockClass (200,'success','{"statusCode":"200","statusMsg":"Record inserted Successfully","data":""}');
        Test.setMock(HttpCalloutMock.class,mock);
        Lead leadObj =  TestDataFactory.createLeadRecord();
        leadObj.Industry_Leader__c =UserInfo.getUserId();
        leadObj.Industry__c ='Banking';
        leadObj.Status = 'NotAccept';
        leadObj.Reject_Reason__c = 'No response';
        leadObj.Reject_Reason__c = 'No response';
        leadObj.Email ='Test32@233test.com';
        leadObj.EntityId__c='L22210MH1995PLC084781';
        leadObj.External_Database_Source__c = 'MCA'; 
        leadObj.CountryCode__c ='India (+91)';
        insert leadObj;
        leadObj.EntityId__c='L27100MH1907PLC000260';
        
        update leadObj;
        Test.stopTest(); 
    } 
     @isTest static void testUpdateMCA_Id(){
        Test.startTest();
        GenericMockClass mock= new GenericMockClass (200,'success','{"statusCode":"200","statusMsg":"Record inserted Successfully","data":""}');
        Test.setMock(HttpCalloutMock.class,mock);
        Lead leadObj =  TestDataFactory.createLeadRecord();
        leadObj.Industry_Leader__c =UserInfo.getUserId();
        leadObj.Industry__c ='Banking';
        leadObj.Status = 'NotAccept';
        leadObj.Reject_Reason__c = 'No response';
        leadObj.Reject_Reason__c = 'No response';
        leadObj.Email ='Test32@233test.com';
        leadObj.MCA_ID__c='KCO000008144326G';
        leadObj.External_Database_Source__c = 'MCA'; 
        leadObj.CountryCode__c ='India (+91)';
        insert leadObj;
        leadObj.MCA_ID__c='KCO000008871309H';
        update leadObj;
        Test.stopTest(); 
     } 

     @isTest static void testUpdateIndustryLeader(){
        Test.startTest();
        GenericMockClass mock= new GenericMockClass (200,'success','{"statusCode":"200","statusMsg":"Record inserted Successfully","data":""}');
        Test.setMock(HttpCalloutMock.class,mock);
        Profile pf= [Select Id from profile where Name='System Administrator']; 
        User user =TestDataFactory.createUser(pf.Id);
        insert user;
        Lead leadObj = [SELECT Id FROM Lead LIMIT 1];  
        leadObj.Industry_Leader__c = user.Id;
        leadObj.Industry_Business_Partner__c =user.Id;
        update leadObj;
        Test.stopTest();
    }
    @isTest static void testWebsite(){
        Test.startTest();
        GenericMockClass mock= new GenericMockClass (200,'success','{"statusCode":"200","statusMsg":"Record inserted Successfully","data":""}');
        Test.setMock(HttpCalloutMock.class,mock);
        Lead leadRecord1 =  TestDataFactory.createLeadRecord();
        leadRecord1.Industry_Leader__c =UserInfo.getUserId();
        leadRecord1.Industry__c ='Banking';
        leadRecord1.LeadSource='Website';
        leadRecord1.Email ='Banking@te77st.com';
        leadRecord1.Channel_query_Request_Type__c = 'Services';
        leadRecord1.CountryCode__c ='India (+91)';
        insert leadRecord1;
        List<Lead> lstLead = new List<Lead>();
        lstLead.add(leadRecord1);
        LeadTriggerHandler.isBeforeDelete(lstLead);
        Test.stopTest();
         
     } 
     /*
     @isTest static void testUpdateIApprovalStatus(){
        Test.startTest();
        GenericMockClass mock= new GenericMockClass (200,'success','{"statusCode":"200","statusMsg":"Record inserted Successfully","data":""}');
        Test.setMock(HttpCalloutMock.class,mock);
        Lead leadRecord =  TestDataFactory.createLeadRecord();
        leadRecord.Industry_Leader__c =UserInfo.getUserId();
        leadRecord.Industry__c ='Banking';
        //leadRecord.Status = 'NotAccept';
        leadRecord.Email ='Test32@233test.com';
        //leadRecord.IndustryLeaderApprovalStatus__c = 'Approved'; //Phase-1
       // leadRecord.Expertise_LT__c = 'test';
        //leadRecord.SMEG_LT__c ='test';
        leadRecord.Company ='testyuong';
        leadRecord.ClientBackground__c = '1';
        leadRecord.GrowthPotential__c = '2';
        leadRecord.TentativeFee__c =  1;
        leadRecord.HowDidYouArriveAThisTentativeFee__c = 'testyuong';
        leadRecord.ShortSummary__c = 'testyuong';
        leadRecord.CountryCode__c ='India (+91)';
        leadRecord.MobilePhone = 
        
        insert  leadRecord;
        List<Task> taskList =new List<Task>();
        Task task =  TestDataFactory.createTaskRecord();
        task.WhoId =leadRecord.Id;
        task.Subject = 'Enrichment of Segmentation Details of New Client';
        taskList.add(task);
        Task task1 =  TestDataFactory.createTaskRecord();
        task1.WhoId =leadRecord.Id;
        task1.Subject = 'Next steps & actions discussed with NSL';
        taskList.add(task1);
        Task task2 =  TestDataFactory.createTaskRecord();
        task2.WhoId =leadRecord.Id;
        task2.Subject = 'NSL Discussion Pending';
        taskList.add(task2);

        Task task3 =  TestDataFactory.createTaskRecord();
        task3.WhoId =leadRecord.Id;
        task3.Subject = 'New Client Owner based on NSL discussion';
        taskList.add(task3);

        Task task4 =  TestDataFactory.createTaskRecord();
        task4.WhoId =leadRecord.Id;
        task4.Subject = 'Client Engagement';
        taskList.add(task4);

        Task task5 =  TestDataFactory.createTaskRecord();
        task5.WhoId =leadRecord.Id;
        task5.Subject = 'Client Take-On Preparation Deck';
        taskList.add(task5);
        


        
        insert taskList;
        leadRecord.Status = 'Internal / External Discussions';
        //leadRecord.IL_ApprovalRejectionRecommendation__c ='test';// Phase-1
        //leadRecord.CCApprovalRejectionRecommendation__c = 'test'; // Phase-1
        update leadRecord;
        Test.stopTest(); 
     } 
     */
   /*  @isTest static void testApprove(){
        GenericMockClass mock= new GenericMockClass (200,'success','{"statusCode":"200","statusMsg":"Record inserted Successfully","data":""}');
        Test.setMock(HttpCalloutMock.class,mock);
        Lead leadObj = [SELECT Id FROM Lead LIMIT 1]; 
        Approval.ProcessSubmitRequest app = new Approval.ProcessSubmitRequest();
        app.setObjectId(leadObj.id);
       // app.setProcessDefinitionNameOrId('test');
        app.setComments('Approv');
        Approval.ProcessResult result = Approval.process(app);
    } */
     
}