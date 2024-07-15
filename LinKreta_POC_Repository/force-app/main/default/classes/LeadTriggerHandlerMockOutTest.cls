//Author : Gaurav Kumar
//Date   : 06-Sep-2023
//Description :AutoConvertLeads
@isTest
global class LeadTriggerHandlerMockOutTest implements HttpCalloutMock {
    
    global static HTTPResponse respond(HTTPRequest req) {
        String body = '{\"sFirstName\":\"Test\",\"sLastName\":\"yyyy\",\"sNewClientId\":\"00Q1s000004qOL3EAM\",\"sMobileNo\":\"+3764567865456\",\"sCompanyName\":\"AdaniGreenEnergyLimited\",\"sStatus\":\"1\",\"sStatusReason\":\"NSLApproved\",\"sUserId\":\"US000407\",\"sEmail\":\"abc@alc.com\"}';
        HttpResponse res = new HttpResponse ();
        res.setHeader('Content-Type','application/json');
        res.setStatusCode(200);
        res.setBody(body);
        return res;
    }
}