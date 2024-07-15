/*
* @Name: SObjectDataTableController
* @Author: Bhavishya Basantwani
* @Description: This class is used for LWC(SObjectDataTableController) to retrieve the data of Conatct,Job,Enquiries of Client By Key Account .
* @Date: 13-July-23
*/

public with sharing class SObjectDataTableController {
    
    @AuraEnabled(cacheable=true)
    public static ResponseBody getAllRecords(String objectApiName,string relatedObject, String fieldApiNames,id recordId, string clause ,string dependent) {
        //getRecordsByObjectApi
        system.debug('clause'+clause);
        String objectApiNameParent = null;
        Boolean CustomStandard = false ;
        String Related;
        try {
            SObjectType objectType = recordId.getSObjectType();
            objectApiNameParent = objectType.getDescribe().getName();
            
            
        } catch (Exception ex) {
            // Handle any exceptions
        }
        
    
        
        
        
        String querryParent = 'SELECT ' + 'id' + ' from ' +  objectApiNameParent + ' where Key_Account_360__c =: recordId';
        system.debug('querryParent'+querryParent);
        List<Sobject> listOfQuerryParent = Database.query(querryParent);
        system.debug('listOfQuerryParent'+listOfQuerryParent);
        set<id> setOfIds = new set<id>();
        for(Sobject rec : listOfQuerryParent){
            setOfIds.add(rec.id);
        }
        
        ResponseBody wra = new ResponseBody();
        List<Sobject> listOfOptions = [select name from account where GT_Client_Group__c =:setOfIds AND  RecordType.DeveloperName != 'Bill_To_Client'];
        system.debug('ListOfobjectApiNameMiddle'+listOfOptions);
        wra.ListOfFilterOptions = listOfOptions;
       
        
        string querryLast = 'SELECT ' + fieldApiNames + ' FROM ' + relatedObject + ' WHERE ' + clause + ' =: listOfOptions ';
        system.debug('querrylast>>>>'+querryLast);
        List<Sobject> listOfAllRelatedRecords = Database.query(querryLast);
        wra.ListOfAll = listOfAllRelatedRecords;
        return wra;
    }
    
    
    @AuraEnabled(cacheable=true)
    public static List<SObject> getFilterRecords(String objectApiName,string relatedObject,String fieldApiNames,id recordId , string value ,string clause ,string dependent) {
        system.debug('value'+value);
        system.debug('relatedObject'+relatedObject);
        system.debug('objectApiName'+objectApiName);
        system.debug('fieldApiNames'+fieldApiNames);
        system.debug('clause'+clause);
        
        String objectApiNameParent = null;
        Boolean CustomStandard = false ;
        String Related;
        try {
            SObjectType objectType = recordId.getSObjectType();
            objectApiNameParent = objectType.getDescribe().getName();
            
         
        } catch (Exception ex) {
            // Handle any exceptions
        }
        
      
        
        
        String querryParent = 'SELECT ' + 'id' + ' from ' +  objectApiNameParent + ' where Key_Account_360__c =: recordId';
        system.debug('querryParent'+querryParent);
        List<Sobject> listOfQuerryParent = Database.query(querryParent);
        system.debug('listOfQuerryParent'+listOfQuerryParent);
        set<id> setOfIds = new set<id>();
        for(Sobject rec : listOfQuerryParent){
            setOfIds.add(rec.id);
        }
        
        List<Sobject> listOfOptions= [select id,name from account where GT_Client_Group__c =:setOfIds AND  RecordType.DeveloperName != 'Bill_To_Client'];
        system.debug('listOfOptions'+listOfOptions);
        
        string querryLast = 'SELECT ' + fieldApiNames + ' FROM ' + relatedObject + ' WHERE ' + clause + ' =: value ';
        List<Sobject> listOfFilterRealtedRecords = Database.query(querryLast);
        
        return listOfFilterRealtedRecords;
    }
    
    @AuraEnabled(cacheable=true)
    public static List<List<String>> genrateColumns(string Fields , string related , List<Account> Records){
        System.debug('Records'+Records);
        Boolean CustomStandard = false ;
        string fieldChildLabel;
        System.debug('Fields>>>>'+ Fields);
        List<List<String>> ListOfFieldList = new  List<List<String>>();   
        List<String> ListOfFields =  Fields.split(',');
        system.debug('ListOfFields'+ListOfFields);
        for(String  objField : ListOfFields){
            system.debug('obj>>' +objField);
            string objFieldString = objField;
            system.debug('objFieldString'+objFieldString);
            List<String> listOfString = new List<String>();
            if(objField.contains('.')){
                system.debug('INN con');
                list<String> SeprateObjField = objFieldString.split('\\.');
                system.debug('SeprateObjField'+SeprateObjField);
                Schema.DescribeSObjectResult objectDescribe = Schema.getGlobalDescribe().get(related).getDescribe();
                CustomStandard = objectDescribe.isCustom();
                
                if(CustomStandard){
                    if(SeprateObjField[0].contains('__r')){ 
                        List<String> spliList = SeprateObjField[0].split('__');
                        
                        fieldChildLabel =  spliList[0] + '__c';
                        system.debug('fieldChildLabel'+fieldChildLabel);
                    } 
                    
                }
                else{
                    if(SeprateObjField[0].contains('__r')){ 
                        List<String> spliList = SeprateObjField[0].split('__');
                        
                        fieldChildLabel =  spliList[0] + '__c';
                        system.debug('fieldChildLabel'+fieldChildLabel);
                    } 
                    else{
                        fieldChildLabel = SeprateObjField[0]+'Id';
                    }
                }
            }
            string fieldapi ='';
            if(objField.contains('.')){
                system.debug('Inn Con Iff');
                fieldapi = fieldChildLabel;
                system.debug('fieldOnly' + fieldapi);
           
            }
            else{
                fieldapi = objField;
                
            }
            SObjectField field = Schema.getGlobalDescribe().get(related).getDescribe().fields.getMap().get(fieldapi);
            	 system.debug('fieldLable' + field.getDescribe().getLabel());
                listOfString.add(field.getDescribe().getLabel());
                //String objFieldApi = objField.remove('.');
                listOfString.add(objField);
                ListOfFieldList.add(listOfString);
            
            
        }
        
        system.debug('ListOfFieldList>>'+ListOfFieldList);
        return ListOfFieldList;
        
    }
    
    public class ResponseBody {
        @AuraEnabled public List<Sobject> ListOfFilterOptions;
        @AuraEnabled public List<Sobject> ListOfAll;
    }
}