/*
    AUTHOR                   : Deepak joshi
    VERSION                  : 1
    MODIFICATION DATE        : 31 July 2023
    PROJECT NAME / TICKET #  : GT
    DESCRIPTION              : NameChangeApproveNotifications

    AUTHOR                   :
    VERSION                  :2
    MODIFICATION DATE        : 
    PROJECT NAME / TICKET #  : 
    DESCRIPTION              : 
    */
    public class NameChangeApproveNotifications { 
        /**
        * 
    * @description 
    * @author Deepak Joshi | 31 July 2023
    * @param accountId 
    **/
    @InvocableMethod
    public static void invocable(List<Id> accountId){
        Account_Requests__c accountRequestObj =  [SELECT Id,Client__c, New_Client__c,Status__c FROM Account_Requests__c WHERE Id =:accountId[0]];
        if(accountRequestObj.Client__c !=null && accountRequestObj.Status__c ==  ConstantUtility.APPROVED){
            accountNameChange(accountRequestObj.Client__c,accountId[0]);
        }
        if(accountRequestObj.New_Client__c !=null && accountRequestObj.Status__c ==  ConstantUtility.APPROVED){
        leadNameChange(accountRequestObj.New_Client__c,accountId[0]);
        }
        if(accountRequestObj.Client__c !=null && accountRequestObj.Status__c ==  ConstantUtility.SUBMITTED){
            System.debug('Called from flow');
            System.debug('accountRequestObjClient__c'+accountRequestObj.Client__c);
        accountNameChangeSubmission(accountRequestObj.Client__c,accountId[0]);
        }
        if(accountRequestObj.New_Client__c !=null && accountRequestObj.Status__c ==  ConstantUtility.SUBMITTED){
        leadNameChangeSubmission(accountRequestObj.New_Client__c,accountId[0]);
        }

    }
        /**
        * 
    * @description 
    * @author Deepak Joshi | 31 July 2023
    * @param accountRecId 
    **/
    public static void accountNameChange(String accountRecId,String accountRequestId){
        List<EmailTemplate> emailTemplateList=[SELECT Id ,Body,Name,CreatedBy.Name,DeveloperName,Subject FROM EmailTemplate WHERE DeveloperName='Account_Name_Change_Request_Approved_Email' limit 1];
        List<OrgWideEmailAddress> orgWideEmails = [SELECT Id, Address, DisplayName FROM OrgWideEmailAddress WHERE DisplayName = 'Linkreta' LIMIT 1];
        Set<String> groupNames = new Set<String>();
        groupNames.add('FAP_team');
        groupNames.add('C_M_Team');
        groupNames.add('IT_Team');

        Set<String> userIds = new Set<String>();
        Map<String,Set<String>> userGroupWithUserIds = getGropWithUserId(groupNames);
        if(userGroupWithUserIds.containsKey('FAP_team')){
            List<String> userList = new  List<String>(userGroupWithUserIds.get('FAP_team'));
            userIds.addAll(userList);
            sendEmailIndividual(accountRecId,userList,emailTemplateList, '[Recipeint User]','FAP Team',orgWideEmails);
        }
        if(userGroupWithUserIds.containsKey('C_M_Team')){
            List<String> userList = new  List<String>(userGroupWithUserIds.get('C_M_Team'));
            userIds.addAll(userList);
            sendEmailIndividual(accountRecId,userList,emailTemplateList, '[Recipeint User]','C&M Team',orgWideEmails);
        }
        if(userGroupWithUserIds.containsKey('IT_Team')){
            List<String> userList = new  List<String>(userGroupWithUserIds.get('IT_Team'));
            userIds.addAll(userList);
            sendEmailIndividual(accountRecId,userList,emailTemplateList, '[Recipeint User]','IT Team',orgWideEmails);
        }


        Account accountObj = [SELECT Id,Name,Proposed_Client_Name__c,OwnerId,Owner.Name FROM Account WHERE Id =: accountRecId];
        //get related Client Contact Relationship Team
        Set<String> relationshipTeamUserIds = getClientContactRelationshipTeam(accountObj.Id,orgWideEmails,emailTemplateList,'[Recipeint User]');
        if(relationshipTeamUserIds !=null && relationshipTeamUserIds.Size() > 0 ){
            userIds.addAll(relationshipTeamUserIds);
        }
        userIds.add(accountObj.OwnerId);
        sendEmailIndividual(accountRecId,new List<String>{accountObj.OwnerId},emailTemplateList, '[Recipeint User]',accountObj.Owner.Name,orgWideEmails);
        if(!emailTemplateList.isEmpty() && userIds !=null){
           // GenericNotification.SendEmail(accountRecId, userIds,emailTemplateList[0]);
            String messageBody  = 'You are required to review the Name change request from '+accountObj.Name+' to '+accountObj.Proposed_Client_Name__c+'.';	
            String title ='Account name change request approved';
            GenericNotification.sendNotification(accountRequestId, userIds,messageBody,title);
        }
    }
        /**
        * 
    * @description 
    * @author Deepak Joshi | 31 July 2023
    * @param leadId 
    **/
    public static void leadNameChange(String leadId,String accountRequestId){
        List<EmailTemplate> emailTemplateList=[SELECT Id ,Body,Name,CreatedBy.Name,DeveloperName,Subject FROM EmailTemplate WHERE DeveloperName='New_Client_Name_Change_Request_Approved_Email' limit 1];
        List<OrgWideEmailAddress> orgWideEmails = [SELECT Id, Address, DisplayName FROM OrgWideEmailAddress WHERE DisplayName = 'Linkreta' LIMIT 1];
        Set<String> groupNames = new Set<String>();
        groupNames.add('NSL');
        groupNames.add('C_M_Team');
        groupNames.add('IT_Team');
        Set<String> userIds =new Set<String>();
        Map<String,Set<String>> userGroupWithUserIds = getGropWithUserId(groupNames);
        if(userGroupWithUserIds.containsKey('NSL')){
            List<String> userList = new  List<String>(userGroupWithUserIds.get('NSL'));
            userIds.addAll(userList);
            sendEmailIndividual(leadId,userList,emailTemplateList, '[Recipeint User]','NSL Team',orgWideEmails);
        }
        if(userGroupWithUserIds.containsKey('C_M_Team')){
            List<String> userList = new  List<String>(userGroupWithUserIds.get('C_M_Team'));
            userIds.addAll(userList);
            sendEmailIndividual(leadId,userList,emailTemplateList, '[Recipeint User]','C&M Team',orgWideEmails);
        }
        if(userGroupWithUserIds.containsKey('IT_Team')){
            List<String> userList = new  List<String>(userGroupWithUserIds.get('IT_Team'));
            userIds.addAll(userList);
            sendEmailIndividual(leadId,userList,emailTemplateList, '[Recipeint User]','IT Team',orgWideEmails);
        }

        Lead leadObj = [SELECT Id,OwnerId,Company,Owner.Name FROM Lead WHERE Id=:leadId];        
        userIds.add(leadObj.OwnerId);
        if(leadObj.Owner.Name != null){
            sendEmailIndividual(leadId,new List<String>{leadObj.OwnerId},emailTemplateList, '[Recipeint User]',leadObj.Owner.Name,orgWideEmails);
        }
        if(!emailTemplateList.isEmpty() && userIds !=null){
            //GenericNotification.SendEmail(leadId, userIds,emailTemplateList[0]);
            String messageBody  = 'The Account Name change request on new client for '+leadObj.Company+' has been approved.';	
            String title ='New client name change request approved';

            GenericNotification.sendNotification(accountRequestId, userIds,messageBody,title);
        }
        
    }
        /**
        * 
    * @description 
    * @author Deepak Joshi | 31 July 2023
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
    * @author Deepak Joshi | 31 July 2023
    * @param leadId 
    **/

    public static void accountNameChangeSubmission(String accountRecId,String accountRequestId){
        List<OrgWideEmailAddress> orgWideEmails = [SELECT Id, Address, DisplayName FROM OrgWideEmailAddress WHERE DisplayName = 'Linkreta' LIMIT 1];
        List<EmailTemplate> emailTemplateList=[SELECT Id ,Body,Name,CreatedBy.Name,DeveloperName,Subject FROM EmailTemplate WHERE DeveloperName='Account_Name_Change_Request_Submission_Email' limit 1];
        Set<String> groupNames = new Set<String>();
        groupNames.add('DS_Team');

        Map<String,Set<String>> userGroupWithUserIds = getGropWithUserId(groupNames);
        Set<String> userIdsForNotification= new Set<String>();
        //Set<String> userIdsForNotification=getGroup(groupNames);
        if(userGroupWithUserIds.containsKey('DS_Team')){
            List<String> userList = new  List<String>(userGroupWithUserIds.get('DS_Team'));
            userIdsForNotification.addAll(userList);
            sendEmailIndividual(accountRequestId,userList,emailTemplateList, 'DS Team','DS Team',orgWideEmails);
        }

       // Set<String> userIdsForEmail =new  Set<String>();
        Account accountObj = [SELECT Id,Name,Proposed_Client_Name__c,OwnerID FROM Account WHERE Id =: accountRecId]; 
        //get related Client Contact Relationship Team
        Set<String> relationshipTeamUserIds = getClientContactRelationshipTeam(accountObj.Id,orgWideEmails,emailTemplateList,'DS Team');
        if(relationshipTeamUserIds !=null && relationshipTeamUserIds.Size() > 0 ){
            //userIdsForEmail.addAll(relationshipTeamUserIds);
            userIdsForNotification.addAll(relationshipTeamUserIds);
        }
        if(!emailTemplateList.isEmpty()){
           // if(userIdsForEmail !=null && userIdsForEmail.Size()>0){
            //   GenericNotification.SendEmail(accountRequestId, userIdsForEmail,emailTemplateList[0]);
           // }
            if(userIdsForNotification !=null && userIdsForNotification.Size()>0){
                String messageBody  = 'You are required to approve the request for Client Name Change of '+accountObj.Name;	
                String title =emailTemplateList[0].Subject;
                GenericNotification.sendNotification(accountRequestId, userIdsForNotification,messageBody,title);
            }
           
        }

    }
        /**
        * 
    * @description 
    * @author Deepak Joshi | 31 July 2023
    * @param leadId 
    **/
    public static void leadNameChangeSubmission(String leadId,String accountRequestId){
        List<EmailTemplate> emailTemplateList=[SELECT Id ,Body,Name,CreatedBy.Name,DeveloperName,Subject FROM EmailTemplate WHERE DeveloperName='New_Client_Name_Change_Request_Submission_Email' limit 1];
        List<OrgWideEmailAddress> orgWideEmails = [SELECT Id, Address, DisplayName FROM OrgWideEmailAddress WHERE DisplayName = 'Linkreta' LIMIT 1];

        Set<String> groupNames = new Set<String>();
        groupNames.add('C_M_Team');
        Set<String> userIds =new Set<String>();
        Map<String,Set<String>> userGroupWithUserIds = getGropWithUserId(groupNames);
        if(userGroupWithUserIds.containsKey('C_M_Team')){
            List<String> userList = new  List<String>(userGroupWithUserIds.get('C_M_Team'));
            userIds.addAll(userList);
           // sendEmailIndividual(leadId,userList,emailTemplateList, 'C&M Team','C&M Team',orgWideEmails);
        }

       Lead leadObj = [SELECT Id,OwnerId,Company FROM Lead WHERE Id=:leadId];
        if(!emailTemplateList.isEmpty() && userIds !=null){
            //GenericNotification.SendEmail(leadId, userIds,emailTemplateList[0]);
            String messageBody  = 'You are required to approve the request for Client Name Change of '+leadObj.Company;	
            String title =emailTemplateList[0].Subject;
            GenericNotification.sendNotification(accountRequestId, userIds,messageBody,title);
        }
    }
     /**
        * 
    * @description 
    * @author Deepak Joshi | 21 August 2023
    * @param accountId 
    **/
    public static Set<String> getClientContactRelationshipTeam(String accountId,List<OrgWideEmailAddress> orgWideEmails,List<EmailTemplate> emailTemplateList, String oldValue){
        Set<String> contactIds = new Set<String>();
        for(Contact con :[SELECT Id FROM Contact WHERE AccountId =:accountId]){
            contactIds.add(con.Id);
        }
        Set<String> userIds = new Set<String>();
        if(contactIds !=null && contactIds.Size()>0){
            for(Client_Contact_Relationship_Team__c team: [SELECT Id,User__c,User__r.Name FROM Client_Contact_Relationship_Team__c WHERE Client_Contact__c =:contactIds AND User__c !=null]){
                userIds.add(team.User__c);
                sendEmailIndividual(accountId,new List<String>{team.User__c},emailTemplateList, oldValue,team.User__r.Name,orgWideEmails);

            } 
        }
        return userIds;
    }
    public static void sendEmailIndividual(String objectId,List<String> recipientIds ,List<EmailTemplate> emailTemplate, String oldValue, String newValue, List<OrgWideEmailAddress> orgWideEmails){
        List<Messaging.SingleEmailMessage> listEmailMessage = new List<Messaging.SingleEmailMessage>();
        Messaging.SingleEmailMessage emailMessage = Messaging.renderStoredEmailTemplate(emailTemplate[0].Id,recipientIds[0],objectId);
        if(orgWideEmails != null){
            emailMessage.setOrgWideEmailAddressId(orgWideEmails[0].Id);
        }
        emailMessage.setToAddresses(recipientIds);
        emailMessage.setSaveAsActivity(false);  
        String body = emailMessage.getHtmlBody().replace(oldValue,newValue);
        emailMessage.setHtmlBody('');
        emailMessage.setHtmlBody(body);	
        listEmailMessage.add(emailMessage);        
        
        try{
            Messaging.sendEmail(listEmailMessage);
        }
        catch(Exception e){
            System.debug('Error message : ' + e.getMessage() + ' in line : ' + e.getLineNumber());
        }
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
    
}