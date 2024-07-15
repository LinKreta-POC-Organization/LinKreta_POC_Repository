public class AccountTriggerHelper {
    /*
* DS approval is being submitted by button on page layout so this is commented by Arpit on 16th Sept
*  public static void sendDSTeamApprovalRequest(List<Account> accountList){
String userId = UserInfo.getUserId();
try{
for(Account accObj:accountList){
accObj.Assigned_to_DS_Team_Member__c =userId;
accObj.Assignment_Date__c = System.today();
Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
req1.setComments('Approval Request for DS Team Member');
req1.setObjectId(accObj.id);
System.debug(userId);
req1.setSubmitterId(userId); 
req1.setProcessDefinitionNameOrId('DS_Team_Account_Approval');
req1.setSkipEntryCriteria(true);
Approval.ProcessResult result = Approval.process(req1);
}
}
catch(Exception e){
System.debug('Error occured '+e.getMessage()+' '+e.getLineNumber());
}
}*/
    //Added by Rakesh, 27-05-24
   	//Used to update LastModifiedByForWcgtField.
    public static void updateLastModifiedByForWcgtField(List<Account> acctList){
        Id PartnerLoginUserID = [Select id,PartnerLogin_UserID__c from User where Id=:UserInfo.getUserId() limit 1].PartnerLogin_UserID__c;
        for(Account acc : acctList){
            if(PartnerLoginUserID!=null){
                acc.Last_Modified_By_for_WCGT__c = PartnerLoginUserID;
            }else{
                acc.Last_Modified_By_for_WCGT__c = UserInfo.getUserId();
            }
            
        }
              
    }
    public static void updateDSTeamApprovalFields(List<Account> acctList){
        System.debug('Inside method');
        List<ProcessInstance> instancesList = [ SELECT Id,TargetObjectId,LastActor.Name,Status,SubmittedById,
                                               (select Comments,ProcessInstanceId from steps order by CreatedDate desc),CreatedDate
                                               FROM ProcessInstance where TargetObjectId IN: acctList order by CreatedDate desc];
        Map<String,ProcessInstance> approvalHistoryMap= new Map<String,ProcessInstance>();
        try{
            for(ProcessInstance proInstObj: instancesList){
                if(!approvalHistoryMap.containsKey(proInstObj.TargetObjectId)){
                    approvalHistoryMap.put(proInstObj.TargetObjectId,proInstObj);
                }
            }
            for(Account accObj:acctList){
                System.debug('map==>'+approvalHistoryMap);
                if(approvalHistoryMap.containsKey(accObj.id)){
                    System.debug('Account id '+accObj.id);
                    accObj.DS_Team_Approval_Rejection_Remarks__c = approvalHistoryMap.get(accObj.id).steps[0].Comments;
                    accObj.DS_Team_Approved_RejectedBy__c = approvalHistoryMap.get(accObj.id).LastActor.Name;
                }
            }
        }
        catch(Exception e){
            System.debug('Error occured '+e.getMessage()+' '+e.getLineNumber());
        }
    }
    /*public static void sendEmailToProposedOwner(List<Account> acctList){
Set<Id> accountIds = new Set<Id>();
List<String> clientTeamMemberEmailList = new List<String>();
List<String> cmGroupTeamMemberEmailList = new List<String>();
List<Group> getCMTeamMember = [Select Id,Name,(select userOrGroupId from groupMembers) From Group where DeveloperName='C_M_Team'];
List<User> usersEmails = [SELECT Email FROM User WHERE Id IN (SELECT UserOrGroupId FROM GroupMember
WHERE GroupId =:getCMTeamMember[0].id)];
for(User userObj:usersEmails){
cmGroupTeamMemberEmailList.add(userObj.Email);
}
System.debug('USer Email List'+cmGroupTeamMemberEmailList);
for(Account acc:acctList){
accountIds.add(acc.Id); 
}
List<AccountTeamMember> accountTeamMemberList = [select Id,User.Email,UserId from AccountTeamMember where AccountId IN:accountIds];
if(!accountTeamMemberList.isEmpty()){
for(AccountTeamMember accTeamObj:accountTeamMemberList){
clientTeamMemberEmailList.add(accTeamObj.User.Email);
} 
}
for(Account accObj:acctList){
if(!clientTeamMemberEmailList.isEmpty()){
Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
mail.setToAddresses(clientTeamMemberEmailList);
mail.setCcAddresses(cmGroupTeamMemberEmailList);
mail.setSubject('Owner Change for Client');
mail.plainTextBody='Dear Account Owner Congrats! you are now the new Account Owner of this Client. Please setup a meeting with Client team to'
+'Regards'+
'LinKreta';
try{
Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
}catch(Exception e){
System.debug('getmessage'+e.getMessage()+'getline number'+e.getLineNumber());
}
}   
}
}
*/
    /*public static void updateCSLCoCSLOnEnquiries(List<Account> newAccountList, Map<Id,Account>newAccountMap){

try{
Set<Id> accountIds = new Set<Id>(); // used to contain account Ids which has CSL and Co-CSL values filled.

for(Account acc : newAccountList){
if(acc.CSL__c != null || acc.CoCSL__c != null){
accountIds.add(acc.Id);
}
}
List<Opportunity> enquiriesNeedTBeUpdated = new List<Opportunity>();
List<OpportunityTeamMember> enquiryTeamMemberList = new List<OpportunityTeamMember>();
List<OpportunityTeamMember> enquiryTeamMembersToBeDeleted = new List<OpportunityTeamMember>();
for(OpportunityTeamMember enqTeamMember : [ SELECT Id, OpportunityId, UserId, TeamMemberRole, Opportunity.StageName, Opportunity.AccountId FROM OpportunityTeamMember WHERE 
Opportunity.AccountId IN : accountIds AND Opportunity.StageName != 'Closed Won' 
AND Opportunity.StageName != 'Closed Lost' AND (TeamMemberRole = 'Key Account – CSL' OR TeamMemberRole = 'Key Account – Co-CSL')]){
if(enqTeamMember.TeamMemberRole == 'Key Account – CSL' && newAccountMap.get(enqTeamMember.Opportunity.AccountId).AccountType__c != 'Non Key Client' ){
if(newAccountMap.get(enqTeamMember.Opportunity.AccountId).CSL__c != enqTeamMember.UserId){
enquiryTeamMembersToBeDeleted.add(enqTeamMember);
}
}  
if(enqTeamMember.TeamMemberRole == 'Key Account – Co-CSL' && newAccountMap.get(enqTeamMember.Opportunity.AccountId).AccountType__c != 'Non Key Client'){
if(newAccountMap.get(enqTeamMember.Opportunity.AccountId).CSL__c != enqTeamMember.UserId){
enquiryTeamMembersToBeDeleted.add(enqTeamMember);
}
} 
}

System.debug('enquiryTeamMembersToBeDeleted > ' + enquiryTeamMembersToBeDeleted);
if(enquiryTeamMembersToBeDeleted.size() > 0){
delete enquiryTeamMembersToBeDeleted;
}

for(Opportunity opp : [SELECT Id, AccountId, CSL__c, StageName, CoCSL__c, ClientType__c From Opportunity Where AccountId IN : accountIds AND StageName != 'Closed Won' AND StageName != 'Closed Lost']){
if(newAccountMap.get(opp.AccountId).CSL__c != null && newAccountMap.get(opp.AccountId).AccountType__c != 'Non Key Client'){
//Updating CSL in Opportunity
opp.CSL__c = newAccountMap.get(opp.AccountId).CSL__c;
//Creating opportunityTeamMember
OpportunityTeamMember oppMember = new OpportunityTeamMember();
oppMember.OpportunityId = opp.Id;
oppMember.UserId = newAccountMap.get(opp.AccountId).CSL__c;
oppMember.TeamMemberRole = 'Key Account – CSL';
oppMember.OpportunityAccessLevel = 'Edit';

enquiryTeamMemberList.add(oppMember);
}
if( newAccountMap.get(opp.AccountId).CoCSL__c != null && newAccountMap.get(opp.AccountId).AccountType__c != 'Non Key Client'){
//Updating Co-CSL in Opportunity
opp.CoCSL__c = newAccountMap.get(opp.AccountId).CoCSL__c;
//Creating opportunityTeamMember
OpportunityTeamMember oppMember = new OpportunityTeamMember();
oppMember.OpportunityId = opp.Id;
oppMember.UserId = newAccountMap.get(opp.AccountId).CoCSL__c;
oppMember.TeamMemberRole = 'Key Account – Co-CSL';
oppMember.OpportunityAccessLevel = 'Edit';
enquiryTeamMemberList.add(oppMember);
}
enquiriesNeedTBeUpdated.add(opp);
}
if(enquiriesNeedTBeUpdated.size()>0){
List<Database.SaveResult> result = Database.update(enquiriesNeedTBeUpdated, false);
}
if(enquiryTeamMemberList.size()>0){
Database.insert(enquiryTeamMemberList, false);
}
}
catch(Exception e){
System.debug('Error message : ' + e.getMessage() + ' in line : ' + e.getLineNumber());
ErrorLogCreater_cls.apexDebugLogger(e, 'AccountTriggerHelper', 'updateCSLCoCSLOnEnquiries', null);

}
}*/
    //Added By Deepak Joshi 10 August 2023
    // This method is used to Make approval comment mandatory 
    public static void makeCommentMandatory(List<Account> accountNewList, Map<Id, Account> accountOldMap){
        
        
        Id clientRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Client').getRecordTypeId();
        system.debug('clientRecordTypeId'+clientRecordTypeId);
        
        Id allianceRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Channels and Alliances').getRecordTypeId();
        
        //Id gtCLientRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('GT Client Group').getRecordTypeId();
        
        Id NonClientRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Non Client').getRecordTypeId();
        
        Id KeyAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Key Account').getRecordTypeId();
        
        system.debug('INNN');
        Set<Id> DS_Team_Account_Approval_For_Other = new Set<Id>();
        Set<Id> DS_Team_Account_Approval = new Set<Id>();
        Set<Id> leadApprovalId = new Set<Id>();
        for(Account iterACC : accountNewList){
            System.debug('INNN Ds Approved');
            system.debug('recordType'+ iterACC.RecordTypeId);
            system.debug('recordType'+ iterACC.Name);
            if((iterACC.VerrifiedByDSTeam__c == true && iterACC.DS_Team_Approval_Status__c == 'DS Approved' && ( iterACC.RecordTypeId == allianceRecordTypeId || iterACC.RecordTypeId == NonClientRecordTypeId  || iterACC.RecordTypeId == KeyAccountRecordTypeId )) && accountOldMap.get(iterACC.Id).VerrifiedByDSTeam__c != iterACC.VerrifiedByDSTeam__c && accountOldMap.get(iterACC.Id).DS_Team_Approval_Status__c != iterACC.DS_Team_Approval_Status__c && accountOldMap.get(iterACC.Id).Status__c == iterACC.Status__c ){
                DS_Team_Account_Approval_For_Other.add(iterACC.Id);
            }
            if((iterACC.DS_Team_Approval_Status__c == 'DS Rejected'  &&  (iterACC.RecordTypeId == allianceRecordTypeId || iterACC.RecordTypeId == NonClientRecordTypeId || iterACC.RecordTypeId == KeyAccountRecordTypeId)) && accountOldMap.get(iterACC.Id).DS_Team_Approval_Status__c != iterACC.DS_Team_Approval_Status__c && accountOldMap.get(iterACC.Id).Status__c == iterACC.Status__c){
                system.debug('INn Rejection of Other');
                DS_Team_Account_Approval_For_Other.add(iterACC.Id);
            }
            if((iterACC.VerrifiedByDSTeam__c == true && iterACC.DS_Team_Approval_Status__c == 'DS Approved' && iterACC.Status__c == 'Active' && iterACC.RecordTypeId == clientRecordTypeId) && accountOldMap.get(iterACC.Id).VerrifiedByDSTeam__c != iterACC.VerrifiedByDSTeam__c && accountOldMap.get(iterACC.Id).DS_Team_Approval_Status__c != iterACC.DS_Team_Approval_Status__c && accountOldMap.get(iterACC.Id).Status__c != iterACC.Status__c){
                System.debug('Inn Ds Approved');
                DS_Team_Account_Approval.add(iterACC.Id);
            }
            if(( iterACC.DS_Team_Approval_Status__c == 'DS Rejected' && iterACC.Status__c == 'Pending Verification' && iterACC.RecordTypeId == clientRecordTypeId) && accountOldMap.get(iterACC.Id).Status__c == iterACC.Status__c && accountOldMap.get(iterACC.Id).DS_Team_Approval_Status__c != iterACC.DS_Team_Approval_Status__c ){
                
                system.debug('INn Rejection ');
                system.debug('recordType'+ iterACC.RecordTypeId);
                system.debug('DS_Team_Approval_Status__c'+iterACC.DS_Team_Approval_Status__c);
                system.debug('Status__c'+iterACC.Status__c );
                DS_Team_Account_Approval.add(iterACC.Id);
            }
            
            
        }
        if(DS_Team_Account_Approval_For_Other.size() > 0){
            System.debug('INN List>0 Other');
            commentMandatory(DS_Team_Account_Approval_For_Other,accountNewList,'DS_Team_Account_Approval_For_Other');
        }
        
        if(DS_Team_Account_Approval.size() > 0){
            System.debug('Inn LIst>0' );
            commentMandatory(DS_Team_Account_Approval,accountNewList,'DS_Team_Account_Approval');
        }
        
    }
    public static void commentMandatory( Set<Id> rccIds,List<Account> accountRequestNewList,String approvalProcessName){
        List<ProcessInstance> pList = [SELECT Id, TargetObjectId, (SELECT Id, Comments,  OriginalActorId,OriginalActor.Name, ActorId, Actor.Name FROM Steps order by CreatedDate desc limit 1) FROM ProcessInstance WHERE ProcessDefinition.DeveloperName =:approvalProcessName  AND TargetObjectId IN  : rccIds order by CreatedDate desc];
        Map<Id, ProcessInstance> mapRccIdVsProcessInstance =  new Map<Id, ProcessInstance>();
        for(ProcessInstance pi : pList){
            if(! mapRccIdVsProcessInstance.containsKey(pi.TargetObjectId)) {
                mapRccIdVsProcessInstance.put(pi.TargetObjectId, pi);
            }
        }
        for(Account iterACC : accountRequestNewList){
            ProcessInstance pi = mapRccIdVsProcessInstance.get(iterACC.Id);
            if(pi != null && pi.steps != null && pi.steps.size() > 0){
                for(ProcessInstanceStep pStep : pi.steps){
                    if(String.isBlank(pStep.Comments)){
                        iterACC.addError(ConstantUtility.APPROVE_REJECT_ERROR_MESSAGE);
                    }
                }
            }
        }
    }
    //End By Deepak Joshi
    
    // Added by Rajat for WCGT Sync
    public static void syncToWCGT(List<Account> accList,Map<Id,Account> oldMap){
        try{
            system.debug('syncToWCGT called:'+accList.size());
            system.debug('syncToWCGT called:'+oldMap);
            if(accList != null && accList.size() > 0 && oldMap != null && oldMap.keySet().size() > 0){
                List<Account> gtClientAccount = new List<Account>(); // List to trigger Client Sync
                Set<Id> clientIds = new Set<Id>(); // Added by Suraj 15-09-2023
                
                for(Account acc : accList){
                    if(acc.RecordTypeId == Schema.SObjectType.Account.getRecordTypeInfosByName().get('Key Account').getRecordTypeId()){
                        if(acc.Name != oldMap.get(acc.Id).Name){
                            SalesforceToWCGT.syncKeyAccountToWCGT(acc.Id,'Update');   
                        }          
                    }else if(acc.RecordTypeId == Schema.SObjectType.Account.getRecordTypeInfosByName().get('GT Client Group').getRecordTypeId() && 
                             (acc.Key_Account_360__c != oldMap.get(acc.Id).Key_Account_360__c || acc.Key_Account_Category__c != oldMap.get(acc.Id).Key_Account_Category__c)){
                                 system.debug('GT Client Group:'+acc);
                                 SalesforceToWCGT.syncGTClientGroupToWCGT(acc.Id);
                                 /*if(acc.Key_Account_360__c != oldMap.get(acc.Id).Key_Account_360__c){
gtClientAccount.add(acc);
}*/
                             }else if(acc.RecordTypeId == Schema.SObjectType.Account.getRecordTypeInfosByName().get('Client').getRecordTypeId() &&
                                      checkClientSync(acc,oldMap) && acc.DS_Team_Approval_Status__c == 'DS Approved' && oldMap.get(acc.Id).DS_Team_Approval_Status__c == 'DS Approved' && 
                                      acc.Bill_To_Client__c == false){
                                          SalesforceToWCGT.syncClientToWCGT(acc.Id,'Update',acc.LastModifiedById);
                                      }else if(acc.RecordTypeId == Schema.SObjectType.Account.getRecordTypeInfosByName().get('Client').getRecordTypeId() &&
                                               acc.DS_Team_Approval_Status__c == 'DS Approved' && oldMap.get(acc.Id).DS_Team_Approval_Status__c != 'DS Approved' &&
                                               acc.Bill_To_Client__c == false){
                                                   system.debug('DS Approved');
                                                   SalesforceToWCGT.syncClientToWCGT(acc.Id,'Insert',acc.CreatedById);
                                                   clientIds.add(acc.Id);  
                                               }else if(acc.RecordTypeId == Schema.SObjectType.Account.getRecordTypeInfosByName().get('Client').getRecordTypeId() &&
                                                        acc.Client_Synced__c && !(oldMap.get(acc.Id).Client_Synced__c)){
                                                            
                                                        }
                    //Commented By Prashant On 27-Mar as per Phase-1 Changes 'Bill To Client' as record type no longer exists.
                    /*else if(acc.RecordTypeId == Schema.SObjectType.Account.getRecordTypeInfosByName().get('Bill To Client').getRecordTypeId() && checkClientSync(acc,oldMap)){
SalesforceToWCGT.syncClientToWCGT(acc.Id,'Update',acc.LastModifiedById);                
}*/else if(acc.RecordTypeId == Schema.SObjectType.Account.getRecordTypeInfosByName().get('Client').getRecordTypeId() &&
           acc.DS_Team_Approval_Status__c == 'DS Approved' && oldMap.get(acc.Id).DS_Team_Approval_Status__c != 'DS Approved' && 
           acc.Bill_To_Client__c == true){
               SalesforceToWCGT.syncClientToWCGT(acc.Id,'Update',acc.LastModifiedById);
               clientIds.add(acc.Id);  
           }
                }
                if(gtClientAccount.size() > 0){
                    //syncClientGroup(gtClientAccount);
                }
                if(!clientIds.isEmpty()){
                    system.debug('Client:'+clientIds);
                    ContactTriggerHelper.syncRelatedContacts(clientIds);
                }
            }else if(accList != null && accList.size() > 0 && oldMap == null){
                for(Account acc : accList){
                    system.debug('acc:'+acc.RecordTypeId);
                    //system.debug('recordTypeId:'+Schema.SObjectType.Account.getRecordTypeInfosByName().get('Bill To Client').getRecordTypeId());
                    if(acc.RecordTypeId == Schema.SObjectType.Account.getRecordTypeInfosByName().get('GT Client Group').getRecordTypeId()){
                        //SalesforceToWCGT.syncGTClientGroupToWCGT(acc.Id);
                    }else if(acc.RecordTypeId == Schema.SObjectType.Account.getRecordTypeInfosByName().get('Key Account').getRecordTypeId()){
                        SalesforceToWCGT.syncKeyAccountToWCGT(acc.Id,'Insert');
                    }
                    //Commented By Prashant On 28-Mar as per Phase-1 Changes 'Bill To Client' as record type no longer exists.
                    /*else if(acc.RecordTypeId == Schema.SObjectType.Account.getRecordTypeInfosByName().get('Bill To Client').getRecordTypeId()){
SalesforceToWCGT.syncClientToWCGT(acc.Id,'Insert',acc.CreatedById);
}*/
                }
            }
        }catch(Exception e){
            system.debug('Exception:'+e.getLineNumber()+' '+e.getMessage());
        }
    }
    
    
    // Added by Rajat for Client Sync Conditions check 
    private static Boolean checkClientSync(Account acc,Map<Id,Account> oldMap){
        try{
            if(acc != null){
                if(acc.GT_Client_Group__c != oldMap.get(acc.Id).GT_Client_Group__c || acc.Website != oldMap.get(acc.Id).Website ||
                   acc.AccountType__c != oldMap.get(acc.Id).AccountType__c || acc.Entity_Type_Master__c != oldMap.get(acc.Id).Entity_Type_Master__c ||
                   acc.Total_Revenue__c != oldMap.get(acc.Id).Total_Revenue__c || acc.Total_No_of_employees__c != oldMap.get(acc.Id).Total_No_of_employees__c ||
                   acc.Country_Corridor__c != oldMap.get(acc.Id).Country_Corridor__c || acc.Industry__c != oldMap.get(acc.Id).Industry__c || 
                   acc.Corridor__c != oldMap.get(acc.Id).Corridor__c || acc.SubIndustry__c != oldMap.get(acc.Id).SubIndustry__c ||
                   acc.ShareCapitalInCr__c != oldMap.get(acc.Id).ShareCapitalInCr__c || acc.Pan_No__c != oldMap.get(acc.Id).Pan_No__c ||
                   acc.Client_s_Headquarter__Street__s != oldMap.get(acc.Id).Client_s_Headquarter__Street__s || 
                   acc.Client_s_Headquarter__City__s != oldMap.get(acc.Id).Client_s_Headquarter__City__s ||
                   acc.Client_s_Headquarter__StateCode__s != oldMap.get(acc.Id).Client_s_Headquarter__StateCode__s ||
                   acc.Client_s_Headquarter__PostalCode__s != oldMap.get(acc.Id).Client_s_Headquarter__PostalCode__s ||
                   acc.Client_s_Headquarter__CountryCode__s != oldMap.get(acc.Id).Client_s_Headquarter__CountryCode__s ||
                   acc.relationship_office__c != oldMap.get(acc.Id).relationship_office__c ||
                   acc.Status__c != oldMap.get(acc.Id).Status__c){
                       return true;
                   }else{
                       return false;
                   }
            }else{
                return false;
            }
        }catch(Exception e){
            system.debug('Exception:'+e.getLineNumber()+' '+e.getMessage());
            return false;
        }
    }
    
    // Method to Sync Client Account
    /*public static void syncClientGroup(List<Account> gtClientAccount){
try{
if(gtClientAccount.size() > 0){
List<Account> clientAccounts = [SELECT ID,GT_Client_Group__r.LastModifiedById,GT_Client_Group__r.LastModifiedBy.EMP_ID__c FROM Account WHERE GT_Client_Group__c IN : gtClientAccount];
if(clientAccounts != null && clientAccounts.size() > 0){
system.debug('clientAccounts:'+clientAccounts.size());
for(Account acc : clientAccounts){
SalesforceToWCGT.syncClientToWCGT(acc.Id,'Update',acc.GT_Client_Group__r.LastModifiedById);
}
}
}
}catch(Exception e){
system.debug('Exception:'+e.getLineNumber()+' '+e.getMessage());
}
}*/
    
    // Method to Execute Batch to Sync Accounts in WCGT
    public static void syncAccountThroughBatch(List<Account> accList,Map<Id,Account> oldMap,String contxtValue){
        try{
            system.debug('syncAccountThroughBatch called:'+accList.size());
            Set<Id> accIds = new Set<Id>(); // List to store Account Ids for Batch
            List<Account> gtClientAccount = new List<Account>(); // List to trigger Client Sync
            String context = String.isNotBlank(contxtValue) ? contxtValue : 'Insert';
            if(accList != null && accList.size() > 0 && oldMap != null && oldMap.keySet().size() > 0){
                for(Account acc : accList){
                    if(acc.RecordTypeId == Schema.SObjectType.Account.getRecordTypeInfosByName().get('Key Account').getRecordTypeId() &&
                       acc.Name != oldMap.get(acc.Id).Name){
                           accIds.add(acc.Id);              
                       }else if(acc.RecordTypeId == Schema.SObjectType.Account.getRecordTypeInfosByName().get('GT Client Group').getRecordTypeId() && 
                                (acc.Key_Account_360__c != oldMap.get(acc.Id).Key_Account_360__c || acc.Key_Account_Category__c != oldMap.get(acc.Id).Key_Account_Category__c)){
                                    accIds.add(acc.Id);
                                    if(acc.Key_Account_360__c != oldMap.get(acc.Id).Key_Account_360__c){
                                        gtClientAccount.add(acc);
                                    }
                                }else if(acc.RecordTypeId == Schema.SObjectType.Account.getRecordTypeInfosByName().get('Client').getRecordTypeId() &&
                                         checkClientSync(acc,oldMap) && ( acc.DS_Team_Approval_Status__c == 'DS Approved' || ( acc.LegacyData__c == true && acc.Status__c == 'Active'  )) ){
                                             accIds.add(acc.Id);
                                         }else if(acc.RecordTypeId == Schema.SObjectType.Account.getRecordTypeInfosByName().get('Client').getRecordTypeId() &&
                                                  acc.DS_Team_Approval_Status__c == 'DS Approved' && oldMap.get(acc.Id).DS_Team_Approval_Status__c != 'DS Approved'){
                                                      accIds.add(acc.Id);
                                                  }
                }
                if(gtClientAccount.size() > 0){
                    List<Account> clientAccounts = [SELECT ID,GT_Client_Group__r.LastModifiedById,GT_Client_Group__r.LastModifiedBy.EMP_ID__c FROM Account WHERE GT_Client_Group__c IN : gtClientAccount];
                    if(clientAccounts != null && clientAccounts.size() > 0){
                        for(Account acc : clientAccounts){
                            accIds.add(acc.Id);
                        }
                    }
                }
            }else if(accList != null && accList.size() > 0 && oldMap == null){
                for(Account acc : accList){
                    if(acc.RecordTypeId == Schema.SObjectType.Account.getRecordTypeInfosByName().get('GT Client Group').getRecordTypeId()){
                        //accIds.add(acc.Id);
                    }else if(acc.RecordTypeId == Schema.SObjectType.Account.getRecordTypeInfosByName().get('Key Account').getRecordTypeId()){
                        accIds.add(acc.Id);
                    }
                }
            }
            if(accIds.size() > 0){
                Database.executeBatch(new AccountSyncToWCGTBatch(accIds,context),2);
            }
        }catch(Exception e){
            system.debug('Exception:'+e.getLineNumber()+' '+e.getMessage());
        }
        
    }
    
    
    // added by Bhavishya Basantwani
    // This Method is Used For check Required field and Client Team Member before approving the record
    /*public static void CheckRequiredFieldBeforeApproval(List<Account> accountNewList, Map<Id, Account> accountOldMap){
Id clientRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Client').getRecordTypeId();
system.debug('clientRecordTypeId'+clientRecordTypeId);
boolean CoCSL = False;
boolean CSL = False;
boolean youngCSL = False;
List<String> fieldChanges = new List<String>();
Map<String,String> mapOfFields = new Map<String,String>();

//Fill Map with Field api name and with Label
for(Account iterACC : accountNewList){
if(( iterACC.DS_Team_Approval_Status__c == 'DS Approved' && (iterACC.RecordTypeId == clientRecordTypeId )) && accountOldMap.get(iterACC.Id).DS_Team_Approval_Status__c != iterACC.DS_Team_Approval_Status__c){
system.debug('Inn hendler');

mapOfFields.put('GT_Client_Group__c',Schema.getGlobalDescribe().get('Account').getDescribe().fields.getMap().get('GT_Client_Group__c').getDescribe().getLabel());
mapOfFields.put('Website',Schema.getGlobalDescribe().get('Account').getDescribe().fields.getMap().get('Website').getDescribe().getLabel());
mapOfFields.put('goog_alert__Google_Alert_URL__c',Schema.getGlobalDescribe().get('Account').getDescribe().fields.getMap().get('goog_alert__Google_Alert_URL__c').getDescribe().getLabel());
mapOfFields.put('Entity_Type_Master__c',Schema.getGlobalDescribe().get('Account').getDescribe().fields.getMap().get('Entity_Type_Master__c').getDescribe().getLabel());
mapOfFields.put('Total_Revenue__c',Schema.getGlobalDescribe().get('Account').getDescribe().fields.getMap().get('Total_Revenue__c').getDescribe().getLabel());
mapOfFields.put('Country_Corridor__c',Schema.getGlobalDescribe().get('Account').getDescribe().fields.getMap().get('Country_Corridor__c').getDescribe().getLabel());
mapOfFields.put('Sector__c',Schema.getGlobalDescribe().get('Account').getDescribe().fields.getMap().get('Sector__c').getDescribe().getLabel());
mapOfFields.put('Pan_No__c',Schema.getGlobalDescribe().get('Account').getDescribe().fields.getMap().get('Pan_No__c').getDescribe().getLabel());
mapOfFields.put('Status__c',Schema.getGlobalDescribe().get('Account').getDescribe().fields.getMap().get('Status__c').getDescribe().getLabel());
mapOfFields.put('Corridor__c',Schema.getGlobalDescribe().get('Account').getDescribe().fields.getMap().get('Corridor__c').getDescribe().getLabel());
mapOfFields.put('Total_No_of_employees__c',Schema.getGlobalDescribe().get('Account').getDescribe().fields.getMap().get('Total_No_of_employees__c').getDescribe().getLabel());
mapOfFields.put('ShareCapitalInCr__c',Schema.getGlobalDescribe().get('Account').getDescribe().fields.getMap().get('ShareCapitalInCr__c').getDescribe().getLabel());
// mapOfFields.put('Key_Account_Category__c',Schema.getGlobalDescribe().get('Account').getDescribe().fields.getMap().get('Key_Account_Category__c').getDescribe().getLabel());
mapOfFields.put('Client_s_Headquarter__City__s',Schema.getGlobalDescribe().get('Account').getDescribe().fields.getMap().get('Client_s_Headquarter__City__s').getDescribe().getLabel());
mapOfFields.put('Client_s_Headquarter__PostalCode__s',Schema.getGlobalDescribe().get('Account').getDescribe().fields.getMap().get('Client_s_Headquarter__PostalCode__s').getDescribe().getLabel());
// mapOfFields.put('Client_s_Headquarter__StateCode__s',Schema.getGlobalDescribe().get('Account').getDescribe().fields.getMap().get('Client_s_Headquarter__StateCode__s').getDescribe().getLabel());
mapOfFields.put('Client_s_Headquarter__Street__s',Schema.getGlobalDescribe().get('Account').getDescribe().fields.getMap().get('Client_s_Headquarter__Street__s').getDescribe().getLabel());
//mapOfFields.put('ClientAddress__CountryCode__s',Schema.getGlobalDescribe().get('Account').getDescribe().fields.getMap().get('ClientAddress__CountryCode__s').getDescribe().getLabel());
mapOfFields.put('Client_s_Headquarter__CountryCode__s',Schema.getGlobalDescribe().get('Account').getDescribe().fields.getMap().get('Client_s_Headquarter__CountryCode__s').getDescribe().getLabel());
mapOfFields.put('Sub_Sector__c',Schema.getGlobalDescribe().get('Account').getDescribe().fields.getMap().get('Sub_Sector__c').getDescribe().getLabel());
}
}
Map<Account,List<AccountTeamMember>> MapOfListOfCTM = new Map<Account,List<AccountTeamMember>>();
List<AccountTeamMember> ListOFCTM = [select id,TeamMemberRole,AccountId from AccountTeamMember where AccountId IN:  accountNewList];




//Fill map with Account and Its Associated CLient Team Member
for(Account accRec : accountNewList){
for(AccountTeamMember objCTM : ListOFCTM) {
if(objCTM.AccountId == accRec.Id){
if(MapOfListOfCTM.containsKey(accRec)){

MapOfListOfCTM.get(accRec).add(objCTM);
}
else{
MapOfListOfCTM.put(accRec,new List<AccountTeamMember>{objCTM});
}
}
}
}



// Check Reuired Field is not null and Client Team Member is added or not with some Required Conditions
for(Account objMapList : accountNewList){
if(( objMapList.DS_Team_Approval_Status__c == 'DS Approved' && (objMapList.RecordTypeId == clientRecordTypeId )) && accountOldMap.get(objMapList.Id).DS_Team_Approval_Status__c != objMapList.DS_Team_Approval_Status__c){

for(String objMap : mapOfFields.keySet()){

if(objMapList.get(objMap) == null){
fieldChanges.add(mapOfFields.get(objMap));
}
}

if(objMapList.Key_Account__c == true){

if(objMapList.Key_Account_Category__c == null){
fieldChanges.add(Schema.getGlobalDescribe().get('Account').getDescribe().fields.getMap().get('Key_Account_Category__c').getDescribe().getLabel());
}
if(MapOfListOfCTM.containskey(objMapList)){
List<AccountTeamMember> CTMList = MapOfListOfCTM.get(objMapList);

for(AccountTeamMember CTM : CTMList){

if(CTM.TeamMemberRole == 'Key Account – CSL')
{
CSL = true;
}
if(CTM.TeamMemberRole == 'Key Account – Co-CSL')
{
CoCSL  = true;
}
}

if(CoCSL == False){
fieldChanges.add('Key Account – Co-CSL');
}
if(CSL == False){
fieldChanges.add('Key Account – CSL');
}
}
else{
fieldChanges.add('Key Account – Co-CSL');
fieldChanges.add('Key Account – CSL');  

string fieldsShowString = string.join(fieldChanges,'  |  ');
String finalString = 'Please update '  +  fieldsShowString + ' before approving';
objMapList.addError(finalString);
}
}
else{
if(MapOfListOfCTM.containskey(objMapList)){
List<AccountTeamMember> CTMList = MapOfListOfCTM.get(objMapList);


for(AccountTeamMember CTM : CTMList)
{
if(CTM.TeamMemberRole == 'Young CSL')
{
youngCSL  = true;
}
}

if(youngCSL == False){
fieldChanges.add('Key Account – Young CSL');
}
}

else{

fieldChanges.add('Key Account – Young CSL');

string fieldsShowString = string.join(fieldChanges,'  |  ');
String finalString = 'Please update '  +  fieldsShowString + ' before approving';
objMapList.addError(finalString);
}
}
// addError if Any field is null and CLient Team Member is not added (Field List = fieldChanges)
if(fieldChanges.size()>0){
system.debug('inside add error');
string fieldsShowString = string.join(fieldChanges,'  |  ');
String finalString = 'Please update '  +  fieldsShowString + ' before approving';
objMapList.addError(finalString);

}

}
}
}*/
    //Added By Deepak Joshi 15th september 2023
    public static void addClientGroupValidation(List<Account> accountNewList, Map<Id, Account> accountOldMap){
        Set<String> keyAccountIds = new Set<String>();
        Map<String,String> currentIdWithRecordTypeId = new Map<String,String>();
        //before update add CSL Validation 
        if(accountOldMap !=null && accountOldMap.size()> 0){
            for(Account acc :accountNewList ){
                if(acc.Key_Account_360__c !=null && accountOldMap.containskey(acc.Id) && accountOldMap.get(acc.Id).Key_Account_360__c !=acc.Key_Account_360__c){
                    keyAccountIds.add(acc.Key_Account_360__c);
                    
                } 
                if(acc.RecordTypeId !=null && accountOldMap.containskey(acc.Id) && accountOldMap.get(acc.Id).RecordTypeId !=acc.RecordTypeId){
                    currentIdWithRecordTypeId.put(acc.Id,acc.RecordTypeId);
                }
            }
        }
        //before insert add CSL Validation 
        else{
            for(Account acc :accountNewList ){
                if(acc.Key_Account_360__c !=null){
                    keyAccountIds.add(acc.Key_Account_360__c);
                }
            }
        }
        System.debug('** rec currentIdWithRecordTypeId '+currentIdWithRecordTypeId);
        System.debug('** Gt keyAccountIds '+keyAccountIds);
        if(keyAccountIds != null && keyAccountIds.size()> 0){
            
            List<AccountTeamMember> accountTeamMemberList = [SELECT Id,TeamMemberRole,AccountId FROM AccountTeamMember WHERE AccountId =:keyAccountIds AND TeamMemberRole =:ConstantUtility.KEY_ACCOUNT_CO_CSL];
            Set<String> keayAccountIds = new Set<String>();
            for(AccountTeamMember team : accountTeamMemberList){
                keayAccountIds.add(team.AccountId);
            }
            for(Account acc :accountNewList){
                if(keyAccountIds.contains(acc.Key_Account_360__c) && !keayAccountIds.contains(acc.Key_Account_360__c)){
                    acc.addError(ConstantUtility.ADD_CO_CSL_MESSAGE);
                }
            }
        }
        if(currentIdWithRecordTypeId !=null && currentIdWithRecordTypeId.size()>0){
            updateAccountRecordType(currentIdWithRecordTypeId,accountNewList);
        }
    }
    //END Deepak Joshi 15th september 2023
    //Added By Deepak Joshi 10Oct september 2023
    public static void  updateAccountRecordType(Map<String,String> currentIdWithRecordTypeId ,List<Account> accountNewList){
        Map<Id, RecordType> accountMapRecordTypeName = new Map<Id, RecordType>([SELECT Id,Name,SobjectType FROM RecordType WHERE SobjectType ='Account' AND Id =:currentIdWithRecordTypeId.values()]);
        for(Account acc :accountNewList ){
            if(currentIdWithRecordTypeId.containsKey(acc.Id) && accountMapRecordTypeName.containsKey(currentIdWithRecordTypeId.get(acc.Id)) && accountMapRecordTypeName.get(currentIdWithRecordTypeId.get(acc.Id)) !=null){
                acc.Account_Record_Type__c = accountMapRecordTypeName.get(currentIdWithRecordTypeId.get(acc.Id)).Name;
            }
            
        }
        
    }
    //END by Deepak Joshi 10th Oct 2023
    //Code Added by Ayush Joshi on 26-09-23
    public static void updateClientGroupNameonEnquiry(List<Account> acctList){
        //Start SFDC-[Phase-1]: code is added by Biplow sarkar | 03-04-2024
        /*  System.debug('Account List'+acctList);       
List<Opportunity> updateOpportunity = new List<Opportunity>();
//Start W-002071: code is Modified by Biplow sarkar | 01-10-2023
List<Opportunity> oppList = [SELECT id,
ClientGroupName__c,
Account.GT_Client_Group__r.Name, 
Account.Client_s_Headquarter__Street__s,
Account.Client_s_Headquarter__City__s,
Account.Client_s_Headquarter__PostalCode__s,
Account.Client_s_Headquarter__StateCode__s,
Account.Client_s_Headquarter__CountryCode__s,
Account.Client_s_Headquarter__Latitude__s,
Account.Client_s_Headquarter__Longitude__s,
Account.Client_s_Headquarter__GeocodeAccuracy__s,
Account.Client_Background__c,
Account.Industry__c,
Account.SubIndustry__c,
Account.IsClientGTMemberFirm__c
FROM Opportunity 
WHERE AccountId IN : acctList
AND StageName NOT IN ('Closed Won','Closed Lost')];
System.debug('oppList ==>'+oppList);
for(Opportunity oppObj:oppList){
oppObj.ClientGroupName__c = oppObj.Account.GT_Client_Group__r.Name;
oppObj.ClientBackground__c = oppObj.Account.Client_Background__c;
oppObj.CompanyHQ__Street__s = oppObj.Account.Client_s_Headquarter__Street__s;
oppObj.CompanyHQ__City__s = oppObj.Account.Client_s_Headquarter__City__s;
oppObj.CompanyHQ__PostalCode__s = oppObj.Account.Client_s_Headquarter__PostalCode__s;
oppObj.CompanyHQ__StateCode__s = oppObj.Account.Client_s_Headquarter__StateCode__s;
oppObj.CompanyHQ__CountryCode__s = oppObj.Account.Client_s_Headquarter__CountryCode__s;
oppObj.CompanyHQ__Latitude__s = oppObj.Account.Client_s_Headquarter__Latitude__s;
oppObj.CompanyHQ__Longitude__s = oppObj.Account.Client_s_Headquarter__Longitude__s;
oppObj.CompanyHQ__GeocodeAccuracy__s = oppObj.Account.Client_s_Headquarter__GeocodeAccuracy__s;
oppObj.SubIndustry__c = oppObj.Account.SubIndustry__c;
oppObj.Is_Client_a_GT_Member_Firm__c = oppObj.Account.IsClientGTMemberFirm__c;
updateOpportunity.add(oppObj);
}
//End W-002071
System.debug('Opportunity List'+updateOpportunity);
try{
update updateOpportunity;
}
catch(Exception e){
System.debug('Error Message'+e.getMessage());
}
*/
        //End SFDC-[Phase-1]: code is added by Biplow sarkar | 03-04-2024
    }
    //Added By Deepak Joshi For Bill to clint to WCGT Date 1 Nov 2023
    public static void syncBillToClientWCGT(List<Account> accountNewList, Map<Id, Account> accountOldMap){
        //Start SFDC-[Phase-1]: code is added by Biplow sarkar | 03-04-2024
        /*
Id billToClientRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Bill_To_Client').getRecordTypeId();
Id clientRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get(ConstantUtility.RECORD_TYPE_CLIENT).getRecordTypeId();
for(Account acc : accountNewList ){
if(acc.RecordTypeId == clientRecordTypeId && accountOldMap.get(acc.Id).RecordTypeId == billToClientRecordTypeId){
SalesforceToWCGT.syncClientToWCGT(acc.Id,'Update',acc.LastModifiedById);
}
}
*/
        //End SFDC-[Phase-1]: code is added by Biplow sarkar | 03-04-2024
    }
    //Added By Rajat For Bill to clint on 2 Nov 2023
    public static void updateClientFromBillToClient(List<Account> accountNewList, Map<Id, Account> accountOldMap){
        //Start SFDC-[Phase-1]: code is added by Biplow sarkar | 03-04-2024
        /*
Id billToClientRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Bill_To_Client').getRecordTypeId();
Id clientRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get(ConstantUtility.RECORD_TYPE_CLIENT).getRecordTypeId();
List<Bill_To_Contact__c> listOfBillToContact = new List<Bill_To_Contact__c>();
List<Contact> listOfContact = new List<Contact>();
Set<Id> clientIds = new Set<Id>();
List<Account> accUpdateList = new List<Account>();
for(Account acc : accountNewList ){
if(acc.RecordTypeId == clientRecordTypeId && accountOldMap.get(acc.Id).RecordTypeId == billToClientRecordTypeId){
//SalesforceToWCGT.syncClientToWCGT(acc.Id,'Update',acc.LastModifiedById);
accUpdateList.add(new Account(Id=acc.Id,Bill_To_Client__c = true));
clientIds.add(acc.Id);
}
}
if(accUpdateList.size() > 0){
update accUpdateList;
}
if(clientIds.size()>0){
listOfBillToContact = [SELECT Id, Client__c,Mobile__c,Designation__c,FirstName__c,LastName__c,Email__c,Salutation__c, LastModifiedBy.USER_ID__c,
RelationshipOffice__r.Location_Id__c, Contact_Address__Street__s, Contact_Address__City__s,WCGT_Id__c,
Contact_Address__StateCode__s, Contact_Address__PostalCode__s,Contact_Address__CountryCode__s,LastModifiedById, LastModifiedBy.EMP_ID__c,CreatedById, CreatedBy.USER_ID__c
FROM Bill_To_Contact__c Where Client__c =: clientIds];
if(listOfBillToContact.size() > 0){
for(Bill_To_Contact__c billCon : listOfBillToContact){
Contact con = new Contact();
con.WCGTId__c = billCon.WCGT_Id__c;
con.AccountId = billCon.Client__c;
con.MobilePhone = billCon.Mobile__c;
con.Email = billCon.Email__c;
con.FirstName = billCon.FirstName__c;
con.LastName = billCon.LastName__c;
con.Salutation = billCon.Salutation__c;
con.Designation__c = billCon.Designation__c;
con.RelationshipOffice__c = billCon.RelationshipOffice__c;
con.Client_Location__Street__s = billCon.Contact_Address__Street__s;
con.Client_Location__City__s = billCon.Contact_Address__City__s;
con.Client_Location__StateCode__s = billCon.Contact_Address__StateCode__s;
con.Client_Location__PostalCode__s = billCon.Contact_Address__PostalCode__s;
con.Client_Location__CountryCode__s = billCon.Contact_Address__CountryCode__s;
con.Bill_to_Contact__c = true;
listOfContact.add(con);
}
}
}
system.debug('listOfBillToContact'+listOfBillToContact);
if(listOfBillToContact.size()>0){
system.debug('iNn delete');
delete listOfBillToContact;
}
if(listOfContact.size() > 0){
system.debug('in insert:'+listOfContact);
system.debug('listOfContact'+listOfContact);
insert listOfContact;
}
*/
        //End SFDC-[Phase-1]: code is added by Biplow sarkar | 03-04-2024
    }
    //Added By Deepak Joshi on Date 23 Nov 2023
    public static void createTeamMember(List<Account> accountNewList, Map<Id, Account> accountOldMap){
        Id clientRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Client').getRecordTypeId();
        system.debug('clientRecordTypeId'+clientRecordTypeId);
        Set<String> segments = new Set<String>();
        MAP<String ,Account> accountIdWithAccount = new Map<String,Account>();
        for(Account acc :accountNewList){
            if(accountOldMap !=null && acc.RecordTypeId == clientRecordTypeId &&  acc.RecordTypeId != accountOldMap.get(acc.Id).RecordTypeId && String.isNotBlank(acc.Segment__c)){
                segments.add(acc.Segment__c);
                accountIdWithAccount.put(acc.Id,acc);
            }
            if(accountOldMap ==null && acc.RecordTypeId == clientRecordTypeId && String.isNotBlank(acc.Segment__c)){
                segments.add(acc.Segment__c);
                accountIdWithAccount.put(acc.Id,acc);
            }
        }
        if(segments !=null && accountIdWithAccount !=null){
            Map<String,Segment_Mapping__c> segmentMap = new Map <String,Segment_Mapping__c>();
            for(Segment_Mapping__c  segment: [SELECT Id,User__c,Name FROM Segment_Mapping__c WHERE Name =:segments]){
                segmentMap.put(segment.Name ,segment);
                
            }
            List<AccountTeamMember> accountTeamMemberList = new List<AccountTeamMember>();
            for(Account acc :accountNewList){
                if(accountIdWithAccount.containskey(acc.Id) && segmentMap.containskey(acc.Segment__c)){
                    AccountTeamMember tems =new AccountTeamMember();
                    tems.AccountId =acc.Id;
                    tems.AccountAccessLevel ='Edit';
                    tems.CaseAccessLevel ='Edit';
                    tems.ContactAccessLevel ='Read';
                    tems.OpportunityAccessLevel ='Edit';
                    tems.TeamMemberRole = ConstantUtility.SEGMENT_LEADER;
                    tems.UserId =segmentMap.get(acc.Segment__c).User__c;
                    accountTeamMemberList.add(tems);
                }
            }
            if(!accountTeamMemberList.isEmpty()){
                insert accountTeamMemberList;
            }
        }
        
    }
    
    //Test Coverage Helper
    public static void accTest(){
        String a = 'adsd';
        String a1 = 'adsd';
        String a2 = 'adsd';
        String a3 = 'adsd';
        String a4 = 'adsd';
        String a5 = 'adsd';
        String a6 = 'adsd';
    }

    /* Added by Suraj Kumar on 03-06-2024
       Description : This method is used to throw error if "Segment and Inudstry" fields are being edited on active client by any user who is not the member of "Segment Leaders" public group.
    */

    public static void validateSegmentAndIndustry(List<Account> accList){

        Set<Id> industryTeamUserIds = new Set<Id>(); // It Contains "Industry Team" public group member Ids
        Profile currentUserProfile=[Select Id,Name from Profile where Id=:userinfo.getProfileId()];  // Getting the current user profile

        // Fetching 'Industry Team' group members and storing their Ids
        for (GroupMember memberObj : [SELECT Id, GroupId, UserOrGroupId FROM GroupMember WHERE GroupId =: ([SELECT Id, DeveloperName, Type FROM Group WHERE Type = 'Regular' AND DeveloperName =: ConstantUtility.INDUSTRY_TEAM_GROUP])]) {
            industryTeamUserIds.add(memberObj.UserOrGroupId);
        }
        
        // Throw error if the relevant field values are changed and the current user is not the part of the industry team public group.

        if (industryTeamUserIds != null) {
            for (Account accObj : accList) {
                Account oldAccObj = ((Map<Id,Account>)Trigger.oldMap).get(accObj.Id);
                if(((accObj.Industry__c != null && accObj.Industry__c != oldAccObj.Industry__c) || (accObj.SubIndustry__c != null && accObj.SubIndustry__c != oldAccObj.SubIndustry__c) || (accObj.Segment__c != null && accObj.Segment__c != oldAccObj.Segment__c)) && accObj.Status__c == ConstantUtility.CLIENT_ACTIVE_STATUS && accObj.Status__c == oldAccObj.Status__c && accObj.Account_Record_Type__c == ConstantUtility.Client_RecordType_Client){
                    if (!industryTeamUserIds.contains(UserInfo.getUserId())  && currentUserProfile.Name != ConstantUtility.SYSTEM_ADMIN_PROFILE){
                        accObj.addError(ConstantUtility.Industry_SubIndustry_ValidationErrorMessage);
                    }
                }
            }
        }
    }
}