/*
* @Name: SendNotificationToCTMTest
* @Author: Bhavishya Basantwani
* @Description: This class is used for Send Email and Notification To Client Team Member.
* @Date: 28-July-23
*/
@isTest
public class SendNotificationToCTMTest {
    
    @testSetup static void dataCreation() {
        
        
        Id KeyAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Key Account').getRecordTypeId();
        Id clientRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Client').getRecordTypeId();
        Id gtCLientRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('GT Client Group').getRecordTypeId();    
        
        
        Account KeyAcc = TestDataFactory.createAccountRecord();
        KeyAcc.Name = 'Test';
        KeyAcc.RecordTypeId = KeyAccountRecordTypeId;
        KeyAcc.Client_Category__c = 'GX - Platinum';
        KeyAcc.Client_Sub_Category__c = 'Gx - Gold';
        KeyAcc.Channel_Type__c ='Audit Client';
        KeyAcc.Segment__c = 'Government';
        KeyAcc.Industry__c ='Agriculture';
        insert KeyAcc;
        
        Account KeyAcc1 = TestDataFactory.createAccountRecord();
        KeyAcc1.Name = 'Test1';
        KeyAcc1.RecordTypeId = KeyAccountRecordTypeId;
        KeyAcc1.Client_Category__c = 'GX - Platinum';
        KeyAcc1.Client_Sub_Category__c = 'Gx - Gold';
        KeyAcc1.Channel_Type__c ='Audit Client';
        KeyAcc1.Segment__c = 'Government';
        KeyAcc1.Industry__c ='Agriculture';
        insert KeyAcc1;
        
        Account KeyAcc2 = TestDataFactory.createAccountRecord();
        KeyAcc2.Name = 'Test2';
        KeyAcc2.RecordTypeId = KeyAccountRecordTypeId;
        KeyAcc2.Client_Category__c = 'GX - Platinum';
        KeyAcc2.Client_Sub_Category__c = 'Gx - Gold';
        KeyAcc2.Channel_Type__c ='Audit Client';
        KeyAcc2.Segment__c = 'Government';
        KeyAcc2.Industry__c ='Agriculture';
        insert KeyAcc2;
        
        Contact con = TestDataFactory.createContactRecord();
        con.AccountId = KeyAcc.Id;
        con.Client_Location__Street__s = 'test,test';
        con.Client_Location__City__s  ='test';
        con.Client_Location__PostalCode__s = '12345';
        con.Client_Location__StateCode__s = 'CT';
        con.Client_Location__CountryCode__s = 'IN';
        insert con;
        Test.StartTest();
        Client_Contact_Relationship_Team__c RelationshipTeam = TestDataFactory.createClientContactRelationshipTeam(con.Id);
        RelationshipTeam.Access__c = 'Read Only';
        insert RelationshipTeam;
        
        AccountTeamMember CTMFirst = TestDataFactory.createAccountTeamMember(KeyAcc.Id);
        CTMFirst.TeamMemberRole = 'Key Account – CSL';
        CTMFirst.ContactAccessLevel = 'Read';
        CTMFirst.CaseAccessLevel = 'Edit'; 
        CTMFirst.OpportunityAccessLevel = 'Edit';
        CTMFirst.AccountAccessLevel = 'Read';
        AccountTeamMember CTMSeond = TestDataFactory.createAccountTeamMember(KeyAcc.Id);
        CTMseond.TeamMemberRole = 'Solution Expert';
        CTMseond.TeamMemberRole = 'Solution Expert';
        CTMseond.ContactAccessLevel = 'Read';
        CTMseond.CaseAccessLevel = 'Edit';
        CTMseond.OpportunityAccessLevel = 'Edit';
        CTMseond.AccountAccessLevel = 'Read';
        
        
        insert CTMFirst;
       // insert CTMSeond;
        
        
        Account GtAcc = TestDataFactory.createAccountRecord();
        GtAcc.RecordTypeId = gtCLientRecordTypeId;
        GtAcc.Key_Account_360__c = KeyAcc.Id;
        insert GtAcc;
        
        Account acc = TestDataFactory.createAccountRecord();
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
        
        insert acc;
        
        AccountTeamMember CTMFifth = TestDataFactory.createAccountTeamMember(acc.Id);
        CTMFifth.TeamMemberRole = 'Solution Expert';
        CTMFifth.TeamMemberRole = 'Solution Expert';
        CTMFifth.ContactAccessLevel = 'Read';
        CTMFifth.CaseAccessLevel = 'Edit';
        CTMFifth.OpportunityAccessLevel = 'Edit';
        CTMFifth.AccountAccessLevel = 'Read';
        
        
      //  insert CTMFifth;
        
        Contact con1 = TestDataFactory.createContactRecord();
        con1.FirstName = 'name44';
        con1.LastName = '55';
        con1.AccountId = KeyAcc.Id;
        con1.Client_Location__Street__s = 'test,test';
        con1.Client_Location__City__s  ='test';
        con1.Client_Location__PostalCode__s = '12345';
        con1.Client_Location__StateCode__s = 'CT';
        con1.Client_Location__CountryCode__s = 'IN';
        insert con1;
        
        Client_Contact_Relationship_Team__c RelationshipTeam1 = TestDataFactory.createClientContactRelationshipTeam(con1.Id);
        RelationshipTeam1.Access__c = 'Read Only';
        insert RelationshipTeam1;
        
        
        AccountTeamMember CTMThird = TestDataFactory.createAccountTeamMember(KeyAcc1.Id);
         CTMThird.TeamMemberRole = 'Key Account – CSL';
        CTMThird.ContactAccessLevel = 'Read';
        CTMThird.CaseAccessLevel = 'Edit'; 
        CTMThird.OpportunityAccessLevel = 'Edit';
        CTMThird.AccountAccessLevel = 'Read';
        AccountTeamMember CTMForth = TestDataFactory.createAccountTeamMember(KeyAcc1.Id);
        CTMForth.TeamMemberRole = 'Solution Expert';
        CTMForth.ContactAccessLevel = 'Read';
        CTMForth.CaseAccessLevel = 'Edit'; 
        CTMForth.OpportunityAccessLevel = 'Edit';
        CTMForth.AccountAccessLevel = 'Read';
        
        
        insert CTMThird;
       // insert CTMForth;
      Test.StopTest();
    }
    
    @isTest static void sendCustomNotificationToCTMTest() {
        Id KeyAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Key Account').getRecordTypeId();
        List<Account> listOfAccount =  [SELECT Id,Name FROM Account Where RecordTypeId =:  KeyAccountRecordTypeId];
        List<SendNotificationToCTM.ActionRequest> listOfResp = new List<SendNotificationToCTM.ActionRequest>();
        List<Id> ListOfRecIds = new List<Id>();
        For(Account acc : listOfAccount){
            ListOfRecIds.add(acc.Id);
        }
        Test.StartTest();
        SendNotificationToCTM.ActionRequest ResObj = new SendNotificationToCTM.ActionRequest();
        ResObj.RecId = ListOfRecIds;
        
        listOfResp.add(ResObj);
        
        SendNotificationToCTM.sendCustomNotificationToCTM(listOfResp);
      //  Test.StopTest();
        System.assertEquals(3 , listOfAccount.size() , 'successfull');
        Test.StopTest();
    }
}