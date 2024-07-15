/*
AUTHOR                   : Prashant Bansal
CREATED DATE             : 18-May-2024
PROJECT NAME / TICKET #  : EA Partner Login Functionality
DESCRIPTION
Handler class of Trigger on EAPartnerLogin_Mapper__c Object
*/
public class EAPartnerLogin_MapperTriggerHandler {
    
    public static void handleBeforeInsert(List<EAPartnerLogin_Mapper__c> lstMapper) {
        Set<Id> partnerUserIdsFromMapper = new Set<Id>();
        Set<Id> eaUserIdsFromMapper = new Set<Id>();
        Map<Id,User> mapEAUserToUpdate = new Map<Id,User>();
        Map<Id,User> mapPartnerUserToUpdate = new Map<Id,User>();
        for(EAPartnerLogin_Mapper__c mapper: lstMapper) {
            if(mapper.Is_Deleted__c == false) {
                partnerUserIdsFromMapper.add(mapper.PartnerUser__c);
                eaUserIdsFromMapper.add(mapper.EAUser__c);
            }  else if(mapper.EAUser__c == mapper.PartnerUser__c){
                mapper.addError('Partner and EA user cannot be same.');
            } else {
                mapper.addError('Mapping can only be inserted if the \'Is Deleted\' field is set as false');
            }
        }
        List<EAPartnerLogin_Mapper__c> lstExistingActivePartnerMappingMain = [SELECT Id, EAUser__c,PartnerUser__c, Is_Deleted__c FROM EAPartnerLogin_Mapper__c WHERE Is_Deleted__c = false AND PartnerUser__c IN: partnerUserIdsFromMapper];
        Map<Id, EAPartnerLogin_Mapper__c> mapExistingActivePartnerIdVsMapperRecord = new Map<Id, EAPartnerLogin_Mapper__c>();
        for(EAPartnerLogin_Mapper__c mapper: lstExistingActivePartnerMappingMain) {
            mapExistingActivePartnerIdVsMapperRecord.put(mapper.PartnerUser__c, mapper);
        }
        List<EA_Configuration__c> lstExistingEAConfig = [SELECT Id, Name, EA_Emp_Id__c,EA_User__c, Original_Role__c, Original_Profile__c, Original_Public_Groups__c, Original_Queues__c
                                                 FROM EA_Configuration__c WHERE EA_User__c IN: eaUserIdsFromMapper];
        Map<Id, EA_Configuration__c> mapEAIdVsConfigRecord = new Map<Id, EA_Configuration__c>();
        for(EA_Configuration__c config: lstExistingEAConfig) {
            mapEAIdVsConfigRecord.put(config.EA_User__c, config);
        }
        Map<Id,User> mapUserQueried = new Map<Id, User>([SELECT Id, Name, Emp_Id__c, Profile.Name, UserRole.DeveloperName, IsAnExecutiveAdminEA__c FROM User WHERE (Id IN: partnerUserIdsFromMapper OR  Id IN: eaUserIdsFromMapper)]);
        Map<Id, String> mapPartnerIdVsPartnerGroupName = new Map<Id, String>();
        Map<Id,User> mapEAUserQueried = new Map<Id, User>();
        Map<Id,User> mapPartnerUserQueried = new Map<Id, User>();
        for(User usr: mapUserQueried.values()) {
            if(partnerUserIdsFromMapper.contains(usr.Id)) {
                mapPartnerIdVsPartnerGroupName.put(usr.Id, usr.Emp_Id__c + '_EA_Group');
                mapPartnerUserQueried.put(usr.Id, usr);
            } if(eaUserIdsFromMapper.contains(usr.Id)) {
                mapEAUserQueried.put(usr.Id, usr);
                
            }
        }
        List<Group> lstPartnerGroupsQueried = [SELECT Id, DeveloperName FROM Group WHERE DeveloperName IN: mapPartnerIdVsPartnerGroupName.values()];
        Map<String,Id> mapPartnerGrpNameVsGroupId = new Map<String,Id>();
        for(Group grp: lstPartnerGroupsQueried) {
            mapPartnerGrpNameVsGroupId.put(grp.DeveloperName, grp.Id);
        }
        List<Group> lstPartnerGroupsToInsert = new List<Group>();
        Map<Id,GroupMember> lstGroupMembersToDeleteFromGroup = new Map<Id,GroupMember>([SELECT Id FROM GroupMember WHERE GroupId IN: mapPartnerGrpNameVsGroupId.values()]);

        List<PermissionSetAssignment> lstEAOriginalPermissionSetAssignments = [SELECT Id, PermissionSetId,PermissionSet.Name, PermissionSetGroupId, AssigneeId, IsActive, IsRevoked FROM PermissionSetAssignment where IsRevoked = false AND AssigneeId =: eaUserIdsFromMapper];
        Map<Id, List<PermissionSetAssignment>> mapEAIdVsLstOriginalPSA = new Map<Id, List<PermissionSetAssignment>>();
        for(PermissionSetAssignment psa: lstEAOriginalPermissionSetAssignments) {
            if(!mapEAIdVsLstOriginalPSA.containsKey(psa.AssigneeId)) {
                mapEAIdVsLstOriginalPSA.put(psa.AssigneeId, new List<PermissionSetAssignment>());
            } else {
                mapEAIdVsLstOriginalPSA.get(psa.AssigneeId).add(psa);
            }
        }
        
        List<String> groupsToSearch = new List<String>();
        groupsToSearch = Label.PartnerGroupsForEAPartnerFunctionality.split(';');
        List<GroupMember> lstOriginalGroupMemberEA = [SELECT Id, GroupId,Group.DeveloperName, UserOrGroupId, Group.Type FROM GroupMember 
                                                  where (Group.Type = 'Queue' OR Group.Type = 'Regular') AND UserOrGroupId IN:eaUserIdsFromMapper AND Group.DeveloperName IN: groupsToSearch];
        Map<Id, List<GroupMember>> mapEAIdVslstOriginalGroupMember = new Map<Id, List<GroupMember>>();
        for(GroupMember member: lstOriginalGroupMemberEA) {
            if(!mapEAIdVslstOriginalGroupMember.containsKey(member.UserOrGroupId)) {
                mapEAIdVslstOriginalGroupMember.put(member.UserOrGroupId, new List<GroupMember>());
            } else {
                mapEAIdVslstOriginalGroupMember.get(member.UserOrGroupId).add(member);
            }
        }   
        Map<String, EA_Configuration__c> mapEAEmpIdVsEAConfigToInsert = new Map<String, EA_Configuration__c>();
        for(EAPartnerLogin_Mapper__c mapper: lstMapper) {
            // Insert of EAPartnerLogin_Mapper__c will be allowded only if Is_Deleted__c = false 
            if(mapper.Is_Deleted__c == false) {
                // If Existing Active Mapping records does not extist for Partner
                if(! mapExistingActivePartnerIdVsMapperRecord.containsKey(mapper.PartnerUser__c)) {
                    User EAUserQueried = mapEAUserQueried.get(mapper.EAUser__c);
                    if(EAUserQueried != null) {
                        EA_Configuration__c eaConfig = createEAConfigRecord2(EAUserQueried, mapEAIdVsConfigRecord, mapEAIdVsLstOriginalPSA, mapEAIdVslstOriginalGroupMember);
                        if(eaConfig != new EA_Configuration__c()) {
                            mapEAEmpIdVsEAConfigToInsert.put(eaConfig.EA_Emp_Id__c, eaConfig);
                        }
                    }

                    // We need to create a new group with Group Name {Partner Emp Id} + '_EA_Group', this group will be use to share the Partner Record with EA
                    User partnerUserQueried = mapPartnerUserQueried.get(mapper.PartnerUser__c);
                    String partnerGroupName = mapPartnerIdVsPartnerGroupName.get(mapper.PartnerUser__c);
                    
                    // If Partner Group doesn't exist in System, inserting a new one
                    if(! mapPartnerGrpNameVsGroupId.containsKey(mapPartnerIdVsPartnerGroupName.get(mapper.PartnerUser__c))) {
                        Group grp = new Group();
                        grp.Type = 'Regular';
                        grp.Name = partnerGroupName;
                        grp.DeveloperName = partnerGroupName;
                        //Insert grp;
                        lstPartnerGroupsToInsert.add(grp);
                    }

                    //if(EAUserQueried.IsAnExecutiveAdminEA__c != true) {
                        EAUserQueried.IsAnExecutiveAdminEA__c = true;
                        EAUserQueried.UserPreferencesReceiveNoNotificationsAsApprover = false; // For Delegate Approver 
                        EAUserQueried.UserPreferencesReceiveNotificationsAsDelegatedApprover= true;  // For Delegate Approver    
                        //update EAUserQueried;
                        mapEAUserToUpdate.put(EAUserQueried.Id, EAUserQueried);
                    //}

                    partnerUserQueried.DelegatedApproverId = EAUserQueried.Id; // For Delegate Approver 
                   
                    mapPartnerUserToUpdate.put(partnerUserQueried.Id, partnerUserQueried);
                    
                } else {
                    mapper.addError('Active Mapping already Exists for the Given Partner User');
                }
            }
        }

        Insert mapEAEmpIdVsEAConfigToInsert.values();
        Insert lstPartnerGroupsToInsert;
        futureMthdToDeleteGroupMember( lstGroupMembersToDeleteFromGroup.keyset());
        Update mapEAUserToUpdate.values();
        Update mapPartnerUserToUpdate.values();
        
    }
    @future
    public static void futureMthdToDeleteGroupMember(Set<Id> grpMemberIds) {
        List<GroupMember> lstGroupMembersToDeleteFromGroup = [SELECT Id FROM GroupMember WHERE Id IN: grpMemberIds];
        Delete lstGroupMembersToDeleteFromGroup;
    }
    public static void handleBeforeUpdate( Map<Id,EAPartnerLogin_Mapper__c> mapOldMapper, List<EAPartnerLogin_Mapper__c> lstNewMapper) {
        
        List<AuthSession> lstSessionsToDelete = new List<AuthSession>();
        //@@List<EA_Configuration__c> lstEAConfigRecordsToDelete = new List<EA_Configuration__c>();
        Set<Id> setIdUsersToDeleteSession = new Set<Id>();
        Set<Id> newEAUserInExistingMapping = new Set<Id>();
        //@@Set<Id> oldEAUserInExistingMapping = new Set<Id>();
        List<GroupMember> lstOriginalGroupMemberEA = new List<GroupMember>();
        List<String> groupsToSearch = new List<String>();
        groupsToSearch = Label.PartnerGroupsForEAPartnerFunctionality.split(';');
        Map<Id, User> mapNewEAUserQueried = new Map<Id, User>();
        //List<EAPartnerLogin_Mapper__c> lstExistingActivePartnerMappingForOldEA = new List<EAPartnerLogin_Mapper__c>();
        //@@Map<Id, List<EAPartnerLogin_Mapper__c>> mapEAOldIdVsLstActiveMappings = new Map<Id, List<EAPartnerLogin_Mapper__c>>();
        //@@Set<Id> eaUserIdstoDeleteConfigRecords = new Set<Id>();
        List<EAPartnerLogin_Mapper__c> lstEligibleMapperRecords = new List<EAPartnerLogin_Mapper__c>();
        Map<String, EA_Configuration__c> mapEAEmpIdVsEAConfigToInsert = new Map<String, EA_Configuration__c>();
        for(EAPartnerLogin_Mapper__c mapperNew: lstNewMapper) {
            // If Existing EA Mapping record is updated to mark as Inactive
            if((mapperNew.Is_Deleted__c == true && mapperNew.Is_Deleted__c !=  mapOldMapper.get(mapperNew.Id).Is_Deleted__c 
                && mapperNew.EAUser__c == mapOldMapper.get(mapperNew.Id).EAUser__c && mapperNew.PartnerUser__c == mapOldMapper.get(mapperNew.Id).PartnerUser__c)) {
                lstEligibleMapperRecords.add(mapperNew);
                setIdUsersToDeleteSession.add(mapOldMapper.get(mapperNew.Id).EAUser__c);
                // calling Future Method to delete EA Config record if that EA is not longen an EA
                //@@futureMthd(mapOldMapper.get(mapperNew.Id).EAUser__c, mapOldMapper.get(mapperNew.Id).PartnerUser__c);
            } 
            // If EA user is Updated in Existing Active Mapping
            else if((mapperNew.EAUser__c != mapOldMapper.get(mapperNew.Id).EAUser__c
                    && mapperNew.PartnerUser__c == mapOldMapper.get(mapperNew.Id).PartnerUser__c && mapperNew.Is_Deleted__c ==  mapOldMapper.get(mapperNew.Id).Is_Deleted__c && mapperNew.Is_Deleted__c == false)) {
                lstEligibleMapperRecords.add(mapperNew);
                setIdUsersToDeleteSession.add(mapOldMapper.get(mapperNew.Id).EAUser__c);
                newEAUserInExistingMapping.add(mapperNew.EAUser__c);
                //@@oldEAUserInExistingMapping.add(mapOldMapper.get(mapperNew.Id).EAUser__c);
            }
            // User is trying to update inactive record
            else if(mapperNew.Is_Deleted__c == true && mapperNew.Is_Deleted__c ==  mapOldMapper.get(mapperNew.Id).Is_Deleted__c ) {
                mapperNew.addError('No changes are allowded in Inactive Mapping record.');
            } else if(mapperNew.EAUser__c == mapperNew.PartnerUser__c){
                mapperNew.addError('Partner and EA user cannot be same.');
            }
            else {
                mapperNew.addError('EA Partner Mapping can only be updated to mark the \'Is Deleted\' field as true or to update the EA User in the Active Mapping record.');
             }
        }


        mapNewEAUserQueried = new Map<Id, User>([SELECT Id, Name, ProfileId, Profile.Name, Emp_Id__c, UserRoleId, UserRole.DeveloperName, PartnerLogin_UserID__c, IsAnExecutiveAdminEA__c
                                                 FROM User WHERE Id IN:newEAUserInExistingMapping]);                                               
        
        List<EA_Configuration__c> lstEAConfig = [SELECT Id, Name, EA_Emp_Id__c,EA_User__c, Original_Role__c, Original_Profile__c, Original_Public_Groups__c, Original_Queues__c
        FROM EA_Configuration__c WHERE EA_User__c IN: newEAUserInExistingMapping];
        Map<Id, EA_Configuration__c> mapEAIdVsConfigRecord = new Map<Id, EA_Configuration__c>();
        for(EA_Configuration__c config: lstEAConfig) {
            mapEAIdVsConfigRecord.put(config.EA_User__c, config);
        }
        List<PermissionSetAssignment> lstPermissionSetAssignments = [SELECT Id, PermissionSetId,PermissionSet.Name, PermissionSetGroupId, AssigneeId, IsActive, IsRevoked FROM PermissionSetAssignment where IsRevoked = false AND AssigneeId =: newEAUserInExistingMapping];
        Map<Id, List<PermissionSetAssignment>> mapEAIdVsLstPermissionSetAssignment = new Map<Id, List<PermissionSetAssignment>>();
        for(PermissionSetAssignment psa: lstPermissionSetAssignments) {
            if(!mapEAIdVsLstPermissionSetAssignment.containsKey(psa.AssigneeId)) {
            mapEAIdVsLstPermissionSetAssignment.put(psa.AssigneeId, new List<PermissionSetAssignment>());
            } else {
                mapEAIdVsLstPermissionSetAssignment.get(psa.AssigneeId).add(psa);
            }
        }

        lstOriginalGroupMemberEA = [SELECT Id, GroupId,Group.DeveloperName, UserOrGroupId, Group.Type FROM GroupMember 
                where (Group.Type = 'Queue' OR Group.Type = 'Regular') AND UserOrGroupId IN:newEAUserInExistingMapping AND Group.DeveloperName IN: groupsToSearch];
        Map<Id, List<GroupMember>> mapEAIdVslstOriginalGroupMember = new Map<Id, List<GroupMember>>();
        for(GroupMember member: lstOriginalGroupMemberEA) {
            if(!mapEAIdVslstOriginalGroupMember.containsKey(member.UserOrGroupId)) {
                mapEAIdVslstOriginalGroupMember.put(member.UserOrGroupId, new List<GroupMember>());
            } else {
                mapEAIdVslstOriginalGroupMember.get(member.UserOrGroupId).add(member);
            }
        }  
        for(EAPartnerLogin_Mapper__c mapperNew: lstEligibleMapperRecords) {
            User EAUserQueried = mapNewEAUserQueried.get(mapperNew.EAUser__c);
            if(EAUserQueried != null) {
                EA_Configuration__c eaConfig = createEAConfigRecord2(EAUserQueried, mapEAIdVsConfigRecord, mapEAIdVsLstPermissionSetAssignment, mapEAIdVslstOriginalGroupMember);
                if(eaConfig != new EA_Configuration__c()) {
                    mapEAEmpIdVsEAConfigToInsert.put(eaConfig.EA_Emp_Id__c, eaConfig);
                }
            }
        }
        //@@lstEAConfigRecordsToDelete = [SELECT Id FROM EA_Configuration__c WHERE EA_User__c =: eaUserIdstoDeleteConfigRecords];  
        //@@Delete lstEAConfigRecordsToDelete;    
        lstSessionsToDelete = [SELECT Id, UsersId,Users.Name, UserType, NumSecondsValid, IsCurrent FROM AuthSession WHERE UsersId IN: setIdUsersToDeleteSession];
        Delete lstSessionsToDelete; 
        Insert mapEAEmpIdVsEAConfigToInsert.values();

    } 

    public static EA_Configuration__c createEAConfigRecord2(User eaUser, Map<Id, EA_Configuration__c> mapEAIdVsConfigRecord, Map<Id, List<PermissionSetAssignment>> mapEAIdVsLstOriginalPSA, Map<Id, List<GroupMember>> mapEAIdVslstOriginalGroupMember) {
        EA_Configuration__c eaConfig = new EA_Configuration__c();
        
        if(mapEAIdVsConfigRecord != null && mapEAIdVsConfigRecord.containsKey(eaUser.Id)) {
            // eaConfig = mapEAIdVsConfigRecord.get(eaUser.Id);
            // return null;
            return eaConfig;
        } 
        // If EA Configuration record is not present, creating a new record for EA config that will have all the Permissions or Access EA user have at that time 
        else {
            List<GroupMember> lstGroupMemberEA = new List<GroupMember>();
            String strEAOriginalPublicGroups = '';
            String strEAOriginalQueueGroups = '';
            String strEAOriginalPermissionSets = '';
            if(mapEAIdVslstOriginalGroupMember.containsKey(eaUser.Id)) {
                lstGroupMemberEA = mapEAIdVslstOriginalGroupMember.get(eaUser.Id);

                for(GroupMember member: lstGroupMemberEA) {
                    if(member.Group.Type == 'Regular') {
                        strEAOriginalPublicGroups += member.Group.DeveloperName + ';';
                    } else {
                        strEAOriginalQueueGroups += member.Group.DeveloperName + ';';
                    }
                } 
                strEAOriginalPublicGroups = strEAOriginalPublicGroups.removeEnd(';');
                System.debug('strEAOriginalPublicGroups--'+strEAOriginalPublicGroups);
                
                strEAOriginalQueueGroups = strEAOriginalQueueGroups.removeEnd(';');
                System.debug('strEAOriginalQueueGroups--'+strEAOriginalQueueGroups);
            }

            List<PermissionSetAssignment> lstPermissionSetAssignments = new List<PermissionSetAssignment>();
            if(mapEAIdVsLstOriginalPSA.containsKey(eaUser.Id)) {

                lstPermissionSetAssignments = mapEAIdVsLstOriginalPSA.get(eaUser.Id);
                for(PermissionSetAssignment psa: lstPermissionSetAssignments) {
                    strEAOriginalPermissionSets += psa.PermissionSet.Name + ';';
                } 
                strEAOriginalPermissionSets = strEAOriginalPermissionSets.removeEnd(';');
                System.debug('strEAOriginalPermissionSets--'+strEAOriginalPermissionSets);
            }
            
            eaConfig.EA_Emp_Id__c = eaUser.EMP_ID__c;
            eaConfig.EA_User__c = eaUser.Id;
            eaConfig.Original_Profile__c = eaUser.Profile.Name;
            eaConfig.Original_Permission_Sets__c = strEAOriginalPermissionSets;
            eaConfig.Original_Role__c = eaUser.UserRole.DeveloperName;
            eaConfig.Original_Queues__c = strEAOriginalQueueGroups;
            eaConfig.Original_Public_Groups__c	= strEAOriginalPublicGroups;
            //Insert eaConfig;
            return eaConfig;
        }
    }

    public static void handleBeforeDelete(List<EAPartnerLogin_Mapper__c> lstMapper) {
        for(EAPartnerLogin_Mapper__c mapperRecord: lstMapper) {
            if((mapperRecord.Is_Deleted__c == false)) {
                mapperRecord.addError('Active Mapping record cannot be deleted');
            }
        }
    } 

}