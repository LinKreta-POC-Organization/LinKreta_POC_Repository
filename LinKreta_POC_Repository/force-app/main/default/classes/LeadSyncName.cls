// Created By : Rajat
// Description : Called from flow when New Client Name is changed, New Name is synced with WCGT through this class.
// Created Date : 18/08/2023

public class LeadSyncName {
	@InvocableMethod
    public static void invocable(List<Id> leadId){
        if(leadId != null && leadId.size() > 0){
            //Added by Rajat to sync New Client name to WCGT
            List<Lead> leadList = [SELECT Id,Formerly_Known_As__c,Company,Last_Modified_By_for_WCGT__c FROM Lead WHERE ID IN: leadId];
            if(leadList != null && leadList.size() > 0){
                SalesforceToWCGT.changeNameToWCGT(leadList[0].Id,leadList[0].Formerly_Known_As__c,leadList[0].Company);
            }
        }
    }
}