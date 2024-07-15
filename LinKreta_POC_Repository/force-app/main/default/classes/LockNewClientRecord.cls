public class LockNewClientRecord {
    @InvocableMethod
    public static void lockNewClientRecord(List<Id> leadIds){ 
        List<Lead> leadList = [SELECT Id FROM Lead WHERE Status = 'NotAccept' AND Id IN:leadIds];
        List<Approval.LockResult> lockResList = Approval.lock(leadList, false);
        for(Approval.LockResult lr: lockResList){
            if(lr.isSuccess()){
                System.debug('Successfully Locked Records With Id : '+ lr.getId());
            }else{
                for(Database.Error err: lr.getErrors()){
                    System.debug('The following error has occured.');
                    System.debug(err.getStatusCode() + ': ' + err.getMessage());
                    System.debug('New Client fields that affected this error: ' + err.getFields());
                }
            }
        }
    }
}