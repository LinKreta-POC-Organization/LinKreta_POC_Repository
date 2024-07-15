public class compititorMCAWrapper {

	public class RatAnalysis {
		public String ebitdaMargin;
		public String netProfitMargin;
		public String netDebtEquity;
		public String interestCoverage;
		public String roce;
		public String netOpIncGrowth;
		public String returnOnEquity;
	}

	public String requestId;
	public Result result;
	public Integer statusCode;

	public class BalSheet {
		public String totalBorr;
		public String cashAndBank;
		public String totalAssets;
		public String avgCapitalEmployed;
		public String avgEquity;
		public String totalEquity;
	}

	public class Metadata {
		public String finyrEnddate;
	}

	public class CurrentFinancialSummary {
		public IncomeState incomeState;
		public RatAnalysis ratAnalysis;
		public BalSheet balSheet;
	}

	public class BusinessActivity {
		public String description;
		public String code;
		public String percentageTurnover;
	}

	public class Records {
		public String kid;
		public String name;
		public String entityId;
		public List<BusinessActivity> businessActivity;
		public String employeeCount;
		public CurrentFinancialSummary currentFinancialSummary;
		public String peerMetric;
		public Metadata metadata;
	}

	public class IncomeState {
		public String ebitda;
		public String revenueFromOperations;
		public String profitLoss;
		public String ebit;
		public String pbt;
		public String finCost;
	}

	public class Result {
		public List<Records> records;
	}

	
	public static compititorMCAWrapper parse(String json) {
		return (compititorMCAWrapper) System.JSON.deserialize(json, compititorMCAWrapper.class);
	}
}