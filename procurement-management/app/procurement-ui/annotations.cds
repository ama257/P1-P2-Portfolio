using ProcurementService from '../../srv/procurement-service';

annotate ProcurementService.PurchaseRequests with @(
    Capabilities.InsertRestrictions: {
        Insertable: true
    },

    UI.HeaderInfo: {
        TypeName: 'Purchase Request',
        TypeNamePlural: 'Purchase Requests',
        Title: {
            Value: requestNumber
        },
        Description: {
            Value: description
        }
    },

    UI.Facets: [
    {
        $Type: 'UI.ReferenceFacet',
        ID: 'GeneralInformation',
        Label: 'General Information',
        Target: '@UI.FieldGroup#GeneralInformation'
    },
    {
        $Type: 'UI.ReferenceFacet',
        ID: 'Items',
        Label: 'Items',
        Target: 'items/@UI.LineItem'
    },
    {
        $Type: 'UI.ReferenceFacet',
        ID: 'ApprovalHistory',
        Label: 'Approval History',
        Target: 'approvalHistory/@UI.LineItem'
    }
],

    UI.Identification: [
        {
            $Type: 'UI.DataFieldForAction',
            Action: 'ProcurementService.approveRequest',
            Label: 'Approve'
        },
        {
            $Type: 'UI.DataFieldForAction',
            Action: 'ProcurementService.rejectRequest',
            Label: 'Reject'
        }
    ],

    UI.FieldGroup #GeneralInformation: {
        Data: [
            {
                $Type: 'UI.DataField',
                Value: requestNumber,
                Label: 'Request Number'
            },
            {
                $Type: 'UI.DataField',
                Value: description,
                Label: 'Description'
            },
            {
                $Type: 'UI.DataField',
                Value: requester_ID,
                Label: 'Requester'
            },
            {
                $Type: 'UI.DataField',
                Value: supplier_ID,
                Label: 'Supplier'
            },
            {
                $Type: 'UI.DataField',
                Value: totalAmount,
                Label: 'Total Amount'
            },
            {
                $Type: 'UI.DataField',
                Value: currency,
                Label: 'Currency'
            },
            {
                $Type: 'UI.DataField',
                Value: approvalLevel,
                Label: 'Approval Level'
            },
            {
                $Type: 'UI.DataField',
                Value: status,
                Label: 'Status',
                Criticality: (
                    status = 'PENDING'
                    ? 2
                    : (
                        status = 'APPROVED'
                        ? 3
                        : (
                            status = 'REJECTED'
                            ? 1
                            : 0
                        )
                    )
                )
            },
            {
                $Type: 'UI.DataField',
                Value: requestedDate,
                Label: 'Requested Date'
            },
            {
                $Type: 'UI.DataField',
                Value: approvedDate,
                Label: 'Approved Date'
            }
        ]
    },

    UI.LineItem: [
        {
            $Type: 'UI.DataField',
            Value: requestNumber,
            Label: 'Request Number'
        },
        {
            $Type: 'UI.DataField',
            Value: description,
            Label: 'Description'
        },
        {
            $Type: 'UI.DataField',
            Value: requester_ID,
            Label: 'Requester'
        },
        {
            $Type: 'UI.DataField',
            Value: supplier_ID,
            Label: 'Supplier'
        },
        {
            $Type: 'UI.DataField',
            Value: totalAmount,
            Label: 'Total Amount'
        },
        {
            $Type: 'UI.DataField',
            Value: currency,
            Label: 'Currency'
        },
        {
            $Type: 'UI.DataField',
            Value: approvalLevel,
            Label: 'Approval Level'
        },
        {
            $Type: 'UI.DataField',
            Value: status,
            Label: 'Status',
            Criticality: (
                status = 'PENDING'
                ? 2
                : (
                    status = 'APPROVED'
                    ? 3
                    : (
                        status = 'REJECTED'
                        ? 1
                        : 0
                    )
                )
            )
        },
        {
            $Type: 'UI.DataField',
            Value: requestedDate,
            Label: 'Requested Date'
        }
    ]
);


annotate ProcurementService.Employees with @(
    Capabilities.InsertRestrictions: {
        Insertable: true
    },

    UI.HeaderInfo: {
        TypeName: 'Employee',
        TypeNamePlural: 'Employees',
        Title: {
            Value: employeeId
        },
        Description: {
            Value: firstName
        }
    },

    UI.LineItem: [
        {
            $Type: 'UI.DataField',
            Value: employeeId,
            Label: 'Employee ID'
        },
        {
            $Type: 'UI.DataField',
            Value: firstName,
            Label: 'First Name'
        },
        {
            $Type: 'UI.DataField',
            Value: lastName,
            Label: 'Last Name'
        },
        {
            $Type: 'UI.DataField',
            Value: email,
            Label: 'Email'
        },
        {
            $Type: 'UI.DataField',
            Value: department,
            Label: 'Department'
        }
    ],

    UI.Facets: [
        {
            $Type: 'UI.ReferenceFacet',
            ID: 'EmployeeInformation',
            Label: 'Employee Information',
            Target: '@UI.FieldGroup#EmployeeInformation'
        }
    ],

    UI.FieldGroup #EmployeeInformation: {
        Data: [
            {
                $Type: 'UI.DataField',
                Value: employeeId,
                Label: 'Employee ID'
            },
            {
                $Type: 'UI.DataField',
                Value: firstName,
                Label: 'First Name'
            },
            {
                $Type: 'UI.DataField',
                Value: lastName,
                Label: 'Last Name'
            },
            {
                $Type: 'UI.DataField',
                Value: email,
                Label: 'Email'
            },
            {
                $Type: 'UI.DataField',
                Value: department,
                Label: 'Department'
            }
        ]
    }
);


annotate ProcurementService.Suppliers with @(
    Capabilities.InsertRestrictions: {
        Insertable: true
    },

    UI.HeaderInfo: {
        TypeName: 'Supplier',
        TypeNamePlural: 'Suppliers',
        Title: {
            Value: supplierId
        },
        Description: {
            Value: name
        }
    },

    UI.LineItem: [
        {
            $Type: 'UI.DataField',
            Value: supplierId,
            Label: 'Supplier ID'
        },
        {
            $Type: 'UI.DataField',
            Value: name,
            Label: 'Name'
        },
        {
            $Type: 'UI.DataField',
            Value: email,
            Label: 'Email'
        },
        {
            $Type: 'UI.DataField',
            Value: phone,
            Label: 'Phone'
        },
        {
            $Type: 'UI.DataField',
            Value: country,
            Label: 'Country'
        }
    ],

    UI.Facets: [
        {
            $Type: 'UI.ReferenceFacet',
            ID: 'SupplierInformation',
            Label: 'Supplier Information',
            Target: '@UI.FieldGroup#SupplierInformation'
        }
    ],

    UI.FieldGroup #SupplierInformation: {
        Data: [
            {
                $Type: 'UI.DataField',
                Value: supplierId,
                Label: 'Supplier ID'
            },
            {
                $Type: 'UI.DataField',
                Value: name,
                Label: 'Name'
            },
            {
                $Type: 'UI.DataField',
                Value: email,
                Label: 'Email'
            },
            {
                $Type: 'UI.DataField',
                Value: phone,
                Label: 'Phone'
            },
            {
                $Type: 'UI.DataField',
                Value: country,
                Label: 'Country'
            }
        ]
    }
);


annotate ProcurementService.PurchaseRequests with {

    requester @Common.ValueList: {
        Label: 'Requester',
        CollectionPath: 'Employees',
        Parameters: [
            {
                $Type: 'Common.ValueListParameterInOut',
                LocalDataProperty: requester_ID,
                ValueListProperty: 'ID'
            },
            {
                $Type: 'Common.ValueListParameterDisplayOnly',
                ValueListProperty: 'employeeId'
            },
            {
                $Type: 'Common.ValueListParameterDisplayOnly',
                ValueListProperty: 'firstName'
            },
            {
                $Type: 'Common.ValueListParameterDisplayOnly',
                ValueListProperty: 'lastName'
            },
            {
                $Type: 'Common.ValueListParameterDisplayOnly',
                ValueListProperty: 'department'
            }
        ]
    };

    supplier @Common.ValueList: {
        Label: 'Supplier',
        CollectionPath: 'Suppliers',
        Parameters: [
            {
                $Type: 'Common.ValueListParameterInOut',
                LocalDataProperty: supplier_ID,
                ValueListProperty: 'ID'
            },
            {
                $Type: 'Common.ValueListParameterDisplayOnly',
                ValueListProperty: 'supplierId'
            },
            {
                $Type: 'Common.ValueListParameterDisplayOnly',
                ValueListProperty: 'name'
            },
            {
                $Type: 'Common.ValueListParameterDisplayOnly',
                ValueListProperty: 'country'
            },
            {
                $Type: 'Common.ValueListParameterDisplayOnly',
                ValueListProperty: 'email'
            }
        ]
    };

    requester @Common.Text: requester.employeeId;
    supplier @Common.Text: supplier.supplierId;

    requester @Common.TextArrangement: #TextOnly;
    supplier @Common.TextArrangement: #TextOnly;
};


annotate ProcurementService.ApprovalHistory with @(
    UI.LineItem: [
        {
            $Type: 'UI.DataField',
            Value: action,
            Label: 'Action'
        },
        {
            $Type: 'UI.DataField',
            Value: comments,
            Label: 'Comments'
        },
        {
            $Type: 'UI.DataField',
            Value: actionDate,
            Label: 'Action Date'
        }
    ]
);


annotate ProcurementService.PurchaseRequestSummary with @(
    UI.HeaderInfo: {
        TypeName: 'Purchase Request Summary',
        TypeNamePlural: 'Purchase Request Summary',
        Title: {
            Value: ID
        }
    },

    UI.LineItem: [
        {
            $Type: 'UI.DataField',
            Value: totalRequests,
            Label: 'Total Requests'
        },
        {
            $Type: 'UI.DataField',
            Value: pendingRequests,
            Label: 'Pending Requests'
        },
        {
            $Type: 'UI.DataField',
            Value: approvedRequests,
            Label: 'Approved Requests'
        },
        {
            $Type: 'UI.DataField',
            Value: rejectedRequests,
            Label: 'Rejected Requests'
        },
        {
            $Type: 'UI.DataField',
            Value: totalAmount,
            Label: 'Total Amount'
        }
    ]
);
annotate ProcurementService.Products with @(
    Capabilities.InsertRestrictions: {
        Insertable: true
    },

    UI.HeaderInfo: {
        TypeName: 'Product',
        TypeNamePlural: 'Products',
        Title: {
            Value: productId
        },
        Description: {
            Value: name
        }
    },

    UI.LineItem: [
        {
            $Type: 'UI.DataField',
            Value: productId,
            Label: 'Product ID'
        },
        {
            $Type: 'UI.DataField',
            Value: name,
            Label: 'Name'
        },
        {
            $Type: 'UI.DataField',
            Value: category,
            Label: 'Category'
        },
        {
            $Type: 'UI.DataField',
            Value: unitPrice,
            Label: 'Unit Price'
        },
        {
            $Type: 'UI.DataField',
            Value: currency,
            Label: 'Currency'
        }
    ],

    UI.Facets: [
        {
            $Type: 'UI.ReferenceFacet',
            ID: 'ProductInformation',
            Label: 'Product Information',
            Target: '@UI.FieldGroup#ProductInformation'
        }
    ],

    UI.FieldGroup #ProductInformation: {
        Data: [
            {
                $Type: 'UI.DataField',
                Value: productId,
                Label: 'Product ID'
            },
            {
                $Type: 'UI.DataField',
                Value: name,
                Label: 'Name'
            },
            {
                $Type: 'UI.DataField',
                Value: category,
                Label: 'Category'
            },
            {
                $Type: 'UI.DataField',
                Value: unitPrice,
                Label: 'Unit Price'
            },
            {
                $Type: 'UI.DataField',
                Value: currency,
                Label: 'Currency'
            }
        ]
    }
);
annotate ProcurementService.PurchaseRequestItems with @(
    Capabilities.InsertRestrictions: {
        Insertable: true
    },

    UI.HeaderInfo: {
        TypeName: 'Purchase Request Item',
        TypeNamePlural: 'Purchase Request Items',
        Title: {
            Value: product_ID
        },
        Description: {
            Value: quantity
        }
    },

    UI.Facets: [
        {
            $Type: 'UI.ReferenceFacet',
            ID: 'ItemInformation',
            Label: 'Item Information',
            Target: '@UI.FieldGroup#ItemInformation'
        }
    ],

    UI.FieldGroup #ItemInformation: {
        Data: [
            {
                $Type: 'UI.DataField',
                Value: product_ID,
                Label: 'Product'
            },
            {
                $Type: 'UI.DataField',
                Value: quantity,
                Label: 'Quantity'
            },
            {
                $Type: 'UI.DataField',
                Value: unitPrice,
                Label: 'Unit Price'
            },
            {
                $Type: 'UI.DataField',
                Value: lineTotal,
                Label: 'Line Total'
            },
            {
                $Type: 'UI.DataField',
                Value: currency,
                Label: 'Currency'
            }
        ]
    },

    UI.LineItem: [
        {
            $Type: 'UI.DataField',
            Value: product_ID,
            Label: 'Product'
        },
        {
            $Type: 'UI.DataField',
            Value: quantity,
            Label: 'Quantity'
        },
        {
            $Type: 'UI.DataField',
            Value: unitPrice,
            Label: 'Unit Price'
        },
        {
            $Type: 'UI.DataField',
            Value: lineTotal,
            Label: 'Line Total'
        },
        {
            $Type: 'UI.DataField',
            Value: currency,
            Label: 'Currency'
        }
    ]
);
annotate ProcurementService.PurchaseRequestItems with {
    product @Common.Text: product.productId;
    product @Common.TextArrangement: #TextOnly;

    product @Common.ValueList: {
        Label: 'Product',
        CollectionPath: 'Products',
        Parameters: [
            {
                $Type: 'Common.ValueListParameterInOut',
                LocalDataProperty: product_ID,
                ValueListProperty: 'ID'
            },
            {
                $Type: 'Common.ValueListParameterDisplayOnly',
                ValueListProperty: 'productId'
            },
            {
                $Type: 'Common.ValueListParameterDisplayOnly',
                ValueListProperty: 'name'
            },
            {
                $Type: 'Common.ValueListParameterDisplayOnly',
                ValueListProperty: 'category'
            },
            {
                $Type: 'Common.ValueListParameterDisplayOnly',
                ValueListProperty: 'unitPrice'
            },
            {
                $Type: 'Common.ValueListParameterDisplayOnly',
                ValueListProperty: 'currency'
            }
        ]
    };
};