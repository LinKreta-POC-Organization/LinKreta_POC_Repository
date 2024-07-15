/*
* @Name: SendNotificationToRealtionshipTeam
* @Author: Bhavishya Basantwani
* @Description: This class is used for Send Notifcation to Client Contact Relationship Team.
* @Date: 14th-september-23
*/
public class SendNotificationToRealtionshipTeam {
    @InvocableMethod()
    public static void SendNotification(List<ActionRequest> getInfo){
       
       /* Set<String> setOfContactIds = new Set<String>(getInfo[0].ContactIds);
        
        List<Contact> ContactList = [SELECT Id,Name FROM Contact WHERE Id IN :setOfContactIds];
        
         Map<Id,Contact> MapOfContact = new Map<Id,Contact>();
        
        for(Contact con : ContactList){
            If(!MapOfContact.containsKey(con.Id)){
                MapOfContact.put(con.Id,con);
            }
        }
        
        
        Map<Id,Set<Client_Contact_Relationship_Team__c>> MapOfRelationTeam = new Map<Id,Set<Client_Contact_Relationship_Team__c>>();
        
        List<Client_Contact_Relationship_Team__c> listOfRealtionshipTeam = [SELECT Id,Name,Role__c,User__c,Client_Contact__c FROM Client_Contact_Relationship_Team__c WHERE Client_Contact__c =: setOfContactIds];
        
        for(Client_Contact_Relationship_Team__c Team : listOfRealtionshipTeam){
            if(MapOfRelationTeam.containsKey(Team.Client_Contact__c)){
                MapOfRelationTeam.get(Team.Client_Contact__c).add(Team);
            }
            else{
                MapOfRelationTeam.put(Team.Client_Contact__c,new set<Client_Contact_Relationship_Team__c>{Team});
            }
        }
        
        
        List<Messaging.SingleEmailMessage> emailList = new List<Messaging.SingleEmailMessage>();
        //For(integer i=0 ; i<mapOfAccount.RecId.size(); i++){
        Messaging.SingleEmailMessage mail = Messaging.renderStoredEmailTemplate(getInfo[0].TemplateId, UserInfo.getUserId() ,listOfRealtionshipTeam[0].Client_Contact__c );
        String baseUrl = URL.getOrgDomainURL().toExternalForm();
		system.debug('baseUrl'+baseUrl);
        String Link;                                          
        For(Id key : MapOfRelationTeam.keySet()){
            
            // notifcation
            String bodyAndTitle ;
            Messaging.CustomNotification notification = new Messaging.CustomNotification();
            
            Contact ConObj = MapOfContact.get(key);
            
            set<String> SetOfUserId = new set<String>();
            Set<Client_Contact_Relationship_Team__c> varRelationshipTeam = MapOfRelationTeam.get(key);
            for(Client_Contact_Relationship_Team__c Team : varRelationshipTeam){
                SetOfUserId.add(Team.User__c);
            }
            
            if(getInfo[0].NotificationType == 'Association'){
                bodyAndTitle = 'The contact ' + ConObj.Name + ' has been associated with the Key Account '+ getInfo[0].RelatedRecName[0] +'.';
            }
            else{
                bodyAndTitle = 'The contact ' + ConObj.Name + ' has been deassociated with the Key Account '+ getInfo[0].RelatedRecName[0] +'.';
            }
            
            notification.setTitle(bodyAndTitle);
            notification.setBody(bodyAndTitle);
            
            // Set the notification type and target
            notification.setNotificationTypeId(getInfo[0].CustomNotification);
            notification.setTargetId(key);
            
            notification.send(SetOfUserId);
            
            // Email 
             Messaging.SingleEmailMessage ObjMail = new Messaging.SingleEmailMessage();
            String body = mail.getHtmlBody();
            if(body.contains('{Object.Link}')){
                    
                    Link = baseUrl + '/' + key;
                    system.debug('Link>>>'+Link);
                    body = body.replace('{Object.Link}',Link);
                    system.debug('Link>>>'+Link);
                }
            If(body.contains('{Object.Name}')){
                body = body.replace('{Object.Name}',ConObj.Name);
            }
            if(body.contains('{Account.Name}')){
                    body = body.replace('{Account.Name}',getInfo[0].RelatedRecName[0]);
                }
            List<String> sendingTo = new List<String>(SetOfUserId);
            //sendingTo.addAll(SetOfUserId);
            ObjMail.setSaveAsActivity(false);
            ObjMail.setTargetObjectId(UserInfo.getUserId());
            ObjMail.setTreatTargetObjectAsRecipient(false);
            ObjMail.setToAddresses(sendingTo);
          	objMail.setHtmlBody(body);
            emailList.add(ObjMail);
            
        }
         Messaging.SendEmailResult[] results = Messaging.sendEmail(emailList); */
    }
    
    public class ActionRequest{
        @InvocableVariable
        public List<string> RelatedRecName; 
        @InvocableVariable
        public List<string> ContactIds; 
        @InvocableVariable
        public Id CustomNotification;
        @InvocableVariable
        public String NotificationType;
        @InvocableVariable
        public String TemplateId;
        @InvocableVariable
        public List<string> UserName;
        
    }
}