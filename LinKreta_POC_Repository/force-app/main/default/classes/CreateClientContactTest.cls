@isTest
public class CreateClientContactTest {
	 @isTest static void testCreateClientContact(){
        
        Lead leadRec = TestDataFactory.createLeadRecord();
        Insert leadRec;
         
        Test.setMock(HttpCalloutMock.class, new CreateClientContactMockCallout());
        Test.startTest();
         try{
            // createClientContact.createContactFromCAPIQBOD(leadRec.Id,'IQ40311193','Lead');
            // createClientContact.createContactFromCAPIQBODIndividual(leadRec.Id,'IQ40311193','Lead');
         }catch(Exception e){
             System.debug(e);
         }
        Test.stopTest();
        
     }
}