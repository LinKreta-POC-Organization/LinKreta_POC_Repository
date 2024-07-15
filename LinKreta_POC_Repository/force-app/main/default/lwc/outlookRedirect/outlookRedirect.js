import { LightningElement, api,track } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';

export default class OutlookRedirect extends NavigationMixin(LightningElement) {
@api prop2;
@api prop1;
    handleClick() {
        
        this[NavigationMixin.Navigate]({
            type: 'standard__webPage',
            attributes: {
                //url: 'ms-outlook://'
             //url: 'ms-outlook://events'
           // url: 'mailto:email'
           url: 'webcal://'
            }
        });
        
    }

}