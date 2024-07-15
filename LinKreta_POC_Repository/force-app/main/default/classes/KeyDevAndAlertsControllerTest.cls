@isTest
public  class KeyDevAndAlertsControllerTest {
    @testSetup 
    static void dataCreation() { 
        
        GenericMockClass mock= new GenericMockClass (200,'success','{"statusCode":"200","statusMsg":"Record inserted Successfully","data":""}');
        Test.setMock(HttpCalloutMock.class,mock);
        Account gtClientGroupAccoount = TestDataFactory.createAccountRecord();
        gtClientGroupAccoount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('GT_Client_Group').getRecordTypeId();
        insert gtClientGroupAccoount ;
        
        
        List<Lead> leadList = new List<Lead>();
        Lead leadRecord =  TestDataFactory.createLeadRecord();
        leadRecord.Industry_Leader__c =UserInfo.getUserId();
        leadRecord.Industry__c ='Banking';
        leadRecord.capIQId__c ='test';
        leadRecord.MCA_ID__c ='test';
        leadList.add(leadRecord);
        Lead leadRecord1 =  TestDataFactory.createLeadRecord();
        leadRecord1.Industry_Leader__c =UserInfo.getUserId();
        leadRecord1.Industry__c ='Banking';
        leadList.add(leadRecord1);
        insert leadList;

        List<Client_News__c> clientNewsList = new List<Client_News__c>();
        Client_News__c  news  =TestDataFactory.createClientNews();
        news.New_Client__c =leadRecord.Id;
        news.severity__c = 'test';
        news.Case_Number__c = 'test';
        clientNewsList.add(news);
       
        Client_News__c  news1  =TestDataFactory.createClientNews();
        news1.New_Client__c =leadRecord1.Id;
        news1.severity__c = 'test';
        news1.Case_Number__c = 'test';
        clientNewsList.add(news1);
        List<Account> accountList =new List<Account>();
        Account acc =TestDataFactory.createAccountRecord();
        acc.Status__c='Active';
        acc.Country_Corridor__c = 'Afghanistan';
        acc.Corridor__c ='NA';
        acc.Status_DS_Team_Remark_Status__c = 'Pending';
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Client').getRecordTypeId();
        acc.DS_Team_Approval_Status__c ='Pending with DS';
        acc.GT_Client_Group__c = gtClientGroupAccoount.Id;
        acc.Website ='WWW.google.com';
        acc.Industry__c ='Agriculture';

        acc.ClientAddress__Street__s = 'test,test';
        acc.ClientAddress__City__s ='test';
        acc.ClientAddress__PostalCode__s ='12345';
        acc.ClientAddress__StateCode__s ='CT' ;
        acc.ClientAddress__CountryCode__s =  'IN';
        acc.capIQId__c ='test';
        accountList.add(acc);

        Account acc1 =TestDataFactory.createAccountRecord();
        acc1.Status__c='Active';
        acc1.Country_Corridor__c = 'Afghanistan';
        acc1.Corridor__c ='NA';
        acc1.Status_DS_Team_Remark_Status__c = 'Pending';
        acc1.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Client').getRecordTypeId();
        acc1.DS_Team_Approval_Status__c ='Pending with DS';
        acc1.GT_Client_Group__c = gtClientGroupAccoount.Id;
        acc1.Website ='WWW.google.com';
        acc1.Industry__c ='Agriculture';

        acc1.ClientAddress__Street__s = 'test,test';
        acc1.ClientAddress__City__s ='test';
        acc1.ClientAddress__PostalCode__s ='12345';
        acc1.ClientAddress__StateCode__s ='CT' ;
        acc1.ClientAddress__CountryCode__s =  'IN';
        acc1.MCA_ID__c ='test';
        accountList.add(acc1);

        Account keyAccount =TestDataFactory.createAccountRecord();
        
        //keyAccount.Country_Corridor__c = 'Afghanistan';
        //keyAccount.Corridor__c ='Others';
        //keyAccount.Key_Account_Category__c ='Key Account -GX';
       // keyAccount.Client_Sub_Category__c ='GX - Platinum';
        keyAccount.Name ='testKey Account';
        keyAccount.RecordTypeId =   Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get(ConstantUtility.KEY_ACCOUNT).getRecordTypeId();
        accountList.add(keyAccount);
        insert accountList;

        
        AccountTeamMember CTMFirst = TestDataFactory.createAccountTeamMember(keyAccount.Id);
        CTMFirst.TeamMemberRole = 'Key Account – CSL';
        CTMFirst.CaseAccessLevel = 'Read';
        CTMFirst.ContactAccessLevel = 'Read';
        CTMFirst.OpportunityAccessLevel = 'Edit';
        insert CTMFirst;

        Account gtClintGroup  =TestDataFactory.createAccountRecord();
        gtClintGroup.Key_Account_360__c = keyAccount.Id;
        gtClintGroup.Name='gt Cint test ';
        gtClintGroup.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('GT_Client_Group').getRecordTypeId();
        
        insert gtClintGroup;

        Account clint1 =TestDataFactory.createAccountRecord();
        clint1.Name ='testClint1w';
        clint1.Status__c='Active';
        clint1.Country_Corridor__c = 'Afghanistan';
        clint1.Corridor__c ='NA';
        clint1.Status_DS_Team_Remark_Status__c = 'Pending';
        clint1.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Client').getRecordTypeId();
        clint1.DS_Team_Approval_Status__c ='Pending with DS';
        clint1.GT_Client_Group__c = gtClintGroup.Id;
        clint1.Website ='WWW.google.com';
        clint1.Industry__c ='Agriculture';

        clint1.ClientAddress__Street__s = 'test,test';
        clint1.ClientAddress__City__s ='test';
        clint1.ClientAddress__PostalCode__s ='12345';
        clint1.ClientAddress__StateCode__s ='CT' ;
        clint1.ClientAddress__CountryCode__s =  'IN';
        
        insert clint1;
        Test.StartTest();

     //   IntegratedEnquiry__c integratedEnquiryRecord = TestDataFactory.createIntegratedEnquiryRecord();
     //   Insert integratedEnquiryRecord;


      //  List<Opportunity> oppList = TestDataFactory.createEnquiryRecord(acc.Id,integratedEnquiryRecord.Id,null);
      //  oppList[0].SubIndustry__c = null;
      //  insert oppList[0];


        Client_News__c  newsAcc  =TestDataFactory.createClientNews();
        newsAcc.Client__c =acc.Id;
        newsAcc.severity__c = 'test';
        clientNewsList.add(newsAcc);
        Client_News__c  newsAcc1  =TestDataFactory.createClientNews();
        newsAcc1.Client__c =acc1.Id;
        newsAcc1.severity__c = 'test';
        clientNewsList.add(newsAcc1);

        insert clientNewsList;
        Test.StopTest();

        

    }
    @isTest static void testGetNewClient(){
        Test.StartTest();
        List<lead> leadList = [SELECT Id FROM Lead ];
        KeyDevAndAlertsController.getNewClient(leadList[0].Id,'Lead');
        KeyDevAndAlertsController.getNewClient(leadList[1].Id,'Lead');
        Test.StopTest();
         
    }
    @isTest static void testGetNewClient1(){
        Test.StartTest();
        List<Account>  accountList= [SELECT Id FROM Account];
        KeyDevAndAlertsController.getNewClient(accountList[0].Id,'Account');
        KeyDevAndAlertsController.getNewClient(accountList[1].Id,'Account');
        KeyDevAndAlertsController.getNewClient(accountList[2].Id,'Account');
        Test.StopTest();
         
    }
 /*   @isTest static void testGetNewClient2(){
        Test.StartTest();
        List<Opportunity> opportunityList= [SELECT Id FROM Opportunity];
        KeyDevAndAlertsController.getNewClient(opportunityList[0].Id,'Opportunity');
        Test.StopTest(); 
    }
*/
    @isTest static void testGetNewClientMCA(){
        Test.StartTest();
        List<lead> leadList = [SELECT Id FROM Lead ];
        KeyDevAndAlertsController.getNewClientMCA(leadList[0].Id,'Lead');
        KeyDevAndAlertsController.getNewClientMCA(leadList[1].Id,'Lead');
        Test.StopTest(); 
    }
   /*
    @isTest static void testGetNewClientMCA1(){
        Test.StartTest();
        List<Opportunity> opportunityList= [SELECT Id FROM Opportunity];
        KeyDevAndAlertsController.getNewClientMCA(opportunityList[0].Id,'Opportunity');
        Test.StopTest(); 
    }
*/ 
    @isTest static void testGetNewClientMCACourtCase(){
        Test.StartTest();
        List<lead> leadList = [SELECT Id FROM Lead ];
        KeyDevAndAlertsController.getNewClientMCACourtCase(leadList[0].Id,'Lead');
        KeyDevAndAlertsController.getNewClientMCACourtCase(leadList[1].Id,'Lead');
        Test.StopTest(); 
    }
    
    /* Start : Commented by Rakesh Kumar for Phase-1    
     * 9/4/24                                       
	  
    @isTest static void testGetNewClientMCACourtCase1(){

        Test.StartTest();
        List<Opportunity> opportunityList= [SELECT Id FROM Opportunity];
        KeyDevAndAlertsController.getNewClientMCACourtCase(opportunityList[0].Id,'Opportunity');
        Test.StopTest(); 
    }
End : Commented by Rakesh Kumar for Phase-1  
*/
    @isTest static void testGetAccount(){
        Test.StartTest();
        List<Account>  accountList= [SELECT Id,RecordTypeId,RecordType.Name FROM Account];
        for(Account acc : accountList){
            KeyDevAndAlertsController.getAccount(acc.Id);
        }
        //KeyDevAndAlertsController.getAccount(accountList[0].Id);
        //KeyDevAndAlertsController.getAccount(accountList[1].Id);
        //KeyDevAndAlertsController.getAccount(accountList[2].Id);
        //KeyDevAndAlertsController.getAccount(accountList[3].Id);
        Test.StopTest();
         
    }

    
}