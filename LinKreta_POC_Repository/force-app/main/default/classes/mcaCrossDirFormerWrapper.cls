public class mcaCrossDirFormerWrapper {

	public class FormerDirectors {
		public String din;
		public String name;
		public String designation;
		public String dateOfAppointment;
		public String tenureEndDate;
		public String pan;
		public String tenureBeginDate;
	}

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
		public List<FormerDirectors> formerDirectors;
		public String name;
		public String dateOfIncorporation;
		public Double percent;
		public List<Directors> directors;
		public String entityId;
		public String kid;
	}

	
	public static mcaCrossDirFormerWrapper parse(String json) {
		return (mcaCrossDirFormerWrapper) System.JSON.deserialize(json, mcaCrossDirFormerWrapper.class);
	}
}