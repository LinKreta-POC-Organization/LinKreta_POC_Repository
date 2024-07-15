global without sharing class AutoConvertLeads {
    @InvocableMethod
    public static void leadAssign(List<Id> leadIds){
        
        List<Lead> enquiryListToUpdate = new List<Lead>(); // Added by Suraj --> Contain the enquiry records to update the Converted Client.
        List<Account> accList = new List<Account>();        
        LeadStatus cLeadStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted = True AND MasterLabel = 'Converted' LIMIT 1];
        
        List<Lead> ldList = [SELECT Id, OwnerId,capIQId__c,MCA_ID__c,Company, Existing_Client__c, FirstName, LastName, Email, MobilePhone, is_Enquiry_Created_For_Existing_Client__c,ConvertedAccountId,ConvertedContactId, Existing_Client__r.DS_Team_Approval_Status__c FROM Lead Where id IN :leadIds];
        //duplicate lead Company Name Set
        System.debug('ldList-->'+ldList);
        Set<String> dupClientName = New Set<String>();
        
        List<Database.LeadConvert> massLeadConvert = new List<Database.LeadConvert>();
        Set<Id> enquiryIdSetToSyncToWCGT = new Set<Id>(); // Contains the enquiry Ids which need to be synced to WCGT after the conversion.
        // Added by Suraj for Existing Client functionality
        Set<String> existingContactIdentifierSet = new Set<String>(); 

        Set<String> firstNameSet = new Set<String>();  
        Set<String> lastNameSet = new Set<String>();  
        Set<String> emailSet = new Set<String>();  
        Set<String> mobilePhoneSet = new Set<String>();  
        Set<String> companySet = new Set<String>();  
        Map<Id, Id> existingClientIdMap = new Map<Id, Id>();
        Map<String, Contact> existingAccountToContactMap = new Map<String, Contact>();

        for(Lead lead : ldList) {
            System.debug('Existing client : ' + lead.Existing_Client__c);
            if(lead.Existing_Client__c != null && lead.is_Enquiry_Created_For_Existing_Client__c == true){
                // Start- Enquiry sync to WCGT
                if(lead.Existing_Client__r.DS_Team_Approval_Status__c == 'DS Approved'){
                    enquiryIdSetToSyncToWCGT.add(lead.Id);
                }
                //End
                existingClientIdMap.put(lead.Existing_Client__c, lead.Existing_Client__c);
                existingContactIdentifierSet.add(lead.FirstName+lead.lastName+lead.Email+lead.MobilePhone+lead.Company);

                if(String.isNotBlank(lead.FirstName)){
                    firstNameSet.add(lead.FirstName);
                }
                if(String.isNotBlank(lead.LastName)){
                    lastNameSet.add(lead.LastName);
                }
                if(String.isNotBlank(lead.Email)){
                    emailSet.add(lead.Email);
                }
                if(String.isNotBlank(lead.MobilePhone)){
                    mobilePhoneSet.add(lead.MobilePhone);
                }
                if(String.isNotBlank(lead.Company)){
                    companySet.add(lead.Company);
                }
            }

        }

        System.debug('existingContactIdentifierSet : ' + existingContactIdentifierSet);

        for(Contact contactObj : [SELECT Id, FirstName, LastName, Email, MobilePhone, AccountId, Client_Location__Longitude__s, Client_Location__Latitude__s, Client_Location__CountryCode__s, Client_Location__StateCode__s,Client_Location__PostalCode__s, Client_Location__City__s, Client_Location__Street__s, Client_Location__GeocodeAccuracy__s, Account_Name__c FROM Contact WHERE FirstName IN : firstNameSet OR lastName IN : lastNameSet OR Email IN: emailSet OR MobilePhone IN : mobilePhoneSet]){
            String existingContactIdentifier = contactObj.FirstName+contactObj.lastName+contactObj.Email+contactObj.MobilePhone+contactObj.Account_Name__c;
            System.debug('existingContactIdentifier : ' + existingContactIdentifier);
            if(existingContactIdentifierSet.contains(existingContactIdentifier)){
                existingAccountToContactMap.put(existingContactIdentifier, contactObj);
            }
        }

        System.debug('existingClientIdMap : ' + existingClientIdMap);
        System.debug('existingAccountToContactMap : ' + existingAccountToContactMap);
        
        for(Lead lead : ldList) { 
            Database.LeadConvert leadConvert = new Database.LeadConvert();
            
            if(String.isNotBlank(lead.Existing_Client__c) && existingClientIdMap.containsKey(lead.Existing_Client__c) && lead.is_Enquiry_Created_For_Existing_Client__c == true){
                leadConvert.setAccountId(existingClientIdMap.get(lead.Existing_Client__c));
                //27-03-24 Modified by Prashant
                String existingContactIdentifier = lead.FirstName+lead.lastName+lead.Email+lead.MobilePhone+lead.Company;
                if(existingAccountToContactMap.containsKey(existingContactIdentifier)){
                    System.debug('Converted contact Id added : ' + existingAccountToContactMap.get(existingContactIdentifier).Id);
                    leadConvert.setContactId(existingAccountToContactMap.get(existingContactIdentifier).Id);
                }
            }

            

            // End of Existing Client functionality
            lead.ByPassValidation__c  = true;
            leadConvert.setLeadId(lead.id);
            leadConvert.setConvertedStatus(cLeadStatus.MasterLabel);
            leadConvert.setOwnerId(lead.OwnerId);
            leadConvert.setDoNotCreateOpportunity(TRUE);
            System.debug('Lead Convert'+leadConvert);
            massLeadConvert.add(leadConvert);
            dupClientName.add(lead.Company);
        }
        if(!massLeadConvert.isEmpty()){
            
            if(!accList.isEmpty()){
                update accList;
            }
            System.debug('massLeadConvert : '+massLeadConvert);
            List<Database.LeadConvertResult> lCR = Database.convertLead(massLeadConvert);
        }
        
        
        List<Lead> leadList = [SELECT Id,Solution__c, TentativeFee__c, ClientContact__c,  
                               GTEmployee__c, Company, IsLead__c, 
                               LeadSource, Client__c, ClientBackground__c, ClientName__c, 
                               CompanyHQ__c, CAGR__c, Corridor__c, CountryCode__c, 
                               CSL__c, Email, EstimatedRevenue__c,
                               FindingPartner__c, GrowthPotential__c,  HeadQuarters__c, 
                               HowDidYouArriveAThisTentativeFee__c, Industry, Investors_Private_Equity_Firms__c, 
                               InvestorsPrivateEquityFirms__c, LawFirm__c, Market__c,
                               MobilePhone, Name, HowCanWeHelpYou__c, NewClientAge__c, OwnerId, Owner.Name, Channel__c, 
                               NumberOfEmployees, Industry_Leader__c,pi__comments__c,
                               pi__conversion_date__c, pi__created_date__c, pi__first_activity__c, pi__grade__c, 
                               pi__last_activity__c, pi__Pardot_Last_Scored_At__c, pi__notes__c, pi__score__c, 
                                Phone,Rating, Recovery__c, Chamber__c, Remark__c, Industry__c, 
                               Industry_Business_Partner__c, Segment__c, ShortSummary__c,  
                               SubIndustry__c,  TotalRevenue__c, Website, YearFounded__c, 
                               CompanyHQ__City__s, CompanyHQ__CountryCode__s,CompanyHQ__GeocodeAccuracy__s, 
                               CompanyHQ__Latitude__s, CompanyHQ__Longitude__s, CompanyHQ__PostalCode__s, 
                               CompanyHQ__StateCode__s, CompanyHQ__Street__s, ConvertedAccountId, ConvertedContactId,
                               CreatedById, SolutionOther__c, Client_Region__c, Description,GT_Alumni_Name__c,
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
                               FirstName, lastName
                               From Lead Where id IN :leadIds];
        System.debug('leadList : '+leadList);
        System.debug('Lead Status'+cLeadStatus);
        Map<Id, Account> existingAccountQueriedMap = new Map<Id, Account> ([SELECT Id, Name, Client_s_Headquarter__Street__s, Client_s_Headquarter__City__s, Client_s_Headquarter__PostalCode__s, Client_s_Headquarter__StateCode__s, Client_s_Headquarter__CountryCode__s, Client_s_Headquarter__Latitude__s, Client_s_Headquarter__Longitude__s, Client_s_Headquarter__GeocodeAccuracy__s, ClientAddress__Street__s, ClientAddress__City__s, ClientAddress__PostalCode__s, ClientAddress__StateCode__s, ClientAddress__CountryCode__s, ClientAddress__Latitude__s, ClientAddress__Longitude__s, ClientAddress__GeocodeAccuracy__s, Is_Record_Type_Change__c, Status__c, New_Client__c, Is_Client_From_Bill_To_Client__c, AccountType__c, RecordTypeId  FROM Account WHERE Id IN: existingClientIdMap.values()]);
        Map<Id, Account> mapAccountToUpdate = new Map<Id, Account>();
        Account objAccount;
        Map<Id, Contact> mapContactToUpdate = new Map<Id, Contact>();
        Contact objContact;
        for(Lead lead : leadList) { 
            // setIENames.add(lead.Company + '%');  --- Commented by Suraj 21-03-2024
            if(lead.ConvertedAccountId != null) {
                System.debug('lead.ConvertedAccountId : ' + lead.ConvertedAccountId);
                lead.Converted_Client__c = lead.ConvertedAccountId;
                lead.ByPassValidation__c = true; 
                enquiryListToUpdate.add(lead);
                objAccount = new Account();
                if(existingAccountQueriedMap.containsKey(lead.ConvertedAccountId)) {
                    objAccount = existingAccountQueriedMap.get(lead.ConvertedAccountId);
                }
                objAccount.Id = lead.ConvertedAccountId;
                system.debug('lead.ConvertedAccountId>>'+lead.ConvertedAccountId);
                objAccount.Client_s_Headquarter__Street__s = lead.CompanyHQ__Street__s == Null ? objAccount.Client_s_Headquarter__Street__s : lead.CompanyHQ__Street__s;
                objAccount.Client_s_Headquarter__City__s = lead.CompanyHQ__City__s == Null ? objAccount.Client_s_Headquarter__City__s : lead.CompanyHQ__City__s;
                objAccount.Client_s_Headquarter__PostalCode__s = lead.CompanyHQ__PostalCode__s == Null ? objAccount.Client_s_Headquarter__PostalCode__s : lead.CompanyHQ__PostalCode__s;
                objAccount.Client_s_Headquarter__StateCode__s = lead.CompanyHQ__StateCode__s == Null ? objAccount.Client_s_Headquarter__StateCode__s : lead.CompanyHQ__StateCode__s;
                objAccount.Client_s_Headquarter__CountryCode__s = lead.CompanyHQ__CountryCode__s == Null ? objAccount.Client_s_Headquarter__CountryCode__s : lead.CompanyHQ__CountryCode__s;
                objAccount.Client_s_Headquarter__Latitude__s = lead.CompanyHQ__Latitude__s == Null ? objAccount.Client_s_Headquarter__Latitude__s : lead.CompanyHQ__Latitude__s;
                objAccount.Client_s_Headquarter__Longitude__s = lead.CompanyHQ__Longitude__s == Null ? objAccount.Client_s_Headquarter__Longitude__s : lead.CompanyHQ__Longitude__s;
                objAccount.Client_s_Headquarter__GeocodeAccuracy__s = lead.CompanyHQ__GeocodeAccuracy__s == Null ? objAccount.Client_s_Headquarter__GeocodeAccuracy__s : lead.CompanyHQ__GeocodeAccuracy__s;

                //New Client Address to  ClientAddress
                // Added by Deepak Joshi 13 oct 2023
                objAccount.ClientAddress__Street__s = lead.New_Client_Address__Street__s == Null ? objAccount.ClientAddress__Street__s : lead.New_Client_Address__Street__s;
                objAccount.ClientAddress__City__s = lead.New_Client_Address__City__s == Null ? objAccount.ClientAddress__City__s : lead.New_Client_Address__City__s;
                objAccount.ClientAddress__PostalCode__s = lead.New_Client_Address__PostalCode__s == Null ? objAccount.ClientAddress__PostalCode__s : lead.New_Client_Address__PostalCode__s;
                objAccount.ClientAddress__StateCode__s = lead.New_Client_Address__StateCode__s == Null ? objAccount.ClientAddress__StateCode__s : lead.New_Client_Address__StateCode__s;
                objAccount.ClientAddress__CountryCode__s = lead.New_Client_Address__CountryCode__s == Null ? objAccount.ClientAddress__CountryCode__s : lead.New_Client_Address__CountryCode__s;
                objAccount.ClientAddress__Latitude__s = lead.New_Client_Address__Latitude__s == Null ? objAccount.ClientAddress__Latitude__s : lead.New_Client_Address__Latitude__s;
                objAccount.ClientAddress__Longitude__s = lead.New_Client_Address__Longitude__s == Null ? objAccount.ClientAddress__Longitude__s : lead.New_Client_Address__Longitude__s;
                objAccount.ClientAddress__GeocodeAccuracy__s = lead.New_Client_Address__GeocodeAccuracy__s == Null ? objAccount.ClientAddress__GeocodeAccuracy__s : lead.New_Client_Address__GeocodeAccuracy__s;
                
                objAccount.New_Client__c =lead.Id;
                
                mapAccountToUpdate.put(lead.ConvertedAccountId, objAccount);
            }
            String existingContactIdentifier = lead.FirstName+lead.lastName+lead.Email+lead.MobilePhone;
            if(lead.ConvertedContactId != null && existingAccountToContactMap.containsKey(existingContactIdentifier)) {
                System.debug('ConvertedContactId--->'+lead.ConvertedContactId);
                objContact = new Contact();
                objContact = existingAccountToContactMap.get(existingContactIdentifier);
                objContact.Id = lead.ConvertedContactId;
                objContact.New_Client__c = lead.Id;
                objContact.LeadSource = lead.LeadSource == Null ? objContact.LeadSource : lead.LeadSource;
                objContact.MobilePhone = lead.MobilePhone == Null ? objContact.MobilePhone : lead.MobilePhone;
                objContact.Email = lead.Email == Null ? objContact.Email : lead.Email;
                
                mapContactToUpdate.put(lead.ConvertedContactId, objContact);
            }
        }
        
        // Added by Suraj to update the Converted Client field value which will used to display the converted client to user.
        if (!enquiryListToUpdate.isEmpty()) {
            update enquiryListToUpdate;
           
        }
        if(!mapAccountToUpdate.isEmpty()){
            update mapAccountToUpdate.values();
        }
        if(!mapContactToUpdate.isEmpty()){
            try{
                update mapContactToUpdate.values();
            }
            catch(Exception e){
                System.debug('Exception message : ' + e.getMessage());
            }
        }

        if(!enquiryIdSetToSyncToWCGT.isEmpty()){
            for (Id enquiryId : enquiryIdSetToSyncToWCGT) {
                salesforceToWCGT.syncEnquiryToWCGTFuture(enquiryId);
            }
        }
        
        if(enquiryListToUpdate.size() > 0){
            for(lead objLead : enquiryListToUpdate){

                objLead.ByPassValidation__c = false;
            }

           update enquiryListToUpdate;
        }
            
    }
    /*
     * Commented By Suraj Kumar for phase 1 on 18-04-2024
    public static void mapNewClintFieldsToClient(Lead led ,Account acc){
        
        acc.OwnerId = led.OwnerId;
        system.debug('Is_Client_From_Bill_To_Client__c406'+acc.Is_Client_From_Bill_To_Client__c);
        acc.Is_Client_From_Bill_To_Client__c = false;
        acc.Country_Code__c = led.CountryCode__c;
        acc.Country_of_Incorporation__c  = led.Country_of_Incorporation__c;
        acc.Currency_Format__c = led.Currency_Format__c;
        acc.Gx_Platinum_Gx_Gold_Cx__c  = led.Client_Region__c;
        acc.Company_Status__c  = led.Company_Status__c;
        acc.Compounded_Annual_Growth_Rate_CAGR__c = led.CAGR__c; 
        acc.Corridor__c = led.Corridor__c;
        acc.Growth_Potential_Of_Client__c = led.GrowthPotential__c;
        acc.GT_Employee__c = led.GTEmployee__c;
        acc.Financial_Year__c  = led.Financial_Year__c;
        acc.Global_Ultimate_Owner__c  = led.Global_Ultimate_Owner__c;
        acc.GT_Member_Firms__c = led.InboundReferral__c;
        acc.ClientGroup__c = led.Client_Group_Name__c;
        acc.Global_Ultimate_Owner_ID__c = led.Global_Ultimate_Owner_ID__c;
        acc.Gross_Profit__c = led.Gross_Profit__c;
        acc.Company_Overview__c  = led.Company_Overview__c;
        acc.Client_Background__c = led.ClientBackground__c; 
        acc.Client_Contact__c = led.ClientContact__c;
        acc.Client_Group_Name_CIQID__c = led.Client_Group_Name_CIQID__c;
        acc.Client_Name__c = led.ClientName__c;
        acc.Domestic_Ultimate_Owner__c = led.Domestic_Ultimate_Owner__c;
        acc.Current_Auditor_Name__c = led.Current_Auditor_Name__c;
        acc.Designation__c = led.Designation__c;
        acc.Earnings_Before_Interest_and_Taxes_EBIT__c = led.Earnings_Before_Interest_and_Taxes_EBIT__c;
        acc.EBITDA__c = led.EBITDA__c;
        acc.Existing_service_providers__c = led.ExistingServiceProviders__c;
        acc.Campaign__c = led.Campaign__c;
        acc.Investors_Private_Equity_Firms_Contact__c = led.InvestorsPrivateEquityFirms__c;
        acc.Company_Phone_No__c = led.Company_Phone_No__c;
        acc.Industry_CAP_IQ_MCA__c = led.Industry_CAP_IQ_MCA__c;
        acc.Investors_Private_Equity_Firms__c = led.Investors_Private_Equity_Firms__c;
        acc.ISIN_Number__c = led.ISIN_Number__c;
        acc.Law_Firm__c = led.LawFirm__c;
        acc.Net_Income__c = led.Net_Income__c;
        acc.Total_Debt__c = led.Total_Debt__c;
        acc.Total_Assets__c = led.Total_Assets__c;
        acc.Total_Current_Assets__c = led.Total_Current_Assets__c;
        acc.Total_Current_Liabilities__c = led.Total_Current_Liabilities__c;
        acc.Total_Equity__c = led.Total_Equity__c;
        acc.Total_Liabilities__c  = led.Total_Liabilities__c;
        acc.AnnualRevenue__c = led.TotalRevenue__c;
        acc.Year_Founded__c = led.Year_Founded__c;
        acc.Public_Private_Company__c = led.Public_Private_Company__c;
        acc.Referral_Client__c = led.Referral_Client__c;
        acc.Pan_No__c = led.PAN__c;
        acc.Referral_Contact__c = led.Referral_Contact__c;
        acc.Referred_by_Chamber__c = led.Chamber__c;
        acc.SIC_Code__c = led.EntityId__c;
        acc.Stock_Exchange_symbol__c = led.Stock_Exchange_symbol__c;
        acc.Ticker_Symbol__c  = led.Ticker_Symbol__c;
        if(String.isNotBlank(led.MCA_ID__c)){
            acc.MCA_ID__c = led.MCA_ID__c;
        }
        if(String.isNotBlank(led.capIQId__c)){
            acc.capIQId__c = led.capIQId__c;
        }
        if(String.isNotBlank(led.External_Database_Source__c)){
            acc.External_Database_Source__c = led.External_Database_Source__c;
        }
        if(String.isNotBlank(led.SubIndustry__c)){
            acc.SubIndustry__c = led.SubIndustry__c;
        }
        if(String.isNotBlank(led.Industry__c)){
            acc.Industry__c = led.Industry__c;
        }
        if(led.Shared_Up_Capital__c !=null){
            acc.ShareCapitalInCr__c = led.Shared_Up_Capital__c;
        }
        if(led.Total_No_of_employees__c !=null){
            acc.Total_No_of_employees__c = led.Total_No_of_employees__c;
        }
        if(led.Total_Revenue__c !=null){
            acc.Total_Revenue__c = led.Total_Revenue__c;
        }
        acc.Working_Capital__c = led.WorkingCapital__c;		            
        
    }*/
}