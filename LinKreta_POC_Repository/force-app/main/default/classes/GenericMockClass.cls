public class GenericMockClass implements HttpCalloutMock {
    public Integer code;
    public String status;
    public String body;
    public GenericMockClass(Integer code, String status, String body) {
        this.code = code;
        this.status = status;
        this.body = body;
    }
    public HTTPResponse respond(HTTPRequest request) {
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setBody(this.body);
        response.setStatusCode(this.code);
        response.setStatus(this.status);
        return response;


    }
}