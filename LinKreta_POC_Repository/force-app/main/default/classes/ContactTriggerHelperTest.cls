@isTest
public class ContactTriggerHelperTest {
    
    @isTest
    static void testSendDSTeamApprovalRequest() {
        
        // Create test data for Contact records
        List<Contact> testContacts = new List<Contact>();
        
        Entity_Type_Master__c entityTypeMasterRec = TestDataFactory.createEntityTypeMaster();
        insert entityTypeMasterRec;
        
        List<Account> accountList =new List<Account>();

        Account keyAccount = TestDataFactory.createAccountRecord();
        keyAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Key Account').getRecordTypeId();
        keyAccount.VerrifiedByDSTeam__c = false;
        keyAccount.DS_Team_Approval_Status__c = 'Pending with DS';
        accountList.add(keyAccount);
        
        Account gtClientGroupAccoount = TestDataFactory.createAccountRecord();
        gtClientGroupAccoount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('GT_Client_Group').getRecordTypeId();
        accountList.add(gtClientGroupAccoount);       

        Account acc = TestDataFactory.createAccountRecord();
        acc.Country_Corridor__c = 'Afghanistan';
        acc.Corridor__c ='NA';
        acc.Status_DS_Team_Remark_Status__c = 'Pending';
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Client').getRecordTypeId();
        acc.DS_Team_Approval_Status__c ='DS Approved';
        acc.GT_Client_Group__c = accountList[1].Id;
        acc.Website ='WWW.google.com';
        acc.Industry__c ='Banking';
        acc.SubIndustry__c ='Investment banking';
        acc.Status__c ='Active';
        acc.is_Address_filled__c = false;
        accountList.add(acc);
        insert accountList;
        
        //insert acc;
        User user = TestDataFactory.createUserRecord();
        insert user;
        
        Location__c locationRecord = new Location__c();
        locationRecord.Region__c = 'WEST';
        locationRecord.Location_Id__c = 'LC000021';
        insert locationRecord;  
        
        Campaign campaign = TestDataFactory.createCampaign();    
        //campaign.Campaign_Owner__c = user.Id;
        insert campaign;
        
        Contact contactRecord = TestDataFactory.createContact();
        System.debug('Acc Industry : ' + accountList[2].Industry__c);
        contactRecord.AccountId = accountList[2].Id;
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
        contactRecord.OwnerId = user.Id;
        contactRecord.RelationshipOffice__c = locationRecord.Id;
        contactRecord.Pick_Record__c = false;
        contactRecord.is_Address_filled__c  = false;
        contactRecord.IsPardot__c = '';
        insert contactRecord;
                
        contactRecord.DS_Team_Approval_Status__c = 'DS Approved';
        //contactRecord.IsPardot__c = true;
        contactRecord.KeyContactIdentifier__c = 'BOD';
        contactRecord.Pick_Record__c = true;
        contactRecord.IsPardot__c = 'Pardot';
        contactRecord.Contact_status__c = 'Active';
        testContacts.add(contactRecord);
        
        upsert testContacts;
        
        Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
        //req1.setComments('Submitting request for approval.');
        req1.setObjectId(contactRecord.id);
        
        req1.setSubmitterId(user.Id); 
        
        req1.setProcessDefinitionNameOrId('DS_Team_Contact_Approval');
        req1.setSkipEntryCriteria(true);
        
        Approval.ProcessResult result = Approval.process(req1);
        
        try{
            List<ProcessInstanceWorkitem> workItems = [
                SELECT Id, ProcessInstanceId 
                FROM ProcessInstanceWorkitem 
                WHERE ProcessInstance.TargetObjectId = : contactRecord.Id
            ];
            List<Approval.ProcessWorkitemRequest> requests = new List<Approval.ProcessWorkitemRequest>();
            for(ProcessInstanceWorkitem workItem : workItems){
                Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
                req.setWorkitemId(workItem.Id);
                //Valid values are: Approve, Reject, or Removed. 
                //Only system administrators can specify Removed.
                req.setAction('Approve');
                //req.setComments('Your Comment.');
                requests.add(req);
            }
            Approval.ProcessResult[] processResults = Approval.process(requests);
        }
        catch(Exception e){
            System.debug('Approval Error : ' + e.getMessage());
            // System.assertEquals(e.getMessage(), ConstantUtility.Comment_Mandatory_Message);
            
        }
        
        
    }
      
}