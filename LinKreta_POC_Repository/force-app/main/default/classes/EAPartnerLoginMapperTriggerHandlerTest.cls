@isTest
public with sharing class EAPartnerLoginMapperTriggerHandlerTest {
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

      
    }

    @isTest static void createEAPartnerLoginMapper(){
        List<User> lstUser = [SELECT Id,EMP_ID__c FROM user where EMP_ID__c in('Test1','Test2','Test11') ];
      
        system.debug('lstUser>>>'+lstUser);
        EAPartnerLogin_Mapper__c objEAPartnerLogin = new EAPartnerLogin_Mapper__c();
        objEAPartnerLogin.EAUser__c = lstUser[0].Id;
        objEAPartnerLogin.Mapping_Id__c = 'TestOnw';
        objEAPartnerLogin.PartnerUser__c = lstUser[1].Id;
        objEAPartnerLogin.Is_Deleted__c = false;

        Test.startTest();
        INSERT objEAPartnerLogin;
        objEAPartnerLogin.EAUser__c  = lstUser[2].Id;
        UPDATE objEAPartnerLogin;
        Test.stopTest();
    }
}