public class AccountTeamMemberTriggerHelper {
    public static void IsAfterUpdate(List<AccountTeamMember> teamList, Map<Id,AccountTeamMember> oldMap){
        try{
            if(teamList.size() > 0 && oldMap.keySet().size() > 0){
                Set<Id> keyAccount = new Set<Id>();
                Set<Id> accIdsToDeleteYoungCSLs = new Set<Id>();
                Map<Id, AccountTeamMember> accToAccountTeamMemMap = new Map<Id, AccountTeamMember>();
                
                List<Client_Contact_Relationship_Team__c> contactTeamToDelete = new List<Client_Contact_Relationship_Team__c>();
                List<Client_Contact_Relationship_Team__c> contactTeamToCreate = new List<Client_Contact_Relationship_Team__c>();

                for(AccountTeamMember accTeamMem : teamList){
                    if(accTeamMem.AccountId != null){
                        if(checkWCTGSyncConditions(accTeamMem,oldMap)){
                            keyAccount.add(accTeamMem.AccountId);
                        }
                        // Added by Suraj to update Young CSL on contact Team on 13-06-2024
                        if(oldMap.get(accTeamMem.Id).TeamMemberRole == 'Young CSL' && oldMap.get(accTeamMem.Id).TeamMemberRole != accTeamMem.TeamMemberRole){
                            accIdsToDeleteYoungCSLs.add(accTeamMem.AccountId);
                        }
                        else if(accTeamMem.TeamMemberRole == 'Young CSL' && oldMap.get(accTeamMem.Id).TeamMemberRole != accTeamMem.TeamMemberRole){
                            accToAccountTeamMemMap.put(accTeamMem.AccountId, accTeamMem);
                        }
                    }
                }
                // Added by Suraj to update Young CSL on contact Team on 13-06-2024
                if(accIdsToDeleteYoungCSLs != null && accIdsToDeleteYoungCSLs.size() > 0){
                    for (Client_Contact_Relationship_Team__c contactTeamMember : [SELECT Id, Client_Contact__r.AccountId, Role__c FROM Client_Contact_Relationship_Team__c WHERE Client_Contact__r.AccountId IN : accIdsToDeleteYoungCSLs AND Role__c = 'Young CSL']) {
                        contactTeamToDelete.add(contactTeamMember);
                    }

                    if(!contactTeamToDelete.isEmpty() && contactTeamToDelete.size() > 0){
                        for (Client_Contact_Relationship_Team__c contactTeamMember : contactTeamToDelete) {
                            contactTeamMember.System_Deletion__c = true;
                        }
                        Database.update(contactTeamToDelete, false);
                        Database.delete(contactTeamToDelete, false);
                    }


                }

                // Added by Suraj to create Young CSL on contact Team on 13-06-2024
                if(accToAccountTeamMemMap != null && accToAccountTeamMemMap.keySet().size() > 0){
                    for (Contact contactObj : [SELECT Id, AccountId, Name FROM Contact WHERE AccountId IN : accToAccountTeamMemMap.keySet()]) {
                        if(accToAccountTeamMemMap.containsKey(contactObj.AccountId) && accToAccountTeamMemMap.get(contactObj.AccountId) != null){
                            Client_Contact_Relationship_Team__c contactTeamMember = new Client_Contact_Relationship_Team__c();
                            contactTeamMember.Role__c = 'Young CSL';
                            contactTeamMember.Client_Contact__c = contactObj.Id;
                            contactTeamMember.User__c = accToAccountTeamMemMap.get(contactObj.AccountId).UserId;
                            contactTeamMember.Status__c = 'Active';
                            contactTeamMember.System_Deletion__c = true;
                            contactTeamMember.Access__c = 'Read/Write';
                            contactTeamToCreate.add(contactTeamMember);

                        }
                    }
                    if(!contactTeamToCreate.isEmpty() && contactTeamToCreate.size() > 0){
                        Database.insert(contactTeamToCreate, false);
                        for (Client_Contact_Relationship_Team__c contactTeamMember : contactTeamToCreate) {
                            contactTeamMember.System_Deletion__c = false;
                        }
                        Database.update(contactTeamToCreate, false);
                    }


                }
                //End - Suraj

                if(keyAccount.size() > 0){
                    syncGTClientGroup(keyAccount);
                }
            }
        }catch(Exception e){
            system.debug('Exception:'+e.getLineNumber()+' '+e.getMessage());
        }
    }
    
    // Method to handler After Insert Operations : Rajat
    public static void IsAfterInsert(List<AccountTeamMember> teamList){
        try{
            if(teamList.size() > 0){
                Set<Id> keyAccount = new Set<Id>();
                Set<Id> clientIds = new Set<Id>();
                for(AccountTeamMember accTeamMem : teamList){
                    system.debug('accTeamMem:'+accTeamMem);
                    if(accTeamMem.AccountId != null){
                        if(accTeamMem.TeamMemberRole == 'Key Account – CSL' || accTeamMem.TeamMemberRole == 'Key Account – Co-CSL'){
                            keyAccount.add(accTeamMem.AccountId);
                        }else if(accTeamMem.TeamMemberRole == 'Young CSL'){
                            clientIds.add(accTeamMem.AccountId);
                        }
                    }
                }
                if(keyAccount.size() > 0){
                    syncGTClientGroup(keyAccount);
                }if(clientIds.size() > 0){
                    syncClient(clientIds);
                }
            }
        }catch(Exception e){
            system.debug('Exception:'+e.getLineNumber()+' '+e.getMessage());
        }
    }
    
    // Method to check the WCGT Sync Conditions
    private static boolean checkWCTGSyncConditions(AccountTeamMember accTeamMem,Map<Id,AccountTeamMember> oldMap){
        try{
            if(accTeamMem != null && oldMap.keySet().size() > 0){
                if((accTeamMem.TeamMemberRole == 'Key Account – CSL' || accTeamMem.TeamMemberRole == 'Key Account – Co-CSL' || accTeamMem.TeamMemberRole == 'Young CSL') &&
                   accTeamMem.TeamMemberRole != oldMap.get(accTeamMem.Id).TeamMemberRole){
                       return true;
                   }
                return false;
            }
            return false;
        }catch(Exception e){
            system.debug('Exception:'+e.getLineNumber()+' '+e.getMessage());
            return false;
        }
    } 
    
    // Method to Sync GT Client Group Account : Rajat
    public static void syncGTClientGroup(Set<Id> keyAccountIds){
        try{
            if(keyAccountIds.size() > 0){
                List<Account> gtAccountList = [SELECT Id,LastModifiedById,LastModifiedBy.EMP_ID__c FROM Account WHERE Key_Account_360__c IN : keyAccountIds];
                system.debug('gtAccountList:'+gtAccountList);
                if(gtAccountList != null && gtAccountList.size() > 0){
                    for(Account acc : gtAccountList){
                        SalesforceToWCGT.syncGTClientGroupToWCGT(acc.Id);
                    }
                    //AccountTriggerHelper.syncClientGroup(gtAccountList);
                }
            }
        }catch(Exception e){
            system.debug('Exception:'+e.getLineNumber()+' '+e.getMessage());
        }
    }
    
    // Method to Sync Client Account : Rajat
    public static void syncClient(Set<Id> clientIds){
        try{
            system.debug('clientIds:'+clientIds);
            if(clientIds.size() > 0){
                Id clientRecordTypeID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Client').getRecordTypeId();
                List<Account> clientList = [SELECT Id,LastModifiedById,LastModifiedBy.User_ID__c,RecordTypeId FROM Account WHERE Id IN : clientIds AND RecordTypeId = :clientRecordTypeID AND DS_Team_Approval_Status__c = 'DS Approved'];
                if(clientList != null && clientList.size() > 0){
                    system.debug('clientList:'+clientList);
                    if(clientList.size() > 40){
                        Set<Id> accIds = new Set<Id>();
                        for(Account acc : clientList){
                            accIds.add(acc.Id);
                        }
                        Database.executeBatch(new AccountSyncToWCGTBatch(accIds,'Update'),2);
                    }else{
                        for(Account acc : clientList){
                            SalesforceToWCGT.syncClientToWCGT(acc.Id,'Update',acc.LastModifiedById);
                        }
                    }
                }
            }
        }catch(Exception e){
            system.debug('Exception:'+e.getLineNumber()+' '+e.getMessage());
        }
    }
    
    // Added By Prashant on 24-Aug-2023 for work Id: W-002152
    //public static void shareIntegratedEnquiryRecord(List<AccountTeamMember> newAccountTeamMemberList) {
       //Start SFDC-[Phase-1]: code is added by Biplow sarkar | 03-04-2024
        /*
        Map<Id, Set<Id>> accIdVsUserIds = new Map<Id, Set<Id>>();
        Map<Id, Set<Id>>  accIdVsIEIds = new Map<Id, Set<Id>>();
        Map<Id, Set<Id>> ieIdVsUserIds = new Map<Id, Set<Id>>();
        for(AccountTeamMember iter: newAccountTeamMemberList) {
            if(iter.TeamMemberRole == 'Key Account – CSL' || iter.TeamMemberRole == 'Key Account – Co-CSL' || iter.TeamMemberRole == 'Young CSL' ) {
                if(! accIdVsUserIds.containsKey(iter.AccountId)) {
                    accIdVsUserIds.put(iter.AccountId, new Set<Id>());
                }
                accIdVsUserIds.get(iter.AccountId).add(iter.UserId);
            } 
        }
        List<IntegratedEnquiry__c> lstIE = [SELECT Id, Client__c FROM IntegratedEnquiry__c WHERE Client__c IN: accIdVsUserIds.keySet()];
        for(IntegratedEnquiry__c iter: lstIE) {
            if(! accIdVsIEIds.containsKey(iter.Client__c)) {
                accIdVsIEIds.put(iter.Client__c, new Set<Id>());
            }
            accIdVsIEIds.get(iter.Client__c).add(iter.Id);
        }
        for(Id accId: accIdVsUserIds.keySet()) {
            //add 25 line by Bhavishya Basantwani give error of null pointer exception While adding Client Team Member 
            if(accIdVsIEIds.ContainsKey(accId)){
                for(Id ieId : accIdVsIEIds.get(accId)) {
                    ieIdVsUserIds.put(ieId, accIdVsUserIds.get(accId));                
                }
            }
        }
        List<IntegratedEnquiry__Share> lstIEShare = new List<IntegratedEnquiry__Share>();
        for(Id ieId: ieIdVsUserIds.keySet()) {
            for(Id userId: ieIdVsUserIds.get(ieId)) {
                IntegratedEnquiry__Share objShare = new IntegratedEnquiry__Share();
                objShare.ParentId = ieId;
                objShare.UserOrGroupId = userId;
                objShare.RowCause = Schema.IntegratedEnquiry__Share.RowCause.Account_Team_Member__c;
                objShare.AccessLevel = 'Read';
                lstIEShare.add(objShare);
            }
        }
        try {
            insert lstIEShare;
        } catch (exception e) {
            System.debug('Exception - '+e);
        }
        */
        //End SFDC-[Phase-1]: code is added by Biplow sarkar | 03-04-2024
    //}
    
    // Added By Prashant on 24-Aug-2023 for work Id: W-002152
    //public static void unshareIntegratedEnquiryRecord(List<AccountTeamMember> accountTeamMemberList) {
        //Start SFDC-[Phase-1]: code is added by Biplow sarkar | 03-04-2024
       /* Map<Id, Set<Id>> accIdVsUserIds = new Map<Id, Set<Id>>();
        for(AccountTeamMember iter: accountTeamMemberList) {
            if(iter.TeamMemberRole == 'Key Account – CSL' || iter.TeamMemberRole == 'Key Account – Co-CSL' || iter.TeamMemberRole == 'Young CSL' ) {
                if(! accIdVsUserIds.containsKey(iter.AccountId)) {
                    accIdVsUserIds.put(iter.AccountId, new Set<Id>());
                }
                accIdVsUserIds.get(iter.AccountId).add(iter.UserId);
            } 
        }
        List<IntegratedEnquiry__Share> lstIEShare = [SELECT Id, AccessLevel, LastModifiedById, LastModifiedDate, ParentId,Parent.Client__c, RowCause, UserOrGroupId, UserOrGroup.Name
                                                     FROM IntegratedEnquiry__Share WHERE Parent.Client__c IN: accIdVsUserIds.keySet() 
                                                     AND RowCause =: Schema.IntegratedEnquiry__Share.RowCause.Account_Team_Member__c];
        List<IntegratedEnquiry__Share> ieShareToDelete = new List<IntegratedEnquiry__Share>();
        for(IntegratedEnquiry__Share share: lstIEShare) {
            if(accIdVsUserIds.containsKey(share.Parent.Client__c) && accIdVsUserIds.get(share.Parent.Client__c).contains(share.UserOrGroupId)) {
                System.debug('share.id--'+share.id);
                ieShareToDelete.add(new IntegratedEnquiry__Share(Id = share.id));
            }
        }
        try {
            Delete ieShareToDelete;            
        } catch (exception e) {
            System.debug('Exception - '+e);
        }
        */
        //End SFDC-[Phase-1]: code is added by Biplow sarkar | 03-04-2024
    //}
    //Added by Deepak Joshi Date 1-Sep-2023
    public static void validateTeamMembers(List<AccountTeamMember> newList,Map<Id,AccountTeamMember> oldMap){
        
       // System.debug('Final number of script statements used so far : ' + Limits.getDmlStatements());
         //       System.debug('Final heap size: ' + Limits.getHeapSize());
                System.debug('Total Number of SOQL Queries allowed in this apex code context: Start validateTeamMembers Method' +  Limits.getLimitQueries());
                System.debug('1.Number of Queries used in this apex code so far: ' + Limits.getQueries());
        Map<String, Set<String>> mapOfAcountIdAndRole = new  Map<String ,Set<String>>();
        Set<String> accountIds = new Set<String>();
        Set<String> role =new Set<String>();
        List<String> teamRoles = ConstantUtility.CLIENT_TEAM_ROLES.split(',');
        Boolean isInsert = false;
        Id keyRecordTypeID = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Key_Account').getRecordTypeId();
        Map<String,String> keyaccountIdWithCSLrole =new Map<String,String>();
        Set<String> keyaccountIdsCSLRol =new set<String>();
        Set<String> officeManagingPartneUsers =new set<String>();
        Set<String> EMP_IDS =new set<String>();
        for(OfficeManagingPartner__mdt  omp : OfficeManagingPartner__mdt.getAll().values()){
            EMP_IDS.add(omp.EMP_ID__c);
        }
        for(User u :[SELECT Id FROM USER WHERE EMP_ID__c =: EMP_IDS]){
            officeManagingPartneUsers.add(u.Id);
        }
        for(AccountTeamMember team: newList){
            System.debug('currentTeamRole : ' + team.TeamMemberRole);
            System.debug('teamRoles : ' + teamRoles);
            System.debug('list contains current role : ' + teamRoles.contains(team.TeamMemberRole));
            if(!teamRoles.contains(team.TeamMemberRole)){
                team.addError(ConstantUtility.CLIENT_TEAM_ROLES_ERROR_MESSAGE);
            }
            if(team.TeamMemberRole == ConstantUtility.OFFICE_MANAGING_PARTNER && !officeManagingPartneUsers.contains(team.UserId)){
                team.addError(ConstantUtility.OFFICE_MANAGING_PARTNER_ERROR_MESSAGE);
            }
            if(oldMap !=null ){
                if(oldMap.get(team.Id).TeamMemberRole !=team.TeamMemberRole){
                    accountIds.add(team.AccountId);
                }
            }
            else{
                isInsert =true;
                accountIds.add(team.AccountId);
                String tem =team.AccountId+team.TeamMemberRole;
                if(role.contains(tem)){
                    team.addError(ConstantUtility.ONLY_ONE_USER_ROLE);
                }
                if(team.TeamMemberRole == ConstantUtility.KEY_ACCOUNT_CSL){
                    keyaccountIdsCSLRol.add(team.AccountId);
                }
                role.add(tem);
            }
        }
        
        System.debug('Total Number of SOQL Queries allowed in this apex code context: Middle validateTeamMembers Method' +  Limits.getLimitQueries());
                System.debug('1.Number of Queries used in this apex code so far: ' + Limits.getQueries());
        // validation add CSL on Key account
        Set<String> keyAccountIds = new Set<String>();
        if(isInsert ==true){
            List<Account> keyAccountList = [SELECT Id FROM Account WHERE Id =:accountIds AND recordTypeId =: keyRecordTypeID];
            for(Account keyAccount : keyAccountList ){
                keyAccountIds.add(keyAccount.Id);
            }
        }
        List<AccountTeamMember> teamList  = [SELECT Id,TeamMemberRole,AccountId,Account.RecordTypeId FROM AccountTeamMember WHERE AccountId =: accountIds];
        for(AccountTeamMember team : teamList){
            // validation add CSL on Key account
            if(isInsert ==true && keyAccountIds.contains(team.AccountId) && team.TeamMemberRole == ConstantUtility.KEY_ACCOUNT_CSL ){
                keyAccountIds.remove(team.AccountId);
            }
            if (mapOfAcountIdAndRole.containskey(team.AccountId)) {
                mapOfAcountIdAndRole.get(team.AccountId).add(team.TeamMemberRole);
            } 
            else{
                mapOfAcountIdAndRole.put(team.AccountId, new Set<String>{team.TeamMemberRole});
            }
        }
        List<String> teamRolesToRestrictMultipleCreation = ConstantUtility.CLIENT_TEAM_ROLES_FOR_MULTIPLE_USERS.split(','); // Added by Suraj 31-05-2024 
        for(AccountTeamMember team: newList){
            System.debug('role exists? ' + teamRolesToRestrictMultipleCreation.contains(team.TeamMemberRole));
            if (mapOfAcountIdAndRole.containskey(team.AccountId) && mapOfAcountIdAndRole.get(team.AccountId).contains(team.TeamMemberRole) ) {
                if(teamRolesToRestrictMultipleCreation.contains(team.TeamMemberRole)){
                    team.addError(ConstantUtility.TEAM_MEMBER_EXISTS);

                }
            }
            /*if(team.OpportunityAccessLevel !='Edit'){
                team.addError(ConstantUtility.ENQUIRY_ACCESS);
            }*/
            /*if(team.CaseAccessLevel !='Edit'){
                team.addError(ConstantUtility.PRELIMINARY_ACCES);
            }*/
            //Start SFDC-[Phase-1]: code is added by Biplow sarkar | 11-04-2024
            if( ! (team.ContactAccessLevel == 'Read' || team.ContactAccessLevel == 'None' ) ){
                team.addError(ConstantUtility.CLIENT_CONTACT_ACCESS);
            }
             //End SFDC-[Phase-1]:
            if(keyAccountIds.contains(team.AccountId) && (team.TeamMemberRole !=ConstantUtility.SEGMENT_LEADER && team.TeamMemberRole !=ConstantUtility.KEY_ACCOUNT_CSL)) {
                if(!keyaccountIdsCSLRol.contains(team.AccountId)){
                    team.addError(ConstantUtility.ADD_CO_CSL_MESSAGE); 
                }
            }
            //Added by Deepak Joshi for Nomenclature
            if(team.TeamMemberRole == ConstantUtility.OFFICE_MANAGING_PARTNER && team.AccountAccessLevel !='Edit'){
                team.addError(ConstantUtility.OFFICE_MANAGING_PARTNER_ACCESS);
            }
        }
        
        System.debug('Total Number of SOQL Queries allowed in this apex code context: Finish validateTeamMembers Method' +  Limits.getLimitQueries());
        System.debug('1.Number of Queries used in this apex code so far: ' + Limits.getQueries());

    }
    
    //Added By Bhavishya Basantwani (Date 14 sep 2023)
    //This Method is used For restrict to add CO-CSl and CSL In Account Only In CLient Record Type (CO-CSl and CSl Is Added In CLient record Type Record With automation From Key Account Record Type)
    public static void ValidateCslCoCsl(List<AccountTeamMember> newList){
        
        
        System.debug('Total Number of SOQL Queries allowed in this apex code context: Start ValidateCslCoCsl Method' +  Limits.getLimitQueries());
                System.debug('1.Number of Queries used in this apex code so far: ' + Limits.getQueries());
        Id clientRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Client').getRecordTypeId();
        system.debug('clientRecordTypeId'+clientRecordTypeId);
        
        set<Id> setOfClientIds = new set<Id>();
        for(AccountTeamMember Team : newList){
            setOfClientIds.add(Team.AccountId);
        }
        
        List<Account> ListOfClients = [select id,name,RecordTypeId from Account where id IN: setOfClientIds];
        system.debug('ListOfClients'+ListOfClients);
        Map<Id,Account> MapOfClient = new Map<Id,Account>();
        
        for(Account acc : ListOfClients){
            if(!MapOfClient.containsKey(acc.Id)){
                MapOfClient.put(acc.Id,acc);
            }
        }
        
        for(AccountTeamMember Team : newList){
            if((Team.TeamMemberRole == 'Key Account – CSL' || Team.TeamMemberRole == 'Key Account – Co-CSL') && Team.CslCO_Csl__c == False){
                system.debug('In');
                if(MapOfClient.containsKey(Team.AccountId)){
                    Account acc = MapOfClient.get(Team.AccountId);
                    if(acc.RecordTypeId == clientRecordTypeId){
                        Team.addError('You Cannot add Csl And Co-csl');
                    } 
                }
            }
        }
        System.debug('Total Number of SOQL Queries allowed in this apex code context: finish ValidateCslCoCsl Method' +  Limits.getLimitQueries());
                System.debug('1.Number of Queries used in this apex code so far: ' + Limits.getQueries());
    }
    //end   
    
    // Added By Bhavishya Basantwani
    
    // This class is used for validated from delete Account Team Memebr That Role Has Relationship Leader , Co-csl and Csl.
     public static void ValidateCslCoCslNOwnerFromDelete(List<AccountTeamMember> newList){
        
        Id clientRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Client').getRecordTypeId();
        system.debug('clientRecordTypeId'+clientRecordTypeId);
        Set<Id> SetOfAccountIds = new Set<Id>();
        Map<Id,Account> mapOfAccount = new  Map<Id,Account>();
        for(AccountTeamMember CTM : newList){
            SetOfAccountIds.add(CTM.AccountId);
        }
        
        List<Account> ListOfAccount = [Select Id,Name,RecordType.Name, Account_Record_Type__c from Account Where Id IN: SetOfAccountIds];
        
        for(Account acc : ListOfAccount){
            If(!mapOfAccount.ContainsKey(acc.Id)){
                mapOfAccount.put(acc.Id,acc);
            }
        }
        system.debug('mapOfAccount'+mapOfAccount);
        for(AccountTeamMember CTM : newList){
            system.debug('System_Deletion__c'+CTM.System_Deletion__c);
            if(mapOfAccount.get(CTM.AccountId).RecordType.Id == clientRecordTypeId && (CTM.TeamMemberRole == 'Key Account – CSL' || CTM.TeamMemberRole == 'Key Account – Co-CSL' || CTM.TeamMemberRole == 'Relationship Leader' ||  CTM.TeamMemberRole == 'Sector Expert') && CTM.System_Deletion__c == False){
                System.debug('INnneror');
                CTM.addError('You cannot delete team member');   
            } 
            if(mapOfAccount.get(CTM.AccountId).Account_Record_Type__c == 'Key Account' && (CTM.TeamMemberRole == 'Key Account – CSL') && CTM.System_Deletion__c == False){
                System.debug('INnneror');
                // CTM.addError('You are not authorized to delete Key Account CSL, please add Key Account CSL so that the older one gets updated');   
            } 
        }
    }
    //end by bhavishya Basantwani
    
    //public static void insertCSLandCOCSLonEnquiry(List<AccountTeamMember> accTeamMemberList,Set<Id> accountIds){
        //Start SFDC-[Phase-1]: code is added by Biplow sarkar | 03-04-2024
        /*
        System.debug('accTeamMemberList >>' + accTeamMemberList);
        System.debug(';accountIds : ' + accountIds);
        
        List<Account> getKeyAccountList = [select id from Account where Id IN:accountIds AND AccountType__c ='Key Client'];
        System.debug('getKeyAccountList==> '+getKeyAccountList);
        if(!getKeyAccountList.isEmpty()){
            List<Opportunity> oppList = [select id,AccountId, StageName from Opportunity where AccountId IN : getKeyAccountList AND StageName != 'Closed Won' AND StageName != 'Closed Lost'];
            List<OpportunityTeamMember> insertOpportunityTeamMemberList = new List<OpportunityTeamMember>();
            Map<Id,List<Opportunity>> accountIdwithOpportunityMap = new  Map<Id,List<Opportunity>>();
            for(Opportunity oppObj: oppList){
                if(oppObj.AccountId==null){
                    System.debug('AccounId is null');
                    continue;
                }
                if(!accountIdwithOpportunityMap.ContainsKey(oppObj.AccountId)){
                    accountIdwithOpportunityMap.put(oppObj.AccountId,new List<Opportunity>{oppObj});
                    System.debug('accountIdwithOpportunityMap >>' + accountIdwithOpportunityMap);
                }
                else{
                    accountIdwithOpportunityMap.get(oppObj.AccountId).add(oppObj);
                }
            }
            System.debug('Account map '+accountIdwithOpportunityMap);
            System.debug('AccountId from Team Member'+accTeamMemberList);
            for(AccountTeamMember acctTeamMemObj: accTeamMemberList){
                System.debug('Account Id '+accountIdwithOpportunityMap.get(acctTeamMemObj.AccountId));
                if(accountIdwithOpportunityMap.ContainsKey(acctTeamMemObj.AccountId)){
                    for(Opportunity oppObj:accountIdwithOpportunityMap.get(acctTeamMemObj.AccountId)){
                        OpportunityTeamMember oppTeam = new OpportunityTeamMember();
                        oppTeam.TeamMemberRole = acctTeamMemObj.TeamMemberRole;
                        oppTeam.UserId = acctTeamMemObj.UserId;
                        oppTeam.OpportunityAccessLevel = 'Edit';
                        oppTeam.OpportunityId = oppObj.Id;
                        oppTeam.CSLOrCoCSLAddedFromClient__c = true;
                        insertOpportunityTeamMemberList.add(oppTeam);
                    } 
                }
                
            }
            System.debug('insert =='+insertOpportunityTeamMemberList);
            try{
                Database.insert(insertOpportunityTeamMemberList,false);     
            }
            catch(Exception e){
                System.debug('Error msg'+ e.getMessage());
            }
        }
        */
        //End SFDC-[Phase-1]: code is added by Biplow sarkar | 03-04-2024
    //}
    //public static void deleteOpportunityTeamMember(List<AccountTeamMember> accTeamMemberList,Set<Id> accountIds){
        //Start SFDC-[Phase-1]: code is added by Biplow sarkar | 03-04-2024
        /*
        System.debug('accountIds : ' + accountIds);
        
        Map<Id,Opportunity> oppListMap = new Map<Id,Opportunity>([select id,AccountId from Opportunity where AccountId IN : accountIds AND StageName != 'Closed Won' AND StageName != 'Closed Lost']);
        
        if(!oppListMap.isEmpty()){
            System.debug('oppListMap : ' + oppListMap);
            List<OpportunityTeamMember> deleteOpportunityTeamMemberList = new List<OpportunityTeamMember>();
            List<OpportunityTeamMember> oppoTeamMemberList = [select id,OpportunityId,TeamMemberRole from OpportunityTeamMember where OpportunityId IN :oppListMap.KeySet()
                                                              AND (TeamMemberRole = 'Key Account – CSL' OR TeamMemberRole = 'Key Account – Co-CSL' OR TeamMemberRole = 'Young CSL')];
            
            System.debug('oppoTeamMemberList : ' + oppoTeamMemberList);
            
            Map<id,List<OpportunityTeamMember>> mapofAccountIdwithOppTeamMember = new Map<id,List<OpportunityTeamMember>>();
            
            for(OpportunityTeamMember oppTeamObj:oppoTeamMemberList ){
                if(oppTeamObj.OpportunityId==null){
                    continue;
                }
                String accId = oppListMap.get(oppTeamObj.OpportunityId).AccountId!=null?oppListMap.get(oppTeamObj.OpportunityId).AccountId:null;
                if(accId==null){
                    continue;
                }
                if(!mapofAccountIdwithOppTeamMember.containsKey(accId)){
                    mapofAccountIdwithOppTeamMember.put(accId,new List<OpportunityTeamMember>{oppTeamObj});
                    System.debug('OppTeamMember added');
                }
                else{
                    mapofAccountIdwithOppTeamMember.get(accId).add(oppTeamObj);
                }
                
            }
            
            System.debug('mapofAccountIdwithOppTeamMember : ' + mapofAccountIdwithOppTeamMember);
            
            for(AccountTeamMember accTeamObj: accTeamMemberList){
                if(mapofAccountIdwithOppTeamMember.ContainsKey(accTeamObj.AccountId)){
                    for(OpportunityTeamMember oppoTeamObj:mapofAccountIdwithOppTeamMember.get(accTeamObj.AccountId)){
                        if(accTeamObj.TeamMemberRole==oppoTeamObj.TeamMemberRole){
                            deleteOpportunityTeamMemberList.add(oppoTeamObj);
                        }
                    }
                }
            }
            System.debug('Delete =='+deleteOpportunityTeamMemberList);
            try{
                delete deleteOpportunityTeamMemberList;     
            }
            catch(Exception e){
                System.debug('Error msg'+ e.getMessage());
            }
        }
        */
         //End SFDC-[Phase-1]: code is added by Biplow sarkar | 03-04-2024
    //}
    //Added by Deepak Joshi Date 28-Sep-2023
    public static void addCSLonAccountTeamInsert(List<AccountTeamMember> newList){
        Map<String,AccountTeamMember> accountIdWithAccountTeamMember = new Map<String,AccountTeamMember>();
        for(AccountTeamMember team : newList){
            if(team.TeamMemberRole == ConstantUtility.KEY_ACCOUNT_CSL ){
                accountIdWithAccountTeamMember.Put(team.AccountId,team);
            }
        } 
        if(accountIdWithAccountTeamMember.size() > 0){
            updateCSLonAccount(accountIdWithAccountTeamMember,false);
            

        }
       
    }
    public static void addCSLonAccountTeamUpdate(List<AccountTeamMember> newList,Map<Id,AccountTeamMember> oldMap){
        Map<String,AccountTeamMember> accountIdWithAccountTeamMember = new Map<String,AccountTeamMember>();
        Map<String,AccountTeamMember> accountIdWithAccountTeamMemberNullUser = new Map<String,AccountTeamMember>();
        for(AccountTeamMember team : newList){
            if(team.TeamMemberRole == ConstantUtility.KEY_ACCOUNT_CSL && oldMap.get(team.Id).TeamMemberRole != team.TeamMemberRole){
                accountIdWithAccountTeamMember.Put(team.AccountId,team);
            }
            else if(oldMap.get(team.Id).TeamMemberRole == ConstantUtility.KEY_ACCOUNT_CSL && oldMap.get(team.Id).TeamMemberRole != team.TeamMemberRole){
                accountIdWithAccountTeamMemberNullUser.put(team.AccountId,team);
            }

        }
        if(accountIdWithAccountTeamMember.size() > 0){
            updateCSLonAccount(accountIdWithAccountTeamMember,false);
        }
        if(accountIdWithAccountTeamMemberNullUser.size()> 0){
            updateCSLonAccount(accountIdWithAccountTeamMemberNullUser,true);

        }

    }
    public static void addCSLonAccountTeamDelete(List<AccountTeamMember> oldList){
        Map<String,AccountTeamMember> accountIdWithAccountTeamMemberNullUser = new Map<String,AccountTeamMember>();
        for(AccountTeamMember team : oldList){
            if(team.TeamMemberRole == ConstantUtility.KEY_ACCOUNT_CSL ){
                accountIdWithAccountTeamMemberNullUser.Put(team.AccountId,team);
            }
        }
        if(accountIdWithAccountTeamMemberNullUser.size()> 0){
            updateCSLonAccount(accountIdWithAccountTeamMemberNullUser,true);

        }

    }
    public static void updateCSLonAccount(Map<String,AccountTeamMember> accountIdWithAccountTeamMember, Boolean isNUll){
        String keyAccountId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get(ConstantUtility.KEY_ACCOUNT).getRecordTypeId();
        List<Account> accountList = [SELECT Id,CSL__c,OwnerId FROM Account WHERE Id =: accountIdWithAccountTeamMember.keySet() AND RecordTypeId =:keyAccountId];
        for(Account acc :accountList){
            if(isNUll ==false){
                acc.CSL__c =accountIdWithAccountTeamMember.get(acc.Id).UserId;
                //acc.OwnerId =accountIdWithAccountTeamMember.get(acc.Id).UserId;
            }
            else{
                acc.CSL__c =null;
            }
        }
        System.debug('**team  accountList 22 '+accountList);
        if(!accountList.isEmpty()){
            update accountList;
        }
    }
    //end by Deepak Joshi
    
    // Create Sharing record for EA is Partner is added to Account Team
    // Added by BHavishya Basantwani
    public static void shareAccWithEA(List<AccountTeamMember> accTeamMemList){
        
        Set<Id> accId = New set<Id>(); 
        set<Id> accTeamMemId = new set<Id>();
        Map<Id,List<AccountTeamMember>> accIdAndAccTeamMem = new Map<Id,List<AccountTeamMember>>(); // Map of Account Id and its Account Team Member list
        Map<Id,List<AccountShare>> accIdAndAccShare = new Map<Id,List<AccountShare>>();
        Map<Id, Id> partnerIdAndEAId = new Map<Id, Id>();
        List<AccountShare> accShareRecordsToBeCreated = New List<AccountShare>();
        
        for(AccountTeamMember accTeamMem :accTeamMemList){
            accId.add(accTeamMem.AccountId);
            accTeamMemId.add(accTeamMem.UserId);
        }
        List<EAPartnerLogin_Mapper__c> eaPartnerList  = [SELECT id, EAUser__c, PartnerUser__c FROM EAPartnerLogin_Mapper__c WHERE PartnerUser__c IN :accTeamMemId AND EAUser__r.IsActive = true];
        for(EAPartnerLogin_Mapper__c eaPartnerObj : eaPartnerList){
                partnerIdAndEAId.put(eaPartnerObj.PartnerUser__c, eaPartnerObj.EAUser__c);
        }
        system.debug('partnerIdAndEAId'+partnerIdAndEAId);
        for(AccountTeamMember accTeamMemObj : accTeamMemList){
            if(partnerIdAndEAId.containsKey(accTeamMemObj.UserId)){
                AccountShare accShare = New AccountShare();
                accShare.AccountId = accTeamMemObj.AccountId;
                accShare.UserOrGroupId = partnerIdAndEAId.get(accTeamMemObj.UserId);
                accShare.RowCause = 'Manual'; // 'Account_Team_Member';
                accShare.AccountAccessLevel = accTeamMemObj.AccountAccessLevel;
                accShare.ContactAccessLevel = accTeamMemObj.ContactAccessLevel;
                accShare.OpportunityAccessLevel = accTeamMemObj.OpportunityAccessLevel;
                accShare.CaseAccessLevel = accTeamMemObj.CaseAccessLevel;
                accShareRecordsToBeCreated.add(accShare);
            }
        }
        if(accShareRecordsToBeCreated.size()>0){
            upsert accShareRecordsToBeCreated;
        }
    } 
    
    
    public static void unshareAccWithEA(List<AccountTeamMember> accTeamMemList){
        system.debug('unshareAccWithEA method is called');
        Set<Id> accId = New set<Id>(); // all acc ids of team member from which team member are deleted
        set<Id> accTeamMemId = new set<Id>();
        Map<Id,List<AccountTeamMember>> accIdAndAccTeamMem = new Map<Id,List<AccountTeamMember>>(); // Map of Account Id and its Account Team Member list
        Map<Id,AccountShare> accIdAndAccShare = new Map<Id,AccountShare>();
        Map<Id,Map<Id, String>> accIdVsEaIdVsNewAccess = new Map<Id,Map<Id, String>>();
        Map<Id, Id> partnerIdAndEAId = new Map<Id, Id>();
        Map<Id, Id> AllpartnerIdAndEAId = new Map<Id, Id>();
       
        List<AccountShare> accShareRecordsToBeDeleted = New List<AccountShare>();
        List<AccountShare> accShareRecordsToBeUpdated = New List<AccountShare>();
        
        for(AccountTeamMember accTeamMem : accTeamMemList){
            accId.add(accTeamMem.AccountId);
            accTeamMemId.add(accTeamMem.UserId);
            system.debug('accTeamMem.AccountId'+accTeamMem.AccountId);
        }
        system.debug('AccId'+accId);
        system.debug('accTeamMemId'+accTeamMemId);
        List<EAPartnerLogin_Mapper__c> eaPartnerList = [SELECT id, EAUser__c, PartnerUser__c FROM EAPartnerLogin_Mapper__c];
        for(EAPartnerLogin_Mapper__c eaPartnerObj : eaPartnerList){
            
            AllpartnerIdAndEAId.put(eaPartnerObj.PartnerUser__c, eaPartnerObj.EAUser__c);
            if(accTeamMemId.Contains(eaPartnerObj.PartnerUser__c)){
                System.debug('eaPartnerObj.PartnerUser__c'+eaPartnerObj.PartnerUser__c);
                partnerIdAndEAId.put(eaPartnerObj.PartnerUser__c, eaPartnerObj.EAUser__c);
            }
        }
        system.debug('AllpartnerIdAndEAId'+AllpartnerIdAndEAId);
        system.debug('AllpartnerIdAndEAId Size'+AllpartnerIdAndEAId.size());
        system.debug('partnerIdAndEAId'+partnerIdAndEAId);
        List<Account> accList = [SELECT Id, (SELECT Id, AccountAccessLevel, UserId  FROM AccountTeamMembers) From Account WHERE Id IN : accId ];
        For(Account accObj : accList){
            system.debug('inside for loop to get Account');
            if(!accIdVsEaIdVsNewAccess.containsKey(accObj.id)){
                accIdVsEaIdVsNewAccess.put(accObj.id, New Map<Id, String>());
                system.debug('accIdAndOppTeamMem.containsKey'+accObj.id);
                for(AccountTeamMember accTeamMemObj : accObj.AccountTeamMembers){
                    system.debug('accTeamMemObj 1'+accTeamMemObj.UserId);
                    if(AllpartnerIdAndEAId.containsKey(accTeamMemObj.UserId)){
                        system.debug('AllpartnerIdAndEAId.containsKey(accTeamMemObj.UserId)'+accTeamMemObj.UserId);
                        accIdAndAccTeamMem.put(accObj.id, New List<AccountTeamMember>());
                        accIdAndAccTeamMem.get(accObj.id).add(accTeamMemObj);
                        
                        system.debug('accTeamMemId.contains(accTeamMemObj.UserId)'+accTeamMemObj.UserId);
                        system.debug('accTeamMemId---->'+accTeamMemId);
                        if(!accTeamMemId.contains(accTeamMemObj.UserId)){
                            system.debug('inside second if');
                            if(!accIdVsEaIdVsNewAccess.containsKey(accObj.id)){
                                system.debug('inside third if');
                                
                                system.debug('inside forth if');
                                if(!(accIdVsEaIdVsNewAccess.get(accObj.id).containsKey(AllpartnerIdAndEAId.get(accTeamMemObj.UserId)))){
                                    accIdVsEaIdVsNewAccess.get(accObj.id).put(AllpartnerIdAndEAId.get(accTeamMemObj.UserId), accTeamMemObj.AccountAccessLevel);
                                }
                                else if(accIdVsEaIdVsNewAccess.get(accObj.id).containsKey(AllpartnerIdAndEAId.get(accTeamMemObj.UserId))){
                                    system.debug('inside first if else');
                                    if(accIdVsEaIdVsNewAccess.get(accObj.id).get(AllpartnerIdAndEAId.get(accTeamMemObj.UserId)) != accTeamMemObj.AccountAccessLevel){
                                        if(accIdVsEaIdVsNewAccess.get(accObj.id).get(AllpartnerIdAndEAId.get(accTeamMemObj.UserId))=='Read' && accTeamMemObj.AccountAccessLevel == 'Edit' ){
                                            accIdVsEaIdVsNewAccess.get(accObj.id).put(AllpartnerIdAndEAId.get(accTeamMemObj.UserId), 'Edit');
                                        }
                                        if(accIdVsEaIdVsNewAccess.get(accObj.id).get(AllpartnerIdAndEAId.get(accTeamMemObj.UserId))=='Read' && accTeamMemObj.AccountAccessLevel == 'All' ){
                                            accIdVsEaIdVsNewAccess.get(accObj.id).put(AllpartnerIdAndEAId.get(accTeamMemObj.UserId), 'All');
                                        }
                                        if(accIdVsEaIdVsNewAccess.get(accObj.id).get(AllpartnerIdAndEAId.get(accTeamMemObj.UserId))=='Edit' && accTeamMemObj.AccountAccessLevel == 'All' ){
                                            accIdVsEaIdVsNewAccess.get(accObj.id).put(AllpartnerIdAndEAId.get(accTeamMemObj.UserId), 'All');
                                        }
                                    }
                                }
                            }
                            else if(accIdVsEaIdVsNewAccess.containsKey(accObj.id)){
                                if(!(accIdVsEaIdVsNewAccess.get(accObj.id).containsKey(AllpartnerIdAndEAId.get(accTeamMemObj.UserId)))){
                                    accIdVsEaIdVsNewAccess.get(accObj.id).put(AllpartnerIdAndEAId.get(accTeamMemObj.UserId), accTeamMemObj.AccountAccessLevel);
                                }
                                else if(accIdVsEaIdVsNewAccess.get(accObj.id).containsKey(AllpartnerIdAndEAId.get(accTeamMemObj.UserId))){
                                    if(accIdVsEaIdVsNewAccess.get(accObj.id).get(AllpartnerIdAndEAId.get(accTeamMemObj.UserId)) != accTeamMemObj.AccountAccessLevel){
                                        if(accIdVsEaIdVsNewAccess.get(accObj.id).get(AllpartnerIdAndEAId.get(accTeamMemObj.UserId))=='Read' && accTeamMemObj.AccountAccessLevel == 'Edit' ){
                                            accIdVsEaIdVsNewAccess.get(accObj.id).put(AllpartnerIdAndEAId.get(accTeamMemObj.UserId), 'Edit');
                                        }
                                        if(accIdVsEaIdVsNewAccess.get(accObj.id).get(AllpartnerIdAndEAId.get(accTeamMemObj.UserId))=='Read' && accTeamMemObj.AccountAccessLevel == 'All' ){
                                            accIdVsEaIdVsNewAccess.get(accObj.id).put(AllpartnerIdAndEAId.get(accTeamMemObj.UserId), 'All');
                                        }
                                        if(accIdVsEaIdVsNewAccess.get(accObj.id).get(AllpartnerIdAndEAId.get(accTeamMemObj.UserId))=='Edit' && accTeamMemObj.AccountAccessLevel == 'All' ){
                                            accIdVsEaIdVsNewAccess.get(accObj.id).put(AllpartnerIdAndEAId.get(accTeamMemObj.UserId), 'All');
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            else if(accIdAndAccTeamMem.containsKey(accObj.id)){
                for(AccountTeamMember accTeamMemObj : accObj.AccountTeamMembers){
                    if(AllpartnerIdAndEAId.containsKey(accTeamMemObj.UserId)){
                        accIdAndAccTeamMem.get(accObj.id).add(accTeamMemObj);
                    }
                }
            }
        }
        
        System.debug('accIdVsEaIdVsNewAccess --> ' + accIdVsEaIdVsNewAccess);

        List<AccountShare> accShareList = [SELECT Id, AccountId, RowCause, UserOrGroupId FROM AccountShare WHERE (AccountId IN : accId AND RowCause = 'Manual')];
        
        for(AccountShare accShare : accShareList){
            system.debug('accShare'+accShare);
            system.debug('accIdVsEaIdVsNewAccess in Acc Share Loop+'+accIdVsEaIdVsNewAccess);
            if(accIdVsEaIdVsNewAccess.containsKey(accShare.AccountId)){
                system.debug('accShare.AccountId--->'+accShare.AccountId);
                if(!(accIdVsEaIdVsNewAccess.get(accShare.AccountId).containsKey(accShare.UserOrGroupId))){
                    system.debug('NOT accIdVsEaIdVsNewAccess.get(accShare.AccountId).containsKey(accShare.UserOrGroupId)--->'+accShare.UserOrGroupId);
                    accShareRecordsToBeDeleted.add(accShare);
                }
                else if(accIdVsEaIdVsNewAccess.get(accShare.AccountId).containsKey(accShare.UserOrGroupId)){
                    system.debug('accIdVsEaIdVsNewAccess.get(accShare.AccountId).containsKey(accShare.UserOrGroupId)--->'+accShare.UserOrGroupId);
                    accShare.AccountAccessLevel = accIdVsEaIdVsNewAccess.get(accShare.AccountId).get(accShare.UserOrGroupId);
                    accShareRecordsToBeUpdated.add(accShare);
                }
            }
        }
        system.debug('accIdVsEaIdVsNewAccess'+accIdVsEaIdVsNewAccess);
        system.debug('accShareRecordsToBeUpdated'+accShareRecordsToBeUpdated);
        if(accShareRecordsToBeDeleted.size()>0){
            system.debug('accShareRecordsToBeDeleted'+accShareRecordsToBeDeleted);
            delete accShareRecordsToBeDeleted;
        }
        if(accShareRecordsToBeUpdated.size()>0){
            system.debug('accShareRecordsToBeUpdated'+accShareRecordsToBeUpdated);
            update accShareRecordsToBeUpdated;
        }
    } 


    // public static void validateCSL(List<AccountTeamMember> teamMemberList){
    //     for (AccountTeamMember memberObj : teamMemberList) {
    //         if(memberObj.TeamMemberRole == ConstantUtility.KEY_ACCOUNT_CSL){

    //         }
    //     }
    // }


    public static void deleteCSLFromKeyClient(List<AccountTeamMember> accTeamMembers){
        Set<Id> accountIds = new Set<Id>();
        List<AccountTeamMember> teamMembersToDelete = new List<AccountTeamMember>();
        for (AccountTeamMember memberObj : accTeamMembers) {
            if (memberObj.TeamMemberRole == ConstantUtility.KEY_ACCOUNT_CSL) {
                accountIds.add(memberObj.AccountId);
            }
        }

        System.debug('accountIds : ' + accountIds);

        if(accountIds != null){
            for (AccountTeamMember memberObj : [SELECT Id, TeamMemberRole, AccountId, Account.Account_Record_Type__c FROM AccountTeamMember WHERE AccountId IN : accountIds AND TeamMemberRole =: ConstantUtility.KEY_ACCOUNT_CSL]) {
                System.debug('Current Team member : ' + memberObj);
                System.debug('Account Record Type : ' + memberObj.Account.Account_Record_Type__c);
                System.debug('does csl contains ? : ' + accTeamMembers.contains(memberObj));
                if(!accTeamMembers.contains(memberObj) && memberObj.Account.Account_Record_Type__c == 'Key Account'){
                    System.debug('Member added for deletion');
                    memberObj.System_Deletion__c = true;
                    teamMembersToDelete.add(memberObj);
                }
            }
        }

        System.debug('teamMembersToDelete : ' + teamMembersToDelete);

        if(!teamMembersToDelete.isEmpty() && teamMembersToDelete.size() > 0){
            Database.delete(teamMembersToDelete, false);
        }
    }
    
}