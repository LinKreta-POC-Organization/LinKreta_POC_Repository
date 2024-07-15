/*
 * Author : Suraj Kumar
 * Date : 20-01-2023
 * Description : Controller class for Key development and Alerts LWC
 * Last Updated By :- Bhanwar 
 * Last Update Discription :- Added for Enquiry so we can get all the news related to that client
*/
public Without Sharing class KeyDevAndAlertsController {
    
    @AuraEnabled
    public static DataWrapper getNewClient(String recordId, String objectName){
        DataWrapper dataWrapperObj = new DataWrapper();
        if(objectName == 'Lead'){
            Lead lead = [SELECT Id, Name, capIQId__c, (SELECT Id, Name, IQ_KEY_DEV_HEADLINE__c,Key_Development_Date__c,ExternalDataSource__c FROM Client_Newss__r ORDER BY Key_Development_Date__c DESC) FROM Lead WHERE Id =: recordId ];
            
            if(!lead.Client_Newss__r.isEmpty() && lead.capIQId__c != Null){
                //return lead.Client_Newss__r;
                 dataWrapperObj.clientNews = lead.Client_Newss__r;
                 return dataWrapperObj;
            }
            else{
                return null;
            }
        }
        else if(objectName == 'Account'){
            dataWrapperObj = getAccount(recordId);
            System.debug('** acc getAccount dataWrapperObj '+dataWrapperObj);
            if(dataWrapperObj !=null){
               return dataWrapperObj;
            }

            /*Account acc = [SELECT Id, Name, capIQId__c, (SELECT Id, Name, IQ_KEY_DEV_HEADLINE__c,Key_Development_Date__c,ExternalDataSource__c FROM Client_Newss__r ORDER BY Key_Development_Date__c DESC) FROM Account WHERE Id =: recordId ];
            
            if(!acc.Client_Newss__r.isEmpty() && acc.capIQId__c != Null){
                //return acc.Client_Newss__r;
                 dataWrapperObj.clientNews =acc.Client_Newss__r;
                 return dataWrapperObj;
            }
            else{
                return null;
            }*/
            return null;
        }
        /*else if(objectName == 'Opportunity'){
            Opportunity opp = [SELECT Id, Name, capIQId__c, (SELECT Id, Name, IQ_KEY_DEV_HEADLINE__c FROM Client_Newss__r) FROM Opportunity WHERE Id =: recordId];
            System.debug('Opportunity : ' + opp.Client_Newss__r);
            
            if(!opp.Client_Newss__r.isEmpty() && opp.capIQId__c != Null){
                return opp.Client_Newss__r;
            }
            else{
                return null;
            }
        }*/
        // By Bhanwar 24/04/23
        //Start SFDC-[Phase-1]: code is added by Biplow sarkar | 03-04-2024
        /*
        else if(objectName == 'Opportunity'){
            Opportunity opp = [SELECT Id, AccountId FROM Opportunity WHERE Id =: recordId ];
            Account acc = [SELECT Id, Name, capIQId__c, (SELECT Id, Name, IQ_KEY_DEV_HEADLINE__c,ExternalDataSource__c,Key_Development_Date__c FROM Client_Newss__r ORDER BY Key_Development_Date__c DESC) FROM Account WHERE Id =: opp.AccountId ];
            
            if(!acc.Client_Newss__r.isEmpty() && acc.capIQId__c != Null){
                //return acc.Client_Newss__r;
                 dataWrapperObj.clientNews =acc.Client_Newss__r;
                 return dataWrapperObj;
            }
            else{
                return null;
            }
        } */
        //End SFDC-[Phase-1]: code is added by Biplow sarkar | 03-04-2024
        else{
            return null;
        }
        
    }


    @AuraEnabled
    public static DataWrapper getNewClientMCA(String recordId, String objectName){
        DataWrapper dataWrapperObj = new DataWrapper();
        if(objectName == 'Lead'){
            Lead lead = [SELECT Id, Name, MCA_ID__c  , (SELECT Id, Name, remarks_details__c,severity__c,ExternalDataSource__c FROM Client_Newss__r WHERE severity__c !='' ) FROM Lead WHERE Id =: recordId ];
            
            if(!lead.Client_Newss__r.isEmpty() && lead.MCA_ID__c != Null){
                //return lead.Client_Newss__r;
                 dataWrapperObj.clientNews = lead.Client_Newss__r;
                 return dataWrapperObj;
            }
            else{
                return null;
            }
        }
        /*else if(objectName == 'Account'){
            Account acc = [SELECT Id, Name, (SELECT Id, Name, remarks_details__c,severity__c,ExternalDataSource__c FROM Client_Newss__r WHERE severity__c !='' ) FROM Account WHERE Id =: recordId ];
            
            if(!acc.Client_Newss__r.isEmpty()){
                //return acc.Client_Newss__r;
                 dataWrapperObj.clientNews = acc.Client_Newss__r;
                 return dataWrapperObj;
            }
            else{
                return null;
            }
        }*/
        /*else if(objectName == 'Opportunity'){
            Opportunity opp = [SELECT Id, Name, capIQId__c, (SELECT Id, Name, IQ_KEY_DEV_HEADLINE__c FROM Client_Newss__r) FROM Opportunity WHERE Id =: recordId];
            System.debug('Opportunity : ' + opp.Client_Newss__r);
            
            if(!opp.Client_Newss__r.isEmpty() && opp.capIQId__c != Null){
                return opp.Client_Newss__r;
            }
            else{
                return null;
            }
        }*/
        // By Bhanwar 24/04/23
        //Start SFDC-[Phase-1]: code is added by Biplow sarkar | 03-04-2024
       /*  else if(objectName == 'Opportunity'){
            Opportunity opp = [SELECT Id, AccountId FROM Opportunity WHERE Id =: recordId  Limit 1];
            Account acc = [SELECT Id, Name,  (SELECT Id, Name, remarks_details__c,ExternalDataSource__c,severity__c FROM Client_Newss__r WHERE severity__c !='' ) FROM Account WHERE Id =: opp.AccountId  Limit 1];
            
            if(!acc.Client_Newss__r.isEmpty()){
                //return acc.Client_Newss__r;
                 dataWrapperObj.clientNews = acc.Client_Newss__r;
                 return dataWrapperObj;
                
            }
            else{
                return null;
            }
        } */
        //End SFDC-[Phase-1]: code is added by Biplow sarkar | 03-04-2024
        else{
            return null;
        }
        
    }
    
    @AuraEnabled
    public static DataWrapper getNewClientMCACourtCase(String recordId, String objectName){
        DataWrapper dataWrapperObj = new DataWrapper();
        if(objectName == 'Lead'){
            Lead lead = [SELECT Id, Name, MCA_ID__c  , (SELECT Id, Name, Case_Number__c,convictedDirectors__c,ExternalDataSource__c FROM Client_Newss__r WHERE Case_Number__c !=''  ) FROM Lead WHERE Id =: recordId ];
            
            if(!lead.Client_Newss__r.isEmpty() && lead.MCA_ID__c != Null){
               // return lead.Client_Newss__r;
               dataWrapperObj.clientNews =lead.Client_Newss__r;
               return dataWrapperObj;
            }
            else{
                return null;
            }
        }
        /*else if(objectName == 'Account'){
            Account acc = [SELECT Id, Name, (SELECT Id, Name, Case_Number__c,convictedDirectors__c,ExternalDataSource__c FROM Client_Newss__r WHERE Case_Number__c !=''  ) FROM Account WHERE Id =: recordId ];
            
            if(!acc.Client_Newss__r.isEmpty()){
                //return acc.Client_Newss__r;
                 dataWrapperObj.clientNews =acc.Client_Newss__r;
                 return dataWrapperObj;
            }
            else{
                return null;
            }
        }*/
        /*else if(objectName == 'Opportunity'){
            Opportunity opp = [SELECT Id, Name, capIQId__c, (SELECT Id, Name, IQ_KEY_DEV_HEADLINE__c FROM Client_Newss__r) FROM Opportunity WHERE Id =: recordId];
            System.debug('Opportunity : ' + opp.Client_Newss__r);
            
            if(!opp.Client_Newss__r.isEmpty() && opp.capIQId__c != Null){
                return opp.Client_Newss__r;
            }
            else{
                return null;
            }
        }*/
        // By Bhanwar 24/04/23
        //Start SFDC-[Phase-1]: code is added by Biplow sarkar | 03-04-2024
        /*
        else if(objectName == 'Opportunity'){
            Opportunity opp = [SELECT Id, AccountId FROM Opportunity WHERE Id =: recordId  Limit 1];
            Account acc = [SELECT Id, Name,  (SELECT Id, Name, Case_Number__c,convictedDirectors__c,ExternalDataSource__c,severity__c FROM Client_Newss__r) FROM Account WHERE Id =: opp.AccountId  Limit 1];
            
            if(!acc.Client_Newss__r.isEmpty()){
                //return acc.Client_Newss__r;
                 dataWrapperObj.clientNews = acc.Client_Newss__r;
                 return dataWrapperObj;
            }
            else{
                return null;
            }
        } */
        //End SFDC-[Phase-1]: code is added by Biplow sarkar | 03-04-2024
        else{
            return null;
        }
        
    }
     /**
     * 
    * @description  this mathod use for account to client news
    * @author Deepak Joshi | 21 Aug 2023
    * @param recordId 
    **/
    public static DataWrapper getAccount(String recordId){
        DataWrapper dataWrapperObj = new DataWrapper();
        String clientRecordTypeId =   Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get(ConstantUtility.RECORD_TYPE_CLIENT).getRecordTypeId();
        String keyAccountRecordTypeId =   Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get(ConstantUtility.KEY_ACCOUNT).getRecordTypeId();
        Account accRecordTypeId =[SELECT Id,RecordTypeId FROM Account WHERE Id =: recordId ];
        if(accRecordTypeId.RecordTypeId == clientRecordTypeId){
            Account acc = [SELECT Id, Name, capIQId__c,MCA_ID__c, (SELECT Id, Name, IQ_KEY_DEV_HEADLINE__c,Key_Development_Date__c,ExternalDataSource__c,Case_Number__c,Alert__c,remarks_details__c,severity__c,convictedDirectors__c FROM Client_Newss__r ORDER BY Key_Development_Date__c ASC) FROM Account WHERE Id =: recordId ];
            
            if(!acc.Client_Newss__r.isEmpty() && acc.capIQId__c != Null){
                //return acc.Client_Newss__r;
                 dataWrapperObj.clientNews =acc.Client_Newss__r;
                 dataWrapperObj.externalDatabaseSource = 'CAPIQ';
                 return dataWrapperObj;
            }
            else if(!acc.Client_Newss__r.isEmpty() && acc.MCA_ID__c != Null){
                //return acc.Client_Newss__r;
                 dataWrapperObj.clientNews =acc.Client_Newss__r;
                 dataWrapperObj.externalDatabaseSource = 'MCA';
                 return dataWrapperObj;
            }
            else{
                return null;
            }
        }
        else if(accRecordTypeId.RecordTypeId == keyAccountRecordTypeId){
            Set<String> GT_ClientGroupIds = new Set<String>();
            for(Account acc : [SELECT Id FROM Account WHERE Key_Account_360__c =: recordId ]){
                GT_ClientGroupIds.add(acc.Id);
            }
            Map<String ,Account> idWithAccountMap = new Map<String ,Account>();
            if(GT_ClientGroupIds !=null && GT_ClientGroupIds.size()>0){
                for(Account acc: [SELECT Id, Name, capIQId__c,MCA_ID__c,External_Database_Source__c,RecordTypeId FROM Account WHERE GT_Client_Group__c =: GT_ClientGroupIds ]){
                    idWithAccountMap.put(acc.Id,acc);
                }

            }
            if(idWithAccountMap != null && idWithAccountMap.size()>0){
                Set<String> clientAccountIds = new Set<String>();
                List<Client_News__c> clientNewsList = [SELECT Id,Client__c, Name, IQ_KEY_DEV_HEADLINE__c,IQ_KEY_DEV_TYPE__c,Key_Development_Date__c,remarks_details__c,convictedDirectors__c,severity__c,Alert__c,Case_Number__c
                    FROM Client_News__c WHERE Client__c =:idWithAccountMap.keyset()  ORDER BY Key_Development_Date__c ASC];

                for(Client_News__c clientNewsObj : clientNewsList){
                    clientAccountIds.add(clientNewsObj.Client__c);
                }
                if(clientAccountIds != null && clientAccountIds.size()> 0){
                    List<AccountInformation> accountInformationList = new  List<AccountInformation>();
                   
                    for(String key :clientAccountIds){
                        if(idWithAccountMap.containsKey(key)){
                            AccountInformation accountInformationObj = new AccountInformation();
                            accountInformationObj.name =idWithAccountMap.get(key).Name;
                            accountInformationObj.recordId =idWithAccountMap.get(key).Id;
                            accountInformationList.add(accountInformationObj);
                        }
                    }
                    dataWrapperObj.isKeyAccount = true;
                    dataWrapperObj.keyAccountInformation =accountInformationList;
                    dataWrapperObj.clientNews = clientNewsList;
                    return dataWrapperObj;
                }

            }
            
            return null;
        }
        else{
            return null;
        }

    }
    //Added Deepak Joshi
    public class DataWrapper{
        @AuraEnabled
        public List<Client_News__c> clientNews;
        @AuraEnabled
        public String externalDatabaseSource;
        @AuraEnabled
        public List<AccountInformation> keyAccountInformation;
        @AuraEnabled
        public Boolean isKeyAccount; 
    }
    public class AccountInformation{
        @AuraEnabled
        public String name;
        @AuraEnabled
        public String recordId;
    }
}