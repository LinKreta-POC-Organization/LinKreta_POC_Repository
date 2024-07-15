// OpenIntrohiveActionController.js
({
    openIntrohive : function(component, event, helper) {
        // Open Introhive in a new tab
        window.open('https://aus.introhive.com', '_blank');
        
        // Close the action modal if needed
        $A.get("e.force:closeQuickAction").fire();
    }
})