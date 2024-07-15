/* 
     Written By: Bhanwar Singh
     Created Date: 22-03-23
     Last Modified By : Bhanwar Singh
     Last Modified Date : 22-03-23
     Description : This is Used as A Wrapper For MCA Entity 
     
*/

public class MCACorpInvestorWrapper_cls {

	public String requestId;
	public Result result;
	public Integer statusCode;

	public class Metadata {
		public String source;
		public String documentName;
		public String dateOfFiling;
		public String finYearStartDate;
		public String finYearEndDate;
		public String docId;
	}

	public class ShareHolders {
		public String din;
		public String pan;
		public String name;
		public String percentageOfHoldingByShares;
		public String numberOfEquitySharesHeld;
		public Metadata metadata;
		public String address;
		public String cin;
		public String percentageOfHoldingByVotes;
	}

	public class Result {
		public List<ShareHolders> shareHolders;
		public String companyName;
		public String entityId;
		public String lastDownloaded;
	}

	
	public static MCACorpInvestorWrapper_cls parse(String json) {
		return (MCACorpInvestorWrapper_cls) System.JSON.deserialize(json, MCACorpInvestorWrapper_cls.class);
	}
}