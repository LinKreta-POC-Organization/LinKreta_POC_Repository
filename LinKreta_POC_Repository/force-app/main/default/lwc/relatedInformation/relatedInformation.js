import { LightningElement,track,api} from 'lwc';
export default class RelatedInformation extends LightningElement {
    @track relatedContacts = [];
    @track relatedEnquiries = [];
    @track relatedJobs = [];

    @track columnsCont = [
        { label: 'Contact Name', fieldName: 'contactName' },
        { label: 'Client Entity', fieldName: 'clientEntity' },
        { label: 'Designation', fieldName: 'designation'},
        { label: 'Client Group', fieldName: 'clientGrp'}
    ];
    @track columnsEnq = [
        { label: 'Enquiry', fieldName: 'enquiry' },
        { label: 'Client Entity', fieldName: 'clientEntity' },
        { label: 'Stage', fieldName: 'stage'},
        { label: 'Amount', fieldName: 'amount'}
    ];
    @track columnsJobs = [
        { label: 'Job Name', fieldName: 'name' },
        { label: 'Client', fieldName: 'clientEntity' },
        { label: 'Expertise', fieldName: 'expertise'},
        { label: 'Status', fieldName: 'status'}
    ];


    connectedCallback() {
        let wrp = {srno:1,contactName : 'Anil',clientEntity:'Anil Textiles Pvt Ltd',designation:'CEO',clientGrp:'Anil Textiles'};
        let wrp2 = {srno:2,contactName : 'Piyush',clientEntity:'Anil Capitals Pvt Ltd',designation:'Delivery Manager',clientGrp:'Anil Capitals'};
        let wrp3 = {srno:3,contactName : 'Tania',clientEntity:'Anil Motors Pvt Ltd',designation:'Sales Manager',clientGrp:'Anil Motors'};
        let wrp4 = {srno:4,contactName : 'Shivansh',clientEntity:'Anil Chemicals Pvt Ltd',designation:'Regional Head',clientGrp:'Anil Chemicals'};
        let wrp5 = {srno:5,contactName : 'Kabir',clientEntity:'Anil Textiles Pvt Ltd',designation:'Regional Distributor',clientGrp:'Anil Textiles'};
        this.relatedContacts.push(wrp);
        this.relatedContacts.push(wrp2);
        this.relatedContacts.push(wrp3);
        this.relatedContacts.push(wrp4);
        this.relatedContacts.push(wrp5);

        let wrpEnq = {srno:1,enquiry:'EN-001',clientEntity:'Anil Textiles',stage:'Client Take on',amount:500000};
        let wrpEnq2 = {srno:2,enquiry:'EN-002',clientEntity:'Anil Motors',stage:'Accept Client',amount:700000};
        let wrpEnq3 = {srno:3,enquiry:'EN-003',clientEntity:'Anil Chemicals',stage:'New',amount:530000};
        let wrpEnq4 = {srno:4,enquiry:'EN-004',clientEntity:'Anil Capitals',stage:'Not Accepted Client',amount:424000};
        let wrpEnq5 = {srno:5,enquiry:'EN-005',clientEntity:'Anil Finance',stage:'Client Take-on PreWork',amount:320000};
        this.relatedEnquiries.push(wrpEnq);
        this.relatedEnquiries.push(wrpEnq2);
        this.relatedEnquiries.push(wrpEnq3);
        this.relatedEnquiries.push(wrpEnq4);
        this.relatedEnquiries.push(wrpEnq5);

        let wrpJob = {srno:1,name:'Auditing',clientEntity:'Anil Textiles Pvt Ltd',expertise:'Audit',status:'Monitor'};
        let wrpJob2 = {srno:2,name:'Cyber Security Head',clientEntity:'Anil Motors',expertise:'Cyber Security',status:'New Project'};
        let wrpJob3 = {srno:3,name:'Business Analyst',clientEntity:'Anil Capitals',expertise:'Business Intelligence',status:'Closure'};
        let wrpJob4 = {srno:4,name:'Lead Consultant',clientEntity:'Anil Motors',expertise:'Lead Advisory',status:'Kick-Off'};
        let wrpJob5 = {srno:5,name:'Forensic Expert',clientEntity:'Anil Chemicals',expertise:'Forensic Science',status:'New-Project'};
        this.relatedJobs.push(wrpJob);
        this.relatedJobs.push(wrpJob2);
        this.relatedJobs.push(wrpJob3);
        this.relatedJobs.push(wrpJob4);
        this.relatedJobs.push(wrpJob5);
    }
    handleToggleSection(){

    }
}