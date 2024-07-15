({
	handleLWCMethodCall : function(component, event, helper) {
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