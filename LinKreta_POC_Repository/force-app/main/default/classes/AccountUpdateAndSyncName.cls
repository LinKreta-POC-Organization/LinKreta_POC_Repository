public  class AccountUpdateAndSyncName {  
    @InvocableMethod
    public static void invocable(List<Id> accountId){
        if(accountId != null && accountId.size() > 0){
            //sendWhenClientCreation(accountId[0]);
            //
            //Added by Rajat to sync Client name to WCGT
            List<Account> accList = [SELECT Id,Formerly_Known_As__c,Name,Last_Modified_By_for_WCGT__c FROM Account WHERE ID IN: accountId AND Status__c = 'Active'];
            if(accList != null && accList.size() > 0){
               SalesforceToWCGT.changeNameToWCGT(accList[0].Id,accList[0].Formerly_Known_As__c,accList[0].Name);
            }
        }
    }
}