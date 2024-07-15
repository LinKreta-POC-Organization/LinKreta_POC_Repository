/*
NAME                     : SendEmailUsingApex_CLS
AUTHOR                   : Suraj Kumar
VERSION                  : 1
CREATED DATE             : 4th June 2023
PROJECT NAME / TICKET #  : U_032
DESCRIPTION
This is a Flow Invocable class created to send emails using 
Messaging.SingleEmailMessage(). We have multiple requirements 
where we need to send an email to more than 5 recipients and 
in some cases attach the Quote Document to the email message.
This custom class is to overcome the standard limitations which 
apply when using Email Alerts or the Send Email Action.


CHANGE HISTORY
--------------------------
AUTHOR                   : 
VERSION                  : 
MODIFICATION DATE        : 
PROJECT NAME / TICKET #  : 
DESCRIPTION              : 

*/

public class SendEmailUsingApex_CLS{ 
    
    
    @InvocableMethod
    public static void execute(List<processEmailRequest> listOfEmailRequests){
        System.debug('listOfEmailRequests : ' + listOfEmailRequests[0]);
        try{
            List<Messaging.SingleEmailMessage> emailMessages = new List<Messaging.SingleEmailMessage>();
            
            for (processEmailRequest currentEmailRequest : listOfEmailRequests){
                
                if((!(currentEmailRequest.varToAddresses).isEmpty()) || 
                   (String.isNotBlank(currentEmailRequest.varTemplateID)) || (String.isNotBlank(currentEmailRequest.varSubject)) 
                  ){   
                      Messaging.SingleEmailMessage emailMessageRequest = new Messaging.SingleEmailMessage();
                      emailMessageRequest.setWhatId(currentEmailRequest.varWhatId);
                      List<OrgWideEmailAddress> orgWideEmails =  [SELECT Id, Address, DisplayName FROM OrgWideEmailAddress WHERE DisplayName = 'Linkreta' LIMIT 1];
                      if(orgWideEmails != null){
                          emailMessageRequest.setOrgWideEmailAddressId(orgWideEmails[0].Id);
                      }
                      if(currentEmailRequest.varToAddresses != null){
                          emailMessageRequest.setToAddresses(currentEmailRequest.varToAddresses);
                      }
                      System.debug('ccAddress before : ' + currentEmailRequest.varCcAddresses);
                      if(currentEmailRequest.varCcAddresses != null){
                          for (Integer i = currentEmailRequest.varCcAddresses.size() - 1; i >= 0; i--) {
                              if (currentEmailRequest.varCcAddresses[i] == null) {
                                  currentEmailRequest.varCcAddresses.remove(i);
                              }
                          }
                          emailMessageRequest.setCcAddresses(currentEmailRequest.varCcAddresses);
                      }
                      System.debug('ccAddress after : ' + currentEmailRequest.varCcAddresses);
                      emailMessageRequest.setTreatTargetObjectAsRecipient(false);
                      
                      
                      if(currentEmailRequest.varTemplateID != NULL){
                          emailMessageRequest.setTemplateID(currentEmailRequest.varTemplateID);
                      }
                      
                      if(currentEmailRequest.varTemplateName == 'Campaign Live'){
                          String body = SendEmailUsingApex_CLS.sendEmailEnquiryTeam(currentEmailRequest.varRecordId,currentEmailRequest.varRecordURL);
                          emailMessageRequest.setHtmlBody(body);
                      }
                      
                      if(currentEmailRequest.varSaveAsActivity == NULL)
                      {
                          emailMessageRequest.setSaveAsActivity(FALSE);
                      }
                      else
                      {
                          emailMessageRequest.setSaveAsActivity(currentEmailRequest.varSaveAsActivity);
                      }
                      
                      if(String.isNotBlank(currentEmailRequest.varTargetObjectId))
                      {
                          emailMessageRequest.setTargetObjectId(currentEmailRequest.varTargetObjectId);
                      }
                      else
                      {
                          emailMessageRequest.setTargetObjectId(UserInfo.getUserId());
                      }
                      if(String.isNotBlank(currentEmailRequest.varBody))
                      {
                          // emailMessageRequest.setPlainTextBody(currentEmailRequest.varBody);// Commented by Prashant to fix issue W-002907 on 10-Apr-2024
                          emailMessageRequest.setHTMLBody(currentEmailRequest.varBody);
                      }
                      // Added By Prashant to fix issue W-002907 on 10-Apr-2024
                      if(String.isNotBlank(currentEmailRequest.varSubject))
                      {
                          emailMessageRequest.setSubject(currentEmailRequest.varSubject);
                      }
                      System.debug('currentEmailRequest : ' + currentEmailRequest);
                      emailMessages.add(emailMessageRequest);
                  }
            }
            
            if(!emailMessages.isEmpty()){
                Messaging.sendEmail(emailMessages);
            }
            else{
                
            }
        }
        catch(Exception e){
            System.debug('Error message : ' + e.getMessage() + ' in line : ' + e.getLineNumber());
        }
        
    }
    
    public class processEmailRequest{
        
        @InvocableVariable
        public String varTargetObjectId;
        //The ID of the contact, lead, or user to which the email will be sent.
        //The ID you specify sets the context and ensures that merge fields in the template contain the correct data.
        
        @InvocableVariable
        public String varWhatId;
        //The recordId which will be used to populate the merge fields in the template.
        
        @InvocableVariable
        public List<String> varToAddresses;
        //A list of email addresses
        
        @InvocableVariable
        public String varTemplateID;
        //The ID of the template used to create the email.
        
        @InvocableVariable
        public String varTemplateName;
        //The TemplateName used to create the email.
        
        @InvocableVariable
        public String varRecordId;
        //The Record Id used to create the email.
        
        @InvocableVariable
        public String varRecordURL;
        //The Record URL used to create the email.
        
        @InvocableVariable
        public String varSubject;
        //The Subject used to create the email.
        
        @InvocableVariable
        public String varBody;
        // used to set the email body.
        
        @InvocableVariable
        public Boolean varSaveAsActivity;
        
        @InvocableVariable
        public List<String> varCcAddresses;
        //Indicates if you want the email is saved as an activity. 
        //This argument only applies if the recipient list is based on targetObjectId or targetObjectIds.
        //If HTML email tracking is enabled for the organization, you will be able to track open rates.
        
    }
    
    public static String sendEmailEnquiryTeam(String recordId,String recordUrl){
        if(recordId != null){
            //Campaign tmpObj = [SELECT Id, Name,EndDate,StartDate,Campaign_Request__r.Enquiry__r.Name,Campaign_Request__r.Client__r.Name,Campaign_Request__r.Enquiry__r.Description,Campaign_Request__r.Type_of_Campaign__c FROM Campaign  WHERE Id=:recordId]; //Phase-1
            Campaign tmpObj = [SELECT Id, Name,EndDate,StartDate,Campaign_Request__r.Client__r.Name,Campaign_Request__r.Type_of_Campaign__c FROM Campaign  WHERE Id=:recordId];
            //System.debug('Start Name :'+tmpObj.Campaign_Request__r.Enquiry__r.Name);
            String body='';
            body += '<br> Hello Enquiry Team, </br></br>';
            body += '<br> </br>' ;
            //body += '<br> The campaign related to </br>'+tmpObj.Campaign_Request__r.Enquiry__r.Name+' for '+tmpObj.Campaign_Request__r.Client__r.Name+'<br>is live and running. The details of the client are below.</br></br>';//Phase-1
            body += '<br> </br>' ;
            // body += '<br> Enquiry Description : </br>'+tmpObj.Campaign_Request__r.Enquiry__r.Description; //Phase-1
            body += '<br> Campaign start date : </br>'+tmpObj.StartDate;
            body += '<br> Campaign end date : </br>'+tmpObj.EndDate;
            body += '<br> Name of campaign : </br>'+tmpObj.Name;
            body += '<br> Type of campaign : </br>'+tmpObj.Campaign_Request__r.Type_of_Campaign__c;
            body += '<br> </br>' ;
            body += '<br> To access the live campaign on LinKreta, please click on the following link: </br></br>';
            body += '<br> </br>' ;
            body += recordUrl;
            body += '<br> Note:- This is a System Generated E-Mail. Please do not reply to this mail. </br>';
            return body;
        }
        return null;
    }
    public static void sendEmailTONCO(List<Lead> duplicateLeadList){
        System.debug('duplicateLeadList :'+duplicateLeadList);
        try{
            List<Messaging.SingleEmailMessage> emailMessages = new List<Messaging.SingleEmailMessage>();
            for(Lead leadObj : duplicateLeadList){
                String body='';
                body += 'Hi '+leadObj.FirstName +' '+leadObj.LastName;
                body += '<br> You client has already been accepted. Please proceed to create Integrated Enquiry for your New client: </br>'+system.URL.getSalesforceBaseUrl().toExternalForm()+'/'+leadObj.Id;
                body += 'Thanks & Regards';
                Messaging.SingleEmailMessage emailMessageRequest = new Messaging.SingleEmailMessage();
                emailMessageRequest.setSenderDisplayName('Linkreta');
                emailMessageRequest.setToAddresses(new List<String> {leadObj.Owner.Email});
                emailMessageRequest.setSubject('Dupicate record');
                emailMessageRequest.setHtmlBody(body);
                emailMessages.add(emailMessageRequest);
            }
            if(!emailMessages.isEmpty()){
                Messaging.sendEmail(emailMessages);
            }
        }
        Catch(Exception ex){
            System.debug('Error :'+ex.getStackTraceString());
        }
    }
    
}