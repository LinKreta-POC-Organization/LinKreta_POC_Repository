import { LightningElement, api,track } from 'lwc';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import {NavigationMixin} from 'lightning/navigation'
import deleteFile from '@salesforce/apex/FileUploadComponentController.deleteFile'
import getFiles from '@salesforce/apex/FileUploadComponentController.getFiles'
export default class FileUploadComponent extends NavigationMixin(LightningElement) {
    @api selectedRecordId;
    showFileInfo =false;
    fileDeleted =false;
    uploadedFileNames;
    @api contentVersionId;
    @track filesData = [];
    isLoading = false;
    @track columns = [
        { label: 'File Name', fieldName: 'fileName' ,wrapText: true, type: 'text'},
  ];
    handleUploadFinished(event) {
        // Get the list of uploaded files
        const uploadedFiles = event.detail.files;
       this.isLoading = true
        for(let i = 0; i < uploadedFiles.length; i++) {
            this.uploadedFileNames = uploadedFiles[i].name;
            this.showFileInfo =true;
            this.contentVersionId =uploadedFiles[i].documentId
            this.filesData.push({'fileName':uploadedFiles[i].name, 'documentId':uploadedFiles[i].documentId});
        }
        this.isLoading = false;
        this.fileDeleted = false
    }
    viewHandleClick(event){
        let contentVersionId = this.filesData[event.currentTarget.dataset.id].documentId;
        this[NavigationMixin.Navigate]({ 
            type:'standard__namedPage',
            attributes:{ 
                pageName:'filePreview'
            },
            state:{ 
                selectedRecordId:  contentVersionId
            }
        })
        
    }
    deletehandleClick(event){
        var index = event.currentTarget.dataset.id;
       let contentVersionId =  this.filesData[index].documentId;
        this.isLoading = true
        deleteFile({contentDocumentId:contentVersionId })
        .then((result) => {
            if(result){
                this.filesData.splice(index, 1);
                if(this.filesData.length == 0){
                    this.showFileInfo = false;
                    this.contentVersionId =null;
                    this.fileDeleted = true;
                }
            }
           this.isLoading = false;
            console.log('result  ',result);
        }).catch((error) => {
            this.isLoading = false;
            console.log('error  ',error)
        })

    }
    connectedCallback(){
        if(this.selectedRecordId){
            getFiles({publishLocationId:this.selectedRecordId})
            .then((result) => {
                if(result.length > 0){
                    for(let i = 0; i < result.length; i++) {
                        //this.uploadedFileNames = uploadedFiles[i].name;
                        this.showFileInfo =true;
                        this.contentVersionId =result[i].ContentDocumentId
                        this.filesData.push({'fileName':result[i].Title, 'documentId':result[i].ContentDocumentId});
                    }
                    
                }
                console.log('=====this.result  '+JSON.stringify(result));
            }).catch((error) => {
                
                console.log('error  ',error)
            })
        }
    }
}