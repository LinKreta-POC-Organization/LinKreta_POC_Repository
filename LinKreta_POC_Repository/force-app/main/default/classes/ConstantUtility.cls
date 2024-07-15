/* 
Written By: Ayush Joshi
Created Date: 04-06-2023
Last Modified By : Prashant Bansal
Last Modified Date : 05-Sept-2023
*/
public class ConstantUtility {
    public static boolean integrtedEnquiryRecursion = false;
    //Start U_225: Code added by Deepak Joshi on 13 June-2023
    public static String GROUP_CM_TEAM ='C_M_Team';
    public static String GROUP_CRM_TEAM ='CRM_Team';
    public static String STAGE_CLOSED_WON ='Closed Won';
    public static String STAGE_CLOSED_LOST ='Closed Lost'; 
    //End U_225
    
    // Suraj(22-06-2023) : U_155
    public static String Enquiry_Approval_For_CSL_CoCSL ='Enquiry_approval_for_CSL_Co_CSL';
    public static String Enquiry_Approval_For_REL ='Enquiry_approval_for_REL';
    public static String Enquiry_Approval_For_BUL ='Enquiry_approval_for_BUL';
    public static String Auto_Approval_Comment ='Auto Approved by System';
    public static String Comment_Mandatory_Message ='Process failed. First exception on row 0; first error: FIELD_CUSTOM_VALIDATION_EXCEPTION, Please provide comments.: []';
    
    //Added by Deepak Joshi
    public static String Client_RecordType_Client = 'Client';
    public static String PITCH_PRESENTATION = 'Pitch Presentation';  
    public static String PITCH_DECK = 'Pitch Deck';
    public static String PROPOSAL = 'Proposal';
    public static String REQUEST_FOR_CUSTOMIZED_CLIENT_PROPOSAL = 'Request For Customized Client Proposal';
    public static String REQUEST_FOR_SUPPORTING_CONTENT = 'Request For Supporting Content';
    // End by Deepak Joshi
    
    //Start GS345-40 Added by Deepak Joshi 12-07-2023
    public static String NEW_CLIENT_CREATION ='New Client Creation';
    public static String RECORD_TYPE_CLIENT ='Client';
    public static String SEGMENT_LEADER ='Segment Leader';
    public static String RELATIONSHIP_LEADER = 'Relationship Leader';
    public static String SECTOR_BUSINESS_PARTNER ='Sector Business Partner';
    public static String NON_KEY_CLIENT  = 'Non Key Account';
    public static String DS_APPROVED  = 'DS Approved';
    public static String CLIENT_ACCOUNT  = 'Client Account';
    
    public static String CampaignStatusClose = 'Closed';
    public static String TaskStatusCompleted = 'Completed';
    public static String CampaignTrigger = 'CampaignBeforeUpdate';
    public static String CampaignMemberTrigger = 'Campaign_Member_Trigger';
    public static String SurveyInvitationTrigger = 'Survey_Invitation_Trigger';
    public static String JobTrigger = 'Job_Trigger';
    public static String CampaignApprovalPending = 'Approval Pending';
    public static String CampaignApproved = 'Approved';
    public static String CampaignRejected = 'Not Approved';
    public static String KEY_ACCOUNT =  'Key_Account';
    public static String APPROVED =  'Approved';
    public static String SUBMITTED =  'Submitted';
    public static String REJECTED='Rejected';
    public static String APPROVE_REJECT_ERROR_MESSAGE  = 'Please provide comments.';
    public static String DS_APPROVAL_PROCESS ='DS_Team_Account_Name_Change_Approval';
    public static String CNM_APPROVAL_PROCESS = 'CNM_Team_New_Client_Name_Change_Approval';
    public static String SUCCESS =  'Success';
    public static String OK =  'Ok';
    public static String SYNC_FAILED_EMAIL_TEMPLATE = 'Email_Template_for_API_SYNC_Fail';
    public static String NPS_QUESTION = 'How likely is it that you would recommend Grant Thornton to another organisation or a colleague?';
    //End GS345-40
    
    //Suraj
    public static String contactLastModifiedDate = 'Last Modified Date';
    public static String systemModstamp = 'System Modstamp';
    public static String contactLastActivityTime = 'Last Activity Date Time';
    public static String contactLastModifiedByID = 'Last Modified By ID';
    public static String clicktoviewClientContact = 'Click to view Client Contact';
    public static String ContactTrigger = 'Contact_Trigger';
    public static String UserTrigger = 'User_Trigger';
    public static String LeadTrigger = 'Lead_Trigger';
    public static String IntroHiveLastUpdateTime = 'Last Update Time';
    public static String ContactWCGTId = 'WCGT Id';
    public static String LinkedInProfile = 'LinkedIn Profile';
    public static String TopConnectedColleague = 'Top Connected Colleague';
    public static String TopRelationshipStrength = 'Top Relationship Strength';
    public static String CorporateRelationshipStrength = 'Corporate Relationship Strength';
    public static String DepartmentClassification = 'Department Classification';
    public static String FindIntroductions = 'Find Introductions';
    public static String LastInteraction = 'Last Interaction';
    public static String LastInteractionType = 'Last Interaction Type';
    public static String LastModifiedFromIntrohiveBy = 'Last Modified From Introhive By';
    public static String PopulatedbyIntrohive = 'Populated by Introhive';
    public static String IntrohiveIntroCount = 'Introhive Intro Count';
    public static String CreatedFromIntrohiveBy = 'Created From Introhive By';
    public static String TitleCategory = 'Title Category';
    public static String UpdatedbyIntrohive = 'Updated by Introhive';
    public static String IntrohiveLinkedInURL = 'LinkedIn Url';

    
    public static String TEAM_MEMBER_EXISTS  = 'Team member role already exists';
    public static String ONLY_ONE_USER_ROLE = 'only one role will be assigned to one user';
    public static String KEY_ACCOUNT_CO_CSL  = 'Key Account – CSL';
    public static String KEY_ACCOUNT_CSL  = 'Key Account – CSL';
    public static String ADD_CO_CSL_MESSAGE  = 'Please add Key Account – CSL team Member on Key Account First';
    public static String ENQUIRY_ACCESS   = 'Enquiry Access should be Read/Write only';
    public static String CLIENT_CONTACT_ACCESS  = 'Client Contact Access should be Read only';
    public static String PRELIMINARY_ACCES  = 'Preliminary New Client Access should be Read/Write only'; 
    public static String CLIENT_TEAM_ROLES  = 'Account Director,Other,Corridor Expert,Segment Leader,Solution Expert,Key Account – Co-CSL,Key Account – CSL,Relationship Leader,Sector Expert,Young CSL,Industry Leader,Office Managing Partner';
    public static String CLIENT_TEAM_ROLES_ERROR_MESSAGE = 'You have selected an Enquiry role which is not valid on an Account team';   
    public static String CLIENT_TEAM_ROLES_FOR_MULTIPLE_USERS = 'Key Account – CSL,Key Account – Co-CSL,Young CSL,Segment Leader,Industry Leader';   // Added by Suraj 31-05-2024
    
    

    
    public static String ClientContact_KeyContactIdentifier_BOD = 'BOD';// Added by Prashant
    public static String ClientContact_KeyContactIdentifier_KMP = 'KMP';// Added by Prashant
    public static String Enquiry_RCC_Deletion_Validation_Msg = 'RCC can only be deleted at "Identify/Create Enquiry" stage'; // Added by Prashant
    
    public static String Enquiry_EnquiryApprovalStatus_Approved = 'Approved';// Added by Prashant
    public static String Enquiry_StageName_ClosedWon = 'Closed Won';// Added by Prashant
    public static String RCCActualMatch_Status_NoConflict = 'No Conflict';	// Added by Prashant
    
    //Rakesh 19-05-2023
    public static String TASK_TRIGGER  = 'Task_Trigger';
    public static String CAMPAIGN_EXPENSE_TRIGGER  = 'Campaign_Expense_Trigger';
    public static String EVENT_TRIGGER  = 'EventTrigger';
    public static String STAGE_NEW  = 'New';
    public static String STATUS_WCGT_NEW  = 'New';
    public static String STAGE_KICKOFF  = '	Kick-Off';
    public static String STAGE_CLOSURE  = 'Closure';
    public static String STATUS_WCGT_CLOSED  = 'Closed';
    public static String STAGE_PRE_CLOSURE  = 'Pre Closure';
    public static String STATUS_WCGT_OPEN  = 'Open';
    
    //Bhavika
    public static String Commercial_Line_Item_Trigger  = 'CommercialLineItemTrigger';
    
    public static String RCCRecommendedMatch_HidePotentialConflictButton_ForRCCStatuses = 'Tier-1 Response Awaited;;No Relationship Identified;;Relationship Identified; Evaluation Pending;;Approved;;Expired';// Added by Prashant // Values are separated by ;;
    
    //Added by Deepak Joshi for Nomenclature
    public static String OFFICE_MANAGING_PARTNER_ACCESS  = 'Client Access should be Read/Write only';
    public static String OFFICE_MANAGING_PARTNER  = 'Office Managing Partner';
    public static String OFFICE_MANAGING_PARTNER_ERROR_MESSAGE  = 'User does not have access to the office managing partner role';
    public static String MANDATORY_TASK_COMMENT = 'Auto Complete';

     //Start SFDC-[Phase-1]: code is added by Biplow sarkar | 21-03-2024
     public static String BUSINESS_AS_USUAL_BAU = 'Business as Usual (BAU)';
     public static String STRATEGIC_STR = 'Strategic (STR)';
     public static String CONVERTED = 'Converted';
     public static String FILLED_NEXT_STEPS_AND_RECOMMENDATIONS ='Please filled Next Steps and Recommendations';
     public static String ENQUIRY_TYPE ='Please filled the Enquiry Type and Next Steps and Recommendations';
     public static String WEBSITE ='Website';
     public static String CHAT_BOT ='Chat Bot';
     public static String Dummy_UserId ='US00012';
     //End SFDC-[Phase-1]
	
    public static String ConvertedEnquiryDeletionErrorMsg = 'Deleting a converted enquiry is not allowed.'; // Added By Prashant on 28March for Phase-1
	public static String NoneOfThem_ExternalDataSource = 'None of them'; // Added By Prashant on 04April for Phase-1
	public static String Industry_SubIndustry_ValidationErrorMessage = 'Segment, Industry fields are not editable as the client is active'; // Added By Suraj on 03-06-2024 for Phase-1
	public static String SYSTEM_ADMIN_PROFILE = 'System Administrator'; // Added By Suraj on 06-06-2024 for Phase-1
	public static String CLIENT_ACTIVE_STATUS = 'Active'; // Added By Suraj on 06-06-2024 for Phase-1
	public static String INDUSTRY_TEAM_GROUP = 'Industry_Team'; // Added By Suraj on 06-06-2024 for Phase-1
}