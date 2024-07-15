@isTest
private class mcaCrossDirFormerWrapperTest {
    @isTest
    static void testParse() {
        String json = '{"statusCode": 200, "requestId": "123456", "result": [{"formerDirectors": [{"din": "DIN456", "name": "FormerDirector1", "designation": "CFO", "dateOfAppointment": "2019-01-01", "tenureEndDate": "2023-01-01", "pan": "PAN456", "tenureBeginDate": "2019-01-01"}], "name": "Company2", "dateOfIncorporation": "2018-01-01", "percent": 80.2, "directors": [{"din": "DIN789", "name": "Director2", "designation": "CTO", "dateOfAppointment": "2020-01-01", "tenureEndDate": "2024-01-01", "pan": "PAN789", "tenureBeginDate": "2020-01-01"}], "entityId": "Entity2", "kid": "KID456"}]}';

        mcaCrossDirFormerWrapper obj = mcaCrossDirFormerWrapper.parse(json);

        System.assertEquals(200, obj.statusCode);
        System.assertEquals('123456', obj.requestId);
        System.assertNotEquals(null, obj.result);
        System.assertEquals(1, obj.result.size());
        System.assertEquals('Company2', obj.result[0].name);

        // Add more assertions as needed to validate the parsed object's properties
        // For example:
        System.assertEquals('2018-01-01', obj.result[0].dateOfIncorporation);
        System.assertEquals(80.2, obj.result[0].percent);
        System.assertEquals('DIN456', obj.result[0].formerDirectors[0].din);
        System.assertEquals('FormerDirector1', obj.result[0].formerDirectors[0].name);
        // ... and so on
    }
}