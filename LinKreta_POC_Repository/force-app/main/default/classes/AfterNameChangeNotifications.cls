/*
AUTHOR                   : Deepak joshi
VERSION                  : 1
MODIFICATION DATE        : 1 August 2023
PROJECT NAME / TICKET #  : GT
DESCRIPTION              : AfterNameChangeNotifications

AUTHOR                   :
VERSION                  :2
MODIFICATION DATE        : 
PROJECT NAME / TICKET #  : 
DESCRIPTION              : 
*/
public  class AfterNameChangeNotifications {
    /**
     * 
    * @description 
    * @author Deepak Joshi | 1 August 2023
    * @param accountId 
    **/
    @InvocableMethod
    public static void invocable(List<Id> recordId){
        List<Account> accountList = [SELECT Id,OwnerId,Name,Owner.Name FROM Account WHERE Id =:recordId[0]];
        List<Lead> leadList = [SELECT Id,OwnerId,Company,Owner.Name FROM Lead WHERE Id =:recordId[0]];

        if(!accountList.isEmpty()){
            accountNameChange(accountList[0]);
        }
        if(!leadList.isEmpty()){
            leadNameChange(leadList[0]);
        }

    }
      /**
     * 
    * @description 
    * @author Deepak Joshi | 1 August 2023
    * @param accountRecId 
    **/
    public static void accountNameChange(Account accountObj){
        List<OrgWideEmailAddress> orgWideEmails = [SELECT Id, Address, DisplayName FROM OrgWideEmailAddress WHERE DisplayName = 'Linkreta' LIMIT 1];
        List<EmailTemplate> emailTemplateList=[SELECT Id ,Body,Name,CreatedBy.Name,DeveloperName,Subject FROM EmailTemplate WHERE DeveloperName='After_Account_Name_Change_Email' limit 1];

        Set<String> groupNames = new Set<String>();
        groupNames.add('NSL');
        groupNames.add('C_M_Team');
        groupNames.add('Independence_team');
        groupNames.add('LRM_Team');
        groupNames.add('QRMG_Team');
        groupNames.add('BUL');
        //groupNames.add('Independence_team');

        List<Messaging.SingleEmailMessage> listEmailMessage = new List<Messaging.SingleEmailMessage>();

        Map<String,Set<String>> userGroupWithUserIds = getGropWithUserId(groupNames);
        Set<String> userIds = new  Set<String>();
        if(userGroupWithUserIds.containsKey('NSL')){
            List<String> userList = new  List<String>(userGroupWithUserIds.get('NSL'));
            userIds.addAll(userList);
            Messaging.SingleEmailMessage eMessage  = sendEmailIndividual(accountObj.Id,userList,emailTemplateList, '[Recipeint User]','NSL Team',orgWideEmails);
            listEmailMessage.add(eMessage);
        }
        if(userGroupWithUserIds.containsKey('C_M_Team')){
            List<String> userList = new  List<String>(userGroupWithUserIds.get('C_M_Team'));
            userIds.addAll(userList);
            Messaging.SingleEmailMessage eMessage = sendEmailIndividual(accountObj.Id,userList,emailTemplateList, '[Recipeint User]','C&M Team',orgWideEmails);
            listEmailMessage.add(eMessage);
        }
        if(userGroupWithUserIds.containsKey('Independence_team')){
            List<String> userList = new  List<String>(userGroupWithUserIds.get('Independence_team'));
            userIds.addAll(userList);
            Messaging.SingleEmailMessage eMessage = sendEmailIndividual(accountObj.Id,userList,emailTemplateList, '[Recipeint User]','Independence Team',orgWideEmails);
            listEmailMessage.add(eMessage);
        }
        if(userGroupWithUserIds.containsKey('LRM_Team')){
            List<String> userList = new  List<String>(userGroupWithUserIds.get('LRM_Team'));
            userIds.addAll(userList);
            Messaging.SingleEmailMessage eMessage = sendEmailIndividual(accountObj.Id,userList,emailTemplateList, '[Recipeint User]','LRM Team',orgWideEmails);
            listEmailMessage.add(eMessage);
        }
        if(userGroupWithUserIds.containsKey('QRMG_Team')){
            List<String> userList = new  List<String>(userGroupWithUserIds.get('QRMG_Team'));
            userIds.addAll(userList);
            Messaging.SingleEmailMessage eMessage = sendEmailIndividual(accountObj.Id,userList,emailTemplateList, '[Recipeint User]','QRMG Team',orgWideEmails);
            listEmailMessage.add(eMessage);
        }
        if(userGroupWithUserIds.containsKey('BUL')){
            List<String> userList = new  List<String>(userGroupWithUserIds.get('BUL'));
            userIds.addAll(userList);
            Messaging.SingleEmailMessage eMessage = sendEmailIndividual(accountObj.Id,userList,emailTemplateList, '[Recipeint User]','BUL Team',orgWideEmails);
            listEmailMessage.add(eMessage);
        }

        userIds.add(accountObj.ownerId);
        Messaging.SingleEmailMessage eMessage = sendEmailIndividual(accountObj.Id,new List<String>{accountObj.ownerId} , emailTemplateList, '[Recipeint User]',accountObj.owner.Name,orgWideEmails);
        listEmailMessage.add(eMessage);
        for(AccountTeamMember team : [SELECT Id,TeamMemberRole, UserId,User.Name  FROM AccountTeamMember  WHERE AccountId =:accountObj.Id]){
            userIds.add(team.UserId);

            Messaging.SingleEmailMessage eMessage1 = sendEmailIndividual(accountObj.Id,new List<String>{team.UserId} , emailTemplateList, '[Recipeint User]',team.User.Name,orgWideEmails);
            listEmailMessage.add(eMessage1);
        }
        //Start Phase-1 code comment
        /* 
        for(Opportunity opp :[SELECT Id,StageName,OwnerId,Owner.Name FROM Opportunity  WHERE AccountId =:accountObj.Id AND StageName !='Closed Lost' AND StageName !='Closed Won']){
            userIds.add(opp.OwnerId);
            Messaging.SingleEmailMessage eMessage2 = sendEmailIndividual(accountObj.Id,new List<String>{opp.OwnerId} , emailTemplateList, '[Recipeint User]',opp.Owner.Name , orgWideEmails);
            listEmailMessage.add(eMessage2);
        }
        for(Job__c job :[SELECT Id,Client__c,JobOwner__c,JobOwner__r.Name FROM Job__c  WHERE JobOwner__c !=null AND Client__c =:accountObj.Id]){
            userIds.add(job.JobOwner__c);
            Messaging.SingleEmailMessage eMessage3 = sendEmailIndividual(accountObj.Id,new List<String>{job.JobOwner__c} , emailTemplateList, '[Recipeint User]',job.JobOwner__r.Name , orgWideEmails);
            listEmailMessage.add(eMessage3);
        } */
        //End Phase-1 code comment
        //get related Client Contact Relationship Team
        Set<String> relationshipTeamUserIds = getClientContactRelationshipTeam(accountObj.Id,emailTemplateList,orgWideEmails);
        if(relationshipTeamUserIds !=null && relationshipTeamUserIds.Size() > 0 ){
            userIds.addAll(relationshipTeamUserIds);
        }
        if(!emailTemplateList.isEmpty() && userIds !=null){
           // GenericNotification.SendEmail(accountObj.Id, userIds,emailTemplateList[0]);
            sendEmailMassages(listEmailMessage);
            String messageBody  = 'You can view the Name Change for '+accountObj.Name+'.';	
            String title ='You can view the Name Change';
            GenericNotification.sendNotification(accountObj.Id, userIds,messageBody,title);
        }
    }
      /**
     * 
    * @description 
    * @author Deepak Joshi | 1 August 2023
    * @param leadId 
    **/
    public static void leadNameChange(Lead leadObj){
        List<OrgWideEmailAddress> orgWideEmails = [SELECT Id, Address, DisplayName FROM OrgWideEmailAddress WHERE DisplayName = 'Linkreta' LIMIT 1];
        List<EmailTemplate> emailTemplateList=[SELECT Id ,Body,Name,CreatedBy.Name,DeveloperName,Subject FROM EmailTemplate WHERE DeveloperName='After_New_Client_Name_Change_Email' limit 1];
        Set<String> groupNames = new Set<String>();
        groupNames.add('NSL');
        groupNames.add('C_M_Team');

        List<Messaging.SingleEmailMessage> listEmailMessage = new List<Messaging.SingleEmailMessage>();

        Map<String,Set<String>> userGroupWithUserIds = getGropWithUserId(groupNames);
        Set<String> userIds = new  Set<String>();
        if(userGroupWithUserIds.containsKey('NSL')){
            List<String> userList = new  List<String>(userGroupWithUserIds.get('NSL'));
            userIds.addAll(userList);
            Messaging.SingleEmailMessage eMessage = sendEmailIndividual(leadObj.Id,userList,emailTemplateList, '[Recipeint User]','NSL Team',orgWideEmails);
            listEmailMessage.add(eMessage);
        }
        if(userGroupWithUserIds.containsKey('C_M_Team')){
            List<String> userList = new  List<String>(userGroupWithUserIds.get('C_M_Team'));
            userIds.addAll(userList);
            Messaging.SingleEmailMessage eMessage = sendEmailIndividual(leadObj.Id,userList,emailTemplateList, '[Recipeint User]','C&M Team',orgWideEmails);
            listEmailMessage.add(eMessage);
        }
        userIds.add(leadObj.OwnerId);
        if(leadObj.Owner.Name != null){
            Messaging.SingleEmailMessage eMessage = sendEmailIndividual(leadObj.Id,new List<String>{leadObj.OwnerId},emailTemplateList, '[Recipeint User]',leadObj.Owner.Name,orgWideEmails);
            listEmailMessage.add(eMessage);
        }
        if(!emailTemplateList.isEmpty() && userIds !=null){
           // GenericNotification.SendEmail(leadObj.Id, userIds,emailTemplateList[0]);
           sendEmailMassages(listEmailMessage);
            String messageBody  = 'The Account Name change request on new client for '+leadObj.Company+' has been approved.';	
            String title ='You can view the Name Change';

            GenericNotification.sendNotification(leadObj.Id, userIds,messageBody,title);
        }
        
    }
      /**
     * 
    * @description 
    * @author Deepak Joshi | 1 August 2023
    * @param groupNames 
    **/
    public static Set<String>  getGroup(Set<String> groupNames){
        List<User> groupMember =[SELECT Id, Name, IsActive FROM User 
                      WHERE IsActive =true AND Id IN  
                      (SELECT UserOrGroupId FROM GroupMember  WHERE Group.DeveloperName =:groupNames)];
        Set<String> userIds = new Set<String>();
        for(User  usr: groupMember){
            userIds.add(usr.Id);
        }
        return userIds;
    }
    /**
    * 
    * @description 
    * @author Deepak Joshi | 21 August 2023
    * @param accountId 
    **/
    public static Set<String> getClientContactRelationshipTeam(String accountId,List<EmailTemplate> emailTemplateList,List<OrgWideEmailAddress> orgWideEmails){
        List<Messaging.SingleEmailMessage> listEmailMessage = new List<Messaging.SingleEmailMessage>();
        Set<String> contactIds = new Set<String>();
        for(Contact con :[SELECT Id FROM Contact WHERE AccountId =:accountId]){
            contactIds.add(con.Id);
        }
        Set<String> userIds = new Set<String>();
        if(contactIds !=null && contactIds.Size()>0){
            for(Client_Contact_Relationship_Team__c team: [SELECT Id,User__c,User__r.Name FROM Client_Contact_Relationship_Team__c WHERE Client_Contact__c =:contactIds AND User__c !=null]){
                userIds.add(team.User__c);
                Messaging.SingleEmailMessage eMessage = sendEmailIndividual(accountId,new List<String>{team.User__c} , emailTemplateList, '[Recipeint User]',team.User__r.Name , orgWideEmails);
                listEmailMessage.add(eMessage);
            } 
        }
        sendEmailMassages(listEmailMessage);
        return userIds;
    }

    public static Messaging.SingleEmailMessage sendEmailIndividual(String objectId,List<String> recipientIds ,List<EmailTemplate> emailTemplate, String oldValue, String newValue, List<OrgWideEmailAddress> orgWideEmails){
        //List<Messaging.SingleEmailMessage> listEmailMessage = new List<Messaging.SingleEmailMessage>();
        Messaging.SingleEmailMessage emailMessage = Messaging.renderStoredEmailTemplate(emailTemplate[0].Id,recipientIds[0],objectId);
        //List<OrgWideEmailAddress> orgWideEmails = [SELECT Id, Address, DisplayName FROM OrgWideEmailAddress WHERE DisplayName = 'Grant Thornton' LIMIT 1];
        if(orgWideEmails != null){
            emailMessage.setOrgWideEmailAddressId(orgWideEmails[0].Id);
        }
        emailMessage.setToAddresses(recipientIds);
        emailMessage.setSaveAsActivity(false);  
        String body = emailMessage.getHtmlBody().replace(oldValue,newValue);
        //body = body.replace('[Field]',fieldChanges);
        emailMessage.setHtmlBody('');
        emailMessage.setHtmlBody(body);	
        //listEmailMessage.add(emailMessage);        
        
       // try{
       //     Messaging.sendEmail(listEmailMessage);
       // }
       // catch(Exception e){
       //     System.debug('Error message : ' + e.getMessage() + ' in line : ' + e.getLineNumber());
       // }
       return emailMessage;
    }

    public static Map<String,Set<String>>  getGropWithUserId(Set<String> groupNames){  
        Map<String,Set<String>> groupUserIDs =  new Map<String,Set<String>>();
        Map<String,String> groupUserIdAndGroupName =  new Map<String,String>();
       List<GroupMember> groupMemb = [SELECT UserOrGroupId,Group.DeveloperName FROM GroupMember WHERE Group.DeveloperName =:groupNames];
       for(GroupMember gro :groupMemb){
            groupUserIdAndGroupName.put(gro.UserOrGroupId,gro.Group.DeveloperName);
       }
       
       List<User> userList = [SELECT Id, Name, IsActive FROM User WHERE IsActive =true AND Id =:groupUserIdAndGroupName.keySet()];
       for(User u : userList){
            if(groupUserIdAndGroupName.containsKey(u.Id)){
                if(groupUserIDs.containsKey(groupUserIdAndGroupName.get(u.Id))){
                    groupUserIDs.get(groupUserIdAndGroupName.get(u.Id)).add(u.Id);
                }
                else{
                    groupUserIDs.put(groupUserIdAndGroupName.get(u.Id) ,new Set<String>{u.Id});
                }

            }
       }
       return groupUserIDs;
    }
    public static void  sendEmailMassages(List<Messaging.SingleEmailMessage> listEmailMessage){ 
        try{
            if(!listEmailMessage.isEmpty()){
                Messaging.sendEmail(listEmailMessage);
            }
        }
        catch(Exception e){
            System.debug('Error message : ' + e.getMessage() + ' in line : ' + e.getLineNumber());
        } 

    }
}