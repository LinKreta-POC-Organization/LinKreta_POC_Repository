/*
 Written By: Rohitash mourya
     Created Date: 22/02/2023
     Last Modified By : Rohitash mourya
     Last Modified Date : 16-03-23
     Description : This class is used to create new client from Lwc and check duplicate client name
     Variable Used in Method : -
       leadObject: Stringify object recevied from new client lwc page .
       accountName: Client name recieved from new client lwc page for duplicate check in new client records
*/

public with sharing class CreateleadHelper {
    @AuraEnabled
    Public static String Createlead(String leadObject, List<String> selectedExpertise) {
        string str=null;
        CustomResponse response = new CustomResponse();
        response.status = 'Ok';
        system.debug('Lead Object ---->'+leadObject);
        try {
            Lead leadlist=(Lead)JSON.deserialize(leadObject,lead.class);
            System.debug('leadlist : ' + leadlist);            
            if(leadlist!=null){
                if(! String.isBlank(leadlist.capIQId__c)) {
                    leadlist.External_Database_Source__c = 'CapIQ';
                } else if(! String.isBlank(leadlist.MCA_ID__c)) {
                    leadlist.External_Database_Source__c = 'MCA';
                }
                insert leadlist;
                Lead LeadQueried = [SELECT Id, NewClientNo__c, Company, LeadSource, Name, Email, MobilePhone, capIQId__c, MCA_ID__c, External_Database_Source__c FROM Lead WHERE Id =: leadlist.Id];
                if(!selectedExpertise.isEmpty()){
                    Map<Id, ExpertiseMaster__c> expertiseMap = new Map<Id, ExpertiseMaster__c>([SELECT Id, Name FROM ExpertiseMaster__c WHERE Id IN: selectedExpertise]);
                    List<Enquiry_Expertise__c> lineItemsToInsert = new List<Enquiry_Expertise__c>();
                    for (String expertiseId : selectedExpertise) {
                        Enquiry_Expertise__c lineItemObj = new Enquiry_Expertise__c();
                        lineItemObj.Enquiry__c = LeadQueried.Id;
                        lineItemObj.Expertise_Master__c = expertiseId;
                        lineItemObj.Name = expertiseMap.get(expertiseId).Name;
                        lineItemsToInsert.add(lineItemObj);
                    }

                    if(!lineItemsToInsert.isEmpty()){
                        insert lineItemsToInsert;
                    }
                }

                response.body = LeadQueried.Id;
                
                /*Added on 05Apr as per phase-1 -->*/
                System.debug('LeadQueried.capIQId__c--'+LeadQueried.capIQId__c);
                System.debug('LeadQueried.MCA_ID__c--'+LeadQueried.MCA_ID__c);
                if(String.isBlank(LeadQueried.capIQId__c) && String.isBlank(LeadQueried.MCA_ID__c)) {
                    //Lead leadQueried = [SELECT Id, Name FROM Lead WHERE Id =: LeadQueried.Id];
                    EmailTemplate et = [SELECT Id,Subject, HTMLValue ,DeveloperName FROM EmailTemplate Where DeveloperName = 'Enquiry_No_data_received_from_CapIQ_and_MCA'];
                    List<OrgWideEmailAddress> orgWideEmails = [SELECT Id, Address, DisplayName FROM OrgWideEmailAddress WHERE DisplayName = 'Linkreta' LIMIT 1];
                    List<string> toAddress = new List<string>();
                    toAddress.addAll(capIQButtontoUpdateClient.getActiveUsersFromGroup('C_M_Team'));
                    System.debug('toAddress--'+toAddress);
                    	
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    mail.setTemplateId(et.Id);
                    //toAddress = new List<Id>();
                    if(orgWideEmails != null){
                        mail.setOrgWideEmailAddressId(orgWideEmails[0].Id);
                    }
                    mail.setToAddresses(toAddress);
                    
                    mail.setSubject(et.subject);
                    String strEmailBody;
                    System.debug('strEmailBody--'+strEmailBody);
                    String EnquiryLink = URL.getSalesforceBaseURL().toExternalForm() + '/' + String.valueOf(LeadQueried.Id);
                    
                    strEmailBody = et.HTMLValue;
                    strEmailBody = strEmailBody.replace('{LeadNewClientNo}', LeadQueried.NewClientNo__c);
                    strEmailBody = strEmailBody.replace('{LeadCompany}', LeadQueried.Company);
                    strEmailBody = strEmailBody.replace('{LeadLeadSource}', LeadQueried.LeadSource);
                    strEmailBody = strEmailBody.replace('{LeadName}', LeadQueried.Name);
                    strEmailBody = strEmailBody.replace('{LeadEmail}', LeadQueried.Email);
                    strEmailBody = strEmailBody.replace('{LeadMobilePhone}', LeadQueried.MobilePhone);                    
                    strEmailBody = strEmailBody.replace('{LeadLink}', enquiryLink);
                    System.debug('strEmailBody--'+strEmailBody);
                    mail.setHTMLBody(strEmailBody);
                    mail.setTargetObjectId(LeadQueried.Id);
                    mail.setTreatTargetObjectAsRecipient(false);
                    //mail.setTargetObjectId(toAddress[0]);
                    mail.setWhatId(LeadQueried.Id);
                    mail.setSaveAsActivity(false);
                    mail.setUseSignature(false);
                    List<Messaging.SingleEmailMessage> allmsg = new List<Messaging.SingleEmailMessage>();
                    allmsg.add(mail);
                    
                    try {
                        Messaging.sendEmail(allmsg,true);
                        System.debug('@@@Success@@@');
                        response.status = 'Ok';
                    } catch (Exception e) {
                        System.debug('@@@ERROR@@@');
                        System.debug(e.getMessage());
                        System.debug(e.getLineNumber());
                        response.status = 'Fail';
                        response.body = e.getMessage();
                    }  
                }
                /*<--Added on 05Apr as per phase-1*/
                
                 
            }
         
        } catch (Exception ex) {
            System.debug(ex);
            ErrorLogCreater_cls.apexDebugLogger(ex, 'CreateleadHelper', 'Createlead', null);
            response.status = 'Fail';
            String errorMessage = ex.getMessage();
            if(errorMessage.contains('INVALID_EMAIL_ADDRESS')){
                response.body = 'The entered email address is invalid, Please enter a valid email address.';
            } else {
                response.body = ex.getMessage();
            }
            
        }
        str =  JSON.serialize(response);
        return str;
    }

    @AuraEnabled
    Public static Boolean findDuplicateAccount(String companyName){
        Boolean leadMatched;
        try{
            List<Account> listOfAccount = new List<Account>();
            listOfAccount = [SELECT Id, Name FROM Account WHERE Name =: companyName];
           
            if(!listOfAccount.isEmpty()){
                leadMatched = true;
            }
            else{
                leadMatched = false;
            }
            return leadMatched;
        }
        catch(Exception ex){
            return leadMatched;
        }
    }

    public class CustomResponse {
        @AuraEnabled
        public string status { get;set;}
        @AuraEnabled
        public String error {get;set;}
        @AuraEnabled
        public string body { get;set;}
    }

}