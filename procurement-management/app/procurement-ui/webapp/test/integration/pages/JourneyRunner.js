sap.ui.define([
    "sap/fe/test/JourneyRunner",
	"company/procurement/procurementui/test/integration/pages/PurchaseRequestsList.gen",
	"company/procurement/procurementui/test/integration/pages/PurchaseRequestsObjectPage.gen"
], function (JourneyRunner, PurchaseRequestsListGenerated, PurchaseRequestsObjectPageGenerated) {
    'use strict';

    const runner = new JourneyRunner({
        launchUrl: sap.ui.require.toUrl('company/procurement/procurementui') + '/test/flp.html#app-preview',
        pages: {
			onThePurchaseRequestsListGenerated: PurchaseRequestsListGenerated,
			onThePurchaseRequestsObjectPageGenerated: PurchaseRequestsObjectPageGenerated
        },
        async: true
    });

    return runner;
});

