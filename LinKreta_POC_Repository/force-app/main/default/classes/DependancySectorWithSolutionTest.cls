@isTest
private class DependancySectorWithSolutionTest {
    
    @isTest
    static void testPicklistValues() {
     //   SolutionPL__c solutionRecord=new SolutionPl__c(LOV__c = 'NA');
     //   Insert solutionRecord;
        
     //   ExpertisePL__c expertiseRecord=new ExpertisePL__c(Solution__c = solutionRecord.Id, LOV__c = 'NA');
     //   Insert expertiseRecord;
        
     //   SubExpertisePL__c subExpertiseRecord=new SubExpertisePL__c(LOV__c = 'NA', Expertise__c = expertiseRecord.Id);
     //   Insert subExpertiseRecord;
        
     //   SME_PL__c smeLURecord = new SME_PL__c(Sub_Expertise_PL__c = subExpertiseRecord.Id);
     //   INSERT smeLURecord;
     //   Industry_Leader_Mapping__c testSector = new Industry_Leader_Mapping__c(
     //       Name = 'Test Sector'
            // Add other required fields as needed
     //   );
     //   insert testSector;
     /*   
        Sub_Industry__c testSubIndustry1 = new Sub_Industry__c(
            
            Industry_Leader_Mapping__c = testSector.Id,
            SubIndustry__c = 'Agricultural products'
        );
        Sub_Industry__c testSubIndustry2 = new Sub_Industry__c(
            
            Industry_Leader_Mapping__c = testSector.Id,
            SubIndustry__c = 'Agricultural products'
        );
        insert new List<Sub_Industry__c>{testSubIndustry1, testSubIndustry2};
        */
        User userRecord = TestDataFactory.createUserRecord();
        UserRecord.Username = 'test1@GTUser.com';
		insert userRecord;
        Industry_Leader_Mapping__c ILMapping = new Industry_Leader_Mapping__c();
        ILMapping.Name = 'Agriculture';
        ILMapping.Industry_Business_Partner__c = userRecord.Id;
        ILMapping.Industry_Leader__c = userRecord.Id;
        ILMapping.Industry__c = 'Agriculture';
		insert ILMapping;
        Sub_Industry__c objSubIndustry = new Sub_Industry__c(Industry_Leader_Mapping__c = ILMapping.Id, SubIndustry__c = 'Agricultural products');
        insert objSubIndustry;
        //SELECT Id, Name, Industry_Leader__c, Industry_Business_Partner__c, (SELECT Id, SubIndustry__c FROM Sub_Industries__r) FROM Industry_Leader_Mapping__c WHERE Name =: Sector LIMIT 1];
        
         Account accountObj = new Account(
            Name = 'BLUEBERRY',
            Website = 'www.googl.com',
            CurrencyIsoCode = 'INR',
            AccountType__c = 'Client Account',
            Corridor__c = 'Australia Corridor',
           // Account_Plan_Status__c = 'Draft',
            // Sector__c = 'Auto & Auto Components',
            ClientStatus__c = 'Active',
            Account_Record_Type__c = 'Bill To Client',
            ClientAddress__Street__s = 'test,test',
            ClientAddress__City__s = 'Jaipur',
            ClientAddress__PostalCode__s = '789',
            ClientAddress__CountryCode__s = 'IN',
            ClientAddress__StateCode__s = 'CT',
            DUOAddress__CountryCode__s = 'IN',
            //HQAddressGUO__CountryCode__s = 'IN',
            ShareCapitalInCr__c = 1233,
            Client_s_Headquarter__CountryCode__s = 'US',
            // Sub_Sector__c = 'Auto & Auto Components',
            Company_HQ__CountryCode__s = 'IN',
            Total_No_of_employees__c = '45',
            capIQId__c = 'IQ570461896',
            Total_Revenue__c = 123,
            Country_Corridor__c = 'Australia',
            External_Database_Source__c = 'CapIQ',
            Status__c = 'Active',
            Entity_Type__c = 'Foreign Co.- only foreign operations');
        insert accountObj;

		Contact contactRecord = TestDataFactory.createContact();
       
        contactRecord.AccountId = accountObj.Id;
        contactRecord.Linkedin_URL__c = 'www.google.com';
        contactRecord.MobilePhone = '2233445566';
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
        contactRecord.is_Address_filled__c  = false;
        contactRecord.IsPardot__c = '';
        insert contactRecord;
               
            
            // Call the PicklistValues method
        Test.StartTest();
        List<dependancySectorWithSolution.PiclistWrapperClass> result = dependancySectorWithSolution.PicklistValues('Agriculture');
        List<dependancySectorWithSolution.PiclistWrapperClass> result1 = dependancySectorWithSolution.newClientSourcePicklistValues();
        List<dependancySectorWithSolution.PiclistWrapperClass> result2 = dependancySectorWithSolution.fetchAccount('Client Referral');
        List<dependancySectorWithSolution.PiclistWrapperClass> result3 = dependancySectorWithSolution.fetchAccount('Chambers');
        List<dependancySectorWithSolution.PiclistWrapperClass> result4 = dependancySectorWithSolution.fetchAccount('Channels and Alliances');
        List<dependancySectorWithSolution.PiclistWrapperClass> result5 = dependancySectorWithSolution.fetchContact(accountObj.Id);
        Test.StopTest();
        
        
        System.debug('result'+result);
        // Perform assertions
        System.assertEquals(1, result.size(), 'Result should not be empty');
        // Add more assertions as needed based on your specific requirements
        
        
    }
}