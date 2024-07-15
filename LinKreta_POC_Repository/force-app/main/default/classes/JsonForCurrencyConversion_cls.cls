public class  JsonForCurrencyConversion_cls  {
        public List<Data> data;

	public class Data {
		public String rates;
		public String up_Date;
	}

	
	public static JsonForCurrencyConversion_cls parse(String json) {
		return (JsonForCurrencyConversion_cls) System.JSON.deserialize(json, JsonForCurrencyConversion_cls.class);
	}     
}