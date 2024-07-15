@isTest
public class DedupeRecordCollection_CLSTest {

    @isTest
    static void testDedupeList() {
        // Test data setup
        List<SObject> inputRecords = new List<SObject>();
        Lead leadRec = TestDataFactory.createLeadRecord();
        Insert leadRec;
        List<Lead> leadist = New List<Lead>();
        leadist.add(leadRec);
        DedupeRecordCollection_CLS.FlowRequest request = new DedupeRecordCollection_CLS.FlowRequest();
        request.inputRecordCollection = leadist;
        request.fieldToBeUsedForDeDupe = 'ExpertiseForDeDupe__c';

        List<DedupeRecordCollection_CLS.FlowRequest> requestList = new List<DedupeRecordCollection_CLS.FlowRequest>();
        requestList.add(request);
        
        Test.startTest();
        List<DedupeRecordCollection_CLS.FlowResponse> result = DedupeRecordCollection_CLS.dedupeList(requestList);
        Test.stopTest();
        System.assertNotEquals(null, result);
        System.assertEquals(1, result.size());
        System.assertNotEquals(null, result[0].outputRecordCollection);
    }
}