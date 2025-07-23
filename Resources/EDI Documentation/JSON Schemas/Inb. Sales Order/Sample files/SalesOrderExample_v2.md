# Business Central EDI API Examples

## Sample Sales Order JSON

```json
{
  "integrationCode": "EDIBAQSTORE",
  "documentType": "Order",
  "tradingPartyCode": "FK",
  "ediCreationDate": "2025-07-11",
  "ediCreationTime": "15:11:00",
  "ediInboundTransactionRef": "EDI-REF-1234",
  "shipToCode": "MAIN",
  "shipmentContact": "John Smith",
  "shipmentAddress": "123 Main Street",
  "shipmentAddress2": "Suite 100",
  "shipmentCity": "London",
  "shipmentCounty": "Greater London",
  "shipmentPostCode": "EC1A 1BB",
  "shipmentCountryCode": "GB",
  "externalDocumentNo": "PO-12345",
  "orderDate": "2025-07-11",
  "requestedDeliveryDate": "2025-07-18",
  "currencyCode": "GBP",
  "yourReference": "REF-CUST-001",
  "shipmentEMail": "shipping@customer.com",
  "smsPhoneNo": "+447700900123",
  "inboundSalesDocumentLines": [
    {
      "ediLineNo": 10000,
      "type": "Item",
      "itemReferenceNo": "CUST-ITEM-001",
      "quantity": 5,
      "unitOfMeasureCode": "PCS",
      "unitPrice": 25.50,
      "width": 10.0,
      "length": 50.0,
      "totalLineAmountExclVAT": 127.50
    },
    {
      "ediLineNo": 20000,
      "type": "Item",
      "no": "ITEM1000",
      "quantity": 10,
      "unitOfMeasureCode": "BOX",
      "unitPrice": 100.00,
      "width": 20.0,
      "length": 75.0,
      "totalLineAmountExclVAT": 1000.00
    }
  ]
}