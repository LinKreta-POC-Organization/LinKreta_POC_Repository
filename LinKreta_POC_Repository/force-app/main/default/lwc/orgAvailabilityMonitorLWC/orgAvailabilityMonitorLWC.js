import { LightningElement, track, wire} from 'lwc';

import orgAvailabilityMonitors from '@salesforce/apex/OrgAvailabilityMonitor.getOrgAvailabilityMonitors';

export default class OrgAvailabilityMonitorLWC extends LightningElement {

     @track columns = [
          { label: 'Id', fieldName: 'Id' },
          { label: 'Program Name', fieldName: 'Name' },
          { label: 'Portfolio Name', fieldName: 'Portfolio_Name__c'},
          { label: 'Feature Name', fieldName: 'Feature_Name__c'},
          { label: 'Monitoring URL', fieldName: 'Monitoring_URL__c'}
      ];

     @track monitorList;

     @wire (orgAvailabilityMonitors) wiredphotos({data,error}){
          if (data) {
            this.monitorList = data;
          console.log(data); 
          } else if (error) {
            console.log(error);
          }
     }
}