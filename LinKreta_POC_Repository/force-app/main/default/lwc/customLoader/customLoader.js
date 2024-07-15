import { LightningElement, api } from 'lwc';

export default class CustomLoader extends LightningElement {
    @api sprinnerText ='';
    @api size='medium';// small, medium,large
    @api variant = 'base';//base;brand,inverse
    
    get helpText(){
        return this.sprinnerText ? this.sprinnerText : 'Loading......';
    }

}