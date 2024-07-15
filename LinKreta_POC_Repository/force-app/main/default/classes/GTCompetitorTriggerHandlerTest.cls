@isTest
public class GTCompetitorTriggerHandlerTest {
    /*
    @testSetup 
    static void dataCreation() { 
        GenericMockClass mock= new GenericMockClass (200,'success','{"statusCode":"200","statusMsg":"Record inserted Successfully","data":""}');
        Test.setMock(HttpCalloutMock.class,mock);

        Account gtClientGroupAccoount = TestDataFactory.createAccountRecord();
        gtClientGroupAccoount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('GT_Client_Group').getRecordTypeId();
        insert gtClientGroupAccoount ;
        Account acc =TestDataFactory.createAccountRecord();
        acc.Status__c='Active';
        acc.Country_Corridor__c = 'Afghanistan';
        acc.Corridor__c ='NA';
        acc.Status_DS_Team_Remark_Status__c = 'Pending';
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Client').getRecordTypeId();
        acc.DS_Team_Approval_Status__c ='Pending with DS';
        acc.GT_Client_Group__c = gtClientGroupAccoount.Id;
        acc.Website ='WWW.google.com';
        acc.Industry__c ='Agriculture';

        acc.ClientAddress__Street__s = 'test,test';
        acc.ClientAddress__City__s ='test';
        acc.ClientAddress__PostalCode__s ='12345';
        acc.ClientAddress__StateCode__s ='CT' ;
        acc.ClientAddress__CountryCode__s =  'IN';
        acc.capIQId__c ='test';

        insert acc;

        IntegratedEnquiry__c intg =TestDataFactory.createIntegratedEnquiryRecord();
        intg.Industry__c = '';
        intg.Expected_Proposal_Submission_Date__c =System.today();
        intg.CloseDate__c=System.today();
        intg.Attachment__C= true;
        intg.Type_of_document__C=ConstantUtility.PITCH_PRESENTATION;
        insert intg;

        Profile pf= [Select Id from profile where Name='System Administrator']; 
        String orgId=UserInfo.getOrganizationId(); 
        String dateString=String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','') ;
        Integer RandomId=Integer.valueOf(Math.rint(Math.random()*1000000)); 
        String uniqueName=orgId+dateString+RandomId; 
        User testUser=new User(firstname = 'ABC', 
                         lastName = 'XYZ', 
                         email = uniqueName + '@test' + orgId + '.org', 
                         Username = uniqueName + '@test' + orgId + '.org', 
                         EmailEncodingKey = 'ISO-8859-1', 
                         Alias = uniqueName.substring(18, 23), 
                         TimeZoneSidKey = 'America/Los_Angeles', 
                         LocaleSidKey = 'en_US', 
                         LanguageLocaleKey = 'en_US', 
                         ProfileId = pf.Id
                        ); 
        insert testUser;
        //System.runAs(testUser) {
        List<User> user= [SELECT Id, Name, IsActive FROM User  WHERE  IsActive =true AND   Id IN (SELECT UserOrGroupId FROM GroupMember  WHERE Group.DeveloperName =:ConstantUtility.GROUP_CM_TEAM OR Group.DeveloperName =:ConstantUtility.GROUP_CRM_TEAM) LIMIT 1];
        System.debug('** test user  '+user);
        if(user.size()> 0){
                System.runAs(user[0]) {
                List<Opportunity> oppList = TestDataFactory.createEnquiryRecord(acc.Id,intg.Id,null);
                oppList[0].SubIndustry__c = null;
                oppList[0].Is_Fee_Arrangement_Letter_Uploaded__c = true;
                oppList[0].StageName =' Determine problem & impact';
                oppList[0].DS_Team_Status__c ='DS Approved';
                oppList[0].IndustryLeaderApprovalStatus__c ='Approved';
                oppList[0].OwnerId = testUser.Id;
            
                insert oppList[0];

                GT_Competitor__c testCompetitor = new GT_Competitor__c(
                    Name = 'Test Competitor',
                    Enquiry__c = oppList[0].Id
                );
                try{
                    insert testCompetitor;
                }
                catch(Exception e)
                {
                    String message = e.getMessage();
                    system.assert(message.contains(Label.Error_Message_Enquiry_Owner_Team_Member), 'message=' + message);
        
                }
            }
        }
    }
    */
    
    @isTest static void handleCompetitorRecords(){
        Test.startTest();
         GT_Competitor__c testCompetitor = new GT_Competitor__c(
                    Name = 'Test Competitor'
                );
        List<GT_Competitor__c> lstGtComp = new List<GT_Competitor__c>();
        lstGtComp.add(testCompetitor);
        GTCompetitorTriggerHandler.handleCompetitorRecords(lstGtComp);
        
        Test.StopTest(); 
    }
    @isTest static void testHandleCompetitorRecords(){
        Test.startTest();
       /* Opportunity opp =[SELECT Id,OwnerId FROM Opportunity LIMIT 1];
        OpportunityTeamMember oppTeam  =new OpportunityTeamMember();
        oppTeam.TeamMemberRole ='Relationship Leader';
        oppTeam.UserId =UserInfo.getUserId();
        oppTeam.OpportunityId =opp.Id;
        insert oppTeam;
*/
        
        Opportunity opp = new Opportunity();
        Map<Id, User> userOrGroupMap = new Map<Id, User>();
        Id userId = UserInfo.getUserId();
        GTCompetitorTriggerHandler.isUserInOpportunityTeam(opp,userId,userOrGroupMap);
        
        Test.StopTest(); 
    }
}