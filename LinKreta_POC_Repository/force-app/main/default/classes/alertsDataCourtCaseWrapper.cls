public class alertsDataCourtCaseWrapper {

	public String requestId;
	public List<Result> result;
	public Integer statusCode;

	public class Result {
		public String compoundableOrNonCompoundable;
		public List<String> convictedDirectors;
		public String courtCaseNumber;
		public String dateOfFilingReceivingOfNotice;
		public String filedUnderSection;
		public String financialYearOfDisposingOfComplaint;
		public String investigationCaseNumber;
		public Boolean isSfioConvictedDirectorCompoundable;
		public String isSfioConvictedDirectorNonCompoundable;
		public String kid;
		public String name;
		public String nameAddressOfTheCourt;
		public String nameOfThePresentComplainantPairviOfficer;
		public String nextDateOfHearing;
		public String numberOfAccusedAtPresent;
		public String petitioner;
		public String remarks;
		public String respondent;
		public String sourceUri;
		public String srcAccusedPersons;
		public String srcCauseTitleOfTheCase;
		public String timestamp;
		public String type;
	}

	
	public static alertsDataCourtCaseWrapper parse(String json) {
		return (alertsDataCourtCaseWrapper) System.JSON.deserialize(json, alertsDataCourtCaseWrapper.class);
	}
}