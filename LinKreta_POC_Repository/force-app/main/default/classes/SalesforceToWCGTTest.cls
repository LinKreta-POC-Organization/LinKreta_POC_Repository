@isTest 
private class SalesforceToWCGTTest {
    /*@testSetup static void createData(){
        Test.setMock(HttpCalloutMock.class, new SalesforceToWCGTMockCallout());
        Job_TestDataFactory.Wrapper enquiryJobObj =  Job_TestDataFactory.createJob();
    }
    @isTest static void testSendWhenNSLApprovedNewClient(){
        Test.setMock(HttpCalloutMock.class, new SalesforceToWCGTMockCallout());
        Opportunity opp = [Select id,IntegratedEnquiry__c from Opportunity];
        System.debug('opp--->'+opp);
        IntegratedEnquiry__c intEnqObj = [Select id,New_Client__c from IntegratedEnquiry__c where id=:opp.IntegratedEnquiry__c];
        System.debug('intEnqObj--->'+intEnqObj);
        GenericMockClass mock= new GenericMockClass (200,'success','{"sFirstName": "asheesh","sLastName": "sharma","sNewClientId": "'+intEnqObj.New_Client__c+'","sMobileNo": "+2139418241350","sCompanyName": "India Mumbai Indians (Pty) Limited","sStatus": "1","sStatusReason": "NSL Approved","sUserId": "US006222","sEmail": "asheesh.gcd@gmail.com"}');
        Test.setMock(HttpCalloutMock.class,mock);
        salesforceToWCGT.sendWhenNSLApprovedNewClient(intEnqObj.New_Client__c);
    }
    @isTest static void testSendWhenNewClientNotAccepted(){
        Test.setMock(HttpCalloutMock.class, new SalesforceToWCGTMockCallout());
        Opportunity opp = [Select id,IntegratedEnquiry__c from Opportunity];
        System.debug('opp--->'+opp);
        IntegratedEnquiry__c intEnqObj = [Select id,New_Client__c from IntegratedEnquiry__c where id=:opp.IntegratedEnquiry__c];
        System.debug('intEnqObj--->'+intEnqObj);
        GenericMockClass mock= new GenericMockClass (200,'success','{"sFirstName": "asheesh","sLastName": "sharma","sClientId": "null","sMobileNo": "null","sExperties": "null","sDesignation": "IT","sEmail":"asheesh.gcd@gmail.com","sSector": "Sports","sEnqDesc": "null","sRemarks": "IT"}');
        Test.setMock(HttpCalloutMock.class,mock);
        salesforceToWCGT.sendWhenNewClientNotAccepted(intEnqObj.New_Client__c);
    }    
    @isTest static void testsendWhenClientCreation(){
        Test.setMock(HttpCalloutMock.class, new SalesforceToWCGTMockCallout());
        Opportunity opp = [Select id,IntegratedEnquiry__c,AccountId from Opportunity];
        System.debug('opp--->'+opp);
        IntegratedEnquiry__c intEnqObj = [Select id,New_Client__c from IntegratedEnquiry__c where id=:opp.IntegratedEnquiry__c];
        System.debug('intEnqObj--->'+intEnqObj);
        GenericMockClass mock= new GenericMockClass (200,'success','{"sClientSFID":"'+opp.AccountId+'","sClientGroupName":"VED PARKASH & SONS (A sister concern of Nova Publications)","sClientName":"Eicher Motors Limited","sWebsite":"www.eichermotors.com","sClientType":"PS002114","sEntityType":"PS000010","sTotRevenue":"PS006134","sTotEmpNo":"PS006126","sRelOffice":"PS007572","sCountryHQ":"PS001117","sKam_NonKam":"1", "sSector":"null","sSubSector":"null","sCategory_CX_GX":"PS008099","sUserId":"US006212","sFlag":"1"}');
        Test.setMock(HttpCalloutMock.class,mock);
        salesforceToWCGT.sendWhenClientCreation(opp.AccountId);
    }*/
 /*    @testSetup static void createData(){
        Test.startTest();
      //  Job_TestDataFactory.Wrapper enquiryAndJob = Job_TestDataFactory.createJob();
        Test.stopTest();

     }
     @isTest static void testSy(){
        Test.startTest();
        IntegratedEnquiry__c  intg =[SELECT Id FROM IntegratedEnquiry__c LIMIT 1];
        PitchDeckProposalRequest__c pdprObj =TestDataFactory.createPitchDeckProposalRequest(intg.Id);
        insert pdprObj;
        SalesforceToWCGT.sendPitchDeckorProposal(pdprObj.Id);
        Test.stopTest();
     }

*/

/*
    @isTest static void testSyncLeadToWCGT(){
        Test.setMock(HttpCalloutMock.class, new SalesforceToWCGTMockCallout());
        Profile pro = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User u = new user();
        u.LastName = 'Testclassra Code';
        u.Email = 'test@test.com';
        u.Alias = 'Tcode';
        u.Username = 'testclasshhhy@test.com';
        u.CommunityNickname = 'test12';
        u.LocaleSidKey = 'en_US';
        u.TimeZoneSidKey = 'GMT';
        u.ProfileId = pro.Id;
        u.LanguageLocaleKey = 'en_US';
        u.EmailEncodingKey = 'UTF-8';
        insert u;
        
         Account keyAccount = TestDataFactory.createAccountRecord();
        keyAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Key Account').getRecordTypeId();
        keyAccount.VerrifiedByDSTeam__c = false;
        keyAccount.DS_Team_Approval_Status__c ='Pending with DS';
        //keyAccount.Segment__c = 'Large Corporate';
        //keyAccount.Sub_Segment__c = 'LC - Large';
        keyAccount.Segment__c = 'Government';
        keyAccount.Sub_Segment__c = 'Government';
        Insert keyAccount;
        
        Lead obj1 = new Lead();
        obj1.LastName = 'Test Test';
        obj1.FirstName = 'vijay';
        //obj1.IndustryLeaderApprovalStatus__c = 'Approved'; //Phase-1
        obj1.Status = 'Converted';
        //obj1.CCApprovalStatus__c = 'Approved';
        obj1.CountryCode__c = 'India (+91)';
        obj1.OnNewStage__c = 2323;
        obj1.Expertise_LT__c = 'Human Capital Consulting';
        obj1.SMEG_LT__c = 'Cyber';
        obj1.Region__c = 'North';
        //obj1.IL_ApprovalRejectionRecommendation__c = 'fgnc'; //Phase-1
        obj1.Company = 'Cloud Analogy';
        obj1.Industry_Leader__c = u.Id;
        obj1.Industry__c = 'Banking';
        obj1.Email = 'test@gmail.com';
        obj1.IsLead__c = True;
        obj1.MobilePhone = '1234567891';
        obj1.Formerly_Known_As__c = 'Rajat';
        insert obj1;
        
       // Job_TestDataFactory.Wrapper enquiryAndJob = Job_TestDataFactory.createJob();
        
        
      //  Opportunity opp  = [SELECT Id,AccountId FROM Opportunity LIMIT 1];
      //  Account acc = [SELECT Id FROM Account WHERE Id =keyAccount.Id LIMIT 1];
      //  Job__c Job = [SELECT Id,Enquiry__c FROM Job__c ];
       
        //Account acc = [SELECT Id FROM Account WHERE Id =:enquiryAndJob.enquiry.AccountId];
        
      //  Location__c locationRecord = new Location__c();
      //  locationRecord.Region__c = 'WEST';
      //  locationRecord.Location_Id__c = 'LC070021';
      //  insert locationRecord;  

        Test.startTest();
        Contact contactRecord = TestDataFactory.createContact();
        contactRecord.FirstName = 'test09 contact';
        contactRecord.LastName = 'test09 contact';
        contactRecord.AccountId = keyAccount.Id;
        contactRecord.Linkedin_URL__c = 'www.google.com';
        contactRecord.MobilePhone = '9876543210';
        contactRecord.Email = 'test887@gmail.com';
        contactRecord.Designation__c = 'CEO';
        contactRecord.Salutation = 'Mr.';
        contactRecord.pi__campaign__c = 'Pratham campaign';
        contactRecord.Client_Location__City__s = 'TEST';
        contactRecord.Client_Location__CountryCode__s = 'US';
        contactRecord.Client_Location__PostalCode__s = '121002';
        contactRecord.Client_Location__StateCode__s = 'AL';
        contactRecord.Client_Location__Street__s = 'Test, street';
        contactRecord.Pick_Record__c = false;
        contactRecord.BOD_Flag__c = 'NO';
        contactRecord.DS_Team_Approval_Status__c ='DS Approved';
        contactRecord.Client_Contact_Record_Type__c = 'Client';
       // contactRecord.RelationshipOffice__c = locationRecord.Id;
        
        
        insert contactRecord;
     
        Event testEvent1 = new Event(
            Subject = 'Unveil Event',
            StartDateTime = DateTime.newInstance(2023, 8, 4, 12, 0, 0),
            EndDateTime = DateTime.newInstance(2023, 8, 4, 14, 0, 0),
           // WhatId = enquiryAndJob.job.Id,
           WhatId = keyAccount.Id,
            Type = 'Unveil Event'
        );
        Event testEvent2 = new Event(
            Subject = 'Unveil Event',
            StartDateTime = DateTime.newInstance(2023, 8, 4, 12, 0, 0),
            EndDateTime = DateTime.newInstance(2023, 8, 4, 14, 0, 0),
            //WhatId = enquiryAndJob.enquiry.Id,
            WhatId = keyAccount.Id,
            Type = 'Unveil Event'
        );
        Event testEvent3 = new Event(
            Subject = 'Unveil Event',
            StartDateTime = DateTime.newInstance(2023, 8, 4, 12, 0, 0),
            EndDateTime = DateTime.newInstance(2023, 8, 4, 14, 0, 0),
            WhatId = keyAccount.Id,
            Type = 'Unveil Event'
        );
        List<Event> testEventList = new List<Event>();
        testEventList.add(testEvent1);
        testEventList.add(testEvent2);
        testEventList.add(testEvent3);
        
        INSERT testEventList;

      
        SalesforceToWCGT.sendWhenNSLApprovedNewClient(obj1.Id);
        SalesforceToWCGT.sendWhenNewClientNotAccepted(obj1.Id);
        SalesforceToWCGT.syncEnquiryToWCGTFuture(obj1.Id);
       // SalesforceToWCGT.sendWhenEnquiryCreated(opp.Id);
      //  SalesforceToWCGT.sendWhenEnquiryClosedWonLost(opp.Id);
      //  SalesforceToWCGT.updateEnquiryAfterCallout(200,new List<Opportunity>{opp});
       // SalesforceToWCGT.insertforFindingPartner(opp.Id);
       // SalesforceToWCGT.updateforFindingPartner(opp.Id);
        //SalesforceToWCGT.sendDataforRcc();
     //   SalesforceToWCGT.sendDataforRccByOpp(opp.Id);
        SalesforceToWCGT.sendWhenBDActivity(new List<Id>{testEventList[0].Id});
        SalesforceToWCGT.sendWhenBDActivity(new List<Id>{testEventList[1].Id});
        SalesforceToWCGT.sendWhenBDActivity(new List<Id>{testEventList[2].Id});
        //SalesforceToWCGT.sendPitchDeckorProposal();
        //SalesforceToWCGT.sendELToWCGT();
        
        Test.stopTest();
    }
    
    */
    
    @isTest static void testSyncAccountToWCGT(){
        Test.setMock(HttpCalloutMock.class, new SalesforceToWCGTMockCallout());
        Test.startTest();
        User u = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
            LastName = 'last2',
            Email = 'puser000@amamama.com',
            Username = 'puser000@amamama2.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US'
        );
        INSERT u;
        
        User u2 = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
            LastName = 'last1',
            Email = 'puser000@amamama.com',
            Username = 'puser001@amamama1.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US'
        );
        INSERT u2;
        
        User u3 = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
            LastName = 'last',
            Email = 'puser000@amamama.com',
            Username = 'puser002@amamama.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US'
        );
        INSERT u3;
        
        Account keyAccoount = TestDataFactory.createAccountRecord();
        keyAccoount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Key_Account').getRecordTypeId();
        insert keyAccoount ;
        
        AccountTeamMember keyTeamMember1 = new AccountTeamMember(AccountId = keyAccoount.Id,UserId=UserInfo.getUserId(),TeamMemberRole='Key Account – CSL',ContactAccessLevel='Read',OpportunityAccessLevel='Edit',AccountAccessLevel ='Edit');
        AccountTeamMember keyTeamMember2 = new AccountTeamMember(AccountId = keyAccoount.Id,UserId=u2.Id,TeamMemberRole='Key Account – Co-CSL',ContactAccessLevel='Read',OpportunityAccessLevel='Edit',AccountAccessLevel ='Edit');
        AccountTeamMember keyTeamMember3 = new AccountTeamMember(AccountId = keyAccoount.Id,UserId=u3.Id,TeamMemberRole='Young CSL',ContactAccessLevel='Read',OpportunityAccessLevel='Edit',AccountAccessLevel ='Edit');
        
        List<AccountTeamMember> keyTeamList = new List<AccountTeamMember>();
        keyTeamList.add(keyTeamMember1);
        keyTeamList.add(keyTeamMember2);
        keyTeamList.add(keyTeamMember3);
        INSERT keyTeamList;
        
        system.debug('93:'+keyTeamList[0].Id);
        Account gtClientGroupAccoount = TestDataFactory.createAccountRecord();
        gtClientGroupAccoount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('GT_Client_Group').getRecordTypeId();
        gtClientGroupAccoount.Key_Account_360__c = keyAccoount.Id;
        gtClientGroupAccoount.Name = 'test yo no2hh2';
        insert gtClientGroupAccoount ;
        
        Account accObj = TestDataFactory.createAccountRecord();
        accObj.Country_Corridor__c = 'Afghanistan';
        //accObj.Corridor__c ='NA';
        accObj.Status_DS_Team_Remark_Status__c = 'Pending';
        accObj.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Client').getRecordTypeId();
        accObj.DS_Team_Approval_Status__c ='DS Approved';
        accObj.GT_Client_Group__c = gtClientGroupAccoount.Id;
        accObj.Website ='WWW.google.com';
        accObj.Industry__c ='Sports';
        //accObj.SubIndustry__c ='Fitness facilities';
        accObj.Status__c ='Active';
        accObj.ClientAddress__City__s = 'Delhi';
        accObj.ClientAddress__Street__s = 'Del,hi';
        accObj.ClientAddress__StateCode__s = 'DL';
        accObj.ClientAddress__CountryCode__s = 'IN';
        accObj.ClientAddress__PostalCode__s = '176022';
        INSERT accObj;
     /*   
        Location__c locationRecord = new Location__c();
        locationRecord.Region__c = 'WEST';
        locationRecord.Location_Id__c = 'LC000021';
        insert locationRecord;  
     */   
        Contact contactRecord = TestDataFactory.createContact();
        contactRecord.FirstName = 'test facontactsfa';
        contactRecord.LastName = 'test contact';
        contactRecord.AccountId = accObj.Id;
        contactRecord.Linkedin_URL__c = 'www.google.com';
        contactRecord.MobilePhone = '987654321011';
        contactRecord.Email = 'test@gmail.com';
        contactRecord.Designation__c = 'CEO';
        contactRecord.Salutation = 'Mr.';
        contactRecord.pi__campaign__c = 'Pratham campaign';
        contactRecord.Client_Location__City__s = 'TEST';
        contactRecord.Client_Location__CountryCode__s = 'US';
        contactRecord.Client_Location__PostalCode__s = '121002';
        contactRecord.Client_Location__StateCode__s = 'AL';
        contactRecord.Client_Location__Street__s = 'Test, street';
        contactRecord.Pick_Record__c = false;
        contactRecord.BOD_Flag__c = 'NO';
        contactRecord.Client_Contact_Record_Type__c = 'Client';
     //   contactRecord.RelationshipOffice__c = locationRecord.Id;
        insert contactRecord;
        
        DepthOfRelationship__c depRol = new DepthOfRelationship__c();
        depRol.ClientContact__c = contactRecord.Id;
        depRol.GTRL__c          = u.Id;
        depRol.StrengthOfRelationship__c = 'High';
        INSERT depRol;
     /*   
        Bill_To_Contact__c con = new Bill_To_Contact__c(FirstName__c = 'test contact',LastName__c = 'test contact',Email__c = 'test@gmail.com',Mobile__c = '9876543210',Client__c = accObj.Id);
        con.Contact_Address__Street__s = 'WS,WS';
        con.Contact_Address__City__s = 'Delhi';
        con.Contact_Address__StateCode__s = 'DL';
        con.Contact_Address__CountryCode__s = 'IN';
        con.Contact_Address__CountryCode__s = 'IN';
        con.Contact_Address__PostalCode__s = '176022';
        INSERT con;
       */ 
        SalesforceToWCGT.syncKeyAccountToWCGT(keyAccoount.Id, 'Insert');
        SalesforceToWCGT.syncGTClientGroupToWCGT(gtClientGroupAccoount.Id);
        SalesforceToWCGT.syncClientToWCGT(accObj.Id,'Insert','UserID');
        SalesforceToWCGT.changeNameToWCGT(keyAccoount.Id,'New','Old');
        SalesforceToWCGT.syncClientContactToWCGT(contactRecord.Id,'Insert');
        SalesforceToWCGT.insertContactTeamToWCGT(contactRecord.Id,u.Id);
      //  SalesforceToWCGT.syncBillToContactToWCGT(con.Id,'Insert');
        SalesforceToWCGT.sendWhenClientCreation(accObj.Id);
        SalesforceToWCGT.sendWhenNewClienttoContact(contactRecord.Id);
        salesforceToWCGTHelper.sendWhenBDActivity(new List<Id>{accObj.Id});
        SalesforceToWCGTHelper.getCountryNameByIsoCode('IN','Country','Account');
        SalesforceToWCGTHelper.getCountryNameByIsoCode('DL','State','Account');
        Test.stopTest();
    }
   
}