/*@isTest
public class UpdateClientContactIdTest {
    
    @isTest Static void setData(){
        
        Contact conRec = TestDataFactory.createContact();
        conRec.is_Address_filled__c = false;
        conRec.WCGTId__c = 'CN058312';
        Insert conRec;
        
        String body = '{"WCGTId":"'+conRec.WCGTId__c+'","SFDCRecordID":"'+conRec.Id+'"}';
        //UpdateClientContactId.JsonParser testLead = (UpdateClientContactId.JsonParser)JSON.deserialize(body, UpdateClientContactId.JsonParser.class);
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/updateClientContactId';
        req.httpMethod = 'PUT';
        //req.params.put('WCGTId','test');
        //req.params.put('SFDCRecordID','test');
        req.addHeader('Content-Type', 'application/json');
        req.requestBody = Blob.valueOf(JSON.serialize(body));
        RestContext.request = req;
        RestContext.response = res;
        //System.assertEquals(200, res.statusCode);
        Test.startTest();
        UpdateClientContactId.doPut();
        Test.StopTest();
    }
    
    
}*/

@isTest
private class UpdateClientContactIdTest {

    @isTest
    static void testUpdateContactId() {
       // Create a test Contact record
        Contact testContact = TestDataFactory.createContact();
        testContact.is_Address_filled__c = false;
        testContact.WCGTId__c = 'CN058312';
        Insert testContact;

        // Create a JSON string to simulate the request payload
        String jsonString = '{ "WCGTId": "CN058312", "SFDCRecordID": "' + testContact.Id + '" }';
       

        // Simulate the HTTP request to the REST service
        Test.startTest();
        RestRequest request = new RestRequest();
        request.requestURI = '/services/apexrest/updateClientContactId';
        request.httpMethod = 'PUT';
        request.requestBody = Blob.valueOf(jsonString);
        RestContext.request = request;

        String response = UpdateClientContactId.doPut();
        Test.stopTest();

        // Perform assertions on the response received
        System.assertEquals('The WCGT ID has been Successfully Updated', response);

        // Query the Contact record to verify the update
        Contact updatedContact = [SELECT Id, WCGTId__c FROM Contact WHERE Id = :testContact.Id LIMIT 1];
        System.assertEquals('CN058312', updatedContact.WCGTId__c);
    }
    
     @isTest
    static void testUpdateContactId1() {
        // Create a test Contact record
        Contact testContact = TestDataFactory.createContact();
        testContact.is_Address_filled__c = false;
        testContact.WCGTId__c = 'CN058312';
        Insert testContact;

        // Create a JSON string to simulate the request payload with SFDCRecordID as null
        String jsonStringNullSFDCRecordID = '{ "WCGTId": "CN058312", "SFDCRecordID": null }';

        // Simulate the HTTP request to the REST service with null SFDCRecordID
        Test.startTest();
        RestRequest requestNullSFDCRecordID = new RestRequest();
        requestNullSFDCRecordID.requestURI = '/services/apexrest/updateClientContactId';
        requestNullSFDCRecordID.httpMethod = 'PUT';
        requestNullSFDCRecordID.requestBody = Blob.valueOf(jsonStringNullSFDCRecordID);
        RestContext.request = requestNullSFDCRecordID;

        String responseNullSFDCRecordID = UpdateClientContactId.doPut();
        Test.stopTest();

        // Perform assertions on the response received for null SFDCRecordID
        System.assertEquals('The SFDC Record ID cannot be Blank or Empty', responseNullSFDCRecordID);
    
    }
}