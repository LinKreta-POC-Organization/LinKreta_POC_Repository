@isTest
private class KeyAlertAndDevForClietControllerTest {
     @testSetup static void testData(){
        User userRecord = TestDataFactory.createUserRecord();
        insert userRecord;
        
        Account accRecord  = TestDataFactory.createAccountRecordDetailed();
        insert accRecord;
         
         Client_News__c client_newsObj = new Client_News__c(
	Name = 'M&A Transaction Announcements',
	IQ_KEY_DEV_HEADLINE__c = 'Crompton Greaves Consumer Electricals Limited (NSEI:CROMPTON) entered into a scheme of arrangement to acquire the remaining 19% stake in Butterfly Gandhimathi Appliances Limited (BSE:517421)',
	IQ_KEY_DEV_TYPE__c = 'M&A Transaction Announcements',
	Key_Development_Date__c = system.today(),
	Client__c = accRecord.Id,
	ExternalDataSource__c = 'CapIQ');
 insert client_newsObj;
         
    }
    @isTest
    static void testGetClientNews() {
        
        List<Client_News__c> clientNewsList = [SELECT Id, Name ,Client__c, IQ_KEY_DEV_HEADLINE__c,IQ_KEY_DEV_TYPE__c,Key_Development_Date__c,Alert__c, Case_Number__c,convictedDirectors__c,remarks_details__c,severity__c From Client_News__c];
        String recordId = clientNewsList[0].Client__c;
        List<Client_News__c> lstclientNews = KeyAlertAndDevelopmentForClietController.getClientNews(recordId);
        KeyAlertAndDevelopmentForClietController KeyAlertAndDevelopmentForClietControllerObj = new KeyAlertAndDevelopmentForClietController();
        
     //   System.assertEquals(1, lstCase.size());
    }
}