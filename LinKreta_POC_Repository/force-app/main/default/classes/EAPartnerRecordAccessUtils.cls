/*
AUTHOR                   : Prashant Bansal
CREATED DATE             : 07-May-2024
PROJECT NAME / TICKET #  : EA Functionality Record Sharing and unsharing with EA
DESCRIPTION
EA Functionality Record Sharing and unsharing with EA
*/
public class EAPartnerRecordAccessUtils {
    // This method will share the Custom Object records with the corresponding EA Group based on the owner id of Partner
    //eg: objectName = Joint_Venture__Share
    public static void EAShareRecor(List<sObject> sObjectlst,String objectName){
        System.debug('sObjectlst-->'+sObjectlst);
        System.debug('objectName-->'+objectName);
        Map<Id,Id> mapPartnerIdVsGrpId = getEAGroupId(sObjectlst);
        
        List<SObject> lstSobjectToInsert = new List<SObject>();
        for(sObject sObjec : sObjectlst){
            Id ownerId = (Id)sObjec.get('OwnerId');
            // If clause added by Prashant on 25May
            if(mapPartnerIdVsGrpId != null && mapPartnerIdVsGrpId.containsKey(ownerId)) {
                SObject obj = Schema.getGlobalDescribe().get(objectName).newSObject();
                obj.put('ParentId', sObjec.Id);
                obj.put('RowCause', 'Manual');
                obj.put('UserOrGroupId',mapPartnerIdVsGrpId.get(ownerId));
                obj.put('AccessLevel', 'Edit');
                lstSobjectToInsert.add(obj);
            }
        }
        System.debug('lstSobjectToInsert-->'+lstSobjectToInsert);
        Database.SaveResult[] lsr = Database.insert(lstSobjectToInsert,false);
        // Iterate through each returned result
        for (Database.SaveResult sr : lsr) {
            if (sr.isSuccess()) {
                // Operation was successful, so get the ID of the record that was processed
                System.debug('Successfully inserted Record. Record ID: ' + sr.getId());
            }
            else {
                // Operation failed, so get all errors                
                for(Database.Error err : sr.getErrors()) {
                    System.debug('The following error has occurred --> '+ err.getStatusCode() + ': ' + err.getMessage());
                }
            }
        }
    }
    
    // This method will share the Standard Object records with the corresponding EA Group based on the owner id of Partner
    //eg: objectName = LeadShare
    public static void EAShareRecor(List<sObject> sObjectlst,String objectName, string parentField,string accessLevel ){
        System.debug('sObjectlst-->'+sObjectlst);
        System.debug('objectName-->'+objectName);
        System.debug('parentField-->'+parentField);
        System.debug('accessLevel-->'+accessLevel);
        
        Map<Id,Id> mapPartnerIdVsGrpId = getEAGroupId(sObjectlst);
        List<SObject> lstSobjectToInsert = new List<SObject>();
        for(sObject sObjec : sObjectlst){
            Id ownerId = (Id)sObjec.get('OwnerId');
            // If clause added by Prashant on 25May
            if(mapPartnerIdVsGrpId != null && mapPartnerIdVsGrpId.containsKey(ownerId)) {
                SObject obj = Schema.getGlobalDescribe().get(objectName).newSObject();
                obj.put(parentField, sObjec.Id);
                obj.put('RowCause', 'Manual');
                obj.put('UserOrGroupId', mapPartnerIdVsGrpId.get(ownerId));
                obj.put(accessLevel, 'Edit');
                if(objectName=='AccountShare'){
                    obj.put('CaseAccessLevel', 'Edit');
                    obj.put('ContactAccessLevel', 'Edit');
                    obj.put('OpportunityAccessLevel', 'Edit');
                }
                lstSobjectToInsert.add(obj);
            }
        }
        System.debug('lstSobjectToInsert-->'+lstSobjectToInsert);
        Database.SaveResult[] lsr = Database.insert(lstSobjectToInsert,false);
        
        // Iterate through each returned result
        for (Database.SaveResult sr : lsr) {
            if (sr.isSuccess()) {
                // Operation was successful, so get the ID of the record that was processed
                System.debug('Successfully inserted Record. Record ID: ' + sr.getId());
            }
            else {
                // Operation failed, so get all errors                
                for(Database.Error err : sr.getErrors()) {
                    System.debug('The following error has occurred --> '+ err.getStatusCode() + ': ' + err.getMessage());
                }
            }
        }
    }
    
    // This method returns the Map of Partner Id & GroupId (mapPartnerIdVsGrpId)
    public static Map<Id,Id> getEAGroupId(List<sObject> sObjectlst){
        System.debug('sObjectlst-->'+sObjectlst);
        
        Set<Id> setRecordId = new Set<Id>();
        Set<String> recordOwnerEmpIdSet = new Set<String>();
        
        for(sObject sObj : sObjectlst){
            Id ownerId = (Id)sObj.get('OwnerId');
            setRecordId.add(ownerId);
        }
        System.debug('setRecordId-->'+setRecordId);
        
        Map<String,Id> mapPartnerEmpIdVsId = new Map<String,Id>();
        List<User> ownerEmpIdsLst = [Select Id,Emp_Id__c from User where Id =:setRecordId and Emp_Id__c!=null];
        System.debug('ownerEmpIdsLst-->'+ownerEmpIdsLst);
        
        for(User userObj : ownerEmpIdsLst){
            mapPartnerEmpIdVsId.put(userObj.Emp_Id__c, userObj.Id);
            recordOwnerEmpIdSet.add(userObj.Emp_Id__c + '_EA_Group');
        }
        System.debug('mapPartnerEmpIdVsId-->'+mapPartnerEmpIdVsId);
        System.debug('recordOwnerEmpIdSet-->'+recordOwnerEmpIdSet);
        
        List<Group> lstGroupToShareRecord = [Select Id,developerName FROM Group WHERE developerName IN : recordOwnerEmpIdSet ];
        System.debug('lstGroupToShareRecord-->'+lstGroupToShareRecord);
        Map<Id,Id> mapPartnerIdVsGrpId = new Map<Id,Id>();
        
        if(! lstGroupToShareRecord.isEmpty()) {
            for(Group eaGrp : lstGroupToShareRecord){
                string empId =  eaGrp.developerName.SubstringBefore('_EA_Group');
                string userId = mapPartnerEmpIdVsId.get(empId);
                mapPartnerIdVsGrpId.put(userId,eaGrp.Id);
            }
            System.debug('mapPartnerIdVsGrpId-->'+mapPartnerIdVsGrpId);
        }
        return mapPartnerIdVsGrpId;
    }
    
    /*  
// This method shares the record with the corresponding EA Group based on the owner id of Partner
public static void ownerChange(Map<String, sObject> sObjectNewMap, Map<string, sObject> sObjectOldMap, String objectName,String parentField, String accessLevel) {
List<sObject> sObjectlst = new List<sObject>();
for(sObject obj : sObjectNewMap.Values()){
sObjectlst.add(obj);
}
for(sObject sObj : sObjectNewMap.values()){

Id newOwnerId = (Id)sObj.get('OwnerId');

sObject oldObj = sObjectOldMap.get(sObj.Id);
Id oldOwnerId = (Id)oldObj.get('OwnerId');

if(newOwnerId != oldOwnerId){
if(parentField == 'ParentId'){
EAShareRecor(sObjectlst, objectName);
}else{
EAShareRecor(sObjectlst, objectName,parentField,accessLevel);
}
}
}
}  */  
}