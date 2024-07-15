import { LightningElement, api } from 'lwc';

import { ShowToastEvent } from 'lightning/platformShowToastEvent';
export default class RedirectToRecordPage extends LightningElement {
    @api recordId;
    @api target = '_self';
    @api message;

    connectedCallback() {
        const event = new ShowToastEvent({
            title: '',
            message: this.message,
            variant: 'success',
            mode: 'dismissable'
        });
        this.dispatchEvent(event);
        setTimeout(() => {
            const completeURL = `${window.location.origin}/${this.recordId}`;
            window.open(completeURL, this.target);
        }, 3000);
    }
}