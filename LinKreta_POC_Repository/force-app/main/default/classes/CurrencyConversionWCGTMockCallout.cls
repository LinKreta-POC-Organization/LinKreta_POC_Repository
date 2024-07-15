public class CurrencyConversionWCGTMockCallout implements HttpCalloutMock{
    public HttpResponse respond(HTTPRequest req){
        HttpResponse res = new HttpResponse();
        res.setStatus('OK');
        res.setStatusCode(200);
        res.setBody('{"rates":"82","up_Date":"20-20-2023"}');
        return res;
    }
}