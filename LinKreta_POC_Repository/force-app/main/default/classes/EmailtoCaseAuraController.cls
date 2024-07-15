public without sharing class EmailtoCaseAuraController {
    @AuraEnabled
    public static Boolean createNewClient(String recordId){
        Boolean returnValue;
        System.debug('Inside Method');
        try {
            Case caseObj=[select id,CaseNumber,SuppliedName,Subject,Industry__c,SubIndustry__c,SuppliedEmail,Status,Client_Name__c,
                          Owner.Name,Lead_Created__c,Solution__c,Expertise__c,SuppliedPhone, Remarks__c, Website__c from Case
                          where id =: recordId];
            Group queue= [SELECT Id from Group WHERE Type = 'Queue' AND DeveloperName = 'SectorAssignmentTeam'];
            //List<Case> updateCaseList = new List<Case>();
            //List<Lead> updateLeadList = new List<Lead>();
            System.debug('Queue Name'+queue.id);
            if(caseObj != Null){
                System.debug('Case is not Empty' + caseObj);
                if(String.isNotBlank(caseObj.Industry__c) && String.isNotBlank(caseObj.SuppliedName) && String.isNotBlank(caseObj.SuppliedEmail)
                   && String.isNotBlank(caseObj.Website__c) && String.isNotBlank(caseObj.Client_Name__c) && caseObj.SuppliedPhone != null){
                       System.debug('Inside if');
                       String str=caseObj.SuppliedEmail;
                       String splitString = str.substringAfter('@');
                       String companyEmail = splitString.substringBefore('.');
                       caseObj.Lead_Created__c = true;
                       caseObj.Status = 'Converted to New Client';
                       Lead leadObj = new Lead();
                       leadObj.LastName = caseObj.SuppliedName!=null?caseObj.SuppliedName:caseObj.CaseNumber;//case number
                       leadObj.Status = 'New';
                       System.debug('check Industry'+caseObj.Industry__c);
                       leadObj.Industry__c= caseObj.Industry__c;
                       //leadObj.SubSector__c= caseObj.Sub_Sector__c; 
                       leadObj.Expertise_LT__c = caseObj.Expertise__c;
                       leadObj.Solution__c = caseObj.Solution__c;
                       leadObj.LeadSource = 'Email';
                       leadObj.Channel__c = 'Digital';
                       leadObj.MobilePhone = caseObj.SuppliedPhone !=null ? caseObj.SuppliedPhone : '';
                       leadObj.Preliminary_New_Clients__c = caseObj.id;
                       leadObj.Email = caseObj.SuppliedEmail !=null ? caseObj.SuppliedEmail : 'noemail@test.com';
                       leadObj.Company = caseObj.Client_Name__c;//email to case//new client source
                       try{
                           update caseObj;
                           insert leadObj;
                           System.debug('lead created : ' + leadObj.Id);
                           returnValue = true;
                       }
                       catch(Exception e){
                           System.debug('Error'+e.getLineNumber() + ' and message : ' + e.getMessage());
                           returnValue = false;
                       }
                   }
                
                else{
                    returnValue = false;
                        /*System.debug('Inside else');
                        String str=caseObj.SuppliedEmail;
                        String splitString = str.substringAfter('@');
                        String companyEmail = splitString.substringBefore('.');
                        caseObj.Lead_Created__c = true;
                        Lead leadObj = new Lead();
                        leadObj.LastName = caseObj.SuppliedName!=null?caseObj.SuppliedName:caseObj.CaseNumber;//case number
                        leadObj.Status = 'New';
                        System.debug('above owner id');
                        leadObj.OwnerId = queue.id;
                        System.debug('below Email');
                        leadObj.LeadSource = 'Email';
                        leadObj.Channel__c = 'Digital';
                        leadObj.Preliminary_New_Clients__c = caseObj.id;
                        leadObj.MobilePhone = caseObj.SuppliedPhone!=null?caseObj.SuppliedPhone:'';
                        leadObj.Email = caseObj.SuppliedEmail!=null?caseObj.SuppliedEmail:'noemail@test.com';
                        leadObj.Company = caseObj.Client_Name__c;//email to case//new client source
                        //updateLeadList.add(leadObj);
                        //updateCaseList.add(caseObj);*/
                }
            }
            
            System.debug('returnValue : ' + returnValue);
            return returnValue;            
        } 
        catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
            
        }
    }
}