@isTest
private class mcaAlertsWrapperTest {
    @isTest
    static void testParse() {
        String json = '{"statusCode": 200, "requestId": "123456", "result": {"alerts": {"alertSummary": {"severity": {"high": 2, "severe": 5, "medium": 10, "low": 15}, "details": {"entityAlerts": {"mcaProsecution": [{"violationSection": "Section A", "prosecutionSection": "Section X"}], "ibbi": [{"announcementPdfLink": "link1", "timestamp": "timestamp1", "applicantName": "Applicant 1", "dateOfPublicAnnouncement": "Date 1", "name": "Name 1"}]}}}, "alertList": [{"documentUrl": "url1", "detailsAsPerSource": [{"source": "Source 1", "details": [{"value": ["value1"], "label": "Label 1"}]}], "alert": "Alert 1", "lastUpdatedDate": "Date 1", "exists": true, "severity": "High"}]}}}';

        mcaAlertsWrapper obj = mcaAlertsWrapper.parse(json);

        System.assertEquals(200, obj.statusCode);
        System.assertNotEquals(null, obj.result);
       /* System.assertEquals('123456', obj.requestId);
        
        System.assertNotEquals(null, obj.result.alerts);

        // Add more assertions as needed to validate the parsed object's properties
        // For example:
        System.assertEquals(2, obj.result.alerts.alertSummary.severity.high);
        System.assertEquals(5, obj.result.alerts.alertSummary.severity.severe);
        System.assertEquals('Section A', obj.result.alerts.alertSummary.details.entityAlerts.mcaProsecution[0].violationSection);
        System.assertEquals('link1', obj.result.alerts.alertList[0].documentUrl);
        // ... and so on */
    }
}