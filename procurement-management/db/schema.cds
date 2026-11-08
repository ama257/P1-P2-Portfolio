namespace company.procurement;

using { cuid, managed } from '@sap/cds/common';

@cds.odata.valuelist
entity Employees : cuid, managed {
    employeeId  : String(20);
    firstName   : String(50);
    lastName    : String(50);
    email       : String(100);
    department  : String(50);
    manager     : Association to Employees;
}

@cds.odata.valuelist
entity Suppliers : cuid, managed {
    supplierId  : String(20);
    name        : String(100);
    email       : String(100);
    phone       : String(30);
    country     : String(50);
}

@cds.odata.valuelist
entity Products : cuid, managed {
    productId   : String(20);
    name        : String(100);
    category    : String(50);
    unitPrice   : Decimal(15,2);
    currency    : String(3);
}
entity PurchaseRequests : cuid, managed {

    requestNumber : String(20);

    requester : Association to Employees;

    supplier : Association to Suppliers;

    description : String(255);

    totalAmount : Decimal(15,2);

    currency : String(3);

    status : String(20);

    requestedDate : Date;

    approvedDate : Date;

    approvalLevel : String(30);

    approvalHistory : Association to many ApprovalHistory
        on approvalHistory.purchaseRequest = $self;

    items : Composition of many PurchaseRequestItems on items.purchaseRequest = $self;
}

entity ApprovalHistory : cuid, managed {

    purchaseRequest : Association to PurchaseRequests;

    action : String(20);

    comments : String(255);

    actionDate : DateTime;
}

entity PurchaseRequestItems : cuid, managed {

    purchaseRequest : Association to PurchaseRequests;

    product : Association to Products;

    quantity : Decimal(15,2);

    unitPrice : Decimal(15,2);

    lineTotal : Decimal(15,2);

    currency : String(3);
}

entity PurchaseRequestSummary {
    key ID : String(1);
    totalRequests : Integer;
    pendingRequests : Integer;
    approvedRequests : Integer;
    rejectedRequests : Integer;
    totalAmount : Decimal(15,2);
}