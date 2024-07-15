/*Created Date : 9/11/2023
 * Author : Muskan Soni
 * Class Name : API_LoggerCommonUtilityTest
 * lastModification : Aman Vijay
*/
@istest
public class API_LoggerCommonUtilityTest {
    @testSetup
    public static void dataInsert(){
        API_Logger__c  logger = new API_Logger__c();
        logger.Request__c = 'Success';
        logger.Response__c = '{"message":"test","statusCode":"200"}';
        logger.Status__c = 'Success';
        logger.Class_Name__c = 'test';
        logger.End_Point__c = 'Success';
        logger.Status_Code__c = 200;
        logger.Message__c = 'test';
        insert logger;
        API_Logger__c  logger1 = new API_Logger__c();
        logger1.Request__c = 'Success';
        logger1.Response__c = '{"message":"test","statusCode":"200"}';
        logger1.Status__c = 'Success';
        logger1.Class_Name__c = 'test';
        logger1.End_Point__c = 'Success';
        logger1.Status_Code__c = 200;
        logger1.Message__c = 'test';
        insert logger1;
    }
    @istest
    public static void apiLogger(){
        list<API_Logger__c> apiLoggerList = [select id from API_Logger__c];
        test.startTest();
        API_LoggerCommonUtility.sendSyncFailedEmail(apiLoggerList);
        API_LoggerCommonUtility.createAPILogger(apiLoggerList[0].id,'test','Success','Success','test','test',200,'test');
        API_LoggerCommonUtility.createAPILogger(apiLoggerList[0].id,'test','{"message":"test","statusCode":"200"}','Success','test','test',200,'test',apiLoggerList[1].id);
        API_LoggerCommonUtility.createAPILogger(apiLoggerList[0].id, 'test', 'Success', 'Success', 'test','test',200);
        API_LoggerCommonUtility.createAPILogger(apiLoggerList[0].id, 'test', 'Success', 'test','test','200');
        test.stopTest();
        
    }

}