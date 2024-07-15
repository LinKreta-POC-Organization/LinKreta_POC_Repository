@istest
public class GetSobjectNameTest {
	@istest
    public static void getSObjectNameTest(){
        Account gtClientGroupAccoount = TestDataFactory.createAccountRecord();
        gtClientGroupAccoount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('GT_Client_Group').getRecordTypeId();
        insert gtClientGroupAccoount;
        List<Id> ids = new List<Id>{gtClientGroupAccoount.Id};
            
        List<GetSobjectName.Result> results = GetSobjectName.getSObjectName(ids);
        List<GetObjectDetailsFromRecordId.FlowResponse> results2 = GetObjectDetailsFromRecordId.getObjectDetails(ids);
        List<GetSobjectName.Result> results3 = GetSobjectName.getSObjectName(new List<ID>());
    }
}