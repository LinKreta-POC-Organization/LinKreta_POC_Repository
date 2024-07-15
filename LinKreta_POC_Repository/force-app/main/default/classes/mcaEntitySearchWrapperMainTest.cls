@isTest
public class mcaEntitySearchWrapperMainTest {
    
    
    @isTest
    static void testParse() {
        String json = '{"requestId": "123456", "statusCode": 200, "result": [{"kid": "1", "name": "Entity1", "type": "Type1", "status": "Active", "pans": ["pan1", "pan2"], "location": "Location1", "entityId": "ID1", "additionalEntityIds": [], "primaryName": "Primary", "secondaryName": "Secondary", "score": 0.75}]}';
        
        mcaEntitySearchWrapperMain obj = mcaEntitySearchWrapperMain.parse(json);
        
        System.assertEquals('123456', obj.requestId);
        System.assertNotEquals(null, obj.result);
    }
    
    
}