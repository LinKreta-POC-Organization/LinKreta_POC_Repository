public class mcaEntitySearchWrapperMain {
		public String requestId;
		public List<Result> result;
		public Integer statusCode;
	

	public class AdditionalEntityIds {
	}

	public class Result {
		public String kid;
		public String name;
		public String type;
		public String status;
		public List<String> pans;
		public String location;
		public String entityId;
		public List<AdditionalEntityIds> additionalEntityIds;
		public String primaryName;
		public String secondaryName;
		public Double score;
	}

	
	public static mcaEntitySearchWrapperMain parse(String json) {
		return (mcaEntitySearchWrapperMain) System.JSON.deserialize(json, mcaEntitySearchWrapperMain.class);
	}
}