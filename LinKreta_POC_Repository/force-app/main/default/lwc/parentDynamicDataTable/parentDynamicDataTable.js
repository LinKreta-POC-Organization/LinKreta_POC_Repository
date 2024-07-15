import { LightningElement,api} from 'lwc';
export default class ParentDynamicDataTable extends LightningElement {
     @api ApiNameOfObject ;
    @api ApiNameOfRelatedObject;
    @api SubTitle;
    @api ApiNamesOfField ;
    @api WhereClause;
    @api displayDataTable = false;
    @api recordId;
    @api ControllingField;
     @api Width;
    @api Height;

connectedCallback() {
    //code
    console.log('object',this.ApiNameOfObject);
        console.log('fields',this.ApiNamesOfField);
        console.log('related',this.ApiNameOfRelatedObject);

         if (this.ApiNameOfObject && this.ApiNamesOfField) {
            this.displayDataTable = true;
        } else {
            this.displayDataTable = false;
        }

}
    handleObjectApiNameChange(event) {
        this.ApiNameOfObject = event.target.value;
    }

    handleFieldApiNamesChange(event) {
        this.ApiNamesOfField = event.target.value;
    }

    handleDisplayDataTable() {
        
        if (this.ApiNameOfObject && this.ApiNamesOfField) {
            this.displayDataTable = true;
        } else {
            this.displayDataTable = false;
        }
    }
}