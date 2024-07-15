@isTest
public class RetrySyncAPIBatch_Test {
	@isTest
    public static void Test_RetrySyncAPIBatch(){
        Account gtClientGroupAccount = TestDataFactory.createAccountRecord();
        gtClientGroupAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('GT_Client_Group').getRecordTypeId();
        insert gtClientGroupAccount;
        WCGTEndPoint__mdt metaRecord = WCGTEndPoint__mdt.getInstance('Client_Insert');
        String reqBody = '{"sYoungCSLId":"","sWebsite":"https://www.bing.com","sUserId":"US004848","sTotRevenue":"PS006127","sTotEmpNo":"PS006122","sSubSector":"SI000094","sStatus":"1","sSharedPaidUpCapital":"0","sSector":"SB000020","sPAN_No":"EWJPC4150M","sKeyAccountId":"","sKam_NonKam":"0","sFlag":"1","sEntityType":"PS001439","sCSLID":"","sCountryHQ":"PS001117","sCorridor":"PS080302","sCoCSLId":"","sClientType":"PS002114","sClientStreet":"new,side","sClientStateId":"ST000454","sClientSFID":"0011s00001t2aCBAAY","sClientPincode":"456782","sClientName":"Basin Dialysis, LLC","sClientGroupSFID":"0011s00001se1xdAAA","sClientGroupName":"AMITE","sClientCountryId":"CO000001","sClientCityId":"bhopal","sCategory_CX_GX":""}';
        HttpResponse res = new HttpResponse();
        res.setStatus('OK');
        res.setStatusCode(500);
        res.setBody('{"statusCode":"500","statusMsg":"Not Inserted","data":""}');
        
        API_Logger__c apiLog = API_LoggerCommonUtility.createAPILogger(gtClientGroupAccount.Id,reqBody,res.getBody(),res.getStatus(),'SalesforceToWCGT',metaRecord.URL__c,res.getStatusCode(),null,null);
        INSERT apiLog;
        
        apiLog.Total_Retries__c = 2;
        UPDATE apiLog;
        
        system.debug('apiLog:'+apiLog);
        
        ScheduleRetryAPISync testsche = new ScheduleRetryAPISync();
		String sch = '0 0 23 * * ?';
		system.schedule('Test status Check', sch, testsche );
        
        Test.setMock(HttpCalloutMock.class, new SalesforceToWCGTMockCallout());
        Database.executeBatch(new RetrySyncAPIBatch(),200);
        
    }
}