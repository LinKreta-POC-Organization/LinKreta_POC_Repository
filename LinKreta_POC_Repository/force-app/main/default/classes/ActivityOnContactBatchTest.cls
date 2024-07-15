@IsTest
public class ActivityOnContactBatchTest {
	
    
   //@IsTest(SeeAllData=true)
    /*Public static void testBatchClass(){
        //List<Contact> conList = [SELECT Id ,AccountId,Name ,LastActivityDate FROM Contact WHERE LastActivityDate < Last_N_Days : 15];
        //System.debug('conact list '+conList);
        Test.startTest();
        //ActivityOnContactBatch obje = new ActivityOnContactBatch();
        //Database.executeBatch(obje,1);

        
       /* String cronExp = '0 0 23 * * ?';
        ScheduledActivityOnContactBatch scheduledObje = new ScheduledActivityOnContactBatch();
        System.schedule('Test Student Status Update1', cronExp, scheduledObje);*/
       // Test.stopTest();
    //}*/
    @isTest static void testInsertContact() {
        Test.startTest();
        Account gtClientGroupAccoount = TestDataFactory.createAccountRecord();
        gtClientGroupAccoount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('GT_Client_Group').getRecordTypeId(); 
        gtClientGroupAccoount.Name = 'yon test mjj';
        insert gtClientGroupAccoount ;

        Account acc = TestDataFactory.createAccountRecord();
            acc.Country_Corridor__c = 'Afghanistan';
            acc.Corridor__c ='NA';
            acc.Status_DS_Team_Remark_Status__c = 'Pending';
            acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Client').getRecordTypeId();
            acc.DS_Team_Approval_Status__c ='Pending with DS';
            acc.GT_Client_Group__c = gtClientGroupAccoount.Id;
            acc.Website ='WWW.google.com';
            acc.Industry__c ='Agriculture';
            //acc.SubIndustry__c ='Agricultural productss';
            acc.Status__c ='Active';
    
            acc.ClientAddress__Street__s = 'test,test';
            acc.ClientAddress__City__s ='test';
            acc.ClientAddress__PostalCode__s ='12345';
            acc.ClientAddress__StateCode__s ='CT' ;
            acc.ClientAddress__CountryCode__s =  'IN';
            insert acc;

            AccountTeamMember solutionOBJ = TestDataFactory.createAccountTeamMember(gtClientGroupAccoount.Id);
            solutionOBJ.TeamMemberRole = 'Solution Expert';
            solutionOBJ.CaseAccessLevel = 'Read';
            solutionOBJ.ContactAccessLevel = 'Read';
            solutionOBJ.OpportunityAccessLevel = 'Edit';
            solutionOBJ.AccountId = acc.Id;
            solutionOBJ.userId =UserInfo.getUserId();
            insert solutionOBJ;

        Location__c locationRecord = new Location__c();
        locationRecord.Region__c = 'WEST';
        locationRecord.Location_Id__c = 'LC000021';
        insert locationRecord; 
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
        //contactRecord.OwnerId = user.Id;
        contactRecord.RelationshipOffice__c = locationRecord.Id;
        contactRecord.Pick_Record__c = false;
        insert contactRecord;


        Task t = new Task(

        WhoId = contactRecord.id,

        Subject = 'Test',

        ActivityDate = Date.today().addDays(-17),

        Status = 'Completed',
        Comments__c ='test'

        );
        insert t;
        List<Contact> conList = [SELECT Id ,AccountId,Name ,LastActivityDate FROM Contact];
        System.debug('** Test conList  '+conList);

        
        //ActivityOnContactBatch obje = new ActivityOnContactBatch();
        //Database.executeBatch(obje,1);

        
        String cronExp = '0 0 23 * * ?';
        ScheduledActivityOnContactBatch scheduledObje = new ScheduledActivityOnContactBatch();
        System.schedule('Test Student Status Update1', cronExp, scheduledObje);
        Test.stopTest();
    }
    
    
}