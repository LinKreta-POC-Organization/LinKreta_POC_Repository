import { LightningElement, api, track } from 'lwc';
import getFilterRecords from '@salesforce/apex/SObjectDataTableController.getFilterRecords';
import getAllRecords from '@salesforce/apex/SObjectDataTableController.getAllRecords';
import genrateColumns from '@salesforce/apex/SObjectDataTableController.genrateColumns';
export default class SObjectDataTable extends LightningElement {
    //@api ApiNameOfObject ;
    //@api ApiNamesOfField ;
     @api heightWidth;
    @api width;
    @api height;
    @api dependent;
    @api object;
    @api field;
    @api related;
    @api clause;
    // @api title;
    @track options;
    @track data = [];
    columns = [];
    error;
    @api recordId;
    @track splitList = [];

    handleChange(event) {
        this.value = event.detail.value;
        this.data = [];
        if (this.value == 'All') {
            this.retrieveRecords();
            return;
        }
        this.splitList = [];
        getFilterRecords({ objectApiName: this.object, relatedObject: this.related, fieldApiNames: this.field, recordId: this.recordId, value: this.value, clause: this.clause, dependent: this.dependent })
            .then(result => {
                console.log('result ', result);
                this.columns = this.generateColumns(result);
                //this.data = JSON.parse(JSON.stringify(result));
                //console.log('this.data>>????', this.data);
                // this.data.forEach(res =>{
                //     console.log('resData ',res);
                //     res.urlLink = '/' + res.Id;
                //     if(this.related == 'contact' || this.related == 'Opportunity'){
                //         res.accName = res.Account.Name;
                //         res.urlLinkAcc = '/' + res.Account.Id;
                //     }
                //     if(this.related == 'Job__c' ){
                //         res.accNamee = res.ClientId__r.Name;
                //         res.urlLinkAcc = '/' + res.ClientId__r.Id;
                //     }
                //     if(this.related == 'Investor__c'){
                //        res.accNameeInv = res.Client__r.Name;
                //             res.urlLinkAcc = '/' + res.Client__r.Id;
                //     }
                //     // if(this.related == 'Job__c' ){
                //     //     res.accNamee = res.ClientId__r.Name;
                //     // }
                // })

            })
            .catch(error => {
                this.error = 'Error retrieving records: ' + error.body.message;
            });

    }
    connectedCallback() {
         this.heightWidth = "height: " + this.height + ";" + "width:" + this.width;
         
        this.options = [];

        this.data = [];
        console.log('recordId', this.recordId);
        //console.log('Apiobject',this.ApiNameOfObject);
        //console.log('ApiField',this.ApiNamesOfField);
        console.log('tttt', this.object);
        console.log('t22', this.field);
        if (this.object && this.field)
            this.retrieveRecords();
        //this.retrieveRecords1();
    }

    async retrieveRecords() {
        this.data = [];
        await getAllRecords({ objectApiName: this.object, relatedObject: this.related, fieldApiNames: this.field, recordId: this.recordId, clause: this.clause, dependent: this.dependent })
            .then(result => {
                console.log('result 123 ', result);
                let resultOpt = JSON.parse(JSON.stringify(result.ListOfFilterOptions));
                console.log('resultOpt ', resultOpt);
                if (result.ListOfAll) {
                    console.log('listOfall>>>>>');
                    console.log('RESULT LIST OF ALL ', result.ListOfAll);
                    this.generateColumns(result.ListOfAll);
                    //console.log('columns', this.columns);
                    //console.log('result ', result.ListOfAll);

                    // this.data.forEach(res =>{
                    //     console.log('resData ',res);
                    //     res.urlLink = '/' + res.Id;
                    //res.urlLinkAcc = '/' + res.AccountId;
                    //     if(this.related == 'contact' || this.related == 'Opportunity' ){
                    //         res.accName = res.Account.Name;
                    //         res.urlLinkAcc = '/' + res.Account.Id;
                    //     }
                    //     if(this.related == 'Job__c' ){
                    //         res.accNamee = res.ClientId__r.Name;
                    //         res.urlLinkAcc = '/' + res.ClientId__r.Id;
                    //     }
                    //     if(this.related == 'Investor__c' ){
                    //         res.accNameeInv = res.Client__r.Name;
                    //         res.urlLinkAcc = '/' + res.Client__r.Id;
                    //     }

                    // })
                }
                if (resultOpt) {
                    this.options = [];
                    this.options.push({ label: 'All', value: 'All' })
                    resultOpt.forEach(element => {
                        console.log('ELEMENT ', element);
                        this.options.push({ label: element.Name, value: element.Id });
                    });
                    this.options = JSON.parse(JSON.stringify(this.options));
                    //console.log('options',JSON.stringify());
                }
            })
            .catch(error => {
                console.log('errror ', error);
                //this.error = 'Error retrieving records: ' + error.body.message;
            });
    }

    async generateColumns(records) {


        let makeColumns;
        var columns = [];

        await genrateColumns({ Fields: this.field, related: this.related, Records: records })
            .then(result => {
                this.data = JSON.parse(JSON.stringify(records));
                console.log('columnss>>Last', this.columns);
                console.log('data>>Last', this.data);
                
                if(this.dependent.includes(',')){
                    console.log('iNNNN,');
                    this.splitList = this.dependent.split(',');
                }
                else{
                    console.log('IIIIIoooo');
                    this.splitList.push(this.dependent);
                }
                console.log('splitList',this.splitList);
                this.data.forEach(res => {
                    console.log('resData before ', res);
                    res.urlLink = '/' + res.Id;
                    
                    
                    if (this.splitList) {
                        console.log('iffff INNNN');
                    for(let i=0 ; i<this.splitList.length ;i++){
                        
                        console.log('INN For Loop')
                        //console.log('this.dependent', splitList[i]);
                        console.log('res' + res);
                        var key = this.splitList[i].split('.')[0];    
                        if(res[key] !== undefined){
                            console.log('splitList[i]',this.splitList[i]);
                           // var SplitApi = splitList[i].remove('.');
                           //var SplitApi = this.splitList[i].split('.').join("");
                           console.log('splitApi',SplitApi);
                           var SplitApi = this.splitList[i];
                           console.log('fieldApniurl>>>',SplitApi);
                           var afterDott = SplitApi.split('.');
                           var stringAfterDott = afterDott[1];
                            console.log('stringAfterDott',stringAfterDott);
                            //res[SplitApi] = res[key] + '.' + afterDott[1];
                            //res[SplitApi] = res[key].Name;
                            res[SplitApi] = res[key][stringAfterDott];
                            var splitApiUrl = 'url' + SplitApi ;
                            res[splitApiUrl] = '/' + res[key].Id;
                        }
                    }
                }
                    console.log('resData after ', res);
                });

                console.log('THIS DATA AFTER ',this.data);

                // for(let i =0 ;i <this.splitList.length ;i++){
                //    this.splitList[i] = this.splitList[i].split('.').join("");
                // }
                console.log('splitLast',this.splitList);
                console.log('result>>ListOfFieldList>>', result);
                makeColumns = JSON.parse(JSON.stringify(result));
                console.log('makeColumns>>', makeColumns);
                if (makeColumns) {
                    console.log('makeColumns  INNNNN>>');
                    for (const field in makeColumns) {
                        console.log('makeColumns[field][1]',makeColumns[field][1]);
                        if (makeColumns[field][1] == 'Name') {
                            console.log('feiled INNNNN>>NAme');
                            console.log('Field$$Name', makeColumns[field]);
                            console.log('fildKa0Name', makeColumns[field][0]);
                            console.log('fildKa1Name', makeColumns[field][1]);
                            columns.push({
                                label: makeColumns[field][0],
                                fieldName: 'urlLink',
                                type: 'url',
                                typeAttributes: { label: { fieldName: makeColumns[field][1] }, target: '_blank' }
                            });
                        }
                        
                        
                        // else if(makeColumns[field][1] == 'ClientId__r.Name'){
                        //     console.log('feiled INNNNN>>elseiff');
                        //     console.log('Field$$Name', makeColumns[field]);
                        //     console.log('fildKa0Name' , makeColumns[field][0]);
                        //     console.log('fildKa1Name' , makeColumns[field][1]);
                        //         columns.push({
                        //             label: makeColumns[field][0],
                        //             fieldName: 'urlLinkAcc',
                        //             type: 'url',
                        //             typeAttributes: { label: { fieldName: makeColumns[field][1]}, target: '_blank' }
                        //         });
                        // }
                        // else if(makeColumns[field][1] == 'Client__r.Name'){
                        //     console.log('feiled INNNNN>>elseiff');
                        //     console.log('Field$$Name', makeColumns[field]);
                        //     console.log('fildKa0Name' , makeColumns[field][0]);
                        //     console.log('fildKa1Name' , makeColumns[field][1]);
                        //         columns.push({
                        //             label: makeColumns[field][0],
                        //             fieldName: 'urlLinkAcc',
                        //             type: 'url',
                        //             typeAttributes: { label: { fieldName: makeColumns[field][1]}, target: '_blank' }
                        //         });
                        // }
                        // else if(makeColumns[field][1] == 'ClientGroupName__r.Name'){
                        //     console.log('feiled INNNNN>>elseiff');
                        //     console.log('Field$$Name', makeColumns[field]);
                        //     console.log('fildKa0Name' , makeColumns[field][0]);
                        //     console.log('fildKa1Name' , makeColumns[field][1]);
                        //         columns.push({
                        //             label: makeColumns[field][0],
                        //             fieldName: 'urlLinkAccOfGt',
                        //             type: 'url',
                        //             typeAttributes: { label: { fieldName: makeColumns[field][1]}, target: '_blank' }
                        //         });
                        // }
                        if ((!makeColumns[field][1].includes('.') && makeColumns[field][1] != 'Name')){
                            console.log('feiled INNNNN>>__C');
                            console.log('Field$$', makeColumns[field]);
                            console.log('fildKa0', makeColumns[field][0]);
                            columns.push({
                                label: makeColumns[field][0],
                                fieldName: makeColumns[field][1],
                                //type: typeof makeColumns[field][1]
                            });
                        }

                         if(makeColumns && this.dependent){
                            console.log('Length of SplitList',this.splitList.length);
                            for(let i =0 ;i<this.splitList.length; i++){
                                console.log('IIIII',i);
                                console.log(this.splitList[i]);
                            if (makeColumns[field][1] == this.splitList[i]  ){
                                console.log('innncontrole');
                                
                                    
                                //console.log('makeColumns[field][1]',makeColumns[field][1]);
                                //console.log('this.dependent',this.dependent);
                                   // var SplitApi = this.dependent.split('.').join("");
                                    // var SplitApi = splitList[i].remove('.');
                                    // res[SplitApi] = res[key].Name;
                                    // var splitApiUrl = 'url' + SplitApi ;
                                    // res[splitApiUrl] = '/' + res[key].Id;  
                                    var unique = 'url' + this.dependent;  
                                console.log('feiled INNNNN>>elseiff');
                                // console.log('Field$$Name', makeColumns[field]);
                                // console.log('fildKa0Name', makeColumns[field][0]);
                                // console.log('fildKa1Name', makeColumns[field][1]);
                                columns.push({
                                    label: makeColumns[field][0],
                                    fieldName: 'url' + this.splitList[i],
                                    type: 'url',
                                    typeAttributes: { label: { fieldName: this.splitList[i] }, target: '_blank' }
                                });
                            }
                            
                        }
                        }
                    }
                    this.columns = columns
                    


                    // this.data = JSON.parse(JSON.stringify(records));
                    // console.log('columnss>>Last',this.columns);
                    // console.log('data>>Last',this.data);

                    // this.data.forEach(res =>{
                    // console.log('resData ',res);
                    // res.urlLink = '/' + res.Id;

                    // if(this.related == 'contact'){
                    // res.accName = res.Account.Name;   
                    // res.urlLinkAcc = '/' + res.Account.Id;
                    // }
                    // })
                }
                console.log('cols', columns);

            })
            .catch(error => {
                console.log('error', error);
            })

    }

}