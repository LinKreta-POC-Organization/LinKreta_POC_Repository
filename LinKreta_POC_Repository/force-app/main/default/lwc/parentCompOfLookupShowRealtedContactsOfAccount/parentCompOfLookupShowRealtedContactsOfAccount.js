import { LightningElement ,api} from 'lwc';

export default class ParentCompOfLookupShowRealtedContactsOfAccount extends LightningElement {

    @api recordId ;
    @api accWrapper ;
    @api contWrapper ;
    @api contactId;
    @api accountId;
    @api keyAccountId;
    connectedCallback(){
      console.log('recordIdd',this.recordId);
      console.log('keyAccountId'+this.keyAccountId);
       this.accWrapper = {
            otherFieldApiName :"Industry",
            fieldApiName : "Name",
            objectApiName : "Account",
            objectLabel : "Account",
             selectedIconName :"standard:account",
             label : "* Entity Name",
            relatedId : '',
            selected_id : '',
            selectedRecordName :'',
            keyAccountId : this.keyAccountId
           }
           this.contWrapper = {
            otherFieldApiName :"Email",
            fieldApiName : "Name",
            objectApiName : "Contact",
            objectLabel : "Contact",
             selectedIconName :"standard:contact",
             label : "Primary Client contact",
            relatedId : '',
            selected_id : '',
            selectedRecordName : '',
           }
    }
    @api validate() {
        if(this.accWrapper.selected_id) {
          console.log('inside validate');
          console.log(this.accWrapper.selected_id);
          //console.log(selectedRecordName);
          return { isValid: true };
          }
        else {
          // If the component is invalid, return the isValid parameter
          // as false and return an error message.
          return {
            isValid: false,
            errorMessage: 'Entity Name is required'
          };
        }
      }
    handleValueSelectedOnAccount(event) {
        console.log('iNN Parents');
        console.log('this.relatedId'+this.relatedId);
        console.log('event.detail.relatedId;'+event.detail.relatedId);
       var temp = this.contWrapper;
       if(event.detail.type === 'Account'){
        this.accWrapper.selected_id = event.detail.relatedId;
        temp.relatedId = event.detail.relatedId;
        this.contWrapper = JSON.parse(JSON.stringify(temp));
        this.accWrapper.selectedRecordName =event.detail.selectedName;
        this.contWrapper.selected_id = '';
        this.contWrapper.selectedRecordName ='';
        this.accountId = event.detail.relatedId;
        try{
            //this.template.querySelector('c-show-related-contacts-of-account').balnkContact();
            this.refs.contactLookup.balnkContact();
        }catch(err ){
            console.log('in err'+err);
        }

        console.log('this.contWrapper.relatedId '+this.contWrapper.relatedId);
       }else if(event.detail.type === 'Contact'){
        this.contWrapper.selected_id = event.detail.relatedId;
        this.contWrapper.selectedRecordName = event.detail.selectedName;
        this.contactId = event.detail.relatedId;
       }
       

    }
}