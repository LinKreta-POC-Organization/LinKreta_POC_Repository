/*
AUTHOR                   : Deepak joshi
VERSION                  : 1
MODIFICATION DATE        : 21 september 2023
PROJECT NAME / TICKET #  : GT
DESCRIPTION              : AccountTriggerHelperTest test class
*/
@isTest
public  class AccountTriggerHelperTest {  
    @testSetup static void dataCreation() {
        GenericMockClass mock= new GenericMockClass (200,'success','{"statusCode":"200","statusMsg":"Record inserted Successfully","data":""}');
        Test.setMock(HttpCalloutMock.class,mock);
        Entity_Type_Master__c entityTypeMasterRec = TestDataFactory.createEntityTypeMaster();
        INSERT entityTypeMasterRec;
        List<Account> accountList =new List<Account>();
        
        Account keyAccount = TestDataFactory.createAccountRecord();
        keyAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Key Account').getRecordTypeId();
        keyAccount.VerrifiedByDSTeam__c = false;
        keyAccount.DS_Team_Approval_Status__c ='Pending with DS';
        keyAccount.Segment__c = 'Government';
        keyAccount.Sub_Segment__c = 'Government';
        accountList.add(keyAccount);
        Account gtClientGroupAccoount = TestDataFactory.createAccountRecord();
        gtClientGroupAccoount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('GT_Client_Group').getRecordTypeId();
        accountList.add(gtClientGroupAccoount);       
        
        Account acc = TestDataFactory.createAccountRecord();
        acc.Country_Corridor__c = 'Afghanistan';
        acc.Corridor__c ='NA';
        acc.Status_DS_Team_Remark_Status__c = 'Pending';
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Client').getRecordTypeId();
        acc.DS_Team_Approval_Status__c ='Pending with DS';
        acc.GT_Client_Group__c = accountList[1].Id;
        acc.Website ='WWW.google.com';
        acc.Industry__c ='Agriculture';
        //acc.SubIndustry__c ='Agricultural productss';
        acc.Status__c ='Active';
        
        acc.ClientAddress__Street__s = 'test,test';
        acc.ClientAddress__City__s ='test';
        acc.ClientAddress__PostalCode__s ='12345';
        acc.ClientAddress__StateCode__s ='CT' ;
        acc.ClientAddress__CountryCode__s =  'IN';
        
        accountList.add(acc);
        
        Account accBillToClint = TestDataFactory.createAccountRecord();
        accBillToClint.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Channels_and_Alliances').getRecordTypeId();
        accBillToClint.ClientAddress__Street__s = 'test,test';
        accBillToClint.ClientAddress__City__s ='test';
        accBillToClint.ClientAddress__PostalCode__s ='12345';
        accBillToClint.ClientAddress__StateCode__s ='CT' ;
        accBillToClint.ClientAddress__CountryCode__s =  'IN';
        accBillToClint.Name ='testbilltocltes';
        //accountList.add(accBillToClint);
        INSERT accountList;
        /*
Bill_To_Contact__c billToClient = TestDataFactory.createBillToClient(accBillToClint.Id);
billToClient.Contact_Address__Street__s = 'test,test';
billToClient.Contact_Address__City__s ='test';
billToClient.Contact_Address__PostalCode__s ='12345';
billToClient.Contact_Address__StateCode__s ='CT' ;
billToClient.Contact_Address__CountryCode__s =  'IN';
billToClient.FirstName__c = 'tttest';
billToClient.LastName__c ='billto Last';


insert billToClient;
*/
        Approval.ProcessSubmitRequest app = new Approval.ProcessSubmitRequest();
        app.setObjectId(acc.id);
        Approval.ProcessResult result = Approval.process(app);
        AccountTeamMember  accountTeamMemberRec = TestDataFactory.createAccountTeamMember(acc.Id);
        accountTeamMemberRec.TeamMemberRole ='Key Account – CSL';
        accountTeamMemberRec.ContactAccessLevel ='Read';
        accountTeamMemberRec.OpportunityAccessLevel ='Edit';
        accountTeamMemberRec.CaseAccessLevel ='Edit';
        accountTeamMemberRec.AccountId =keyAccount.Id;
        Test.startTest();
        INSERT accountTeamMemberRec;
        Test.stopTest();
       
        /*
        IntegratedEnquiry__c integratedEnquiryRecord = TestDataFactory.createIntegratedEnquiryRecord();
        Insert integratedEnquiryRecord;
        
        SolutionPL__c solutionRecord=new SolutionPl__c(LOV__c = 'NA');
        Insert solutionRecord;
        
        ExpertisePL__c expertiseRecord=new ExpertisePL__c(Solution__c = solutionRecord.Id, LOV__c = 'NA');
        Insert expertiseRecord;
        
        SubExpertisePL__c subExpertiseRecord=new SubExpertisePL__c(LOV__c = 'NA', Expertise__c = expertiseRecord.Id);
        Insert subExpertiseRecord;
        
        SME_PL__c smeLURecord = new SME_PL__c(Sub_Expertise_PL__c = subExpertiseRecord.Id);
        INSERT smeLURecord;
        List<Opportunity> enquiryList = TestDataFactory.createEnquiryRecord(acc.Id,integratedEnquiryRecord.Id,smeLURecord.Id);
        enquiryList[0].ExpectedRecovery__c =80;
        insert enquiryList[0];
*/
        
    }
    @isTest static void updateClient() {
        Entity_Type_Master__c entityTypeMasterRec =[SELECT Id FROM Entity_Type_Master__c LIMIT 1];
        List<Account> accountList =[SELECT Id,RecordTypeId FROM Account];
        System.debug('TEst accountList  '+accountList);
        accountList[0].VerrifiedByDSTeam__c = true;
        accountList[0].Name = 'Test name update';
        accountList[0].DS_Team_Approval_Status__c = 'DS Approved';
        
        
        accountList[0].RecordTypeId = accountList[1].RecordTypeId;
        UPDATE accountList[0];
        accountList[0].DS_Team_Approval_Status__c= 'DS Rejected';
        //UPDATE accountList[0];
        
        
        //accountList[1].Key_Account_360__c = accountList[0].Id;
        
        accountList[2].Status_DS_Team_Remark_Status__c = 'Approved';
        accountList[2].DS_Team_Approval_Status__c = 'DS Approved';
        /*accountList[2].Entity_Type_Master__c =entityTypeMasterRec.Id;
accountList[2].Total_Revenue__c = 50000;
accountList[2].Country_HQ__c ='India';
accountList[2].Sector__c ='Auto & Auto Components';
accountList[2].Pan_No__c = '123';
accountList[2].Total_No_of_employees__c ='1';
accountList[2].ShareCapitalInCr__c =500;
accountList[2].GT_Client_Group__c = accountList[1].Id;
accountList[2].Client_s_Headquarter__City__s ='Jaipur';
accountList[2].Client_s_Headquarter__PostalCode__s ='302012';
accountList[2].Client_s_Headquarter__Street__s ='Jan pat';*/
        accountList[2].Client_Background__c = 'test';
        Test.startTest();
        UPDATE accountList;
        Test.stopTest();
    }
    @isTest static void updateClient1() {
        List<Account> accountList =[SELECT Id FROM Account];
        System.debug('TEst accountList  '+accountList);
        accountList[0].VerrifiedByDSTeam__c = true;
        
        accountList[0].DS_Team_Approval_Status__c= 'DS Rejected';
        
        Approval.ProcessSubmitRequest app = new Approval.ProcessSubmitRequest();
        app.setObjectId(accountList[0].id);
        app.setProcessDefinitionNameOrId('DS_Team_Account_Approval_For_Other');
        app.setComments('Approv');
        Approval.ProcessResult result = Approval.process(app);
        Test.startTest();
        UPDATE accountList[0];
        Test.stopTest();
    }
    @isTest static void testDelete() {
        List<Account> accountList =[SELECT Id FROM Account];
        
        Test.startTest();
        delete accountList[0];
        Test.stopTest();
    }
    @isTest static void testUpdatePick() {
        List<Account> accountList =[SELECT Id FROM Account];
        Map<Id,Account> accMap = new Map<Id,Account>();
        accMap.Put(accountList[0].Id,accountList[0]);
        Test.startTest();
        accountList[0].Pick_Record__c=true;
        update accountList[0];
        AccountTriggerHelper.syncBillToClientWCGT(accountList,accMap);
            AccountTriggerHelper.updateClientFromBillToClient(accountList,accMap);
        AccountTriggerHelper.accTest();
        Test.stopTest();
    }
    /*
     * Commented by Suraj Kumar for Phase 1 dated [18-04-2024]
     * 
     @istest
    public static void testBillToClient(){
        Test.startTest();
        String recType = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Channels_and_Alliances').getRecordTypeId();  
        Account acc = [SELECT Id FROM Account WHERE RecordTypeId =: recType LIMIT 1];
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Client').getRecordTypeId();
        acc.Pan_No__c = '1234567891';
        acc.Segment__c = 'Large Corporate';
        update acc;
        
        Test.stopTest();
        
    }*/
    
    @istest
    public static void accountSyncToWCGTBatchTest(){
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new SalesforceToWCGTMockCallout());
        Account gtClientGroupAccoount = TestDataFactory.createAccountRecord();
        gtClientGroupAccoount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('GT_Client_Group').getRecordTypeId();
        gtClientGroupAccoount.name='testGt grouptt';
        insert gtClientGroupAccoount ;
        
        // Account keyAccoount = TestDataFactory.createAccountRecord();
        //keyAccoount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Key_Account').getRecordTypeId();
        // insert keyAccoount ;
        
        List<Account> accList = new List<Account>();
        List<Account> keyAccountList = new List<Account>();
        List<AccountTeamMember> teamMemberList = new List<AccountTeamMember>();
        for(integer i=0;i<42;i++){
            Account acc = TestDataFactory.createAccountRecord();
            acc.Name= 'test11tt '+i+ 'testt';
            acc.Country_Corridor__c = 'Afghanistan';
            acc.Corridor__c ='NA';
            acc.Status_DS_Team_Remark_Status__c = 'Pending';
            acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Client').getRecordTypeId();
            acc.DS_Team_Approval_Status__c ='Pending with DS';
            acc.GT_Client_Group__c = gtClientGroupAccoount.Id;
            acc.Website ='WWW.google.com';
            acc.Industry__c ='Sports';
            acc.SubIndustry__c ='Fitness facilities';
            acc.DS_Team_Approval_Status__c = 'DS Approved';
            accList.add(acc);
        }
        for(integer i=0;i<2;i++){
            Account keyAccoount = TestDataFactory.createAccountRecord();
            keyAccoount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Key_Account').getRecordTypeId();
            keyAccoount.Name ='ttTestKey '+i+' teskey';
            keyAccountList.add(keyAccoount);
            
        }
        insert accList;
        insert keyAccountList;
        
        for(Account keyAccount : keyAccountList){
            AccountTeamMember keyAccountCSL = TestDataFactory.createAccountTeamMember(keyAccount.Id);
            keyAccountCSL.TeamMemberRole = 'Key Account – CSL';
            teamMemberList.add(keyAccountCSL);
        }
        
        insert teamMemberList;
        
        accList[0].Key_Account_360__c = keyAccountList[0].Id;
        update accList;
        Test.stopTest();
        
    }
    
    
}