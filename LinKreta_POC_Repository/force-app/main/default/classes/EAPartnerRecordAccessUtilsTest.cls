@isTest
public with sharing class EAPartnerRecordAccessUtilsTest {
    @testSetup static void dataCreation() {
        
        List<User> listUser = new List<User>();
        
        User userEA =   TestDataFactory.createUserRecord();
        userEA.EMP_ID__c = 'Test1';
        userEA.IsActive = true;
        userEA.Username='testx1.t@gmail.com';
        userEA.Alias ='tu2';
        User userEA2 =   TestDataFactory.createUserRecord();
        userEA2.EMP_ID__c = 'Test11';
        userEA2.IsActive = true;
        userEA2.Username='testx11.t@gmail.com';
        userEA2.Alias ='tu21';
        User userPartnerUser =   TestDataFactory.createUserRecord();
        userPartnerUser.EMP_ID__c = 'Test2';
        userPartnerUser.IsActive = true;
        
        listUser.add(userEA);
        listUser.add(userPartnerUser);
        listUser.add(userEA2);
        
        insert listUser;
        
        //Create Contact
        Contact cont = TestDataFactory.createContact();
        Insert cont;
    }
    
    @isTest static void createEAPartnerLoginMapper(){
        String contId = [SELECT Id FROM Contact LIMIT 1].Id;
        List<User> lstUser = [SELECT Id,EMP_ID__c FROM user where EMP_ID__c in('Test1','Test2','Test11') ];
        system.debug('lstUser>>>'+lstUser);
        
        Group grp = new Group();
        grp.DeveloperName = lstUser[1].EMP_ID__c+'_EA_Group';
        grp.Name = lstUser[1].EMP_ID__c+'_EA_Group';
        Insert grp;
        
        EAPartnerLogin_Mapper__c objEAPartnerLogin = new EAPartnerLogin_Mapper__c();
        objEAPartnerLogin.EAUser__c = lstUser[0].Id;
        objEAPartnerLogin.Mapping_Id__c = 'TestOnw';
        objEAPartnerLogin.PartnerUser__c = lstUser[1].Id;
        objEAPartnerLogin.Is_Deleted__c = false;
        
     
        lead leadObj = new lead();
        leadObj.FirstName = 'parle';
        leadObj.CountryCode__c = 'Algeria (+213)';
        leadObj.Email = 'rak@gmail.com';
        leadObj.Enquiry_Type__c = 'Business as Usual (BAU)';
        leadObj.LastName = 'India';
        leadObj.Industry__c = 'Asset Management';
        leadObj.Description = 'Test';  
        leadObj.ownerid = lstUser[1].Id;
        leadObj.Company = 'parle';
        List<Lead> leadlst = new List<Lead>();
        leadlst.add(leadObj);
        Insert leadlst;
        
        List<Client_Contact_Directory__c> ClientContactDirectorylst = new List<Client_Contact_Directory__c>();
        Client_Contact_Directory__c ClientContactDirectoryObj = new Client_Contact_Directory__c(
            BOD_Flag__c = 'No',
            Client_Contact_Source__c = 'None',
            Client_Contact__c = contId,
            Client_Location__CountryCode__s = 'IN',
            Country_Code__c = 'Algeria (+213)',
            Email__c = 'aortega@gcfund.org',
            Key_Contact_Identifier__c = 'None',
            Mailing_Address__CountryCode__s = 'IN',
            Mobile__c = '9999999999',
            Sub_Sector__c = 'Agriculture',
            OwnerId = lstUser[1].Id);
        ClientContactDirectorylst.add(ClientContactDirectoryObj);
        insert ClientContactDirectorylst;
        
        EAPartnerRecordAccessUtils.EAShareRecor(leadlst,'LeadShare','LeadId','LeadAccessLevel');
        EAPartnerRecordAccessUtils.EAShareRecor(ClientContactDirectorylst,'Client_Contact_Directory__Share');
        
    }
}