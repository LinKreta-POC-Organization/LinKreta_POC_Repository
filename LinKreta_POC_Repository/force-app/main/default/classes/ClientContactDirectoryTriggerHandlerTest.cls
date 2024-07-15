@isTest
public with sharing class ClientContactDirectoryTriggerHandlerTest {
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
         
         ClientContactDirectoryObj.OwnerId = lstUser[0].Id;
         update ClientContactDirectoryObj;
     }

}