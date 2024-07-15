/**
 * @description      :
 * @author           : Mohd Sameer Salmani
 * @group            :
 * @last modified on : 06-12-2022
 * @last modified by : Mohd Sameer Salmani
 **/
import { LightningElement, api } from 'lwc';

import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import {
    FlowAttributeChangeEvent,
    FlowNavigationNextEvent,
    FlowNavigationFinishEvent,
} from 'lightning/flowSupport';

export default class ShowToastMessage extends LightningElement {
    @api message
    @api variant
    @api mode
    @api isloaded = false

    connectedCallback() {
        this.showToast();
    }

    showToast(){
        if(! this.isloaded){
            this.isloaded = true;
        const toastEvent = new ShowToastEvent({
            title: 'Record Saved!',
            mode: 'dismissable',
            message: this.message,
            variant: this.variant
        });
        

        if(this.message == 'Greylist Account request initiated'){
        this.dispatchEvent(toastEvent);
        const navigateNextEvent = new FlowNavigationFinishEvent();
        this.dispatchEvent(navigateNextEvent);
        }

        else{
        this.dispatchEvent(toastEvent);
        const navigateNextEvent = new FlowNavigationNextEvent();
        this.dispatchEvent(navigateNextEvent);
        }
        
       }
    }
}