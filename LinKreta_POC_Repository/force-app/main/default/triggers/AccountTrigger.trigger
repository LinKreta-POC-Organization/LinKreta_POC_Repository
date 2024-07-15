trigger AccountTrigger on Account (before insert,before update,after update,after insert) {
    TriggerService__mdt triggerServiceObj = TriggerService__mdt.getInstance('AccountTrigger');
    if(triggerServiceObj.Active__c == true){
        if(Trigger.isBefore){
            if(Trigger.isInsert){
                //Added by Rakesh, 27-05-24
          		//Used to update LastModifiedByForWcgtField
          		AccountTriggerHelper.updateLastModifiedByForWcgtField(Trigger.new);
                //Added By Deepak Joshi 10th Oct 2023
                AccountTriggerHelper.addClientGroupValidation(Trigger.new, null);
                //End By Deepak Joshi

            }
            if(Trigger.isUpdate){
                //Added by Rakesh, 27-05-24
          		//Used to update LastModifiedByForWcgtField
          		AccountTriggerHelper.updateLastModifiedByForWcgtField(Trigger.new);
                //Added By Deepak Joshi 15th september 2023
                AccountTriggerHelper.addClientGroupValidation(Trigger.new, Trigger.oldMap);
                //End By Deepak Joshi
                
                //Added By Bhavishya Basantwani 1st september 2023
                system.debug('inn Called check field');
                AccountTriggerHelper.makeCommentMandatory(Trigger.new, Trigger.oldMap);
                //AccountTriggerHelper.CheckRequiredFieldBeforeApproval(Trigger.new, Trigger.oldMap); 
                //End By Bhavishya Basantwani
                //List<Account> acctListIds = new List<Account>();
                List<Account> acctList = new List<Account>();
                List<Account> acctProposedList = new List<Account>();
                for(Account acc:Trigger.New){
                    /*if(acc.Pick_Record__c!= Trigger.oldMap.get(acc.id).Pick_Record__c && acc.Pick_Record__c==true){
acctListIds.add(acc);
}*/
                    if(acc.Status_DS_Team_Remark_Status__c!=Trigger.oldMap.get(acc.Id).Status_DS_Team_Remark_Status__c){
                        acctList.add(acc);
                    }
                    /*if(acc.OwnerId!=Trigger.oldMap.get(acc.Id).OwnerId && acc.Proposed_Account_Owner_Approval_Status__c=='Approved'){
acctProposedList.add(acc);
}*/
                }
                //AccountTriggerHelper.sendDSTeamApprovalRequest(acctListIds);
                if(acctList.size()>0){
                    AccountTriggerHelper.updateDSTeamApprovalFields(acctList); 
                    //AccountTriggerHelper.sendEmailToProposedOwner(acctProposedList);
                }
                /*if(acctProposedList.size()>0){
AccountTriggerHelper.sendEmailToProposedOwner(acctProposedList);
}*/

                AccountTriggerHelper.validateSegmentAndIndustry(Trigger.new);
            }
        }
        //Bhanwar 
        if(Trigger.isAfter)
        {
            if(Trigger.isInsert){
                AccountTriggerHelper.createTeamMember(Trigger.New,null);
                /* for(Account acc : Trigger.New)
{
salesforceToWCGT.sendWhenClientCreation(acc.Id);
String obj = 'Account';
if(acc.capIQId__c != ''){
//createInvestors.createInvestorsFromCAPIQ(acc.Id,acc.capIQId__c , obj);
//createCompetitor.createCompetitorFromCAPIQ(acc.Id,acc.capIQId__c , obj);
//createClientContact.createContactFromCAPIQBOD(acc.Id , acc.capIQId__c );
//createClientContact.createContactFromCAPIQProfessional(acc.Id , acc.capIQId__c);
//createClientNews.createClientNewsFromCAPIQ(acc.Id, acc.capIQId__c, obj);
}

}*/
                if(Trigger.new.size() > 40){
                    AccountTriggerHelper.syncAccountThroughBatch(Trigger.New,Trigger.oldMap,'Insert');
                }else{
                    AccountTriggerHelper.syncToWCGT(Trigger.New,Trigger.oldMap);
                }
                //Added by Rakesh, 22-05-24
                //Used to Share Records with the Partner's EA.
                List<Account> accLst = new List<Account>();
                for(Account acc : Trigger.new){
                	accLst.add(acc);
                }
                EAPartnerRecordAccessUtils.EAShareRecor(accLst,'AccountShare','AccountId','AccountAccessLevel');
            }
            //Gaurav
            if(Trigger.isUpdate){
                AccountTriggerHelper.createTeamMember(Trigger.New,Trigger.oldMap);
                 //Added by Deepak Joshi for Bill to Clint WCGT Date 1 Nov 2023
                //AccountTriggerHelper.syncBillToClientWCGT(Trigger.New,Trigger.oldMap);
                
                //Added by Rajat for bill_to_client to client
                //AccountTriggerHelper.updateClientFromBillToClient(Trigger.New,Trigger.oldMap);
                
                //Ayush Added Code 26/09/23
                List<Account> acctListUpdateClientGroupName = new List<Account>();
                Set<Id> clientIds = new Set<Id>(); // Added by Suraj 15-09-2023 
                system.debug('Trigger called:'+Trigger.New.size());
                for(Account acc:Trigger.New){
                    if(acc.CSL__c != Trigger.oldMap.get(acc.id).CSL__c || acc.CoCSL__c != Trigger.oldMap.get(acc.id).CoCSL__c){
                        //AccountTriggerHelper.updateCSLCoCSLOnEnquiries(Trigger.new,Trigger.newMap);
                    }
                    if(acc.DS_Team_Approval_Status__c == 'DS Approved' && Trigger.oldMap.get(acc.Id).DS_Team_Approval_Status__c != acc.DS_Team_Approval_Status__c){
                        //salesforceToWCGT.sendWhenClientCreation(acc.Id);
                        // Added by Rajat for WCGT Sync
                        if(acc.RecordTypeId == Schema.SObjectType.Account.getRecordTypeInfosByName().get('Client').getRecordTypeId()){
                            //SalesforceToWCGT.syncClientToWCGT(acc.Id,'Insert',acc.CreatedById);
                        }
                        
                        // Added by Suraj 15-09-2023 to Sync contacts related to clients to WCGT
                        if((acc.RecordTypeId == Schema.SObjectType.Account.getRecordTypeInfosByName().get('Client').getRecordTypeId()) ||
                           (acc.RecordTypeId == Schema.SObjectType.Account.getRecordTypeInfosByName().get('Key Account').getRecordTypeId())){
                               clientIds.add(acc.Id);
                           }
                    }
                    //Start W-002071: code is Modified by Biplow sarkar | 01-10-2023
                    if(acc.GT_Client_Group__c != Trigger.oldMap.get(acc.id).GT_Client_Group__c 
                       || acc.Client_s_Headquarter__Street__s != Trigger.oldMap.get(acc.id).Client_s_Headquarter__Street__s
                       || acc.Client_s_Headquarter__City__s != Trigger.oldMap.get(acc.id).Client_s_Headquarter__City__s
                       || acc.Client_s_Headquarter__PostalCode__s != Trigger.oldMap.get(acc.id).Client_s_Headquarter__PostalCode__s
                       || acc.Client_s_Headquarter__StateCode__s != Trigger.oldMap.get(acc.id).Client_s_Headquarter__StateCode__s
                       || acc.Client_s_Headquarter__CountryCode__s != Trigger.oldMap.get(acc.id).Client_s_Headquarter__CountryCode__s
                       || acc.Client_s_Headquarter__Latitude__s != Trigger.oldMap.get(acc.id).Client_s_Headquarter__Latitude__s
                       || acc.Client_s_Headquarter__Longitude__s != Trigger.oldMap.get(acc.id).Client_s_Headquarter__Longitude__s
                       || acc.Client_s_Headquarter__GeocodeAccuracy__s != Trigger.oldMap.get(acc.id).Client_s_Headquarter__GeocodeAccuracy__s
                       || acc.Client_Background__c != Trigger.oldMap.get(acc.id).Client_Background__c
                       || acc.SubIndustry__c != Trigger.oldMap.get(acc.id).SubIndustry__c
                       || acc.IsClientGTMemberFirm__c != Trigger.oldMap.get(acc.id).IsClientGTMemberFirm__c){
                        
                        acctListUpdateClientGroupName.add(acc);
                    }
                    //End W-002071
                    //Added by Rakesh, 22-05-24
                    //Used to Share Records with the Partner's EA.
                    if(acc.OwnerId != Trigger.oldMap.get(acc.id).OwnerId){
                        List<Account> acclst = new List<Account>();
                        acclst.add(acc);
                        EAPartnerRecordAccessUtils.EAShareRecor(acclst,'AccountShare','AccountId','AccountAccessLevel');
                    }   
                }
                if(!acctListUpdateClientGroupName.isEmpty()){
                    AccountTriggerHelper.updateClientGroupNameonEnquiry(acctListUpdateClientGroupName);
                }
                // Added by Suraj 15-09-2023 to Sync contacts related to clients to 
                if(!clientIds.isEmpty()){
                    // ContactTriggerHelper.syncRelatedContacts(clientIds);
                }
                //end
                
                if(Trigger.new.size() > 40){
                    system.debug('Batch called:');
                    AccountTriggerHelper.syncAccountThroughBatch(Trigger.New,Trigger.oldMap,'Update');
                }else{
                    system.debug('Trigger called:');
                    AccountTriggerHelper.syncToWCGT(Trigger.New,Trigger.oldMap);
                }
                //added by Deepak joshi for test class
                if(Test.isRunningTest()){
                    //AccountTriggerHelper.syncAccountThroughBatch(Trigger.New,Trigger.oldMap,'Update');
                }
            }
        }
    }
    
}