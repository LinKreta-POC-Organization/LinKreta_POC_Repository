import { LightningElement, api, track } from 'lwc';
import FORM_FACTOR from '@salesforce/client/formFactor'

export default class MultiSelectPicklist extends LightningElement {
    @api picklistOptions = [];
    @track selectedValues = [];
    @api desktop;
    // @track selectedValuesString = '';

    handleMultiSelect(event) {

        try {
            this.selectedValues = event.detail.value;
            console.log('Selected values in multiplicklist comp : ', JSON.stringify(this.selectedValues));

            let selectedOptions =[];
            event.detail.value.forEach(option => {
                let currentOption = this.picklistOptions.find( o => o.value === option);
                console.log('currentOption : ' , currentOption.label);
                selectedOptions.push(currentOption.label);
            });

            let selectedValuesString = selectedOptions.join(';');
            console.log('selectedValuesString ', selectedValuesString);
            this.dispatchEvent(new CustomEvent('select', { detail: {'selectedValues' : this.selectedValues, 'selectedValuesString' : selectedValuesString} }));
        } catch (error) {
            console.log('HandleMultiSelect error : ', error);
        }

    }

    connectedCallback() {
        this.removeLegendStyling();
        console.log('desktop : ' , this.desktop);
    }

    removeLegendStyling() {
        const dualListbox = this.template.querySelector('lightning-dual-listbox');
        console.log('dualListbox : ' + JSON.stringify(dualListbox));
        if (dualListbox) {
            const dualListboxEl = dualListbox.shadowRoot.querySelector('.slds-form-element__legend');
            if (dualListboxEl) {
                dualListboxEl.classList.remove('slds-form-element__legend');
            }
        }
    }

}