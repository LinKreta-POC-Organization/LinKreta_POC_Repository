/*
* @Name: CheckRequiredField
* @Author: Bhavishya Basantwani
* @Date: 1-september-23 (this class is used for making field Required before Ds Approval )
*/

public class CheckRequiredFields {
    
    @InvocableMethod()
    public Static List<String> requiredField(List<ID> AccountIdList){
        system.debug('innn');
        
        Id clientRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Client').getRecordTypeId();
        system.debug('clientRecordTypeId'+clientRecordTypeId);
        boolean CoCSL = False;
        boolean CSL = False;
        boolean youngCSL = False;
        String reuiredFields = '';
        List<String> blankFields = new List<String>();
        List<String> returnStringList = new List<String>();
        Map<String,String> mapOfFields = new Map<String,String>();
        
        List<Account> accountNewList = [select Id,name,RecordTypeId,Key_Account_Id__c , GT_Client_Group__c ,AccountType__c ,Website,Entity_Type__c,Country_Corridor__c,Key_Account__c,	
                                        SubIndustry__c,	Industry__c,Pan_No__c ,	Status__c, 	Corridor__c,Total_Employees__c,Key_Account_Category__c,
                                        BillingCity,BillingCountry, BillingStreet, BillingState,BillingPostalCode,ShareCapitalInCr__c,goog_alert__Google_Alert_URL__c,Entity_Type_Master__c,Domestic_Ultimate_Owner__c,Global_Ultimate_Owner__c,
                                        Total_Revenue__c,Total_No_of_employees__c,ClientAddress__Street__s,ClientAddress__City__s,ClientAddress__StateCode__s,ClientAddress__PostalCode__s,ClientAddress__CountryCode__s from Account where Id =: AccountIdList];
        
        //Fill Map with Field api name and with Label
        for(Account iterACC : accountNewList){
            if(( iterACC.Status__c == 'Pending Verification' && (iterACC.RecordTypeId == clientRecordTypeId ))){
                system.debug('Inn hendler');
                
                mapOfFields.put('GT_Client_Group__c',Schema.getGlobalDescribe().get('Account').getDescribe().fields.getMap().get('GT_Client_Group__c').getDescribe().getLabel());
                mapOfFields.put('goog_alert__Google_Alert_URL__c',Schema.getGlobalDescribe().get('Account').getDescribe().fields.getMap().get('goog_alert__Google_Alert_URL__c').getDescribe().getLabel());
                mapOfFields.put('Website',Schema.getGlobalDescribe().get('Account').getDescribe().fields.getMap().get('Website').getDescribe().getLabel());
                //mapOfFields.put('Entity_Type_Master__c',Schema.getGlobalDescribe().get('Account').getDescribe().fields.getMap().get('Entity_Type_Master__c').getDescribe().getLabel());
                mapOfFields.put('Total_Revenue__c',Schema.getGlobalDescribe().get('Account').getDescribe().fields.getMap().get('Total_Revenue__c').getDescribe().getLabel());
                mapOfFields.put('Country_Corridor__c',Schema.getGlobalDescribe().get('Account').getDescribe().fields.getMap().get('Country_Corridor__c').getDescribe().getLabel());
                mapOfFields.put('Industry__c',Schema.getGlobalDescribe().get('Account').getDescribe().fields.getMap().get('Industry__c').getDescribe().getLabel());
                mapOfFields.put('Pan_No__c',Schema.getGlobalDescribe().get('Account').getDescribe().fields.getMap().get('Pan_No__c').getDescribe().getLabel());
                mapOfFields.put('Status__c',Schema.getGlobalDescribe().get('Account').getDescribe().fields.getMap().get('Status__c').getDescribe().getLabel());
                mapOfFields.put('Corridor__c',Schema.getGlobalDescribe().get('Account').getDescribe().fields.getMap().get('Corridor__c').getDescribe().getLabel());
                mapOfFields.put('Total_No_of_employees__c',Schema.getGlobalDescribe().get('Account').getDescribe().fields.getMap().get('Total_No_of_employees__c').getDescribe().getLabel());
                mapOfFields.put('ShareCapitalInCr__c',Schema.getGlobalDescribe().get('Account').getDescribe().fields.getMap().get('ShareCapitalInCr__c').getDescribe().getLabel());
                // mapOfFields.put('Key_Account_Category__c',Schema.getGlobalDescribe().get('Account').getDescribe().fields.getMap().get('Key_Account_Category__c').getDescribe().getLabel());
                //mapOfFields.put('Client_s_Headquarter__City__s',Schema.getGlobalDescribe().get('Account').getDescribe().fields.getMap().get('Client_s_Headquarter__City__s').getDescribe().getLabel());
                // mapOfFields.put('Client_s_Headquarter__PostalCode__s',Schema.getGlobalDescribe().get('Account').getDescribe().fields.getMap().get('Client_s_Headquarter__PostalCode__s').getDescribe().getLabel());
                // mapOfFields.put('Client_s_Headquarter__StateCode__s',Schema.getGlobalDescribe().get('Account').getDescribe().fields.getMap().get('Client_s_Headquarter__StateCode__s').getDescribe().getLabel());
                //mapOfFields.put('Client_s_Headquarter__Street__s',Schema.getGlobalDescribe().get('Account').getDescribe().fields.getMap().get('Client_s_Headquarter__Street__s').getDescribe().getLabel());
                mapOfFields.put('SubIndustry__c',Schema.getGlobalDescribe().get('Account').getDescribe().fields.getMap().get('SubIndustry__c').getDescribe().getLabel());
                mapOfFields.put('ClientAddress__CountryCode__s',Schema.getGlobalDescribe().get('Account').getDescribe().fields.getMap().get('ClientAddress__CountryCode__s').getDescribe().getLabel());
                mapOfFields.put('ClientAddress__PostalCode__s',Schema.getGlobalDescribe().get('Account').getDescribe().fields.getMap().get('ClientAddress__PostalCode__s').getDescribe().getLabel());
                mapOfFields.put('ClientAddress__StateCode__s',Schema.getGlobalDescribe().get('Account').getDescribe().fields.getMap().get('ClientAddress__StateCode__s').getDescribe().getLabel());
                mapOfFields.put('ClientAddress__City__s',Schema.getGlobalDescribe().get('Account').getDescribe().fields.getMap().get('ClientAddress__City__s').getDescribe().getLabel());
                mapOfFields.put('ClientAddress__Street__s',Schema.getGlobalDescribe().get('Account').getDescribe().fields.getMap().get('ClientAddress__Street__s').getDescribe().getLabel());
                mapOfFields.put('Domestic_Ultimate_Owner__c',Schema.getGlobalDescribe().get('Account').getDescribe().fields.getMap().get('Domestic_Ultimate_Owner__c').getDescribe().getLabel());
                mapOfFields.put('Global_Ultimate_Owner__c',Schema.getGlobalDescribe().get('Account').getDescribe().fields.getMap().get('Global_Ultimate_Owner__c').getDescribe().getLabel());
            }
        }
        Map<Id,Account> MapOfAccount = new  Map<Id,Account>();
        Map<Account,List<AccountTeamMember>> MapOfListOfCTM = new Map<Account,List<AccountTeamMember>>();
        List<AccountTeamMember> ListOFCTM = [select id,TeamMemberRole,AccountId from AccountTeamMember where AccountId IN:  accountNewList];
        
        //fill Map With AccountId and Account Record
        For(Account acc : accountNewList){
            if(!MapOfAccount.containsKey(acc.Id)){
                MapOfAccount.put(acc.Id,acc);
            }
        }        
        
        
        //Fill map with Account and Its Associated CLient Team Member
        
        for(AccountTeamMember objCTM : ListOFCTM) {
            if(MapOfAccount.ContainsKey(objCTM.AccountId)){
                Account accRec = MapOfAccount.get(objCTM.AccountId);
                if(MapOfListOfCTM.containsKey(accRec)){
                    MapOfListOfCTM.get(accRec).add(objCTM);
                }
                else{
                    MapOfListOfCTM.put(accRec,new List<AccountTeamMember>{objCTM});
                }
            }
        }
        
        
        
        
        // Check Reuired Field is not null and Client Team Member is added or not with some Required Conditions
        for(Account objMapList : accountNewList){
            if(( objMapList.Status__c == 'Pending Verification' && (objMapList.RecordTypeId == clientRecordTypeId ))){
                
                for(String objMap : mapOfFields.keySet()){
                    
                    if(objMapList.get(objMap) == null){
                        blankFields.add(mapOfFields.get(objMap));
                    }
                }
                
                if(objMapList.Key_Account__c == true){
                    
                    if(objMapList.Key_Account_Category__c == null){
                        blankFields.add(Schema.getGlobalDescribe().get('Account').getDescribe().fields.getMap().get('Key_Account_Category__c').getDescribe().getLabel());
                    }
                    if(MapOfListOfCTM.containskey(objMapList)){
                        List<AccountTeamMember> CTMList = MapOfListOfCTM.get(objMapList);
                        
                        
                        for(AccountTeamMember CTM : CTMList)
                        {
                            
                            if(CTM.TeamMemberRole == 'Key Account – CSL')
                            {
                                CSL = true;
                            }
                            /*  if(CTM.TeamMemberRole == 'Key Account – Co-CSL')
{
CoCSL  = true;
}
*/
                        }
                        
                        /*if(CoCSL == False){
blankFields.add('Key Account – Co-CSL');
}*/
                        if(CSL == False){
                            blankFields.add('Key Account – CSL');
                        }
                    }
                    else{
                        // blankFields.add('Key Account – Co-CSL');
                        blankFields.add('Key Account – CSL');  
                        
                        //string fieldsShowString = string.join(blankFields,'  |  ');
                        //String finalString = 'Please update '  +  fieldsShowString + ' before approving';
                        //objMapList.addError(finalString);
                    }
                }
                /* else{
if(MapOfListOfCTM.containskey(objMapList)){
List<AccountTeamMember> CTMList = MapOfListOfCTM.get(objMapList);


for(AccountTeamMember CTM : CTMList)
{
if(CTM.TeamMemberRole == 'Young CSL')
{
youngCSL  = true;
}
}

if(youngCSL == False){
blankFields.add('Young CSL');
}
}

else{

blankFields.add('Young CSL');

// string fieldsShowString = string.join(blankFields,'  |  ');
// String finalString = 'Please update '  +  fieldsShowString + ' before approving';
// objMapList.addError(finalString);
}
} */
                
                // addError if Any field is null and CLient Team Member is not added (Field List = blankFields)
                if(blankFields.size()>0){
                    system.debug('inside add error');
                    //string fieldsShowString = string.join(blankFields,'  |  ');
                    //String finalString = 'Please update '  +  fieldsShowString + ' before approving';
                    //objMapList.addError(finalString);
                    
                    for(String val : blankFields)
                    {
                        reuiredFields = reuiredFields + '* ' +val +  '\n' ;
                    }
                    returnStringList.add(reuiredFields);
                    
                }
                
            }
        }
        
        return returnStringList; 
    }
    
}