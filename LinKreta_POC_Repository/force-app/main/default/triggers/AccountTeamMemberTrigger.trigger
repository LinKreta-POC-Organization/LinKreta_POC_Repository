/* 
Written By: Prashant Bansal
Created Date: 24-Aug-2023
Last Modified By : Prashant Bansal
Last Modified Date : 24-Aug-23
*/
trigger AccountTeamMemberTrigger on AccountTeamMember (before insert, before update, after insert, After update, before delete,after delete) {
    TriggerService__mdt triggerServiceObj = TriggerService__mdt.getInstance('AccountTeamMemberTrigger');
    if(triggerServiceObj.Active__c == true){
        if(Trigger.isAfter){
            if(Trigger.isInsert){
                //AccountTeamMemberTriggerHelper.shareIntegratedEnquiryRecord(trigger.new); //Phase-1
                AccountTeamMemberTriggerHelper.IsAfterInsert(trigger.new);
                   List<AccountTeamMember> accTeamList = new List<AccountTeamMember>();
                Set<Id> accountIds = new Set<Id>();
                for(AccountTeamMember accTeamObj : Trigger.new){
                    if(accTeamObj.AccountId!=null && accTeamObj.TeamMemberRole == 'Key Account – CSL' || accTeamObj.TeamMemberRole == 'Key Account – Co-CSL' || accTeamObj.TeamMemberRole == 'Young CSL'){
                       accTeamList.add(accTeamObj);
                        accountIds.add(accTeamObj.AccountId);
                    }
                }
                //Start SFDC-[Phas-1]: code is added by Biplow sarkar | 10-04-2024
                /*
                if(!accTeamList.isEmpty()){
                AccountTeamMemberTriggerHelper.insertCSLandCOCSLonEnquiry(accTeamList,accountIds);// Added by Ayush on 22-Sep-2023 for work Id: W-002151
   
                } */
                //End SFDC-[Phas-1]
                //Added by Deepak Joshi Date 28-Sep-2023
                AccountTeamMemberTriggerHelper.addCSLonAccountTeamInsert(Trigger.New);
                //end By Deepak Joshi 
                
                // Commented on 04June2024
                //AccountTeamMemberTriggerHelper.shareAccWithEA(Trigger.new);// Added By Bhavishya Basantwani on 04-Dec-2023
            }
            if(Trigger.isUpdate){
                AccountTeamMemberTriggerHelper.IsAfterUpdate(Trigger.New,Trigger.oldMap);
                //Added by Deepak Joshi Date 28-Sep-2023
                AccountTeamMemberTriggerHelper.addCSLonAccountTeamUpdate(Trigger.New,Trigger.oldMap);
                //end By Deepak Joshi
            }
            
            if(Trigger.isDelete){
                 List<AccountTeamMember> accTeamList = new List<AccountTeamMember>();
                Set<Id> accountIds = new Set<Id>();
                for(AccountTeamMember accTeamObj : Trigger.old){
                    if(accTeamObj.AccountId!=null && accTeamObj.TeamMemberRole == 'Key Account – CSL' || accTeamObj.TeamMemberRole == 'Key Account – Co-CSL' || accTeamObj.TeamMemberRole == 'Young CSL' || accTeamObj.TeamMemberRole == 'Young CSL'){
                       accTeamList.add(accTeamObj);
                        accountIds.add(accTeamObj.AccountId);
                    }
                }
                 //Start SFDC-[Phase-1]: code is added by Biplow sarkar | 10-04-2024
                /*
                if(!accTeamList.isEmpty()){
                    AccountTeamMemberTriggerHelper.deleteOpportunityTeamMember(accTeamList,accountIds);// Added by Ayush on 22-Sep-2023 for work Id: W-002151 
                }
                */
                //End SFDC-[Phase-1]
                //Added by Deepak Joshi Date 28-Sep-2023
                AccountTeamMemberTriggerHelper.addCSLonAccountTeamDelete(Trigger.Old);
                //end By Deepak Joshi
                
                // Commented on 04June2024
                //AccountTeamMemberTriggerHelper.unshareAccWithEA(Trigger.Old);// Added By Bhavishya Basantwani on 04-Dec-2023
            }
        }
        
        
        
        //Start SFDC-[Phase-1]: code is added by Biplow sarkar | 10-04-2024
        /*
        if(Trigger.isBefore){
            if(Trigger.isDelete){
                AccountTeamMemberTriggerHelper.unshareIntegratedEnquiryRecord(trigger.old);
            }
        }
        */
        //End SFDC-[Phase-1]
        //Added by Deepak Joshi Date 1-Sep-2023
        if(Trigger.isBefore){
            if(Trigger.isInsert){
                AccountTeamMemberTriggerHelper.validateTeamMembers(Trigger.new,Trigger.oldMap);
                // added By Bhavishya Basantwani Date 14 sep 2023
                AccountTeamMemberTriggerHelper.ValidateCslCoCsl(Trigger.new);
            }
            if(Trigger.isUpdate){
               
                 AccountTeamMemberTriggerHelper.validateTeamMembers(Trigger.new,Trigger.oldMap);
                // added By Bhavishya Basantwani Date 14 sep 2023
                AccountTeamMemberTriggerHelper.ValidateCslCoCsl(Trigger.new);
                
            }
        }
        //End Deepak Joshi
        
        //Added by Bhavishya Basantwani Date 22 sep 2023
        If(Trigger.isDelete){
            AccountTeamMemberTriggerHelper.ValidateCslCoCslNOwnerFromDelete(Trigger.Old);
        }
        // End by Bhavishya
    }
}