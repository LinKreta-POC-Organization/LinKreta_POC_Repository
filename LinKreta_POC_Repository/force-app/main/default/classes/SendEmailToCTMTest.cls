/*
@isTest
public class SendEmailToCTMTest {
    
    @testSetup static void dataCreation() {
        
        Account acc = TestDataFactory.createAccountRecord();
        insert acc;
        
        AccountTeamMember CTMfirst = TestDataFactory.createAccountTeamMember(acc.Id);
        AccountTeamMember CTMseond = TestDataFactory.createAccountTeamMember(acc.Id);
        CTMseond.TeamMemberRole = 'Solution Expert';
        
        
        insert CTMfirst;
        insert CTMseond;
        
        
        
    }
    
    
    @isTest static void sendEmail() {
        List<String> ListOfUserName = new List<String>();
        List<Id> ListOfRecepientsIds = new List<Id>();
        List<String> ListOfEmailAddress = new List<String>();
        List<String> ListOfRecId = new List<String>();
        List<String> ListOfTeamRole = new List<String>();
        List<String> ListOfRelatedRec = new List<String>();
        List<AccountTeamMember> CTMList =[SELECT Id,AccountId,UserId,TeamMemberRole FROM AccountTeamMember];
        List<Account> listOfAccount =  [SELECT Id,Name FROM Account] ;
        
        for(Account acc : listOfAccount){
            ListOfRecId.add(acc.Id);
            ListOfRelatedRec.add(acc.Name);
        }
        
        for(AccountTeamMember CTM : CTMList){
            ListOfRecepientsIds.add(CTM.UserId);
            ListOfEmailAddress.add('bhavi@gmail.com');
            ListOfUserName.add('Bhavi Basant');
            ListOfTeamRole.add(CTM.TeamMemberRole);
        }
        
        EmailTemplate TemplateObj = [select Id,Name from EmailTemplate where DeveloperName =: 'Template_For_Associated_Client_With_Key_Account'];
        List<SendEmailToCTM.ActionRequest> listOfResp = new List<SendEmailToCTM.ActionRequest>();
        SendEmailToCTM.ActionRequest ResObj = new SendEmailToCTM.ActionRequest();
        ResObj.EmailAddress = ListOfEmailAddress;
        ResObj.RecipentId = ListOfRecepientsIds;
        ResObj.UserName = ListOfUserName;
        ResObj.TemlateId = TemplateObj.Id;
        ResObj.RecId = ListOfRecId;
        ResObj.TeamRole = ListOfTeamRole;
        ResObj.RelatedRecName = ListOfRelatedRec;
        listOfResp.add(ResObj);
        
        SendEmailToCTM.MailToCixTeam(listOfResp);
        
        System.assertEquals('bhavi@gmail.com', ListOfEmailAddress[0] , 'Successfull');
    }
    
} 




* @Name: SendEmailToCTMTest
* @Author: Bhavishya Basantwani
* @Date: 9-dec-23 
*/
@isTest
public class SendEmailToCTMTest {
    
    @testSetup static void dataCreation() {
        
        Id clientRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Client').getRecordTypeId();
        system.debug('clientRecordTypeId'+clientRecordTypeId);
        Id gtCLientRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('GT Client Group').getRecordTypeId();        
        Id KeyAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Key Account').getRecordTypeId();
        
        Account KeyAcc = TestDataFactory.createAccountRecord();
        KeyAcc.RecordTypeId = KeyAccountRecordTypeId;
        KeyAcc.Client_Category__c = 'GX - Platinum';
        KeyAcc.Client_Sub_Category__c = 'Gx - Gold';
        KeyAcc.Channel_Type__c ='Audit Client';
        KeyAcc.Segment__c = 'Government';
        KeyAcc.Industry__c ='Agriculture';
        insert KeyAcc;
        
        AccountTeamMember CTMFifth = TestDataFactory.createAccountTeamMember(KeyAcc.Id);
        CTMFifth.TeamMemberRole = 'Key Account – CSL';
        CTMFifth.ContactAccessLevel = 'Read';
        CTMFifth.CaseAccessLevel = 'Edit';
        CTMFifth.OpportunityAccessLevel ='Edit';
        CTMFifth.AccountAccessLevel = 'Read';
        insert CTMFifth;
        
         AccountTeamMember CTMSeven = TestDataFactory.createAccountTeamMember(KeyAcc.Id);
        CTMSeven.TeamMemberRole = 'Key Account – Co-CSL';
        CTMSeven.ContactAccessLevel = 'Read';
        CTMSeven.CaseAccessLevel = 'Edit';
        CTMSeven.OpportunityAccessLevel = 'Edit';
        CTMSeven.AccountAccessLevel = 'Read';
        
        
        
        Account GtAcc = TestDataFactory.createAccountRecord();
        GtAcc.Name = 'Name44';
        GtAcc.RecordTypeId = gtCLientRecordTypeId;
        GtAcc.Key_Account_360__c = KeyAcc.Id;
        insert GtAcc;
        
        Account GtAcc1 = TestDataFactory.createAccountRecord();
        GtAcc1.Name = 'Shree ji';
        GtAcc1.RecordTypeId = gtCLientRecordTypeId;
        insert GtAcc1;
        
        Id UserId = UserInfo.getUserId() ;
        
        Account acc = TestDataFactory.createAccountRecord();
        
        acc.RecordTypeId = clientRecordTypeId;
        acc.Name = 'Ram radhe';
        //acc.CSL__c = UserId;
        //acc.CoCSL__c = UserId;
       // acc.GSTIN__c = '00900';
        acc.Client_reason_if_inactive__c = 'testtttttt';
        acc.ClientStatus__c = 'Inactive';
        acc.GT_Client_Group__c = GtAcc.Id;
        acc.ClientAddress__City__s = 'Jaipur';
        acc.ClientAddress__CountryCode__s = 'IN';
        acc.ClientAddress__PostalCode__s = '789'; 
        acc.ClientAddress__StateCode__s = 'AS';
        acc.ClientAddress__Street__s = 'test,test';
        
        insert acc;
        
       
        
        
        
        
    }
    
    
    @isTest static void sendEmail() {
        
        Id KeyAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Key Account').getRecordTypeId();
        List<String> ListOfUserName = new List<String>();
        List<Id> ListOfRecepientsIds = new List<Id>();
        List<String> ListOfEmailAddress = new List<String>();
        List<String> ListOfRecId = new List<String>();
        List<String> ListOfTeamRole = new List<String>();
        List<String> ListOfRelatedRec = new List<String>();
        List<AccountTeamMember> CTMList =[SELECT Id,AccountId,UserId,TeamMemberRole FROM AccountTeamMember ];
        system.debug('CTMList'+CTMList);
        List<Account> listOfAccount =  [SELECT Id,Name FROM Account where recordType.Id =: KeyAccountRecordTypeId];
        
        for(Account acc : listOfAccount){
            ListOfRecId.add(acc.Id);
            ListOfRelatedRec.add(acc.Name);
        }
        
        	ListOfRecepientsIds.add(UserInfo.getUserId());
            ListOfEmailAddress.add('bhavi@gmail.com');
            ListOfUserName.add('Bhavi Basant');
            ListOfTeamRole.add('Solution Expert'); 
        
       /* for(AccountTeamMember CTM : CTMList){
            ListOfRecepientsIds.add(CTM.UserId);
            ListOfEmailAddress.add('bhavi@gmail.com');
            ListOfUserName.add('Bhavi Basant');
            ListOfTeamRole.add(CTM.TeamMemberRole);
        }*/
        
        EmailTemplate TemplateObj = [select Id,Name from EmailTemplate where DeveloperName =: 'Template_For_Associated_Client_With_Key_Account'];
        List<SendEmailToCTM.ActionRequest> listOfResp = new List<SendEmailToCTM.ActionRequest>();
        SendEmailToCTM.ActionRequest ResObj = new SendEmailToCTM.ActionRequest();
        ResObj.EmailAddress = ListOfEmailAddress;
        ResObj.RecipentId = ListOfRecepientsIds;
        ResObj.UserName = ListOfUserName;
        ResObj.TemlateId = TemplateObj.Id;
        ResObj.RecId = ListOfRecId;
        ResObj.TeamRole = ListOfTeamRole;
        ResObj.RelatedRecName = ListOfRelatedRec;
        listOfResp.add(ResObj);
        
        SendEmailToCTM.MailToCixTeam(listOfResp);
        
        System.assertEquals('bhavi@gmail.com', ListOfEmailAddress[0] , 'Successfull');
    }
    
}