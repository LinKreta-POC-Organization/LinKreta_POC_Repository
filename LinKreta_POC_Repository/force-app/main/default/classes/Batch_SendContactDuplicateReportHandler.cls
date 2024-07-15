public class Batch_SendContactDuplicateReportHandler {
    public static String getQuery(){
        String query = 'SELECT Id, AccountId, Last_Activity_Date_Time__c, (SELECT Id, User__c, User__r.Email FROM Client_Contact_Relationship_Team__r WHERE User__c  != null AND User__r.isActive = true) FROM Contact WHERE AccountId != null AND Last_Activity_Date_Time__c < LAST_N_DAYS : 30';
        return query;
    }
    
    public static List<String> sendEmailToClientAndContactTeam(List<Contact> contactList, List<String> emailRecipientList) {
        Set<Id> accountIds = new Set<Id>();
        Set<String> accountTeamEmails = new Set<String>();

        Set<String> contactTeamEmails = new Set<String>();
        Set<String> meTeamEmails = new Set<String>();

        Set<Id> userIds = new Set<Id>();
        Set<String> emailRecipients = new Set<String>();
        
        
        EmailTemplate emailTemp = [SELECT Id, DeveloperName, Subject, Body, HtmlValue FROM EmailTemplate WHERE DeveloperName = 'Email_Template_for_Meetings_Report'];
        
        // Add AccountIds and Contact Team member emails
        for (Contact con : contactList) {
            if (con.AccountId != null) {
                accountIds.add(con.AccountId);
            }
            for (Client_Contact_Relationship_Team__c ccrt : con.Client_Contact_Relationship_Team__r) {
                if (ccrt.User__c != null && !emailRecipientList.contains(ccrt.User__r.Email)) {
                    contactTeamEmails.add(ccrt.User__r.Email);
                }
            }
        }
        
        // Add Account Team member emails
        for (AccountTeamMember atm : [SELECT UserId, User.Email FROM AccountTeamMember WHERE AccountId IN :accountIds AND User.Email NOT IN :emailRecipientList AND User.isActive = true] ) {
            accountTeamEmails.add(atm.User.Email);
        }
        
        // Add Group members' emails
        for (GroupMember grpMember : [SELECT UserOrGroupId FROM GroupMember WHERE Group.DeveloperName = 'C_M_Team' AND Group.Type = 'Regular']) {
            userIds.add(grpMember.UserOrGroupId);
        }
        
        // Add User emails
        for (User user : [SELECT Email FROM User WHERE Id IN :userIds AND Email  NOT IN :emailRecipientList AND isActive =true]) {
            meTeamEmails.add(user.Email);
        }
        List<OrgWideEmailAddress> orgWideEmails = [SELECT Id, Address, DisplayName FROM OrgWideEmailAddress WHERE DisplayName = 'Linkreta' LIMIT 1];
        
        List<Messaging.SingleEmailMessage> emailMessageRequestList = new List<Messaging.SingleEmailMessage>();
        
        if(!accountTeamEmails.isEmpty()){
            Messaging.SingleEmailMessage emailMessageRequest = new Messaging.SingleEmailMessage();
            emailMessageRequest.setSubject(emailTemp.Subject);
            String body = emailTemp.HtmlValue.replace('[Recepient Name]','Client Team');
            emailMessageRequest.setHtmlBody(body);
            if(orgWideEmails != null){
                emailMessageRequest.setOrgWideEmailAddressId(orgWideEmails[0].Id);
            }
            emailMessageRequest.setToAddresses(new List<String>(accountTeamEmails));
            emailMessageRequest.setTemplateID(emailTemp.Id);
            emailMessageRequestList.add(emailMessageRequest);
        }if(!contactTeamEmails.isEmpty()){
            Messaging.SingleEmailMessage emailMessageRequest2 = new Messaging.SingleEmailMessage();
            emailMessageRequest2.setSubject(emailTemp.Subject);
            String body = emailTemp.HtmlValue.replace('[Recepient Name]','Client Contact Team');
            emailMessageRequest2.setHtmlBody(body);
            if(orgWideEmails != null){
                emailMessageRequest2.setOrgWideEmailAddressId(orgWideEmails[0].Id);
            }
            emailMessageRequest2.setSenderDisplayName('Linkreta GT');
            emailMessageRequest2.setToAddresses(new List<String>(contactTeamEmails));
            emailMessageRequest2.setTemplateID(emailTemp.Id);
            emailMessageRequestList.add(emailMessageRequest2);
        }if(!meTeamEmails.isEmpty()){
            Messaging.SingleEmailMessage emailMessageRequest3 = new Messaging.SingleEmailMessage();
            emailMessageRequest3.setSubject(emailTemp.Subject);
            String body = emailTemp.HtmlValue.replace('[Recepient Name]','Market Ecosystems Team');
            emailMessageRequest3.setHtmlBody(body);
            if(orgWideEmails != null){
                emailMessageRequest3.setOrgWideEmailAddressId(orgWideEmails[0].Id);
            }
            emailMessageRequest3.setSenderDisplayName('Linkreta GT');
            emailMessageRequest3.setToAddresses(new List<String>(meTeamEmails));
            emailMessageRequest3.setTemplateID(emailTemp.Id);
            emailMessageRequestList.add(emailMessageRequest3);
        }
        /*if (!emailRecipients.isEmpty()){
            Messaging.SingleEmailMessage emailMessageRequest = new Messaging.SingleEmailMessage();
            emailMessageRequest.setSubject(emailTemp.Subject);
            emailMessageRequest.setPlainTextBody(emailTemp.Body);
            emailMessageRequest.setSenderDisplayName('Linkreta GT');
            emailMessageRequest.setToAddresses(new List<String>(emailRecipients));
            emailMessageRequest.setTemplateID(emailTemp.Id);
            emailMessageRequestList.add(emailMessageRequest);
            Messaging.sendEmail(emailMessageRequestList);
        } else {
            System.debug('Mail List is empty');
        }*/
        try{
            Messaging.sendEmail(emailMessageRequestList);
        }catch(Exception e){
            system.debug('Exception:'+e.getLineNumber()+' '+e.getMessage());
        }
        // Add new unique email recipients to the existing global list
        emailRecipientList.addAll(accountTeamEmails);
        emailRecipientList.addAll(contactTeamEmails);
        emailRecipientList.addAll(meTeamEmails);

        return emailRecipientList;
    }
    
}