public class mcaCrossDirCurrentWrapper {

	public Integer statusCode;
	public String requestId;
	public List<Result> result;

	public class Directors {
		public String din;
		public String name;
		public String designation;
		public String dateOfAppointment;
		public String tenureEndDate;
		public String pan;
		public String tenureBeginDate;
	}

	public class Result {
		public String name;
		public String dateOfIncorporation;
		public Double percent;
		public List<Directors> directors;
		public String entityId;
		public String kid;
	}

	
	public static mcaCrossDirCurrentWrapper parse(String json) {
		return (mcaCrossDirCurrentWrapper) System.JSON.deserialize(json, mcaCrossDirCurrentWrapper.class);
	}
}