/* 
Created By: Bhavika Gandhi
Last Modified Date : 18 Oct 2023 (Bhavika)
Description : Contains enquiry and job data.
*/

public class Job_TestDataFactory {
    /* Start : Commented by Rakesh Kumar for Phase-1
     * 8/4/24
    public static Wrapper createJob(){
    Wrapper wrap = new Wrapper();
        wrap.enquiry = ELController_TestDataFactory.createRelatedData();
        wrap.job = getEnquiryAndJob(wrap.enquiry);
        return wrap;
    }
    
    
    public static Job__c getEnquiryAndJob(Opportunity enquriy){
        system.debug('enquriy:: '+enquriy);
        // Create a test Job record
        Job__c testJob = new Job__c(
            Enquiry__c = enquriy.Id,
            BudgetedJOBOPEINR__c = 22.3,
            FirstExpectedBillDate__c = Date.today(),
            WCGTProjectID__c = 'PR026181',
            Stage__c = 'New',
            Discount__c = 22.22,
            Client_financial_period_end_for_this_ass__c = Date.today()
        );
        insert testJob;
        system.debug('testJob:: '+testJob);
        return testJob;
    }
    
    public class Wrapper{
        public job__c job{get;set;}
        public Opportunity enquiry{get;set;}
    }
    End : : Commented by Rakesh Kumar for Phase-1
*/
    //Added by Rakesh
    Public static Account createAccountRecord(){
        Account accountRecord = new Account(Name = 'TATA',Status__c = 'Active'/*,CountryCode__c='Algeria (+213)'*/);  
        return accountRecord;
    }
  /* Start : Commented by Rakesh Kumar for Phase-1
    public static IntegratedEnquiry__c createIntegratedEnquiryRecord(){
        IntegratedEnquiry__c integratedEnquiryRec = new IntegratedEnquiry__c(Status__c= 'New', Industry__c = 'Agriculture' , Short_Description__c = 'You will want to clearly define the concept, which could be a feature');
        return integratedEnquiryRec;
     End : : Commented by Rakesh Kumar for Phase-1
    }
*/
    public static contact createContactRecord(){
        Contact contactRecord = new Contact(FirstName='Test',LastName=' contact',is_Address_filled__c = false, Client_Location__City__s='San Francisco',Client_Location__PostalCode__s='94102',Client_Location__Street__s='344, Ellis Street',Client_Location__CountryCode__s='TR');
        return contactRecord;
    }
    
    Public static User createUserRecord(String empId,String designation,String username){     
        Profile existingProfile = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
        User userRecord = new User();
        userRecord.EMP_ID__c = empId;
        userRecord.Designation__c = designation;
        userRecord.Expertise__c = 'Risk';
        userRecord.FirstName = 'Test';
        userRecord.Username = username;
        userRecord.LastName ='user 1';
        userRecord.Email = 'Test@gmail.com';
        userRecord.Alias ='tu1';
        userRecord.IsActive = true;
        userRecord.Also_a_Job_Manager__c =True;
        userRecord.TimeZoneSidKey ='Asia/Kolkata';
        userRecord.LocaleSidKey ='en_IN';
        userRecord.EmailEncodingKey ='UTF-8';
        userRecord.ProfileId =existingProfile.Id;
        userRecord.LanguageLocaleKey ='en_US';
        return userRecord;    
    }
    Public static Currency_Code__c createCurrencyCodeRecord(){
        Currency_Code__c currencyCodeRecord = new Currency_Code__c();
        currencyCodeRecord.Currency_Code__c = 'CU010003';
        return currencyCodeRecord;
    }
    
   /* Start : Commented by Rakesh Kumar for Phase-1
     public static Opportunity createEnquiryRecordForJob( String accountId, String IntegratedEnquiryId, String smeLUId, String userId){
        Opportunity opportunityObj = new Opportunity();
        opportunityObj.DiscountProposedBy__c=userId;
      //  opportunityObj.Market_Description__c = 'International Standards & Solutions';
      //  opportunityObj.Sub_Market_Description__c = 'CROSS BORDER TRANSACTIONS';
        opportunityObj.ProjectStartDate__c = Date.Today();
        opportunityObj.OriginalCloseDate__c = Date.Today()+1;
        opportunityObj.AccountId = accountId;
        opportunityObj.ReasonForRecoveryLessThan75__c = 'Demo Reason';
        opportunityObj.Name = 'Test Enquiry';
        opportunityObj.Description = 'Enquiry for Testing';
        opportunityObj.StageName = 'Identify/Create Enquiry';
        opportunityObj.Amount = 23452354;
        opportunityObj.Probability = 45;
        opportunityObj.CloseDate = Date.today();
        opportunityObj.LeadSource = 'Manual';
        opportunityObj.ForecastCategoryName = 'Pipeline';
        opportunityObj.TentativeFee__c = 23452354;
        opportunityObj.Industry__c = 'Agriculture';
        opportunityObj.SubIndustry__c = 'Agricultural products';
        opportunityObj.Region__c = 'West';
       // opportunityObj.Corridor__c = 'Others';
        opportunityObj.Email__c = 'sachin@test.com';
        opportunityObj.ExpectedRecovery__c = 80;
        opportunityObj.RCCCurrentStatus__c = 'Not Initiated';
        opportunityObj.ClientGroupName__c = 'Mahindra';
      //  opportunityObj.Job_Delivery_Location__c = 'A';
        opportunityObj.SME_LU__c = smeLUId;
        opportunityObj.IntegratedEnquiry__c = IntegratedEnquiryId;
        opportunityObj.EnquiryTeamMemberCount__c = 1;
        opportunityObj.IsOriginatedFromLeadConversion__c = true;
        // opportunityObj.REL__c = userId;
        opportunityObj.Efficiency_and_Results_Leader__c = userId;
        opportunityObj.BUL__c = userId;
       // opportunityObj.SME__c = 'Global Delivery / Remote site audit';
       // opportunityObj.SMEG__c = 'Governance Risk & Operations (GRO)-North';
        opportunityObj.Expertise_TXT__c = 'Risk';
        opportunityObj.OwnerId=userId;
        opportunityObj.ReasonForRecoveryLessThan75__c='3121142a';
        opportunityObj.Last_Enquiry_Activity_Date_Time__c = Datetime.Now();
        opportunityObj.ConvertedCurrency__c = '67';
        return opportunityObj;

    }
    
    Public static Job__c createJobRecord(String opportunityId,String oppAccountId,String WCGTProjectID,String userId){
        Job__c jobObj = new Job__c();
        jobObj.Enquiry__c = opportunityId; //Enquiry Lookup
        jobObj.Client__c = oppAccountId; //Client Lookup
        jobObj.WCGTProjectID__c = WCGTProjectID;
        jobObj.Job_Name_B__c = 'Job '+WCGTProjectID;
        // jobObj.REL__c = userId;
        jobObj.ERL__c = userId;
        jobObj.BUL__c = userId;
        jobObj.Job_Manager__c = userId;
        jobObj.Job_Partner__c = userId;
        jobObj.Stage__c = 'NEW';
        jobObj.Status_WCGT__c ='Open';
        jobObj.Survey_Applicable__c = False;
        jobObj.Survey_Update_Date__c = Date.Today();
        jobObj.Job_Status__c = 'Activate';
        jobObj.JobCode__c = 'JobCode101';
       // jobObj.Engagement_Quality_Reviewer__c = userId;
       // jobObj.JobOwner__c = opportunityObj.OwnerId;
        jobObj.JobCreationDate__c =Date.Today();
       // jobObj.Market__c = opportunityObj.Market_Description__c;
       // jobObj.SubMarket__c = opportunityObj.Sub_Market_Description__c;
       // jobObj.Billing_Currency__c = cc.Id;
        jobObj.BudgetedJOBOPEINR__c = 22.3;
        jobObj.FirstExpectedBillDate__c =Date.Today();
        jobObj.Acceptance_Id__c = 'ABC10101';
        jobObj.GSTStatus__c = 'PR056407';
        jobObj.AdministrativeCharges__c = 'Yes';
        jobObj.Client_financial_period_end_for_this_ass__c = Date.Today();
        jobObj.Second_Engagement_Leader__c = userId;
        jobObj.Third_Engagement_Leader__c = userId;
        jobObj.Assignment_Incharge__c = userId;
        jobObj.Reference_Person_Office__c = 'PR056407';
        jobObj.GT_Reference_Country__c = 'PR056407';
        jobObj.Initial_Budget_Value__c = 22.22;
        jobObj.Discount__c =22.22;
        jobObj.Data_Privacy_Compliance__c = 'Yes';
        jobObj.Job_Budget_Value__c = 22.2;
        jobObj.Third_Party_Vendor_Contractor__c = 'Yes';
        jobObj.Fee_Collected__c =321342;
        jobObj.End_Date__c =Date.today();
        return jobObj;
    }
    
    Public static Suggested_job_Partner__c createSuggestedJobPartnerRecord(String jobId){
        Suggested_job_Partner__c suggested_job_partnerObj = new Suggested_job_Partner__c();
        suggested_job_partnerObj.AcceptanceID__c = 'ABC10101';
        suggested_job_partnerObj.EmpID__c = 'TMC-EMP-551';
        suggested_job_partnerObj.Job__c = jobId;
        return suggested_job_partnerObj;
    }
    
     Public static Third_Party_Vendor__c createThirdPartyVendorRecord(String jobId){
    Third_Party_Vendor__c third_party_vendorObj = new Third_Party_Vendor__c(
            Name = 'c',
            Third_Party_Vendor_Payment__c = 3000,
            job__c=jobId);
        return third_party_vendorObj;
     }
    
    Public static OpportunityContactRole createOpportunityContactRoleRecord(String contactId,String opportunityId){
    OpportunityContactRole opportunitycontactroleObj = new OpportunityContactRole(
            ContactId = contactId,
            Role = 'Decision Maker',
            IsPrimary = true,
            OpportunityId = opportunityId);
        return opportunitycontactroleObj;
    }

End :  Commented by Rakesh Kumar for Phase-1
*/
}