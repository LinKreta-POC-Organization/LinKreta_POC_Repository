@isTest
public class SendEmailFromFlowTest {
	@isTest
    public static void sendEmailTest(){
        
        Account keyAccount =TestDataFactory.createAccountRecord();
        keyAccount.Name ='testKey Account team';
        keyAccount.RecordTypeId =   Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get(ConstantUtility.KEY_ACCOUNT).getRecordTypeId();
        keyAccount.AccountType__c ='Key Client';
        keyAccount.Status__c='Active';
        insert keyAccount;
        
        Contact contactRecord = TestDataFactory.createContact();
        contactRecord.FirstName = 'test facontactsfa';
        contactRecord.LastName = 'test contact';
        contactRecord.AccountId = keyAccount.Id;
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
     //   contactRecord.RelationshipOffice__c = locationRecord.Id;
        insert contactRecord;
        
        // Create a test EmailTemplate
        EmailTemplate validEmailTemplate;
            System.runAs(new User(Id = UserInfo.getUserId())) {
                validEmailTemplate  = new EmailTemplate();
                validEmailTemplate.isActive = true;
                validEmailTemplate.Name = 'Email_Test_Template';
                validEmailTemplate.DeveloperName = 'Email_Test_Template';
                validEmailTemplate.TemplateType = 'Text';
                validEmailTemplate.FolderId = UserInfo.getUserId();
                
                UPsert validEmailTemplate;
            }
       // Job_TestDataFactory.Wrapper enquiryAndJob = Job_TestDataFactory.createJob();
        SendEmailFromFlow.InputWrapper inputWrapper = new SendEmailFromFlow.InputWrapper();
        inputWrapper.recipientIds = new List<Id>{UserInfo.getUserId()};
        inputWrapper.emailTemplateName = 'Email_Test_Template';
        inputWrapper.whatId = contactRecord.Id; 
        List<SendEmailFromFlow.InputWrapper> inputWrappers = new List<SendEmailFromFlow.InputWrapper>{
            inputWrapper
        };
        // Call the sendEmails method
        Test.startTest();
        SendEmailFromFlow emailObj = new SendEmailFromFlow();
        SendEmailFromFlow.sendEmails(inputWrappers);
        SendEmailFromFlow.getContact();
       /* try{
            SendEmailFromFlow.deleteContact(contactRecord.Id);
        	
        }catch(Exception e){
            
        }*/
        Test.stopTest();
    }
}