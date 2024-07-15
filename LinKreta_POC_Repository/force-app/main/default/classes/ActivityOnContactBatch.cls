/*
* Author : Gaurav Kumar 
* Description :  system will notify Account Team to arrange a meeting/session with Client
* Date : 22/12/2022
* Helper Class : ActivityOnContactBatchHelper
* Scheduled Class : ScheduledActivityOnContactBatch
* Test Class :
* User Story : U_119
* Work ID : W-000284
*/
global class ActivityOnContactBatch implements Database.Batchable<SObject> {
    global Database.QueryLocator start(Database.BatchableContext bc){
        return Database.getQueryLocator(ActivityOnContactBatchHelper.getQuery());
    }
    
    global void execute(Database.BatchableContext bc, List<Contact> conList){
        try{
            //System.debug('Size :'+conList.size());
            //System.debug('Contact List :'+conList);
            List<Messaging.SingleEmailMessage> mailsList = new List<Messaging.SingleEmailMessage>();
            List<Id> accIdList = new List<Id>();
            if(!conList.isEmpty()){
                for(Contact con : conList){
                    if(con.AccountId !=null){
                        accIdList.add(con.AccountId);
                    }
                }
            }
            //System.debug('Size :'+accIdList.size());
            List<AccountTeamMember> accTeamList = [SELECT User.Email, AccountId, Id FROM AccountTeamMember WHERE AccountId IN : accIdList];
            //System.debug('AccountTeamMember :'+accTeamList);
            for(AccountTeamMember teamMember : accTeamList) {
                for(Contact con : conList){
                    // For Email
                    if(con.AccountId == teamMember.AccountId){
                        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                        email.setToAddresses(new String[] {teamMember.User.Email});
                        email.setSubject('Hi Team');
                        String body = 'You are the relationship holder of this '+con.Name+'<br> <br>';
                        body += 'We have observed no activity, since last 15 days on this Client Contact '+con.Name+'<br> <br>';
                        body += 'Please continue to collaborate with '+con.Name+'<br> <br>';
                        body += 'Moreover, you can also invite your contacts, if required to campaigns/event organized by Marcom team.</br>';
                        body += 'Regards <br>';
                        body += 'LinKreta Team <br>';
                        email.setHtmlBody(body);
                        //System.debug('Email : ' + email);
                        mailsList.add(email);
                    }
                }
            }
            if(!mailsList.isEmpty()){
                Messaging.sendEmail(mailsList);
            }
        }
        Catch(Exception ex){
            System.debug('Error :'+ex.getMessage());
            System.debug('In Line Number :'+ex.getLineNumber());
        }
    }
    
    global void finish(Database.BatchableContext bc){
        
    }
}