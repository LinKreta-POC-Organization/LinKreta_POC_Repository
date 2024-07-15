public without sharing class CheckDuplicateForNewClient {
    @AuraEnabled
    public static List<boolean> checkduplicate(string solution,string experty,string subexperty,string Company){
        List<Boolean> Listofvalues = New List<Boolean>();
        boolean isClientDuplicate=false;
        boolean isNewClientDuplicate=false;
        try {
            system.debug('experty'+experty);
            system.debug('subexperty'+subexperty);
            system.debug('Company'+Company);
            system.debug('solution'+solution);
            List<String> ListOfExperty= experty.split(';');
            List<String> ListOfSubExperty= subexperty.split(';');
            system.debug('ListOfExperty1'+ListOfExperty);
            ListOfExperty.sort();
            ListOfSubExperty.sort();
            system.debug('ListOfExperty2'+ListOfExperty);
            String expertyStr= string.join(ListOfExperty,'');
            String subexpertyStr=string.join(ListOfSubExperty,'');
            system.debug('str'+expertyStr);
            
            List<Account> clientrecord=[Select Name From Account Where name=:Company];
            if(clientrecord.size()!=0){
                isClientDuplicate=true; 
                Listofvalues.add(isClientDuplicate);
            }else{
                Listofvalues.add(isClientDuplicate);
            }
            for(Lead leadList:[Select id,SubexpertiesForDuplicateRule__c,Expertise_LT__c, ExpertiesForDuplicateRule__c, Company, Solution__c,IsConverted  from lead where IsConverted =false]){
                 
                if(!isNewClientDuplicate){
                    if(leadList.SubexpertiesForDuplicateRule__c==subexpertyStr && leadList.ExpertiesForDuplicateRule__c==expertyStr && leadList.Company==Company && leadList.Solution__c==solution){
                       
                        isNewClientDuplicate=true;
                        Listofvalues.add(isNewClientDuplicate);
                    }
                }
            }
            if(!isNewClientDuplicate){
                Listofvalues.add(isNewClientDuplicate);
            }
            system.debug('Listofvalues'+Listofvalues);
        } catch (Exception e) {
            System.debug('e.getMessage '+e.getLineNumber());
            throw new AuraHandledException(e.getMessage());
        }
        return Listofvalues;
    } 
    
}