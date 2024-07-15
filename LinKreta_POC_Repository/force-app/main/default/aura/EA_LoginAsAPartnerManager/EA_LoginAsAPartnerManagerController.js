({
    init : function (component)
    {
        var flow = component.find("flowData");
        flow.startFlow("EA_Login_As_a_Partner_From_Global_Action");
        
    },
    
    statusChange : function (cmp, event, helper) {
        console.log('Flow Status : '  + event.getParam('status'));
        if (event.getParam('status') === "FINISHED") {
            let outputVariables = event.getParam("outputVariables");
            console.log('outputVariables: ', JSON.stringify(outputVariables));       
            helper.ClosePopUp(cmp,event,helper); 
        }
    }
})