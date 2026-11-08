Procurement Management

A full-stack procurement management application built with SAP Cloud Application Programming Model (CAP), SAP Fiori elements, OData V4, and SAP HANA Cloud.

The project demonstrates an enterprise-style procurement workflow including employee and supplier management, product selection, purchase request processing, automatic amount calculation, and approval workflows.

Technology Stack

TechnologyPurposeSAP CAPBackend application developmentCDSData modeling and service definitionsNode.jsBackend runtime and business logicOData V4Service communicationSAP Fiori elementsUser interfaceSAPUI5Frontend frameworkSQLiteLocal development databaseSAP HANA CloudCloud databaseSAP BTPCloud platform 

Key Features

Employee Management

Create and manage employee records.

Store employee name, email, department, and manager information.

Automatically generate employee business numbers.

Example: E004

Supplier Management

Create and manage supplier records.

Store supplier name, contact information, and country.

Automatically generate supplier business numbers.

Select suppliers through Fiori value help.

Example: S004

Product Management

Create and manage product master data.

Store product ID, name, category, unit price, and currency.

Select products through Fiori value help.

Purchase Request Management

Create and manage purchase requests.

Assign requester and supplier.

Automatically generate request numbers.

Track request status.

Manage multiple purchase request items.

Example:

P0001

Purchase Request Items

Each purchase request can contain multiple items.

Each item includes:

Product

Quantity

Unit price

Line total

Currency

The system automatically retrieves the selected product's unit price.

Line Total = Quantity × Unit Price 

The purchase request total amount is automatically calculated from all item line totals.

When items are created, updated, or deleted, the total amount and approval level are recalculated.

Approval Workflow

Purchase requests support:

PENDING

APPROVED

REJECTED

Users can approve or reject pending requests through custom CAP actions.

Approval and rejection actions are recorded in ApprovalHistory.

Approval Level

The approval level is automatically determined by the total amount.

Total AmountApproval Level≤ 5,000Manager> 5,000 and ≤ 20,000Department Head> 20,000Finance 

Examples:

4,500 USD → Manager 8,500 USD → Department Head 20,350 USD → Finance 

Business Flow

Employee ↓ Create Purchase Request ↓ Select Supplier ↓ Add Products ↓ Enter Quantity ↓ Calculate Line Total ↓ Calculate Total Amount ↓ Determine Approval Level ↓ Approve / Reject ↓ Record Approval History 

Data Model

Main CDS entities:

Employees

Suppliers

Products

PurchaseRequests

PurchaseRequestItems

ApprovalHistory

PurchaseRequestSummary

Main relationships:

Employees ───────→ PurchaseRequests Suppliers ───────→ PurchaseRequests Products ────────→ PurchaseRequestItems PurchaseRequests ─→ PurchaseRequestItems PurchaseRequests ─→ ApprovalHistory 

The data model is defined in:

db/schema.cds 

CAP Service

Service definition:

srv/procurement-service.cds 

Business logic:

srv/procurement-service.js 

The CAP service implements:

Request validation

Automatic business number generation

Product unit price retrieval

Line total calculation

Purchase request total calculation

Approval-level assignment

Approve / Reject actions

Approval history

Purchase request summary

Fiori Elements

The frontend is implemented using SAP Fiori elements and OData V4.

The application includes:

Purchase Requests

Purchase Request Items

Employees

Suppliers

Products

Purchase Request Summary

UI annotations:

app/procurement-ui/annotations.cds 

The UI configuration includes:

List report columns

Object page sections

Field groups

Value help

Text arrangements

Table presentation

Draft support is enabled for transactional editing.

Project Structure

procurement-management/ │ ├── app/ │ └── procurement-ui/ │ ├── webapp/ │ ├── annotations.cds │ └── ... │ ├── db/ │ ├── schema.cds │ └── data/ │ ├── srv/ │ ├── procurement-service.cds │ └── procurement-service.js │ ├── package.json ├── package-lock.json └── README.md 

Local Development

Install dependencies:

npm install 

Start the application:

npm run start 

The application can be accessed through the SAP Business Application Studio preview environment.

SQLite is used for local development:

db/procurement.sqlite 

SQLite runtime files are excluded from Git version control.

SAP HANA Cloud

The project is designed to support SAP HANA Cloud deployment on SAP BTP.

SQLite is used during local development, while SAP HANA Cloud serves as the cloud database target for deployment scenarios.

SAP BTP │ ├── CAP Application │ └── HDI Container ↓ SAP HANA Cloud 

Final end-to-end HANA Cloud deployment validation can be completed as part of the cloud deployment stage.

Project Status

Completed

Employee management

Supplier management

Product management

Purchase request management

Purchase request items

Product value help

Automatic unit price retrieval

Line total calculation

Total amount calculation

Approval level assignment

Automatic business number generation

Request validation

Approve / Reject actions

Approval history

Fiori elements frontend

CAP backend service

OData V4

SQLite local development

Future Improvements

Complete end-to-end SAP HANA Cloud deployment validation.

Complete XSUAA authentication validation.

Add role-based access control.

Add approval notifications.

Add automated unit and integration tests.

Integrate external supplier systems through SAP Integration Suite.

Portfolio Context

This project is the Business Application Development stage of a three-project SAP BTP portfolio.

Project 1 Procurement Management CAP + Fiori elements ↓ Project 3 End-to-End API Integration ↓ Project 2 Supplier Integration Platform Integration Suite + iFlow 

The next stage extends this procurement application with SAP Integration Suite and external supplier system integration.