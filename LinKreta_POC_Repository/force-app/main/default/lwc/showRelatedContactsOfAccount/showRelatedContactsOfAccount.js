import { LightningElement, api, track } from 'lwc';
import fetchRecords from '@salesforce/apex/ReusableLookupController.fetchRecords';
import RecentRecords from '@salesforce/apex/ReusableLookupController.RecentRecords';
const DELAY = 500;
export default class ShowRelatedContactsOfAccount extends LightningElement {


    /** The delay used when debouncing event handlers before invoking Apex. */


@api balnkContact(){
    console.log('this.objectApiName '+this.objectApiName);
    if(this.objectApiName == 'Contact'){
        this.selectedRecordName ='';
        this.selectedRecordId = '';
    }
}
@api recordId ;
   @api helpText ;
    @api label ;
    @api required;
    @api selectedIconName;
    @api objectLabel;
    
    recordsList = [];
    @api selectedRecordName;


    @api objectApiName ;
    @api fieldApiName ;
    @api otherFieldApiName;
    @api searchString = "";
    @api selectedRecordId ;
    @api parentRecordId;
    @api parentFieldApiName;
    @api relatedId ;
    @api keyAccountId;

    preventClosingOfSerachPanel = false;

    get methodInput() {
        return {
            objectApiName: this.objectApiName,
            fieldApiName: this.fieldApiName,
            otherFieldApiName: this.otherFieldApiName,
            searchString: this.searchString,
            selectedRecordId: this.selectedRecordId,
            parentRecordId: this.parentRecordId,
            parentFieldApiName: this.parentFieldApiName
            
        };
    }

    get showRecentRecords() {
        if (!this.recordsList) {
            return false;
        }
        return this.recordsList.length > 0;
    }

    //getting the default selected record
    connectedCallback() {
        console.log('RecordIdd>>',this.recordId);
        console.log('keyAccountId'+this.keyAccountId);
        console.log('inside connected callback' + this.selectedRecordName);
        if (this.selectedRecordId) {
            this.fetchSobjectRecords(true);
            //this.fetchSobjectRecentRecords(true);
        }
        
    }

    fetchSobjectRecentRecords() {
        console.log('fetchSobjectRecentRecords callback' + this.relatedId);
        RecentRecords({ inputWrapper: this.methodInput , accId : this.relatedId , keyAccountId : this.keyAccountId}).then(result => {
            if (result) {
                this.recordsList = JSON.parse(JSON.stringify(result));
               
            }
        }).catch(error => {
            console.log(error);
        })
        console.log('recordsList',this.recordsList);
    }

    //call the apex method
    fetchSobjectRecords(loadEvent) {
        fetchRecords({
            inputWrapper: this.methodInput , accId : this.relatedId , keyAccountId : this.keyAccountId
        }).then(result => {
           // if (loadEvent && result) {
            //    this.selectedRecordName = result[0].mainField;
           // }
            if (result) {
                this.recordsList = JSON.parse(JSON.stringify(result));
            } else {
                this.recordsList = [];
            }
        }).catch(error => {
            console.log(error);
        })
    }

    get isValueSelected() {
        return this.selectedRecordId;
    }

    //handler for calling apex when user change the value in lookup
    handleChange(event) {
        console.log('handleChange in '+this.relatedId);
        this.searchString = event.target.value;
        this.fetchSobjectRecords(true);
    }

    handleClick(){
        if(!this.selectedRecordId){
            console.log('inside else');
            this.fetchSobjectRecentRecords(true);
        }
    }
    //handler for clicking outside the selection panel
    handleBlur() {
        this.recordsList = [];
        this.preventClosingOfSerachPanel = false;
    }

    //handle the click inside the search panel to prevent it getting closed
    handleDivClick() {
        this.preventClosingOfSerachPanel = true;
        console.log('inside pannel')
    }

    //handler for deselection of the selected item
    handleCommit() {
        this.selectedRecordId = "";
        this.selectedRecordName = "";
        const selectedEvent = new CustomEvent('valueselected', {
            
            detail:  { relatedId : this.selectedRecordId, type: this.objectApiName, selectedName : this.selectedRecordName }
        });
        this.dispatchEvent(selectedEvent);
    }

    //handler for selection of records from lookup result list
    handleSelect(event) {
        let selectedRecord = {
            mainField: event.currentTarget.dataset.mainfield,
            subField: event.currentTarget.dataset.subfield,
            id: event.currentTarget.dataset.id
        };
        this.selectedRecordId = selectedRecord.id;
        //this.realtedId = this.selectedRecordId;
        this.selectedRecordName = selectedRecord.mainField;
        console.log('this.selectedRecordName '+this.selectedRecordName);
        this.recordsList = [];
        // Creates the event
        const selectedEvent = new CustomEvent('valueselected', {
            
            detail:  { relatedId : this.selectedRecordId, type: this.objectApiName, selectedName : this.selectedRecordName }
        });
        //dispatching the custom event
        this.dispatchEvent(selectedEvent);
    }
    // validate 
//     @api validate() {
//   if(this.selectedRecordId) {
//     console.log('inside validate');
//     console.log(this.selectedRecordId);
//     return { isValid: true };
//     }
//   else {
//     // If the component is invalid, return the isValid parameter
//     // as false and return an error message.
//     return {
//       isValid: false,
//       errorMessage: '/*A message that explains what went wrong.*/'
//     };
//   }
// }

    //to close the search panel when clicked outside of search input
    handleInputBlur(event) {
        // Debouncing this method: Do not actually invoke the Apex call as long as this function is
        // being called within a delay of DELAY. This is to avoid a very large number of Apex method calls.
        window.clearTimeout(this.delayTimeout);
        // eslint-disable-next-line @lwc/lwc/no-async-operation
        this.delayTimeout = setTimeout(() => {
            if (!this.preventClosingOfSerachPanel) {
                this.recordsList = [];
            }
            this.preventClosingOfSerachPanel = false;
        }, DELAY);
    }

}