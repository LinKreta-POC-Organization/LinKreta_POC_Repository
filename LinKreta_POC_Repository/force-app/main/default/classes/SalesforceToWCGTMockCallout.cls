public class SalesforceToWCGTMockCallout implements HttpCalloutMock{
    public HttpResponse respond(HTTPRequest req){
        HttpResponse res = new HttpResponse();
        res.setStatus('OK');
        res.setStatusCode(200);
        res.setBody('{"statusCode":"200","statusMsg":"Record inserted Successfully","data":""}');
        return res;
    }
    
}