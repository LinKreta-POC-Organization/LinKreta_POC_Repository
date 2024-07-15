/*
* @Name: SendEmailToCTM
* @Author: Bhavishya Basantwani
* @Description: This class is used for Send Email and Notification To Client Team Member.
* @Date: 28-July-23
*/
Public  Class SendEmailToCTM{
    
    @InvocableMethod()
    public static void MailToCixTeam(List<ActionRequest> getInfo){
        
         
         // Get those records based on the IDs
         System.debug('Total Number of SOQL Queries allowed in this apex code context: Start MailToCixTeam Method' +  Limits.getLimitQueries());
                System.debug('1.Number of Queries used in this apex code so far: ' + Limits.getQueries());
        
        List<Messaging.SingleEmailMessage> emailList = new List<Messaging.SingleEmailMessage>();
        String baseUrl = URL.getOrgDomainURL().toExternalForm();
        String Link;
        
       // EmailTemplate EmailTem = [select Id,Subject from EmailTemplate Where Id =: getInfo[0].TemlateId];
       // String Subject = EmailTem.Subject;
        Messaging.SingleEmailMessage mail = Messaging.renderStoredEmailTemplate( getInfo[0].TemlateId , getInfo[0].recipentid[0], getInfo[0].RecId[0]);
        for(ActionRequest accReqObj : getInfo){
            //  Loop for sending email to CTM 
            
            For(integer i=0 ; i<accReqObj.RecId.size(); i++){
                
                Messaging.SingleEmailMessage objMail = new Messaging.SingleEmailMessage();
                
                string[] to = new string[] {accReqObj.EmailAddress[i]};
                    objMail.setToAddresses(to);
                String body = mail.getHtmlBody();
                String Subject = mail.getSubject();
                System.debug('SubjectINN'+Subject);
                if(body.contains('{recipient.name}') && accReqObj.UserName != NUll && accReqObj.UserName.Size()>0){
                    body = body.replace('{recipient.name}',accReqObj.UserName[i]);
                }
                if(body.contains('{Team.Role}') && accReqObj.TeamRole != Null && accReqObj.TeamRole.Size()>0){
                    body = body.replace('{Team.Role}',accReqObj.TeamRole[i]);
                }
                if(body.contains('{Account.Name}') && accReqObj.RelatedRecName != Null && accReqObj.RelatedRecName.Size()>0){
                    body = body.replace('{Account.Name}',accReqObj.RelatedRecName[i]);
                }
                system.debug(body.contains('{Object.Link}') && accReqObj.RecId != Null &&  accReqObj.RecId.Size()>0 );
                if(body.contains('{Object.Link}')){
                    
                    Link = baseUrl + '/' + accReqObj.RecId[i];
                    
                    body = body.replace('{Object.Link}',Link);
                    
                }
                
                objMail.setHtmlBody(body);
             	objMail.setSubject(Subject);
                List<OrgWideEmailAddress> orgWideEmails =  [SELECT Id, Address, DisplayName FROM OrgWideEmailAddress WHERE DisplayName = 'Linkreta' LIMIT 1];
                if(orgWideEmails != null){
                    objMail.setOrgWideEmailAddressId(orgWideEmails[0].Id);
                }
                objMail.setSaveAsActivity(false);
                emailList.add(objMail);
                
            }
        }
        
        Messaging.SendEmailResult[] results = Messaging.sendEmail(emailList);
        
        System.debug('Total Number of SOQL Queries allowed in this apex code context: Finish MailToCixTeam Method' +  Limits.getLimitQueries());
                System.debug('1.Number of Queries used in this apex code so far: ' + Limits.getQueries());
        
       
    
   }
    
   
  /*  @future(callout = true)
    public static void processCtmEmail(String getInfo)
    {   
       
    } */
    
    
    
    
    
    public class ActionRequest{
        @InvocableVariable
        public List<string> RecId;
        @InvocableVariable
        public string TemlateId;
        @InvocableVariable
        public List<string> RecipentId;
        @InvocableVariable
        public List<string> EmailAddress;
        @InvocableVariable
        public List<string> UserName;
        @InvocableVariable
        public List<string> RelatedRecName;
        @InvocableVariable
        public List<string> TeamRole;
        
        
    }
}