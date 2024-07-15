@isTest
private class CurrencyConversionWCGT_clsTest {
    @isTest
    static void testcurrencyCode() {
        Test.setMock(HttpCalloutMock.class, new CurrencyConversionWCGTMockCallout());
        Currency_Code__c currency_codeObj = new Currency_Code__c(
            Name = 'RS',
            CurrencyIsoCode = 'INR',
            Currency_Code__c = 'CU000001',
            Currency_Name__c = 'Indian Rupee');
        insert currency_codeObj;
        
        List<Currency_Code__c> currencyId = new List<Currency_Code__c>();
        currencyId.add(currency_codeObj);
        
        CurrencyConversionWCGT_cls.currencyCode(currencyId);
        
    }
    
    @isTest
    static void testGetCurrencyRate() {
        Test.setMock(HttpCalloutMock.class, new CurrencyConversionWCGTMockCallout());
        Currency_Code__c currency_codeObj = new Currency_Code__c(
            Name = 'RS',
            CurrencyIsoCode = 'INR',
            Currency_Code__c = 'CU000001',
            Currency_Name__c = 'Indian Rupee');
        insert currency_codeObj;
        
        List<Currency_Code__c> currencyId = new List<Currency_Code__c>();
        currencyId.add(currency_codeObj);
        
        CurrencyConversionWCGT_cls.getCurrencyRate(currency_codeObj);
    }
    
     @isTest
    static void testUpdateCurrency() {
        Test.setMock(HttpCalloutMock.class, new CurrencyConversionWCGTMockCallout());
        Currency_Code__c currency_codeObj = new Currency_Code__c(
            Name = 'RS',
            CurrencyIsoCode = 'INR',
            Currency_Code__c = 'CU000001',
            Currency_Name__c = 'Indian Rupee');
        insert currency_codeObj;
        
        List<Currency_Code__c> currencyId = new List<Currency_Code__c>();
        currencyId.add(currency_codeObj);
        
        HttpResponse res = new HttpResponse();
        res.setStatus('OK');
        res.setStatusCode(200);
        res.setBody('{"rates":"82","up_Date":"20-20-2023"}');
        
        CurrencyConversionWCGT_cls.updateCurrency(currency_codeObj,res);
    }
    
}