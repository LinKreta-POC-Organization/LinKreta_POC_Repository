public class ContactService {
    public static List<Contact> getClientContact(Set<Id> clientContactIds){
        try{
            system.debug('clientContactIds:'+clientContactIds);
            List<Contact> clientContacts = new List<Contact>();
            if(clientContactIds != null && clientContactIds.size() > 0){
                clientContacts = [SELECT Id,Name,AccountId,Account.Name,Account.Country_Corridor__c,MobilePhone,Email,Designation__c,Contact_status__c,Salutation,
                                   FirstName,LastName,RelationshipOffice__r.Location_Id__c,Client_Location__Street__s,Client_Location__City__s,
                                  Client_Location__StateCode__s,Client_Location__PostalCode__s,Client_Location__CountryCode__s,
                                  LastModifiedById FROM Contact WHERE ID IN : clientContactIds];
            }
            return clientContacts;
        }catch(Exception e){
            system.debug('exception:'+e.getLineNumber()+' '+e.getMessage());
            return null;
        }
    }
    
    public static List<DepthOfRelationship__c> getDepOfRelRelatedContact(Id contactId,Id gtUser){
        try{
            List<DepthOfRelationship__c> contactTeam = new List<DepthOfRelationship__c>();
            if(String.isNotBlank(contactId) && String.isNotBlank(gtUser)){
                contactTeam = [SELECT Id,Name,ClientContact__c,ClientContact__r.WCGTId__c,GTRL__c,GTRL__r.EMP_ID__c FROM DepthOfRelationship__c
                               WHERE ClientContact__c =: contactId AND GTRL__c =: gtUser];
            }
            return contactTeam;
        }catch(Exception e){
            system.debug('exception:'+e.getLineNumber()+' '+e.getMessage());
            return null;
        }
    }
}