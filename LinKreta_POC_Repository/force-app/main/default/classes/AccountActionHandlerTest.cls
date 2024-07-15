@istest
public class AccountActionHandlerTest {
    @isTest(SeeAllData=True)
    public static void updateNPSOnAccount(){
         test.startTest();
        Account acc = Job_TestDataFactory.createAccountRecord();
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Client').getRecordTypeId();
        insert acc;
        
        Contact con = Job_TestDataFactory.createContactRecord();
        con.AccountId = acc.Id;
        insert con;
        
       
        

        User u1 = Job_TestDataFactory.createUserRecord('EMP1234','CEO','test0981@test.com');
        u1.Also_a_Job_Manager__c = true;
        insert u1;
        
        User u2 = Job_TestDataFactory.createUserRecord('EMP1235','CEO','test0982@test.com');
        insert u2;
        
        User u3 = Job_TestDataFactory.createUserRecord('EMP1236','CEO','test0983@test.com');
        insert u3;
        
        Currency_Code__c currCod = Job_TestDataFactory.createCurrencyCodeRecord();
        insert currCod;
        
        Contact contactRecord = TestDataFactory.createContact();
        contactRecord.FirstName = 'test contact';
        contactRecord.LastName = 'test contact';
        contactRecord.AccountId = acc.Id;
        contactRecord.Linkedin_URL__c = 'www.google.com';
        contactRecord.MobilePhone = '9876543210';
        contactRecord.Email = 'test@gmail.com';
        contactRecord.Designation__c = 'CEO';
        contactRecord.Salutation = 'Mr.';
        contactRecord.pi__campaign__c = 'Pratham campaign';
        contactRecord.Client_Location__City__s = 'TEST';
        contactRecord.Client_Location__CountryCode__s = 'US';
        contactRecord.Client_Location__PostalCode__s = '121002';
        contactRecord.Client_Location__StateCode__s = 'AL';
        contactRecord.Client_Location__Street__s = 'Test, street';
        contactRecord.Pick_Record__c = false;
        contactRecord.BOD_Flag__c = 'NO';
        contactRecord.Client_Contact_Record_Type__c = 'Client';
        contactRecord.WCGTId__c = '889';
        insert contactRecord;
         /* Start : Commented by Rakesh Kumar for Phase-1
     * 9/4/24
        IntegratedEnquiry__c igEnq = Job_TestDataFactory.createIntegratedEnquiryRecord();
        insert igEnq;

        Opportunity opp = Job_TestDataFactory.createEnquiryRecordForJob(acc.Id,igEnq.Id,null,u1.Id);
        opp.OwnerId = userInfo.getUserId();
        insert opp;
        
        Job__c job = Job_TestDataFactory.createJobRecord(opp.Id,acc.Id,'PS09192892',null);
        job.CSL__c = u1.Id;
        job.CO_CSL__c = u2.Id;
        job.BUL__c = u3.Id;
        job.Industry_Leader__c = u1.Id;
        insert job;
        
        //Job_TestDataFactory.Wrapper enquiryAndJob = Job_TestDataFactory.createJob();
        test.stopTest();
        Id communityId = [select Id from Network where Name = 'GT Survey'].Id;
        Survey Surveyrec = [Select Id,latestVersionId from Survey where Name = 'Net Promoter Score'];
        //Account acc = [SELECT Id FROM Account LIMIT 1];
        	 
        
        
        SurveyInvitation SInv = New SurveyInvitation();
        Sinv.CommunityId = communityId;
        SInv.Name = 'TestSurvey';
        SInv.OptionsCollectAnonymousResponse = false;
        SInv.OptionsAllowGuestUserResponse = true;
        SInv.SurveyId = Surveyrec.Id;
        SInv.ParticipantId = contactRecord.Id;
        SInv.Net_Promoter_Score__c = 6;
        SInv.Customer_Experience_Index__c = 6;
        SInv.Customer_Satisfaction_Index__c = 6;
        insert SInv;
        
        SurveySubject SS = new SurveySubject();
        SS.SubjectId = job.Id;
        SS.ParentId = SInv.Id;//
        SS.Name = 'TestSurvey';
        SS.Net_Promoter_Score__c = 6;
        SS.Customer_Experience_Index__c = 6;
        SS.Customer_Satisfaction_Index__c = 6;
        insert SS;
        
        SurveyInvitation SInv1 = New SurveyInvitation();
        Sinv1.CommunityId = communityId;
        SInv1.Name = 'TestSurvey';
        SInv1.OptionsCollectAnonymousResponse = false;
        SInv1.OptionsAllowGuestUserResponse = true;
        SInv1.SurveyId = Surveyrec.Id;
        SInv1.ParticipantId = contactRecord.Id;
        SInv1.Net_Promoter_Score__c = 7;
        SInv1.Customer_Experience_Index__c = 7;
        SInv1.Customer_Satisfaction_Index__c = 7;
        insert SInv1;
        
        SurveySubject SS1 = new SurveySubject();
        SS1.SubjectId = job.Id;
        SS1.ParentId = SInv1.Id;//
        SS1.Name = 'TestSurvey';
        SS1.Net_Promoter_Score__c = 7;
        SS1.Customer_Experience_Index__c = 7;
        SS1.Customer_Satisfaction_Index__c = 7;
        insert SS1;
        
        SurveyInvitation SInv2 = New SurveyInvitation();
        Sinv2.CommunityId = communityId;
        SInv2.Name = 'TestSurvey';
        SInv2.OptionsCollectAnonymousResponse = false;
        SInv2.OptionsAllowGuestUserResponse = true;
        SInv2.SurveyId = Surveyrec.Id;
        SInv2.ParticipantId = contactRecord.Id;
        SInv2.Net_Promoter_Score__c = 9;
        SInv2.Customer_Experience_Index__c = 9;
        SInv2.Customer_Satisfaction_Index__c = 9;
        insert SInv2;
        
        SurveySubject SS2 = new SurveySubject();
        SS2.SubjectId = job.Id;
        SS2.ParentId = SInv2.Id;//
        SS2.Name = 'TestSurvey';
        SS2.Net_Promoter_Score__c = 9;
        SS2.Customer_Experience_Index__c = 9;
        SS2.Customer_Satisfaction_Index__c = 9;
        insert SS2;

SurveyInvitationService.getSurveyInvitationByIds(new Set<String>{SInv2.Id});
        SurveyInvitationService.getSurveyInvitationByConIds(new Set<String>{contactRecord.Id});
        SurveyInvitationService.getSurveyInvitationByIds(new Set<String>{'contactRecord.Id'});
        


        AccountActionHandler.updateNPSOnAccount(new Set<String>{acc.Id});
        */
        //End Phase-1 : Commented by Rakesh Kumar for 
    }
}