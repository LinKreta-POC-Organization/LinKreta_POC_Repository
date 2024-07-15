/*
AUTHOR                   : Deepak joshi
VERSION                  : 1
MODIFICATION DATE        : 28 september 2023
PROJECT NAME / TICKET #  : GT
DESCRIPTION              : AfterNameChangeNotifications test class
*/
@isTest
public  class AfterNameChangeNotificationsTest {
    @testSetup static void dataCreation() {
        Account gtClientGroupAccoount = TestDataFactory.createAccountRecord();
        gtClientGroupAccoount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('GT_Client_Group').getRecordTypeId();
        insert gtClientGroupAccoount ; 
        Account acc = TestDataFactory.createAccountRecord();
       
        acc.Country_Corridor__c = 'Afghanistan';
        acc.Corridor__c ='NA';
        acc.Status_DS_Team_Remark_Status__c = 'Pending';
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Client').getRecordTypeId();
        acc.DS_Team_Approval_Status__c ='Pending with DS';
        acc.GT_Client_Group__c = gtClientGroupAccoount.Id;
        acc.Website ='WWW.google.com';
        //acc.Industry__c ='Auto & Auto Components';
        //acc.SubIndustry__c ='Auto & Auto Components';
        insert acc;
        AccountTeamMember accountTeamMemberRec = TestDataFactory.createAccountTeamMember(acc.Id);
        accountTeamMemberRec.TeamMemberRole ='Key Account – CSL';
        accountTeamMemberRec.ContactAccessLevel ='Read';
        accountTeamMemberRec.OpportunityAccessLevel ='Edit';
        accountTeamMemberRec.CaseAccessLevel ='Edit';
       //insert accountTeamMemberRec;
        Contact contactRecord = TestDataFactory.createContactRecord();
        contactRecord.FirstName = 'test After Name chang';
        contactRecord.AccountId =acc.Id;
       // insert contactRecord;
           
        Lead leadRecord = TestDataFactory.createLeadRecord();
        leadRecord.ownerId =UserInfo.getUserId();
        insert leadRecord;

    }
    @isTest static void testAccountinvocable() {
        List<Account> accList = [SELECT Id FROM Account ];
        AfterNameChangeNotifications.invocable(new List<Id>{accList[1].Id} );
        System.assertEquals(2,accList.size());

    }
    
    
    @isTest static void testLeadinvocable() {
        lead leadRecord = [SELECT Id,OwnerId,Owner.Name FROM Lead LIMIT 1 ];
        System.debug('** test leadRecord  '+leadRecord);
        System.debug('** test leadRecord owne name '+leadRecord.Owner.Name);
        AfterNameChangeNotifications.invocable(new List<Id>{leadRecord.Id} );
        System.assertnotEquals(null,leadRecord);

    }
   
    
}