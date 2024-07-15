public class mcaAlertsWrapper {

	public class Ibbi {
		public String announcementPdfLink;
		public String timestamp;
		public String applicantName;
		public String dateOfPublicAnnouncement;
		public String name;
	}

	public Integer statusCode;
	public String requestId;
	public Result result;

	public class McaProsecution {
		public String violationSection;
		public String prosecutionSection;
	}

	public class Severity {
		public Integer high;
		public Integer severe;
		public Integer medium;
		public Integer low;
	}

	public class Details_Z {
		public EntityAlerts entityAlerts;
		public List<ManagementAlerts> managementAlerts;
	}

	public class Details_Y {
		public List<String> value;
		public String label;
	}

	public class Result {
		public Alerts_Z alerts;
	}

	public class Alerts_Z {
		public AlertSummary alertSummary;
		public List<AlertList> alertList;
	}

	public class Details {
	}

	public class ManagementAlerts {
		public String din;
		public List<Alerts> alerts;
		public String kid;
	}

	public class DetailsAsPerSource {
		public String source;
		public List<Details_Y> details;
	}

	public class AlertList {
		public String documentUrl;
		public List<DetailsAsPerSource> detailsAsPerSource;
		public String alert;
		public String lastUpdatedDate;
		public Boolean exists;
		public String severity;
	}

	public class Alerts {
		public Details details;
		public String alert;
	}

	public class AlertSummary {
		public Severity severity;
		public Details_Z details;
	}

	public class EntityAlerts {
		public List<McaProsecution> mcaProsecution;
		public List<Ibbi> ibbi;
	}

	
	public static mcaAlertsWrapper parse(String json) {
		return (mcaAlertsWrapper) System.JSON.deserialize(json, mcaAlertsWrapper.class);
	}
}