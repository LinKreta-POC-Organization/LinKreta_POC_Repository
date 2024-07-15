import { LightningElement, track ,api} from 'lwc';
import clientByGtClientGroup from '@salesforce/apex/clientByGtClientGroup.getRecord';
import clientByGtClientGroupALl from '@salesforce/apex/clientByGtClientGroup.getRecordFilter';



const columns = [
{
    label: 'Client Name',
    fieldName: 'accLink',
    type: 'url',
    typeAttributes:
    { 
        label: { fieldName: 'Name' },
        target: '_blank'
    },

    
},
{
    label: 'GT Client Group',
    fieldName: 'urLinkGt',
    type: 'url',
    typeAttributes:
    { 
        label: { fieldName: 'GtName' },
        target: '_blank'
    },

},
/*{
    label: 'New Client',
    fieldName: 'urLinkNewClient',
    type: 'url',
    typeAttributes:
    { 
        label: { fieldName: 'NewClient' },
        target: '_blank'
    },

},
{
    label: 'Sector',
    fieldName: 'Sector__c',
    type: 'Text',
   

},*/

{
    label: 'Sector',
    fieldName: 'Industry__c',
    type: 'Text',
   

},

{
    label: 'Owner',
    fieldName: 'urLinkOwner',
    type: 'url',
    typeAttributes:
    { 
        label: { fieldName: 'OwnerName' },
        target: '_blank'
    },

}

]
export default class ClientByGtClientGroup extends LightningElement {
@track data = [];
@api recordId;
columns = columns;
@track options=[];
@track allData = [];
value = "";

connectedCallback(){
this.options = [];
console.log('recordId>>>>>>>>>>>>>>>>>',this.recordId);
if(this.recordId)
    this.getAllClientWithGTClient(this.recordId);
    
}

getAllClientWithGTClient(recId){
console.log('RecId ',recId);
clientByGtClientGroup({recordId : recId})
    .then(result => {
        console.log('recordId>>>>>>>>>>>>>>>>>',this.recordId);
        console.log('result>>>>>>>>>>>>>>>>>>>>>>>> ',result);
        var mapOption =  JSON.parse(JSON.stringify(result));
        console.log('mapOption ',mapOption);
        var tempList = [];
        this.allData = [];
        tempList.push({label:'All',value:'All'});
        for (let key in result) {
            console.log('key in map ',key);
            console.log('result[key]',result[key][0].GT_Client_Group__c);
            
            tempList.push({ label: key, value: result[key][0].GT_Client_Group__c});
            this.options = JSON.parse(JSON.stringify(tempList));
            console.log('optionsss>',this.options);
            console.log('JSON.parse(JSON.stringify(result[key]) ',JSON.parse(JSON.stringify(result[key])));
            var dataValue = JSON.parse(JSON.stringify(result[key]));
            dataValue.forEach(res =>{
                console.log('res ',res);
                res.accLink = '/' + res.Id;
                res.urLinkGt = '/' + res.GT_Client_Group__c;
                res.urLinkOwner = '/' + res.Owner.Id;
                res.OwnerName =  res.Owner.Name;
                res.GtName = key;
                if(res.New_Client__r != null){
                res.urLinkNewClient = '/' + res.New_Client__r.Id;
                res.NewClient = res.New_Client__r.Name;
                }
            })
            console.log('dataValue ',dataValue);
            dataValue.forEach(res =>{
                this.allData.push(res);
            })
            }
            console.log('this.allData',this.allData);
        //   for (let res in result) {
        //             console.log('res>>>>', res);
        //             console.log('Name >>>>', result[res].Name);
        //             this.options.push({ label: res, value: res});
        //          }
            console.log('optionsss>',this.options);
        //this.data = JSON.parse(JSON.stringify(result));
        console.log('data>>>>>>>>>>>>',this.data);  
    })
    .catch(error => {
        console.log('error ',error);
    });


    
}
handleChange(event) {
    console.log('indisevaluee>>>>>');
    this.value = event.detail.value;
    if(this.value == 'All'){
        this.getAllClientWithGTClient(this.recordId);
        return;   
    }
    console.log('this.value ',this.value);

    clientByGtClientGroupALl({ recordId : this.recordId , SelectedValue : this.value} )
    .then(result => {
        console.log('filte',result);
        var lastData = JSON.parse(JSON.stringify(result));
        this.allData = [];
        lastData.forEach(res => {
            console.log('res>>??',res);
            res.accLink = '/' + res.Id;
            res.GtName = res.GT_Client_Group__r.Name;
            res.urLinkGt = '/' + res.GT_Client_Group__c;
            res.urLinkOwner = '/' + res.Owner.Id;
                res.OwnerName =  res.Owner.Name;
            if(res.New_Client__r != null){
                res.urLinkNewClient = '/' + res.New_Client__r.Id;
                res.NewClient = res.New_Client__r.Name;
                }
            console.log('res>>$$$?',res);
        });
        console.log('lastData>>',lastData);
        lastData.forEach(res =>{
            this.allData.push(res);
        })
        console.log('allData',this.allData);
        // this.allData = result;

    })
    .catch(error =>{

    })
}


}