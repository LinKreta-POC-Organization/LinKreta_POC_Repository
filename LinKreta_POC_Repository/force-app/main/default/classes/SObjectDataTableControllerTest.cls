@isTest
public class SObjectDataTableControllerTest {
    @testSetup static void dataCreation() {
        Id clientRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Client').getRecordTypeId();
        system.debug('clientRecordTypeId'+clientRecordTypeId);
        Id gtCLientRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('GT Client Group').getRecordTypeId();        
        Id KeyAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Key Account').getRecordTypeId();
        
        Account KeyAcc = TestDataFactory.createAccountRecord();
        KeyAcc.RecordTypeId = KeyAccountRecordTypeId;
        // KeyAcc.Client_Category__c = 'Key Account - GX';
        // KeyAcc.Client_Sub_Category__c = 'Gx - Gold';
        KeyAcc.Channel_Type__c ='Audit Client';
        KeyAcc.Segment__c = 'Government';
        KeyAcc.Industry__c ='Agriculture';
        insert KeyAcc;
        
        AccountTeamMember CTMFirst = TestDataFactory.createAccountTeamMember(KeyAcc.Id);
        CTMFirst.TeamMemberRole = 'Key Account – CSL';
        CTMFirst.ContactAccessLevel = 'Read';
        CTMFirst.CaseAccessLevel = 'Edit'; 
        CTMFirst.OpportunityAccessLevel = 'Edit';
        CTMFirst.AccountAccessLevel = 'Read';
        insert CTMFirst;
        
        Account GtAcc = TestDataFactory.createAccountRecord();
        GtAcc.RecordTypeId = gtCLientRecordTypeId;
        GtAcc.Key_Account_360__c = KeyAcc.Id;
        insert GtAcc;
        
        Account GtAcc1 = TestDataFactory.createAccountRecord();
        GtAcc1.Name = 'Name55';
        GtAcc1.RecordTypeId = gtCLientRecordTypeId;
        GtAcc.Key_Account_360__c = KeyAcc.Id;
        insert GtAcc1;
        
        Id UserId = UserInfo.getUserId() ;
        
        Account acc = TestDataFactory.createAccountRecord();
        acc.Name = 'Name88';
        acc.RecordTypeId = clientRecordTypeId;
        //acc.GSTIN__c = '00900';
        acc.Client_reason_if_inactive__c = 'testtttttt';
        acc.ClientStatus__c = 'Inactive';
        acc.GT_Client_Group__c = GtAcc.Id;
        acc.ClientAddress__Street__s = 'test,test';
        acc.ClientAddress__City__s ='test';
        acc.ClientAddress__PostalCode__s ='12345';
        acc.ClientAddress__StateCode__s ='CT' ;
        acc.ClientAddress__CountryCode__s =  'IN';
        
        //acc.AccountType__c = 'Key Account';
        
        insert acc;
        
        Account acc1 = TestDataFactory.createAccountRecord();
        acc1.Name = 'Name99';
        acc1.RecordTypeId = clientRecordTypeId;
        acc1.CSL__c = UserId;
        acc1.CoCSL__c = UserId;
        //acc1.GSTIN__c = '0090067788';
        acc1.Client_reason_if_inactive__c = 'test';
        //acc1.GSTIN__c = '12345';
        acc1.ClientStatus__c = 'Active';
        acc1.GT_Client_Group__c = GtAcc1.Id;
        acc1.ClientAddress__Street__s = 'test,test';
        acc1.ClientAddress__City__s ='test';
        acc1.ClientAddress__PostalCode__s ='12345';
        acc1.ClientAddress__StateCode__s ='CT' ;
        acc1.ClientAddress__CountryCode__s =  'IN';
        //acc1.AccountType__c = 'Key Account';
        
        insert acc1;
        
        Contact con1 = TestDataFactory.createContactRecord();
        con1.FirstName = 'BHavi';
        con1.LastName = 'Basant';
        con1.AccountId = acc1.Id;
        con1.Client_Location__Street__s = 'test,test';
        con1.Client_Location__City__s  ='test';
        con1.Client_Location__PostalCode__s = '12345';
        con1.Client_Location__StateCode__s = 'CT';
        con1.Client_Location__CountryCode__s = 'IN';
        insert con1;
        
        Contact con = TestDataFactory.createContactRecord();
        con.FirstName = 'BHavi1';
        con.LastName = 'Basant2';
        con.AccountId = acc.Id;
        con.Client_Location__Street__s = 'test,test';
        con.Client_Location__City__s  ='test';
        con.Client_Location__PostalCode__s = '12345';
        con.Client_Location__StateCode__s = 'CT';
        con.Client_Location__CountryCode__s = 'IN';
        insert con;
        
        /*SME_PL__c SMe = new SME_PL__c();
        Insert SMe;
            
        IntegratedEnquiry__c IntegratedEnquiryRec = TestDataFactory.createIntegratedEnquiryRecord();
        insert IntegratedEnquiryRec;
        
        Opportunity Enquiry = TestDataFactory.createEnquiryRecord(String(acc.Id) , String(IntegratedEnquiryRec.Id) , SMe.Id); 
        insert Enquiry;
        
        Job__c job =  TestDataFactory.createJob();
        job.ClientId__c = acc.Id;
        job.Enquiry__c = Enquiry.Id;
        insert job;
        
        Job__c job1 =  TestDataFactory.createJob();
        job1.ClientId__c = acc1.Id;
        insert job1;
*/
        
    }
    
    @isTest static void getAllRecordsTest() {
        
        Id clientRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Client').getRecordTypeId();
        system.debug('clientRecordTypeId'+clientRecordTypeId);
        Id gtCLientRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('GT Client Group').getRecordTypeId();        
        Id KeyAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Key Account').getRecordTypeId();
        
        List<Account> listOfAccountKey =  [SELECT Id,Name FROM Account Where RecordTypeId =:  KeyAccountRecordTypeId];
        List<Account> listOfAccountClient =  [SELECT Id,Name FROM Account Where RecordTypeId =:  clientRecordTypeId];
        String dependent = 'Account.Name';
        String  clause = 'AccountId';
        String  recordId = listOfAccountKey[0].Id;
        String  fieldApiNames = 'Name,Designation__c,Email,Account.Name';
        String  relatedObject = 'Contact';
        String  objectApiName = 'Account';
        String  value = 'test';
        
        SObjectDataTableController.getAllRecords(objectApiName , relatedObject ,fieldApiNames ,recordId,clause,dependent);
        SObjectDataTableController.getFilterRecords(objectApiName , relatedObject ,fieldApiNames ,recordId, value ,clause,dependent);
        List<List<String>> returnList = SObjectDataTableController.genrateColumns(fieldApiNames, relatedObject, listOfAccountClient); 
        
         System.assertEquals(1 , listOfAccountKey.Size() , 'successfull');
        System.assertEquals(4 , returnList.Size() , 'successfull');
    }
    
   /* @isTest static void getAllRecordsTest1() {
        
        Id clientRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Client').getRecordTypeId();
        system.debug('clientRecordTypeId'+clientRecordTypeId);
        Id gtCLientRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('GT Client Group').getRecordTypeId();        
        Id KeyAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Key Account').getRecordTypeId();
        
        List<Account> listOfAccountKey =  [SELECT Id,Name FROM Account Where RecordTypeId =:  KeyAccountRecordTypeId];
        List<Account> listOfAccountClient =  [SELECT Id,Name FROM Account Where RecordTypeId =:  clientRecordTypeId];
        String dependent = 'ClientId__r.Name';
        String  clause = 'ClientId__c';
        String  recordId = listOfAccountKey[0].Id;
        String  fieldApiNames = 'Name,Stage__c,ClientId__r.Name';
        String  relatedObject = 'Job__c';
        String  objectApiName = 'Account';
        String  value = 'test';
        
        SObjectDataTableController.getAllRecords(objectApiName , relatedObject ,fieldApiNames ,recordId,clause,dependent);
        SObjectDataTableController.getFilterRecords(objectApiName , relatedObject ,fieldApiNames ,recordId, value ,clause,dependent);
        SObjectDataTableController.genrateColumns(fieldApiNames, relatedObject, listOfAccountClient); 
    }*/
    
    
}