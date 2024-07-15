import { LightningElement, api, track, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import updateAccount from '@salesforce/apex/capIQButtontoUpdateClient.sendCapIQIdtoMap';
import { CloseActionScreenEvent } from 'lightning/actions';
import clientNewSearchByNamemca from '@salesforce/apex/newClientDataFromMCA.newClientCompanySearchByName';
// import clientNewSearchByName from '@salesforce/apex/capIQButtontoUpdateClient.ClientNewSearchByName';
import clientNewSearchByName from '@salesforce/apex/newClientByCompanyNameIQ.ClientNewSearchByName';
import clientNewSearchId from '@salesforce/apex/newClientByCompanyNameIQ.ClientNewSearchId';
//import updateCompetitor from '@salesforce/apex/capIQButtontoUpdateClient.sendCapIQIdtoCompetitor';
//import getCompanyName from '@salesforce/apex/capIQButtontoUpdateClient.ClientNewSearchByName';
import updateNewClient from '@salesforce/apex/capIQButtontoUpdateClient.sendCapIQIdtoNewClient';
import updateNewClientMCA from '@salesforce/apex/capIQButtontoUpdateClientMCA.updateNewClientMCA';
import clientNewTracker from '@salesforce/apex/newClientByCompanyNameIQ.clientnewSearchForLoc';
import { RefreshEvent } from 'lightning/refresh';

import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import { updateRecord } from 'lightning/uiRecordApi';
import NAME_FIELD from '@salesforce/schema/Lead.FirstName';
import LastNAME_FIELD from '@salesforce/schema/Lead.LastName';
import ID_FIELD from '@salesforce/schema/Lead.Id';
import ExternalDataSource_FIELD from '@salesforce/schema/Lead.External_Database_Source__c';
import DuplicateNewClientAlreadyConverted_FIELD from '@salesforce/schema/Lead.Duplicate_New_Client_Already_Converted__c';
import PROFILE_NAME_FIELD from '@salesforce/schema/User.Profile.Name';
import userId from '@salesforce/user/Id';
import Partner_Id from '@salesforce/schema/User.PartnerLogin_UserID__c';
import EnrichDataFromExternalDB_AuthorizationMsg_Body from '@salesforce/label/c.EnrichDataFromExternalDB_AuthorizationMsg_Body';
import EnrichDataFromExternalDB_AuthorizationMsg_Header from '@salesforce/label/c.EnrichDataFromExternalDB_AuthorizationMsg_Header';
import EnrichDataFromExternalDB_ErrorMsg_Body from '@salesforce/label/c.EnrichDataFromExternalDB_ErrorMsg_Body';

const FIELDS = ['Lead.capIQId__c', 'Lead.FirstName', 'Lead.LastName', 'Lead.Status', 'Lead.Industry_Business_Partner__c' , 'Lead.Company', 'Lead.External_Database_Source__c' , 'Lead.MCA_ID__c', 'Lead.Duplicate_New_Client_Already_Converted__c'];
const COLS = [
    { label: 'New Client Name', fieldName: 'companyName', type: 'text', wrapText: true },
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

export default class CapIQButton extends LightningElement {
    @track ifUpdated = false;
    @api recordId;
    @api objectApiName;
    @api flexipageRegionWidth;
    @track show = true;
    @track ifFirstNameNotAvailable = false;
    @track dataResult = false;
    @track ifYes = false;
    @track ifData = false;
    @track companyNameChange;
    @track mcaId; 
    @track entityId;
    @track companyNameChangeOld;
    @track arrDataList = [];
    @track comapnyNameLength = true;
    @track showButton = false;
    @track ifMCAtrue = false;
    @track ifCapIQtrue = false;
    @track mapOfValues = [];
    prfName;
    partnerId; //This will hold the partner id of the EA user when logged in as partner.
    showComp =false;
    showErrorMessage1= false;
    showErrorMessage2= false;
    showErrorMessage3= false;
    headerMsg = EnrichDataFromExternalDB_AuthorizationMsg_Header;
    errMsg1 = EnrichDataFromExternalDB_ErrorMsg_Body;
    errMsg2 = EnrichDataFromExternalDB_AuthorizationMsg_Body;
    errMsg3 = 'You can only change the status to Client Already Accepted';
    capIqId = '';
    @track capIq;
    showUpdatedScreen = false;
    firstName;
    companyName;
    lastName;
    cols = COLS;
    showSpinner = false; //Added by AK
    showSpinner1 = true;
    isLoaded = false;
    memberOfMETeam = false;
    currentRecordId;

    @track mapOfValuesCapIQ = [];
    showCompanies = false;
    capIQresultcounter = 0;


    renderedCallback(){
        if(this.isLoaded) return;
        const STYLE = document.createElement("style");
        STYLE.innerText =`.slds-modal__container {
            margin: 0 auto;
            width: 60% !important;
            max-width: 60% !important;
            min-width: 20rem;
        }`;
        this.template.querySelector('lightning-card').appendChild(STYLE);
        this.isLoaded = true;

    }

    @api callFromParent(paremt1) {
        console.log('RecordId InSide LWC :', paremt1);
        this.recordId = paremt1;

    }

    @wire(getRecord, {
        recordId: userId,
        fields: [PROFILE_NAME_FIELD, Partner_Id]
    }) wireuser({ error, data }) {
        debugger
        if (error) {
            this.error = error;
        } else if (data) {
            this.prfName = data.fields.Profile.value.fields.Name.value;
            this.partnerId = data.fields.PartnerLogin_UserID__c.value;
            
            console.log(' this.prfName : ', this.prfName);
            if(this.prfName != undefined){
                this.currentRecordId = this.recordId;
            }
            console.log(' this.partnerId : ', data.fields.PartnerLogin_UserID__c.value);
        }
    }

    @wire(getRecord, { recordId: '$currentRecordId', fields: FIELDS })
    wiredRecord({ error, data }) {
        if (data) {
            console.log('Wired data : ', data);
            console.log('capIq data : ', data.fields.capIQId__c.value);
            console.log('sectorCoordintaor : ', data.fields.Industry_Business_Partner__c.value);
            console.log('First Name : ', data.fields.FirstName.value);
            console.log('userId : ' , userId);
            console.log('Duplicate flag' , data.fields.Duplicate_New_Client_Already_Converted__c.value);
            if (data.fields.Status.value === 'NotAccept'){
                
                this.showErrorMessage1 = true;
                this.showErrorMessage2 = false;
                this.showErrorMessage3 = false;
                this.showSpinner1 = false;
            }
            else if(data.fields.Duplicate_New_Client_Already_Converted__c.value === false){
                console.log('Flag value' , data.fields.Duplicate_New_Client_Already_Converted__c.value === false);
                console.log('this.prfName main : ' , this.prfName);
                
                if(this.prfName === 'System Administrator' || this.prfName ==='Markets Ecosystems' || data.fields.Industry_Business_Partner__c.value === this.partnerId){
                    this.showComp = true;
                    this.showSpinner1 = false;
                }
                else{
                    this.showErrorMessage2 = true;
                    this.showErrorMessage1 = false;
                    this.showErrorMessage3 = false;
                    this.showSpinner1 = false;
                }
                this.showSpinner1 = false;
            }
            else{
                this.showErrorMessage3 = true;
                this.showErrorMessage2 = false;
                this.showErrorMessage1 = false;
            }
            this.showSpinner1 = false;

            this.lastName = data.fields.LastName.value;
            this.companyName = data.fields.Company.value;
            this.companyNameChangeOld = this.companyName;
            if (data.fields.FirstName.value == null) {
                this.ifFirstNameNotAvailable = true;
            }
            if (data.fields.capIQId__c.value !== null) {
                this.showUpdatedScreen = true;
                console.log('Val1 : ', this.showUpdatedScreen);
            }
            else if (data.fields.capIQId__c.value === null) {
                this.showUpdatedScreen = false;
                console.log('Val2 : ', this.showUpdatedScreen);
            }
        }
        else if (error) {
            console.log('Error : ', error);
        }
    }

    async handleRowAction(event) {
        debugger;
        console.log('HandleRowAction ---> ', event.detail.row.companyName);
        this.showSpinner = true; //Added BY AK
        this.companyName = event.detail.row.companyName;
        console.log(this.ifMCAtrue);
        if(this.ifCapIQtrue == true){
            await clientNewSearchId({ companyName: this.companyName })
            .then((result) => {
                this.capIq = result;
                if (result == 'Data Unavailable') {
                    this.ifUpdated = true;
                    this.dataResult = false;
                    this.ifYes = false;
                    this.ifData = false;
                }
                console.log('160  capIQ ID --->', this.capIq);
            }).catch((error) => {
                console.log("250 an error has occured :  ", error);
            })
            updateNewClient({ recordId: this.recordId, capIqId: this.capIq })
            .then((result) => {

                console.log('capIQ ID --->', result);
                if (result) {
                    this.ifUpdated = true;
                    this.dataResult = true;
                    this.ifYes = false;
                    this.ifData = false;
                } else {
                    this.ifUpdated = true;
                    this.dataResult = false;
                    this.ifYes = false;
                    this.ifData = false;
                }
                this.showSpinner = false;//Added By AK
            }).catch((error) => {
                this.showSpinner = false;//Added By AK
                console.log("95 an error has occured :  ", error.message);
            })
        }
        else if(this.ifMCAtrue){
            for (let x in this.mapOfValues) {
                if (this.mapOfValues[x].value == this.companyName) {
                    console.log(this.mapOfValues[x].key,'  ',this.mapOfValues[x].value);
                    let arrayData = this.mapOfValues[x].key.split('$$$$');
                    this.mcaId= arrayData[0];
                    this.entityId = arrayData[1];
                }
                console.log(' 191 --- > this.mcaId',this.mcaId);
                updateNewClientMCA({ recordId: this.recordId, mcaId: this.mcaId , mcaName: this.companyName , entityId : this.entityId})
                .then((result) => {

                console.log('MCA --->', result);
                if (result) {
                    this.ifUpdated = true;
                    this.dataResult = true;
                    this.ifYes = false;
                    this.ifData = false;
                } else {
                    this.ifUpdated = true;
                    this.dataResult = false;
                    this.ifYes = false;
                    this.ifData = false;
                }
                this.showSpinner = false;//Added By AK
                }).catch((error) => {
                this.showSpinner = false;//Added By AK
                console.log(error);
                    this.ifUpdated = true;
                    this.dataResult = false;
                    this.ifYes = false;
                    this.ifData = false;
                })
            }
        }
        

    }

    fieldValidation() {
        try {
            let isValid = true;

            let inputFields = this.template.querySelectorAll('.validate');
            console.log('InputFields : ', inputFields);
            inputFields.forEach(inputField => {
                if (!inputField.checkValidity()) {
                    inputField.reportValidity();
                    isValid = false;
                }
                this.objInsurance[inputField.name] = inputField.value;
            });
            return isValid;
        } catch (error) {
            console.log('Error : ', error);
        }
    }

    getFirstName(event) {
        //this.firstName=event.target.value;
        NAME_FIELD.FirstName = event.target.value;
        this.firstName = event.target.value;
        console.log('First Name : ', this.firstName);
    }

    getLastName(event) {
        LastNAME_FIELD.LastName = event.target.value;
        this.lastName = event.target.value;
        console.log('Last Name : ', this.lastName);
    }

    updateFirstNameButton(event) {
        console.log('clicked and this.firstName : ', this.firstName);
        const fields = {};
        fields[ID_FIELD.fieldApiName] = this.recordId;
        fields[NAME_FIELD.fieldApiName] = this.firstName;
        fields[LastNAME_FIELD.fieldApiName] = this.lastName;
        const recordInput = { fields };
        console.log('fileds : ', fields);
        // console.log('this.firstName.trim() ',this.firstName.trim());
        if (this.firstName) {
            if (this.firstName.trim()) {
                updateRecord(recordInput)
                    .then(() => {
                        //this.dispatchEvent(new CloseActionScreenEvent()); 
                        this.showUpdatedScreen = true;
                        this.ifFirstNameNotAvailable = false;
                        this.dispatchEvent(
                            new ShowToastEvent({
                                title: 'Success',
                                message: 'First Name updated',
                                variant: 'success'
                            })
                        );

                    })
                    .catch(error => {
                        console.log('error : ', error);
                    })
            }


        }

        if (this.firstName == undefined || this.firstName == null || this.firstName.trim() < 1) {
            console.log('first name  : ', this.firstName);
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Required',
                    message: 'Please fill First Name',
                    variant: 'warning'
                })
            );
        }
        else if (this.lastName == '' || this.lastName == null || this.lastName.trim() < 1) {
            this.dispatchEvent(

                new ShowToastEvent({
                    title: 'Required',
                    message: 'Please fill Last Name',
                    variant: 'warning'
                })
            );
            //window.alert('Please fill First Name');
            console.log('Invalid');
        }

    }
    async handleMCASearch(){
        this.showSpinner1 = true;
        console.log('HandleMCASearch');
        try{
            
            await clientNewSearchByNamemca({ searchString: this.companyName })
            .then((data) => {
                 if(data)
                {
                    
                    console.log('clientNewSearchByNamemca imp data : ' , JSON.stringify(data));
                            let arrDataListTemp = [];
                            for (let x in data) {
                                let arrData = {};
                                let arrayData = data[x].split('$$$$');
                                arrData.Name = arrayData[0];
                                arrDataListTemp.push(arrData);
                            }
                            this.arrDataList = arrDataListTemp;
                            //this.companylist = data;
                            console.log(this.arrDataList);
                            this.error = undefined;
                            for (let key in data) {
                                // Preventing unexcepted data
                                if (data.hasOwnProperty(key)) { // Filtering the data in the loop
                                    let arrayData1 = data[key].split('$$$$');
                                    //let arrayData = data[key].split('$$$$');
                                    this.mapOfValues.push({ value: arrayData1[0], key: key });
                                }
                            }     
                }
                
            
            else if (error){
                console.log(error);
            }})
             if(this.arrDataList.length == 0){
                this.showSpinner1=false;
                console.log('this.arrDataList ---> ', this.arrDataList.length);
                                const fields = {};
                                fields[ID_FIELD.fieldApiName] = this.recordId;
                                fields[ExternalDataSource_FIELD.fieldApiName] = 'None';
                                const recordInput = { fields };
                                updateRecord(recordInput)
                                    .then(() => {
                                        console.log('Update External Data Source');

                                    })
                                    .catch(error => {
                                        console.log('error : ', error);
                                    })
                                this.ifUpdated = true;
                                this.dataResult = false;
                                this.ifYes = false;
                                this.ifData = false;
            }
            else{
                this.showSpinner1=false;
                this.ifMCAtrue =true;
                this.ifData = true;
            }
        }
        catch(e){
            this.showSpinner1=false;
        }
    }


    handleClick(event) {
        console.log('handle Click');
        this.companyName = this.companyNameChange;
        this.showSpinner1=true;
        try {
            clientNewSearchByName({ searchString: this.companyName })
                .then((data) => {
                    if (data) {
                        console.log('clientNewSearchByName imp data stringified : ' + JSON.stringify(data));
                        console.log('clientNewSearchByName imp data parsed : ' + JSON.parse(JSON.stringify(data)));
                        if (data == 'Data Unavailable') {
                            this.handleMCASearch();
                        } else {
                            // this.showSpinner1=false;
                            console.log(data);
                            let arrDataListTemp = [];
                            for (let x in data) {
                                console.log('x prior : ' , x);
                                let arrData = {};
                                arrData.Name = data[x];
                                arrData.Id = x;
                                arrDataListTemp.push(arrData);
                            }
                            this.arrDataList = arrDataListTemp;
                            //this.companylist = data;
                            this.error = undefined;

                            //console.log('811 company List',JSON.stringify(this.companylist));
                            //console.log('this.data.length',this.arrDataList.length);
                            if (this.arrDataList.length == 0) {
                                this.handleMCASearch();

                            } else {
                                // this.showSpinner1=false;
                                this.ifCapIQtrue = true;
                                this.ifData = true;
                                console.log('191 this.arrDataList ---> ', this.arrDataList.length);
                                console.log('this.arrDataList ---> ', this.arrDataList);
                            }
                        }
                    }
                    else if (error) {
                        this.error = error;
                        //this.companylist = 'Its';
                        if (this.arrDataList.length == 0) {
                            this.handleMCASearch();
                        }
                    }

                    // if (this.arrDataList.length > 0) {
                    //     console.log('this.arrDataList data : ', JSON.stringify(this.arrDataList));
                    //     let tempData = [];
                    //     for (let x in this.arrDataList) {
                    //         console.log('x : ' , x);
                    //         this.capIQ = this.arrDataList[x].Id;
                    //         console.log(this.arrDataList[x].Id);
                    //         let testData = await this.handletrickerCallout(this.capIQ);
                    //         console.log('testData : ' + JSON.stringify(testData));
                    //         tempData.push(testData);
                    //     }

                    //     if(tempData.length == this.arrDataList.length){
                    //         this.mapOfValuesCapIQ = tempData;
                    //         this.dataReceived = true;
                    //         console.log('dataReceived--' + this.dataReceived);
                    //         console.log('Vlaues Added');
                    //     }
            
                    // }
                    this.handleDataSync();
                })
                

        } catch (e) {
            console.log('Error', e);
            if (this.arrDataList.length == 0) {
                this.handleMCASearch();
            }
        }
    }

    async handleDataSync(){
        if (this.arrDataList.length > 0) {
            console.log('this.arrDataList data : ', JSON.stringify(this.arrDataList));
            let tempData = [];
            for (let x in this.arrDataList) {
                console.log('x : ' , x);
                this.capIQ = this.arrDataList[x].Id;
                console.log(this.arrDataList[x].Id);
                let testData = await this.handletrickerCallout(this.capIQ);
                console.log('testData : ' + JSON.stringify(testData));
                tempData.push(testData);
            }

            if(tempData.length == this.arrDataList.length){
                this.mapOfValuesCapIQ = tempData;
                this.dataReceived = true;
                this.dispatchEvent(new RefreshEvent());
                this.showCompanies = true;
                this.showSpinner1=false;
                console.log('dataReceived--' + this.dataReceived);
                console.log('Vlaues Added');
            }

        }
    }


    async handletrickerCallout(capIQVar) {
        try {

            console.log('this.capIQ--' + this.capIQ);
            let dataToReturn;
            //this.capIqVar = JSON.stringify(this.capIQ);
            await clientNewTracker({ companyID: this.capIQ })
                .then((data) => {
                    if (data) {
                        console.log('data--' + JSON.stringify(data));

                        // this.mapOfValuesCapIQ.push({ companyName: data[0], countryName: data[2], tickerSymbol: data[1], key: capIQVar });
                        console.log('companyName : ', data[0] + ', countryName : ', data[2] + ', tickerSymbol : ', data[1] + ', key : ', capIQVar);
                        dataToReturn = { 'companyName': data[0], 'countryName': data[2], 'tickerSymbol': data[1], 'key': capIQVar }
                        // debugger
                        console.log('set dataToReturn--' + JSON.stringify(dataToReturn));
                        console.log('mapOfValuesCapIQ--' + JSON.stringify(this.mapOfValuesCapIQ));
                        this.capIQresultcounter = this.capIQresultcounter + 1;
                        console.log('capIQresultcounter--' + this.capIQresultcounter);
                        console.log('arrDataList.length--' + this.arrDataList.length);
                        if (this.capIQresultcounter == this.arrDataList.length) {
                            // this.dataReceived = true;
                            // console.log('dataReceived--' + this.dataReceived);
                        }
                    } else if (error) {
                        console.log('ticker callout error : ', error);
                    }
                })
            console.log(this.capIQresultcounter, this.arrDataList.length);
            if (this.capIQresultcounter >= this.arrDataList.length) {
                console.log(this.capIQresultcounter == this.arrDataList.length);

                this.isSearchDisabled = false;
                this.ifData = true;
                this.externalDataSourceisCapIQ = true;
            }
            console.log('Data to be returned : ', dataToReturn);
            return dataToReturn;

        } catch (error) {
            console.log('handleTickerCallout error : ', error);
        }
    }


    handleChange(event) {
        this.ifData = false;
        this.companyNameChange = event.target.value;
        this.companyNameChange = this.companyNameChange.replace(/^\s+|\s+$/gm,'');
        if(this.companyNameChange != this.companyNameChangeOld){
            this.showButton = true;
        }
        else{
            this.showButton = false;
        }
        if(this.companyNameChange.length < 3){
            this.showButton = false;
            this.comapnyNameLength = false;
        }else{
            this.comapnyNameLength = true;
        }
        console.log('this.companyName  Old --->>> ', this.companyNameChangeOld);
        console.log('this.companyName New  --->>> ', this.companyNameChange);
    }
    giveCompany(event) {
        this.ifYes = true;
        this.showUpdatedScreen = true;
        this.show = false;
    }
    refreshPage() {

        this.dispatchEvent(new CloseActionScreenEvent());
        setTimeout(() => {
            eval("$A.get('e.force:refreshView').fire();");

        }, 1000);
        console.log('page refreshed!!');
        var dataToSend = 'trnsfer';
        const sendDataEvent = new CustomEvent('callLWC', {
            detail: { dataToSend }
        });

        //Actually dispatching the event that we created above.
        this.dispatchEvent(sendDataEvent);
        console.log('page refreshed!!309');

    }
}