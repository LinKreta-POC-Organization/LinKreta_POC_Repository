@RestResource(urlMapping='/updateClientId/*')
Global With Sharing class UpdateClientId{
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
                 List<Account> accountRecord = [Select Id,WCGTId__c From Account Where Id =: data.SFDCRecordID Limit 1];
                
				if(accountRecord.size()<1)
				{
					return 'The SFDC Record ID is Invalid';
                }
				else
				{
					accountRecord[0].WCGTId__c = data.WCGTId;
					update accountRecord;
					
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