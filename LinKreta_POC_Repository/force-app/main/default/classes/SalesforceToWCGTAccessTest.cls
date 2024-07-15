@isTest
public class SalesforceToWCGTAccessTest {
    
    @isTest
    public static void getAuthenticationToken(){
        GenericMockClass mock= new GenericMockClass (200,'success','{"statusCode":"200","statusMsg":"Record inserted Successfully","data":""}');
        Test.setMock(HttpCalloutMock.class,mock);
        SalesforceToWCGTAccess.getAuthenticationToken();
    }
}