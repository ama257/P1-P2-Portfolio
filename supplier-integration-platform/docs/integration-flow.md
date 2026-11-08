# SupplierDataIntegration - Integration Flow

## 1. Overview

SupplierDataIntegration is an SAP Integration Suite Cloud Integration flow.

It receives supplier data through an HTTP endpoint, validates the incoming JSON payload, and forwards valid data to the SupplierIntegrationService exposed by the SAP CAP backend.

The CAP service writes the supplier record to the persistent Suppliers entity in SAP HANA Cloud.

## 2. Integration Flow

The implemented processing sequence is:

HTTP Sender
    |
    v
ValidateSupplier (Groovy Script)
    |
    v
SetCAPRequestHeaders
    |
    v
HTTP Receiver
    |
    v
SAP CAP SupplierIntegrationService
    |
    v
SAP HANA Cloud - Suppliers

## 3. HTTP Sender

- Adapter: HTTP
- Resource Path: /http/supplier
- Method: POST
- Purpose: Receive supplier data from an external client.

## 4. Payload

The flow expects a JSON object containing these required fields:

| Field | Description |
|---|---|
| name | Supplier name |
| email | Supplier email address |
| phone | Supplier phone number |
| country | Supplier country |

Example:

{
  "name": "Example Supplier",
  "email": "supplier@example.com",
  "phone": "+65 61234567",
  "country": "Singapore"
}

## 5. Data Validation

The ValidateSupplier Groovy script checks:

1. The request body is not empty.
2. The request body contains valid JSON.
3. The JSON payload is an object.
4. The required fields name, email, phone, and country are present and not empty.
5. The email address follows the configured validation pattern.

Invalid input raises an IllegalArgumentException and is handled by the integration flow's exception handling.

The script is stored separately in:

groovy/ValidateSupplier.groovy

## 6. HTTP Receiver

The HTTP Receiver forwards valid supplier data to the CAP backend.

- Method: POST
- Proxy Type: Internet
- Authentication: OAuth2 Client Credentials
- Credential Alias: CAPSupplierOAuth

Target service:

/supplier-integration/Suppliers

The receiver uses the CAP backend's SupplierIntegrationService.

No client secret or access token is stored in this document.

## 7. Backend Integration

The CAP service is provided by Project 1:

SupplierIntegrationService

The service writes supplier records to the persistent Suppliers entity and generates supplier IDs.

The integration flow does not create a separate supplier database.

## 8. Error Handling and Monitoring

The flow includes exception handling for invalid supplier requests.

Validation scenarios tested include:

- Empty request body
- Invalid JSON
- JSON that is not an object
- Missing required fields
- Empty required fields
- Invalid email format

Execution results and exception details can be inspected in SAP Integration Suite Monitor.

## 9. Verification

The successful integration was verified by:

1. Sending a supplier request through the Integration Suite HTTP endpoint using Postman.
2. Receiving HTTP 201 Created for a successful request.
3. Confirming the supplier record through the CAP SupplierIntegrationService.
4. Confirming the supplier was available in the Project 1 Fiori application.

The integration test created supplier records S005 and S006 in the remote backend.

