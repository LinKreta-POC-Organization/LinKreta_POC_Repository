public class MockClassForEAPartner implements HttpCalloutMock {
    public Integer code;
    public String status;
    public String body;
    public MockClassForEAPartner(Integer code, String status, String body) {
        this.code = code;
        this.status = status;
        this.body = body;
    }
    public HTTPResponse respond(HTTPRequest request) {
        // Create a fake response
        HttpResponse response = new HttpResponse();
        String strbody = body;
        if(strbody == null) {
            if(request.getEndpoint().contains('/services/oauth2/')) {
                strBody = '{ "access_token": "00DBi000000osBh!AQEAQDMWYjKXbeoGUMDFlIE89uZCHC3ktt.Q6hmWNSZMtEZzpCCG3w400crOv21YoMn7pQmP_X74wWaV4xGTo7teZ7AZ3Zss", "instance_url": "https://test.salesforce.com", "id": "https://test.salesforce.com/id/00DBi000000osBhMAI/0055j000005XLUTA11", "token_type": "Bearer", "issued_at": "1717589921011", "signature": "pi+SSlhE+k+ToECaq3G1vX8+T3mRNMdjG7OncNrYnqqq" }';
            }else {
                strbody = '[ { "id": "005Bi000002lAkMIaa", "success": true, "errors": [], "created": false } ]';                                
            }
        }
        response.setBody(strbody);
        response.setStatusCode(this.code);
        response.setStatus(this.status);
        return response;


    }
}