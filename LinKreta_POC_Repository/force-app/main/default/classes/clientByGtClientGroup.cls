/*
* @Name: ClientByGtClientGroup
* @Author: Bhavishya Basantwani
* @Description: This class is used for LWC(ClientByGtClientGroup) to retrieve the data of Gt Client Group And Client By Key Account .
* @Date: 13-July-23
*/
public class clientByGtClientGroup {
    
    @AuraEnabled(cacheable=true)
    public static map<string,list<Account>> getRecord(id recordId){
        
        //Like '%GT%'
        Map<string,list<Account>> listOfMap = new Map<string,list<Account>>();
        system.debug('recordId'+recordId);
        list<Account> listOfAccount =   [select id,name, (select id,name,new_client__r.Name,Net_Promoter_Score__c,Promoter__c,Detractor__c,Industry__c,SubIndustry__c,Owner.Name,
                                                          Customer_Satisfaction_Index__c,Customer_Experience_Index__c from Clients1__r where RecordType.DeveloperName !='Bill_To_Client') from Account 
                                         where recordtype.name =:'GT Client Group' and key_Account_360__c =: recordId];
        system.debug('listOfAccount'+listOfAccount);
        
        for(Account Acc : listOfAccount){
            listOfMap.put(Acc.Name,Acc.Clients1__r);   
        }
        
        
        system.debug('listOfMap'+listOfMap);
        return listOfMap;
    }
    
    @AuraEnabled(cacheable=true)
    public static list<Account> getRecordFilter(id recordId , string SelectedValue){
        
        system.debug('indisee>>>$$');
        system.debug('SelectedValue'+SelectedValue);
        system.debug('recordId'+recordId);
        list<Account> listOfAccount =   [select id,Name,Industry__c,Owner.Name,GT_Client_Group__r.Name,new_client__r.Name from Account where GT_Client_Group__c =:SelectedValue AND RecordType.DeveloperName !='Bill_To_Client'];
        system.debug('listOfAccount'+listOfAccount);
        
        return listOfAccount;
    }
    
    
    
}