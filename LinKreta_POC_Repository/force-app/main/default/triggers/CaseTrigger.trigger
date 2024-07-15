trigger CaseTrigger on Case (before insert,before update, after update, after insert) {
    if(Trigger.isBefore){
        if(Trigger.isUpdate){
            List<Case> caseList = new List<Case>();
           List<String> checkStatus = new List<String>();
            checkStatus.add('Closed');
            checkStatus.add('Converted to Enquiry');
            checkStatus.add('Converted to IE');
            for(Case caseObj:Trigger.New){
                if(Trigger.oldMap.get(caseObj.id).Status=='New' && !checkStatus.contains(caseObj.Status)){
                   caseList.add(caseObj); 
                }   
            }
            CaseTriggerHelper.updateStatusOnCase(caseList);
        }
    }
    /*By :-Suresh gupta
         *Date:- 22 Feb 2023
         *Purpose:- to send acknowledgement mail to Prospect
        */
        /*------------------------------------------------------*/
    if(Trigger.isAfter){
        system.debug('is after');
        if(Trigger.isUpdate){
            system.debug('is update');
            List<case> caseList = new List<Case>();
            for(Case caseObj :Trigger.New){
                if(caseObj.Status!=Trigger.oldMap.get(caseObj.id).Status && caseObj.Status == 'Converted to Enquiry'){
                    caseList.add(caseObj);
                    system.debug('Entry COndition matched');
                }
            }
            if(caseList.size()>0){
                CaseTriggerHelper.afterUpdateMethod(caseList);
                system.debug('Check---->');
            }
        }
    }
}