/* 
Written By: Bhanwar Singh
Created Date: 12/20/2022
Last Modified By : 
Last Modified Date : 28/7/23
Description : This class is used to send data from Salesforce to WCGT.
*/

public without sharing class salesforceToWCGT {
    //Send When NSL Approved 
    
    // Commented by Suraj for Phase 1 - Start

    // @Future(callout=true)
    // public static Void sendWhenNSLApprovedNewClient(id NewClientid)
    // {
    //     String reqBody = '';
    //     String responseBody = '';
    //     WCGTEndPoint__mdt bdRecord = [SELECT Id, MasterLabel, URL__c FROM WCGTEndPoint__mdt Where Label = 'New Client' limit 1];
    //     try{
    //         Http http = new Http();
    //         HttpRequest req = new HttpRequest();
    //         req.setEndpoint(bdRecord.URL__c);
            
    //         req.setMethod('POST');
    //         String token = SalesforceToWCGTAccess.getAuthenticationToken();
    //         req.setHeader('Authorization','Bearer '+token);
    //         req.setHeader('Content-Type','application/json'); 
    //         Lead leads = [SELECT Id,FirstName,MobilePhone,CountryCode__c,LastName,Phone,Status,Email,Company,OwnerId FROM Lead WHERE id =:  NewClientid Limit 1];
    //         User users = [SELECT Id, USER_ID__c FROM User Where Id =: leads.OwnerId Limit 1];
    //         String statuss;
    //         integer wcgtStatus;
    //         if(leads.Status == 'Accept Client' ){
    //             statuss = 'New Client Accepted';
    //             wcgtStatus=2;
    //         }else if(leads.Status == 'NotAccept' ){
    //             statuss = 'New Client Not Accepted';
    //             wcgtStatus=3;
    //         }else{
    //             statuss = 'NSL Approved';
    //             wcgtStatus=1;
    //         }
    //         list<String> slist = leads.CountryCode__c.split('\\('); 
    //         slist = slist[1].split('\\)');
    //         System.debug(slist[0]);
    //         String userId ;
    //         if(users.USER_ID__c == Null|| users.USER_ID__c ==''){
    //             userId = 'US00012';
    //         }
    //         else{
    //             userId = users.USER_ID__c;
    //         }
    //         reqBody = '{"sFirstName": "'+leads.FirstName+'","sLastName": "'+leads.LastName+'","sNewClientId": "'+leads.Id+'","sMobileNo": "'+slist[0]+leads.MobilePhone+'","sCompanyName": "'+leads.Company+'","sStatus": "'+wcgtStatus+'","sStatusReason": "'+statuss+'","sUserId": "'+userId+'","sEmail": "'+leads.Email+'"}';
    //         system.debug('reqBody'+reqBody);
    //         req.setBody(reqBody);
    //         System.debug('req-->'+req);
    //         HttpResponse resp = http.send(req);
    //         System.debug('resp -->'+resp);
    //         System.debug('resp getBody -->'+resp.getBody());
    //         responseBody = resp.getBody();
    //         API_Logger__c apiLog = API_LoggerCommonUtility.createAPILogger(NewClientid,reqBody,responseBody,resp.getStatus(),'salesforceToWCGT.sendWhenNSLApprovedNewClient',bdRecord.URL__c,resp.getStatusCode(),null,null);                  
    //         Insert apiLog;  
    //         //API_Logger__c apiLogTest = API_LoggerCommonUtility.createAPILogger(NewClientid,reqBody,responseBody,resp.getStatus(),'salesforceToWCGT.sendWhenNSLApprovedNewClient',token);                  
    //         //Insert apiLogTest;      
    //     } catch(Exception e){
    //         System.debug(e.getMessage());
    //         ErrorLogCreater_cls.apexDebugLoggerForAPICallout(e, 'salesforceToWCGT' , 'sendWhenNSLApprovedNewClient' , '' , reqBody,responseBody, bdRecord.URL__c );
    //     }
    // }
    //When New CLient Not Accepted
    // @future(callout=true)
    // public static Void sendWhenNewClientNotAccepted(id NewClientid)
    // {
    //     Http http = new Http();
    //     HttpRequest req = new HttpRequest();
    //     WCGTEndPoint__mdt bdRecord = [SELECT Id, MasterLabel, URL__c FROM WCGTEndPoint__mdt Where Label = 'New Client' limit 1];
    //     req.setEndpoint(bdRecord.URL__c);
    //     req.setMethod('POST');
    //     String token = SalesforceToWCGTAccess.getAuthenticationToken();
    //     req.setHeader('Authorization','Bearer '+token);
    //     req.setHeader('Content-Type','application/json'); 
    //     Lead leads = [SELECT Id,FirstName,LastName,Client__c,Phone,Remark__c,Expertise_LT__c ,Industry__c,Email ,Description FROM Lead WHERE id =:  NewClientid];
    //     String reqBody = '{"sFirstName": "'+leads.FirstName+'","sLastName": "'+leads.LastName+'","sClientId": "'+leads.Client__c+'","sMobileNo": "'+leads.Phone+'","sExperties": "'+leads.Expertise_LT__c+'","sDesignation": "IT","sEmail":"'+leads.Email+'","sSector": "'+leads.Industry__c+'","sEnqDesc": "'+leads.Description+'","sRemarks": "IT"}';
    //     system.debug('reqBody'+reqBody);
    //     req.setBody(reqBody);
    //     HttpResponse resp = http.send(req);
    //     System.debug('resp -->'+resp);
    //     String resp1;
        
    // }


    // Phase 1 End
    
    /*
    Added by Suraj Kumar 27-03-2024
    Description : This method is used to send the enquiry data to WCGT.
*/
    @future(callout=true)
    public static void syncEnquiryToWCGTFuture(Id enquiryId){
        try {
            Lead syncedEnquiry;
            Api_Logger__c enquiryApiLog;
            List<Api_Logger__c> apiLoggerList = syncEnquiryToWCGT(enquiryId);
            for (Api_Logger__c apiLog : apiLoggerList) {
                if(apiLog.Class_Name__c == 'salesforceToWCGT.syncEnquiryToWCGT' && apiLog != null){
                    enquiryApiLog = apiLog;
                }
            }
            if (enquiryApiLog != null) {
                if (enquiryApiLog.Status_Code__c == 200) {
                    syncedEnquiry= new Lead(Id = enquiryApiLog.Record_Id__c, Is_Synced_with_WCGT__c = true, ByPassValidation__c = true);
                }
            }

            if (syncedEnquiry != null) {
                update syncedEnquiry;
                syncedEnquiry.ByPassValidation__c = false;
                update syncedEnquiry;
            }

            if(!apiLoggerList.isEmpty()){
                insert apiLoggerList;
            }

        } catch (Exception e) {
            System.debug('Exception : ' + e.getStackTraceString());
            ErrorLogCreater_cls.apexDebugLogger(e, 'salesforceToWCGT' , 'syncEnquiryToWCGTFuture' , enquiryId );
        }
        
    }

    public static List<Api_Logger__c> syncEnquiryToWCGT(Id enquiryId){
        List<Api_Logger__c> apiLoggerList = new List<Api_Logger__c>();
        String reqBody = '';
        String responseBody = '';
        WCGTEndPoint__mdt metadataRecord = [SELECT Id, MasterLabel, URL__c FROM WCGTEndPoint__mdt Where Label = 'New Client' limit 1];
        String endpoint;
        try{
            Http http = new Http();
            HttpRequest req = new HttpRequest();
            SalesforceToWCGTAccess.TokenResponse tokenResp = SalesforceToWCGTAccess.getAuthentication(enquiryId);
            apiLoggerList.add(tokenResp.apiLog);
            System.debug('tokenResp.token--'+tokenResp.token);
            endpoint = metadataRecord.URL__c + '?stoken=' + tokenResp.token;
            System.debug('endpoint--'+endpoint);
            req.setEndpoint(endpoint);
            req.setMethod('POST');
            req.setHeader('Content-Type','application/json'); 
            
            Lead enquiryRecord = [SELECT Id,FirstName,MobilePhone,LastName,Email,Company,OwnerId, Description, Enquiry_Expertise__c, Designation__c, Current_Steps__c, Industry__c, Enquiry_Type__c, Next_Steps_and_Recommendations_from_SC__c, Next_Steps_and_Recommendations_from_BUEL__c,
                                  Last_Modified_By_for_WCGT__r.USER_ID__c
                                  FROM Lead WHERE Id =: enquiryId];
            
            User userRecord = [SELECT Id, USER_ID__c FROM User Where Id =: enquiryRecord.OwnerId];
            
            String userId = (userRecord.USER_ID__c == Null|| userRecord.USER_ID__c =='') ? ConstantUtility.Dummy_UserId : userRecord.USER_ID__c;
            String updatedUserId = enquiryRecord.Last_Modified_By_for_WCGT__r.USER_ID__c;

            List<String> expertiseList = new List<String>();
            String industryValue;
            String enquiryType;

            for(Enquiry_Expertise__c enquiryExpertise : [SELECT Id, Enquiry__c, Expertise_Master__c, Expertise_Master__r.LOV_Id__c FROM Enquiry_Expertise__c WHERE Enquiry__c =: enquiryId]){
                expertiseList.add(enquiryExpertise.Expertise_Master__r.LOV_Id__c);
            }
            
            for(WCGT_Master__c masterRecord : [SELECT Id, Para_Desc__c, WCGT_Id__c, Type__c FROM WCGT_Master__c WHERE Type__c = 'Enquiry Type' OR Type__c = 'Industry']){
                if(masterRecord.Type__c == 'Industry' && masterRecord.Para_Desc__c == enquiryRecord.Industry__c){
                    industryValue = masterRecord.WCGT_Id__c;
                }
                if(masterRecord.Type__c == 'Enquiry Type' && masterRecord.Para_Desc__c == enquiryRecord.Enquiry_Type__c){
                    enquiryType = masterRecord.WCGT_Id__c;
                }
            }

            salesforceToWCGTHelper.EnquirySyncRequestWrapper requestWrapper = new salesforceToWCGTHelper.EnquirySyncRequestWrapper();
            requestWrapper.sFirstName = enquiryRecord.FirstName;
            requestWrapper.sLastName = enquiryRecord.LastName;
            requestWrapper.sNewClientId = enquiryRecord.Id;
            requestWrapper.sMobileNo = enquiryRecord.MobilePhone;
            requestWrapper.sUserId = userId;
            requestWrapper.sUpdatedUserId = updatedUserId;
            requestWrapper.sEmail = enquiryRecord.Email;
            requestWrapper.sCompanyName = enquiryRecord.Company;
            requestWrapper.sEnquiryType = enquiryType;
            requestWrapper.sEnquiryDescription = enquiryRecord.Description;
            requestWrapper.sDesignation = enquiryRecord.Designation__c;
            requestWrapper.sSECTOR = industryValue;
            requestWrapper.sEXPERTIES = String.join(expertiseList, ',');
            requestWrapper.sNextSteps = enquiryRecord.Enquiry_Type__c == ConstantUtility.STRATEGIC_STR ? enquiryRecord.Next_Steps_and_Recommendations_from_SC__c : enquiryRecord.Next_Steps_and_Recommendations_from_BUEL__c;
            reqBody = JSON.serialize(requestWrapper);
            
            system.debug('reqBody'+reqBody);
            req.setBody(reqBody);
            System.debug('req-->'+req);
            HttpResponse resp = http.send(req);
            System.debug('resp getBody -->'+resp.getBody());
            responseBody = resp.getBody();

            API_Logger__c enquirySyncApiLog = API_LoggerCommonUtility.createAPILogger(enquiryId,reqBody,responseBody,resp.getStatus(),'salesforceToWCGT.syncEnquiryToWCGT',endpoint,resp.getStatusCode(),null,null);    

            apiLoggerList.add(enquirySyncApiLog);
            
            if (!apiLoggerList.isEmpty()) {
                return apiLoggerList;     
                
            } else {
                return null;
            }

        } catch(Exception e){
            System.debug(e.getStackTraceString());
            ErrorLogCreater_cls.apexDebugLoggerForAPICallout(e, 'salesforceToWCGT' , 'syncEnquiryToWCGT' , '' , reqBody,responseBody, endpoint );
            return null;
        }
    }
    
    //On Client Creation, record data will be pushed to WCGT - 28
    //On Lead Conversion, Client Record will be created and pushed to WCGT - 29
    @Future(callout=true)
    public static Void sendWhenClientCreation(id clientId)
    {
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        WCGTEndPoint__mdt bdRecord = [SELECT Id, MasterLabel, URL__c FROM WCGTEndPoint__mdt Where Label = 'Client' limit 1];
        req.setEndpoint(bdRecord.URL__c);
        req.setMethod('POST');
        String token = SalesforceToWCGTAccess.getAuthenticationToken();
        req.setHeader('Authorization','Bearer '+token);
        req.setHeader('Content-Type','application/json'); 
        List<Account> acc = new List<Account>([SELECT Id,Name,CreatedById,GT_Client_Group__c,OwnerId,ParentId,Website,AccountType__c/*,HQAddressGUO__c*/,RelationshipOffice__c,NumberOfEmployees,Total_Revenue__c,LegalEntityType__c,SubIndustry__c,Industry__c FROM Account WHERE id =:  clientId limit 1]);
        List<Account> parentAccount = new List<Account>([Select Id,Name From Account Where Id =: acc[0].GT_Client_Group__c Limit 1]);
        List<User> users = new List<User>([SELECT Id, USER_ID__c FROM User Where Id =: acc[0].OwnerId Limit 1]);
        string userId = users[0].USER_ID__c;
        //Using this for Testing Perpose as Client Object Fields are not still completed
        string sClientType = 'PS002114';
        String sEntityType = 'PS000010';
        String sTotEmpNo = 'PS006126';
        String sRelOffice = 'PS007572';
        String sCountryHQ = 'PS001117';
        String sKam_NonKam = '1';
        String sCategory_CX_GX ='PS008099';
        String sTotRevenue = 'PS006127';
        String sFlag = '1';
        String reqBody = '{'+
            '"sClientSFID":"'+acc[0].Id+'",'+
            '"sClientGroupName":"'+parentAccount[0].Name+'",'+
            '"sClientName":"'+acc[0].Name+'",'+
            '"sWebsite":"'+acc[0].Website+'",'+
            '"sClientType":"'+sClientType+'",'+
            '"sEntityType":"'+sEntityType+'",'+
            '"sTotRevenue":"'+sTotRevenue+'",'+
            '"sTotEmpNo":"'+sTotEmpNo+'",'+
            '"sRelOffice":"'+sRelOffice+'",'+
            '"sCountryHQ":"'+sCountryHQ+'",'+
            '"sKam_NonKam":"'+sKam_NonKam+'", '+ //1 Kam & 0 Nonkam
            '"sSector":"'+acc[0].Industry__c+'",'+
            '"sSubSector":"'+acc[0].SubIndustry__c+'"'+
            ',"sCategory_CX_GX":"'+sCategory_CX_GX+'",'+
            '"sUserId":"'+userId+'",'+
            '"sFlag":"'+sFlag+'"'+      //1 insert & 2 Update
            '}';
        system.debug('reqBody'+reqBody);
        req.setBody(reqBody);
        // HttpResponse resp = http.send(req);
        //System.debug('resp -->'+resp.getBody());
        String resp1;
        
    }
    
    //On Lead Conversion, Client Contact Record will be created and pushed to WCGT
    //On Client Contact Creation, record data will be pushed to WCGT.
    @Future(callout=true)
    public static void sendWhenNewClienttoContact(id clientContactId) {
        String reqBody = '';
        String responseBody = '';
        WCGTEndPoint__mdt bdRecord = [SELECT Id, MasterLabel, URL__c FROM WCGTEndPoint__mdt Where Label = 'Client Contact' limit 1];
        try {
            Http http = new Http();
            HttpRequest req = new HttpRequest();
            
            req.setEndpoint(bdRecord.URL__c);
            req.setMethod('POST');
            String token = SalesforceToWCGTAccess.getAuthenticationToken();
            req.setHeader('Authorization','Bearer '+token);
            req.setHeader('Content-Type','application/json'); 
            Contact con = [SELECT Id,Name,Email,MobilePhone,LastName,FirstName,Salutation,MailingAddress,AccountId,Designation__c    FROM Contact WHERE id =:  clientContactId];
            reqBody = '{'+
                '"sClientSFID":"'+con.AccountId+'",'+
                '"sContactSFID":"'+con.Id+'",'+
                '"sMobileNo":"'+con.MobilePhone+'",'+
                '"sContPerson":"'+con.Salutation+' '+con.Name+'",'+
                '"sDesign":"'+con.Designation__c+'",'+
                '"sEmailId":"'+con.Email+'",'+
                '"sStatus":"1",'+
                '"sFlag":"1",'+  //1 insert & 2 Update
                '"sPrefix":"'+con.Salutation+'",'+
                '"sFirstName":"'+con.FirstName+'",'+
                '"sLastName":"'+con.LastName+'"'+
                '}'; 
            system.debug('reqBody'+reqBody);
            HttpResponse resp = http.send(req);
            System.debug('resp -->'+resp.getBody());
            responseBody = resp.getBody();
            API_Logger__c apiLog = API_LoggerCommonUtility.createAPILogger(clientContactId,reqBody,responseBody,resp.getStatus(),'salesforceToWCGT.sendWhenNewClienttoContact',bdRecord.URL__c,resp.getStatusCode(),null,null);                  
            Insert apiLog;
            // API_Logger__c apiLogTest = API_LoggerCommonUtility.createAPILogger(clientContactId,reqBody,responseBody,resp.getStatus(),'salesforceToWCGT.sendWhenNewClienttoContact',token);                  
            //    Insert apiLogTest;
        }
        catch (Exception ex) {
            System.debug(ex.getMessage());
            ErrorLogCreater_cls.apexDebugLoggerForAPICallout(ex,'salesforceToWCGT','sendWhenNewClienttoContact',clientContactId,reqBody,responseBody,bdRecord.URL__c);
        }
        
    }
    //
    @Future(callout=true)
    public static Void sendWhenEnquiryCreated(id OpportunityId)
    {  //Start Phase-1 Code comment
        /*
        String reqBody = '';
        String responseBody = '';
        WCGTEndPoint__mdt bdRecord = [SELECT Id, MasterLabel, URL__c FROM WCGTEndPoint__mdt Where Label = 'Enquiry' limit 1];
        try {
            Http http = new Http();
            HttpRequest req = new HttpRequest();
            req.setEndpoint(bdRecord.URL__c);
            req.setMethod('POST');
            String token = SalesforceToWCGTAccess.getAuthenticationToken();
            req.setHeader('Authorization','Bearer '+token);
            req.setHeader('Content-Type','application/json'); 
            List<Opportunity> opp = new List<Opportunity>([SELECT Id,RecurringNonRecurringJobs__c,Revenue_Unit_LU__c,Amount,Name,IntegratedEnquiry__c,Bill_to_Client__c  ,SME_LU__c,Account.Phone,AccountId,OwnerId,Expertise__c,Job_Delivery_Location_LU__c,Market__c,ReasonForWinLose__c,Reason_For_Recovery_Less_Then_75__c,DiscountProposedBy__c,CoCSL__c,CSL__c,Description,OriginalCloseDate__c,SubIndustry__c,SME_Competency__c,Industry__c,BillingCurrency__c,RemarksWinProb__c,ProbabilityOfWinning__c,Remark__c,Pitch_Presentation_Status__c,Fee_INR_Lacs__c,Job_Delivery_Location__c,SubExpertise__c,Status__c,RCCStatus__c,LossReason__c,ProjectStartDate__c,ExpectedRecovery__c,RevenueUnit__c  FROM Opportunity WHERE id =: OpportunityId Limit 1]);
            List<Enquiry_Client_Contact__c > listcontact = new List<Enquiry_Client_Contact__c >([SELECT Id, Enquiry__c, Client_Contact__c FROM Enquiry_Client_Contact__c Where Enquiry__c=: opp[0].Id ]);
            Integer recurringFlag = opp[0].RecurringNonRecurringJobs__c == 'Recurring Jobs' ? 1 : 0;
            String contactId = '';
            if(listcontact.Size()>0){
                contactId = listcontact[0].Client_Contact__c;
            }
            Contact con = [Select Id,Name From Contact Where AccountId =: opp[0].AccountId AND DS_Team_Approval_Status__c ='DS Approved' Limit 1];
            List<SME_PL__c> sme = new List<SME_PL__c> ([SELECT Id, LOV_Id__c ,Sub_Expertise_PL__c ,SME_Master__c FROM SME_PL__c Where Id =: opp[0].SME_LU__c Limit 1]);
            String smeValue ='';
            String serviceLineIdValue ='';
            String smegValue ='';
            String sEnityValue = '';
            String sectorValue = '';
            String SubSectorValue ='';
            List<WCGT_Master__c> listSector = new List<WCGT_Master__c>([SELECT Id, Para_Desc__c, WCGT_Id__c, Sector_Leader__c, Type__c, Name FROM WCGT_Master__c Where Para_Desc__c =: opp[0].Industry__c]);
            List<WCGT_Master__c> listSubSector = new List<WCGT_Master__c>([SELECT Id, Para_Desc__c, WCGT_Id__c, Sector_Leader__c, Type__c, Name FROM WCGT_Master__c Where Para_Desc__c =: opp[0].SubIndustry__c]);
            if(listSector.Size()>0){
                sectorValue = listSector[0].WCGT_Id__c;
            }
            if(listSubSector.size()>0){
                SubSectorValue = listSubSector[0].WCGT_Id__c;
            }
            
            if(sme.size()>0){
                List<SubExpertisePL__c> smeg = new List<SubExpertisePL__c>([SELECT Id, LOV_Id__c, Expertise__c FROM SubExpertisePL__c Where Id =:sme[0].Sub_Expertise_PL__c]);
                List<ExpertisePL__c> expertisePL = new List<ExpertisePL__c>([SELECT Id, ExpertiseMaster__c FROM ExpertisePL__c Where Id =:smeg[0].Expertise__c]);
                List<ExpertiseMaster__c> serviceLine = new List<ExpertiseMaster__c>([SELECT Id, LOV_Id__c FROM ExpertiseMaster__c Where Id =:expertisePL[0].ExpertiseMaster__c Limit 1]);
                if(smeg.size()>0){
                    smegValue = smeg[0].LOV_Id__c;
                }
                List<SME_Master__c> serviceLineId = new List<SME_Master__c>([SELECT Id, LOV_Id__c FROM SME_Master__c Where Id =: sme[0].SME_Master__c Limit 1]);
                if(serviceLine.size()>0){
                    serviceLineIdValue=serviceLine[0].LOV_Id__c;
                }
                smeValue = sme[0].LOV_Id__c;
            }
            //Revenue_Unit_Master__c  revUnit = [SELECT  Reve_Id__c FROM Revenue_Unit_Master__c Where Id =:opp[0].Revenue_Unit_LU__c  Limit 1];
            //Location__c loc = [SELECT Id, Location_Id__c FROM Location__c Where Id =: opp[0].Job_Delivery_Location_LU__c Limit 1];
            
            List<OpportunityTeamMember> oppTeam = new List<OpportunityTeamMember>([SELECT Id, OpportunityId, UserId, TeamMemberRole FROM OpportunityTeamMember Where OpportunityId =: opp[0].Id Limit 3]);
            List <String> listUserId = new List <String>();
            List <String> listRole = new List <String>();
            IntegratedEnquiry__c intEnquiry = [SELECT Id, New_Client__c  FROM IntegratedEnquiry__c Where Id =: opp[0].IntegratedEnquiry__c Limit 1];
            for(integer i=0;i<3 ;i++){
                String userId;
                String role;
                if(oppTeam.size()>i){
                    system.debug(i);
                    role = oppTeam[i].TeamMemberRole;
                    User userRecord = [SELECT Id, EMP_ID__c  FROM User Where Id =:oppTeam[i].UserId  Limit 1];
                    userId = userRecord.EMP_ID__c ;
                }
                else{
                    role = '';
                    userId='';
                }
                listRole.add(role);
                listUserId.add(userId);
            }
            String newClientId ='';
            if(intEnquiry.New_Client__c != Null){
                newClientId=intEnquiry.New_Client__c;
            }
            
            String sflag = '1';
            String status = '1';
            String completeFlag = '1';
            String pitchStatus = '0';
            User userRec = [SELECT Id, USER_ID__c FROM User Where Id =: opp[0].OwnerId Limit 1];
            //Added by Deepak Joshi W-002672
            Decimal sFinalProposedFeeInINR = opp[0].Amount !=null ? Math.round(opp[0].Amount) :0;
            System.debug('** Dk sFinalProposedFeeInINR  '+sFinalProposedFeeInINR);
            Integer initialAmount = 0;
            List<OpportunityFieldHistory> lstOpportunityHistory = [SELECT Id, OpportunityId, Field, OldValue, NewValue FROM OpportunityFieldHistory where Field = 'Amount' AND OpportunityId =: opp[0].Id ORDER BY Createddate asc];
            for(OpportunityFieldHistory iter : lstOpportunityHistory) {
                if(iter.OldValue != null) {
                    initialAmount = Integer.valueOf(iter.OldValue);
                    break;
                }
            }
            reqBody = '{'+
                '"sEnquirySFID": "'+opp[0].Id+'",'+
                '"sName": "'+opp[0].Name+'",'+
                '"sNewClientSFID": "'+newClientId +'",'+
                '"sContactIdSFID": "'+con.Id+'",'+
                '"sClientIdSFID": "'+opp[0].AccountId+'",'+
                '"sServiceLineId": "'+serviceLineIdValue+'",'+ //Master
                '"sMarketId": "",'+ //Mater
                '"sUserId": "'+userRec.USER_ID__c+'",'+
                '"sWonReasonDesc": "",'+ //Master
                '"sCompleteflag": "'+completeFlag+'",'+
                '"sPitchStatus": "'+pitchStatus+'",'+
                '"sPerciveRisk": "",'+
                '"sPerciveRiskDesc": "",'+
                '"sWinProbability": "",'+
                '"sRemarks": "",'+
                '"sBillingCurrId": "",'+
                '"sSector": "'+sectorValue+'",'+
                '"sSme": "'+smeValue+'",'+
                '"sSubSector": "'+SubSectorValue+'",'+
                '"sFinalProposeDope": "",'+
                '"sWonActualClosureDtae": "",'+
                '"sPitchDesc": "'+opp[0].Description+'",'+
                '"sCslId": "",'+
                '"sCocsl": "",'+
                '"sreasonForDisko": "",'+
                '"sDiscoProposed": "",'+
                '"sReasonRecovery": "",'+
                '"sWonExpectRecoveryPercent": "",'+
                '"sWonReasonRecoveryLess": "",'+
                '"sWonReason": "",'+
                '"sLostReason": "",'+
                '"sLostReasonDesc": "",'+
                '"sLostActualPitchClosureDate": "",'+
                '"sExpectedRecoveryPercent": "'+opp[0].ExpectedRecovery__c+'",'+
                '"sProjectStartDate": "",'+
                '"sNrccId": "",'+
                '"sNrccStatus": "",'+
                '"sStatus": "'+status+'",'+
                '"sINTERNALSERVICELINEID": "'+smegValue+'",'+ //Master
                '"sREVENUEUNITID": "",'+  //Master
                '"sJobDeliveryLocationID": "",'+ //Master
                '"sLEADGENERATORID_1": "'+listUserId[0]+'",'+
                '"sLEADGENERATORID_2": "'+listUserId[1]+'",'+
                '"sLEADGENERATORID_3": "'+listUserId[2]+'",'+
                '"sRole1": "'+listRole[0]+'",'+
                '"sRole2": "'+listRole[1]+'",'+
                '"sRole3": "'+listRole[2]+'",'+
                '"sExpectedFee": "'+initialAmount+'",'+
                '"sFinalProposedFee": "",'+
                '"sEntity": "",'+
                '"sFlag": "'+sflag+'",'+
                '"sBillTo":"",'+
                '"sPROJECTWCGTID":"",'+
                '"sSubMarketID": "",'+
                '"sRecurring": "'+recurringFlag+'",'+
                '"sFinalProposedFeeInINR": "'+sFinalProposedFeeInINR+'"'+ //Added by Deepak Joshi W-002672
                '}';
            
            
            system.debug('reqBody'+reqBody);
            req.setBody(reqBody);
            HttpResponse resp = http.send(req);
            System.debug('resp -->'+resp.getBody());
            responseBody = resp.getBody();
            //ErrorLogCreater_cls.apexDebugLoggerForAPICallout(null,'salesforceToWCGT','sendWhenEnquiryCreated',null,reqBody,responseBody,bdRecord.URL__c); 
            //String resp1;
            API_Logger__c apiLog = API_LoggerCommonUtility.createAPILogger(OpportunityId,reqBody,responseBody,resp.getStatus(),'salesforceToWCGT.sendWhenEnquiryCreated',bdRecord.URL__c,resp.getStatusCode(),null,null);                  
            Insert apiLog;
            // API_Logger__c apiLogTest = API_LoggerCommonUtility.createAPILogger(OpportunityId,reqBody,responseBody,resp.getStatus(),'salesforceToWCGT.sendWhenEnquiryCreated',token);                  
            //     Insert apiLogTest;
        } catch(Exception e){
            System.debug(e.getMessage());
            ErrorLogCreater_cls.apexDebugLoggerForAPICallout(e, 'salesforceToWCGT' , 'sendWhenEnquiryCreated' , '' , reqBody,responseBody, bdRecord.URL__c );
        } 
        */
        //End Phase-1 Code comment
    }
    
    /* @Future(callout=true)
public static Void sendWhenEnquiryClosedWonLost(id OpportunityId){
sendWhenEnquiryClosedWonLostCallout(OpportunityId);
}  */
    
    @Future(callout=true)
    public static Void sendWhenEnquiryClosedWonLost(id OpportunityId)
    {   //Start Phase-1 Code comment 
        /*
        String reqBody = '';
        String responseBody = '';
        WCGTEndPoint__mdt bdRecord = [SELECT Id, MasterLabel, URL__c FROM WCGTEndPoint__mdt Where Label = 'Enquiry' limit 1];
        try {
            System.debug('sendWhenEnquiryClosedWonLost>>>>');
            System.debug('sendWhenEnquiryClosedWonLost isbatch>>>>'+system.isbatch());
            System.debug('sendWhenEnquiryClosedWonLost isfuture>>>>'+system.isfuture());
            System.debug('sendWhenEnquiryClosedWonLost isScheduled>>>>'+system.isScheduled());
            
            List<Opportunity> opp = new List<Opportunity>([SELECT Id,RecurringNonRecurringJobs__c, ReasonForDiscount__c,Amount,Market_Description__c, 
                                                           Sub_Market_Description__c,Enquiry_Closed_Won_Lost_Reason__c,Revenue_Unit_LU__c,BillingCurrency_LU__c,
                                                           Name,IntegratedEnquiry__c,Bill_to_Client__c  ,SME_LU__c,Account.Phone,AccountId,OwnerId,Expertise__c,
                                                           Job_Delivery_Location_LU__c,Market__c,ReasonForWinLose__c,Reason_For_Recovery_Less_Then_75__c,
                                                           DiscountProposedBy__c,CoCSL__c,CSL__c,Description,OriginalCloseDate__c,Agreed_OPE__c,SubIndustry__c,
                                                           SME_Competency__c,Industry__c,BillingCurrency__c,RemarksWinProb__c,ProbabilityOfWinning__c,Remark__c,
                                                           Pitch_Presentation_Status__c,Entity_LU__c ,Fee_INR_Lacs__c,DS_Team_Status__c ,Job_Delivery_Location__c,
                                                           SubExpertise__c,Status__c,RCCCurrentNumber__c, RCCCurrentStatus__c,LossReason__c,ProjectStartDate__c,
                                                           ExpectedRecovery__c,RevenueUnit__c,StageName,ConvertedAmount__c,IntegratedEnquiry__r.Job_Approval_Status__c,
                                                           IntegratedEnquiry__r.Job_Code__c,IntegratedEnquiry__r.Job_Without_EL_Triggered__c,
                                                           IntegratedEnquiry__r.New_Job_Status_Approved_Count__c,WCGT_Job_ID__c, Is_Job_Without_EL__c 
                                                           FROM Opportunity WHERE id =: OpportunityId Limit 1]); //ConvertedValue__c
            
            Opportunity opportunityObj =   opp[0];
            System.debug('opportunityObj.IntegratedEnquiry__r.Job_Approval_Status__c--'+opportunityObj.IntegratedEnquiry__r.Job_Approval_Status__c);
            System.debug('opportunityObj.StageName--'+opportunityObj.StageName);
            System.debug('opportunityObj.WCGT_Job_ID__c--'+opportunityObj.WCGT_Job_ID__c);
            //if(opportunityObj.IntegratedEnquiry__r.Job_Approval_Status__c == 'Approved' && opportunityObj.StageName == 'Closed Won' && opportunityObj.WCGT_Job_ID__c !=null )
            /*if(opportunityObj.IntegratedEnquiry__r.Job_Approval_Status__c == 'Approved' && opportunityObj.StageName == 'Closed Won') {
System.debug('--@@IF BLOCK--');
sendELToWCGT(opportunityObj.Id);
} else {*/ 
          //Start Phase-1 Code comment
          /*  System.debug('--@@Else BLOCK--');
            
            Http http = new Http();
            HttpRequest req = new HttpRequest();
            req.setEndpoint(bdRecord.URL__c);
            req.setMethod('POST');
            String token = SalesforceToWCGTAccess.getAuthenticationToken();
            req.setHeader('Authorization','Bearer '+token);
            req.setHeader('Content-Type','application/json');
            req.setTimeout(120000);
            
            List<Enquiry_Client_Contact__c > listcontact = new List<Enquiry_Client_Contact__c >([SELECT Id, Enquiry__c, Client_Contact__c FROM Enquiry_Client_Contact__c Where Enquiry__c=: opp[0].Id]);
            Integer recurringFlag = opp[0].RecurringNonRecurringJobs__c == 'Recurring Jobs' ? 1 : 0;
            String contactId = '';
            if(listcontact.Size()>0){
                contactId = listcontact[0].Client_Contact__c;
            }
            Contact con = [Select Id,Name From Contact Where AccountId =: opp[0].AccountId AND DS_Team_Approval_Status__c ='DS Approved' Limit 1];
            List<SME_PL__c> sme = new List<SME_PL__c> ([SELECT Id, LOV_Id__c ,Sub_Expertise_PL__c ,SME_Master__c FROM SME_PL__c Where Id =: opp[0].SME_LU__c Limit 1]);
            String smeValue ='';
            String serviceLineIdValue ='';
            String smegValue ='';
            String sEnityValue = '';
            List<Enquiry_RCC__c> listEnquiryrcc = new List<Enquiry_RCC__c>([SELECT Id, Enquiry__c, RCC__c FROM Enquiry_RCC__c Where Enquiry__c=: opp[0].Id ]);
            String sNRccStatus ='';
            String sNRccNumber ='';
            if(listEnquiryrcc.Size()>0){
                List<RCC__c> listRcc = new List<RCC__c>([SELECT Id, RCC_Status__c FROM RCC__c Where Id =:listEnquiryrcc[0].RCC__c]);
                sNRccStatus =listRcc[0].RCC_Status__c;
                sNRccNumber = listRcc[0].Id;
            }
            String sectorValue = '';
            String SubSectorValue ='';
            List<WCGT_Master__c> listSector = new List<WCGT_Master__c>([SELECT Id, Para_Desc__c, WCGT_Id__c, Sector_Leader__c, Type__c, Name FROM WCGT_Master__c Where Para_Desc__c =: opp[0].Industry__c AND Sector_Id__c!='' ]);
            List<WCGT_Master__c> listSubSector = new List<WCGT_Master__c>([SELECT Id, Para_Desc__c, WCGT_Id__c, Sector_Leader__c, Type__c, Name FROM WCGT_Master__c Where Para_Desc__c =: opp[0].SubIndustry__c]);
            if(listSector.Size()>0){
                sectorValue = listSector[0].WCGT_Id__c;
            }
            if(listSubSector.size()>0){
                SubSectorValue = listSubSector[0].WCGT_Id__c;
            }
            List<Entity_Master__c> listEntity = new List<Entity_Master__c>([SELECT Id, EID__c FROM Entity_Master__c Where Id =: opp[0].Entity_LU__c]);
            if(listEntity.Size()>0){
                sEnityValue = listEntity[0].EID__c;
            }
            if(sme.size()>0){
                List<SubExpertisePL__c> smeg = new List<SubExpertisePL__c>([SELECT Id, LOV_Id__c, Expertise__c FROM SubExpertisePL__c Where Id =:sme[0].Sub_Expertise_PL__c]);
                List<ExpertisePL__c> expertisePL = new List<ExpertisePL__c>([SELECT Id, ExpertiseMaster__c FROM ExpertisePL__c Where Id =:smeg[0].Expertise__c]);
                List<ExpertiseMaster__c> serviceLine = new List<ExpertiseMaster__c>([SELECT Id, LOV_Id__c FROM ExpertiseMaster__c Where Id =:expertisePL[0].ExpertiseMaster__c Limit 1]);
                if(smeg.size()>0){
                    smegValue = smeg[0].LOV_Id__c;
                }
                List<SME_Master__c> serviceLineId = new List<SME_Master__c>([SELECT Id, LOV_Id__c FROM SME_Master__c Where Id =: sme[0].SME_Master__c Limit 1]);
                if(serviceLineId.size()>0){
                    serviceLineIdValue=serviceLine[0].LOV_Id__c;
                }
                smeValue = sme[0].LOV_Id__c;
            }
            List<Revenue_Unit_Master__c>  revUnit = new List<Revenue_Unit_Master__c>([SELECT  Reve_Id__c FROM Revenue_Unit_Master__c Where Id =:opp[0].Revenue_Unit_LU__c  Limit 1]);
            List<Location__c> listLoc = new List<Location__c>([SELECT Id, Location_Id__c FROM Location__c Where Id =: opp[0].Job_Delivery_Location_LU__c Limit 1]);
            List<Currency_Code__c> listBilling = new List<Currency_Code__c>([SELECT Id, Currency_Code__c FROM Currency_Code__c Where Id =: opp[0].BillingCurrency_LU__c]);
            String revenUnit='';
            String loc ='';
            String billingCurrencyId ='';
            if(revUnit.size()>0){
                if(revUnit[0].Reve_Id__c!=''){
                    revenUnit = revUnit[0].Reve_Id__c;
                }
            }
            if(listBilling.size()>0){
                if(listBilling[0].Currency_Code__c!=''){
                    billingCurrencyId = listBilling[0].Currency_Code__c;
                }
            }
            if(listLoc.size()>0){
                if(listLoc[0].Location_Id__c!=''){
                    loc = listLoc[0].Location_Id__c;
                }
            }
            
            List<OpportunityTeamMember> oppTeam = new List<OpportunityTeamMember>([SELECT Id, OpportunityId, UserId, TeamMemberRole FROM OpportunityTeamMember Where OpportunityId =: opp[0].Id Order by CreatedDate desc Limit 3]);
            List <String> listUserId = new List <String>();
            List <String> listRole = new List <String>();
            IntegratedEnquiry__c intEnquiry = [SELECT Id, New_Client__c  FROM IntegratedEnquiry__c Where Id =: opp[0].IntegratedEnquiry__c Limit 1];
            for(integer i=0;i<3 ;i++){
                String userId;
                String role;
                if(oppTeam.size()>i){
                    system.debug(i);
                    role = oppTeam[i].TeamMemberRole;
                    User userRecord = [SELECT Id, EMP_ID__c  FROM User Where Id =:oppTeam[i].UserId  Limit 1];
                    userId = userRecord.EMP_ID__c ;
                }
                else{
                    role = '';
                    userId='';
                }
                listRole.add(role);
                listUserId.add(userId);
            }
            String newClientId ='';
            if(intEnquiry.New_Client__c != Null){
                newClientId=intEnquiry.New_Client__c;
            }
            
            
            
            String sWonReasonDesc ='';
            if( opp[0].ReasonForWinLose__c!= Null){
                sWonReasonDesc=opp[0].ReasonForWinLose__c;
            }
            
            String sPerciveRiskDesc ='';
            if( opp[0].Remark__c!= Null){
                sPerciveRiskDesc=opp[0].Remark__c;
            }
            String sWinProbability ='';
            if( opp[0].ProbabilityOfWinning__c!= Null){
                sWinProbability=String.valueOf(opp[0].ProbabilityOfWinning__c);
            }
            String sRemarks ='';
            if( opp[0].RemarksWinProb__c!= Null){
                sRemarks=opp[0].RemarksWinProb__c;
            }
            String sFinalProposeDope ='';
            if( opp[0].Agreed_OPE__c!= Null){
                sFinalProposeDope=String.valueOf(opp[0].Agreed_OPE__c);
            }
            String sWonActualClosureDtae ='';
            if( opp[0].OriginalCloseDate__c!= Null){
                String originalDate = String.valueOf(opp[0].OriginalCloseDate__c);
                
                List<String> dateParts = new List<String>(originalDate.split('-'));
                Integer day = Integer.valueOf(dateParts[2]);
                Integer month = Integer.valueOf(dateParts[1]);
                Integer year = Integer.valueOf(dateParts[0]);
                originalDate ='';
                if(month<10){
                    originalDate='0'; 
                }
                String yearString = String.valueOf(year);
                List<String> digitList = new List<String>();
                for (Integer i = 0; i < yearString.length(); i++) {
                    digitList.add(yearString.substring(i, i+1));
                }
                sWonActualClosureDtae= string.ValueOf(day+'-'+originalDate+month+'-'+digitList[2]+digitList[3]);
                
            }
            String sPitchDesc ='';
            if( opp[0].Description!= Null){
                sPitchDesc=opp[0].Description;
            }
            String sCslId ='';
            if( opp[0].CSL__c!= Null){
                User userRecord = [SELECT Id, EMP_ID__c  FROM User Where Id =:opp[0].CSL__c  Limit 1];
                sCslId=userRecord.EMP_ID__c;
            }
            String sCocsl ='';
            if( opp[0].CoCSL__c!= Null){
                User userRecord = [SELECT Id, EMP_ID__c  FROM User Where Id =:opp[0].CoCSL__c  Limit 1];
                sCocsl=userRecord.EMP_ID__c;
            }
            String sDiscoProposed ='';
            if( opp[0].DiscountProposedBy__c!= Null){
                User userRecord = [SELECT Id, EMP_ID__c  FROM User Where Id =:opp[0].DiscountProposedBy__c  Limit 1];
                sDiscoProposed=userRecord.EMP_ID__c;
            }
            String sReasonRecovery ='';
            if( opp[0].Reason_For_Recovery_Less_Then_75__c!= Null){
                sReasonRecovery=opp[0].Reason_For_Recovery_Less_Then_75__c;
            }
            String sWonExpectRecoveryPercent ='';
            /*if( opp[0].WonExpectedRecovery__c!= Null){
sWonExpectRecoveryPercent=String.valueOf(opp[0].WonExpectedRecovery__c);
}*/
         //Start Phase-1 Code comment
         /*
            String sWonReasonRecoveryLess ='';
            if( opp[0].Reason_For_Recovery_Less_Then_75__c!= Null){
                sWonReasonRecoveryLess=opp[0].Reason_For_Recovery_Less_Then_75__c;
            }
            
            String sWonReason ='';
            if( opp[0].ReasonForWinLose__c!= Null){
                sWonReason=opp[0].ReasonForWinLose__c;
            }
            String sLostReason ='';
            if( opp[0].ReasonForWinLose__c!= Null){
                sLostReason=opp[0].ReasonForWinLose__c;
            }
            String sLostReasonDesc ='';
            if( opp[0].Enquiry_Closed_Won_Lost_Reason__c!= Null){
                sLostReasonDesc=opp[0].Enquiry_Closed_Won_Lost_Reason__c;
            }
            String sExpectedRecoveryPercent ='';
            if( opp[0].ExpectedRecovery__c!= Null){
                sExpectedRecoveryPercent=String.valueOf(opp[0].ExpectedRecovery__c);
            }
            String sProjectStartDate ='';
            if( opp[0].ProjectStartDate__c!= Null){
                String originalDate = String.valueOf(opp[0].ProjectStartDate__c);
                
                List<String> dateParts = new List<String>(originalDate.split('-'));
                Integer day = Integer.valueOf(dateParts[2]);
                Integer month = Integer.valueOf(dateParts[1]);
                Integer year = Integer.valueOf(dateParts[0]);
                originalDate ='';
                if(month<10){
                    originalDate='0'; 
                }
                String yearString = String.valueOf(year);
                List<String> digitList = new List<String>();
                for (Integer i = 0; i < yearString.length(); i++) {
                    digitList.add(yearString.substring(i, i+1));
                }
                sProjectStartDate= string.ValueOf(day+'-'+originalDate+month+'-'+digitList[2]+digitList[3]);
                
            }
            
            
            /*String sFinalProposedFee ='';
if( opp[0].FinalProposedFee__c!= Null){
sFinalProposedFee=String.valueOf(opp[0].);
}*/          //Start Phase-1 Code comment
           /*
            String sBillTo ='';
            if( opp[0].Bill_to_Client__c!= Null){
                sBillTo=String.valueOf(opp[0].Bill_to_Client__c);
            }
            String subMarket ='';
            String sMarket =''; 
            if(opp[0].Market_Description__c != '' && opp[0].Market_Description__c!=NULL ){
                sMarket=opp[0].Market_Description__c;
            }
            if(opp[0].Sub_Market_Description__c != '' && opp[0].Sub_Market_Description__c!=NULL){
                subMarket=opp[0].Sub_Market_Description__c;
            }
            String sflag = '1';
            String status = '';
            String completeFlag = '';
            String pitchStatus = '';
            String sreasonForDisko =opp[0].ReasonForDiscount__c;
            
            //sDiscoProposed ='';
            String reasonLost='';
            String reasonWon='';
            String amountValue = '';
            if(String.valueOf(opp[0].ConvertedAmount__c)!='' && String.valueOf(opp[0].ConvertedAmount__c) !=NULL){
                amountValue = String.valueOf(Math.round(opp[0].ConvertedAmount__c));
            }
            //String sWonReasonForDisc ='';
            String sLostActualClosureDtae = '';
            if(opp[0].StageName=='Closed Lost'){
                if(opp[0].DS_Team_Status__c =='DS Approved'){
                    sflag = '2';
                }
                else{
                    sflag = '1';
                }
                
                status = '1';
                completeFlag = '1';
                pitchStatus = '2';
                sLostReasonDesc=opp[0].Enquiry_Closed_Won_Lost_Reason__c;
                reasonLost = opp[0].ReasonForWinLose__c;
                sLostActualClosureDtae = sWonActualClosureDtae;
                sWonActualClosureDtae ='';
                sWonReasonDesc ='';
                sWonReasonRecoveryLess ='';
            }
            else if(opp[0].StageName=='Closed Won'){
                sflag = '2';
                //sflag = '1';
                status = '1';
                completeFlag = '1';
                pitchStatus = '1';
                reasonWon='PS006119';
                sLostActualClosureDtae = '';
                reasonWon=sLostReasonDesc;
                reasonLost='';
                sLostReasonDesc ='';
                sWonExpectRecoveryPercent = sExpectedRecoveryPercent;
                
            }            
            
            User userRec = [SELECT Id, USER_ID__c FROM User Where Id =: opp[0].OwnerId Limit 1];
            //Added by Deepak Joshi W-002672
            Decimal sFinalProposedFeeInINR = opp[0].Amount !=null ? Math.round(opp[0].Amount) :0;
            System.debug('** Dk sFinalProposedFeeInINR  '+sFinalProposedFeeInINR);
            
            Integer initialAmount = 0;
            List<OpportunityFieldHistory> lstOpportunityHistory = [SELECT Id, OpportunityId, Field, OldValue, NewValue FROM OpportunityFieldHistory where Field = 'Amount' AND OpportunityId =: opp[0].Id ORDER BY Createddate asc];
            for(OpportunityFieldHistory iter : lstOpportunityHistory) {
                if(iter.OldValue != null) {
                    initialAmount = Integer.valueOf(iter.OldValue);
                    break;
                }
            }
            
            // Commented by Prashant TEMPORARY
            reqBody = '{'+
                '"sEnquirySFID": "'+opp[0].Id+'",'+
                '"sName": "'+opp[0].Name+'",'+
                '"sNewClientSFID": "'+newClientId +'",'+
                '"sContactIdSFID": "'+con.Id+'",'+
                '"sClientIdSFID": "'+opp[0].AccountId+'",'+
                '"sServiceLineId": "'+serviceLineIdValue+'",'+ //Master
                '"sMarketId": "'+sMarket+'",'+ //Mater
                '"sUserId": "'+userRec.USER_ID__c+'",'+
                '"sWonReasonDesc": "'+sWonReasonDesc+'",'+ //Master
                '"sCompleteflag": "'+completeFlag+'",'+
                '"sPitchStatus": "'+pitchStatus+'",'+
                '"sPerciveRiskDesc": "'+sPerciveRiskDesc+'",'+
                '"sWinProbability": "'+sWinProbability+'",'+
                '"sRemarks": "'+sRemarks+'",' +
                '"sBillingCurrId": "'+billingCurrencyId+'",'+
                '"sSector": "'+sectorValue+'",'+
                '"sSme": "'+smeValue+'",'+
                '"sSubSector": "'+SubSectorValue+'",'+
                '"sFinalProposeDope": "'+sFinalProposeDope+'",'+
                '"sWonActualClosureDtae": "'+sWonActualClosureDtae+'",'+
                '"sPitchDesc": "'+sPitchDesc+'",'+  
                '"sCslId": "'+sCslId+'",'+
                '"sCocsl": "'+sCocsl+'",'+
                '"sreasonForDisko": "'+sreasonForDisko+'",'+
                '"sDiscoProposed": "'+sDiscoProposed+'",'+
                '"sReasonRecovery": "'+sWonReasonRecoveryLess+'",'+
                '"sWonExpectRecoveryPercent": "'+sWonExpectRecoveryPercent+'",'+
                '"sWonReasonRecoveryLess": "'+sWonReasonRecoveryLess+'",'+    //DOne
                '"sWonReason": "'+reasonWon+'",'+
                '"sLostReason": "'+sLostReasonDesc+'",'+
                '"sLostReasonDesc": "'+reasonLost+'",'+
                '"sLostActualPitchClosureDate": "'+sLostActualClosureDtae+'",'+
                '"sExpectedRecoveryPercent": "'+sExpectedRecoveryPercent+'",'+
                '"sProjectStartDate": "'+sProjectStartDate+'",'+
                '"sNrccId": "'+sNRccNumber+'",'+
                '"sNrccStatus": "'+sNRccStatus+'",'+
                '"sStatus": "'+status+'",'+
                '"sINTERNALSERVICELINEID": "'+smegValue+'",'+ //Master
                '"sREVENUEUNITID": "'+revenUnit+'",'+  //Master
                '"sJobDeliveryLocationID": "'+loc+'",'+ //Master
                '"sLEADGENERATORID_1": "'+listUserId[0]+'",'+
                '"sLEADGENERATORID_2": "'+listUserId[1]+'",'+
                '"sLEADGENERATORID_3": "'+listUserId[2]+'",'+
                '"sRole1": "'+listRole[0]+'",'+
                '"sRole2": "'+listRole[1]+'",'+
                '"sRole3": "'+listRole[2]+'",'+
                '"sExpectedFee": "'+initialAmount+'",'+
                '"sFinalProposedFee": "'+amountValue+'",'+ //Done
                '"sEntity": "'+sEnityValue+'",'+
                '"sFlag": "'+sflag+'",'+
                '"sBillTo":"'+sBillTo +'",'+
                '"sPROJECTWCGTID":"",' +
                '"sSubMarketID":"'+subMarket+'",' +
                '"sRecurring": "'+recurringFlag+'",'+
                '"sFinalProposedFeeInINR": "'+sFinalProposedFeeInINR+'"'+ //Added by Deepak Joshi W-002672
                '}';
            
            
            // Added by Prashant TEMPORARY
            //String reqBody = ' { "sEnquirySFID": "0061s00000c3thaAAA", "sName": "1MG Technologies Private Limited-GRO-South-SoX-FY2023-24-15", "sNewClientSFID": "", "sContactIdSFID": "", "sClientIdSFID": "0011s00001lzNn5AAE", "sServiceLineId": "SM003892", "sMarketId": "", "sUserId": "US006212", "sWonReasonDesc": "", "sCompleteflag": "1", "sPitchStatus": "2", "sPerciveRiskDesc": "", "sWinProbability": "", "sRemarks": "", "sBillingCurrId": "", "sSector": "", "sSme": "SM003892", "sSubSector": "", "sFinalProposeDope": "", "sWonActualClosureDtae": "", "sPitchDesc": "", "sCslId": "", "sCocsl": "", "sreasonForDisko": "", "sDiscoProposed": "", "sReasonRecovery": "", "sWonExpectRecoveryPercent": "", "sWonReasonRecoveryLess": "", "sWonReason": "", "sLostReason": "PS006119", "sLostReasonDesc": "Created by Mistake", "sLostActualPitchClosureDate": "30-08-23", "sExpectedRecoveryPercent": "", "sProjectStartDate": "", "sNrccId": "", "sNrccStatus": "", "sStatus": "1", "sINTERNALSERVICELINEID": "IS000692", "sREVENUEUNITID": "", "sJobDeliveryLocationID": "", "sLEADGENERATORID_1": "", "sLEADGENERATORID_2": "", "sLEADGENERATORID_3": "", "sRole1": "", "sRole2": "", "sRole3": "", "sExpectedFee": "", "sFinalProposedFee": "", "sEntity": "", "sFlag": "1", "sBillTo": "", "sPROJECTWCGTID": "" }';
            system.debug('reqBody'+reqBody);
            req.setBody(reqBody);
            HttpResponse resp = http.send(req);
            System.debug('resp -->'+resp);
            
            responseBody = resp.getBody();
            System.debug('responseBody -->'+resp.getBody());
            
            //salesforceToWCGT.updateEnquiryAfterCallout(resp.getStatusCode(),opp);
            if(resp.getStatusCode() == 200 && opportunityObj.StageName == 'Closed Won' && opportunityObj.Is_Job_Without_EL__c == False){
                string oppId = opp[0].Id; 
                sendELToWCGT(oppId);
            }
            API_Logger__c apiLog = API_LoggerCommonUtility.createAPILogger(OpportunityId,reqBody,responseBody,resp.getStatus(),'salesforceToWCGT.sendWhenEnquiryClosedWonLost',bdRecord.URL__c,resp.getStatusCode(),null,null);                  
            Insert apiLog;
            //  API_Logger__c apiLogTest = API_LoggerCommonUtility.createAPILogger(OpportunityId,reqBody,responseBody,resp.getStatus(),'salesforceToWCGT.sendWhenEnquiryClosedWonLost',token);                  
            // Insert apiLogTest;
        }
        catch(Exception e){
            System.debug('>>>>Exception>>'+e.getMessage());
            ErrorLogCreater_cls.apexDebugLoggerForAPICallout(e, 'salesforceToWCGT' , 'sendWhenEnquiryClosedWonLost' , '' , reqBody,responseBody, bdRecord.URL__c );
        }
        */
        //End Phase-1 Code comment
        
    }
    //Start Phase-1 Code comment
    /*
    public Static void updateEnquiryAfterCallout(Integer statusCode,List<Opportunity> opp){
       
     try{
            
            if(statusCode == 200){
                //opp[0].WCGT_Status__c = 'Enquiry Closed Won';
                // update opp;
                sendELToWCGT(opp[0].Id);
            }
            
        }
        catch(Exception e){
            ErrorLogCreater_cls.apexDebugLogger(e, 'salesforceToWCGT' , 'updateEventAfterCallout' , null);
        }
        
    }
    */
    //End Phase-1 Code comment
    
    
    //@future (callout=true)
    // Changed by Suraj Kumar on 19th Jan 
    @InvocableMethod(label='Call BD Activity')
    public static void sendWhenBDActivity(List<Id> eventsId)
    {
        System.debug('Id :' + eventsId[0]);
        System.debug('Ids :' + eventsId);
        
        
        
        String attendees;
        String company;
        Id leadId;
        Event events = [Select Id,End_Date_Time__c,WCGTStatus__c, Start_Date_Time__c, Actual_Attendees__c, Actual_Duration__c,WhoId,Type,OwnerId,Subject,AttendeesId__c,WhatId FROM Event Where Id =: eventsId[0] Limit 1];
        List<EventRelation> listevRel = new List<EventRelation> ([SELECT Id, RelationId FROM EventRelation Where EventId =: eventsId[0] Limit 1]);
        User userRecord = [SELECT Id, USER_ID__c FROM User Where Id =: events.OwnerId Limit 1];
        System.debug('WhatId -->' + events.WhatId + 'WhoId -->' + events.WhoId);
        if(events.WhatId != NULL){
           // List<Job__c> job = [select id,Client__r.Name  from job__c Where Id =: events.WhatId Limit 1];
           //  List<Opportunity> opp = [SELECT Id, Account.Name FROM Opportunity Where Id =: events.WhatId Limit 1]; //Phase-1
            List<Account> acc = [select id,Name  from Account Where Id =: events.WhatId Limit 1];
            
          /*  if (job.size()>0) {//Phase-1
                System.debug(job);
                company = job[0].Client__r.Name;
                leadId = job[0].Id;
            }  else if (opp.size()>0) { 
                System.debug(opp);
                company = opp[0].Account.Name;
                leadId = opp[0].Id;
            } //Phase-1 */
            if (acc.size()>0) {
                System.debug(acc);
                company = acc[0].Name;
                leadId = acc[0].Id;
            }
        }
        else if(events.WhoId != NULL) {
            Lead useratt = [Select Id, Name, Company From Lead Where Id =: events.WhoId Limit 1];
            
            company =  useratt.Company ;
            leadId = useratt.Id;
        }

        /*
        for( EventRelation evRel : listevRel){
            Id userId = evRel.RelationId;
            
            
            try{
                
            }
            catch(Exception e){
                ErrorLogCreater_cls.apexDebugLogger(e, 'salesforceToWCGT' , 'sendWhenBDActivity' , eventsId[0]);
            }
            
        } */
        
        Integer startYear = events.Start_Date_Time__c.year();
        Integer startMonth = events.Start_Date_Time__c.month();
        Integer startDay = events.Start_Date_Time__c.day();
        
        
        Integer endYear = events.End_Date_Time__c.year();
        Integer endMonth = events.End_Date_Time__c.month();
        Integer endDay = events.End_Date_Time__c.day();
        Integer hr = Integer.valueOf(events.Actual_Duration__c/60);
        Integer min =  math.mod(Integer.valueOf(events.Actual_Duration__c), 100);
        min = Integer.valueOf(events.Actual_Duration__c)-(hr*60);
        min = math.mod(min, 100);
        System.debug(min);        
        String reqBody = '{' +
            +'"sSubject": "'+events.Subject+'",'+
            '"sActivityType": "Client Meeting",'+
            '"sAttendees": "'+events.AttendeesId__c+'",'+
            '"sCompanyName": "'+company+'",'+
            '"sActivityDate": "'+startDay+'/'+startMonth+'/'+startYear+'",'+
            '"sCompletedDate": "'+endDay+'/'+endMonth+'/'+endYear+'",'+
            '"sDuration":"'+hr+'.'+min+'",'+
            '"sUserId": "'+userRecord.USER_ID__c+'",'+
            '"SFID": "'+leadId+'",'+
            '"sMeetingId": "'+events.Id+'","sLeaderId": "'+userRecord.USER_ID__c+'"}';
        System.debug('reqBody'+reqBody);
        
        if(events.WCGTStatus__c != 'Success'){
            salesforceToWCGT.sendBDActivity(reqBody, events.Id);
        }
        else{
            system.debug('Already Updated');
        }
    }
    @Future(callout=true)
    public static void sendBDActivity(String reqBody, Id eventId){
        Api_Logger__c apiLog = new Api_Logger__c();
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        
        HttpResponse resp;
        WCGTEndPoint__mdt bdRecord = [SELECT Id, MasterLabel, URL__c FROM WCGTEndPoint__mdt Where Label = 'BD Activity' limit 1];
        try{
            String token = SalesforceToWCGTAccess.getAuthenticationToken();
            String endpoint = bdRecord.URL__c + '?stoken=' + token;
          
            req.setMethod('POST');
            req.setEndpoint(endpoint);
            req.setHeader('Content-Type','application/json'); 
            req.setTimeout(30000);
            req.setBody(reqBody);
            resp = http.send(req);
            System.debug('resp -->'+reqBody);
            salesforceToWCGT.updateEventAfterCallout(resp.getStatusCode(),eventId);
            apiLog = API_LoggerCommonUtility.createAPILogger(eventId,reqBody,resp.getBody(),resp.getStatus(),'SalesforceToWCGT.sendBDActivity',endpoint,resp.getStatusCode(),null,null);                  
            insert apiLog;
            //  API_Logger__c apiLogTest = API_LoggerCommonUtility.createAPILogger(eventId,reqBody,resp.getBody(),resp.getStatus(),'salesforceToWCGT.sendBDActivity',token);                  
            //  Insert apiLogTest;
        }
        catch(Exception e){
            salesforceToWCGT.updateEventAfterCallout(400,eventId);
            ErrorLogCreater_cls.apexDebugLoggerForAPICallout(e, 'salesforceToWCGT' , 'sendBDActivity' , '' , reqBody,resp.getBody(), bdRecord.URL__c );
        }
    }
    public Static void updateEventAfterCallout(Integer statusCode,Id eventId){
        try{
            Event eventRecord = [Select Id, WCGTStatus__c From Event Where Id =: eventId Limit 1];
            if(statusCode == 200){
                eventRecord.WCGTStatus__c = 'Success';
                eventRecord.Status__c = 'Completed';
                
            }else{
                eventRecord.WCGTStatus__c = 'Error';
                eventRecord.Status__c = 'Completed';
            }
            Update eventRecord;
        }
        catch(Exception e){
            //ErrorLogCreater_cls.apexDebugLoggerForAPICallout(e, 'salesforceToWCGT' , 'updateEventAfterCallout' , '' , reqBody,resp.getBody(), 'https://uat360.wcgt.in/GTSF/api/BDActivity/Insert' );
        }
    }
    @Future(callout=true)
    public Static void insertforFindingPartner(Id oppId){
        //Start Phase-1 Code comment
        /*
        String reqBody = '';
        String responseBody = '';
        WCGTEndPoint__mdt bdRecord = [SELECT Id, MasterLabel, URL__c FROM WCGTEndPoint__mdt Where Label = 'FindingPartner' limit 1];
        try{
            
            Http http = new Http();
            HttpRequest req = new HttpRequest();
            
            req.setEndpoint(bdRecord.URL__c);
            List<Opportunity> listofOpportunity = new List<Opportunity>([Select id,Enquiry_Team_Member_WCGT_Status__c From Opportunity Where Id =: oppId Limit 1]);
            List<OpportunityTeamMember> oppTeam = new List<OpportunityTeamMember>([SELECT Id, OpportunityId, UserId,Other_Role__c , TeamMemberRole FROM OpportunityTeamMember Where OpportunityId =: oppId order by CreatedDate asc]);
            req.setMethod('POST');
            String token = SalesforceToWCGTAccess.getAuthenticationToken();
            req.setHeader('Authorization','Bearer '+token);
            req.setHeader('Content-Type','application/json'); 
            req.setTimeout(30000);
            List <String> listUserId = new List <String>();
            List <String> listRole = new List <String>();
            List <String> listRoleDesc = new List <String>();
            for(integer i=0;i<11 ;i++){
                String userId;
                String role;
                String roleDesc;
                if(oppTeam.size()>i){
                    system.debug(i);
                    role = oppTeam[i].TeamMemberRole;
                    if(oppTeam[i].TeamMemberRole=='Other'){
                        roleDesc = oppTeam[i].Other_Role__c;
                    }
                    else{
                        roleDesc ='';
                    }
                    User userRecord = [SELECT Id, EMP_ID__c  FROM User Where Id =:oppTeam[i].UserId  Limit 1];
                    userId = userRecord.EMP_ID__c ;
                }
                else{
                    role = '';
                    userId='';
                    roleDesc ='';
                }
                listRole.add(role);
                listUserId.add(userId);
                listRoleDesc.add(roleDesc);
            }
            reqBody = '{' +
                '"sEnquirySFID":"'+oppId+'",' +
                '"sFp1":"'+listUserId[0]+'",'+
                '"sFp2":"'+listUserId[1]+'",'+
                '"sFp3":"'+listUserId[2]+'",'+
                '"sFp4":"'+listUserId[3]+'",'+
                '"sFp5":"'+listUserId[4]+'",'+
                '"sFp6":"'+listUserId[5]+'",'+
                '"sFp7":"'+listUserId[6]+'",'+
                '"sFp8":"'+listUserId[7]+'",'+
                '"sFp9":"'+listUserId[8]+'",'+
                '"sFp10":"'+listUserId[9]+'",'+
                '"sFp11":"'+listUserId[10]+'",'+
                '"sRole1":"'+listRole[0]+'",'+
                '"sRole2":"'+listRole[1]+'",'+
                '"sRole3":"'+listRole[2]+'",'+
                '"sRole4":"'+listRole[3]+'",'+
                '"sRole5":"'+listRole[4]+'",'+
                '"sRole6":"'+listRole[5]+'",'+
                '"sRole7":"'+listRole[6]+'",'+
                '"sRole8":"'+listRole[7]+'",'+
                '"sRole9":"'+listRole[8]+'",'+
                '"sRole10":"'+listRole[9]+'",'+
                '"sRole11":"'+listRole[10]+'",'+
                '"sOther1":"'+listRoleDesc[0]+'",'+
                '"sOther2":"'+listRoleDesc[1]+'",'+
                '"sOther3":"'+listRoleDesc[2]+'",'+
                '"sOther4":"'+listRoleDesc[3]+'",'+
                '"sOther5":"'+listRoleDesc[4]+'",'+
                '"sOther6":"'+listRoleDesc[5]+'",'+
                '"sOther7":"'+listRoleDesc[6]+'",'+
                '"sOther8":"'+listRoleDesc[7]+'",'+
                '"sOther9":"'+listRoleDesc[8]+'",'+
                '"sOther10":"'+listRoleDesc[9]+'",'+
                '"sOther11":"'+listRoleDesc[10]+'",'+
                '"sFlag":"1"'+   //1 insert & 2 Update
                '}';
            req.setBody(reqBody);
            System.debug('reqBody -->'+reqBody);
            HttpResponse resp;
            resp = http.send(req);
            System.debug('resp -->'+resp+ '  resp ->>'+resp.getBody());
            responseBody = resp.getBody();
            API_Logger__c apiLog = API_LoggerCommonUtility.createAPILogger(oppId,reqBody,responseBody,resp.getStatus(),'salesforceToWCGT.insertforFindingPartner',bdRecord.URL__c,resp.getStatusCode(),null,null);                  
            Insert apiLog;
            //  API_Logger__c apiLogTest = API_LoggerCommonUtility.createAPILogger(oppId,reqBody,responseBody,resp.getStatus(),'salesforceToWCGT.insertforFindingPartner',token);                  
            //  Insert apiLogTest;
            if(resp.getStatusCode() == 200){
                listofOpportunity[0].Enquiry_Team_Member_WCGT_Status__c = 'Success';
                update listofOpportunity;
            }
        }
        catch(Exception e){
            System.debug(e.getMessage()+'  '+e.getLineNumber());
            ErrorLogCreater_cls.apexDebugLoggerForAPICallout(e, 'salesforceToWCGT' , 'insertforFindingPartner' , '' , reqBody,responseBody, bdRecord.URL__c );
            //salesforceToWCGT.updateEventAfterCallout(400,eventId);
            //ErrorLogCreater_cls.apexDebugLoggerForAPICallout(e, 'salesforceToWCGT' , 'sendBDActivity' , '' , reqBody,resp.getBody(), 'https://uat360.wcgt.in/GTSF/api/BDActivity/Insert' );
        }
        */
         //End Phase-1 Code comment
        
    }
    @Future(callout=true)
    public Static void updateforFindingPartner(Id oppId){
         //Start Phase-1 Code comment
         /*
        String reqBody = '';
        String responseBody = '';
        WCGTEndPoint__mdt bdRecord = [SELECT Id, MasterLabel, URL__c FROM WCGTEndPoint__mdt Where Label = 'FindingPartner' limit 1];           
        try{
            
            Http http = new Http();
            HttpRequest req = new HttpRequest();
            req.setEndpoint(bdRecord.URL__c);
            List<Opportunity> listofOpportunity = new List<Opportunity>([Select id,Enquiry_Team_Member_WCGT_Status__c From Opportunity Where Id =: oppId Limit 1]);
            List<OpportunityTeamMember> oppTeam = new List<OpportunityTeamMember>([SELECT Id, OpportunityId, UserId,Other_Role__c , TeamMemberRole FROM OpportunityTeamMember Where OpportunityId =: oppId order by CreatedDate asc]);
            req.setMethod('POST');
            String token = SalesforceToWCGTAccess.getAuthenticationToken();
            req.setHeader('Authorization','Bearer '+token);
            req.setHeader('Content-Type','application/json'); 
            req.setTimeout(30000);
            List <String> listUserId = new List <String>();
            List <String> listRole = new List <String>();
            List <String> listRoleDesc = new List <String>();
            for(integer i=0;i<11 ;i++){
                String userId;
                String role;
                String roleDesc;
                if(oppTeam.size()>i){
                    system.debug(i);
                    role = oppTeam[i].TeamMemberRole;
                    if(oppTeam[i].TeamMemberRole=='Other'){
                        roleDesc = oppTeam[i].Other_Role__c;
                    }
                    else{
                        roleDesc = '';
                    }
                    
                    User userRecord = [SELECT Id, EMP_ID__c  FROM User Where Id =:oppTeam[i].UserId  Limit 1];
                    userId = userRecord.EMP_ID__c ;
                    
                }
                else{
                    role = '';
                    userId='';
                    roleDesc ='';
                }
                listRole.add(role);
                listUserId.add(userId);
                listRoleDesc.add(roleDesc);
            }
            reqBody = '{' +
                '"sEnquirySFID":"'+oppId+'",' +
                '"sFp1":"'+listUserId[0]+'",'+
                '"sFp2":"'+listUserId[1]+'",'+
                '"sFp3":"'+listUserId[2]+'",'+
                '"sFp4":"'+listUserId[3]+'",'+
                '"sFp5":"'+listUserId[4]+'",'+
                '"sFp6":"'+listUserId[5]+'",'+
                '"sFp7":"'+listUserId[6]+'",'+
                '"sFp8":"'+listUserId[7]+'",'+
                '"sFp9":"'+listUserId[8]+'",'+
                '"sFp10":"'+listUserId[9]+'",'+
                '"sFp11":"'+listUserId[10]+'",'+
                '"sRole1":"'+listRole[0]+'",'+
                '"sRole2":"'+listRole[1]+'",'+
                '"sRole3":"'+listRole[2]+'",'+
                '"sRole4":"'+listRole[3]+'",'+
                '"sRole5":"'+listRole[4]+'",'+
                '"sRole6":"'+listRole[5]+'",'+
                '"sRole7":"'+listRole[6]+'",'+
                '"sRole8":"'+listRole[7]+'",'+
                '"sRole9":"'+listRole[8]+'",'+
                '"sRole10":"'+listRole[9]+'",'+
                '"sRole11":"'+listRole[10]+'",'+
                '"sOther1":"'+listRoleDesc[0]+'",'+
                '"sOther2":"'+listRoleDesc[1]+'",'+
                '"sOther3":"'+listRoleDesc[2]+'",'+
                '"sOther4":"'+listRoleDesc[3]+'",'+
                '"sOther5":"'+listRoleDesc[4]+'",'+
                '"sOther6":"'+listRoleDesc[5]+'",'+
                '"sOther7":"'+listRoleDesc[6]+'",'+
                '"sOther8":"'+listRoleDesc[7]+'",'+
                '"sOther9":"'+listRoleDesc[8]+'",'+
                '"sOther10":"'+listRoleDesc[9]+'",'+
                '"sOther11":"'+listRoleDesc[10]+'",'+
                '"sFlag":"2"'+   //1 insert & 2 Update
                '}';
            req.setBody(reqBody);
            System.debug('reqBody -->'+reqBody );
            
            HttpResponse resp;
            resp = http.send(req);
            responseBody = resp.getBody();
            System.debug('resp -->'+resp+ '  resp ->>'+resp.getBody());
            responseBody = resp.getBody();
            API_Logger__c apiLog = API_LoggerCommonUtility.createAPILogger(oppId,reqBody,responseBody,resp.getStatus(),'salesforceToWCGT.updateforFindingPartner',bdRecord.URL__c,resp.getStatusCode(),null,null);                  
            Insert apiLog;
            // API_Logger__c apiLogTest = API_LoggerCommonUtility.createAPILogger(oppId,reqBody,responseBody,resp.getStatus(),'salesforceToWCGT.updateforFindingPartner',token);                  
            // Insert apiLogTest;
            
        }
        catch(Exception e){
            System.debug(e.getMessage());
            ErrorLogCreater_cls.apexDebugLoggerForAPICallout(e, 'salesforceToWCGT' , 'updateforFindingPartner' , '' , reqBody,responseBody, bdRecord.URL__c );
        }
        */
         //End Phase-1 Code comment
    }
    @Future(callout=true)
    public Static void sendDataforRcc(Id rccId){
         //Start Phase-1 Code comment
         /*
        String reqBody = '';
        String responseBody = '';
        WCGTEndPoint__mdt bdRecord = [SELECT Id, MasterLabel, URL__c FROM WCGTEndPoint__mdt Where Label = 'RCC' limit 1];
        try{
            Http http = new Http();
            HttpRequest req = new HttpRequest();
            req.setEndpoint(bdRecord.URL__c);
            //List<OpportunityTeamMember> oppTeam = new List<OpportunityTeamMember>([SELECT Id, Other_Role__c ,OpportunityId, UserId, TeamMemberRole FROM OpportunityTeamMember Where OpportunityId =: oppId]);
            req.setMethod('POST');
            String token = SalesforceToWCGTAccess.getAuthenticationToken();
            req.setHeader('Authorization','Bearer '+token);
            req.setHeader('Content-Type','application/json'); 
            req.setTimeout(30000);
            List<RCC__c> listRcc = new List<RCC__c>([SELECT Id,OwnerId , Enquiry__c,Client_Contact__c , ClientName__c , RCC_Status__c, WCGTStatus__c, ExpiryDate__c FROM RCC__c Where Id =:rccId Limit 1]);
            String sFlag;
            List<Enquiry_RCC__c> listEnquirRrcc = new List<Enquiry_RCC__c> ([SELECT Id, RCC__c ,Enquiry__c  FROM Enquiry_RCC__c Where RCC__c =:listRcc[0].Id]);
            List<Opportunity> opp = new List<Opportunity>([SELECT Id,Revenue_Unit_LU__c,BillingCurrency_LU__c,Name,IntegratedEnquiry__c,Bill_to_Client__c  ,SME_LU__c,Account.Phone,AccountId,OwnerId,Expertise__c,Job_Delivery_Location_LU__c,Market__c,ReasonForWinLose__c,Reason_For_Recovery_Less_Then_75__c,WonExpectedRecovery__c,DiscountProposedBy__c,CoCSL__c,CSL__c,Description,OriginalCloseDate__c,FinalProposedOPE__c,SubIndustry__c,SME_Competency__c,Industry__c,BillingCurrency__c,RemarksWinProb__c,ProbabilityOfWinning__c,Remark__c,Pitch_Presentation_Status__c,FinalProposedFee__c,Fee_INR_Lacs__c,Job_Delivery_Location__c,SubExpertise__c,Status__c,RCCStatus__c,LossReason__c,ProjectStartDate__c,ExpectedRecovery__c,RevenueUnit__c  FROM Opportunity WHERE id =: listEnquirRrcc[0].Enquiry__c Limit 1]);
            List<RCC_Client_Contact__c> listRccCC = new List<RCC_Client_Contact__c>([SELECT Id, RCC__c, Client_Contact__c FROM RCC_Client_Contact__c Where RCC__c =:listRcc[0].Id ]);
            List<Account> listAcc = new List<Account>([SELECT Id, WCGTId__c  From Account Where Id =:listRcc[0].ClientName__c ]);
            List<Contact> listCon = new List<Contact>([SELECT Id,WCGTId__c From Contact Where Id =: listRccCC[0].Client_Contact__c AND WCGTId__c!='']);
            SME_PL__c sme = [SELECT Id, LOV_Id__c ,Sub_Expertise_PL__c ,SME_Master__c FROM SME_PL__c Where Id =: opp[0].SME_LU__c Limit 1];
            SME_Master__c serviceLineId = [SELECT Id, LOV_Id__c FROM SME_Master__c Where Id =: sme.SME_Master__c Limit 1];
            List<User> userRecord = new List<User>([SELECT Id, USER_ID__c  FROM User Where Id =: listRcc[0].OwnerId Limit 1]);
            if(listRcc[0].WCGTStatus__c=='Success'){
                sFlag = '1';
            }
            else{
                sFlag = '2';
            }
            Integer endYear = listRcc[0].ExpiryDate__c.year();
            Integer month  = listRcc[0].ExpiryDate__c.month();
            String endMonth='';
            String[] monthNames = new String[] {
                'jan', 'feb', 'mar', 'apr', 'may', 'jun',
                    'july', 'aug', 'sep', 'oct', 'nov', 'dec'
                    };
                        
                        if (month >= 1 && month <= 12) {
                            endMonth = monthNames[month - 1];
                            System.debug('Month Name: ' + endMonth);
                        } else {
                            System.debug('Invalid month value');
                        }
            
            
            Integer endDay = listRcc[0].ExpiryDate__c.day();
            reqBody = '{' +
                
                '"sRccSFID":"'+listRcc[0].Id+'",'+
                
                '"sEnquirySFID":"'+opp[0].Id+'",'+
                
                '"sWCGTClientId":"'+listAcc[0].WCGTId__c+'",'+
                
                '"sServiceLineId":"'+serviceLineId.LOV_Id__c+'",'+
                
                '"sStatus":"'+listRcc[0].RCC_Status__c+'",'+
                
                '"sWCGTContactId":"'+listCon[0].WCGTId__c+'",'+
                
                '"sExpiryDate":"'+endDay+'/'+endMonth+'/'+endYear+'",'+
                
                '"sFlag":"'+sFlag+'",'+                                                    //1 insert & 2 Update
                
                '"sUserID":"'+userRecord[0].USER_ID__c+'"'+
                
                '}';
            req.setBody(reqBody);
            System.debug('reqBody -->'+reqBody);
            HttpResponse resp;
            resp = http.send(req);
            System.debug('resp -->'+resp +'resp Body'+resp.getBody() );
            responseBody = resp.getBody();
            API_Logger__c apiLog = API_LoggerCommonUtility.createAPILogger(rccId,reqBody,responseBody,resp.getStatus(),'salesforceToWCGT.sendDataforRcc',bdRecord.URL__c,resp.getStatusCode(),null,null);                  
            Insert apiLog;
            //  API_Logger__c apiLogTest = API_LoggerCommonUtility.createAPILogger(rccId,reqBody,responseBody,resp.getStatus(),'salesforceToWCGT.sendDataforRcc',token);                  
            //  Insert apiLogTest;
            if(resp.getStatusCode() == 200){
                listRcc[0].WCGTStatus__c = 'Success';
                update listRcc;
            }
            
        }
        catch(Exception e){
            //salesforceToWCGT.updateEventAfterCallout(400,eventId);
            //ErrorLogCreater_cls.apexDebugLoggerForAPICallout(e, 'salesforceToWCGT' , 'sendBDActivity' , '' , reqBody,resp.getBody(), 'https://uat360.wcgt.in/GTSF/api/BDActivity/Insert' );
            System.debug(e.getMessage());
            ErrorLogCreater_cls.apexDebugLoggerForAPICallout(e, 'salesforceToWCGT' , 'sendDataforRcc' , '' , reqBody,responseBody, bdRecord.URL__c );
        }
        */
        //End Phase-1 Code comment
    }
    
    
    @Future(callout=true)
    public Static void sendDataforRccByOpp(Id oppId){
         //Start Phase-1 Code comment
         /*
        List<Enquiry_RCC__c> listEnquiryrcc = new List<Enquiry_RCC__c>([SELECT Id, Enquiry__c, RCC__c FROM Enquiry_RCC__c Where Enquiry__r.DS_Team_Status__c = 'DS Approved' AND RCC__r.RCC_Status__c = 'Approved' AND Enquiry__r.Account.WCGTId__c != null AND Enquiry__c=: oppId Order By LastModifiedDate Desc Limit 1]);
        if(! listEnquiryrcc.isEmpty()) {
            sendDataforRccByEnquiryRCC(listEnquiryrcc[0].Id);
        }
        */
        //End Phase-1 Code comment
    }
    
    //@Future(Callout=true)
    public Static void sendDataforRccByEnquiryRCC(Id enquiryRccId){
        //Start Phase-1 Code comment
         /*
        Enquiry_RCC__c enquiryRcc = [SELECT Id, Enquiry__c, RCC__c FROM Enquiry_RCC__c Where Id =: enquiryRccId];
        String reqBody = '';
        String responseBody = '';     
        WCGTEndPoint__mdt bdRecord = [SELECT Id, MasterLabel, URL__c FROM WCGTEndPoint__mdt Where Label = 'RCC' limit 1];
        
        Try{ 
            Opportunity opp = [Select Id,SME_LU__c, RecurringNonRecurringJobs__c From Opportunity Where Id =:enquiryRcc.Enquiry__c];
            RCC__c rcc = [SELECT Id,OwnerId , Enquiry__c,Client_Contact__c , ClientName__c , RCC_Status__c, WCGTStatus__c, ExpiryDate__c FROM RCC__c Where Id =:enquiryRcc.RCC__c];
            Http http = new Http();
            HttpRequest req = new HttpRequest();
            req.setEndpoint(bdRecord.URL__c);
            //List<OpportunityTeamMember> oppTeam = new List<OpportunityTeamMember>([SELECT Id, Other_Role__c ,OpportunityId, UserId, TeamMemberRole FROM OpportunityTeamMember Where OpportunityId =: oppId]);
            req.setMethod('POST');
            String token = SalesforceToWCGTAccess.getAuthenticationToken();
            req.setHeader('Authorization','Bearer '+token);
            req.setHeader('Content-Type','application/json'); 
            req.setTimeout(30000);
            Integer recurringFlag = opp.RecurringNonRecurringJobs__c == 'Recurring Jobs' ? 1 : 0;
            String sRccId ='';
            //String sNRccNumber ='';
            sRccId = enquiryRcc.RCC__c;
            
            
            List<SME_PL__c> sme = new List<SME_PL__c> ([SELECT Id, LOV_Id__c ,Sub_Expertise_PL__c ,SME_Master__c FROM SME_PL__c Where Id =: opp.SME_LU__c Limit 1]);
            String smeValue ='';
            String serviceLineIdValue ='';
            String smegValue ='';
            if(sme.size()>0){
                List<SubExpertisePL__c> smeg = new List<SubExpertisePL__c>([SELECT Id, LOV_Id__c, Expertise__c FROM SubExpertisePL__c Where Id =:sme[0].Sub_Expertise_PL__c]);
                List<ExpertisePL__c> expertisePL = new List<ExpertisePL__c>([SELECT Id, ExpertiseMaster__c FROM ExpertisePL__c Where Id =:smeg[0].Expertise__c]);
                List<ExpertiseMaster__c> serviceLine = new List<ExpertiseMaster__c>([SELECT Id, LOV_Id__c FROM ExpertiseMaster__c Where Id =:expertisePL[0].ExpertiseMaster__c Limit 1]);
                if(smeg.size()>0){
                    smegValue = smeg[0].LOV_Id__c;
                }
                List<SME_Master__c> serviceLineId = new List<SME_Master__c>([SELECT Id, LOV_Id__c FROM SME_Master__c Where Id =: sme[0].SME_Master__c Limit 1]);
                if(serviceLineId.size()>0){
                    serviceLineIdValue=serviceLineId[0].LOV_Id__c;
                }
                smeValue = sme[0].LOV_Id__c;
            }
            List<RCC_Client_Contact__c> listClientContactrcc = new List<RCC_Client_Contact__c>([SELECT Id, RCC__c, Client_Contact__c, Client_Contact__r.WCGTId__c FROM RCC_Client_Contact__c Where Client_Contact__c != null AND Client_Contact__r.WCGTId__c != null AND RCC__c=: rcc.Id ]);
            if(listClientContactrcc.Size()>0){
                
                String wContactClientId ='';
                
                for(RCC_Client_Contact__c iter: listClientContactrcc) {
                    wContactClientId += iter.Client_Contact__r.WCGTId__c + ',';
                }
                wContactClientId = wContactClientId.removeEnd(',');
                
                String sFlag;
                String sClientId ='';
                List<Account> listAcc = new List<Account>([Select Id, WCGTId__c From Account Where Id =:rcc.ClientName__c]);
                if(listAcc.Size()>0){
                    sClientId=listAcc[0].WCGTId__c;
                }
                List<User> userRecord = new List<User>([SELECT Id, USER_ID__c  FROM User Where Id =: rcc.OwnerId Limit 1]);
                if(rcc.WCGTStatus__c!='Success'){
                    sFlag = '1';
                }
                else{
                    sFlag = '2';
                }
                Integer year = rcc.ExpiryDate__c.year();
                Integer month = rcc.ExpiryDate__c.month();
                Integer day = rcc.ExpiryDate__c.day();
                
                String dateValue ='';
                String[] monthNames = new String[] {
                    'jan', 'feb', 'mar', 'apr', 'may', 'jun',
                        'july', 'aug', 'sep', 'oct', 'nov', 'dec'
                        };
                            
                            if (month >= 1 && month <= 12) {
                                dateValue = monthNames[month - 1];
                                //System.debug('Month Name: ' + monthName);
                            }
                
                
                reqBody = '{' +
                    
                    '"sRccSFID":"'+rcc.Id+'",'+
                    
                    '"sEnquirySFID":"'+opp.Id+'",'+
                    
                    '"sWCGTClientId":"'+sClientId+'",'+
                    
                    '"sServiceLineId":"'+serviceLineIdValue+'",'+
                    
                    '"sStatus":"'+rcc.RCC_Status__c+'",'+
                    
                    '"sWCGTContactId":"'+wContactClientId+'",'+
                    
                    '"sExpiryDate":"'+day+'/'+dateValue+'/'+year+'",'+
                    
                    '"sFlag":"'+sFlag+'",'+                                                    //1 insert & 2 Update
                    
                    '"sUserID":"'+userRecord[0].USER_ID__c+'",'+
                    
                    '"sRecurring": "'+recurringFlag+'"'+
                    
                    '}';
                req.setBody(reqBody);
                System.debug('reqBody -->'+reqBody);
                HttpResponse resp;
                
                resp = http.send(req);
                System.debug('resp -->'+resp +'resp Body'+resp.getBody() );
                responseBody = resp.getBody();
                
                if(resp.getStatusCode() == 200) {
                    Enquiry_RCC__c enquiryRCCObj = new Enquiry_RCC__c();
                    enquiryRCCObj.Id = enquiryRcc.Id;
                    enquiryRCCObj.Synced_on_WCGT__c = true;
                    update enquiryRCCObj;
                }
                API_Logger__c apiLog = API_LoggerCommonUtility.createAPILogger(enquiryRCC.Id,reqBody,responseBody,resp.getStatus(),'salesforceToWCGT.sendDataforRccByEnquiryRCC',bdRecord.URL__c,resp.getStatusCode(),null,null);                  
                Insert apiLog;
                //    API_Logger__c apiLogTest = API_LoggerCommonUtility.createAPILogger(enquiryRCC.Id,reqBody,responseBody,resp.getStatus(),'salesforceToWCGT.sendDataforRccByEnquiryRCC',token);                  
                //Insert apiLogTest;
            }
            
        }
        catch(Exception e){
            System.debug(e.getMessage());
            ErrorLogCreater_cls.apexDebugLoggerForAPICallout(e, 'salesforceToWCGT' , 'sendDataforRccByEnquiryRCC' , '' , reqBody,responseBody, bdRecord.URL__c );
            //salesforceToWCGT.updateEventAfterCallout(400,eventId);
            //ErrorLogCreater_cls.apexDebugLoggerForAPICallout(e, 'salesforceToWCGT' , 'sendBDActivity' , '' , reqBody,resp.getBody(), 'https://uat360.wcgt.in/GTSF/api/BDActivity/Insert' );
        }
        */

        //End Phase-1 Code comment
        
        
    }
    
    
    //Bhanwar File Transfer to WCGT Pitch Deck or Proposal 
    @Future(callout=true)
    public Static void sendPitchDeckorProposal(Id pitchDeckId){
        //Start Phase-1 Code comment
         /*
        String reqBody = '';     
        String responseBody = '';     
        WCGTEndPoint__mdt bdRecord = [SELECT Id, MasterLabel, URL__c FROM WCGTEndPoint__mdt Where Label = 'Upload Signed EL' limit 1];
        try{
            
            Http http = new Http();
            HttpRequest req = new HttpRequest();
            req.setEndpoint(bdRecord.URL__c);
            //List<OpportunityTeamMember> oppTeam = new List<OpportunityTeamMember>([SELECT Id, Other_Role__c ,OpportunityId, UserId, TeamMemberRole FROM OpportunityTeamMember Where OpportunityId =: oppId]);
            req.setMethod('POST');
            String token = SalesforceToWCGTAccess.getAuthenticationToken();
            req.setHeader('Authorization','Bearer '+token);
            req.setHeader('Content-Type','application/json'); 
            req.setTimeout(30000);
            
            List<PitchDeckProposalRequest__c> listPitchDeck = new List<PitchDeckProposalRequest__c>([SELECT Id, Integrated_Enquiry__c,ListOfEnquiries__c,Type_of_Document__c  FROM PitchDeckProposalRequest__c Where Id =:pitchDeckId]);
            List<IntegratedEnquiry__c > integratedEnquiryList=[select Id, Type_of_content__c, Specify_details_of_content__c, Reason_for_request__c, Job_Code__c,
                                                               Type_of_document__c, Level_of_support__c,Client__c , Lead_member_firm__c,
                                                               Proposalvalue__c,CreatedBy.Name,Child_Enquiries__c,Attachment__C,SupportRequired__c/*,Entity_LU__c,Entity_LU__r.EID__c*/ /*,
                                                                //Start Phase-1 Code comment
                                                               (Select ContentDocumentId,contentdocument.title, ContentDocument.LatestPublishedVersionId  from contentdocumentlinks 
                                                                order by ContentDocument.LatestPublishedVersionId desc limit 1)content,        
                                                               Industry__c,SubIndustry__c,Request_Type__c,Expected_Proposal_Submission_Date__c,CloseDate__c  from IntegratedEnquiry__c  where Id=:listPitchDeck[0].Integrated_Enquiry__c];
            
            
            
            List<Opportunity> listOpp = new List<Opportunity> ([Select Id, Name, Pitch_Deck_Proposal_Request__c FROM Opportunity Where Pitch_Deck_Proposal_Request__c =: pitchDeckId]);
            String sEnquiryId='';
            string contentData ='';
            String fileExtension='';
            String fileType = listPitchDeck[0].Type_of_Document__c;
            String clientId = integratedEnquiryList[0].Client__c;
            if(integratedEnquiryList[0].ContentDocumentLinks.Size()>0){
                List<ContentVersion> listContentVersion = new List<ContentVersion>([SELECT Id,Title,ContentDocumentId,versiondata,IsLatest,fileextension FROM ContentVersion WHERE IsLatest=true and ContentDocumentId =:integratedEnquiryList[0].ContentDocumentLinks[0].ContentDocumentId LIMIT 1]);
                if(listContentVersion.size()>0){
                    fileExtension = listContentVersion[0].fileextension;
                    contentData=EncodingUtil.base64Encode(listContentVersion[0].VersionData);
                }
            }
            if(listPitchDeck[0].Type_of_Document__c == 'Pitch Presentation'){
                fileType='Pitch Deck';
            }
            else{
                fileType='Proposal';
            }
            
            
            for(Integer i=0;i<listOpp.Size();i++){
                if(i==0){
                    sEnquiryId = listOpp[0].Id;
                }else{
                    sEnquiryId = sEnquiryId +',' +listOpp[0].Id;
                }
            }
            if(sEnquiryId==''){
                sEnquiryId= listPitchDeck[0].ListOfEnquiries__c;
            }
            System.debug(contentData);
            String sFlag ='1';
            
            reqBody = '{"sSFID": "'+pitchDeckId+'",'+
                '"sEnquiry_SFId": "'+sEnquiryId+'",'+
                '"sClient_SFId": "'+clientId+'",'+
                '"sProject_WCGTId": "",'+
                '"sEncodedFormatByte": "'+contentData+'",'+
                '"sFormat": "'+fileExtension+'",'+
                '"sType": "'+fileType+'",'+
                '"sFlag": "'+sFlag+'"}';
            req.setBody(reqBody);
            System.debug('reqBody -->'+reqBody);
            HttpResponse resp;
            
            resp = http.send(req);
            System.debug('resp -->'+resp +'resp Body'+resp.getBody() );
            responseBody = resp.getBody();
            API_Logger__c apiLog = API_LoggerCommonUtility.createAPILogger(pitchDeckId,reqBody,responseBody,resp.getStatus(),'salesforceToWCGT.sendPitchDeckorProposal',bdRecord.URL__c,resp.getStatusCode(),null,null);                  
            Insert apiLog;
            //  API_Logger__c apiLogTest = API_LoggerCommonUtility.createAPILogger(pitchDeckId,reqBody,responseBody,resp.getStatus(),'salesforceToWCGT.sendPitchDeckorProposal',token);                  
            //  Insert apiLogTest;
            if(resp.getStatusCode() == 200){
                
            }
        }
        catch(Exception e){
            //salesforceToWCGT.updateEventAfterCallout(400,eventId);
            //ErrorLogCreater_cls.apexDebugLoggerForAPICallout(e, 'salesforceToWCGT' , 'sendBDActivity' , '' , reqBody,resp.getBody(), 'https://uat360.wcgt.in/GTSF/api/BDActivity/Insert' );
            System.debug(e.getMessage());
            ErrorLogCreater_cls.apexDebugLoggerForAPICallout(e, 'salesforceToWCGT' , 'sendPitchDeckorProposal' , '' , reqBody,responseBody, bdRecord.URL__c );
        }
        */
        //End Phase-1 Code comment
        
    }  
    
    //Added by Ayushi Sethi When enquiry gets Closed Won , send the EL to WCGT 
    public static void sendELToWCGT(string closedEnquiriesId){
        //Start Phase-1 Code comment
         /*
        if(closedEnquiriesId != null){
            //closed enquiries elLineItems
            List<Engagement_Letter_Line_Item__c> elLineItemsClosedEnquiry = new List<Engagement_Letter_Line_Item__c>(
                [SELECT Id,Enquiry__c,Engagement_Letter__c 
                 from Engagement_Letter_Line_Item__c
                 where Enquiry__c  =:closedEnquiriesId AND Engagement_Letter__r.API_Status__c != 'Success']);
            system.debug('elLineItemsClosedEnquiry :: '+elLineItemsClosedEnquiry.size());
            Set<Id> elIds = new Set<Id>();
            for(Engagement_Letter_Line_Item__c lineItem : elLineItemsClosedEnquiry){
                elIds.add(lineItem.Engagement_Letter__c);
            }
            //all lineItems that were related to EL but not necessarily had closed enquiry
            List<Engagement_Letter_Line_Item__c> elLineItems = new List<Engagement_Letter_Line_Item__c>([SELECT Id,Enquiry__c,Engagement_Letter__c, 
                                                                                                         Enquiry__r.StageName
                                                                                                         from Engagement_Letter_Line_Item__c 
                                                                                                         where Engagement_Letter__c IN : elIds AND Engagement_Letter__r.API_Status__c != 'Success']);
            Map<Id,List<Engagement_Letter_Line_Item__c>> elLineItemsMap = new Map<Id,List<Engagement_Letter_Line_Item__c>>();
            Set<Id> enquiriesId = new Set<Id>();
            for(Engagement_Letter_Line_Item__c lineItem : elLineItems){
                enquiriesId.add(lineItem.Enquiry__c);
                if(!elLineItemsMap.containsKey(lineItem.Engagement_Letter__c)){
                    elLineItemsMap.put(lineItem.Engagement_Letter__c,new List<Engagement_Letter_Line_Item__c>());
                }
                elLineItemsMap.get(lineItem.Engagement_Letter__c).add(lineItem);
            }
            
            system.debug('elLineItemsMap :::'+elLineItemsMap);
            List<Id> engagementLetterClosedEnquiries = new List<Id>(); //list storing engagement letter Ids whose all enquiries are closed
            system.debug('elLineItemsMap ::'+elLineItemsMap);
            Map<Id, Set<Id>> elEnquiries = new Map<Id, Set<Id>>();
            for(Id elId : elLineItemsMap.keySet()){
                Boolean isClosed = true;
                //check whether all enquires are closed
                Set<Id> enquiryIds = new Set<Id>();
                for(Engagement_Letter_Line_Item__c lineItem : elLineItemsMap.get(elId)){
                    enquiryIds.add(lineItem.Enquiry__c);
                    if(lineItem.Enquiry__r.StageName != 'Closed Won'){
                        isClosed = false;
                    }
                }
                if(isClosed){
                    elEnquiries.put(elId, enquiryIds);
                }
            }
            system.debug('engagementLetterClosedEnquiries ::: '+engagementLetterClosedEnquiries);
            if(elEnquiries.size() > 0){
                system.debug('send the ELs files to WCGT');
                system.debug('elEnquiries '+elEnquiries); 
                SendELToWCGT.sendToWCGT(elEnquiries);
            }
        }
        */
        //End Phase-1 Code comment
    
    }
    
    // sync GT Client Group to WCGT : Rajat Sharma
    @Future(callout=true)
    public Static void syncGTClientGroupToWCGT(ID gtClientID){
        if(gtClientID != null){
            Api_Logger__c apiLog = SalesforceToWCGTHelper.syncGTClient(gtClientID);
            if(apiLog != null){
                INSERT apiLog;
            }
        }
    }
    
    // sync Key Account to WCGT : Rajat Sharma
    @Future(callout=true)
    public Static void syncKeyAccountToWCGT(ID keyAccountId, String flag){
        if(keyAccountId != null && String.isNotBlank(flag)){
            Api_Logger__c apiLog = SalesforceToWCGTHelper.syncKeyAccount(keyAccountId, flag);
            if(apiLog != null){
                INSERT apiLog;
            }
        }
    }
    
    // sync Client to WCGT : Rajat Sharma
    @Future(callout=true)
    public Static void syncClientToWCGT(ID clientId,String Flag,String userID){
        //Start - Added by Suraj Kumar for revised Enquiry Sync Changes
        List<API_Logger__c> apiLoggerList = new List<API_Logger__c>();
        List<Lead> enquiriesToSync = [SELECT Id, is_Enquiry_Created_For_Existing_Client__c, Converted_Client__c, ConvertedAccountId, Is_Synced_with_WCGT__c FROM Lead WHERE Converted_Client__c =: clientId AND ConvertedAccountId != null AND Is_Synced_with_WCGT__c = false];

        System.debug('enquiriesToSync --> ' + enquiriesToSync);
        try {
        if(clientId != null){
            API_Logger__c clientApiLogger;
            List<API_Logger__c> clientSyncLoggerList = SalesforceToWCGTHelper.syncClientAccount(clientId, Flag, userID);
            
            if(clientSyncLoggerList != null){
                for (API_Logger__c apiLog : clientSyncLoggerList) {
                    if(apiLog.Class_Name__c == 'SalesforceToWCGT.syncClientAccount' && apiLog != null){
                        clientApiLogger = apiLog;
                    }
                }
            }

            if (clientSyncLoggerList != null) {
                apiLoggerList.addAll(clientSyncLoggerList);
            }

            if(clientApiLogger != null){
                if (!enquiriesToSync.isEmpty() && clientApiLogger.isSuccess__c ) {
                    List<Lead> lstEnquiriesSynced = new List<Lead>();
                    for(Lead enquiryRecord : enquiriesToSync){
                        API_Logger__c enquiryApiLogger;
                        List<API_Logger__c> enquirySyncLoggerList = salesforceToWCGT.syncEnquiryToWCGT(enquiryRecord.Id);

                        if(enquirySyncLoggerList != null){
                            for (Api_Logger__c apiLog : enquirySyncLoggerList) {
                                if(apiLog.Class_Name__c == 'salesforceToWCGT.syncEnquiryToWCGT' && apiLog != null){
                                    enquiryApiLogger = apiLog;
                                }
                            }
                        }
						System.debug('enquiryApiLogger--'+enquiryApiLogger);
						System.debug('enquiryApiLogger--'+enquiryApiLogger);
                        if(enquiryApiLogger != null){
                            // apiLoggerList.add(enquiryApiLogger);
                            apiLoggerList.addAll(enquirySyncLoggerList);

                            if (enquiryApiLogger.Status_Code__c == 200) {
                                enquiryRecord.Is_Synced_with_WCGT__c = true;
                                enquiryRecord.ByPassValidation__c = true;
                                lstEnquiriesSynced.add(enquiryRecord);
                            }
                        }
                    }
                    update lstEnquiriesSynced;

                    for (Lead enquiryRecord : lstEnquiriesSynced) {
                        enquiryRecord.ByPassValidation__c = false;
                    }
                    update lstEnquiriesSynced;
                    
                }
                
                Account client = new Account(Id = clientId,Client_Synced__c = true);
                update client;
            }
            if(!apiLoggerList.isEmpty()){
                System.debug('apiLoggerList : ' + apiLoggerList);
                insert apiLoggerList;
            }
        } 
    }catch(Exception e){
            system.debug('Exception e:'+e.getLineNumber()+' '+e.getMessage());
            ErrorLogCreater_cls.apexDebugLogger(e, 'SalesforceToWCGT' , 'syncClientToWCGT' , clientId );
        }
        
    }
    
    // Change Client or New Client Name to WCGT : Rajat Sharma
    @Future(callout=true)
    public Static void changeNameToWCGT(Id recId, String oldName, String newName){
        if(String.isNotBlank(recId) && String.isNotBlank(oldName) && String.isNotBlank(newName)){
            String reqBody = '';
            String responseBody = '';
            WCGTEndPoint__mdt metaRecord = WCGTEndPoint__mdt.getInstance('Change_Name_WCGT');
            String endpoint;
            try{
                Http http = new Http();
                HttpRequest req = new HttpRequest();
                String token = SalesforceToWCGTAccess.getAuthenticationToken();
                endpoint = metaRecord.URL__c + '?stoken=' + token;
                req.setEndpoint(endpoint);
                req.setMethod('POST');
                // req.setHeader('Authorization','Bearer '+token);
                req.setHeader('Content-Type','application/json');
                // Get Request Wrapper from Helper Class
                reqBody = SalesforceToWCGTHelper.getChangeNameReqWrp(recId,oldName,newName);
                req.setBody(reqBody);
                System.debug('reqBody -->'+reqBody);
                HttpResponse resp;
                resp = http.send(req);
                System.debug('resp -->'+resp);
                responseBody = resp.getBody();
                
                API_Logger__c apiLog = API_LoggerCommonUtility.createAPILogger(recId,reqBody,resp.getBody(),resp.getStatus(),'salesforceToWCGT.changeNameToWCGT',endpoint,resp.getStatusCode(),null,null);
                INSERT apiLog;
                // API_Logger__c apiLogTest = API_LoggerCommonUtility.createAPILogger(recId,reqBody,resp.getBody(),resp.getStatus(),'salesforceToWCGT.changeNameToWCGT',token);                  
                // Insert apiLogTest;
            }
            catch(Exception e){
                //ErrorLogCreater_cls.apexDebugLoggerForAPICallout(e, 'salesforceToWCGT' , 'sendBDActivity' , '' , reqBody,resp.getBody(), 'https://uat360.wcgt.in/GTSF/api/BDActivity/Insert' );
                System.debug(e.getMessage());
                ErrorLogCreater_cls.apexDebugLoggerForAPICallout(e, 'salesforceToWCGT' , 'changeNameToWCGT' , '' , reqBody,responseBody, endpoint );
            }
        }  
    }
    
    // Insert / Update Client Contact to WCGT : Rajat Sharma
    // Modified by Suraj Kumar on 05-09-2023
    @Future(callout=true)
    public Static void syncClientContactToWCGT(ID clientContactId,String Flag){
        Contact con = [SELECT Id, Name, AccountId, Account.Name, MiddleName,Last_Modified_By_for_WCGT__c, MobilePhone, Email,Designation__c, Contact_status__c, Salutation, LastModifiedBy.USER_ID__c,WCGTId__c,
                       FirstName, LastName, RelationshipOffice__r.Location_Id__c, Client_Location__Street__s, Client_Location__City__s, Account.DS_Team_Approval_Status__c,Owner.USER_ID__c,
                       toLabel(Client_Location__StateCode__s), Client_Location__PostalCode__s,  toLabel(Client_Location__CountryCode__s), LastModifiedById, LastModifiedBy.EMP_ID__c,CreatedById, CreatedBy.USER_ID__c,
                       Account.Client_s_Headquarter__City__s, Account.Client_s_Headquarter__Street__s, toLabel(Account.Client_s_Headquarter__CountryCode__s), Account.Client_s_Headquarter__PostalCode__s, toLabel(Account.Client_s_Headquarter__StateCode__s), 
                       Last_Modified_By_for_WCGT__r.USER_ID__c
                       FROM Contact
                       WHERE ID =: clientContactId];
        List<API_Logger__c> contactApiLogs = SyncClientContactToWCGTHelper.syncClientContactToWCGT(con, Flag);  
        if(contactApiLogs != null){
            insert contactApiLogs;
        }
        //return apiLog;
    }
    // Insert Client Contact Team to WCGT : Rajat Sharma
    @Future(callout=true)
    public Static void insertContactTeamToWCGT(ID clientContactId,Id gtUser){
        if(String.isNotBlank(clientContactId) && String.isNotBlank(gtUser)){
            Http http = new Http();
            HttpRequest req = new HttpRequest();
            WCGTEndPoint__mdt metaRecord = WCGTEndPoint__mdt.getInstance('Contact_Team_Insert');
            //WCGTEndPoint__mdt metaRecord = [SELECT Id, MasterLabel, URL__c FROM WCGTEndPoint__mdt Where DeveloperName = 'Contact_Team_Insert' limit 1];
            req.setEndpoint(metaRecord.URL__c);
            req.setMethod('POST');
            String token = SalesforceToWCGTAccess.getAuthenticationToken();
            req.setHeader('Authorization','Bearer '+token);
            req.setHeader('Content-Type','application/json'); 
            List<DepthOfRelationship__c> contactTeam = ContactService.getDepOfRelRelatedContact(clientContactId,gtUser);
            if(contactTeam != null && contactTeam.size() > 0){
                system.debug('contactTeam:'+contactTeam);
                // Get Request Wrapper from Helper Class
                String reqBody = salesforceToWCGTHelper.getContactTeamReqWrp(contactTeam);
                req.setBody(reqBody);
                System.debug('reqBody -->'+reqBody);
                HttpResponse resp;
                try{
                    resp = http.send(req);
                    System.debug('resp -->'+resp);
                    API_Logger__c apiLog = API_LoggerCommonUtility.createAPILogger(clientContactId,reqBody,resp.getBody(),resp.getStatus(),'SalesforceToWCGT',metaRecord.URL__c,resp.getStatusCode(),null,null);                    
                    INSERT apiLog;
                    //  API_Logger__c apiLogTest = API_LoggerCommonUtility.createAPILogger(clientContactId,reqBody,resp.getBody(),resp.getStatus(),'salesforceToWCGT.insertContactTeamToWCGT',token);                  
                    // Insert apiLogTest;
                }
                catch(Exception e){
                    //ErrorLogCreater_cls.apexDebugLoggerForAPICallout(e, 'salesforceToWCGT' , 'sendBDActivity' , '' , reqBody,resp.getBody(), 'https://uat360.wcgt.in/GTSF/api/BDActivity/Insert' );
                }
            }            
        }
    }
    
    @Future(callout=true)
    public Static void syncBillToContactToWCGT(ID billToClientId,String Flag){
        //Start Phase-1 Code comment
        /*
        Bill_To_Contact__c billCon = [SELECT Id, Client__c,Mobile__c,Designation__c,FirstName__c,LastName__c,Email__c,Salutation__c, LastModifiedBy.USER_ID__c,
                                      RelationshipOffice__r.Location_Id__c, Contact_Address__Street__s, Contact_Address__City__s, WCGT_Id__c,
                                      toLabel(Contact_Address__StateCode__s), Contact_Address__PostalCode__s,  toLabel(Contact_Address__CountryCode__s), LastModifiedById, LastModifiedBy.EMP_ID__c,CreatedById, CreatedBy.USER_ID__c
                                      FROM Bill_To_Contact__c
                                      WHERE ID =: billToClientId];
        API_Logger__c apiLog = SalesforceToWCGTHelper.syncBillToContactToWCGT(billCon, Flag);  
        if(apiLog != null){
            insert apiLog;
        }
        */
        //End Phase-1 Code comment
    } 
}