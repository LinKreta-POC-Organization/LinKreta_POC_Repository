({
	helperMethod : function(component,helper) {
        var recId= component.get("v.recordId");
        var comments = component.get("v.myVal");
        var action = component.get("c.sendProposedAccountOwnerApproval");
        action.setParams({ "recordId" : recId ,
                          "assignApproval": 'Proposed_Account_Owner_Approval_Request',
                         "comments": comments});
        action.setCallback(this,function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "message": "Sent Successfully",
                    duration:' 5000',
                    type: 'success'    
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);
        $A.get('e.force:refreshView').fire();
        var dismissActionPanel = $A.get("e.force:closeQuickAction");
        dismissActionPanel.fire();
    
	}
})