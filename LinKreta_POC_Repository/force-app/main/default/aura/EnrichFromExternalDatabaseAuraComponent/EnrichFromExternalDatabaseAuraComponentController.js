({
	handleLWCMethodCall : function(component, event, helper) {
       /* console.log('Aura Component Loaded');
		var getRecordId = component.get("v.recordId");
        console.log('RecordId :',getRecordId);
        component.find('lWCChild').callFromParent(getRecordId); 
        console.log('Aura Component Loaded--->>>End');*/
        window.setTimeout(
            $A.getCallback(function() {
                var getRecordId = component.get("v.recordId");
                component.find('lWCChild').callFromParent(getRecordId); 
                
            }),10
        );
	},
    closeScreen : function(component, event, helper){
        console.log('---->>>>>17');
           	$A.get("e.force:closeQuickAction").fire();
    }
})