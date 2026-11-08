SAP Supplier Integration Platform

1. Project Overview

SAP Supplier Integration Platform is an SAP Integration Suite project that demonstrates how external supplier data can be validated and integrated into an existing SAP procurement application.

The project uses an HTTP-based integration flow to receive supplier information, validate the incoming JSON payload, and forward valid requests to an SAP CAP backend.

This project is the second stage of a three-part SAP procurement portfolio.

2. Project Objectives

- Receive supplier data from an external client.
- Validate incoming JSON requests.
- Integrate SAP Integration Suite with an existing SAP CAP backend.
- Use OAuth2 Client Credentials authentication for backend communication.
- Handle invalid requests through exception handling.
- Monitor integration message processing.

3. Technology Stack

Technology| Purpose
SAP BTP| Cloud platform
SAP Integration Suite| Integration platform
Cloud Integration| Integration flow runtime
Groovy| Supplier data validation
HTTP / REST| API communication
JSON| Request payload format
OAuth2 Client Credentials| Backend authentication
SAP CAP| Backend service provided by Project 1
SAP HANA Cloud| Persistent supplier data storage
Postman| API testing

4. Integration Flow

iFlow name: "SupplierDataIntegration"

The integration flow follows this processing sequence:

Postman / External Client
          |
          v
HTTP Sender
          |
          v
ValidateSupplier
          |
          v
SetCAPRequestHeaders
          |
          v
HTTP Receiver
          |
          v
Project 1 - SupplierIntegrationService
          |
          v
SAP HANA Cloud

HTTP Sender

- Method: POST
- Resource Path: "/http/supplier"
- Content Type: JSON

Validation

The "ValidateSupplier" Groovy script checks that:

- The request body is not empty.
- The JSON syntax is valid.
- The JSON payload is an object.
- Required fields are present and not empty.
- The email address follows the configured validation pattern.

HTTP Receiver

Valid supplier requests are forwarded to the CAP backend.

- Method: POST
- Proxy Type: Internet
- Authentication: OAuth2 Client Credentials
- Credential Alias: "CAPSupplierOAuth"

5. Request Payload

The integration flow expects the following JSON structure:

{
  "name": "Example Supplier",
  "email": "supplier@example.com",
  "phone": "+65 61234567",
  "country": "Singapore"
}

Required fields:

Field| Description
name| Supplier name
email| Supplier email address
phone| Supplier phone number
country| Supplier country

6. Project Structure

supplier-integration-platform/
├── README.md
├── docs/
│   ├── architecture.md
│   └── integration-flow.md
├── evidence/
│   ├── monitoring/
│   ├── successful-test/
│   └── validation-error/
├── groovy/
│   └── ValidateSupplier.groovy
├── integration-suite/
└── postman/

7. Integration Testing

Postman was used to test the deployed Integration Suite HTTP endpoint.

Verified scenarios include:

Scenario| Verification
Valid supplier request| HTTP 201 Created
Empty request body| Validation error
Invalid JSON| Validation error
JSON is not an object| Validation error
Missing required fields| Validation error
Empty required fields| Validation error
Invalid email format| Validation error

The successful integration created supplier records S005 and S006 in the Project 1 backend.

The records were confirmed through the CAP service and were visible in the Project 1 Fiori application.

8. Error Handling and Monitoring

The integration flow includes exception handling for invalid supplier requests.

Integration execution results and exception details can be inspected through SAP Integration Suite Monitor.

The monitoring evidence is intended to demonstrate both successful processing and validation failures.

9. Relationship with the Portfolio

This project is part of a three-stage SAP procurement portfolio.

Project| Main Focus
Project 1| SAP BTP Procurement Management Application
Project 2| SAP Supplier Integration Platform
Project 3| End-to-End Procurement API Integration

The overall technical direction is:

SAP BTP Business Application Development → SAP Integration Suite → End-to-End API Integration

Project 2 consumes the SupplierIntegrationService developed in Project 1. It does not duplicate the CAP backend or create a separate supplier database.

10. Current Implementation Status

Implemented and tested:

- SupplierDataIntegration iFlow
- HTTP Sender endpoint
- Groovy supplier validation
- HTTP Receiver configuration
- OAuth2 Client Credentials authentication
- Successful supplier creation
- Validation error scenarios
- Integration message monitoring

Local evidence exports, such as iFlow packages, Postman collection exports, and monitoring screenshots, should only be added to this repository after they have actually been exported and saved.