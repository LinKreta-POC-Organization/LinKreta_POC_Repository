@isTest
public with sharing class EAPartnerLoginUtilsTest {
    @testSetup static void dataCreation() {
        
        List<User> listUser = new List<User>();
        
        User userEA =   TestDataFactory.createUserRecord();
        userEA.EMP_ID__c = 'Test1';
        userEA.IsActive = true;
        userEA.Username='testx1.t@gmail.com';
        userEA.Alias ='tu1';
        User userEA2 =   TestDataFactory.createUserRecord();
        userEA2.EMP_ID__c = 'Test11';
        userEA2.IsActive = true;
        userEA2.Username='testx11.t@gmail.com';
        userEA2.Alias ='tu11';
        
        
        User userPartnerUser =   TestDataFactory.createUserRecord();
        userPartnerUser.EMP_ID__c = 'Test2';
        userPartnerUser.IsActive = true;
        userPartnerUser.Username='testx2.t@gmail.com';
        userPartnerUser.Alias ='tu2'; 
        
        User userPartnerUser2 =   TestDataFactory.createUserRecord();
        userPartnerUser2.EMP_ID__c = 'Test21';
        userPartnerUser2.IsActive = true;
        userPartnerUser2.Username='testx21.t@gmail.com';
        userPartnerUser2.Alias ='tu21'; 
        listUser.add(userEA);
        listUser.add(userEA2);
        listUser.add(userPartnerUser);
        listUser.add(userPartnerUser2);
        insert listUser;
        
        User userEAEarlierLoggedInAsPartner =   TestDataFactory.createUserRecord();
        userEAEarlierLoggedInAsPartner.EMP_ID__c = 'Test12';
        userEAEarlierLoggedInAsPartner.IsActive = true;
        userEAEarlierLoggedInAsPartner.Username='testx12.t@gmail.com';
        userEAEarlierLoggedInAsPartner.Alias ='tu12';
        userEAEarlierLoggedInAsPartner.PartnerLogin_UserID__c = listUser[2].Id;
        insert userEAEarlierLoggedInAsPartner;
        
        List<Group> lstGroupsToInsert = new List<Group>();
        
        Group grp1 = new Group();
        grp1.Type = 'Regular';
        grp1.Name = 'group1';
        grp1.DeveloperName = 'group1';
        lstGroupsToInsert.add(grp1);
        
        Group grp2 = new Group();
        grp2.Type = 'Regular';
        grp2.Name = 'group2';
        grp2.DeveloperName = 'group2';
        lstGroupsToInsert.add(grp2);
        
        Group grp3 = new Group();
        grp3.Type = 'Regular';
        grp3.Name = 'group3';
        grp3.DeveloperName = 'group3';
        lstGroupsToInsert.add(grp3);
        
        Group grp4 = new Group();
        grp4.Type = 'Regular';
        grp4.Name = 'group4';
        grp4.DeveloperName = 'group4';
        lstGroupsToInsert.add(grp4);
        
        Insert lstGroupsToInsert;
        
        List<GroupMember> lstGroupMembers = new List<GroupMember>();
        GroupMember gm1 = new GroupMember();
        gm1.GroupId = lstGroupsToInsert[0].Id;
        gm1.UserOrGroupId = listUser[0].Id;
        lstGroupMembers.add(gm1);
               
        GroupMember gm2 = new GroupMember();
        gm2.GroupId = lstGroupsToInsert[1].Id;
        gm2.UserOrGroupId = listUser[0].Id;
        lstGroupMembers.add(gm2);
        
                GroupMember gm3 = new GroupMember();
        gm3.GroupId = lstGroupsToInsert[1].Id;
        gm3.UserOrGroupId = listUser[2].Id;
        lstGroupMembers.add(gm3);
                GroupMember gm4 = new GroupMember();
        gm4.GroupId = lstGroupsToInsert[2].Id;
        gm4.UserOrGroupId = listUser[2].Id;
        lstGroupMembers.add(gm4);
                    GroupMember gm5 = new GroupMember();
        gm5.GroupId = lstGroupsToInsert[3].Id;
        gm5.UserOrGroupId = listUser[3].Id;
        lstGroupMembers.add(gm5);
                    
        Insert lstGroupMembers;
        
    }
    
    @isTest static void createEAPartnerLoginMapper(){
        List<User> lstUser = [SELECT Id,EMP_ID__c FROM user where EMP_ID__c in('Test1','Test11','Test2','Test21') ];
        Map<String,User> mapUser = new Map<String,User>();
        for(User u: lstUser) {
            mapUser.put(u.Emp_Id__c, u);
        }
        
        system.debug('lstUser>>>'+lstUser);
        List<EAPartnerLogin_Mapper__c> lstEAMapping = new List<EAPartnerLogin_Mapper__c>();
        EAPartnerLogin_Mapper__c objEAPartnerLogin1 = new EAPartnerLogin_Mapper__c();
        objEAPartnerLogin1.EAUser__c = mapUser.get('Test1').Id;
        objEAPartnerLogin1.Mapping_Id__c = 'TestOnw';
        objEAPartnerLogin1.PartnerUser__c = mapUser.get('Test2').Id;
        objEAPartnerLogin1.Is_Deleted__c = false;
        
        EAPartnerLogin_Mapper__c objEAPartnerLogin2 = new EAPartnerLogin_Mapper__c();
        objEAPartnerLogin2.EAUser__c = mapUser.get('Test1').Id;
        objEAPartnerLogin2.Mapping_Id__c = 'TestTwo';
        objEAPartnerLogin2.PartnerUser__c = mapUser.get('Test21').Id;
        objEAPartnerLogin2.Is_Deleted__c = false;
        lstEAMapping.add(objEAPartnerLogin1);
        lstEAMapping.add(objEAPartnerLogin2);
        INSERT lstEAMapping;
        //objEAPartnerLogin.EAUser__c  = lstUser[2].Id;
        //UPDATE objEAPartnerLogin;
        
        Test.startTest();
        String body;
        MockClassForEAPartner mock= new MockClassForEAPartner (200,'success',body);
        Test.setMock(HttpCalloutMock.class,mock);
        EAPartnerLoginUtils.switchUserProfile(mapUser.get('Test1').Id, mapUser.get('Test2').Id, false);
        // EAPartnerLoginUtils.switchUserProfile(mapUser.get('Test1').Id, mapUser.get('Test21').Id, false);
        //EAPartnerLoginUtils.switchUserProfile(mapUser.get('Test1').Id, null, true);
        Test.stopTest();
        
        
        
    }
    @isTest static void createEAPartnerLoginMapper2(){
        List<User> lstUser = [SELECT Id,EMP_ID__c FROM user where EMP_ID__c in('Test1','Test11','Test2','Test21', 'Test12') ];
        Map<String,User> mapUser = new Map<String,User>();
        for(User u: lstUser) {
            mapUser.put(u.Emp_Id__c, u);
        }
        
        system.debug('lstUser>>>'+lstUser);
        List<EAPartnerLogin_Mapper__c> lstEAMapping = new List<EAPartnerLogin_Mapper__c>();
        EAPartnerLogin_Mapper__c objEAPartnerLogin1 = new EAPartnerLogin_Mapper__c();
        objEAPartnerLogin1.EAUser__c = mapUser.get('Test12').Id;
        objEAPartnerLogin1.Mapping_Id__c = 'TestOnw';
        objEAPartnerLogin1.PartnerUser__c = mapUser.get('Test2').Id;
        objEAPartnerLogin1.Is_Deleted__c = false;
        
        EAPartnerLogin_Mapper__c objEAPartnerLogin2 = new EAPartnerLogin_Mapper__c();
        objEAPartnerLogin2.EAUser__c = mapUser.get('Test12').Id;
        objEAPartnerLogin2.Mapping_Id__c = 'TestTwo';
        objEAPartnerLogin2.PartnerUser__c = mapUser.get('Test21').Id;
        objEAPartnerLogin2.Is_Deleted__c = false;
        lstEAMapping.add(objEAPartnerLogin1);
        lstEAMapping.add(objEAPartnerLogin2);
        INSERT lstEAMapping;
        //objEAPartnerLogin.EAUser__c  = lstUser[2].Id;
        //UPDATE objEAPartnerLogin;
        
        Test.startTest();
        String body;
        MockClassForEAPartner mock= new MockClassForEAPartner (200,'success',body);
        Test.setMock(HttpCalloutMock.class,mock);
        // EAPartnerLoginUtils.switchUserProfile(mapUser.get('Test1').Id, mapUser.get('Test2').Id, false);
        //EAPartnerLoginUtils.switchUserProfile(mapUser.get('Test1').Id, mapUser.get('Test21').Id, false);
        
            List<SwitchUserProfile_Cls.RequestWrapper> lstRequestWrap = new List<SwitchUserProfile_Cls.RequestWrapper>();
            SwitchUserProfile_Cls.RequestWrapper wrap = new SwitchUserProfile_Cls.RequestWrapper();
            wrap.eaUserId = mapUser.get('Test12').Id;
            wrap.partnerUserId = null;
            wrap.isLoginAsEA = true;
            lstRequestWrap.add(wrap);
            SwitchUserProfile_Cls.switchUserProfile(lstRequestWrap);
        //EAPartnerLoginUtils.switchUserProfile(mapUser.get('Test12').Id, null, true);
        Test.stopTest();
                
    }
   
}