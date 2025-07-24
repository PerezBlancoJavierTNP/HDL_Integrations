page 51200 "API Inb. Sales Doc. EC TNP"

{
    APIGroup = 'nHancedEcomHdl';
    APIPublisher = 'node4';
    APIVersion = 'v1.0';
    DelayedInsert = true;
    DeleteAllowed = false;
    Description = 'API page for handling inbound sales documents in the nHanced Ecom module.';
    EntityName = 'inboundSalesDocument';
    EntitySetName = 'inboundSalesDocuments';
    Extensible = true;
    ModifyAllowed = false;
    ODataKeyFields = SystemId;
    PageType = API;
    SourceTable = "Inbound Sales Header nH";
    layout
    {
        area(Content)
        {
            repeater(mainRepeater)
            {
                field(integrationCode; Rec."Integration Code")
                {
                    ApplicationArea = All;
                }
                field(documentType; Rec."Document Type")
                {
                    ApplicationArea = All;
                }
                field(tradingPartyCode; Rec."Sender Code TNP")
                {
                    ApplicationArea = All;
                }
                field(ediCreationDate; Rec."EDI Creation Date TNP")
                {
                    ApplicationArea = All;
                }
                field(ediCreationTime; Rec."EDI Creation Time TNP")
                {
                    ApplicationArea = All;
                }
                field(customerNo; Rec."Customer No.")
                {
                    ApplicationArea = All;
                }
                field(ediInboundTransactionRef; Rec."EDI Inbound TransactionRef TNP")
                {
                    ApplicationArea = All;
                }
                field(shipToCode; Rec."Ship-To-Code TNP")
                {
                    ApplicationArea = All;
                }
                field(shipmentContact; Rec."Shipment Contact")
                {
                    ApplicationArea = All;
                }
                field(shipmentAddress; Rec."Shipment Address")
                {
                    ApplicationArea = All;
                }
                field(shipmentAddress2; Rec."Shipment Address 2")
                {
                    ApplicationArea = All;
                }
                field(shipmentCity; Rec."Shipment City")
                {
                    ApplicationArea = All;
                }
                field(shipmentCounty; Rec."Shipment County")
                {
                    ApplicationArea = All;
                }
                field(shipmentPostCode; Rec."Shipment Post Code")
                {
                    ApplicationArea = All;
                }
                field(shipmentCountryCode; Rec."Shipment Country Code")
                {
                    ApplicationArea = All;
                }
                field(externalDocumentNo; Rec."External Document No. TNP")
                {
                    ApplicationArea = All;
                }
                field(orderDate; Rec."Order Date")
                {
                    ApplicationArea = All;
                }
                field(requestedDeliveryDate; Rec."Requested Delivery Date")
                {
                    ApplicationArea = All;
                }
                field(currencyCode; Rec."Currency Code")
                {
                    ApplicationArea = All;
                }
                field(yourReference; Rec."Your Reference TNP")
                {
                    ApplicationArea = All;
                }
                field(shipmentEMail; Rec."Shipment E-Mail")
                {
                    ApplicationArea = All;
                }
                field(smsPhoneNo; Rec."SMS Phone No. TNP")
                {
                    ApplicationArea = All;
                }
                field(systemId; Rec.SystemId)
                {
                    ApplicationArea = All;
                }
            }

            part(Lines; "API Inb. Sales Doc.Line EC TNP")
            {
                ApplicationArea = All;
                Caption = 'Lines';
                Description = 'Lines of the inbound sales document, containing detailed information about each item in the document.';
                EntityName = 'inboundSalesDocumentLine';
                EntitySetName = 'inboundSalesDocumentLines';
                SubPageLink = "Header ID" = field(ID);
            }
        }
    }

    trigger OnOpenPage();
    var
        NhancedEcomModule: Codeunit "nHanced Ecom Module nH";
    begin
        NhancedEcomModule.CanUseEcomWebServices(true);
    end;

}