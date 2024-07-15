/*
* @Name: salesforceToWCGTHelper
* @Author: Rakesh Kumar
* @Description:checking the type of sObject associated with the given recordId. 
* @Date: 20-July-23
*/

public class salesforceToWCGTHelper {
    
    @InvocableMethod(label='Check sObject')
    public static List<Result> sendWhenBDActivity(List<Id> recordId)
    {
        System.debug('Id -->:' + recordId[0]);
        System.debug('Ids -->:' + recordId); 
        
        // Create a list to hold the Result objects that will be returned
        List<Result> responseWrapper = new List<Result>();
        
        // Create a new Result object to store the response data
        Result response = new Result();
        
        // Get the sObject type name of the Id
        response.outputMember = String.valueOf(recordId[0].getSobjectType());
        responseWrapper.add(response);
        System.debug('responseWrapper=='+responseWrapper);
        return responseWrapper;
    }
    
    // Added by Rajat for GT Client Group Mapping for WCGT Sync
    public static String getGTClientGroupReqWrp(List<Account> gtClient){
        try{
            if(gtClient != null && gtClient.size() > 0){
                GTClientGroupReqWrp gtClientReqWrp = new GTClientGroupReqWrp();
                gtClientReqWrp.sClientGroupSFID = gtClient[0].ID;
                if(gtClient[0].Key_Account_360__c != null){
                    List<String> teamRole = new List<String>{'Key Account – CSL','Key Account – Co-CSL'};
                    gtClientReqWrp.sKeyAccountId = gtClient[0].Key_Account_360__c;
                    List<AccountTeamMember> clientTeam = [SELECT Id,TeamMemberRole, UserId,User.EMP_ID__c FROM AccountTeamMember 
                                                          WHERE AccountId =:gtClient[0].Key_Account_360__c AND 
                                                          TeamMemberRole IN: teamRole];
                    if(clientTeam != null && clientTeam.size() > 0){
                        for(AccountTeamMember clientT : clientTeam){
                            if(clientT.TeamMemberRole == 'Key Account – CSL'){
                                gtClientReqWrp.sCSLID = clientT.User.EMP_ID__c != Null ? clientT.User.EMP_ID__c : '';
                            }else if(clientT.TeamMemberRole == 'Key Account – Co-CSL'){
                                gtClientReqWrp.sCoCSLId = clientT.User.EMP_ID__c != Null ? clientT.User.EMP_ID__c : '';
                            }
                        }
                    }
                    gtClientReqWrp.sKam_NonKam = '1';
                    String category = gtClient[0].Key_Account_360__r.Client_Category__c != null ? 
                                      WCGTMasterService.getWCGTRecord('Category CX GX', gtClient[0].Key_Account_360__r.Client_Category__c) : '';
                    gtClientReqWrp.sCategory_CX_GX = category != null ? category : null;
                }else{
                    gtClientReqWrp.sKam_NonKam = '0';
                    gtClientReqWrp.sCSLID = '';
                    gtClientReqWrp.sCoCSLId = '';
                    gtClientReqWrp.sCategory_CX_GX = '';
                }
                String reqBody = JSON.serialize(gtClientReqWrp);
                return reqBody;
            }else{
                return null;
            }
        }catch(Exception e){
            system.debug('exception:'+e.getLineNumber()+' '+e.getMessage());
            return null;
        }
    }
    
    // Added by Rajat for GT Client Group for WCGT Sync
    public static Api_Logger__c syncGTClient(Id gtClientID){
        Api_Logger__c apiLog = new Api_Logger__c();
        try{
            if(gtClientID != null){
                system.debug('sync to GT called');
                Http http = new Http();
                HttpRequest req = new HttpRequest();
                WCGTEndPoint__mdt metaRecord = WCGTEndPoint__mdt.getInstance('GT_Client_Group_Insert');

                String token = SalesforceToWCGTAccess.getAuthenticationToken();
                String endpoint = metaRecord.URL__c + '?stoken=' + token;
                req.setEndpoint(endpoint);
                req.setMethod('POST');
        	    req.setHeader('Authorization','Bearer '+token); 
                req.setHeader('Content-Type','application/json');
                List<Account> gtClient = new List<Account>();
                gtClient = AccountService.getGTClientGroup(new Set<Id>{gtClientID});
                if(gtClient != null && gtClient.size() > 0){
                    String reqBody = SalesforceToWCGTHelper.getGTClientGroupReqWrp(gtClient);
                    req.setBody(reqBody);
                    System.debug('reqBody -->'+reqBody);
                    HttpResponse resp = http.send(req);
                    System.debug('resp -->'+resp);
                    apiLog = API_LoggerCommonUtility.createAPILogger(gtClientID,reqBody,resp.getBody(),resp.getStatus(),'SalesforceToWCGT.syncGTClient',endpoint,resp.getStatusCode(),null,null);                   
                }
            }
        }catch(Exception e){
            system.debug('Exception e:'+e.getLineNumber()+' '+e.getMessage());
        }
        return apiLog;
    }
    
    // Added by Rajat for Key Account Mapping for WCGT Sync
    public static String getKeyAccountReqWrp(List<Account> keyAcc,String flag){
        try{
            if(keyAcc != null && keyAcc.size() > 0){
                KeyAccountReqWrp keyAccReqWrp = new KeyAccountReqWrp();
                keyAccReqWrp.sKeyAccountId   = keyAcc[0].Id;
                keyAccReqWrp.sKeyAccountName = keyAcc[0].Name;
                keyAccReqWrp.sFlag           = flag == 'Insert' ? '1' : '2';
                String reqBody = JSON.serialize(keyAccReqWrp);
                return reqBody;
            }else{
                return null;
            }
        }catch(Exception e){
            system.debug('exception:'+e.getLineNumber()+' '+e.getMessage());
            return null;
        }
    }
    
    // Added by Rajat for Key Account for WCGT Sync
    public static Api_Logger__c syncKeyAccount(ID keyAccountId, String flag){
        Api_Logger__c apiLog = new Api_Logger__c();
        try{
            if(keyAccountId != null && String.isNotBlank(flag)){
                Http http = new Http();
                HttpRequest req = new HttpRequest();
                WCGTEndPoint__mdt metaRecord = WCGTEndPoint__mdt.getInstance('Key_Account_Insert');

                String token = SalesforceToWCGTAccess.getAuthenticationToken();
                String endpoint = metaRecord.URL__c + '?stoken=' + token;

                req.setEndpoint(endpoint);
                req.setMethod('POST');
            	req.setHeader('Authorization','Bearer '+token); 
                req.setHeader('Content-Type','application/json');
                List<Account> keyAcc = AccountService.getKeyAccount(new Set<Id>{keyAccountId});
                if(keyAcc != null && keyAcc.size() > 0){
                    // Get Request Wrapper from Helper Class
                    String reqBody = SalesforceToWCGTHelper.getKeyAccountReqWrp(keyAcc,flag);
                    req.setBody(reqBody);
                    System.debug('reqBody -->'+reqBody);
                    HttpResponse resp;
                    resp = http.send(req);
                    System.debug('resp -->'+resp);
                    apiLog = API_LoggerCommonUtility.createAPILogger(keyAccountId,reqBody,resp.getBody(),resp.getStatus(),'SalesforceToWCGT.syncKeyAccount',endpoint,resp.getStatusCode(),null,null);
                    return apiLog;
                }
            }
        }catch(Exception e){
            system.debug('Exception e:'+e.getLineNumber()+' '+e.getMessage());
        }
        return apiLog;
    }
    
    // Added by Rajat for Client Mapping for WCGT Sync
    public static String getClientReqWrp(List<Account> clientAcc,String Flag,String userID){
        //try{
            if(clientAcc != null && clientAcc.size() > 0){
                Set<String> wcgtValues = new Set<String>();
                Set<String> wcgtValues2 = new Set<String>();
                Map<String,String> mapTypeToId = new Map<String,String>();
                Map<String,String> mapWcgtValToId = new Map<String,String>();
                Id ClientRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Client').getRecordTypeId();
                for(Account  acc : clientAcc){
                    if(acc.Status__c != null){
                        mapTypeToId.put('Client Type',acc.Status__c);
                    }if(acc.Country_Corridor__c != null){
                        mapTypeToId.put('Country HQ',acc.Country_Corridor__c);
                    }
                    if(acc.Industry__c != null){
                        mapTypeToId.put('Industry',acc.Industry__c);
                    }if(acc.Corridor__c != null){
                        mapTypeToId.put('Corridor',acc.Corridor__c);
                    }
                    if(acc.SubIndustry__c != null){
                        String key = acc.Industry__c+'-'+acc.SubIndustry__c;
                        mapTypeToId.put('Sub Industry',key);
                    }if(acc.GT_Client_Group__r.Key_Account_360__r.Client_Category__c != null){
                        mapTypeToId.put('Category CX GX',acc.GT_Client_Group__r.Key_Account_360__r.Client_Category__c);
                    }if(acc.ClientAddress__CountryCode__s != null){
                        mapTypeToId.put('CountryId',acc.ClientAddress__CountryCode__s);
                    }if(acc.ClientAddress__StateCode__s != null){
                        mapTypeToId.put('StateId',acc.ClientAddress__StateCode__s);
                    }/*if(acc.Total_No_of_employees__c != null){
                        mapTypeToId.put('Tot Emp No',acc.Total_No_of_employees__c);
                    }if(acc.Total_Revenue__c != null){
                        mapTypeToId.put('Tot Revenue',String.valueOf(acc.Total_Revenue__c));
                    }*/
                }
                if(mapTypeToId.keySet().size() > 0){
                    mapWcgtValToId = WCGTMasterService.getWCGTIdByMap(mapTypeToId); 
                    system.debug('mapTypeToId:'+mapWcgtValToId);
                }
               
                ClientReqWrp clientReqWrp = new ClientReqWrp();
                //added by rakesh kumar for EA Login Changes
                clientReqWrp.sUpdatedUserId = clientAcc[0].Last_Modified_By_for_WCGT__r.USER_ID__c;
                List<String> teamRole = new List<String>{'Key Account – CSL','Key Account – Co-CSL','Young CSL'};
                clientReqWrp.sKeyAccountId    = clientAcc[0].GT_Client_Group__r.Key_Account_360__c != null && clientAcc[0].RecordTypeId == ClientRecTypeId ? String.ValueOf(clientAcc[0].GT_Client_Group__r.Key_Account_360__c) : '';
                clientReqWrp.sKam_NonKam      = clientAcc[0].GT_Client_Group__r.Key_Account_360__c != null && clientAcc[0].RecordTypeId == ClientRecTypeId ? '1' : '0';
                clientReqWrp.sClientSFID      = clientAcc[0].Id;
                clientReqWrp.sClientName      = clientAcc[0].Name;
                clientReqWrp.sClientGroupSFID = clientAcc[0].GT_Client_Group__c;
                clientReqWrp.sClientGroupName = clientAcc[0].GT_Client_Group__r.Name;
                clientReqWrp.sWebsite         = clientAcc[0].Website;
                clientReqWrp.sClientType      = clientAcc[0].Status__c != null && mapWcgtValToId.containsKey('Client Type') ? 
                                                mapWcgtValToId.get('Client Type') : '';
                clientReqWrp.sEntityType      = clientAcc[0].Entity_Type_Master__c != null ? clientAcc[0].Entity_Type_Master__r.WCGT_Id__c : '';
                clientReqWrp.sTotRevenue      = clientAcc[0].Total_Revenue__c != null ? 
                                                WCGTMasterService.getWCGTId(String.valueOf(clientAcc[0].Total_Revenue__c),'Tot Revenue') : '';
                clientReqWrp.sTotEmpNo        = clientAcc[0].Total_No_of_employees__c != null ? 
                                                WCGTMasterService.getWCGTId(clientAcc[0].Total_No_of_employees__c,'Tot Emp No') : '';
                //clientReqWrp.sRelOffice       = 'PS002673';
                clientReqWrp.sCountryHQ       = clientAcc[0].Country_Corridor__c != null && mapWcgtValToId.containsKey('Country HQ') ? 
                                                mapWcgtValToId.get('Country HQ') : '';
                //clientReqWrp.sCountryHQ       = 'PS001428';
                
                 clientReqWrp.sSector          = clientAcc[0].Industry__c != null && mapWcgtValToId.containsKey('Industry') ? mapWcgtValToId.get('Industry') : '';
                clientReqWrp.sCorridor        = clientAcc[0].Corridor__c != null && mapWcgtValToId.containsKey('Corridor') ? 
                                                mapWcgtValToId.get('Corridor') : 'PS007874';
                //clientReqWrp.sCorridor        = 'PS007874';
            
                clientReqWrp.sSubSector       = clientAcc[0].SubIndustry__c != null && mapWcgtValToId.containsKey('Sub Industry') ? mapWcgtValToId.get('Sub Industry') : '';
                //clientReqWrp.sSubSector       = 'SI000065';
                String category               = clientAcc[0].GT_Client_Group__r.Key_Account_360__r.Client_Category__c != null && 
                                                mapWcgtValToId.containsKey('Category CX GX') ? mapWcgtValToId.get('Category CX GX') : '';
                
                clientReqWrp.sCategory_CX_GX  = category != null && clientAcc[0].RecordTypeId == ClientRecTypeId ? category : '';
                clientReqWrp.sUserId          = Flag == 'Insert' ? clientAcc[0].Owner.User_ID__c : clientAcc[0].LastModifiedBy.User_ID__c;
                clientReqWrp.sFlag            = Flag == 'Insert' ? '1' : '2';
                clientReqWrp.sSharedPaidUpCapital = String.valueOf(clientAcc[0].ShareCapitalInCr__c);
                clientReqWrp.sPAN_No          = clientAcc[0].Pan_No__c != null ? clientAcc[0].Pan_No__c : '';
                /*String addrss1                = '';
                String addrss2                = '';
                if(clientAcc[0].ClientAddress__Street__s != null && clientAcc[0].ClientAddress__Street__s.contains(',')){
                    for(integer i = 0 ; i < clientAcc[0].ClientAddress__Street__s.split(',').size();i++){
                        if(i == 0){
                            addrss1 = clientAcc[0].ClientAddress__Street__s.split(',')[i];
                        }else if(i > 0){
                            addrss2 = addrss2 + ' ' + clientAcc[0].ClientAddress__Street__s.split(',')[i];
                        }
                    }
                }
                clientReqWrp.sClientAddress1  = addrss1;
                clientReqWrp.sClientAddress2  = addrss2;*/
                clientReqWrp.sClientStreet    = clientAcc[0].ClientAddress__Street__s;
                clientReqWrp.sClientCityId    = clientAcc[0].ClientAddress__City__s;
                clientReqWrp.sClientStateId   = clientAcc[0].ClientAddress__StateCode__s != null && 
                                                mapWcgtValToId.containsKey('StateId') ? mapWcgtValToId.get('StateId') : '';
                clientReqWrp.sClientPincode   = clientAcc[0].ClientAddress__PostalCode__s;
                clientReqWrp.sClientCountryId = clientAcc[0].ClientAddress__CountryCode__s != null && 
                                                mapWcgtValToId.containsKey('CountryId') ? mapWcgtValToId.get('CountryId') : '';
                clientReqWrp.sStatus          = '1';
                
                //clientReqWrp.sClientCountryId  = 'CO000001';
                if(clientAcc[0].AccountTeamMembers != null && clientAcc[0].AccountTeamMembers.size() > 0 && clientAcc[0].RecordTypeId == ClientRecTypeId){
                    for(AccountTeamMember clientT : clientAcc[0].AccountTeamMembers){
                        if(clientT.TeamMemberRole == 'Key Account – CSL'){
                            clientReqWrp.sCSLID = clientT.User.EMP_ID__c != Null ? clientT.User.EMP_ID__c : '';
                        }else if(clientT.TeamMemberRole == 'Key Account – Co-CSL'){
                            clientReqWrp.sCoCSLId = clientT.User.EMP_ID__c != Null ? clientT.User.EMP_ID__c : '';
                        }else if(clientT.TeamMemberRole == 'Young CSL'){
                            clientReqWrp.sYoungCSLId = clientT.User.EMP_ID__c != Null ? clientT.User.EMP_ID__c : '';
                        }
                    }
                }
                String reqBody = JSON.serialize(clientReqWrp);
                return reqBody;
            }else{
                return null;
            }
       /* }catch(Exception e){
           system.debug('exception:'+e.getLineNumber()+' '+e.getMessage());
           return null; 
        }*/
    }
    
    // Added by Rajat for Client Account for WCGT Sync
    public static List<Api_Logger__c> syncClientAccount(ID clientId,String Flag,String userID){
        List<Api_Logger__c> apiLoggerList = new List<Api_Logger__c>();
        Api_Logger__c clientApiLog = new Api_Logger__c();
        try{
            if(clientId != null && String.isNotBlank(Flag) && String.isNotBlank(userID)){
                Http http = new Http();
                HttpRequest req = new HttpRequest();
                SalesforceToWCGTAccess.TokenResponse tokenResp = SalesforceToWCGTAccess.getAuthentication(clientId);
                if(tokenResp.apiLog != null){
                    apiLoggerList.add(tokenResp.apiLog);
                }
                WCGTEndPoint__mdt metaRecord = WCGTEndPoint__mdt.getInstance('Client_Insert');
                String endpoint = metaRecord.URL__c + '?stoken=' + tokenResp.token;
                req.setEndpoint(endpoint);
                req.setMethod('POST');
                req.setHeader('Content-Type','application/json'); 
                List<Account> clientAcc = new List<Account>();
                clientAcc = AccountService.getClientAccount(new Set<Id>{clientId});
                system.debug('syncClientAccount:'+clientId);
                if(clientAcc != null && clientAcc.size() > 0){
                    // Get Request Wrapper from Helper Class
                    system.debug('clientAcc:'+clientAcc);
                    String reqBody = SalesforceToWCGTHelper.getClientReqWrp(clientAcc,Flag,userID);
                    req.setBody(reqBody);
                    System.debug('reqBody -->'+reqBody);
                    HttpResponse resp;
                    resp = http.send(req);
                    System.debug('resp -->'+resp);
                    System.debug('resp Body -->'+resp.getBody());
                    clientApiLog = API_LoggerCommonUtility.createAPILogger(clientId,reqBody,resp.getBody(),resp.getStatus(),'SalesforceToWCGT.syncClientAccount',endpoint,resp.getStatusCode(),null,null);
                    if(clientApiLog != null){
                        apiLoggerList.add(clientApiLog);
                    }
                }
            }
            if (!apiLoggerList.isEmpty()) {
                return apiLoggerList;
            } else {
                return null;
            }
        }catch(Exception e){
            system.debug('Exception e:'+e.getLineNumber()+' '+e.getMessage());
            ErrorLogCreater_cls.apexDebugLogger(e, 'salesforceToWCGTHelper' , 'syncClientAccount' , clientId );
            return null;
        }
        
        
    }
    
    // Added by Rajat for Name Change Request in WCGT
    public static String getChangeNameReqWrp(Id recId, String oldName, String newName){
        try{
            if(String.isNotBlank(recId) && String.isNotBlank(oldName) && String.isNotBlank(newName)){
                //added by rakesh for EA process
                Account acc = [Select Id, Last_Modified_By_for_WCGT__c, Last_Modified_By_for_WCGT__r.USER_ID__c From Account Where Id =:recId];
                ChangeNameReqWrp changeReqWrp = new ChangeNameReqWrp();
                changeReqWrp.sUpdatedUserId    = acc.Last_Modified_By_for_WCGT__r.USER_ID__c;
                changeReqWrp.SF_ID    = recId;
                changeReqWrp.sOldName = oldName;
                changeReqWrp.sNewName = newName;
                
                String reqBody = JSON.serialize(changeReqWrp);
                return reqBody;
            }else{
                return null;
            }
        } catch(Exception e){
            system.debug('exception:'+e.getLineNumber()+' '+e.getMessage());
            ErrorLogCreater_cls.apexDebugLogger(e, 'ErrorLog' , 'flowDebugLogger' , '' );
            return null;
        }
    }
    
    
    // Modified by Suraj Kumar on 05-09-2023
    
    public static String getClientContactRequestBody(Contact clientContact, String Flag){
        Map<String,String> mapTypeToId = new Map<String,String>();
        Map<String,String> mapWcgtValToId = new Map<String,String>();
        
        if(clientContact != null){
            Set<String> wcgtValues = new Set<String>();
            if(String.isNotBlank(clientContact.Client_Location__CountryCode__s)){
                System.debug('CountryId:' + clientContact.Client_Location__CountryCode__s);
                mapTypeToId.put('CountryId',clientContact.Client_Location__CountryCode__s);
            }if(String.isNotBlank(clientContact.Client_Location__StateCode__s)){
                System.debug('StateId:' + clientContact.Client_Location__StateCode__s);
                mapTypeToId.put('StateId',clientContact.Client_Location__StateCode__s);
            }
            if(mapTypeToId.keySet().size() > 0){
                mapWcgtValToId = WCGTMasterService.getWCGTIdByMap(mapTypeToId); 
                system.debug('mapTypeToId:'+mapWcgtValToId);
            }
        }
            
        ClientContactReqWrp clientContactWrapper = new ClientContactReqWrp();
        
        clientContactWrapper.sClientSFID  = clientContact.AccountId;
        clientContactWrapper.sContactSFID = clientContact.Id;
        clientContactWrapper.sMobileNo    = clientContact.MobilePhone != null ? clientContact.MobilePhone : '2233445566';
        clientContactWrapper.sDesign      = clientContact.Designation__c != null ? clientContact.Designation__c : 'Dummy CEO';
        clientContactWrapper.sContPerson  = clientContact.FirstName+' ' + clientContact.LastName;
        
        clientContactWrapper.sEmailId     = clientContact.Email != null ? clientContact.Email : 'Dummytest@gmail.com';
        clientContactWrapper.sStatus      = clientContact.Contact_status__c != null ? (clientContact.Contact_status__c == 'Active' ? '1' : '0') : '0';
        clientContactWrapper.sFlag        = Flag != null && Flag == 'Insert' ? '1' : '2';
        clientContactWrapper.sPrefix      = clientContact.Salutation != null ? clientContact.Salutation : 'Mr.';
        clientContactWrapper.sFirstName   = clientContact.FirstName != null ? clientContact.FirstName : 'DummyJoe';
        clientContactWrapper.sLastName    = clientContact.LastName != null ? clientContact.LastName : 'DummyRogan';
        clientContactWrapper.sMiddleName    = clientContact.MiddleName != null ? clientContact.MiddleName : '';
        
        clientContactWrapper.sRelOffc = clientContact.RelationshipOffice__r.Location_Id__c != null ? clientContact.RelationshipOffice__r.Location_Id__c : 'LC000021';
        //added by rakesh kumar for ea login functionality
        clientContactWrapper.sUpdatedUserId = clientContact.Last_Modified_By_for_WCGT__r.USER_ID__c;
        clientContactWrapper.sUserId      = Flag == 'Insert' ? clientContact.Owner.USER_ID__c : clientContact.LastModifiedBy.USER_ID__c;
        //clientContactWrapper.sStreet = clientContact.Client_Location__Street__s != null ? clientContact.Client_Location__Street__s : 'DummyNoida';
        clientContactWrapper.sWCGTContactId = clientContact.WCGTId__c != null ? clientContact.WCGTId__c : '';
        String addrss1                = '';
        String addrss2                = '';
        if(clientContact.Client_Location__Street__s != null && clientContact.Client_Location__Street__s.contains(',')){
            for(integer i = 0 ; i < clientContact.Client_Location__Street__s.split(',').size();i++){
                if(i == 0){
                    addrss1 = clientContact.Client_Location__Street__s.split(',')[i];
                }else if(i > 0){
                    addrss2 = addrss2 + ' ' + clientContact.Client_Location__Street__s.split(',')[i];
                }
            }
        }else{
            addrss1 = 'dummy';
            addrss2 = 'dummy';
        }
        clientContactWrapper.sAddress1  = addrss1;
        clientContactWrapper.sAddress2  = addrss2;
        clientContactWrapper.sStateId = clientContact.Client_Location__StateCode__s != null && mapWcgtValToId.containsKey('StateId') ? 
                                                mapWcgtValToId.get('StateId') : 'ST000472';                
        clientContactWrapper.sCityId = clientContact.Client_Location__City__s != null ? 
                                                clientContact.Client_Location__City__s : 'Delhi'; 
        clientContactWrapper.sPincode = clientContact.Client_Location__PostalCode__s != null ? 
                                                clientContact.Client_Location__PostalCode__s : '121002'; 
        clientContactWrapper.sCountryId = clientContact.Client_Location__CountryCode__s != null && mapWcgtValToId.containsKey('CountryId') ? 
                                                mapWcgtValToId.get('CountryId') : 'CO000001';
        
              
        
        String reqBody = JSON.serialize(clientContactWrapper);
        System.debug('reqBody from wrapper :' + reqBody);
        if(String.isNotBlank(reqBody)){
            return reqBody;
        }
        else{
            return null;
        }
    }

    public static String getContactTeamReqWrp(List<DepthOfRelationship__c> contactTeam){
        try{
            if(contactTeam != null && contactTeam.size() > 0){
                ContactTeamReqWrp clientConTeamWrp = new ContactTeamReqWrp();
                clientConTeamWrp.sContactWCGTID    = contactTeam[0].ClientContact__r.WCGTId__c;
                clientConTeamWrp.sEMPID            = contactTeam[0].GTRL__r.EMP_ID__c;
                clientConTeamWrp.sUserId           = contactTeam[0].GTRL__c;
                clientConTeamWrp.sStatus           = '1';
                
                String reqBody = JSON.serialize(clientConTeamWrp);
                return reqBody;
            }else{
                return null;
            }
        }catch(Exception e){
            system.debug('exception:'+e.getLineNumber()+' '+e.getMessage());
            return null;
        }
    }
    
    
    // Method to get Country / State Name from Code
    public static String getCountryNameByIsoCode(String isoCode,String fieldName,String objName){
        // fieldName values should be : 'State' OR 'Country'
        if(isoCode == null) return null;
        if(String.isNotBlanK(fieldName) && String.isNotBlanK(objName)){
            Schema.DescribeFieldResult fieldResult;
            if(objName == 'Account'){
                if(fieldName == 'Country'){
                    fieldResult = Account.Client_s_Headquarter__CountryCode__s.getDescribe();
                }else if(fieldName == 'State'){
                    fieldResult = Account.Client_s_Headquarter__StateCode__s.getDescribe();
                }
            }
            List<Schema.PicklistEntry> pickListValues = fieldResult.getPicklistValues();
            for( Schema.PicklistEntry pickListEntry : pickListValues) {
                if(pickListEntry.getValue().toLowerCase() == isoCode.toLowerCase()) {
                    return pickListEntry.getLabel();
                }
            }
        }
        return null;
    }
    //Start SFDC-[Phase-1]: code is added by Biplow sarkar | 03-04-2024
    /*
    // Added by Rajat on 05-11-2023
    public Static API_Logger__c syncBillToContactToWCGT(Bill_To_Contact__c clientContact, String Flag){
        //Start SFDC-[Phase-1]: code is added by Biplow sarkar | 03-04-2024
        
        try{
            WCGTEndPoint__mdt metaRecord = WCGTEndPoint__mdt.getInstance('Client_Contact_Insert');
            
            Http http = new Http();
            HttpRequest req = new HttpRequest();
            req.setEndpoint(metaRecord.URL__c);
            req.setMethod('POST');
            String token = SalesforceToWCGTAccess.getAuthenticationToken();
        	req.setHeader('Authorization','Bearer '+token); 
            req.setHeader('Content-Type','application/json');        
            
            // Get Request Wrapper from Helper Class
            String reqBody = getBillToContactRequestBody(clientContact, Flag);
            System.debug('reqBody -->' + reqBody);  
            req.setBody(reqBody);
            
            HttpResponse resp;
            resp = http.send(req);
            System.debug('resp -->'+resp);
            System.debug('resp -->'+resp.getBody());
            API_Logger__c apiLog = API_LoggerCommonUtility.createAPILogger(clientContact.Id,reqBody,resp.getBody(),resp.getStatus(),'SyncClientContactToWCGTHelper',metaRecord.URL__c,resp.getStatusCode());
            return apiLog;
        }
        catch(Exception e){
            System.debug('Error: ' + e.getMessage() + ' in line : ' + e.getLineNumber());
            return null;
        }

        //End SFDC-[Phase-1]: code is added by Biplow sarkar | 03-04-2024
        return null;
    }
    
    // Added by Rajat on 05-11-2023
    public static String getBillToContactRequestBody(Bill_To_Contact__c clientContact, String Flag){
        //Start SFDC-[Phase-1]: code is added by Biplow sarkar | 03-04-2024
        /*
        Map<String,String> mapTypeToId = new Map<String,String>();
        Map<String,String> mapWcgtValToId = new Map<String,String>();
        
        if(clientContact != null){
            Set<String> wcgtValues = new Set<String>(); 
            if(String.isNotBlank(clientContact.Contact_Address__CountryCode__s)){
                System.debug('CountryId:' + clientContact.Contact_Address__CountryCode__s);
                mapTypeToId.put('CountryId',clientContact.Contact_Address__CountryCode__s);
            }if(String.isNotBlank(clientContact.Contact_Address__StateCode__s)){
                System.debug('StateId:' + clientContact.Contact_Address__StateCode__s);
                mapTypeToId.put('StateId',clientContact.Contact_Address__StateCode__s);
            }
            if(mapTypeToId.keySet().size() > 0){
                //Un Comment
                mapWcgtValToId = WCGTMasterService.getWCGTIdByMap(mapTypeToId); 
                //system.debug('mapTypeToId:'+mapWcgtValToId);
            }
    
        }
        
        ClientContactReqWrp clientContactWrapper = new ClientContactReqWrp();
        
        clientContactWrapper.sClientSFID  = clientContact.Client__c;
        clientContactWrapper.sContactSFID = clientContact.Id;
        clientContactWrapper.sMobileNo    = clientContact.Mobile__c != null ? clientContact.Mobile__c : '2233445566';
        clientContactWrapper.sDesign      = clientContact.Designation__c != null ? clientContact.Designation__c : 'Dummy CEO';
        clientContactWrapper.sContPerson  = clientContact.FirstName__c+' ' + clientContact.LastName__c;
        
        clientContactWrapper.sEmailId     = clientContact.Email__c != null ? clientContact.Email__c : 'Dummytest@gmail.com';
        //clientContactWrapper.sStatus      = clientContact.Contact_status__c != null ? (clientContact.Contact_status__c == 'Active' ? '1' : '0') : '0';
        clientContactWrapper.sStatus  ='1';
        clientContactWrapper.sFlag        = Flag != null && Flag == 'Insert' ? '1' : '2';
        clientContactWrapper.sPrefix      = clientContact.Salutation__c != null ? clientContact.Salutation__c : 'Mr.';
        clientContactWrapper.sFirstName   = clientContact.FirstName__c != null ? clientContact.FirstName__c : 'DummyJoe';
        clientContactWrapper.sLastName    = clientContact.LastName__c != null ? clientContact.LastName__c : 'DummyRogan';
        clientContactWrapper.sRelOffc = clientContact.RelationshipOffice__r.Location_Id__c != null ? clientContact.RelationshipOffice__r.Location_Id__c : 'LC000021';
        
        clientContactWrapper.sUserId      = Flag == 'Insert' ? clientContact.CreatedBy.USER_ID__c : clientContact.LastModifiedBy.USER_ID__c;
        //clientContactWrapper.sStreet = clientContact.Client_Location__Street__s != null ? clientContact.Client_Location__Street__s : 'DummyNoida';
        clientContactWrapper.sWCGTContactId = clientContact.WCGT_Id__c != null ? clientContact.WCGT_Id__c : '';
        String addrss1                = '';
        String addrss2                = '';
        if(clientContact.Contact_Address__Street__s != null && clientContact.Contact_Address__Street__s.contains(',')){
            for(integer i = 0 ; i < clientContact.Contact_Address__Street__s.split(',').size();i++){
                if(i == 0){
                    addrss1 = clientContact.Contact_Address__Street__s.split(',')[i];
                }else if(i > 0){
                    addrss2 = addrss2 + ' ' + clientContact.Contact_Address__Street__s.split(',')[i];
                }
            }
        }else{
            addrss1 = 'dummy';
            addrss2 = 'dummy';
        }
        clientContactWrapper.sAddress1  = addrss1;
        clientContactWrapper.sAddress2  = addrss2;
        clientContactWrapper.sStateId = clientContact.Contact_Address__StateCode__s != null && mapWcgtValToId.containsKey('StateId') ? 
            mapWcgtValToId.get('StateId') : 'ST000472';                
        clientContactWrapper.sCityId = clientContact.Contact_Address__City__s != null ? 
            clientContact.Contact_Address__City__s : 'Delhi'; 
        clientContactWrapper.sPincode = clientContact.Contact_Address__PostalCode__s != null ? 
            clientContact.Contact_Address__PostalCode__s : '121002'; 
        clientContactWrapper.sCountryId = clientContact.Contact_Address__CountryCode__s != null && mapWcgtValToId.containsKey('CountryId') ? 
            mapWcgtValToId.get('CountryId') : 'CO000001';
        
        
        
        String reqBody = JSON.serialize(clientContactWrapper);
        System.debug('reqBody from wrapper :' + reqBody);
        if(String.isNotBlank(reqBody)){
            return reqBody;
        }
        else{
            return null;
        }
        //End SFDC-[Phase-1]: code is added by Biplow sarkar | 03-04-2024
        return null;
    }
    */
    //End SFDC-[Phase-1]: code is added by Biplow sarkar | 03-04-2024
    //Wrapper Classes
    public class GTClientGroupReqWrp{
        public String sKam_NonKam;
        public String sKeyAccountId;
        public String sClientGroupSFID;
        public String sCategory_CX_GX;
        public String sCSLID;
        public String sCoCSLId;
        
        public GTClientGroupReqWrp(){
            this.sKam_NonKam = '';
            this.sKeyAccountId = '';
            this.sClientGroupSFID = '';
            this.sCategory_CX_GX = '';
            this.sCSLID = '';
            this.sCoCSLId = '';
        }
    }
    public class ClientReqWrp{
        public String sKeyAccountId;
        public String sClientGroupSFID;
        public String sClientGroupName;
        public String sClientSFID;
        public String sClientName;
        public String sWebsite;
        public String sClientType;
        public String sEntityType;
        public String sTotRevenue;
        public String sTotEmpNo;
        //public String sRelOffice;
        public String sCountryHQ;
        public String sKam_NonKam;
        public String sSector;
        public String sCorridor;
        public String sSubSector;
        public String sCSLID;
        public String sCoCSLId;
        public String sYoungCSLId;
        public String sCategory_CX_GX;
        public String sUserId;
        public String sFlag;
        public String sSharedPaidUpCapital;
        public String sPAN_No;
        //public String sClientAddress1;
        //public String sClientAddress2;
        public String sClientStreet;
        public String sClientStateId;
        public String sClientCityId;
        public String sClientPincode;
        public String sClientCountryId;
        public String sStatus;
        //added by rakesh for EA process
        public String sUpdatedUserId;
        public ClientReqWrp(){
            this.sYoungCSLId = '';
            this.sCSLID = '';
            this.sCoCSLId = '';
        }
    }
    public class KeyAccountReqWrp{
        public String sKeyAccountId;
        public String sKeyAccountName;
        public String sFlag;
    }
    public class ChangeNameReqWrp{
        public String SF_ID;
        public String sOldName;
        public String sNewName;
        //added by rakesh for EA process
        public String sUpdatedUserId;
    }
    public class ClientContactReqWrp{
        public String sClientSFID;
        public String sContactSFID;
        public String sMobileNo;
        public String sContPerson;
        public String sDesign;
        public String sEmailId;
        public String sStatus;
        public String sFlag;
        public String sPrefix;
        public String sFirstName;
        public String sMiddleName;
        public String sLastName;
        public String sRelOffc;
        public String sUserId;
        //public String sStreet;
        public String sAddress1;
        public String sAddress2;
        public String sStateId;
        public String sCityId;
        public String sPincode;
        public String sCountryId;
        public String sWCGTContactId;
        //added by rakesh for EA process
        public String sUpdatedUserId;
    }
    public class ContactAddress{
        public String sStreet;
        public String sStateId;
        public String sCityId;
        public String sPincode;
        public String sCountryId;
    }
    public class ContactTeamReqWrp{
        public String sContactWCGTID;
        public String sEMPID;
        public String sUserId;
        public String sStatus;
    }
    public class Result {
        @InvocableVariable(label='Records for Output' )
        
        // The field to store the sObject type name.
        public String outputMember;
    }

    public class EnquirySyncRequestWrapper{
        public String sFirstName;
        public String sLastName;
        public String sNewClientId;
        public String sMobileNo;
        public String sUserId;
        public String sEmail;
        public String sCompanyName;
        // public String sStatus;   Commented according to new json structure received on 02-04-2024
        // public String sStatusReason;  Commented according to new json structure received on 02-04-2024
        public String sEnquiryType;
        public String sEnquiryDescription;
        public String sDesignation;
        public String sSECTOR;
        public String sEXPERTIES;
        public String sNextSteps;
        //added by Rakesh for EA Process
        public String sUpdatedUserId;
    }
}