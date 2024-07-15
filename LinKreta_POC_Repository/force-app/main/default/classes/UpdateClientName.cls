public without sharing class UpdateClientName {

    public static void updateName(Account accObj) {
        accObj.IsNameChange__c = accObj.IsNameChange__c == false ? true : false;        
        update accObj;
        
        // Setting IsNameChange as false after updating Account Name
        accObj.IsNameChange__c = accObj.IsNameChange__c == false ? true : false;        
        update accObj;
    } 
}