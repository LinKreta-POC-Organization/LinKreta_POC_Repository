/*
* Author : Gaurav Kumar 
* Description :  System will notify to Account owner through email on client after status Approved
* Date : 22/12/2022
* Helper Class : SendEmailAccountOwnerBatchHelper
* Scheduled Class : ScheduledSendEmailAccountOwnerBatch
* Test Class :
* User Story : U_050
* Work ID : W-000211
*/
global class SendEmailAccountOwnerBatch implements Database.Batchable<SObject> {
    
    global Database.QueryLocator start(Database.BatchableContext bc){
        return Database.getQueryLocator(SendEmailAccountOwnerBatchHelper.getQuery());
    }
    global void execute(Database.BatchableContext bc, List<Account> accList){
        try{
            List<Messaging.SingleEmailMessage> mailsList = new List<Messaging.SingleEmailMessage>();
            if(!accList.isEmpty()){
                for(Account acc : [SELECT Id, Name ,Owner.Name, Owner.Email ,Status_DS_Team_Remark_Status__c FROM Account WHERE Id IN : accList]){
                    Messaging.SingleEmailMessage emailObj = new Messaging.SingleEmailMessage();
                    emailObj.setToAddresses(new String[] {acc.Owner.Email});
                    emailObj.setSubject('DS Team Approval');
                    String body = ' Hi ' + acc.Owner.Name + ', <br>';
                    body += 'Today is the 1st of <br> '+System.today();
                    body += 'This is a gentle reminder to send out invites and meet the Client at least once in this month. <br> <br>';
                    body += 'Regards <br>';
                    body += 'LinKreta Team';
                    emailObj.setHtmlBody(body);
                    mailsList.add(emailObj);
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