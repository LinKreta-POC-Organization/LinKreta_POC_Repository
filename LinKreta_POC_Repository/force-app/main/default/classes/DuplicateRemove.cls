/*
* @Name: DuplicateRemove
* @Author: Bhavishya Basantwani
* @Description: This class is used for Remove Duplicate Record with Some Specific Text.
* @Date: 15th-september-23
*/
public class DuplicateRemove {
    @InvocableMethod()
    public static List<ActionResponce> Remove(List<ActionRequest> getInfo){
        
        List<ActionResponce> listOfResp = new List<ActionResponce>();
        List<Sobject> UniqueRecordList = new List<Sobject>();
        Map<String,Sobject> MapOfUnique= new  Map<String,Sobject>();
        List<Sobject> listOfSobject = new List<Sobject>();
        ActionResponce ResObj = new ActionResponce();

        
        string respectiveField = getInfo[0].respectiveField;
        for(Sobject obj : getInfo[0].ListOfRecords){
            
            String Key = String.ValueOf(obj.get(respectiveField));
            if(!MapOfUnique.ContainsKey(Key)){
                MapOfUnique.put(Key,obj);
            }
        }
        
        
        
        for(String Key : MapOfUnique.KeySet()){
            UniqueRecordList.add(MapOfUnique.get(Key));
        }
        
        
        system.debug('UniqueRecordList>>>'+UniqueRecordList);
        ResObj.ListObj = UniqueRecordList;
        listOfResp.add(ResObj);
        
        return listOfResp;
    }
    
    public class ActionRequest{
        @InvocableVariable
        public List<Sobject> ListOfRecords; 
        @InvocableVariable
        public string NameOfObject; 
        @InvocableVariable
        public string NameOfFields;  
        @InvocableVariable
        public string respectiveField;
        
    }
    
    public class ActionResponce{
        @InvocableVariable
        public List<Sobject> ListObj; 
    }
    
}