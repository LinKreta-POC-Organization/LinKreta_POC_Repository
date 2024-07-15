import { LightningElement, api,track } from 'lwc';
import getFiles from '@salesforce/apex/FileUploadComponentController.getFiles';
import {NavigationMixin} from 'lightning/navigation'
export default class FileViewComponent extends NavigationMixin(LightningElement) {
    @api selectedRecordId;
    @track contentVersion;
    connectedCallback(){
        if(this.selectedRecordId){
            getFiles({publishLocationId:this.selectedRecordId})
            .then((result) => {
                this.contentVersion  =result;
                console.log('=====this.contentVersion  '+JSON.stringify(this.contentVersion));
            }).catch((error) => {
                
                console.log('error  ',error)
            })
        }
    }
    viewHandleClick(event){
        let contentVersionId =event.currentTarget.dataset.id;
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
}