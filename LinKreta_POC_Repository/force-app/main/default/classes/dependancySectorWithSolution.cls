public with sharing class dependancySectorWithSolution {
    @AuraEnabled(cacheable=true)
    public static List<PiclistWrapperClass> PicklistValues(String Sector){
        List<PiclistWrapperClass> wrapperList = new List<PiclistWrapperClass>();
        Industry_Leader_Mapping__c sectorSolution = [SELECT Id, Name, Industry_Leader__c, Industry_Business_Partner__c, (SELECT Id, SubIndustry__c FROM Sub_Industries__r) FROM Industry_Leader_Mapping__c WHERE Name =: Sector LIMIT 1];
        List<String> ListOfSolution = new List<String>();
        if(sectorSolution.Sub_Industries__r != null && ! sectorSolution.Sub_Industries__r.isEmpty()){
            for(Sub_Industry__c iter: sectorSolution.Sub_Industries__r) {
                ListOfSolution.add(iter.SubIndustry__c);
                
                PiclistWrapperClass pwc = new PiclistWrapperClass();
                pwc.picklistvalue = iter.SubIndustry__c;
                pwc.picklistlabel=  iter.SubIndustry__c;
                wrapperList.add(pwc);
            }
        } 
        System.debug('wrapperList'+wrapperList);
        
        return wrapperList;
    }
    
    @AuraEnabled(cacheable=true)
    public static List<PiclistWrapperClass> newClientSourcePicklistValues(){
        List<PiclistWrapperClass> wrapperList = new List<PiclistWrapperClass>();
        List<LeadSource_For_LWC__mdt> leadSource = [select New_Client_Source__c from LeadSource_For_LWC__mdt ORDER BY New_Client_Source__c asc];
        List<String> ListOfSolution = new List<String>();
        
        for(LeadSource_For_LWC__mdt res : leadSource) {
            
            PiclistWrapperClass pwc = new PiclistWrapperClass();
            pwc.picklistvalue = res.New_Client_Source__c;
            pwc.picklistlabel=  res.New_Client_Source__c;
            wrapperList.add(pwc);
        }
        System.debug('wrapperList'+wrapperList);
        
        return wrapperList;
    }
    
    //Gaurav Kumar (16-Sep-2023)
    @AuraEnabled(cacheable=true)
    public static List<PiclistWrapperClass> fetchAccount(String allianceType){
        System.debug('allianceType :'+allianceType);
        String dynamicValue;
        if(allianceType == 'Chambers'){
            String recordType = 'Channels and Alliances';
            String CType = 'Chamber';
            dynamicValue = 'WHERE RecordType.Name=\''+recordType+'\'';
            dynamicValue = dynamicValue+' AND Type=\''+CType+'\'';
            //dynamicValue = dynamicValue+' AND Channel_and_Alliance_Type__c=\''+allianceType+'\'';
        }
        else if(allianceType == 'Client Referral'){
            String recordType = 'Client';
            String CType = 'Channel';
            dynamicValue = 'WHERE RecordType.Name=\''+recordType+'\'';
            //dynamicValue = dynamicValue+' AND Type=\''+CType+'\'';
            //dynamicValue = dynamicValue+' AND Channel_and_Alliance_Type__c=\''+allianceType+'\'';
        }
        else{
            String recordType = 'Channels and Alliances';
            String CType = 'Channel';
            dynamicValue = 'WHERE RecordType.Name=\''+recordType+'\'';
            dynamicValue = dynamicValue+' AND Type=\''+CType+'\'';
            dynamicValue = dynamicValue+' AND Channel_and_Alliance_Type__c=\''+allianceType+'\'';
        }
        
        List<PiclistWrapperClass> wrapperList = new List<PiclistWrapperClass>();
        System.debug('Query :'+dynamicValue);
        String query = 'SELECT Id,Name, RecordType.Name,Type,Channel_and_Alliance_Type__c,(select id,Name,AccountId from contacts) FROM Account '+dynamicValue;
        List<Account> accList = database.query(query);
        System.debug('Result :'+accList);
        for(Account acc : accList){
            PiclistWrapperClass pwc = new PiclistWrapperClass();
            pwc.picklistvalue = acc.Name;
            pwc.recordId=  acc.Id;
            wrapperList.add(pwc);
            System.debug('Record Type Name :'+acc.RecordType.Name);
        }
        
        return wrapperList;
    }
    
    //Gaurav Kumar (16-Sep-2023)
    @AuraEnabled(cacheable=true)
    public static List<PiclistWrapperClass> fetchContact(String accountId){
        String dynamicValue = ' WHERE AccountId=\''+accountId+'\'';        
        List<PiclistWrapperClass> wrapperList = new List<PiclistWrapperClass>();
        System.debug('Id :'+accountId);
        String query = 'SELECT Id,Name,AccountId from Contact'+dynamicValue;
        List<Contact> conList = database.query(query);
        System.debug('Result :'+conList);
        for(Contact con : conList){
            PiclistWrapperClass pwc = new PiclistWrapperClass();
            pwc.picklistvalue = con.Name;
            pwc.recordId=  con.Id;
            wrapperList.add(pwc);
        }
        
        return wrapperList;
    }
    
    
    public class PiclistWrapperClass{
        @AuraEnabled public String picklistvalue;
        @AuraEnabled public String picklistlabel;
        @AuraEnabled public String recordId;//Gaurav Kumar (16-Sep-2023)
    }
}