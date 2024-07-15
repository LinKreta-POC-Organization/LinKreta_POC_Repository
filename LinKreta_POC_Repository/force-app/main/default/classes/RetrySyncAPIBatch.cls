public class RetrySyncAPIBatch implements Database.Batchable<sObject>,Schedulable,Database.Stateful, Database.AllowsCallouts{
	public Database.QueryLocator start(Database.BatchableContext BC){
      String query = 'SELECT ID, Response__c, Request__c, Total_Retries__c, End_Point__c, Status__c, Record_Id__c,';
            query += 'Class_Name__c, Status_Code__c FROM API_LOGGER__c ';
            query += 'WHERE isSuccess__c = false AND (Total_Retries__c = null  OR Total_Retries__c < 3) AND Parent__c = null ORDER BY LastModifiedDate desc';
        system.debug('query:'+query);
        return Database.getQueryLocator(query);
    }
    public void execute(schedulableContext sc){
        Database.executeBatch(new RetrySyncAPIBatch(),50);
    }
    public void execute(Database.BatchableContext BC, List<API_Logger__c> listAPIs){
        //try{
            Map<Id,API_Logger__c> mapParentIdToAPILogger = new Map<Id,API_Logger__c>(); // Map with Parent ID and New API Logger
            Map<Id,API_Logger__c> mapIDToAPILogger = new Map<Id,API_Logger__c>(); // Map with Parent Id and Parent API Logger
            List<API_Logger__c> listAPILogs = new List<API_Logger__c>(); // list to send EMAIL on 3rd retry failed
            if(listAPIs.size() > 0){
                system.debug('listAPIs 15:'+listAPIs.size());
                for(API_Logger__c api : listAPIs){
                    if(api.End_Point__c != null){
                        Http http = new Http();
                        HttpRequest req = new HttpRequest();
                        req.setEndpoint(api.End_Point__c);
                        req.setMethod('POST'); 
                        req.setHeader('Content-Type','application/json');
                        req.setBody(api.Request__c);
                        HttpResponse resp = http.send(req);
                        System.debug('resp -->'+resp.getBody());
                        if(resp.getBody() != null){
                            API_Logger__c apiLog = API_LoggerCommonUtility.createAPILogger(api.Record_Id__c,api.Request__c,resp.getBody(),resp.getStatus(),api.Class_Name__c,api.End_Point__c,resp.getStatusCode(),'',api.Id);
                        	mapParentIdToAPILogger.put(api.Id,apiLog);
                            mapIDToAPILogger.put(api.Id,api);
                        }
                    }
                }
                system.debug('mapParentIdToAPILogger 29:'+mapParentIdToAPILogger);
                system.debug('mapParentIdToAPILogger 30:'+mapIDToAPILogger);
                if(mapParentIdToAPILogger.keySet().size() > 0){
                    INSERT mapParentIdToAPILogger.values();
                    for(API_Logger__c apiLog : mapParentIdToAPILogger.values()){
                        if(apiLog.Status__c == ConstantUtility.SUCCESS){
                            mapIDToAPILogger.get(apiLog.Parent__c).status__c = apiLog.Status__c;
                            mapIDToAPILogger.get(apiLog.Parent__c).Response__c = apiLog.Response__c;
                            mapIDToAPILogger.get(apiLog.Parent__c).Status_Code__c = apiLog.Status_Code__c;
                        }else{
                            mapIDToAPILogger.get(apiLog.Parent__c).status__c = apiLog.Status__c;
                            mapIDToAPILogger.get(apiLog.Parent__c).Response__c = apiLog.Response__c;
                            mapIDToAPILogger.get(apiLog.Parent__c).Status_Code__c = apiLog.Status_Code__c;
                            if(mapIDToAPILogger.get(apiLog.Parent__c).Total_Retries__c != null){
                                mapIDToAPILogger.get(apiLog.Parent__c).Total_Retries__c += 1;
                            }else{
                                 mapIDToAPILogger.get(apiLog.Parent__c).Total_Retries__c = 1;
                            } 
                            if(mapIDToAPILogger.get(apiLog.Parent__c).Total_Retries__c == 3){
                                listAPILogs.add(mapIDToAPILogger.get(apiLog.Parent__c));
                            }
                        }
                    }
                    UPDATE mapIDToAPILogger.values();
                    if(listAPILogs.size() > 0){
                        // SEND EMAIL TO ADMIN FOR 3RD RETRY FAILED
                        API_LoggerCommonUtility.sendSyncFailedEmail(listAPILogs);
                    }
                }
            }            
        /*}catch(Exception e){
            System.debug('Exception :'+e.getLineNumber()+' '+e.getMessage());
        }*/
    }

   public void finish(Database.BatchableContext BC){
   }
}