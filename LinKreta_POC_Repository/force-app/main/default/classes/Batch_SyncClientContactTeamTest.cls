@isTest
public class Batch_SyncClientContactTeamTest {
	@isTest
    static void testGetRelationshipTeamMembers() {
        Account testAccount = TestDataFactory.createAccountRecord();
        insert testAccount;
        
        User testUser = TestDataFactory.createUserRecord();
        testUser.USER_ID__c ='US017041';
        insert testUser;
//add by Aman vijay	
        Contact testContact = TestDataFactory.createContact();
        testContact.AccountId = testAccount.Id;
        testContact.BOD_Flag__c = 'No';
        
        testContact.is_Address_filled__c = false;
        
        
        
        System.runAs(testUser){
            insert testContact;
        }
		
                
        Client_contact_relationship_team__c testContactTeamMember = TestDataFactory.createContactTeam(testUser.Id);
        testContactTeamMember.Client_Contact__c = testContact.Id;
        testContactTeamMember.User__c = testUser.Id;
        insert testContactTeamMember;

        // Mock the HTTP callout
        
        Test.startTest();
        
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        Database.executeBatch(new Batch_SyncClientContactTeam());

        Test.stopTest();

    }

    // Mock HTTP callout response
    public class MockHttpResponseGenerator implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setStatus('OK');
            res.setStatusCode(200);
            String body = '{"sContactWCGTID":"CN002560","sEMPID":"EM001394,EM002008,EM000923","sUserId":"US001376","sStatus":"1"}';
            res.setBody(body);
            return res;
        }
    }

}