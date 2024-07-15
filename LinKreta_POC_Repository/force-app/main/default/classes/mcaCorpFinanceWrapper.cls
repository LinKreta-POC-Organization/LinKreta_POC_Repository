public class mcaCorpFinanceWrapper {

	public String requestId {get;set;} 
	public Result result {get;set;} 
	public Integer statusCode {get;set;} 

	public mcaCorpFinanceWrapper(JSONParser parser) {
		while (parser.nextToken() != System.JSONToken.END_OBJECT) {
			if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
				String text = parser.getText();
				if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
					if (text == 'requestId') {
						requestId = parser.getText();
					} else if (text == 'result') {
						result = new Result(parser);
					} else if (text == 'statusCode') {
						statusCode = parser.getIntegerValue();
					} else {
						System.debug(LoggingLevel.WARN, 'mcaCorpFinanceWrapper consuming unrecognized property: '+text);
						consumeObject(parser);
					}
				}
			}
		}
	}
	
	public class Expenses {
		public Double changesInInventoriesOfFinishedGoodsWorkInProgressAndStockInTrade {get;set;} 
		public Double costMaterial {get;set;} 
		public Double deprcnAmort {get;set;} 
		public Double empBenefitExp {get;set;} 
		public String expenditureOnProductionTransportationAndOtherExpenditurePertainingToExplorationAndProductionActivities {get;set;} 
		public Double finCost {get;set;} 
		public Double othExp {get;set;} 
		public String purchaseStock {get;set;} 
		public Double totExp {get;set;} 

		public Expenses(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'changesInInventoriesOfFinishedGoodsWorkInProgressAndStockInTrade') {
							changesInInventoriesOfFinishedGoodsWorkInProgressAndStockInTrade = parser.getDoubleValue();
						} else if (text == 'costMaterial') {
							costMaterial = parser.getDoubleValue();
						} else if (text == 'deprcnAmort') {
							deprcnAmort = parser.getDoubleValue();
						} else if (text == 'empBenefitExp') {
							empBenefitExp = parser.getDoubleValue();
						} else if (text == 'expenditureOnProductionTransportationAndOtherExpenditurePertainingToExplorationAndProductionActivities') {
							expenditureOnProductionTransportationAndOtherExpenditurePertainingToExplorationAndProductionActivities = parser.getText();
						} else if (text == 'finCost') {
							finCost = parser.getDoubleValue();
						} else if (text == 'othExp') {
							othExp = parser.getDoubleValue();
						} else if (text == 'purchaseStock') {
							purchaseStock = parser.getText();
						} else if (text == 'totExp') {
							totExp = parser.getDoubleValue();
						} else {
							System.debug(LoggingLevel.WARN, 'Expenses consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class BalanceSheet {
		public Assets assets {get;set;} 
		public String date_Z {get;set;} // in json: date
		public EquityLiabilities equityLiabilities {get;set;} 

		public BalanceSheet(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'assets') {
							assets = new Assets(parser);
						} else if (text == 'date') {
							date_Z = parser.getText();
						} else if (text == 'equityLiabilities') {
							equityLiabilities = new EquityLiabilities(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'BalanceSheet consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Metadata {
		public String companyID {get;set;} 
		public String categoryCode {get;set;} 
		public String documentName {get;set;} 
		public String dateOfFiling {get;set;} 
		public String formId {get;set;} 
		public String type {get;set;} 
		public String docId {get;set;} 
		public String lastUpdated {get;set;} 
		public String docLink {get;set;} 
		public String excelLink {get;set;} 
		public String attachmentLink {get;set;} 

		public Metadata(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'companyID') {
							companyID = parser.getText();
						} else if (text == 'categoryCode') {
							categoryCode = parser.getText();
						} else if (text == 'documentName') {
							documentName = parser.getText();
						} else if (text == 'dateOfFiling') {
							dateOfFiling = parser.getText();
						} else if (text == 'formId') {
							formId = parser.getText();
						} else if (text == 'type') {
							type = parser.getText();
						} else if (text == 'docId') {
							docId = parser.getText();
						} else if (text == 'lastUpdated') {
							lastUpdated = parser.getText();
						} else if (text == 'docLink') {
							docLink = parser.getText();
						} else if (text == 'excelLink') {
							excelLink = parser.getText();
						} else if (text == 'attachmentLink') {
							attachmentLink = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Metadata consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Ratios_Z {
		public String cashConversionCycle {get;set;} 
		public Double cashFlowCoverage {get;set;} 
		public String cashFlowMargin {get;set;} 
		public Double cashRatio {get;set;} 
		public Double currentLiabilityCoverage {get;set;} 
		public Double currentRatio {get;set;} 
		public String daysOfInventoryOutstanding {get;set;} 
		public String daysOfPayablesOutstanding {get;set;} 
		public String daysOfSalesOutstanding {get;set;} 
		public String daysWorkingCapital {get;set;} 
		public Double debtCapital {get;set;} 
		public Double debtEquity {get;set;} 
		public String debtToEbitda {get;set;} 
		public Double ebitdaCoverage {get;set;} 
		public String ebitdaMargin {get;set;} 
		public Double equityMultiplier {get;set;} 
		public String grossProfitMargin {get;set;} 
		public Double interestCoverage {get;set;} 
		public String inventoryTurnover {get;set;} 
		public Double longTermDebtCoverage {get;set;} 
		public String netProfitMargin {get;set;} 
		public String netSalesGrowth {get;set;} 
		public String netWorthGrowth {get;set;} 
		public String operatingProfitMargin {get;set;} 
		public String payablesTurnover {get;set;} 
		public Double quickRatio {get;set;} 
		public String receivablesTurnover {get;set;} 
		public String returnOnAssets {get;set;} 
		public String totalAssetTurnover {get;set;} 
		public String totalAssetsGrowth {get;set;} 
		public String totalLiabilitiesGrowth {get;set;} 
		public String workingCapitalTurnover {get;set;} 

		public Ratios_Z(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'cashConversionCycle') {
							cashConversionCycle = parser.getText();
						} else if (text == 'cashFlowCoverage') {
							cashFlowCoverage = parser.getDoubleValue();
						} else if (text == 'cashFlowMargin') {
							cashFlowMargin = parser.getText();
						} else if (text == 'cashRatio') {
							cashRatio = parser.getDoubleValue();
						} else if (text == 'currentLiabilityCoverage') {
							currentLiabilityCoverage = parser.getDoubleValue();
						} else if (text == 'currentRatio') {
							currentRatio = parser.getDoubleValue();
						} else if (text == 'daysOfInventoryOutstanding') {
							daysOfInventoryOutstanding = parser.getText();
						} else if (text == 'daysOfPayablesOutstanding') {
							daysOfPayablesOutstanding = parser.getText();
						} else if (text == 'daysOfSalesOutstanding') {
							daysOfSalesOutstanding = parser.getText();
						} else if (text == 'daysWorkingCapital') {
							daysWorkingCapital = parser.getText();
						} else if (text == 'debtCapital') {
							debtCapital = parser.getDoubleValue();
						} else if (text == 'debtEquity') {
							debtEquity = parser.getDoubleValue();
						} else if (text == 'debtToEbitda') {
							debtToEbitda = parser.getText();
						} else if (text == 'ebitdaCoverage') {
							ebitdaCoverage = parser.getDoubleValue();
						} else if (text == 'ebitdaMargin') {
							ebitdaMargin = parser.getText();
						} else if (text == 'equityMultiplier') {
							equityMultiplier = parser.getDoubleValue();
						} else if (text == 'grossProfitMargin') {
							grossProfitMargin = parser.getText();
						} else if (text == 'interestCoverage') {
							interestCoverage = parser.getDoubleValue();
						} else if (text == 'inventoryTurnover') {
							inventoryTurnover = parser.getText();
						} else if (text == 'longTermDebtCoverage') {
							longTermDebtCoverage = parser.getDoubleValue();
						} else if (text == 'netProfitMargin') {
							netProfitMargin = parser.getText();
						} else if (text == 'netSalesGrowth') {
							netSalesGrowth = parser.getText();
						} else if (text == 'netWorthGrowth') {
							netWorthGrowth = parser.getText();
						} else if (text == 'operatingProfitMargin') {
							operatingProfitMargin = parser.getText();
						} else if (text == 'payablesTurnover') {
							payablesTurnover = parser.getText();
						} else if (text == 'quickRatio') {
							quickRatio = parser.getDoubleValue();
						} else if (text == 'receivablesTurnover') {
							receivablesTurnover = parser.getText();
						} else if (text == 'returnOnAssets') {
							returnOnAssets = parser.getText();
						} else if (text == 'totalAssetTurnover') {
							totalAssetTurnover = parser.getText();
						} else if (text == 'totalAssetsGrowth') {
							totalAssetsGrowth = parser.getText();
						} else if (text == 'totalLiabilitiesGrowth') {
							totalLiabilitiesGrowth = parser.getText();
						} else if (text == 'workingCapitalTurnover') {
							workingCapitalTurnover = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Ratios_Z consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Signatories {
		public List<SignedAuditReport> signedAuditReport {get;set;} 
		public List<SignedBoardReport> signedBoardReport {get;set;} 
		public List<SignedFinStatements> signedFinStatements {get;set;} 

		public Signatories(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'signedAuditReport') {
							signedAuditReport = arrayOfSignedAuditReport(parser);
						} else if (text == 'signedBoardReport') {
							signedBoardReport = arrayOfSignedBoardReport(parser);
						} else if (text == 'signedFinStatements') {
							signedFinStatements = arrayOfSignedFinStatements(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'Signatories consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class CashFlowsFromUsedInInvestingActivities {
		public String cashAdvancesAndLoansMadeToOtherPartiesClassifiedAsInvestingActivities {get;set;} 
		public String cashFlowsFromLosingControlOfSubsidiariesOrOtherBusinessesClassifiedAsInvestingActivities {get;set;} 
		public Double cashFlowsFromUsedInInvestingActivities {get;set;} 
		public String cashFlowsUsedInObtainingControlOfSubsidiariesOrOtherBusinessesClassifiedAsInvestingActivities {get;set;} 
		public String cashPaymentForInvestmentInPartnershipFirmOrAssociationOfPersonsOrLimitedLiabilityPartnerships {get;set;} 
		public String cashPaymentsForFutureContractsForwardContractsOptionContractsAndSwapContractsClassifiedAsInvestingActivities {get;set;} 
		public String cashReceiptsFromFutureContractsForwardContractsOptionContractsAndSwapContractsClassifiedAsInvestingActivities {get;set;} 
		public String cashReceiptsFromRepaymentOfAdvancesAndLoansMadeToOtherPartiesClassifiedAsInvestingActivities {get;set;} 
		public String cashReceiptsFromShareOfProfitsOfPartnershipFirmOrAssociationOfPersonsOrLimitedLiabilityPartnerships {get;set;} 
		public String dividendsReceivedClassifiedAsInvestingActivities {get;set;} 
		public String incomeTaxesPaidRefundClassifiedAsInvestingActivities {get;set;} 
		public String interestReceivedClassifiedAsInvestingActivities {get;set;} 
		public String otherCashPaymentsToAcquireEquityOrDebtInstrumentsOfOtherEntitiesClassifiedAsInvestingActivities {get;set;} 
		public String otherCashPaymentsToAcquireInterestsInJointVenturesClassifiedAsInvestingActivities {get;set;} 
		public String otherCashReceiptsFromSalesOfEquityOrDebtInstrumentsOfOtherEntitiesClassifiedAsInvestingActivities {get;set;} 
		public String otherCashReceiptsFromSalesOfInterestsInJointVenturesClassifiedAsInvestingActivities {get;set;} 
		public String otherInflowsOutflowsOfCashClassifiedAsInvestingActivities {get;set;} 
		public String proceedsFromBiologicalAssetsOtherThanBearerPlantsClassifiedAsInvestingActivities {get;set;} 
		public String proceedsFromGovernmentGrantsClassifiedAsInvestingActivities {get;set;} 
		public String proceedsFromSalesOfGoodwillClassifiedAsInvestingActivities {get;set;} 
		public String proceedsFromSalesOfIntangibleAssetsClassifiedAsInvestingActivities {get;set;} 
		public String proceedsFromSalesOfIntangibleAssetsUnderDevelopment {get;set;} 
		public String proceedsFromSalesOfInvestmentPropertyClassifiedAsInvestingActivities {get;set;} 
		public String proceedsFromSalesOfOtherLongTermAssetsClassifiedAsInvestingActivities {get;set;} 
		public String proceedsFromSalesOfPropertyPlantAndEquipmentClassifiedAsInvestingActivities {get;set;} 
		public String purchaseOfBiologicalAssetsOtherThanBearerPlantsClassifiedAsInvestingActivities {get;set;} 
		public String purchaseOfGoodwillClassifiedAsInvestingActivities {get;set;} 
		public String purchaseOfIntangibleAssetsClassifiedAsInvestingActivities {get;set;} 
		public String purchaseOfIntangibleAssetsUnderDevelopment {get;set;} 
		public String purchaseOfInvestmentPropertyClassifiedAsInvestingActivities {get;set;} 
		public String purchaseOfOtherLongTermAssetsClassifiedAsInvestingActivities {get;set;} 
		public Double purchaseOfPropertyPlantAndEquipmenyClassifiedAsInvestingActivities {get;set;} 

		public CashFlowsFromUsedInInvestingActivities(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'cashAdvancesAndLoansMadeToOtherPartiesClassifiedAsInvestingActivities') {
							cashAdvancesAndLoansMadeToOtherPartiesClassifiedAsInvestingActivities = parser.getText();
						} else if (text == 'cashFlowsFromLosingControlOfSubsidiariesOrOtherBusinessesClassifiedAsInvestingActivities') {
							cashFlowsFromLosingControlOfSubsidiariesOrOtherBusinessesClassifiedAsInvestingActivities = parser.getText();
						} else if (text == 'cashFlowsFromUsedInInvestingActivities') {
							cashFlowsFromUsedInInvestingActivities = parser.getDoubleValue();
						} else if (text == 'cashFlowsUsedInObtainingControlOfSubsidiariesOrOtherBusinessesClassifiedAsInvestingActivities') {
							cashFlowsUsedInObtainingControlOfSubsidiariesOrOtherBusinessesClassifiedAsInvestingActivities = parser.getText();
						} else if (text == 'cashPaymentForInvestmentInPartnershipFirmOrAssociationOfPersonsOrLimitedLiabilityPartnerships') {
							cashPaymentForInvestmentInPartnershipFirmOrAssociationOfPersonsOrLimitedLiabilityPartnerships = parser.getText();
						} else if (text == 'cashPaymentsForFutureContractsForwardContractsOptionContractsAndSwapContractsClassifiedAsInvestingActivities') {
							cashPaymentsForFutureContractsForwardContractsOptionContractsAndSwapContractsClassifiedAsInvestingActivities = parser.getText();
						} else if (text == 'cashReceiptsFromFutureContractsForwardContractsOptionContractsAndSwapContractsClassifiedAsInvestingActivities') {
							cashReceiptsFromFutureContractsForwardContractsOptionContractsAndSwapContractsClassifiedAsInvestingActivities = parser.getText();
						} else if (text == 'cashReceiptsFromRepaymentOfAdvancesAndLoansMadeToOtherPartiesClassifiedAsInvestingActivities') {
							cashReceiptsFromRepaymentOfAdvancesAndLoansMadeToOtherPartiesClassifiedAsInvestingActivities = parser.getText();
						} else if (text == 'cashReceiptsFromShareOfProfitsOfPartnershipFirmOrAssociationOfPersonsOrLimitedLiabilityPartnerships') {
							cashReceiptsFromShareOfProfitsOfPartnershipFirmOrAssociationOfPersonsOrLimitedLiabilityPartnerships = parser.getText();
						} else if (text == 'dividendsReceivedClassifiedAsInvestingActivities') {
							dividendsReceivedClassifiedAsInvestingActivities = parser.getText();
						} else if (text == 'incomeTaxesPaidRefundClassifiedAsInvestingActivities') {
							incomeTaxesPaidRefundClassifiedAsInvestingActivities = parser.getText();
						} else if (text == 'interestReceivedClassifiedAsInvestingActivities') {
							interestReceivedClassifiedAsInvestingActivities = parser.getText();
						} else if (text == 'otherCashPaymentsToAcquireEquityOrDebtInstrumentsOfOtherEntitiesClassifiedAsInvestingActivities') {
							otherCashPaymentsToAcquireEquityOrDebtInstrumentsOfOtherEntitiesClassifiedAsInvestingActivities = parser.getText();
						} else if (text == 'otherCashPaymentsToAcquireInterestsInJointVenturesClassifiedAsInvestingActivities') {
							otherCashPaymentsToAcquireInterestsInJointVenturesClassifiedAsInvestingActivities = parser.getText();
						} else if (text == 'otherCashReceiptsFromSalesOfEquityOrDebtInstrumentsOfOtherEntitiesClassifiedAsInvestingActivities') {
							otherCashReceiptsFromSalesOfEquityOrDebtInstrumentsOfOtherEntitiesClassifiedAsInvestingActivities = parser.getText();
						} else if (text == 'otherCashReceiptsFromSalesOfInterestsInJointVenturesClassifiedAsInvestingActivities') {
							otherCashReceiptsFromSalesOfInterestsInJointVenturesClassifiedAsInvestingActivities = parser.getText();
						} else if (text == 'otherInflowsOutflowsOfCashClassifiedAsInvestingActivities') {
							otherInflowsOutflowsOfCashClassifiedAsInvestingActivities = parser.getText();
						} else if (text == 'proceedsFromBiologicalAssetsOtherThanBearerPlantsClassifiedAsInvestingActivities') {
							proceedsFromBiologicalAssetsOtherThanBearerPlantsClassifiedAsInvestingActivities = parser.getText();
						} else if (text == 'proceedsFromGovernmentGrantsClassifiedAsInvestingActivities') {
							proceedsFromGovernmentGrantsClassifiedAsInvestingActivities = parser.getText();
						} else if (text == 'proceedsFromSalesOfGoodwillClassifiedAsInvestingActivities') {
							proceedsFromSalesOfGoodwillClassifiedAsInvestingActivities = parser.getText();
						} else if (text == 'proceedsFromSalesOfIntangibleAssetsClassifiedAsInvestingActivities') {
							proceedsFromSalesOfIntangibleAssetsClassifiedAsInvestingActivities = parser.getText();
						} else if (text == 'proceedsFromSalesOfIntangibleAssetsUnderDevelopment') {
							proceedsFromSalesOfIntangibleAssetsUnderDevelopment = parser.getText();
						} else if (text == 'proceedsFromSalesOfInvestmentPropertyClassifiedAsInvestingActivities') {
							proceedsFromSalesOfInvestmentPropertyClassifiedAsInvestingActivities = parser.getText();
						} else if (text == 'proceedsFromSalesOfOtherLongTermAssetsClassifiedAsInvestingActivities') {
							proceedsFromSalesOfOtherLongTermAssetsClassifiedAsInvestingActivities = parser.getText();
						} else if (text == 'proceedsFromSalesOfPropertyPlantAndEquipmentClassifiedAsInvestingActivities') {
							proceedsFromSalesOfPropertyPlantAndEquipmentClassifiedAsInvestingActivities = parser.getText();
						} else if (text == 'purchaseOfBiologicalAssetsOtherThanBearerPlantsClassifiedAsInvestingActivities') {
							purchaseOfBiologicalAssetsOtherThanBearerPlantsClassifiedAsInvestingActivities = parser.getText();
						} else if (text == 'purchaseOfGoodwillClassifiedAsInvestingActivities') {
							purchaseOfGoodwillClassifiedAsInvestingActivities = parser.getText();
						} else if (text == 'purchaseOfIntangibleAssetsClassifiedAsInvestingActivities') {
							purchaseOfIntangibleAssetsClassifiedAsInvestingActivities = parser.getText();
						} else if (text == 'purchaseOfIntangibleAssetsUnderDevelopment') {
							purchaseOfIntangibleAssetsUnderDevelopment = parser.getText();
						} else if (text == 'purchaseOfInvestmentPropertyClassifiedAsInvestingActivities') {
							purchaseOfInvestmentPropertyClassifiedAsInvestingActivities = parser.getText();
						} else if (text == 'purchaseOfOtherLongTermAssetsClassifiedAsInvestingActivities') {
							purchaseOfOtherLongTermAssetsClassifiedAsInvestingActivities = parser.getText();
						} else if (text == 'purchaseOfPropertyPlantAndEquipmenyClassifiedAsInvestingActivities') {
							purchaseOfPropertyPlantAndEquipmenyClassifiedAsInvestingActivities = parser.getDoubleValue();
						} else {
							System.debug(LoggingLevel.WARN, 'CashFlowsFromUsedInInvestingActivities consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class DisclosureOfPrincipalProductOrService {
		public String descriptionOfProductOrService {get;set;} 
		public String descriptionOfProductOrServiceCategory {get;set;} 
		public String highestTurnoverContributingProductOrServiceITC8DigitCode {get;set;} 
		public String productOrServiceCategoryItc4DigitCode {get;set;} 
		public String quantityOfHighestContributingProductOrServiceInUom {get;set;} 
		public String turnoverOfHighestContributingProductOrService {get;set;} 
		public String turnoverOfProductOrServiceCategory {get;set;} 
		public String unitOfMeasurementOfHighestContributingProductOrService {get;set;} 

		public DisclosureOfPrincipalProductOrService(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'descriptionOfProductOrService') {
							descriptionOfProductOrService = parser.getText();
						} else if (text == 'descriptionOfProductOrServiceCategory') {
							descriptionOfProductOrServiceCategory = parser.getText();
						} else if (text == 'highestTurnoverContributingProductOrServiceITC8DigitCode') {
							highestTurnoverContributingProductOrServiceITC8DigitCode = parser.getText();
						} else if (text == 'productOrServiceCategoryItc4DigitCode') {
							productOrServiceCategoryItc4DigitCode = parser.getText();
						} else if (text == 'quantityOfHighestContributingProductOrServiceInUom') {
							quantityOfHighestContributingProductOrServiceInUom = parser.getText();
						} else if (text == 'turnoverOfHighestContributingProductOrService') {
							turnoverOfHighestContributingProductOrService = parser.getText();
						} else if (text == 'turnoverOfProductOrServiceCategory') {
							turnoverOfProductOrServiceCategory = parser.getText();
						} else if (text == 'unitOfMeasurementOfHighestContributingProductOrService') {
							unitOfMeasurementOfHighestContributingProductOrService = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'DisclosureOfPrincipalProductOrService consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class AuditorProfile {
		public String addressOfAuditors {get;set;} 
		public String categryAudtrfrm {get;set;} 
		public String dateOfSigningAuditReportByAuditors {get;set;} 
		public String dateOfSigningOfBalanceSheetByAuditors {get;set;} 
		public String itPan {get;set;} 
		public String membrshpNum {get;set;} 
		public String nameOfAuditor {get;set;} 
		public String nameOfAuditorSigningReport {get;set;} 
		public String regstrnNum {get;set;} 
		public String srnOfFormADT1 {get;set;} 

		public AuditorProfile(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'addressOfAuditors') {
							addressOfAuditors = parser.getText();
						} else if (text == 'categryAudtrfrm') {
							categryAudtrfrm = parser.getText();
						} else if (text == 'dateOfSigningAuditReportByAuditors') {
							dateOfSigningAuditReportByAuditors = parser.getText();
						} else if (text == 'dateOfSigningOfBalanceSheetByAuditors') {
							dateOfSigningOfBalanceSheetByAuditors = parser.getText();
						} else if (text == 'itPan') {
							itPan = parser.getText();
						} else if (text == 'membrshpNum') {
							membrshpNum = parser.getText();
						} else if (text == 'nameOfAuditor') {
							nameOfAuditor = parser.getText();
						} else if (text == 'nameOfAuditorSigningReport') {
							nameOfAuditorSigningReport = parser.getText();
						} else if (text == 'regstrnNum') {
							regstrnNum = parser.getText();
						} else if (text == 'srnOfFormADT1') {
							srnOfFormADT1 = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'AuditorProfile consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Result {
		public List<Financial> financial {get;set;} 
		public List<SignedAuditReport> consolidatedFinancial {get;set;} 
		public String companyName {get;set;} 
		public String entityId {get;set;} 
		public String lastDownloaded {get;set;} 
		public String mergedFinancials {get;set;} 

		public Result(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'financial') {
							financial = arrayOfFinancial(parser);
						} else if (text == 'consolidatedFinancial') {
							consolidatedFinancial = arrayOfSignedAuditReport(parser);
						} else if (text == 'companyName') {
							companyName = parser.getText();
						} else if (text == 'entityId') {
							entityId = parser.getText();
						} else if (text == 'lastDownloaded') {
							lastDownloaded = parser.getText();
						} else if (text == 'mergedFinancials') {
							mergedFinancials = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Result consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Ratios {
		public String cashConversionCycle {get;set;} 
		public Double cashFlowCoverage {get;set;} 
		public String cashFlowMargin {get;set;} 
		public Double cashRatio {get;set;} 
		public Double currentLiabilityCoverage {get;set;} 
		public Double currentRatio {get;set;} 
		public String daysOfInventoryOutstanding {get;set;} 
		public String daysOfPayablesOutstanding {get;set;} 
		public String daysOfSalesOutstanding {get;set;} 
		public String daysWorkingCapital {get;set;} 
		public Double debtCapital {get;set;} 
		public Double debtEquity {get;set;} 
		public String debtToEbitda {get;set;} 
		public Double ebitdaCoverage {get;set;} 
		public String ebitdaMargin {get;set;} 
		public Double equityMultiplier {get;set;} 
		public String grossProfitMargin {get;set;} 
		public Double interestCoverage {get;set;} 
		public String inventoryTurnover {get;set;} 
		public Double longTermDebtCoverage {get;set;} 
		public String netProfitMargin {get;set;} 
		public String netSalesGrowth {get;set;} 
		public Double netWorthGrowth {get;set;} 
		public String operatingProfitMargin {get;set;} 
		public String payablesTurnover {get;set;} 
		public Double quickRatio {get;set;} 
		public String receivablesTurnover {get;set;} 
		public Double returnOnAssets {get;set;} 
		public Double returnOnEquity {get;set;} 
		public Double totalAssetTurnover {get;set;} 
		public Double totalAssetsGrowth {get;set;} 
		public Double totalLiabilitiesGrowth {get;set;} 
		public String workingCapitalTurnover {get;set;} 

		public Ratios(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'cashConversionCycle') {
							cashConversionCycle = parser.getText();
						} else if (text == 'cashFlowCoverage') {
							cashFlowCoverage = parser.getDoubleValue();
						} else if (text == 'cashFlowMargin') {
							cashFlowMargin = parser.getText();
						} else if (text == 'cashRatio') {
							cashRatio = parser.getDoubleValue();
						} else if (text == 'currentLiabilityCoverage') {
							currentLiabilityCoverage = parser.getDoubleValue();
						} else if (text == 'currentRatio') {
							currentRatio = parser.getDoubleValue();
						} else if (text == 'daysOfInventoryOutstanding') {
							daysOfInventoryOutstanding = parser.getText();
						} else if (text == 'daysOfPayablesOutstanding') {
							daysOfPayablesOutstanding = parser.getText();
						} else if (text == 'daysOfSalesOutstanding') {
							daysOfSalesOutstanding = parser.getText();
						} else if (text == 'daysWorkingCapital') {
							daysWorkingCapital = parser.getText();
						} else if (text == 'debtCapital') {
							debtCapital = parser.getDoubleValue();
						} else if (text == 'debtEquity') {
							debtEquity = parser.getDoubleValue();
						} else if (text == 'debtToEbitda') {
							debtToEbitda = parser.getText();
						} else if (text == 'ebitdaCoverage') {
							ebitdaCoverage = parser.getDoubleValue();
						} else if (text == 'ebitdaMargin') {
							ebitdaMargin = parser.getText();
						} else if (text == 'equityMultiplier') {
							equityMultiplier = parser.getDoubleValue();
						} else if (text == 'grossProfitMargin') {
							grossProfitMargin = parser.getText();
						} else if (text == 'interestCoverage') {
							interestCoverage = parser.getDoubleValue();
						} else if (text == 'inventoryTurnover') {
							inventoryTurnover = parser.getText();
						} else if (text == 'longTermDebtCoverage') {
							longTermDebtCoverage = parser.getDoubleValue();
						} else if (text == 'netProfitMargin') {
							netProfitMargin = parser.getText();
						} else if (text == 'netSalesGrowth') {
							netSalesGrowth = parser.getText();
						} else if (text == 'netWorthGrowth') {
							netWorthGrowth = parser.getDoubleValue();
						} else if (text == 'operatingProfitMargin') {
							operatingProfitMargin = parser.getText();
						} else if (text == 'payablesTurnover') {
							payablesTurnover = parser.getText();
						} else if (text == 'quickRatio') {
							quickRatio = parser.getDoubleValue();
						} else if (text == 'receivablesTurnover') {
							receivablesTurnover = parser.getText();
						} else if (text == 'returnOnAssets') {
							returnOnAssets = parser.getDoubleValue();
						} else if (text == 'returnOnEquity') {
							returnOnEquity = parser.getDoubleValue();
						} else if (text == 'totalAssetTurnover') {
							totalAssetTurnover = parser.getDoubleValue();
						} else if (text == 'totalAssetsGrowth') {
							totalAssetsGrowth = parser.getDoubleValue();
						} else if (text == 'totalLiabilitiesGrowth') {
							totalLiabilitiesGrowth = parser.getDoubleValue();
						} else if (text == 'workingCapitalTurnover') {
							workingCapitalTurnover = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Ratios consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Assets {
		public Double bankBalanceOtherThanCashAndCashEquivalents {get;set;} 
		public String biologicalAssetsOtherThanBearerPlants {get;set;} 
		public Double capWip {get;set;} 
		public Double cashEqui {get;set;} 
		public Double currInv {get;set;} 
		public String currentTaxAssets {get;set;} 
		public String deferredTaxAssetsNet {get;set;} 
		public String goodwill {get;set;} 
		public Double intangAsset {get;set;} 
		public String intangAssetAud {get;set;} 
		public Double inventory {get;set;} 
		public String investmentProperty {get;set;} 
		public String investmentsAccountedForUsingEquityMethod {get;set;} 
		public Double loansCurrent {get;set;} 
		public Double loansNonCurrent {get;set;} 
		public Double nonCurrInv {get;set;} 
		public Double nonCurrentFinancialAssets {get;set;} 
		public String noncurrentAssetsClassifiedAsHeldForSale {get;set;} 
		public Double othCurrAsset {get;set;} 
		public Double othNonCurrAsset {get;set;} 
		public Double otherCurrentFinancialAssets {get;set;} 
		public Double otherNonCurrentFinancialAssets {get;set;} 
		public Double propertyPlantAndEquipment {get;set;} 
		public String regulatoryDeferralAccountDebitBalancesAndRelatedDeferredTaxAssets {get;set;} 
		public String totalAssets {get;set;} 
		public String totalCurrentAssets {get;set;} 
		public Double totalCurrentFinancialAssets {get;set;} 
		public String totalNonCurrentAssets {get;set;} 
		public Double tradeRec {get;set;} 
		public String tradeReceivablesNonCurrent {get;set;} 

		public Assets(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'bankBalanceOtherThanCashAndCashEquivalents') {
							bankBalanceOtherThanCashAndCashEquivalents = parser.getDoubleValue();
						} else if (text == 'biologicalAssetsOtherThanBearerPlants') {
							biologicalAssetsOtherThanBearerPlants = parser.getText();
						} else if (text == 'capWip') {
							capWip = parser.getDoubleValue();
						} else if (text == 'cashEqui') {
							cashEqui = parser.getDoubleValue();
						} else if (text == 'currInv') {
							currInv = parser.getDoubleValue();
						} else if (text == 'currentTaxAssets') {
							currentTaxAssets = parser.getText();
						} else if (text == 'deferredTaxAssetsNet') {
							deferredTaxAssetsNet = parser.getText();
						} else if (text == 'goodwill') {
							goodwill = parser.getText();
						} else if (text == 'intangAsset') {
							intangAsset = parser.getDoubleValue();
						} else if (text == 'intangAssetAud') {
							intangAssetAud = parser.getText();
						} else if (text == 'inventory') {
							inventory = parser.getDoubleValue();
						} else if (text == 'investmentProperty') {
							investmentProperty = parser.getText();
						} else if (text == 'investmentsAccountedForUsingEquityMethod') {
							investmentsAccountedForUsingEquityMethod = parser.getText();
						} else if (text == 'loansCurrent') {
							loansCurrent = parser.getDoubleValue();
						} else if (text == 'loansNonCurrent') {
							loansNonCurrent = parser.getDoubleValue();
						} else if (text == 'nonCurrInv') {
							nonCurrInv = parser.getDoubleValue();
						} else if (text == 'nonCurrentFinancialAssets') {
							nonCurrentFinancialAssets = parser.getDoubleValue();
						} else if (text == 'noncurrentAssetsClassifiedAsHeldForSale') {
							noncurrentAssetsClassifiedAsHeldForSale = parser.getText();
						} else if (text == 'othCurrAsset') {
							othCurrAsset = parser.getDoubleValue();
						} else if (text == 'othNonCurrAsset') {
							othNonCurrAsset = parser.getDoubleValue();
						} else if (text == 'otherCurrentFinancialAssets') {
							otherCurrentFinancialAssets = parser.getDoubleValue();
						} else if (text == 'otherNonCurrentFinancialAssets') {
							otherNonCurrentFinancialAssets = parser.getDoubleValue();
						} else if (text == 'propertyPlantAndEquipment') {
							propertyPlantAndEquipment = parser.getDoubleValue();
						} else if (text == 'regulatoryDeferralAccountDebitBalancesAndRelatedDeferredTaxAssets') {
							regulatoryDeferralAccountDebitBalancesAndRelatedDeferredTaxAssets = parser.getText();
						} else if (text == 'totalAssets') {
							totalAssets = parser.getText();
						} else if (text == 'totalCurrentAssets') {
							totalCurrentAssets = parser.getText();
						} else if (text == 'totalCurrentFinancialAssets') {
							totalCurrentFinancialAssets = parser.getDoubleValue();
						} else if (text == 'totalNonCurrentAssets') {
							totalNonCurrentAssets = parser.getText();
						} else if (text == 'tradeRec') {
							tradeRec = parser.getDoubleValue();
						} else if (text == 'tradeReceivablesNonCurrent') {
							tradeReceivablesNonCurrent = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Assets consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class EquityLiabilities {
		public Double borrowingsCurrent {get;set;} 
		public Double borrowingsNonCurrent {get;set;} 
		public Double currentFinancialLiabilities {get;set;} 
		public String currentLiabilties {get;set;} 
		public String currentTaxLiabilities {get;set;} 
		public String deferredGovernmentGrantsCurrent {get;set;} 
		public String deferredGovernmentGrantsNoncurrent {get;set;} 
		public String deffTaxLiab {get;set;} 
		public String liabilitiesDirectlyAssociatedWithAssetsInDisposalGroupClassifiedAsHeldForSale {get;set;} 
		public Double nonControllingInterest {get;set;} 
		public String nonCurrentFinancialLiabilities {get;set;} 
		public Double otherCurrentFinancialLiabilities {get;set;} 
		public Double otherCurrentLiabilities {get;set;} 
		public Double otherEquity {get;set;} 
		public String otherNonCurrentFinancialLiabilities {get;set;} 
		public String otherNonCurrentLiabilities {get;set;} 
		public Double provisionsCurrent {get;set;} 
		public Double provisionsNonCurrent {get;set;} 
		public String regulatoryDeferralAccountCreditBalancesAndRelatedDeferredTaxLiability {get;set;} 
		public Double shareCap {get;set;} 
		public Double totalEl {get;set;} 
		public String totalEquity {get;set;} 
		public Double totalEquityAttributableToOwnersOfParent {get;set;} 
		public String totalLiabilities {get;set;} 
		public Double totalNonCurrentLiabilities {get;set;} 
		public Double tradePay {get;set;} 
		public String tradePayablesNoncurrent {get;set;} 

		public EquityLiabilities(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'borrowingsCurrent') {
							borrowingsCurrent = parser.getDoubleValue();
						} else if (text == 'borrowingsNonCurrent') {
							borrowingsNonCurrent = parser.getDoubleValue();
						} else if (text == 'currentFinancialLiabilities') {
							currentFinancialLiabilities = parser.getDoubleValue();
						} else if (text == 'currentLiabilties') {
							currentLiabilties = parser.getText();
						} else if (text == 'currentTaxLiabilities') {
							currentTaxLiabilities = parser.getText();
						} else if (text == 'deferredGovernmentGrantsCurrent') {
							deferredGovernmentGrantsCurrent = parser.getText();
						} else if (text == 'deferredGovernmentGrantsNoncurrent') {
							deferredGovernmentGrantsNoncurrent = parser.getText();
						} else if (text == 'deffTaxLiab') {
							deffTaxLiab = parser.getText();
						} else if (text == 'liabilitiesDirectlyAssociatedWithAssetsInDisposalGroupClassifiedAsHeldForSale') {
							liabilitiesDirectlyAssociatedWithAssetsInDisposalGroupClassifiedAsHeldForSale = parser.getText();
						} else if (text == 'nonControllingInterest') {
							nonControllingInterest = parser.getDoubleValue();
						} else if (text == 'nonCurrentFinancialLiabilities') {
							nonCurrentFinancialLiabilities = parser.getText();
						} else if (text == 'otherCurrentFinancialLiabilities') {
							otherCurrentFinancialLiabilities = parser.getDoubleValue();
						} else if (text == 'otherCurrentLiabilities') {
							otherCurrentLiabilities = parser.getDoubleValue();
						} else if (text == 'otherEquity') {
							otherEquity = parser.getDoubleValue();
						} else if (text == 'otherNonCurrentFinancialLiabilities') {
							otherNonCurrentFinancialLiabilities = parser.getText();
						} else if (text == 'otherNonCurrentLiabilities') {
							otherNonCurrentLiabilities = parser.getText();
						} else if (text == 'provisionsCurrent') {
							provisionsCurrent = parser.getDoubleValue();
						} else if (text == 'provisionsNonCurrent') {
							provisionsNonCurrent = parser.getDoubleValue();
						} else if (text == 'regulatoryDeferralAccountCreditBalancesAndRelatedDeferredTaxLiability') {
							regulatoryDeferralAccountCreditBalancesAndRelatedDeferredTaxLiability = parser.getText();
						} else if (text == 'shareCap') {
							shareCap = parser.getDoubleValue();
						} else if (text == 'totalEl') {
							totalEl = parser.getDoubleValue();
						} else if (text == 'totalEquity') {
							totalEquity = parser.getText();
						} else if (text == 'totalEquityAttributableToOwnersOfParent') {
							totalEquityAttributableToOwnersOfParent = parser.getDoubleValue();
						} else if (text == 'totalLiabilities') {
							totalLiabilities = parser.getText();
						} else if (text == 'totalNonCurrentLiabilities') {
							totalNonCurrentLiabilities = parser.getDoubleValue();
						} else if (text == 'tradePay') {
							tradePay = parser.getDoubleValue();
						} else if (text == 'tradePayablesNoncurrent') {
							tradePayablesNoncurrent = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'EquityLiabilities consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class SignedAuditReport {

		public SignedAuditReport(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						{
							System.debug(LoggingLevel.WARN, 'SignedAuditReport consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class PrincipalProduct {
		public List<DisclosureOfPrincipalProductOrService> disclosureOfPrincipalProductOrService {get;set;} 

		public PrincipalProduct(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'disclosureOfPrincipalProductOrService') {
							disclosureOfPrincipalProductOrService = arrayOfDisclosureOfPrincipalProductOrService(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'PrincipalProduct consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Financial {
		public Data data {get;set;} 
		public Metadata metadata {get;set;} 

		public Financial(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'data') {
							data = new Data(parser);
						} else if (text == 'metadata') {
							metadata = new Metadata(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'Financial consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class SignedBoardReport {
		public String dateSigninBR1 {get;set;} 
		public String din1 {get;set;} 
		public String directorNameBR1 {get;set;} 
		public String dtlsOfDirDsgtn1 {get;set;} 
		public String lastNameOfDirector {get;set;} 
		public String middleNameOfDirector {get;set;} 

		public SignedBoardReport(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'dateSigninBR1') {
							dateSigninBR1 = parser.getText();
						} else if (text == 'din1') {
							din1 = parser.getText();
						} else if (text == 'directorNameBR1') {
							directorNameBR1 = parser.getText();
						} else if (text == 'dtlsOfDirDsgtn1') {
							dtlsOfDirDsgtn1 = parser.getText();
						} else if (text == 'lastNameOfDirector') {
							lastNameOfDirector = parser.getText();
						} else if (text == 'middleNameOfDirector') {
							middleNameOfDirector = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'SignedBoardReport consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Data {
		public Signatories signatories {get;set;} 
		public Current current {get;set;} 
		public Previous previous {get;set;} 
		public AuditorReport auditorReport {get;set;} 
		public List<AuditorProfile> auditorProfile {get;set;} 
		public CompanyInfo companyInfo {get;set;} 
		public PrincipalProduct principalProduct {get;set;} 
		public String statementOfSolvency {get;set;} 
		public String financialStartDate {get;set;} 
		public String financialEndDate {get;set;} 

		public Data(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'signatories') {
							signatories = new Signatories(parser);
						} else if (text == 'current') {
							current = new Current(parser);
						} else if (text == 'previous') {
							previous = new Previous(parser);
						} else if (text == 'auditorReport') {
							auditorReport = new AuditorReport(parser);
						} else if (text == 'auditorProfile') {
							auditorProfile = arrayOfAuditorProfile(parser);
						} else if (text == 'companyInfo') {
							companyInfo = new CompanyInfo(parser);
						} else if (text == 'principalProduct') {
							principalProduct = new PrincipalProduct(parser);
						} else if (text == 'statementOfSolvency') {
							statementOfSolvency = parser.getText();
						} else if (text == 'financialStartDate') {
							financialStartDate = parser.getText();
						} else if (text == 'financialEndDate') {
							financialEndDate = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Data consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class CashFlowStatement {
		public CashFlowsFromUsedInFinancingActivities cashFlowsFromUsedInFinancingActivities {get;set;} 
		public CashFlowsFromUsedInInvestingActivities cashFlowsFromUsedInInvestingActivities {get;set;} 
		public CashFlowsFromUsedInOperatingActivities cashFlowsFromUsedInOperatingActivities {get;set;} 
		public EffectOfExchangeRateChangesOnCashAndCashEquivalents effectOfExchangeRateChangesOnCashAndCashEquivalents {get;set;} 
		public Boolean whetherCashFlowStatementIsApplicableOnCompany {get;set;} 

		public CashFlowStatement(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'cashFlowsFromUsedInFinancingActivities') {
							cashFlowsFromUsedInFinancingActivities = new CashFlowsFromUsedInFinancingActivities(parser);
						} else if (text == 'cashFlowsFromUsedInInvestingActivities') {
							cashFlowsFromUsedInInvestingActivities = new CashFlowsFromUsedInInvestingActivities(parser);
						} else if (text == 'cashFlowsFromUsedInOperatingActivities') {
							cashFlowsFromUsedInOperatingActivities = new CashFlowsFromUsedInOperatingActivities(parser);
						} else if (text == 'effectOfExchangeRateChangesOnCashAndCashEquivalents') {
							effectOfExchangeRateChangesOnCashAndCashEquivalents = new EffectOfExchangeRateChangesOnCashAndCashEquivalents(parser);
						} else if (text == 'whetherCashFlowStatementIsApplicableOnCompany') {
							whetherCashFlowStatementIsApplicableOnCompany = parser.getBooleanValue();
						} else {
							System.debug(LoggingLevel.WARN, 'CashFlowStatement consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class SignedFinStatements {
		public String dateSigningFS1 {get;set;} 
		public String dinPan1 {get;set;} 
		public String directorName1 {get;set;} 
		public String dtlsOfDsgtn1 {get;set;} 
		public String lastNameOfDirector {get;set;} 
		public String middleNameOfDirector {get;set;} 

		public SignedFinStatements(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'dateSigningFS1') {
							dateSigningFS1 = parser.getText();
						} else if (text == 'dinPan1') {
							dinPan1 = parser.getText();
						} else if (text == 'directorName1') {
							directorName1 = parser.getText();
						} else if (text == 'dtlsOfDsgtn1') {
							dtlsOfDsgtn1 = parser.getText();
						} else if (text == 'lastNameOfDirector') {
							lastNameOfDirector = parser.getText();
						} else if (text == 'middleNameOfDirector') {
							middleNameOfDirector = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'SignedFinStatements consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class OtherComprehensiveIncome {
		public String aggregatedIncomeTaxRelatingToComponentsOfOtherComprehensiveIncomeThatWillBeReclassifiedToProfitOrLoss {get;set;} 
		public String aggregatedIncomeTaxRelatingToComponentsOfOtherComprehensiveIncomeThatWillNotBeReclassifiedToProfitOrLoss {get;set;} 
		public String amountsRemovedFromEquityAndAdjustedAgainstFairValueOfFinancialAssetsOnReclassificationOutOfFairValueThroughOtherComprehensiveIncomeMeasurementCategoryBeforeTax {get;set;} 
		public String amountsRemovedFromEquityAndAdjustedAgainstFairValueOfFinancialAssetsOnReclassificationOutOfFairValueThroughOtherComprehensiveIncomeMeasurementCategoryNetOfTax {get;set;} 
		public String amountsRemovedFromEquityAndIncludedInCarryingAmountOfNonFinancialAssetLiabilityWhoseAcquisitionOrIncurrenceWasHedgedHighlyProbableForecastTransactionNetOfTax {get;set;} 
		public String amountsRemovedFromEquityAndIncludedInCarryingAmountOfNonfinancialAssetsLiabilityWhoseAcquisitionOrIncurrenceWasHedgedHighlyProbableForecastTransactionBeforeTax {get;set;} 
		public String comprehensiveIncomeAttributableToComprehensiveIncomeAttributableToNonControllingInterests {get;set;} 
		public String comprehensiveIncomeAttributableToComprehensiveIncomeAttributableToOwnersOfParent {get;set;} 
		public String comprehensiveIncomeAttributableToNetOfTaxComprehensiveIncomeAttributableToNoncontrollingInterests {get;set;} 
		public String comprehensiveIncomeAttributableToNetOfTaxComprehensiveIncomeAttributableToOwnersOfParent {get;set;} 
		public String gainsLossesOnCashFlowHedgesNetOfTax {get;set;} 
		public String gainsLossesOnChangeInValueOfForeignCurrencyBasisSpreadsBeforeTax {get;set;} 
		public String gainsLossesOnChangeInValueOfForeignCurrencyBasisSpreadsNetOfTax {get;set;} 
		public String gainsLossesOnChangeInValueOfForwardElementsOfForwardContractsBeforeTax {get;set;} 
		public String gainsLossesOnChangeInValueOfForwardElementsOfForwardContractsNetOfTax {get;set;} 
		public String gainsLossesOnChangeInValueOfTimeValueOfOptionsBeforeTax {get;set;} 
		public String gainsLossesOnChangeInValueOfTimeValueOfOptionsNetOfTax {get;set;} 
		public String gainsLossesOnDebtInstrumentThroughOtherComprehensiveIncomeBeforeTax {get;set;} 
		public String gainsLossesOnDebtInstrumentThroughOtherComprehensiveIncomeNetOfTax {get;set;} 
		public String gainsLossesOnExchangeDifferencesOnTranslationBeforeTax {get;set;} 
		public String gainsLossesOnExchangeDifferencesOnTranslationNetOfTax {get;set;} 
		public String gainsLossesOnFinancialAssetsMeasuredAtFairValueThroughOtherComprehensiveIncomeBeforeTax {get;set;} 
		public String gainsLossesOnFinancialAssetsMeasuredAtFairValueThroughOtherComprehensiveIncomeNetOfTax {get;set;} 
		public String gainsLossesOnHedgesOfNetInvestmentsInForeignOperationsBeforeTax {get;set;} 
		public String gainsLossesOnHedgesOfNetInvestmentsInForeignOperationsNetOfTax {get;set;} 
		public String gainsLossesOnNetMovementInRegulatoryDeferralAccountBalancesRelatedToItemsThatWillBeReclassifiedToProfitOrLossBeforeTax {get;set;} 
		public String gainsLossesOnNetMovementInRegulatoryDeferralAccountBalancesRelatedToItemsThatWillBeReclassifiedToProfitOrLossNetOfTax {get;set;} 
		public String incomeTaxRelatingToCashFlowHedgesOfOtherComprehensiveIncome {get;set;} 
		public String incomeTaxRelatingToChangeInValueOfForeignCurrencyBasisSpreadsOfOtherComprehensiveIncome {get;set;} 
		public String incomeTaxRelatingToChangeInValueOfForwardElementsOfForwardContractsOfOtherComprehensiveIncome {get;set;} 
		public String incomeTaxRelatingToChangeInValueOfTimeValueOfOptionsOfOtherComprehensiveIncome {get;set;} 
		public String incomeTaxRelatingToChangesInFairValueOfFinancialLiabilityAttributableToChangeInCreditRiskOfLiabilityOfOtherComprehensiveIncome {get;set;} 
		public String incomeTaxRelatingToChangesInRevaluationSurplusOfOtherComprehensiveIncome {get;set;} 
		public String incomeTaxRelatingToExchangeDifferencesOnTranslationOfOtherComprehensiveIncome {get;set;} 
		public String incomeTaxRelatingToFinancialAssetsMeasuredAtFairValueThroughOtherComprehensiveIncome {get;set;} 
		public String incomeTaxRelatingToHedgesOfInvestmentsInEquityInstrumentsOfOtherComprehensiveIncome {get;set;} 
		public String incomeTaxRelatingToHedgesOfNetInvestmentsInForeignOperationsOfOtherComprehensiveIncome {get;set;} 
		public String incomeTaxRelatingToInvestmentsInEquityInstrumentsOfOtherComprehensiveIncome {get;set;} 
		public String incomeTaxRelatingToRemeasurementsOfDefinedBenefitPlansOfOtherComprehensiveIncome {get;set;} 
		public String incomeTaxRelatingToShareOfOtherComprehensiveIncomeOfAssociatesAndJointVenturesAccountedForUsingEquityMethodThatWillBeReclassifiedToProfitOrLoss {get;set;} 
		public String incomeTaxRelatingToShareOfOtherComprehensiveIncomeOfAssociatesAndJointVenturesAccountedForUsingEquityMethodThatWillNotBeReclassifiedToProfitOrLoss {get;set;} 
		public String otherComprehensiveIncomeAttributableToOtherComprehensiveIncomeAttributableToNoncontrollingInterests {get;set;} 
		public String otherComprehensiveIncomeAttributableToOtherComprehensiveIncomeAttributableToOwnersOfParent {get;set;} 
		public Double otherComprehensiveIncomeAttributableToTotalComprehensiveIncome {get;set;} 
		public String otherComprehensiveIncomeBeforeTaxChangeInFairValueOfFinancialLiabilityAttributableToChangeInCreditRiskOfLiability {get;set;} 
		public String otherComprehensiveIncomeBeforeTaxDebtInstrumentThroughOtherComprehensiveIncome {get;set;} 
		public String otherComprehensiveIncomeBeforeTaxGainsLossesFromInvestmentsInEquityInstruments {get;set;} 
		public String otherComprehensiveIncomeBeforeTaxGainsLossesOnHedgingInstrumentsThatHedgeInvestmentsInEquityInstruments {get;set;} 
		public String otherComprehensiveIncomeBeforeTaxGainsLossesOnRemeasurementsOfDefinedBenefitPlans {get;set;} 
		public String otherComprehensiveIncomeBeforeTaxGainsLossesOnRevaluation {get;set;} 
		public String otherComprehensiveIncomeBeforeTaxNetMovementInRegulatoryDeferralAccountBalancesRelatedToItemsThatWillBeReclassifiedToProfitOrLossAbstract {get;set;} 
		public String otherComprehensiveIncomeBeforeTaxNetMovementInRegulatoryDeferralAccountBalancesRelatedToItemsThatWillNotBeReclassifiedToProfitOrLoss {get;set;} 
		public String otherComprehensiveIncomeNetOfTaxChangeInFairValueOfFinancialLiabilityAttributableToChangeInCreditRiskOfLiability {get;set;} 
		public Double otherComprehensiveIncomeNetOfTaxDebtInstrumentThroughOtherComprehensiveIncome {get;set;} 
		public String otherComprehensiveIncomeNetOfTaxGainsLossesFromInvestmentsInEquityInstruments {get;set;} 
		public String otherComprehensiveIncomeNetOfTaxGainsLossesOnHedgingInstrumentsThatHedgeInvestmentsInEquityInstruments {get;set;} 
		public String otherComprehensiveIncomeNetOfTaxGainsLossesOnRemeasurementsOfDefinedBenefitPlans {get;set;} 
		public String otherComprehensiveIncomeNetOfTaxGainsLossesOnRevaluation {get;set;} 
		public String otherComprehensiveIncomeNetOfTaxNetMovementInRegulatoryDeferralAccountBalancesRelatedToItemsThatWillNotBeReclassifiedToProfitOrLoss {get;set;} 
		public String otherComprehensiveIncomeNetOfTaxOtherComprehensiveIncomeAttributableToOwnersOfParent {get;set;} 
		public Double otherComprehensiveIncomeNetOfTaxTotalComprehensiveIncome {get;set;} 
		public String otherComprehensiveIncomeNetOfTaxotherComprehensiveIncomeAttributableToNoncontrollingInterests {get;set;} 
		public String otherComprehensiveIncomeThatWillBeReclassifiedToProfitOrLossBeforeTaxOthers {get;set;} 
		public Double otherComprehensiveIncomeThatWillBeReclassifiedToProfitOrLossNetOfTax {get;set;} 
		public String otherComprehensiveIncomeThatWillNotBeReclassifiedToProfitOrLossBeforeTax {get;set;} 
		public String otherComprehensiveIncomeThatWillNotBeReclassifiedToProfitOrLossBeforeTaxOthers {get;set;} 
		public Double otherIncomeComprehensiveThatWillNotBeReclassifiedToProfitOrLossNetOfTaxOthers {get;set;} 
		public String othersIncomeTaxRelatingToComponentsOfOtherComprehensiveIncomeThatWillBeReclassifiedToProfitOrLoss {get;set;} 
		public String othersIncomeTaxRelatingToComponentsOfOtherComprehensiveIncomeThatWillNotBeReclassifiedToProfitOrLoss {get;set;} 
		public String preTaxGainOrLossRecognisedOnDisposalOfAssetsOrSettlementOfLiabilitiesAttributableToDiscontinuedOperations {get;set;} 
		public String reclassificationAdjustmentsOnCashFlowHedgesBeforeTax {get;set;} 
		public String reclassificationAdjustmentsOnCashFlowHedgesNetOfTax {get;set;} 
		public String reclassificationAdjustmentsOnChangeInValueOfForeignCurrencyBasisSpreadsBeforeTax {get;set;} 
		public String reclassificationAdjustmentsOnChangeInValueOfForeignCurrencyBasisSpreadsNetOfTax {get;set;} 
		public String reclassificationAdjustmentsOnChangeInValueOfForwardElementsOfForwardContractsBeforeTax {get;set;} 
		public String reclassificationAdjustmentsOnChangeInValueOfForwardElementsOfForwardContractsNetOfTax {get;set;} 
		public String reclassificationAdjustmentsOnChangeInValueOfTimeValueOfOptionsBeforeTax {get;set;} 
		public String reclassificationAdjustmentsOnChangeInValueOfTimeValueOfOptionsNetOfTax {get;set;} 
		public String reclassificationAdjustmentsOnDebtInstrumentThroughOtherComprehensiveIncomeBeforeTax {get;set;} 
		public String reclassificationAdjustmentsOnDebtInstrumentThroughOtherComprehensiveIncomeNetOfTax {get;set;} 
		public String reclassificationAdjustmentsOnExchangeDifferencesOnTranslationBeforeTax {get;set;} 
		public String reclassificationAdjustmentsOnExchangeDifferencesOnTranslationNetOfTax {get;set;} 
		public String reclassificationAdjustmentsOnFinancialAssetsMeasuredAtFairValueThroughOtherComprehensiveIncomeBeforeTax {get;set;} 
		public String reclassificationAdjustmentsOnFinancialAssetsMeasuredAtFairValueThroughOtherComprehensiveIncomeNetOfTax {get;set;} 
		public String reclassificationAdjustmentsOnHedgesOfNetInvestmentsInForeignOperationsBeforeTax {get;set;} 
		public String reclassificationAdjustmentsOnHedgesOfNetInvestmentsInForeignOperationsNetOfTax {get;set;} 
		public String reclassificationAdjustmentsOnNetMovementInRegulatoryDeferralAccountBalancesBeforeTax {get;set;} 
		public String reclassificationAdjustmentsOnNetMovementInRegulatoryDeferralAccountBalancesNetOfTax {get;set;} 
		public String shareOfOtherComprehensiveIncomeOfAssociatesAndJointVenturesAccountedForUsingEquityMethodThatWillBeReclassifiedToProfitOrLossBeforeTax {get;set;} 
		public String shareOfOtherComprehensiveIncomeOfAssociatesAndJointVenturesAccountedForUsingEquityMethodThatWillBeReclassifiedToProfitOrLossNetOfTax {get;set;} 
		public String shareOfOtherComprehensiveIncomeOfAssociatesAndJointVenturesAccountedForUsingEquityMethodThatWillNotBeReclassifiedToProfitOrLossBeforeTax {get;set;} 
		public String shareOfOtherComprehensiveIncomeOfAssociatesAndJointVenturesAccountedForUsingEquityMethodThatWillNotBeReclassifiedToProfitOrLossNetOfTax {get;set;} 
		public String shareOfProfitLossOfAssociatesAndJointVenturesAccountedForUsingEquityMethod {get;set;} 
		public Double totalOtherComprehensiveIncome {get;set;} 
		public String totalOtherComprehensiveIncomeBeforeTax {get;set;} 
		public String totalOtherComprehensiveIncomeBeforeTaxCashFlowHedges {get;set;} 
		public String totalOtherComprehensiveIncomeBeforeTaxChangeInValueOfForeignCurrencyBasisSpreads {get;set;} 
		public String totalOtherComprehensiveIncomeBeforeTaxChangeInValueOfForwardElementsOfForwardContracts {get;set;} 
		public String totalOtherComprehensiveIncomeBeforeTaxChangeInValueOfTimeValueOfOptions {get;set;} 
		public String totalOtherComprehensiveIncomeBeforeTaxExchangeDifferencesOnTranslation {get;set;} 
		public String totalOtherComprehensiveIncomeBeforeTaxFinancialAssetsMeasuredAtFairValueThroughOtherComprehensiveIncome {get;set;} 
		public String totalOtherComprehensiveIncomeBeforeTaxHedgesOfNetInvestmentsInForeignOperations {get;set;} 
		public String totalOtherComprehensiveIncomeBeforeTaxNetMovementInRegulatoryDeferralAccountBalancesRelatedToItemsThatWillBeReclassifiedToProfitOrLoss {get;set;} 
		public Double totalOtherComprehensiveIncomeNetOfTaxCashFlowHedges {get;set;} 
		public Double totalOtherComprehensiveIncomeNetOfTaxChangeInValueOfForeignCurrencyBasisSpreads {get;set;} 
		public Double totalOtherComprehensiveIncomeNetOfTaxChangeInValueOfForwardElementsOfForwardContracts {get;set;} 
		public Double totalOtherComprehensiveIncomeNetOfTaxChangeInValueOfTimeValueOfOptions {get;set;} 
		public Double totalOtherComprehensiveIncomeNetOfTaxExchangeDifferencesOnTranslation {get;set;} 
		public Double totalOtherComprehensiveIncomeNetOfTaxFinancialAssetsMeasuredAtFairValueThroughOtherComprehensiveIncome {get;set;} 
		public Double totalOtherComprehensiveIncomeNetOfTaxHedgesOfNetInvestmentsInForeignOperations {get;set;} 
		public Double totalOtherComprehensiveIncomeNetOfTaxNetMovementInRegulatoryDeferralAccountBalancesRelatedToItemsThatWillBeReclassifiedToProfitOrLoss {get;set;} 
		public String totalOtherComprehensiveIncomeThatWillBeReclassifiedToProfitOrLossBeforeTax {get;set;} 
		public Double totalOtherComprehensiveIncomeThatWillBeReclassifiedToProfitOrLossNetOfTax {get;set;} 
		public Double totalOtherComprehensiveIncomeThatWillNotBeReclassifiedToProfitOrLossNetOfTax {get;set;} 
		public Boolean whetherCompanyHasOtherComprehensiveIncomeOCIComponentsPresentedBeforeTax {get;set;} 
		public Boolean whetherCompanyHasOtherComprehensiveIncomeOCIComponentsPresentedNetOfTax {get;set;} 

		public OtherComprehensiveIncome(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'aggregatedIncomeTaxRelatingToComponentsOfOtherComprehensiveIncomeThatWillBeReclassifiedToProfitOrLoss') {
							aggregatedIncomeTaxRelatingToComponentsOfOtherComprehensiveIncomeThatWillBeReclassifiedToProfitOrLoss = parser.getText();
						} else if (text == 'aggregatedIncomeTaxRelatingToComponentsOfOtherComprehensiveIncomeThatWillNotBeReclassifiedToProfitOrLoss') {
							aggregatedIncomeTaxRelatingToComponentsOfOtherComprehensiveIncomeThatWillNotBeReclassifiedToProfitOrLoss = parser.getText();
						} else if (text == 'amountsRemovedFromEquityAndAdjustedAgainstFairValueOfFinancialAssetsOnReclassificationOutOfFairValueThroughOtherComprehensiveIncomeMeasurementCategoryBeforeTax') {
							amountsRemovedFromEquityAndAdjustedAgainstFairValueOfFinancialAssetsOnReclassificationOutOfFairValueThroughOtherComprehensiveIncomeMeasurementCategoryBeforeTax = parser.getText();
						} else if (text == 'amountsRemovedFromEquityAndAdjustedAgainstFairValueOfFinancialAssetsOnReclassificationOutOfFairValueThroughOtherComprehensiveIncomeMeasurementCategoryNetOfTax') {
							amountsRemovedFromEquityAndAdjustedAgainstFairValueOfFinancialAssetsOnReclassificationOutOfFairValueThroughOtherComprehensiveIncomeMeasurementCategoryNetOfTax = parser.getText();
						} else if (text == 'amountsRemovedFromEquityAndIncludedInCarryingAmountOfNonFinancialAssetLiabilityWhoseAcquisitionOrIncurrenceWasHedgedHighlyProbableForecastTransactionNetOfTax') {
							amountsRemovedFromEquityAndIncludedInCarryingAmountOfNonFinancialAssetLiabilityWhoseAcquisitionOrIncurrenceWasHedgedHighlyProbableForecastTransactionNetOfTax = parser.getText();
						} else if (text == 'amountsRemovedFromEquityAndIncludedInCarryingAmountOfNonfinancialAssetsLiabilityWhoseAcquisitionOrIncurrenceWasHedgedHighlyProbableForecastTransactionBeforeTax') {
							amountsRemovedFromEquityAndIncludedInCarryingAmountOfNonfinancialAssetsLiabilityWhoseAcquisitionOrIncurrenceWasHedgedHighlyProbableForecastTransactionBeforeTax = parser.getText();
						} else if (text == 'comprehensiveIncomeAttributableToComprehensiveIncomeAttributableToNonControllingInterests') {
							comprehensiveIncomeAttributableToComprehensiveIncomeAttributableToNonControllingInterests = parser.getText();
						} else if (text == 'comprehensiveIncomeAttributableToComprehensiveIncomeAttributableToOwnersOfParent') {
							comprehensiveIncomeAttributableToComprehensiveIncomeAttributableToOwnersOfParent = parser.getText();
						} else if (text == 'comprehensiveIncomeAttributableToNetOfTaxComprehensiveIncomeAttributableToNoncontrollingInterests') {
							comprehensiveIncomeAttributableToNetOfTaxComprehensiveIncomeAttributableToNoncontrollingInterests = parser.getText();
						} else if (text == 'comprehensiveIncomeAttributableToNetOfTaxComprehensiveIncomeAttributableToOwnersOfParent') {
							comprehensiveIncomeAttributableToNetOfTaxComprehensiveIncomeAttributableToOwnersOfParent = parser.getText();
						} else if (text == 'gainsLossesOnCashFlowHedgesNetOfTax') {
							gainsLossesOnCashFlowHedgesNetOfTax = parser.getText();
						} else if (text == 'gainsLossesOnChangeInValueOfForeignCurrencyBasisSpreadsBeforeTax') {
							gainsLossesOnChangeInValueOfForeignCurrencyBasisSpreadsBeforeTax = parser.getText();
						} else if (text == 'gainsLossesOnChangeInValueOfForeignCurrencyBasisSpreadsNetOfTax') {
							gainsLossesOnChangeInValueOfForeignCurrencyBasisSpreadsNetOfTax = parser.getText();
						} else if (text == 'gainsLossesOnChangeInValueOfForwardElementsOfForwardContractsBeforeTax') {
							gainsLossesOnChangeInValueOfForwardElementsOfForwardContractsBeforeTax = parser.getText();
						} else if (text == 'gainsLossesOnChangeInValueOfForwardElementsOfForwardContractsNetOfTax') {
							gainsLossesOnChangeInValueOfForwardElementsOfForwardContractsNetOfTax = parser.getText();
						} else if (text == 'gainsLossesOnChangeInValueOfTimeValueOfOptionsBeforeTax') {
							gainsLossesOnChangeInValueOfTimeValueOfOptionsBeforeTax = parser.getText();
						} else if (text == 'gainsLossesOnChangeInValueOfTimeValueOfOptionsNetOfTax') {
							gainsLossesOnChangeInValueOfTimeValueOfOptionsNetOfTax = parser.getText();
						} else if (text == 'gainsLossesOnDebtInstrumentThroughOtherComprehensiveIncomeBeforeTax') {
							gainsLossesOnDebtInstrumentThroughOtherComprehensiveIncomeBeforeTax = parser.getText();
						} else if (text == 'gainsLossesOnDebtInstrumentThroughOtherComprehensiveIncomeNetOfTax') {
							gainsLossesOnDebtInstrumentThroughOtherComprehensiveIncomeNetOfTax = parser.getText();
						} else if (text == 'gainsLossesOnExchangeDifferencesOnTranslationBeforeTax') {
							gainsLossesOnExchangeDifferencesOnTranslationBeforeTax = parser.getText();
						} else if (text == 'gainsLossesOnExchangeDifferencesOnTranslationNetOfTax') {
							gainsLossesOnExchangeDifferencesOnTranslationNetOfTax = parser.getText();
						} else if (text == 'gainsLossesOnFinancialAssetsMeasuredAtFairValueThroughOtherComprehensiveIncomeBeforeTax') {
							gainsLossesOnFinancialAssetsMeasuredAtFairValueThroughOtherComprehensiveIncomeBeforeTax = parser.getText();
						} else if (text == 'gainsLossesOnFinancialAssetsMeasuredAtFairValueThroughOtherComprehensiveIncomeNetOfTax') {
							gainsLossesOnFinancialAssetsMeasuredAtFairValueThroughOtherComprehensiveIncomeNetOfTax = parser.getText();
						} else if (text == 'gainsLossesOnHedgesOfNetInvestmentsInForeignOperationsBeforeTax') {
							gainsLossesOnHedgesOfNetInvestmentsInForeignOperationsBeforeTax = parser.getText();
						} else if (text == 'gainsLossesOnHedgesOfNetInvestmentsInForeignOperationsNetOfTax') {
							gainsLossesOnHedgesOfNetInvestmentsInForeignOperationsNetOfTax = parser.getText();
						} else if (text == 'gainsLossesOnNetMovementInRegulatoryDeferralAccountBalancesRelatedToItemsThatWillBeReclassifiedToProfitOrLossBeforeTax') {
							gainsLossesOnNetMovementInRegulatoryDeferralAccountBalancesRelatedToItemsThatWillBeReclassifiedToProfitOrLossBeforeTax = parser.getText();
						} else if (text == 'gainsLossesOnNetMovementInRegulatoryDeferralAccountBalancesRelatedToItemsThatWillBeReclassifiedToProfitOrLossNetOfTax') {
							gainsLossesOnNetMovementInRegulatoryDeferralAccountBalancesRelatedToItemsThatWillBeReclassifiedToProfitOrLossNetOfTax = parser.getText();
						} else if (text == 'incomeTaxRelatingToCashFlowHedgesOfOtherComprehensiveIncome') {
							incomeTaxRelatingToCashFlowHedgesOfOtherComprehensiveIncome = parser.getText();
						} else if (text == 'incomeTaxRelatingToChangeInValueOfForeignCurrencyBasisSpreadsOfOtherComprehensiveIncome') {
							incomeTaxRelatingToChangeInValueOfForeignCurrencyBasisSpreadsOfOtherComprehensiveIncome = parser.getText();
						} else if (text == 'incomeTaxRelatingToChangeInValueOfForwardElementsOfForwardContractsOfOtherComprehensiveIncome') {
							incomeTaxRelatingToChangeInValueOfForwardElementsOfForwardContractsOfOtherComprehensiveIncome = parser.getText();
						} else if (text == 'incomeTaxRelatingToChangeInValueOfTimeValueOfOptionsOfOtherComprehensiveIncome') {
							incomeTaxRelatingToChangeInValueOfTimeValueOfOptionsOfOtherComprehensiveIncome = parser.getText();
						} else if (text == 'incomeTaxRelatingToChangesInFairValueOfFinancialLiabilityAttributableToChangeInCreditRiskOfLiabilityOfOtherComprehensiveIncome') {
							incomeTaxRelatingToChangesInFairValueOfFinancialLiabilityAttributableToChangeInCreditRiskOfLiabilityOfOtherComprehensiveIncome = parser.getText();
						} else if (text == 'incomeTaxRelatingToChangesInRevaluationSurplusOfOtherComprehensiveIncome') {
							incomeTaxRelatingToChangesInRevaluationSurplusOfOtherComprehensiveIncome = parser.getText();
						} else if (text == 'incomeTaxRelatingToExchangeDifferencesOnTranslationOfOtherComprehensiveIncome') {
							incomeTaxRelatingToExchangeDifferencesOnTranslationOfOtherComprehensiveIncome = parser.getText();
						} else if (text == 'incomeTaxRelatingToFinancialAssetsMeasuredAtFairValueThroughOtherComprehensiveIncome') {
							incomeTaxRelatingToFinancialAssetsMeasuredAtFairValueThroughOtherComprehensiveIncome = parser.getText();
						} else if (text == 'incomeTaxRelatingToHedgesOfInvestmentsInEquityInstrumentsOfOtherComprehensiveIncome') {
							incomeTaxRelatingToHedgesOfInvestmentsInEquityInstrumentsOfOtherComprehensiveIncome = parser.getText();
						} else if (text == 'incomeTaxRelatingToHedgesOfNetInvestmentsInForeignOperationsOfOtherComprehensiveIncome') {
							incomeTaxRelatingToHedgesOfNetInvestmentsInForeignOperationsOfOtherComprehensiveIncome = parser.getText();
						} else if (text == 'incomeTaxRelatingToInvestmentsInEquityInstrumentsOfOtherComprehensiveIncome') {
							incomeTaxRelatingToInvestmentsInEquityInstrumentsOfOtherComprehensiveIncome = parser.getText();
						} else if (text == 'incomeTaxRelatingToRemeasurementsOfDefinedBenefitPlansOfOtherComprehensiveIncome') {
							incomeTaxRelatingToRemeasurementsOfDefinedBenefitPlansOfOtherComprehensiveIncome = parser.getText();
						} else if (text == 'incomeTaxRelatingToShareOfOtherComprehensiveIncomeOfAssociatesAndJointVenturesAccountedForUsingEquityMethodThatWillBeReclassifiedToProfitOrLoss') {
							incomeTaxRelatingToShareOfOtherComprehensiveIncomeOfAssociatesAndJointVenturesAccountedForUsingEquityMethodThatWillBeReclassifiedToProfitOrLoss = parser.getText();
						} else if (text == 'incomeTaxRelatingToShareOfOtherComprehensiveIncomeOfAssociatesAndJointVenturesAccountedForUsingEquityMethodThatWillNotBeReclassifiedToProfitOrLoss') {
							incomeTaxRelatingToShareOfOtherComprehensiveIncomeOfAssociatesAndJointVenturesAccountedForUsingEquityMethodThatWillNotBeReclassifiedToProfitOrLoss = parser.getText();
						} else if (text == 'otherComprehensiveIncomeAttributableToOtherComprehensiveIncomeAttributableToNoncontrollingInterests') {
							otherComprehensiveIncomeAttributableToOtherComprehensiveIncomeAttributableToNoncontrollingInterests = parser.getText();
						} else if (text == 'otherComprehensiveIncomeAttributableToOtherComprehensiveIncomeAttributableToOwnersOfParent') {
							otherComprehensiveIncomeAttributableToOtherComprehensiveIncomeAttributableToOwnersOfParent = parser.getText();
						} else if (text == 'otherComprehensiveIncomeAttributableToTotalComprehensiveIncome') {
							otherComprehensiveIncomeAttributableToTotalComprehensiveIncome = parser.getDoubleValue();
						} else if (text == 'otherComprehensiveIncomeBeforeTaxChangeInFairValueOfFinancialLiabilityAttributableToChangeInCreditRiskOfLiability') {
							otherComprehensiveIncomeBeforeTaxChangeInFairValueOfFinancialLiabilityAttributableToChangeInCreditRiskOfLiability = parser.getText();
						} else if (text == 'otherComprehensiveIncomeBeforeTaxDebtInstrumentThroughOtherComprehensiveIncome') {
							otherComprehensiveIncomeBeforeTaxDebtInstrumentThroughOtherComprehensiveIncome = parser.getText();
						} else if (text == 'otherComprehensiveIncomeBeforeTaxGainsLossesFromInvestmentsInEquityInstruments') {
							otherComprehensiveIncomeBeforeTaxGainsLossesFromInvestmentsInEquityInstruments = parser.getText();
						} else if (text == 'otherComprehensiveIncomeBeforeTaxGainsLossesOnHedgingInstrumentsThatHedgeInvestmentsInEquityInstruments') {
							otherComprehensiveIncomeBeforeTaxGainsLossesOnHedgingInstrumentsThatHedgeInvestmentsInEquityInstruments = parser.getText();
						} else if (text == 'otherComprehensiveIncomeBeforeTaxGainsLossesOnRemeasurementsOfDefinedBenefitPlans') {
							otherComprehensiveIncomeBeforeTaxGainsLossesOnRemeasurementsOfDefinedBenefitPlans = parser.getText();
						} else if (text == 'otherComprehensiveIncomeBeforeTaxGainsLossesOnRevaluation') {
							otherComprehensiveIncomeBeforeTaxGainsLossesOnRevaluation = parser.getText();
						} else if (text == 'otherComprehensiveIncomeBeforeTaxNetMovementInRegulatoryDeferralAccountBalancesRelatedToItemsThatWillBeReclassifiedToProfitOrLossAbstract') {
							otherComprehensiveIncomeBeforeTaxNetMovementInRegulatoryDeferralAccountBalancesRelatedToItemsThatWillBeReclassifiedToProfitOrLossAbstract = parser.getText();
						} else if (text == 'otherComprehensiveIncomeBeforeTaxNetMovementInRegulatoryDeferralAccountBalancesRelatedToItemsThatWillNotBeReclassifiedToProfitOrLoss') {
							otherComprehensiveIncomeBeforeTaxNetMovementInRegulatoryDeferralAccountBalancesRelatedToItemsThatWillNotBeReclassifiedToProfitOrLoss = parser.getText();
						} else if (text == 'otherComprehensiveIncomeNetOfTaxChangeInFairValueOfFinancialLiabilityAttributableToChangeInCreditRiskOfLiability') {
							otherComprehensiveIncomeNetOfTaxChangeInFairValueOfFinancialLiabilityAttributableToChangeInCreditRiskOfLiability = parser.getText();
						} else if (text == 'otherComprehensiveIncomeNetOfTaxDebtInstrumentThroughOtherComprehensiveIncome') {
							otherComprehensiveIncomeNetOfTaxDebtInstrumentThroughOtherComprehensiveIncome = parser.getDoubleValue();
						} else if (text == 'otherComprehensiveIncomeNetOfTaxGainsLossesFromInvestmentsInEquityInstruments') {
							otherComprehensiveIncomeNetOfTaxGainsLossesFromInvestmentsInEquityInstruments = parser.getText();
						} else if (text == 'otherComprehensiveIncomeNetOfTaxGainsLossesOnHedgingInstrumentsThatHedgeInvestmentsInEquityInstruments') {
							otherComprehensiveIncomeNetOfTaxGainsLossesOnHedgingInstrumentsThatHedgeInvestmentsInEquityInstruments = parser.getText();
						} else if (text == 'otherComprehensiveIncomeNetOfTaxGainsLossesOnRemeasurementsOfDefinedBenefitPlans') {
							otherComprehensiveIncomeNetOfTaxGainsLossesOnRemeasurementsOfDefinedBenefitPlans = parser.getText();
						} else if (text == 'otherComprehensiveIncomeNetOfTaxGainsLossesOnRevaluation') {
							otherComprehensiveIncomeNetOfTaxGainsLossesOnRevaluation = parser.getText();
						} else if (text == 'otherComprehensiveIncomeNetOfTaxNetMovementInRegulatoryDeferralAccountBalancesRelatedToItemsThatWillNotBeReclassifiedToProfitOrLoss') {
							otherComprehensiveIncomeNetOfTaxNetMovementInRegulatoryDeferralAccountBalancesRelatedToItemsThatWillNotBeReclassifiedToProfitOrLoss = parser.getText();
						} else if (text == 'otherComprehensiveIncomeNetOfTaxOtherComprehensiveIncomeAttributableToOwnersOfParent') {
							otherComprehensiveIncomeNetOfTaxOtherComprehensiveIncomeAttributableToOwnersOfParent = parser.getText();
						} else if (text == 'otherComprehensiveIncomeNetOfTaxTotalComprehensiveIncome') {
							otherComprehensiveIncomeNetOfTaxTotalComprehensiveIncome = parser.getDoubleValue();
						} else if (text == 'otherComprehensiveIncomeNetOfTaxotherComprehensiveIncomeAttributableToNoncontrollingInterests') {
							otherComprehensiveIncomeNetOfTaxotherComprehensiveIncomeAttributableToNoncontrollingInterests = parser.getText();
						} else if (text == 'otherComprehensiveIncomeThatWillBeReclassifiedToProfitOrLossBeforeTaxOthers') {
							otherComprehensiveIncomeThatWillBeReclassifiedToProfitOrLossBeforeTaxOthers = parser.getText();
						} else if (text == 'otherComprehensiveIncomeThatWillBeReclassifiedToProfitOrLossNetOfTax') {
							otherComprehensiveIncomeThatWillBeReclassifiedToProfitOrLossNetOfTax = parser.getDoubleValue();
						} else if (text == 'otherComprehensiveIncomeThatWillNotBeReclassifiedToProfitOrLossBeforeTax') {
							otherComprehensiveIncomeThatWillNotBeReclassifiedToProfitOrLossBeforeTax = parser.getText();
						} else if (text == 'otherComprehensiveIncomeThatWillNotBeReclassifiedToProfitOrLossBeforeTaxOthers') {
							otherComprehensiveIncomeThatWillNotBeReclassifiedToProfitOrLossBeforeTaxOthers = parser.getText();
						} else if (text == 'otherIncomeComprehensiveThatWillNotBeReclassifiedToProfitOrLossNetOfTaxOthers') {
							otherIncomeComprehensiveThatWillNotBeReclassifiedToProfitOrLossNetOfTaxOthers = parser.getDoubleValue();
						} else if (text == 'othersIncomeTaxRelatingToComponentsOfOtherComprehensiveIncomeThatWillBeReclassifiedToProfitOrLoss') {
							othersIncomeTaxRelatingToComponentsOfOtherComprehensiveIncomeThatWillBeReclassifiedToProfitOrLoss = parser.getText();
						} else if (text == 'othersIncomeTaxRelatingToComponentsOfOtherComprehensiveIncomeThatWillNotBeReclassifiedToProfitOrLoss') {
							othersIncomeTaxRelatingToComponentsOfOtherComprehensiveIncomeThatWillNotBeReclassifiedToProfitOrLoss = parser.getText();
						} else if (text == 'preTaxGainOrLossRecognisedOnDisposalOfAssetsOrSettlementOfLiabilitiesAttributableToDiscontinuedOperations') {
							preTaxGainOrLossRecognisedOnDisposalOfAssetsOrSettlementOfLiabilitiesAttributableToDiscontinuedOperations = parser.getText();
						} else if (text == 'reclassificationAdjustmentsOnCashFlowHedgesBeforeTax') {
							reclassificationAdjustmentsOnCashFlowHedgesBeforeTax = parser.getText();
						} else if (text == 'reclassificationAdjustmentsOnCashFlowHedgesNetOfTax') {
							reclassificationAdjustmentsOnCashFlowHedgesNetOfTax = parser.getText();
						} else if (text == 'reclassificationAdjustmentsOnChangeInValueOfForeignCurrencyBasisSpreadsBeforeTax') {
							reclassificationAdjustmentsOnChangeInValueOfForeignCurrencyBasisSpreadsBeforeTax = parser.getText();
						} else if (text == 'reclassificationAdjustmentsOnChangeInValueOfForeignCurrencyBasisSpreadsNetOfTax') {
							reclassificationAdjustmentsOnChangeInValueOfForeignCurrencyBasisSpreadsNetOfTax = parser.getText();
						} else if (text == 'reclassificationAdjustmentsOnChangeInValueOfForwardElementsOfForwardContractsBeforeTax') {
							reclassificationAdjustmentsOnChangeInValueOfForwardElementsOfForwardContractsBeforeTax = parser.getText();
						} else if (text == 'reclassificationAdjustmentsOnChangeInValueOfForwardElementsOfForwardContractsNetOfTax') {
							reclassificationAdjustmentsOnChangeInValueOfForwardElementsOfForwardContractsNetOfTax = parser.getText();
						} else if (text == 'reclassificationAdjustmentsOnChangeInValueOfTimeValueOfOptionsBeforeTax') {
							reclassificationAdjustmentsOnChangeInValueOfTimeValueOfOptionsBeforeTax = parser.getText();
						} else if (text == 'reclassificationAdjustmentsOnChangeInValueOfTimeValueOfOptionsNetOfTax') {
							reclassificationAdjustmentsOnChangeInValueOfTimeValueOfOptionsNetOfTax = parser.getText();
						} else if (text == 'reclassificationAdjustmentsOnDebtInstrumentThroughOtherComprehensiveIncomeBeforeTax') {
							reclassificationAdjustmentsOnDebtInstrumentThroughOtherComprehensiveIncomeBeforeTax = parser.getText();
						} else if (text == 'reclassificationAdjustmentsOnDebtInstrumentThroughOtherComprehensiveIncomeNetOfTax') {
							reclassificationAdjustmentsOnDebtInstrumentThroughOtherComprehensiveIncomeNetOfTax = parser.getText();
						} else if (text == 'reclassificationAdjustmentsOnExchangeDifferencesOnTranslationBeforeTax') {
							reclassificationAdjustmentsOnExchangeDifferencesOnTranslationBeforeTax = parser.getText();
						} else if (text == 'reclassificationAdjustmentsOnExchangeDifferencesOnTranslationNetOfTax') {
							reclassificationAdjustmentsOnExchangeDifferencesOnTranslationNetOfTax = parser.getText();
						} else if (text == 'reclassificationAdjustmentsOnFinancialAssetsMeasuredAtFairValueThroughOtherComprehensiveIncomeBeforeTax') {
							reclassificationAdjustmentsOnFinancialAssetsMeasuredAtFairValueThroughOtherComprehensiveIncomeBeforeTax = parser.getText();
						} else if (text == 'reclassificationAdjustmentsOnFinancialAssetsMeasuredAtFairValueThroughOtherComprehensiveIncomeNetOfTax') {
							reclassificationAdjustmentsOnFinancialAssetsMeasuredAtFairValueThroughOtherComprehensiveIncomeNetOfTax = parser.getText();
						} else if (text == 'reclassificationAdjustmentsOnHedgesOfNetInvestmentsInForeignOperationsBeforeTax') {
							reclassificationAdjustmentsOnHedgesOfNetInvestmentsInForeignOperationsBeforeTax = parser.getText();
						} else if (text == 'reclassificationAdjustmentsOnHedgesOfNetInvestmentsInForeignOperationsNetOfTax') {
							reclassificationAdjustmentsOnHedgesOfNetInvestmentsInForeignOperationsNetOfTax = parser.getText();
						} else if (text == 'reclassificationAdjustmentsOnNetMovementInRegulatoryDeferralAccountBalancesBeforeTax') {
							reclassificationAdjustmentsOnNetMovementInRegulatoryDeferralAccountBalancesBeforeTax = parser.getText();
						} else if (text == 'reclassificationAdjustmentsOnNetMovementInRegulatoryDeferralAccountBalancesNetOfTax') {
							reclassificationAdjustmentsOnNetMovementInRegulatoryDeferralAccountBalancesNetOfTax = parser.getText();
						} else if (text == 'shareOfOtherComprehensiveIncomeOfAssociatesAndJointVenturesAccountedForUsingEquityMethodThatWillBeReclassifiedToProfitOrLossBeforeTax') {
							shareOfOtherComprehensiveIncomeOfAssociatesAndJointVenturesAccountedForUsingEquityMethodThatWillBeReclassifiedToProfitOrLossBeforeTax = parser.getText();
						} else if (text == 'shareOfOtherComprehensiveIncomeOfAssociatesAndJointVenturesAccountedForUsingEquityMethodThatWillBeReclassifiedToProfitOrLossNetOfTax') {
							shareOfOtherComprehensiveIncomeOfAssociatesAndJointVenturesAccountedForUsingEquityMethodThatWillBeReclassifiedToProfitOrLossNetOfTax = parser.getText();
						} else if (text == 'shareOfOtherComprehensiveIncomeOfAssociatesAndJointVenturesAccountedForUsingEquityMethodThatWillNotBeReclassifiedToProfitOrLossBeforeTax') {
							shareOfOtherComprehensiveIncomeOfAssociatesAndJointVenturesAccountedForUsingEquityMethodThatWillNotBeReclassifiedToProfitOrLossBeforeTax = parser.getText();
						} else if (text == 'shareOfOtherComprehensiveIncomeOfAssociatesAndJointVenturesAccountedForUsingEquityMethodThatWillNotBeReclassifiedToProfitOrLossNetOfTax') {
							shareOfOtherComprehensiveIncomeOfAssociatesAndJointVenturesAccountedForUsingEquityMethodThatWillNotBeReclassifiedToProfitOrLossNetOfTax = parser.getText();
						} else if (text == 'shareOfProfitLossOfAssociatesAndJointVenturesAccountedForUsingEquityMethod') {
							shareOfProfitLossOfAssociatesAndJointVenturesAccountedForUsingEquityMethod = parser.getText();
						} else if (text == 'totalOtherComprehensiveIncome') {
							totalOtherComprehensiveIncome = parser.getDoubleValue();
						} else if (text == 'totalOtherComprehensiveIncomeBeforeTax') {
							totalOtherComprehensiveIncomeBeforeTax = parser.getText();
						} else if (text == 'totalOtherComprehensiveIncomeBeforeTaxCashFlowHedges') {
							totalOtherComprehensiveIncomeBeforeTaxCashFlowHedges = parser.getText();
						} else if (text == 'totalOtherComprehensiveIncomeBeforeTaxChangeInValueOfForeignCurrencyBasisSpreads') {
							totalOtherComprehensiveIncomeBeforeTaxChangeInValueOfForeignCurrencyBasisSpreads = parser.getText();
						} else if (text == 'totalOtherComprehensiveIncomeBeforeTaxChangeInValueOfForwardElementsOfForwardContracts') {
							totalOtherComprehensiveIncomeBeforeTaxChangeInValueOfForwardElementsOfForwardContracts = parser.getText();
						} else if (text == 'totalOtherComprehensiveIncomeBeforeTaxChangeInValueOfTimeValueOfOptions') {
							totalOtherComprehensiveIncomeBeforeTaxChangeInValueOfTimeValueOfOptions = parser.getText();
						} else if (text == 'totalOtherComprehensiveIncomeBeforeTaxExchangeDifferencesOnTranslation') {
							totalOtherComprehensiveIncomeBeforeTaxExchangeDifferencesOnTranslation = parser.getText();
						} else if (text == 'totalOtherComprehensiveIncomeBeforeTaxFinancialAssetsMeasuredAtFairValueThroughOtherComprehensiveIncome') {
							totalOtherComprehensiveIncomeBeforeTaxFinancialAssetsMeasuredAtFairValueThroughOtherComprehensiveIncome = parser.getText();
						} else if (text == 'totalOtherComprehensiveIncomeBeforeTaxHedgesOfNetInvestmentsInForeignOperations') {
							totalOtherComprehensiveIncomeBeforeTaxHedgesOfNetInvestmentsInForeignOperations = parser.getText();
						} else if (text == 'totalOtherComprehensiveIncomeBeforeTaxNetMovementInRegulatoryDeferralAccountBalancesRelatedToItemsThatWillBeReclassifiedToProfitOrLoss') {
							totalOtherComprehensiveIncomeBeforeTaxNetMovementInRegulatoryDeferralAccountBalancesRelatedToItemsThatWillBeReclassifiedToProfitOrLoss = parser.getText();
						} else if (text == 'totalOtherComprehensiveIncomeNetOfTaxCashFlowHedges') {
							totalOtherComprehensiveIncomeNetOfTaxCashFlowHedges = parser.getDoubleValue();
						} else if (text == 'totalOtherComprehensiveIncomeNetOfTaxChangeInValueOfForeignCurrencyBasisSpreads') {
							totalOtherComprehensiveIncomeNetOfTaxChangeInValueOfForeignCurrencyBasisSpreads = parser.getDoubleValue();
						} else if (text == 'totalOtherComprehensiveIncomeNetOfTaxChangeInValueOfForwardElementsOfForwardContracts') {
							totalOtherComprehensiveIncomeNetOfTaxChangeInValueOfForwardElementsOfForwardContracts = parser.getDoubleValue();
						} else if (text == 'totalOtherComprehensiveIncomeNetOfTaxChangeInValueOfTimeValueOfOptions') {
							totalOtherComprehensiveIncomeNetOfTaxChangeInValueOfTimeValueOfOptions = parser.getDoubleValue();
						} else if (text == 'totalOtherComprehensiveIncomeNetOfTaxExchangeDifferencesOnTranslation') {
							totalOtherComprehensiveIncomeNetOfTaxExchangeDifferencesOnTranslation = parser.getDoubleValue();
						} else if (text == 'totalOtherComprehensiveIncomeNetOfTaxFinancialAssetsMeasuredAtFairValueThroughOtherComprehensiveIncome') {
							totalOtherComprehensiveIncomeNetOfTaxFinancialAssetsMeasuredAtFairValueThroughOtherComprehensiveIncome = parser.getDoubleValue();
						} else if (text == 'totalOtherComprehensiveIncomeNetOfTaxHedgesOfNetInvestmentsInForeignOperations') {
							totalOtherComprehensiveIncomeNetOfTaxHedgesOfNetInvestmentsInForeignOperations = parser.getDoubleValue();
						} else if (text == 'totalOtherComprehensiveIncomeNetOfTaxNetMovementInRegulatoryDeferralAccountBalancesRelatedToItemsThatWillBeReclassifiedToProfitOrLoss') {
							totalOtherComprehensiveIncomeNetOfTaxNetMovementInRegulatoryDeferralAccountBalancesRelatedToItemsThatWillBeReclassifiedToProfitOrLoss = parser.getDoubleValue();
						} else if (text == 'totalOtherComprehensiveIncomeThatWillBeReclassifiedToProfitOrLossBeforeTax') {
							totalOtherComprehensiveIncomeThatWillBeReclassifiedToProfitOrLossBeforeTax = parser.getText();
						} else if (text == 'totalOtherComprehensiveIncomeThatWillBeReclassifiedToProfitOrLossNetOfTax') {
							totalOtherComprehensiveIncomeThatWillBeReclassifiedToProfitOrLossNetOfTax = parser.getDoubleValue();
						} else if (text == 'totalOtherComprehensiveIncomeThatWillNotBeReclassifiedToProfitOrLossNetOfTax') {
							totalOtherComprehensiveIncomeThatWillNotBeReclassifiedToProfitOrLossNetOfTax = parser.getDoubleValue();
						} else if (text == 'whetherCompanyHasOtherComprehensiveIncomeOCIComponentsPresentedBeforeTax') {
							whetherCompanyHasOtherComprehensiveIncomeOCIComponentsPresentedBeforeTax = parser.getBooleanValue();
						} else if (text == 'whetherCompanyHasOtherComprehensiveIncomeOCIComponentsPresentedNetOfTax') {
							whetherCompanyHasOtherComprehensiveIncomeOCIComponentsPresentedNetOfTax = parser.getBooleanValue();
						} else {
							System.debug(LoggingLevel.WARN, 'OtherComprehensiveIncome consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Key_identity {
		public List<SignedAuditReport> auditorsDisclaimer {get;set;} 
		public List<String> auditorsFavourable {get;set;} 
		public List<SignedAuditReport> auditorsUnfavourable {get;set;} 
		public List<String> clauseNotApplicable {get;set;} 

		public Key_identity(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'auditorsDisclaimer') {
							auditorsDisclaimer = arrayOfSignedAuditReport(parser);
						} else if (text == 'auditorsFavourable') {
							auditorsFavourable = arrayOfString(parser);
						} else if (text == 'auditorsUnfavourable') {
							auditorsUnfavourable = arrayOfSignedAuditReport(parser);
						} else if (text == 'clauseNotApplicable') {
							clauseNotApplicable = arrayOfString(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'Key_identity consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class AuditorReport {
		public String acceptancePubD {get;set;} 
		public String accumulatedLosses {get;set;} 
		public String adequacyOfRecordsMaintainedByShareTradingCompanies {get;set;} 
		public String audRepExplntry {get;set;} 
		public List<SignedAuditReport> audiDirDetail {get;set;} 
		public String auditorsQualificationsReservationsAdverseRemarksInAuditorsReport {get;set;} 
		public String cagConductedSupplementaryTestAudit {get;set;} 
		public List<SignedAuditReport> cagsDirCommDetail {get;set;} 
		public Boolean clauseNotApplicable {get;set;} 
		public String directorsCommentOnAuditorsQualificationsReservationsAdverseRemarksInAuditorsReport {get;set;} 
		public String disclaimerRemarks {get;set;} 
		public String disclosureAboutLoansGrantedToPartiesCoveredUnderSection189OfCompaniesAct {get;set;} 
		public String disclosureEndUseOfFunds {get;set;} 
		public String disclosureInAuditorsReportRelatingToComplianceWithSection185And186OfCompaniesAct2013 {get;set;} 
		public String disclosureInAuditorsReportRelatingToDepositsAccepted {get;set;} 
		public String disclosureInAuditorsReportRelatingToLoans {get;set;} 
		public String disclosureInAuditorsReportRelatingToManagerialRemuneration {get;set;} 
		public String disclosureInAuditorsReportRelatingToNonCashTransactionsWithDirectorsOrPersonsConnectedWithHim {get;set;} 
		public String disclosureInAuditorsReportRelatingToPreferentialAllotmentOrPrivatePlacementOfSharesOrConvertibleDebentures {get;set;} 
		public String disclosureInAuditorsReportRelatingToPublicOfferAndTermLoansUsedForPurposeForWhichThoseWereRaised {get;set;} 
		public String disclosureInAuditorsReportRelatingToRegistrationUnderSection45IAOfReserveBankOfIndiaAct1934 {get;set;} 
		public String disclosureInAuditorsReportRelatingToTransactionsWithRelatedParties {get;set;} 
		public String disclosureRegardingReceiptOfLoansGranted {get;set;} 
		public String disclosureRegardingTermsOfRecoveryOfLoansGranted {get;set;} 
		public String disclosureRelatingToDisputedStatutoryDuesExplanatory {get;set;} 
		public String disclosureRelatingToPhysicalVerificationAndMaterialDiscrepanciesOfFixedAssets {get;set;} 
		public String disclosureRelatingToQuantitativeDetailsOfFixedAssets {get;set;} 
		public String disclosureRelatingToRegularityInPaymentOfUndisputedStatutoryDuesExplanatory {get;set;} 
		public String disclosureRelatingToTermsAndConditionsOfLoansGranted {get;set;} 
		public Boolean favourableRemarks {get;set;} 
		public String fixedAssets {get;set;} 
		public String fraudNoticed {get;set;} 
		public String immovableProperties {get;set;} 
		public String inventories {get;set;} 
		public Key_identity key_identity {get;set;} 
		public String loansGivenComp {get;set;} 
		public String maintenanceCr {get;set;} 
		public String nidhiCompany {get;set;} 
		public String otherComments {get;set;} 
		public String preferentialAllotments {get;set;} 
		public String provisionsUnderSpecialStatue {get;set;} 
		public String purposeAndEndUseOfMoneyRaisedThroughPublicIssues {get;set;} 
		public Boolean rbAudtrReport {get;set;} 
		public Boolean rbCompAudt {get;set;} 
		public String rbComptrlAudtr {get;set;} 
		public String rbRequisiteDis {get;set;} 
		public String repaymentOfFinancialDues {get;set;} 
		public String securitiesCreatedAgainstDebenturesIssued {get;set;} 
		public String signingOfRptsDate {get;set;} 
		public String statutoryDues {get;set;} 
		public String termLoans {get;set;} 
		public String unfavourableRemarks {get;set;} 
		public String whetherAttachedBalanceSheetHasBeenAuditedByTheAuditors {get;set;} 

		public AuditorReport(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'acceptancePubD') {
							acceptancePubD = parser.getText();
						} else if (text == 'accumulatedLosses') {
							accumulatedLosses = parser.getText();
						} else if (text == 'adequacyOfRecordsMaintainedByShareTradingCompanies') {
							adequacyOfRecordsMaintainedByShareTradingCompanies = parser.getText();
						} else if (text == 'audRepExplntry') {
							audRepExplntry = parser.getText();
						} else if (text == 'audiDirDetail') {
							audiDirDetail = arrayOfSignedAuditReport(parser);
						} else if (text == 'auditorsQualificationsReservationsAdverseRemarksInAuditorsReport') {
							auditorsQualificationsReservationsAdverseRemarksInAuditorsReport = parser.getText();
						} else if (text == 'cagConductedSupplementaryTestAudit') {
							cagConductedSupplementaryTestAudit = parser.getText();
						} else if (text == 'cagsDirCommDetail') {
							cagsDirCommDetail = arrayOfSignedAuditReport(parser);
						} else if (text == 'clauseNotApplicable') {
							clauseNotApplicable = parser.getBooleanValue();
						} else if (text == 'directorsCommentOnAuditorsQualificationsReservationsAdverseRemarksInAuditorsReport') {
							directorsCommentOnAuditorsQualificationsReservationsAdverseRemarksInAuditorsReport = parser.getText();
						} else if (text == 'disclaimerRemarks') {
							disclaimerRemarks = parser.getText();
						} else if (text == 'disclosureAboutLoansGrantedToPartiesCoveredUnderSection189OfCompaniesAct') {
							disclosureAboutLoansGrantedToPartiesCoveredUnderSection189OfCompaniesAct = parser.getText();
						} else if (text == 'disclosureEndUseOfFunds') {
							disclosureEndUseOfFunds = parser.getText();
						} else if (text == 'disclosureInAuditorsReportRelatingToComplianceWithSection185And186OfCompaniesAct2013') {
							disclosureInAuditorsReportRelatingToComplianceWithSection185And186OfCompaniesAct2013 = parser.getText();
						} else if (text == 'disclosureInAuditorsReportRelatingToDepositsAccepted') {
							disclosureInAuditorsReportRelatingToDepositsAccepted = parser.getText();
						} else if (text == 'disclosureInAuditorsReportRelatingToLoans') {
							disclosureInAuditorsReportRelatingToLoans = parser.getText();
						} else if (text == 'disclosureInAuditorsReportRelatingToManagerialRemuneration') {
							disclosureInAuditorsReportRelatingToManagerialRemuneration = parser.getText();
						} else if (text == 'disclosureInAuditorsReportRelatingToNonCashTransactionsWithDirectorsOrPersonsConnectedWithHim') {
							disclosureInAuditorsReportRelatingToNonCashTransactionsWithDirectorsOrPersonsConnectedWithHim = parser.getText();
						} else if (text == 'disclosureInAuditorsReportRelatingToPreferentialAllotmentOrPrivatePlacementOfSharesOrConvertibleDebentures') {
							disclosureInAuditorsReportRelatingToPreferentialAllotmentOrPrivatePlacementOfSharesOrConvertibleDebentures = parser.getText();
						} else if (text == 'disclosureInAuditorsReportRelatingToPublicOfferAndTermLoansUsedForPurposeForWhichThoseWereRaised') {
							disclosureInAuditorsReportRelatingToPublicOfferAndTermLoansUsedForPurposeForWhichThoseWereRaised = parser.getText();
						} else if (text == 'disclosureInAuditorsReportRelatingToRegistrationUnderSection45IAOfReserveBankOfIndiaAct1934') {
							disclosureInAuditorsReportRelatingToRegistrationUnderSection45IAOfReserveBankOfIndiaAct1934 = parser.getText();
						} else if (text == 'disclosureInAuditorsReportRelatingToTransactionsWithRelatedParties') {
							disclosureInAuditorsReportRelatingToTransactionsWithRelatedParties = parser.getText();
						} else if (text == 'disclosureRegardingReceiptOfLoansGranted') {
							disclosureRegardingReceiptOfLoansGranted = parser.getText();
						} else if (text == 'disclosureRegardingTermsOfRecoveryOfLoansGranted') {
							disclosureRegardingTermsOfRecoveryOfLoansGranted = parser.getText();
						} else if (text == 'disclosureRelatingToDisputedStatutoryDuesExplanatory') {
							disclosureRelatingToDisputedStatutoryDuesExplanatory = parser.getText();
						} else if (text == 'disclosureRelatingToPhysicalVerificationAndMaterialDiscrepanciesOfFixedAssets') {
							disclosureRelatingToPhysicalVerificationAndMaterialDiscrepanciesOfFixedAssets = parser.getText();
						} else if (text == 'disclosureRelatingToQuantitativeDetailsOfFixedAssets') {
							disclosureRelatingToQuantitativeDetailsOfFixedAssets = parser.getText();
						} else if (text == 'disclosureRelatingToRegularityInPaymentOfUndisputedStatutoryDuesExplanatory') {
							disclosureRelatingToRegularityInPaymentOfUndisputedStatutoryDuesExplanatory = parser.getText();
						} else if (text == 'disclosureRelatingToTermsAndConditionsOfLoansGranted') {
							disclosureRelatingToTermsAndConditionsOfLoansGranted = parser.getText();
						} else if (text == 'favourableRemarks') {
							favourableRemarks = parser.getBooleanValue();
						} else if (text == 'fixedAssets') {
							fixedAssets = parser.getText();
						} else if (text == 'fraudNoticed') {
							fraudNoticed = parser.getText();
						} else if (text == 'immovableProperties') {
							immovableProperties = parser.getText();
						} else if (text == 'inventories') {
							inventories = parser.getText();
						} else if (text == 'key_identity') {
							key_identity = new Key_identity(parser);
						} else if (text == 'loansGivenComp') {
							loansGivenComp = parser.getText();
						} else if (text == 'maintenanceCr') {
							maintenanceCr = parser.getText();
						} else if (text == 'nidhiCompany') {
							nidhiCompany = parser.getText();
						} else if (text == 'otherComments') {
							otherComments = parser.getText();
						} else if (text == 'preferentialAllotments') {
							preferentialAllotments = parser.getText();
						} else if (text == 'provisionsUnderSpecialStatue') {
							provisionsUnderSpecialStatue = parser.getText();
						} else if (text == 'purposeAndEndUseOfMoneyRaisedThroughPublicIssues') {
							purposeAndEndUseOfMoneyRaisedThroughPublicIssues = parser.getText();
						} else if (text == 'rbAudtrReport') {
							rbAudtrReport = parser.getBooleanValue();
						} else if (text == 'rbCompAudt') {
							rbCompAudt = parser.getBooleanValue();
						} else if (text == 'rbComptrlAudtr') {
							rbComptrlAudtr = parser.getText();
						} else if (text == 'rbRequisiteDis') {
							rbRequisiteDis = parser.getText();
						} else if (text == 'repaymentOfFinancialDues') {
							repaymentOfFinancialDues = parser.getText();
						} else if (text == 'securitiesCreatedAgainstDebenturesIssued') {
							securitiesCreatedAgainstDebenturesIssued = parser.getText();
						} else if (text == 'signingOfRptsDate') {
							signingOfRptsDate = parser.getText();
						} else if (text == 'statutoryDues') {
							statutoryDues = parser.getText();
						} else if (text == 'termLoans') {
							termLoans = parser.getText();
						} else if (text == 'unfavourableRemarks') {
							unfavourableRemarks = parser.getText();
						} else if (text == 'whetherAttachedBalanceSheetHasBeenAuditedByTheAuditors') {
							whetherAttachedBalanceSheetHasBeenAuditedByTheAuditors = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'AuditorReport consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class CashFlowsFromUsedInOperatingActivities {
		public String adjustmentsForDecreaseIncreaseInInventories {get;set;} 
		public Double adjustmentsForDecreaseIncreaseInOtherCurrentAssets {get;set;} 
		public Double adjustmentsForDecreaseIncreaseInOtherNonCurrentAssets {get;set;} 
		public String adjustmentsForDecreaseIncreaseInTradeReceivables {get;set;} 
		public String adjustmentsForDecreaseIncreaseInTradeReceivablesNoncurrent {get;set;} 
		public String adjustmentsForDepreciationAndAmortisationExpense {get;set;} 
		public String adjustmentsForDividendIncome {get;set;} 
		public String adjustmentsForFairValueGainsLosses {get;set;} 
		public Double adjustmentsForFinanceCosts {get;set;} 
		public String adjustmentsForImpairmentLossReversalOfImpairmentLossRecognisedInProfitOrLoss {get;set;} 
		public Double adjustmentsForIncreaseDecreaseInOtherCurrentLiabilities {get;set;} 
		public String adjustmentsForIncreaseDecreaseInOtherNonCurrentLiabilities {get;set;} 
		public String adjustmentsForIncreaseDecreaseInTradePayables {get;set;} 
		public String adjustmentsForIncreaseDecreaseInTradePayablesNoncurrent {get;set;} 
		public String adjustmentsForInterestIncome {get;set;} 
		public String adjustmentsForOtherBankBalances {get;set;} 
		public String adjustmentsForOtherFinancialAssetsCurrent {get;set;} 
		public String adjustmentsForOtherFinancialAssetsNoncurrent {get;set;} 
		public Double adjustmentsForOtherFinancialLiabilitiesCurrent {get;set;} 
		public String adjustmentsForOtherFinancialLiabilitiesNoncurrent {get;set;} 
		public String adjustmentsForProvisions {get;set;} 
		public String adjustmentsForProvisionsNoncurrent {get;set;} 
		public Double adjustmentsForReconcileProfitLoss {get;set;} 
		public String adjustmentsForSharebasedPayments {get;set;} 
		public String adjustmentsForUndistributedProfitsOfAssociates {get;set;} 
		public String adjustmentsForUnrealisedForeignExchangeLossesGains {get;set;} 
		public Double cashFlowsFromUsedInOperatingActivities {get;set;} 
		public Double cashFlowsFromUsedInOperations {get;set;} 
		public String dividendsReceivedClassifiedAsOperatingActivities {get;set;} 
		public Double incomeTaxesPaidRefundClassifiedAsOperatingActivities {get;set;} 
		public String interestPaidClassifiedAsOperatingActivities {get;set;} 
		public String interestReceivedClassifiedAsOperatingActivities {get;set;} 
		public String otherAdjustmentsForNoncashItems {get;set;} 
		public String otherAdjustmentsForWhichCashEffectsAreInvestingOrFinancingCashFlow {get;set;} 
		public String otherAdjustmentsToReconcileProfitLoss {get;set;} 
		public String otherInflowsOutflowsOfCashClassifiedAsOperatingActivities {get;set;} 
		public Double profitBeforeTax {get;set;} 
		public String shareOfProfitAndLossFromPartnershipFirmOrAssociationOfPersonsOrLimitedLiabilityPartnerships {get;set;} 

		public CashFlowsFromUsedInOperatingActivities(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'adjustmentsForDecreaseIncreaseInInventories') {
							adjustmentsForDecreaseIncreaseInInventories = parser.getText();
						} else if (text == 'adjustmentsForDecreaseIncreaseInOtherCurrentAssets') {
							adjustmentsForDecreaseIncreaseInOtherCurrentAssets = parser.getDoubleValue();
						} else if (text == 'adjustmentsForDecreaseIncreaseInOtherNonCurrentAssets') {
							adjustmentsForDecreaseIncreaseInOtherNonCurrentAssets = parser.getDoubleValue();
						} else if (text == 'adjustmentsForDecreaseIncreaseInTradeReceivables') {
							adjustmentsForDecreaseIncreaseInTradeReceivables = parser.getText();
						} else if (text == 'adjustmentsForDecreaseIncreaseInTradeReceivablesNoncurrent') {
							adjustmentsForDecreaseIncreaseInTradeReceivablesNoncurrent = parser.getText();
						} else if (text == 'adjustmentsForDepreciationAndAmortisationExpense') {
							adjustmentsForDepreciationAndAmortisationExpense = parser.getText();
						} else if (text == 'adjustmentsForDividendIncome') {
							adjustmentsForDividendIncome = parser.getText();
						} else if (text == 'adjustmentsForFairValueGainsLosses') {
							adjustmentsForFairValueGainsLosses = parser.getText();
						} else if (text == 'adjustmentsForFinanceCosts') {
							adjustmentsForFinanceCosts = parser.getDoubleValue();
						} else if (text == 'adjustmentsForImpairmentLossReversalOfImpairmentLossRecognisedInProfitOrLoss') {
							adjustmentsForImpairmentLossReversalOfImpairmentLossRecognisedInProfitOrLoss = parser.getText();
						} else if (text == 'adjustmentsForIncreaseDecreaseInOtherCurrentLiabilities') {
							adjustmentsForIncreaseDecreaseInOtherCurrentLiabilities = parser.getDoubleValue();
						} else if (text == 'adjustmentsForIncreaseDecreaseInOtherNonCurrentLiabilities') {
							adjustmentsForIncreaseDecreaseInOtherNonCurrentLiabilities = parser.getText();
						} else if (text == 'adjustmentsForIncreaseDecreaseInTradePayables') {
							adjustmentsForIncreaseDecreaseInTradePayables = parser.getText();
						} else if (text == 'adjustmentsForIncreaseDecreaseInTradePayablesNoncurrent') {
							adjustmentsForIncreaseDecreaseInTradePayablesNoncurrent = parser.getText();
						} else if (text == 'adjustmentsForInterestIncome') {
							adjustmentsForInterestIncome = parser.getText();
						} else if (text == 'adjustmentsForOtherBankBalances') {
							adjustmentsForOtherBankBalances = parser.getText();
						} else if (text == 'adjustmentsForOtherFinancialAssetsCurrent') {
							adjustmentsForOtherFinancialAssetsCurrent = parser.getText();
						} else if (text == 'adjustmentsForOtherFinancialAssetsNoncurrent') {
							adjustmentsForOtherFinancialAssetsNoncurrent = parser.getText();
						} else if (text == 'adjustmentsForOtherFinancialLiabilitiesCurrent') {
							adjustmentsForOtherFinancialLiabilitiesCurrent = parser.getDoubleValue();
						} else if (text == 'adjustmentsForOtherFinancialLiabilitiesNoncurrent') {
							adjustmentsForOtherFinancialLiabilitiesNoncurrent = parser.getText();
						} else if (text == 'adjustmentsForProvisions') {
							adjustmentsForProvisions = parser.getText();
						} else if (text == 'adjustmentsForProvisionsNoncurrent') {
							adjustmentsForProvisionsNoncurrent = parser.getText();
						} else if (text == 'adjustmentsForReconcileProfitLoss') {
							adjustmentsForReconcileProfitLoss = parser.getDoubleValue();
						} else if (text == 'adjustmentsForSharebasedPayments') {
							adjustmentsForSharebasedPayments = parser.getText();
						} else if (text == 'adjustmentsForUndistributedProfitsOfAssociates') {
							adjustmentsForUndistributedProfitsOfAssociates = parser.getText();
						} else if (text == 'adjustmentsForUnrealisedForeignExchangeLossesGains') {
							adjustmentsForUnrealisedForeignExchangeLossesGains = parser.getText();
						} else if (text == 'cashFlowsFromUsedInOperatingActivities') {
							cashFlowsFromUsedInOperatingActivities = parser.getDoubleValue();
						} else if (text == 'cashFlowsFromUsedInOperations') {
							cashFlowsFromUsedInOperations = parser.getDoubleValue();
						} else if (text == 'dividendsReceivedClassifiedAsOperatingActivities') {
							dividendsReceivedClassifiedAsOperatingActivities = parser.getText();
						} else if (text == 'incomeTaxesPaidRefundClassifiedAsOperatingActivities') {
							incomeTaxesPaidRefundClassifiedAsOperatingActivities = parser.getDoubleValue();
						} else if (text == 'interestPaidClassifiedAsOperatingActivities') {
							interestPaidClassifiedAsOperatingActivities = parser.getText();
						} else if (text == 'interestReceivedClassifiedAsOperatingActivities') {
							interestReceivedClassifiedAsOperatingActivities = parser.getText();
						} else if (text == 'otherAdjustmentsForNoncashItems') {
							otherAdjustmentsForNoncashItems = parser.getText();
						} else if (text == 'otherAdjustmentsForWhichCashEffectsAreInvestingOrFinancingCashFlow') {
							otherAdjustmentsForWhichCashEffectsAreInvestingOrFinancingCashFlow = parser.getText();
						} else if (text == 'otherAdjustmentsToReconcileProfitLoss') {
							otherAdjustmentsToReconcileProfitLoss = parser.getText();
						} else if (text == 'otherInflowsOutflowsOfCashClassifiedAsOperatingActivities') {
							otherInflowsOutflowsOfCashClassifiedAsOperatingActivities = parser.getText();
						} else if (text == 'profitBeforeTax') {
							profitBeforeTax = parser.getDoubleValue();
						} else if (text == 'shareOfProfitAndLossFromPartnershipFirmOrAssociationOfPersonsOrLimitedLiabilityPartnerships') {
							shareOfProfitAndLossFromPartnershipFirmOrAssociationOfPersonsOrLimitedLiabilityPartnerships = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'CashFlowsFromUsedInOperatingActivities consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class ProfitAndLoss {
		public Double basicEarningsLossPerShareFromContinuingOperations {get;set;} 
		public String basicEarningsLossPerShareFromDiscontinuedOperations {get;set;} 
		public Double currTax {get;set;} 
		public String deffTax {get;set;} 
		public Double dilutedEarningsLossPerShareFromContinuingOperations {get;set;} 
		public String dilutedEarningsLossPerShareFromDiscontinuedOperations {get;set;} 
		public String exceptionalItemsBeforeTax {get;set;} 
		public Expenses expenses {get;set;} 
		public String extraordItem {get;set;} 
		public String fromDate {get;set;} 
		public String netMovementInRegulatoryDeferralAccountBalancesRelatedToProfitOrLossAndTheRelatedDeferredTaxMovement {get;set;} 
		public OtherComprehensiveIncome otherComprehensiveIncome {get;set;} 
		public Double profLossBefTax {get;set;} 
		public String profitBfrExtr {get;set;} 
		public Double profitBfrExtrExcept {get;set;} 
		public Double profitLoss {get;set;} 
		public Double profitLossContOprtn {get;set;} 
		public Double profitLossFromDiscontinuedOperationsAfterTax {get;set;} 
		public String profitLossFromDiscontinuedOperationsBeforeTax {get;set;} 
		public String profitOrLossAttributableToNonControllingInterests {get;set;} 
		public String profitOrLossAttributableToOwnersOfParent {get;set;} 
		public Revenue revenue {get;set;} 
		public String shareOfProfitLossOfAssociates {get;set;} 
		public String shareOfProfitLossOfAssociatesAndJointVenturesAccountedForUsingEquityMethod {get;set;} 
		public Double taxExpenseOfDiscontinuedOperations {get;set;} 
		public String toDate {get;set;} 
		public Double totalBasicEarningsLossPerShare {get;set;} 
		public String totalDilutedEarningsLossPerShare {get;set;} 
		public Double totalTaxExpense {get;set;} 

		public ProfitAndLoss(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'basicEarningsLossPerShareFromContinuingOperations') {
							basicEarningsLossPerShareFromContinuingOperations = parser.getDoubleValue();
						} else if (text == 'basicEarningsLossPerShareFromDiscontinuedOperations') {
							basicEarningsLossPerShareFromDiscontinuedOperations = parser.getText();
						} else if (text == 'currTax') {
							currTax = parser.getDoubleValue();
						} else if (text == 'deffTax') {
							deffTax = parser.getText();
						} else if (text == 'dilutedEarningsLossPerShareFromContinuingOperations') {
							dilutedEarningsLossPerShareFromContinuingOperations = parser.getDoubleValue();
						} else if (text == 'dilutedEarningsLossPerShareFromDiscontinuedOperations') {
							dilutedEarningsLossPerShareFromDiscontinuedOperations = parser.getText();
						} else if (text == 'exceptionalItemsBeforeTax') {
							exceptionalItemsBeforeTax = parser.getText();
						} else if (text == 'expenses') {
							expenses = new Expenses(parser);
						} else if (text == 'extraordItem') {
							extraordItem = parser.getText();
						} else if (text == 'fromDate') {
							fromDate = parser.getText();
						} else if (text == 'netMovementInRegulatoryDeferralAccountBalancesRelatedToProfitOrLossAndTheRelatedDeferredTaxMovement') {
							netMovementInRegulatoryDeferralAccountBalancesRelatedToProfitOrLossAndTheRelatedDeferredTaxMovement = parser.getText();
						} else if (text == 'otherComprehensiveIncome') {
							otherComprehensiveIncome = new OtherComprehensiveIncome(parser);
						} else if (text == 'profLossBefTax') {
							profLossBefTax = parser.getDoubleValue();
						} else if (text == 'profitBfrExtr') {
							profitBfrExtr = parser.getText();
						} else if (text == 'profitBfrExtrExcept') {
							profitBfrExtrExcept = parser.getDoubleValue();
						} else if (text == 'profitLoss') {
							profitLoss = parser.getDoubleValue();
						} else if (text == 'profitLossContOprtn') {
							profitLossContOprtn = parser.getDoubleValue();
						} else if (text == 'profitLossFromDiscontinuedOperationsAfterTax') {
							profitLossFromDiscontinuedOperationsAfterTax = parser.getDoubleValue();
						} else if (text == 'profitLossFromDiscontinuedOperationsBeforeTax') {
							profitLossFromDiscontinuedOperationsBeforeTax = parser.getText();
						} else if (text == 'profitOrLossAttributableToNonControllingInterests') {
							profitOrLossAttributableToNonControllingInterests = parser.getText();
						} else if (text == 'profitOrLossAttributableToOwnersOfParent') {
							profitOrLossAttributableToOwnersOfParent = parser.getText();
						} else if (text == 'revenue') {
							revenue = new Revenue(parser);
						} else if (text == 'shareOfProfitLossOfAssociates') {
							shareOfProfitLossOfAssociates = parser.getText();
						} else if (text == 'shareOfProfitLossOfAssociatesAndJointVenturesAccountedForUsingEquityMethod') {
							shareOfProfitLossOfAssociatesAndJointVenturesAccountedForUsingEquityMethod = parser.getText();
						} else if (text == 'taxExpenseOfDiscontinuedOperations') {
							taxExpenseOfDiscontinuedOperations = parser.getDoubleValue();
						} else if (text == 'toDate') {
							toDate = parser.getText();
						} else if (text == 'totalBasicEarningsLossPerShare') {
							totalBasicEarningsLossPerShare = parser.getDoubleValue();
						} else if (text == 'totalDilutedEarningsLossPerShare') {
							totalDilutedEarningsLossPerShare = parser.getText();
						} else if (text == 'totalTaxExpense') {
							totalTaxExpense = parser.getDoubleValue();
						} else {
							System.debug(LoggingLevel.WARN, 'ProfitAndLoss consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class CashFlowsFromUsedInFinancingActivities {
		public Double cashFlowsFromUsedInFinancingActivities {get;set;} 
		public String dividendsPaid {get;set;} 
		public String incomeTaxesPaidRefundClassifiedAsFinancingActivities {get;set;} 
		public Double increaseDecreaseInCashAndCashEquivalentsBeforeEffectOfExchangeRateChanges {get;set;} 
		public String interestPaidClassifiedAsFinancingActivities {get;set;} 
		public String otherInflowsOutflowsOfCashClassifiedAsFinancingActivities {get;set;} 
		public String paymentsFromChangesInOwnershipInterestsInSubsidiaries {get;set;} 
		public String paymentsOfFinanceLeaseLiabilitiesClassifiedAsFinancingActivities {get;set;} 
		public String paymentsOfLeaseLiabilitiesClassifiedAsFinancingActivities {get;set;} 
		public String paymentsOfOtherEquityInstruments {get;set;} 
		public String paymentsToAcquireOrRedeemEntitysShares {get;set;} 
		public Double proceedsFromBorrowingsClassifiedAsFinancingActivities {get;set;} 
		public String proceedsFromChangesInOwnershipInterestsInSubsidiaries {get;set;} 
		public String proceedsFromExerciseOfStockOptions {get;set;} 
		public String proceedsFromIssuingDebenturesNotesBondsEtc {get;set;} 
		public String proceedsFromIssuingOtherEquityInstruments {get;set;} 
		public String proceedsFromIssuingSharesClassifiedAsFinancingActivities {get;set;} 
		public Double repaymentsOfBorrowingsClassifiedAsFinancingActivities {get;set;} 

		public CashFlowsFromUsedInFinancingActivities(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'cashFlowsFromUsedInFinancingActivities') {
							cashFlowsFromUsedInFinancingActivities = parser.getDoubleValue();
						} else if (text == 'dividendsPaid') {
							dividendsPaid = parser.getText();
						} else if (text == 'incomeTaxesPaidRefundClassifiedAsFinancingActivities') {
							incomeTaxesPaidRefundClassifiedAsFinancingActivities = parser.getText();
						} else if (text == 'increaseDecreaseInCashAndCashEquivalentsBeforeEffectOfExchangeRateChanges') {
							increaseDecreaseInCashAndCashEquivalentsBeforeEffectOfExchangeRateChanges = parser.getDoubleValue();
						} else if (text == 'interestPaidClassifiedAsFinancingActivities') {
							interestPaidClassifiedAsFinancingActivities = parser.getText();
						} else if (text == 'otherInflowsOutflowsOfCashClassifiedAsFinancingActivities') {
							otherInflowsOutflowsOfCashClassifiedAsFinancingActivities = parser.getText();
						} else if (text == 'paymentsFromChangesInOwnershipInterestsInSubsidiaries') {
							paymentsFromChangesInOwnershipInterestsInSubsidiaries = parser.getText();
						} else if (text == 'paymentsOfFinanceLeaseLiabilitiesClassifiedAsFinancingActivities') {
							paymentsOfFinanceLeaseLiabilitiesClassifiedAsFinancingActivities = parser.getText();
						} else if (text == 'paymentsOfLeaseLiabilitiesClassifiedAsFinancingActivities') {
							paymentsOfLeaseLiabilitiesClassifiedAsFinancingActivities = parser.getText();
						} else if (text == 'paymentsOfOtherEquityInstruments') {
							paymentsOfOtherEquityInstruments = parser.getText();
						} else if (text == 'paymentsToAcquireOrRedeemEntitysShares') {
							paymentsToAcquireOrRedeemEntitysShares = parser.getText();
						} else if (text == 'proceedsFromBorrowingsClassifiedAsFinancingActivities') {
							proceedsFromBorrowingsClassifiedAsFinancingActivities = parser.getDoubleValue();
						} else if (text == 'proceedsFromChangesInOwnershipInterestsInSubsidiaries') {
							proceedsFromChangesInOwnershipInterestsInSubsidiaries = parser.getText();
						} else if (text == 'proceedsFromExerciseOfStockOptions') {
							proceedsFromExerciseOfStockOptions = parser.getText();
						} else if (text == 'proceedsFromIssuingDebenturesNotesBondsEtc') {
							proceedsFromIssuingDebenturesNotesBondsEtc = parser.getText();
						} else if (text == 'proceedsFromIssuingOtherEquityInstruments') {
							proceedsFromIssuingOtherEquityInstruments = parser.getText();
						} else if (text == 'proceedsFromIssuingSharesClassifiedAsFinancingActivities') {
							proceedsFromIssuingSharesClassifiedAsFinancingActivities = parser.getText();
						} else if (text == 'repaymentsOfBorrowingsClassifiedAsFinancingActivities') {
							repaymentsOfBorrowingsClassifiedAsFinancingActivities = parser.getDoubleValue();
						} else {
							System.debug(LoggingLevel.WARN, 'CashFlowsFromUsedInFinancingActivities consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class EffectOfExchangeRateChangesOnCashAndCashEquivalents {
		public Double cashAndCashEquivalentsCashFlowStatementAtEndOfPeriod {get;set;} 
		public String effectOfExchangeRateChangesOnCashAndCashEquivalents {get;set;} 
		public Double increaseDecreaseInCashAndCashEquivalents {get;set;} 

		public EffectOfExchangeRateChangesOnCashAndCashEquivalents(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'cashAndCashEquivalentsCashFlowStatementAtEndOfPeriod') {
							cashAndCashEquivalentsCashFlowStatementAtEndOfPeriod = parser.getDoubleValue();
						} else if (text == 'effectOfExchangeRateChangesOnCashAndCashEquivalents') {
							effectOfExchangeRateChangesOnCashAndCashEquivalents = parser.getText();
						} else if (text == 'increaseDecreaseInCashAndCashEquivalents') {
							increaseDecreaseInCashAndCashEquivalents = parser.getDoubleValue();
						} else {
							System.debug(LoggingLevel.WARN, 'EffectOfExchangeRateChangesOnCashAndCashEquivalents consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Previous {
		public BalanceSheet balanceSheet {get;set;} 
		public CashFlowStatement cashFlowStatement {get;set;} 
		public ProfitAndLoss profitAndLoss {get;set;} 
		public Ratios_Z ratios {get;set;} 

		public Previous(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'balanceSheet') {
							balanceSheet = new BalanceSheet(parser);
						} else if (text == 'cashFlowStatement') {
							cashFlowStatement = new CashFlowStatement(parser);
						} else if (text == 'profitAndLoss') {
							profitAndLoss = new ProfitAndLoss(parser);
						} else if (text == 'ratios') {
							ratios = new Ratios_Z(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'Previous consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Revenue {
		public Double otherIncome {get;set;} 
		public Double revenueFromOperations {get;set;} 
		public String salGoodsDom {get;set;} 
		public String salGoodsExp {get;set;} 
		public String salGoodsTrdDom {get;set;} 
		public String salGoodsTrdExp {get;set;} 
		public String salSuppServiceDom {get;set;} 
		public String salSuppServiceExp {get;set;} 
		public String totalRev {get;set;} 

		public Revenue(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'otherIncome') {
							otherIncome = parser.getDoubleValue();
						} else if (text == 'revenueFromOperations') {
							revenueFromOperations = parser.getDoubleValue();
						} else if (text == 'salGoodsDom') {
							salGoodsDom = parser.getText();
						} else if (text == 'salGoodsExp') {
							salGoodsExp = parser.getText();
						} else if (text == 'salGoodsTrdDom') {
							salGoodsTrdDom = parser.getText();
						} else if (text == 'salGoodsTrdExp') {
							salGoodsTrdExp = parser.getText();
						} else if (text == 'salSuppServiceDom') {
							salSuppServiceDom = parser.getText();
						} else if (text == 'salSuppServiceExp') {
							salSuppServiceExp = parser.getText();
						} else if (text == 'totalRev') {
							totalRev = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Revenue consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class CompanyInfo {
		public String SRNOfForm66 {get;set;} 
		public String accbooksElecform {get;set;} 
		public String addLine1 {get;set;} 
		public String addLine2 {get;set;} 
		public String addressAndContactDetailsOfRegistrarAndTransferAgent {get;set;} 
		public String addressAsProvidedByTheServiceProvider {get;set;} 
		public Boolean adoptedAdjournedagm {get;set;} 
		public Boolean agmHeld {get;set;} 
		public String authCap {get;set;} 
		public String balanceSheetDate {get;set;} 
		public String categoryOrSubcategoryOfCompany {get;set;} 
		public String cinHoldcomp {get;set;} 
		public String cinSubscomp {get;set;} 
		public String city {get;set;} 
		public String compSubs {get;set;} 
		public String companyResNo {get;set;} 
		public String comphasSubs {get;set;} 
		public Boolean consolidatedfsReq {get;set;} 
		public String contentOfReport {get;set;} 
		public Integer copNumber {get;set;} 
		public String costRecords {get;set;} 
		public String country {get;set;} 
		public String dateAgm {get;set;} 
		public String dateBodmeetingboardrepapprov {get;set;} 
		public String dateBodmeetingfsapprov {get;set;} 
		public String dateFromWhichRegisterOfMembersRemainedClosed {get;set;} 
		public String dateOfAGMAccountsBySH {get;set;} 
		public String dateOfBoardMeetingWhenFinalAccountsWereApproved {get;set;} 
		public String dateOfEndOfReportingPeriod {get;set;} 
		public String dateOfStartOfReportingPeriod {get;set;} 
		public String dateTillWhichRegisterOfMembersRemainedClosed {get;set;} 
		public String declByBod {get;set;} 
		public String descriptionOfPresentationCurrency {get;set;} 
		public String descriptionOfPrincipalProductOrServicesCategory {get;set;} 
		public String designation {get;set;} 
		public String din {get;set;} 
		public String dirtReportDisclosureSec134 {get;set;} 
		public String disclosureWebLinkOfCompanyAtWhichAnnualReportIsPlaced {get;set;} 
		public String district {get;set;} 
		public String dueDateAgmAfrExtn {get;set;} 
		public String duedateAgm {get;set;} 
		public String eformSrn {get;set;} 
		public String entityEmailId {get;set;} 
		public String entityGln {get;set;} 
		public String entityId {get;set;} 
		public String entityName {get;set;} 
		public Boolean extsnforAgm {get;set;} 
		public String filingDate {get;set;} 
		public String finyrEnddate {get;set;} 
		public String finyrStartdate {get;set;} 
		public String internetProtocolAddressOfServiceProvider {get;set;} 
		public String isoCountrycode {get;set;} 
		public String lengthOfLifeOfLimitedLifeEntity {get;set;} 
		public String levelOfRoundingUsedInFinancialStatements {get;set;} 
		public String locationOfTheServiceProvider {get;set;} 
		public String membrshpNum {get;set;} 
		public String nameHoldcomp {get;set;} 
		public String nameOfParentEntity {get;set;} 
		public String nameOfRegistrarAndTransferAgent {get;set;} 
		public String nameOfTheServiceProvider {get;set;} 
		public String nameOfUltimateParentOfGroup {get;set;} 
		public String nameSubs {get;set;} 
		public String natureOffs {get;set;} 
		public String netWorthCsr {get;set;} 
		public String noMem {get;set;} 
		public String numSubs {get;set;} 
		public String panOfEntity {get;set;} 
		public String periodCoveredByFinancialStatements {get;set;} 
		public String phCode {get;set;} 
		public String phNum {get;set;} 
		public String pinCode {get;set;} 
		public String provisionCompSubsc {get;set;} 
		public String provisonCompsubs {get;set;} 
		public String regAddOfEntity {get;set;} 
		public String registrationDateOfCompany {get;set;} 
		public Boolean sch3App {get;set;} 
		public String secretarialAudApp {get;set;} 
		public String signingOfRptsDateByAud {get;set;} 
		public String srnAoc4 {get;set;} 
		public String stateUt {get;set;} 
		public String toBeDigSignedBy {get;set;} 
		public String totalNumberOfProductOrServiceCategory {get;set;} 
		public String turnoverCsr {get;set;} 
		public String typInd {get;set;} 
		public String typeOfCashFlowStatement {get;set;} 
		public String whetherAssOrFel {get;set;} 
		public String whetherBooksOfAccountAndOtherBooksAndPapersAreMaintainedOnCloud {get;set;} 
		public String whetherCompanyIsListedCompany {get;set;} 
		public String whetherCompanyIsMaintainingBooksOfAccountAndOtherRelevantBooksAndPapersInElectronicForm {get;set;} 
		public String whetherFinancialStatementsDrawnOnTheBasisOf {get;set;} 
		public String whthrAuditOfCostRecord {get;set;} 
		public String whthrSchVIApp {get;set;} 

		public CompanyInfo(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'SRNOfForm66') {
							SRNOfForm66 = parser.getText();
						} else if (text == 'accbooksElecform') {
							accbooksElecform = parser.getText();
						} else if (text == 'addLine1') {
							addLine1 = parser.getText();
						} else if (text == 'addLine2') {
							addLine2 = parser.getText();
						} else if (text == 'addressAndContactDetailsOfRegistrarAndTransferAgent') {
							addressAndContactDetailsOfRegistrarAndTransferAgent = parser.getText();
						} else if (text == 'addressAsProvidedByTheServiceProvider') {
							addressAsProvidedByTheServiceProvider = parser.getText();
						} else if (text == 'adoptedAdjournedagm') {
							adoptedAdjournedagm = parser.getBooleanValue();
						} else if (text == 'agmHeld') {
							agmHeld = parser.getBooleanValue();
						} else if (text == 'authCap') {
							authCap = parser.getText();
						} else if (text == 'balanceSheetDate') {
							balanceSheetDate = parser.getText();
						} else if (text == 'categoryOrSubcategoryOfCompany') {
							categoryOrSubcategoryOfCompany = parser.getText();
						} else if (text == 'cinHoldcomp') {
							cinHoldcomp = parser.getText();
						} else if (text == 'cinSubscomp') {
							cinSubscomp = parser.getText();
						} else if (text == 'city') {
							city = parser.getText();
						} else if (text == 'compSubs') {
							compSubs = parser.getText();
						} else if (text == 'companyResNo') {
							companyResNo = parser.getText();
						} else if (text == 'comphasSubs') {
							comphasSubs = parser.getText();
						} else if (text == 'consolidatedfsReq') {
							consolidatedfsReq = parser.getBooleanValue();
						} else if (text == 'contentOfReport') {
							contentOfReport = parser.getText();
						} else if (text == 'copNumber') {
							copNumber = parser.getIntegerValue();
						} else if (text == 'costRecords') {
							costRecords = parser.getText();
						} else if (text == 'country') {
							country = parser.getText();
						} else if (text == 'dateAgm') {
							dateAgm = parser.getText();
						} else if (text == 'dateBodmeetingboardrepapprov') {
							dateBodmeetingboardrepapprov = parser.getText();
						} else if (text == 'dateBodmeetingfsapprov') {
							dateBodmeetingfsapprov = parser.getText();
						} else if (text == 'dateFromWhichRegisterOfMembersRemainedClosed') {
							dateFromWhichRegisterOfMembersRemainedClosed = parser.getText();
						} else if (text == 'dateOfAGMAccountsBySH') {
							dateOfAGMAccountsBySH = parser.getText();
						} else if (text == 'dateOfBoardMeetingWhenFinalAccountsWereApproved') {
							dateOfBoardMeetingWhenFinalAccountsWereApproved = parser.getText();
						} else if (text == 'dateOfEndOfReportingPeriod') {
							dateOfEndOfReportingPeriod = parser.getText();
						} else if (text == 'dateOfStartOfReportingPeriod') {
							dateOfStartOfReportingPeriod = parser.getText();
						} else if (text == 'dateTillWhichRegisterOfMembersRemainedClosed') {
							dateTillWhichRegisterOfMembersRemainedClosed = parser.getText();
						} else if (text == 'declByBod') {
							declByBod = parser.getText();
						} else if (text == 'descriptionOfPresentationCurrency') {
							descriptionOfPresentationCurrency = parser.getText();
						} else if (text == 'descriptionOfPrincipalProductOrServicesCategory') {
							descriptionOfPrincipalProductOrServicesCategory = parser.getText();
						} else if (text == 'designation') {
							designation = parser.getText();
						} else if (text == 'din') {
							din = parser.getText();
						} else if (text == 'dirtReportDisclosureSec134') {
							dirtReportDisclosureSec134 = parser.getText();
						} else if (text == 'disclosureWebLinkOfCompanyAtWhichAnnualReportIsPlaced') {
							disclosureWebLinkOfCompanyAtWhichAnnualReportIsPlaced = parser.getText();
						} else if (text == 'district') {
							district = parser.getText();
						} else if (text == 'dueDateAgmAfrExtn') {
							dueDateAgmAfrExtn = parser.getText();
						} else if (text == 'duedateAgm') {
							duedateAgm = parser.getText();
						} else if (text == 'eformSrn') {
							eformSrn = parser.getText();
						} else if (text == 'entityEmailId') {
							entityEmailId = parser.getText();
						} else if (text == 'entityGln') {
							entityGln = parser.getText();
						} else if (text == 'entityId') {
							entityId = parser.getText();
						} else if (text == 'entityName') {
							entityName = parser.getText();
						} else if (text == 'extsnforAgm') {
							extsnforAgm = parser.getBooleanValue();
						} else if (text == 'filingDate') {
							filingDate = parser.getText();
						} else if (text == 'finyrEnddate') {
							finyrEnddate = parser.getText();
						} else if (text == 'finyrStartdate') {
							finyrStartdate = parser.getText();
						} else if (text == 'internetProtocolAddressOfServiceProvider') {
							internetProtocolAddressOfServiceProvider = parser.getText();
						} else if (text == 'isoCountrycode') {
							isoCountrycode = parser.getText();
						} else if (text == 'lengthOfLifeOfLimitedLifeEntity') {
							lengthOfLifeOfLimitedLifeEntity = parser.getText();
						} else if (text == 'levelOfRoundingUsedInFinancialStatements') {
							levelOfRoundingUsedInFinancialStatements = parser.getText();
						} else if (text == 'locationOfTheServiceProvider') {
							locationOfTheServiceProvider = parser.getText();
						} else if (text == 'membrshpNum') {
							membrshpNum = parser.getText();
						} else if (text == 'nameHoldcomp') {
							nameHoldcomp = parser.getText();
						} else if (text == 'nameOfParentEntity') {
							nameOfParentEntity = parser.getText();
						} else if (text == 'nameOfRegistrarAndTransferAgent') {
							nameOfRegistrarAndTransferAgent = parser.getText();
						} else if (text == 'nameOfTheServiceProvider') {
							nameOfTheServiceProvider = parser.getText();
						} else if (text == 'nameOfUltimateParentOfGroup') {
							nameOfUltimateParentOfGroup = parser.getText();
						} else if (text == 'nameSubs') {
							nameSubs = parser.getText();
						} else if (text == 'natureOffs') {
							natureOffs = parser.getText();
						} else if (text == 'netWorthCsr') {
							netWorthCsr = parser.getText();
						} else if (text == 'noMem') {
							noMem = parser.getText();
						} else if (text == 'numSubs') {
							numSubs = parser.getText();
						} else if (text == 'panOfEntity') {
							panOfEntity = parser.getText();
						} else if (text == 'periodCoveredByFinancialStatements') {
							periodCoveredByFinancialStatements = parser.getText();
						} else if (text == 'phCode') {
							phCode = parser.getText();
						} else if (text == 'phNum') {
							phNum = parser.getText();
						} else if (text == 'pinCode') {
							pinCode = parser.getText();
						} else if (text == 'provisionCompSubsc') {
							provisionCompSubsc = parser.getText();
						} else if (text == 'provisonCompsubs') {
							provisonCompsubs = parser.getText();
						} else if (text == 'regAddOfEntity') {
							regAddOfEntity = parser.getText();
						} else if (text == 'registrationDateOfCompany') {
							registrationDateOfCompany = parser.getText();
						} else if (text == 'sch3App') {
							sch3App = parser.getBooleanValue();
						} else if (text == 'secretarialAudApp') {
							secretarialAudApp = parser.getText();
						} else if (text == 'signingOfRptsDateByAud') {
							signingOfRptsDateByAud = parser.getText();
						} else if (text == 'srnAoc4') {
							srnAoc4 = parser.getText();
						} else if (text == 'stateUt') {
							stateUt = parser.getText();
						} else if (text == 'toBeDigSignedBy') {
							toBeDigSignedBy = parser.getText();
						} else if (text == 'totalNumberOfProductOrServiceCategory') {
							totalNumberOfProductOrServiceCategory = parser.getText();
						} else if (text == 'turnoverCsr') {
							turnoverCsr = parser.getText();
						} else if (text == 'typInd') {
							typInd = parser.getText();
						} else if (text == 'typeOfCashFlowStatement') {
							typeOfCashFlowStatement = parser.getText();
						} else if (text == 'whetherAssOrFel') {
							whetherAssOrFel = parser.getText();
						} else if (text == 'whetherBooksOfAccountAndOtherBooksAndPapersAreMaintainedOnCloud') {
							whetherBooksOfAccountAndOtherBooksAndPapersAreMaintainedOnCloud = parser.getText();
						} else if (text == 'whetherCompanyIsListedCompany') {
							whetherCompanyIsListedCompany = parser.getText();
						} else if (text == 'whetherCompanyIsMaintainingBooksOfAccountAndOtherRelevantBooksAndPapersInElectronicForm') {
							whetherCompanyIsMaintainingBooksOfAccountAndOtherRelevantBooksAndPapersInElectronicForm = parser.getText();
						} else if (text == 'whetherFinancialStatementsDrawnOnTheBasisOf') {
							whetherFinancialStatementsDrawnOnTheBasisOf = parser.getText();
						} else if (text == 'whthrAuditOfCostRecord') {
							whthrAuditOfCostRecord = parser.getText();
						} else if (text == 'whthrSchVIApp') {
							whthrSchVIApp = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'CompanyInfo consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Current {
		public BalanceSheet balanceSheet {get;set;} 
		public CashFlowStatement cashFlowStatement {get;set;} 
		public ProfitAndLoss profitAndLoss {get;set;} 
		public Ratios ratios {get;set;} 

		public Current(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'balanceSheet') {
							balanceSheet = new BalanceSheet(parser);
						} else if (text == 'cashFlowStatement') {
							cashFlowStatement = new CashFlowStatement(parser);
						} else if (text == 'profitAndLoss') {
							profitAndLoss = new ProfitAndLoss(parser);
						} else if (text == 'ratios') {
							ratios = new Ratios(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'Current consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	
	public static mcaCorpFinanceWrapper parse(String json) {
		System.JSONParser parser = System.JSON.createParser(json);
		return new mcaCorpFinanceWrapper(parser);
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
	
    private static List<AuditorProfile> arrayOfAuditorProfile(System.JSONParser p) {
        List<AuditorProfile> res = new List<AuditorProfile>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new AuditorProfile(p));
        }
        return res;
    }


















    private static List<Financial> arrayOfFinancial(System.JSONParser p) {
        List<Financial> res = new List<Financial>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Financial(p));
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




    private static List<SignedFinStatements> arrayOfSignedFinStatements(System.JSONParser p) {
        List<SignedFinStatements> res = new List<SignedFinStatements>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new SignedFinStatements(p));
        }
        return res;
    }



    private static List<SignedAuditReport> arrayOfSignedAuditReport(System.JSONParser p) {
        List<SignedAuditReport> res = new List<SignedAuditReport>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new SignedAuditReport(p));
        }
        return res;
    }




    private static List<SignedBoardReport> arrayOfSignedBoardReport(System.JSONParser p) {
        List<SignedBoardReport> res = new List<SignedBoardReport>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new SignedBoardReport(p));
        }
        return res;
    }



    private static List<DisclosureOfPrincipalProductOrService> arrayOfDisclosureOfPrincipalProductOrService(System.JSONParser p) {
        List<DisclosureOfPrincipalProductOrService> res = new List<DisclosureOfPrincipalProductOrService>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new DisclosureOfPrincipalProductOrService(p));
        }
        return res;
    }








}