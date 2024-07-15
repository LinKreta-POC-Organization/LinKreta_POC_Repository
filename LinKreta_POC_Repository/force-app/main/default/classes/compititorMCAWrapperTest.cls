@isTest
private class compititorMCAWrapperTest {

    @isTest
    static void testParseMethod() {
        // Create a sample JSON string to simulate the data
        String sampleJSON = '{"requestId": "12345", "statusCode": 200, "result": {"records": [{"kid": "1", "name": "Company A", "entityId": "C123", "employeeCount": "100", "peerMetric": "Metric A", "metadata": {"finyrEnddate": "2023-12-31"}, "businessActivity": [{"description": "Activity 1", "code": "A1", "percentageTurnover": "30"}], "currentFinancialSummary": {"incomeState": {"ebitda": "500000", "revenueFromOperations": "1000000", "profitLoss": "200000", "ebit": "250000", "pbt": "300000", "finCost": "50000"}, "ratAnalysis": {"ebitdaMargin": "50%", "netProfitMargin": "20%", "netDebtEquity": "1.2", "interestCoverage": "5", "roce": "15%", "netOpIncGrowth": "10%", "returnOnEquity": "25%"}, "balSheet": {"totalBorr": "150000", "cashAndBank": "100000", "totalAssets": "500000", "avgCapitalEmployed": "400000", "avgEquity": "300000", "totalEquity": "350000"}}}]}}';

        // Call the parse method of compititorMCAWrapper class
        compititorMCAWrapper parsedData = compititorMCAWrapper.parse(sampleJSON);

        // Perform assertions to validate the parsing
        System.assertEquals('12345', parsedData.requestId);
        System.assertEquals(200, parsedData.statusCode);
        System.assertEquals(1, parsedData.result.records.size());
        compititorMCAWrapper.Records record = parsedData.result.records[0];
        System.assertEquals('1', record.kid);
        System.assertEquals('Company A', record.name);
        // Add more assertions for other fields as needed
    }
}