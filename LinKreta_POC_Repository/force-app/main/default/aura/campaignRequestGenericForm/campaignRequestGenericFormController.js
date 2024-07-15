({
    init : function (component,event) {
        var flow = component.find("campaignRequestFlow");
        flow.startFlow("Screen_Flow_Create_Generic_Campaign_Request");
    }
})