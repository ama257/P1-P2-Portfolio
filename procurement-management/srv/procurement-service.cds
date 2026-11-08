using { company.procurement as db } from '../db/schema';

service ProcurementService @(path: '/procurement') {

    @odata.draft.enabled
    entity Employees as projection on db.Employees;

    @odata.draft.enabled
    entity Suppliers as projection on db.Suppliers;

    @odata.draft.enabled
    entity Products as projection on db.Products;

    @odata.draft.enabled
    entity PurchaseRequests as projection on db.PurchaseRequests
        actions {
            action approveRequest();
            action rejectRequest();
        };

    entity PurchaseRequestItems as projection on db.PurchaseRequestItems;   
    
    entity ApprovalHistory as projection on db.ApprovalHistory {
        *,
        purchaseRequest : redirected to PurchaseRequests
    };    
    entity PurchaseRequestSummary as projection on db.PurchaseRequestSummary;
}