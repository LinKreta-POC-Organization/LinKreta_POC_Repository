@isTest
public class createJointVentureTest {

    private class MockHttpResponse implements HttpCalloutMock {
        private String response;

        public MockHttpResponse(String response) {
            this.response = response;
        }

        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setBody(response);
            res.setStatusCode(200);
            return res;
        }
    }

    @isTest
    static void testCreateJointVenture() {
        // Create a CapIQ Custom Metadata Type record for testing
        CapIQ__mdt capIqMetadata = CapIQ__mdt.getInstance('Capiq');

        // Create a Lead record for testing
        Lead testLead = TestDataFactory.createLeadRecord();
        insert testLead;

        // Set up the mock response for the HTTP callout
        String mockResponse = '{"GDSSDKResponse": [{"Rows": [{"Row": ["Feature1"]}]}, {"Rows": [{"Row": ["CompanyName"]}]}, {"Rows": [{"Row": ["OtherInfo"]}]}, {"Rows": [{"Row": ["AnotherInfo"]}]}, {"Rows": [{"Row": ["AndSoOn"]}]}, {"Rows": [{"Row": ["MoreData"]}]}, {"Rows": [{"Row": ["EvenMoreData"]}]}]}';

        Test.startTest();
        
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse(mockResponse));
        createJointVenture.deleteOldJV(testLead.Id, 'CompanyID123', 'Lead');

        Test.stopTest();
    }
}