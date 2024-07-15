public class MCAWrapperForClosingPrice {

	public Integer statusCode;
	public String requestId;
	public List<Result> result;

	public class Result {
		public String noOfShares;
		public String netTurnover;
		public String isin;
		public String dateOfTrading;
		public String sourceUri;
		public String lastPrice;
		public String securityId;
		public String lowPrice;
		public String highPrice;
		public String closingPrice;
		public String securityType;
		public String name;
		public String instrument;
		public String openingPrice;
		public String securityCode;
		public String timestamp;
		public String noOfTrades;
		public String securityGroup;
		public String tdcloindi;
		public String kid;
		public String previousClosingPrice;
	}

	
	public static MCAWrapperForClosingPrice parse(String json) {
		return (MCAWrapperForClosingPrice) System.JSON.deserialize(json, MCAWrapperForClosingPrice.class);
	}
}