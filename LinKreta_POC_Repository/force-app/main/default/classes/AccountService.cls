public class AccountService {
    public static List<Account> getGTClientGroup(Set<Id> gtClientIds){
        try{
            List<Account> gtClients = new List<Account>();
            if(gtClientIds.size() > 0){
                gtClients = [SELECT ID,Key_Account_360__c,Key_Account_360__r.Client_Category__c,Key_Account_360__r.CSL__c,
                           Key_Account_360__r.CoCSL__c,Key_Account_360__r.YoungCSL__c FROM Account WHERE ID IN : gtClientIds];
            }
            return gtClients;
        }catch(Exception e){
            system.debug('exception:'+e.getLineNumber()+' '+e.getMessage());
            return null;
        }
    }
    public static List<Account> getKeyAccount(Set<Id> keyAccountIds){
        try{
            List<Account> keyClient = new List<Account>();
            if(keyAccountIds != null && keyAccountIds.size() > 0){
               keyClient = [SELECT ID,Name FROM Account WHERE ID IN : keyAccountIds];
            }
            return keyClient;
        }catch(Exception e){
            system.debug('exception:'+e.getLineNumber()+' '+e.getMessage());
            return null;
        }
    }
    public static List<Account> getClientAccount(Set<Id> clientAccountIds){
        try{
            List<Account> clientAccounts = new List<Account>();
            if(clientAccountIds != null && clientAccountIds.size() > 0){
               //List<String> teamRole = new List<String>{'Key Account – CSL','Key Account – Co-CSL','Young CSL'};
               clientAccounts = [SELECT ID,Name,GT_Client_Group__c,GT_Client_Group__r.Name,GT_Client_Group__r.Key_Account_360__c,RecordTypeId,
                                 GT_Client_Group__r.Key_Account_360__r.Client_Category__c,GT_Client_Group__r.Key_Account_360__r.RelationshipOffice__c,
                                 Entity_Type__c,Pan_No__c,website,AccountType__c,LegalEntityType__c,Total_Revenue__c,Employees__c,Total_Employees__c,
                                 Country_Corridor__c,Corridor__c, Industry__c,SubIndustry__c,RelationshipOffice__c,Status__c,Total_No_of_employees__c,
                                 Owner.User_ID__c,OwnerID,
                                 LastModifiedBy.User_ID__c,ShareCapitalInCr__c,Entity_Type_Master__c,Entity_Type_Master__r.WCGT_Id__c,LastModifiedById,
                                 Relationship_Office__c,Relationship_Office__r.WCGT_Id__c,Client_s_Headquarter__c,Client_s_Headquarter__Street__s,toLabel(Client_s_Headquarter__StateCode__s),
                                 Client_s_Headquarter__City__s,Client_s_Headquarter__PostalCode__s,toLabel(Client_s_Headquarter__CountryCode__s),AnnualRevenue__c,CreatedBy.User_ID__c,
                                 ClientAddress__c,ClientAddress__Street__s,toLabel(ClientAddress__StateCode__s),ClientAddress__City__s,ClientAddress__PostalCode__s,toLabel(ClientAddress__CountryCode__s),
                                 Last_Modified_By_for_WCGT__c, Last_Modified_By_for_WCGT__r.USER_ID__c,
                                 (SELECT Id,TeamMemberRole,UserId,User.EMP_ID__c FROM AccountTeamMembers)
                                 FROM Account WHERE ID IN : clientAccountIds];
            }
            return clientAccounts;
        }catch(Exception e){
            system.debug('exception:'+e.getLineNumber()+' '+e.getMessage());
            return null;
        }
    }
}