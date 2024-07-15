global class Batch_SendContactDuplicateReport implements Database.Batchable<SObject>, Database.stateful {
    global List<String> emailRecipients = new List<String>();
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        
        return Database.getQueryLocator(Batch_SendContactDuplicateReportHandler.getQuery());
    }
    
    global void execute(Database.BatchableContext bc, List<Contact> contactList) {
        try {
            if (!contactList.isEmpty()) {
                emailRecipients = Batch_SendContactDuplicateReportHandler.sendEmailToClientAndContactTeam(contactList, emailRecipients);
                
            }
        } catch (Exception e) {
            System.debug('Error message : ' + e.getMessage() + ' in line number : ' + e.getLineNumber());
        }
    }
    
    global void finish(Database.BatchableContext bc) {
    }
}