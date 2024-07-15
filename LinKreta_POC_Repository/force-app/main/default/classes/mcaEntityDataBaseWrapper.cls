public class mcaEntityDataBaseWrapper {
    
    public class Tan {
        public String address {get;set;} 
        public String areaCode {get;set;} 
        public String assessingOfficerNumber {get;set;} 
        public String branch {get;set;} 
        public String buildingName {get;set;} 
        public String category {get;set;} 
        public String deductorCategory {get;set;} 
        public String divisionName {get;set;} 
        public List<String> emailDomains {get;set;} 
        public List<String> emails {get;set;} 
        public String kid {get;set;} 
        public String name {get;set;} 
        public String pan {get;set;} 
        public String sourceUri {get;set;} 
        public String subCategory {get;set;} 
        public String tan {get;set;} 
        public String tanStatus {get;set;} 
        public String timestamp {get;set;} 
        public String dispatchDate {get;set;} 
        
        public Tan(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'address') {
                            address = parser.getText();
                        } else if (text == 'areaCode') {
                            areaCode = parser.getText();
                        } else if (text == 'assessingOfficerNumber') {
                            assessingOfficerNumber = parser.getText();
                        } else if (text == 'branch') {
                            branch = parser.getText();
                        } else if (text == 'buildingName') {
                            buildingName = parser.getText();
                        } else if (text == 'category') {
                            category = parser.getText();
                        } else if (text == 'deductorCategory') {
                            deductorCategory = parser.getText();
                        } else if (text == 'divisionName') {
                            divisionName = parser.getText();
                        } else if (text == 'emailDomains') {
                            emailDomains = arrayOfString(parser);
                        } else if (text == 'emails') {
                            emails = arrayOfString(parser);
                        } else if (text == 'kid') {
                            kid = parser.getText();
                        } else if (text == 'name') {
                            name = parser.getText();
                        } else if (text == 'pan') {
                            pan = parser.getText();
                        } else if (text == 'sourceUri') {
                            sourceUri = parser.getText();
                        } else if (text == 'subCategory') {
                            subCategory = parser.getText();
                        } else if (text == 'tan') {
                            tan = parser.getText();
                        } else if (text == 'tanStatus') {
                            tanStatus = parser.getText();
                        } else if (text == 'timestamp') {
                            timestamp = parser.getText();
                        } else if (text == 'dispatchDate') {
                            dispatchDate = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'Tan consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class FormerSymbols {
        public String oldSymbol {get;set;} 
        public String newSymbol {get;set;} 
        public String fromDate {get;set;} 
        public String toDate {get;set;} 
        
        public FormerSymbols(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'oldSymbol') {
                            oldSymbol = parser.getText();
                        } else if (text == 'newSymbol') {
                            newSymbol = parser.getText();
                        } else if (text == 'fromDate') {
                            fromDate = parser.getText();
                        } else if (text == 'toDate') {
                            toDate = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'FormerSymbols consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class Defaults_Z {
        public String wageYearMonth {get;set;} 
        public String establishmentId {get;set;} 
        
        public Defaults_Z(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'wageYearMonth_') {
                            wageYearMonth = parser.getText();
                        } else if (text == 'establishmentId') {
                            establishmentId = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'Defaults_Z consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class Defaults_Y {
        public String returnType {get;set;} 
        public String returnYearMonth {get;set;} 
        public String gstin {get;set;} 
        
        public Defaults_Y(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'returnType') {
                            returnType = parser.getText();
                        } else if (text == 'returnYearMonth') {
                            returnYearMonth = parser.getText();
                        } else if (text == 'gstin') {
                            gstin = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'Defaults_Y consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class Result {
        public Profile profile {get;set;} 
        public Management management {get;set;} 
        public List<Charges> charges {get;set;} 
        public StatutoryRegistration statutoryRegistration {get;set;} 
        public List<CreditRatings> creditRatings {get;set;} 
        public Alerts_Z alerts {get;set;} 
        public Alerts_Z formerAlerts {get;set;} 
        public StatutoryCompliance statutoryCompliance {get;set;} 
        
        public Result(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'profile') {
                            profile = new Profile(parser);
                        } else if (text == 'management') {
                            management = new Management(parser);
                        } else if (text == 'charges') {
                            charges = arrayOfCharges(parser);
                        } else if (text == 'statutoryRegistration') {
                            statutoryRegistration = new StatutoryRegistration(parser);
                        } else if (text == 'creditRatings') {
                            creditRatings = arrayOfCreditRatings(parser);
                        } else if (text == 'alerts') {
                            alerts = new Alerts_Z(parser);
                        } else if (text == 'formerAlerts') {
                            formerAlerts = new Alerts_Z(parser);
                        } else if (text == 'statutoryCompliance') {
                            statutoryCompliance = new StatutoryCompliance(parser);
                        } else {
                            System.debug(LoggingLevel.WARN, 'Result consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class BseSecurity {
        public String bookClosureRecordDate {get;set;} 
        public String bseCompanyDelistingDate {get;set;} 
        public String bseCompanyDelistingLastUpdated {get;set;} 
        public String bseCompanyDelistingReason {get;set;} 
        public String bseCompanyDelistingSource {get;set;} 
        public String bseCompanySuspensionMoreThan7YearsDateOfSuspension {get;set;} 
        public String bseCompanySuspensionMoreThan7YearsLastUpdate {get;set;} 
        public String bseCompanySuspensionMoreThan7YearsNoOfShares {get;set;} 
        public String bseCompanySuspensionMoreThan7YearsSource {get;set;} 
        public String bseGsmSurveillanceLastUpdated {get;set;} 
        public String bseGsmSurveillanceSource {get;set;} 
        public String bseGsmSurveillanceStage {get;set;} 
        public String bseGsmSurveillanceWithEffectFromDate {get;set;} 
        public String bseIlliquidLastUpdated {get;set;} 
        public String bseIlliquidSecurityLastTradedPrice {get;set;} 
        public String bseIlliquidSecuritySource {get;set;} 
        public String bsePenalSuspensionDate {get;set;} 
        public String bsePenalSuspensionLastUpdated {get;set;} 
        public String bsePenalSuspensionReason {get;set;} 
        public String bsePenalSuspensionSource {get;set;} 
        public String bseSebiRelaxationForMpsLastUpdated {get;set;} 
        public String bseSebiRelaxationForMpsSource {get;set;} 
        public String cin {get;set;} 
        public List<String> contacts {get;set;} 
        public String dateOfListing {get;set;} 
        public List<Directors_Y> directors {get;set;} 
        public List<EligibleOfferForSales> eligibleOfferForSales {get;set;} 
        public List<String> emailDomains {get;set;} 
        public List<String> emails {get;set;} 
        public String faceValue {get;set;} 
        public List<FormerNames_Z> formerNames {get;set;} 
        public String impactCost {get;set;} 
        public String industry {get;set;} 
        public String instrument {get;set;} 
        public String isBseCompanyDelisted {get;set;} 
        public String isBseCompanySuspendedMoreThan7Years {get;set;} 
        public String isBseIlliquidSecurity {get;set;} 
        public String isBsePenalSuspended {get;set;} 
        public String isBseSebiRelaxationForMps {get;set;} 
        public String isBseUnderGsmSurveillance {get;set;} 
        public String isin {get;set;} 
        public String issuerName {get;set;} 
        public String kid {get;set;} 
        public String marketLot {get;set;} 
        public String mergerLastUpdated {get;set;} 
        public String mergerReason {get;set;} 
        public String mergerSource {get;set;} 
        public String mergerTargetEntity {get;set;} 
        public String mergerType {get;set;} 
        public String name {get;set;} 
        public List<RegisteredOffices> registeredOffices {get;set;} 
        public List<Registrars> registrars {get;set;} 
        public List<SecretarialAuditors> secretarialAuditors {get;set;} 
        public String securityCode {get;set;} 
        public String securityGroup {get;set;} 
        public String securityId {get;set;} 
        public String sourceUri {get;set;} 
        public List<String> srcContacts {get;set;} 
        public List<String> srcEmails {get;set;} 
        public List<String> srcWebsites {get;set;} 
        public String status {get;set;} 
        public List<StatutoryAuditors> statutoryAuditors {get;set;} 
        public String timestamp {get;set;} 
        public List<String> websiteDomains {get;set;} 
        public List<String> websites {get;set;} 
        
        public BseSecurity(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'bookClosureRecordDate') {
                            bookClosureRecordDate = parser.getText();
                        } else if (text == 'bseCompanyDelistingDate') {
                            bseCompanyDelistingDate = parser.getText();
                        } else if (text == 'bseCompanyDelistingLastUpdated') {
                            bseCompanyDelistingLastUpdated = parser.getText();
                        } else if (text == 'bseCompanyDelistingReason') {
                            bseCompanyDelistingReason = parser.getText();
                        } else if (text == 'bseCompanyDelistingSource') {
                            bseCompanyDelistingSource = parser.getText();
                        } else if (text == 'bseCompanySuspensionMoreThan7YearsDateOfSuspension') {
                            bseCompanySuspensionMoreThan7YearsDateOfSuspension = parser.getText();
                        } else if (text == 'bseCompanySuspensionMoreThan7YearsLastUpdate') {
                            bseCompanySuspensionMoreThan7YearsLastUpdate = parser.getText();
                        } else if (text == 'bseCompanySuspensionMoreThan7YearsNoOfShares') {
                            bseCompanySuspensionMoreThan7YearsNoOfShares = parser.getText();
                        } else if (text == 'bseCompanySuspensionMoreThan7YearsSource') {
                            bseCompanySuspensionMoreThan7YearsSource = parser.getText();
                        } else if (text == 'bseGsmSurveillanceLastUpdated') {
                            bseGsmSurveillanceLastUpdated = parser.getText();
                        } else if (text == 'bseGsmSurveillanceSource') {
                            bseGsmSurveillanceSource = parser.getText();
                        } else if (text == 'bseGsmSurveillanceStage') {
                            bseGsmSurveillanceStage = parser.getText();
                        } else if (text == 'bseGsmSurveillanceWithEffectFromDate') {
                            bseGsmSurveillanceWithEffectFromDate = parser.getText();
                        } else if (text == 'bseIlliquidLastUpdated') {
                            bseIlliquidLastUpdated = parser.getText();
                        } else if (text == 'bseIlliquidSecurityLastTradedPrice') {
                            bseIlliquidSecurityLastTradedPrice = parser.getText();
                        } else if (text == 'bseIlliquidSecuritySource') {
                            bseIlliquidSecuritySource = parser.getText();
                        } else if (text == 'bsePenalSuspensionDate') {
                            bsePenalSuspensionDate = parser.getText();
                        } else if (text == 'bsePenalSuspensionLastUpdated') {
                            bsePenalSuspensionLastUpdated = parser.getText();
                        } else if (text == 'bsePenalSuspensionReason') {
                            bsePenalSuspensionReason = parser.getText();
                        } else if (text == 'bsePenalSuspensionSource') {
                            bsePenalSuspensionSource = parser.getText();
                        } else if (text == 'bseSebiRelaxationForMpsLastUpdated') {
                            bseSebiRelaxationForMpsLastUpdated = parser.getText();
                        } else if (text == 'bseSebiRelaxationForMpsSource') {
                            bseSebiRelaxationForMpsSource = parser.getText();
                        } else if (text == 'cin') {
                            cin = parser.getText();
                        } else if (text == 'contacts') {
                            contacts = arrayOfString(parser);
                        } else if (text == 'dateOfListing') {
                            dateOfListing = parser.getText();
                        } else if (text == 'directors') {
                            directors = arrayOfDirectors_Y(parser);
                        } else if (text == 'eligibleOfferForSales') {
                            eligibleOfferForSales = arrayOfEligibleOfferForSales(parser);
                        } else if (text == 'emailDomains_') {
                            emailDomains = arrayOfString(parser);
                        } else if (text == 'emails') {
                            emails = arrayOfString(parser);
                        } else if (text == 'faceValue') {
                            faceValue = parser.getText();
                        } else if (text == 'formerNames') {
                            formerNames = arrayOfFormerNames_Z(parser);
                        } else if (text == 'impactCost') {
                            impactCost = parser.getText();
                        } else if (text == 'industry') {
                            industry = parser.getText();
                        } else if (text == 'instrument') {
                            instrument = parser.getText();
                        } else if (text == 'isBseCompanyDelisted') {
                            isBseCompanyDelisted = parser.getText();
                        } else if (text == 'isBseCompanySuspendedMoreThan7Years') {
                            isBseCompanySuspendedMoreThan7Years = parser.getText();
                        } else if (text == 'isBseIlliquidSecurity') {
                            isBseIlliquidSecurity = parser.getText();
                        } else if (text == 'isBsePenalSuspended') {
                            isBsePenalSuspended = parser.getText();
                        } else if (text == 'isBseSebiRelaxationForMps') {
                            isBseSebiRelaxationForMps = parser.getText();
                        } else if (text == 'isBseUnderGsmSurveillance') {
                            isBseUnderGsmSurveillance = parser.getText();
                        } else if (text == 'isin') {
                            isin = parser.getText();
                        } else if (text == 'issuerName') {
                            issuerName = parser.getText();
                        } else if (text == 'kid') {
                            kid = parser.getText();
                        } else if (text == 'marketLot') {
                            marketLot = parser.getText();
                        } else if (text == 'mergerLastUpdated') {
                            mergerLastUpdated = parser.getText();
                        } else if (text == 'mergerReason') {
                            mergerReason = parser.getText();
                        } else if (text == 'mergerSource') {
                            mergerSource = parser.getText();
                        } else if (text == 'mergerTargetEntity') {
                            mergerTargetEntity = parser.getText();
                        } else if (text == 'mergerType') {
                            mergerType = parser.getText();
                        } else if (text == 'name') {
                            name = parser.getText();
                        } else if (text == 'registeredOffices') {
                            registeredOffices = arrayOfRegisteredOffices(parser);
                        } else if (text == 'registrars') {
                            registrars = arrayOfRegistrars(parser);
                        } else if (text == 'secretarialAuditors') {
                            secretarialAuditors = arrayOfSecretarialAuditors(parser);
                        } else if (text == 'securityCode') {
                            securityCode = parser.getText();
                        } else if (text == 'securityGroup') {
                            securityGroup = parser.getText();
                        } else if (text == 'securityId') {
                            securityId = parser.getText();
                        } else if (text == 'sourceUri') {
                            sourceUri = parser.getText();
                        } else if (text == 'srcContacts') {
                            srcContacts = arrayOfString(parser);
                        } else if (text == 'srcEmails') {
                            srcEmails = arrayOfString(parser);
                        } else if (text == 'srcWebsites') {
                            srcWebsites = arrayOfString(parser);
                        } else if (text == 'status') {
                            status = parser.getText();
                        } else if (text == 'statutoryAuditors') {
                            statutoryAuditors = arrayOfStatutoryAuditors(parser);
                        } else if (text == 'timestamp') {
                            timestamp = parser.getText();
                        } else if (text == 'websiteDomains_') {
                            websiteDomains = arrayOfString(parser);
                        } else if (text == 'websites') {
                            websites = arrayOfString(parser);
                        } else {
                            System.debug(LoggingLevel.WARN, 'BseSecurity consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class Epf_Z {
        public List<Delays_Z> delays {get;set;} 
        public List<Defaults_Z> defaults {get;set;} 
        
        public Epf_Z(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'delays') {
                            delays = arrayOfDelays_Z(parser);
                        } else if (text == 'defaults') {
                            defaults = arrayOfDefaults_Z(parser);
                        } else {
                            System.debug(LoggingLevel.WARN, 'Epf_Z consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class EligibleOfferForSales {
        public String fromYearMonth {get;set;} 
        public String toYearMonth {get;set;} 
        
        public EligibleOfferForSales(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'fromYearMonth') {
                            fromYearMonth = parser.getText();
                        } else if (text == 'toYearMonth') {
                            toYearMonth = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'EligibleOfferForSales consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class StartupRecognition {
        public String certificateNumber {get;set;} 
        public String companyType {get;set;} 
        public String dateOfIncorporation {get;set;} 
        public String dateOfIssueOfCertificate {get;set;} 
        public String kid {get;set;} 
        public String name {get;set;} 
        public String placeOfIssue {get;set;} 
        public String recognition {get;set;} 
        public String sourceUri {get;set;} 
        public String timestamp {get;set;} 
        
        public StartupRecognition(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'certificateNumber') {
                            certificateNumber = parser.getText();
                        } else if (text == 'companyType') {
                            companyType = parser.getText();
                        } else if (text == 'dateOfIncorporation') {
                            dateOfIncorporation = parser.getText();
                        } else if (text == 'dateOfIssueOfCertificate') {
                            dateOfIssueOfCertificate = parser.getText();
                        } else if (text == 'kid') {
                            kid = parser.getText();
                        } else if (text == 'name') {
                            name = parser.getText();
                        } else if (text == 'placeOfIssue') {
                            placeOfIssue = parser.getText();
                        } else if (text == 'recognition') {
                            recognition = parser.getText();
                        } else if (text == 'sourceUri') {
                            sourceUri = parser.getText();
                        } else if (text == 'timestamp') {
                            timestamp = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'StartupRecognition consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class NseSecurity {
        public List<FormerNames_Y> formerNames {get;set;} 
        public List<FormerSymbols> formerSymbols {get;set;} 
        public String isNseCompanyDelisted {get;set;} 
        public String isNseCompanySuspended {get;set;} 
        public String isNseCompanySuspendedNonCompliance {get;set;} 
        public String isNseUnderAsmSurveillance {get;set;} 
        public String isNseUnderGsmSurveillance {get;set;} 
        public String kid {get;set;} 
        public String name {get;set;} 
        public String nseAsmSurveillanceIsin {get;set;} 
        public String nseAsmSurveillanceLastUpdated {get;set;} 
        public String nseAsmSurveillanceSource {get;set;} 
        public String nseAsmSurveillanceStage {get;set;} 
        public String nseAsmSurveillanceType {get;set;} 
        public String nseCompanyDelistingDate {get;set;} 
        public String nseCompanyDelistingLastUpdated {get;set;} 
        public String nseCompanyDelistingSource {get;set;} 
        public String nseCompanyDelistingType {get;set;} 
        public String nseCompanySuspensionDate {get;set;} 
        public String nseCompanySuspensionIssueSize {get;set;} 
        public String nseCompanySuspensionLastTradingDate {get;set;} 
        public String nseCompanySuspensionLastUpdated {get;set;} 
        public String nseCompanySuspensionNoOfShares {get;set;} 
        public String nseCompanySuspensionNonComplianceDate {get;set;} 
        public String nseCompanySuspensionNonComplianceIssueSize {get;set;} 
        public String nseCompanySuspensionNonComplianceLastTradingDate {get;set;} 
        public String nseCompanySuspensionNonComplianceLastUpdated {get;set;} 
        public String nseCompanySuspensionNonComplianceNoOfShares {get;set;} 
        public String nseCompanySuspensionNonComplianceReason {get;set;} 
        public String nseCompanySuspensionNonComplianceSource {get;set;} 
        public String nseCompanySuspensionNonComplianceType {get;set;} 
        public String nseCompanySuspensionReason {get;set;} 
        public String nseCompanySuspensionSource {get;set;} 
        public String nseCompanySuspensionType {get;set;} 
        public String nseGsmSurveillanceIndicator {get;set;} 
        public String nseGsmSurveillanceIsin {get;set;} 
        public String nseGsmSurveillanceLastUpdated {get;set;} 
        public String nseGsmSurveillanceSource {get;set;} 
        public String nseGsmSurveillanceStage {get;set;} 
        public List<Promoters> promoters {get;set;} 
        public List<String> segments {get;set;} 
        public String sourceUri {get;set;} 
        public String symbol {get;set;} 
        public String timestamp {get;set;} 
        
        public NseSecurity(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'formerNames') {
                            formerNames = arrayOfFormerNames_Y(parser);
                        } else if (text == 'formerSymbols') {
                            formerSymbols = arrayOfFormerSymbols(parser);
                        } else if (text == 'isNseCompanyDelisted') {
                            isNseCompanyDelisted = parser.getText();
                        } else if (text == 'isNseCompanySuspended') {
                            isNseCompanySuspended = parser.getText();
                        } else if (text == 'isNseCompanySuspendedNonCompliance') {
                            isNseCompanySuspendedNonCompliance = parser.getText();
                        } else if (text == 'isNseUnderAsmSurveillance') {
                            isNseUnderAsmSurveillance = parser.getText();
                        } else if (text == 'isNseUnderGsmSurveillance') {
                            isNseUnderGsmSurveillance = parser.getText();
                        } else if (text == 'kid') {
                            kid = parser.getText();
                        } else if (text == 'name') {
                            name = parser.getText();
                        } else if (text == 'nseAsmSurveillanceIsin') {
                            nseAsmSurveillanceIsin = parser.getText();
                        } else if (text == 'nseAsmSurveillanceLastUpdated') {
                            nseAsmSurveillanceLastUpdated = parser.getText();
                        } else if (text == 'nseAsmSurveillanceSource') {
                            nseAsmSurveillanceSource = parser.getText();
                        } else if (text == 'nseAsmSurveillanceStage') {
                            nseAsmSurveillanceStage = parser.getText();
                        } else if (text == 'nseAsmSurveillanceType') {
                            nseAsmSurveillanceType = parser.getText();
                        } else if (text == 'nseCompanyDelistingDate') {
                            nseCompanyDelistingDate = parser.getText();
                        } else if (text == 'nseCompanyDelistingLastUpdated') {
                            nseCompanyDelistingLastUpdated = parser.getText();
                        } else if (text == 'nseCompanyDelistingSource') {
                            nseCompanyDelistingSource = parser.getText();
                        } else if (text == 'nseCompanyDelistingType') {
                            nseCompanyDelistingType = parser.getText();
                        } else if (text == 'nseCompanySuspensionDate') {
                            nseCompanySuspensionDate = parser.getText();
                        } else if (text == 'nseCompanySuspensionIssueSize') {
                            nseCompanySuspensionIssueSize = parser.getText();
                        } else if (text == 'nseCompanySuspensionLastTradingDate') {
                            nseCompanySuspensionLastTradingDate = parser.getText();
                        } else if (text == 'nseCompanySuspensionLastUpdated') {
                            nseCompanySuspensionLastUpdated = parser.getText();
                        } else if (text == 'nseCompanySuspensionNoOfShares') {
                            nseCompanySuspensionNoOfShares = parser.getText();
                        } else if (text == 'nseCompanySuspensionNonComplianceDate') {
                            nseCompanySuspensionNonComplianceDate = parser.getText();
                        } else if (text == 'nseCompanySuspensionNonComplianceIssueSize') {
                            nseCompanySuspensionNonComplianceIssueSize = parser.getText();
                        } else if (text == 'nseCompanySuspensionNonComplianceLastTradingDate') {
                            nseCompanySuspensionNonComplianceLastTradingDate = parser.getText();
                        } else if (text == 'nseCompanySuspensionNonComplianceLastUpdated') {
                            nseCompanySuspensionNonComplianceLastUpdated = parser.getText();
                        } else if (text == 'nseCompanySuspensionNonComplianceNoOfShares') {
                            nseCompanySuspensionNonComplianceNoOfShares = parser.getText();
                        } else if (text == 'nseCompanySuspensionNonComplianceReason') {
                            nseCompanySuspensionNonComplianceReason = parser.getText();
                        } else if (text == 'nseCompanySuspensionNonComplianceSource') {
                            nseCompanySuspensionNonComplianceSource = parser.getText();
                        } else if (text == 'nseCompanySuspensionNonComplianceType') {
                            nseCompanySuspensionNonComplianceType = parser.getText();
                        } else if (text == 'nseCompanySuspensionReason') {
                            nseCompanySuspensionReason = parser.getText();
                        } else if (text == 'nseCompanySuspensionSource') {
                            nseCompanySuspensionSource = parser.getText();
                        } else if (text == 'nseCompanySuspensionType') {
                            nseCompanySuspensionType = parser.getText();
                        } else if (text == 'nseGsmSurveillanceIndicator') {
                            nseGsmSurveillanceIndicator = parser.getText();
                        } else if (text == 'nseGsmSurveillanceIsin') {
                            nseGsmSurveillanceIsin = parser.getText();
                        } else if (text == 'nseGsmSurveillanceLastUpdated') {
                            nseGsmSurveillanceLastUpdated = parser.getText();
                        } else if (text == 'nseGsmSurveillanceSource') {
                            nseGsmSurveillanceSource = parser.getText();
                        } else if (text == 'nseGsmSurveillanceStage') {
                            nseGsmSurveillanceStage = parser.getText();
                        } else if (text == 'promoters') {
                            promoters = arrayOfPromoters(parser);
                        } else if (text == 'segments') {
                            segments = arrayOfString(parser);
                        } else if (text == 'sourceUri') {
                            sourceUri = parser.getText();
                        } else if (text == 'symbol') {
                            symbol = parser.getText();
                        } else if (text == 'timestamp') {
                            timestamp = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'NseSecurity consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class Directors_Z {
        public String name {get;set;} 
        public String fatherName {get;set;} 
        public String address {get;set;} 
        public String contact {get;set;} 
        public List<String> contacts {get;set;} 
        
        public Directors_Z(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'name') {
                            name = parser.getText();
                        } else if (text == 'fatherName') {
                            fatherName = parser.getText();
                        } else if (text == 'address') {
                            address = parser.getText();
                        } else if (text == 'contact') {
                            contact = parser.getText();
                        } else if (text == 'contacts_') {
                            contacts = arrayOfString(parser);
                        } else {
                            System.debug(LoggingLevel.WARN, 'Directors_Z consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class Directors_Y {
        public String prefix {get;set;} 
        public String firstName {get;set;} 
        public String middleName {get;set;} 
        public String lastName {get;set;} 
        public String fullName {get;set;} 
        public String designation {get;set;} 
        
        public Directors_Y(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'prefix') {
                            prefix = parser.getText();
                        } else if (text == 'firstName') {
                            firstName = parser.getText();
                        } else if (text == 'middleName') {
                            middleName = parser.getText();
                        } else if (text == 'lastName') {
                            lastName = parser.getText();
                        } else if (text == 'fullName') {
                            fullName = parser.getText();
                        } else if (text == 'designation') {
                            designation = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'Directors_Y consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class Rcmcs {
        public String rcmcNumber {get;set;} 
        public String type {get;set;} 
        public String issuedBy {get;set;} 
        public String issueDate {get;set;} 
        public String expiryDate {get;set;} 
        
        public Rcmcs(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'rcmcNumber') {
                            rcmcNumber = parser.getText();
                        } else if (text == 'type') {
                            type = parser.getText();
                        } else if (text == 'issuedBy') {
                            issuedBy = parser.getText();
                        } else if (text == 'issueDate') {
                            issueDate = parser.getText();
                        } else if (text == 'expiryDate') {
                            expiryDate = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'Rcmcs consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class Registrations {
        public String registrationNumber {get;set;} 
        public String type {get;set;} 
        public String place {get;set;} 
        public String dateOfRegistration {get;set;} 
        
        public Registrations(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'registrationNumber') {
                            registrationNumber = parser.getText();
                        } else if (text == 'type') {
                            type = parser.getText();
                        } else if (text == 'place') {
                            place = parser.getText();
                        } else if (text == 'dateOfRegistration') {
                            dateOfRegistration = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'Registrations consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class Registrars {
        public String name {get;set;} 
        public String srcWebsites {get;set;} 
        public List<String> websites {get;set;} 
        public List<String> websiteDomains {get;set;} 
        public String srcEmails {get;set;} 
        public List<String> emails {get;set;} 
        public List<String> emailDomains {get;set;} 
        public String srcContacts {get;set;} 
        public List<String> contacts {get;set;} 
        public String address {get;set;} 
        
        public Registrars(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'name') {
                            name = parser.getText();
                        } else if (text == 'srcWebsites') {
                            srcWebsites = parser.getText();
                        } else if (text == 'websites') {
                            websites = arrayOfString(parser);
                        } else if (text == 'websiteDomains_') {
                            websiteDomains = arrayOfString(parser);
                        } else if (text == 'srcEmails') {
                            srcEmails = parser.getText();
                        } else if (text == 'emails') {
                            emails = arrayOfString(parser);
                        } else if (text == 'emailDomains_') {
                            emailDomains = arrayOfString(parser);
                        } else if (text == 'srcContacts') {
                            srcContacts = parser.getText();
                        } else if (text == 'contacts') {
                            contacts = arrayOfString(parser);
                        } else if (text == 'address') {
                            address = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'Registrars consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class FormerNames {
        public String name {get;set;} 
        public String fromDate {get;set;} 
        public String toDate {get;set;} 
        
        public FormerNames(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'name') {
                            name = parser.getText();
                        } else if (text == 'fromDate') {
                            fromDate = parser.getText();
                        } else if (text == 'toDate') {
                            toDate = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'FormerNames consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class FormerEntityIds {
        public String entityId {get;set;} 
        public String fromDate {get;set;} 
        public String toDate {get;set;} 
        
        public FormerEntityIds(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'entityId') {
                            entityId = parser.getText();
                        } else if (text == 'fromDate') {
                            fromDate = parser.getText();
                        } else if (text == 'toDate') {
                            toDate = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'FormerEntityIds consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class Branches {
        public String address {get;set;} 
        public String addr {get;set;} 
        public String email {get;set;} 
        public String emailDomain {get;set;} 
        public String contact {get;set;} 
        public String natureOfTrade {get;set;} 
        public String lastUpdatedDate {get;set;} 
        
        public Branches(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'address') {
                            address = parser.getText();
                        } else if (text == 'addr') {
                            addr = parser.getText();
                        } else if (text == 'email') {
                            email = parser.getText();
                        } else if (text == 'emailDomain') {
                            emailDomain = parser.getText();
                        } else if (text == 'contact') {
                            contact = parser.getText();
                        } else if (text == 'natureOfTrade') {
                            natureOfTrade = parser.getText();
                        } else if (text == 'lastUpdatedDate') {
                            lastUpdatedDate = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'Branches consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class Iec {
        public String accountNumber {get;set;} 
        public String accountType {get;set;} 
        public String address {get;set;} 
        public String bank {get;set;} 
        public String bin {get;set;} 
        public List<String> branches {get;set;} 
        public String contact {get;set;} 
        public List<String> contacts {get;set;} 
        public String dateOfIecAllotment {get;set;} 
        public String dateOfIncorporation {get;set;} 
        public List<Directors_Z> directors {get;set;} 
        public String email {get;set;} 
        public String emailDomain {get;set;} 
        public String entityType {get;set;} 
        public String exporterType {get;set;} 
        public String fileDate {get;set;} 
        public String fileNumber {get;set;} 
        public String iec {get;set;} 
        public String iecGateStatus {get;set;} 
        public String iecPrintStatus {get;set;} 
        public String kid {get;set;} 
        public String name {get;set;} 
        public List<Orders> orders {get;set;} 
        public String pan {get;set;} 
        public String panIssueDate {get;set;} 
        public String panIssuedBy {get;set;} 
        public List<Rcmcs> rcmcs {get;set;} 
        public List<Registrations> registrations {get;set;} 
        public String sourceUri {get;set;} 
        public String timestamp {get;set;} 
        
        public Iec(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'accountNumber') {
                            accountNumber = parser.getText();
                        } else if (text == 'accountType') {
                            accountType = parser.getText();
                        } else if (text == 'address') {
                            address = parser.getText();
                        } else if (text == 'bank') {
                            bank = parser.getText();
                        } else if (text == 'bin') {
                            bin = parser.getText();
                        } else if (text == 'branches') {
                            branches = arrayOfString(parser);
                        } else if (text == 'contact') {
                            contact = parser.getText();
                        } else if (text == 'contacts_') {
                            contacts = arrayOfString(parser);
                        } else if (text == 'dateOfIecAllotment') {
                            dateOfIecAllotment = parser.getText();
                        } else if (text == 'dateOfIncorporation') {
                            dateOfIncorporation = parser.getText();
                        } else if (text == 'directors') {
                            directors = arrayOfDirectors_Z(parser);
                        } else if (text == 'email') {
                            email = parser.getText();
                        } else if (text == 'emailDomain') {
                            emailDomain = parser.getText();
                        } else if (text == 'entityType') {
                            entityType = parser.getText();
                        } else if (text == 'exporterType') {
                            exporterType = parser.getText();
                        } else if (text == 'fileDate') {
                            fileDate = parser.getText();
                        } else if (text == 'fileNumber') {
                            fileNumber = parser.getText();
                        } else if (text == 'iec') {
                            iec = parser.getText();
                        } else if (text == 'iecGateStatus') {
                            iecGateStatus = parser.getText();
                        } else if (text == 'iecPrintStatus') {
                            iecPrintStatus = parser.getText();
                        } else if (text == 'kid') {
                            kid = parser.getText();
                        } else if (text == 'name') {
                            name = parser.getText();
                        } else if (text == 'orders') {
                            orders = arrayOfOrders(parser);
                        } else if (text == 'pan') {
                            pan = parser.getText();
                        } else if (text == 'panIssueDate') {
                            panIssueDate = parser.getText();
                        } else if (text == 'panIssuedBy') {
                            panIssuedBy = parser.getText();
                        } else if (text == 'rcmcs') {
                            rcmcs = arrayOfRcmcs(parser);
                        } else if (text == 'registrations') {
                            registrations = arrayOfRegistrations(parser);
                        } else if (text == 'sourceUri') {
                            sourceUri = parser.getText();
                        } else if (text == 'timestamp') {
                            timestamp = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'Iec consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class StatutoryCompliance {
        public Tan_Z tan {get;set;} 
        public Epf_Z epf {get;set;} 
        public Gst_Z gst {get;set;} 
        public Mca_Z mca {get;set;} 
        
        public StatutoryCompliance(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'tan') {
                            tan = new Tan_Z(parser);
                        } else if (text == 'epf') {
                            epf = new Epf_Z(parser);
                        } else if (text == 'gst') {
                            gst = new Gst_Z(parser);
                        } else if (text == 'mca') {
                            mca = new Mca_Z(parser);
                        } else {
                            System.debug(LoggingLevel.WARN, 'StatutoryCompliance consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class StatutoryRegistration {
        public List<Mca> mca {get;set;} 
        public List<Gst> gst {get;set;} 
        public List<Iec> iec {get;set;} 
        public List<Tan> tan {get;set;} 
        public List<Epf> epf {get;set;} 
        public List<Lin> lin {get;set;} 
        public List<Pans> pans {get;set;} 
        public List<StartupRecognition> startupRecognition {get;set;} 
        public List<Lei> lei {get;set;} 
        public ExchangeInformation exchangeInformation {get;set;} 
        
        public StatutoryRegistration(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'mca') {
                            mca = arrayOfMca(parser);
                        } else if (text == 'gst') {
                            gst = arrayOfGst(parser);
                        } else if (text == 'iec') {
                            iec = arrayOfIec(parser);
                        } else if (text == 'tan') {
                            tan = arrayOfTan(parser);
                        } else if (text == 'epf') {
                            epf = arrayOfEpf(parser);
                        } else if (text == 'lin') {
                            lin = arrayOfLin(parser);
                        } else if (text == 'pans') {
                            pans = arrayOfPans(parser);
                        } else if (text == 'startupRecognition') {
                            startupRecognition = arrayOfStartupRecognition(parser);
                        } else if (text == 'lei') {
                            lei = arrayOfLei(parser);
                        } else if (text == 'exchangeInformation') {
                            exchangeInformation = new ExchangeInformation(parser);
                        } else {
                            System.debug(LoggingLevel.WARN, 'StatutoryRegistration consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class Details_Z {
        public List<ManagementAlerts> managementAlerts {get;set;} 
        public Alerts entityAlerts {get;set;} 
        
        public Details_Z(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'managementAlerts') {
                            managementAlerts = arrayOfManagementAlerts(parser);
                        } else if (text == 'entityAlerts') {
                            entityAlerts = new Alerts(parser);
                        } else {
                            System.debug(LoggingLevel.WARN, 'Details_Z consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class Promoters {
        public String name {get;set;} 
        
        public Promoters(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'name') {
                            name = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'Promoters consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class Pans {
        public String address {get;set;} 
        public String dateOfBirth {get;set;} 
        public String dateOfIssuance {get;set;} 
        public String email {get;set;} 
        public String emailDomain {get;set;} 
        public String isAddressQualityPoor {get;set;} 
        public String isPanInactive {get;set;} 
        public String mcaEntityId {get;set;} 
        public String mcaEntityType {get;set;} 
        public String name {get;set;} 
        public String pan {get;set;} 
        public String panType {get;set;} 
        public String pincode {get;set;} 
        public String state {get;set;} 
        public String timestamp {get;set;} 
        public String yearMonthOfIssuance {get;set;} 
        
        public Pans(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'address') {
                            address = parser.getText();
                        } else if (text == 'dateOfBirth') {
                            dateOfBirth = parser.getText();
                        } else if (text == 'dateOfIssuance') {
                            dateOfIssuance = parser.getText();
                        } else if (text == 'email') {
                            email = parser.getText();
                        } else if (text == 'emailDomain') {
                            emailDomain = parser.getText();
                        } else if (text == 'isAddressQualityPoor_') {
                            isAddressQualityPoor = parser.getText();
                        } else if (text == 'isPanInactive') {
                            isPanInactive = parser.getText();
                        } else if (text == 'mcaEntityId') {
                            mcaEntityId = parser.getText();
                        } else if (text == 'mcaEntityType') {
                            mcaEntityType = parser.getText();
                        } else if (text == 'name') {
                            name = parser.getText();
                        } else if (text == 'pan') {
                            pan = parser.getText();
                        } else if (text == 'panType') {
                            panType = parser.getText();
                        } else if (text == 'pincode') {
                            pincode = parser.getText();
                        } else if (text == 'state') {
                            state = parser.getText();
                        } else if (text == 'timestamp') {
                            timestamp = parser.getText();
                        } else if (text == 'yearMonthOfIssuance') {
                            yearMonthOfIssuance = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'Pans consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class Details {
        public String label {get;set;} 
        public List<String> value {get;set;} 
        
        public Details(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'label') {
                            label = parser.getText();
                        } else if (text == 'value') {
                            value = arrayOfString(parser);
                        } else {
                            System.debug(LoggingLevel.WARN, 'Details consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class Defaults {
        public String tan {get;set;} 
        public String latestDateOfDefault {get;set;} 
        
        public Defaults(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'tan') {
                            tan = parser.getText();
                        } else if (text == 'latestDateOfDefault') {
                            latestDateOfDefault = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'Defaults consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class EstablishmentMembers {
        public String name {get;set;} 
        public String fatherName {get;set;} 
        public String dateOfBirth {get;set;} 
        public String address {get;set;} 
        public String designation {get;set;} 
        public String tenureBeginDate {get;set;} 
        
        public EstablishmentMembers(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'name') {
                            name = parser.getText();
                        } else if (text == 'fatherName') {
                            fatherName = parser.getText();
                        } else if (text == 'dateOfBirth') {
                            dateOfBirth = parser.getText();
                        } else if (text == 'address') {
                            address = parser.getText();
                        } else if (text == 'designation') {
                            designation = parser.getText();
                        } else if (text == 'tenureBeginDate') {
                            tenureBeginDate = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'EstablishmentMembers consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class StatutoryAuditors {
        public String name {get;set;} 
        public String companyCode {get;set;} 
        public String registrationNumber {get;set;} 
        public String peerReviewCertificateNumber {get;set;} 
        
        public StatutoryAuditors(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'name') {
                            name = parser.getText();
                        } else if (text == 'companyCode') {
                            companyCode = parser.getText();
                        } else if (text == 'registrationNumber') {
                            registrationNumber = parser.getText();
                        } else if (text == 'peerReviewCertificateNumber') {
                            peerReviewCertificateNumber = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'StatutoryAuditors consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class AlertList {
        public String alert {get;set;} 
        public String exists {get;set;} 
        public String severity {get;set;} 
        public String documentUrl {get;set;} 
        public String lastUpdatedDate {get;set;} 
        public List<DetailsAsPerSource> detailsAsPerSource {get;set;} 
        
        public AlertList(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'alert') {
                            alert = parser.getText();
                        } else if (text == 'exists') {
                            exists = parser.getText();
                        } else if (text == 'severity') {
                            severity = parser.getText();
                        } else if (text == 'documentUrl') {
                            documentUrl = parser.getText();
                        } else if (text == 'lastUpdatedDate') {
                            lastUpdatedDate = parser.getText();
                        } else if (text == 'detailsAsPerSource') {
                            detailsAsPerSource = arrayOfDetailsAsPerSource(parser);
                        } else {
                            System.debug(LoggingLevel.WARN, 'AlertList consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class Alerts {
        
        public Alerts(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        {
                            System.debug(LoggingLevel.WARN, 'Alerts consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class Delays {
        public String tan {get;set;} 
        public String latestDateOfDelay {get;set;} 
        
        public Delays(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'tan') {
                            tan = parser.getText();
                        } else if (text == 'latestDateOfDelay') {
                            latestDateOfDelay = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'Delays consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class Current {
        public String kid {get;set;} 
        public String din {get;set;} 
        public String dinPan {get;set;} 
        public List<String> pans {get;set;} 
        public String name {get;set;} 
        public String contact {get;set;} 
        public String gender {get;set;} 
        public String email {get;set;} 
        public String isDscRegistered {get;set;} 
        public String dscExpiryDate {get;set;} 
        public String designation {get;set;} 
        public String dateOfBirth {get;set;} 
        public List<Alerts> alerts {get;set;} 
        public String tenureBeginDate {get;set;} 
        public String tenureEndDate {get;set;} 
        public String fatherName {get;set;} 
        public String status {get;set;} 
        public String address {get;set;} 
        public String city {get;set;} 
        public String state {get;set;} 
        public String pin {get;set;} 
        public String dinDateOfApproval {get;set;} 
        
        public Current(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'kid') {
                            kid = parser.getText();
                        } else if (text == 'din') {
                            din = parser.getText();
                        } else if (text == 'dinPan_') {
                            dinPan = parser.getText();
                        } else if (text == 'pans') {
                            pans = arrayOfString(parser);
                        } else if (text == 'name') {
                            name = parser.getText();
                        } else if (text == 'contact') {
                            contact = parser.getText();
                        } else if (text == 'gender') {
                            gender = parser.getText();
                        } else if (text == 'email') {
                            email = parser.getText();
                        } else if (text == 'isDscRegistered') {
                            isDscRegistered = parser.getText();
                        } else if (text == 'dscExpiryDate') {
                            dscExpiryDate = parser.getText();
                        } else if (text == 'designation') {
                            designation = parser.getText();
                        } else if (text == 'dateOfBirth') {
                            dateOfBirth = parser.getText();
                        } else if (text == 'alerts') {
                            alerts = arrayOfAlerts(parser);
                        } else if (text == 'tenureBeginDate') {
                            tenureBeginDate = parser.getText();
                        } else if (text == 'tenureEndDate') {
                            tenureEndDate = parser.getText();
                        } else if (text == 'fatherName') {
                            fatherName = parser.getText();
                        } else if (text == 'status') {
                            status = parser.getText();
                        } else if (text == 'address') {
                            address = parser.getText();
                        } else if (text == 'city') {
                            city = parser.getText();
                        } else if (text == 'state') {
                            state = parser.getText();
                        } else if (text == 'pin') {
                            pin = parser.getText();
                        } else if (text == 'dinDateOfApproval') {
                            dinDateOfApproval = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'Current consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class Orders {
        public String orderNumber {get;set;} 
        public String issuedBy {get;set;} 
        public String dateOfOrder {get;set;} 
        public String details {get;set;} 
        
        public Orders(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'orderNumber') {
                            orderNumber = parser.getText();
                        } else if (text == 'issuedBy') {
                            issuedBy = parser.getText();
                        } else if (text == 'dateOfOrder') {
                            dateOfOrder = parser.getText();
                        } else if (text == 'details') {
                            details = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'Orders consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class SecretarialAuditors {
        public String name {get;set;} 
        public String companyCode {get;set;} 
        public String icsiCertificateOfPracticeNumber {get;set;} 
        
        public SecretarialAuditors(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'name') {
                            name = parser.getText();
                        } else if (text == 'companyCode') {
                            companyCode = parser.getText();
                        } else if (text == 'icsiCertificateOfPracticeNumber') {
                            icsiCertificateOfPracticeNumber = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'SecretarialAuditors consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public Integer statusCode {get;set;} 
    public Result result {get;set;} 
    
    public mcaEntityDataBaseWrapper(JSONParser parser) {
        while (parser.nextToken() != System.JSONToken.END_OBJECT) {
            if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                String text = parser.getText();
                if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                    if (text == 'statusCode') {
                        statusCode = parser.getIntegerValue();
                    } else if (text == 'result') {
                        result = new Result(parser);
                    } else {
                        System.debug(LoggingLevel.WARN, 'mcaEntityDataBaseWrapper consuming unrecognized property: '+text);
                        consumeObject(parser);
                    }
                }
            }
        }
    }
    
    public class FormerNames_Y {
        public String oldName {get;set;} 
        public String newName {get;set;} 
        public String fromDate {get;set;} 
        public String toDate {get;set;} 
        
        public FormerNames_Y(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'oldName') {
                            oldName = parser.getText();
                        } else if (text == 'newName') {
                            newName = parser.getText();
                        } else if (text == 'fromDate') {
                            fromDate = parser.getText();
                        } else if (text == 'toDate') {
                            toDate = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'FormerNames_Y consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class FormerNames_Z {
        public String oldName {get;set;} 
        public String newName {get;set;} 
        public String fromDate {get;set;} 
        public String toDate {get;set;} 
        public String sourceUri {get;set;} 
        
        public FormerNames_Z(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'oldName') {
                            oldName = parser.getText();
                        } else if (text == 'newName') {
                            newName = parser.getText();
                        } else if (text == 'fromDate') {
                            fromDate = parser.getText();
                        } else if (text == 'toDate') {
                            toDate = parser.getText();
                        } else if (text == 'sourceUri') {
                            sourceUri = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'FormerNames_Z consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class Delays_Y {
        public String returnType {get;set;} 
        public String returnYearMonth {get;set;} 
        public String arn {get;set;} 
        public String dateOfFiling {get;set;} 
        public String revisedDueDateOfFiling {get;set;} 
        public String noOfDaysOfDelay {get;set;} 
        public String gstin {get;set;} 
        
        public Delays_Y(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'returnType') {
                            returnType = parser.getText();
                        } else if (text == 'returnYearMonth') {
                            returnYearMonth = parser.getText();
                        } else if (text == 'arn') {
                            arn = parser.getText();
                        } else if (text == 'dateOfFiling') {
                            dateOfFiling = parser.getText();
                        } else if (text == 'revisedDueDateOfFiling') {
                            revisedDueDateOfFiling = parser.getText();
                        } else if (text == 'noOfDaysOfDelay') {
                            noOfDaysOfDelay = parser.getText();
                        } else if (text == 'gstin') {
                            gstin = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'Delays_Y consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class Delays_Z {
        public String wageYearMonth {get;set;} 
        public String transactionYearMonth {get;set;} 
        public String transactionId {get;set;} 
        public String dateOfCredit {get;set;} 
        public String establishmentId {get;set;} 
        
        public Delays_Z(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'wageYearMonth_') {
                            wageYearMonth = parser.getText();
                        } else if (text == 'transactionYearMonth_') {
                            transactionYearMonth = parser.getText();
                        } else if (text == 'transactionId') {
                            transactionId = parser.getText();
                        } else if (text == 'dateOfCredit') {
                            dateOfCredit = parser.getText();
                        } else if (text == 'establishmentId') {
                            establishmentId = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'Delays_Z consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class Profile {
        public String name {get;set;} 
        public String tradeName {get;set;} 
        public List<FormerNames> formerNames {get;set;} 
        public List<FormerEntityIds> formerEntityIds {get;set;} 
        public List<String> pans {get;set;} 
        public String contact {get;set;} 
        public String email {get;set;} 
        public String industry {get;set;} 
        public String subIndustry {get;set;} 
        public String activityGroup {get;set;} 
        public String activityClass {get;set;} 
        public String activitySubClass {get;set;} 
        public String entityClass {get;set;} 
        public List<String> natureOfBusiness {get;set;} 
        public String fatherName {get;set;} 
        public String registeredAddress {get;set;} 
        public String city {get;set;} 
        public String state {get;set;} 
        public String pin {get;set;} 
        public String dateOfIncorporation {get;set;} 
        public String constitutionOfBusiness {get;set;} 
        public String entityId {get;set;} 
        public String type {get;set;} 
        public String descriptionOfMainDivision {get;set;} 
        public String mainDivisonOfBusinessActivity {get;set;} 
        
        public Profile(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'name') {
                            name = parser.getText();
                        } else if (text == 'tradeName') {
                            tradeName = parser.getText();
                        } else if (text == 'formerNames') {
                            formerNames = arrayOfFormerNames(parser);
                        } else if (text == 'formerEntityIds') {
                            formerEntityIds = arrayOfFormerEntityIds(parser);
                        } else if (text == 'pans') {
                            pans = arrayOfString(parser);
                        } else if (text == 'contact') {
                            contact = parser.getText();
                        } else if (text == 'email') {
                            email = parser.getText();
                        } else if (text == 'industry') {
                            industry = parser.getText();
                        } else if (text == 'subIndustry') {
                            subIndustry = parser.getText();
                        } else if (text == 'activityGroup') {
                            activityGroup = parser.getText();
                        } else if (text == 'activityClass') {
                            activityClass = parser.getText();
                        } else if (text == 'activitySubClass') {
                            activitySubClass = parser.getText();
                        } else if (text == 'entityClass') {
                            entityClass = parser.getText();
                        } else if (text == 'natureOfBusiness') {
                            natureOfBusiness = arrayOfString(parser);
                        } else if (text == 'fatherName') {
                            fatherName = parser.getText();
                        } else if (text == 'registeredAddress') {
                            registeredAddress = parser.getText();
                        } else if (text == 'city') {
                            city = parser.getText();
                        } else if (text == 'state') {
                            state = parser.getText();
                        } else if (text == 'pin') {
                            pin = parser.getText();
                        } else if (text == 'dateOfIncorporation') {
                            dateOfIncorporation = parser.getText();
                        } else if (text == 'entityId') {
                            entityId = parser.getText();
                        } else if (text == 'type') {
                            type = parser.getText();
                        } else if (text == 'descriptionOfMainDivision') {
                            descriptionOfMainDivision = parser.getText();
                        } else if (text == 'mainDivisonOfBusinessActivity') {
                            mainDivisonOfBusinessActivity = parser.getText();
                        }else if (text == 'constitutionOfBusiness') {
                            constitutionOfBusiness = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'Profile consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class SignatoriesContact {
        public String name {get;set;} 
        public String email {get;set;} 
        public String emailDomain {get;set;} 
        public String contact {get;set;} 
        
        public SignatoriesContact(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'name') {
                            name = parser.getText();
                        } else if (text == 'email') {
                            email = parser.getText();
                        } else if (text == 'emailDomain') {
                            emailDomain = parser.getText();
                        } else if (text == 'contact') {
                            contact = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'SignatoriesContact consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class Tan_Z {
        public List<Delays> delays {get;set;} 
        public List<Defaults> defaults {get;set;} 
        
        public Tan_Z(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'delays') {
                            delays = arrayOfDelays(parser);
                        } else if (text == 'defaults') {
                            defaults = arrayOfDefaults(parser);
                        } else {
                            System.debug(LoggingLevel.WARN, 'Tan_Z consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class DetailsAsPerSource {
        public String source {get;set;} 
        public List<Details> details {get;set;} 
        
        public DetailsAsPerSource(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'source') {
                            source = parser.getText();
                        } else if (text == 'details') {
                            details = arrayOfDetails(parser);
                        } else {
                            System.debug(LoggingLevel.WARN, 'DetailsAsPerSource consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class ManagementAlerts {
        public String din {get;set;} 
        public String kid {get;set;} 
        public List<Alerts> alerts {get;set;} 
        
        public ManagementAlerts(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'din') {
                            din = parser.getText();
                        } else if (text == 'kid') {
                            kid = parser.getText();
                        } else if (text == 'alerts') {
                            alerts = arrayOfAlerts(parser);
                        } else {
                            System.debug(LoggingLevel.WARN, 'ManagementAlerts consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class Directors {
        public String din {get;set;} 
        public String pan {get;set;} 
        public String name {get;set;} 
        public String designation {get;set;} 
        public String dateOfAppointment {get;set;} 
        public String tenureBeginDate {get;set;} 
        public String tenureEndDate {get;set;} 
        
        public Directors(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'din') {
                            din = parser.getText();
                        } else if (text == 'pan') {
                            pan = parser.getText();
                        } else if (text == 'name') {
                            name = parser.getText();
                        } else if (text == 'designation') {
                            designation = parser.getText();
                        } else if (text == 'dateOfAppointment') {
                            dateOfAppointment = parser.getText();
                        } else if (text == 'tenureBeginDate') {
                            tenureBeginDate = parser.getText();
                        } else if (text == 'tenureEndDate') {
                            tenureEndDate = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'Directors consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class ExchangeInformation {
        public List<BseSecurity> bseSecurity {get;set;} 
        public List<NseSecurity> nseSecurity {get;set;} 
        
        public ExchangeInformation(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'bseSecurity') {
                            bseSecurity = arrayOfBseSecurity(parser);
                        } else if (text == 'nseSecurity') {
                            nseSecurity = arrayOfNseSecurity(parser);
                        } else {
                            System.debug(LoggingLevel.WARN, 'ExchangeInformation consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class CreditRatings {
        public String absoluteAmount {get;set;} 
        public String action {get;set;} 
        public String address {get;set;} 
        public String amount {get;set;} 
        public String category {get;set;} 
        public String currencyType {get;set;} 
        public String dateOfIssuance {get;set;} 
        public String entityLocation {get;set;} 
        public String entityType {get;set;} 
        public String industry {get;set;} 
        public String instrument {get;set;} 
        public String instrumentType {get;set;} 
        public String internalRelativeUri {get;set;} 
        public String internalUri {get;set;} 
        public String isCreditRatingDowngraded {get;set;} 
        public String isCreditRatingOutlookNegative {get;set;} 
        public String isCreditRatingOutlookPositive {get;set;} 
        public String isCreditRatingOutlookStable {get;set;} 
        public String isCreditRatingReaffirmed {get;set;} 
        public String isCreditRatingSuspended {get;set;} 
        public String isCreditRatingUpgraded {get;set;} 
        public String isCreditRatingWithdrawn {get;set;} 
        public String isCreditWatchWithDevelopingImplication {get;set;} 
        public String isCreditWatchWithNegativeImplication {get;set;} 
        public String isCreditWatchWithPositiveImplication {get;set;} 
        public String isRatedEntityNonCooperative {get;set;} 
        public String kid {get;set;} 
        public String lastUpdated {get;set;} 
        public String name {get;set;} 
        public String outlook {get;set;} 
        public String product {get;set;} 
        public String promoter {get;set;} 
        public String rating {get;set;} 
        public String ratingAgency {get;set;} 
        public String ratingDescription {get;set;} 
        public String ratingRationale {get;set;} 
        public String ratingTerm {get;set;} 
        public String registrationNumber {get;set;} 
        public String segmentType {get;set;} 
        public String sourceId {get;set;} 
        public String sourceUri {get;set;} 
        public String subsegmentType {get;set;} 
        public String timestamp {get;set;} 
        
        public CreditRatings(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'absoluteAmount_') {
                            absoluteAmount = parser.getText();
                        } else if (text == 'action') {
                            action = parser.getText();
                        } else if (text == 'address') {
                            address = parser.getText();
                        } else if (text == 'amount') {
                            amount = parser.getText();
                        } else if (text == 'category') {
                            category = parser.getText();
                        } else if (text == 'currencyType') {
                            currencyType = parser.getText();
                        } else if (text == 'dateOfIssuance') {
                            dateOfIssuance = parser.getText();
                        } else if (text == 'entityLocation') {
                            entityLocation = parser.getText();
                        } else if (text == 'entityType') {
                            entityType = parser.getText();
                        } else if (text == 'industry') {
                            industry = parser.getText();
                        } else if (text == 'instrument') {
                            instrument = parser.getText();
                        } else if (text == 'instrumentType_') {
                            instrumentType = parser.getText();
                        } else if (text == 'internalRelativeUri') {
                            internalRelativeUri = parser.getText();
                        } else if (text == 'internalUri') {
                            internalUri = parser.getText();
                        } else if (text == 'isCreditRatingDowngraded') {
                            isCreditRatingDowngraded = parser.getText();
                        } else if (text == 'isCreditRatingOutlookNegative') {
                            isCreditRatingOutlookNegative = parser.getText();
                        } else if (text == 'isCreditRatingOutlookPositive') {
                            isCreditRatingOutlookPositive = parser.getText();
                        } else if (text == 'isCreditRatingOutlookStable') {
                            isCreditRatingOutlookStable = parser.getText();
                        } else if (text == 'isCreditRatingReaffirmed') {
                            isCreditRatingReaffirmed = parser.getText();
                        } else if (text == 'isCreditRatingSuspended') {
                            isCreditRatingSuspended = parser.getText();
                        } else if (text == 'isCreditRatingUpgraded') {
                            isCreditRatingUpgraded = parser.getText();
                        } else if (text == 'isCreditRatingWithdrawn') {
                            isCreditRatingWithdrawn = parser.getText();
                        } else if (text == 'isCreditWatchWithDevelopingImplication') {
                            isCreditWatchWithDevelopingImplication = parser.getText();
                        } else if (text == 'isCreditWatchWithNegativeImplication') {
                            isCreditWatchWithNegativeImplication = parser.getText();
                        } else if (text == 'isCreditWatchWithPositiveImplication') {
                            isCreditWatchWithPositiveImplication = parser.getText();
                        } else if (text == 'isRatedEntityNonCooperative') {
                            isRatedEntityNonCooperative = parser.getText();
                        } else if (text == 'kid') {
                            kid = parser.getText();
                        } else if (text == 'lastUpdated') {
                            lastUpdated = parser.getText();
                        } else if (text == 'name') {
                            name = parser.getText();
                        } else if (text == 'outlook') {
                            outlook = parser.getText();
                        } else if (text == 'product') {
                            product = parser.getText();
                        } else if (text == 'promoter') {
                            promoter = parser.getText();
                        } else if (text == 'rating') {
                            rating = parser.getText();
                        } else if (text == 'rating_') {
                            rating = parser.getText();
                        } else if (text == 'ratingAgency') {
                            ratingAgency = parser.getText();
                        } else if (text == 'ratingDescription') {
                            ratingDescription = parser.getText();
                        } else if (text == 'ratingRationale') {
                            ratingRationale = parser.getText();
                        } else if (text == 'ratingTerm') {
                            ratingTerm = parser.getText();
                        } else if (text == 'registrationNumber') {
                            registrationNumber = parser.getText();
                        } else if (text == 'segmentType') {
                            segmentType = parser.getText();
                        } else if (text == 'sourceId_') {
                            sourceId = parser.getText();
                        } else if (text == 'sourceUri') {
                            sourceUri = parser.getText();
                        } else if (text == 'subsegmentType') {
                            subsegmentType = parser.getText();
                        } else if (text == 'timestamp') {
                            timestamp = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'CreditRatings consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class Charges {
        public String chargeId {get;set;} 
        public String srn {get;set;} 
        public String status {get;set;} 
        public String chargeHolderName {get;set;} 
        public String chargeHolderNameStandardized {get;set;} 
        public String chargeHolderType {get;set;} 
        public String amount {get;set;} 
        public String address {get;set;} 
        public String assetsUnderCharge {get;set;} 
        public String dateOfCreation {get;set;} 
        public String dateOfModification {get;set;} 
        public String dateOfSatisfaction {get;set;} 
        public String chargeHolderTag {get;set;} 
        
        public Charges(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'chargeId') {
                            chargeId = parser.getText();
                        } else if (text == 'srn') {
                            srn = parser.getText();
                        } else if (text == 'status') {
                            status = parser.getText();
                        } else if (text == 'chargeHolderName') {
                            chargeHolderName = parser.getText();
                        } else if (text == 'chargeHolderNameStandardized_') {
                            chargeHolderNameStandardized = parser.getText();
                        } else if (text == 'chargeHolderType_') {
                            chargeHolderType = parser.getText();
                        } else if (text == 'amount') {
                            amount = parser.getText();
                        } else if (text == 'address') {
                            address = parser.getText();
                        } else if (text == 'assetsUnderCharge') {
                            assetsUnderCharge = parser.getText();
                        } else if (text == 'dateOfCreation') {
                            dateOfCreation = parser.getText();
                        } else if (text == 'dateOfModification') {
                            dateOfModification = parser.getText();
                        } else if (text == 'dateOfSatisfaction') {
                            dateOfSatisfaction = parser.getText();
                        } else if (text == 'chargeHolderTag_') {
                            chargeHolderTag = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'Charges consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class AlertSummary {
        public Severity severity {get;set;} 
        public Details_Z details {get;set;} 
        
        public AlertSummary(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'severity') {
                            severity = new Severity(parser);
                        } else if (text == 'details') {
                            details = new Details_Z(parser);
                        } else {
                            System.debug(LoggingLevel.WARN, 'AlertSummary consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class Kycs {
        public String types {get;set;} 
        public String value {get;set;} 
        public String isKycCorrespondsToEntity {get;set;} 
        
        public Kycs(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'type') {
                            types = parser.getText();
                        } else if (text == 'value') {
                            value = parser.getText();
                        } else if (text == 'isKycCorrespondsToEntity_') {
                            isKycCorrespondsToEntity = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'Kycs consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class Gst_Z {
        public List<Delays_Y> delays {get;set;} 
        public List<Defaults_Y> defaults {get;set;} 
        
        public Gst_Z(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'delays') {
                            delays = arrayOfDelays_Y(parser);
                        } else if (text == 'defaults') {
                            defaults = arrayOfDefaults_Y(parser);
                        } else {
                            System.debug(LoggingLevel.WARN, 'Gst_Z consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class Defaulter {
        public String entityId {get;set;} 
        public List<String> mcaCompanyDefaulterDefaults {get;set;} 
        public String mcaCompanyDefaulterLastUpdated {get;set;} 
        public String mcaCompanyDefaulterSource {get;set;} 
        public List<String> mcaCompanyDefaulterYears {get;set;} 
        
        public Defaulter(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'entityId') {
                            entityId = parser.getText();
                        } else if (text == 'mcaCompanyDefaulterDefaults') {
                            mcaCompanyDefaulterDefaults = arrayOfString(parser);
                        } else if (text == 'mcaCompanyDefaulterLastUpdated') {
                            mcaCompanyDefaulterLastUpdated = parser.getText();
                        } else if (text == 'mcaCompanyDefaulterSource') {
                            mcaCompanyDefaulterSource = parser.getText();
                        } else if (text == 'mcaCompanyDefaulterYears') {
                            mcaCompanyDefaulterYears = arrayOfString(parser);
                        } else {
                            System.debug(LoggingLevel.WARN, 'Defaulter consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class RegisteredOffices {
        public String address {get;set;} 
        public String city {get;set;} 
        public String state {get;set;} 
        public String pincode {get;set;} 
        public String fullAddress {get;set;} 
        
        public RegisteredOffices(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'address') {
                            address = parser.getText();
                        } else if (text == 'city') {
                            city = parser.getText();
                        } else if (text == 'state') {
                            state = parser.getText();
                        } else if (text == 'pincode') {
                            pincode = parser.getText();
                        } else if (text == 'fullAddress_') {
                            fullAddress = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'RegisteredOffices consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class Gst {
        public String addr {get;set;} 
        public String address {get;set;} 
        public List<Branches> branches {get;set;} 
        public String complianceRating {get;set;} 
        public String constitutionOfBusiness {get;set;} 
        public String contact {get;set;} 
        public String contacted {get;set;} 
        public String dateOfRegistration {get;set;} 
        public String dateOfRegistrationCancellation {get;set;} 
        public String dateOfVatRegistration {get;set;} 
        public String dealerType {get;set;} 
        public String email {get;set;} 
        public String emailDomain {get;set;} 
        public String gstin {get;set;} 
        public String isFieldVisitConducted {get;set;} 
        public String isMoreAdditionalPlaces {get;set;} 
        public String kid {get;set;} 
        public String lastUpdatedDate {get;set;} 
        public String legalName {get;set;} 
        public List<String> natureOfBusiness {get;set;} 
        public String natureOfTrade {get;set;} 
        public String pan {get;set;} 
        public List<String> signatories {get;set;} 
        public List<SignatoriesContact> signatoriesContact {get;set;} 
        public String sourceUri {get;set;} 
        public String state {get;set;} 
        public String status {get;set;} 
        public String timestamp {get;set;} 
        public String tin {get;set;} 
        public String tradeName {get;set;} 
        
        public Gst(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'addr') {
                            addr = parser.getText();
                        } else if (text == 'address') {
                            address = parser.getText();
                        } else if (text == 'branches') {
                            branches = arrayOfBranches(parser);
                        } else if (text == 'complianceRating') {
                            complianceRating = parser.getText();
                        } else if (text == 'constitutionOfBusiness') {
                            constitutionOfBusiness = parser.getText();
                        } else if (text == 'contact') {
                            contact = parser.getText();
                        } else if (text == 'contacted') {
                            contacted = parser.getText();
                        } else if (text == 'dateOfRegistration') {
                            dateOfRegistration = parser.getText();
                        } else if (text == 'dateOfRegistrationCancellation') {
                            dateOfRegistrationCancellation = parser.getText();
                        } else if (text == 'dateOfVatRegistration') {
                            dateOfVatRegistration = parser.getText();
                        } else if (text == 'dealerType') {
                            dealerType = parser.getText();
                        } else if (text == 'email') {
                            email = parser.getText();
                        } else if (text == 'emailDomain') {
                            emailDomain = parser.getText();
                        } else if (text == 'gstin') {
                            gstin = parser.getText();
                        } else if (text == 'isFieldVisitConducted') {
                            isFieldVisitConducted = parser.getText();
                        } else if (text == 'isMoreAdditionalPlaces') {
                            isMoreAdditionalPlaces = parser.getText();
                        } else if (text == 'kid') {
                            kid = parser.getText();
                        } else if (text == 'lastUpdatedDate') {
                            lastUpdatedDate = parser.getText();
                        } else if (text == 'legalName') {
                            legalName = parser.getText();
                        } else if (text == 'natureOfBusiness') {
                            natureOfBusiness = arrayOfString(parser);
                        } else if (text == 'natureOfTrade') {
                            natureOfTrade = parser.getText();
                        } else if (text == 'pan') {
                            pan = parser.getText();
                        } else if (text == 'signatories') {
                            signatories = arrayOfString(parser);
                        } else if (text == 'signatoriesContact') {
                            signatoriesContact = arrayOfSignatoriesContact(parser);
                        } else if (text == 'sourceUri') {
                            sourceUri = parser.getText();
                        } else if (text == 'state') {
                            state = parser.getText();
                        } else if (text == 'status') {
                            status = parser.getText();
                        } else if (text == 'timestamp') {
                            timestamp = parser.getText();
                        } else if (text == 'tin') {
                            tin = parser.getText();
                        } else if (text == 'tradeName') {
                            tradeName = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'Gst consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class Mca {
        public String activeCompliance {get;set;} 
        public String activityClass {get;set;} 
        public String activityGroup {get;set;} 
        public String activitySubClass {get;set;} 
        public String alternateAddress {get;set;} 
        public String authorisedCapital {get;set;} 
        public String category {get;set;} 
        public String class_Z {get;set;} // in json: class
        public String countryOfIncorporation {get;set;} 
        public String dateOfAnnualReturnFiled {get;set;} 
        public String dateOfBalanceSheet {get;set;} 
        public String dateOfIncorporation {get;set;} 
        public String dateOfLastAgm {get;set;} 
        public String dateOfStatementOfAccountsAndSolvencyFiled {get;set;} 
        public String descriptionOfMainDivision {get;set;} 
        public List<Directors> directors {get;set;} 
        public String email {get;set;} 
        public String emailDomain {get;set;} 
        public String entityId {get;set;} 
        public String foreignCompanyWithShareCapital {get;set;} 
        public List<FormerBusinesses> formerBusinesses {get;set;} 
        public List<Directors> formerDirectors {get;set;} 
        public List<FormerEntityIds> formerEntityIds {get;set;} 
        public List<FormerNames> formerNames {get;set;} 
        public String industry {get;set;} 
        public String kid {get;set;} 
        public String listingStatus {get;set;} 
        public String mainDivisonOfBusinessActivity {get;set;} 
        public String name {get;set;} 
        public String numberOfAuthorisedRepresentatives {get;set;} 
        public String numberOfDesignatedPartners {get;set;} 
        public String numberOfMembers {get;set;} 
        public String numberOfPartners {get;set;} 
        public String officeDetails {get;set;} 
        public String paidUpCapital {get;set;} 
        public List<String> pans {get;set;} 
        public String registeredAddress {get;set;} 
        public String registrationNumber {get;set;} 
        public String rocCode {get;set;} 
        public String sourceUri {get;set;} 
        public String status {get;set;} 
        public String subIndustry {get;set;} 
        public String subcategory {get;set;} 
        public String timestamp {get;set;} 
        public String totalObligationOfContribution {get;set;} 
        public String types {get;set;} 
        public String typeOfOffice {get;set;} 
        
        public Mca(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'activeCompliance') {
                            activeCompliance = parser.getText();
                        } else if (text == 'activityClass_') {
                            activityClass = parser.getText();
                        } else if (text == 'activityGroup_') {
                            activityGroup = parser.getText();
                        } else if (text == 'activitySubClass_') {
                            activitySubClass = parser.getText();
                        } else if (text == 'alternateAddress') {
                            alternateAddress = parser.getText();
                        } else if (text == 'authorisedCapital') {
                            authorisedCapital = parser.getText();
                        } else if (text == 'category') {
                            category = parser.getText();
                        } else if (text == 'class') {
                            class_Z = parser.getText();
                        } else if (text == 'countryOfIncorporation') {
                            countryOfIncorporation = parser.getText();
                        } else if (text == 'dateOfAnnualReturnFiled') {
                            dateOfAnnualReturnFiled = parser.getText();
                        } else if (text == 'dateOfBalanceSheet') {
                            dateOfBalanceSheet = parser.getText();
                        } else if (text == 'dateOfIncorporation') {
                            dateOfIncorporation = parser.getText();
                        } else if (text == 'dateOfLastAgm') {
                            dateOfLastAgm = parser.getText();
                        } else if (text == 'dateOfStatementOfAccountsAndSolvencyFiled') {
                            dateOfStatementOfAccountsAndSolvencyFiled = parser.getText();
                        } else if (text == 'descriptionOfMainDivision') {
                            descriptionOfMainDivision = parser.getText();
                        } else if (text == 'directors') {
                            directors = arrayOfDirectors(parser);
                        } else if (text == 'email') {
                            email = parser.getText();
                        } else if (text == 'emailDomain') {
                            emailDomain = parser.getText();
                        } else if (text == 'entityId') {
                            entityId = parser.getText();
                        } else if (text == 'foreignCompanyWithShareCapital') {
                            foreignCompanyWithShareCapital = parser.getText();
                        } else if (text == 'formerBusinesses_') {
                            formerBusinesses = arrayOfFormerBusinesses(parser);
                        } else if (text == 'formerDirectors') {
                            formerDirectors = arrayOfDirectors(parser);
                        } else if (text == 'formerEntityIds') {
                            formerEntityIds = arrayOfFormerEntityIds(parser);
                        } else if (text == 'formerNames') {
                            formerNames = arrayOfFormerNames(parser);
                        } else if (text == 'industry_') {
                            industry = parser.getText();
                        } else if (text == 'kid') {
                            kid = parser.getText();
                        } else if (text == 'listingStatus') {
                            listingStatus = parser.getText();
                        } else if (text == 'mainDivisonOfBusinessActivity') {
                            mainDivisonOfBusinessActivity = parser.getText();
                        } else if (text == 'name') {
                            name = parser.getText();
                        } else if (text == 'numberOfAuthorisedRepresentatives') {
                            numberOfAuthorisedRepresentatives = parser.getText();
                        } else if (text == 'numberOfDesignatedPartners') {
                            numberOfDesignatedPartners = parser.getText();
                        } else if (text == 'numberOfMembers') {
                            numberOfMembers = parser.getText();
                        } else if (text == 'numberOfPartners') {
                            numberOfPartners = parser.getText();
                        } else if (text == 'officeDetails') {
                            officeDetails = parser.getText();
                        } else if (text == 'paidUpCapital') {
                            paidUpCapital = parser.getText();
                        } else if (text == 'pans') {
                            pans = arrayOfString(parser);
                        } else if (text == 'registeredAddress') {
                            registeredAddress = parser.getText();
                        } else if (text == 'registrationNumber') {
                            registrationNumber = parser.getText();
                        } else if (text == 'rocCode') {
                            rocCode = parser.getText();
                        } else if (text == 'sourceUri') {
                            sourceUri = parser.getText();
                        } else if (text == 'status') {
                            status = parser.getText();
                        } else if (text == 'subIndustry_') {
                            subIndustry = parser.getText();
                        } else if (text == 'subcategory') {
                            subcategory = parser.getText();
                        } else if (text == 'timestamp') {
                            timestamp = parser.getText();
                        } else if (text == 'totalObligationOfContribution') {
                            totalObligationOfContribution = parser.getText();
                        } else if (text == 'type_') {
                            types = parser.getText();
                        } else if (text == 'typeOfOffice') {
                            typeOfOffice = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'Mca consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class Severity {
        public String high {get;set;} 
        public String medium {get;set;} 
        public String low {get;set;} 
        
        public Severity(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'high') {
                            high = parser.getText();
                        } else if (text == 'medium') {
                            medium = parser.getText();
                        } else if (text == 'low') {
                            low = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'Severity consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    
    public class Management {
        public String source {get;set;} 
        public List<Current> current {get;set;} 
        public List<Current> former {get;set;} 
        
        public Management(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'source') {
                            source = parser.getText();
                        } else if (text == 'current') {
                            current = arrayOfCurrent(parser);
                        } else if (text == 'former') {
                            former = arrayOfCurrent(parser);
                        } else {
                            System.debug(LoggingLevel.WARN, 'Management consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    
    
    public class Mca_Z {
        public List<Defaulter> defaulter {get;set;} 
        
        public Mca_Z(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'defaulter') {
                            defaulter = arrayOfDefaulter(parser);
                        } else {
                            System.debug(LoggingLevel.WARN, 'Mca_Z consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    public class Lin {
        public String addressLine1 {get;set;} 
        public String addressLine2 {get;set;} 
        public String contact {get;set;} 
        public String country {get;set;} 
        public String district {get;set;} 
        public String fullAddress {get;set;} 
        public String jurisdiction {get;set;} 
        public String kid {get;set;} 
        public List<Kycs> kycs {get;set;} 
        public String lin {get;set;} 
        public String name {get;set;} 
        public List<String> pans {get;set;} 
        public String pincode {get;set;} 
        public String registrationStatus {get;set;} 
        public String sourceUri {get;set;} 
        public String state {get;set;} 
        public String timestamp {get;set;} 
        
        public Lin(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'addressLine1') {
                            addressLine1 = parser.getText();
                        } else if (text == 'addressLine2') {
                            addressLine2 = parser.getText();
                        } else if (text == 'contact') {
                            contact = parser.getText();
                        } else if (text == 'country') {
                            country = parser.getText();
                        } else if (text == 'district') {
                            district = parser.getText();
                        } else if (text == 'fullAddress_') {
                            fullAddress = parser.getText();
                        } else if (text == 'jurisdiction') {
                            jurisdiction = parser.getText();
                        } else if (text == 'kid') {
                            kid = parser.getText();
                        } else if (text == 'kycs') {
                            kycs = arrayOfKycs(parser);
                        } else if (text == 'lin') {
                            lin = parser.getText();
                        } else if (text == 'name') {
                            name = parser.getText();
                        } else if (text == 'pans') {
                            pans = arrayOfString(parser);
                        } else if (text == 'pincode') {
                            pincode = parser.getText();
                        } else if (text == 'registrationStatus') {
                            registrationStatus = parser.getText();
                        } else if (text == 'sourceUri') {
                            sourceUri = parser.getText();
                        } else if (text == 'state') {
                            state = parser.getText();
                        } else if (text == 'timestamp') {
                            timestamp = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'Lin consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class Lei {
        public String country {get;set;} 
        public String dparentAccountingPeriodEndDate {get;set;} 
        public String dparentAccountingPeriodStartDate {get;set;} 
        public String dparentAccountingStandard {get;set;} 
        public String dparentDocumentFilingEndDate {get;set;} 
        public String dparentDocumentFilingStartDate {get;set;} 
        public String dparentExceptionDetail {get;set;} 
        public String dparentInitialRegistrationDate {get;set;} 
        public String dparentLastUpdateDate {get;set;} 
        public String dparentLei {get;set;} 
        public String dparentManagingLou {get;set;} 
        public String dparentName {get;set;} 
        public String dparentNextRenewalDate {get;set;} 
        public String dparentPeriodType {get;set;} 
        public String dparentRegistrationStatus {get;set;} 
        public String dparentRelationshipEndDate {get;set;} 
        public String dparentRelationshipQualifiersCategory {get;set;} 
        public String dparentRelationshipQuantifiers {get;set;} 
        public String dparentRelationshipStartDate {get;set;} 
        public String dparentRelationshipStatus {get;set;} 
        public String dparentRelationshipType {get;set;} 
        public String dparentShareholding {get;set;} 
        public String dparentValidationReference {get;set;} 
        public String dparentValidationSources {get;set;} 
        public String entityExpirationDate {get;set;} 
        public String entityExpirationReason {get;set;} 
        public String entityStatus {get;set;} 
        public String exceptionSourceUri {get;set;} 
        public String fullHeadquartersAddress {get;set;} 
        public String fullRegisteredAddress {get;set;} 
        public HeadquartersAddress headquartersAddress {get;set;} 
        public String isAddressQualityPoor {get;set;} 
        public String isLeiRegistrationDuplicate {get;set;} 
        public String isLeiRegistrationLapsed {get;set;} 
        public String isLeiRegistrationRetired {get;set;} 
        public String jurisdiction {get;set;} 
        public String kid {get;set;} 
        public String legalForm {get;set;} 
        public String lei {get;set;} 
        public String louId {get;set;} 
        public String name {get;set;} 
        public String nextRenewalDate {get;set;} 
        public String parentRelationSourceUri {get;set;} 
        public HeadquartersAddress registeredAddress {get;set;} 
        public String registrationAuthorityId {get;set;} 
        public String registrationAuthorityName {get;set;} 
        public String registrationDate {get;set;} 
        public String registrationLastUpdateDate {get;set;} 
        public String registrationStatus {get;set;} 
        public String sourceUri {get;set;} 
        public String successorLei {get;set;} 
        public String timestamp {get;set;} 
        public String uparentAccountingPeriodEndDate {get;set;} 
        public String uparentAccountingPeriodStartDate {get;set;} 
        public String uparentAccountingStandard {get;set;} 
        public String uparentDocumentFilingEndDate {get;set;} 
        public String uparentDocumentFilingStartDate {get;set;} 
        public String uparentExceptionDetail {get;set;} 
        public String uparentInitialRegistrationDate {get;set;} 
        public String uparentLastUpdateDate {get;set;} 
        public String uparentLei {get;set;} 
        public String uparentManagingLou {get;set;} 
        public String uparentName {get;set;} 
        public String uparentNextRenewalDate {get;set;} 
        public String uparentPeriodType {get;set;} 
        public String uparentRegistrationStatus {get;set;} 
        public String uparentRelationshipEndDate {get;set;} 
        public String uparentRelationshipQualifiersCategory {get;set;} 
        public String uparentRelationshipQuantifiers {get;set;} 
        public String uparentRelationshipStartDate {get;set;} 
        public String uparentRelationshipStatus {get;set;} 
        public String uparentRelationshipType {get;set;} 
        public String uparentShareholding {get;set;} 
        public String uparentValidationReference {get;set;} 
        public String uparentValidationSources {get;set;} 
        public String validationSource {get;set;} 
        
        public Lei(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'country') {
                            country = parser.getText();
                        } else if (text == 'dparentAccountingPeriodEndDate') {
                            dparentAccountingPeriodEndDate = parser.getText();
                        } else if (text == 'dparentAccountingPeriodStartDate') {
                            dparentAccountingPeriodStartDate = parser.getText();
                        } else if (text == 'dparentAccountingStandard') {
                            dparentAccountingStandard = parser.getText();
                        } else if (text == 'dparentDocumentFilingEndDate') {
                            dparentDocumentFilingEndDate = parser.getText();
                        } else if (text == 'dparentDocumentFilingStartDate') {
                            dparentDocumentFilingStartDate = parser.getText();
                        } else if (text == 'dparentExceptionDetail') {
                            dparentExceptionDetail = parser.getText();
                        } else if (text == 'dparentInitialRegistrationDate') {
                            dparentInitialRegistrationDate = parser.getText();
                        } else if (text == 'dparentLastUpdateDate') {
                            dparentLastUpdateDate = parser.getText();
                        } else if (text == 'dparentLei') {
                            dparentLei = parser.getText();
                        } else if (text == 'dparentManagingLou') {
                            dparentManagingLou = parser.getText();
                        } else if (text == 'dparentName') {
                            dparentName = parser.getText();
                        } else if (text == 'dparentNextRenewalDate') {
                            dparentNextRenewalDate = parser.getText();
                        } else if (text == 'dparentPeriodType') {
                            dparentPeriodType = parser.getText();
                        } else if (text == 'dparentRegistrationStatus') {
                            dparentRegistrationStatus = parser.getText();
                        } else if (text == 'dparentRelationshipEndDate') {
                            dparentRelationshipEndDate = parser.getText();
                        } else if (text == 'dparentRelationshipQualifiersCategory') {
                            dparentRelationshipQualifiersCategory = parser.getText();
                        } else if (text == 'dparentRelationshipQuantifiers') {
                            dparentRelationshipQuantifiers = parser.getText();
                        } else if (text == 'dparentRelationshipStartDate') {
                            dparentRelationshipStartDate = parser.getText();
                        } else if (text == 'dparentRelationshipStatus') {
                            dparentRelationshipStatus = parser.getText();
                        } else if (text == 'dparentRelationshipType') {
                            dparentRelationshipType = parser.getText();
                        } else if (text == 'dparentShareholding') {
                            dparentShareholding = parser.getText();
                        } else if (text == 'dparentValidationReference') {
                            dparentValidationReference = parser.getText();
                        } else if (text == 'dparentValidationSources') {
                            dparentValidationSources = parser.getText();
                        } else if (text == 'entityExpirationDate') {
                            entityExpirationDate = parser.getText();
                        } else if (text == 'entityExpirationReason') {
                            entityExpirationReason = parser.getText();
                        } else if (text == 'entityStatus') {
                            entityStatus = parser.getText();
                        } else if (text == 'exceptionSourceUri') {
                            exceptionSourceUri = parser.getText();
                        } else if (text == 'fullHeadquartersAddress_') {
                            fullHeadquartersAddress = parser.getText();
                        } else if (text == 'fullRegisteredAddress_') {
                            fullRegisteredAddress = parser.getText();
                        } else if (text == 'headquartersAddress') {
                            headquartersAddress = new HeadquartersAddress(parser);
                        } else if (text == 'isAddressQualityPoor_') {
                            isAddressQualityPoor = parser.getText();
                        } else if (text == 'isLeiRegistrationDuplicate') {
                            isLeiRegistrationDuplicate = parser.getText();
                        } else if (text == 'isLeiRegistrationLapsed') {
                            isLeiRegistrationLapsed = parser.getText();
                        } else if (text == 'isLeiRegistrationRetired') {
                            isLeiRegistrationRetired = parser.getText();
                        } else if (text == 'jurisdiction') {
                            jurisdiction = parser.getText();
                        } else if (text == 'kid') {
                            kid = parser.getText();
                        } else if (text == 'legalForm') {
                            legalForm = parser.getText();
                        } else if (text == 'lei') {
                            lei = parser.getText();
                        } else if (text == 'louId') {
                            louId = parser.getText();
                        } else if (text == 'name') {
                            name = parser.getText();
                        } else if (text == 'nextRenewalDate') {
                            nextRenewalDate = parser.getText();
                        } else if (text == 'parentRelationSourceUri') {
                            parentRelationSourceUri = parser.getText();
                        } else if (text == 'registeredAddress') {
                            registeredAddress = new HeadquartersAddress(parser);
                        } else if (text == 'registrationAuthorityId') {
                            registrationAuthorityId = parser.getText();
                        } else if (text == 'registrationAuthorityName') {
                            registrationAuthorityName = parser.getText();
                        } else if (text == 'registrationDate') {
                            registrationDate = parser.getText();
                        } else if (text == 'registrationLastUpdateDate') {
                            registrationLastUpdateDate = parser.getText();
                        } else if (text == 'registrationStatus') {
                            registrationStatus = parser.getText();
                        } else if (text == 'sourceUri') {
                            sourceUri = parser.getText();
                        } else if (text == 'successorLei') {
                            successorLei = parser.getText();
                        } else if (text == 'timestamp') {
                            timestamp = parser.getText();
                        } else if (text == 'uparentAccountingPeriodEndDate') {
                            uparentAccountingPeriodEndDate = parser.getText();
                        } else if (text == 'uparentAccountingPeriodStartDate') {
                            uparentAccountingPeriodStartDate = parser.getText();
                        } else if (text == 'uparentAccountingStandard') {
                            uparentAccountingStandard = parser.getText();
                        } else if (text == 'uparentDocumentFilingEndDate') {
                            uparentDocumentFilingEndDate = parser.getText();
                        } else if (text == 'uparentDocumentFilingStartDate') {
                            uparentDocumentFilingStartDate = parser.getText();
                        } else if (text == 'uparentExceptionDetail') {
                            uparentExceptionDetail = parser.getText();
                        } else if (text == 'uparentInitialRegistrationDate') {
                            uparentInitialRegistrationDate = parser.getText();
                        } else if (text == 'uparentLastUpdateDate') {
                            uparentLastUpdateDate = parser.getText();
                        } else if (text == 'uparentLei') {
                            uparentLei = parser.getText();
                        } else if (text == 'uparentManagingLou') {
                            uparentManagingLou = parser.getText();
                        } else if (text == 'uparentName') {
                            uparentName = parser.getText();
                        } else if (text == 'uparentNextRenewalDate') {
                            uparentNextRenewalDate = parser.getText();
                        } else if (text == 'uparentPeriodType') {
                            uparentPeriodType = parser.getText();
                        } else if (text == 'uparentRegistrationStatus') {
                            uparentRegistrationStatus = parser.getText();
                        } else if (text == 'uparentRelationshipEndDate') {
                            uparentRelationshipEndDate = parser.getText();
                        } else if (text == 'uparentRelationshipQualifiersCategory') {
                            uparentRelationshipQualifiersCategory = parser.getText();
                        } else if (text == 'uparentRelationshipQuantifiers') {
                            uparentRelationshipQuantifiers = parser.getText();
                        } else if (text == 'uparentRelationshipStartDate') {
                            uparentRelationshipStartDate = parser.getText();
                        } else if (text == 'uparentRelationshipStatus') {
                            uparentRelationshipStatus = parser.getText();
                        } else if (text == 'uparentRelationshipType') {
                            uparentRelationshipType = parser.getText();
                        } else if (text == 'uparentShareholding') {
                            uparentShareholding = parser.getText();
                        } else if (text == 'uparentValidationReference') {
                            uparentValidationReference = parser.getText();
                        } else if (text == 'uparentValidationSources') {
                            uparentValidationSources = parser.getText();
                        } else if (text == 'validationSource') {
                            validationSource = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'Lei consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class Alerts_Z {
        public List<AlertList> alertList {get;set;} 
        public AlertSummary alertSummary {get;set;} 
        
        public Alerts_Z(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'alertList') {
                            alertList = arrayOfAlertList(parser);
                        } else if (text == 'alertSummary') {
                            alertSummary = new AlertSummary(parser);
                        } else {
                            System.debug(LoggingLevel.WARN, 'Alerts_Z consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class FormerBusinesses {
        public String industry {get;set;} 
        public String subIndustry {get;set;} 
        public String activityGroup {get;set;} 
        public String activityClass {get;set;} 
        public String activitySubClass {get;set;} 
        
        public FormerBusinesses(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'industry') {
                            industry = parser.getText();
                        } else if (text == 'subIndustry') {
                            subIndustry = parser.getText();
                        } else if (text == 'activityGroup') {
                            activityGroup = parser.getText();
                        } else if (text == 'activityClass') {
                            activityClass = parser.getText();
                        } else if (text == 'activitySubClass') {
                            activitySubClass = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'FormerBusinesses_ consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class BranchesWithoutCode {
        public String establishmentId {get;set;} 
        public String primaryEstablishmentId {get;set;} 
        public String establishmentNumber {get;set;} 
        public String subEstablishmentNumber {get;set;} 
        public String epfoOfficeCode {get;set;} 
        public String stateCode {get;set;} 
        public String name {get;set;} 
        public String epfoOfficeName {get;set;} 
        public String address {get;set;} 
        
        public BranchesWithoutCode(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'establishmentId') {
                            establishmentId = parser.getText();
                        } else if (text == 'primaryEstablishmentId_') {
                            primaryEstablishmentId = parser.getText();
                        } else if (text == 'establishmentNumber_') {
                            establishmentNumber = parser.getText();
                        } else if (text == 'subEstablishmentNumber_') {
                            subEstablishmentNumber = parser.getText();
                        } else if (text == 'epfoOfficeCode_') {
                            epfoOfficeCode = parser.getText();
                        } else if (text == 'stateCode_') {
                            stateCode = parser.getText();
                        } else if (text == 'name') {
                            name = parser.getText();
                        } else if (text == 'epfoOfficeName') {
                            epfoOfficeName = parser.getText();
                        } else if (text == 'address') {
                            address = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'BranchesWithoutCode consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class HeadquartersAddress {
        public String addressLine1 {get;set;} 
        public String addressLine2 {get;set;} 
        public String addressLine3 {get;set;} 
        public String addressLine4 {get;set;} 
        public String region {get;set;} 
        public String city {get;set;} 
        public String country {get;set;} 
        public String pincode {get;set;} 
        
        public HeadquartersAddress(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'addressLine1') {
                            addressLine1 = parser.getText();
                        } else if (text == 'addressLine2') {
                            addressLine2 = parser.getText();
                        } else if (text == 'addressLine3') {
                            addressLine3 = parser.getText();
                        } else if (text == 'addressLine4') {
                            addressLine4 = parser.getText();
                        } else if (text == 'region') {
                            region = parser.getText();
                        } else if (text == 'city') {
                            city = parser.getText();
                        } else if (text == 'country') {
                            country = parser.getText();
                        } else if (text == 'pincode') {
                            pincode = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'HeadquartersAddress consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class EmployeeCounts {
        public String wageYearMonth {get;set;} 
        public Integer employeeCount {get;set;} 
    }
    
    public class Epf {
        public String actionableStatus {get;set;} 
        public String address {get;set;} 
        public String addressProof {get;set;} 
        public List<BranchesWithoutCode> branchesWithoutCode {get;set;} 
        public List<EmployeeCounts> employeeCounts {get;set;}
        public String city {get;set;} 
        public String contact {get;set;} 
        public String country {get;set;} 
        public String coverageSection {get;set;} 
        public String dateOfCoverage {get;set;} 
        public String dateOfIncorporation {get;set;} 
        public String district {get;set;} 
        public String ecrRegistrationStatus {get;set;} 
        public String email {get;set;} 
        public String emailDomain {get;set;} 
        public String epfoRegion {get;set;} 
        public String epfoZone {get;set;} 
        public String esicCode {get;set;} 
        public String establishmentId {get;set;} 
        public List<EstablishmentMembers> establishmentMembers {get;set;} 
        public String establishmentNumber {get;set;} 
        public List<BranchesWithoutCode> establishmentsWithSamePan {get;set;} 
        public String exemptionStatus {get;set;} 
        public List<EstablishmentMembers> factoryDetails {get;set;} 
        public String fax {get;set;} 
        public String fullAddress {get;set;} 
        public String kid {get;set;} 
        public String laborIdentificationNumber {get;set;} 
        public String lastUpdatedOn {get;set;} 
        public String msmeOrderDate {get;set;} 
        public String msmeOrderNumber {get;set;} 
        public String name {get;set;} 
        public String nameAsPerPan {get;set;} 
        public List<BranchesWithoutCode> otherCodesWithSameEstablishment {get;set;} 
        public String ownershipType {get;set;} 
        public String panStatus {get;set;} 
        public String pincode {get;set;} 
        public String postCoverageStatus {get;set;} 
        public String primaryBusinessActivity {get;set;} 
        public String primaryEstablishmentId {get;set;} 
        public String sectionApplicable {get;set;} 
        public String sourceUri {get;set;} 
        public String startupOrderDate {get;set;} 
        public String startupOrderNumber {get;set;} 
        public String state {get;set;} 
        public String status {get;set;} 
        public List<BranchesWithoutCode> stockKeepingUnits {get;set;} 
        public String subEstablishmentNumber {get;set;} 
        public String timestamp {get;set;} 
        public List<BranchesWithoutCode> unitsUnderSameJurisdiction {get;set;} 
        public String website {get;set;} 
        public String websiteDomain {get;set;} 
        public String workingStatus {get;set;} 
        
        public Epf(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'actionableStatus') {
                            actionableStatus = parser.getText();
                        } else if (text == 'address') {
                            address = parser.getText();
                        } else if (text == 'addressProof') {
                            addressProof = parser.getText();
                        } else if (text == 'branchesWithoutCode') {
                            branchesWithoutCode = arrayOfBranchesWithoutCode(parser);
                        } else if (text == 'city') {
                            city = parser.getText();
                        } else if (text == 'contact') {
                            contact = parser.getText();
                        } else if (text == 'country') {
                            country = parser.getText();
                        } else if (text == 'coverageSection') {
                            coverageSection = parser.getText();
                        } else if (text == 'dateOfCoverage') {
                            dateOfCoverage = parser.getText();
                        } else if (text == 'dateOfIncorporation') {
                            dateOfIncorporation = parser.getText();
                        } else if (text == 'district') {
                            district = parser.getText();
                        } else if (text == 'ecrRegistrationStatus') {
                            ecrRegistrationStatus = parser.getText();
                        } else if (text == 'email') {
                            email = parser.getText();
                        } else if (text == 'emailDomain') {
                            emailDomain = parser.getText();
                        } else if (text == 'epfoRegion') {
                            epfoRegion = parser.getText();
                        } else if (text == 'epfoZone') {
                            epfoZone = parser.getText();
                        } else if (text == 'esicCode') {
                            esicCode = parser.getText();
                        } else if (text == 'establishmentId') {
                            establishmentId = parser.getText();
                        } else if (text == 'establishmentMembers') {
                            establishmentMembers = arrayOfEstablishmentMembers(parser);
                        } else if (text == 'establishmentNumber_') {
                            establishmentNumber = parser.getText();
                        } else if (text == 'establishmentsWithSamePan') {
                            establishmentsWithSamePan = arrayOfBranchesWithoutCode(parser);
                        } else if (text == 'exemptionStatus') {
                            exemptionStatus = parser.getText();
                        } else if (text == 'factoryDetails') {
                            factoryDetails = arrayOfEstablishmentMembers(parser);
                        } else if (text == 'fax') {
                            fax = parser.getText();
                        } else if (text == 'fullAddress_') {
                            fullAddress = parser.getText();
                        } else if (text == 'kid') {
                            kid = parser.getText();
                        } else if (text == 'laborIdentificationNumber') {
                            laborIdentificationNumber = parser.getText();
                        } else if (text == 'lastUpdatedOn') {
                            lastUpdatedOn = parser.getText();
                        } else if (text == 'msmeOrderDate') {
                            msmeOrderDate = parser.getText();
                        } else if (text == 'msmeOrderNumber') {
                            msmeOrderNumber = parser.getText();
                        } else if (text == 'name') {
                            name = parser.getText();
                        } else if (text == 'nameAsPerPan') {
                            nameAsPerPan = parser.getText();
                        } else if (text == 'otherCodesWithSameEstablishment') {
                            otherCodesWithSameEstablishment = arrayOfBranchesWithoutCode(parser);
                        } else if (text == 'ownershipType') {
                            ownershipType = parser.getText();
                        } else if (text == 'panStatus') {
                            panStatus = parser.getText();
                        } else if (text == 'pincode') {
                            pincode = parser.getText();
                        } else if (text == 'postCoverageStatus') {
                            postCoverageStatus = parser.getText();
                        } else if (text == 'primaryBusinessActivity') {
                            primaryBusinessActivity = parser.getText();
                        } else if (text == 'primaryEstablishmentId_') {
                            primaryEstablishmentId = parser.getText();
                        } else if (text == 'sectionApplicable') {
                            sectionApplicable = parser.getText();
                        } else if (text == 'sourceUri') {
                            sourceUri = parser.getText();
                        } else if (text == 'startupOrderDate') {
                            startupOrderDate = parser.getText();
                        } else if (text == 'startupOrderNumber') {
                            startupOrderNumber = parser.getText();
                        } else if (text == 'state') {
                            state = parser.getText();
                        } else if (text == 'status') {
                            status = parser.getText();
                        } else if (text == 'stockKeepingUnits') {
                            stockKeepingUnits = arrayOfBranchesWithoutCode(parser);
                        } else if (text == 'subEstablishmentNumber_') {
                            subEstablishmentNumber = parser.getText();
                        } else if (text == 'timestamp') {
                            timestamp = parser.getText();
                        } else if (text == 'unitsUnderSameJurisdiction') {
                            unitsUnderSameJurisdiction = arrayOfBranchesWithoutCode(parser);
                        } else if (text == 'website') {
                            website = parser.getText();
                        } else if (text == 'websiteDomain') {
                            websiteDomain = parser.getText();
                        } else if (text == 'workingStatus') {
                            workingStatus = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'Epf consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    
    public static mcaEntityDataBaseWrapper parse(String json) {
        System.JSONParser parser = System.JSON.createParser(json);
        return new mcaEntityDataBaseWrapper(parser);
    }
    
    public static void consumeObject(System.JSONParser parser) {
        Integer depth = 0;
        do {
            System.JSONToken curr = parser.getCurrentToken();
            if (curr == System.JSONToken.START_OBJECT || 
                curr == System.JSONToken.START_ARRAY) {
                    depth++;
                } else if (curr == System.JSONToken.END_OBJECT ||
                           curr == System.JSONToken.END_ARRAY) {
                               depth--;
                           }
        } while (depth > 0 && parser.nextToken() != null);
    }
    
    
    
    
    private static List<Details> arrayOfDetails(System.JSONParser p) {
        List<Details> res = new List<Details>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Details(p));
        }
        return res;
    }
    
    
    private static List<FormerBusinesses> arrayOfFormerBusinesses(System.JSONParser p) {
        List<FormerBusinesses> res = new List<FormerBusinesses>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new FormerBusinesses(p));
        }
        return res;
    }
    
    
    
    private static List<Delays_Y> arrayOfDelays_Y(System.JSONParser p) {
        List<Delays_Y> res = new List<Delays_Y>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Delays_Y(p));
        }
        return res;
    }
    
    
    
    
    
    private static List<Directors_Y> arrayOfDirectors_Y(System.JSONParser p) {
        List<Directors_Y> res = new List<Directors_Y>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Directors_Y(p));
        }
        return res;
    }
    
    
    
    private static List<BranchesWithoutCode> arrayOfBranchesWithoutCode(System.JSONParser p) {
        List<BranchesWithoutCode> res = new List<BranchesWithoutCode>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new BranchesWithoutCode(p));
        }
        return res;
    }
    
    
    
    
    
    private static List<RegisteredOffices> arrayOfRegisteredOffices(System.JSONParser p) {
        List<RegisteredOffices> res = new List<RegisteredOffices>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new RegisteredOffices(p));
        }
        return res;
    }
    private static List<Current> arrayOfCurrent(System.JSONParser p) {
        List<Current> res = new List<Current>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Current(p));
        }
        return res;
    }
    
    private static List<SignatoriesContact> arrayOfSignatoriesContact(System.JSONParser p) {
        List<SignatoriesContact> res = new List<SignatoriesContact>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new SignatoriesContact(p));
        }
        return res;
    }
    
    
    private static List<NseSecurity> arrayOfNseSecurity(System.JSONParser p) {
        List<NseSecurity> res = new List<NseSecurity>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new NseSecurity(p));
        }
        return res;
    }
    
    
    private static List<Mca> arrayOfMca(System.JSONParser p) {
        List<Mca> res = new List<Mca>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Mca(p));
        }
        return res;
    }
    
    
    private static List<Kycs> arrayOfKycs(System.JSONParser p) {
        List<Kycs> res = new List<Kycs>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Kycs(p));
        }
        return res;
    }
    
    
    private static List<StartupRecognition> arrayOfStartupRecognition(System.JSONParser p) {
        List<StartupRecognition> res = new List<StartupRecognition>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new StartupRecognition(p));
        }
        return res;
    }
    
    
    private static List<AlertList> arrayOfAlertList(System.JSONParser p) {
        List<AlertList> res = new List<AlertList>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new AlertList(p));
        }
        return res;
    }
    
    
    
    private static List<BseSecurity> arrayOfBseSecurity(System.JSONParser p) {
        List<BseSecurity> res = new List<BseSecurity>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new BseSecurity(p));
        }
        return res;
    }
    
    
    
    
    
    
    private static List<FormerNames> arrayOfFormerNames(System.JSONParser p) {
        List<FormerNames> res = new List<FormerNames>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new FormerNames(p));
        }
        return res;
    }
    
    
    private static List<Defaults_Y> arrayOfDefaults_Y(System.JSONParser p) {
        List<Defaults_Y> res = new List<Defaults_Y>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Defaults_Y(p));
        }
        return res;
    }
    
    
    
    private static List<Epf> arrayOfEpf(System.JSONParser p) {
        List<Epf> res = new List<Epf>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Epf(p));
        }
        return res;
    }
    
    
    private static List<Delays_Z> arrayOfDelays_Z(System.JSONParser p) {
        List<Delays_Z> res = new List<Delays_Z>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Delays_Z(p));
        }
        return res;
    }
    
    
    
    private static List<StatutoryAuditors> arrayOfStatutoryAuditors(System.JSONParser p) {
        List<StatutoryAuditors> res = new List<StatutoryAuditors>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new StatutoryAuditors(p));
        }
        return res;
    }
    
    
    
    
    private static List<Lei> arrayOfLei(System.JSONParser p) {
        List<Lei> res = new List<Lei>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Lei(p));
        }
        return res;
    }
    
    
    private static List<String> arrayOfString(System.JSONParser p) {
        List<String> res = new List<String>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(p.getText());
        }
        return res;
    }
    
    
    
    
    
    
    
    private static List<FormerSymbols> arrayOfFormerSymbols(System.JSONParser p) {
        List<FormerSymbols> res = new List<FormerSymbols>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new FormerSymbols(p));
        }
        return res;
    }
    
    
    
    
    
    private static List<Gst> arrayOfGst(System.JSONParser p) {
        List<Gst> res = new List<Gst>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Gst(p));
        }
        return res;
    }
    
    
    private static List<EligibleOfferForSales> arrayOfEligibleOfferForSales(System.JSONParser p) {
        List<EligibleOfferForSales> res = new List<EligibleOfferForSales>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new EligibleOfferForSales(p));
        }
        return res;
    }
    
    
    
    
    
    private static List<Registrars> arrayOfRegistrars(System.JSONParser p) {
        List<Registrars> res = new List<Registrars>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Registrars(p));
        }
        return res;
    }
    
    
    
    private static List<Alerts> arrayOfAlerts(System.JSONParser p) {
        List<Alerts> res = new List<Alerts>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Alerts(p));
        }
        return res;
    }
    
    
    
    
    private static List<EstablishmentMembers> arrayOfEstablishmentMembers(System.JSONParser p) {
        List<EstablishmentMembers> res = new List<EstablishmentMembers>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new EstablishmentMembers(p));
        }
        return res;
    }
    
    
    private static List<Directors_Z> arrayOfDirectors_Z(System.JSONParser p) {
        List<Directors_Z> res = new List<Directors_Z>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Directors_Z(p));
        }
        return res;
    }
    
    
    
    
    private static List<ManagementAlerts> arrayOfManagementAlerts(System.JSONParser p) {
        List<ManagementAlerts> res = new List<ManagementAlerts>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new ManagementAlerts(p));
        }
        return res;
    }
    
    
    private static List<Charges> arrayOfCharges(System.JSONParser p) {
        List<Charges> res = new List<Charges>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Charges(p));
        }
        return res;
    }
    
    
    
    
    
    private static List<Defaults> arrayOfDefaults(System.JSONParser p) {
        List<Defaults> res = new List<Defaults>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Defaults(p));
        }
        return res;
    }
    
    
    private static List<Registrations> arrayOfRegistrations(System.JSONParser p) {
        List<Registrations> res = new List<Registrations>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Registrations(p));
        }
        return res;
    }
    
    
    
    private static List<Rcmcs> arrayOfRcmcs(System.JSONParser p) {
        List<Rcmcs> res = new List<Rcmcs>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Rcmcs(p));
        }
        return res;
    }
    
    
    private static List<Tan> arrayOfTan(System.JSONParser p) {
        List<Tan> res = new List<Tan>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Tan(p));
        }
        return res;
    }
    
    
    
    
    
    
    
    
    
    private static List<FormerNames_Z> arrayOfFormerNames_Z(System.JSONParser p) {
        List<FormerNames_Z> res = new List<FormerNames_Z>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new FormerNames_Z(p));
        }
        return res;
    }
    
    
    
    
    
    private static List<Delays> arrayOfDelays(System.JSONParser p) {
        List<Delays> res = new List<Delays>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Delays(p));
        }
        return res;
    }
    
    
    private static List<Orders> arrayOfOrders(System.JSONParser p) {
        List<Orders> res = new List<Orders>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Orders(p));
        }
        return res;
    }
    
    
    
    
    private static List<FormerEntityIds> arrayOfFormerEntityIds(System.JSONParser p) {
        List<FormerEntityIds> res = new List<FormerEntityIds>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new FormerEntityIds(p));
        }
        return res;
    }
    
    
    private static List<Lin> arrayOfLin(System.JSONParser p) {
        List<Lin> res = new List<Lin>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Lin(p));
        }
        return res;
    }
    
    
    
    
    private static List<Pans> arrayOfPans(System.JSONParser p) {
        List<Pans> res = new List<Pans>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Pans(p));
        }
        return res;
    }
    
    
    
    
    
    
    
    private static List<FormerNames_Y> arrayOfFormerNames_Y(System.JSONParser p) {
        List<FormerNames_Y> res = new List<FormerNames_Y>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new FormerNames_Y(p));
        }
        return res;
    }
    
    
    
    
    private static List<Directors> arrayOfDirectors(System.JSONParser p) {
        List<Directors> res = new List<Directors>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Directors(p));
        }
        return res;
    }
    
    
    
    
    
    private static List<DetailsAsPerSource> arrayOfDetailsAsPerSource(System.JSONParser p) {
        List<DetailsAsPerSource> res = new List<DetailsAsPerSource>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new DetailsAsPerSource(p));
        }
        return res;
    }
    
    
    private static List<Defaults_Z> arrayOfDefaults_Z(System.JSONParser p) {
        List<Defaults_Z> res = new List<Defaults_Z>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Defaults_Z(p));
        }
        return res;
    }
    
    
    private static List<SecretarialAuditors> arrayOfSecretarialAuditors(System.JSONParser p) {
        List<SecretarialAuditors> res = new List<SecretarialAuditors>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new SecretarialAuditors(p));
        }
        return res;
    }
    
    
    
    private static List<Promoters> arrayOfPromoters(System.JSONParser p) {
        List<Promoters> res = new List<Promoters>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Promoters(p));
        }
        return res;
    }
    
    
    private static List<Iec> arrayOfIec(System.JSONParser p) {
        List<Iec> res = new List<Iec>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Iec(p));
        }
        return res;
    }
    
    
    
    private static List<CreditRatings> arrayOfCreditRatings(System.JSONParser p) {
        List<CreditRatings> res = new List<CreditRatings>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new CreditRatings(p));
        }
        return res;
    }
    private static List<Defaulter> arrayOfDefaulter(System.JSONParser p) {
        List<Defaulter> res = new List<Defaulter>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Defaulter(p));
        }
        return res;
    }
    
    
    private static List<Branches> arrayOfBranches(System.JSONParser p) {
        List<Branches> res = new List<Branches>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Branches(p));
        }
        return res;
    }
    
    
}