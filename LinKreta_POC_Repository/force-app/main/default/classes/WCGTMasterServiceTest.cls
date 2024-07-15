/*Author Name :  Muskan Soni
*/
@istest
public class WCGTMasterServiceTest {
    @testSetup
    public static void testData(){
        WCGT_Master__c wcgtObj = new WCGT_Master__c();
        wcgtObj.Type__c ='Client Type';
        wcgtObj.Para_Desc__c='80.0-90.0';
        insert wcgtObj;
        
        WCGT_Master__c wcgtObj1 = new WCGT_Master__c();
        wcgtObj1.Type__c ='Client Type';
        wcgtObj1.Para_Desc__c='80.0-70.0';
        insert wcgtObj1;
        
    }
    
    @istest
    public static void test(){
        list <WCGT_Master__c> wcgtList =[select id,Type__c,name,Para_Desc__c from WCGT_Master__c];
        set<String> wgtValuesSet = new set <String>();
        map <String,String> wgtMap = new map<String,String>();
        for(WCGT_Master__c obj : wcgtList){
            wgtMap.put(obj.Type__c,obj.Para_Desc__c);
            wgtValuesSet.add(obj.Para_Desc__c);
        }
        WCGTMasterService.getWCGTRecord(wcgtList[0].Para_Desc__c,wcgtList[0].Type__c);
        WCGTMasterService.getWCGTRecord(wgtValuesSet);
        WCGTMasterService.getWCGTValueMap(wgtValuesSet);
        WCGTMasterService.getWCGTIdByMap(wgtMap);
    }
     @istest
    public static void test1(){
        list <WCGT_Master__c> wcgtList =[select id,Type__c,name,Para_Desc__c from WCGT_Master__c where Para_Desc__c='80.0-70.0' ];
        set<String> wgtValuesSet = new set <String>();
        wgtValuesSet.add('');
        WCGTMasterService.getWCGTRecord('','');
        WCGTMasterService.getWCGTValueMap(wgtValuesSet);
       WCGTMasterService.getWCGTId('80.0',wcgtList[0].Type__c);
    }
    //Phase-1 Rakesh
    @istest
    public static void test2(){
        list <WCGT_Master__c> wcgtList =[select id,Type__c,name,Para_Desc__c from WCGT_Master__c where Para_Desc__c='80.0-70.0' ];
        wcgtList[0].Para_Desc__c = 'above';
        wcgtList[0].Type__c = '';
        update wcgtList;
        set<String> wgtValuesSet = new set <String>();
        wgtValuesSet.add('');
        map <String,String> wgtMap = new map<String,String>();
        for(WCGT_Master__c obj : wcgtList){
            wgtMap.put(obj.Type__c,obj.Para_Desc__c);
            wgtValuesSet.add(obj.Para_Desc__c);
        }
        WCGTMasterService.getWCGTIdByMap(wgtMap);
        WCGTMasterService.getWCGTRecord('','');
        WCGTMasterService.getWCGTValueMap(wgtValuesSet);
       WCGTMasterService.getWCGTId('80.0',wcgtList[0].Type__c);
    }

}