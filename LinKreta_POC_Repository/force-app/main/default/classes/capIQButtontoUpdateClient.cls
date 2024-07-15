/* 
     Written By: Bhanwar Singh
     Created Date: 1/5/2023
     Last Modified By : Bhanwar Singh
     Last Modified Date : 04/11/2023
     Last Update:- Modifed the Financial Year Format from 2022 to 2022-23
     Description : This class is used to Update New Client Which are coming from Email , Web and ChatBot.
     Variable Used : - 
       searchString : - Company Name from LWC component Enrich From External Database. 
       companyName : - Company Name after Selection of Company
       companyId : - Company CAPIQ Id
       recordId : - New Client Record Id
*/
public class capIQButtontoUpdateClient
    {
        //This Class is Used For Searching Company Name From Enrich From External DataBase Button on Detail Page.
        //By Bhanwar
        @AuraEnabled
        public static List<String> ClientNewSearchByName(String searchString){
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setMethod('POST');
        CapIQ__mdt capIq = [SELECT Id, UserName__c, Password__c, EndPointURL__c  FROM CapIQ__mdt Limit 1];
        req.setEndpoint(capIq.EndPointURL__c);
        Blob headerValue = Blob.valueOf  (capIq.UserName__c + ':' + capIq.Password__c);
        //List<AggregateResult> a = [SELECT Count(Id) From lead Where Company =: searchString];
        String authorizationHeader = 'BASIC ' + EncodingUtil.base64Encode(headerValue);
        req.setHeader('Authorization',authorizationHeader);
        req.setHeader('Content-Type','application/json');
        List<String> listCompany= new List<String>();
        String reqBody = '{"inputRequests": [ {'+
    
            '"function":"GDSHE",' +
    
            '"mnemonic":"IQ_COMPANY_NAME_QUICK_MATCH",'+

            '"identifier" :"  '+ searchString +'",'
             +'"properties": {"startRank":"1","endRank":"5"}'+
                '}]}';
         req.setTimeout(30000);
         req.setBody(reqBody);
        HttpResponse resp;        
       
        // InputRequests respoApex=(InputRequests) System.JSON.deserialize(resp.getBody(), InputRequests.class);
        
         try{
             resp = http.send(req);
            clientNewIqWrapper respoApex=(clientNewIqWrapper) System.JSON.deserialize(resp.getBody(), clientNewIqWrapper.class);
            for(integer i=0;i<5;i++)
            {
                if(respoApex.GDSSDKResponse[0].Rows[i].Row[0] != 'Data Unavailable')
                {
                    String companyName12 = respoApex.GDSSDKResponse[0].Rows[i].Row[0];
                    listCompany.add(companyName12);
                }
            }
             
             API_Logger__c apiLog = API_LoggerCommonUtility.createAPILogger(null,reqBody,resp.getBody(),resp.getStatus(),'capIQButtontoUpdateClient',capIq.EndPointURL__c,resp.getStatusCode());                  
            	System.debug('apiLog-->'+apiLog);
             insert apiLog; 
        }
        catch(Exception e){
            ErrorLogCreater_cls.apexDebugLoggerForAPICallout(e, 'capIQButtontoUpdateClient' , 'ClientNewSearchByName' , '' , reqBody,resp.getBody(), capIq.EndPointURL__c );
            
        }
         
       System.debug(listCompany);
        return listCompany;

   }
        //This Class is Used For Updating in Account by Enrich From External DataBase Button
        //By Bhanwar
        @AuraEnabled
        public static Boolean sendCapIQIdtoMap(Id recordId)
        {
            System.debug('Running Client');
            Http http = new Http();
            HttpRequest req = new HttpRequest();
            req.setMethod('POST');
            CapIQ__mdt capIq = [SELECT Id, UserName__c, Password__c, EndPointURL__c  FROM CapIQ__mdt Limit 1];
            req.setEndpoint(capIq.EndPointURL__c);
            Blob headerValue = Blob.valueOf  (capIq.UserName__c + ':' + capIq.Password__c);
            
            String authorizationHeader = 'BASIC ' + EncodingUtil.base64Encode(headerValue);
            req.setHeader('Authorization',authorizationHeader);
            req.setHeader('Content-Type','application/json');
            Account acc = [SELECT Id, Name , capIQId__c From Account Where Id =: recordId Limit 1];
            String companyID = acc.capIQId__c;
            Boolean result;
            if(companyID == NULL)
            {
                Map <String,String> compNameList = newClientByCompanyNameIQ.ClientNewSearchByName(acc.Name);
                //System.debug('compNameList ===>' + compNameList);
                //companyID = newClientByCompanyNameIQ.ClientNewSearchId(compNameList[0]);
                System.debug('companyID ===>' + companyID);
                acc.capIQId__c = companyID;
            }
            
            String reqBody = '{"inputRequests":[{"function":"GDSP","mnemonic":"PARENT_NAME","identifier":"'+companyID+'","startDate":"01/01/202"},'+
                '{"function":"GDSP","mnemonic":"IQ_COMPANY_TICKER","identifier":"' +companyID+'"},' +
                '{"function":"GDSP","mnemonic":"IQ_PRIMARY_SIC_INDUSTRY","identifier":"'+companyID+'"},'+
                '{"function":"GDSP","mnemonic":"IQ_CEO_NAME","identifier":"'+companyID+'"},'+
                '{"function":"GDSP","mnemonic":"IQ_ULT_PARENT","identifier":"'+companyID+'"},'+
                '{"function":"GDSP","mnemonic":"IQ_COMPANY_TYPE","identifier":"'+companyID+'"},'+
                '{"function":"GDSP","mnemonic":"IQ_PRESIDENT_NAME","identifier":"'+companyID+'"},'+
                '{"function":"GDSP","mnemonic":"IQ_SHORT_BUSINESS_DESCRIPTION","identifier":"'+companyID+'"},'+
                '{"function":"GDSP","mnemonic":"IQ_PRIMARY_SIC_CODE","identifier":"'+companyID+'"},'+
                '{"function":"GDSP","mnemonic":"IQ_EXCHANGE","identifier":"'+companyID+'"},'+
                '{"function":"GDSP","mnemonic":"IQ_COO_NAME","identifier":"'+companyID+'"},'+
                '{"function":"GDSP","mnemonic":"IQ_CFO_NAME","identifier":"'+companyID+'"},'+
                '{"function":"GDSP","mnemonic":"IQ_COMPANY_STREET2","identifier":"'+companyID+'"},'+
                '{"function":"GDSP","mnemonic":"IQ_CITY","identifier":"'+companyID+'"},'+
                '{"function":"GDSP","mnemonic":"IQ_COUNTRY_NAME","identifier":"'+companyID+'"},'+
                '{"function":"GDSP","mnemonic":"IQ_EMPLOYEES","identifier":"'+companyID+'"},'+
                '{"function":"GDSP","mnemonic":"IQ_COMPANY_WEBSITE","identifier":"'+companyID+'"},'+
                '{"function":"GDSP","mnemonic":"IQ_DESCRIPTION_LONG","identifier":"'+companyID+'"},'+
                '{"function":"GDSP","mnemonic":"IQ_YEAR_FOUNDED","identifier":"'+companyID+'"},'+
                '{"function":"GDSHE","mnemonic":"IQ_COMPETITOR_ALL","identifier":"'+companyID+'","properties": {"startRank":"1","endRank":"5"}},'+
                '{"function":"GDSP","mnemonic":"IQ_CHAIRMAN_NAME","identifier":"'+companyID+'"},'+
                '{"function":"GDSP","mnemonic":"IQ_COUNTRY_OF_INC","identifier":"'+companyID+'"},'+
                '{"function":"GDSP","mnemonic":"IQ_COMPANY_PHONE","identifier":"'+companyID+'"},'+
                '{"function":"GDSP","mnemonic":"IQ_ULT_PARENT_CIQID","identifier":"'+companyID+'"},'+
                '{"function":"GDSP","mnemonic":"IQ_COMPANY_NAME","identifier":"'+companyID+'"},'+
                '{"function":"GDSP","mnemonic":"IQ_COMPANY_ADDRESS","identifier":"'+companyID+'"},'+
                '{"function":"GDSP","mnemonic":"IQ_COMPANY_ZIP","identifier":"'+companyID+'"},'+
                '{"function":"GDSP","mnemonic":"IQ_STATE","identifier":"'+companyID+'"},'+
                '{"function":"GDSP","mnemonic":"IQ_COMPANY_STREET1","identifier":"'+companyID+'"},'+
                '{"function":"GDSP","mnemonic":"IQ_COMPANY_WEBSITE","identifier":"'+companyID+'"},'+
                '{"function":"GDSP","mnemonic":"DOM_ULTIMATE_PARENT_NAME","identifier":"'+companyID+'"},'+
                '{"function":"GDSHE","mnemonic":"IQ_INVESTORS_ALL","identifier":"'+companyID+'","properties": {"startRank":"1","endRank":"5"}},'+
                '{"function":"GDSP","mnemonic":"IQ_PROFESSIONAL_DIRECT_PHONE","identifier":"'+companyID+'"},'+
                '{"function":"GDSHE","mnemonic":"IQ_BOARD_MEMBER","identifier":"'+companyID+'","properties": {"startRank":"1","endRank":"5"}},'+
                '{"function":"GDSHE","mnemonic":"IQ_BOARD_MEMBER_TITLE","identifier":"'+companyID+'","properties": {"startRank":"1","endRank":"5"}},'+
                '{"function":"GDSHE","mnemonic":"IQ_PROFESSIONAL","identifier":"'+companyID+'","properties": {"startRank":"1","endRank":"5"}},'+
                '{"function":"GDSHE","mnemonic":"IQ_PROFESSIONAL_MAIN_PHONE","identifier":"'+companyID+'","properties": {"startRank":"1","endRank":"5"}},'+
                '{"function":"GDSHE","mnemonic":"IQ_PROFESSIONAL_EMAIL","identifier":"'+companyID+'","properties": { "startRank":"1","endRank":"5"}},'+
                '{"function":"GDSHE","mnemonic":"IQ_PROFESSIONAL_TITLE","identifier":"'+companyID+'","properties": {"startRank":"1","endRank":"5"}},'+
                '{"function":"GDSP","mnemonic":"IQ_EBIT","identifier":"'+companyID+'"},'+
                '{"function":"GDSP","mnemonic":"IQ_TOTAL_EQUITY","identifier":"'+companyID+'"},'+
                '{"function":"GDSP","mnemonic":"IQ_REV","identifier":"'+companyID+'","properties" : {"periodType" : "FY2022"}},'+
                '{"function":"GDSP","mnemonic":"IQ_TOTAL_ASSETS","identifier":"'+companyID+'"},'+
                '{"function":"GDSP","mnemonic":"IQ_EBITDA","identifier":"'+companyID+'"},'+
                '{"function":"GDSP","mnemonic":"IQ_NI","identifier":"'+companyID+'"},'+
                '{"function":"GDSP","mnemonic":"IQ_GP","identifier":"'+companyID+'"},'+
                '{"function":"GDSP","mnemonic":"IQ_TOTAL_CL","identifier":"'+companyID+'"},'+
                '{"function":"GDSP","mnemonic":"IQ_TOTAL_CA","identifier":"'+companyID+'"},'+
                '{"function":"GDSP","mnemonic":"IQ_TOTAL_LIAB","identifier":"'+companyID+'"},'+
                '{"function":"GDSP","mnemonic":"IQ_TOTAL_REV","identifier":"'+companyID+'"},'+
                '{"function":"GDSP","mnemonic":"IQ_TOTAL_DEBT","identifier":"'+companyID+'"},'+
                '{"function":"GDSP","mnemonic":"IQ_HOLDER_NAME","identifier":"'+companyID+'","properties" : {"asOfDate" : "01/01/2022", "startRank" : "1","endRank" : "5", "currencyId" : "EUR", "currencyConversionModeId" : "Historical"} },'+
                '{"function":"GDSP","mnemonic":"IQ_HOLDER_PERCENT","identifier":"'+companyID+'","properties" : {"asOfDate" : "01/01/2022", "startRank" : "1","endRank" : "5", "currencyId" : "EUR", "currencyConversionModeId" : "Historical"}},'+
                '{"function":"GDSP","mnemonic":"IQ_ISIN","identifier":"'+companyID+'"},'+
                '{"function":"GDSP","mnemonic":"IQ_KEY_DEV_ID","identifier":"'+companyID+'","properties": {"startDate":"01/01/2022","endDate":"09/09/2022","keyDevFilter" : "C2,T36"}},'+
                ']}';
            
            
            req.setBody(reqBody);
           
            HttpResponse resp = http.send(req); 
            clientNewIqWrapper respoApex=(clientNewIqWrapper) System.JSON.deserialize(resp.getBody(), clientNewIqWrapper.class);
            System.debug(respoApex.GDSSDKResponse[0]); 
            try{
                String companyTickter=respoApex.GDSSDKResponse[1].Rows[0].Row[0]; 
                String primarySIC=respoApex.GDSSDKResponse[2].Rows[0].Row[0]; 
                String ceoName=respoApex.GDSSDKResponse[3].Rows[0].Row[0];
                String iqULTParent=respoApex.GDSSDKResponse[4].Rows[0].Row[0];
                String companyType=respoApex.GDSSDKResponse[5].Rows[0].Row[0];
                String presidentName=respoApex.GDSSDKResponse[6].Rows[0].Row[0];
                String shortDescription=respoApex.GDSSDKResponse[7].Rows[0].Row[0];
                String primarySICCode=respoApex.GDSSDKResponse[8].Rows[0].Row[0];
                String exchange=respoApex.GDSSDKResponse[9].Rows[0].Row[0];
                String cooName=respoApex.GDSSDKResponse[10].Rows[0].Row[0];
                String cfoName=respoApex.GDSSDKResponse[11].Rows[0].Row[0];
                String companyStreet=respoApex.GDSSDKResponse[12].Rows[0].Row[0];
                String city=respoApex.GDSSDKResponse[13].Rows[0].Row[0];
                String countryName=respoApex.GDSSDKResponse[14].Rows[0].Row[0];
                String employees=respoApex.GDSSDKResponse[15].Rows[0].Row[0];
                String companyWebsite=respoApex.GDSSDKResponse[16].Rows[0].Row[0];
                String longDescription=respoApex.GDSSDKResponse[17].Rows[0].Row[0];
                String yearFounded=respoApex.GDSSDKResponse[18].Rows[0].Row[0];
                //    String competeterAll=respoApex.GDSSDKResponse[19].Rows[0].Row[0] + ' , ' + respoApex.GDSSDKResponse[19].Rows[1].Row[0] +' , ' + respoApex.GDSSDKResponse[19].Rows[2].Row[0] + ' , ' + respoApex.GDSSDKResponse[19].Rows[3].Row[0] + ' , '+respoApex.GDSSDKResponse[19].Rows[4].Row[0];
                String chairmanName = respoApex.GDSSDKResponse[20].Rows[0].Row[0];
                String countryINC = respoApex.GDSSDKResponse[21].Rows[0].Row[0];
                String companyPhone = respoApex.GDSSDKResponse[22].Rows[0].Row[0];
                String ultParentCAPIQ = respoApex.GDSSDKResponse[23].Rows[0].Row[0];
                String companyName = respoApex.GDSSDKResponse[24].Rows[0].Row[0];
                String companyAddress = respoApex.GDSSDKResponse[25].Rows[0].Row[0];
                String companyZIP = respoApex.GDSSDKResponse[26].Rows[0].Row[0];
                String state = respoApex.GDSSDKResponse[27].Rows[0].Row[0];
                String companyStreet1 = respoApex.GDSSDKResponse[28].Rows[0].Row[0];
                //String companyWebsite = respoApex.GDSSDKResponse[29].Rows[0].Row[0];
                //System.debug(respoApex.GDSSDKResponse[30].Rows[0].Row[0]);
                //   String investorsAll = respoApex.GDSSDKResponse[31].Rows[0].Row[0]+ ' , ' + respoApex.GDSSDKResponse[31].Rows[1].Row[0] +' , ' + respoApex.GDSSDKResponse[31].Rows[2].Row[0] + ' , ' + respoApex.GDSSDKResponse[31].Rows[3].Row[0] + ' , '+respoApex.GDSSDKResponse[31].Rows[4].Row[0];
                String professionalPhone = respoApex.GDSSDKResponse[32].Rows[0].Row[0];
                
                /*String iqProfessional = respoApex.GDSSDKResponse[35].Rows[0].Row[0]+ ' , ' + respoApex.GDSSDKResponse[35].Rows[1].Row[0] +' , ' + respoApex.GDSSDKResponse[35].Rows[2].Row[0] + ' , ' + respoApex.GDSSDKResponse[35].Rows[3].Row[0] + ' , '+respoApex.GDSSDKResponse[35].Rows[4].Row[0];
    String iqProfesiionalPhone = respoApex.GDSSDKResponse[36].Rows[0].Row[0]+ ' , ' + respoApex.GDSSDKResponse[36].Rows[1].Row[0] +' , ' + respoApex.GDSSDKResponse[36].Rows[2].Row[0] + ' , ' + respoApex.GDSSDKResponse[36].Rows[3].Row[0] + ' , '+respoApex.GDSSDKResponse[36].Rows[4].Row[0];
    String iqProfessionalEmail = respoApex.GDSSDKResponse[37].Rows[0].Row[0]+ ' , ' + respoApex.GDSSDKResponse[37].Rows[1].Row[0] +' , ' + respoApex.GDSSDKResponse[37].Rows[2].Row[0] + ' , ' + respoApex.GDSSDKResponse[37].Rows[3].Row[0] + ' , '+respoApex.GDSSDKResponse[37].Rows[4].Row[0];
    String iqProfessionalTitle = respoApex.GDSSDKResponse[38].Rows[0].Row[0]+ ' , ' + respoApex.GDSSDKResponse[38].Rows[1].Row[0] +' , ' + respoApex.GDSSDKResponse[38].Rows[2].Row[0] + ' , ' + respoApex.GDSSDKResponse[38].Rows[3].Row[0] + ' , '+respoApex.GDSSDKResponse[38].Rows[4].Row[0];
    */     String ebit = respoApex.GDSSDKResponse[39].Rows[0].Row[0];
                String totalEquity = respoApex.GDSSDKResponse[40].Rows[0].Row[0];
                String iqRev = respoApex.GDSSDKResponse[41].Rows[0].Row[0];
                String totalAssets = respoApex.GDSSDKResponse[42].Rows[0].Row[0];
                String ebitda = respoApex.GDSSDKResponse[43].Rows[0].Row[0];
                String ni = respoApex.GDSSDKResponse[44].Rows[0].Row[0];
                String gp = respoApex.GDSSDKResponse[45].Rows[0].Row[0];
                String totalCL = respoApex.GDSSDKResponse[46].Rows[0].Row[0];
                String totalCA = respoApex.GDSSDKResponse[47].Rows[0].Row[0];
                String totalLiab = respoApex.GDSSDKResponse[48].Rows[0].Row[0];
                String totalRev = respoApex.GDSSDKResponse[49].Rows[0].Row[0];
                String totalDebt = respoApex.GDSSDKResponse[50].Rows[0].Row[0];
                //String holderName  = respoApex.GDSSDKResponse[51].Rows[0].Row[0]+ ' , ' + respoApex.GDSSDKResponse[51].Rows[1].Row[0] +' , ' + respoApex.GDSSDKResponse[51].Rows[2].Row[0] + ' , ' + respoApex.GDSSDKResponse[51].Rows[3].Row[0] + ' , '+respoApex.GDSSDKResponse[51].Rows[4].Row[0];
                String iqISIN /*= respoApex.GDSSDKResponse[52].Rows[0].Row[0]*/;
                String keyDevId = respoApex.GDSSDKResponse[53].Rows[0].Row[0];
                acc.Total_Assets__c = Decimal.valueOf(totalAssets);
                acc.Total_Current_Assets__c = Decimal.valueOf(totalCA);
                acc.Total_Current_Liabilities__c = Decimal.valueOf(totalCL);
                acc.Total_Debt__c = Decimal.valueOf(totalDebt);
                acc.Total_Equity__c = Decimal.valueOf(totalEquity);
                acc.Total_Liabilities__c = Decimal.valueOf(totalLiab);
                acc.Total_No_of_employees__c = employees;
                acc.Total_Revenue__c = Decimal.ValueOf(totalRev);
                acc.Earnings_Before_Interest_and_Taxes_EBIT__c = decimal.valueOf(ebit);
                acc.EBITDA__c = Decimal.valueOf(ebitda);
                acc.Ticker_Symbol__c = companyTickter;
                //acc.Industry__c = primarySIC;
                //acc.CEO_Name__c = ceoName;
                acc.Global_Ultimate_Owner__c = iqULTParent;
                acc.Public_Private_Company__c = companyType;
                acc.Business_Short_Description__c = shortDescription;
                acc.Stock_Exchange_symbol__c= exchange;
                acc.Company_Website__c = companyWebsite;
                acc.Company_Overview__c = longDescription;
                acc.Year_Founded__c = yearFounded;
                //acc.Chairman_Name__c = chairmanName;
                acc.Country_of_Incorporation__c = countryINC;
               // acc.Revenue__c = iqRev;
                
                update acc;
                System.debug(acc);
                result= true;
                API_Logger__c apiLog = API_LoggerCommonUtility.createAPILogger(null,reqBody,resp.getBody(),resp.getStatus(),'capIQButtontoUpdateClient',capIq.EndPointURL__c,resp.getStatusCode());                  
                insert apiLog;
                System.debug('apiLog-->'+apiLog);
            }
            catch(Exception e)
            {
                result = false;
            }
            return result;
            
        }
        
        
        //This Class is Used For Updating in Lead by Enrich From External DataBase Button
        //By Bhanwar 13/03/2023
        @AuraEnabled
        public static Boolean sendCapIQIdtoNewClient(Id recordId , String capIqId)
        {
            Lead lead = [SELECT Name,Company,capIQId__c, Currency_Format__c From Lead Where Id = :recordId Limit 1];
            String companyID=capIqId;
            System.debug('Client ---->'+lead.Company);
            lead.capIQId__c = capIqId;
            
           /* Http http = new Http();
            HttpRequest req = new HttpRequest();
            req.setMethod('POST');
            CapIQ__mdt capIq = [SELECT Id, UserName__c,NumberofBoardMember__c , Password__c, EndPointURL__c  FROM CapIQ__mdt Limit 1];
            capIq.NumberofBoardMember__c = Integer.ValueOf(capIq.NumberofBoardMember__c);
            req.setEndpoint(capIq.EndPointURL__c);
            Blob headerValue = Blob.valueOf  (capIq.UserName__c + ':' + capIq.Password__c);
            String authorizationHeader = 'BASIC ' + EncodingUtil.base64Encode(headerValue);
            req.setHeader('Authorization',authorizationHeader);
            req.setHeader('Content-Type','application/json');
            
            //System.debug('companyID ===>' + leads );
            String reqBody = '{"inputRequests":[{"function":"GDSP","mnemonic":"PARENT_NAME","identifier":"'+companyID+'","startDate":"01/01/202"},'+
                '{"function":"GDSP","mnemonic":"IQ_COMPANY_TICKER","identifier":"' +companyID+'"},' +
                '{"function":"GDSP","mnemonic":"IQ_PRIMARY_SIC_INDUSTRY","identifier":"'+companyID+'"},'+
                '{"function":"GDSP","mnemonic":"IQ_CEO_NAME","identifier":"'+companyID+'"},'+
                '{"function":"GDSP","mnemonic":"IQ_ULT_PARENT","identifier":"'+companyID+'"},'+
                '{"function":"GDSP","mnemonic":"IQ_COMPANY_TYPE","identifier":"'+companyID+'"},'+
                '{"function":"GDSP","mnemonic":"IQ_PRESIDENT_NAME","identifier":"'+companyID+'"},'+
                '{"function":"GDSP","mnemonic":"IQ_SHORT_BUSINESS_DESCRIPTION","identifier":"'+companyID+'"},'+
                '{"function":"GDSP","mnemonic":"IQ_PRIMARY_SIC_CODE","identifier":"'+companyID+'"},'+
                '{"function":"GDSP","mnemonic":"IQ_EXCHANGE","identifier":"'+companyID+'"},'+
                '{"function":"GDSP","mnemonic":"IQ_COO_NAME","identifier":"'+companyID+'"},'+
                '{"function":"GDSP","mnemonic":"IQ_CFO_NAME","identifier":"'+companyID+'"},'+
                '{"function":"GDSP","mnemonic":"IQ_COMPANY_STREET2","identifier":"'+companyID+'"},'+
                '{"function":"GDSP","mnemonic":"IQ_CITY","identifier":"'+companyID+'"},'+
                '{"function":"GDSP","mnemonic":"IQ_COUNTRY_NAME","identifier":"'+companyID+'"},'+
                '{"function":"GDSP","mnemonic":"IQ_EMPLOYEES","identifier":"'+companyID+'"},'+
                '{"function":"GDSP","mnemonic":"IQ_COMPANY_WEBSITE","identifier":"'+companyID+'"},'+
                '{"function":"GDSP","mnemonic":"IQ_DESCRIPTION_LONG","identifier":"'+companyID+'"},'+
                '{"function":"GDSP","mnemonic":"IQ_YEAR_FOUNDED","identifier":"'+companyID+'"},'+
                '{"function":"GDSHE","mnemonic":"IQ_COMPETITOR_ALL","identifier":"'+companyID+'","properties": {"startRank":"1","endRank":"5"}},'+
                '{"function":"GDSP","mnemonic":"IQ_CHAIRMAN_NAME","identifier":"'+companyID+'"},'+
                '{"function":"GDSP","mnemonic":"IQ_COUNTRY_OF_INC","identifier":"'+companyID+'"},'+
                '{"function":"GDSP","mnemonic":"IQ_COMPANY_PHONE","identifier":"'+companyID+'"},'+
                '{"function":"GDSP","mnemonic":"IQ_ULT_PARENT_CIQID","identifier":"'+companyID+'"},'+
                '{"function":"GDSP","mnemonic":"IQ_COMPANY_NAME","identifier":"'+companyID+'"},'+
                '{"function":"GDSP","mnemonic":"IQ_COMPANY_ADDRESS","identifier":"'+companyID+'"},'+
                '{"function":"GDSP","mnemonic":"IQ_COMPANY_ZIP","identifier":"'+companyID+'"},'+
                '{"function":"GDSP","mnemonic":"IQ_STATE","identifier":"'+companyID+'"},'+
                '{"function":"GDSP","mnemonic":"IQ_COMPANY_STREET1","identifier":"'+companyID+'"},'+
                '{"function":"GDSP","mnemonic":"IQ_COMPANY_WEBSITE","identifier":"'+companyID+'"},'+
                '{"function":"GDSP","mnemonic":"DOM_ULTIMATE_PARENT_NAME","identifier":"'+companyID+'"},'+
                '{"function":"GDSHE","mnemonic":"IQ_INVESTORS_ALL","identifier":"'+companyID+'","properties": {"startRank":"1","endRank":"5"}},'+
                '{"function":"GDSP","mnemonic":"IQ_PROFESSIONAL_DIRECT_PHONE","identifier":"'+companyID+'"},'+
                '{"function":"GDSHE","mnemonic":"IQ_BOARD_MEMBER","identifier":"'+companyID+'","properties": {"startRank":"1","endRank":"'+capIq.NumberofBoardMember__c +'"}},'+
                '{"function":"GDSHE","mnemonic":"IQ_BOARD_MEMBER_TITLE","identifier":"'+companyID+'","properties": {"startRank":"1","endRank":"'+capIq.NumberofBoardMember__c +'"}},'+
                '{"function":"GDSHE","mnemonic":"IQ_PROFESSIONAL","identifier":"'+companyID+'","properties": {"startRank":"1","endRank":"5"}},'+
                '{"function":"GDSHE","mnemonic":"IQ_PROFESSIONAL_MAIN_PHONE","identifier":"'+companyID+'","properties": {"startRank":"1","endRank":"5"}},'+
                '{"function":"GDSHE","mnemonic":"IQ_PROFESSIONAL_EMAIL","identifier":"'+companyID+'","properties": { "startRank":"1","endRank":"5"}},'+
                '{"function":"GDSHE","mnemonic":"IQ_PROFESSIONAL_TITLE","identifier":"'+companyID+'","properties": {"startRank":"1","endRank":"5"}},'+
                '{"function":"GDSP","mnemonic":"IQ_EBIT","identifier":"'+companyID+'","properties" : {"periodType" : "IQ_FY","currencyId" : "INR"}},'+
                '{"function":"GDSP","mnemonic":"IQ_TOTAL_EQUITY","identifier":"'+companyID+'","properties" : {"periodType" : "IQ_FY","currencyId" : "INR"}},'+
                '{"function":"GDSP","mnemonic":"IQ_REV","identifier":"'+companyID+'","properties" : {"periodType" : "IQ_FY","currencyId" : "INR"}},'+
                '{"function":"GDSP","mnemonic":"IQ_TOTAL_ASSETS","identifier":"'+companyID+'","properties" : {"periodType" : "IQ_FY","currencyId" : "INR"}},'+
                '{"function":"GDSP","mnemonic":"IQ_EBITDA","identifier":"'+companyID+'","properties" : {"periodType" : "IQ_FY","currencyId" : "INR"}},'+
                '{"function":"GDSP","mnemonic":"IQ_NI","identifier":"'+companyID+'","properties" : {"periodType" : "IQ_FY","currencyId" : "INR"}},'+
                '{"function":"GDSP","mnemonic":"IQ_GP","identifier":"'+companyID+'","properties" : {"periodType" : "IQ_FY","currencyId" : "INR"}},'+
                '{"function":"GDSP","mnemonic":"IQ_TOTAL_CL","identifier":"'+companyID+'","properties" : {"periodType" : "IQ_FY","currencyId" : "INR"}},'+
                '{"function":"GDSP","mnemonic":"IQ_TOTAL_CA","identifier":"'+companyID+'","properties" : {"periodType" : "IQ_FY","currencyId" : "INR"}},'+
                '{"function":"GDSP","mnemonic":"IQ_TOTAL_LIAB","identifier":"'+companyID+'","properties" : {"periodType" : "IQ_FY","currencyId" : "INR"}},'+
                '{"function":"GDSP","mnemonic":"IQ_TOTAL_REV","identifier":"'+companyID+'","properties" : {"periodType" : "IQ_FY","currencyId" : "INR"}},'+
                '{"function":"GDSP","mnemonic":"IQ_TOTAL_DEBT","identifier":"'+companyID+'","properties" : {"periodType" : "IQ_FY","currencyId" : "INR"}},'+
                '{"function":"GDSP","mnemonic":"IQ_HOLDER_NAME","identifier":"'+companyID+'","properties" : {"asOfDate" : "01/01/2022", "startRank" : "1","endRank" : "5", "currencyId" : "EUR", "currencyConversionModeId" : "Historical"} },'+
                '{"function":"GDSP","mnemonic":"IQ_HOLDER_PERCENT","identifier":"'+companyID+'","properties" : {"asOfDate" : "01/01/2022", "startRank" : "1","endRank" : "5", "currencyId" : "EUR", "currencyConversionModeId" : "Historical"}},'+
                '{"function":"GDSP","mnemonic":"IQ_ISIN","identifier":"'+companyID+'"},'+
                '{"function":"GDSP","mnemonic":"IQ_KEY_DEV_ID","identifier":"'+companyID+'","properties": {"startDate":"01/01/2022","endDate":"09/09/2022","keyDevFilter" : "C2,T36"}},'+
                '{"function":"GDSP","mnemonic":"IQ_PERIODDATE_IS","identifier":"'+companyID+'", "properties": { "periodType": "IQ_FY" }},'+
                '{"function":"GDSHE","mnemonic":"IQ_IMM_PARENT","identifier":"'+companyID+'","properties": {"startRank":"1","endRank":"5"}},'+
                '{"function":"GDSHE","mnemonic":"IQ_IMM_PARENT_CIQID","identifier":"'+companyID+'","properties": {"startRank":"1","endRank":"5"}},'+
                '{"function":"GDSP","mnemonic":"IQ_ULT_PARENT_CIQID","identifier":"'+companyID+'"},'+']}';
    
            
            
            req.setBody(reqBody);
            HttpResponse resp;
            try{
                resp = http.send(req); 
            }
            catch(Exception e){
                ErrorLogCreater_cls.apexDebugLoggerForAPICallout(e, 'capIQButtontoUpdateClient' , 'sendCapIQIdtoNewClient' , '' , reqBody,resp.getBody(), capIq.EndPointURL__c );
            }*/
            //added by Deepak joshi
            HttpResponse resp = callOut(companyID);
            System.debug('response--'+resp);
            System.debug('response.getBody()--'+resp.getBody());
            
            clientNewIqWrapper respoApex=(clientNewIqWrapper) System.JSON.deserialize(resp.getBody(), clientNewIqWrapper.class);
            try{
                System.debug(respoApex.GDSSDKResponse[1].Rows[0].Row[0]); 
                if(respoApex.GDSSDKResponse[1].Rows[0].Row[0] !='Data Unavailable')
                {
                    lead.Ticker_Symbol__c = respoApex.GDSSDKResponse[1].Rows[0].Row[0]; 
                }
                else{
                    lead.Ticker_Symbol__c= '';
                }
                if(respoApex.GDSSDKResponse[2].Rows[0].Row[0]  !='Data Unavailable'){
                    lead.Industry_CAP_IQ_MCA__c=respoApex.GDSSDKResponse[2].Rows[0].Row[0]; 
                }
                else{
                    lead.Industry_CAP_IQ_MCA__c='';
                }
                if(respoApex.GDSSDKResponse[3].Rows[0].Row[0]  !='Data Unavailable'){
                    lead.CEO_Name__c=respoApex.GDSSDKResponse[3].Rows[0].Row[0]; 
                }
                else{
                    lead.CEO_Name__c='';
                }
                if(respoApex.GDSSDKResponse[4].Rows[0].Row[0]  !='Data Unavailable'){
                    lead.Global_Ultimate_Owner__c=respoApex.GDSSDKResponse[4].Rows[0].Row[0]; 
                }
                else{
                    lead.Global_Ultimate_Owner__c='';
                }
                if(respoApex.GDSSDKResponse[5].Rows[0].Row[0]  !='Data Unavailable'){
                    lead.Public_Private_Company__c=respoApex.GDSSDKResponse[5].Rows[0].Row[0]; 
                }
                else{
                    lead.Public_Private_Company__c='';
                }
                
                String presidentName=respoApex.GDSSDKResponse[6].Rows[0].Row[0];
                
                if(respoApex.GDSSDKResponse[7].Rows[0].Row[0]  !='Data Unavailable'){
                    lead.ClientBackground__c=respoApex.GDSSDKResponse[7].Rows[0].Row[0]; 
                }
                else{
                    lead.ClientBackground__c='';
                }
                
                //lead.ClientBackground__c=respoApex.GDSSDKResponse[7].Rows[0].Row[0]
                System.debug('respoApex.GDSSDKResponse[8]--'+respoApex.GDSSDKResponse[8]);
                System.debug('respoApex.GDSSDKResponse[8].Rows[0]--'+respoApex.GDSSDKResponse[8].Rows[0]);
                System.debug('respoApex.GDSSDKResponse[8].Rows[0].Row[0]--'+respoApex.GDSSDKResponse[8].Rows[0].Row[0]);
                
                if(respoApex.GDSSDKResponse[8].Rows[0].Row[0]!='Data Unavailable'){
                    if (respoApex.GDSSDKResponse[8].Rows[0].Row[0] != null) {
                        
                        lead.SIC_Code__c =respoApex.GDSSDKResponse[8].Rows[0].Row[0]; 
                    } else{
                        lead.SIC_Code__c ='';// Added on 22/Apr/2024 to resolve bug W-002912
                    }
                }
                else{
                    lead.SIC_Code__c ='';
                }
                String primarySICCode=respoApex.GDSSDKResponse[8].Rows[0].Row[0];
                if(respoApex.GDSSDKResponse[9].Rows[0].Row[0]!='Data Unavailable'){
                    lead.Stock_Exchange_symbol__c=respoApex.GDSSDKResponse[7].Rows[0].Row[0]; 
                }
                else{
                    lead.Stock_Exchange_symbol__c='';
                }
                //lead.Stock_Exchange_symbol__c=respoApex.GDSSDKResponse[9].Rows[0].Row[0];
                String cooName=respoApex.GDSSDKResponse[10].Rows[0].Row[0];
                String cfoName=respoApex.GDSSDKResponse[11].Rows[0].Row[0];
                String companyStreet=respoApex.GDSSDKResponse[12].Rows[0].Row[0];
                String city=respoApex.GDSSDKResponse[13].Rows[0].Row[0];
                String countryName=respoApex.GDSSDKResponse[14].Rows[0].Row[0];
                String totalNo = respoApex.GDSSDKResponse[15].Rows[0].Row[0];
                if(totalNo !='Data Unavailable'){
                    totalNo = totalNo.split('\\.')[0];
                    lead.Total_No_of_employees__c=totalNo;
                }
                else{
                    lead.Total_No_of_employees__c='';
                }
                if(respoApex.GDSSDKResponse[16].Rows[0].Row[0] != 'Data Unavailable'){
                    lead.Company_Website__c =respoApex.GDSSDKResponse[16].Rows[0].Row[0];
                    lead.Website = respoApex.GDSSDKResponse[16].Rows[0].Row[0];
                }else{
                    lead.Company_Website__c  = '';
                    lead.Website = '';
                }
                if(respoApex.GDSSDKResponse[17].Rows[0].Row[0] != 'Data Unavailable'){
                    lead.Company_Overview__c=respoApex.GDSSDKResponse[17].Rows[0].Row[0];
                }else{
                    lead.Company_Overview__c = '';
                }
                
                if(respoApex.GDSSDKResponse[18].Rows[0].Row[0] != 'Data Unavailable'){
                    lead.Year_Founded__c=respoApex.GDSSDKResponse[18].Rows[0].Row[0];
                }else{
                    lead.Year_Founded__c = '';
                }
                //lead.Year_Founded__c=respoApex.GDSSDKResponse[18].Rows[0].Row[0];
                //    String competeterAll=respoApex.GDSSDKResponse[19].Rows[0].Row[0] + ' , ' + respoApex.GDSSDKResponse[19].Rows[1].Row[0] +' , ' + respoApex.GDSSDKResponse[19].Rows[2].Row[0] + ' , ' + respoApex.GDSSDKResponse[19].Rows[3].Row[0] + ' , '+respoApex.GDSSDKResponse[19].Rows[4].Row[0];
                
                if(respoApex.GDSSDKResponse[20].Rows[0].Row[0] != 'Data Unavailable'){
                    lead.Chairman_Name__c=respoApex.GDSSDKResponse[20].Rows[0].Row[0];
                }else{
                    lead.Chairman_Name__c = '';
                }
                if(respoApex.GDSSDKResponse[21].Rows[0].Row[0] != 'Data Unavailable'){
                    lead.Country_of_Incorporation__c=respoApex.GDSSDKResponse[21].Rows[0].Row[0];
                }else{
                    lead.Country_of_Incorporation__c = '';
                }
                
                //lead.Country_of_Incorporation__c = respoApex.GDSSDKResponse[21].Rows[0].Row[0];
                String companyPhone = respoApex.GDSSDKResponse[22].Rows[0].Row[0];
                if(respoApex.GDSSDKResponse[22].Rows[0].Row[0] != 'Data Unavailable'){
                    lead.Company_Phone_No__c  =respoApex.GDSSDKResponse[22].Rows[0].Row[0];
                }else{
                    lead.Company_Phone_No__c   = '';
                }
                String ultParentCAPIQ = respoApex.GDSSDKResponse[23].Rows[0].Row[0];
                
                if(respoApex.GDSSDKResponse[24].Rows[0].Row[0] != 'Data Unavailable'){
                    lead.Company=respoApex.GDSSDKResponse[24].Rows[0].Row[0];
                }else{
                    lead.Company = '';
                }
                

                
                //String companyWebsite = respoApex.GDSSDKResponse[29].Rows[0].Row[0];
                //System.debug(respoApex.GDSSDKResponse[30].Rows[0].Row[0]);
                //   String investorsAll = respoApex.GDSSDKResponse[31].Rows[0].Row[0]+ ' , ' + respoApex.GDSSDKResponse[31].Rows[1].Row[0] +' , ' + respoApex.GDSSDKResponse[31].Rows[2].Row[0] + ' , ' + respoApex.GDSSDKResponse[31].Rows[3].Row[0] + ' , '+respoApex.GDSSDKResponse[31].Rows[4].Row[0];
                String professionalPhone = respoApex.GDSSDKResponse[32].Rows[0].Row[0];
                //  String boardMember = respoApex.GDSSDKResponse[33].Rows[0].Row[0]+ ' , ' + respoApex.GDSSDKResponse[33].Rows[1].Row[0] +' , ' + respoApex.GDSSDKResponse[33].Rows[2].Row[0] + ' , ' + respoApex.GDSSDKResponse[33].Rows[3].Row[0] + ' , '+respoApex.GDSSDKResponse[33].Rows[4].Row[0];
                /*  String boardTitle = respoApex.GDSSDKResponse[34].Rows[0].Row[0]+ ' , ' + respoApex.GDSSDKResponse[34].Rows[1].Row[0] +' , ' + respoApex.GDSSDKResponse[34].Rows[2].Row[0] + ' , ' + respoApex.GDSSDKResponse[34].Rows[3].Row[0] + ' , '+respoApex.GDSSDKResponse[34].Rows[4].Row[0];
    String iqProfessional = respoApex.GDSSDKResponse[35].Rows[0].Row[0]+ ' , ' + respoApex.GDSSDKResponse[35].Rows[1].Row[0] +' , ' + respoApex.GDSSDKResponse[35].Rows[2].Row[0] + ' , ' + respoApex.GDSSDKResponse[35].Rows[3].Row[0] + ' , '+respoApex.GDSSDKResponse[35].Rows[4].Row[0];
    String iqProfesiionalPhone = respoApex.GDSSDKResponse[36].Rows[0].Row[0]+ ' , ' + respoApex.GDSSDKResponse[36].Rows[1].Row[0] +' , ' + respoApex.GDSSDKResponse[36].Rows[2].Row[0] + ' , ' + respoApex.GDSSDKResponse[36].Rows[3].Row[0] + ' , '+respoApex.GDSSDKResponse[36].Rows[4].Row[0];
    String iqProfessionalEmail = respoApex.GDSSDKResponse[37].Rows[0].Row[0]+ ' , ' + respoApex.GDSSDKResponse[37].Rows[1].Row[0] +' , ' + respoApex.GDSSDKResponse[37].Rows[2].Row[0] + ' , ' + respoApex.GDSSDKResponse[37].Rows[3].Row[0] + ' , '+respoApex.GDSSDKResponse[37].Rows[4].Row[0];
    String iqProfessionalTitle = respoApex.GDSSDKResponse[38].Rows[0].Row[0]+ ' , ' + respoApex.GDSSDKResponse[38].Rows[1].Row[0] +' , ' + respoApex.GDSSDKResponse[38].Rows[2].Row[0] + ' , ' + respoApex.GDSSDKResponse[38].Rows[3].Row[0] + ' , '+respoApex.GDSSDKResponse[38].Rows[4].Row[0];
    */          String ebit = respoApex.GDSSDKResponse[39].Rows[0].Row[0];
                List<String> spliters;
                if(ebit !='Data Unavailable'){
                    try{
                        spliters = ebit.split('\\.');
                        ebit = spliters[0]+'.';
                        spliters = spliters[1].split('');
                        ebit = ebit+spliters[0];            
                    }catch(Exception e){
                        
                    }
                    lead.Earnings_Before_Interest_and_Taxes_EBIT__c = decimal.valueOf(ebit);
                }
                else{
                    lead.Earnings_Before_Interest_and_Taxes_EBIT__c=0;
                }
                if(respoApex.GDSSDKResponse[40].Rows[0].Row[0] != 'Data Unavailable'){
                    lead.Total_Equity__c=decimal.valueOf(respoApex.GDSSDKResponse[40].Rows[0].Row[0]);
                }else{
                    lead.Total_Equity__c = 0;
                }
                //lead.Total_Equity__c = decimal.valueOf(respoApex.GDSSDKResponse[40].Rows[0].Row[0]);
                String iqRev =respoApex.GDSSDKResponse[41].Rows[0].Row[0];
                if(iqRev !='Data Unavailable'){
                    try{
                        spliters = iqRev.split('\\.');
                        iqRev = spliters[0]+'.';
                        spliters = spliters[1].split('');
                        iqRev = iqRev+spliters[0];           
                    }catch(Exception e){
                        
                    }
                    lead.Total_Revenue__c  = decimal.valueOf(iqRev);
                }else{
                    
                   lead.Total_Revenue__c = 0;
                }
                if(respoApex.GDSSDKResponse[42].Rows[0].Row[0] != 'Data Unavailable'){
                    lead.Total_Assets__c=decimal.valueOf(respoApex.GDSSDKResponse[42].Rows[0].Row[0]);
                }else{
                    lead.Total_Assets__c = 0;
                }
                
                if(respoApex.GDSSDKResponse[43].Rows[0].Row[0] != 'Data Unavailable'){
                    lead.EBITDA__c=decimal.valueOf(respoApex.GDSSDKResponse[43].Rows[0].Row[0]);
                }else{
                    lead.EBITDA__c = 0;
                }
                
                if(respoApex.GDSSDKResponse[44].Rows[0].Row[0] != 'Data Unavailable'){
                    lead.Net_Income__c=decimal.valueOf(respoApex.GDSSDKResponse[44].Rows[0].Row[0]);
                }else{
                    lead.Net_Income__c = 0;
                }
                String gp = respoApex.GDSSDKResponse[45].Rows[0].Row[0];
                
                if(gp !='Data Unavailable'){
                    try{
                        spliters = gp.split('\\.');
                        gp = spliters[0]+'.';
                        spliters = spliters[1].split('');
                        gp = gp+spliters[0];     
                        }catch(Exception e){
                        
                       }
                    lead.Gross_Profit__c = decimal.valueOf(gp);
                }
                else{
                    lead.Gross_Profit__c = 0;
                }
                
                if(respoApex.GDSSDKResponse[46].Rows[0].Row[0] != 'Data Unavailable'){
                    lead.Total_Current_Liabilities__c=decimal.valueOf(respoApex.GDSSDKResponse[46].Rows[0].Row[0]);
                }else{
                    lead.Total_Current_Liabilities__c = 0;
                }
                lead.Currency_Format__c = 'INR in Millions';
                
                if(respoApex.GDSSDKResponse[47].Rows[0].Row[0] != 'Data Unavailable'){
                    lead.Total_Current_Assets__c=decimal.valueOf(respoApex.GDSSDKResponse[47].Rows[0].Row[0]);
                }else{
                    lead.Total_Current_Assets__c = 0;
                }
                
                if(respoApex.GDSSDKResponse[48].Rows[0].Row[0] != 'Data Unavailable'){
                    lead.Total_Liabilities__c=decimal.valueOf(respoApex.GDSSDKResponse[48].Rows[0].Row[0]);
                }else{
                    lead.Total_Liabilities__c = 0;
                }
                if(respoApex.GDSSDKResponse[49].Rows[0].Row[0] != 'Data Unavailable'){
                    lead.Total_Revenue__c=decimal.valueOf(respoApex.GDSSDKResponse[49].Rows[0].Row[0]);
                }else{
                    lead.Total_Revenue__c = 0;
                }
                if(respoApex.GDSSDKResponse[50].Rows[0].Row[0] != 'Data Unavailable'){
                    lead.Total_Debt__c=decimal.valueOf(respoApex.GDSSDKResponse[50].Rows[0].Row[0]);
                }else{
                    lead.Total_Debt__c = 0;
                }
                lead.External_Database_Source__c = 'CapIQ';
                //String holderName  = respoApex.GDSSDKResponse[51].Rows[0].Row[0]+ ' , ' + respoApex.GDSSDKResponse[51].Rows[1].Row[0] +' , ' + respoApex.GDSSDKResponse[51].Rows[2].Row[0] + ' , ' + respoApex.GDSSDKResponse[51].Rows[3].Row[0] + ' , '+respoApex.GDSSDKResponse[51].Rows[4].Row[0];
                String iqISIN /*= respoApex.GDSSDKResponse[52].Rows[0].Row[0]*/;
                String keyDevId = respoApex.GDSSDKResponse[53].Rows[0].Row[0];
                String fYear = respoApex.GDSSDKResponse[55].Rows[0].Row[0];
                List<String> fy2 = new List<String>();
                if(fYear != 'Data Unavailable'){
                     fy2 = fYear.split(' ');
                    fYear = fy2[0];
                    fy2 = fYear.split('/');
                    system.debug('----> fy2'+fy2);
                    fYear = fy2[2];
                    decimal fy = decimal.valueOf(fYear);
                    fYear = string.valueOf(fy-1) + '-' + string.valueof(fy).right(2);
                    lead.Financial_Year__c = fYear;
                }else{
                    lead.Financial_Year__c= '';
                }
                if(respoApex.GDSSDKResponse[56].Rows[0].Row[0] != 'Data Unavailable'){
                    lead.Client_Group_Name__c=respoApex.GDSSDKResponse[56].Rows[0].Row[0];
                }else{
                    lead.Client_Group_Name__c = '';
                }
                if(respoApex.GDSSDKResponse[57].Rows[0].Row[0] != 'Data Unavailable'){
                    lead.Client_Group_Name_CIQID__c=respoApex.GDSSDKResponse[57].Rows[0].Row[0];
                }else{
                    lead.Client_Group_Name_CIQID__c = '';
                }
                if(respoApex.GDSSDKResponse[58].Rows[0].Row[0] != 'Data Unavailable'){
                    lead.Global_Ultimate_Owner_ID__c=respoApex.GDSSDKResponse[58].Rows[0].Row[0];
                }else{
                    lead.Global_Ultimate_Owner_ID__c = '';
                }
            }
            catch(Exception e){
                System.debug('Exception');
            }
            try{
                lead.CompanyHQ__City__s = '';
                lead.CompanyHQ__CountryCode__s = '';
                lead.CompanyHQ__PostalCode__s = '';
                lead.CompanyHQ__StateCode__s = '';
                lead.CompanyHQ__Street__s = '';
                
                String city=respoApex.GDSSDKResponse[13].Rows[0].Row[0];
                String companyAddress = respoApex.GDSSDKResponse[25].Rows[0].Row[0];
                String companyZIP = respoApex.GDSSDKResponse[26].Rows[0].Row[0];
                String state = respoApex.GDSSDKResponse[27].Rows[0].Row[0];
                String companyStreet1 = respoApex.GDSSDKResponse[28].Rows[0].Row[0];
                //lead.Company_HQ__CountryCode__s = respoApex.GDSSDKResponse[14].Rows[0].Row[0];
                if(companyZIP!='Data Unavailable'){
                    lead.CompanyHQ__PostalCode__s = companyZIP;
                }
                if(state!='Data Unavailable'){
                    lead.CompanyHQ__Street__s = companyStreet1;
                }
                if(city!='Data Unavailable'){
                    lead.CompanyHQ__City__s=city;
                }
                
            }
            catch(Exception e){
                
            }
           String boardMember;
    
            try{
                if(respoApex.GDSSDKResponse[33].Rows[0].Row[0] !='Data Unavailable'){
                    boardMember = respoApex.GDSSDKResponse[33].Rows[0].Row[0]+ '  (' +respoApex.GDSSDKResponse[34].Rows[0].Row[0]+') ';
    
                for(Integer i=1;i<10;i++)
                {
                    
                    boardMember =boardMember + ';  '+ respoApex.GDSSDKResponse[33].Rows[i].Row[0]+ '  (' +respoApex.GDSSDKResponse[34].Rows[i].Row[0]+')  ';
                }
                }
            }
            catch(Exception e)
            {
            }
            String professional;
    
            try{
                if(respoApex.GDSSDKResponse[35].Rows[0].Row[0] !='Data Unavailable'){
                    professional = respoApex.GDSSDKResponse[35].Rows[0].Row[0]+ '  (' +respoApex.GDSSDKResponse[38].Rows[0].Row[0]+') ';
    
                    for(Integer i=1;i<10;i++)
                    {
                        
                        professional =professional + ';  '+ respoApex.GDSSDKResponse[35].Rows[i].Row[0]+ '  (' +respoApex.GDSSDKResponse[38].Rows[i].Row[0]+')  ';
                    }
    
                        
                   }           
                }
                catch(Exception e)
                {
                    
                }
            lead.KMP__c = professional;
            
            lead.Board_of_Directors__c =  boardMember;
            System.debug('Currency format : ' + lead.Currency_Format__c);
            update lead;
            System.debug('companyID : ' + companyID);
            if(companyId == 'Data Unavailable' || companyId == ''){
                System.debug('false');
                return false;
            }
            else{
                System.debug('true');
                return true;
            }
            
            
        }
        
        //Created By Gaurav Kumar 
        //Date :18-April-2023
        //Description : Enrich Data From External Database button Accebility for Sector Business Partner  
        @AuraEnabled
        public static String getCurrentUserProfile(){
            Profile p = [Select Name from Profile where Id =: userinfo.getProfileid()];
            System.debug('Current Profile :'+p.Name);
            return p.Name;
        }
    //added by Deepak joshi
    public static HttpResponse callOut(String companyID){

        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setMethod('POST');
        CapIQ__mdt capIq = [SELECT Id, UserName__c,NumberofBoardMember__c , Password__c, EndPointURL__c  FROM CapIQ__mdt Limit 1];
        capIq.NumberofBoardMember__c =  Integer.ValueOf(capIq.NumberofBoardMember__c);
        req.setEndpoint(capIq.EndPointURL__c);
        Blob headerValue = Blob.valueOf  (capIq.UserName__c + ':' + capIq.Password__c);
        String authorizationHeader = 'BASIC ' + EncodingUtil.base64Encode(headerValue);
        req.setHeader('Authorization',authorizationHeader);
        req.setHeader('Content-Type','application/json');
        
        //System.debug('companyID ===>' + leads );
        String reqBody = '{"inputRequests":[{"function":"GDSP","mnemonic":"PARENT_NAME","identifier":"'+companyID+'","startDate":"01/01/202"},'+
            '{"function":"GDSP","mnemonic":"IQ_COMPANY_TICKER","identifier":"' +companyID+'"},' +
            '{"function":"GDSP","mnemonic":"IQ_PRIMARY_SIC_INDUSTRY","identifier":"'+companyID+'"},'+
            '{"function":"GDSP","mnemonic":"IQ_CEO_NAME","identifier":"'+companyID+'"},'+
            '{"function":"GDSP","mnemonic":"IQ_ULT_PARENT","identifier":"'+companyID+'"},'+
            '{"function":"GDSP","mnemonic":"IQ_COMPANY_TYPE","identifier":"'+companyID+'"},'+
            '{"function":"GDSP","mnemonic":"IQ_PRESIDENT_NAME","identifier":"'+companyID+'"},'+
            '{"function":"GDSP","mnemonic":"IQ_SHORT_BUSINESS_DESCRIPTION","identifier":"'+companyID+'"},'+
            '{"function":"GDSP","mnemonic":"IQ_PRIMARY_SIC_CODE","identifier":"'+companyID+'"},'+
            '{"function":"GDSP","mnemonic":"IQ_EXCHANGE","identifier":"'+companyID+'"},'+
            '{"function":"GDSP","mnemonic":"IQ_COO_NAME","identifier":"'+companyID+'"},'+
            '{"function":"GDSP","mnemonic":"IQ_CFO_NAME","identifier":"'+companyID+'"},'+
            '{"function":"GDSP","mnemonic":"IQ_COMPANY_STREET2","identifier":"'+companyID+'"},'+
            '{"function":"GDSP","mnemonic":"IQ_CITY","identifier":"'+companyID+'"},'+
            '{"function":"GDSP","mnemonic":"IQ_COUNTRY_NAME","identifier":"'+companyID+'"},'+
            '{"function":"GDSP","mnemonic":"IQ_EMPLOYEES","identifier":"'+companyID+'"},'+
            '{"function":"GDSP","mnemonic":"IQ_COMPANY_WEBSITE","identifier":"'+companyID+'"},'+
            '{"function":"GDSP","mnemonic":"IQ_DESCRIPTION_LONG","identifier":"'+companyID+'"},'+
            '{"function":"GDSP","mnemonic":"IQ_YEAR_FOUNDED","identifier":"'+companyID+'"},'+
            '{"function":"GDSHE","mnemonic":"IQ_COMPETITOR_ALL","identifier":"'+companyID+'","properties": {"startRank":"1","endRank":"5"}},'+
            '{"function":"GDSP","mnemonic":"IQ_CHAIRMAN_NAME","identifier":"'+companyID+'"},'+
            '{"function":"GDSP","mnemonic":"IQ_COUNTRY_OF_INC","identifier":"'+companyID+'"},'+
            '{"function":"GDSP","mnemonic":"IQ_COMPANY_PHONE","identifier":"'+companyID+'"},'+
            '{"function":"GDSP","mnemonic":"IQ_ULT_PARENT_CIQID","identifier":"'+companyID+'"},'+
            '{"function":"GDSP","mnemonic":"IQ_COMPANY_NAME","identifier":"'+companyID+'"},'+
            '{"function":"GDSP","mnemonic":"IQ_COMPANY_ADDRESS","identifier":"'+companyID+'"},'+
            '{"function":"GDSP","mnemonic":"IQ_COMPANY_ZIP","identifier":"'+companyID+'"},'+
            '{"function":"GDSP","mnemonic":"IQ_STATE","identifier":"'+companyID+'"},'+
            '{"function":"GDSP","mnemonic":"IQ_COMPANY_STREET1","identifier":"'+companyID+'"},'+
            '{"function":"GDSP","mnemonic":"IQ_COMPANY_WEBSITE","identifier":"'+companyID+'"},'+
            '{"function":"GDSP","mnemonic":"DOM_ULTIMATE_PARENT_NAME","identifier":"'+companyID+'"},'+
            '{"function":"GDSHE","mnemonic":"IQ_INVESTORS_ALL","identifier":"'+companyID+'","properties": {"startRank":"1","endRank":"5"}},'+
            '{"function":"GDSP","mnemonic":"IQ_PROFESSIONAL_DIRECT_PHONE","identifier":"'+companyID+'"},'+
            '{"function":"GDSHE","mnemonic":"IQ_BOARD_MEMBER","identifier":"'+companyID+'","properties": {"startRank":"1","endRank":"'+capIq.NumberofBoardMember__c +'"}},'+
            '{"function":"GDSHE","mnemonic":"IQ_BOARD_MEMBER_TITLE","identifier":"'+companyID+'","properties": {"startRank":"1","endRank":"'+capIq.NumberofBoardMember__c +'"}},'+
            '{"function":"GDSHE","mnemonic":"IQ_PROFESSIONAL","identifier":"'+companyID+'","properties": {"startRank":"1","endRank":"5"}},'+
            '{"function":"GDSHE","mnemonic":"IQ_PROFESSIONAL_MAIN_PHONE","identifier":"'+companyID+'","properties": {"startRank":"1","endRank":"5"}},'+
            '{"function":"GDSHE","mnemonic":"IQ_PROFESSIONAL_EMAIL","identifier":"'+companyID+'","properties": { "startRank":"1","endRank":"5"}},'+
            '{"function":"GDSHE","mnemonic":"IQ_PROFESSIONAL_TITLE","identifier":"'+companyID+'","properties": {"startRank":"1","endRank":"5"}},'+
            '{"function":"GDSP","mnemonic":"IQ_EBIT","identifier":"'+companyID+'","properties" : {"periodType" : "IQ_FY","currencyId" : "INR"}},'+
            '{"function":"GDSP","mnemonic":"IQ_TOTAL_EQUITY","identifier":"'+companyID+'","properties" : {"periodType" : "IQ_FY","currencyId" : "INR"}},'+
            '{"function":"GDSP","mnemonic":"IQ_REV","identifier":"'+companyID+'","properties" : {"periodType" : "IQ_FY","currencyId" : "INR"}},'+
            '{"function":"GDSP","mnemonic":"IQ_TOTAL_ASSETS","identifier":"'+companyID+'","properties" : {"periodType" : "IQ_FY","currencyId" : "INR"}},'+
            '{"function":"GDSP","mnemonic":"IQ_EBITDA","identifier":"'+companyID+'","properties" : {"periodType" : "IQ_FY","currencyId" : "INR"}},'+
            '{"function":"GDSP","mnemonic":"IQ_NI","identifier":"'+companyID+'","properties" : {"periodType" : "IQ_FY","currencyId" : "INR"}},'+
            '{"function":"GDSP","mnemonic":"IQ_GP","identifier":"'+companyID+'","properties" : {"periodType" : "IQ_FY","currencyId" : "INR"}},'+
            '{"function":"GDSP","mnemonic":"IQ_TOTAL_CL","identifier":"'+companyID+'","properties" : {"periodType" : "IQ_FY","currencyId" : "INR"}},'+
            '{"function":"GDSP","mnemonic":"IQ_TOTAL_CA","identifier":"'+companyID+'","properties" : {"periodType" : "IQ_FY","currencyId" : "INR"}},'+
            '{"function":"GDSP","mnemonic":"IQ_TOTAL_LIAB","identifier":"'+companyID+'","properties" : {"periodType" : "IQ_FY","currencyId" : "INR"}},'+
            '{"function":"GDSP","mnemonic":"IQ_TOTAL_REV","identifier":"'+companyID+'","properties" : {"periodType" : "IQ_FY","currencyId" : "INR"}},'+
            '{"function":"GDSP","mnemonic":"IQ_TOTAL_DEBT","identifier":"'+companyID+'","properties" : {"periodType" : "IQ_FY","currencyId" : "INR"}},'+
            '{"function":"GDSP","mnemonic":"IQ_HOLDER_NAME","identifier":"'+companyID+'","properties" : {"asOfDate" : "01/01/2022", "startRank" : "1","endRank" : "5", "currencyId" : "EUR", "currencyConversionModeId" : "Historical"} },'+
            '{"function":"GDSP","mnemonic":"IQ_HOLDER_PERCENT","identifier":"'+companyID+'","properties" : {"asOfDate" : "01/01/2022", "startRank" : "1","endRank" : "5", "currencyId" : "EUR", "currencyConversionModeId" : "Historical"}},'+
            '{"function":"GDSP","mnemonic":"IQ_ISIN","identifier":"'+companyID+'"},'+
            '{"function":"GDSP","mnemonic":"IQ_KEY_DEV_ID","identifier":"'+companyID+'","properties": {"startDate":"01/01/2022","endDate":"09/09/2022","keyDevFilter" : "C2,T36"}},'+
            '{"function":"GDSP","mnemonic":"IQ_PERIODDATE_IS","identifier":"'+companyID+'", "properties": { "periodType": "IQ_FY" }},'+
            '{"function":"GDSHE","mnemonic":"IQ_IMM_PARENT","identifier":"'+companyID+'","properties": {"startRank":"1","endRank":"5"}},'+
            '{"function":"GDSHE","mnemonic":"IQ_IMM_PARENT_CIQID","identifier":"'+companyID+'","properties": {"startRank":"1","endRank":"5"}},'+
            '{"function":"GDSP","mnemonic":"IQ_ULT_PARENT_CIQID","identifier":"'+companyID+'"},'+']}';

        
        
        req.setBody(reqBody);
        HttpResponse resp;
        try{
            resp = http.send(req); 
            API_Logger__c apiLog = API_LoggerCommonUtility.createAPILogger(null,reqBody,resp.getBody(),resp.getStatus(),'capIQButtontoUpdateClient',capIq.EndPointURL__c,resp.getStatusCode());                  
            	insert apiLog; 
            System.debug('apiLog-->'+apiLog);
        }
        catch(Exception e){
            ErrorLogCreater_cls.apexDebugLoggerForAPICallout(e, 'capIQButtontoUpdateClient' , 'sendCapIQIdtoNewClient' , '' , reqBody,resp.getBody(), capIq.EndPointURL__c );
        }
        return resp;

    }
     //added by Deepak joshi
    @AuraEnabled
    public static string updateAcountFromExternal (Id recordId , String capIqId, String registeredCompanyName, String wrapperObj)
    {
        Boolean manualClient = false;
        Account acc = [SELECT Id, Name , capIQId__c, IsNameChange__c From Account Where Id =: recordId Limit 1];
        //Added By Prashant on 02Apr2024 as per Phase-1 Changes
        if(String.isBlank(acc.capIQId__c)) {
            manualClient = true;
            System.debug('@@registeredCompanyName--'+registeredCompanyName);
            acc.Name = registeredCompanyName;
        }
        acc.capIQId__c = capIqId; // Added By Prashant on 22Mar2024 as per Phase-1 Changes
        acc.External_Database_Source__c = 'CapIQ'; // Added By Prashant on 22Mar2024 as per Phase-1 Changes
            
        String companyID = capIqId;
        String result= 'Success';
        System.debug('**Enrich recordId  '+recordId);
        System.debug('**Enrich capIqId  '+capIqId);
        System.debug('**Enrich acc  '+acc);
        System.debug('**Enrich wrapperObj  '+wrapperObj);
        if(companyID != null && companyID !='')
        {
            //HttpResponse resp = callOut(companyID);
           /*if(resp.getStatusCode() != 200){
            result = 'ERROR '+resp.getStatus() +' StatusCode '+resp.getStatusCode();
            System.debug('**Enrich result  '+result);
            return result;
           }*/
            clientNewIqWrapper respoApex=(clientNewIqWrapper) System.JSON.deserialize(wrapperObj, clientNewIqWrapper.class);
            System.debug('**Enrich respoApex  '+respoApex);
            try{
                /*if(respoApex.GDSSDKResponse[24].Rows[0].Row[0] != 'Data Unavailable'){
                    acc.Name=respoApex.GDSSDKResponse[24].Rows[0].Row[0];
                }else{
                    acc.Name = '';
                }*/
                if(respoApex.GDSSDKResponse[7].Rows[0].Row[0]  !='Data Unavailable'){
                    acc.Client_Background__c=respoApex.GDSSDKResponse[7].Rows[0].Row[0]; 
                }
                else{
                    acc.Client_Background__c='';
                }
                /*if(respoApex.GDSSDKResponse[56].Rows[0].Row[0] != 'Data Unavailable'){
                    acc.ClientGroup__c=respoApex.GDSSDKResponse[56].Rows[0].Row[0];
                }else{
                    acc.ClientGroup__c = '';
                }*/
                if(respoApex.GDSSDKResponse[57].Rows[0].Row[0] != 'Data Unavailable'){
                    acc.Client_Group_Name_CIQID__c=respoApex.GDSSDKResponse[57].Rows[0].Row[0];
                }else{
                    acc.Client_Group_Name_CIQID__c = '';
                }
                if(respoApex.GDSSDKResponse[17].Rows[0].Row[0] != 'Data Unavailable'){
                    acc.Company_Overview__c=respoApex.GDSSDKResponse[17].Rows[0].Row[0];
                }else{
                    acc.Company_Overview__c = '';
                }
                if(respoApex.GDSSDKResponse[22].Rows[0].Row[0] != 'Data Unavailable'){
                    acc.Company_Phone_No__c  =respoApex.GDSSDKResponse[22].Rows[0].Row[0];
                }else{
                    acc.Company_Phone_No__c   = '';
                }
                if(respoApex.GDSSDKResponse[16].Rows[0].Row[0] != 'Data Unavailable'){
                    acc.Website =respoApex.GDSSDKResponse[16].Rows[0].Row[0];
                }else{
                    acc.Website  = '';
                }
                if(respoApex.GDSSDKResponse[4].Rows[0].Row[0]  !='Data Unavailable'){
                    acc.Global_Ultimate_Owner__c=respoApex.GDSSDKResponse[4].Rows[0].Row[0]; 
                }
                else{
                    acc.Global_Ultimate_Owner__c='';
                }
                if(respoApex.GDSSDKResponse[58].Rows[0].Row[0] != 'Data Unavailable'){
                    acc.Global_Ultimate_Owner_ID__c=respoApex.GDSSDKResponse[58].Rows[0].Row[0];
                }else{
                    acc.Global_Ultimate_Owner_ID__c = '';
                }
                String gp = respoApex.GDSSDKResponse[45].Rows[0].Row[0];
                List<String> spliters;               
                if(gp !='Data Unavailable'){
                    try{
                        spliters = gp.split('\\.');
                        gp = spliters[0]+'.';
                        spliters = spliters[1].split('');
                        gp = gp+spliters[0];     
                        }catch(Exception e){
                            System.debug('Error occured4 '+e.getMessage()+' '+e.getLineNumber());
                            throw new AuraHandledException(e.getMessage());
                        }
                        acc.Gross_Profit__c =Decimal.valueOf(gp);
                }
                else{
                    acc.Gross_Profit__c = 0;
                }
                System.debug('respoApex.GDSSDKResponse[8]--'+respoApex.GDSSDKResponse[8]);
                System.debug('respoApex.GDSSDKResponse[8].Rows[0]--'+respoApex.GDSSDKResponse[8].Rows[0]);
                System.debug('respoApex.GDSSDKResponse[8].Rows[0].Row[0]--'+respoApex.GDSSDKResponse[8].Rows[0].Row[0]);
                if(respoApex.GDSSDKResponse[8].Rows[0].Row[0]!='Data Unavailable'){
                    if (respoApex.GDSSDKResponse[8].Rows[0].Row[0] != null) {
                        acc.SIC_Code__c =respoApex.GDSSDKResponse[8].Rows[0].Row[0]; 
                        
                    }  else{
                        acc.SIC_Code__c ='';// Added on 22/Apr/2024 to resolve bug W-002912
                    }
                }
                    else{
                        acc.SIC_Code__c ='';
                    }
                    if(respoApex.GDSSDKResponse[9].Rows[0].Row[0]!='Data Unavailable'){
                        acc.Stock_Exchange_symbol__c=respoApex.GDSSDKResponse[7].Rows[0].Row[0]; 
                    }
                    else{
                        acc.Stock_Exchange_symbol__c='';
                    }
                    String totalNo = respoApex.GDSSDKResponse[15].Rows[0].Row[0];
                    if(totalNo !='Data Unavailable'){
                        totalNo = totalNo.split('\\.')[0];
                        acc.Total_No_of_employees__c=totalNo;
                    }
                    else{
                        acc.Total_No_of_employees__c='';
                    }
                    if(respoApex.GDSSDKResponse[40].Rows[0].Row[0] != 'Data Unavailable'){
                        acc.Total_Equity__c=decimal.valueOf(respoApex.GDSSDKResponse[40].Rows[0].Row[0]);
                    }else{
                        acc.Total_Equity__c = 0;
                    }
                    if(respoApex.GDSSDKResponse[42].Rows[0].Row[0] != 'Data Unavailable'){
                        acc.Total_Assets__c=decimal.valueOf(respoApex.GDSSDKResponse[42].Rows[0].Row[0]);
                    }else{
                        acc.Total_Assets__c = 0;
                    }
                    if(respoApex.GDSSDKResponse[46].Rows[0].Row[0] != 'Data Unavailable'){
                        acc.Total_Current_Liabilities__c=decimal.valueOf(respoApex.GDSSDKResponse[46].Rows[0].Row[0]);
                    }else{
                        acc.Total_Current_Liabilities__c = 0;
                    }
                    if(respoApex.GDSSDKResponse[47].Rows[0].Row[0] != 'Data Unavailable'){
                        acc.Total_Current_Assets__c=decimal.valueOf(respoApex.GDSSDKResponse[47].Rows[0].Row[0]);
                    }else{
                        acc.Total_Current_Assets__c = 0;
                    }
                    if(respoApex.GDSSDKResponse[48].Rows[0].Row[0] != 'Data Unavailable'){
                        acc.Total_Liabilities__c=decimal.valueOf(respoApex.GDSSDKResponse[48].Rows[0].Row[0]);
                    }else{
                        acc.Total_Liabilities__c = 0;
                    }
                    if(respoApex.GDSSDKResponse[50].Rows[0].Row[0] != 'Data Unavailable'){
                        acc.Total_Debt__c=decimal.valueOf(respoApex.GDSSDKResponse[50].Rows[0].Row[0]);
                    }else{
                        acc.Total_Debt__c = 0;
                    }
                    acc.External_Database_Source__c = 'CapIQ';
                    if(respoApex.GDSSDKResponse[1].Rows[0].Row[0] !='Data Unavailable')
                    {
                        acc.Ticker_Symbol__c = respoApex.GDSSDKResponse[1].Rows[0].Row[0]; 
                    }
                    else{
                        acc.Ticker_Symbol__c= '';
                    }
                    if(respoApex.GDSSDKResponse[5].Rows[0].Row[0]  !='Data Unavailable'){
                        acc.Public_Private_Company__c=respoApex.GDSSDKResponse[5].Rows[0].Row[0]; 
                    }
                    else{
                        acc.Public_Private_Company__c='';
                    }
                    if(respoApex.GDSSDKResponse[18].Rows[0].Row[0] != 'Data Unavailable'){
                        acc.Year_Founded__c=respoApex.GDSSDKResponse[18].Rows[0].Row[0];
                    }else{
                        acc.Year_Founded__c = '';
                    }
                    if(respoApex.GDSSDKResponse[21].Rows[0].Row[0] != 'Data Unavailable'){
                        acc.Country_of_Incorporation__c=respoApex.GDSSDKResponse[21].Rows[0].Row[0];
                    }else{
                        acc.Country_of_Incorporation__c = '';
                    }
                    String iqRev =respoApex.GDSSDKResponse[41].Rows[0].Row[0];
                    if(iqRev !='Data Unavailable'){
                        try{
                            spliters = iqRev.split('\\.');
                            iqRev = spliters[0]+'.';
                            spliters = spliters[1].split('');
                            iqRev = iqRev+spliters[0];           
                        }catch(Exception e){
                            System.debug('Error occured3 '+e.getMessage()+' '+e.getLineNumber());
                            throw new AuraHandledException(e.getMessage());
                        }
                        acc.Total_Revenue__c  = decimal.valueOf(iqRev);
                    }else{
                        
                        acc.Total_Revenue__c = 0;
                    }
                    if(respoApex.GDSSDKResponse[49].Rows[0].Row[0] != 'Data Unavailable'){
                        acc.Total_Revenue__c=decimal.valueOf(respoApex.GDSSDKResponse[49].Rows[0].Row[0]);
                    }else{
                        acc.Total_Revenue__c = 0;
                    }
                    if(respoApex.GDSSDKResponse[43].Rows[0].Row[0] != 'Data Unavailable'){
                        acc.EBITDA__c=decimal.valueOf(respoApex.GDSSDKResponse[43].Rows[0].Row[0]);
                    }else{
                        acc.EBITDA__c = 0;
                    }
                    if(respoApex.GDSSDKResponse[44].Rows[0].Row[0] != 'Data Unavailable'){
                        acc.Net_Income__c=decimal.valueOf(respoApex.GDSSDKResponse[44].Rows[0].Row[0]);
                    }else{
                        acc.Net_Income__c = 0;
                    }
                    acc.Currency_Format__c = 'INR in Millions';if(respoApex.GDSSDKResponse[2].Rows[0].Row[0]  !='Data Unavailable'){
                        acc.Industry_CAP_IQ_MCA__c=respoApex.GDSSDKResponse[2].Rows[0].Row[0]; 
                    }
                    else{
                        acc.Industry_CAP_IQ_MCA__c='';
                    }
                    try{
                        acc.Company_HQ__City__s = '';
                        acc.Company_HQ__CountryCode__s = '';
                        acc.Company_HQ__PostalCode__s = '';
                        acc.Company_HQ__StateCode__s = '';
                        acc.Company_HQ__Street__s = '';
                        
                        String city=respoApex.GDSSDKResponse[13].Rows[0].Row[0];
                        String companyAddress = respoApex.GDSSDKResponse[25].Rows[0].Row[0];
                        String companyZIP = respoApex.GDSSDKResponse[26].Rows[0].Row[0];
                        String state = respoApex.GDSSDKResponse[27].Rows[0].Row[0];
                        String companyStreet1 = respoApex.GDSSDKResponse[28].Rows[0].Row[0];
                        //lead.Company_HQ__CountryCode__s = respoApex.GDSSDKResponse[14].Rows[0].Row[0];
                        /*if(companyZIP!='Data Unavailable'){
                            acc.CompanyHQ__PostalCode__s = companyZIP;
                        }
                        if(state!='Data Unavailable'){
                            acc.CompanyHQ__Street__s = companyStreet1;
                        }
                        if(city!='Data Unavailable'){
                            acc.CompanyHQ__City__s=city;
                        }*/
                        
                    }
                    catch(Exception e){
                        System.debug('Error occured1 '+e.getMessage()+' '+e.getLineNumber());
                        throw new AuraHandledException(e.getMessage());
                    }
                    
                    
                    
                    
                    
                    String obj = 'Account';
                    createCompetitor.deleteOldCompetitor(acc.Id, acc.capIQId__c, obj );
                    createInvestors.deleteOldInv(acc.Id, acc.capIQId__c, obj);
                    createClientNews.deleteOldClientNews(acc.Id, acc.capIQId__c, obj);
                    createSubsidiarys.deleteOldSubsidiarys(acc.Id, acc.capIQId__c, obj);
                    createJointVenture.deleteOldJV(acc.Id, acc.capIQId__c, obj);
                    System.debug('**Enrich acc befor updte  '+acc);
                if(! manualClient) {
                    update acc;                    
                } else {
                    UpdateClientName.updateName(acc);
                }
                    System.debug('**Enrich acc befor updte2  '+acc);
              
                return result;
              

            }
            catch(Exception e){
                System.debug('Error occured 25 '+e.getMessage()+' '+e.getLineNumber());
                System.debug('Error occured 26 '+e.getCause());
                System.debug('Error occured 27 '+e.getStackTraceString());
                System.debug('Error occured 28 '+e.getTypeName());
               
                throw new AuraHandledException(e.getMessage());
               // result =false;
            }
            
        }
        return result;
    }
    
    //added by Deepak joshi
    @AuraEnabled
    public static CAPIQ_Information getCapiqRegisteredCompanyName(String capIqId){
        if(capIqId != null && capIqId !='')
        {
            CAPIQ_Information  CAPIQ_InformationObj = new CAPIQ_Information();
            HttpResponse resp = callOut(capIqId);
            if(resp.getStatusCode() != 200){
                String result = 'ERROR '+resp.getStatus() +' StatusCode '+resp.getStatusCode();
                System.debug('**Enrich result  '+result);
                CAPIQ_InformationObj.error = result;
                return CAPIQ_InformationObj;
            }
            System.debug('**Enrich resp.getBody()  '+resp.getBody());
            clientNewIqWrapper respoApex=(clientNewIqWrapper) System.JSON.deserialize(resp.getBody(), clientNewIqWrapper.class);
            System.debug('**Enrich respoApex  '+respoApex);
            String registeredCompanyName;
            try{
                 if(respoApex.GDSSDKResponse[24].Rows[0].Row[0] != 'Data Unavailable'){
                    //registeredCompanyName=respoApex.GDSSDKResponse[24].Rows[0].Row[0];
                    CAPIQ_InformationObj.clientNewIqWrapperObj =resp.getBody();
                    CAPIQ_InformationObj.registeredCompanyName = respoApex.GDSSDKResponse[24].Rows[0].Row[0];
                    return CAPIQ_InformationObj;
                }
                //return registeredCompanyName;
            }
            catch(Exception e){
                System.debug('Error occured2 '+e.getMessage()+' '+e.getLineNumber());
                throw new AuraHandledException(e.getMessage());
              
            }
        }
        return null;

    }
        
        // Method to check whether the company is already in record // Added By Prashant on 21-March-2024 as per Phase-1
        @AuraEnabled
        public static List<Account> searchClientInternally(String searchString, String recordId){
            if(searchString.containsWhitespace()){
                searchString = searchString.replaceAll('\\s+', ' ');
            }
            searchString = searchString.trim();
            system.debug('searchString'+searchString);
            //strFilter = '%Nahar%';
            list<account> clientList = [SELECT Name, ParentId, Parent.Name, Owner.Name FROM Account WHERE Name = :searchString AND Id !=: recordId AND Status__c != 'Inactive' AND RecordType.name = 'Client'];
            return clientList;
        }
        
        // Added By Prashant on 22Mar2024 as per Phase-1 Changes
        @AuraEnabled
        public static String sendEmailToInactivateClient(Id OriginalClientId, Id DuplicateClientId) {
            
            Account originalClientQueried = [SELECT Id, Name FROM Account WHERE Id =: OriginalClientId];
            EmailTemplate et = [SELECT Id,Subject, HTMLValue ,DeveloperName FROM EmailTemplate Where DeveloperName = 'Client_Inactivation_Email_to_ME_Team'];
            List<string> toAddress = new List<string>();
            toAddress.addAll(getActiveUsersFromGroup('C_M_Team'));
            System.debug('toAddress--'+toAddress);
            
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setTemplateId(et.Id);
            //toAddress = new List<Id>();
            //toAddress.add('0051s000003W3rbAAC');//prashant.b@techmatrixconsulting.com
            mail.setToAddresses(toAddress);

            mail.setSubject(et.subject);
            String strEmailBody;
            System.debug('strEmailBody--'+strEmailBody);
            String DuplicateClientLink = URL.getSalesforceBaseURL().toExternalForm() + '/' + String.valueOf(DuplicateClientId);
            String OriginalClientLink = URL.getSalesforceBaseURL().toExternalForm() + '/' + String.valueOf(OriginalClientId);

            strEmailBody = et.HTMLValue.replace('{DuplicateClientLink}', DuplicateClientLink);
            strEmailBody = strEmailBody.replace('{OriginalClientLink}', OriginalClientLink);
            System.debug('strEmailBody--'+strEmailBody);
            mail.setHTMLBody(strEmailBody);
            
            if (!toAddress.isEmpty()) {
                mail.setTargetObjectId(toAddress[0]);
            }
            List<OrgWideEmailAddress> orgWideEmails =  [SELECT Id, Address, DisplayName FROM OrgWideEmailAddress WHERE DisplayName = 'Linkreta' LIMIT 1];
            if(orgWideEmails != null){
                mail.setOrgWideEmailAddressId(orgWideEmails[0].Id);
            }
            mail.setWhatId(DuplicateClientId);
            mail.setTreatTargetObjectAsRecipient(false);
            mail.setSaveAsActivity(false);
            mail.setUseSignature(false);
            List<Messaging.SingleEmailMessage> allmsg = new List<Messaging.SingleEmailMessage>();
            allmsg.add(mail);
            
            try {
                Account_Requests__c objRequest = new Account_Requests__c();
                objRequest.Client__c = DuplicateClientId;
                objRequest.Reason_Description__c = 'This is a Duplicate Client, the Original Client Name is: ' + originalClientQueried.Name;
                objRequest.Requested_By__c = UserInfo.getUserId();
                objRequest.Requested_Date_Time__c = System.Now();
                objRequest.Status__c = 'Submitted';
                objRequest.Type__c = 'Greylist Account';
                insert objRequest;
                    
                Messaging.sendEmail(allmsg,true);
                return 'Success';
            } catch (Exception e) {
                System.debug(e.getMessage());
                System.debug(e.getLineNumber());
                return 'Error';
            }  
        }
        
        // Added By Prashant on 03Apr2024 as per Phase-1 Changes
        @AuraEnabled
        public static String sendEmailAsNoDataFound(Id clientId) {
            
            Account clientQueried = [SELECT Id, Name FROM Account WHERE Id =: clientId];
            EmailTemplate et = [SELECT Id,Subject, HTMLValue ,DeveloperName FROM EmailTemplate Where DeveloperName = 'Client_No_data_received_from_CapIQ_and_MCA'];
            List<OrgWideEmailAddress> orgWideEmails = [SELECT Id, Address, DisplayName FROM OrgWideEmailAddress WHERE DisplayName = 'Linkreta' LIMIT 1];
            List<string> toAddress = new List<string>();
            toAddress.addAll(getActiveUsersFromGroup('C_M_Team'));
            System.debug('toAddress--'+toAddress);
            
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setTemplateId(et.Id);
            //toAddress = new List<Id>();
            //toAddress.add('0051s000003W3rbAAC');//prashant.b@techmatrixconsulting.com
            if(orgWideEmails != null){
                mail.setOrgWideEmailAddressId(orgWideEmails[0].Id);
            }
            mail.setToAddresses(toAddress);

            mail.setSubject(et.subject);
            String strEmailBody;
            System.debug('strEmailBody--'+strEmailBody);
            String clientLink = URL.getSalesforceBaseURL().toExternalForm() + '/' + String.valueOf(clientId);

            strEmailBody = et.HTMLValue;
            strEmailBody = strEmailBody.replace('{AccountClientNo}', '{AccountClientNo}');
            strEmailBody = strEmailBody.replace('{AccountCompany}', clientQueried.Name);
            strEmailBody = strEmailBody.replace('{AccountLink}', clientLink);
            System.debug('strEmailBody--'+strEmailBody);
            mail.setHTMLBody(strEmailBody);
            
            if (!toAddress.isEmpty()) {
                mail.setTargetObjectId(toAddress[0]);
            }
            
            mail.setTreatTargetObjectAsRecipient(false);
            mail.setWhatId(clientId);
            mail.setSaveAsActivity(false);
            mail.setUseSignature(false);
            List<Messaging.SingleEmailMessage> allmsg = new List<Messaging.SingleEmailMessage>();
            allmsg.add(mail);
            
            try {
                Messaging.sendEmail(allmsg,true);
                Account clientObj = new Account();
                clientObj.Id = clientId;
                clientObj.External_Database_Source__c = ConstantUtility.NoneOfThem_ExternalDataSource;
                Update clientObj;
                return 'Success';
            } catch (Exception e) {
                System.debug(e.getMessage());
                System.debug(e.getLineNumber());
                return 'Error';
            }  
        }
        
        
        // Added By Prashant on 22Mar2024 as per Phase-1 Changes
        public static List<Id> getActiveUsersFromGroup(String grpDeveloperName) {
            List<Id> lstUsersToReturn = new List<Id>();
            Set<Id> lstUsers = new Set<Id>();
            List<GroupMember> lstMembers = [SELECT Id, GroupId, UserOrGroupId FROM GroupMember where Group.DeveloperName =: grpDeveloperName]; //'C_M_Team'
            for(GroupMember member : lstMembers) {
                if(String.ValueOf(member.UserOrGroupId).startsWith('005')) {
                    lstUsers.add(member.UserOrGroupId);
                }
            }
            System.debug('lstUsers--'+lstUsers);

            //HARDCODED USER NAMES
            // TEMPORARY
            List<User> lstUsersQueried = [Select Id, Name FROM User WHERE Id IN: lstUsers AND IsActive = true];
            System.debug('lstUsersQueried--'+lstUsersQueried);
            for(User usr : lstUsersQueried) {
                lstUsersToReturn.add(usr.Id);
            }
            return lstUsersToReturn;
        }
    public class CAPIQ_Information{
        @AuraEnabled
        public String clientNewIqWrapperObj;
        @AuraEnabled
        public String registeredCompanyName;
        @AuraEnabled
        public String error;
    }
    
}