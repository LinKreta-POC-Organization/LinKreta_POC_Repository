@isTest
public class Batch_SyncClientContactTest {
    @isTest
    static void testGetRelationshipTeamMembers() {
        Account testAccount = TestDataFactory.createAccountRecord();
        insert testAccount;
        
        Contact testContact = TestDataFactory.createContact();
        testContact.AccountId = testAccount.Id;
        testContact.is_Address_filled__c = false;//add by aman vijay
        insert testContact;
        
        User testUser = TestDataFactory.createUserRecord();
        insert testUser;
        
        Map<Contact, String> contactMap = new Map<Contact, String>();
        contactMap.put(testContact, 'Insert');
        
        // Mock the HTTP callout
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        Database.executeBatch(new BatchSyncClientContactToWCGT(contactMap));
        
        Test.stopTest();
        
    }
    
    // Mock HTTP callout response
    private class MockHttpResponseGenerator implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setStatus('OK');
            res.setStatusCode(200);
            String body = '{"sUserId":"US013737","sStatus":"1","sStateId":"ST000472","sRelOffc":"LC000021","sPrefix":"Mr.","sPincode":"121002","sMobileNo":"2233445567","sLastName":"Kapoor38","sFlag":"2","sFirstName":"Bhawik38","sEmailId":"38dummy_0031s000019wdydaak@example.com","sDesign":"CEO","sCountryId":"CO000106","sContPerson":"Bhawik38 Kapoor38","sContactSFID":"0031s000019WdYdAAK","sClientSFID":"0011s00001qjDlVAAU","sClientAddress2":"dummy","sClientAddress1":"dummy","sCityId":"Delhi"}';
            res.setBody(body);
            return res;
        }
    }
    
}