public class capIQButtontoUpdateClientMCA {
    @AuraEnabled
        public static Boolean updateNewClientMCA(Id recordId , String mcaId , String mcaName, String entityId)
        {
            Lead lead = [SELECT Name,Company,MCA_ID__c, EntityId__c,External_Database_Source__c,Currency_Format__c,Company_Status__c,Website,Board_of_Directors__c,Email,Industry_CAP_IQ_MCA__c,Public_Private_Company__c,Global_Ultimate_Owner__c,ISIN_Number__c,Domestic_Ultimate_Owner__c,Country_of_Incorporation__c,Ticker_Symbol__c
                         ,EBITDA__c,Earnings_Before_Interest_and_Taxes_EBIT__c,Total_Revenue__c,Total_Liabilities__c,Total_Current_Liabilities__c,Total_Equity__c,Total_Current_Assets__c,capIQId__c,CEO_Name__c,Chairman_Name__c,Client_Group_Name_CIQID__c, Client_Group_Name__c , ClientBackground__c ,Company_Website__c  , Financial_Year__c , KMP__c ,Stock_Exchange_symbol__c,Total_No_of_employees__c From Lead Where Id = :recordId];
            lead.MCA_ID__c = mcaId;
            lead.Company = mcaName;
            lead.External_Database_Source__c = 'MCA';
            lead.EntityId__c = entityId;
            List<String> result = newClientDataFromMCA.newClientCompanySearchEnityData(mcaId);
            if(result.size()>22){
                        lead.CompanyHQ__City__s = result[16];
                        lead.CompanyHQ__Street__s = result[0];
                        lead.CompanyHQ__PostalCode__s = result[18];
                        lead.Company_Status__c = result[1];
                        lead.Ticker_Symbol__c = result[2];
                        lead.Country_of_Incorporation__c =result[3];
                        lead.Domestic_Ultimate_Owner__c = result[4];
                        lead.ISIN_Number__c = result[5];
                        lead.Global_Ultimate_Owner__c = result[6];
                        lead.Year_Founded__c = result[7];
                        lead.Public_Private_Company__c = result[8];
                        lead.Listed__c= result[9];
                        lead.Industry_CAP_IQ_MCA__c = result[10];
                        lead.NewClientEmail__c = result[11];
                        lead.Company_Phone_No__c = result[12];
                        lead.Board_of_Directors__c = result[13];
                        lead.Website = result[15];
                        lead.Financial_Year__c = result[14];
                        lead.KMP__c = result[19];
                        lead.CEO_Name__c = result[20];
                        lead.Chairman_Name__c = result[21];
                        if(result[22]!=''){
                            lead.Closing_Price__c = Decimal.valueOf(result[22]);
                        }
                        else{
                            lead.Closing_Price__c =0;
                        }
            }
            else{
                        lead.CompanyHQ__City__s='';
                        lead.CompanyHQ__Street__s='';
                        lead.CompanyHQ__PostalCode__s='';
                        lead.Company_Status__c='';
                        lead.Ticker_Symbol__c='';
                        lead.Country_of_Incorporation__c='';
                        lead.Domestic_Ultimate_Owner__c='';
                        lead.ISIN_Number__c='';
                        lead.Global_Ultimate_Owner__c='';
                        lead.Year_Founded__c='';
                        lead.Public_Private_Company__c='';
                        lead.Listed__c='';
                        lead.Industry_CAP_IQ_MCA__c='';
                        lead.NewClientEmail__c='';
                        lead.Company_Phone_No__c='';
                        lead.Board_of_Directors__c='';
                        lead.Website='';
                        lead.Financial_Year__c='';
                        lead.KMP__c='';
                        lead.CEO_Name__c='';
                        lead.Chairman_Name__c='';
                        lead.Closing_Price__c=0;
            }
            if(entityId!=''){
                capIQButtontoUpdateClientMCA.newClientCompanySearchFinanceData(recordId,entityId);
                capIQButtontoUpdateClientMCA.newClientCompanySearchCorpFinanceData(recordId,entityId);
            }
            
            lead.capIQId__c = '';
            lead.CEO_Name__c = '';
            lead.Chairman_Name__c = '';
            lead.Client_Group_Name_CIQID__c = '';
            lead.Client_Group_Name__c = '';
            lead.ClientBackground__c = ' ';
            lead.Company_Website__c = ' ';
            lead.Currency_Format__c = 'INR';
            lead.Financial_Year__c = System.Label.MCAFinancialYear;
            lead.KMP__c = '';
            lead.Total_No_of_employees__c = ' ';
            lead.Stock_Exchange_symbol__c = ' ';
            update lead;
            return true;
        }
    @Future(callout=true)
    public static void newClientCompanySearchFinanceData(Id recordId, String mcaId){
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        MCA__mdt  entitySearch = [SELECT x_karza_key__c, URL__c ,Label FROM MCA__mdt Where Label = 'Financial Summary' Limit 1];
        req.setEndpoint(entitySearch.URL__c);
        
        List<Lead> lead = new List<Lead>([SELECT Name,Company,MCA_ID__c,Gross_Profit__c, Net_Income__c,EntityId__c,External_Database_Source__c,Currency_Format__c,Company_Status__c,Website,Board_of_Directors__c,Email,Industry_CAP_IQ_MCA__c,Public_Private_Company__c,Global_Ultimate_Owner__c,ISIN_Number__c,Domestic_Ultimate_Owner__c,Country_of_Incorporation__c,Ticker_Symbol__c
                         ,EBITDA__c,Earnings_Before_Interest_and_Taxes_EBIT__c,Total_Revenue__c,Total_Liabilities__c,Total_Current_Liabilities__c,Total_Equity__c,Total_Current_Assets__c,capIQId__c,CEO_Name__c,Chairman_Name__c,Client_Group_Name_CIQID__c, Client_Group_Name__c , ClientBackground__c ,Company_Website__c  , Financial_Year__c , KMP__c ,Stock_Exchange_symbol__c,Total_No_of_employees__c From Lead Where Id = :recordId Limit 1]);
            
        req.setMethod('POST');
        req.setHeader('Content-Type','application/json');
        req.setHeader('x-karza-key',entitySearch.x_karza_key__c);
        string fyearMCA = System.Label.MCAFinancialYear;
        String reqBody = '{"consent":"Y","entityId":"'+mcaId+'","financialYear":["'+fyearMCA+'"],"financialType":"both"}';
        req.setBody(reqBody);
        try{
        HttpResponse resp = http.send(req);        
        // InputRequests respoApex=(InputRequests) System.JSON.deserialize(resp.getBody(), InputRequests.class);
        System.debug('resp.getBody() --->'+resp.getBody());
        mcaFinanceWrapper respoApex=(mcaFinanceWrapper) System.JSON.deserialize(resp.getBody(), mcaFinanceWrapper.class);
        System.debug(respoApex.Result.Standalone[0].Data.CurrentFinancialSummary.IncomeState.profitLoss);
        List<String> listCorpFinance = new List<String>();
        String profitLoss = respoApex.Result.Standalone[0].Data.CurrentFinancialSummary.IncomeState.profitLoss;
        String ebit = respoApex.Result.Standalone[0].Data.CurrentFinancialSummary.IncomeState.ebit;
        String ebitda = respoApex.Result.Standalone[0].Data.CurrentFinancialSummary.IncomeState.ebitda;
        String revenuefromOperations = respoApex.Result.Standalone[0].Data.CurrentFinancialSummary.IncomeState.revenuefromOperations;
        
            if(profitLoss!=Null){
                lead[0].Gross_Profit__c = decimal.valueOf(profitLoss);
                //listCorpFinance.add(profitLoss);
            }
            else{
                lead[0].Gross_Profit__c = 0;
                listCorpFinance.add('0');
            }
            if(ebit!=Null){
                 lead[0].Earnings_Before_Interest_and_Taxes_EBIT__c= decimal.valueOf(ebit);
                
            }else{
                
            }
            if(ebitda!=Null){
                lead[0].EBITDA__c = decimal.valueOf(ebitda);
            }else{
                listCorpFinance.add('0');
            }
            if(revenuefromOperations!=Null){
                lead[0].Net_Income__c = decimal.valueOf(revenuefromOperations);
                listCorpFinance.add(revenuefromOperations);
            }else{
                lead[0].Net_Income__c=0;
                listCorpFinance.add('0');
            }
        
        }
        catch(Exception e){

        }
        
        update lead;
        //return listCorpFinance;
    }
    @Future(callout=true)
    public static void newClientCompanySearchCorpFinanceData(Id recordId, String mcaId){
            List<Lead> lead = new List<Lead>([SELECT Name,Company,MCA_ID__c, EntityId__c,External_Database_Source__c,Currency_Format__c,Company_Status__c,Website,Board_of_Directors__c,Email,Industry_CAP_IQ_MCA__c,Public_Private_Company__c,Global_Ultimate_Owner__c,ISIN_Number__c,Domestic_Ultimate_Owner__c,Country_of_Incorporation__c,Ticker_Symbol__c
                         ,EBITDA__c,Earnings_Before_Interest_and_Taxes_EBIT__c,Total_Revenue__c,Total_Liabilities__c,Total_Current_Liabilities__c,Total_Equity__c,Total_Current_Assets__c,capIQId__c,CEO_Name__c,Chairman_Name__c,Client_Group_Name_CIQID__c, Client_Group_Name__c , ClientBackground__c ,Company_Website__c  , Financial_Year__c , KMP__c ,Stock_Exchange_symbol__c,Total_No_of_employees__c From Lead Where Id = :recordId Limit 1]);
            
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        String reqBody='';
        String responseBody='';
        MCA__mdt  entitySearch = [SELECT x_karza_key__c, URL__c ,Label FROM MCA__mdt Where Label = 'Corp Financial Data' Limit 1];
        List<String> listCorpFinance = new List<String>();
        try {
            req.setEndpoint(entitySearch.URL__c);
            req.setMethod('POST');
            req.setHeader('Content-Type','application/json');
            req.setHeader('x-karza-key',entitySearch.x_karza_key__c);
            string fyearMCA = System.Label.MCAFinancialYear;
            reqBody = '{"entityId":"'+mcaId+'","financialYear":["'+fyearMCA+'"],"financialType":"both","noOfYearsToMerge":"1","consent":"y"}';
            req.setBody(reqBody);
            System.debug(reqBody);
            HttpResponse resp = http.send(req);        
            // InputRequests respoApex=(InputRequests) System.JSON.deserialize(resp.getBody(), InputRequests.class);
            System.debug('resp.getBody() --->'+resp.getBody());
            responseBody = resp.getBody();
            if(String.isNotBlank(responseBody)){
                mcaCorpFinanceWrapper respoApex=(mcaCorpFinanceWrapper) System.JSON.deserialize(resp.getBody(), mcaCorpFinanceWrapper.class);
        
            System.debug(respoApex.Result.Financial[0].Data.Current.BalanceSheet.Assets.totalAssets);
            String totalAssets = respoApex.Result.Financial[0].Data.Current.BalanceSheet.Assets.totalAssets;
            String totalCurrentAssets = respoApex.Result.Financial[0].Data.Current.BalanceSheet.Assets.totalCurrentAssets;
            String currentLiabilties = respoApex.Result.Financial[0].Data.Current.BalanceSheet.EquityLiabilities.currentLiabilties;
            String nonCurrentFinancialLiabilities = respoApex.Result.Financial[0].Data.Current.BalanceSheet.EquityLiabilities.nonCurrentFinancialLiabilities;
            String totalEquity = respoApex.Result.Financial[0].Data.Current.BalanceSheet.EquityLiabilities.totalEquity;
            String totalLiabilities = respoApex.Result.Financial[0].Data.Current.BalanceSheet.EquityLiabilities.totalLiabilities;
            String totalDilutedEarningsLossPerShare = respoApex.Result.Financial[0].Data.Current.ProfitAndLoss.totalDilutedEarningsLossPerShare;
            String totalRev = respoApex.Result.Financial[0].Data.Current.ProfitAndLoss.Revenue.totalRev;
            if(totalAssets!=''){
                lead[0].Total_Assets__c = decimal.valueOf(totalAssets);
                    
            }
            else{
                listCorpFinance.add('');
            }
            if(totalCurrentAssets!=''){
                lead[0].Total_Current_Assets__c = decimal.valueOf(totalCurrentAssets);
            }
            else{
                listCorpFinance.add('');
            }
            if(currentLiabilties!=''){
                lead[0].Total_Current_Liabilities__c = decimal.valueOf(currentLiabilties);
            }
            else{
                listCorpFinance.add('');
            }
            if(nonCurrentFinancialLiabilities!=''){
                lead[0].Total_Debt__c = decimal.valueOf(nonCurrentFinancialLiabilities);
                listCorpFinance.add(nonCurrentFinancialLiabilities);
            }
            else{
                listCorpFinance.add('');
            }
            if(totalEquity!=''){
                lead[0].Total_Equity__c = decimal.valueOf(totalEquity);
            }
            else{
                listCorpFinance.add('');
            }if(totalLiabilities!=''){
                lead[0].Total_Liabilities__c = decimal.valueOf(totalEquity);
                
            }
            else{
                listCorpFinance.add('');
            }if(totalDilutedEarningsLossPerShare!=''){
                lead[0].Total_Diluted_Earning_Loss_per_Share__c = decimal.valueOf(totalDilutedEarningsLossPerShare);
                listCorpFinance.add(totalDilutedEarningsLossPerShare);
            }
            else{
                listCorpFinance.add('');
            }if(totalRev!=''){
                lead[0].Total_Revenue__c = decimal.valueOf(totalEquity);
            }
            else{
                listCorpFinance.add('');
            }
            System.debug(listCorpFinance);

            }
            
            ErrorLogCreater_cls.apexDebugLoggerForAPICallout(null,'newClientDataFromMCA','CorpFinancialData',null,reqBody,responseBody,entitySearch.URL__c);
        }
        catch(Exception ex){
            ErrorLogCreater_cls.apexDebugLoggerForAPICallout(ex,'newClientDataFromMCA','newClientCompanySearchCorpFinanceData',null,reqBody,responseBody,entitySearch.URL__c);
        }
        update lead;
        //return listCorpFinance;
    }
   

    @AuraEnabled
    public static string updateAcountFromMCA(Id recordId , String mcaId, String registeredCompanyName){
        try {
            String resultSuccess= 'Success';
            Boolean manualClient = false;
            Account acc =[SELECT Id, EntityId__c,Ticker_Symbol__c,Country_of_Incorporation__c,Global_Ultimate_Owner__c,Website,Earnings_Before_Interest_and_Taxes_EBIT__c,EBITDA__c,Total_Assets__c,Total_Current_Assets__c,Total_Equity__c,Total_Current_Liabilities__c,Total_Liabilities__c,Total_Revenue__c,Domestic_Ultimate_Owner__c,
            Industry_CAP_IQ_MCA__c,ISIN_Number__c,Email__c,Company_Status__c,Public_Private_Company__c, MCA_ID__c, IsNameChange__c FROM Account
             WHERE Id =:recordId];
            
            if(String.isBlank(acc.MCA_ID__c)) {
                manualClient = true;
                System.debug('@@registeredCompanyName--'+registeredCompanyName);
                acc.Name = registeredCompanyName;
            }
            acc.MCA_ID__c = mcaId; // Added By Prashant on 22Mar2024 as per Phase-1 Changes
            acc.External_Database_Source__c = 'MCA'; // Added By Prashant on 22Mar2024 as per Phase-1 Changes
            
            List<String> result = newClientDataFromMCA.newClientCompanySearchEnityData(mcaId);
            System.debug('result   :  '+result);
            for(String s: result) {
                System.debug('s--'+s);
            }
            if(result.size()>1){
                acc.Public_Private_Company__c = result[1];
                acc.Ticker_Symbol__c = result[2] == null ? '': result[2];
                acc.Country_of_Incorporation__c =result[3] == null ? '': result[3];
                acc.Domestic_Ultimate_Owner__c = result[4] == null ? '': result[4];
                acc.ISIN_Number__c = result[5] == null ? '': result[5];
                acc.Global_Ultimate_Owner__c = result[6] == null ? '': result[6];
                acc.Public_Private_Company__c = result[8] == null ? '': result[8];
                acc.Industry_CAP_IQ_MCA__c = result[9] == null ? '': result[9];
                //System.debug('result[10]--'+result[10]);
               // acc.Email__c = result[10];// Commented By Prashant as Email is present at result[11]
                acc.Email__c = result[11] == null ? '': result[11];
                //acc.Website = result[13];
                acc.Company_Status__c = result[1] == null ? '': result[1];
            }
            
            if(acc.EntityId__c != null && acc.EntityId__c !=''){
                capIQButtontoUpdateClientMCA.updateAccountCompanySearchFinanceData(recordId,acc.EntityId__c);
                capIQButtontoUpdateClientMCA.updateAccountCompanySearchCorpFinanceData(recordId,acc.EntityId__c);
               /* List<String> result2 = newClientDataFromMCA.newClientCompanySearchFinanceData(acc.EntityId__c);
                if(result2.size()>1){
                    acc.Earnings_Before_Interest_and_Taxes_EBIT__c= result2[1];
                    acc.EBITDA__c = decimal.valueOf(result2[2]);
                }
                List<String> result3 = newClientDataFromMCA.newClientCompanySearchCorpFinanceData(acc.EntityId__c);
                if(result3.Size()>1){
                    acc.Total_Assets__c =decimal.valueOf(result3[0]);
                    acc.Total_Current_Assets__c =decimal.valueOf(result3[1]);
                    acc.Total_Equity__c =decimal.valueOf(result3[4]);
                    acc.Total_Current_Liabilities__c =decimal.valueOf(result3[2]);
                    acc.Total_Liabilities__c =decimal.valueOf(result3[5]);
                    acc.Total_Revenue__c =decimal.valueOf(result3[7]);
                }*/
            }
            
            if(! manualClient) {
                update acc;                    
            } else {
                UpdateClientName.updateName(acc);
            }
            
            System.debug('**acc   :  '+acc);
            return resultSuccess;
        } catch (Exception e) {
            System.debug('**error   :  '+e);
            throw new AuraHandledException(e.getMessage());
        }
    }
    @Future(callout=true)
    public static void updateAccountCompanySearchFinanceData(Id recordId, String mcaId){
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        MCA__mdt  entitySearch = [SELECT x_karza_key__c, URL__c ,Label FROM MCA__mdt Where Label = 'Financial Summary' Limit 1];
        req.setEndpoint(entitySearch.URL__c);
        
        List<Account> acc =[SELECT Id, EntityId__c,Ticker_Symbol__c,Country_of_Incorporation__c,Global_Ultimate_Owner__c,Website,Earnings_Before_Interest_and_Taxes_EBIT__c,EBITDA__c,Total_Assets__c,Total_Current_Assets__c,Total_Equity__c,Total_Current_Liabilities__c,Total_Liabilities__c,Total_Revenue__c,Domestic_Ultimate_Owner__c,
        Industry_CAP_IQ_MCA__c,ISIN_Number__c,Email__c,Company_Status__c,Public_Private_Company__c FROM Account WHERE Id =:recordId];

        req.setMethod('POST');
        req.setHeader('Content-Type','application/json');
        req.setHeader('x-karza-key',entitySearch.x_karza_key__c);
        string fyearMCA = System.Label.MCAFinancialYear;
        String reqBody = '{"consent":"Y","entityId":"'+mcaId+'","financialYear":["'+fyearMCA+'"],"financialType":"both"}';
        req.setBody(reqBody);
        try{
        HttpResponse resp = http.send(req);        
        // InputRequests respoApex=(InputRequests) System.JSON.deserialize(resp.getBody(), InputRequests.class);
        System.debug('resp.getBody() --->'+resp.getBody());
        mcaFinanceWrapper respoApex=(mcaFinanceWrapper) System.JSON.deserialize(resp.getBody(), mcaFinanceWrapper.class);
        System.debug(respoApex.Result.Standalone[0].Data.CurrentFinancialSummary.IncomeState.profitLoss);
        List<String> listCorpFinance = new List<String>();
        String profitLoss = respoApex.Result.Standalone[0].Data.CurrentFinancialSummary.IncomeState.profitLoss;
        String ebit = respoApex.Result.Standalone[0].Data.CurrentFinancialSummary.IncomeState.ebit;
        String ebitda = respoApex.Result.Standalone[0].Data.CurrentFinancialSummary.IncomeState.ebitda;
        String revenuefromOperations = respoApex.Result.Standalone[0].Data.CurrentFinancialSummary.IncomeState.revenuefromOperations;
        
            if(profitLoss!=Null){
                listCorpFinance.add(profitLoss);
            }
            else{
                listCorpFinance.add('0');
            }
            if(ebit!=Null){
                acc[0].Earnings_Before_Interest_and_Taxes_EBIT__c=decimal.valueOf(ebit);
                
            }else{
                
            }
            if(ebitda!=Null){
                acc[0].EBITDA__c = decimal.valueOf(ebitda);
            }else{
                listCorpFinance.add('0');
            }
            if(revenuefromOperations!=Null){
                listCorpFinance.add(revenuefromOperations);
            }else{
                listCorpFinance.add('0');
            }
        
        }
        catch(Exception e){

        }
        
        update acc;
        //return listCorpFinance;
    }
    @Future(callout=true)
    public static void updateAccountCompanySearchCorpFinanceData(Id recordId, String mcaId){
        List<Account> acc =[SELECT Id, EntityId__c,Ticker_Symbol__c,Country_of_Incorporation__c,Global_Ultimate_Owner__c,Website,Earnings_Before_Interest_and_Taxes_EBIT__c,EBITDA__c,Total_Assets__c,Total_Current_Assets__c,Total_Equity__c,Total_Current_Liabilities__c,Total_Liabilities__c,Total_Revenue__c,Domestic_Ultimate_Owner__c,
        Industry_CAP_IQ_MCA__c,ISIN_Number__c,Email__c,Company_Status__c,Public_Private_Company__c FROM Account WHERE Id =:recordId];

        Http http = new Http();
        HttpRequest req = new HttpRequest();
        String reqBody='';
        String responseBody='';
        MCA__mdt  entitySearch = [SELECT x_karza_key__c, URL__c ,Label FROM MCA__mdt Where Label = 'Corp Financial Data' Limit 1];
        List<String> listCorpFinance = new List<String>();
        try {
            req.setEndpoint(entitySearch.URL__c);
            req.setMethod('POST');
            req.setHeader('Content-Type','application/json');
            req.setHeader('x-karza-key',entitySearch.x_karza_key__c);
            string fyearMCA = System.Label.MCAFinancialYear;
            reqBody = '{"entityId":"'+mcaId+'","financialYear":["'+fyearMCA+'"],"financialType":"both","noOfYearsToMerge":"1","consent":"y"}';
            req.setBody(reqBody);
            System.debug(reqBody);
            HttpResponse resp = http.send(req);        
            // InputRequests respoApex=(InputRequests) System.JSON.deserialize(resp.getBody(), InputRequests.class);
            System.debug('resp.getBody() --->'+resp.getBody());
            responseBody = resp.getBody();
            if(String.isNotBlank(responseBody)){
                mcaCorpFinanceWrapper respoApex=(mcaCorpFinanceWrapper) System.JSON.deserialize(resp.getBody(), mcaCorpFinanceWrapper.class);
        
            System.debug(respoApex.Result.Financial[0].Data.Current.BalanceSheet.Assets.totalAssets);
            String totalAssets = respoApex.Result.Financial[0].Data.Current.BalanceSheet.Assets.totalAssets;
            String totalCurrentAssets = respoApex.Result.Financial[0].Data.Current.BalanceSheet.Assets.totalCurrentAssets;
            String currentLiabilties = respoApex.Result.Financial[0].Data.Current.BalanceSheet.EquityLiabilities.currentLiabilties;
            String nonCurrentFinancialLiabilities = respoApex.Result.Financial[0].Data.Current.BalanceSheet.EquityLiabilities.nonCurrentFinancialLiabilities;
            String totalEquity = respoApex.Result.Financial[0].Data.Current.BalanceSheet.EquityLiabilities.totalEquity;
            String totalLiabilities = respoApex.Result.Financial[0].Data.Current.BalanceSheet.EquityLiabilities.totalLiabilities;
            String totalDilutedEarningsLossPerShare = respoApex.Result.Financial[0].Data.Current.ProfitAndLoss.totalDilutedEarningsLossPerShare;
            String totalRev = respoApex.Result.Financial[0].Data.Current.ProfitAndLoss.Revenue.totalRev;
            if(totalAssets!=''){
                acc[0].Total_Assets__c = decimal.valueOf(totalAssets);
                    
            }
            else{
                listCorpFinance.add('');
            }
            if(totalCurrentAssets!=''){
                acc[0].Total_Current_Assets__c = decimal.valueOf(totalCurrentAssets);
            }
            else{
                listCorpFinance.add('');
            }
            if(currentLiabilties!=''){
                acc[0].Total_Current_Liabilities__c = decimal.valueOf(currentLiabilties);
            }
            else{
                listCorpFinance.add('');
            }
            if(nonCurrentFinancialLiabilities!=''){
                listCorpFinance.add(nonCurrentFinancialLiabilities);
            }
            else{
                listCorpFinance.add('');
            }
            if(totalEquity!=''){
                acc[0].Total_Equity__c = decimal.valueOf(totalEquity);
            }
            else{
                listCorpFinance.add('');
            }if(totalLiabilities!=''){
                acc[0].Total_Liabilities__c = decimal.valueOf(totalEquity);
                
            }
            else{
                listCorpFinance.add('');
            }if(totalDilutedEarningsLossPerShare!=''){
                listCorpFinance.add(totalDilutedEarningsLossPerShare);
            }
            else{
                listCorpFinance.add('');
            }if(totalRev!=''){
                acc[0].Total_Revenue__c = decimal.valueOf(totalEquity);
            }
            else{
                listCorpFinance.add('');
            }
            System.debug(listCorpFinance);

            }
            
            ErrorLogCreater_cls.apexDebugLoggerForAPICallout(null,'newClientDataFromMCA','CorpFinancialData',null,reqBody,responseBody,entitySearch.URL__c);
        }
        catch(Exception ex){
            ErrorLogCreater_cls.apexDebugLoggerForAPICallout(ex,'newClientDataFromMCA','newClientCompanySearchCorpFinanceData',null,reqBody,responseBody,entitySearch.URL__c);
        }
        update acc;
        //return listCorpFinance;
    }
    //Added by Deepak Joshi
    @AuraEnabled
    public static string getCapiqRegisteredCompanyMCA(String mcaId){
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        String reqBody='';
        String responseBody='';
        MCA__mdt  entitySearch = [SELECT x_karza_key__c, URL__c ,Label FROM MCA__mdt Where Label = 'Entity Search API' Limit 1];
        List<String> listCorpFinance = new List<String>();
        try {
            System.debug('mcaId ==='+ mcaId);
            req.setEndpoint(entitySearch.URL__c);
            req.setMethod('POST');
            req.setHeader('Content-Type','application/json');
            req.setHeader('x-karza-key',entitySearch.x_karza_key__c);
            reqBody = '{"id":"'+mcaId+'","filter":{"name":"","email":"","domain":"","domainSearch":false,"address":"","contact":"","fatherName":"","dateOfInception":""},"entitySearch":true,"nameMatch":true,"nameMatchThreshold":true,"temporaryKid":false,"sources":[]}';
            req.setBody(reqBody);
            System.debug('reqBody ==='+ reqBody);
            HttpResponse resp = http.send(req);        
            // InputRequests respoApex=(InputRequests) System.JSON.deserialize(resp.getBody(), InputRequests.class);
            System.debug('resp.getBody() --->'+resp.getBody());
            if(resp.getStatusCode() != 200){
                String result = 'ERROR '+resp.getStatus() +' Status Code '+resp.getStatusCode();
                return result;
            }
            responseBody = resp.getBody();
            if(String.isNotBlank(responseBody)){
                 mcaEntitySearchWrapperMain respoApex=(mcaEntitySearchWrapperMain) System.JSON.deserialize(resp.getBody(), mcaEntitySearchWrapperMain.class);
                if(respoApex !=null && respoApex.result !=null &&  respoApex.result.size()>0){
                    return respoApex.result[0].name;
                }
            }
            ErrorLogCreater_cls.apexDebugLoggerForAPICallout(null,'newClientDataFromMCA','getCapiqRegisteredCompanyMCA',null,reqBody,responseBody,entitySearch.URL__c);
            return null;
        }
        catch(Exception ex){
            ErrorLogCreater_cls.apexDebugLoggerForAPICallout(ex,'newClientDataFromMCA','getCapiqRegisteredCompanyMCA',null,reqBody,responseBody,entitySearch.URL__c);
            System.debug('Error occured2 '+ex.getMessage()+' '+ex.getLineNumber());
            throw new AuraHandledException(ex.getMessage());
        }
    }
    
}