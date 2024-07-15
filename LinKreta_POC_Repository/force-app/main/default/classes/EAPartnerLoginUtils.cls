/*
AUTHOR                   : Prashant Bansal
CREATED DATE             : 13-May-2024
PROJECT NAME / TICKET #  : EA Partner Login Functionality
DESCRIPTION
This is utility class for EA Partner Login Functionality
*/
public without sharing class EAPartnerLoginUtils {
    
    // Here 
    public static String switchUserProfile(String eaUserId, String partnerUserId, Boolean isLoginAsEA){
        System.debug('isLoginAsEA--'+isLoginAsEA);
        String successUserUpdate = '';
        String successPermissionSetsChanges = '';
        User EAUserQueried = [SELECT Id, Name, ProfileId, Emp_Id__c, UserRoleId, UserRole.DeveloperName, PartnerLogin_UserID__c, IsAnExecutiveAdminEA__c
                              FROM User WHERE Id =: eaUserId];
        EA_Configuration__c eaConfig = new EA_Configuration__c();
        List<EA_Configuration__c> lstEAConfig = [SELECT Id, Name, EA_Emp_Id__c,EA_User__c, Original_Role__c, Original_Permission_Sets__c, Original_Profile__c, Original_Public_Groups__c, Original_Queues__c
                                                 FROM EA_Configuration__c WHERE EA_User__c =: eaUserId];
        if(! lstEAConfig.isEmpty()) {
            eaConfig = lstEAConfig[0];
        }

        // EA Login as Myself
        if(isLoginAsEA) {
            //Lasttime As well EA Logged in as Myself Or first time Login By EA and as Myself
            if(EAUserQueried.PartnerLogin_UserID__c == null ) {
                //No Change in Permissions But Record creation of EA_Configuration__c Object needed
            }
            // Lasttime EA Logged in As Partner
            else {
                // Update EA user Profile, Role and Remove EA from Partner Groups
                Savepoint sp;
                String token;
                try {
                    token =  getAuthenticationToken();
                    successUserUpdate = handleEAUserProfileAndRoleChange(eaUserId, partnerUserId, isLoginAsEA, token, eaConfig);
                    
                    // To assign and revoke Permission Sets to EA user
                    successPermissionSetsChanges = handleEAUserPermissionSets(eaUserId, partnerUserId, isLoginAsEA, token, eaConfig);
                    System.debug('successUserUpdate API--'+successUserUpdate);
                    System.debug('successPermissionSetsChanges API--'+successPermissionSetsChanges);
                    
                    sp = Database.setSavepoint();
                
                    //To Add EA in Public Group and Queue-->
                    // handleEAUserGroupAssignment(eaUserId+'1@@@', partnerUserId, isLoginAsEA, eaConfig);
                    handleEAUserGroupAssignment(eaUserId, partnerUserId, isLoginAsEA, eaConfig);
                        


                
                    //@@@@@@@@
                    // List<EAPartnerLogin_Mapper__c> lstExistingActivePartnerMappingForOldEA = new List<EAPartnerLogin_Mapper__c>();
                    // lstExistingActivePartnerMappingForOldEA = [SELECT Id, EAUser__c,PartnerUser__c, Is_Deleted__c FROM EAPartnerLogin_Mapper__c WHERE Is_Deleted__c = false AND EAUser__c =: eaUserId];
                    // List<EA_Configuration__c> lstEAConfigRecordsToDelete = [SELECT Id FROM EA_Configuration__c WHERE EA_User__c =: eaUserId];  
                    // Delete lstEAConfigRecordsToDelete;    
            
                    //@@@@@@@@

                    User EAUserQueriedAgain = [SELECT Id, Name, ProfileId, UserRoleId, UserRole.DeveloperName,IsAnExecutiveAdminEA__c FROM User WHERE Id =: eaUserId];
                    System.debug('EAUserQueriedAgain--'+EAUserQueriedAgain); 
                    System.debug('EAUserQueriedAgain.UserRoleId--'+EAUserQueriedAgain.UserRoleId); 
                    System.debug('EAUserQueriedAgain.UserRole.DeveloperName--'+EAUserQueriedAgain.UserRole.DeveloperName); 

                    List<EAPartnerLogin_Mapper__c> lstEAsActiveRecords = [SELECT Id, Mapping_Id__c, EAUser__c, PartnerUser__c, Is_Deleted__c FROM EAPartnerLogin_Mapper__c 
                    WHERE EAUser__c =: eaUserId AND Is_Deleted__c = false];
                    if(lstEAsActiveRecords == null ||lstEAsActiveRecords.isEmpty()) {
                        if(EAUserQueriedAgain.IsAnExecutiveAdminEA__c == true) {
                            EAUserQueriedAgain.IsAnExecutiveAdminEA__c = false;
                            update EAUserQueriedAgain;
                        }
                    }

                    //This method is to Perform other required operations on Non-Setup Objects that can't be executed synchronously due to Mixed DML limitation
                    futureMthd(eaUserId, partnerUserId, isLoginAsEA);
                    return 'success';
                } catch (Exception e) {
                    // if(successPermissionSetsChanges == 'true') {
                    //     String token =  getAuthenticationToken();
                    //     handleEAUserPermissionSets(eaUserId, partnerUserId, ! isLoginAsEA, token, eaConfig);// reverting the profile changes 
                    // }
                    Database.rollback(sp);                    
                    if(successUserUpdate == 'true') {
                        Update EAUserQueried; // reverting all the changes in User that we dont through API
                    }

                    System.debug('Exception : ' + e.getStackTraceString());
                    String excMessage = 'Error Message: '+ e.getMessage()+' | Stack Trace: '+ e.getStackTraceString();
                    Id eaConfigId;
                    if(eaConfig != new EA_Configuration__c()) {
                        eaConfigId = eaConfig.Id;
                    } 
                    String InitialUserId = EAUserQueried.PartnerLogin_UserID__c;
                    String TargettedUserId = eaUserId;
                    apexDebugLogger(excMessage, e.getTypeName(), 'EAPartnerLoginUtils' , 'switchUserProfile' , eaUserId, eaUserId, EAUserQueried.PartnerLogin_UserID__c, false, token, eaConfigId, successPermissionSetsChanges );
                    return 'error';
                }

            }
        } 
        // EA Login as Partner
        else {
            // EA Logged in as Same Partner by whom he logged in Earlier
            if(partnerUserId == EAUserQueried.PartnerLogin_UserID__c) {
                // No Changes Needed 
            } 
            // EA Log in as another Partner (e.g Earlier Partner 1, now Partner 2 OR,, earlier as EA and now as Partner 1 )
            else {
                //Remove Old Partner Permissions from EA user and add New Partner Permissions
                Savepoint sp;
                String token;
                try {
                    token =  getAuthenticationToken();
                    successUserUpdate = handleEAUserProfileAndRoleChange(eaUserId, partnerUserId, isLoginAsEA, token, eaConfig);
                    
                    // To assign and revoke Permission Sets to EA user
                    successPermissionSetsChanges = handleEAUserPermissionSets(eaUserId, partnerUserId, isLoginAsEA, token, eaConfig);                
                    System.debug('successUserUpdate API--'+successUserUpdate);
                    System.debug('successPermissionSetsChanges API--'+successPermissionSetsChanges);
                    sp = Database.setSavepoint();

                    //To Add EA in Public Group and Queue-->
                    // handleEAUserGroupAssignment(eaUserId+'TESTTEST', partnerUserId, isLoginAsEA, eaConfig);
                    handleEAUserGroupAssignment(eaUserId, partnerUserId, isLoginAsEA, eaConfig);

                    //This method is to Perform other required operations that can't be executed synchronously due to Mixed DML limitation
                    futureMthd(eaUserId, partnerUserId, isLoginAsEA);

                    return 'success';
                } catch (Exception e) {
                    // if(successPermissionSetsChanges == 'true') {
                    //     String token =  getAuthenticationToken();
                    //     handleEAUserPermissionSets(eaUserId, partnerUserId, ! isLoginAsEA, token, eaConfig);// reverting the profile changes 
                    // }
                    Database.rollback(sp);
                    if(successUserUpdate == 'true') {
                        Update EAUserQueried; // reverting all the changes in User that we dont through API
                    }


                    System.debug('Exception : ' + e.getStackTraceString());
                    String excMessage = 'Error Message: '+ e.getMessage()+' | Stack Trace: '+ e.getStackTraceString();
                    Id eaConfigId;
                    if(eaConfig != new EA_Configuration__c()) {
                        eaConfigId = eaConfig.Id;
                    } 
                    //apexDebugLogger(excMessage, e.getTypeName(), 'EAPartnerLoginUtils' , 'switchUserProfile' , eaUserId, eaUserId, partnerUserId, isLoginAsEA, eaConfigId );
                    // String InitialUserId = EAUserQueried.PartnerLogin_UserID__c;
                    // String TargettedUserId = partnerUserId;
                    if(EAUserQueried.PartnerLogin_UserID__c == null) {
                        apexDebugLogger(excMessage, e.getTypeName(), 'EAPartnerLoginUtils' , 'switchUserProfile' , eaUserId, eaUserId, '', true, token, eaConfigId, successPermissionSetsChanges);
                    } else if(EAUserQueried.PartnerLogin_UserID__c != partnerUserId) {
                        apexDebugLogger(excMessage, e.getTypeName(), 'EAPartnerLoginUtils' , 'switchUserProfile' , eaUserId, eaUserId, EAUserQueried.PartnerLogin_UserID__c, false, token, eaConfigId, successPermissionSetsChanges);
                    }
                    return 'error';
                }
            }
        }
                     
        return 'Success';
    }
    @future (callout = true)
    public static void apexDebugLogger(String excMessage, String excType,  String className , String methodName , String recordReference,String eaUserId, String partnerUserId, Boolean isLoginAsEA, String token, Id eaConfigId, String successPermissionSetsChanges){
        try{
            
            if(successPermissionSetsChanges == 'true') {
                EA_Configuration__c eaConfig = new EA_Configuration__c();
                if(eaConfigId != null) {
                    eaConfig = [SELECT Id, Name, EA_Emp_Id__c,EA_User__c, Original_Role__c, Original_Permission_Sets__c, Original_Profile__c, Original_Public_Groups__c, Original_Queues__c
                    FROM EA_Configuration__c WHERE Id =: eaConfigId];
                }
                token =  getAuthenticationToken();
                handleEAUserPermissionSets(eaUserId, partnerUserId, isLoginAsEA, token, eaConfig);// reverting the profile changes 
            }
            
            ErrorLog__c err = new ErrorLog__c();
            err.NameofArtifact__c = className;
            err.ExceptionMessage__c = excMessage;
            err.ExceptionType__c = excType;
            err.MethodName__c = methodName;
            if(!String.isEmpty(recordReference)) {
             err.SFDCRecordReference__c = recordReference;
            }
            err.ErrorAPI__c = true;
            insert err;
        }
        Catch(Exception ex){
            System.debug('Error: ErrorLog>>apexDebugLogger>>'+ex);
        }
    }
    
    // This Method will handle the Profile Update of EA user using REST API
    public static String handleEAUserProfileAndRoleChange(String eaUserId, String partnerUserId, Boolean isLoginAsEA, String token, EA_Configuration__c eaConfig) {
        String profileIdForEA;
        String roleIdForEA = '';
        String isSuccess = 'false';
        if(isLoginAsEA) {
            Profile objProfileEA = [SELECT Id, Name FROM Profile WHERE Name =: eaConfig.Original_Profile__c];
            profileIdForEA = objProfileEA.Id;
            
            if(eaConfig.Original_Role__c != null && String.isNotBlank(eaConfig.Original_Role__c)) {
                UserRole objRoleEA = [SELECT Id, Name, DeveloperName FROM UserRole WHERE DeveloperName =: eaConfig.Original_Role__c];
                roleIdForEA = objRoleEA.Id;   
            }
            
        } else {
            User PartnerUserQueried = [SELECT Id, Name, ProfileId, UserRoleId FROM User WHERE Id =: partnerUserId];
            profileIdForEA = PartnerUserQueried.ProfileId;   
            roleIdForEA = PartnerUserQueried.UserRoleId;         
        }
        if(roleIdForEA == null) {
            roleIdForEA = '';
        }
        String body = '{ "allOrNone": false, "records": [ { "attributes": { "type": "User" }, "Id": "'+eaUserId+'", "ProfileId": "'+profileIdForEA+'", "UserRoleId": "'+roleIdForEA+'" } ] }';
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        String sfdcBaseURL = URL.getOrgDomainURL().toExternalForm();
        System.debug('Base URL: ' + sfdcBaseURL ); 
        req.setEndpoint(sfdcBaseURL+'/services/data/v58.0/composite/sobjects/User/Id');
        req.setMethod('PATCH'); 
        req.setHeader('Authorization','Bearer '+token);
        req.setHeader('Content-Type','application/json');
        String reqBody = body;
        system.debug('reqBody:'+reqBody);
        req.setBody(reqBody);
        HttpResponse resp;
        resp = http.send(req);
        System.debug('resp -->'+resp);
        System.debug('resp.getStatusCode()--'+resp.getStatusCode());
        System.debug('resp Body -->'+resp.getBody());
        List<Object> lstResponseObject = (List<Object>) JSON.deserializeUntyped(resp.getBody());
        Map<String, Object> objMap = (Map<String, Object>) lstResponseObject[0];

        isSuccess = String.valueOf(objMap.get('success'));
        System.debug('isSuccess--'+isSuccess); 

        return isSuccess;
    }
    
    // This Method will handle the Assignment and revokement of Permission Sets for EA User
    public static String handleEAUserPermissionSets(String eaUserId, String partnerUserId, Boolean isLoginAsEA, String token, EA_Configuration__c eaConfig) {
        Set<String> setEaPermissionsToAdd = new Set<String>();
        String strExceptionMessage = '';
        String isDeletePermissionSetsSuccess = 'false';
        if(isLoginAsEA) {
            Set<String> setEaOriginalPermissions  = new Set<String>(); //This permission name will come from a new custom object
            //setEaOriginalPermissions.add('New_Client_Owner');// TEMPORARY 
            if(! String.isBlank(eaConfig.Original_Permission_Sets__c)) {
                setEaOriginalPermissions.addAll(eaConfig.Original_Permission_Sets__c.split(';'));            
            }
            System.debug('setEaOriginalPermissions--'+setEaOriginalPermissions);   
            
            setEaPermissionsToAdd = setEaOriginalPermissions.clone();//a,b,c
        }
        else {
            List<PermissionSetAssignment> lstPermissionsPartnerQueried = [SELECT Id, PermissionSetId,PermissionSet.Name, PermissionSetGroupId, AssigneeId, IsActive FROM PermissionSetAssignment WHERE IsActive = true AND AssigneeId =: partnerUserId];
            for(PermissionSetAssignment assignment:lstPermissionsPartnerQueried) {
                setEaPermissionsToAdd.add(assignment.PermissionSet.Name);
                System.debug('Partner Permission Set Needed--'+assignment.PermissionSet.Name);
            }
        }
        System.debug('setEaPermissionsToAdd--'+setEaPermissionsToAdd);
        List<PermissionSetAssignment> lstPermissionsEAQueried = [SELECT Id, PermissionSetId,PermissionSet.Name, PermissionSetGroupId, AssigneeId, IsActive FROM PermissionSetAssignment WHERE IsActive = true AND AssigneeId =: eaUserId];
        Set<String> setEAPermissionsQueried = new Set<String>();//b,c,d
        Set<String> setEAPermissionsToDelete = new Set<String>(); 
        for(PermissionSetAssignment assignment:lstPermissionsEAQueried) {
            setEAPermissionsQueried.add(assignment.PermissionSet.Name);
        } 
        System.debug('setEAPermissionsQueried--'+setEAPermissionsQueried);
        setEAPermissionsToDelete = setEAPermissionsQueried.clone();
        setEAPermissionsToDelete.removeAll(setEaPermissionsToAdd); //d
        if(setEAPermissionsToDelete != null && ! setEAPermissionsToDelete.isEmpty()) {
            List<PermissionSetAssignment> lstPermissionToDelete =  [SELECT Id, PermissionSetId,PermissionSet.Name, PermissionSetGroupId, AssigneeId, IsActive FROM PermissionSetAssignment WHERE IsActive = true AND AssigneeId =: eaUserId AND PermissionSet.Name IN: setEAPermissionsToDelete];
            //Delete lstPermissionToDelete;
            String strPermissionAssignmentToRemove = '';
            for(PermissionSetAssignment assignment:lstPermissionToDelete) {
                strPermissionAssignmentToRemove += assignment.Id + ',';
                System.debug('EA Permission to Delete--'+assignment.PermissionSet.Name);
            }
            strPermissionAssignmentToRemove = strPermissionAssignmentToRemove.removeEnd(',');
            
            isDeletePermissionSetsSuccess = deletePermissionSetsUsingAPI(strPermissionAssignmentToRemove, token); // Calling API To Delete the Permissions that were Assigned to EA when he logged in as Partner
            if(isDeletePermissionSetsSuccess == 'false') {
                return 'error';
            }
        } else {
            isDeletePermissionSetsSuccess = 'true';
        }
        
        setEaPermissionsToAdd.removeAll(setEAPermissionsQueried);
        
        // This block with restore the Original Permission the EA User has
        if(! setEaPermissionsToAdd.isEmpty()) {
            List<PermissionSetAssignment> permissionsToAddFromEAUser = new List<PermissionSetAssignment>();
            List<PermissionSet> lstPermissionsToAssign = [SELECT Id, Name FROM PermissionSet WHERE Name IN : setEaPermissionsToAdd];
            for(PermissionSet permission: lstPermissionsToAssign) {
                System.debug('EA Permission to add--'+permission.Name);
                permissionsToAddFromEAUser.add(new PermissionSetAssignment(PermissionSetId = permission.Id, AssigneeId = eaUserId));
            }
            //insert permissionsToAddFromEAUser;
            Database.SaveResult[] srList = Database.insert(permissionsToAddFromEAUser, false);
            // Iterate through each returned result
            for (Database.SaveResult sr : srList) {
                if (sr.isSuccess()) {
                    // Operation was successful, so get the ID of the record that was processed
                    System.debug('Successfully inserted account. Account ID: ' + sr.getId());
                }
                else {
                    // Operation failed, so get all errors       
                    strExceptionMessage += 'The following error has occurred while Assigning the Permission-> ';         
                    for(Database.Error err : sr.getErrors()) {
                        System.debug('The following error has occurred.');                    
                        System.debug(err.getStatusCode() + ': ' + err.getMessage());
                        strExceptionMessage += err.getStatusCode() + ': ' + err.getMessage() + '\n\n';
                    }
                }
            }
            System.debug('strExceptionMessage--'+strExceptionMessage);
        } 
        return isDeletePermissionSetsSuccess;
    }
    
    // This Method will create record of EAPartnerLogin_History__c if - EA Log in as Partner
    @future
    public static void futureMthd(String eaUserId, String partnerUserId, Boolean isLoginAsEA){
        if(! isLoginAsEA) {
            EAPartnerLogin_History__c history = new EAPartnerLogin_History__c();
            history.EAUser__c = eaUserId;
            history.PartnerUser_LoggedInAs__c = partnerUserId;
            insert history;
        } /*else {
            List<EAPartnerLogin_Mapper__c> lstEAsActiveRecords = [SELECT Id, Mapping_Id__c, EAUser__c, PartnerUser__c, Is_Deleted__c FROM EAPartnerLogin_Mapper__c 
            WHERE EAUser__c =: eaUserId AND Is_Deleted__c = false];
            if(lstEAsActiveRecords == null ||lstEAsActiveRecords.isEmpty()) {
                List<EA_Configuration__c> lstEAConfig = [SELECT Id, EA_User__c FROM EA_Configuration__c WHERE EA_User__c =: eaUserId];
                Delete lstEAConfig;
            }
        }*/
    }
    
    // This Method will return the Access Token to access current Salesforce org using API
    // In this Currently Client Id, Client Secret, Username(Integration User Admin) and Password is Hardcoded TEMPORARY
    public static string getAuthenticationToken(){
        Salesforce_Auth_Details__mdt authDetails = Salesforce_Auth_Details__mdt.getInstance('Grant_Type_Details');
        String token = '';
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        String sfdcBaseURL = URL.getOrgDomainURL().toExternalForm();
        System.debug('Base URL: ' + sfdcBaseURL ); 
        //req.setEndpoint(sfdcBaseURL+'/services/oauth2/token?grant_type=password&client_id=3MVG9pcaEGrGRoTJT2A6l4MSrI0aeI66AcjEgq_86PTeQNGox8Qe0sMjf91KfubyuNqCuHhJ1tx7lwAuJ1Hen&client_secret=4D0415CDFC03A90CE36126253B3536F8C35C30CFCF177EEE538AB8A2D4A56501&username=linkreta.integration@in.gt.com.lkpauat&password=Ch@nd@ry@@n@202324RG51nho8VxaLIwWLQGBpxsWG');
        req.setEndpoint(sfdcBaseURL+'/services/oauth2/token?grant_type=password&client_id='+authDetails.Client_Id__c+'&client_secret='+authDetails.Client_Secret__c+'&username='+authDetails.Username__c+'&password='+authDetails.Password__c);
        req.setMethod('POST'); 
        req.setHeader('Content-Type','application/json');
        String reqBody = '';
        HttpResponse resp;
        try{
            resp = http.send(req);
            System.debug('resp -->'+resp);
            System.debug('resp Body -->'+resp.getBody());
            //INSERT apiLog;
            if(resp != null){
                Map<String, Object> deserialized = (Map<String, Object>)JSON.deserializeUntyped(resp.getBody());
                System.debug('deserialized -->'+deserialized);
                System.debug('statusCode -->'+deserialized.get('statusCode'));
                if(resp.getStatusCode() == 200) {
                    token = String.valueOf(deserialized.get('access_token'));
                    System.debug('token -->'+token);
                }
            }
        }
        catch(Exception e){
            system.debug('Error:'+e.getMessage()+' '+e.getLineNumber());
        }
        
        return token;
    }
    
    // This Method is to revoke the Extra Permission that EA User haswhich got assigned to EA User when he logged in as Partner
    public static string deletePermissionSetsUsingAPI(String strPermissionAssignmentToRemove, String token) {
        
        String isSuccess = 'false';

        Http http = new Http();
        HttpRequest req = new HttpRequest();
        String sfdcBaseURL = URL.getOrgDomainURL().toExternalForm();
        System.debug('Base URL: ' + sfdcBaseURL ); 
        System.debug('strPermissionAssignmentToRemove--'+strPermissionAssignmentToRemove);
        req.setEndpoint(sfdcBaseURL+'/services/data/v60.0/composite/sobjects?ids='+strPermissionAssignmentToRemove);
        req.setMethod('DELETE'); 
        req.setHeader('Authorization','Bearer '+token);
        req.setHeader('Content-Type','application/json');
        HttpResponse resp;
        resp = http.send(req);
        System.debug('resp -->'+resp);
        System.debug('resp Body -->'+resp.getBody());

        List<Object> lstResponseObject = (List<Object>) JSON.deserializeUntyped(resp.getBody());
        Map<String, Object> objMap = (Map<String, Object>) lstResponseObject[0];

        isSuccess = String.valueOf(objMap.get('success'));
        System.debug('isSuccess--'+isSuccess); 
        return isSuccess;
    }
    
    // This Method will handle the Assignment and revokement of Permission Sets for EA User
    public static void handleEAUserGroupAssignment(String eaUserId, String partnerUserId, Boolean isLoginAsEA, EA_Configuration__c eaConfig) {
        String eaGroupOriginal = eaConfig.Original_Public_Groups__c;
        Set<String> setEaGroupOriginal = new Set<String>();
        if(! String.isBlank(eaGroupOriginal)) {
            setEaGroupOriginal.addAll(eaGroupOriginal.split(';'));
        }
        
        String eaQueueOriginal = eaConfig.Original_Queues__c;
        Set<String> setEaQueueOriginal = new Set<String>();
        if(! String.isBlank(eaQueueOriginal)) {
            setEaQueueOriginal.addAll(eaQueueOriginal.split(';'));
        }
        
        List<String> partnerGroupsToSearch = new List<String>();
        if(! String.isBlank(Label.PartnerGroupsForEAPartnerFunctionality)) {
            partnerGroupsToSearch = Label.PartnerGroupsForEAPartnerFunctionality.split(';');
        }
        System.debug('Label.PartnerGroupsForEAPartnerFunctionality--'+Label.PartnerGroupsForEAPartnerFunctionality);
        
        List<String> partnerQueuesToSearch = new List<String>();
        if(! String.isBlank(Label.PartnerQueuesForEAPartnerFunctionality)) {
            partnerQueuesToSearch = Label.PartnerQueuesForEAPartnerFunctionality.split(';');
        }
        System.debug('Label.PartnerQueuesForEAPartnerFunctionality--'+Label.PartnerQueuesForEAPartnerFunctionality);
        
        if(isLoginAsEA) {
            //String strEAAdditionalGroup = 'C_M_Team';//'Client_Council_Approval;C_M_Team'; // TEMPORARY HARDCODED This will come from Custom Object of EA Permissions
            //List<String> groupsToSearchToRemoveEA = new List<String>();
            //groupsToSearchToRemoveEA = strEAAdditionalGroup.split(';');
            
            List<GroupMember> lstAdditionalGroupQueueMemberEA = [SELECT Id, GroupId,Group.DeveloperName, UserOrGroupId, Group.Type FROM GroupMember 
                                                                 where UserOrGroupId =:eaUserId AND ((Group.DeveloperName NOT IN: setEaGroupOriginal AND Group.DeveloperName IN: partnerGroupsToSearch AND Group.Type = 'Regular') OR (Group.DeveloperName NOT IN: setEaQueueOriginal AND Group.DeveloperName IN: partnerQueuesToSearch AND Group.Type = 'Queue'))];
            for(GroupMember g: lstAdditionalGroupQueueMemberEA) {
                System.debug('To Delete Group/Queue Member record-->'+g.Id+ '--Type-->'+g.Group.Type+ '--Group Member Id-->'+g.UserOrGroupId+ '--IN Group Name-->'+g.Group.DeveloperName);
            } 
            Delete lstAdditionalGroupQueueMemberEA;

            // remove EA from Old Partner Sharing Group
            User oldEAUserQueried = [SELECT Id, Name, PartnerLogin_UserID__r.Emp_Id__c FROM User WHERE Id =: eaUserId];
            String grpName = oldEAUserQueried.PartnerLogin_UserID__r.Emp_Id__c + '_EA_Group';
            List<GroupMember> lstGroupMemberInOldPartnerRecordsSharing = [SELECT Id, GroupId,Group.DeveloperName,Group.Type, UserOrGroupId FROM GroupMember 
                                                                      where Group.DeveloperName =: grpName AND Group.Type = 'Regular'];
            Delete lstGroupMemberInOldPartnerRecordsSharing;

        }        
        else {
            
            List<GroupMember> lstExistingGroupQueueMemberPartnerEA = [SELECT Id, GroupId,Group.DeveloperName,Group.Type, UserOrGroupId FROM GroupMember 
                                                                      where (UserOrGroupId =:partnerUserId OR UserOrGroupId =:eaUserId) AND
                                                                       ((Group.DeveloperName IN: partnerGroupsToSearch AND Group.Type = 'Regular') OR (Group.DeveloperName IN: partnerQueuesToSearch AND Group.Type = 'Queue'))];

            Set<String> setEaGroupToAdd = new Set<String>();
            Set<String> setEaGroupToDelete = new Set<String>();
            Set<String> setEaGroupQueried = new Set<String>();
            setEaGroupToAdd = setEaGroupOriginal.clone();
            
            Set<String> setEaQueueToAdd = new Set<String>();
            Set<String> setEaQueueToDelete = new Set<String>();
            Set<String> setEaQueueQueried = new Set<String>();
            setEaQueueToAdd = setEaQueueOriginal.clone();
            
            Map<String, Id> mapGroupNameVsId = new Map<String, Id>();
            Map<String, Id> mapQueueNameVsId = new Map<String, Id>();
            
            for(GroupMember member: lstExistingGroupQueueMemberPartnerEA) {
                System.debug('member.UserOrGroupId-->'+member.UserOrGroupId + 'member.Group.Type-->'+member.Group.Type + '   member.Group.DeveloperName-->'+member.Group.DeveloperName);
                /*if(member.Group.Type == 'Regular') {
                    mapGroupNameVsId.put(member.Group.DeveloperName, member.GroupId);
                } else if(member.Group.Type == 'Queue') {
                    mapQueueNameVsId.put(member.Group.DeveloperName, member.GroupId);
                }
                System.debug('mapGroupNameVsId--'+mapGroupNameVsId);
                System.debug('mapQueueNameVsId--'+mapQueueNameVsId);*/
           
                if(member.UserOrGroupId == eaUserId) {
                    if(member.Group.Type == 'Regular') {
                        setEaGroupQueried.add(member.Group.DeveloperName);  
                    } else if(member.Group.Type == 'Queue') {
                        setEaQueueQueried.add(member.Group.DeveloperName);  
                    }
                } else if(member.UserOrGroupId == partnerUserId){
                    if(member.Group.Type == 'Regular') {
                        setEaGroupToAdd.add(member.Group.DeveloperName);  
                    } else if(member.Group.Type == 'Queue') {
                        setEaQueueToAdd.add(member.Group.DeveloperName);  
                    }
                }
            }
            
            setEaGroupToDelete = setEaGroupQueried.clone();
            setEaGroupToDelete.removeAll(setEaGroupToAdd); // This will contain All the Group names from which EA should be removed (Groups of Old Partner)
            
            setEaGroupToAdd.removeAll(setEaGroupQueried); // This will contain All the Group names in which EA should be Added (Groups of New Partner)
            
            System.debug('setEaGroupToDelete--'+setEaGroupToDelete);
            System.debug('setEaGroupToAdd--'+setEaGroupToAdd);
            
            
            setEaQueueToDelete = setEaQueueQueried.clone();
            setEaQueueToDelete.removeAll(setEaQueueToAdd); // This will contain All the Queue names from which EA should be removed (Queues of Old Partner)
            
            setEaQueueToAdd.removeAll(setEaQueueQueried); // This will contain All the Queue names in which EA should be Added (Queues of New Partner)
            
            System.debug('setEaQueueToDelete--'+setEaQueueToDelete);
            System.debug('setEaQueueToAdd--'+setEaQueueToAdd);
            
            List<GroupMember> lstGroupMemberEAToInsert = new List<GroupMember>();
            List<Group> lstPublicGroupsQueriedToAdd = [SELECT Id, DeveloperName, Type FROM Group WHERE Type = 'Regular' OR Type = 'Queue'];
            for(Group grp: lstPublicGroupsQueriedToAdd) {
                if(grp.Type == 'Regular') {
                    mapGroupNameVsId.put(grp.DeveloperName, grp.Id);
                } else if(grp.Type == 'Queue') {
                    mapQueueNameVsId.put(grp.DeveloperName, grp.Id);
                }
            }
           
            for(String grpName:setEaGroupToAdd) {
                System.debug('grpName--'+grpName);
                System.debug('mapGroupNameVsId.get(grpName)--'+mapGroupNameVsId.get(grpName));
                Id groupId = mapGroupNameVsId.get(grpName);
                GroupMember grpMember = new GroupMember();
                grpMember.UserOrGroupId = eaUserId;
                grpMember.GroupId = groupId;
                lstGroupMemberEAToInsert.add(grpMember);
            }
            Insert lstGroupMemberEAToInsert;
            
            List<GroupMember> lstQueueMemberEAToInsert = new List<GroupMember>();
            for(String grpName:setEaQueueToAdd) {
                Id groupId = mapQueueNameVsId.get(grpName);
                GroupMember grpMember = new GroupMember();
                grpMember.UserOrGroupId = eaUserId;
                grpMember.GroupId = groupId;
                lstQueueMemberEAToInsert.add(grpMember);
            }
            Insert lstQueueMemberEAToInsert;
            for(GroupMember g: lstGroupMemberEAToInsert) {
                System.debug('Inserted Group Member record-->'+g.Id+ '--Group Member Id---->'+g.UserOrGroupId+ '--IN Group Name-->'+g.Group.DeveloperName);
            }
            for(GroupMember g: lstQueueMemberEAToInsert) {
                System.debug('Inserted Queue Member record-->'+g.Id+ '--Queue Member Id---->'+g.UserOrGroupId+ '--IN Queue Name-->'+g.Group.DeveloperName);
            }
            
            List<GroupMember> lstGroupQueueMemberRecordsToDelete = [SELECT Id, GroupId,Group.DeveloperName,Group.Type, UserOrGroupId FROM GroupMember 
            where ((Group.DeveloperName IN: setEaGroupToDelete AND Group.Type = 'Regular')
                   OR (Group.DeveloperName IN: setEaQueueToDelete AND Group.Type = 'Queue')) AND UserOrGroupId =:eaUserId];
            Delete lstGroupQueueMemberRecordsToDelete;

            // remove EA from Old Partner Sharing Group
            User eaUserQueried = [SELECT Id, Name, Emp_Id__c, PartnerLogin_UserID__c FROM User WHERE Id =: eaUserId];
            if(eaUserQueried.PartnerLogin_UserID__c != null) {
                User oldPartnerUserQueried = [SELECT Id, Name, Emp_Id__c FROM User WHERE Id =: eaUserQueried.PartnerLogin_UserID__c];
                String grpName = oldPartnerUserQueried.Emp_Id__c + '_EA_Group';
                List<GroupMember> lstGroupMemberInOldPartnerRecordsSharing = [SELECT Id, GroupId,Group.DeveloperName,Group.Type, UserOrGroupId FROM GroupMember 
                                                                        where Group.DeveloperName =: grpName AND Group.Type = 'Regular'];
                Delete lstGroupMemberInOldPartnerRecordsSharing;
            } 
            User partnerUserQueried = [SELECT Id, Name, Emp_Id__c, PartnerLogin_UserID__c FROM User WHERE Id =: partnerUserId];
            String grpName = partnerUserQueried.Emp_Id__c + '_EA_Group';
            List<Group> lstGroup = [SELECT Id, DeveloperName FROM Group WHERE Type = 'Regular' AND DeveloperName =: grpName];
            
            GroupMember grpMember = new GroupMember();
            grpMember.UserOrGroupId = eaUserId;
            grpMember.GroupId = lstGroup[0].Id;
            insert grpMember;
            //<--
        }
    }
    
}