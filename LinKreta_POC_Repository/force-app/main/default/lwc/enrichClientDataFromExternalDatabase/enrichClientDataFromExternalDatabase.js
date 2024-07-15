import { LightningElement, api, track, wire } from 'lwc';

import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import { CloseActionScreenEvent } from 'lightning/actions';
const FIELDS = ['Account.capIQId__c', 'Account.Name', 'Account.External_Database_Source__c', 'Account.MCA_ID__c'];
import updateAcountFromExternal from '@salesforce/apex/capIQButtontoUpdateClient.updateAcountFromExternal';
import getCapiqRegisteredCompanyName from '@salesforce/apex/capIQButtontoUpdateClient.getCapiqRegisteredCompanyName';
import updateAcountFromMCA from '@salesforce/apex/capIQButtontoUpdateClientMCA.updateAcountFromMCA';
import getCapiqRegisteredCompanyMCA from '@salesforce/apex/capIQButtontoUpdateClientMCA.getCapiqRegisteredCompanyMCA';


import clientNewSearchByName from '@salesforce/apex/newClientByCompanyNameIQ.ClientNewSearchByName';
import clientNewSearchByNamemca from '@salesforce/apex/newClientDataFromMCA.newClientCompanySearchByName';
import clientNewTracker from '@salesforce/apex/newClientByCompanyNameIQ.clientnewSearchForLoc';

import searchClientInternally from '@salesforce/apex/capIQButtontoUpdateClient.searchClientInternally';
import sendEmailToInactivateClient from '@salesforce/apex/capIQButtontoUpdateClient.sendEmailToInactivateClient';
import sendEmailAsNoDataFound from '@salesforce/apex/capIQButtontoUpdateClient.sendEmailAsNoDataFound';


import { ShowToastEvent } from 'lightning/platformShowToastEvent';
const COLS = [

    { label: 'Name-of-Entity', fieldName: 'companyName', type: 'text', wrapText: true },
    { label: 'Location', fieldName: 'countryName', type: 'text', wrapText: true },

    { label: 'Ticker Symbol', fieldName: 'tickerSymbol', type: 'text', wrapText: true },
    {
        type: "button", typeAttributes: {
            label: 'Select',
            name: 'View',
            title: 'View',
            disabled: false,
            value: 'view',
            iconPosition: 'left'

        }
    }
];
export default class EnrichClientDataFromExternalDatabase extends LightningElement {
    @api recordId;
    capIq;
    mcaId;
    noData = false;
    isMCA = false;
    isCAPIQ = false;
    showSpinner = false;
    accountName;
    message = 'No data found';
    @track showSpinnerMassage = false;
    @track registeredCompanyName;
    @track clientNewIqWrapperObj;
    @api callFromParent(paremt1) {
        console.log('RecordId InSide LWC :', paremt1);
        this.recordId = paremt1;
    }
    show1 = false;
    @wire(getRecord, { recordId: '$recordId', fields: FIELDS })
    wiredRecord({ error, data }) {
        console.log('data : ', JSON.stringify(data));
        if (data) {
            console.log('data.fields.External_Database_Source__c.value : ', data.fields.External_Database_Source__c.value);
            console.log('data.fields.capIQId__c.value : ', data.fields.capIQId__c.value);
            if (data.fields.capIQId__c.value !== null && data.fields.External_Database_Source__c.value == 'CapIQ') {
                this.accountName = data.fields.Name.value;
                this.capIq = data.fields.capIQId__c.value;
                this.isCAPIQ = true;
                this.getRegisteredCompanyNameCAPIQ();
                this.show1 = true;
            }
            else if (data.fields.MCA_ID__c.value !== null && data.fields.External_Database_Source__c.value == 'MCA') {
                this.accountName = data.fields.Name.value;
                this.mcaId = data.fields.MCA_ID__c.value;
                this.isMCA = true;
                this.getRegisteredCompanyNameMCA();
                this.show1 = true;
            }
            else {
                //@@@this.noData=true; 
                this.notHasCapIqMCAId = true;
                this.show1 = true;
                this.searchString = data.fields.Name.value;
                this.handleCapIQCallout();

            }


        }
        else if (error) {
            console.log('Error : ', error);
            this.noData = true;
            this.message = error.body.message;
        }
    }
    // @@@ 
    notHasCapIqMCAId = false;
    //    @@@ 
    @track mapOfValuesCapIQ = [];
    // @@@ 
    @track capIQresultcounter = 0;
    //    @@@   
    @track arrDataList = [];
    // @@@
    error;
    // @@@
    searchString;
    //@@@
    capIQ;
    //    @@@ 
    async handleCapIQCallout() {
        console.log('In handle Click', this.searchString);
        try {
            await clientNewSearchByName({ searchString: this.searchString })
                .then((data) => {
                    console.log('clientNewSearchByName data--' + JSON.stringify(data));
                    if (data) {

                        let arrDataListTemp = [];
                        for (let x in data) {
                            let arrData = {};
                            arrData.Name = x;
                            arrDataListTemp.push(arrData);
                        }
                        console.log('-------> Chech Wait', this.mapOfValuesCapIQ);
                        this.arrDataList = arrDataListTemp;
                        // this.companylist = data;
                        // this.error = undefined;
                        //console.log('811 company List',JSON.stringify(this.companylist));
                        console.log('this.data.length', this.arrDataList);

                    }
                    else if (error) {

                        // this.isSearchDisabled = false;
                        this.error = error;
                        // this.companylist = 'Its';
                        if (this.arrDataList.length == 0) {
                            console.log('821 this.handleMCA');
                        }
                    }
                })


        } catch (e) {

        }
        if (this.arrDataList.length > 0) {
            console.log('-------> this.arrDataList', JSON.stringify(this.arrDataList));
            this.ifMcaCallout = false;
            for (let x in this.arrDataList) {
                this.capIQ = this.arrDataList[x].Name;
                console.log(this.arrDataList[x].Name);
                this.handletrickerCallout(this.capIQ);
            }

        } else if (this.arrDataList.length == 0) {
            console.log('this.handleMCA');
            console.log('-------> this.mapOfValuesCapIQ.length', this.mapOfValuesCapIQ.length);
            this.handleMCAClick();
            console.log('hii');
        }

    }

    // @@@ 
    @track cols = COLS;
    // @@@ 
    dataReceived = false;
    // capIqVar;
    async handletrickerCallout(capIQVar) {
        console.log('this.capIQ--' + this.capIQ);
        //this.capIqVar = JSON.stringify(this.capIQ);
        await clientNewTracker({ companyID: this.capIQ })
            .then((data) => {
                if (data) {
                    console.log('data--' + JSON.stringify(data));
                    this.mapOfValuesCapIQ.push({ companyName: data[0], countryName: data[2], tickerSymbol: data[1], key: capIQVar });
                    console.log('Waiting');
                    // debugger
                    console.log('mapOfValuesCapIQ--' + JSON.stringify(this.mapOfValuesCapIQ));
                    this.capIQresultcounter = this.capIQresultcounter + 1;
                    console.log('capIQresultcounter--' + this.capIQresultcounter);
                    console.log('arrDataList.length--' + this.arrDataList.length);
                    if (this.capIQresultcounter == this.arrDataList.length) {
                        this.dataReceived = true;
                        console.log('dataReceived--' + this.dataReceived);
                    }
                } else if (error) {

                }
            })
        console.log(this.capIQresultcounter, this.arrDataList.length);
        if (this.capIQresultcounter >= this.arrDataList.length) {
            console.log(this.capIQresultcounter == this.arrDataList.length);

            this.isSearchDisabled = false;
            this.ifData = true;
            this.externalDataSourceisCapIQ = true;
        }
    }
    // @@@ 
    noData2=false;
    handleMCAClick() {
        this.ifMcaCallout = true;
        console.log(this.searchString);
        if (this.searchString != '') {

            clientNewSearchByNamemca({ searchString: this.searchString })
                .then((data) => {
                    console.log('588 ---> ', data);
                    console.log('589 ---> ', JSON.stringify(data));
                    if (data) {
                        console.log('@@');
                        let arrDataListTemp = [];
                        for (let x in data) {
                            let arrData = {};
                            let arrname = {};
                            arrname = data[x].split('$$$$');
                            console.log('@@arrname--' + JSON.stringify(arrname));
                            this.mapOfValuesCapIQ.push({ companyName: arrname[0], countryName: arrname[1], tickerSymbol: '', key: x });
                            arrDataListTemp.push(arrData);
                            console.log('@@arrDataListTemp--' + JSON.stringify(arrDataListTemp));
                            //mp.put(x,arrData.Name);

                            //this.isSearchDisabled = false;
                        }
                        console.log('mapOfValuesCapIQ---' + JSON.stringify(this.mapOfValuesCapIQ));
                        if (this.mapOfValuesCapIQ.length > 0) {
                            this.dataReceived = true;
                        } else {
                            this.noData2 = true;
                            //this.message = 'No data found';
                        }

                    }
                    else if (error) {
                        this.error = undefined;
                    }
                }).catch((error) => {
                    console.error(error);
                })


        }
        else {
            this.ifclick = true;
        }

    }
    //@@@

    ifMcaCallout = false;
    @track clientData;
    @track ifResult;
    @track selectedCustomerName = false;
    show2 = false;
    callRowAction(event) {
        this.show2 = false;
        //console.log('capIq selected--'+event.detail.row.key);
        console.log('capIq selected--' + event.detail.row.companyName);
        this.registeredCompanyName = event.detail.row.companyName
        this.selectedCustomerName = true;
        searchClientInternally({ searchString: event.detail.row.companyName, recordId: this.recordId })
            .then((result) => {
                if (result.length > 0 && event.detail.row.companyName != '') {
                    let data = JSON.parse(JSON.stringify(result));
                    console.log('data 101--' + JSON.stringify(data));
                    for (var i = 0; i < data.length; i++) {
                        data[i].rowNumber = i + 1;
                    }
                    this.clientData = data;
                    if (this.clientData.length > 0) {
                        this.ifResult = true;
                    }
                }
                else {
                    this.enrichClientRecord = true;
                    // if (data.fields.capIQId__c.value !== null && data.fields.External_Database_Source__c.value=='CapIQ') {
                    if (this.ifMcaCallout != true) {
                        this.accountName = event.detail.row.companyName;//data.fields.Name.value;
                        this.capIq = event.detail.row.key;//data.fields.capIQId__c.value;
                        this.isCAPIQ = true;
                        this.getRegisteredCompanyNameCAPIQ();
                        console.log('ifMcaCallout--' + this.ifMcaCallout);
                        console.log('@@312');
                        /// this.giveCompany();
                        console.log('@@314');
                    }
                    else {
                        this.accountName = event.detail.row.companyName;//data.fields.Name.value;
                        var mcaArr = event.detail.row.key.split('$$$$');

                        this.mcaId = mcaArr[0];//data.fields.MCA_ID__c.value;
                        console.log('this.mcaId-----' + this.mcaId);
                        this.isMCA = true;
                        this.getRegisteredCompanyNameMCA();
                        console.log('ifMcaCallout---' + this.ifMcaCallout);
                        console.log('@@412');
                        this.giveCompany();
                        console.log('@@414');
                    }



                    this.clientData = [];
                    this.ifResult = false;
                }
                this.show2 = true;
            })
            .catch((error) => {
                console.log(error);
                this.enrichClientRecord = true;
                this.clientData = [];
                this.ifResult = false;
                this.show2 = false;
            })
    }
    @api enrichClientRecord = false;
    giveCompany() {
        console.log('--giveCompany--');
        console.log('this.isCAPIQ--' + this.isCAPIQ);
        console.log('this.clientNewIqWrapperObj--' + JSON.stringify(this.clientNewIqWrapperObj));
        this.showSpinner = true;
        if (this.isCAPIQ && this.clientNewIqWrapperObj) {
            updateAcountFromExternal({ recordId: this.recordId, capIqId: this.capIq, registeredCompanyName: this.registeredCompanyName, wrapperObj: this.clientNewIqWrapperObj })
                .then((result) => {
                    console.log('result   ', result);
                    this.showSpinner = false;
                    if (result == 'Success') {
                        this.showToast('Record updated successfully', 'success');
                        this.refreshPage();

                    }
                    else {
                        this.noData = true;
                        this.message = result;
                    }

                }).catch((error) => {
                    this.showSpinner = false;
                    console.log("95 an error has occured :  ", error);
                    this.noData = true;
                    this.message = error.body.message;
                })
        }
        if (this.isMCA) {
            updateAcountFromMCA({ recordId: this.recordId, mcaId: this.mcaId, registeredCompanyName: this.registeredCompanyName })
                .then((result) => {
                    console.log('result   ', result);
                    this.showSpinner = false;
                    if (result == 'Success') {
                        this.showToast('Record updated successfully', 'success');
                        this.refreshPage();

                    }

                }).catch((error) => {
                    this.showSpinner = false;
                    console.log("95 an error has occured :  ", error);
                    this.noData = true;
                    this.message = error.body.message;
                })
        }
    }
    refreshPage() {
        console.log('page refreshed!!1');
        this.dispatchEvent(new CloseActionScreenEvent());
        setTimeout(() => {
            eval("$A.get('e.force:refreshView').fire();");

        }, 1000);
        console.log('page refreshed!!2');
        var dataToSend = 'trnsfer';
        const sendDataEvent = new CustomEvent('callLWC', {
            detail: { dataToSend }
        });

        //Actually dispatching the event that we created above.
        this.dispatchEvent(sendDataEvent);
        console.log('page refreshed!!309');

    }
    showToast(message, variant) {
        const toastEvent = new ShowToastEvent({
            title: 'Record Saved!',
            mode: 'dismissable',
            message: message,
            variant: variant
        });
        this.dispatchEvent(toastEvent);

    }
    getRegisteredCompanyNameCAPIQ() {
        console.log('--getRegisteredCompanyNameCAPIQ--');
        this.showSpinnerMassage = true;
        getCapiqRegisteredCompanyName({ capIqId: this.capIq })
            .then((result) => {
                console.log("result::  ", result);
                if (result != null && result.registeredCompanyName != null) {
                    this.registeredCompanyName = result.registeredCompanyName;
                    this.clientNewIqWrapperObj = result.clientNewIqWrapperObj;
                    if (this.enrichClientRecord) {
                        ///@@@
                        console.log('@@418');
                        this.giveCompany();
                    }

                }
                else if (result != null && result.error != null) {
                    this.noData = true;
                    this.message = result.error;
                }
                else {
                    this.noData = true;
                }

                this.showSpinnerMassage = false;
            }).catch((error) => {
                console.log("95 an error has occured :  ", error);
                this.showSpinnerMassage = false;
                this.noData = true;
                this.message = error.body.message;


            })
    }

    getRegisteredCompanyNameMCA() {
        this.showSpinnerMassage = true;
        console.log("this.mcaId  ", this.mcaId);
        getCapiqRegisteredCompanyMCA({ mcaId: this.mcaId })
            .then((result) => {
                console.log("result   ", result);
                if (result != null) {
                    if (result.startsWith("ERROR")) {
                        this.noData = true;
                        this.message = result;
                    }
                    else {
                        this.registeredCompanyName = result;
                    }

                }
                else {
                    this.noData = true;
                }
                this.showSpinnerMassage = false;
            }).catch((error) => {
                console.log("95 an error has occured :  ", error);
                this.showSpinnerMassage = false;
                this.noData = true;
                this.message = error.body.message;

            })
    }

    handleSendEmail(event) {
        console.log('recordId---' + this.recordId);
        console.log('id--' + event.target.dataset.id);
        console.log('name--' + event.target.dataset.name);
        sendEmailToInactivateClient({ OriginalClientId: event.target.dataset.id, DuplicateClientId: this.recordId })
            .then((result) => {
                console.log(result);
                //alert('Success');
                this.showToast('The Email has been send successfully', 'success');
                this.refreshPage();
            })
            .catch((error) => {
                console.log(error);
                //alert('Error');
            })

    }
    sendEmailForNoDataFound() {
        console.log('Send Email to ME as no Data for for this client in External Systems 11');
        sendEmailAsNoDataFound({ clientId: this.recordId })
            .then((result) => {
                if(result == 'Success') {
                    console.log(result);
                    //alert('Success');
                    this.showToast('The Email has been send successfully', 'success');
                    this.refreshPage();
                } else {
                    this.showToast('An error occured, please contact System Admininsitrator', 'error');
                }
            })
            .catch((error) => {
                console.log(error);
                //alert('Error');
            })
            // this.sendNoDataEmail = true;
            // console.log('@@@@');

    }
    /*sendNoDataEmail = false;
    get inputVariables() {
        console.log('this.recordId--@'+this.recordId);
        return [
            {
                name: 'recordId',
                type: 'String',
                value: this.recordId
            }
        ];
    }
    handleStatusChange(event) {
        console.log('handleStatusChange', event.detail);
    }*/

}