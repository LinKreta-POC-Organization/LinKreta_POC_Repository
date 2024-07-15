@isTest
public class FileUploadComponentControllerTest {
    @testSetup static void dataCreation() {
        Lead leadRecord = TestDataFactory.createLeadRecord();
        Insert leadRecord;
        
        ContentVersion cv = new ContentVersion();
        cv.Title = 'Test Document';
        cv.PathOnClient = 'TestDocument.pdf';
        cv.VersionData = Blob.valueOf('Test Content');
        cv.FirstPublishLocationId =leadRecord.Id;
        cv.IsMajorVersion = true;
        Insert cv;
        
        
    }
    @isTest Static void testFileUpload(){
        ContentVersion recCV = [Select id,FirstPublishLocationId, Title,ContentDocumentId From ContentVersion];
        //ContentDocument recDoc = [SELECT Id FROM ContentDocument WHERE ContentDocumentLinkID = recCV.Id];
        FileUploadComponentController.getFiles(recCV.FirstPublishLocationId);
        FileUploadComponentController.deleteFile(recCV.ContentDocumentId);
    }
}