({
	ClosePopUp : function(cmp,event,helper){
		var parentComponent = cmp.get("v.parent");                         
		    parentComponent.closeQuickAction();
		var toastEvent = $A.get("e.force:showToast");
			toastEvent.setParams({
				"title": "Success!",
				"type":"success",
				"message": "You have successfully switched !!"
			});
		    toastEvent.fire();

		/* let baseURL = window.location.hostname;
			baseURL = 'https://'+baseURL+'/lightning/page/home';
			//$A.get('e.force:refreshView').fire();
			window.open(baseURL,'_self'); */
            //document.location.reload(true);
		// window.location.reload();
		/*var urlEvent = $A.get("e.force:navigateToURL");
			urlEvent.setParams({
			"url": baseURL
			});
			urlEvent.fire(); */
			window.setTimeout(
				$A.getCallback(function() {
					let baseURL = window.location.hostname;
					baseURL = 'https://'+baseURL+'/lightning/page/home';
					//$A.get('e.force:refreshView').fire();
					window.open(baseURL,'_self');
				}), 1000
			);
			
    }
})