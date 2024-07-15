@isTest
private class MCAWrapperForClosingPriceTest {

    @isTest
    static void testParsing() {
        // Create a sample JSON string for testing
        String sampleJson = '{ "statusCode": 200, "requestId": "123", "result": [ { "noOfShares": "100", "netTurnover": "500", "isin": "XYZ123", "dateOfTrading": "2023-12-12", "sourceUri": "example.com", "lastPrice": "50", "securityId": "1", "lowPrice": "45", "highPrice": "55", "closingPrice": "48", "securityType": "Stock", "name": "Example Stock", "instrument": "Equity", "openingPrice": "49", "securityCode": "ABC123", "timestamp": "1639296000", "noOfTrades": "50", "securityGroup": "Group A", "tdcloindi": "true", "kid": "456", "previousClosingPrice": "47" } ] }';

        // Parse the sample JSON string
        MCAWrapperForClosingPrice parsedData = MCAWrapperForClosingPrice.parse(sampleJson);

        // Perform assertions to validate the parsing
        System.assertEquals(200, parsedData.statusCode);
        System.assertEquals('123', parsedData.requestId);
        System.assertEquals(1, parsedData.result.size());
        MCAWrapperForClosingPrice.Result result = parsedData.result[0];
        System.assertEquals('100', result.noOfShares);
        System.assertEquals('500', result.netTurnover);
        // Add more assertions for other fields as needed
    }
}