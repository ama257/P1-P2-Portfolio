SAP Supplier Integration Platform - Architecture

1. Project Overview

SAP Supplier Integration Platform is an integration project built with SAP Integration Suite.

The project demonstrates how external supplier data can be received, validated, and integrated into an existing SAP procurement application through an HTTP-based integration flow.

It extends Project 1 by introducing an independent integration layer without duplicating the existing CAP backend or supplier database.

2. System Architecture

External Client (Postman)
          |
          | HTTP POST - JSON
          v
SAP Integration Suite
          |
          v
SupplierDataIntegration
          |
          v
ValidateSupplier
(Groovy Script)
          |
          v
SetCAPRequestHeaders
          |
          v
HTTP Receiver
(OAuth2 Client Credentials)
          |
          v
Project 1 - SAP CAP Backend
SupplierIntegrationService
          |
          v
SAP HANA Cloud
Suppliers Entity
          |
          v
Project 1 - SAP Fiori Application

3. Component Responsibilities

3.1 External Client

Postman simulates an external system sending supplier information to the Integration Suite HTTP endpoint.

The request uses HTTP POST with a JSON payload.

3.2 SAP Integration Suite

SAP Integration Suite provides the integration layer.

The SupplierDataIntegration iFlow performs the following tasks:

- Receives supplier data through an HTTP Sender.
- Validates the incoming JSON payload.
- Uses a Groovy script to check required fields and email format.
- Configures the request headers.
- Forwards valid supplier data to the CAP backend.
- Handles exceptions and supports message monitoring.

3.3 Groovy Validation

The ValidateSupplier script checks:

- Empty request bodies.
- Invalid JSON syntax.
- JSON payload type.
- Required supplier fields.
- Email address format.

Invalid requests raise validation exceptions and are handled by the integration flow.

3.4 SAP CAP Backend

The CAP backend belongs to Project 1.

Its SupplierIntegrationService provides the supplier creation endpoint:

"/supplier-integration/Suppliers"

The service handles supplier record creation and generates supplier IDs.

3.5 SAP HANA Cloud

SAP HANA Cloud stores the supplier records created through the CAP backend.

Project 2 does not introduce a separate supplier database.

3.6 SAP Fiori Application

The Fiori application belongs to Project 1.

It provides the user interface for viewing and selecting supplier records stored in the backend.

4. Project Boundaries

Project 1 - Procurement Management Application

Responsibilities:

- SAP CAP backend
- SupplierIntegrationService
- SAP HANA Cloud persistence
- SAP Fiori application
- Supplier business data

Project 2 - Supplier Integration Platform

Responsibilities:

- SAP Integration Suite
- SupplierDataIntegration iFlow
- Groovy-based supplier validation
- HTTP-based system integration
- OAuth2 Client Credentials authentication
- Exception handling and message monitoring
- Postman integration testing

Project 2 consumes the API provided by Project 1. The CAP backend and supplier database remain part of Project 1.

5. End-to-End Data Flow

1. Postman sends supplier data to the Integration Suite HTTP endpoint.
2. The HTTP Sender receives the request.
3. ValidateSupplier checks the incoming JSON payload.
4. SetCAPRequestHeaders prepares the request headers.
5. The HTTP Receiver forwards valid data to the CAP backend using OAuth2 Client Credentials.
6. SupplierIntegrationService creates the supplier record.
7. The record is stored in SAP HANA Cloud.
8. The supplier becomes available in the Project 1 Fiori application.

6. Verification

The integration was tested using Postman and the deployed Integration Suite iFlow.

Verified results include:

- Successful HTTP request returning 201 Created.
- Supplier records S005 and S006 created in the remote backend.
- Supplier records confirmed through the CAP service.
- Suppliers visible in the Project 1 Fiori application.
- Validation scenarios tested for missing fields, empty values, invalid JSON, and invalid email format.

7. Security

The HTTP Receiver uses OAuth2 Client Credentials authentication through the configured credential alias "CAPSupplierOAuth".

Client secrets and access tokens are not included in this project documentation.