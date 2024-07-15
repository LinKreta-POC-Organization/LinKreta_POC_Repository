//By Rohitash Mourya

public without sharing class leadSharingForNSL {
    public static void leadRecordSharingToNSL(List<ID> leadRecordIDs,Map<Id,Lead> oldLeadMap){
        System.debug('oldLeadMap=='+oldLeadMap);
        List<LeadShare> listLeadShareRecord =new List<LeadShare>();
        List<Lead> leadRecordList=[Select Industry_Leader__c,Id from Lead where Id in:leadRecordIDs]; 
        List<UserRecordAccess> userAccess = new List<UserRecordAccess>();
        IF(leadRecordList[0].Industry_Leader__c!=null && leadRecordList.size()>0 ){
         userAccess = [SELECT RecordId, HasEditAccess FROM UserRecordAccess WHERE UserId =: leadRecordList[0].Industry_Leader__c AND RecordId =: leadRecordList[0].Id LIMIT 1];
        }
        List<LeadShare> leadShareList=new List<LeadShare>();
        Id shareId=leadRecordList[0].id;
        Id nslIdd;
        if(oldLeadMap.get(leadRecordList[0].id).Industry_Leader__c!=leadRecordList[0].Industry_Leader__c){
           nslIdd=oldLeadMap.get(leadRecordList[0].id).Industry_Leader__c;
        }
        for(Lead LeadRecord:leadRecordList){
            if(LeadRecord.Industry_Leader__c!=null){
            LeadShare leadSharing=new leadShare();
            system.debug('LeadRecord.Id'+LeadRecord.Id);  
            leadSharing.LeadId=LeadRecord.Id;
            leadSharing.LeadAccessLevel='Edit';
            //leadSharing.LeadAccessLevel='All';
            system.debug('NSL'+LeadRecord.Industry_Leader__c);  
            leadSharing.UserOrGroupId=  LeadRecord.Industry_Leader__c;
            leadSharing.RowCause=Schema.LeadShare.RowCause.Manual;
            if(shareId!=NULL && nslIdd!=NULL){ 
                     system.Debug('shareId'+shareId);
                      system.Debug('nslIdd'+nslIdd);
                      system.Debug('nslIddnew'+LeadRecord.Industry_Leader__c);
                      
                     leadShareList=[select id,UserOrGroupId,RowCause,LeadId from LeadShare where RowCause ='manual' and LeadId = :shareId and UserOrGroupId= :nslIdd];
                }
             system.debug('Deleted List Size'+ leadShareList.size());
             if(leadShareList.size()>0){
               
                delete leadShareList;
        }  
      
            listLeadShareRecord.add(leadSharing);
              
        }
        }
        if(userAccess.size() > 0){
            if(listLeadShareRecord.size()>0 && userAccess[0].HasEditAccess == False){
                List<Database.SaveResult> sr = Database.insert(listLeadShareRecord,true); 
                system.debug('created sharing for NSl');
            }
        }
    }
    public static void leadRecordSharingToSectorCordinator(List<ID> leadRecordIDs,Map<Id,Lead> oldLeadMap){
        List<LeadShare> listLeadShareRecord =new List<LeadShare>();
        List<Lead> leadRecordList=[Select Industry_Business_Partner__c,Id from Lead where Id in:leadRecordIDs];
        List<UserRecordAccess> userAccess = new List<UserRecordAccess>();
        IF(leadRecordList[0].Industry_Business_Partner__c!=null){
            userAccess = [SELECT RecordId, HasEditAccess FROM UserRecordAccess WHERE UserId =: leadRecordList[0].Industry_Business_Partner__c AND RecordId =: leadRecordList[0].Id LIMIT 1];
        }
        List<LeadShare> leadShareList=new List<LeadShare>();
        Id shareId=leadRecordList[0].id;
        Id sectorIdd;
        if(oldLeadMap.get(leadRecordList[0].id).Industry_Business_Partner__c!=leadRecordList[0].Industry_Business_Partner__c){
           sectorIdd=oldLeadMap.get(leadRecordList[0].id).Industry_Business_Partner__c;
        }
        for(Lead LeadRecord:leadRecordList){
            if(LeadRecord.Industry_Business_Partner__c!=null){
            LeadShare leadSharing=new leadShare();
            system.debug('LeadRecord.Id'+LeadRecord.Id);  
            leadSharing.LeadId=LeadRecord.Id;
            leadSharing.LeadAccessLevel='Edit';
            system.debug('Industry_Business_Partner__c'+LeadRecord.Industry_Business_Partner__c);  
            leadSharing.UserOrGroupId=  LeadRecord.Industry_Business_Partner__c;
            leadSharing.RowCause=Schema.LeadShare.RowCause.Manual;
            listLeadShareRecord.add(leadSharing);
                
        }
             if(shareId!=NULL && sectorIdd!=NULL){ 
                     system.Debug('shareId'+shareId);
                      system.Debug('sectorIdd'+sectorIdd);
                      system.Debug('sectorIddNew'+LeadRecord.Industry_Business_Partner__c);
                      
                     leadShareList=[select id,UserOrGroupId,RowCause,LeadId from LeadShare where RowCause ='manual' and LeadId = :shareId and UserOrGroupId= :sectorIdd];
                }
            system.debug('Deleted List Size'+ leadShareList.size());
             if(leadShareList.size()>0){
               
                delete leadShareList;
        }  
      
        }
        if(userAccess.size() > 0){
            if(listLeadShareRecord.size()>0 && userAccess[0].HasEditAccess == False){
                List<Database.SaveResult> sr = Database.insert(listLeadShareRecord,true); 
                system.debug('created sharing Sector bussiness Partner');                   
            }
        }
        
    }  
}