public without sharing class EmailtoCaseLWCController {
    @AuraEnabled(Cacheable = true)
    public static List<Case> getEmailtoCase(){
        List<Case> caseList = [select id,CaseNumber,Subject,SuppliedEmail,SuppliedName,Owner.Name,Lead_Created__c from Case
                               where Owner.Name='Email to Case Queue' AND Lead_Created__c=false ];
        
        return caseList;
    }
    @AuraEnabled
    public static void createLead(List<String> selectedCaseList){
        System.debug('Inside Method'+selectedCaseList);
        try {
            List<Case> caseList=[select id,CaseNumber,SuppliedName,Subject,Industry__c,SubIndustry__c,SuppliedEmail,
                                 Owner.Name,Lead_Created__c,Solution__c,Expertise__c,SuppliedPhone from Case
                                 where CaseNumber IN: selectedCaseList ];
            List<Group> queueName= [SELECT Id from Group WHERE Type = 'Queue' AND DeveloperName = 'SectorAssignmentTeam' ];
            List<Case> updateCaseList = new List<Case>();
            List<Lead> updateLeadList = new List<Lead>();
            System.debug('Queue Name'+queueName[0].id);
            if(!caseList.isEmpty()){
                System.debug('Case List is not Empty'+caseList);
                for(Case caseObj:caseList){
                    //if((String.isNotBlank(caseObj.Industry__c) || String.isNotBlank(caseObj.Expertise__c) || String.isNotBlank(caseObj.Solution__c))){
                    if((String.isNotBlank(caseObj.Industry__c) || String.isNotBlank(caseObj.Expertise__c))){
                        System.debug('Inside if');
                        String str=caseObj.SuppliedEmail;
                        String splitString = str.substringAfter('@');
                        String companyEmail = splitString.substringBefore('.');
                        caseObj.Lead_Created__c = true;
                        Lead leadObj = new Lead();
                        leadObj.LastName = caseObj.SuppliedName!=null?caseObj.SuppliedName:caseObj.CaseNumber;//case number
                        leadObj.Status = 'New';
                        System.debug('check sector'+caseObj.Industry__c);
                        leadObj.Industry__c= caseObj.Industry__c;
                        //leadObj.SubIndustry__c= caseObj.Sub_Sector__c; 
                        leadObj.Expertise_LT__c = caseObj.Expertise__c;
                        //leadObj.Solution__c = caseObj.Solution__c;
                        leadObj.LeadSource = 'Email';
                        leadObj.Channel__c = 'Digital';
                        leadObj.Preliminary_New_Clients__c = caseObj.id;
                        leadObj.MobilePhone = caseObj.SuppliedPhone!=null?caseObj.SuppliedPhone:'';
                        leadObj.Email = caseObj.SuppliedEmail!=null?caseObj.SuppliedEmail:'noemail@test.com';
                        leadObj.Company = companyEmail;//email to case//new client source
                        updateLeadList.add(leadObj);
                        updateCaseList.add(caseObj);
                    }
                    else{
                        System.debug('Inside else');
                        String str=caseObj.SuppliedEmail;
                        String splitString = str.substringAfter('@');
                        String companyEmail = splitString.substringBefore('.');
                        caseObj.Lead_Created__c = true;
                        Lead leadObj = new Lead();
                        leadObj.LastName = caseObj.SuppliedName!=null?caseObj.SuppliedName:caseObj.CaseNumber;//case number
                        leadObj.Status = 'New';
                        System.debug('above owner id');
                        leadObj.OwnerId = queueName[0].id;
                        System.debug('below Email');
                        leadObj.LeadSource = 'Email';
                        leadObj.Channel__c = 'Digital';
                        leadObj.Preliminary_New_Clients__c = caseObj.id;
                         leadObj.MobilePhone = caseObj.SuppliedPhone!=null?caseObj.SuppliedPhone:'';
                        leadObj.MobilePhone = caseObj.SuppliedPhone!=null?caseObj.SuppliedPhone:'';
                        leadObj.Email = caseObj.SuppliedEmail!=null?caseObj.SuppliedEmail:'noemail@test.com';
                        leadObj.Company = companyEmail;//email to case//new client source
                        updateLeadList.add(leadObj);
                        updateCaseList.add(caseObj);
                    }
                }
                try{
                    update updateCaseList;
                    insert updateLeadList; 
                }
                catch(Exception e){
                    System.debug('Error'+e.getLineNumber());
                }
                
            }            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}