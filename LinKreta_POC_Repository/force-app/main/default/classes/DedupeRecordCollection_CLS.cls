/*
NAME                     : DedupeRecordCollection_CLS
AUTHOR                   : Swarna Sankha Singh [SWS]
VERSION                  : 1
CREATED DATE             : 8th June 2023
PROJECT NAME / TICKET #  : Linkreta U_223
DESCRIPTION
This is a Flow Invocable class created to receive a collection of records for 
Expertise or SMEG or SME and return a List of String containing the unique 
LOV__c values. This was introduced to improve the performance of the Flow used 
for managing the Update Professional Services function.


CHANGE HISTORY
--------------------------
AUTHOR                   : 
VERSION                  : 
MODIFICATION DATE        : 
PROJECT NAME / TICKET #  : 
DESCRIPTION              : 

*/

global class DedupeRecordCollection_CLS {

    @InvocableMethod(label='Dedupe Record Collection [For Expertise, SMEG and SME]' category='Util' )
    global static List<FlowResponse> dedupeList(List<FlowRequest> requests)
	{
        List<FlowResponse> flowResponses = new List<FlowResponse>();
        for (FlowRequest request : requests)
		{
            FlowResponse flowResponse = new FlowResponse();
            flowResponse.outputRecordCollection = getUniqueStringOfLOV(request);
            flowResponses.add(flowResponse);
        }
        return flowResponses;
    }

    private static List<String> getUniqueStringOfLOV(FlowRequest request)
	{
        Map<String, String> sobjectMap = new Map<String, String>();
        for (SObject record : request.inputRecordCollection)
		{
            try
			{
                String fieldValue = String.valueOf(record.get(request.fieldToBeUsedForDeDupe));
                if(!sobjectMap.containsKey(fieldValue))
				{
                    sobjectMap.put(fieldValue, fieldValue);
                }
            } 
			catch(SObjectException e)
			{
                System.debug(e.getMessage());
            }
        }
        return sobjectMap.values();
    }

    global class FlowRequest
	{
		@InvocableVariable(required=true)
        global List<SObject> inputRecordCollection;
        
        @InvocableVariable(required=true)
        global String fieldToBeUsedForDeDupe;
        
    }

    global class FlowResponse
	{
		public FlowResponse()
		{
            outputRecordCollection = new List<String>();
        }

        @InvocableVariable
        global List<String> outputRecordCollection;
	}
}