public class ELControllerTest_Mock implements HttpCalloutMock {
 public HTTPResponse respond(HTTPRequest req) {
            // Create a mock HTTP response with the desired payload
            HttpResponse response = new HttpResponse();
            response.setHeader('Content-Type', 'application/json');
            response.setBody('{"records": [{"Id": "mockId1","Quip_Template_URL__c": "mockId2" ,"Signing_Authority__c": "mockId2", "Account.Country_Corridor__c": "Australia" , "IntegratedEnquiry__c": "mockId2", "Entity__c": "GTAPL", "IntegratedEnquiry__r.Short_Description__c": "mockId2"}]}');
            response.setStatusCode(200);
            return response;
        }
}