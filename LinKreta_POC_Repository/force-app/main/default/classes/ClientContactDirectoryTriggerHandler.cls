//Added by Rakesh, 27-05-24
//Used to share record  with EA user.
public class ClientContactDirectoryTriggerHandler {
    
    public static void insertClientContactDirList(List<Client_Contact_Directory__c> newClientContactDirList){
        List<Client_Contact_Directory__c> conDirectLst = new List<Client_Contact_Directory__c>();
        for(Client_Contact_Directory__c con : newClientContactDirList){
            conDirectLst.add(con);
        }
        if(conDirectLst.size()>0)
        {
            EAPartnerRecordAccessUtils.EAShareRecor(conDirectLst,'Client_Contact_Directory__Share');
        }
    }
    
    public static void updateClientContactDirList(List<Client_Contact_Directory__c> newClientContactDirList, Map<Id,Client_Contact_Directory__c> oldMapClientContactDir){
        for(Client_Contact_Directory__c contDirect : newClientContactDirList){
            if(contDirect.OwnerId != oldMapClientContactDir.get(contDirect.id).OwnerId){
                List<Client_Contact_Directory__c> conDirectLst = new List<Client_Contact_Directory__c>();
                conDirectLst.add(contDirect);
                if(conDirectLst.size()>0)
                {
                    EAPartnerRecordAccessUtils.EAShareRecor(conDirectLst,'Client_Contact_Directory__Share');
                }                        
            }
        }
    }
}