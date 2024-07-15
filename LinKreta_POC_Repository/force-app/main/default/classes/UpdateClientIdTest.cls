@isTest
public class UpdateClientIdTest {
    
    @isTest
    static void testUpdateClientIds(){
        
        Id clientRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Client').getRecordTypeId();
        Account testAccount = TestDataFactory.createAccountRecord();
        testAccount.Name = 'Deepak Sir';
        testAccount.RecordTypeId = clientRecordTypeId;
        testAccount.Status__c = 'Active';
        // acc1.GT_Client_Group__c = GtAcc.Id;
        testAccount.ClientAddress__City__s = 'Jaipur';
        testAccount.ClientAddress__CountryCode__s = 'IN';
        testAccount.ClientAddress__PostalCode__s = '789'; 
        testAccount.ClientAddress__StateCode__s = 'AS';
        testAccount.ClientAddress__Street__s = 'test,test';
        //acc1.Key_Account__c = True;
        insert testAccount;
         // Create a JSON string to simulate the request payload
        String jsonString = '{ "WCGTId": "CN058312", "SFDCRecordID": "' + testAccount.Id + '" }';

        // Simulate the HTTP request to the REST service
        Test.startTest();
        RestRequest request = new RestRequest();
        request.requestURI = '/services/apexrest/updateClientId';
        request.httpMethod = 'PUT';
        request.requestBody = Blob.valueOf(jsonString);
        RestContext.request = request;

        String response = UpdateClientId.doPut();
        Test.stopTest();

        // Perform assertions on the response received
        System.assertEquals('The WCGT ID has been Successfully Updated', response);

        // Query the Account record to verify the update
        Account updatedAccount = [SELECT Id, WCGTId__c FROM Account WHERE Id = :testAccount.Id LIMIT 1];
        System.assertEquals('CN058312', updatedAccount.WCGTId__c);
    }
    
     @isTest
    static void testUpdateClientIds1() {
         Id clientRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Client').getRecordTypeId();
        Account testAccount = TestDataFactory.createAccountRecord();
        testAccount.Name = 'Deepak Sir';
        testAccount.RecordTypeId = clientRecordTypeId;
        testAccount.Status__c = 'Active';
        // acc1.GT_Client_Group__c = GtAcc.Id;
        testAccount.ClientAddress__City__s = 'Jaipur';
        testAccount.ClientAddress__CountryCode__s = 'IN';
        testAccount.ClientAddress__PostalCode__s = '789'; 
        testAccount.ClientAddress__StateCode__s = 'AS';
        testAccount.ClientAddress__Street__s = 'test,test';
        //acc1.Key_Account__c = True;
        insert testAccount;

        // Create a JSON string to simulate the request payload with SFDCRecordID as null
        String jsonStringNullSFDCRecordID = '{ "WCGTId": "CN058312", "SFDCRecordID": null }';

        // Simulate the HTTP request to the REST service with null SFDCRecordID
        Test.startTest();
        RestRequest requestNullSFDCRecordID = new RestRequest();
        requestNullSFDCRecordID.requestURI = '/services/apexrest/updateClientContactId';
        requestNullSFDCRecordID.httpMethod = 'PUT';
        requestNullSFDCRecordID.requestBody = Blob.valueOf(jsonStringNullSFDCRecordID);
        RestContext.request = requestNullSFDCRecordID;

        String responseNullSFDCRecordID = UpdateClientId.doPut();
        Test.stopTest();

        // Perform assertions on the response received for null SFDCRecordID
        System.assertEquals('The SFDC Record ID cannot be Blank or Empty', responseNullSFDCRecordID);
    
    }
    

}