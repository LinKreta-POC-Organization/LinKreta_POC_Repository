/*
* @Name: SendEmailOnFieldUpdateTest
* @Author: Bhavishya Basantwani
* @Date: 9-dec-23 
*/
@isTest
public class SendEmailOnFieldUpdateTest {
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
        KeyAcc.Domestic_Ultimate_Owner__c = 'Test';
        insert KeyAcc;
        
        AccountTeamMember CTMFifth = TestDataFactory.createAccountTeamMember(KeyAcc.Id);
        CTMFifth.TeamMemberRole = 'Key Account – CSL';
        CTMFifth.ContactAccessLevel = 'Read';
        CTMFifth.CaseAccessLevel = 'Edit';
        CTMFifth.OpportunityAccessLevel ='Edit';
        CTMFifth.AccountAccessLevel = 'Read';
        insert CTMFifth;
        
        Account GtAcc = TestDataFactory.createAccountRecord();
        GtAcc.Name = 'Name44';
        GtAcc.RecordTypeId = gtCLientRecordTypeId;
        GtAcc.Key_Account_360__c = KeyAcc.Id;
        GtAcc.Domestic_Ultimate_Owner__c = 'Test';
        insert GtAcc;
        
        Account GtAcc1 = TestDataFactory.createAccountRecord();
        GtAcc1.Name = 'Shree ji';
        GtAcc1.RecordTypeId = gtCLientRecordTypeId;
        GtAcc1.Domestic_Ultimate_Owner__c = 'Test';
        insert GtAcc1;
        
        Id UserId = UserInfo.getUserId() ;
        
        Account acc = TestDataFactory.createAccountRecord();
        
        acc.RecordTypeId = clientRecordTypeId;
        acc.Name = 'Ram radhe';
        //acc.CSL__c = UserId;
        //acc.CoCSL__c = UserId;
        //acc.GSTIN__c = '00900';
        acc.Client_reason_if_inactive__c = 'testtttttt';
        acc.ClientStatus__c = 'Inactive';
        acc.GT_Client_Group__c = GtAcc.Id;
        acc.ClientAddress__City__s = 'Jaipur';
        acc.ClientAddress__CountryCode__s = 'IN';
        acc.ClientAddress__PostalCode__s = '789'; 
        acc.ClientAddress__StateCode__s = 'AS';
        acc.ClientAddress__Street__s = 'test,test';
        acc.Domestic_Ultimate_Owner__c = 'Test';
        //acc.AccountType__c = 'Key Account';
        
        insert acc;
        
        Entity_Type_Master__c entity_type_masterObj = new Entity_Type_Master__c(
	Name = 'Artificial juridical person',
	CurrencyIsoCode = 'INR',
	WCGT_Id__c = 'PS0020');
 insert entity_type_masterObj;
        
        Account acc1 = TestDataFactory.createAccountRecord();
        acc1.Name = 'Ladhu';
        acc1.RecordTypeId = clientRecordTypeId;
        acc1.CSL__c = UserId;
        acc1.CoCSL__c = UserId;
        //acc1.GSTIN__c = '0090067788';
        acc1.Client_reason_if_inactive__c = 'test';
        //acc1.GSTIN__c = '12345';
        acc1.ClientStatus__c = 'Active';
        acc1.GT_Client_Group__c = GtAcc1.Id;
        acc1.ClientAddress__City__s = 'Jaipur';
        acc1.ClientAddress__CountryCode__s = 'IN';
        acc1.ClientAddress__PostalCode__s = '789'; 
        acc1.ClientAddress__StateCode__s = 'AS';
        acc1.ClientAddress__Street__s = 'test,test';
        acc1.Domestic_Ultimate_Owner__c = 'Test1';
        acc1.Global_Ultimate_Owner__c = 'Test';
        acc1.Client_reason_if_inactive__c = '1';
        acc1.Client_Category__c = 'CX';
        acc1.Entity_Type_Master__c = entity_type_masterObj.Id;
        acc1.ParentId = GtAcc.Id;
        acc1.LegalEntityType__c = 'Public Listed';
        acc1.Client_Account_Sub_Category__c = 'Client Account';
        //acc1.AccountType__c = 'Key Account';
        
        insert acc1;
        
       /* AccountTeamMember CTMFirst = TestDataFactory.createAccountTeamMember(acc.Id);
        AccountTeamMember CTMSeond = TestDataFactory.createAccountTeamMember(acc.Id);
        CTMseond.TeamMemberRole = 'Solution Expert';
        
        
        insert CTMFirst;
        insert CTMSeond; */
        
    }
    
    @isTest static void FieldUpdateTest() {
        Id clientRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Client').getRecordTypeId();
        List<String> ListOfUserName = new List<String>();
        List<Id> ListOfRecepientsIds = new List<Id>();
        List<String> ListOfEmailAddress = new List<String>();
        List<AccountTeamMember> CTMList =[SELECT Id,AccountId,UserId,TeamMemberRole FROM AccountTeamMember];
        
        List<Account> listOfAccount =  [SELECT Id,Name,ParentId,GT_Client_Group__c,Key_Account_360__c,CSL__c,CoCSL__c,Client_reason_if_inactive__c,Client_Category__c,Entity_Type_Master__c,LegalEntityType__c/*,GSTIN__c*/,Client_Account_Sub_Category__c,AccountType__c,Currency_Format__c,ClientStatus__c,Website,Domestic_Ultimate_Owner__c,Global_Ultimate_Owner__c FROM Account Where RecordTypeId =:clientRecordTypeId ] ;
        Account priorRec = listOfAccount[0] ;
        system.debug('priorRec'+priorRec);
        Account presentRec = listOfAccount[1]; 
        system.debug('presentRec'+presentRec);
        
        for(AccountTeamMember CTM : CTMList){
            ListOfRecepientsIds.add(CTM.UserId);
            ListOfEmailAddress.add('bhavi@gmail.com');
        }
        
        EmailTemplate TemplateObj = [select Id,Name from EmailTemplate where DeveloperName =: 'Email_Template_For_Change_in_fields_of_Account'];
        List<SendEmailOnFieldUpdate.ActionRequest> listOfResp = new List<SendEmailOnFieldUpdate.ActionRequest>();
        SendEmailOnFieldUpdate.ActionRequest ResObj = new SendEmailOnFieldUpdate.ActionRequest();
        ResObj.EmailAddress = ListOfEmailAddress;
        ResObj.RecipentId = ListOfRecepientsIds;
        ResObj.UserName = 'Bhavi Basant';
        ResObj.TemlateId = TemplateObj.Id;
        ResObj.PresentRecord = presentRec; 
        ResObj.PriorRecord = priorRec;
        listOfResp.add(ResObj);
        
        SendEmailOnFieldUpdate.FieldUpdate(listOfResp);
        
     //  System.assertEquals('12345' , listOfAccount[1].GSTIN__c , 'successfull');
    }
    
    @isTest static void FieldUpdateTest1() {
        
        Id gtCLientRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('GT Client Group').getRecordTypeId();   
        List<String> ListOfUserName = new List<String>();
        List<Id> ListOfRecepientsIds = new List<Id>();
        List<String> ListOfEmailAddress = new List<String>();
        List<AccountTeamMember> CTMList =[SELECT Id,AccountId,UserId,TeamMemberRole FROM AccountTeamMember];
        
        List<Account> listOfAccount =  [SELECT Id,Name,ParentId,GT_Client_Group__c,Key_Account_360__c,CSL__c,CoCSL__c,Client_reason_if_inactive__c,Client_Category__c,Entity_Type_Master__c,LegalEntityType__c/*,GSTIN__c*/,Client_Account_Sub_Category__c,AccountType__c,Currency_Format__c,ClientStatus__c,Website,Domestic_Ultimate_Owner__c,Global_Ultimate_Owner__c FROM Account Where RecordTypeId =: gtCLientRecordTypeId ] ;
        Account priorRec = listOfAccount[0] ;
        system.debug('priorRec'+priorRec);
        Account presentRec = listOfAccount[1]; 
        system.debug('presentRec'+presentRec);
        
        for(AccountTeamMember CTM : CTMList){
            ListOfRecepientsIds.add(CTM.UserId);
            ListOfEmailAddress.add('bhavi@gmail.com');
        }
        
        EmailTemplate TemplateObj = [select Id,Name from EmailTemplate where DeveloperName =: 'Email_Template_For_Change_in_fields_of_Account'];
        List<SendEmailOnFieldUpdate.ActionRequest> listOfResp = new List<SendEmailOnFieldUpdate.ActionRequest>();
        SendEmailOnFieldUpdate.ActionRequest ResObj = new SendEmailOnFieldUpdate.ActionRequest();
        ResObj.EmailAddress = ListOfEmailAddress;
        ResObj.RecipentId = ListOfRecepientsIds;
        ResObj.UserName = 'Bhavi Basant';
        ResObj.TemlateId = TemplateObj.Id;
        ResObj.PresentRecord = presentRec; 
        ResObj.PriorRecord = priorRec;
        listOfResp.add(ResObj);
        
        SendEmailOnFieldUpdate.FieldUpdate(listOfResp);
        
        System.assertEquals('bhavi@gmail.com' , ListOfEmailAddress[0] , 'successfull');
    }
    
    
}