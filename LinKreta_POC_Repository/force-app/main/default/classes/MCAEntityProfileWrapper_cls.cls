/* 
     Written By: Bhanwar Singh
     Created Date: 1/12/2023
     Last Modified By : Bhanwar Singh
     Last Modified Date : 22-03-23
     Description : This is Used as A Wrapper For MCA Entity Profile
     
*/


public class MCAEntityProfileWrapper_cls {

	public class Company {
		public String whetherListedOrNot;
		public String category;
		public String registeredAddress;
		public String rocCode;
		public String subcategory;
		public String emailId;
		public String suspendedAtStockExchange;
		public String dateOfBalanceSheet;
		public String cin;
		public String alternativeAddress;
		public String status;
		public String dateOfLastAGM;
		public String entityClass;
		public String entityName;
		public String paidUpCapital;
		public String authorisedCapital;
		public String numberOfMembers;
		public String registrationNumber;
		public String dateOfIncorporation;
		public String industry;
		public String subIndustry;
		public String activityGroup;
		public String activityClass;
		public String activitySubClass;
	}

	public String requestId;
	public Result result;
	public Integer statusCode;

	public class Directors {
		public String din;
		public String pan;
		public String dob;
		public String fatherName;
		public String name;
		public String designation;
		public String tenureBeginDate;
		public String address;
		public Object tenureEndDate;
	}

	public class Charges {
		public String chargeId;
		public String assetsUnderCharge;
		public String chargeAmount;
		public String dateOfCreation;
		public String dateOfModification;
		public String status;
		public String srn;
		public String chargeHolderName;
		public String dateOfSatisfaction;
		public String address;
	}

	public class Result {
		public Company company;
		public List<Charges> charges;
		public List<Directors> directors;
	}

	
	public static MCAEntityProfileWrapper_cls parse(String json) {
		return (MCAEntityProfileWrapper_cls) System.JSON.deserialize(json, MCAEntityProfileWrapper_cls.class);
	}
}