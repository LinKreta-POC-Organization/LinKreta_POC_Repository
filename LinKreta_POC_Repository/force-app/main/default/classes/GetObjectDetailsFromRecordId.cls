/* 
     Written By: Prashant Bansal
     Created Date: 18-July-2023
     Last Modified By : Prashant Bansal
     Last Modified Date : 18-July-2023
     Description : This class is used to get Object Details Based on Provided Record Id
*/
global class GetObjectDetailsFromRecordId {

    @InvocableMethod
    global static List<FlowResponse> getObjectDetails(List<Id> recordIds) {
        List<FlowResponse> flowResponses = new List<FlowResponse>();
        for (Id recId : recordIds) {
            String sObjName = recId.getSObjectType().getDescribe().getName();
            
            FlowResponse flowResponse = new FlowResponse();
            flowResponse.objectAPIName = sObjName;
            flowResponses.add(flowResponse);
        }
        return flowResponses;
    }

    global class FlowResponse {
	    @InvocableVariable
        global String objectAPIName;
	}
}