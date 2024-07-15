public without sharing class SubmitForApprovalButtonController {
    @AuraEnabled
    public static void sendEnquiryApprovalRequest(String recordId,String assignApproval,String comments){
        System.debug('Hello Testing ');
        List<Lead> leadList = [select id from Lead where Id =:recordId];
        String userId = UserInfo.getUserId();
        Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
        req1.setComments(comments);
        req1.setObjectId(recordId);
        System.debug(userId);
        req1.setSubmitterId(userId); 
        req1.setProcessDefinitionNameOrId(assignApproval);
        req1.setSkipEntryCriteria(true);
        try{
             //Start SFDC-[Phase-1]: code is added by Biplow sarkar | 04-04-2024
            /* 
            Approval.ProcessResult result = Approval.process(req1);
           // if(assignApproval=='NSL_Approval'){
                //leadList[0].IndustryLeaderApprovalStatus__c = 'Pending';  
           // }
           
           /* else if(assignApproval=='ClientCouncilApproval'){
                leadList[0].CCApprovalStatus__c = 'Pending';
            } */
            //End SFDC-[Phase-1]: code is added by Biplow sarkar | 04-04-2024
            update leadList;
        }
        catch(Exception e){
            System.debug('Error occured '+e.getMessage()+' '+e.getLineNumber());
        }
    }
    @AuraEnabled
    public static void sendOpportunityApprovalRequest(String recordId,String assignApproval,String comments){
        List<Opportunity> oppoList = [select id,AccountId,ClientContact__c from Opportunity where Id =:recordId];
        String accountid = oppoList[0].AccountId;
        String contactId;
        if(oppoList[0].ClientContact__c!=null){
            contactId = oppoList[0].ClientContact__c;
        }
        String userId = UserInfo.getUserId();
        String assignAccountApproval = 'DS_Team_Account_Approval';
        String assignContactApproval = 'DS_Team_Contact_Approval';
        Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
        req1.setComments(comments);
        req1.setObjectId(recordId);
        System.debug(userId);
        req1.setSubmitterId(userId); 
        req1.setProcessDefinitionNameOrId(assignApproval);
        req1.setSkipEntryCriteria(true);
        try{
            Approval.ProcessResult result = Approval.process(req1);
            if(assignApproval=='DS_Team_Approval'){
                oppoList[0].StatusDSTeamRemarkStatus__c = 'Pending';
            }
            update oppoList;
        }
        catch(Exception e){
            System.debug('Error occured '+e.getMessage()+' '+e.getLineNumber());
        }
        System.debug('account id'+accountid+'account approval'+assignAccountApproval+'comments'+comments);
        if(accountid!=null && assignAccountApproval!=null ){
           // sendAccountApprovalRequest(accountid,assignAccountApproval,comments);
        }
        if(assignContactApproval!=null && contactId !=null){
           // sendContactApprovalRequest(contactId,assignContactApproval,comments);
        }
    }
    @AuraEnabled
    public static void sendAccountApprovalRequest(String accountid,String assignApproval,String comments){
        String userId = UserInfo.getUserId();
        Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
        req1.setComments(comments);
        req1.setObjectId(accountid);
        System.debug(userId);
        req1.setSubmitterId(userId); 
        req1.setProcessDefinitionNameOrId(assignApproval);
        req1.setSkipEntryCriteria(true);
        try{
            Approval.ProcessResult result = Approval.process(req1);
            /*if(assignApproval=='DS_Team_Approval'){
oppoList[0].StatusDSTeamRemarkStatus__c = 'Pending';
}
update oppoList;*/
        }
        catch(Exception e){
            System.debug('Error occured '+e.getMessage()+' '+e.getLineNumber());
        }
    }
    @AuraEnabled
    public static void sendContactApprovalRequest(String contactId,String assignApproval,String comments){
        String userId = UserInfo.getUserId();
        Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
        req1.setComments(comments);
        req1.setObjectId(contactId);
        System.debug(userId);
        req1.setSubmitterId(userId); 
        req1.setProcessDefinitionNameOrId(assignApproval);
        req1.setSkipEntryCriteria(true);
        try{
            Approval.ProcessResult result = Approval.process(req1);
            /*if(assignApproval=='DS_Team_Approval'){
oppoList[0].StatusDSTeamRemarkStatus__c = 'Pending';
}
update oppoList;*/
        }
        catch(Exception e){
            System.debug('Error occured '+e.getMessage()+' '+e.getLineNumber());
        }
    }
    public static void sendQuoteApprovalRequest(String recordId){
        //Start SFDC-[Phase-1]: code is added by Biplow sarkar | 09-04-2024
        /*
        List<Quote> quoteList = [select id,Opportunity.Account.AccountType__c,Opportunity.CSL__c,Opportunity.Account.Recovery__c
                                 from Quote where Id =:recordId];
        String userId = UserInfo.getUserId();
        Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
        req1.setComments('Submitting request for approval.');
        req1.setObjectId(recordId);
        System.debug(userId);
        req1.setSubmitterId(userId); 
        req1.setProcessDefinitionNameOrId('Quote_Approval');
        req1.setSkipEntryCriteria(true);
        try{
            if(quoteList[0].Status=='Internal Review'){
                if(quoteList[0].Opportunity.Account.AccountType__c=='Key Client'){
                    req1.setNextApproverIds(new Id[] {quoteList[0].Opportunity.CSL__c});
                }
                else if(quoteList[0].Opportunity.Account.AccountType__c=='New Client' && quoteList[0].Opportunity.Account.Recovery__c>70){
                    req1.setNextApproverIds(new Id[] {quoteList[0].Opportunity.CSL__c});
                }
                else if(quoteList[0].Opportunity.Account.AccountType__c=='New Client' && quoteList[0].Opportunity.Account.Recovery__c<70){
                    req1.setNextApproverIds(new Id[] {quoteList[0].Opportunity.CSL__c});  
                }
            }
            Approval.ProcessResult result = Approval.process(req1);
        }
        catch(Exception e){
            System.debug('Error occured '+e.getMessage()+' '+e.getLineNumber());
        }
        */
        //End SFDC-[Phase-1]
    }
    public static void sendProposedAccountOwnerApproval(String recordId,String assignApproval,String comments){
        List<Account> acctList = [select id/*,Proposed_Account_Owner_Approval_Status__c*/ from Account where Id =:recordId];
        String userId = UserInfo.getUserId();
        Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
        req1.setComments(comments);
        req1.setObjectId(recordId);
        System.debug(userId);
        req1.setSubmitterId(userId); 
        req1.setProcessDefinitionNameOrId(assignApproval);
        req1.setSkipEntryCriteria(true);
        try{
            Approval.ProcessResult result = Approval.process(req1);
            if(assignApproval=='Proposed_Account_Owner_Approval_Request'){
             //   acctList[0].Proposed_Account_Owner_Approval_Status__c = 'Pending';
            }
            update acctList;
        }
        catch(Exception e){
            System.debug('Error occured '+e.getMessage()+' '+e.getLineNumber());
        }
    } 
}