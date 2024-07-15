public without sharing class GenericPicklistController {
 @AuraEnabled(cacheable=true)
    public static List<PiclistWrapperClass> PicklistValues(String objectname, String fieldname){
      List<PiclistWrapperClass> wrapperList = new List<PiclistWrapperClass>();
       String[] types = new String[]{objectname};
        Schema.DescribeSobjectResult[] results = Schema.describeSObjects(types);
        for(Schema.DescribeSobjectResult res : results) {
           for (Schema.PicklistEntry entry : res.fields.getMap().get(fieldname).getDescribe().getPicklistValues()) {
              if (entry.isActive()) {
               PiclistWrapperClass pwc = new PiclistWrapperClass();
                pwc.picklistvalue = entry.getValue();
                pwc.picklistlabel=  entry.getLabel();
                  wrapperList.add(pwc);
              }
           }
        }
        return wrapperList;
     }

     public class PiclistWrapperClass{
        @AuraEnabled public String picklistvalue;
        @AuraEnabled public String picklistlabel;
     }
}