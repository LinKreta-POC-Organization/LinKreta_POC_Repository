public class ContactTriggerHelper {
    
    /*public static void updateDSTeamApprovalFields(List<Contact> conList){
        System.debug('Inside method');
        List<ProcessInstance> instancesList = [ SELECT Id,TargetObjectId,LastActor.Name,Status,SubmittedById,
                                               (select Comments,ProcessInstanceId from steps order by CreatedDate desc),CreatedDate
                                               FROM ProcessInstance where TargetObjectId IN: conList order by CreatedDate desc];
        Map<String,ProcessInstance> approvalHistoryMap= new Map<String,ProcessInstance>();
        try{
            for(ProcessInstance proInstObj: instancesList){
                if(!approvalHistoryMap.containsKey(proInstObj.TargetObjectId)){
                    approvalHistoryMap.put(proInstObj.TargetObjectId,proInstObj);
                }
            }
            for(Contact ccObj:conList){
                System.debug('map==>'+approvalHistoryMap);
                if(approvalHistoryMap.containsKey(ccObj.id)){
                    System.debug('Contact id '+ccObj.id);
                    ccObj.DS_Team_Approval_Rejection_Remarks__c = approvalHistoryMap.get(ccObj.id).steps[0].Comments;
                    ccObj.DS_Team_Approved_RejectedBy__c = approvalHistoryMap.get(ccObj.id).LastActor.Name;
                }
            }
        }
        catch(Exception e){
            System.debug('Error occured '+e.getMessage()+' '+e.getLineNumber());
        }
    }*/
    
    /*
    Created by : Suraj Kumar
    Date : 11-08-2023
    User Story : Review Contact Record(U_057)
    Description : This method is used to throw error when approver tries to approve/reject record without adding comments
*/
    
    //Added by Rakesh, 27-05-24
   	//Used to update LastModifiedByForWcgtField.
    public static void updateLastModifiedByForWcgtField(List<Contact> contList){
        Id PartnerLoginUserID = [Select id,PartnerLogin_UserID__c from User where Id=:UserInfo.getUserId() limit 1].PartnerLogin_UserID__c;
        for(Contact cont : contList){
            if(PartnerLoginUserID!=null){
            cont.Last_Modified_By_for_WCGT__c = PartnerLoginUserID;
        }else{
                cont.Last_Modified_By_for_WCGT__c = UserInfo.getUserId();
            }
            
        }
              
    }
    
    public static void validateApprovalComments(List<Contact> clientContacts){
        
        try{
            Map<Id, Contact> clientContactMap = new Map<Id, Contact>();
            System.debug('clientContacts : '+ clientContacts);
            for(Contact con : clientContacts){
                if((con.DS_Team_Approval_Status__c == 'DS Approved' || con.DS_Team_Approval_Status__c == 'DS Rejected') && con.DS_Team_Approval_Status__c <> ((Map<Id,Contact>) Trigger.oldMap).get(con.id).DS_Team_Approval_Status__c){
                    clientContactMap.put(con.Id, con);
                }
            }
            
            if(clientContactMap.size() > 0){
                System.debug('clientContactMap : ' + clientContactMap);
                List<ProcessInstanceStep> pIList = [SELECT Id, Comments,ProcessInstance.TargetObjectId, StepStatus,StepNodeId, OriginalActorId FROM ProcessInstanceSTep where ProcessInstance.TargetObjectId IN  : clientContactMap.keySet() order by CreatedDate desc limit 1];
                System.debug('pIList : ' + pIList);
                
                for(ProcessInstanceStep pStep : pIList){
                    if(String.isBlank(pStep.Comments) && (clientContactMap.containsKey(pStep.ProcessInstance.TargetObjectId))){
                        clientContactMap.get(pStep.ProcessInstance.TargetObjectId).addError(System.label.Mandate_Approval_Rejection_Comments);
                    }
                }
            }
            
        }
        catch(Exception e){
            System.debug('Error message : ' + e.getMessage() + ' in line : ' + e.getLineNumber());
            ErrorLogCreater_cls.apexDebugLogger(e, 'ContactTriggerHelper', 'validateApprovalComments', null);
        }
        
    }
    
    /*
    Created by : Suraj Kumar
    Date : 16-08-2023
    User Story : Review Contact Record(U_057)
    Description : This method is used to throw error when approver approves DS Approval request in case associated client is not DS Approved.
*/
    
    public static void validationDSApproval(List<Contact> clientContacts){
        Set<Id> accountIds = new Set<Id>();
        
        for(Contact con : clientContacts){
            if(con.AccountId != null){
                accountIds.add(con.AccountId);
            }
            
        }
        
        Map<Id,Account> accountMap = new Map<Id,Account>([SELECT Id, DS_Team_Approval_Status__c, Account_Record_Type__c FROM Account WHERE Id IN : accountIds]);
        
        for(Contact con : clientContacts){
            if(accountMap.containsKey(con.AccountId)){
                if(accountMap.get(con.AccountId).DS_Team_Approval_Status__c != 'DS Approved' && accountMap.get(con.AccountId).Account_Record_Type__c == 'Client'){
                    con.addError('Client should be DS Approved before approving Client Contact');
                }
            }
            
        }
    }
    
    //Added by Abdul Vahid || 31 July 2023
    public static void onAfterInsert(List<Contact> contactRecords){
        //Commented By Prashant as Enquiry child Records will no longer needs to be created using Client child records
        /*Map<Id, List<Contact>> accountIdContactListMap = new Map<Id, List<Contact>>();
        
        if(!contactRecords.isEmpty()){
            for(Contact cntRecord : contactRecords){
                System.debug('dd : ' + cntRecord.KeyContactIdentifier__c + ' and ff : ' + cntRecord.AccountId);
                if(cntRecord.KeyContactIdentifier__c == 'BOD' && cntRecord.AccountId != null){
                    if(accountIdContactListMap.containsKey(cntRecord.AccountId)){
                        accountIdContactListMap.get(cntRecord.AccountId).add(cntRecord);    
                    }else{
                        accountIdContactListMap.put(cntRecord.AccountId, new List<Contact>{cntRecord});
                    }
                }
            }
        }
        if(!accountIdContactListMap.isEmpty()){
            createEnquiryClientContactRecords(accountIdContactListMap);
        }*/
    }
    
    //Added by Abdul Vahid || 31 July 2023
    public static void onAfterUpdate(List<Contact> contactRecords, Map<Id, Contact> oldMap){
        //Commented By Prashant as Enquiry child Records will no longer needs to be created using Client child records
        /*Map<Id, List<Contact>> accountIdContactListMap = new Map<Id, List<Contact>>();
        Set<Id> contactIds = new Set<Id>();
        
        if(!contactRecords.isEmpty()){
            for(Contact cntRecord : contactRecords){
                if(oldMap != null && oldMap.get(cntRecord.Id).KeyContactIdentifier__c != cntRecord.KeyContactIdentifier__c &&  cntRecord.AccountId != null){
                    if(cntRecord.KeyContactIdentifier__c == 'BOD'){
                        if(accountIdContactListMap.containsKey(cntRecord.AccountId)){
                            accountIdContactListMap.get(cntRecord.AccountId).add(cntRecord);    
                        }else{
                            accountIdContactListMap.put(cntRecord.AccountId, new List<Contact>{cntRecord});
                        }                        
                    }else if(oldMap.get(cntRecord.Id).KeyContactIdentifier__c == 'BOD'){
                        contactIds.add(cntRecord.Id);
                    }
                } 
            }
        }
        
        if(!contactIds.isEmpty()){
            deleteEnquiryClientContactRecords(contactIds);
        }
        if(!accountIdContactListMap.isEmpty()){
            createEnquiryClientContactRecords(accountIdContactListMap);
        }*/
    }
    //Commented By Prashant as Enquiry child Records will no longer needs to be created using Client child records
    /*//This method is creating Enquiry Client Contact records whenever Client Contact is created
    private static void createEnquiryClientContactRecords(Map<Id, List<Contact>> accountIdAndContactRecords){
        List<Enquiry_Client_Contact__c> enquiryContactRecords = new List<Enquiry_Client_Contact__c>();
        
        List<Opportunity> enquiryRecords = [SELECT Id, AccountId FROM Opportunity
                                            WHERE AccountId IN : accountIdAndContactRecords.keySet()
                                           ];
        if(!enquiryRecords.isEmpty()){
            for(Opportunity enquiry: enquiryRecords){
                if(accountIdAndContactRecords.containsKey(enquiry.AccountId)){
                    for(Contact contactObj : accountIdAndContactRecords.get(enquiry.AccountId)){
                        enquiryContactRecords.add(new Enquiry_Client_Contact__c(Client_Contact__c = contactObj.Id,  Enquiry__c = enquiry.Id));               
                    }
                }            
            }
        }        
        if(!enquiryContactRecords.isEmpty()){
            INSERT enquiryContactRecords; 
        }        
    }
    //delete contact record related to enquiry client contact records
    private static void deleteEnquiryClientContactRecords(Set<Id> contactIds){
        
        List<Enquiry_Client_Contact__c> enquiryClientContactRecords = [SELECT Id, Client_Contact__c FROM Enquiry_Client_Contact__c WHERE Client_Contact__c IN: contactIds];
        
        if(!enquiryClientContactRecords.isEmpty()){
            delete enquiryClientContactRecords;
        }        
    }*/
    
    
    public static void syncClientContactOnInsert(List<Contact> contactList){
        Map<Contact, String> contactsToBeSynced = new Map<Contact, String>();
        Id KeyAccountRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Key Account').getRecordTypeId();
        Id ClientRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Client').getRecordTypeId();
        for(Contact con : [SELECT Id, Name, AccountId, Account.Name, MobilePhone, Email,Designation__c, Account.DS_Team_Approval_Status__c , Contact_status__c, Salutation,
                           FirstName, LastName, MiddleName, RelationshipOffice__r.Location_Id__c, Client_Location__Street__s, Client_Location__City__s, LastModifiedBy.USER_ID__c,
                           toLabel(Client_Location__StateCode__s), Client_Location__PostalCode__s,  toLabel(Client_Location__CountryCode__s), LastModifiedById, LastModifiedBy.EMP_ID__c,
                           Account.RecordTypeId,WCGTId__c,
                           Account.Client_s_Headquarter__City__s, Account.Client_s_Headquarter__Street__s, Client_Contact_Record_Type__c , toLabel(Account.Client_s_Headquarter__CountryCode__s), Account.Client_s_Headquarter__PostalCode__s, toLabel(Account.Client_s_Headquarter__StateCode__s) 
                           FROM Contact
                           WHERE ID IN : contactList]){
                            //Start SFDC-[Phase-1]: code is added by Biplow sarkar | 09-04-2024
                                if(((con.Account.DS_Team_Approval_Status__c == 'DS Approved' && con.Account.RecordTypeId == ClientRecTypeId)
                                    || con.Account.RecordTypeId == KeyAccountRecTypeId) && !contactsToBeSynced.containsKey(con)){
                                        System.debug('Status : ' + con.Account.DS_Team_Approval_Status__c);
                                        contactsToBeSynced.put(con, 'Insert');
                                    }
                                //Phase-1
                               /*if(((con.Account.DS_Team_Approval_Status__c == 'DS Approved' && con.Account.RecordTypeId == ClientRecTypeId)
                                   || con.Account.RecordTypeId == KeyAccountRecTypeId) && !contactsToBeSynced.containsKey(con) && con.Bill_To_Contact__c == false){
                                       System.debug('Status : ' + con.Account.DS_Team_Approval_Status__c);
                                       contactsToBeSynced.put(con, 'Insert');
                                   }else if(con.Bill_To_Contact__c == true){
                                       contactsToBeSynced.put(con, 'Update');
                                   } */
                                //End SFDC-[Phase-1]
                           }
        
        if(contactsToBeSynced != null){
            system.debug('Client Contact Synced');
            if(contactsToBeSynced.KeySet().size() > 40){
                Database.executeBatch(new BatchSyncClientContactToWCGT(contactsToBeSynced), 1);
                
            }
            else{
                for(Contact con : contactsToBeSynced.KeySet()){
                    salesforceToWCGT.syncClientContactToWCGT(con.Id, contactsToBeSynced.get(con));
                }
            }
        }
        
    }
    
    public static void syncClientContactOnUpdate(List<Contact> contactList){
        System.debug('syncClientContactOnUpdate called');
        
        Map<Contact, String> contactsToBeSynced = new Map<Contact, String>();
        Id KeyAccountRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Key Account').getRecordTypeId();
        Id ClientRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Client').getRecordTypeId();
        for(Contact con : [SELECT Id, Name, AccountId, Account.Name, MobilePhone, Email,Designation__c, Account.DS_Team_Approval_Status__c , Contact_status__c, Salutation,
                           FirstName, LastName, MiddleName, RelationshipOffice__r.Location_Id__c, Client_Location__Street__s, Client_Location__City__s, LastModifiedBy.USER_ID__c,
                           Client_Location__StateCode__s, Client_Location__PostalCode__s,  Client_Location__CountryCode__s, LastModifiedById, LastModifiedBy.EMP_ID__c,
                           Account.RecordTypeId,DS_Team_Approval_Status__c,Account.Client_s_Headquarter__c,Owner.USER_ID__c,
                           Account.Client_s_Headquarter__City__s, Account.Client_s_Headquarter__Street__s, Client_Contact_Record_Type__c , toLabel(Account.Client_s_Headquarter__CountryCode__s), Account.Client_s_Headquarter__PostalCode__s, toLabel(Account.Client_s_Headquarter__StateCode__s) 
                           FROM Contact
                           WHERE ID IN : contactList]){
                               Contact oldContact = (Contact)Trigger.oldMap.get(con.Id);
                               if((con.DS_Team_Approval_Status__c == 'DS Approved' && (con.DS_Team_Approval_Status__c <> oldContact.DS_Team_Approval_Status__c))
                                  && (con.Account.RecordTypeId == ClientRecTypeId || con.Account.RecordTypeId == KeyAccountRecTypeId)){
                                      System.debug('COntact added 283');
                                      contactsToBeSynced.put(con, 'Update');
                                  }
                               if((oldContact.DS_Team_Approval_Status__c == 'DS Approved') && 
                                  (  (con.AccountId != oldContact.AccountId)
                                   || (con.MobilePhone != oldContact.MobilePhone)
                                   || (con.FirstName != oldContact.FirstName)
                                   || (con.MiddleName != oldContact.MiddleName)
                                   || (con.LastName != oldContact.LastName)
                                   || (con.Designation__c != oldContact.Designation__c)
                                   || (con.Email != oldContact.Email)
                                   || (con.Contact_status__c != oldContact.Contact_status__c)
                                   || (con.Salutation != oldContact.Salutation)
                                   || (con.RelationshipOffice__c != oldContact.RelationshipOffice__c)
                                   || (con.Client_Location__Street__s != oldContact.Client_Location__Street__s)
                                   || (con.Client_Location__City__s != oldContact.Client_Location__City__s)
                                   || (con.Client_Location__PostalCode__s != oldContact.Client_Location__PostalCode__s)
                                   || (con.Client_Location__CountryCode__s != oldContact.Client_Location__CountryCode__s)
                                   || (con.Client_Location__StateCode__s != oldContact.Client_Location__StateCode__s)
                                   && con.AccountId != null)){
                                    //    System.debug('COntact added 298' + toLabel(oldContact.Client_Location__StateCode__s));
                                       System.debug('new Contact 298 -> ' + con + ', street : ' + con.Client_Location__Street__s + ', city : ' + con.Client_Location__City__s + ', postalCode : ' + con.Client_Location__PostalCode__s + 'countryCode : ' + con.Client_Location__CountryCode__s + ', stateCode : ' + con.Client_Location__StateCode__s);
                                       System.debug('Old Contact 298 -> ' + ', street : ' + oldContact.Client_Location__Street__s + ', city : ' + oldContact.Client_Location__City__s + ', postalCode : ' + oldContact.Client_Location__PostalCode__s + 'countryCode : ' + oldContact.Client_Location__CountryCode__s + ', stateCode : ' + oldContact.Client_Location__StateCode__s);
                                       System.debug('Old Contact 298 -> ' + oldContact);
                                       contactsToBeSynced.put(con, 'Update');
                                   }
                           }
        
        
        if(contactsToBeSynced != null){
            System.debug('contactsToBeSynced -->' + contactsToBeSynced);
            
            if(contactsToBeSynced.KeySet().size() == 1){
                Database.executeBatch(new BatchSyncClientContactToWCGT(contactsToBeSynced), 1);
                
            }
            else{
                for(Contact con : contactsToBeSynced.KeySet()){
                    salesforceToWCGT.syncClientContactToWCGT(con.Id, contactsToBeSynced.get(con));
                }
            }
        }
    }
    
    public static void syncRelatedContacts(Set<Id> clientIds){
        Map<Contact, String> contactsToBeSynced = new Map<Contact, String>();
        system.debug('syncRelatedContacts');
        for(Contact con : [SELECT Id, Name, AccountId, Account.Name, MobilePhone, Email,Designation__c, Account.DS_Team_Approval_Status__c , Contact_status__c, Salutation,
                           FirstName, LastName, MiddleName,RelationshipOffice__r.Location_Id__c, Client_Location__Street__s, Client_Location__City__s, LastModifiedBy.USER_ID__c,Owner.USER_ID__c,
                           toLabel(Client_Location__StateCode__s), Client_Location__PostalCode__s,  toLabel(Client_Location__CountryCode__s), LastModifiedById, LastModifiedBy.EMP_ID__c,
                           Account.Client_s_Headquarter__City__s, Account.Client_s_Headquarter__Street__s, toLabel(Account.Client_s_Headquarter__CountryCode__s), Account.Client_s_Headquarter__PostalCode__s, toLabel(Account.Client_s_Headquarter__StateCode__s) 
                           FROM Contact
                           WHERE AccountId IN : clientIds]){
                               contactsToBeSynced.put(con, 'Insert');
                           }
        
        if(contactsToBeSynced != null){
            system.debug('contactsToBeSynced:'+contactsToBeSynced.KeySet().size());
            Database.executeBatch(new BatchSyncClientContactToWCGT(contactsToBeSynced), 10);
            /*if(contactsToBeSynced.KeySet().size() > 40){
Database.executeBatch(new BatchSyncClientContactToWCGT(contactsToBeSynced), 1);

}
else{
for(Contact con : contactsToBeSynced.KeySet()){
salesforceToWCGT.syncClientContactToWCGT(con.Id, contactsToBeSynced.get(con));
}
}*/
        }
    }
    
    
    //Gaurav Kumar (28-Sep-2023)
    //Description :Used this method to create Pardot landing page record
    public static void createPardotLandingPageRecord(List<Contact> newContactList){
        //ContactTriggerHelper.permissionSetAssignmentMethod();
        try{
            System.debug('createPardotLandingPageRecord :'+newContactList);
            List<String> sectorNameList = new List<String>();
            Map<Id,String> conAccountStatusMap = new Map<Id,String>();
            // Map<Id,Account> AccountActiveStatusMap = new Map<Id,Account>();
            Map<String,String> nslUserMap = new Map<String,String>();
            Map<String,String> sectorUserSBPMap = new Map<String,String>();
            Map<String,String> sectorUserNSLMap = new Map<String,String>();
            Map<String,String> sbpUserEMap = new Map<String,String>();
            Map<String,String> contactAndIEMap = new Map<String,String>();
            Map<String,String> campaignIdMap = new Map<String,String>();
            Map<String, Id> piCampToCampaignMap = new Map<String,Id>();
            
            for(Contact conObj : newContactList){
                campaignIdMap.put(conObj.pi__campaign__c,conObj.Id);
                sectorNameList.add(conObj.Industry__c);
                conAccountStatusMap.put(conObj.Id,conObj.AccountId);
            }
            Map<Id,Account> accountActiveStatusMap = new Map<Id,Account>([SELECT Id,Status__c, Industry__c,
                                                                          CSL__r.Id
                                                                          /*Nome changes ,Industry__c*/
                                                                          FROM Account WHERE Id in :conAccountStatusMap.values()]);
            
            /* for(Account acc : [SELECT Id,Status__c FROM Account WHERE Id in:conAccountStatusMap.values() ]){
AccountActiveStatusMap.put(acc.Id,acc);
} */
            //Start SFDC-[Phase-1]: code is added by Biplow sarkar | 03-04-2024
            /*
            System.debug('Map Contact Account :'+AccountActiveStatusMap);
            List<Campaign> camList = [SELECT Id,Name FROM Campaign WHERE Name in:campaignIdMap.keySet()];
            for(Campaign cam : camList){
                if(!piCampToCampaignMap.containsKey(cam.Name)){
                    piCampToCampaignMap.put(cam.Name, cam.Id);
                }
                
            }
            List<sector_cordinator__mdt> sectorList = [select id,NSL__c,sector_cordinator_id__c,Sector__c from sector_cordinator__mdt where label in:sectorNameList];
            for(sector_cordinator__mdt mdt : sectorList){
                nslUserMap.put(mdt.NSL__c,mdt.Sector__c);
                sbpUserEMap.put(mdt.sector_cordinator_id__c,mdt.Sector__c);
            }
            
            List<User> userList = [SELECT Id,FederationIdentifier FROM User WHERE FederationIdentifier in:nslUserMap.keySet() OR FederationIdentifier in:sbpUserEMap.keySet()];
            for(User usr : userList){
                if(nslUserMap.containsKey(usr.FederationIdentifier)){
                    sectorUserNSLMap.put(nslUserMap.get(usr.FederationIdentifier),usr.Id);
                }
                if(sbpUserEMap.containsKey(usr.FederationIdentifier)){
                    sectorUserSBPMap.put(sbpUserEMap.get(usr.FederationIdentifier),usr.Id);
                }
                
            }
            */
            //End SFDC-[Phase-1]: code is added by Biplow sarkar | 03-04-2024
            
            List<Pardot_Landing_Page__c> pardotLPList = new List<Pardot_Landing_Page__c>();
           //Start SFDC-[Phase-1]: code is added by Biplow sarkar | 03-04-2024
            /*
            List<IntegratedEnquiry__c> ieList = new List<IntegratedEnquiry__c>();
            
            for(Contact con : newContactList){
                if(accountActiveStatusMap.containsKey(con.AccountId)){
                    
                    Account acc = accountActiveStatusMap.get(con.AccountId);
                    
                    if(acc.Status__c =='Active'){
                        IntegratedEnquiry__c IntegratedEnquiry = new IntegratedEnquiry__c();
                        IntegratedEnquiry.CSL__c = acc.CSL__r.Id;
                        IntegratedEnquiry.Client__c = con.AccountId;
                        //IntegratedEnquiry.Existing_Client_Contact__c = con.Id;
                        IntegratedEnquiry.Industry__c = acc.Industry__c;
                        //IntegratedEnquiry.Solution1__c ='Digital & Cyber - Automotive standards';
                        //IntegratedEnquiry.Solution_PL__c ='Digital & Cyber - Automotive standards';
                       //Nome changes
                        /*if(sectorUserNSLMap.containsKey(acc.Industry__c)){
                            IntegratedEnquiry.NSL__c =sectorUserNSLMap.get(acc.Industry__c); 
                        }
                        if(sectorUserSBPMap.containsKey(acc.Industry__c)){
                            IntegratedEnquiry.SectorCoordinator__c =sectorUserSBPMap.get(acc.Industry__c); 
                        }*/
                        /*if(userList[0].FederationIdentifier ==sector.NSL__c){
IntegratedEnquiry.NSL__c =userList[0].Id;
}
else{
IntegratedEnquiry.SectorCoordinator__c =userList[0].Id;
}

if(userList[1].FederationIdentifier ==sector.NSL__c){
IntegratedEnquiry.NSL__c =userList[1].Id;
}
else{
IntegratedEnquiry.SectorCoordinator__c =userList[1].Id;
}*/ //Phase-1 
/*
                        IntegratedEnquiry.LeadSource__c = 'Campaign';
                        IntegratedEnquiry.Channel__c = 'Campaign';
                        IntegratedEnquiry.Short_Description__c = 'This Integrated Enquiry is created from Pardot.';
                        IntegratedEnquiry.Campaign__c = piCampToCampaignMap.get(con.pi__campaign__c);
                        ieList.add(IntegratedEnquiry);
                    }
                }
            }
            if(ieList.size()>0){
                System.debug('ieList size : ' + ieList.size());
                insert ieList;
                for(IntegratedEnquiry__c ie : ieList){
                    contactAndIEMap.put(ie.ClientContact__c,ie.Id);
                }
            }
            */
            //End SFDC-[Phase-1]: code is added by Biplow sarkar | 03-04-2024
            for(Contact con : newContactList){
                
                Pardot_Landing_Page__c obj = new Pardot_Landing_Page__c();
                obj.First_Name__c = con.FirstName;
                obj.Last_Name__c = con.LastName;
                obj.Phone__c = con.Phone;
                obj.Email__c = con.Email;
                obj.Job_Title__c = con.Designation__c;
                //obj.Company__c = con.Company;
                obj.Client_Contact__c = con.Id;
                /* Phase-1
                if(contactAndIEMap.containsKey(con.Id)){
                    obj.Integrated_Enquiry__c = contactAndIEMap.get(con.Id);
                } */ //Phase-1
                obj.Pardot_Expertise__c = con.Pardot_Expertise__c;
                obj.Registered__c = con.Registered__c;
                obj.Attended__c = con.Attendee__c;
                //obj.Campaign__c = con.Campaign__c;
                obj.Pardot_Event_Name__c = con.Pardot_Event_Name__c;
                obj.Campaign__c = piCampToCampaignMap.get(con.pi__campaign__c);
                obj.Landing_Page_Name__c = con.Landing_Page_Name__c;
                obj.Pardot_Sector__c = String.isNotBlank(con.Pardot_Sector__c) ? con.Pardot_Sector__c : '';
                pardotLPList.add(obj);
                //con.isPardot__c = '';
            }
            if(pardotLPList.size()>0){
                insert pardotLPList;
            }
            //newContactList[0].isPardot__c = '';
        }
        Catch(Exception ex){
            ErrorLogCreater_cls.apexDebugLogger(ex, 'ContactTriggerHelper' , 'createPardotLandingPageRecord' , null);
        }
        
    }
    
    /*@future
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
        
    }*/
}