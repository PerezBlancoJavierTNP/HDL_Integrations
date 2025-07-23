# Business Central EDI Inbound Sales Document API

## Overview
This API allows external systems to create sales orders in Business Central through EDI integration. The API follows standard Business Central REST API patterns and requires proper authentication.

## Authentication
The API uses OAuth 2.0 for authentication. You must obtain a valid access token with the appropriate permissions

## Endpoint
POST https://api.businesscentral.dynamics.com/v2.0/{tenant-id}/{environment-id}/api/node4/nHancedEcomHdl/v1.0/companies({company-id})/inboundSalesDocuments

## Request Parameters
- tenant-id: The ID of the Business Central tenant where the sales document will be created.
- environment-id: The ID of the Business Central environment where the sales document will be created.
- company-id: The ID of the company where the sales document will be created.

Replace:
- `{environment-id}` with your Business Central environment ID
- `{company-id}` with your company ID in Business Central

## Headers
- `Content-Type: application/json`
- `Authorization: Bearer {your-access-token}`


## Code snippet
curl --location 'https://api.businesscentral.dynamics.com/v2.0/{environment-id}/HDL_CDX_BCDEV1/api/node4/nHancedEcomHdl/v1.0/companies({company-id})/inboundSalesDocuments' \
--header 'Content-Type: application/json' \
--header 'Authorization: Bearer {your-access-token}' \
--data-raw '{
  "integrationCode": "FKSAMPLE",
  "documentType": "Order",
  "ediCreationDate": "2025-07-15",
  "ediCreationTime": "16:18:00",
  "customerNo": "10000",
  "ediInboundTransactionRef": "EDI-REF-2234",
  "shipToCode": "MAIN",
  "shipmentContact": "John Smith",
  "shipmentAddress": "123 Main Street",
  "shipmentAddress2": "Suite 100",
  "shipmentCity": "London",
  "shipmentCounty": "Greater London",
  "shipmentPostCode": "EC1A 1BB",
  "shipmentCountryCode": "GB",
  "externalDocumentNo": "PO-12345",
  "orderDate": "2025-07-15",
  "requestedDeliveryDate": "2025-07-22",
  "currencyCode": "GBP",
  "yourReference": "REF-CUST-001",
  "shipmentEMail": "shipping@customer.com",
  "inboundSalesDocumentLines": [
    {
      "ediLineNo": 10000,
      "type": "Item",
      "itemReferenceNo": "CUST-ITEM-001",
      "quantity": 5,
      "unitOfMeasureCode": "PCS",
      "unitPrice": 25.50
    },
    {
      "ediLineNo": 20000,
      "type": "Item",
      "no": "ITEM1000",
      "quantity": 10,
      "unitOfMeasureCode": "BOX",
      "unitPrice": 100.00
    }
  ]
}'


## Important Notes

`Security`: Never share your access token. The token shown in examples should be replaced with your own valid token.

`Required Fields` The following fields are mandatory:
integrationCode
customerNo
ediCreationDate
ediCreationTime
ediInboundTransactionRef
At least one line item with ediLineNo, type, quantity, and either itemReferenceNo or no

`Business Rules`:
Only one sales order per API call
Only Type=Item is supported for line items (no GL Account lines)
Order amendments and cancellations are NOT supported
Integration code must exist in the Integration nH table
Ship-to code is mandatory if Ship-To Code Validation is TRUE in Integration nH
Response
A successful request returns `HTTP 201` Created with the created sales document details `including a system-generated ID`.

`Error Handling`
`Common error responses`:

400 Bad Request: Invalid data or missing required fields
401 Unauthorized: Invalid or expired token
404 Not Found: Resource not found
409 Conflict: Duplicate transaction reference
500 Internal Server Error: Server-side processing error