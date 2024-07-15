@isTest
public class SendNotificationToRelationshipTeamTest {
    
    @testSetup static void dataCreation() {
        Account acc = TestDataFactory.createAccountRecord();
        insert acc;
        
        Contact con = TestDataFactory.createContactRecord();
        con.AccountId = acc.Id;
        insert con;
        
        Client_Contact_Relationship_Team__c RelationshipTeam = TestDataFactory.createClientContactRelationshipTeam(con.Id);
        
        Contact con1 = TestDataFactory.createContactRecord();
        con1.AccountId = acc.Id;
        con1.firstName='test12testff';
        con1.lastName='test12teiiff';
        insert con1;
        
        Client_Contact_Relationship_Team__c RelationshipTeam1 = TestDataFactory.createClientContactRelationshipTeam(con1.Id);
        insert RelationshipTeam1;
        
        
        
    }
    
    @isTest static void SendNotificationTest() {
        
        List<Contact> listOfContacts =  [SELECT Id,Name FROM Contact];
        List<Id> listOfContactsIds = new List<Id>();
        for(Contact con : listOfContacts){
            listOfContactsIds.add(con.Id);
        }
        List<SendNotificationToRealtionshipTeam.ActionRequest> listOfResp = new List<SendNotificationToRealtionshipTeam.ActionRequest>();
        EmailTemplate TemplateObj = [select Id,Name from EmailTemplate where DeveloperName =: 'Email_emplate_for_deassociation_of_client_Contact_Relationship_Team'];
        CustomNotificationType notificationType = [SELECT Id, DeveloperName FROM CustomNotificationType WHERE DeveloperName='NewClientOwnerChanged'];	
        List<String> listOfUserName = new List<String>();
        listOfUserName.add('bhavi basant');
        listOfuserName.add('bhavishya Basantwani');
        list<String> listOfRelatedRec = new list<String>();
        listOfRelatedRec.add('Future And Company');
        listOfRelatedRec.add('Future And Company');
       
        
        SendNotificationToRealtionshipTeam.ActionRequest ResObj = new SendNotificationToRealtionshipTeam.ActionRequest();
        ResObj.ContactIds = listOfContactsIds;
        ResObj.CustomNotification = notificationType.Id;
        ResObj.NotificationType = 'Association';
        ResObj.RelatedRecName = listOfRelatedRec;
        ResObj.TemplateId = TemplateObj.Id;
        ResObj.UserName = listOfuserName;
        
        listOfResp.add(ResObj);
        SendNotificationToRealtionshipTeam.SendNotification(listOfResp);
        System.assertEquals(2 , listOfContacts.size() , 'successfull');
 }
    
}