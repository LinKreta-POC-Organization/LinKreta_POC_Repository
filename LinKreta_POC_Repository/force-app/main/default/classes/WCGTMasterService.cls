public class WCGTMasterService {
    public static String getWCGTRecord(String wcgtType,String paraDesc){
        system.debug('wcgtType:'+wcgtType);
        system.debug('paraDesc:'+paraDesc);
        if(String.isNotBlank(wcgtType) && String.isNotBlank(paraDesc)){
            List<WCGT_Master__c> wcgt = new List<WCGT_Master__c>();
            wcgt = [SELECT 	WCGT_Id__c,	Name, Type__c, 	Para_Desc__c FROM WCGT_Master__c WHERE Type__c =: wcgtType AND Para_Desc__c =: paraDesc LIMIT 1];
            if(wcgt != null && wcgt.size() > 0){
                system.debug('9');
                return wcgt[0].WCGT_Id__c;
            }else{
                return '';
            }
        }else{
            return '';
        }
    }
    public static List<WCGT_Master__c> getWCGTRecord(Set<String> wcgtValues){
        if(wcgtValues.size() > 0){
            List<WCGT_Master__c> wcgt = new List<WCGT_Master__c>();
            wcgt = [SELECT 	WCGT_Id__c,	Name, Type__c, 	Para_Desc__c FROM WCGT_Master__c WHERE Para_Desc__c IN :wcgtValues];
            return wcgt;
        }else{
            return null;
        }
    }
    public static Map<String,String> getWCGTValueMap(Set<String> wcgtValues){
        try{
            Map<String,String> mapValueToId = new Map<String,String>();
            if(wcgtValues.size() > 0){
                List<WCGT_Master__c> listWCGT = WCGTMasterService.getWCGTRecord(wcgtValues);
                if(listWCGT != null){
                    for(WCGT_Master__c wcgt : listWCGT){
                        if(wcgt.Para_Desc__c != null && wcgt.WCGT_Id__c != null){
                            mapValueToId.put(wcgt.Para_Desc__c,wcgt.WCGT_Id__c);
                        }
                    }
                }
            }
            return mapValueToId;
        }catch(Exception e){
            system.debug('Exception e:'+e.getLineNumber()+' '+e.getMessage());
            return null;
        }
    }
    public static String getWCGTId(String paraDesc,String wcgtType){
        system.debug('paraDesc:'+paraDesc);
        if(String.isNotBlank(paraDesc) && String.isNotBlank(wcgtType)){
            List<WCGT_Master__c> wcgtList = new List<WCGT_Master__c>();
            string wcgtId = '';
            wcgtList = [SELECT 	WCGT_Id__c,	Name, Type__c,Para_Desc__c FROM WCGT_Master__c WHERE Type__c =: wcgtType];
            if(wcgtList != null && wcgtList.size() > 0){
                for(WCGT_Master__c wcgt : wcgtList){
                    if(String.isNotBlank(wcgt.Para_Desc__c) && !wcgt.Para_Desc__c.contains('above')){
                        if(Decimal.valueOf(paraDesc) >= Decimal.valueOf(wcgt.Para_Desc__c.split('-')[0]) && 
                           Decimal.valueOf(paraDesc) <= Decimal.valueOf(wcgt.Para_Desc__c.split('-')[1])){
							return wcgt.WCGT_Id__c;                                                                         
                        }
                    }else if(wcgt.Para_Desc__c.contains('above')){
                        wcgtId = wcgt.WCGT_Id__c;
                    }
                }
            }
            return wcgtId;
        }else{
            return '';
        }
    }
    public static Map<String,String> getWCGTIdByMap(Map<String,String> dataMap){
        List<WCGT_Master__c> wcgtList = new List<WCGT_Master__c>();
        Map<String,String> wcgtIdMap  = new Map<String,String>();
        //Added by Prashant on 22-Apr-2024
        if(! dataMap.containsKey('Country HQ') && dataMap.containsKey('CountryId')) {
            dataMap.put('Country HQ', '');
        }
        if(dataMap.keySet().size() > 0){
            wcgtList = [SELECT 	WCGT_Id__c,	Name, Type__c, 	Para_Desc__c FROM WCGT_Master__c WHERE Type__c IN :dataMap.KeySet()  AND Para_Desc__c =: dataMap.values()];
            system.debug('wcgtList:'+wcgtList);
            if(wcgtList != null && wcgtList.size() > 0){
                for(WCGT_Master__c wcgt : wcgtList){
                    for(String key : dataMap.keySet()){
                        //Updated by Prashant on 22-Apr-2024
                        if(wcgt.Type__c != null && key == wcgt.Type__c && (key != 'Country HQ' && key != 'CountryId')){
                            if(dataMap.get(key) == wcgt.Para_Desc__c){
                                dataMap.put(key,wcgt.WCGT_Id__c);
                            }                        
                        } else if(wcgt.Type__c != null && (key == 'Country HQ' || key == 'CountryId')){
                            if(dataMap.get(key) == wcgt.Para_Desc__c){
                                dataMap.put(key,wcgt.WCGT_Id__c);
                            }                        
                        }
                    }
                }
                wcgtIdMap.putAll(dataMap);
            }
        }
        return wcgtIdMap;
    }
}