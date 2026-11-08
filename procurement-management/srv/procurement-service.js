const cds = require('@sap/cds');

module.exports = cds.service.impl(async function () {

    const {
    PurchaseRequests,
    PurchaseRequestItems,
    ApprovalHistory,
    Employees,
    Suppliers,
    Products
} = this.entities;
// Calculate Purchase Request Item values
    // Product -> Unit Price
    // Quantity × Unit Price -> Line Total

 const calculatePurchaseRequestItem = async (req) => {
    let productId = req.data.product_ID;
    let quantity = req.data.quantity;

    if (req.event === 'UPDATE') {

            const itemId =
                req.data.ID ||
                req.params?.[1]?.ID;

            if (itemId) {

                const existingItem = await SELECT.one
                    .from(req.target)
                    .columns('product_ID', 'quantity')
                    .where({ ID: itemId });

                if (existingItem) {

                    if (!productId) {
                        productId = existingItem.product_ID;
                    }

                    if (quantity == null) {
                        quantity = existingItem.quantity;
                    }
                }
            }
        }

        // Fiori Draft creates and updates the item in multiple steps.
        // Allow incomplete intermediate states.

        if (!productId || quantity == null) {
            return;
        }

        if (Number(quantity) <= 0) {
            req.error(400, 'Quantity must be greater than 0');
            return;
        }

        const product = await SELECT.one
            .from(Products)
            .columns('ID', 'productId', 'name', 'unitPrice', 'currency')
            .where({ ID: productId });

        if (!product) {
            req.error(400, 'Selected product does not exist');
            return;
        }

        req.data.unitPrice = product.unitPrice;

        req.data.lineTotal =
            Number(quantity) * Number(product.unitPrice);

        if (!req.data.currency) {
            req.data.currency = product.currency;
        }
    };

    // Recalculate Purchase Request total amount and approval level
const recalculatePurchaseRequestTotal = async (purchaseRequestId) => {

    if (!purchaseRequestId) {
        return;
    }

    const items = await SELECT
        .from(PurchaseRequestItems)
        .columns('lineTotal')
        .where({ purchaseRequest_ID: purchaseRequestId });

    const totalAmount = items.reduce(
        (sum, item) => sum + Number(item.lineTotal || 0),
        0
    );

    let approvalLevel;

    if (totalAmount <= 5000) {
        approvalLevel = 'Manager';
    } else if (totalAmount <= 20000) {
        approvalLevel = 'Department Head';
    } else {
        approvalLevel = 'Finance';
    }

    await UPDATE(PurchaseRequests)
        .set({
            totalAmount,
            approvalLevel
        })
        .where({ ID: purchaseRequestId });
};

    

    this.before('CREATE', 'PurchaseRequestItems.drafts', calculatePurchaseRequestItem);
    this.before('UPDATE', 'PurchaseRequestItems.drafts', calculatePurchaseRequestItem);

    this.after('CREATE', PurchaseRequestItems, async (item) => {

    if (!item || !item.purchaseRequest_ID) {
        return;
    }

    await recalculatePurchaseRequestTotal(
        item.purchaseRequest_ID
    );
});


this.after('UPDATE', PurchaseRequestItems, async (item) => {

    if (!item || !item.purchaseRequest_ID) {
        return;
    }

    await recalculatePurchaseRequestTotal(
        item.purchaseRequest_ID
    );
});


// Capture Purchase Request ID before deleting an Item
this.before('DELETE', PurchaseRequestItems, async (req) => {

    const itemId =
        req.data?.ID ||
        req.params?.[0]?.ID;

    if (!itemId) {
        return;
    }

    const existingItem = await SELECT.one
        .from(PurchaseRequestItems)
        .columns('purchaseRequest_ID')
        .where({ ID: itemId });

    if (existingItem) {
        req._purchaseRequestId = existingItem.purchaseRequest_ID;
    }
});


// Recalculate total after Item deletion
this.after('DELETE', PurchaseRequestItems, async (item, req) => {

    const purchaseRequestId =
        req?._purchaseRequestId ||
        item?.purchaseRequest_ID;

    if (!purchaseRequestId) {
        return;
    }

    await recalculatePurchaseRequestTotal(
        purchaseRequestId
    );
});
    // Recalculate Purchase Request total after Draft activation
// Draft activation triggers SAVE on the draft entity.

this.after('SAVE', PurchaseRequests.drafts, async (result, req) => {
    const purchaseRequestId =
        result?.ID ||
        req?.data?.ID;
    if (!purchaseRequestId) {
        return;
    }

    await recalculatePurchaseRequestTotal(purchaseRequestId);
});
    this.on('READ', 'PurchaseRequestSummary', async (req) => {

    const requests = await SELECT
        .from(PurchaseRequests)
        .columns('status', 'totalAmount');

    let totalRequests = requests.length;
    let pendingRequests = 0;
    let approvedRequests = 0;
    let rejectedRequests = 0;
    let totalAmount = 0;

    for (const request of requests) {

        if (request.status === 'PENDING') {
            pendingRequests++;
        }

        if (request.status === 'APPROVED') {
            approvedRequests++;
        }

        if (request.status === 'REJECTED') {
            rejectedRequests++;
        }

        if (request.totalAmount != null) {
            totalAmount += Number(request.totalAmount);
        }
    }

    return [{
        ID: '1',
        totalRequests,
        pendingRequests,
        approvedRequests,
        rejectedRequests,
        totalAmount
    }];
});

this.after('READ', PurchaseRequestItems, async (items) => {

    if (!items) return;

    const rows = Array.isArray(items) ? items : [items];

    const productIds = [
        ...new Set(
            rows
                .map(item => item.product_ID)
                .filter(Boolean)
        )
    ];

    if (productIds.length === 0) return;

    const products = await SELECT
        .from(Products)
        .columns('ID', 'productId')
        .where({ ID: { in: productIds } });

    const productMap = new Map(
        products.map(product => [
            product.ID,
            product.productId
        ])
    );

    for (const item of rows) {
        item.productId = productMap.get(item.product_ID) || null;
    }
});

    // Automatically set values and validate when creating a Purchase Request
// Automatically generate Employee ID

this.before('CREATE', Employees, async (req) => {

    if (!req.data.employeeId) {

        const existingEmployees = await SELECT
            .from(Employees)
            .columns('employeeId');

        let maxNumber = 0;

        for (const employee of existingEmployees) {

            if (!employee.employeeId) {
                continue;
            }

            const match =
                employee.employeeId.match(/^E(\d+)$/);

            if (match) {

                const number =
                    parseInt(match[1], 10);

                if (number > maxNumber) {
                    maxNumber = number;
                }
            }
        }

        req.data.employeeId =
            'E' + String(maxNumber + 1).padStart(3, '0');
    }
});
 this.before('CREATE', Suppliers, async (req) => {

    if (!req.data.supplierId) {

        const existingSuppliers = await SELECT
            .from(Suppliers)
            .columns('supplierId');

        let maxNumber = 0;

        for (const supplier of existingSuppliers) {

            if (!supplier.supplierId) {
                continue;
            }

            const match =
                supplier.supplierId.match(/^S(\d+)$/);

            if (match) {

                const number =
                    parseInt(match[1], 10);

                if (number > maxNumber) {
                    maxNumber = number;
                }
            }
        }

        req.data.supplierId =
            'S' + String(maxNumber + 1).padStart(3, '0');
    }
});

this.before('CREATE', PurchaseRequests, async (req) => {

    // Validate description
    if (!req.data.description || !req.data.description.trim()) {
        req.error(400, 'Description is required');
    }

    // Total amount is calculated automatically from purchase request items

    // Validate currency
    if (!req.data.currency || !req.data.currency.trim()) {
        req.error(400, 'Currency is required');
    }

    // Validate requested date
    if (!req.data.requestedDate) {
        req.error(400, 'Requested date is required');
    }

    // Set default status
    if (!req.data.status) {
        req.data.status = 'PENDING';
    }

   

    // Generate Request Number
    if (!req.data.requestNumber) {

    const existingRequests = await SELECT
        .from(PurchaseRequests)
        .columns('requestNumber');

    let maxNumber = 0;

    for (const item of existingRequests) {

        if (!item.requestNumber) {
            continue;
        }

        const match = item.requestNumber.match(/^P(\d+)$/);

        if (match) {
            const number = parseInt(match[1], 10);

            if (number > maxNumber) {
                maxNumber = number;
            }
        }
    }

    req.data.requestNumber =
        'P' + String(maxNumber + 1).padStart(4, '0');
}
});


    // Approve Purchase Request
this.on('approveRequest', PurchaseRequests, async (req) => {

    const id = req.params[0].ID;

    const request = await SELECT.one
        .from(PurchaseRequests)
        .where({ ID: id });

    if (!request) {
        req.reject(404, 'Purchase request not found');
    }

    if (request.status !== 'PENDING') {
        req.reject(
            400,
            'Only PENDING purchase requests can be approved'
        );
    }

    await UPDATE(PurchaseRequests)
    .set({
        status: 'APPROVED',
        approvedDate: new Date()
    })
    .where({ ID: id });

    await INSERT.into(ApprovalHistory).entries({
    purchaseRequest_ID: id,
    action: 'APPROVED',
    comments: 'Purchase request approved',
    actionDate: new Date()
    });

    return req.info('Purchase request approved');
    });


    // Reject Purchase Request
    this.on('rejectRequest', PurchaseRequests, async (req) => {

        const id = req.params[0].ID;

        const request = await SELECT.one
            .from(PurchaseRequests)
            .where({ ID: id });

        if (!request) {
            req.error(404, 'Purchase request not found');
            return;
        }

        if (request.status !== 'PENDING') {
            req.error(
                400,
                'Only PENDING purchase requests can be rejected'
            );
            return;
        }

        await UPDATE(PurchaseRequests)
            .set({
                status: 'REJECTED',
                approvedDate: null
            })
            .where({ ID: id });
            
        await INSERT.into(ApprovalHistory)
            .entries({
                purchaseRequest_ID: id,
                action: 'REJECTED',
                comments: 'Purchase request rejected',
                actionDate: new Date()
            });
        return req.info('Purchase request rejected');
        });

    });