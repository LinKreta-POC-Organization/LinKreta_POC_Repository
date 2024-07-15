/*
Name		:	UserExit_Batch
Author		:	Arpit vijayvergiya @ Techmatrix
Date		:	25 Sept 2023
Description	:	Transfer ownership of Records from the employee leaving the company to different Employee
Last Modified By : Suraj Kumar 27 Oct 2023
*/
global class UserExit_Batch implements Database.Batchable<sObject>, Database.Stateful {
    global Integer sequence;
    global User_Exit_Object_Mapping__mdt userExitMapping;
    global User objUser;
    global UserExit_Batch(User objUser){
        this.sequence = 1;
        this.objUser = objUser;
        this.userExitMapping = [SELECT Id,Sequence__c, Object_API_Name__c, Field_API_Name__c, WHERE_Condition__c FROM User_Exit_Object_Mapping__mdt WHERE Sequence__c =: this.sequence];
    }
    
    global UserExit_Batch(Integer seq,User_Exit_Object_Mapping__mdt userExitMapping, User objUser){
        this.sequence = seq;
        this.userExitMapping = userExitMapping;
        this.objUser = objUser;
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        System.debug('start method');
        System.debug('UE-----> '+this.userExitMapping);

        String Dynamicquery = 'Select id,'+this.userExitMapping.Field_API_Name__c +
            ' FROM '+this.userExitMapping.Object_API_name__c + ' WHERE '+ this.userExitMapping.Field_API_Name__c +' = '+'\''+String.escapeSingleQuotes(this.objUser.Id)+'\'' ;

        if(String.isNotBlank(this.userExitMapping.WHERE_Condition__c)){
            System.debug('this.userExitMapping --> ' + this.userExitMapping);
            Dynamicquery += ' AND ' + this.userExitMapping.WHERE_Condition__c;
        }
        
        System.debug('Dynamicquery --> ' + Dynamicquery);
        return Database.getQueryLocator(Dynamicquery );
    }
    global void execute(Database.BatchableContext BC, List<sObject> scope) {
        System.debug('scope : ' + scope);
        String errorValue;
        List<ErrorLog__c> errorLogList =new List<ErrorLog__c>();
        try{
        List<sObject> UpdateList = new List<Sobject>();
        for(Sobject objRec : scope){
            objRec.put(this.userExitMapping.Field_API_Name__c, this.objUser.Successor_User__c);
            UpdateList.add(objRec);
        }
        if(UpdateList.size()>0){
            System.debug('items to update : ' + updateList);
            Database.SaveResult[] srList = Database.update(UpdateList, false);
            for (Database.SaveResult sr : srList) {
                if (sr.isSuccess()) {
                    // This condition will be executed for successful records and will fetch
                    // the ids of successful records
                    System.debug('Successfully updated: ' + sr.getId());
                } else {
                    
                    // This condition will be executed for failed records
                    Database.Error objErr = sr.getErrors()[0];
                    System.debug('The following error has occurred.');
                    System.debug(': Message ' + objErr.getMessage());
                    System.debug('object field which are affected by the error:' 
                                 + objErr.getFields());
                    ErrorLog__c err = new ErrorLog__c();
                    err.NameofArtifact__c = 'UserExit_Batch';
                    err.ExceptionMessage__c = 'Error Message: '+ objErr.getMessage()+' | Fields: '+objErr.getFields();
                    //err.ExceptionType__c = objErr.getTypeName();
                    err.MethodName__c = 'execute';
                    err.SFDCRecordReference__c =String.valueOf(sr.getId()) ;
                    err.ErrorAPI__c = true;
                    errorLogList.add(err);
                }
            }
            insert errorLogList;
        } 
        }
        catch(Exception e){
           System.debug('Exception Error'+e.getMessage());
        }
    }
    global void finish(Database.BatchableContext BC) {
        this.Sequence +=1;
        List<User_Exit_Object_Mapping__mdt> lstOfUserExitMapping = [SELECT Id,Sequence__c, Object_API_Name__c, Field_API_Name__c, WHERE_Condition__c FROM User_Exit_Object_Mapping__mdt WHERE Sequence__c =: this.sequence];
        if(lstOfUserExitMapping.size() > 0){
           Database.executeBatch(new UserExit_Batch(this.Sequence,lstOfUserExitMapping[0],this.objUser)); 
        }
        //Database.executeBatch(new RecursiveBatch(this.Sequence));
        
    }
    
}