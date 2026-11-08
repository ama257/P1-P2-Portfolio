# Procurement Management

## Overview

Procurement Management is a SAP Fiori Elements application
developed as part of the SAP BTP Procurement Management project.

The application provides a user interface for managing
procurement requests and related business data. It connects
to a local SAP CAP backend through an OData V4 service.

## Features

- Manage employee information.
- Manage supplier information.
- Manage product information.
- Create and manage purchase requests.
- Associate purchase requests with employees and suppliers.
- Manage purchase request line items.
- Calculate line item amounts based on quantity and unit price.
- Calculate purchase request total amounts from line items.
- Determine approval levels based on purchase request amounts.
- Approve or reject purchase requests.
- Maintain approval history.

## Technology Stack

- SAP Fiori Elements
- SAPUI5
- OData V4
- SAP Cloud Application Programming Model (CAP)
- Node.js
- CDS
- SQLite

## Application Details

| Property | Value |
|---|---|
| Application Title | Procurement Management |
| Module Name | procurement-ui |
| Namespace | company.procurement |
| Template | List Report Page V4 |
| Service Type | Local CAP |
| Main Entity | PurchaseRequests |
| UI5 Theme | sap_horizon |
| UI5 Version | 1.152.0 |
| TypeScript | Disabled |
| App Generator | SAP Fiori Application Generator |
| App Generator Version | 1.32.0 |
| Generation Platform | SAP Business Application Studio |

## Backend Service

The application connects to the local CAP service through
the following OData V4 service endpoint:

http://localhost:4004/procurement/

## Running the Application

### Prerequisites

- Node.js
- npm
- The SAP CAP project and its required dependencies

### Start the Application

Start the CAP application from the project root directory.

Then open the following URL in your browser:

http://localhost:4004/procurement-ui/webapp/index.html

## Related Project

This frontend application is part of the
SAP BTP Procurement Management Application.

The overall project combines a SAP Fiori Elements frontend,
a SAP CAP backend, CDS data models, business logic,
and a SQLite database to support procurement management
and approval workflows.