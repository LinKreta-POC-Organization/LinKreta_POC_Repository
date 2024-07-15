@isTest
private class AlertsDataCourtCaseWrapperTest {

    @isTest
    static void testParseMethod() {
        String sampleJSON = '{' +
            '"requestId": "12345",' +
            '"statusCode": 200,' +
            '"result": [' +
                '{' +
                    '"compoundableOrNonCompoundable": "Compoundable",' +
                    '"convictedDirectors": ["Director A", "Director B"],' +
                    '"courtCaseNumber": "CC1234",' +
                    '"dateOfFilingReceivingOfNotice": "2023-12-21"' +
                    // Add other fields as needed
                '}' +
            ']' +
        '}';

        alertsDataCourtCaseWrapper parsedData = alertsDataCourtCaseWrapper.parse(sampleJSON);

        System.assertEquals('12345', parsedData.requestId);
        System.assertEquals(200, parsedData.statusCode);
        System.assertEquals(1, parsedData.result.size());
        alertsDataCourtCaseWrapper.Result result = parsedData.result[0];
        System.assertEquals('Compoundable', result.compoundableOrNonCompoundable);
        System.assertEquals(2, result.convictedDirectors.size());
        // Add more assertions for other fields as needed
    }
}