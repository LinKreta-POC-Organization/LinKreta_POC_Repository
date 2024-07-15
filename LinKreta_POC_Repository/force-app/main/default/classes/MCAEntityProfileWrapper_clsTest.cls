@isTest
private class MCAEntityProfileWrapper_clsTest {
    @isTest
    static void testParse() {
        String json = '{"requestId": "123456", "statusCode": 200, "result": {"company": {"whetherListedOrNot": "Yes", "category": "Category1", "registeredAddress": "Address1", "rocCode": "ROCCODE123", "subcategory": "Subcategory1", "emailId": "example@example.com", "suspendedAtStockExchange": "No", "dateOfBalanceSheet": "2023-01-01", "cin": "CIN123", "alternativeAddress": "AlternateAddress1", "status": "Active", "dateOfLastAGM": "2022-12-31", "entityClass": "EntityClass1", "entityName": "EntityName1", "paidUpCapital": "100000", "authorisedCapital": "500000", "numberOfMembers": "50", "registrationNumber": "Reg123", "dateOfIncorporation": "2020-01-01", "industry": "Industry1", "subIndustry": "SubIndustry1", "activityGroup": "ActivityGroup1", "activityClass": "ActivityClass1", "activitySubClass": "ActivitySubClass1"}, "charges": [{"chargeId": "Charge1", "assetsUnderCharge": "Assets1", "chargeAmount": "20000", "dateOfCreation": "2023-02-01", "dateOfModification": "2023-02-15", "status": "Active", "srn": "SRN123", "chargeHolderName": "Holder1", "dateOfSatisfaction": null, "address": "Address2"}], "directors": [{"din": "DIN123", "pan": "PAN123", "dob": "1990-01-01", "fatherName": "Father1", "name": "Director1", "designation": "CEO", "tenureBeginDate": "2022-01-01", "address": "DirectorAddress1", "tenureEndDate": null}]}}';

        MCAEntityProfileWrapper_cls obj = MCAEntityProfileWrapper_cls.parse(json);

        System.assertEquals('123456', obj.requestId);
        System.assertEquals(200, obj.statusCode);
        System.assertNotEquals(null, obj.result);
        System.assertNotEquals(null, obj.result.company);
        System.assertNotEquals(null, obj.result.charges);
        System.assertNotEquals(null, obj.result.directors);

        // Add more assertions as needed to validate the parsed object's properties
        // For example:
        System.assertEquals('Yes', obj.result.company.whetherListedOrNot);
        System.assertEquals('Category1', obj.result.company.category);
        System.assertEquals('Address1', obj.result.company.registeredAddress);
        // ... and so on
    }
}