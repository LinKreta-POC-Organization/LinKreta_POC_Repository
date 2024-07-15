@isTest
private class MCACorpInvestorWrapper_clsTest {
    @isTest
    static void testParse() {
        String json = '{"requestId": "123456", "statusCode": 200, "result": {"shareHolders": [{"din": "DIN123", "pan": "PAN123", "name": "Shareholder1", "percentageOfHoldingByShares": "50%", "numberOfEquitySharesHeld": "1000", "metadata": {"source": "Source1", "documentName": "Document1", "dateOfFiling": "2023-01-01", "finYearStartDate": "2022-04-01", "finYearEndDate": "2023-03-31", "docId": "Doc123"}, "address": "Address1", "cin": "CIN123", "percentageOfHoldingByVotes": "60%"}], "companyName": "ABC Corp", "entityId": "Entity123", "lastDownloaded": "2023-12-01"}}';

        MCACorpInvestorWrapper_cls obj = MCACorpInvestorWrapper_cls.parse(json);

        System.assertEquals('123456', obj.requestId);
        System.assertEquals(200, obj.statusCode);
        System.assertNotEquals(null, obj.result);
       /* System.assertNotEquals(null, obj.result.shareHolders);
        System.assertEquals('ABC Corp', obj.result.companyName);
        
        // Add more assertions as needed to validate the parsed object's properties
        // For example:
        System.assertEquals('DIN123', obj.result.shareHolders[0].din);
        System.assertEquals('PAN123', obj.result.shareHolders[0].pan);
        System.assertEquals('Shareholder1', obj.result.shareHolders[0].name);
        System.assertEquals('50%', obj.result.shareHolders[0].percentageOfHoldingByShares);
        // ... and so on*/
    }
}