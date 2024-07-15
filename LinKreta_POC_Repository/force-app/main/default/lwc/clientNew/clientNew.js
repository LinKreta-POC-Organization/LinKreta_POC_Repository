import { LightningElement, track, wire, api } from 'lwc';
import IMAGES from "@salesforce/resourceUrl/static_images";
//import companylist from '@salesforce/apex/newClientNew.ClientNewSearch';    //for api call results
import tempCompanylist from '@salesforce/apex/newClientNew.tempClientNewSearch';
import clientNewSearchByName from '@salesforce/apex/newClientByCompanyNameIQ.ClientNewSearchByName';
import clientNewTracker from '@salesforce/apex/newClientByCompanyNameIQ.clientnewSearchForLoc';
import clientNewSearchId from '@salesforce/apex/newClientByCompanyNameIQ.ClientNewSearchId';
import clientFieldDataCapIQ from '@salesforce/apex/newClientByCompanyNameIQ.clientDifferentField';
import clientFieldEntityDataMCA from '@salesforce/apex/newClientDataFromMCA.newClientCompanySearchEnityData';
import clientFieldFinanceDataMCA from '@salesforce/apex/newClientDataFromMCA.newClientCompanySearchFinanceData';
import clientGroupNameFromMCAAnnualReturn from '@salesforce/apex/newClientDataFromMCA.clientGroupNameFromMCAAnnualReturn';
import clientFieldCorpFinanceDataMCA from '@salesforce/apex/newClientDataFromMCA.newClientCompanySearchCorpFinanceData';
import newClientGST from '@salesforce/apex/newClientDataFromMCA.newClientGST';
import createCompetitor from '@salesforce/apex/createCompetitor.createCompetitorFromCAPIQAura';
import createInvestors from '@salesforce/apex/createInvestors.createInvestorsFromCAPIQAura';
import createClientNews from '@salesforce/apex/createClientNews.createClientNewsFromCAPIQAura';
import createJointVenture from '@salesforce/apex/createJointVenture.createJointVentureFromCAPIQAura';
import createSubsidiarys from '@salesforce/apex/createSubsidiarys.createSubsidiarysFromCAPIQAura';

import newClientAlertsData from '@salesforce/apex/newClientDataFromMCA.newClientAlertsDataAura';
import createCompetitorFromMCA from '@salesforce/apex/createCompetitor.createCompetitorFromMCAAura';
import createInvestorsFromMCA from '@salesforce/apex/createInvestors.createInvestorsFromMCAAura';
import createInvestorsFromMCAAnnualReturn from '@salesforce/apex/createInvestors.createInvestorsFromMCAAnnualReturnAura';
import newClientAlertsDataCourtCase from '@salesforce/apex/newClientDataFromMCA.newClientAlertsDataCourtCaseAura';

import clientNewSearchByNamemca from '@salesforce/apex/newClientDataFromMCA.newClientCompanySearchByName';
import newClientCompanyCrossDirectorShipFormerData from '@salesforce/apex/newClientDataFromMCA.newClientCompanyCrossDirectorShipFormerData';
import newClientCompanyCrossDirectorShipCurrentData from '@salesforce/apex/newClientDataFromMCA.newClientCompanyCrossDirectorShipCurrentData';
import checkduplicate from '@salesforce/apex/CheckDuplicateForNewClient.checkduplicate';
import industriesValues from '@salesforce/apex/dependancySectorWithSolution.PicklistValues';
import leadSourceValues from '@salesforce/apex/dependancySectorWithSolution.newClientSourcePicklistValues';
import accountValues from '@salesforce/apex/dependancySectorWithSolution.fetchAccount';
import contactValues from '@salesforce/apex/dependancySectorWithSolution.fetchContact';
import NEW_CLIENT_OBJ_NAME from '@salesforce/schema/Lead';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { encodeDefaultFieldValues } from 'lightning/pageReferenceUtils';
import detailSection from '@salesforce/label/c.Details_Section';
import ReferralSection from '@salesforce/label/c.referral';
import SectorSection from '@salesforce/label/c.Sector_Section';
import ClientSection from '@salesforce/label/c.Client_Section';
import CreateLead from '@salesforce/apex/CreateleadHelper.Createlead';
import CheckDuplicateAccount from '@salesforce/apex/CreateleadHelper.findDuplicateAccount';
import getExpertiseOptionsApex from '@salesforce/apex/newClientNew.getExpertise';
import FORM_FACTOR from '@salesforce/client/formFactor'

// By Ravi...
const Colume = [{ label: 'New Client Name', fieldName: 'Name', type: 'text' }, { label: 'Owner Name', fieldName: 'Owner.Name', type: 'text' }, { label: 'Parent Name', fieldName: 'Parent.Name', type: 'text' }];
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
export default class ClientNew extends NavigationMixin(LightningElement) {
    detailSection = detailSection;
    ClientSection = ClientSection;
    SectorSection = SectorSection;
    ReferralSection = ReferralSection;
    @track isMobileValid = false;
    @track ifExternalData = false;
    @track resultFromnewClientGSTFourth;
    @track resultFromnewClientGSTThird;
    @track resultFromnewClientGSTsecond;
    @track shortMessageLoader = 'Loading....';
    @track resultFromnewClientGSTFirst;
    @track searchCompany1;
    @track constitutionOfBusiness;
    @track capIQ;
    @track mcaId;
    @track about;
    @track capIqCreatedBy = 'No';
    @track modifiedByCapIq;
    @track ifMcaCallout = false;
    @track mcaData = false;
    @track showCapIq = false;
    @track totalAssets;
    @track totalCurrentAssets;
    @track totalCL;
    @track clientId;
    @track totalDebt;
    @track totalEquity;
    @track totalLiab;
    @track employees;
    @track totalRev;
    @track ebit;
    @track mainActivity;
    @track businessActivity;
    @track companyStatus;
    @track ebitda;
    @track companyTickter;
    @track primarySIC;
    @track ceoName;
    @track iqULTParent;
    @track companyType;
    @track companyHQAddress;
    @track shortDescription;
    @track exchange;
    @track showexternalbutton = false;
    @track companyWebsite;
    @track longDescription;
    @track yearFounded;
    @track yearFoundedForAbout;
    @track ifSearch = false;
    @track chairmanName;
    @track countryINC;
    @track iqRev;
    @track boardMember;
    @api searchCompany;
    @track searchString = '';
    @track companylist = '';
    @track companylists = [];
    @track companyEmail = '';
    @track companyMobilePhone = '';
    @track companyWebsite = '';
    @track companyHowCanWeHelpYou = '';
    @track companyExpertise = '';
    @track companySubSector = '';
    @track companySector = '';
    @track companySubExpertise = '';
    @track companyCorridor = '';
    @track companyCompanyHQ = '';
    @track companyAddress = '';
    @track companyChamber = '';
    @track companyClientName = '';
    @track companyLawFirmContacts = '';
    @track companyLawFirm = '';
    @track companyClientContact = '';
    @track companyInboundReferral = '';
    @track companyGTEmployee = '';
    @track countryCode = '';
    @track companySolution = '';
    @track isDisabed = false;
    @track isDisabedDuplicate = false;
    @track isShowModal = false;
    @track companySubsector = '';
    @track channelValue = '';
    @track byPassIfClientOrContactNull = true;
    @track street;
    @track city;
    @track state;
    @track companyZIP;
    @track country;
    isGTEmpDisabled = true;
    isInboundDisabled = true;
    isLowFirmDisabled = true;
    isClientContactDisabled = true;
    isChamberDisabled = true;
    isPEVCConDisabled = true;
    isPEVCDisabled = true;
    @track mapOfValues = [];
    @track data1 = [];
    @track mapOfValuesCapIQ = [];
    @track PevcConRefVal = '';
    @track PevcRefVal = '';
    @track companyChambercontact = '';
    @track showParent = false;


    @track ifclick = false;
    fieldValueForValidation;

    @track searchString = '';
    companyListResult = [];

    @track options = [];
    value = '';
    @track valuedataupdateCheck = false;
    @track showAccordians = false;
    @track showFields = true;
    @track showError = false;
    @track isNotCampaign = false;
    @track companyName = '';
    @track clientData;
    @track entityId;
    @track ifResult = false;
    @track ifExisting = false;
    newClientObjName = NEW_CLIENT_OBJ_NAME.objectApiName;
    @track isClientduplicate = false;
    @track companyCorridor = '';
    @track capIQresultcounter = 0;
    @track fullAddresMCA = '';
    @track expertiseOptions = [];
    @track selectedExpertise = [];
    @track selectedValues = [];

    handleSelect(event) {
        try {
            const selectedValues = event.detail.selectedValues;
            this.selectedExpertise = selectedValues;
            this.leadObject.Enquiry_Expertise__c = event.detail.selectedValuesString;
        } catch (error) {
            console.log('Expertise select error : ', error);
        }

    }

    counter = 0;


    CountryNameValue = 'India';

    activeAccordionSections = ['details', 'companies', 'address', 'referralInfo', 'sectors'];
    ifData = false
    cols = COLS;
    colume = Colume;
    @track arrDataList = [];
    @track leadObject = {
        FirstName: '',
        LastName: '',
        Designation__c: '',
        Description: '',
        Enquiry_Type__c: '',
        is_Enquiry_Created_For_Existing_Client__c: false,
        Existing_Client__c: '',
        Status: 'Internal / External Discussions',
        Enquiry_Expertise__c: '',
        Industry__c: '',
        Referral_Client__c: '',
        Referral_Contact__c: '',
        Email: '',
        Company: '',
        MobilePhone: '',
        countryCode__c: '',
        LeadSource: 'Manual',
        State: '',
        Street: '',
        City: '',
        PostalCode: '',
        Country: '',
        SubIndustry__c: '',
        Total_Assets__c: '',
        Total_Current_Assets__c: '',
        Total_Current_Liabilities__c: '',
        Total_Debt__c: '',
        Total_Equity__c: '',
        Total_Liabilities__c: '',
        Total_Diluted_Earning_Loss_per_Share__c: '',
        Industry__c: '',
        CEO_Name__c: '',
        Global_Ultimate_Owner__c: '',
        Public_Private_Company__c: '',
        Listed__c: '',
        Ticker_Symbol__c: '',
        Currency_Format__c: '',
        External_Database_Source__c: 'None',
        Company_Status__c: '',
        Total_No_of_employees__c: '',
        Total_Revenue__c: '',
        Earnings_Before_Interest_and_Taxes_EBIT__c: '',
        EBITDA__c: '',
        Chairman_Name__c: '',
        Country_of_Incorporation__c: '',
        Board_of_Directors__c: '',
        MCA_ID__c: '',
        Stock_Exchange_symbol__c: '',
        Website: '',
        Company_Overview__c: '',
        Year_Founded__c: '',
        Chairman_Name__c: '',
        Revenue__c: '',
        capIQId__c: '',
        SIC_Code__c: '',
        LawFirm__c: '',
        Channel__c: '',
        InboundReferral__c: '',
        GTEmployee__c: '',
        Chamber_contacts__c: '',
        Chamber__c: '',
        InvestorsPrivateEquityFirms__c: '',
        Investors_Private_Equity_Firms__c: '',
        LawFirmContacts__c: '',
        ClientName__c: '',
        ClientContact__c: '',
        Financial_Year__c: '',
        ClientBackground__c: '',
        Gross_Profit__c: '',
        Net_Income__c: '',
        Intermediary_Referral_Person_Name__c: '',
        Intermediary_Referral_Firm_Name__c: '',
        GT_Alumni_Name__c: '',
        GTI_Member_Firm_Referring_Person_s_name__c: '',
        GTI_Member_Firm_Office__c: '',
        GTI_Member_Firm_Referral_Country__c: '',
        Independent_Director_Contact_Name__c: '',
        Investment_Bank_Firm_Name__c: '',
        Investment_Bank_Contact_Name__c: '',
        Client_Group_Name__c: '',
        Client_Group_Name_CIQID__c: '',
        Global_Ultimate_Owner_ID__c: '',
        CompanyHQ__City__s: '',
        CompanyHQ__StateCode__s: '',
        CompanyHQ__PostalCode__s: '',
        CompanyHQ__Street__s: '',
        CompanyHQ__CountryCode__s: '',
        KMP__c: '',
        NewClientEmail__c: '',
        Domestic_Ultimate_Owner__c: '',
        ISIN_Number__c: '',
        EntityId__c: '',
        Company_Phone_No__c: '',
        Current_Auditor_Name__c: '',
        Closing_Price__c: '',
        CurrentBODcompanyDateofAppointmen__c: '',
        Former_BOD_company_Date_of_Appointmen__c: '',
        PAN__c: '',
        Shared_Up_Capital__c: ''
    };
    isLoading = false;
    isIndependentDirectors = false;
    isGlobalDelivery = false;
    isnvestmentBank = false;
    isLoading = false;

    isGtAlumni = false;
    isintermediaryRef = false;
    isCampaign = false;
    isMinimumChar = false;
    @track ListAllypes;
    @track TypeOptions;
    @track ListAllypesLeadSource;
    @track TypeOptionsLeadSource;
    @track companyTypeForAbout;
    @track stateCountForAbout;
    @track branchCountForAbout;
    @track TypeOptionsAccount;
    @track TypeOptionsContact;
    isIndustrydisable = true;
    isClientContactDisabled = false;
    accountRecordID = '';
    isLawFirm = false;
    isExistingClient = false;
    isChamberShow = false;
    isInvesterPrivate = false;
    isGtEmployee = false;
    isGtMemberFirm = false;

    isLawFirmContact = false;
    isInvesterPrivateContact = false;
    isExistingClientContact = false;
    isnvestmentBankContact = false;
    pastClient = false;
    isSave = true;
    isSearchDisabled = false;

    marginLeft = '';
    inputVariant = '';
    deskTop;
    @track accountId;
    @track isShowModalIE = false;
    @track inputVariables = [
        {
            name: "recordId",
            type: "String",
            value: this.accountId,
        },
        {
            name: 'calledFromLWC',
            type: 'Boolean',
            value: true
        }
    ];

    @track recordTypeName = 'LawFirmIndependentDirectors';
    renderCallback() {
        let sldsElement = this.template.querySelectorAll('slds-form-element__help');
        sldsElement.forEach(result => {
            console.log('line 277');
            result.className = 'slds-form-element__help slds-m-left_medium';
        });
    }

    contactFieldChange(event) {
        console.log('=======' + event.detail.value);
        this.leadObject.Referral_Contact__c = event.detail.value;
        if (event.detail.value == 'PEVC') {

        }
    }

    clientFieldChange(event) {
        console.log('=======' + event.detail.value);
        this.leadObject.Referral_Client__c = event.detail.value;
        console.log('Account Id :' + this.leadObject.Referral_Client__c);
        if (event.detail.value != null) {
            contactValues({ accountId: this.leadObject.Referral_Client__c })
                .then((data) => {
                    if (data) {
                        try {
                            console.log('1204', data);
                            let options = [];
                            for (var key in data) {
                                options.push({ label: data[key].picklistvalue, value: data[key].recordId });

                            }
                            console.log('options', options);
                            this.TypeOptionsContact = options;


                        } catch (error) {
                            console.error('check error here', error);
                        }

                    }
                })
        }
    }
    connectedCallback() {
        this.handleFormFactor();

        leadSourceValues()
            .then(data => {
                if (data) {
                    try {
                        this.ListAllypesLeadSource = data;
                        let options = [];
                        for (var key in data) {
                            options.push({ label: data[key].picklistlabel, value: data[key].picklistvalue });

                        }
                        this.TypeOptionsLeadSource = options;


                    } catch (error) {
                        console.error('check error here', error);
                    }

                }
            }).catch(error => {
                console.log('1221', error)
            });

        this.getExpertiseOptions();

    }

    handleFormFactor() {
        if (FORM_FACTOR === "Large") {
            this.inputVariant = 'label-hidden';
            this.marginLeft = 'slds-m-left_medium'; 
            this.deskTop = true;           
        } else if (FORM_FACTOR === "Medium") {
            this.inputVariant = "";
        } else if (FORM_FACTOR === "Small") {
            this.inputVariant = "";
            this.marginLeft = ''; 
        }
    }
    
    getExpertiseOptions() {
        getExpertiseOptionsApex()
            .then(result => {
                result.forEach(element => {
                    this.expertiseOptions.push({ label: element.Name, value: element.Id })
                });
            })
            .catch(error => {
                // TODO Error handling
            });
    }

    apexCallWithCondition() {
        accountValues({ allianceType: this.channel })
            .then((data) => {
                if (data) {
                    try {
                        console.log('1204', data);
                        let options = [];
                        for (var key in data) {
                            options.push({ label: data[key].picklistvalue, value: data[key].recordId });

                        }
                        this.TypeOptionsAccount = options;


                    } catch (error) {
                        console.error('check error here', error);
                    }

                }
            })
    }

    handleCompanyNameChange(event) {
        this.isDisabedDuplicate = false;
    }

    handleCountryNameChange(event) {
        this.CountryNameValue = event.detail;
        this.ifData = false;
        this.isDisabedDuplicate = false;
        this.ifExternalData = false;
        if (this.ifExternalData == false && this.ifSearch == true)
            this.showexternalbutton = true;

    }
    exclamationImage = IMAGES + '/static_images/images/exclamation_1.png';

    // by Ravi  

    async callRowAction(event) {
        this.isLoading = true;
        console.log('---->>> call ROw Action  this.searchString  <<<------', event);
        this.leadObject.Company = event.detail.row.companyName;
        console.log('event.detail.row.Name', event.detail.row.companyName);
        this.getClientDetails(this.leadObject.Company);
       
    }

    async getClientDetails(companyName){
        try {

            this.isLoading = true;
            console.log('getClientDetails', companyName);
            this.leadObject.Company = companyName;

            console.log('159  --->this.showAccordians', this.showAccordians);
            console.log('this.searchString ', this.searchString);
            if (this.searchString != '') {
                console.log(this.searchString);
                tempCompanylist({ searchString: this.searchString })
                    .then((result) => {
                        if (result.length > 0 && this.searchString != '') {
                            this.ifSearch = false;
                            let data = JSON.parse(JSON.stringify(result));
                            for (var i = 0; i < data.length; i++) {
                                data[i].rowNumber = i + 1;
                            }
                            this.clientData = data;
                            this.ifData = false;
                            this.ifResult = true;
                            this.ifclick = false;
                            this.companyName = this.searchString;
                            this.showError = false;
                        } else if (result.length > 0 && this.searchString == '') {
                            console.log('Step 2');
                            this.ifSearch = false;
                            this.clientData = '';
                            this.ifData = false;
                            this.ifResult = false;
                            this.companyName = this.searchString;
                            this.ifExisting = false;
                            this.ifclick = true;

                        } else if (result.length == 0) {
                            this.ifSearch = true;

                            console.log('Step 3', result.length);
                            this.clientData = '';
                            this.ifData = false;
                            this.ifResult = false;
                            this.showAccordians = true;
                            this.companyName = this.searchString;
                            this.ifExisting = true;
                            //this.showError = false;
                            this.ifclick = false;
                            console.log('<---204---->');
                        }

                    })
                    .catch((error) => {
                        console.log("212  an error has occured :  ", error);
                    })
            }
            else {
                this.ifSearch = false;
                this.ifData = false;
                this.ifResult = false;
                this.showAccordians = false;
                this.companyName = this.searchString;
                this.ifExisting = false;
                this.showError = false;
                this.ifSearch = false;
            }

            this.ifData = false;
            for (let x in this.mapOfValuesCapIQ) {
                this.companyName = this.leadObject.Company;
                console.log(' 390 --- > this.searchString', this.leadObject.Company);
                console.log(' 390 --- > this.searchString', this.companyName);
                if (this.mapOfValuesCapIQ[x].companyName == this.companyName) {
                    let arrayData = this.mapOfValuesCapIQ[x].key.split('$$$$');
                    this.mcaId = arrayData[0];
                    this.entityId = arrayData[1];
                }
                console.log(' 421 --- > this.mcaId', this.mcaId);
                console.log(' 422 --- > this.entityId', this.entityId);
            }


            this.companyName = this.leadObject.Company;
            if (this.ifMcaCallout == false) {
                this.isDisabed = true;
                this.isLoading = true;
                await clientNewSearchId({ companyName: this.companyName })
                    .then((result) => {
                        this.leadObject.capIQId__c = result;
                    }).catch((error) => {
                        console.log("250 an error has occured :  ", error);
                    })
                this.fatchDataFromExternalDataBase();

            }
            else if (this.ifMcaCallout == true) {

                this.isLoading = true;
                console.log('this.isLoading ', this.isLoading, 'this.ifMcaCallout ', this.ifMcaCallout);
                this.leadObject.MCA_ID__c = this.mcaId;
                this.leadObject.EntityId__c = this.entityId;
                this.leadObject.External_Database_Source__c = 'MCA';
                this.leadObject.Currency_Format__c = 'INR in lacs';
                console.log('Mca ID ---->', this.mcaId);
                console.log('SIC_Code__c first ---->', this.entityId.substring(1, 6));
                if (this.entityId.substring(1, 6) !== 'ull') {
                    this.leadObject.SIC_Code__c = this.entityId.substring(1, 6);
                    
                }
                this.leadObject.CompanyHQ__CountryCode__s = 'IN';
                Promise.all([newClientCompanyCrossDirectorShipCurrentData({ mcaId: this.entityId })
                    .then((result) => {
                        console.log('clientGroupNameFromMCAAnnualReturn ', result);
                        this.leadObject.CurrentBODcompanyDateofAppointmen__c = result;


                    }).catch((error) => {
                        console.log("newClientCompanyCrossDirectorShipCurrentData :  ", error);
                    }),
                clientGroupNameFromMCAAnnualReturn({ mcaId: this.entityId })
                    .then((result) => {

                        console.log('clientGroupNameFromMCAAnnualReturn ', result);
                        this.leadObject.Client_Group_Name__c = result[0];
                        this.mainActivity = result[1];
                        this.businessActivity = result[2];

                    }).catch((error) => {

                        console.log("263  an error has occured :  ", error);
                    }), clientFieldCorpFinanceDataMCA({ mcaId: this.entityId })
                        .then((result) => {
                            console.log('clientFieldCorpFinanceDataMCA ', result);
                            this.leadObject.Total_Assets__c = result[0];
                            this.leadObject.Total_Current_Assets__c = result[1];
                            this.leadObject.Total_Debt__c = result[3];
                            this.leadObject.Total_Equity__c = result[4];
                            this.leadObject.Total_Current_Liabilities__c = result[2]
                            this.leadObject.Total_Liabilities__c = result[5];
                            this.leadObject.Total_Diluted_Earning_Loss_per_Share__c = result[6];
                            this.leadObject.Total_Revenue__c = result[7];
                            this.leadObject.Current_Auditor_Name__c = result[8];
                            this.leadObject.Financial_Year__c = result[9];
                        }).catch((error) => {
                            console.log("275 an error has occured :  ", error);
                        }), clientFieldFinanceDataMCA({ mcaId: this.entityId })
                            .then((result) => {
                                console.log('clientFieldFinanceDataMCA ', result);
                                this.leadObject.Net_Income__c = result[0];
                                this.leadObject.Earnings_Before_Interest_and_Taxes_EBIT__c = result[1];
                                this.leadObject.EBITDA__c = result[2];
                                this.leadObject.Gross_Profit__c = result[3];
                                this.ebit = result[3];
                                this.ebitda = result[0];
                                console('this.ebit ----->', this.ebit, this.ebitda);
                            }).catch((error) => {
                                console.log("263  an error has occured :  ", error);
                            }), newClientCompanyCrossDirectorShipFormerData({ mcaId: this.entityId })
                                .then((result) => {
                                    console.log('clientGroupNameFromMCAAnnualReturn ', result);
                                    this.leadObject.Former_BOD_company_Date_of_Appointmen__c = result;


                                }).catch((error) => {
                                    console.log("newClientCompanyCrossDirectorShipFormerData :  ", error);
                                }), clientFieldEntityDataMCA({ mcaId: this.mcaId })
                                    .then((result) => {
                                        console.log('clientFieldEntityDataMCA ', result);
                                        this.leadObject.CompanyHQ__City__s = result[16];
                                        this.leadObject.CompanyHQ__StateCode__s = result[17];
                                        this.leadObject.CompanyHQ__Street__s = result[0];
                                        this.leadObject.CompanyHQ__PostalCode__s = result[18];
                                        this.leadObject.Company_Status__c = result[1];
                                        this.leadObject.Ticker_Symbol__c = result[2];
                                        if (result[3].length > 2) {
                                            this.leadObject.Country_of_Incorporation__c = result[3];
                                        }
                                        else {
                                            this.leadObject.Country_of_Incorporation__c = 'India';
                                        }

                                        this.leadObject.Domestic_Ultimate_Owner__c = result[4];
                                        this.leadObject.ISIN_Number__c = result[5];
                                        this.leadObject.Global_Ultimate_Owner__c = result[6];
                                        this.leadObject.Year_Founded__c = result[7];
                                        this.leadObject.Public_Private_Company__c = result[8];
                                        this.leadObject.Listed__c = result[9];
                                        this.leadObject.Industry__c = result[10];
                                        this.leadObject.NewClientEmail__c = result[11];
                                        this.leadObject.Company_Phone_No__c = result[12];
                                        this.leadObject.Board_of_Directors__c = result[13];
                                        this.leadObject.Website = result[15];
                                        this.leadObject.Financial_Year__c = result[14];
                                        this.leadObject.KMP__c = result[19];
                                        this.leadObject.CEO_Name__c = result[20];
                                        this.leadObject.Chairman_Name__c = result[21];
                                        this.leadObject.Closing_Price__c = result[22];
                                        this.companyTypeForAbout = result[23];
                                        this.stateCountForAbout = result[24];
                                        this.branchCountForAbout = result[25];
                                        this.yearFoundedForAbout = result[26];
                                        this.yearFounded = result[14];
                                        this.leadObject.Total_No_of_employees__c = result[27];
                                        this.leadObject.Shared_Up_Capital__c = result[29];
                                        this.leadObject.PAN__c = result[30];
                                        this.leadObject.Stock_Exchange_symbol__c = result[31];
                                        this.constitutionOfBusiness = result[33];
                                        this.fullAddresMCA = result[34];
                                    }).catch((error) => {
                                        console.log("263  an error has occured :  ", error);
                                    }),
                newClientGST({ mcaId: this.mcaId })
                    .then((result) => {
                        console.log('newClientGST ', result);
                        this.resultFromnewClientGSTFirst = result[0];
                        this.resultFromnewClientGSTsecond = result[1];
                        this.resultFromnewClientGSTThird = result[2];
                        this.resultFromnewClientGSTFourth = result[3];

                    }).catch((error) => {
                        console.log("563 an error has occured :  ", error);

                    })



                ]).then((result) => {

                    this.isDisabed = false;
                    this.isLoading = false;
                    this.showAccordians = true;
                }).catch(error => {


                });



                console.log('287');
            }
            console.log('298');

            this.ifResult = false;
            console.log('about ------ >>>>>>>', this.about);
        }
        catch (error) {
            console.log('getClientDetails error : ' , error);
        }
    }

    // ENd.....
    //for checking the length of mobile number
    handleMouseoutOnMobile(event) {
        let phoneField = this.template.querySelector('.phone_number__c');
        console.log('mobile on out ', event.target.value);
        let numberLength = event.target.value;
        console.log('length', numberLength.length);
        if (numberLength.length < 10 && numberLength.length >= 1 && this.countryCode == 'India (+91)') {
            phoneField.setErrors({ 'body': { 'output': { 'fieldErrors': { 'MobilePhone': [{ 'message': 'Mobile Number should be 10 Digits' }] } } } });

        }

    }
    handleMCAClick() {
        console.log(this.searchString);
        if (this.searchString != '') {
            this.ifclick = false;
            this.companyName = this.searchString;
            this.mcaData = true;
            console.log('this.searchString  ---->>', this.searchString);
            clientNewSearchByNamemca({ searchString: this.searchString })
                .then((data) => {
                    console.log('588 ---> ', data);
                    if (data) {
                        let arrDataListTemp = [];
                        for (let x in data) {
                            let arrData = {};
                            let arrname = {};
                            arrname = data[x].split('$$$$');
                            this.mapOfValuesCapIQ.push({ companyName: arrname[0], countryName: arrname[1], tickerSymbol: ' ', key: x });
                            arrDataListTemp.push(arrData);
                            this.isLoading = false;
                            this.isSearchDisabled = false;
                        }
                        this.arrDataList = arrDataListTemp;
                        this.companylist = data;
                        for (let key in data) {
                            // Preventing unexcepted data
                            if (data.hasOwnProperty(key)) { // Filtering the data in the loop
                                this.mapOfValues.push({ value: data[key], key: key });
                            }
                        }

                        this.error = undefined;
                        console.log('351  company List', JSON.stringify(this.companylist));
                        this.ifMcaCallout = true;
                        console.log('353 MCA   this.arrDataList.length', this.arrDataList);
                        if (this.arrDataList.length == 0) {
                            this.isLoading = false;
                            this.isSearchDisabled = false;
                            this.showAccordians = true;
                            this.ifData = false;
                            this.ifExternalData = true;
                        } else {
                            this.isLoading = false;
                            this.isSearchDisabled = false;
                            this.ifData = true;
                            this.ifExternalData = false;
                        }
                    }
                    else if (error) {
                        this.isLoading = false;
                        this.isSearchDisabled = false;
                        this.error = error;
                        this.companylist = 'Its';
                        this.showAccordians = true;
                        this.ifData = false;
                        this.ifExternalData = true;
                    }
                }).catch((error) => {
                    this.showAccordians = true;
                    this.ifData = false;
                    this.isLoading = false;
                    this.isSearchDisabled = false;
                    this.ifExternalData = true;
                    console.log("534 an error has occured :  ", error);
                })
            this.ifResult = false;

            this.ifExisting = false;
            this.showError = false;
        }
        else {
            this.ifclick = true;
        }

    }
    handleNewClientSource(event) {
        if (event.target.value != this.channelValue) {

            let source = event.target.value;
            console.log(source);
            if (source == "Law Firm") {

                this.companyInboundReferral = null;
                this.companyGTEmployee = null;
                this.PevcConRefVal = null;
                this.PevcRefVal = null;
                this.companyChambercontact = null;
                this.companyChamber = null;
                this.companyClientContact = null;
                this.companyClientName = null;

                this.isGTEmpDisabled = true;
                this.isInboundDisabled = true;
                this.isLowFirmDisabled = false;
                this.isClientContactDisabled = true;
                this.isChamberDisabled = true;
                this.isPEVCConDisabled = true;
                this.isPEVCDisabled = true;


            } else if (source == "Existing Client") {

                this.companyLawFirmContacts = null;
                this.companyLawFirm = null;
                this.companyInboundReferral = null;
                this.companyGTEmployee = null;
                this.PevcConRefVal = null;
                this.PevcRefVal = null;
                this.companyChambercontact = null;
                this.companyChamber = null;


                this.isGTEmpDisabled = true;
                this.isInboundDisabled = true;
                this.isLowFirmDisabled = true;
                this.isClientContactDisabled = false;
                this.isChamberDisabled = true;
                this.isPEVCConDisabled = true;
                this.isPEVCDisabled = true;


            } else if (source == "GT Employee") {

                this.companyInboundReferral = null;
                this.PevcConRefVal = null;
                this.PevcRefVal = null;
                this.companyChambercontact = null;
                this.companyChamber = null;
                this.companyLawFirmContacts = null;
                this.companyLawFirm = null;
                this.companyClientContact = null;
                this.companyClientName = null;

                this.isGTEmpDisabled = false;
                this.isInboundDisabled = true;
                this.isLowFirmDisabled = true;
                this.isClientContactDisabled = true;
                this.isChamberDisabled = true;
                this.isPEVCConDisabled = true;
                this.isPEVCDisabled = true;


            } else if (source == "GT Member Firms") {

                this.companyGTEmployee = null;
                this.PevcConRefVal = null;
                this.PevcRefVal = null;
                this.companyChambercontact = null;
                this.companyChamber = null;
                this.companyLawFirmContacts = null;
                this.companyLawFirm = null;
                this.companyClientContact = null;
                this.companyClientName = null;



                this.isGTEmpDisabled = true;
                this.isInboundDisabled = false;
                this.isLowFirmDisabled = true;
                this.isClientContactDisabled = true;
                this.isChamberDisabled = true;
                this.isPEVCConDisabled = true;
                this.isPEVCDisabled = true;



            } else if (source == "Chamber") {

                this.companyInboundReferral = null;
                this.companyGTEmployee = null;
                this.PevcConRefVal = null;
                this.PevcRefVal = null;
                this.companyLawFirmContacts = null;
                this.companyLawFirm = null;
                this.companyClientContact = null;
                this.companyClientName = null;

                this.isGTEmpDisabled = true;
                this.isInboundDisabled = true;
                this.isLowFirmDisabled = true;
                this.isClientContactDisabled = true;
                this.isChamberDisabled = false;
                this.isPEVCConDisabled = true;
                this.isPEVCDisabled = true;



            }
            else if (source == "Investors / Private Equity Firms") {
                this.companyInboundReferral = null;
                this.companyGTEmployee = null;
                this.companyChambercontact = null;
                this.companyChamber = null;
                this.companyLawFirmContacts = null;
                this.companyLawFirm = null;
                this.companyClientContact = null;
                this.companyClientName = null;

                this.isGTEmpDisabled = true;
                this.isInboundDisabled = true;
                this.isLowFirmDisabled = true;
                this.isClientContactDisabled = true;
                this.isChamberDisabled = true;
                this.isPEVCConDisabled = false;
                this.isPEVCDisabled = false;


            } else {
                console.log('hi else', this.companyGTEmployee)
                this.companyInboundReferral = null;
                this.companyGTEmployee = null;
                this.PevcConRefVal = null;
                this.PevcRefVal = null;
                this.companyChambercontact = null;
                this.companyChamber = null;
                this.companyLawFirmContacts = null;
                this.companyLawFirm = null;
                this.companyClientContact = null;
                this.companyClientName = null;
                console.log('hi else after', this.companyGTEmployee)


                this.isGTEmpDisabled = true;
                this.isInboundDisabled = true;
                this.isLowFirmDisabled = true;
                this.isClientContactDisabled = true;
                this.isChamberDisabled = true;
                this.isPEVCConDisabled = true;
                this.isPEVCDisabled = true;


            }

        }
    }
    handleNewClientSourceClick(event) {
        let source = event.target.value;
        if (source != 'Law Firm' && source != 'Investors / Private Equity Firms' && source != 'Chamber' && source != 'Visiting card' && source != 'GT Member Firms' && source != 'GT Employee' && source != 'Existing Client') {

            this.companyInboundReferral = null;
            this.companyGTEmployee = null;
            this.PevcConRefVal = null;
            this.companyLawFirm = null;
            this.PevcRefVal = null;
            this.companyChambercontact = null;
            this.companyChamber = null;
            this.companyClientContact = null;
            this.companyClientName = null;

            this.isGTEmpDisabled = true;
            this.isInboundDisabled = true;
            this.isLowFirmDisabled = true;
            this.isClientContactDisabled = true;
            this.isChamberDisabled = true;
            this.isPEVCConDisabled = true;
            this.isPEVCDisabled = true;
        }

    }
    handleClientClick(event) {
        console.log(event.currentTarget.dataset.id);
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: event.currentTarget.dataset.id,
                objectApiName: 'Account',
                actionName: 'view'
            }
        })

    }
    handleexpertychange(event) {
        this.isDisabedDuplicate = false;
        this.companyExpertise = event.target.value;
        console.log('companyExpertise', this.companyExpertise);
    }
    handlesubexperties(event) {
        this.isDisabedDuplicate = false;
        this.companySubExpertise = event.target.value;
        console.log('companySubExpertise', this.companySubExpertise);
    }

    fatchDataFromExternalDataBase() {
        this.showAccordians = true;
        this.isDisabedDuplicate = false;
        console.log('companySolution ', this.leadObject.capIQId__c);
        this.isLoading = true;
        clientFieldDataCapIQ({ companyId: this.leadObject.capIQId__c })

            .then((result) => {

                this.leadObject.External_Database_Source__c = 'CapIQ';
                this.leadObject.Currency_Format__c = 'INR in lacs';
                console.log('result: ', result);
                if (result[0] != 'Data Unavailable') {
                    this.leadObject.Total_Assets__c = result[0];
                }
                if (result[1] != 'Data Unavailable') {
                    this.leadObject.Total_Current_Assets__c = result[1];
                }
                if (result[2] != 'Data Unavailable') {
                    this.leadObject.Total_Current_Liabilities__c = result[2];;
                }
                if (result[3] != 'Data Unavailable') {
                    this.leadObject.Total_Debt__c = result[3];
                }
                if (result[4] != 'Data Unavailable') {
                    this.leadObject.Total_Equity__c = result[4];
                }
                if (result[5] != 'Data Unavailable') {
                    this.leadObject.Total_Liabilities__c = result[5];
                }

                if (result[6] != 'Data Unavailable') {
                    this.leadObject.Total_No_of_employees__c = result[6];
                }
                if (result[7] != 'Data Unavailable') {
                    this.leadObject.Total_Revenue__c = result[7];
                }

                if (result[8] != 'Data Unavailable') {
                    this.leadObject.Earnings_Before_Interest_and_Taxes_EBIT__c = result[8];
                }
                if (result[9] != 'Data Unavailable') {
                    this.leadObject.EBITDA__c = result[9];
                }
                if (result[10] != 'Data Unavailable') {
                    this.leadObject.Ticker_Symbol__c = result[10];
                }
                if (result[11] != 'Data Unavailable') {
                    this.leadObject.Industry__c = result[11];
                }
                if (result[12] != 'Data Unavailable') {
                    this.leadObject.CEO_Name__c = result[12];


                }
                if (result[13] != 'Data Unavailable') {
                    this.leadObject.Global_Ultimate_Owner__c = result[13];
                }
                if (result[14] != 'Data Unavailable') {
                    this.leadObject.Public_Private_Company__c = result[14];
                }
                if (result[15] != 'Data Unavailable') {
                    this.leadObject.ClientBackground__c = result[15];



                }
                if (result[16] != 'Data Unavailable') {
                    this.leadObject.Stock_Exchange_symbol__c = result[16];

                }
                if (result[17] != 'Data Unavailable') {
                    this.leadObject.Website = result[17];

                }
                if (result[18] != 'Data Unavailable') {
                    console.log('Company Overview', result[18]);
                    this.leadObject.Company_Overview__c = result[18];
                }
                if (result[19] != 'Data Unavailable') {
                    this.leadObject.Year_Founded__c = result[19];

                }
                if (result[20] != 'Data Unavailable') {
                    this.leadObject.Chairman_Name__c = result[20];

                }
                if (result[21] != 'Data Unavailable') {
                    this.leadObject.Country_of_Incorporation__c = result[21];
                }
                if (result[22] != 'Data Unavailable') {
                    this.leadObject.Revenue__c = result[22];

                }
                if (result[23] != 'Data Unavailable') {
                    this.leadObject.Board_of_Directors__c = result[23];

                }
                if (result[24] != 'Data Unavailable') {
                    this.leadObject.Financial_Year__c = result[24];

                }
                if (result[25] != 'Data Unavailable') {
                    this.leadObject.Net_Income__c = result[25];

                }
                if (result[26] != 'Data Unavailable') {
                    this.leadObject.Gross_Profit__c = result[26];

                }
                if (result[27] != 'Data Unavailable') {
                    this.leadObject.Client_Group_Name__c = result[27];

                }
                if (result[28] != 'Data Unavailable') {
                    this.leadObject.Client_Group_Name_CIQID__c = result[28];

                }
                if (result[29] != 'Data Unavailable') {
                    this.leadObject.Global_Ultimate_Owner_ID__c = result[29];

                }
                if (result[30] != 'Data Unavailable') {
                    this.leadObject.CompanyHQ__Street__s = result[30];

                }
                if (result[31] != 'Data Unavailable') {
                    this.leadObject.CompanyHQ__City__s = result[31];

                }
                if (result[33] != 'Data Unavailable') {
                    this.leadObject.CompanyHQ__PostalCode__s = result[33];

                }
                if (result[34] != 'Data Unavailable') {
                    this.leadObject.KMP__c = result[34];

                }
                if (result[34] != 'Data Unavailable') {
                    this.leadObject.KMP__c = result[34];

                }
                if (result[35] != 'Data Unavailable') {
                    this.leadObject.Shared_Up_Capital__c = result[35];

                }
                if (result[36] != 'Data Unavailable') {
                    this.leadObject.Current_Auditor_Name__c = result[36];

                }
                if (result[37] != 'Data Unavailable') {
                    console.log('SIC Code', result[37]);
                    this.leadObject.SIC_Code__c = result[37];

                }
                if (result[38] != 'Data Unavailable') {
                    this.leadObject.ISIN_Number__c = result[38];

                }
                if (result[39] != 'Data Unavailable') {
                    this.leadObject.Company_Phone_No__c = result[39];

                }
                if (result[40] != 'Data Unavailable') {
                    this.leadObject.Total_Diluted_Earning_Loss_per_Share__c = result[40];

                }
                if (result[41] != 'Data Unavailable') {
                    this.leadObject.Closing_Price__c = result[41];

                }

            })
        this.isDisabed = false;
        this.isLoading = false;
    }

    handleEnter(event) {
        console.log('CHECK', event.keyCode);
        if (event.keyCode === 13) {
            this.handleClick();
        }
    }
    handleCreateEnquiry(event) {
        console.log('Existing client Id : ', event.target.dataset.id);
        console.log('Existing client Name : ', event.target.dataset.name);

        this.getClientDetails(event.target.dataset.name);
        this.leadObject.is_Enquiry_Created_For_Existing_Client__c = true;
        this.leadObject.Existing_Client__c = event.target.dataset.id;
        this.ifResult = false;
        this.showAccordians = true;
    }
    hideModalBoxIE() {
        this.isShowModalIE = false;
    }

    // onchange fuction for company name input
    handleChange(event) {
        this.showAccordians = false;
        this.leadObject.is_Enquiry_Created_For_Existing_Client__c = false;
        this.leadObject.Existing_Client__c = '';
        this.isDisabedDuplicate = false;
        this.showexternalbutton = false;
        this.ifExternalData = false;
        console.log('hello ', this.searchString);
        if (event.target.value != ' ' && event.target.value != null) {
            this.searchString = event.target.value;
            this.leadObject.Company = event.target.value;
            console.log('1130 length ----- >>>> ', this.leadObject.Company);
            if (this.searchString.length < 3) {
                this.isMinimumChar = true;
            }
            if (this.searchString != '' && this.searchString.length > 2 && this.searchString.trim().length !== 0) {
                this.isMinimumChar = false;
                console.log(this.searchString);
                tempCompanylist({ searchString: this.searchString })
                    .then((result) => {
                        if (result.length > 0 && this.searchString != '') {

                            this.ifSearch = false;
                            console.log('line 642 ', JSON.stringify(result));
                            let data = JSON.parse(JSON.stringify(result));
                            for (var i = 0; i < data.length; i++) {

                                data[i].rowNumber = i + 1;

                                if (data[i].ParentId != undefined || data[i].ParentId != null) {
                                    console.log('inside null');
                                    this.showParent = true;
                                    data[i].ShowParent = true;
                                } else {
                                    data[i].ShowParent = false;
                                }
                            }
                            console.log('657 ', JSON.stringify(data));
                            this.clientData = data;
                            this.ifData = false;
                            this.ifResult = true;
                            this.ifclick = false;
                            this.showexternalbutton = false;
                            //this.showAccordians = true;
                            this.leadObject.Company = this.searchString;
                            console.log('1164 length ----- >>>> ', this.leadObject.Company);
                            this.showError = false;
                        } else if (result.length > 0 && this.searchString == '') {
                            console.log('Step 2');
                            this.ifSearch = false;
                            this.clientData = '';
                            this.ifData = false;
                            this.ifResult = false;
                            this.showAccordians = false;
                            this.leadObject.Company = this.searchString;
                            console.log(' 1175length ----- >>>> ', this.leadObject.Company);
                            this.ifExisting = false;
                            this.ifclick = true;
                            this.showexternalbutton = false;

                        } else {
                            this.ifSearch = true;

                            console.log('Step 3 1093');
                            this.clientData = '';
                            this.ifData = false;
                            this.ifResult = false;
                            this.ifclick = false;
                            this.showexternalbutton = true;
                            this.leadObject.Company = this.searchString;
                            console.log('1190  length ----- >>>> ', this.leadObject.Company);
                            this.ifExisting = true;
                            this.showError = false;
                        }

                    })
                    .catch((error) => {
                        console.log("714 an error has occured :  ", error);
                    })
            }
            else {
                this.ifSearch = false;
                this.ifData = false;
                this.ifResult = false;
                this.showAccordians = false;
                this.leadObject.Company = this.searchString;
                console.log('1206 length ----- >>>> ', this.leadObject.Company);
                this.ifExisting = false;
                this.showError = false;
                this.ifSearch = false;
            }

        }


        this.companyListResult = [];
        console.log('   -----   ');
        this.companyEmail = '';
        this.companySubsector = '';
        this.companyExpertise = '';
        this.companyHowCanWeHelpYou = '';
        this.companyWebsite = '';
        this.companyMobilePhone = '';
        this.companySubSector = '';
        this.companySector = '';
        this.companyCorridor = '';
        this.companySubExpertise = '';
        this.leadObject.capIQId__c = '';
        this.leadObject.Channel__c = '';
        this.leadObject.SubIndustry__c = '';
        this.leadObject.Industry__c = '';
        //this.leadObject.CountryCode__c = '';
        this.leadObject.Email = '';
        this.leadObject.MobilePhone = '';
        //this.leadObject.Company = '';
        this.leadObject.LastName = '';
        this.leadObject.FirstName = '';


    }
    handleCountryCodeChange(event) {
        this.countryCode = event.detail.value;
    }
    inputchange = (e) => {
        console.log('hiiiiiiiiii');
        let ph = this.template.querySelector('.phone_number__c');
        console.log('hiiiiiiiiii', ph);
        if (e.target.value.length > 10 && this.leadObject.countryCode__c == 'India (+91)') {
            ph.setErrors({ 'body': { 'output': { 'fieldErrors': { 'Mobile Phone': [{ 'message': 'Mobile Number should be 10 Digits' }] } } } });
            return
        }

        let condition = this.validAlphabetLetter(e.target.value);
        console.log('e.target.value', e.target.value);
        if (!condition) {
            ph.setErrors({ 'body': { 'output': { 'fieldErrors': { 'Mobile Phone': [{ 'message': 'Only Numbers Are Allowed' }] } } } });
        }
    }
    validAlphabetLetter = (l) => {
        let check = true;
        let checkvalidation = true;
        let arrayofphonefield = Array.from(l);
        arrayofphonefield.forEach(dig => {
            checkvalidation = /^[0-9]$/.test(dig);

            if (checkvalidation == false) {
                check = false;
            }
        });
        return check;
    }
    validSpecialChar = (l) => {
        let check = true;
        let checkvalidation = true;
        let arrayofphonefield = Array.from(l);
        arrayofphonefield.forEach(dig => {
            checkvalidation = /^[a-z A-Z]$/.test(dig);

            if (checkvalidation == false) {
                check = false;
            }
        });
        return check;
    }
    async handletrickerCallout() {
        console.log(this.capIQ);
        await clientNewTracker({ companyID: this.capIQ })
            .then((data) => {
                if (data) {
                    this.mapOfValuesCapIQ.push({ companyName: data[0], countryName: data[2], tickerSymbol: data[1], key: this.capIQ });
                    console.log('Waiting');
                    this.capIQresultcounter = this.capIQresultcounter + 1;
                } else if (error) {

                }
            })
        console.log(this.capIQresultcounter, this.arrDataList.length);
        if (this.capIQresultcounter >= this.arrDataList.length) {
            console.log(this.capIQresultcounter == this.arrDataList.length);
            this.isLoading = false;
            this.isSearchDisabled = false;
            this.ifData = true;
        }
    }

    async handleClick() {
        this.capIQresultcounter = 0;
        this.mapOfValuesCapIQ = [];

        try {
            this.isLoading = true;
            this.shortMessageLoader = 'Fetching Data From External DataBase...';
            this.isSearchDisabled = true;

            this.searchCompany1 = this.searchString + ' ' + this.CountryNameValue;
            this.ifSearch = true;
            await clientNewSearchByName({ searchString: this.searchCompany1 })
                .then((data) => {
                    if (data) {

                        let arrDataListTemp = [];
                        for (let x in data) {
                            let arrData = {};
                            arrData.Name = x;
                            arrDataListTemp.push(arrData);
                        }
                        console.log('-------> Chech Wait', this.mapOfValuesCapIQ);
                        this.arrDataList = arrDataListTemp;
                        this.companylist = data;
                        this.error = undefined;
                    }
                    else if (error) {
                        this.isLoading = false;
                        this.isSearchDisabled = false;
                        this.error = error;
                        this.companylist = 'Its';
                        if (this.arrDataList.length == 0) {
                            console.log('821 this.handleMCA');
                        }
                    }
                })


        } catch (e) {
            console.log('Error', e);
            if (this.arrDataList.length == 0) {
                console.log('829 this.handleMCA');
            }
        }
        this.showexternalbutton = false;
        if (this.arrDataList.length > 0) {
            console.log('-------> this.mapOfValuesCapIQ.length', this.arrDataList);
            for (let x in this.arrDataList) {
                this.capIQ = this.arrDataList[x].Name;
                console.log(this.arrDataList[x].Name);
                this.handletrickerCallout();
            }

        } else if (this.arrDataList.length == 0) {
            console.log('this.handleMCA');
            console.log('-------> this.mapOfValuesCapIQ.length', this.mapOfValuesCapIQ.length);
            this.handleMCAClick();
            console.log('hii');
        }
    }

    handleComboxChange(event) {
        this.value = event.detail.value;
        console.log('value', this.value);
        console.log('aa', this.companyListResult[this.value]);

        clientNewSearchByName({ company: this.companyListResult[this.value] })
            .then((result) => {
                console.log('result from combox api', result);
            })
            .catch((error) => {
                console.log('eror from combobox api', error);
            })
    }
    async handleduplicate(event) {
        if (this.leadObject.FirstName == '' || this.leadObject.LastName == '' || this.leadObject.MobilePhone == '' || this.leadObject.Email == '' || this.leadObject.Industry__c == '' || this.leadObject.Referral_Client__c == '' || this.leadObject.Referral_Contact__c == '') {
            console.log(this.leadObject.FirstName == '');
            console.log(this.leadObject.LastName == '');
            console.log(this.leadObject.CountryCode__c == '');
            console.log(this.leadObject.MobilePhone == '');
            console.log(this.leadObject.Email == '');
            console.log(this.leadObject.Industry__c == '');

            const eventt = new ShowToastEvent({
                title: 'Please fill required Fields',
                //  message:'',
                variant: 'warning'
            });
            this.dispatchEvent(eventt);
        }
        else {
            await checkduplicate({ solution: this.companySolution, experty: this.companyExpertise, subexperty: this.companySubExpertise, Company: this.companyName })
                .then(result => {
                    console.log('result', result);
                    if (!result[1]) {
                        const eventt = new ShowToastEvent({
                            title: 'There is no duplicate record',
                            //  message:'',
                            variant: 'success'
                        });
                        this.dispatchEvent(eventt);
                    }

                    this.isShowModal = result[1];
                    this.isClientduplicate = result[0];
                    this.isDisabed = false;
                    this.isDisabedDuplicate = true;
                })
        }

    }
    handleno() {
        this.isShowModal = false;
        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'Lead',
                actionName: 'list'
            },
            state: {

                filterName: 'All_Open_New_Clients',
            }

        });
        eval("$A.get('e.force:refreshView').fire();");
    }
    handleyes() {
        this.isShowModal = false;
        this.isDisabed = false;
        this.template.querySelector('.selfclick').click();

    }
    hideModalBox() {
        //this.isDisabed = true;
        this.isDisabedDuplicate = false;
        this.isShowModal = false;

    }
    handleSubmit(event) {
        console.log('hi');
        const eventt = new ShowToastEvent({
            message: 'Enquiry record created successfully.',
            variant: 'success'
        });
        this.dispatchEvent(eventt);
        console.log('hi');
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                objectApiName: 'Lead',
                recordId: event,
                actionName: 'view'
            },

        });
        eval("$A.get('e.force:refreshView').fire();");
        var delayInMilliseconds = 900; //1 second

    }



    handleError(evt) {
        console.log('error', JSON.stringify(evt));
        console.log('error', JSON.parse(JSON.stringify(evt)));
        console.log('validastion : ', JSON.parse(JSON.stringify(evt)).detail.output.fieldErrors.Name[0].message);

        let showFirstNameValidation = JSON.parse(JSON.stringify(evt)).detail.output.fieldErrors.Name[0].message;

        if (showFirstNameValidation) {

            let attachmentPoint = this.template.querySelector('div[ishtmlcontainer=true]');
            attachmentPoint.innerText = 'Please Enter First Name';
            const test = new ShowToastEvent({
                title: 'First Name is mandatory',
                variant: 'error',
                message:
                    'First Name not filled',
            });
            this.dispatchEvent(test);
        }


        if (this.isClientduplicate) {
            const event = new ShowToastEvent({
                title: 'Client Exist',
                variant: 'error',
                message:
                    'Record already Exist, Kindly close the New Client and create an Enquiry against the client account',
            });
            this.dispatchEvent(event);
            this[NavigationMixin.Navigate]({
                type: 'standard__objectPage',
                attributes: {
                    objectApiName: 'Opportunity',
                    actionName: 'new'
                }
            });
            eval("$A.get('e.force:refreshView').fire();");
        } else {
            this.isDisabed = false;
            if (this.counter == 0) {
                this.counter++;
                this.template.querySelector('.selfclick').click();

            }

        }

    }
    handleValidation(event) {
        if (event.target.fieldName == 'MobilePhone') {
            console.log('first');
            var myReg = /[0-9]{10}/;
            console.log('second');
            var MyText = event.detail.value;
            console.log('3');
            var Result = MyText.match(myReg);
            console.log('4', Result);

        }
    }

    handleclicksubmit(event) {
        console.log('hi Submit');
        this.isSave = true;
        console.log('Handlesubmit Lead record : ', JSON.stringify(this.leadObject.is_Enquiry_Created_For_Existing_Client__c));
        console.log('this.leadObject.Company   --->' + this.leadObject.Company);
        console.log('this.leadObject.Channel__c' + this.leadObject.Channel__c);
        // making the lookup mandatory based on lead source
        if ((this.leadObject.Channel__c == 'Campaign' && this.leadObject.Campaign__c == '')
            || (this.leadObject.Channel__c == 'Client Past Relationships / Existing Client' && ((this.leadObject.ClientName__c == '' || this.leadObject.ClientContact__c == '') || (this.leadObject.ClientName__c == '' && this.leadObject.ClientContact__c == '')))
            || (this.leadObject.Channel__c == 'Global Delivery' && ((this.leadObject.GTI_Member_Firm_Referral_Country__c == '' || this.leadObject.GTI_Member_Firm_Office__c == '' || this.leadObject.GTI_Member_Firm_Referring_Person_s_name__c == '') || (this.leadObject.GTI_Member_Firm_Referral_Country__c == '' && this.leadObject.GTI_Member_Firm_Office__c == '' && this.leadObject.GTI_Member_Firm_Referring_Person_s_name__c == '')))
            || (this.leadObject.Channel__c == 'Inbound Referrals - GT Firm Personnel' && this.leadObject.GTEmployee__c == '')
            || (this.leadObject.Channel__c == 'Inbound Referrals - Intermediary Firm') && ((this.leadObject.Intermediary_Referral_Person_Name__c == '' || this.leadObject.Intermediary_Referral_Firm_Name__c == '') || (this.leadObject.Intermediary_Referral_Person_Name__c == '' && this.leadObject.Intermediary_Referral_Firm_Name__c == ''))
            || (this.leadObject.Channel__c == 'Inbound Referrals - Investment Banks') && ((this.leadObject.Investment_Bank_Contact_Name__c == '' || this.leadObject.Investment_Bank_Firm_Name__c == '') || (this.leadObject.Investment_Bank_Contact_Name__c == '' && this.leadObject.Investment_Bank_Firm_Name__c == ''))
            || (this.leadObject.Channel__c == 'Inbound Referrals - Law Firm') && ((this.leadObject.LawFirmContacts__c == '' || this.leadObject.LawFirm__c == '') || (this.leadObject.LawFirmContacts__c == '' && this.leadObject.LawFirm__c == ''))
            || (this.leadObject.Channel__c == 'Independent Directors' && this.leadObject.Independent_Director_Contact_Name__c == '')
            || (this.leadObject.Channel__c == 'Inbound Referrals - PE/VC') && ((this.leadObject.Investors_Private_Equity_Firms__c == '' || this.leadObject.InvestorsPrivateEquityFirms__c == '') || (this.leadObject.Investors_Private_Equity_Firms__c == '' && this.leadObject.InvestorsPrivateEquityFirms__c == ''))
            || (this.leadObject.Channel__c == 'Alumni – GT@Industry' && this.leadObject.GT_Alumni_Name__c == '')) {
            this.isSave = false;
        }
        console.log('isSave' + this.isSave);

        console.log('this.selectedExpertise.length : ', this.selectedExpertise.length);
        if (this.leadObject.FirstName == '' || this.leadObject.LastName == '' || this.leadObject.MobilePhone == '' || this.leadObject.Email == '' || this.leadObject.Industry__c == '' || this.leadObject.countryCode__c == '' || ((this.leadObject.Referral_Client__c == '' || this.leadObject.Referral_Contact__c == '') && this.byPassIfClientOrContactNull == false) || this.leadObject.Description == '' || this.leadObject.Enquiry_Type__c == '' || this.selectedExpertise.length == 0) {
            console.log('Channel :' + this.channel);
            const eventt = new ShowToastEvent({
                title: 'Please fill required Fields',
                //  message:'',
                variant: 'warning'
            });
            this.dispatchEvent(eventt);
        }
        else {
            console.log('Company Name==>', this.leadObject.Company);
            CheckDuplicateAccount({ companyName: this.leadObject.Company })
                .then(result => {
                    console.log('checkDuplicateAccount: ', result);

                    if (this.leadObject.Industry__c != 'Others') {
                        let checkSpecialCharForAllField = true;
                        if (!this.validSpecialChar(this.leadObject.FirstName) || !this.validSpecialChar(this.leadObject.LastName) || !this.validSpecialChar(this.leadObject.GT_Alumni_Name__c)
                            || !this.validSpecialChar(this.leadObject.GTI_Member_Firm_Office__c) || !this.validSpecialChar(this.leadObject.GTI_Member_Firm_Referring_Person_s_name__c) ||
                            !this.validSpecialChar(this.leadObject.Intermediary_Referral_Firm_Name__c) || !this.validSpecialChar(this.leadObject.Intermediary_Referral_Person_Name__c)) {
                            checkSpecialCharForAllField = false;
                            console.log('checkSpecialCharForAllField', checkSpecialCharForAllField);
                        }
                        let fchar = this.leadObject.MobilePhone;
                        let condition = this.validAlphabetLetter(fchar);
                        if (fchar.charAt(0) != 0 && condition && checkSpecialCharForAllField) {
                            console.log('@@: ')
                            if (this.isSave) {
                                this.createLeadrecord();
                            } else {
                                const eventt = new ShowToastEvent({
                                    title: 'Please fill all referral section information',
                                    //  message:'',
                                    variant: 'error'
                                });
                                this.dispatchEvent(eventt);
                            }
                        } else {

                        }
                    } else {
                        const eventt = new ShowToastEvent({
                            title: 'Kindly provide a relevant sector',
                            //  message:'',
                            variant: 'error'
                        });
                        this.dispatchEvent(eventt);
                    }
                })

                .catch(error => {
                    console.log('checkDuplicateAccount error: ', error);
                })

        }

    }

    showErrorToast(title, variant) {
        const eventt = new ShowToastEvent({
            title: title,
            //  message:'',
            variant: variant
        });
        this.dispatchEvent(eventt);
    }

    handleCancel() {
        eval("$A.get('e.force:refreshView').fire();");
        this.showAccordians = false;
        this.companyListResult = [];
        console.log('   -----   ');
        this.companyEmail = '';
        this.companyExpertise = '';
        this.companyHowCanWeHelpYou = '';
        this.companyWebsite = '';
        this.companyMobilePhone = '';
        this.companySubSector = '';
        this.companySector = '';
        this.companyCorridor = '';
        this.companySubExpertise = '';
        this.companyAddress = '';
        this.companyCompanyHQ = '';
        this.companyChamber = '';
        this.companyClientName = '';
        this.companyGTEmployee = '';
        this.companyInboundReferral = '';
        this.companyClientContact = '';
        this.companyLawFirm = '';
        this.companyLawFirmContacts = '';
        this.countryCode = '';

    }
    handleLwaFirmContact(event) {

        this.companyLawFirmContacts = event.detail.value;

    }

    handleLwaFirm(event) {

        this.companyLawFirm = event.detail.value;
    }
    handleChamberContact(event) {
        this.companyChambercontact = event.detail.value;
    }
    handleChamber(event) {
        this.companyChamber = event.detail.value;
    }
    handlePEVCContact(event) {
        this.PevcConRefVal = event.detail.value;
    }
    handlePEVC(event) {
        this.PevcRefVal = event.detail.value;
    }

    handleGtFirm(event) {
        this.companyInboundReferral = event.detail.value;
    }
    handleGtEmployee(event) {
        this.companyGTEmployee = event.detail.value;
    }
    handleClientContact(event) {
        this.companyClientContact = event.detail.value;
    }
    handleClientName(event) {
        this.companyClientName = event.detail.value;
    }
    handleSelection() {

    }
    Fields = {};
    handleLookUpChange(event) {
        console.log('Field 1567', this.leadObject.Channel__c);
        if (event.detail != null && event.detail.selectedRecord.Id != undefined) {
            this.accountRecordID = '';

            if (this.leadObject.Channel__c == 'Inbound Referrals - Law Firm') {
                this.isLawFirmContact = false;
                if (event.detail != null) {

                    this.leadObject.LawFirm__c = event.detail.selectedRecord.Id;
                    //  this.leadObject.LawFirmContacts__c=event.detail.selectedRecord.Id;

                    this.accountRecordID = event.detail.selectedRecord.Id;

                    this.isLawFirmContact = true;
                }
            } else if (this.leadObject.Channel__c == 'Investors / Private Equity Firms') {
                if (event.detail != null) {
                    this.leadObject.Investors_Private_Equity_Firms__c = event.detail.selectedRecord.Id;
                    //  this.leadObject.InvestorsPrivateEquityFirms__c=event.detail.selectedRecord.Id;

                    this.accountRecordID = event.detail.selectedRecord.Id;
                }
            } else if (this.leadObject.Channel__c == 'Inbound Referrals - GT Firm Personnel') {
                if (event.detail != null) {
                    this.leadObject.GTEmployee__c = event.detail.selectedRecord.Id;
                    // this.accountRecordID=event.detail.selectedRecord.Id;
                }
            } else if (this.leadObject.Channel__c == 'Client Past Relationships / Existing Client') {
                if (event.detail != null) {
                    this.leadObject.ClientName__c = event.detail.selectedRecord.Id;
                    // this.leadObject.ClientContact__c=event.detail.selectedRecord.Id;
                    this.accountRecordID = event.detail.selectedRecord.Id;
                    console.log('Client Past Relationships / Existing Client', event.detail.selectedRecord.Id);

                    this.isExistingClientContact = true;
                }
            } else if (this.leadObject.Channel__c == 'GT Member Firms') {
                if (event.detail != null) {
                    this.leadObject.InboundReferral__c = event.detail.selectedRecord.Id;
                    // this.accountRecordID=event.detail.selectedRecord.Id;
                }
            } else if (this.leadObject.Channel__c == 'Chamber') {
                if (event.detail != null) {
                    this.leadObject.Chamber__c = event.detail.selectedRecord.Id;
                    // this.leadObject.Chamber_contacts__c=event.detail.selectedRecord.Id;
                    this.accountRecordID = event.detail.selectedRecord.Id;
                }
            } else if (this.leadObject.Channel__c == 'Campaign') {
                if (event.detail != null) {
                    this.leadObject.Campaign__c = event.detail.selectedRecord.Id;
                    // this.leadObject.Chamber_contacts__c=event.detail.selectedRecord.Id;
                    //this.accountRecordID=event.detail.selectedRecord.Id;
                }
            } else if (this.leadObject.Channel__c == 'Global Delivery') {
                if (event.detail != null) {
                    this.leadObject.GTI_Member_Firm_Referral_Country__c = event.detail.selectedRecord.Id;
                    // this.leadObject.Chamber_contacts__c=event.detail.selectedRecord.Id;
                    //this.accountRecordID=event.detail.selectedRecord.Id;
                }
            } else if (this.leadObject.Channel__c == 'Inbound Referrals - Investment Banks') {
                if (event.detail != null) {
                    this.leadObject.Investment_Bank_Firm_Name__c = event.detail.selectedRecord.Id;
                    // this.leadObject.Chamber_contacts__c=event.detail.selectedRecord.Id;
                    this.accountRecordID = event.detail.selectedRecord.Id;
                    console.log('Inbound Referrals - Investment Banks', event.detail.selectedRecord.Id);
                    this.isnvestmentBankContact = true;
                }
            } else if (this.leadObject.Channel__c == 'Inbound Referrals - PE/VC') {
                if (event.detail != null) {
                    this.leadObject.Investors_Private_Equity_Firms__c = event.detail.selectedRecord.Id;               // this.leadObject.Chamber_contacts__c=event.detail.selectedRecord.Id;
                    this.accountRecordID = event.detail.selectedRecord.Id;
                    console.log('Inbound Referrals - PE/VC', event.detail.selectedRecord.Id);

                    this.isInvesterPrivateContact = true;
                }
            } else {

            }
        } else {
            console.log('else');
            this.isLawFirmContact = false;
            this.isInvesterPrivateContact = false;
            this.isExistingClientContact = false;
            this.isnvestmentBankContact = false;
        }

    }
    handleFieldChangeForCountryCode(event) {
        let countryCode = String(event.detail);
        if (countryCode != '') {
            console.log('countryCode.includes(' + countryCode.includes('India (+91)'));
            if (countryCode.includes('India (+91)')) {
                console.log('-----eter');
            }

        }
    }
    handleFieldChange(event) {
        console.log('---->>1235' + JSON.stringify(event.detail));
        console.log('event.target.name' + event.target.name);
        var eventName = event.target.name;
        // Added by Deepak Joshi
        this.TypeOptionsContact = [];
        this.leadObject.Referral_Client__c = '';

        //console.log('event name name',eventName,event.detail.value);

        if (event.target.postalCode != '' || event.target.city != '' || event.target.province != '' || event.target.country != '' || event.target.street != '') {
            this.leadObject.City = event.target.city;
            this.leadObject.State = event.target.province;
            this.leadObject.Street = event.target.street;
            this.leadObject.PostalCode = event.target.postalCode;
            this.leadObject.Country = event.target.country;
        }
        switch (eventName) {
            case 'Name':
                this.leadObject.FirstName = event.detail.value;
                break;
            case 'LName':
                this.leadObject.LastName = event.detail.value;
                break;
            case 'Designation':
                this.leadObject.Designation__c = event.detail.value;
                break;
            case 'EnquiryDescription':
                this.leadObject.Description = event.detail.value;
                break;
            case 'EnquiryType':
                console.log('EnquiryType selected value : ', event.detail);
                this.leadObject.Enquiry_Type__c = event.detail;
                console.log('leadObject : ', JSON.stringify(this.leadObject));
                break;
            case 'Company':
                return;
                this.leadObject.Company = this.searchString;
                break;
            case 'Email':
                this.leadObject.Email = event.detail.value;
                break;
            case 'Intermediary Referral Firm Name':
                this.leadObject.Intermediary_Referral_Firm_Name__c = event.detail.value;
                break;
            case 'Intermediary Referral Person Name':
                this.leadObject.Intermediary_Referral_Person_Name__c = event.detail.value;
                break;
            case 'GT Alumni Name':
                this.leadObject.GT_Alumni_Name__c = event.detail.value;
                break;
            case 'Country Code':
                console.log('----->>>>1279');
                this.leadObject.countryCode__c = event.detail;

                //Bhanwar Bug Feedback 18th April 
                console.log()
                var inputFields = this.template.querySelector('.phone_number__c');
                inputFields.setCustomValidity("");
                inputFields.reportValidity();
                if (!inputFields.checkValidity()) {

                }
                else {
                    var inputCmp = this.template.querySelector('.phone_number__c');
                    inputCmp.setCustomValidity("");
                    console.log('this.leadObject.MobilePhone' + this.leadObject.MobilePhone);
                    console.log('this.leadObject.countryCode__c' + this.leadObject.countryCode__c);
                    if (this.leadObject.MobilePhone != '' && this.leadObject.countryCode__c != '') {
                        if (this.leadObject.countryCode__c == 'India (+91)') {
                            console.log('----->>' + this.leadObject.MobilePhone.length);

                            if (this.leadObject.MobilePhone.length < 10 && this.leadObject.MobilePhone.length > 1) {
                                this.isMobileValid = true;
                                inputCmp.setCustomValidity('Please enter a valid 10-digit number');
                                inputCmp.reportValidity();

                            } else if (this.leadObject.MobilePhone.length > 10) {
                                this.isMobileValid = true;
                                inputCmp.setCustomValidity('Please enter a valid 10-digit number');
                                inputCmp.reportValidity();

                            } else {
                                this.isMobileValid = false;
                            }
                        } else {
                            this.isMobileValid = false;
                        }
                    }
                }
                break;
            case 'GTI Member Firm Office - Referring Person Name':
                console.log('----->>>>1279');
                this.leadObject.GTI_Member_Firm_Referring_Person_s_name__c = event.detail.value;
                break;
            case 'GTI Member Firm Office':
                console.log('----->>>>1279');
                this.leadObject.GTI_Member_Firm_Office__c = event.detail.value;
                break;
            case 'leadSource':
                this.pastClient = false;
                this.leadObject.Channel__c = event.detail.value;
                this.isLawFirmContact = false;
                this.isInvesterPrivateContact = false;
                this.isExistingClientContact = false;
                this.isnvestmentBankContact = false;
                this.leadObject.GTI_Member_Firm_Office__c = '';
                this.leadObject.GTI_Member_Firm_Referring_Person_s_name__c = '';
                this.leadObject.GT_Alumni_Name__c = '';
                this.leadObject.Intermediary_Referral_Person_Name__c = '';
                this.leadObject.Intermediary_Referral_Firm_Name__c = '';
                this.leadObject.LawFirm__c = '';
                this.accountRecordID = '';
                this.leadObject.Investors_Private_Equity_Firms__c = '';
                this.leadObject.GTEmployee__c = '';
                this.leadObject.ClientName__c = '';
                this.leadObject.InboundReferral__c = '';
                this.leadObject.Campaign__c = '';
                this.leadObject.GTI_Member_Firm_Referral_Country__c = '';
                this.leadObject.Investment_Bank_Firm_Name__c = '';
                this.leadObject.LawFirmContacts__c = '';
                this.leadObject.InvestorsPrivateEquityFirms__c = '';
                this.leadObject.ClientContact__c = '';
                this.leadObject.Independent_Director_Contact_Name__c = '';
                this.leadObject.Investment_Bank_Contact_Name__c = '';



                if (event.detail.value == 'Chambers') {
                    this.isLawFirm = false;
                    this.byPassIfClientOrContactNull = false;
                    this.isNotCampaign = true;
                    this.isChamberShow = false;
                    this.isGtMemberFirm = false;
                    this.isExistingClient = false;
                    this.isGtEmployee = false;
                    this.isInvesterPrivate = false;
                    this.isCampaign = false;
                    this.isintermediaryRef = false;
                    this.isGtAlumni = false;
                    this.isnvestmentBank = false;
                    this.isGlobalDelivery = false;
                    this.isIndependentDirectors = false;
                    this.channel = event.detail.value;
                    this.apexCallWithCondition();

                } else if (event.detail.value == 'Key Account Leaders') {
                    this.isInvesterPrivate = false;
                    this.byPassIfClientOrContactNull = false;
                    this.isNotCampaign = true;
                    this.isLawFirm = false;
                    this.isChamberShow = false;
                    this.isGtMemberFirm = false;
                    this.isExistingClient = false;
                    this.isGtEmployee = false;
                    this.isCampaign = false;
                    this.isintermediaryRef = false;
                    this.isGtAlumni = false;
                    this.isnvestmentBank = false;
                    this.isGlobalDelivery = false;
                    this.isIndependentDirectors = false;
                    this.channel = event.detail.value;
                    this.apexCallWithCondition();
                } else if (event.detail.value == 'NEDs & ACs') {
                    this.isGtEmployee = false;
                    this.byPassIfClientOrContactNull = false;
                    this.isNotCampaign = true;
                    this.isLawFirm = false;
                    this.isChamberShow = false;
                    this.isGtMemberFirm = false;
                    this.isExistingClient = false;
                    this.isInvesterPrivate = false;
                    this.isCampaign = false;
                    this.isintermediaryRef = false;
                    this.isGtAlumni = false;
                    this.isnvestmentBank = false;
                    this.isGlobalDelivery = false;
                    this.isIndependentDirectors = false;
                    this.channel = event.detail.value;
                    this.apexCallWithCondition();

                } else if (event.detail.value == 'Member Firms Leaders') {
                    console.log('event.detail.value', event.detail.value);
                    this.isExistingClient = false;
                    this.byPassIfClientOrContactNull = false;
                    this.isNotCampaign = true;
                    this.isLawFirm = false;
                    this.isChamberShow = false;
                    this.isGtMemberFirm = false;
                    this.isGtEmployee = false;
                    this.isInvesterPrivate = false;
                    this.isCampaign = false;
                    this.isintermediaryRef = false;
                    this.isGtAlumni = false;
                    this.isnvestmentBank = false;
                    this.isGlobalDelivery = false;
                    this.isIndependentDirectors = false;
                    this.channel = event.detail.value;
                    this.apexCallWithCondition();


                } else if (event.detail.value == 'PEVC') {
                    this.isGtMemberFirm = false;
                    this.byPassIfClientOrContactNull = false;
                    this.isNotCampaign = true;
                    this.isLawFirm = false;
                    this.isChamberShow = false;
                    this.isExistingClient = false;
                    this.isGtEmployee = false;
                    this.isInvesterPrivate = false;
                    this.isCampaign = false;
                    this.isintermediaryRef = false;
                    this.isGtAlumni = false;
                    this.isnvestmentBank = false;
                    this.isGlobalDelivery = false;
                    this.isIndependentDirectors = false;
                    this.channel = event.detail.value;
                    this.apexCallWithCondition();

                } else if (event.detail.value == 'BO & family office') {
                    this.isChamberShow = false;
                    this.byPassIfClientOrContactNull = false;
                    this.isNotCampaign = true;
                    this.isLawFirm = false;
                    this.isGtMemberFirm = false;
                    this.isExistingClient = false;
                    this.isGtEmployee = false;
                    this.isInvesterPrivate = false;
                    this.isCampaign = false;
                    this.isintermediaryRef = false;
                    this.isGtAlumni = false;
                    this.isnvestmentBank = false;
                    this.isGlobalDelivery = false;
                    this.isIndependentDirectors = false;
                    this.channel = event.detail.value;
                    this.apexCallWithCondition();

                } else if (event.detail.value == 'Campaign') {
                    this.isChamberShow = false;
                    this.byPassIfClientOrContactNull = false;
                    this.isLawFirm = false;
                    this.isGtMemberFirm = false;
                    this.isNotCampaign = false;
                    this.isExistingClient = false;
                    this.isGtEmployee = false;
                    this.isInvesterPrivate = false;
                    this.isCampaign = true;
                    this.isintermediaryRef = false;
                    this.isGtAlumni = false;
                    this.isnvestmentBank = false;
                    this.isGlobalDelivery = false;
                    this.isIndependentDirectors = false;


                } else if (event.detail.value == 'Banking') {
                    this.isChamberShow = false;
                    this.byPassIfClientOrContactNull = false;
                    this.isNotCampaign = true;
                    this.isLawFirm = false;
                    this.isGtMemberFirm = false;
                    this.isExistingClient = false;
                    this.isGtEmployee = false;
                    this.isInvesterPrivate = false;
                    this.isCampaign = false;
                    this.isintermediaryRef = false;
                    this.isGtAlumni = false;
                    this.isnvestmentBank = false;
                    this.isGlobalDelivery = false;
                    this.isIndependentDirectors = false;
                    this.channel = event.detail.value;
                    this.apexCallWithCondition();

                } else if (event.detail.value == 'Law Firm') {
                    this.isChamberShow = false;
                    this.byPassIfClientOrContactNull = false;
                    this.isNotCampaign = true;
                    this.isLawFirm = false;
                    this.isGtMemberFirm = false;
                    this.isExistingClient = false;
                    this.isGtEmployee = false;
                    this.isInvesterPrivate = false;
                    this.isCampaign = false;
                    this.isintermediaryRef = false;
                    this.isGtAlumni = false;
                    this.isnvestmentBank = false;
                    this.isGlobalDelivery = false;
                    this.isIndependentDirectors = false;
                    this.channel = event.detail.value;
                    this.apexCallWithCondition();

                } else if (event.detail.value == 'GCC') {
                    this.isChamberShow = false;
                    this.byPassIfClientOrContactNull = false;
                    this.isNotCampaign = true;
                    this.isLawFirm = false;
                    this.isGtMemberFirm = false;
                    this.isExistingClient = false;
                    this.isGtEmployee = false;
                    this.isInvesterPrivate = false;
                    this.isCampaign = false;
                    this.isintermediaryRef = false;
                    this.isGtAlumni = false;
                    this.isnvestmentBank = false;
                    this.isGlobalDelivery = false;
                    this.isIndependentDirectors = false;
                    this.channel = event.detail.value;
                    this.apexCallWithCondition();

                } else if (event.detail.value == 'Alumni') {
                    this.isChamberShow = false;
                    this.byPassIfClientOrContactNull = false;
                    this.isNotCampaign = true;
                    this.isLawFirm = false;
                    this.isGtMemberFirm = false;
                    this.isExistingClient = false;
                    this.isGtEmployee = false;
                    this.isInvesterPrivate = false;
                    this.isCampaign = false;
                    this.isintermediaryRef = false;
                    this.isGtAlumni = false;
                    this.isGlobalDelivery = false;
                    this.isnvestmentBank = false;
                    this.isIndependentDirectors = false;
                    this.channel = event.detail.value;
                    this.apexCallWithCondition();

                } else if (event.detail.value == 'Academia') {
                    this.isChamberShow = false;
                    this.byPassIfClientOrContactNull = false;
                    this.isNotCampaign = true;
                    this.isLawFirm = false;
                    this.isGtMemberFirm = false;
                    this.isExistingClient = false;
                    this.isGtEmployee = false;
                    this.isInvesterPrivate = false;
                    this.isCampaign = false;
                    this.isintermediaryRef = false;
                    this.isGtAlumni = false;
                    this.isGlobalDelivery = false;
                    this.isnvestmentBank = false;
                    this.isIndependentDirectors = false;
                    this.channel = event.detail.value;
                    this.apexCallWithCondition();

                } else if (event.detail.value == 'Regulators') {
                    this.isNotCampaign = true;
                    this.byPassIfClientOrContactNull = false;
                    //this.leadObject.Channel__c=null;
                    this.isChamberShow = false;
                    this.isLawFirm = false;
                    this.isGtMemberFirm = false;
                    this.isExistingClient = false;
                    this.isGtEmployee = false;
                    this.isInvesterPrivate = false;
                    this.isCampaign = false;
                    this.isintermediaryRef = false;
                    this.isGtAlumni = false;
                    this.isGlobalDelivery = false;
                    this.isnvestmentBank = false;
                    this.isIndependentDirectors = false;
                    this.channel = event.detail.value;
                    this.apexCallWithCondition();

                } else if (event.detail.value == 'CIO CDO CISO') {
                    this.isNotCampaign = true;
                    this.byPassIfClientOrContactNull = false;
                    this.isChamberShow = false;
                    this.isLawFirm = false;
                    this.isGtMemberFirm = false;
                    this.isExistingClient = false;
                    this.isGtEmployee = false;
                    this.isInvesterPrivate = false;
                    this.isCampaign = false;
                    this.isintermediaryRef = false;
                    this.isGtAlumni = false;
                    this.isGlobalDelivery = false;
                    this.isnvestmentBank = false;
                    //this.isIndependentDirectors=true;
                    this.channel = event.detail.value;
                    this.apexCallWithCondition();

                } else if (event.detail.value == 'CHRO') {
                    this.isNotCampaign = true;
                    this.byPassIfClientOrContactNull = false;
                    this.isChamberShow = false;
                    this.isLawFirm = false;
                    this.isGtMemberFirm = false;
                    this.isExistingClient = false;
                    this.isGtEmployee = false;
                    this.isInvesterPrivate = false;
                    this.isCampaign = false;
                    this.isintermediaryRef = false;
                    this.isGtAlumni = false;
                    this.isGlobalDelivery = false;
                    this.isnvestmentBank = false;
                    //this.isIndependentDirectors=true;
                    this.channel = event.detail.value;
                    this.apexCallWithCondition();

                } else if (event.detail.value == 'CFO') {
                    this.isNotCampaign = true;
                    this.byPassIfClientOrContactNull = false;
                    this.isChamberShow = false;
                    this.isLawFirm = false;
                    this.isGtMemberFirm = false;
                    this.isExistingClient = false;
                    this.isGtEmployee = false;
                    this.isInvesterPrivate = false;
                    this.isCampaign = false;
                    this.isintermediaryRef = false;
                    this.isGtAlumni = false;
                    this.isGlobalDelivery = false;
                    this.isnvestmentBank = false;
                    //this.isIndependentDirectors=true;
                    this.channel = event.detail.value;
                    this.apexCallWithCondition();

                } else if (event.detail.value == 'CMO') {
                    this.isNotCampaign = true;
                    this.byPassIfClientOrContactNull = false;
                    this.isChamberShow = false;
                    this.isLawFirm = false;
                    this.isGtMemberFirm = false;
                    this.isExistingClient = false;
                    this.isGtEmployee = false;
                    this.isInvesterPrivate = false;
                    this.isCampaign = false;
                    this.isintermediaryRef = false;
                    this.isGtAlumni = false;
                    this.isGlobalDelivery = false;
                    this.isnvestmentBank = false;
                    //this.isIndependentDirectors=true;
                    this.channel = event.detail.value;
                    this.apexCallWithCondition();

                } else if (event.detail.value == 'Tech Alliances') {
                    this.isNotCampaign = true;
                    this.byPassIfClientOrContactNull = false;
                    this.isChamberShow = false;
                    this.isLawFirm = false;
                    this.isGtMemberFirm = false;
                    this.isExistingClient = false;
                    this.isGtEmployee = false;
                    this.isInvesterPrivate = false;
                    this.isCampaign = false;
                    this.isintermediaryRef = false;
                    this.isGtAlumni = false;
                    this.isGlobalDelivery = false;
                    this.isnvestmentBank = false;
                    //this.isIndependentDirectors=true;
                    this.channel = event.detail.value;
                    this.apexCallWithCondition();

                } else if (event.detail.value == 'CA Firms') {
                    this.isNotCampaign = true;
                    this.byPassIfClientOrContactNull = false;
                    this.isChamberShow = false;
                    this.isLawFirm = false;
                    this.isGtMemberFirm = false;
                    this.isExistingClient = false;
                    this.isGtEmployee = false;
                    this.isInvesterPrivate = false;
                    this.isCampaign = false;
                    this.isintermediaryRef = false;
                    this.isGtAlumni = false;
                    this.isGlobalDelivery = false;
                    this.isnvestmentBank = false;
                    //this.isIndependentDirectors=true;
                    this.channel = event.detail.value;
                    this.apexCallWithCondition();

                } else if (event.detail.value == 'Specialised Advisory Firms') {
                    this.isNotCampaign = true;
                    this.byPassIfClientOrContactNull = false;
                    this.isChamberShow = false;
                    this.isLawFirm = false;
                    this.isGtMemberFirm = false;
                    this.isExistingClient = false;
                    this.isGtEmployee = false;
                    this.isInvesterPrivate = false;
                    this.isCampaign = false;
                    this.isintermediaryRef = false;
                    this.isGtAlumni = false;
                    this.isGlobalDelivery = false;
                    this.isnvestmentBank = false;
                    //this.isIndependentDirectors=true;
                    this.channel = event.detail.value;
                    this.apexCallWithCondition();

                } else if (event.detail.value == 'PMOs') {
                    this.isNotCampaign = true;
                    this.byPassIfClientOrContactNull = false;
                    this.isChamberShow = false;
                    this.isLawFirm = false;
                    this.isGtMemberFirm = false;
                    this.isExistingClient = false;
                    this.isGtEmployee = false;
                    this.isInvesterPrivate = false;
                    this.isCampaign = false;
                    this.isintermediaryRef = false;
                    this.isGtAlumni = false;
                    this.isGlobalDelivery = false;
                    this.isnvestmentBank = false;
                    //this.isIndependentDirectors=true;
                    this.channel = event.detail.value;
                    this.apexCallWithCondition();

                } else if (event.detail.value == 'Client Referral') {
                    this.isNotCampaign = true;
                    this.byPassIfClientOrContactNull = false;
                    this.isChamberShow = false;
                    this.isLawFirm = false;
                    this.isGtMemberFirm = false;
                    this.isExistingClient = false;
                    this.isGtEmployee = false;
                    this.isInvesterPrivate = false;
                    this.isCampaign = false;
                    this.isintermediaryRef = false;
                    this.isGtAlumni = false;
                    this.isGlobalDelivery = false;
                    this.isnvestmentBank = false;
                    //this.isIndependentDirectors=true;
                    this.channel = event.detail.value;
                    this.apexCallWithCondition();

                }
                else if (event.detail.value == '--None--') {
                    this.leadObject.Channel__c = null;
                    this.byPassIfClientOrContactNull = true;
                    this.isNotCampaign = false;
                    this.isChamberShow = false;
                    this.isLawFirm = false;
                    this.isGtMemberFirm = false;
                    this.isExistingClient = false;
                    this.isGtEmployee = false;
                    this.isInvesterPrivate = false;
                    this.isCampaign = false;
                    this.isintermediaryRef = false;
                    this.isGtAlumni = false;
                    this.isGlobalDelivery = false;
                    this.isnvestmentBank = false;
                    this.isIndependentDirectors = false;
                    this.channel = event.detail.value;
                    console.log('None ' + this.channel);

                } else {
                    console.log('event.detail.value', event.detail.value);
                    this.byPassIfClientOrContactNull = true;
                    this.pastClient = true;
                    this.isChamberShow = false;
                    this.isLawFirm = false;
                    this.isGtMemberFirm = false;
                    this.isExistingClient = true;
                    this.isGtEmployee = false;
                    this.isInvesterPrivate = false;
                    this.isCampaign = false;
                    this.isintermediaryRef = false;
                    this.isGtAlumni = false;
                    this.isGlobalDelivery = false;
                    this.isnvestmentBank = false;
                    this.isIndependentDirectors = false;
                }
                break;
            case 'Mobile Phone':
                this.leadObject.MobilePhone = event.detail.value;

                var inputFields = this.template.querySelector('.phone_number__c');
                inputFields.setCustomValidity("");
                inputFields.reportValidity();
                if (!inputFields.checkValidity()) {

                }
                else {
                    this.leadObject.MobilePhone = event.detail.value;
                    var inputCmp = this.template.querySelector('.phone_number__c');
                    inputCmp.setCustomValidity("");
                    console.log('this.leadObject.MobilePhone' + this.leadObject.MobilePhone);
                    console.log('this.leadObject.countryCode__c' + this.leadObject.countryCode__c);
                    if (this.leadObject.MobilePhone != '' && this.leadObject.countryCode__c != '') {
                        if (this.leadObject.countryCode__c == 'India (+91)') {
                            console.log('----->>' + this.leadObject.MobilePhone.length);

                            if (this.leadObject.MobilePhone.length < 10 && this.leadObject.MobilePhone.length > 1) {
                                this.isMobileValid = true;
                                inputCmp.setCustomValidity('Please enter a valid 10-digit number');
                                inputCmp.reportValidity();

                            } else if (this.leadObject.MobilePhone.length > 10) {
                                this.isMobileValid = true;
                                inputCmp.setCustomValidity('Please enter a valid 10-digit number');
                                inputCmp.reportValidity();

                            } else {
                                this.isMobileValid = false;
                            }
                        } else {
                            this.isMobileValid = false;
                        }
                    }
                }
                //this.inputchange(event);

                break;
            case 'Industry':
                console.log("Score value is 20");
                //Added by Deepak Joshi bug W-002757
                this.leadObject.SubIndustry__c = '';
                this.isIndustrydisable = true;
                this.leadObject.Industry__c = event.detail;
                if (this.leadObject.Industry__c = event.detail) {
                    this.handleIndustryPiclistValues();
                }
                break;
            case 'SubIndustry__c':
                this.leadObject.SubIndustry__c = event.detail.value;
                break;
            default:
                console.log("error");
        }


    }


    handleMCA_ChildCallout() {

        this.isLoading = true;
        Promise.all([
            this.fnNewClientAlertsData(),
            //this.fnnewClientAlertsDataCourtCase(),
            this.fnCreateCompetitorFromMCA(),
            this.fnCreateInvestorsFromMCA(),
            this.fnCreateInvestorsFromMCAAnnualReturn()

        ]).then((result) => {

            this.handleSubmit(this.clientId);
            this.isLoading = false;
        }).catch(error => {
            console.log('handleMCA_ChildCallout error : ',error);
            console.log('handleMCA_ChildCallout error stringify : ',JSON.stringify(error));
            this.handleSubmit(this.clientId);
            this.isLoading = false;
        });


    }

    async fnNewClientAlertsData() {
        if (!this.isEmpty(this.leadObject.MCA_ID__c)) {
            this.shortMessageLoader = 'Fetching convicted-director from MCA...';
            await newClientAlertsData({ mcaId: this.leadObject.MCA_ID__c, obj: 'Lead', recordId: this.clientId }).then((result) => {
                console.log('Client News  ----> ', result);
                this.shortMessageLoader = 'Fetching convicted-director from MCA...';
            }).catch(error => { });
        }
    }
    async fnnewClientAlertsDataCourtCase() {
        if (!this.isEmpty(this.leadObject.MCA_ID__c)) {
            this.shortMessageLoader = 'Fetching convicted-director from MCA...';
            await newClientAlertsDataCourtCase({ mcaId: this.leadObject.MCA_ID__c, obj: 'Lead', Id: this.clientId }).then((result) => {
                this.shortMessageLoader = 'Fetching convicted-director from MCA...';
            }).catch(error => { });
        }
    }

    async fnCreateCompetitorFromMCA() {
        if (!this.isEmpty(this.leadObject.MCA_ID__c)) {
            this.shortMessageLoader = 'Fetching Competitor from MCA...';
            await createCompetitorFromMCA({ clientId: this.clientId, companyID: this.leadObject.MCA_ID__c, obj: 'Lead' }).then((result) => {
                this.shortMessageLoader = 'Fetching Competitor from MCA...';
            }).catch(error => { });
        }
    }

    async fnCreateInvestorsFromMCA() {
        if (!this.isEmpty(this.leadObject.EntityId__c)) {
            this.shortMessageLoader = 'Fetching Investors from MCA...';
            await createInvestorsFromMCA({ clientId: this.clientId, mcaId: this.leadObject.EntityId__c, obj: 'Lead' }).then((result) => {
                this.shortMessageLoader = 'Fetching Investors from MCA...';
            }).catch(error => { })
        }
    }

    async fnCreateInvestorsFromMCAAnnualReturn() {
        if (!this.isEmpty(this.leadObject.EntityId__c)) {
            this.shortMessageLoader = 'Fetching Investors annual return from MCA...';
            await createInvestorsFromMCAAnnualReturn({ clientId: this.clientId, mcaId: this.leadObject.EntityId__c, obj: 'Lead' }).then((result) => {
                this.shortMessageLoader = 'Fetching Investors annual return from MCA...';
            }).catch(error => { })
        }
    }


    handleChildCallout() {
        Promise.all([createCompetitor({ clientId: this.clientId, companyID: this.leadObject.capIQId__c, obj: 'Lead' })
            .then((result) => {
                this.shortMessageLoader = 'Fetching Data For Competitor...';
            }).catch(error => {

            }), createSubsidiarys({ clientId: this.clientId, companyID: this.leadObject.capIQId__c, obj: 'Lead' })
                .then((result) => {
                    this.shortMessageLoader = 'Fetching Data For Subsidiaries...';
                    console.log('List of SubSidiaries', result);
                    if (result) {

                    }
                }).catch(error => {


                }), createClientNews({ clientId: this.clientId, companyID: this.leadObject.capIQId__c, obj: 'Lead' })
                    .then((result) => {
                        this.shortMessageLoader = 'Fetching Data For Client News...';
                    }).catch(error => {

                    }), createJointVenture({ clientId: this.clientId, companyID: this.leadObject.capIQId__c, obj: 'Lead' })
                        .then((result) => {
                            this.shortMessageLoader = 'Fetching Data For Joint Venture...';
                        }).catch(error => {


                        }), createInvestors({ clientId: this.clientId, companyID: this.leadObject.capIQId__c, obj: 'Lead' })
                            .then((result) => {

                                this.shortMessageLoader = 'Fetching Data For Investor...';
                            }).catch(error => {


                            })]).then((result) => {
                                this.handleSubmit(this.clientId);
                                this.isLoading = false;


                            }).catch(error => {
                                this.handleSubmit(this.clientId);
                                this.isLoading = false;

                            })

    }

    createLeadrecord() {
        console.log('inside submit');
        this.isLoading = true;
        if (this.ifMcaCallout == true) {
            this.about = ' ';

            console.log('2650 this.about ---->', this.about, '  ', this.mainActivity, '  ', this.businessActivity, '  ', this.yearFoundedForAbout);
            /*if( typeof this.mainActivity !== 'undefined' && this.mainActivity !== '' && typeof this.businessActivity !== 'undefined' && this.businessActivity !== ''  && typeof this.yearFoundedForAbout !== 'undefined' && this.yearFoundedForAbout !== ''){
                this.about = this.leadObject.Company+" is a ";
                this.about = this.about+this.mainActivity+" predominantly dealing in "+this.businessActivity+" since last "+this.yearFoundedForAbout +" years. ";
                console.log('2653 this.about ---->',this.about);
            }*/
            if (!this.isEmpty(this.mainActivity) && !this.isEmpty(this.businessActivity) && !this.isEmpty(this.yearFoundedForAbout) && !this.isEmpty(this.constitutionOfBusiness)) {
                this.about = this.leadObject.Company + " is a ";
                this.about = this.about + this.mainActivity + ' ' + this.constitutionOfBusiness + " predominantly dealing in " + this.businessActivity + " since last " + this.yearFoundedForAbout + " years. ";
                console.log('2653 this.about ---->', this.about);
            }

            if (this.about != ' ') {
                if (typeof this.fullAddresMCA !== 'undefined' && this.fullAddresMCA !== '' && typeof this.stateCountForAbout !== 'undefined' && this.stateCountForAbout !== '' && typeof this.branchCountForAbout !== 'undefined' && this.branchCountForAbout !== '') {
                    this.about = this.about + "The entity is based out of " + this.fullAddresMCA + " and has operations across " + this.stateCountForAbout + " states and " + this.branchCountForAbout + " locations across the country.";
                    console.log('2656 this.about ---->', this.about);
                }
            }
            else {
                if (typeof this.fullAddresMCA !== 'undefined' && this.fullAddresMCA !== '' && typeof this.stateCountForAbout !== 'undefined' && this.stateCountForAbout !== '' && typeof this.branchCountForAbout !== 'undefined' && this.branchCountForAbout !== '') {
                    this.about = this.leadObject.Company + " is based out of " + this.fullAddresMCA + " and has operations across " + this.stateCountForAbout + " states and " + this.branchCountForAbout + " locations across the country.";
                    console.log('2656 this.about ---->', this.about);
                }
            }
            if (this.about != ' ') {
                if (typeof this.ebit !== 'undefined' && this.ebit !== '' && typeof this.yearFounded !== 'undefined' && this.yearFounded !== '') {
                    this.about = this.about + '\n ' + this.leadObject.Company + ' has a turnover of ' + this.ebit + " lacs for " + this.yearFounded;

                    this.about = this.about + " with profit of " + this.ebitda + " lacs for " + this.yearFounded;
                    console.log('2663 this.about ---->', this.about);
                }
                else if (typeof this.resultFromnewClientGSTThird !== 'undefined' && this.resultFromnewClientGSTThird !== '') {
                    this.about = this.about + ' \n ' + this.leadObject.Company + ' has a turnover of ' + this.resultFromnewClientGSTFirst + " for " + this.resultFromnewClientGSTsecond;
                    this.about = this.about + " with profit of " + this.resultFromnewClientGSTThird + " for " + this.resultFromnewClientGSTFourth;
                    console.log('2668 this.about ---->', this.about);
                }
            }
            else {
                if (typeof this.ebit !== 'undefined' && this.ebit !== '' && typeof this.yearFounded !== 'undefined' && this.yearFounded !== '') {
                    this.about = this.about + this.leadObject.Company + ' has a turnover of ' + this.ebit + " lacs for " + this.yearFounded;

                    this.about = this.about + " with profit of " + this.ebitda + " lacs for " + this.yearFounded;
                    console.log('2676 this.about ---->', this.about, 'this.ebit --->', this.ebit);
                }
                else if (typeof this.resultFromnewClientGSTThird !== 'undefined' && this.resultFromnewClientGSTThird !== '') {
                    this.about = this.about + this.leadObject.Company + ' has a turnover of ' + this.resultFromnewClientGSTFirst + " for " + this.resultFromnewClientGSTsecond;
                    this.about = this.about + " with profit of " + this.resultFromnewClientGSTThird + " for " + this.resultFromnewClientGSTFourth;
                    console.log('2681 this.about ---->', this.about);
                }
            }


            console.log('2606 this.about ---->', this.about);
            this.leadObject.ClientBackground__c = this.about;
        }

        console.log('Lead record : ', JSON.stringify(this.leadObject));
        CreateLead({ leadObject: JSON.stringify(this.leadObject), selectedExpertise: this.selectedExpertise })
            .then(result => {
                this.shortMessageLoader = 'Fetching Data For Competitor...';
                var response = JSON.parse(result);
                console.log('Data>>>>' + response);
                if (response.status == 'Ok') {
                    this.clientId = response.body;

                    //this.isLoading=false;
                    //this.handleSubmit(result);
                    if (!this.isEmpty(this.capIQ)) {
                        this.isLoading = true;
                        this.shortMessageLoader = 'Fetching from CAPIQ...';
                        console.log('Create capIQ Competitor', this.capIQ, this.clientId);

                        this.handleChildCallout();
                    } else if (!this.isEmpty(this.mcaId)) {
                        this.isLoading = true;
                        console.log('Create MCA Competitor', this.mcaId, this.clientId);
                        this.shortMessageLoader = 'Fetching from MCA...';
                        this.handleMCA_ChildCallout();
                    } else {
                        this.handleSubmit(this.clientId);
                        this.isLoading = false;
                    }

                } else {
                    var errorMessage = response.body;
                    this.isLoading = false;
                    const eventt = new ShowToastEvent({
                        title: errorMessage,
                        //  message:'',
                        variant: 'warning'
                    });
                    this.dispatchEvent(eventt);

                }

            }).catch(error => {
                console.log(error);
                this.error = error;
                this.isLoading = false;
            });
        console.log('inside submit');


    }
    handleIndustryPiclistValues(event) {
        console.log('1196');
        industriesValues({ Sector: this.leadObject.Industry__c })
            .then(data => {
                if (data) {
                    try {
                        console.log('1204', data);
                        this.ListAllypes = data;
                        let options = [];
                        for (var key in data) {
                            options.push({ label: data[key].picklistlabel, value: data[key].picklistvalue });

                        }
                        console.log('options', options);
                        this.TypeOptions = options;
                        this.isIndustrydisable = false;

                    } catch (error) {
                        console.error('check error here', error);
                    }

                }
            }).catch(error => {
                console.log('1221', error)
            });
    }
    handleChildData(event) {
        console.log('child data : ', event.detail);
    }
    handleLookUpContactChange(event) {
        console.log(event.detail.selectedRecord);
        if (event.detail != null) {
            if (this.leadObject.Channel__c == 'Inbound Referrals - Law Firm') {
                if (event.detail != null) {
                    this.leadObject.LawFirmContacts__c = event.detail.selectedRecord.Id;
                }
            } else if (this.leadObject.Channel__c == 'Inbound Referrals - PE/VC') {
                if (event.detail != null) {
                    this.leadObject.InvestorsPrivateEquityFirms__c = event.detail.selectedRecord.Id;
                }
            } else if (this.leadObject.Channel__c == 'Client Past Relationships / Existing Client') {
                if (event.detail != null) {
                    this.leadObject.ClientContact__c = event.detail.selectedRecord.Id;

                }
            } else if (this.leadObject.Channel__c == 'Chamber') {
                if (event.detail != null) {
                    this.leadObject.Chamber_contacts__c = event.detail.selectedRecord.Id;

                }
            } else if (this.leadObject.Channel__c == 'Independent Directors') {
                if (event.detail != null) {
                    this.leadObject.Independent_Director_Contact_Name__c = event.detail.selectedRecord.Id;

                }
            } else if (this.leadObject.Channel__c == 'Inbound Referrals - Investment Banks') {
                if (event.detail != null) {
                    this.leadObject.Investment_Bank_Contact_Name__c = event.detail.selectedRecord.Id;

                }
            }


        }
    }

    isEmpty(val) {
        return (val === undefined || val == null || val.length <= 0) ? true : false;
    }



}