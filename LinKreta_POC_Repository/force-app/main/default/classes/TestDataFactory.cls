public class TestDataFactory {
    //Added by Abdul Vahid
    Public static Account createAccountRecord(){
        Account accountRecord = new Account(Name = 'TATA');     
        return accountRecord;
        
    }
    //Start SFDC-[Phase-1]: code is added by Biplow sarkar | 08-04-2024
    //Added by Abdul Vahid
    /* public static IntegratedEnquiry__c createIntegratedEnquiryRecord(){
        IntegratedEnquiry__c integratedEnquiryRec = new IntegratedEnquiry__c(Status__c= 'New', Industry__c = 'Agriculture' , Short_Description__c = 'You will want to clearly define the concept, which could be a feature');
        return integratedEnquiryRec;
    } 
    //Added by Abdul Vahid
    public static List<Opportunity> createEnquiryRecord( String accountId, String IntegratedEnquiryId, String smeLUId){
        List<Opportunity> enquiryList=new List<Opportunity>();
        
        for(integer i=1; i<=3; i++) {
            Opportunity enquiry = new Opportunity();
            enquiry.Name = 'PNR Enquiry' + i;
            enquiry.StageName = 'Identify/Create Enquiry';
           // enquiry.SubIndustry__c = 'Food & Agri';
            enquiry.CloseDate = System.today();
            enquiry.Amount = 5;
            enquiry.ClientGroupName__c = 'NA';
            enquiry.ExpectedRecovery__c = 12;
            enquiry.Description = 'Test';
            
            enquiry.AccountId = accountId;
            enquiry.SME_LU__c = smeLUId;
            enquiry.IntegratedEnquiry__c = IntegratedEnquiryId;
            enquiryList.add(enquiry);
        }
        return enquiryList;
    }
    */
    //End SFDC-[Phase-1]
    // Added by Suraj
    public static List<SendEmailUsingApex_CLS.processEmailRequest> createTestEmailRequests() {
        List<SendEmailUsingApex_CLS.processEmailRequest> emailRequests = new List<SendEmailUsingApex_CLS.processEmailRequest>();
        
        SendEmailUsingApex_CLS.processEmailRequest emailRequest = new SendEmailUsingApex_CLS.processEmailRequest();
        emailRequest.varToAddresses = new List<String>{ 'test@example.com' };
        emailRequest.varWhatId = UserInfo.getUserId(); 
        EmailTemplate emailTemplate = [SELECT id, DeveloperName FROM EmailTemplate WHERE DeveloperName = 'Email_Template_for_No_Activity_on_Client_Contact']; 
        emailRequest.varTemplateID = emailTemplate.Id;
        emailRequest.varSubject = 'Test Subject';
        emailRequest.varBody = 'Test Body';
        emailRequest.varSaveAsActivity = true;
        emailRequests.add(emailRequest);
        
        return emailRequests;
    }
    
    // Added by Suraj
    public static Contact createContact() {
        Contact testContact = new Contact(
            FirstName = 'TestFirst',
            LastName = 'TestLast',
            AccountId = createAccountRecord().Id,
            Last_Activity_Date_Time__c = System.now() - 35,
            WCGTId__c = 'CN002560'
        );
        return testContact;
    }
    
    public static Contact createContact2() {
        Contact testContact = new Contact(
            FirstName = 'TestFirst2',
            LastName = 'TestLast2',
            AccountId = createAccountRecord().Id,
            Last_Activity_Date_Time__c = System.now() - 35,
            WCGTId__c = 'CN002560'
        );
        return testContact;
    }
    
    
    // Added by Suraj
    public static Client_contact_relationship_team__c createContactTeam(Id userId){
        Client_contact_relationship_team__c clientcontactrelationshipteamcObj = new Client_contact_relationship_team__c (
                User__c = userId, 
                Role__c ='Record Creator', 
                Access__c ='Read Only'
            );
        return clientcontactrelationshipteamcObj;
    }
    
    // Added by Suraj
    public static Campaign createCampaign(){
        Campaign campaignObj = new Campaign (
                Name = 'TestFirst TestLast', 
                StartDate = System.today(), 
                EndDate = System.today() + 2
            );
        return campaignObj;
    }
    
     //Added by Deepak joshi
    public static Entity_Type_Master__c createEntityTypeMaster(){
        Entity_Type_Master__c entityTypeMasterRec = new Entity_Type_Master__c(Name ='New Entity',WCGT_Id__c = '123Abc123');
        return entityTypeMasterRec;
        
    }
     //Added by Deepak joshi
    public static AccountTeamMember createAccountTeamMember(String accountId){
        AccountTeamMember accountTeamMemberRec =new AccountTeamMember(AccountId = accountId,AccountAccessLevel ='Edit',ContactAccessLevel='Read',OpportunityAccessLevel='Edit',CaseAccessLevel='Read',UserId=UserInfo.getUserId(),TeamMemberRole='Relationship Leader');
        return accountTeamMemberRec;
    }
    
    //added By Bhavishya Basantwani
    Public static user createUserRecord(){
        User userRecord = new User(LastName = 'astro');
        Profile existingProfile = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
        userRecord.EMP_ID__c = 'EMP2023';
        userRecord.Designation__c = 'CEO';
        //userRecord.Expertise__c = 'SL000026';
        userRecord.Username = 'testx.t@gmail.com';
        userRecord.LastName ='Test user 1';
        userRecord.Email = 'Test@gmail.com';
        userRecord.Alias ='tu1';
        userRecord.TimeZoneSidKey ='Asia/Kolkata';
        userRecord.LocaleSidKey ='en_IN';
        userRecord.EmailEncodingKey ='UTF-8';
        userRecord.ProfileId =existingProfile.Id;
        userRecord.LanguageLocaleKey ='en_US';
        return userRecord;
    }
    
    //added by Bhavishya Basantwani
    public static contact createContactRecord(){
        Contact contactObj = new Contact();
        contactObj.LastName = 'Ginne' ;
        contactObj.FirstName ='tiestytr';
        contactObj.Linkedin_URL__c ='WWW.google.com';
        contactObj.Client_Location__Street__s = 'test,test';
        contactObj.Client_Location__City__s ='test';
        contactObj.Client_Location__PostalCode__s ='12345';
        contactObj.Client_Location__StateCode__s ='CT' ;
        contactObj.Client_Location__CountryCode__s =  'IN';
        return contactObj;
    }
    //added by Bhavishya Basantwani
    public static Client_Contact_Relationship_Team__c createClientContactRelationshipTeam(string ContactId){
        Client_Contact_Relationship_Team__c clientContactRelationshipTeamRecord = new Client_Contact_Relationship_Team__c(Client_Contact__c = ContactId , User__c=UserInfo.getUserId() , Role__c = 'Record Creator' );
        return clientContactRelationshipTeamRecord;
    }
    //Added by Deepak joshi
    public static Lead createLeadRecord(){
        Lead leadRecord = new Lead(LastName = 'TATA' ,Company='TATA');     
        return leadRecord;
    }
    //Added By Bhavishya Basantwani
    public static Task createTaskRecord(){
        Task taskRecord = new Task();
        return taskRecord;
    }
    //Added By Deepak Joshi
    public static  Account_Requests__c createAccountRequests(){
        Account_Requests__c accountRequestsRecord = new Account_Requests__c (Proposed_Name_New_Name__c ='Test');
        return accountRequestsRecord;

    }
    //Start SFDC-[Phase-1]: code is added by Biplow sarkar | 08-04-2024
    /*
    //Added by Bhavishya Basantwani
    Public static Job__c createJob(){
        Job__c jobRecord = new Job__c ();
        return jobRecord;
    }
    
    //Added By Aman Vijay
    public static  RCC__c createRCC(){
        RCC__c rccRecord = new RCC__c (
            CategoryofProposedServices__c = 'Board of Directors (officer) appointment',
            Circulation_Group__c = 'Partner and Director',
           // ClientName__c = '0011s00001rj59cAAA',
            EntitysLocationCountry__c = 'India',
            EntitysWebsiteorURL__c = 'www.Test',
            Others_Services_Please_describe__c = 'test',
            Client_Group_Name__c ='Test',
            Shareholder_1__c = 'Test'
        );
        return rccRecord;

    }
    //Added By Aman Vijay
    Public static Rcc_Directors_Key_Managerial_Personnel__c createRCCManagerial(String rccId){
        Rcc_Directors_Key_Managerial_Personnel__c rcc_directors_key_managerial_personnelObj = new Rcc_Directors_Key_Managerial_Personnel__c(
            Name = 'Mr. Mukherji',
            CurrencyIsoCode = 'INR',
            Key_Contact_Identifier__c = 'KMP',
            Location__c = 'Mumbai',
            rcc__c =rccId,
            Full_Name_Dir_Key_Managerial_Personnals__c = 'Mr. Mukherji'
        );
        return rcc_directors_key_managerial_personnelObj;
	} 
    //Added By Aman Vijay
    Public static RCC_Billing_Data__c  createRCCBill(String rccId){
        RCC_Billing_Data__c rcc_billing_dataObj = new RCC_Billing_Data__c(
            Client_Name__c = 'Astrome Technologies Private Limited',
            Rcc__c =rccId,
            ExternalId__c = 'IN2122000018970--a1U1s000002I0qZEAS',
            Status__c = 'Conflict');
        return rcc_billing_dataObj;
    } 
    //Added By Aman Vijay
    public static Rcc_Subsidiary__c createRCCSubsidiary(String rccId){
        Rcc_Subsidiary__c rcc_subsidiaryObj = new Rcc_Subsidiary__c(
            Name = 'ABB',
            CurrencyIsoCode = 'INR',
            rcc__c =rccId,
            Full_Subsidiary_Name__c = 'ABB');
        return rcc_subsidiaryObj;
    }
     //Added By Aman Vijay  
     public static RCC_Joint_Venture__c createRCCJointVenture(String rccId){
        RCC_Joint_Venture__c rcc_joint_ventureObj = new RCC_Joint_Venture__c(
            Name = 'Accenture PVT Ltd',
            rcc__c =rccId,
            Full_Joint_Venture_Name__c = 'Accenture PVT Ltd');
        return rcc_joint_ventureObj;
     }
     //Added By Aman Vijay   
    public static Rcc_Brother_Sister_Entity__c createRCCBrotherSister(String rccId){
        Rcc_Brother_Sister_Entity__c rcc_brother_sister_entityObj = new Rcc_Brother_Sister_Entity__c(
            Name = 'Google',
            rcc__c =rccId,
            Full_Brother_Sister_Entity_Name__c = 'Google');
        return rcc_brother_sister_entityObj;
    }
    */
    //End SFDC-[Phase-1]
    //Added By Aman Vijay
    Public static User createUserNewClientOwner(){
        
        Profile existingProfile = [SELECT Id FROM Profile WHERE Name = 'NewClientOwner' LIMIT 1];
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
        return userRecord;
    }
    //Start SFDC-[Phase-1]: code is added by Biplow sarkar | 08-04-2024
    /*
    //Added by Deepak Joshi
    public static RCC_Billing_Data__c createRCC_BillingData(String rcc_Id){
        RCC_Billing_Data__c rcc_billing = new RCC_Billing_Data__c();
        rcc_billing.ExternalId__c='test10200100';
        rcc_billing.RCC__c =rcc_Id;
        return  rcc_billing;
    }
    //Added by Deepak Joshi
    */
    //End SFDC-[Phase-1]
    public static ContentVersion createContentVersion(String title){
        ContentVersion content=new ContentVersion(); 
        content.Title=title; 
        content.PathOnClient='/' + content.Title + '.jpg'; 
        Blob bodyBlob=Blob.valueOf('Unit Test ContentVersion Body'); 
        content.VersionData=bodyBlob; 
        content.origin = 'H';
        return content;
    }
     //Added by Deepak Joshi
     public static ContentDocumentLink createContentDocumentLink(String linkedEntityId ,ContentVersion content){
        ContentDocumentLink contentlink=new ContentDocumentLink();
        contentlink.LinkedEntityId=linkedEntityId;
        contentlink.contentdocumentid=[select contentdocumentid from contentversion where id =: content.id].contentdocumentid;
        contentlink.ShareType = 'I';
        contentlink.Visibility = 'AllUsers';
        return contentlink;
    }
    //Start SFDC-[Phase-1]: code is added by Biplow sarkar | 08-04-2024
    /*
    //Added by Deepak Joshi
    public static RCC_Pipeline_Data__c createRCC_PipelineData(String rcc_Id){
        RCC_Pipeline_Data__c rcc_vendorObj = new RCC_Pipeline_Data__c();
        rcc_vendorObj.RCC__c =rcc_Id;
        rcc_vendorObj.ExternalId__c ='test10200100';
        return  rcc_vendorObj;
    }
    
       //Added by Deepak Joshi
       public static RCC_Register_of_Directorship__c createRCC_RegisterDirectorship(String rcc_Id){
        RCC_Register_of_Directorship__c rcc_vendorObj = new RCC_Register_of_Directorship__c();
        rcc_vendorObj.RCC__c =rcc_Id;
        rcc_vendorObj.ExternalId__c ='test10200100';
        return  rcc_vendorObj;
    }
    
    //Added by Deepak Joshi
    public static RCC_GCL__c createRCC_GCL(String rcc_Id){
        RCC_GCL__c rcc_vendorObj = new RCC_GCL__c();
        rcc_vendorObj.RCC__c =rcc_Id;
        rcc_vendorObj.ExternalId__c ='test10200100';
        return  rcc_vendorObj;
    }
    //Added by Deepak Joshi
    public static RCC_GRL__c createRCC_GRL(String rcc_Id){
        RCC_GRL__c rcc_vendorObj = new RCC_GRL__c();
        rcc_vendorObj.RCC__c =rcc_Id;
        rcc_vendorObj.ExternalId__c ='test10200100';
        return  rcc_vendorObj;
    }
    //Added by Deepak Joshi
    public static RCC_LREL__c createRCC_LREL(String rcc_Id){
        RCC_LREL__c rcc_vendorObj = new RCC_LREL__c();
        rcc_vendorObj.RCC__c =rcc_Id;
        rcc_vendorObj.ExternalId__c ='test10200100';
        return  rcc_vendorObj;
    }
    //Added by Deepak Joshi
    public static RCC_NDCL__c createRCC_NDCL(String rcc_Id){
        RCC_NDCL__c rcc_vendorObj = new RCC_NDCL__c();
        rcc_vendorObj.RCC__c =rcc_Id;
        rcc_vendorObj.ExternalId__c ='test10200100';
        return  rcc_vendorObj;
    }
     //Added by Deepak Joshi
     public static RCC_PCAOB_Criminal__c createRCC_PCAOB_Criminal(String rcc_Id){
        RCC_PCAOB_Criminal__c rcc_vendorObj = new RCC_PCAOB_Criminal__c();
        rcc_vendorObj.RCC__c =rcc_Id;
        rcc_vendorObj.ExternalId__c ='test10200100';
        return  rcc_vendorObj;
    }
    //Added by Deepak Joshi
    public static RCC_Involvement_as_Senior_Personnel__c createRCC_InvolvementSeniorPersonnel(String rcc_Id){
        RCC_Involvement_as_Senior_Personnel__c rcc_vendorObj = new RCC_Involvement_as_Senior_Personnel__c();
        rcc_vendorObj.RCC__c =rcc_Id;
        rcc_vendorObj.ExternalId__c ='test10200100';
        return  rcc_vendorObj;
    }
     //Added by Deepak Joshi
     public static RCC_Directorship_and_Holding__c createRCC_DirectorshipHolding(String rcc_Id){
        RCC_Directorship_and_Holding__c rcc_vendorObj = new RCC_Directorship_and_Holding__c();
        rcc_vendorObj.RCC__c =rcc_Id;
        rcc_vendorObj.ExternalId__c ='test10200100';
        return  rcc_vendorObj;
    }
     //Added by Deepak Joshi
     public static RCC_Employment_Details__c createRCC_EmploymentDetails(String rcc_Id){
        RCC_Employment_Details__c rcc_vendorObj = new RCC_Employment_Details__c();
        rcc_vendorObj.RCC__c =rcc_Id;
        rcc_vendorObj.ExternalId__c ='test10200100';
        return  rcc_vendorObj;
    }
    //Added by Deepak Joshi
    public static RCC_Vendor_Data__c createRCC_VendorData(String rcc_Id){
        RCC_Vendor_Data__c rcc_vendorObj = new RCC_Vendor_Data__c();
        rcc_vendorObj.RCC__c =rcc_Id;
        rcc_vendorObj.ExternalId__c ='test10200100';
        return  rcc_vendorObj;
    }
    //Added by Deepak Joshi
    public static PitchDeckProposalRequest__c createPitchDeckProposalRequest(String integratedEnquiryId){
        PitchDeckProposalRequest__c pdprObj =new  PitchDeckProposalRequest__c();
        pdprObj.Integrated_Enquiry__c =integratedEnquiryId;
        return pdprObj;
    }
    
    //Added By Bhavishya Basantwani  
    Public static Opportunity createEnquiryRec(String accountId, String IntegratedEnquiryId){
        Opportunity enquiryRec = new Opportunity();
        enquiryRec.Name = 'PNR Enquiry';
        enquiryRec.StageName = 'Identify/Create Enquiry';
        // enquiry.SubIndustry__c = 'Food & Agri';
        enquiryRec.CloseDate = System.today();
        enquiryRec.Amount = 56666;
        enquiryRec.ClientGroupName__c = 'NA';
        enquiryRec.ExpectedRecovery__c = 12;
        enquiryRec.Description = 'Test';
       enquiryRec.AccountId = accountId;
        // enquiry.SME_LU__c = smeLUId;
        enquiryRec.IntegratedEnquiry__c = IntegratedEnquiryId;
        
        
        return enquiryRec;
    }
    
    public static List<Opportunity> createOpportunitiesWithIndustryLeader() {
        
        Account objAccount = createAccountRecord();
        objAccount.Status__c = 'Active';
        insert objAccount;
        
        List<Opportunity> opportunities = new List<Opportunity>();
        
        Opportunity oppWithIndustryLeader = new Opportunity(
            Name = 'Test Opportunity with Industry Leader',
            StageName = 'Identify/Create Enquiry',
            Industry_Leader__c = UserInfo.getUserId(),
            CloseDate = System.today(),
            AccountId = objAccount.Id
        );
        
        insert oppWithIndustryLeader;
        opportunities.add(oppWithIndustryLeader);
        
        // Add more opportunities if needed
        
        return opportunities;
    }
    
    public static List<Opportunity> createOpportunitiesWithIndustryBusinessPartner() {
        
        Account objAccount = createAccountRecord();
        objAccount.Status__c = 'Active';
        insert objAccount;
        
        List<Opportunity> opportunities = new List<Opportunity>();
        
        Opportunity oppWithIndustryBP = new Opportunity(
            Name = 'Test Opportunity with Industry Business Partner',
            StageName = 'Identify/Create Enquiry',
            Industry_Business_Partner__c = UserInfo.getUserId(),
            CloseDate = System.today(),
            AccountId = objAccount.Id
        );
        
        insert oppWithIndustryBP;
        opportunities.add(oppWithIndustryBP);
        
        // Add more opportunities if needed
        
        return opportunities;
    }
    
    public static List<IntegratedEnquiry__c> createIntegratedEnquiries() {
        List<IntegratedEnquiry__c> integratedEnquiries = new List<IntegratedEnquiry__c>();
        
        IntegratedEnquiry__c ie = new IntegratedEnquiry__c(
            Efficiency_and_Results_Leader__c = UserInfo.getUserId(),
            BUL__c = UserInfo.getUserId()
        );
        
        insert ie;
        integratedEnquiries.add(ie);
        
        // Add more IntegratedEnquiry__c records if needed
        
        return integratedEnquiries;
    }
    public static List<Opportunity> createOpportunitiesWithExecutiveAssistant() {
        
        Account objAccount = createAccountRecord();
        objAccount.Status__c = 'Active';
        insert objAccount;
        
        List<Opportunity> opportunities = new List<Opportunity>();
        
        Opportunity oppWithEA = new Opportunity(
            Name = 'Test Opportunity with EA',
            StageName = 'Identify/Create Enquiry',
            CloseDate = System.today(),
            Executive_Assistant__c = UserInfo.getUserId(),
            AccountId = objAccount.Id
        );
        
        insert oppWithEA;
        opportunities.add(oppWithEA);
        
        // Add more opportunities if needed
        
        return opportunities;
    }
    */
    //ENd SFDC-[Phase-1]:

     //Added by Rakesh
    Public static Account createAccountRecordDetailed(){
        
        // Account accountRecord = new Account(Name = 'TATA',Status__c = 'Active'/*,CountryCode__c='Algeria (+213)'*/); 
        Account acc = new Account();
        acc.Name = 'TATA';
        acc.Status__c ='Active';
        acc.Country_Corridor__c = 'Afghanistan';
        acc.Corridor__c ='NA';
        acc.Status_DS_Team_Remark_Status__c = 'Approved';
        //acc.DS_Team_Approval_Status__c ='Approved';
        acc.Website ='WWW.google.com';
        acc.Industry__c ='Agriculture';
        acc.SubIndustry__c ='Agricultural products';
        acc.ClientAddress__City__s = 'Delhi';
        acc.ClientAddress__Street__s = 'cp,Delhi';
        acc.ClientAddress__StateCode__s = 'DL';
        acc.ClientAddress__CountryCode__s = 'IN';
        acc.ClientAddress__PostalCode__s = '176022';
        acc.is_Address_filled__c = True;
        return acc; 
    }

    //Start SFDC-[Phase-1]: code is added by Biplow sarkar | 08-04-2024
    //Added by Deepak Joshi
    /*
    public static Bill_To_Contact__c createBillToClient(String clientId){
        Bill_To_Contact__c billToClint = new Bill_To_Contact__c();
        billToClint.Client__c =clientId;
        return  billToClint;
    }
     //added by Deepak Joshi
     public static Brother_Sister_Entity__c createBrotherSisterEntity(){
        Brother_Sister_Entity__c broSisterObj =new  Brother_Sister_Entity__c();
        return broSisterObj;
    }
    public static Subsidiary__c createSubsidiary(Id accountId){
        Subsidiary__c objSubsidiary = new Subsidiary__c();
        objSubsidiary.Client__c = accountId;
        return objSubsidiary;
    }
    //added by Deepak Joshi
    public static Joint_Venture__c createJointVenture(){
        Joint_Venture__c jointVentureObj = new Joint_Venture__c();
        return jointVentureObj;
    }
    */
    //End SFDC-[Phase-1]
    public static User createUser(String profileId){
      
        String orgId=UserInfo.getOrganizationId(); 
        String dateString=String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','') ;
        Integer RandomId=Integer.valueOf(Math.rint(Math.random()*1000000)); 
        String uniqueName=orgId+dateString+RandomId; 
        User testUser=new User(firstname = 'ABC', 
                         lastName = 'XYZ', 
                         email = uniqueName + '@test' + orgId + '.org', 
                         Username = uniqueName + '@test' + orgId + '.org', 
                         EmailEncodingKey = 'ISO-8859-1', 
                         Alias = uniqueName.substring(18, 23), 
                         TimeZoneSidKey = 'America/Los_Angeles', 
                         LocaleSidKey = 'en_US', 
                         LanguageLocaleKey = 'en_US', 
                         ProfileId = profileId
                        ); 
       return testUser;
    }
    //Added by Deepak Joshi
    public static Client_News__c createClientNews(){
        Client_News__c  news  =new Client_News__c();
        return news;
    }
     //Added By Bhavishya Basantwani
    Public static DepthOfRelationship__c createDepthOfRelationship(Id ContactId){ 
        DepthOfRelationship__c depthRelRec = new DepthOfRelationship__c();
        depthRelRec.ClientContact__c = ContactId;
        depthRelRec.GTRL__c = UserInfo.getUserId();
        depthRelRec.Name = 'Test44';
        depthRelRec.StrengthOfRelationship__c = 'Medium';
        return depthRelRec;
    }
    //Start SFDC-[Phase-1]: code is added by Biplow sarkar | 08-04-2024
    //Added By Deepak Joshi
   /* public static echosign_dev1__SIGN_Agreement__c createEchosignDev1SIGNAgreement(){ 
        echosign_dev1__SIGN_Agreement__c  en = new echosign_dev1__SIGN_Agreement__c ();
        return en;
    } */
    //End SFDC-[Phase-1]
}