/* 
     Written By: Bhanwar Singh
     Created Date: 15-03-23
     Last Modified By : 
     Last Modified Date : 15-03-23
     Description : This class is used to create the Error Log For all the Exception occurred in the System.
     Variable Used : - 
      debugMessages : - List of Messages Recieved From Flow 
      className :- Apex Class Name in which exception occurred 
      methodName : - Apex Method/ Function Name in which exception occurred
      recordReference : - Record Id on which error has occurred
      requestBody : - Request Body sent from apex class
      responseBody : - Response recived by API callout
      endPointURL : - API callout url
*/
public without sharing  class ErrorLogCreater_cls {
    // This Method is used for Exception occurred in Flow
    
    /**
    * @description 
    * @author Biplow Sarkar | 16-08-2023 
    * @param debugMessages 
    **/
    @InvocableMethod(label='Log Debug Message' description='Outputs messages to the debug log')
    public static void flowDebugLogger (List<String> debugMessages) {
        try{
            List<ErrorLog__c> errorList = new List<ErrorLog__c>();
            for(String message : debugMessages){
                ErrorLog__c err = new ErrorLog__c();
                err.ExceptionMessage__c = message;
                err.ErrorAPI__c = true;
                errorList.add(err);
            } 
            System.debug('Limits  ');
            insert errorList;
        }
        Catch(Exception e){
            ErrorLogCreater_cls.apexDebugLogger(e, 'ErrorLog' , 'flowDebugLogger' , '' );
        }
    }

    /**
    * @description | This Method is used for all exception occurred in Apex Class except Apex class having API callout
    * @author Biplow Sarkar | 13-06-2023 
    * @param e 
    * @param className 
    * @param methodName 
    * @param recordReference 
    **/
    public static void apexDebugLogger(Exception e, String className , String methodName , String recordReference ){
        try{
            ErrorLog__c err = new ErrorLog__c();
            err.NameofArtifact__c = className;
            err.ExceptionMessage__c = 'Error Message: '+ e.getMessage()+' | Stack Trace: '+ e.getStackTraceString(); //SFDC-[U_224]: code is added by Biplow sarkar | 19-06-2023
            err.ExceptionType__c = e.getTypeName();
            err.MethodName__c = methodName;
            if(!String.isEmpty(recordReference)) {
             err.SFDCRecordReference__c = recordReference;
            }
            err.ErrorAPI__c = true;
            insert err;
        }
        Catch(Exception ex){
            System.debug('Error: ErrorLog>>apexDebugLogger>>'+ex);
        }
    }

    /**
    * @description This Method is used for all exception occurred in Apex Class with API callout
    * @author Biplow Sarkar | 16-08-2023 
    * @param ex 
    * @param className 
    * @param methodName 
    * @param recordReference 
    * @param requestBody 
    * @param responseBody 
    * @param endPointURL 
    **/
    public static void apexDebugLoggerForAPICallout(Exception ex, String className , String methodName , String recordReference , String requestBody , String responseBody, String endPointURL){
        try{
            ErrorLog__c err = new ErrorLog__c();
            List<Attachment> attachmentList = new List<Attachment>();
            err.NameofArtifact__c = className;
            if(ex !=null){
                err.ExceptionMessage__c = 'Error Message: '+ ex.getMessage()+' | Stack Trace: '+ ex.getStackTraceString(); 
                err.ExceptionType__c = ex.getTypeName();
            } 
            err.Service_Name__c = methodName;
            err.MethodName__c = methodName;
            err.SFDCRecordReference__c = recordReference;
            /*  if(requestBody.length() > 131072){
                requestBody = requestBody.substring(0, 131070);
            }
            if(responseBody.length() > 131072){
                responseBody = responseBody.substring(0, 131070);
            } */
           // err.RequestBody__c = requestBody;
           // err.Response_Body__c = responseBody;
            err.URL__c = endPointURL;
            err.ErrorAPI__c = false;
            insert err;
            
            if(String.isNotEmpty(requestBody)){
                Attachment attachment = new Attachment();
                attachment.Body = Blob.valueOf(requestBody);
                attachment.Name = String.valueOf('request.txt');
                attachment.ParentId = err.Id; 
                attachmentList.add(attachment);
            }
           
            if(String.isNotEmpty(responseBody)){
                Attachment attachment = new Attachment();
                attachment.Body = Blob.valueOf(responseBody);
                attachment.Name = String.valueOf('response.txt');
                attachment.ParentId = err.Id; 
                attachmentList.add(attachment);
            }
            
            if(attachmentList.size()>0){
                insert attachmentList;
            }

        }
        Catch(Exception e){
         ErrorLogCreater_cls.apexDebugLogger(e, 'ErrorLog' , 'apexDebugLoggerForAPICallout' , recordReference );
        }
    }
    
}