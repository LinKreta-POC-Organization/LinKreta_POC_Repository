@isTest
public class GenericLookupControllerTest {
	@isTest
    public static void test_Method(){
        Account keyAccount =TestDataFactory.createAccountRecord();
        keyAccount.Name ='testKey Account team';
        keyAccount.RecordTypeId =   Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get(ConstantUtility.KEY_ACCOUNT).getRecordTypeId();
        insert keyAccount;
        
        GenericLookupController.SearchWrapper inputWrp = new GenericLookupController.SearchWrapper();
        inputWrp.objectApiName = 'Account';
        inputWrp.fieldApiName = 'Name';
        inputWrp.otherFieldApiName = 'Website';
        inputWrp.searchString = 'Test';
        inputWrp.selectedRecordId = keyAccount.Id;
        inputWrp.parentRecordId = '';
        inputWrp.parentFieldApiName = '';
        inputWrp.filter = '';
        
        GenericLookupController.SearchWrapper inputWrp2 = new GenericLookupController.SearchWrapper();
        inputWrp2.objectApiName = 'Account';
        inputWrp2.fieldApiName = 'Name';
        inputWrp2.otherFieldApiName = 'Website';
        inputWrp2.searchString = 'Test';
        inputWrp2.selectedRecordId = '';
        inputWrp2.parentRecordId = '';
        inputWrp2.parentFieldApiName = '';
        inputWrp2.filter = '';
        
        GenericLookupController.fetchRecords(inputWrp,'','');
        GenericLookupController.fetchRecords(inputWrp2,'','');
        GenericLookupController.RecentRecords(inputWrp,'','');
    }
}