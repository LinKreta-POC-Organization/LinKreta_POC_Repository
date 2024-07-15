@isTEst
public class MCAwrapperForMCASchedulesTest {
    @isTest static void testMCAwrapperForMCASchedules(){
        Test.startTest();
        String body ='{ "requestId": "013d55ba-7039-451b-8955-f6a2077e7512", "result": {}, "statusCode": 101 }';
        GenericMockClass mock= new GenericMockClass (200,'success',body);
        Test.setMock(HttpCalloutMock.class,mock);
        MCAwrapperForMCASchedules.parse(body);
        Test.stopTest();
    }

    
}