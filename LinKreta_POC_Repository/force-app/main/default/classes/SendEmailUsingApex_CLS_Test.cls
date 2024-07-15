@isTest
public class SendEmailUsingApex_CLS_Test {

    @isTest
    public static void testSendEmail() {
        testSendEmailWithValidData();
    }

    private static void testSendEmailWithValidData() {
        List<SendEmailUsingApex_CLS.processEmailRequest> emailRequests = TestDataFactory.createTestEmailRequests();
        List<Lead> leadList = new List<Lead>();
        Campaign cam = new Campaign();
        cam.Name = 'test';
        insert cam;
        Lead ld = TestDataFactory.createLeadRecord();
        leadList.add(ld);
        
        Test.startTest();
        SendEmailUsingApex_CLS.sendEmailEnquiryTeam(cam.Id,'www.google.com');
        SendEmailUsingApex_CLS.sendEmailTONCO(leadList);
        SendEmailUsingApex_CLS.execute(emailRequests);
        Test.stopTest();
        
    }
}