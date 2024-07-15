@isTest
private class mcaCrossDirCurrentWrapperTest {
    @isTest
    static void testParse() {
        String json = '{"statusCode": 200, "requestId": "123456", "result": [{"name": "Company1", "dateOfIncorporation": "2020-01-01", "percent": 75.5, "directors": [{"din": "DIN123", "name": "Director1", "designation": "CEO", "dateOfAppointment": "2021-01-01", "tenureEndDate": "2025-01-01", "pan": "PAN123", "tenureBeginDate": "2021-01-01"}], "entityId": "Entity1", "kid": "KID123"}]}';

        mcaCrossDirCurrentWrapper obj = mcaCrossDirCurrentWrapper.parse(json);

        System.assertEquals(200, obj.statusCode);
        System.assertEquals('123456', obj.requestId);
        System.assertNotEquals(null, obj.result);
       /* System.assertEquals(1, obj.result.size());
        System.assertEquals('Company1', obj.result[0].name);

        // Add more assertions as needed to validate the parsed object's properties
        // For example:
        System.assertEquals('2020-01-01', obj.result[0].dateOfIncorporation);
        System.assertEquals(75.5, obj.result[0].percent);
        System.assertEquals('DIN123', obj.result[0].directors[0].din);
        System.assertEquals('Director1', obj.result[0].directors[0].name);
        // ... and so on */
    }
}