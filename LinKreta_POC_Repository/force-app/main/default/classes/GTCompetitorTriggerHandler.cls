/*
AUTHOR                   : Deepak joshi
VERSION                  : 1
MODIFICATION DATE        : 13 june 2023
PROJECT NAME / TICKET #  : GT
DESCRIPTION              : GT Competitor Trigger Handler

AUTHOR                   :
VERSION                  :2
MODIFICATION DATE        : 
PROJECT NAME / TICKET #  : 
DESCRIPTION              : 
*/
public class GTCompetitorTriggerHandler {
    /**
     * 
    * @description 
    * @author Deepak Joshi | 13 june 2023
    * @param gtCompetitors 
    **/

    public static void handleCompetitorRecords(List<GT_Competitor__c> gtCompetitors) {
        //Start SFDC-[Phase-1]: code is added by Biplow sarkar | 03-04-2024
        /*
        Set<Id> enquiryIds = new Set<Id>();
        Map<Id, Opportunity> enquiriesMap = new Map<Id, Opportunity>();

        // Collect all related Enquiry IDs
        for (GT_Competitor__c gtCompetitor : gtCompetitors) {
            enquiryIds.add(gtCompetitor.Enquiry__c);
            
        }

        // Retrieve the related Enquiries and store them in a map
        enquiriesMap = new Map<Id, Opportunity>([
            SELECT Id, OwnerId,StageName, (SELECT UserId FROM OpportunityTeamMembers)
            FROM Opportunity
            WHERE Id IN :enquiryIds
        ]);
        //Get Logged-in User Id
        User loggedInUser = [SELECT ID, PartnerLogin_UserID__c FROM User  WHERE Id =: UserInfo.getUserId() Limit 1];

        // group user
        Map<Id, User> userOrGroupMap = new Map<Id, User>();
        userOrGroupMap =  new Map<Id, User>([SELECT Id, Name, IsActive, PartnerLogin_UserID__c FROM User 
                      WHERE IsActive =true AND Id IN  
                      (SELECT UserOrGroupId FROM GroupMember  WHERE Group.DeveloperName =:ConstantUtility.GROUP_CM_TEAM OR Group.DeveloperName =:ConstantUtility.GROUP_CRM_TEAM)]);
       
        Set<String> stageValues = new Set<String>{'Determine Problem & Impact','Validate Benefits & Value','Confirm Value With Client','Negotiation & Mutual Plan','Nurture & Finalizing Closure'};
            if(Label.Linkreta_Integration_User_Id_18_Digits != UserInfo.getUserId()){
            for (GT_Competitor__c gtCompetitor : gtCompetitors) {
            Opportunity relatedEnquiry = enquiriesMap.get(gtCompetitor.Enquiry__c);
            // check enquiry stage
            if(relatedEnquiry.StageName == ConstantUtility.STAGE_CLOSED_WON || relatedEnquiry.StageName == ConstantUtility.STAGE_CLOSED_LOST ){
                gtCompetitor.addError(Label.Error_Message_Enquiry_Closed);
            }
           else if(!stageValues.contains(relatedEnquiry.StageName)){
                gtCompetitor.addError(Label.Error_Message_Enquiry_Stage);

           }
            // Check if the user is not the Enquiry Owner or not in the Opportunity Team
            if (relatedEnquiry.OwnerId != UserInfo.getUserId() && relatedEnquiry.OwnerId != loggedInUser.PartnerLogin_UserID__c
                    && !isUserInOpportunityTeam(relatedEnquiry, UserInfo.getUserId(),userOrGroupMap) ) {
                gtCompetitor.addError(Label.Error_Message_Enquiry_Owner_Team_Member);
            }
        }
            }
    */
    //End SFDC-[Phase-1]: code is added by Biplow sarkar | 03-04-2024

    }
   /**
     * 
    * @description 
    * @author Deepak Joshi | 13 june 2023
    * @param enquiry 
    * @param userId 
    * @param userOrGroupMap 
    **/
    @testvisible
    private static Boolean isUserInOpportunityTeam(Opportunity enquiry, Id userId, Map<Id, User> userOrGroupMap) {
        //Start SFDC-[Phase-1]: code is added by Biplow sarkar | 03-04-2024
        /*
        Id profileId=userinfo.getProfileId();
        String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
        for (OpportunityTeamMember teamMember : enquiry.OpportunityTeamMembers) {
            if (profileName == 'GT Integration' || teamMember.UserId == userId ||(Trigger.isUpdate && userOrGroupMap.containsKey(userId))) {
                return true;
            }
        }
        */
        //End SFDC-[Phase-1]: code is added by Biplow sarkar | 03-04-2024
        return false;
    }
}