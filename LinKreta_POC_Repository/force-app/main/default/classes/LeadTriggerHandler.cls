/*
NAME                     : LeadTriggerHandler
AUTHOR                   : Multiple Users
VERSION                  : 1
CREATED DATE             : 17th April 2023
PROJECT NAME / TICKET #  : Bug W-001761 (Auto Tasks created in the system have created by as the logged in user. It should have created by as the system)
DESCRIPTION
This is a Helper Class for the Apex Trigger on the Task Object. For a predefined set of Tasks, the Created By field should be set to a System User.
In this case, the System User is Linkreta GT and the ID is set in a Custom Label named Default_Creator_Task.

CHANGE HISTORY
--------------------------
AUTHOR                   : Swarna Sankha Singh [SWS]
VERSION                  : 2
MODIFICATION DATE        : 1st June 2023
PROJECT NAME / TICKET #  : Sprint 1 Regression Bug titled "On creating 2 New Clients post approval by NSL, LinKreta is giving an error while conversion and neither of the 2 clients is getting converted"
DESCRIPTION
We have added an additional condition to ensure that we do not add an NSL to the Lead Sharing table if the NSL is the Lead Owner as well. 

AUTHOR                   : Swarna Sankha Singh [SWS]
VERSION                  : 2.1
MODIFICATION DATE        : 2nd June 2023
PROJECT NAME / TICKET #  : Sprint 1 Regression Bug titled "On creating 2 New Clients post approval by NSL, LinKreta is giving an error while conversion and neither of the 2 clients is getting converted"
DESCRIPTION
We migrated the code of Version 2 from the UAT to the QA instance because the code in QA had changes which were not working but those specific use cases were working in UAT.

AUTHOR                   : 
VERSION                  : 
MODIFICATION DATE        : 
PROJECT NAME / TICKET #  : 
DESCRIPTION

*/
public without sharing class LeadTriggerHandler{
    
    //Added by Rakesh, 27-05-24
    //Used to update LastModifiedByForWcgtField.
    public static void updateLastModifiedByForWcgtField(List<Lead> leadList){
        Id PartnerLoginUserID = [Select id,PartnerLogin_UserID__c from User where Id=:UserInfo.getUserId() limit 1].PartnerLogin_UserID__c;
        for(Lead ld : leadList){
            if(PartnerLoginUserID!=null){
                ld.Last_Modified_By_for_WCGT__c = PartnerLoginUserID;
            }else{
                    ld.Last_Modified_By_for_WCGT__c = UserInfo.getUserId();
                }
                
            }
        }
    
    public static void isAfterUpdateMethod(List<Lead> leadList, Map<Id,Lead> oldLeadMap) {
        //********New Client Sharing for NSL************//by Rohitash Mourya
        
        List<ID> nslLeadList=new List<Id>();
        for(Lead leadObj: leadList)
        {
            //[SWS] - Updated as part of Version 2
            //Start Code optimization: code is added by Biplow sarkar | 14-09-2023
            if((leadObj.Industry_Leader__c != Null && leadObj.OwnerID != leadObj.Industry_Leader__c && leadObj.IsConverted == false 
                && oldLeadMap.get(leadObj.Id).Industry_Leader__c != leadObj.Industry_Leader__c) || oldLeadMap.get(leadObj.Id).OwnerID != leadObj.OwnerID) {
                    system.debug('Lead added to Sharing record deletion 1');
                    nslLeadList.add(leadObj.Id);
                }
            //End Code optimization
        }
        
        if(nslLeadList.size()>0)
        {
            
            leadSharingForNSL.leadRecordSharingToNSL(nslLeadList,oldLeadMap);
        }
        
        //********New Client Sharing for Sector Bussines Partner************//by Rohitash Mourya
        List<ID> sectorLeadList=new List<Id>();
        for(Lead leadObj: leadList)
        {
            System.debug('leadObj.Industry_Leader__c!=Null'+leadObj.Industry_Business_Partner__c);
            System.debug('oldLeadMap.get(leadObj.Id).Industry_Leader__c'+oldLeadMap.get(leadObj.Id).Industry_Business_Partner__c);
            
            //[SWS] - Updated as part of Version 2
            //Start Code optimization: code is added by Biplow sarkar | 14-09-2023
            if((leadObj.Industry_Business_Partner__c != Null && leadObj.OwnerID != leadObj.Industry_Business_Partner__c && leadObj.IsConverted == false
                &&  leadObj.Industry_Business_Partner__c != oldLeadMap.get(leadObj.Id).Industry_Business_Partner__c) || oldLeadMap.get(leadObj.Id).OwnerID != leadObj.OwnerID) {
                    sectorLeadList.add(leadObj.Id);
                }
            //End Code optimization
        }
        // Not isBatch added By Prashant on 23-Nov to prevent calling this from FromDateLeaveManagementBatch and ToDateLeaveManagementBatch Batches
        if(sectorLeadList.size()>0 && !System.isBatch()){
            leadSharingForNSL.leadRecordSharingToSectorCordinator(sectorLeadList,oldLeadMap);
        }
        
    }
    
    
    /* By :-Suresh gupta
*Date:- 22 Feb 2023
*last modified by  : Gaurav Kumar
*last modified on  : 28/02/2023
*Purpose:- to send acknowledgement mail to Prospect
*/
    /*------------------------------------------------------*/
    public static void sendEmailToProspect(List<Lead> leadList) {
        try{
            List<GroupMember> METeamMembers = [SELECT UserOrGroupId FROM GroupMember WHERE Group.Type = 'Queue' and Group.DeveloperName='C_M_Team_Queue'];
            System.debug('METeamMembers-->'+METeamMembers);
            
            List<GroupMember> C_M_TeamMembers = [SELECT UserOrGroupId FROM GroupMember WHERE Group.DeveloperName='C_M_Team'];
            System.debug('C_M_TeamMembers-->'+C_M_TeamMembers);
            
            Set<Id> lstMETeamMembers = new Set<Id>();
            for(GroupMember userId :  METeamMembers){
                lstMETeamMembers.add(userId.UserOrGroupId);
            }
            for(GroupMember userId :  C_M_TeamMembers){
                lstMETeamMembers.add(userId.UserOrGroupId);
            }
            System.debug('lstMETeamMembers-->'+lstMETeamMembers);
            List<User> MeUserslst = [Select email from user where id =: lstMETeamMembers and IsActive = true];
            System.debug('MeUserslst-->'+MeUserslst);
            
            List<String> userEmailAddresses = new List<String>();
            for(User userEmail :  MeUserslst){
                userEmailAddresses.add(userEmail.email);
            }        
            System.debug('userEmailAddresses-->'+userEmailAddresses);
            
            for(Lead myLead:leadList){
                if(myLead.LeadSource =='Website' || myLead.LeadSource =='Email' || myLead.LeadSource =='Chat Bot'){
                    Set<String> setMETeamMembers = new Set<String>( (List<String>)new List<Id>( lstMETeamMembers ) );
                    String title = 'A lead has been created via '+myLead.LeadSource+'.';
                    String body = 'A lead has been created via '+myLead.LeadSource+'. Request your inputs on Enquiry classification and subsequently assign an Enquiry owner to proceed with the enquiry.';
                    CustomNotificationFromApex.notifyUsers(title,body,myLead.Id,setMETeamMembers);
                    
                    List<String> lstCCEmailAddress = System.Label.Solution_Business_Team_Email_Ids.split(',');
                    List<User> ccUserIdslst = [Select id from user where email =: lstCCEmailAddress and IsActive = true];
                    System.debug('ccUserIdslst-->'+ccUserIdslst);
                    
                    Set<String> ccUserIdsSet = new Set<String>();
                    for(User userId :  ccUserIdslst){
                        ccUserIdsSet.add(userId.Id);
                    }        
                    System.debug('ccUserIdsSet-->'+ccUserIdsSet);
                    
                    CustomNotificationFromApex.notifyUsers(title,body,myLead.Id,ccUserIdsSet);
                    
                    List<OrgWideEmailAddress> orgWideEmails =  [SELECT Id, Address, DisplayName FROM OrgWideEmailAddress WHERE DisplayName = 'Linkreta' LIMIT 1];
                    List<EmailTemplate> temp = [SELECT Id,Body,HtmlValue FROM EmailTemplate WHERE DeveloperName ='Email_Template_for_Lead_Creation_using_Automated_Channel' Limit 1];
                    system.debug('temp:'+temp);
                    Messaging.SingleEmailMessage mail = Messaging.renderStoredEmailTemplate(temp[0].Id,UserInfo.getUserId(),myLead.Id);
                    if(orgWideEmails != null){
                        mail.setOrgWideEmailAddressId(orgWideEmails[0].Id);
                    }
                    mail.setTargetObjectId(UserInfo.getUserId());
                    mail.setTreatTargetObjectAsRecipient(false);
                    mail.setTemplateId(temp[0].Id); 
                    mail.setWhatId(myLead.Id);
                    mail.setToAddresses(userEmailAddresses);
                    mail.setCcAddresses(lstCCEmailAddress);
                    system.debug('getHtmlBody:'+mail.getHtmlBody());
                    mail.setSaveAsActivity(false);
                    Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{mail});
                    system.debug('mail:'+mail);
                }    
            }
            
        }
        catch(Exception e){
            System.debug('Error :'+e.getMessage());
            System.debug('In Line Number'+e.getLineNumber());
        }
        
    }
    
    
    public static void isBeforeInsert(List<Lead> leadList){
        List<String> ListOfExperty = new List<String>();
        List<String> ListOfSubExperty= new List<String>();
        List<Group> cmTeamQueue  = [Select Id from Group where  DeveloperName = 'C_M_Team_Queue' and Type = 'Queue']; //Start SFDC-[Phase-1]: code is added by Biplow sarkar | 26-03-2024
        system.debug('leadList>>>'+leadList);
        for(lead leadObj : leadList ){
            if(leadObj.Expertise_LT__c <> null)
                ListOfExperty= leadObj.Expertise_LT__c.split(';');
            ListOfExperty.sort();
            String expertyStr= string.join(ListOfExperty,'');
            leadObj.ExpertiesForDuplicateRule__c = expertyStr;
            if(leadObj.SMEG_LT__c <> null)
                ListOfSubExperty= leadObj.SMEG_LT__c.split(';');
            ListOfSubExperty.sort();
            String subexpertyStr=string.join(ListOfSubExperty,'');
            leadObj.SubexpertiesForDuplicateRule__c = subexpertyStr;
            if(String.isBlank(leadObj.IsPardot__c)){
                leadObj.Add_to_marketing_mailing_list__c = true;
            }
            
            //Start SFDC-[Phase-1]: code is added by Biplow sarkar | 26-03-2024
            system.debug('cmTeamQueue>>>'+cmTeamQueue);
            system.debug('leadObj>>>'+leadObj);
            if(cmTeamQueue.size() >0 ){
                
                if(leadObj.LeadSource == ConstantUtility.WEBSITE || leadObj.LeadSource == ConstantUtility.CHAT_BOT ){
                    leadObj.OwnerId = cmTeamQueue[0].Id;
                }
            }
            //End SFDC-[Phase-1]
            
        }
        checkHownCanWeHelpYouShouldBeServiocesOnlyThenLeadShouldBeCreated(leadList);
    }
    
    public static void checkHownCanWeHelpYouShouldBeServiocesOnlyThenLeadShouldBeCreated(List<Lead> leadList){
        System.debug('checkHownCanWeHelpYouShouldBeServiocesOnlyThenLeadShouldBeCreated==');
        
        for(Lead leadObj : leadList) {
            if(leadObj.LeadSource == 'Website') {
                if(leadObj.Channel_query_Request_Type__c != 'Services') {
                    leadObj.addError('Lead can not be created');
                }
            }
        }
    }
    
    /**
* @description 
* @author Biplow Sarkar | 21-03-2024 
* @param newLeadList 
* @param oldLeadMap 
**/
    public static void isBeforeUpdateMethod(List<Lead> newLeadList ,Map<Id,Lead> oldLeadMap){
        System.debug('--isBeforeUpdateMethod--');
        List<String> ListOfExperty = new List<String>();
        List<String> ListOfSubExperty= new List<String>();
        
        for(lead leadObj : newLeadList){
            lead oldLeadObj  = oldLeadMap.get(leadObj.Id); // SFDC-[Phase-1]: code is added by Biplow sarkar | 21-03-2024
            
            if(leadObj.Expertise_LT__c <> null)
                ListOfExperty= leadObj.Expertise_LT__c.split(';');
            ListOfExperty.sort();
            String expertyStr= string.join(ListOfExperty,'');
            leadObj.ExpertiesForDuplicateRule__c = expertyStr;
            if(leadObj.SMEG_LT__c <> null)
                ListOfSubExperty= leadObj.SMEG_LT__c.split(';');
            ListOfSubExperty.sort();
            String subexpertyStr=string.join(ListOfSubExperty,'');
            leadObj.SubexpertiesForDuplicateRule__c = subexpertyStr;
            
            //Start SFDC-[Phase-1]: code is added by Biplow sarkar | 21-03-2024
            
            if(leadObj.Status == ConstantUtility.CONVERTED && leadObj.Status != oldLeadObj.Status
               && leadObj.Enquiry_Type__c == null ){
                   leadObj.addError(ConstantUtility.ENQUIRY_TYPE);
               } 
            
            if(leadObj.Status == ConstantUtility.CONVERTED && leadObj.Status != oldLeadObj.Status 
               &&  leadObj.Enquiry_Type__c == ConstantUtility.BUSINESS_AS_USUAL_BAU  && leadObj.Next_Steps_and_Recommendations_from_BUEL__c ==null){
                   leadObj.addError(ConstantUtility.FILLED_NEXT_STEPS_AND_RECOMMENDATIONS);
                   
               }else if(leadObj.Status == ConstantUtility.CONVERTED && leadObj.Status != oldLeadObj.Status 
                        &&  leadObj.Enquiry_Type__c == ConstantUtility.STRATEGIC_STR && leadObj.Next_Steps_and_Recommendations_from_SC__c ==null ){
                            leadObj.addError(ConstantUtility.FILLED_NEXT_STEPS_AND_RECOMMENDATIONS);
                            
                        } 
            //End SFDC-[Phase-1]
        }
        
        updateCurrAndCompSteps(newLeadList, oldLeadMap);
    }
    
    
    //Gaurav Kumar(23-Aug-2023) 
    public static void updateCurrAndCompSteps(List<Lead> enquiryList, Map<Id, Lead> oldEnquiryMap ){
        try{
            
            Map<String, New_Client_Current_Complete_Step__mdt> mapCurrentSteps = New_Client_Current_Complete_Step__mdt.getAll();
            System.debug('mapCurrentSteps : ' + mapCurrentSteps);
            List<String> currentSteps = new List<String>();
            List<String> completedSteps = new List<String>();
            
            for(Lead enquiryObj : enquiryList){
                if(enquiryObj.Status == 'New'){
                    // if ((enquiryObj.Industry__c != oldEnquiryMap.get(enquiryObj.Id).Industry__c) || (enquiryObj.Enquiry_Type__c != oldEnquiryMap.get(enquiryObj.Id).Enquiry_Type__c) || (enquiryObj.Enquiry_Expertise__c != oldEnquiryMap.get(enquiryObj.Id).Enquiry_Expertise__c)) {
                    if(enquiryObj.Industry__c == null){
                        currentSteps.add(mapCurrentSteps.get('New').Add_Industry__c);
                    }
                    else{
                        completedSteps.add(mapCurrentSteps.get('New').Add_Industry__c);
                    }
                    if(enquiryObj.Enquiry_Type__c == null){
                        currentSteps.add(mapCurrentSteps.get('New').Select_Enquiry_Type__c);
                    }
                    else{
                        completedSteps.add(mapCurrentSteps.get('New').Select_Enquiry_Type__c);
                    }
                    if(enquiryObj.Enquiry_Expertise__c == null || enquiryObj.Enquiry_Expertise__c == ';'){
                        currentSteps.add(mapCurrentSteps.get('New').Choose_Expertise__c);
                    }
                    else{
                        completedSteps.add(mapCurrentSteps.get('New').Choose_Expertise__c);
                    }
                    
                    // }
                    
                }
                else if(enquiryObj.Status == 'Internal / External Discussions'){
                    
                    if((enquiryObj.Enquiry_Type__c == ConstantUtility.BUSINESS_AS_USUAL_BAU && enquiryObj.Next_Steps_and_Recommendations_from_BUEL__c ==null) || (enquiryObj.Enquiry_Type__c == ConstantUtility.STRATEGIC_STR && enquiryObj.Next_Steps_and_Recommendations_from_SC__c ==null)){
                        System.debug('Steps for Internal/External stage : ' + mapCurrentSteps.get('Internal_External_Discussions'));
                        currentSteps.add(mapCurrentSteps.get('Internal_External_Discussions').Add_Next_Steps_and_Recommendations__c);
                    }
                    else{
                        completedSteps.add(mapCurrentSteps.get('Internal_External_Discussions').Add_Next_Steps_and_Recommendations__c);
                    }
                    if(enquiryObj.Meeting_Created__c == true){
                        completedSteps.add(mapCurrentSteps.get('Internal_External_Discussions').Complete_meeting_with_BUEL_SC__c);
                    } else {
                        currentSteps.add(mapCurrentSteps.get('Internal_External_Discussions').Complete_meeting_with_BUEL_SC__c);
                    }
                    
                }
                
                else if(enquiryObj.Status == ConstantUtility.CONVERTED){
                    if(enquiryObj.is_Enquiry_Created_For_Existing_Client__c == true){
                        currentSteps.add(mapCurrentSteps.get('Converted').Navigate_to_WCGT_for_Pipeline_creation__c);
                    }
                    else if(enquiryObj.is_Enquiry_Created_For_Existing_Client__c == false){
                        currentSteps.add(mapCurrentSteps.get('Converted').Navigate_to_Client_page_for_DS_Approval__c);
                    }
                }
                
                System.debug('currentSteps : ' + currentSteps);
                System.debug('completedSteps : ' + completedSteps);
                // Combine the current steps and completed steps into a single string
                String currentStep = currentSteps.isEmpty() == false ? String.join(currentSteps, ', ') : null;
                String completedStep = completedSteps.isEmpty() == false ? String.join(completedSteps, ', ') : null;
                System.debug('currentStep : ' + currentStep + ' and completedStep : ' + completedStep);
                enquiryObj.Current_Steps__c = currentStep;
                enquiryObj.Completed_Steps__c = completedStep;
            }
            
            
        }
        catch(Exception ex){
            System.debug('Error Message :'+ex.getMessage());
            System.debug('In Line Number :'+ex.getLineNumber());
        }
    }
    
    //Gaurav Kumar (28-Sep-2023)
    //Description :Used this method to create Pardot landing page record
    public static void createPardotLandingPageRecord(List<Lead> newListPLP){
        System.debug('createPardotLandingPageRecord :'+newListPLP);
        Map<String,String> campaignIdMap = new Map<String,String>();
        Map<String, Id> piCampToCampaignMap = new Map<String,Id>();
        for(Lead leadObj : newListPLP){
            campaignIdMap.put(leadObj.pi__campaign__c,leadObj.Id);
        }
        List<Campaign> camList = [SELECT Id,Name FROM Campaign WHERE Name in:campaignIdMap.keySet()];
        for(Campaign cam : camList){
            if(!piCampToCampaignMap.containsKey(cam.Name)){
                piCampToCampaignMap.put(cam.Name, cam.Id);
            }
            
        }
        List<Pardot_Landing_Page__c> pardotLPList = new List<Pardot_Landing_Page__c>();
        for(Lead ld : newListPLP){
            Pardot_Landing_Page__c obj = new Pardot_Landing_Page__c();
            obj.First_Name__c = ld.FirstName;
            obj.Last_Name__c = ld.LastName;
            obj.Phone__c = ld.Phone;
            obj.Email__c = ld.Email;
            obj.Job_Title__c = ld.Designation__c;
            obj.Company__c = ld.Company;
            obj.New_Client__c = ld.Id;
            obj.Pardot_Expertise__c = ld.Pardot_Expertise__c;
            obj.Registered__c = ld.Registered__c;
            obj.Attended__c = ld.Attendee__c;
            obj.Campaign__c = piCampToCampaignMap.get(ld.pi__campaign__c);
            obj.Pardot_Event_Name__c = ld.Pardot_Event_Name__c;
            obj.Landing_Page_Name__c = ld.Landing_Page_Name__c;
            obj.Pardot_Sector__c = String.isNotBlank(ld.Pardot_Sector__c) ? ld.Pardot_Sector__c : '';
            
            pardotLPList.add(obj);
        }
        
        if(newListPLP.size()>0){
            String str = JSON.serialize(newListPLP);
        }
        if(pardotLPList.size()>0){
            insert pardotLPList;
        }
        List<Lead> newNewClientList = [SELECT Id,pi__campaign__c,Industry__c,Status FROM Lead Where Id in:newListPLP];
        for(Lead ld : newNewClientList){
            ld.isPardot__c = '';
            ld.Channel__c = 'Campaign';
            ld.LeadSource = 'Campaign';
            ld.Campaign__c = piCampToCampaignMap.get(ld.pi__campaign__c);
            if(ld.Industry__c == null && ld.Status == 'New'){
                ld.Industry__c = 'Others';
            }
        }
        if(newNewClientList.size()>0){
            update newNewClientList;
        }        
        
    }
    
    
    //Gaurav Kumar (28-Sep-2023)
    //Description :Used this method to create Pardot landing page record
    public static void createPardotLandingPageNewClientUpdate(List<Lead> newListPLP){
        LeadTriggerHandler.permissionSetAssignmentMethod();
        System.debug('createPardotLandingPageRecord :'+newListPLP);
        Map<String,String> campaignIdMap = new Map<String,String>();
        
        Map<String, Id> piCampToCampaignMap = new Map<String,Id>();
        for(Lead leadObj : newListPLP){
            campaignIdMap.put(leadObj.pi__campaign__c,leadObj.Id);
        }
        List<Campaign> camList = [SELECT Id,Name FROM Campaign WHERE Name in:campaignIdMap.keySet()];
        for(Campaign cam : camList){
            if(!piCampToCampaignMap.containsKey(cam.Name)){
                piCampToCampaignMap.put(cam.Name, cam.Id);
            }
            
        }
        List<Pardot_Landing_Page__c> pardotLPList = new List<Pardot_Landing_Page__c>();
        for(Lead ld : newListPLP){
            Pardot_Landing_Page__c obj = new Pardot_Landing_Page__c();
            obj.First_Name__c = ld.FirstName;
            obj.Last_Name__c = ld.LastName;
            obj.Phone__c = ld.Phone;
            obj.Email__c = ld.Email;
            obj.Job_Title__c = ld.Designation__c;
            obj.Company__c = ld.Company;
            obj.New_Client__c = ld.Id;
            //obj.Client_Contact__c = ld.ClientContact__c;
            //obj.Integrated_Enquiry__c = ie.Id;
            obj.Pardot_Expertise__c = ld.Pardot_Expertise__c;
            obj.Registered__c = ld.Registered__c;
            obj.Attended__c = ld.Attendee__c;
            //obj.Campaign__c = ld.Campaign__c;
            obj.Pardot_Event_Name__c = ld.Pardot_Event_Name__c;
            obj.Campaign__c = piCampToCampaignMap.get(ld.pi__campaign__c);
            ld.isPardot__c = '';
            obj.Pardot_Sector__c = String.isNotBlank(ld.Pardot_Sector__c) ? ld.Pardot_Sector__c : '';
            if(ld.Industry__c == null && ld.Status == 'New'){
                ld.Industry__c = 'Others';
            }
            pardotLPList.add(obj);
        }
        if(pardotLPList.size()>0){
            insert pardotLPList;
        }
        
    }
    
    @future
    public static void permissionSetAssignmentMethod(){
        String userId = UserInfo.getUserId();
        
        user u = [SELECT ID,UserRole.Name,Profile.Name,IsActive FROM User WHERE  Id=:userId AND (Profile.Name = 'Pardot Admin' OR Profile.Name = 'Marketing User' OR Profile.Name = 'System Administrator') AND IsActive = true];
        if(u.Profile.Name =='Pardot Admin' || u.Profile.Name =='Marketing User' || u.Profile.Name =='System Administrator'){
            List<PermissionSetAssignment> permissionSetList = new List<PermissionSetAssignment>();
            PermissionSet ps = [SELECT Id, Name FROM PermissionSet WHERE Name='Permission_Set_Pardot_Landing_Page'];
            try{
                PermissionSetAssignment obj = new PermissionSetAssignment();
                obj.PermissionSetId = ps.Id;
                obj.AssigneeId = u.Id;
                permissionSetList.add(obj);
                upsert permissionSetList;
                System.Debug('permissionSetList :'+permissionSetList);
            }catch(exception e){
                system.debug('exception caught' + e);
            }
        }
        
    }
    
    /* Added by Suraj Kumar 20-03-2024
Description : This method is used to update enquiry stage if all the mandatory fields are filled otherwise throw an error message to restrict the user to move the stage 
*/
    public static void updateEnquiryStatus(List<Lead> enquiryList, Map<Id,Lead> enquiryOldMap){
        
        try {
            Set<Id> enquiryIds = new Set<Id>();
            List<Lead> enquiriesToUpdate = new List<Lead>();
            
            for (Lead enquiryObj : enquiryList) {
                System.debug('enquiryObj : ' + enquiryObj);
                if(enquiryObj.Status == 'Internal / External Discussions' || enquiryObj.Status == 'New'){
                    System.debug('Stage condition matched ');
                    if((enquiryObj.Industry__c != enquiryOldMap.get(enquiryObj.Id).Industry__c) || (enquiryObj.FirstName != enquiryOldMap.get(enquiryObj.Id).FirstName) || (enquiryObj.LastName != enquiryOldMap.get(enquiryObj.Id).LastName) || (enquiryObj.Enquiry_Type__c != enquiryOldMap.get(enquiryObj.Id).Enquiry_Type__c) || (enquiryObj.Description != enquiryOldMap.get(enquiryObj.Id).Description) || (enquiryObj.Enquiry_Expertise__c != enquiryOldMap.get(enquiryObj.Id).Enquiry_Expertise__c) || (enquiryObj.Company != enquiryOldMap.get(enquiryObj.Id).Company) || (enquiryObj.MobilePhone != enquiryOldMap.get(enquiryObj.Id).MobilePhone) || (enquiryObj.Email != enquiryOldMap.get(enquiryObj.Id).Email) || (enquiryObj.CountryCode__c != enquiryOldMap.get(enquiryObj.Id).CountryCode__c) || (enquiryObj.Status != enquiryOldMap.get(enquiryObj.Id).Status)){
                        String vacantFields;
                        if(enquiryObj.Industry__c == null){
                            System.debug('Industry is blank');
                            vacantFields = String.isBlank(vacantFields) == true ? 'Industry' : vacantFields + ', Industry';
                        }
                        if(enquiryObj.FirstName == null){
                            System.debug('FirstName is blank');
                            vacantFields = String.isBlank(vacantFields) == true ? 'First Name' : vacantFields + ', First Name';
                        }
                        if(enquiryObj.LastName == null){
                            System.debug('LastName is blank');
                            vacantFields = String.isBlank(vacantFields) == true ? 'Last Name' : vacantFields + ', Last Name';
                        }
                        if(enquiryObj.Enquiry_Type__c == null){
                            System.debug('EnquiryType is blank');
                            vacantFields = String.isBlank(vacantFields) == true ? 'Enquiry Type' : vacantFields +  ', Enquiry Type';
                        }
                        if(enquiryObj.Description == null){
                            System.debug('Enquiry Description is blank');
                            vacantFields = String.isBlank(vacantFields) == true ? 'Enquiry Description' : vacantFields + ', Enquiry Description';
                        }
                        if(enquiryObj.Enquiry_Expertise__c == null){
                            System.debug('Expertise is blank');
                            vacantFields = String.isBlank(vacantFields) == true ? 'Expertise' : vacantFields + ', Expertise';
                        }
                        if(enquiryObj.Company == null){
                            System.debug('Client is blank');
                            vacantFields = String.isBlank(vacantFields) == true ? 'Client' : vacantFields + ', Client';
                        }
                        if(enquiryObj.MobilePhone == null){
                            System.debug('MobilePhone is blank');
                            vacantFields = String.isBlank(vacantFields) == true ? 'Mobile Phone' : vacantFields + ', Mobile Phone';
                        }
                        if(enquiryObj.Email == null){
                            System.debug('Email is blank');
                            vacantFields = String.isBlank(vacantFields) == true ? 'Email' : vacantFields + ', Email';
                        }
                        if(enquiryObj.CountryCode__c == null){
                            System.debug('CountryCode is blank');
                            vacantFields = String.isBlank(vacantFields) == true ? 'Country Code' : vacantFields + ', Country Code';
                        }
                        System.debug('Vacant Fields : ' + vacantFields);
                        if(String.isNotBlank(vacantFields) && (enquiryObj.Status != enquiryOldMap.get(enquiryObj.Id).Status)){
                            enquiryObj.addError('Please fill ' + vacantFields);
                        }
                        else if(String.isBlank(vacantFields)){
                            // enquiryObj.Status = 'Internal / External Discussions';
                            enquiryIds.add(enquiryObj.Id);
                        }
                    }
                }
            }
            
            if(enquiryIds != null){
                for (Lead enquiryObj : [SELECT Id, Status FROM Lead WHERE Id IN : enquiryIds]) {
                    enquiryObj.Status = 'Internal / External Discussions';
                    enquiriesToUpdate.add(enquiryObj);
                }
                
                if (!enquiriesToUpdate.isEmpty()) {
                    update enquiriesToUpdate;
                    
                }
            }
        } catch (Exception e) {
            System.debug('Enquiry Status error : ' + e.getMessage() + ' in line number : ' + e.getLineNumber());
        }
        
    }
    // Added By Prashant On 28Mar as per Phase-1 changes
    public static void isBeforeDelete(List<Lead> lstEnquiryOld){
        for(Lead ld : lstEnquiryOld) {
            if(ld.IsConverted) {
                ld.addError(ConstantUtility.ConvertedEnquiryDeletionErrorMsg);
            }
        }
    }
    
    
    
}