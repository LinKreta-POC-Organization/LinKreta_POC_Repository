/*
* Author :Gaurav Kumar 
* Batch Class :ActivityOnContactBatch
* Date :22/12/2022
*/
public class ActivityOnContactBatchHelper {
    public static String getQuery(){
        String query ='SELECT Id ,AccountId,Name ,LastActivityDate FROM Contact WHERE LastActivityDate < Last_N_Days : 15';
        if(String.isNotBlank(query)){
            return query;
        }
        else{
            return null;
        }
    }
}