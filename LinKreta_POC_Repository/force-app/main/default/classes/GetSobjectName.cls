public class GetSobjectName {
	@InvocableMethod(label='Check sObject')
    public static List<Result> getSObjectName(List<Id> recordId){
        //System.debug('Id -->:' + recordId[0]);
        System.debug('Ids -->:' + recordId.size()); 
        
        // Create a list to hold the Result objects that will be returned
        List<Result> responseWrapper = new List<Result>();
        
        // Create a new Result object to store the response data
        Result response = new Result();
        
        // Get the sObject type name of the Id
        if(recordId.size() > 0 && !recordId.isEmpty() && recordId != null ){
            system.debug('recordId15:'+recordId);
            response.outputMember = String.valueOf(recordId[0].getSobjectType());
        }else{
            response.outputMember = '';
        }
        
        responseWrapper.add(response);
        System.debug('responseWrapper=='+responseWrapper);
        return responseWrapper;
    }
    public class Result {
        @InvocableVariable(label='Records for Output' )
        // The field to store the sObject type name.
        public String outputMember;
    }
}