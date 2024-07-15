public class mcaFinanceWrapper {

	public class RatAnalysis {
		public String returnOnEquity;
		public String netDebtEquity;
		public String netProfitMargin;
		public String netOpIncGrowth;
		public String netProfGrowth;
		public String roce;
		public String interestCoverage;
		public String ebitdaMargin;
		public String ebitdaGrowth;
	}

	public Integer statusCode;
	public String requestId;
	public Result result;

	public class BalSheet {
		public String propertyPlantAndEquipment;
		public String shareCap;
		public String otherEquity;
		public String totalEl;
		public String deffTaxLiab;
		public String cashAndBank;
		public String totalBorr;
		public String totalAssets;
		public String nonControllingInterest;
		public String capWip;
		public String investments;
		public String otherAssets;
		public String othersLiab;
	}

	public class Metadata {
		public String docId;
		public String attachmentLink;
		public String excelLink;
		public String documentName;
		public String financialYear;
		public String lastUpdated;
		public String formId;
		public String dateOfFiling;
		public String docLink;
		public String entityId;
		public String type;
	}

	public class Data {
		public TradeReceivables tradeReceivables;
		public CurrentFinancialSummary currentFinancialSummary;
		public String cdrFlag;
		public FinParamProfitLoss finParamProfitLoss;
		public FinParamBalanceSheet finParamBalanceSheet;
	}

	public class TradeReceivables {
		public WithinSixMonths withinSixMonths;
		public ExceedingSixMonths exceedingSixMonths;
	}

	public class IncomeState {
		public String shareAssocJointVent;
		public String deprcnAmort;
		public String totalTaxExpense;
		public String totExp;
		public String exceptionalItemsBeforeTax;
		public String profLossBefTax;
		public String otherIncome;
		public String profitLoss;
		public String finCost;
		public String ebit;
		public String effTaxRate;
		public String ebitda;
		public String revenueFromOperations;
	}

	public class Result {
		public CompanyInfo companyInfo;
		public List<Standalone> standalone;
	}

	public class WithinSixMonths {
		public String doubtfulWithSix;
		public String netTrdRecWithSix;
		public String debtsDueDirWithSix;
		public String totTrdRecWithSix;
		public String securedGoodWithSix;
		public String unsecuredGoodWithSix;
		public String provisionForBadAndDoubtfulDebtsWithSix;
	}

	public class ExceedingSixMonths {
		public String netTrdRecExSix;
		public String provisionForBadAndDoubtfulDebtsExSix;
		public String debtsDueDirExSix;
		public String unsecuredGoodExSix;
		public String doubtfulExSix;
		public String securedGoodExSix;
		public String totTrdRecExSix;
	}

	public class FinParamProfitLoss {
		public String revSubsidies;
		public String propDiv;
		public String propDividendPer;
		public String incomeFor;
		public String consumptnStores;
		public String expenFor;
		public String propDividend;
		public String grossValueTransn;
		public String badDebtsRP;
		public String dilutedEpsPL;
		public String basicEpsPL;
		public String rentPaid;
	}

	public class CashFlowStat {
		public String cashAndCashEquivalentsCashFlowStatementAtBeginningOfPeriod;
		public String cashFlowsFromUsedInFinancingActivities;
		public String cashFlowsFromUsedInInvestingActivities;
		public String freeCashFlow;
		public String capExpenditure;
		public String cashAndCashEquivalentsCashFlowStatementAtEndOfPeriod;
		public String increaseDecreaseInCashAndCashEquivalents;
		public String cashFlowsFromUsedInOperatingActivities;
	}

	public class Standalone {
		public Data data;
		public Metadata metadata;
	}

	public class CurrentFinancialSummary {
		public BalSheet balSheet;
		public CashFlowStat cashFlowStat;
		public RatAnalysis ratAnalysis;
		public IncomeState incomeState;
	}

	public class CompanyInfo {
		public String entityEmailId;
		public String entityId;
		public String regAddOfEntity;
		public String registrationDateOfCompany;
		public String entityName;
	}

	public class FinParamBalanceSheet {
		public String amountIssueAll;
		public String conversionWrDe;
		public String commercialPaper;
		public String rbOperatingLea;
		public String miscExpenditure;
		public String amtDueTransfer;
		public String grossValue;
		public String interCorpBorr1;
		public String goodwillConsl;
		public String defaultPayment1;
		public String securedLoan;
		public String borrowingFia;
		public String debenturesClaim;
		public String warrantsIssued;
		public String forfeitedShares;
		public String interestDeposit;
		public String paidUpCaptFc1Percent;
		public String numShareHoldrs;
		public String depMaturedCla1;
		public String depMaturedCla2;
		public String defaultPayment;
		public String shareAppMoney3;
		public String netWorth;
		public String conversionWrPs;
		public String interCorporate;
		public String unpaidDividend;
		public String capitalReserves;
		public String depreciatnAmort;
		public String paidUpCaptFcPercent;
		public String paidUpCaptFc1;
		public String investmentJoint;
		public String borrowingFc;
		public String conversionWrEs;
		public String numSharesBb;
		public String investmentSubsd;
		public String paidUpCaptFc;
		public String investmentGovt;
		public String shareAppMoney;
		public String warrantsIssued1;
		public String investmentAssoc;
		public String forfeitedSharR;
		public String callsUnpaidDir;
		public String depMaturedClai;
		public String shareAppMoney1;
		public String shareAppMoney2;
		public String grossFixdAsset;
		public String interCorpBorr;
		public String unclaimedMDeb;
		public String callsUnpaidOth;
		public String depAcceptedRen;
		public String unhedgedFeExp;
		public String capitalSubsdies;
	}

	
	public static mcaFinanceWrapper parse(String json) {
		return (mcaFinanceWrapper) System.JSON.deserialize(json, mcaFinanceWrapper.class);
	}
}