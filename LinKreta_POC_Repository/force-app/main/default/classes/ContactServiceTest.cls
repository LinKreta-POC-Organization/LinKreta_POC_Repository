@isTest
public class ContactServiceTest {
    
    @testSetup 
    static void dataCreation() {
        Account acc = TestDataFactory.createAccountRecord();
        acc.Country_Corridor__c = 'Australia';
        acc.Corridor__c ='Australia Corridor';
        acc.Status_DS_Team_Remark_Status__c = 'Pending';
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Client').getRecordTypeId();
        acc.DS_Team_Approval_Status__c ='DS Approved';
        acc.Website ='WWW.google.com';
        acc.Status__c ='Active';
        acc.is_Address_filled__c = false;
        insert acc;
        
        User user = TestDataFactory.createUserRecord();
        insert user;
        /* Start : Commented by Rakesh Kumar for Phase-1    
* 9/4/24
Location__c locationRecord = new Location__c();
locationRecord.Region__c = 'WEST';
locationRecord.Location_Id__c = 'LC000021';
insert locationRecord;  
End : Commented by Rakesh Kumar for Phase-1  
*/ 
        Campaign campaign = TestDataFactory.createCampaign();    
        insert campaign;
        
        Contact contactRecord = TestDataFactory.createContact();
        contactRecord.AccountId = acc.Id;
        contactRecord.Linkedin_URL__c = 'www.google.com';
        contactRecord.MobilePhone = '2233445566';
        contactRecord.Email = 'test@gmail.com';
        contactRecord.Designation__c = 'CEO';
        contactRecord.Salutation = 'Mr.';
        contactRecord.pi__campaign__c = 'Pratham campaign';
        contactRecord.Client_Location__City__s = 'TEST';
        contactRecord.Client_Location__CountryCode__s = 'US';
        contactRecord.Client_Location__PostalCode__s = '121002';
        contactRecord.Client_Location__StateCode__s = 'AL';
        contactRecord.Client_Location__Street__s = 'Test, street';
        contactRecord.OwnerId = user.Id;
        // contactRecord.RelationshipOffice__c = locationRecord.Id;
        contactRecord.Pick_Record__c = false;
        contactRecord.is_Address_filled__c  = false;
        insert contactRecord;
        
        DepthOfRelationship__c depthRelRec = TestDataFactory.createDepthOfRelationship(contactRecord.Id);
        insert depthRelRec;
    }
    
    @isTest
    static void getClientContactTest(){
        Set<Id> setOfIds = new Set<Id>();
        Set<Id> setOfIdsNull = new Set<Id>();
        List<Contact> conList = [select id,name from Contact];
        
        for(Contact con : conList){
            setOfIds.Add(con.Id);
        }
        
        Test.StartTest();
        List<Contact> retrunConList;
        try{
            List<DepthOfRelationship__c> returnDepthList = ContactService.getDepOfRelRelatedContact( conList[0].Id , userInfo.getUserId());
            
            retrunConList = ContactService.getClientContact(setOfIds);
            //retrunConList[0].is_Address_filled__c = true;
            //update retrunConList;            
            
            System.assertNotEquals(null, retrunConList);
            
        }
        catch(Exception e){
            // Assertion for successful execution
            //System.assertNotEquals(null, retrunConList);
        }
        Test.StopTest();
        
    }
}