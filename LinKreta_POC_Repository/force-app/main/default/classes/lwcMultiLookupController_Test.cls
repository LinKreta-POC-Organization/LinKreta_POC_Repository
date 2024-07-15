@isTest
public class lwcMultiLookupController_Test {
    
    @TestSetup  
    public static void setup() {   
        User u = TestDataFactory.createUserRecord();
        u.firstName = 'test2';
        u.UserName = 'test2@GTTestUser.com';
        u.EMP_ID__c = 'EMP0013';
        insert u;
    }
    @isTest
    public static void testMultilookUp(){
        User u = TestDataFactory.createUserRecord();
        u.firstName = 'test';
        u.EMP_ID__c = 'EMP0012';
        insert u;
        
        DateTime myDateTime = DateTime.newInstance(2023, 2, 11, 8, 6, 00);
        DateTime newDateTime = myDateTime.addMinutes(60);
        Event ev = new Event();
        ev.Subject = 'Email';
        ev.Actual_Attendees__c = 'Test';
        ev.DurationInMinutes = 60;
        ev.AttendeesId__c = u.Id;
        ev.StartDateTime = myDateTime;
        ev.EndDateTime = newDateTime;
        insert ev;
        
        Contact con = TestDataFactory.createContactRecord();
        insert con;
        
        EventRelation evRel = new EventRelation();
        evRel.EventId = ev.Id;
        evRel.RelationId = u.Id;
        insert evRel;
        
        EventRelation evRel2 = new EventRelation();
        evRel2.EventId = ev.Id;
        evRel2.RelationId = con.Id;
        insert evRel2;
        List<String> EmList = new List<String>();
        //EmList.add(evRel2);
        //EmList.add(u.Id);
        
        Test.startTest();
        lwcMultiLookupController.getResults('User', 'Name', 'test', null, false);
        lwcMultiLookupController.getResults('User', 'Name', 'test', EmList, true);
        lwcMultiLookupController.updateAttendees(ev.Id, ev.AttendeesId__c);

        lwcMultiLookupController.getSelectedAttendees(ev.Id);
        Test.stopTest();
    }
    
    @isTest
    public static void testMultilookUp1(){
        User u = [SELECt Id,Name,EMP_ID__c FROM User WHERE EMP_ID__c !=null LIMIT 1];
        DateTime myDateTime = DateTime.newInstance(2023, 2, 11, 8, 6, 00);
        DateTime newDateTime = myDateTime.addMinutes(60);
        Event ev = new Event();
        ev.Subject = 'Email';
        ev.AttendeesId__c = u.Id;
        //ev.Actual_Attendees__c = 'Test';
        ev.DurationInMinutes = 60;
        ev.StartDateTime = myDateTime;
        ev.EndDateTime = newDateTime;
        insert ev;
        
        Contact con = TestDataFactory.createContactRecord();
        insert con;
        
        EventRelation evRel = new EventRelation();
        evRel.EventId = ev.Id;
        evRel.RelationId = u.Id;
        insert evRel;
        List<String> EmList = new List<String>();
        lwcMultiLookupController.getSelectedAttendees(ev.Id);
        lwcMultiLookupController.updateAttendees(ev.Id, con.Id);
        
        //lwcMultiLookupController.SObjectResult obj = new lwcMultiLookupController.SObjectResult(ev.Subject,'Test',ev.Id);
    }
}