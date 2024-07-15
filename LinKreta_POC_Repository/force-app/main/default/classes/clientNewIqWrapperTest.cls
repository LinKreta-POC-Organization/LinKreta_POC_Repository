@isTest
private class clientNewIqWrapperTest {

    @isTest
    static void testClientNewIqWrapperParsing() {
        //Valid JSON
        String jsonString = '{"GDSSDKResponse":[{"Function":"TestFunction","Mnemonic":"TestMnemonic","NumCols":3,"NumRows":2,"ErrMsg":null,' +
            '"CacheExpiryTime":null,"Headers":["Header1","Header2"],"Identifier":"TestIdentifier","StartDate":"2023-01-01","Seniority":null,' +
            '"Frequency":"Monthly","SnapType":null,"Limit_Z":"10","Rows":[{"Row":["Value1","Value2","Value3"]},{"Row":["Value4","Value5","Value6"]}],'+
            '"Properties":{"endrank":"EndRankValue","startrank":"StartRankValue"},"EndDate":"2023-12-31"}]}';
        clientNewIqWrapper wrapper = clientNewIqWrapper.parse(jsonString);
        System.assertNotEquals(null, wrapper.GDSSDKResponse, 'GDSSDKResponse should not be null');
        System.assertEquals(1, wrapper.GDSSDKResponse.size(), 'GDSSDKResponse list size should be 1');
        clientNewIqWrapper.GDSSDKResponse firstResponse = wrapper.GDSSDKResponse[0];
        System.assertEquals('TestFunction', firstResponse.Function, 'Function should be "TestFunction"');
        System.assertEquals('TestMnemonic', firstResponse.Mnemonic, 'Mnemonic should be "TestMnemonic"');
        System.assertEquals('EndRankValue', firstResponse.Properties.endrank, 'EndRankValue should be set in Properties_Z');
        System.assertEquals('StartRankValue', firstResponse.Properties.startrank, 'StartRankValue should be set in Properties_Z');

        //JSON with missing optional properties
        String jsonStringMissingOptional = '{"GDSSDKResponse":[{"Function":"TestFunction","Mnemonic":"TestMnemonic","NumCols":3,"NumRows":2,"ErrMsg":null,' +
            '"Identifier":"TestIdentifier","StartDate":"2023-01-01","Frequency":"Monthly","Limit_Z":"10","Rows":[{"Row":["Value1","Value2","Value3"]},{"Row":["Value4","Value5","Value6"]}],'+
            '"Properties":{"endrank":"EndRankValue"},"EndDate":"2023-12-31"}]}';
        clientNewIqWrapper wrapperMissingOptional = clientNewIqWrapper.parse(jsonStringMissingOptional);

        //JSON with unexpected property values
        String jsonStringUnexpectedValues = '{"GDSSDKResponse":[{"Function":null,"Mnemonic":123,"NumCols":3,"NumRows":2,"ErrMsg":true,' +
            '"CacheExpiryTime":123,"Headers":["Header1",123],"Identifier":true,"StartDate":null,"Seniority":123,' +
            '"Frequency":true,"SnapType":123,"Limit_Z":false,"Rows":[{"Row":["Value1",123,true]},{"Row":["Value4","Value5","Value6"]}],'+
            '"Properties":{"endrank":true,"startrank":null},"EndDate":123}]}';
        clientNewIqWrapper wrapperUnexpectedValues = clientNewIqWrapper.parse(jsonStringUnexpectedValues);

        //JSON with missing required properties
        String jsonStringMissingRequired = '{}';
        clientNewIqWrapper wrapperMissingRequired = clientNewIqWrapper.parse(jsonStringMissingRequired);

         //Test parsing of Properties_Y
        String jsonStringPropertiesY = '{"asofdate":"2023-01-01","endrank":"5","currencyid":"USD","currencyconversionmodeid":"Mode1","startrank":"1"}';
        clientNewIqWrapper.Properties_Y propertiesY = new clientNewIqWrapper.Properties_Y(JSON.createParser(jsonStringPropertiesY));
        System.assertEquals('2023-01-01', propertiesY.asofdate, 'asofdate should be "2023-01-01"');

        //Test parsing of Properties_X
        String jsonStringPropertiesX = '{"enddate":"2023-12-31","keydevfilter":"Filter1","startdate":"2023-01-01"}';
        clientNewIqWrapper.Properties_X propertiesX = new clientNewIqWrapper.Properties_X(JSON.createParser(jsonStringPropertiesX));
        System.assertEquals('2023-12-31', propertiesX.enddate, 'enddate should be "2023-12-31"');
        

        //Test parsing of Properties_Z
        String jsonStringPropertiesZ = '{"periodtype":"Type1"}';
        clientNewIqWrapper.Properties_Z propertiesZ = new clientNewIqWrapper.Properties_Z(JSON.createParser(jsonStringPropertiesZ));
        System.assertEquals('Type1', propertiesZ.periodtype, 'periodtype should be "Type1"');
    }
}