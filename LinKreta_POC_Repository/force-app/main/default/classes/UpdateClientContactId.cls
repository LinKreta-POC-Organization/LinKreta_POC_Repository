@RestResource(urlMapping='/updateClientContactId/*')
Global With Sharing class UpdateClientContactId{
    @HTTPPUT
    global static string doPut(){
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
                List<Contact> contactRecord = [Select Id,WCGTId__c From Contact Where Id =: data.SFDCRecordID Limit 1];
                
                if(contactRecord.size()<1)
                {
                    return 'The SFDC Record ID is Invalid';
                }
                else
                {
                    contactRecord[0].WCGTId__c = data.WCGTId;
                    update contactRecord;
                    
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