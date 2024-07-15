/*
AUTHOR                   : Prashant Bansal
CREATED DATE             : 07-May-2024
PROJECT NAME / TICKET #  : EA Functionality
DESCRIPTION
This is a Flow(EA_Login_As_a_Partner_From_Login_Screen) Invocable class created to switch EA User Permissions and Access
*/
public class SwitchUserProfile_Cls {
    
    @InvocableMethod
    public static List<String> switchUserProfile(List<RequestWrapper> requests) {
        List<String> lstStringToReturn = new List<String>();
        for (RequestWrapper request : requests)
        { 
            String partnerUserId ;
            if(request.partnerUserId != null) {
                System.debug('request.partnerUserId--'+request.partnerUserId);
                partnerUserId = request.partnerUserId;   
            }
            lstStringToReturn.add(EAPartnerLoginUtils.switchUserProfile(request.eaUserId, partnerUserId, request.isLoginAsEA));
        }
        return lstStringToReturn;
    }
    
    public class RequestWrapper{
        @InvocableVariable
        public String eaUserId;    
        @InvocableVariable
        public String partnerUserId; 
        @InvocableVariable
        public Boolean isLoginAsEA; 
    }
}