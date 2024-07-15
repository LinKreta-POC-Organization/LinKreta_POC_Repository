@isTest
public class AccountTeamMemberTriggerHelperTest {
    
    @isTest static void testUpdate() {
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
        


        Account keyAccount =TestDataFactory.createAccountRecord();
        keyAccount.Name ='testKey Account team';
        keyAccount.RecordTypeId =   Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get(ConstantUtility.KEY_ACCOUNT).getRecordTypeId();
        keyAccount.AccountType__c ='Key Client';
        keyAccount.Status__c='Active';
        insert keyAccount;
        
        /* Start : Commented by Rakesh Kumar for Phase-1    
     * 9/4/24
        IntegratedEnquiry__c integratedEnquiryRecord = TestDataFactory.createIntegratedEnquiryRecord();
        integratedEnquiryRecord.Client__c= keyAccount.Id;
        Insert integratedEnquiryRecord;
 End : : Commented by Rakesh Kumar for Phase-1  
*/

       
       
        List<AccountTeamMember> accountTeamMemberList =new List<AccountTeamMember>();
        
        AccountTeamMember coCSL = TestDataFactory.createAccountTeamMember(keyAccount.Id);
        coCSL.TeamMemberRole = 'Relationship Leader';
        coCSL.CaseAccessLevel = 'Read';
        coCSL.ContactAccessLevel = 'Read';
        coCSL.OpportunityAccessLevel = 'Edit';
        coCSL.userId =testUser.Id;
        accountTeamMemberList.add(coCSL);

        AccountTeamMember coyoungCSL = TestDataFactory.createAccountTeamMember(keyAccount.Id);
        coyoungCSL.TeamMemberRole = 'Young CSL';
        coyoungCSL.CaseAccessLevel = 'Read';
        coyoungCSL.ContactAccessLevel = 'Read';
        coyoungCSL.OpportunityAccessLevel = 'Edit';
        coyoungCSL.userId =testUser.Id;
        coyoungCSL.AccountId = keyAccount.Id;
        accountTeamMemberList.add(coyoungCSL);
       
        AccountTeamMember CTMFirst = TestDataFactory.createAccountTeamMember(keyAccount.Id);
        CTMFirst.TeamMemberRole = 'Key Account – CSL';
        CTMFirst.CaseAccessLevel = 'Read';
        CTMFirst.ContactAccessLevel = 'Read';
        CTMFirst.OpportunityAccessLevel = 'Edit';
        accountTeamMemberList.add(CTMFirst);
        insert accountTeamMemberList;

        
        
        Account gtClientGroupAccoount = TestDataFactory.createAccountRecord();
        gtClientGroupAccoount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('GT_Client_Group').getRecordTypeId();
        gtClientGroupAccoount.Key_Account_360__c =keyAccount.Id; 
        gtClientGroupAccoount.Name ='TEst gt yy';
        insert gtClientGroupAccoount ;

        AccountTeamMember solutionOBJ = TestDataFactory.createAccountTeamMember(gtClientGroupAccoount.Id);
            solutionOBJ.TeamMemberRole = 'Solution Expert';
            solutionOBJ.CaseAccessLevel = 'Read';
            solutionOBJ.ContactAccessLevel = 'Read';
            solutionOBJ.OpportunityAccessLevel = 'Edit';
            solutionOBJ.userId =UserInfo.getUserId();
            insert solutionOBJ;
        
       AccountShare share = new AccountShare();
       share.AccountId =keyAccount.Id;
       share.OpportunityAccessLevel ='Edit';
       share.RowCause ='Manual';
       share.UserOrGroupId =testUser.Id;
       share.AccountAccessLevel ='Edit';
        insert share;

        Test.startTest();
        //AccountTeamMember accTeam =[SELECT Id FROM AccountTeamMember LIMIT 1];
        coCSL.TeamMemberRole='Key Account – Co-CSL';
        update coCSL;

       // AccountTeamMember accTeam1 =[SELECT Id FROM AccountTeamMember WHERE TeamMemberRole = 'Young CSL' LIMIT 1];
        delete coyoungCSL;
        Test.stopTest();
        
        

        
            



        
    }
    
    /*@isTest static void testUpdate() {
        Test.startTest();
        AccountTeamMember accTeam =[SELECT Id FROM AccountTeamMember LIMIT 1];
        accTeam.TeamMemberRole='Key Account – Co-CSL';
        update accTeam;
        Test.stopTest();
    }
    @isTest static void testDelete() {
        Test.startTest();
        AccountTeamMember accTeam =[SELECT Id FROM AccountTeamMember WHERE TeamMemberRole = 'Young CSL' LIMIT 1];
        delete accTeam;
        Test.StopTest();
    }*/
    @isTest static void testData1() {
        Test.startTest();
        Account objAccount = TestDataFactory.createAccountRecord();
        objAccount.Status__c = 'Active';
        objAccount.AccountType__c ='Key Client';
        insert objAccount;
        objAccount.AccountType__c ='Key Client';
        update objAccount;
        /* Start : Commented by Rakesh Kumar for Phase-1    
     * 9/4/24
        IntegratedEnquiry__c objIE =TestDataFactory.createIntegratedEnquiryRecord();
        insert objIE;        
        Opportunity testEnquiry = TestDataFactory.createEnquiryRec(objAccount.Id, objIE.Id);
        insert testEnquiry;
        
        OpportunityTeamMember opp =new OpportunityTeamMember ();
        opp.TeamMemberRole = 'Young CSL';
        //opp.CaseAccessLevel = 'Read';
        //opp.ContactAccessLevel = 'Read';
        //opp.popportunityId =testEnquiry.Id;op
        opp.OpportunityId = testEnquiry.Id;
        opp.UserId =UserInfo.getUserId();
        insert opp;
 End : : Commented by Rakesh Kumar for Phase-1  
*/
        AccountTeamMember coyoungCSL = TestDataFactory.createAccountTeamMember(objAccount.Id);
        coyoungCSL.TeamMemberRole = 'Young CSL';
        coyoungCSL.CaseAccessLevel = 'Read';
        coyoungCSL.ContactAccessLevel = 'Read';
        coyoungCSL.OpportunityAccessLevel = 'Edit';
        insert coyoungCSL;
        delete coyoungCSL;

        

        Test.stopTest();

    
    }
    
    
}