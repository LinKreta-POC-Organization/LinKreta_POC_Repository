/*************************** 
* @Name        SisterConcernTrigger  
* @Author      Ayushi Sethi
* @Date        27/07/2023
****************************** */

trigger SisterConcernTrigger on Subsidiary__c (after insert) {
    if(Trigger.isInsert && Trigger.isAfter){
        //Commented By Prashant as Enquiry child Records will no longer needs to be created using Client child records
        //this method is creating Enquiry Joint Venture records whenever Joint Venture is created
        //SisterConcernTriggerHelper.createEnquirySisterConcern(Trigger.new);
    }
}