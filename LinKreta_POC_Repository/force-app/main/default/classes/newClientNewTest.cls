@isTest
public class newClientNewTest {
    @testSetup 
    static void dataCreation() { 
        GenericMockClass mock= new GenericMockClass (200,'success','{"statusCode":"200","statusMsg":"Record inserted Successfully","data":""}');
        Test.setMock(HttpCalloutMock.class,mock);
        Account acc =TestDataFactory.createAccountRecord();
        acc.Industry__c = 'Banking';
        acc.Name ='TATA';
        insert acc;

    }
    @isTest static void ClientNewSearch(){
        String body ='{"GDSSDKResponse":[{"ErrMsg":"","Headers":["IQ_COMPANY_NAME_QUICK_MATCH","AsOfDate"],"NumRows":5,"Seniority":"","Properties":{"endrank":"5","startrank":"1"},"EndDate":"","CacheExpiryTime":"0","StartDate":"","Function":"GDSHE","Identifier":"TATA","NumCols":2,"Mnemonic":"IQ_COMPANY_NAME_QUICK_MATCH","Frequency":"","Limit":"","Rows":[{"Row":["Tata Steel Limited",""]},{"Row":["Tata Motors Limited",""]},{"Row":["Tata Consultancy Services Limited",""]},{"Row":["The Tata Power Company Limited",""]},{"Row":["Tata Sons Private Limited",""]}]}]}';
        GenericMockClass mock= new GenericMockClass (200,'success',body);
        Test.setMock(HttpCalloutMock.class,mock);
        Test.startTest();
        newClientNew.ClientNewSearch('TATA');
        Test.StopTest();
    }
    @isTest static void tempClientNewSearch(){
        GenericMockClass mock= new GenericMockClass (200,'success','{"statusCode":"200","statusMsg":"Record inserted Successfully","data":""}');
        Test.setMock(HttpCalloutMock.class,mock);
        Test.startTest();
        newClientNew.tempClientNewSearch('TA TA');
        Test.StopTest();
    }
    @isTest static void tempClientNewSearch1(){
        GenericMockClass mock= new GenericMockClass (200,'success','{"statusCode":"200","statusMsg":"Record inserted Successfully","data":""}');
        Test.setMock(HttpCalloutMock.class,mock);
        Test.startTest();
        newClientNew.tempClientNewSearch('TATA');
        newClientNew.getExpertise();
        Test.StopTest();
    }
    
    
}