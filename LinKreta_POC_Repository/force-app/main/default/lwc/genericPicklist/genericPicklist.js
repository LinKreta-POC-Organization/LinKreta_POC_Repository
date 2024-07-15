import { LightningElement, track, wire, api } from 'lwc';
import Objects_Type from "@salesforce/apex/GenericPicklistController.PicklistValues";

export default class GenericPicklist extends LightningElement {
    @track ListAllypes;
    @track TypeOptions;

    @api objAPIName;
    @api fieldAPIName;
    @api label;
    @api value;
    @api disable;
    @api required = false;
    @api name;

    @wire(Objects_Type, { objectname: '$objAPIName', fieldname: '$fieldAPIName' })
    WiredObjects_Type({ error, data }) {

        if (data) {
            try {
                this.ListAllypes = data;
                let options = [];

                for (var key in data) {
                    // Here key will have index of list of records starting from 0,1,2,....
                    options.push({ label: data[key].picklistlabel, value: data[key].picklistvalue });

                }

                this.TypeOptions = options;

            } catch (error) {
                //console.error('check error here @', error);
            }
        } else if (error) {
            //console.error('check error here', error);
        }
    }

    handleTypeChange(event) {
        try {
            var Picklist_Value = event.target.value;
            const selectedEvent = new CustomEvent("picklistchange", {
                detail: Picklist_Value
            });
            this.dispatchEvent(selectedEvent);
        }
        catch (error) {
            console.log('Error in dispatching event generic picklist : ', error);
        }
    }
}