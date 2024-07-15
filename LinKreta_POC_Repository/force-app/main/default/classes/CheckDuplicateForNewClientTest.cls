@istest
public class CheckDuplicateForNewClientTest {
    @testSetup static void dataCreation() {
        Account gtClientGroupAccoount = TestDataFactory.createAccountRecord();
        gtClientGroupAccoount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('GT_Client_Group').getRecordTypeId();
        insert gtClientGroupAccoount ; 
        Account acc = TestDataFactory.createAccountRecord();
        
        acc.Country_Corridor__c = 'Afghanistan';
        acc.Corridor__c ='NA';
        acc.Status_DS_Team_Remark_Status__c = 'Pending';
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Client').getRecordTypeId();
        acc.DS_Team_Approval_Status__c ='Pending with DS';
        acc.GT_Client_Group__c = gtClientGroupAccoount.Id;
        acc.Website ='WWW.google.com';
        acc.Segment__c = 'Government';
        //acc.Industry__c ='Auto & Auto Components';
        //acc.SubIndustry__c ='Auto & Auto Components';
        insert acc;
        
        // Profile existingProfile = [SELECT Id FROM Profile WHERE Name = 'NewClientOwner' LIMIT 1];
        Profile existingProfile = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
        
        User userRecord = new User();
        userRecord.EMP_ID__c = 'EM0012344';
        userRecord.Designation__c = 'Manager';
        userRecord.Expertise__c = 'Risk';
        userRecord.FirstName = 'Test';
        userRecord.Username = 'demo.test@GrandT.com';
        userRecord.LastName ='user 1';
        userRecord.Email = 'Test@gmail.com';
        userRecord.Alias ='tu1';
        userRecord.Also_a_Job_Manager__c =True;
        userRecord.TimeZoneSidKey ='Asia/Kolkata';
        userRecord.LocaleSidKey ='en_IN';
        userRecord.EmailEncodingKey ='UTF-8';
        userRecord.ProfileId =existingProfile.Id;
        userRecord.LanguageLocaleKey ='en_US';
        insert userRecord;        
        
        Lead leadRecord = TestDataFactory.createLeadRecord();
        leadRecord.Industry__c ='Auto & Ev';
        leadRecord.Industry_Leader__c = userRecord.Id;
        leadRecord.Solution__c ='Auto Analytics Solution (Automating Control Procedures and Business Analytics)';
        leadRecord.SubexpertiesForDuplicateRule__c ='Governance Risk & Operations (GRO);';
        leadRecord.ExpertiesForDuplicateRule__c ='Risk;';
        leadRecord.Company='Tata Consultancy Services Limited';
        insert leadRecord;
    }
    
    @isTest static void method1(){
        Lead recObj = [Select id,SubexpertiesForDuplicateRule__c, ExpertiesForDuplicateRule__c, Company, Solution__c,IsConverted from lead ];
        test.startTest();
        CheckDuplicateForNewClient.checkduplicate('Auto Analytics Solution (Automating Control Procedures and Business Analytics)','Risk;','Governance Risk & Operations (GRO);','Tata Consultancy Services Limited');
        //CheckDuplicateForNewClient.checkduplicate(recObj.Solution__c,recObj.ExpertiesForDuplicateRule__c,recObj.SubexpertiesForDuplicateRule__c,recObj.Company);
        test.stopTest();
    }
}