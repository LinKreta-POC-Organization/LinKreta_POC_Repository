public class clientNewIqWrapper {

	public List<GDSSDKResponse> GDSSDKResponse {get;set;} 

	public clientNewIqWrapper(JSONParser parser) {
		while (parser.nextToken() != System.JSONToken.END_OBJECT) {
			if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
				String text = parser.getText();
				if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
					if (text == 'GDSSDKResponse') {
						GDSSDKResponse = arrayOfGDSSDKResponse(parser);
					} else {
						System.debug(LoggingLevel.WARN, 'JSON2Apex consuming unrecognized property: '+text);
						consumeObject(parser);
					}
				}
			}
		}
	}
	
	public class Properties_Z {
		public String periodtype {get;set;} 

		public Properties_Z(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'periodtype') {
							periodtype = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Properties_Z consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Properties_X {
		public String enddate {get;set;} 
		public String keydevfilter {get;set;} 
		public String startdate {get;set;} 

		public Properties_X(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'enddate') {
							enddate = parser.getText();
						} else if (text == 'keydevfilter') {
							keydevfilter = parser.getText();
						} else if (text == 'startdate') {
							startdate = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Properties_X consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Properties_Y {
		public String asofdate {get;set;} 
		public String endrank {get;set;} 
		public String currencyid {get;set;} 
		public String currencyconversionmodeid {get;set;} 
		public String startrank {get;set;} 

		public Properties_Y(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'asofdate') {
							asofdate = parser.getText();
						} else if (text == 'endrank') {
							endrank = parser.getText();
						} else if (text == 'currencyid') {
							currencyid = parser.getText();
						} else if (text == 'currencyconversionmodeid') {
							currencyconversionmodeid = parser.getText();
						} else if (text == 'startrank') {
							startrank = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Properties_Y consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class GDSSDKResponse {
		public String Function {get;set;} 
		public String Mnemonic {get;set;} 
		public Integer NumCols {get;set;} 
		public Integer NumRows {get;set;} 
		public String ErrMsg {get;set;} 
		public String CacheExpiryTime {get;set;} 
		public List<String> Headers {get;set;} 
		public String Identifier {get;set;} 
		public String StartDate {get;set;} 
		public String Seniority {get;set;} 
		public String Frequency {get;set;} 
		public String SnapType {get;set;} 
		public String Limit_Z {get;set;} // in json: Limit
		public List<Rows> Rows {get;set;} 
		public Properties Properties {get;set;} 
		public String EndDate {get;set;} 

		public GDSSDKResponse(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'Function') {
							Function = parser.getText();
						} else if (text == 'Mnemonic') {
							Mnemonic = parser.getText();
						} else if (text == 'NumCols') {
							NumCols = parser.getIntegerValue();
						} else if (text == 'NumRows') {
							NumRows = parser.getIntegerValue();
						} else if (text == 'ErrMsg') {
							ErrMsg = parser.getText();
						} else if (text == 'CacheExpiryTime') {
							CacheExpiryTime = parser.getText();
						} else if (text == 'Headers') {
							Headers = arrayOfString(parser);
						} else if (text == 'Identifier') {
							Identifier = parser.getText();
						} else if (text == 'StartDate') {
							StartDate = parser.getText();
						} else if (text == 'Seniority') {
							Seniority = parser.getText();
						} else if (text == 'Frequency') {
							Frequency = parser.getText();
						} else if (text == 'SnapType') {
							SnapType = parser.getText();
						} else if (text == 'Limit') {
							Limit_Z = parser.getText();
						} else if (text == 'Rows') {
							Rows = arrayOfRows(parser);
						} else if (text == 'Properties') {
							Properties = new Properties(parser);
						} else if (text == 'EndDate') {
							EndDate = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'GDSSDKResponse consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Properties {
		public String endrank {get;set;} 
		public String startrank {get;set;} 

		public Properties(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'endrank') {
							endrank = parser.getText();
						} else if (text == 'startrank') {
							startrank = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Properties consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Rows {
		public List<String> Row {get;set;} 

		public Rows(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'Row') {
							Row = arrayOfString(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'Rows consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	
	public static clientNewIqWrapper parse(String json) {
		System.JSONParser parser = System.JSON.createParser(json);
		return new clientNewIqWrapper(parser);
	}
	
	public static void consumeObject(System.JSONParser parser) {
		Integer depth = 0;
		do {
			System.JSONToken curr = parser.getCurrentToken();
			if (curr == System.JSONToken.START_OBJECT || 
				curr == System.JSONToken.START_ARRAY) {
				depth++;
			} else if (curr == System.JSONToken.END_OBJECT ||
				curr == System.JSONToken.END_ARRAY) {
				depth--;
			}
		} while (depth > 0 && parser.nextToken() != null);
	}
	

    private static List<GDSSDKResponse> arrayOfGDSSDKResponse(System.JSONParser p) {
        List<GDSSDKResponse> res = new List<GDSSDKResponse>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new GDSSDKResponse(p));
        }
        return res;
    }




    private static List<String> arrayOfString(System.JSONParser p) {
        List<String> res = new List<String>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(p.getText());
        }
        return res;
    }


    private static List<Rows> arrayOfRows(System.JSONParser p) {
        List<Rows> res = new List<Rows>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Rows(p));
        }
        return res;
    }

















}