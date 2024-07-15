@RestResource(urlMapping='/updateEnquiryId/*')
Global With Sharing class UpdateEnquiryId{
    @HTTPPUT
    global static string doPut()
    {
        try
        {
            RestRequest req = RestContext.request;
            blob body = req.requestBody;
            String RequestString = body.toString();
            JsonParser data = parse(RequestString);
            if(data.SFDCRecordID == Null || data.SFDCRecordID == '' || data.WCGTId == Null || data.WCGTId == '')
            {
                if(data.SFDCRecordID == Null || data.SFDCRecordID == '')
                {
                    return 'The SFDC Record ID cannot be Blank or Empty';
                }
                else
                {
                    return 'The WCGT ID cannot be Blank or Empty';
                }
            }
            else
            {
                List<Lead> leadRecordList = [Select Id, WCGTId__c From Lead Where Id =: data.SFDCRecordID Limit 1];
                
                if(leadRecordList.size()<1)
                {
                    return 'The SFDC Record ID is Invalid';
                }
                else
                {
                    leadRecordList[0].WCGTId__c = data.WCGTId;
                    update leadRecordList;
                    
                    return 'The WCGT ID has been Successfully Updated';
                }
            }
        }
        catch(exception e)
        {
            return e.getMessage();
        }
    }
    
    public static JsonParser parse(String json)
    {
        return (JsonParser)System.JSON.deserialize(json, JsonParser.class);
    }
    
    public class JsonParser 
    {
        public String WCGTId;
        public String SFDCRecordID;        
    }
}