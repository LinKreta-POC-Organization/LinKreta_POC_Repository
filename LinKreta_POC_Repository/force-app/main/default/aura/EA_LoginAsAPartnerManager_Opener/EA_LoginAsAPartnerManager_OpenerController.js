({
    init : function (component) {
        var maximizeButton = document.querySelector('[title="Maximize"]');

        if (maximizeButton) {
            maximizeButton.click();
        }
    },
    getCloseQuickAction : function(component, event){
        var CloseButton = document.querySelector('[title="Close"]');

        if (CloseButton) {
            CloseButton.click();
        }
    }
})