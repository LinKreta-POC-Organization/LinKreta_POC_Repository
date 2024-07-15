public class AccountSyncToWCGTBatch implements Database.Batchable<sObject>, Database.Stateful, Database.AllowsCallouts{
	Set<Id> accountIds;
    String context;
    List<Api_Logger__c> apiLogList;
    
    public AccountSyncToWCGTBatch(Set<Id> accIds,String contxtValue){
        this.accountIds = accIds;
        this.context    = contxtValue;
        this.apiLogList = new List<Api_Logger__c>();
    }
    public Database.QueryLocator start(Database.BatchableContext BC){
        system.debug('accountIds:'+this.accountIds);
        Set<Id> accountIdSet = this.accountIds;
        system.debug('accountIdSet:'+accountIdSet);
		String query = 'SELECT ID,RecordTypeId,Name,LastModifiedBy.EMP_ID__c,Last_Modified_By_for_WCGT__c FROM Account WHERE ID IN :accountIdSet';
        system.debug('query:'+Database.query(query).size());
        return Database.getQueryLocator(query);
    }
    public void execute(Database.BatchableContext BC,list<Account> listAccount){
        if(listAccount.size() > 0){
            Id KeyAccountRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Key Account').getRecordTypeId();
            Id GTCliGrpRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('GT Client Group').getRecordTypeId();
            Id ClientRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Client').getRecordTypeId();
            for(Account acc : listAccount){
                Api_Logger__c apiLog = new Api_Logger__c();
                List<Api_Logger__c> apiLoggerList = new List<Api_Logger__c>();
                if(acc.RecordTypeId == KeyAccountRecTypeId){
                    apiLog = SalesforceToWCGTHelper.syncKeyAccount(acc.Id,this.context);
                }else if(acc.RecordTypeId == GTCliGrpRecTypeId){
                    apiLog = SalesforceToWCGTHelper.syncGTClient(acc.Id);
                }else if(acc.RecordTypeId == ClientRecTypeId){
                    apiLoggerList = SalesforceToWCGTHelper.syncClientAccount(acc.Id,this.context,acc.LastModifiedBy.EMP_ID__c);
                }
                if(apiLog != null){
                    this.apiLogList.add(apiLog);
                }
                System.debug('apiLoggerList' + apiLoggerList);
                if(apiLoggerList != null){
                    this.apiLogList.addAll(apiLoggerList);
                }
            }
        }
    }
    public void finish(Database.BatchableContext BC){  
        system.debug('apiLogList:'+apiLogList);
        if(apiLogList.size() > 0){
            INSERT apiLogList;
        }
    }
}