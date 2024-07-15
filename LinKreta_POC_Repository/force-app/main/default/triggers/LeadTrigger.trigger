/**
* @description       : 
* @author            : ChangeMeIn@UserSettingsUnder.SFDoc
* @group             : 
* @last modified on  : 11-10-2023
* @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
trigger LeadTrigger on Lead (before insert,before update,after update,after insert, before delete) {
    TriggerService__mdt triggerService = TriggerService__mdt.getInstance(ConstantUtility.LeadTrigger);
    if(triggerService.Active__c == true){
        if(Trigger.isBefore) {
            if(Trigger.isUpdate) {
                
                //Added by Rakesh, 27-05-24
   				//Used to update LastModifiedByForWcgtField.
                LeadTriggerHandler.updateLastModifiedByForWcgtField(Trigger.new);
                
            // LeadTriggerHandler.updateCurrAndCompSteps(Trigger.New);//Gaurav Kumar
                LeadTriggerHandler.isBeforeUpdateMethod(Trigger.new,Trigger.oldMap);
                
                List<Lead> pardotNewClientList = new List<Lead>();
                
                for(Lead leadObj: Trigger.new){
                    if(leadObj.IsPardot__c!=Trigger.oldMap.get(leadObj.Id).IsPardot__c && leadObj.IsPardot__c=='Pardot'){
                        pardotNewClientList.add(leadObj);
                    }
                }
                if(pardotNewClientList.size()>0){
                    LeadTriggerHandler.createPardotLandingPageNewClientUpdate(pardotNewClientList);//Gaurav Kumar 28-Sep-2023 
                }
                
            }
            if(Trigger.isInsert){
                
                //Added by Rakesh, 27-05-24
   				//Used to update LastModifiedByForWcgtField.
                LeadTriggerHandler.updateLastModifiedByForWcgtField(Trigger.new);
                
                LeadTriggerHandler.isBeforeInsert(Trigger.new); 
            //  LeadTriggerHandler.updateCurrAndCompSteps(Trigger.New);//Gaurav Kumar
            } 
            // Added By Prashant On 28Mar as per Phase-1 changes
            if(Trigger.isDelete) {    
                LeadTriggerHandler.isBeforeDelete(Trigger.old);
            }
        }
        
        if(Trigger.isAfter) {
            if(Trigger.isUpdate) {
                LeadTriggerHandler.isAfterUpdateMethod(Trigger.new,Trigger.oldMap);
                
                // //By Bhanwar
                for(Lead lead: Trigger.New){
                    Lead oldLead = Trigger.oldMap.get(lead.ID);
                    
                    if(lead.EntityId__c != oldLead.EntityId__c && oldLead.EntityId__c != '' && lead.External_Database_Source__c == 'MCA'){
                        String obj = 'Lead';
                        createInvestors.deleteOldInvMCA(lead.Id, lead.EntityId__c, obj);
                    }
                    if(lead.MCA_ID__c != oldLead.MCA_ID__c && oldLead.MCA_ID__c != '' && lead.External_Database_Source__c == 'MCA'){
                        String obj = 'Lead';
                        createCompetitor.deleteOldCompetitorMCA(lead.Id, lead.MCA_ID__c, obj );
                        newClientDataFromMCA.newClientAlertsDataFuture(lead.MCA_ID__c,'Lead',lead.Id);// code is Added by Biplow sarkar | 10-10-2023
                        
                    }
                    //Added by Rakesh, 22-05-24
                    //Used to Share Records with the Partner's EA.
                    if(lead.OwnerId != Trigger.oldMap.get(lead.id).OwnerId){
                        List<Lead> leadLst = new List<Lead>();
                        leadLst.add(lead);
                        EAPartnerRecordAccessUtils.EAShareRecor(leadLst,'LeadShare','LeadId','LeadAccessLevel');
                    }
                }
                
                LeadTriggerHandler.updateEnquiryStatus(Trigger.new, Trigger.oldMap);
                
            }
            
            if(Trigger.isInsert) {
                // Suresh Gupta: 
                // Sending mail to prospect            
                List<Lead> pardotNewClientList = new List<Lead>();
                for(Lead leadObj: Trigger.new){
                    if(leadObj.Email != NULL){
                        LeadTriggerHandler.sendEmailToProspect(Trigger.new);
                    }
                    if(leadObj.IsPardot__c=='Pardot'){
                        pardotNewClientList.add(leadObj);
                    }
                }
                
                if(pardotNewClientList.size()>0){
                    LeadTriggerHandler.createPardotLandingPageRecord(pardotNewClientList);//Gaurav Kumar 28-Sep-2023
                }
                
                //Added by Rakesh, 22-05-24
                //Used to Share Records with the Partner's EA.
                List<Lead> leadLst = new List<Lead>();
                for(Lead ld : Trigger.new){
                	leadLst.add(ld);
                }
                EAPartnerRecordAccessUtils.EAShareRecor(leadLst,'LeadShare','LeadId','LeadAccessLevel');

            }
        }
    }
}