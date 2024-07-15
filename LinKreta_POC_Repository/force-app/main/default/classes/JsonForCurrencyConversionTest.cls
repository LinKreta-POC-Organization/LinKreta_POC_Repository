@isTest
private class JsonForCurrencyConversionTest {

    // Test method to cover JSON parsing
    @isTest
    static void testJsonParsing() {
        // Create a sample JSON string for testing
        String sampleJson = '{"data":[{"rates":"1.23","up_Date":"2023-12-18"}]}';

        // Parse the JSON string using the class method
        JsonForCurrencyConversion_cls parsedData = JsonForCurrencyConversion_cls.parse(sampleJson);

        // Perform assertions to verify the parsing
        System.assertEquals(1, parsedData.data.size(), 'Data size should be 1');
        System.assertEquals('1.23', parsedData.data[0].rates, 'Rates should match');
        System.assertEquals('2023-12-18', parsedData.data[0].up_Date, 'Update date should match');
    }
}