public class FileUploadComponentController {
    @AuraEnabled
    public static Boolean deleteFile(String contentDocumentId){
        try {
            Boolean isDeleted = false;
            if(contentDocumentId !=null && contentDocumentId !=''){
                ContentDocument contentDocumentObj =[SELECT Id FROM ContentDocument WHERE Id =:contentDocumentId];
                delete contentDocumentObj;
                isDeleted = true;
            }
             
            return isDeleted;
        } catch (Exception e) {
            System.debug('error == '+e.getLineNumber());
            throw new AuraHandledException(e.getMessage());
        }
    }
    @AuraEnabled
    public static List<ContentVersion> getFiles(String publishLocationId){
       List<ContentVersion> contentVersionList =[SELECT Id,FirstPublishLocationId, Title,ContentDocumentId FROM ContentVersion WHERE FirstPublishLocationId =:publishLocationId];
    return contentVersionList;
    }
    
}