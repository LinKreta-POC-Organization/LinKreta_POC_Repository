({
	handleLWCMethodCallHelper : function(component, event, helper) {
        console.log('Aura Component Loaded');
		var getRecordId = component.get("v.recordId");
        console.log('RecordId :',getRecordId);
        component.find('lWCChild').callFromParent(getRecordId); 
        console.log('Aura Component Loaded--->>>End');
	}
})