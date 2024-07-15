/*
AUTHOR                   : Prashant Bansal
CREATED DATE             : 07-May-2024
PROJECT NAME / TICKET #  : EA Functionality
DESCRIPTION
This is a Flow(EA_Login_As_a_Partner_From_Login_Screen) Invocable class created to receive a collection of Partner user and other required details
*/
global class LoginAsAPartner_Cls {
    
    @InvocableMethod(label='Get Partner Details' category='Util')
    global static List<FlowResponse> getPartnerDetails(List<String> eaEmpIds) {
        List<FlowResponse> flowResponses = new List<FlowResponse>();
        if(eaEmpIds != null  && ! eaEmpIds.isEmpty()) {
            String eaEmpId = eaEmpIds[0];
            Set<Id> partnerUserIds = new Set<Id>();
            FlowResponse objResponse = new FlowResponse();
            List<User> partnerUsersQueried = new List<User>();
            String partnerGroupName = eaEmpId + '_Partner_Group';
            System.debug('partnerGroupName--'+partnerGroupName);

            List<GroupMember> lstGroupMemberPartner = [SELECT Id, GroupId, Group.Name, UserOrGroupId FROM GroupMember where Group.Name =: partnerGroupName];
            for(GroupMember member: lstGroupMemberPartner) {
                if(String.valueOf(member.UserOrGroupId).startsWith('005')) {
                    partnerUserIds.add(member.UserOrGroupId);        
                }
            }
            partnerUsersQueried = [SELECT Id, Name, Username,ProfileId FROM User where Id IN: partnerUserIds];
            if(! partnerUsersQueried.isEmpty()) {
                for(User usr: partnerUsersQueried) {
                    System.debug('Partner Name-'+usr.Name);
                    
                } 
                System.debug('Partner Group Id-'+lstGroupMemberPartner[0].GroupId);
                objResponse.partnerUsers = partnerUsersQueried;
                //objResponse.partnerGroupId = lstGroupMemberPartner[0].GroupId;
                //objResponse.eaGroupId = lstGroupMemberEA[0].GroupId;
                flowResponses.add(objResponse);
            }
            
        }
        return flowResponses;
    }
   
    global class FlowResponse {
        public FlowResponse() {
            partnerUsers = new List<User>();
        }
        
        @InvocableVariable
        global List<User> partnerUsers;
        //@InvocableVariable
        //global Id partnerGroupId;
        //@InvocableVariable
        //global Id eaGroupId;
    }
    
}