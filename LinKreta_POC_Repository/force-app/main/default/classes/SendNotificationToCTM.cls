/*
* @Name: SendNotificationToCTM
* @Author: Bhavishya Basantwani
* @Description: This class is used for SendNotifcationAndEmail to CTM Of Account that has no activity since 15 days.
* @Date: 1st-september-23
*/
public class SendNotificationToCTM {
    
    @InvocableMethod()
    public static void sendCustomNotificationToCTM(List<ActionRequest> getInfo){
        
        system.debug('getInfo'+getInfo);
        system.debug('size>>'+getInfo.size());
        
        Set<String> setOfKeyAccountIds = new Set<String>(getInfo[0].RecId );
        set<Id> setOfUserIds = new set<Id>();
        Map<Id,User> mapOfUser = new Map<Id,User>();
        Map<Id,set<Id>> mapOfAccount = new Map<Id,set<Id>>();
        
        // get CTM Team of Key Account And fill user in mapOfAccount
        List<AccountTeamMember> ListOfKeyAccountCTM = [SELECT UserId, AccountId, Id, user.IsActive FROM AccountTeamMember where AccountId =: setOfKeyAccountIds AND user.IsActive = true];
        
        if(ListOfKeyAccountCTM.size()>0){
            for(AccountTeamMember objOfCTM :  ListOfKeyAccountCTM){
                
                if(mapOfAccount.containsKey(objOfCTM.AccountId)){
                    mapOfAccount.get(objOfCTM.AccountId).add(objOfCTM.UserId);
                    
                }
                else{
                    mapOfAccount.put(objOfCTM.AccountId,new set<Id>{objOfCTM.UserId});
                }
            }
        }
        
        //get Client Contact Relationship Team of Key Account 
        Map<Id,Set<Id>> MapOfIdAndRealtionshipCon= new Map<Id,set<Id>>();
        Map<Id,Contact> MapOfConIdAndConInfo = new  Map<Id,Contact>();
        List<Contact> listOfClientContact = [select id,name,Contact.AccountId from contact where AccountId IN: getInfo[0].RecId];
        
        for(Contact con : listOfClientContact){
            MapOfConIdAndConInfo.put(con.Id,con);
        }
        
        List<Client_Contact_Relationship_Team__c> listOfClientContactRelationshipTeam = [SELECT Id, Name, Client_Contact__c, Role__c, User__c FROM Client_Contact_Relationship_Team__c where Client_Contact__c IN: listOfClientContact and User__c != null];
        
        if(listOfClientContactRelationshipTeam.size()>0){
            for(Client_Contact_Relationship_Team__c RelationObj : listOfClientContactRelationshipTeam){
                if(MapOfIdAndRealtionshipCon.containsKey(RelationObj.Client_Contact__c)){
                    MapOfIdAndRealtionshipCon.get(RelationObj.Client_Contact__c).add(RelationObj.User__c);
                    
                }
                else{
                    MapOfIdAndRealtionshipCon.put(RelationObj.Client_Contact__c,new set<Id>{RelationObj.User__c});
                }
            }
        }
        
        for(Id objMapRelaCon : MapOfIdAndRealtionshipCon.KeySet()){
            if(MapOfConIdAndConInfo.containsKey(objMapRelaCon)){
                if(mapOfAccount.containsKey(MapOfConIdAndConInfo.get(objMapRelaCon).AccountId)){
                    mapOfAccount.get(MapOfConIdAndConInfo.get(objMapRelaCon).AccountId).addAll(MapOfIdAndRealtionshipCon.get(objMapRelaCon));
                }
                else{
                    Set<Id> varSet = MapOfIdAndRealtionshipCon.get(objMapRelaCon) ;
                    mapOfAccount.put(MapOfConIdAndConInfo.get(objMapRelaCon).AccountId,varSet);
                }
            }
        }
        
        // get CTM Of Gt Client Group and fill User in mapOfAccount
        List<Account> listOfGtCLientGroup = [select Id,name,key_Account_360__c from Account Where key_Account_360__c IN: getInfo[0].RecId];
        
        if(listOfGtCLientGroup.size()>0){
            map<Id,Account> ListOfGtfor3Level = new map<Id,Account>();
            for(Account objGt3levelClient :  listOfGtCLientGroup){
                ListOfGtfor3Level.put(objGt3levelClient.Id,objGt3levelClient);
            }
            Set<String> setOfGtClientGroupIds = new Set<String>();
            for(Account GtClient : listOfGtCLientGroup){
                setOfGtClientGroupIds.add(GtClient.Id);
            }
            
            
            // List<AccountTeamMember> listOfGtClientGroupCTM = [select UserId, AccountId, Id FROM AccountTeamMember where AccountId IN: setOfGtClientGroupIds];
            // Map<Id,set<Id>> MapOfGtClientGroup = new Map<Id,set<Id>>();
            
            /* if(listOfGtClientGroupCTM.size()>0){    
for(AccountTeamMember objOfCTM : listOfGtClientGroupCTM){
if(MapOfGtClientGroup.containsKey(objOfCTM.AccountId)){
MapOfGtClientGroup.get(objOfCTM.AccountId).add(objOfCTM.UserId);
}
else{
MapOfGtClientGroup.put(objOfCTM.AccountId,new set<Id>{objOfCTM.UserId});
}
}

for(Account GtClient : listOfGtCLientGroup){
if(MapOfGtClientGroup.containsKey(GtClient.Id)){
if(mapOfAccount.containsKey(GtClient.Key_Account_360__c)){

Set<Id>  tempList = MapOfGtClientGroup.get(GtClient.Id);
for(Id objTem : tempList){
mapOfAccount.get(GtClient.Key_Account_360__c).add(objTem);
}
}
else{
Set<Id>  tempList = MapOfGtClientGroup.get(GtClient.Id);
for(Id objTem : tempList){
mapOfAccount.put(GtClient.Key_Account_360__c,new set<id>{objTem});
}
}
}
}
}

*/
            // get CTM of clients of GT Client Group and fill user in mapOfAccount
            List<Account> client3LevelList = [select id,name,GT_Client_Group__c from Account Where GT_Client_group__c IN: setOfGtClientGroupIds];
            
            if(client3LevelList.size()>0){    
                Set<Id> setOfClientIds = new set<Id>();
                for(Account objClient : Client3LevelList){
                    setOfClientIds.add(objClient.Id);
                }
                
                List<AccountTeamMember> listOf3LevelClientCTM = [select UserId, AccountId, Id, user.IsActive FROM AccountTeamMember where AccountId IN: setOfClientIds AND user.IsActive = true];
                Map<Id,Set<Id>> mapOf3LevelClient = new  Map<Id,Set<Id>>();
                
                if(listOf3LevelClientCTM.size()>0){
                    for(AccountTeamMember objOfCTM : listOf3LevelClientCTM){
                        if(mapOf3LevelClient.containsKey(objOfCTM.AccountId)){
                            mapOf3LevelClient.get(objOfCTM.AccountId).add(objOfCTM.UserId);
                        }
                        else{
                            mapOf3LevelClient.put(objOfCTM.AccountId,new set<Id>{objOfCTM.UserId});
                        }
                    }        
                    
                    for(Account Client3level : client3LevelList){
                        if(mapOf3LevelClient.containsKey(Client3level.Id)){
                            //  if(MapOfGtClientGroup.containsKey(Client3level.GT_Client_Group__c)){
                            Account tempAcc = ListOfGtfor3Level.get(Client3level.GT_Client_Group__c);
                            Set<Id>  tempList = mapOf3LevelClient.get(Client3level.Id);
                            if(mapOfAccount.containsKey(tempAcc.key_Account_360__c)){
                                for(Id objtem : tempList){
                                    mapOfAccount.get(tempAcc.Key_Account_360__c).add(objTem);
                                }
                            }
                            else{
                                for(Id objtem : tempList){
                                    mapOfAccount.put(tempAcc.Key_Account_360__c,new set<Id>{objtem});
                                }
                            }
                            //  }
                        }
                    }
                }
                
                //get Client Contact Relationship Team of Client Account 3 Level
                Map<Id,Set<Id>> MapOfIdAndRealtionshipConOf3Level = new Map<Id,set<Id>>();
                Map<Id,Contact> MapOfConIdAndConInOf3level = new  Map<Id,Contact>();
                List<Contact> listOfClientContactOf3level = [select id,name,Contact.AccountId from contact where AccountId IN: setOfClientIds];
                
                for(Contact con : listOfClientContactOf3level){
                    MapOfConIdAndConInOf3level.put(con.Id,con);
                }
                
                List<Client_Contact_Relationship_Team__c> listOfClientContactRelationshipTeamOf3Level = [SELECT Id, Name, Client_Contact__c, Role__c, User__c FROM Client_Contact_Relationship_Team__c where Client_Contact__c IN: listOfClientContact and User__c != null];
                
                if(listOfClientContactRelationshipTeamOf3Level.size()>0){
                    for(Client_Contact_Relationship_Team__c RelationObj : listOfClientContactRelationshipTeamOf3Level){
                        if(MapOfIdAndRealtionshipConOf3Level.containsKey(RelationObj.Client_Contact__c)){
                            MapOfIdAndRealtionshipConOf3Level.get(RelationObj.Client_Contact__c).add(RelationObj.User__c);
                            
                        }
                        else{
                            MapOfIdAndRealtionshipConOf3Level.put(RelationObj.Client_Contact__c,new set<Id>{RelationObj.User__c});
                        }
                    }
                }
                
                for(Id objMapRelaCon : MapOfIdAndRealtionshipConOf3Level.KeySet()){
                    if(MapOfConIdAndConInOf3level.containsKey(objMapRelaCon)){
                        if(mapOfAccount.containsKey(MapOfConIdAndConInOf3level.get(objMapRelaCon).AccountId)){
                            mapOfAccount.get(MapOfConIdAndConInOf3level.get(objMapRelaCon).AccountId).addAll(MapOfIdAndRealtionshipConOf3Level.get(objMapRelaCon));
                        }
                        else{
                            Set<Id> varSet = MapOfIdAndRealtionshipConOf3Level.get(objMapRelaCon) ;
                            mapOfAccount.put(MapOfConIdAndConInOf3level.get(objMapRelaCon).AccountId,varSet);
                        }
                    }
                }
            }
            
        }
        
        
        
        CustomNotificationType notificationType = 
            [SELECT Id, DeveloperName 
             FROM CustomNotificationType 
             WHERE DeveloperName='NewClientOwnerChanged'];
        
        
        Map<Id,String>  mapOfAccountInfo = new  Map<Id,String>();
        List<Account> listOfAccountInfo  = [Select id,name from Account Where Id IN: mapOfAccount.keySet()];
        
        for(Account objAcc : listOfAccountInfo){
            mapOfAccountInfo.put(objAcc.Id,objAcc.Name);
        }
        
        
        EmailTemplate emailTemplate = [SELECT DeveloperName, Id, Name FROM EmailTemplate where DeveloperName = 'Send_Email_for_Unmodified_Account_Records']; 
        List<Messaging.SingleEmailMessage> emailList = new List<Messaging.SingleEmailMessage>();
        //For(integer i=0 ; i<mapOfAccount.RecId.size(); i++){
        Messaging.SingleEmailMessage mail = Messaging.renderStoredEmailTemplate(emailTemplate.Id, UserInfo.getUserId() , listOfAccountInfo[0].Id);
        String baseUrl = URL.getOrgDomainURL().toExternalForm();
        system.debug('baseUrl'+baseUrl);
        String Link;     
        
        // Added by Suraj for phase 1 on 23-04-2024

        List<OrgWideEmailAddress> orgWideEmails =  [SELECT Id, Address, DisplayName FROM OrgWideEmailAddress WHERE DisplayName = 'Linkreta' LIMIT 1];

        For(Id key : mapOfAccount.keySet()){
            Messaging.CustomNotification notification = new Messaging.CustomNotification();
            
            // Set the contents for the notification
            String accountName = mapOfAccountInfo.get(key);
            String bodyAndTitle = 'This is a reminder that there have been no field updates, task/event updates for 15 days for '+ accountName;
            notification.setTitle(bodyAndTitle);
            notification.setBody(bodyAndTitle);
            
            // Set the notification type and target
            notification.setNotificationTypeId(notificationType.Id);
            notification.setTargetId(key);
            
            
            // Actually send the notification
            set<String> idSet = new set<String>();
            
            for(String  objMap : mapOfAccount.get(key)){
                idSet.add(objMap);
                setOfUserIds.add(objMap);
            }
            
            notification.send(idSet);
            
            //Email
            Messaging.SingleEmailMessage ObjMail = new Messaging.SingleEmailMessage();
            String body = mail.getHtmlBody();
            if(body.contains('{Object.Link}')){
                
                Link = baseUrl + '/' + key;
                system.debug('Link>>>'+Link);
                body = body.replace('{Object.Link}',Link);
                system.debug('Link>>>'+Link);
            }
            
            If(body.contains('{Object.Name}') && accountName != Null){
                body = body.replace('{Object.Name}',accountName);
            }
            List<Id> sendingTo = new  List<Id>(mapOfAccount.get(key));
            ObjMail.setSaveAsActivity(false);
            ObjMail.setTargetObjectId(UserInfo.getUserId());
            ObjMail.setTreatTargetObjectAsRecipient(false);
            ObjMail.setToAddresses(sendingTo);
            objMail.setHtmlBody(body);
            objMail.setSubject('No activity performed on your Key Account.');
            objMail.setOrgWideEmailAddressId(orgWideEmails[0].Id);
            emailList.add(ObjMail);
            
        }
        
        Messaging.SendEmailResult[] results = Messaging.sendEmail(emailList);
        
        
    }
    
    
    public class ActionRequest{
        @InvocableVariable
        public List<string> RecId;    
    }
}