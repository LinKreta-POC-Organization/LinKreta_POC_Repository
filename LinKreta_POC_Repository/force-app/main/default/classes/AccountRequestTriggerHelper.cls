/*AUTHOR                   : Deepak Joshi
VERSION                  : 1
MODIFICATION DATE        : 10 August 2023
PROJECT NAME / TICKET #  : GT
DESCRIPTION              : Account RequestTrigger

AUTHOR                   :
VERSION                  :1
MODIFICATION DATE        : 
PROJECT NAME / TICKET #  : 
DESCRIPTION              : 
*/
public class AccountRequestTriggerHelper {
    public static void isBeforeUpdate(List<Account_Requests__c> accountRequestNewList, Map<Id, Account_Requests__c> accountRequestOldMap) {
        makeCommentMandatory(accountRequestNewList, accountRequestOldMap);
    }
     // This method is used to Make approval comment mandatory 
     public static void makeCommentMandatory(List<Account_Requests__c> accountRequestNewList, Map<Id, Account_Requests__c> accountRequestOldMap){
        System.debug('Comment mandate method called!');
        Set<Id> accountApprovalId = new Set<Id>();
        Set<Id> leadApprovalId = new Set<Id>();
        for(Account_Requests__c iterACC : accountRequestNewList){
            if(iterACC.Client__c != null && (iterACC.Status__c == ConstantUtility.REJECTED || iterACC.Status__c == ConstantUtility.APPROVED) && accountRequestOldMap.get(iterACC.Id).Status__c != iterACC.Status__c){
                accountApprovalId.add(iterACC.Id);
            }
            if(iterACC.New_Client__c != null && (iterACC.Status__c == ConstantUtility.REJECTED || iterACC.Status__c == ConstantUtility.APPROVED) && accountRequestOldMap.get(iterACC.Id).Status__c != iterACC.Status__c){
                leadApprovalId.add(iterACC.Id);
            }
        }
        
        if(accountApprovalId.size() > 0){
            commentMandatory(accountApprovalId,accountRequestNewList,ConstantUtility.DS_APPROVAL_PROCESS);
        }
        if(leadApprovalId.size() > 0){
            commentMandatory(leadApprovalId,accountRequestNewList,ConstantUtility.CNM_APPROVAL_PROCESS);
        }

    }
    // This method is used to Make approval comment mandatory 
    public static void commentMandatory( Set<Id> rccIds,List<Account_Requests__c> accountRequestNewList,String approvalProcessName){
        List<ProcessInstance> pList = [SELECT Id, TargetObjectId, (SELECT Id, Comments,  OriginalActorId,OriginalActor.Name, ActorId, Actor.Name FROM Steps order by CreatedDate desc limit 1) FROM ProcessInstance WHERE ProcessDefinition.DeveloperName =:approvalProcessName  AND TargetObjectId IN  : rccIds order by CreatedDate desc];        
        Map<Id, ProcessInstance> mapRccIdVsProcessInstance =  new Map<Id, ProcessInstance>();
        for(ProcessInstance pi : pList){
            if(! mapRccIdVsProcessInstance.containsKey(pi.TargetObjectId)) {
                mapRccIdVsProcessInstance.put(pi.TargetObjectId, pi);
            }
        }
        Map<String ,String> clientIdWithComments = new  Map<String ,String>();
        Map<String ,String> newClientIdWithComments = new  Map<String ,String>();
        for(Account_Requests__c iterACC : accountRequestNewList){
            ProcessInstance pi = mapRccIdVsProcessInstance.get(iterACC.Id);
            for(ProcessInstanceStep pStep : pi.steps){
                if(String.isBlank(pStep.Comments)){
                    iterACC.addError(ConstantUtility.APPROVE_REJECT_ERROR_MESSAGE);
                }
                else{
                    if(iterACC.Client__c !=null){
                        clientIdWithComments.put(iterACC.Client__c ,pStep.Comments);
                    }
                    if(iterACC.New_Client__c !=null){
                        newClientIdWithComments.put(iterACC.New_Client__c,pStep.Comments);
                    }
                }
            }
        }
        if(clientIdWithComments !=null && clientIdWithComments.size()>0){
            updateAccountReasonDescription(clientIdWithComments);
        }
        if(newClientIdWithComments !=null && newClientIdWithComments.size()>0){
            updateLeadReasonDescription(newClientIdWithComments);
        }
        
    }
    //Update account Reason(Description) with approval Comments for email 
    public static void updateAccountReasonDescription(Map<String ,String> clientIdWithComments){
        List<Account> accountList = [SELECT Id,Reason_Description__c From Account WHERE Id=:clientIdWithComments.keySet()];
        for(Account acc : accountList){
            acc.Reason_Description__c =  clientIdWithComments.get(acc.Id);
        }
        System.debug('** accountList  '+accountList);
        update accountList;

    }
    //Update lead Reason(Description) with approval Comments for email 
    public static void updateLeadReasonDescription(Map<String ,String> newClientIdWithComments){
        List<Lead> leadList = [SELECT Id,Reason_Description__c From Lead WHERE Id=:newClientIdWithComments.keySet()];
        for(Lead led : leadList){
            led.Reason_Description__c =  newClientIdWithComments.get(led.Id);
        }
        System.debug('** leadList  '+leadList);
        update leadList;

    }
}