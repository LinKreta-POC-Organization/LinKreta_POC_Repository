/* 
     Written By: Bhanwar Singh
     Created Date: 08-05-23
     Last Modified By : 
     Last Modified Date : 22-05-23
     Description : This class is used to get Currency Rates From WCGT.
*/
public class CurrencyConversionWCGT_cls {
    @InvocableMethod(label='Call Currency Conversion Flow')
    public static List<decimal> currencyCode(List<Currency_Code__c> currencyId){
        List<decimal> rates = new List<decimal>();
        try{
            
            Currency_Code__c crr = [SELECT Name,Id, Currency_Code__c FROM Currency_Code__c Where Id =: currencyId[0].Id Limit 1];
            
                rates.add(CurrencyConversionWCGT_cls.getCurrencyRate(crr));
            
        }
        Catch(Exception e){
            
        }
        return rates;
    }
    //Added by Prashant on 19th/Jan
    @future(callout = true)
    public static void getCurrencyRateAndUpdateOnCommertialLineItem(Id crrId, Id commertialLineItemId){
        Currency_Code__c crr = [SELECT Id, Name, Currency_Code__c, Currency_Name__c, Sub_Currency_Name__c FROM Currency_Code__c where Id =: crrId];
        decimal rate = getCurrencyRate(crr);
        QuoteLineItem obj = new QuoteLineItem();
        obj.Id = commertialLineItemId;        
        obj.ConversionRate__c = rate;
        update obj;
    }
    public static decimal getCurrencyRate(Currency_Code__c crr){
        decimal rate;
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        WCGTEndPoint__mdt wcgtCrr = [SELECT Id, MasterLabel, URL__c FROM WCGTEndPoint__mdt Where Label = 'Currency' limit 1];
        String reqBody = '{"sCurrencyID":"'+crr.Currency_Code__c+'"}';
        try{
            req.setEndpoint(wcgtCrr.URL__c);
            System.debug(reqBody + '   ' + wcgtCrr.URL__c);
            req.setMethod('POST');
            String token = SalesforceToWCGTAccess.getAuthenticationToken();
        	req.setHeader('Authorization','Bearer '+token);
            req.setHeader('Content-Type','application/json'); 
            req.setTimeout(30000);
            req.setBody(reqBody);
            System.debug(reqBody);
            HttpResponse resp = http.send(req);
            System.debug(resp.getBody());
            rate = CurrencyConversionWCGT_cls.updateCurrency(crr, resp);
            
        }
        Catch(Exception e){
            ErrorLogCreater_cls.apexDebugLoggerForAPICallout(e,'CurrencyConversionWCGT_cls','getCurrencyRate','',reqBody,'',wcgtCrr.URL__c);
        }
        return rate;
    }
    public static decimal updateCurrency(Currency_Code__c crr, HttpResponse resp){
        Decimal rates;
        try{
            
            JsonForCurrencyConversion_cls respoApex=(JsonForCurrencyConversion_cls) System.JSON.deserialize(resp.getBody(), JsonForCurrencyConversion_cls.class);
            rates = decimal.valueOf(respoApex.Data[0].rates);
            
            
        }
        catch(Exception e){
            
        }
        return rates;
    }
    
    
}