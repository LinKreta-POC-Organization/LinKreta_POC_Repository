public class SendEmailAccountOwnerBatchHelper {

    public static String getQuery(){
        String query = 'SELECT Id, Name ,OwnerId ,Status_DS_Team_Remark_Status__c FROM Account WHERE Status_DS_Team_Remark_Status__c = \'Approved\' ';
        if(String.isNotBlank(query)){
            return query;
        }
        else{
            return null;
        }
    }
}