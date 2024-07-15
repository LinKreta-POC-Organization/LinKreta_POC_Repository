@isTest
private class ErrorLogCreater_clsTest {
    @isTest static void testFlowDebugLogger(){
        List<String> debugMessages = new List<String>{'Test'};
            ErrorLogCreater_cls.flowDebugLogger(debugMessages);
    }
}