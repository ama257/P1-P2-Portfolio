service SupplierIntegrationService @(path: '/supplier-integration') {

    @cds.persistence.skip
    entity Suppliers {
        key ID       : UUID;
            supplierId : String(20);
            name       : String(100);
            email      : String(100);
            phone      : String(30);
            country    : String(50);
            createdAt  : Timestamp;
            createdBy  : String(255);
            modifiedAt : Timestamp;
            modifiedBy : String(255);
    }

}