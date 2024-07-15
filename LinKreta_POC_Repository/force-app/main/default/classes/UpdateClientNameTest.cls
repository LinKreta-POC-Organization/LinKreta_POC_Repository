@isTest 
private class UpdateClientNameTest {
    @testSetup static void setupData(){
        Account keyAccount = TestDataFactory.createAccountRecord();
        keyAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Key Account').getRecordTypeId();
        keyAccount.VerrifiedByDSTeam__c = false;
        keyAccount.DS_Team_Approval_Status__c ='Pending with DS';
        keyAccount.Segment__c = 'Government';
        keyAccount.Sub_Segment__c = 'Government';
        Insert keyAccount;
    }
    
    @isTest static void updateName() {
        Account accountObj =[SELECT Id,IsNameChange__c FROM Account LIMIT 1];
        UpdateClientName.updateName(accountObj);
    }
}