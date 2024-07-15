@isTest
public class AutocreatedRegHandlerTest {
    @testSetup
    public static void createTestData(){
        User userRecord = TestDataFactory.createUserRecord();
        userRecord.FederationIdentifier = 'testx.t@gmail.com';
        insert userRecord;
    }
    
    @isTest
    static void testCanCreateUser() {
        // Test canCreateUser method with different scenarios
        
        Auth.UserData sampleData= new Auth.UserData('goodidentifier', 'firstName', 'lastName', 'fullName', 'testx.t@gmail.com', 
        null, null, 'en', 'provider', null, null);
        User userRecord = [SELECT Id, Name, FederationIdentifier FROM User WHERE FederationIdentifier =: sampleData.email];
        
        Test.startTest();
        AutocreatedRegHandler1665556914174 regHandler = new AutocreatedRegHandler1665556914174();
        regHandler.canCreateUser(sampleData);
        regHandler.createUser(null, sampleData);
        regHandler.updateUser(userRecord.Id, null, sampleData);
        Test.stopTest();
        
    }
    
}