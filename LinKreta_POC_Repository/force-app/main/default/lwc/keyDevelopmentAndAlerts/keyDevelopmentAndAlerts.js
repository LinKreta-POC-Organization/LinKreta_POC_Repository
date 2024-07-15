import { LightningElement, api, track } from 'lwc';
import getNewClient from '@salesforce/apex/KeyDevAndAlertsController.getNewClient';
import getNewClientMCA from '@salesforce/apex/KeyDevAndAlertsController.getNewClientMCA';
import getNewClientMCACaseNumber from '@salesforce/apex/KeyDevAndAlertsController.getNewClientMCACourtCase';

export default class KeyDevelopmentAndAlerts extends LightningElement {

      @api recordId;
      @track data;
      @track dataConvection;
      showDataTable = false;
      @track dataFromCapIQ = false;
      @track dataFromMCA = false;
      @api objectApiName;
      @track accountDataMCA;
      @track accountDataCAPIQ;
      showTableAccountCAPIQ = false;
      showTableAccountMCA = false;
      @track keyAccountData;
      @track allKeyAccountData;
      showTableKeyAccount = false;
      @track accountINfoOption;
      @track selectedKeyAccount ='All';
      @track isLoading=false;
      @track showMessageOfData = 'Loading...';

      @track columns = [
            { label: 'Key Development Type', fieldName: 'Name' , wrapText: true, type: 'text'},
            { label: 'Key Development Date', fieldName: 'Key_Development_Date__c' },
            { label: 'Key Development Headline', fieldName: 'IQ_KEY_DEV_HEADLINE__c', wrapText: true, type: 'text' }
            
      ];
      @track col = [
            { label: 'Severity', fieldName: 'severity__c' },
            { label: 'Alert Header', fieldName: 'Name' },
            { label: 'Description', fieldName: 'remarks_details__c', wrapText: true, type: 'text' }
            
            
      ];
      @track col2 = [
            { label: 'Case Number', fieldName: 'Case_Number__c' },
            { label: 'Convicted Directors', fieldName: 'convictedDirectors__c' }
            
            
      ];
      @track columnsAccountCAPIQ  =[
            { label: 'Date', fieldName: 'Key_Development_Date__c', wrapText: true, type: 'Date' },
            { label: 'Key Developments', fieldName: 'IQ_KEY_DEV_HEADLINE__c', wrapText: true, type: 'text' },
      ]
      @track columnsAccountMCA =[
            { label: 'Alert', fieldName: 'Alert__c', wrapText: true, type: 'text' },
            { label: 'Remarks/details', fieldName: 'remarks_details__c', wrapText: true, type: 'text' },
      ]
      connectedCallback() {
            try {
                  debugger
                  this.isLoading = true;
                  getNewClient({ recordId: this.recordId, objectName: this.objectApiName })
                        .then(result => {
                              console.log('result  == ',JSON.stringify(result));
                             
                              if (result) {
                                    console.log('clientNews  == ',JSON.stringify(result.clientNews));
                                    this.showDataTable = true;
                                    if (this.objectApiName == 'Account') {

                                          /*result.clientNews.forEach(element => {
                                                element.IQ_KEY_DEV_HEADLINE__c = element.IQ_KEY_DEV_HEADLINE__c.slice(3, element.IQ_KEY_DEV_HEADLINE__c.length - 4);

                                          });*/

                                          if(result.externalDatabaseSource =='CAPIQ'){
                                                this.accountDataCAPIQ =result.clientNews;
                                                this.showTableAccountCAPIQ = true;  
                                          }
                                          if(result.externalDatabaseSource =='MCA'){
                                                this.accountDataMCA =result.clientNews;
                                                this.showTableAccountMCA = true;
                                          }
                                          
                                          if(result.isKeyAccount){
                                                console.log('result.isKeyAccount  == ',result.isKeyAccount);
                                                const option = {
                                                      label :'All' ,
                                                      value : 'All'
                                                };
                                                let keyAccountINfoOption =[];
                                               
                                                keyAccountINfoOption.push(option);

                                                for(let i = 0; i < result.keyAccountInformation.length; i++){
                                                      const option = {
                                                            label :result.keyAccountInformation[i].name ,
                                                            value : result.keyAccountInformation[i].recordId 
                                                      };
                                                      keyAccountINfoOption.push(option);
                                                }
                                                this.accountINfoOption = keyAccountINfoOption;

                                                this.keyAccountData = result.clientNews;
                                                this.allKeyAccountData = result.clientNews;
                                                this.showTableKeyAccount = true;
                                          }

                                    }
                                    else {
                                          debugger
                                          this.dataFromCapIQ = true;
                                          this.data = result.clientNews;
                                    }
                                    this.isLoading = false;
                              }
                              else {
                                    console.log('Result is empty and data : ', this.data);
                                    debugger
                                    
                                    this.handleMca();
                              }
                        })
                        .catch(error => {
                              debugger
                              this.isLoading = false;
                              console.log('Error : ', error);
                              this.handleMca();
                        })
            }
            catch (error) {
                  debugger
                  this.handleMca();
                  this.isLoading = false;
            }
      }

      handleMca(){
            debugger
          getNewClientMCA({ recordId: this.recordId, objectName: this.objectApiName })
                        .then(result => {
                              debugger
                              console.log('result check -->',result);
                              if (result) {
                                    console.log('result check -->',result);
                                    if (this.objectApiName == 'Account') {

                                         /* result.clientNews.forEach(element => {
                                                element.remarks_details__c = element.remarks_details__c.slice(3, element.remarks_details__c.length - 4);

                                          });*/
                                          this.data = result.clientNews;

                                    }
                                    else {
                                          this.showDataTable = true;
                                          this.dataFromMCA = true;
                                          this.data = result.clientNews;
                                    }
                              }
                              else {
                                    console.log('Result is empty and data : ', this.data);
                                    this.showDataTable = false;
                                    this.showMessageOfData = 'No client news!!!';
                                    
                              }
                              this.isLoading = false;
                        })
                        .catch(error => {
                              debugger
                              console.log('Error : ', error);
                              this.showDataTable = false;
                              this.showMessageOfData = 'No client news!!!';
                              this.isLoading = false;
                        })
            /*
            getNewClientMCACaseNumber({ recordId: this.recordId, objectName: this.objectApiName })
                        .then(result => {
                              if (result) {
                                    if (this.objectApiName == 'Account') {

                                          /*result.clientNews.forEach(element => {
                                                element.convictedDirectors__c = element.convictedDirectors__c.slice(3, element.convictedDirectors__c.length - 4);

                                          });
                                          this.dataConvection = result.clientNews;

                                    }
                                    else {
                                          this.showDataTable = true;
                                          this.dataFromMCA = true;
                                          this.dataConvection = result.clientNews;
                                    }
                              }
                              else {
                                    console.log('Result is empty and data : ', this.dataConvection);
                                    this.showDataTable = false;
                                    this.showMessageOfData = 'No client news!!! ajay';
                              }
                              this.isLoading = false;
                        })
                        .catch(error => {
                              console.log('Error : ', error);
                              this.showDataTable = false;
                              this.showMessageOfData = 'No client news!!!';
                              this.isLoading = false;
                        })    */        

      }
      
      handleChangeKeyAccounts(event){
            console.log('event  ',event.detail.value);
            if(event.detail.value =='All'){
                  this.keyAccountData  = this.allKeyAccountData;
            }
            else{
                  let clientNews=[];
                  for(let i = 0; i <this.allKeyAccountData.length; i++){
                        
                        if(this.allKeyAccountData[i].Client__c == event.detail.value){
                              clientNews.push(this.allKeyAccountData[i]);
                        }
                  }
                  this.keyAccountData  = clientNews;
            }
      }
}