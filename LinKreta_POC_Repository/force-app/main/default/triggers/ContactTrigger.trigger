trigger ContactTrigger on Contact (before insert,before update, after insert, after update) {
    TriggerService__mdt triggerService = TriggerService__mdt.getInstance(ConstantUtility.ContactTrigger);
    if(triggerService.Active__c == true){
        if(Trigger.isBefore){
            if(Trigger.isInsert){
                //Added by Rakesh, 27-05-24
   				//Used to update LastModifiedByForWcgtField.
                ContactTriggerHelper.updateLastModifiedByForWcgtField(Trigger.New);
            }
            if(Trigger.isUpdate){
                //Added by Rakesh, 27-05-24
   				//Used to update LastModifiedByForWcgtField.
                ContactTriggerHelper.updateLastModifiedByForWcgtField(Trigger.New);
                
                List<Contact> contactListIds = new List<Contact>();
                List<Contact> contactList = new List<Contact>();
                List<Contact> contactsToBeDSApproved = new List<Contact>();
                List<Contact> pardotContactList = new List<Contact>();
                for(Contact cc:Trigger.New){
                    if(cc.Pick_Record__c!= Trigger.oldMap.get(cc.id).Pick_Record__c && cc.Pick_Record__c==true){
                        contactListIds.add(cc);
                    }
                    // Added by Suraj on 11-08-2023
                    if(cc.DS_Team_Approval_Status__c <> Trigger.oldMap.get(cc.id).DS_Team_Approval_Status__c){
                        contactList.add(cc);
                    }
                    if(cc.DS_Team_Approval_Status__c <> Trigger.oldMap.get(cc.id).DS_Team_Approval_Status__c && cc.DS_Team_Approval_Status__c == 'DS Approved'){
                        contactsToBeDSApproved.add(cc);
                    }
                    
                    if(cc.IsPardot__c!=Trigger.oldMap.get(cc.Id).IsPardot__c && cc.IsPardot__c=='Pardot' && cc.Contact_status__c =='Active' ){
                        pardotContactList.add(cc);
                        cc.IsPardot__c = '';
                        
                    }
                    
                }
                                
                if(pardotContactList.size()>0){
                    ContactTriggerHelper.createPardotLandingPageRecord(pardotContactList);// Gaurav Kumar 28-Sep-2023 
                }
                if(contactList.size()>0){
                    //ContactTriggerHelper.updateDSTeamApprovalFields(contactList); 
                    ContactTriggerHelper.validateApprovalComments(contactList);
                }
                
                if(contactsToBeDSApproved.size()>0){
                    ContactTriggerHelper.validationDSApproval(contactsToBeDSApproved); 
                }
            }
        }
        
        if(Trigger.isAfter){
            
            //Added by Abdul Vahid || 31 July 2023
            if(Trigger.isInsert){ 
                ContactTriggerHelper.onAfterInsert(trigger.new);
                
                // Suraj Kumar 05-09-2023
                
                List<Contact> contactList = new List<Contact>();
                for(Contact con : Trigger.new){
                    if(con.AccountId != null){
                        contactList.add(con);
                    }
                }
                
                if(!contactList.isEmpty()){
                    ContactTriggerHelper.syncClientContactOnInsert(contactList);
                }
                //Added by Rakesh, 22-05-24
                //Used to Share Records with the Partner's EA.
                List<Contact> conLst = new List<Contact>();
                for(Contact con : Trigger.new){
                	conLst.add(con);
                }
                EAPartnerRecordAccessUtils.EAShareRecor(conLst,'ContactShare','ContactId','ContactAccessLevel');
            }
            //Added by Abdul Vahid || 31 July 2023
            
            if(Trigger.isUpdate){ 
                ContactTriggerHelper.onAfterUpdate(trigger.new, trigger.oldMap);
                //Bhanwar
                /*for(Contact con : Trigger.New){
                    if(con.DS_Team_Approval_Status__c =='DS Approved' && Trigger.oldMap.get(con.Id).DS_Team_Approval_Status__c != con.DS_Team_Approval_Status__c)  {
                        salesforceToWCGT.sendWhenNewClienttoContact(con.Id);
                    }              
                }*/
                
                // Suraj Kumar 05-09-2023
                
                List<Contact> contactList = new List<Contact>();
                List<String> conIds = new List<String>();
                for(Contact con : Trigger.new){
                    if(con.AccountId != null){
                        contactList.add(con);
                    }
                    //Added by Rakesh, 22-05-24
                    //Used to Share Records with the Partner's EA.
                    if(con.OwnerId != Trigger.oldMap.get(con.id).OwnerId){
                        List<Contact> conLst = new List<Contact>();
                        conLst.add(con);
                        EAPartnerRecordAccessUtils.EAShareRecor(conLst,'ContactShare','ContactId','ContactAccessLevel');
                    }
                }
                if(!contactList.isEmpty()){
                    ContactTriggerHelper.syncClientContactOnUpdate(contactList);
                }
            }
        }
    }
}