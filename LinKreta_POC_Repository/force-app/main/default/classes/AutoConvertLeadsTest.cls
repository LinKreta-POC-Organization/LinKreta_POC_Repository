@isTest
global class AutoConvertLeadsTest {
    global class MockCollout implements HttpCalloutMock{
        global HttpResponse respond(HttpRequest req){
            HttpResponse res = new HttpResponse();
            String body ='{"statusCode":"200","statusMsg":"Record inserted Successfully","data":""}';
            res.setHeader('Content-Type','application/json');
            res.setBody(body);
            res.setStatusCode(200);
            return res;
        }
    }
    
    @testSetup static void dataCreation() {
        GenericMockClass mock= new GenericMockClass (200,'success','{"statusCode":"200","statusMsg":"Record inserted Successfully","data":""}');
        Test.setMock(HttpCalloutMock.class,mock);
        Account acc = TestDataFactory.createAccountRecord();
        acc.Name = 'Mayank Limited';
        acc.Pan_No__c = 'IIBPK4321W';
        acc.capIQId__c = 'IQ8089740';
        acc.Country_Corridor__c = 'Afghanistan';
        acc.Corridor__c ='NA';
        acc.Status_DS_Team_Remark_Status__c = 'Pending';
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Client').getRecordTypeId();
        acc.DS_Team_Approval_Status__c ='Pending with DS';
        acc.Website ='WWW.google.com';
        acc.Industry__c ='Agriculture';
        acc.ClientAddress__Street__s = 'test,test';
        acc.ClientAddress__City__s ='test';
        acc.ClientAddress__PostalCode__s ='12345';
        acc.ClientAddress__StateCode__s ='CT' ;
        acc.ClientAddress__CountryCode__s =  'IN';
        insert acc;
        
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
        
        Lead leadRecord = TestDataFactory.createLeadRecord();
        leadRecord.LastName = 'Test Test1';
        leadRecord.FirstName = 'vijay1';
        //leadRecord.IndustryLeaderApprovalStatus__c = 'Approved';
        leadRecord.Status = 'Converted';
        //leadRecord.CCApprovalStatus__c = 'Approved'; //Phase-1
        leadRecord.CountryCode__c = 'India (+91)';
        leadRecord.Expertise_LT__c = 'Human Capital Consulting';
        leadRecord.SMEG_LT__c = 'Cyber';
        leadRecord.Region__c = 'North';
        // leadRecord.IL_ApprovalRejectionRecommendation__c = 'fgnc';
        leadRecord.Company = 'Cloud Analogy1';
        leadRecord.Industry_Leader__c = u.Id;
        leadRecord.Industry__c = 'Banking';
        leadRecord.Email = 'testsgsed123@gmail.com';
        leadRecord.IsLead__c = True;
        leadRecord.capIQId__c = 'IQ8089740';
        //leadRecord.MCA_ID__c = 'KEP000003852898F';
        leadRecord.MobilePhone = '1234567891';
        // leadRecord.Sector__c ='Banking';
        leadRecord.New_Client_Address__Street__s = 'test,test';
        leadRecord.New_Client_Address__City__s ='test';
        leadRecord.New_Client_Address__PostalCode__s ='12345';
        leadRecord.New_Client_Address__StateCode__s='CT';
        leadRecord.New_Client_Address__CountryCode__s='IN';
        leadRecord.Next_Steps_and_Recommendations_from_BUEL__c = 'abc';
        leadRecord.Next_Steps_and_Recommendations_from_SC__c = 'cde';
        leadRecord.Next_Steps__c = 'fgh';
        leadRecord.Enquiry_Type__c = 'Strategic (STR)';
        
        insert leadRecord;
        
        Contact contactObj = TestDataFactory.createContact();
        contactObj.FirstName = 'Test Test1';
        contactObj.LastName = 'vijay1';
        contactObj.Email = 'testsgsed123@gmail.com';
        contactObj.MobilePhone = '1234567891';
        contactObj.AccountId = acc.Id;
        contactObj.is_Address_filled__c  = false;
        //insert contactObj;
        
        Lead leadRecordNew = TestDataFactory.createLeadRecord();
        leadRecordNew.LastName = 'Test Test2';
        leadRecordNew.FirstName = 'vijay1';
        //leadRecord.IndustryLeaderApprovalStatus__c = 'Approved';
        leadRecordNew.Status = 'Converted';
        //leadRecord.CCApprovalStatus__c = 'Approved'; //Phase-1
        leadRecordNew.CountryCode__c = 'India (+91)';
        leadRecordNew.Expertise_LT__c = 'Human Capital Consulting';
        leadRecordNew.SMEG_LT__c = 'Cyber';
        leadRecordNew.Region__c = 'North';
        // leadRecord.IL_ApprovalRejectionRecommendation__c = 'fgnc';
        leadRecordNew.Company = 'Cloud Analogy1';
        leadRecordNew.Industry_Leader__c = u.Id;
        leadRecordNew.Industry__c = 'Banking';
        leadRecordNew.Email = 'testsgsed123@gmail.com';
        leadRecordNew.IsLead__c = True;
        leadRecordNew.capIQId__c = 'IQ8089740';
        //leadRecord.MCA_ID__c = 'KEP000003852898F';
        leadRecordNew.MobilePhone = '1234567891';
        // leadRecord.Sector__c ='Banking';
        leadRecordNew.New_Client_Address__Street__s = 'test,test';
        leadRecordNew.New_Client_Address__City__s ='test';
        leadRecordNew.New_Client_Address__PostalCode__s ='12345';
        leadRecordNew.New_Client_Address__StateCode__s='CT';
        leadRecordNew.New_Client_Address__CountryCode__s='IN';
        leadRecordNew.Next_Steps_and_Recommendations_from_BUEL__c = 'abc';
        leadRecordNew.Next_Steps_and_Recommendations_from_SC__c = 'cde';
        leadRecordNew.Next_Steps__c = 'fgh';
        leadRecordNew.Enquiry_Type__c = 'Strategic (STR)';
        leadRecordNew.Existing_Client__c = acc.Id;
        leadRecordNew.is_Enquiry_Created_For_Existing_Client__c = true;
        
        insert leadRecordNew;
        
        /*    
IntegratedEnquiry__c intEnqObj = new IntegratedEnquiry__c();
intEnqObj.Company__c = 'Cloud Analogy';
intEnqObj.Industry__c = 'Banking';
intEnqObj.Solution1__c = 'Aviation and Defence';
intEnqObj.Expertise_LT__c = 'Human Capital Consulting';
insert intEnqObj;
*/
    }
    @isTest
    public static void leadAssignTest(){
        List<Lead> leadIdList = [Select Id from Lead];
        List<Id> idsList = new List<Id>();
        for(Lead rec:leadIdList){
            idsList.add(rec.Id);
        }
        Test.setMock(HttpCalloutMock.class, new MockCollout());
        Test.startTest();
        AutoConvertLeads.leadAssign(idsList);
        Test.stopTest();
        
        
    }
    
    /*
@isTest
public static void mapNewClintFieldsToClient(){
Lead leadIdList = [Select Id,Solution__c, TentativeFee__c, ClientContact__c, Expertise_LT__c, 
GTEmployee__c, Company, IsLead__c, 
LeadSource, Client__c, ClientBackground__c, ClientName__c, 
CompanyHQ__c, CAGR__c, Corridor__c, CountryCode__c, 
CSL__c, Email, EstimatedRevenue__c,
FindingPartner__c, GrowthPotential__c, InboundReferral__c, HeadQuarters__c, 
HowDidYouArriveAThisTentativeFee__c, Industry, Investors_Private_Equity_Firms__c, 
InvestorsPrivateEquityFirms__c, LawFirm__c, Market__c,
MobilePhone, Name, HowCanWeHelpYou__c, NewClientAge__c, OwnerId, Owner.Name, Channel__c, 
NumberOfEmployees, Industry_Leader__c, IL_ApprovalRejectionRecommendation__c, 
IndustryLeaderApprovedRejectedBy__c, IndustryLeaderApprovedRejectedDate__c, pi__campaign__c,pi__comments__c,
pi__conversion_date__c, pi__created_date__c, pi__first_activity__c, pi__grade__c, 
pi__last_activity__c, pi__Pardot_Last_Scored_At__c, pi__notes__c, pi__score__c, 
Phone,Rating, Recovery__c, Chamber__c, Remark__c, Industry__c, 
Industry_Business_Partner__c, Segment__c, ShortSummary__c, SMEG_LT__c, 
SubIndustry__c,  TotalRevenue__c, Website, YearFounded__c, 
CompanyHQ__City__s, CompanyHQ__CountryCode__s,CompanyHQ__GeocodeAccuracy__s, 
CompanyHQ__Latitude__s, CompanyHQ__Longitude__s, CompanyHQ__PostalCode__s, 
CompanyHQ__StateCode__s, CompanyHQ__Street__s, ConvertedAccountId, ConvertedContactId,
CreatedById, SolutionOther__c, Client_Region__c, Description,GT_Alumni_Name__c,Campaign__c,
GTI_Member_Firm_Referral_Country__c,GTI_Member_Firm_Referring_Person_s_name__c,GTI_Member_Firm_Office__c,
Independent_Director_Contact_Name__c, KMP__c,New_Client_Address__Street__s,New_Client_Address__City__s,New_Client_Address__PostalCode__s,New_Client_Address__StateCode__s,New_Client_Address__CountryCode__s,
New_Client_Address__Latitude__s,New_Client_Address__Longitude__s,New_Client_Address__GeocodeAccuracy__s,New_Client_Prospect_Address__Street__s,
New_Client_Prospect_Address__City__s, New_Client_Prospect_Address__PostalCode__s, New_Client_Prospect_Address__StateCode__s, New_Client_Prospect_Address__CountryCode__s,
New_Client_Prospect_Address__Latitude__s, New_Client_Prospect_Address__Longitude__s, New_Client_Prospect_Address__GeocodeAccuracy__s,Countries__c,Country_of_Incorporation__c,Currency_Format__c,Company_Status__c,Financial_Year__c,Global_Ultimate_Owner__c,
Gross_Profit__c,Company_Overview__c,capIQId__c,Client_Group_Name_CIQID__c,
Domestic_Ultimate_Owner__c,Current_Auditor_Name__c,Designation__c,External_Database_Source__c,Earnings_Before_Interest_and_Taxes_EBIT__c,
EBITDA__c,ExistingServiceProviders__c,Industry_CAP_IQ_MCA__c,Company_Phone_No__c,ISIN_Number__c,MCA_ID__c,Net_Income__c,Total_Debt__c,
Total_Assets__c,Total_Current_Assets__c,Total_Current_Liabilities__c,Total_Equity__c,Total_Liabilities__c,Total_No_of_employees__c,Total_Revenue__c,
Year_Founded__c,Public_Private_Company__c,Referral_Client__c,Shared_Up_Capital__c,PAN__c,Referral_Contact__c,SIC_Code__c,EntityId__c,Stock_Exchange_symbol__c,
Ticker_Symbol__c,Client_Group_Name__c,Global_Ultimate_Owner_ID__c,WorkingCapital__c,
FirstName, lastName from Lead limit 1];
Account accountList =[SELECT ShippingLongitude, SicDesc, ActivityMetricId, ActivityMetricRollupId, DaysSinceLastModified__c, AccountType__c, Account_Plan_Status__c, AnnualRevenue__c,
Assigned_to_DS_Team_Member__c, Assignment_Date__c, Business_Short_Description__c, CIN_LLPIN_DUO__c, CSL__c, ClientAddress__Street__s,
ClientAddress__City__s, ClientAddress__PostalCode__s, ClientAddress__StateCode__s, ClientAddress__CountryCode__s, ClientAddress__Latitude__s,
ClientAddress__Longitude__s, ClientAddress__GeocodeAccuracy__s, ClientAddress__c, ClientCompetitors__c, ClientGroupName__c, ClientGroup__c, ClientID__c,
ClientParentID__c, ClientServiceLeader__c, EinsteinClientTier__c, Email__c, Employees__c, EnquiryDescription__c, Expertise__c, Formerly_known_as_1__c,
Formerly_known_as_2__c, Formerly_known_as_3__c, Global_Ultimate_Owner_GUO__c, Global_Ultimate_Owner__c, Client_Synced__c, IsClientGTMemberFirm__c,
Is_Client_GreyListed__c, Is_Client_Name_Chnage_is_Approved__c, LegalEntityType__c, ListedUnlisted__c, NSL__c, NatureOfBusiness__c, NetProfit_InCr__c, NewClientName__c, NewSMEsIntroduced__c,
OperatingProfit_inCr__c, Pan_No__c, Pick_Record__c, PipelineConversion__c, ProposedClientOwner__c, Proposed_Account_Owner_Approval_Status__c, Proposed_CSL__c, Proposed_Client_Name__c, Proposed_Co_CSL__c, Public_Private_Company__c, RCCCurrentStatus__c, Rationale_to_make_Key_Client__c, RelationshipOffice__c, Relationship_Manager__c, Remark__c, SIC_Code__c, Industry__c, Segment__c, ShareCapitalInCr__c, Status_DS_Team_Remark_Status__c, Stock_Exchange_symbol__c, SubIndustry_Delete__c, SubIndustry__c, Ticker_Symbol__c, Earnings_Before_Interest_and_Taxes_EBIT__c, Referral_Channel__c, Total_Employees__c, Entity_Type_Master__c, Relationship_Office__c, Total_No_of_employees__c, Customer_Experience_Index__c, VerifiedByDSTeam__c, VerifiedDSTeamDate__c, Verified_by_Ds_Team__c, VerrifiedByDSTeam__c, YearEnded__c, Year_Founded__c, YoungCSL__c, capIQId__c, Account_Record_Type__c, WCGTId__c, DS_Team_Approval_Status__c, Domestic_Ultimate_Owner__c, goog_alert__Google_Alert_URL__c, Total_Revenue__c, EBITDA__c, Total_Assets__c, Total_Current_Assets__c, Total_Current_Liabilities__c, Total_Debt__c, Total_Equity__c, Total_Liabilities__c, Campaign__c, Channel_Type__c, Client_Account_Sub_Category__c, Client_Background__c, Client_Category__c, Client_Contact__c, Client_Group_Name_CIQID__c, Client_Name_Changed_On__c, Client_Name__c, Company_HQ__Street__s, Company_HQ__City__s, Company_HQ__PostalCode__s, Company_HQ__StateCode__s, Company_HQ__CountryCode__s, Company_HQ__Latitude__s, Company_HQ__Longitude__s, Company_HQ__GeocodeAccuracy__s, Company_HQ__c, Company_Phone_No__c, Company_Status__c, Compounded_Annual_Growth_Rate_CAGR__c, IsNameChange__c, Country_Corridor__c, Status_Checkbox__c, Currency_Format__c, Current_Auditor_Name__c, EntityId__c, Entity_Type__c, Estimated_Revenue__c, Existing_service_providers__c, External_Database_Source__c, Financial_Year__c, Former_Key_Account__c, Formerly_Known_As__c, GT_Client_Group__c, GT_Employee__c, GT_Member_Firms__c, Global_Ultimate_Owner_ID__c, Gross_Profit__c, Growth_Potential_Of_Client__c, Gx_Platinum_Gx_Gold_Cx__c, ISIN_Number__c, Industry_CAP_IQ_MCA__c, Investors_Private_Equity_Firms_Contact__c, Investors_Private_Equity_Firms__c, Key_Account_360__c, Key_Account__c, Last_Activity_Date__c, Last_Client_Activity_Date_Time__c, Last_MOM_Updated_Time__c, Law_Firm__c, MCA_ID__c, Net_Income__c, New_Client_Id__c, New_Client__c, Reason_Description__c, Reason__c, Referred_By_Channel__c, Referred_by_Chamber__c, Share_of_Wallet__c, Status__c, Total_Diluted_Earning_Loss_per_Share__c, Channel_and_Alliance_Type__c, Client_Sub_Category__c, Key_Account_Category__c, Key_Account_Group__c, Key_Account_Id__c, Key_Accountt__c, Sub_Segment__c, Salesforce_Id__c, Referral_Client__c, Country_Code__c, Customer_Satisfaction_Index__c, Detractor__c, Net_Promoter_Score__c, Passive__c, Promoter__c, Country_HQ__c, Referral_Contact__c, Is_Record_Type_Change__c, Bill_to_Client__c, Is_Client_From_Bill_To_Client__c, Working_capital__c, Segment_Leader_Mapped__c, Industry_Leader_Mapped__c, LegacyData__c, Relationship_Leader_Mapped__c, Salesforce_Id_For_Client__c, Domestic_Ultimate_Owner_DUO__c, Designation__c, DUOLocation__c, DUOAddress__c, DUOAddress__GeocodeAccuracy__s, DUOAddress__Longitude__s, DateofIncorporation__c, DUOAddress__Latitude__s, DUOAddress__CountryCode__s, DUOAddress__StateCode__s, DUOAddress__PostalCode__s, DUOAddress__City__s, DUOAddress__Street__s, DS_Team_Verification_date__c, DS_Team_Approved_RejectedBy__c, DS_Team_Approval_Rejection_Remarks__c, DS_Team_Approval_Rejection_Date__c, CxScore__c, CreationDate__c, Country_of_Incorporation__c, Corridor__c, Company_Website__c, Company_Overview__c, CollectionInCharge__c, CoCSL__c, Client_s_Headquarter__c, Client_s_Headquarter__GeocodeAccuracy__s, Client_s_Headquarter__Longitude__s, Client_s_Headquarter__Latitude__s, Client_s_Headquarter__StateCode__s, Client_s_Headquarter__CountryCode__s, Client_s_Headquarter__PostalCode__s, Client_s_Headquarter__City__s, Client_reason_if_inactive__c, Client_s_Headquarter__Street__s, Client_Name_changed_on_2__c, Client_Name_changed_on_3__c, Client_Name_changed_on_1__c, Client_Location__c, ClientStatus__c, AccountSource, JigsawCompanyId, Id, Name, Type, BillingStreet, BillingCity, BillingState, BillingPostalCode, BillingLatitude, BillingCountry, BillingLongitude, BillingGeocodeAccuracy, BillingAddress, ShippingStreet, ShippingCity, ShippingState, ShippingPostalCode, ShippingCountry, ShippingLatitude, ShippingGeocodeAccuracy, ShippingAddress, AccountNumber, Website, PhotoUrl, Industry, AnnualRevenue, NumberOfEmployees, Ownership, Description, Rating, Site, OwnerId FROM Account limit 1];


List<Id> idsList = new List<Id>();
for(Lead rec:leadIdList){
idsList.add(rec.Id);
}

Test.setMock(HttpCalloutMock.class, new MockCollout());
Test.startTest();
AutoConvertLeads.mapNewClintFieldsToClient(leadIdList,accountList);
Test.stopTest();


}

*/
    
    /*@isTest
    public static void leadAssignExceptionTest(){
        List<Lead> leadIdList = [Select Id from Lead];
        Account accObj = [Select Id from Account LIMIT 1];
        
        List<Id> idsList = new List<Id>();
        for(Lead rec:leadIdList){
            rec.is_Enquiry_Created_For_Existing_Client__c = true;
            idsList.add(rec.Id);
        }
        Test.setMock(HttpCalloutMock.class, new MockCollout());
        Test.startTest();
        AutoConvertLeads.leadAssign(idsList);
        Test.stopTest();
        
        
    }*/
    
}