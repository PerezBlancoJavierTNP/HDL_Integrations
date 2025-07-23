page 51201 "API Inb. Sales Doc.Line EC TNP"
{
    APIGroup = 'nHancedEcomHdl';
    APIPublisher = 'node4';
    APIVersion = 'v1.0';
    DelayedInsert = true;
    DeleteAllowed = false;
    EntityName = 'inboundSalesDocumentLine';
    EntitySetName = 'inboundSalesDocumentLines';
    Extensible = true;
    ModifyAllowed = false;
    ODataKeyFields = SystemId;
    PageType = API;
    SourceTable = "Inbound Sales Line nH";
    layout
    {
        area(Content)
        {
            repeater(mainRepeater)
            {
                field(ediLineNo; Rec."Line No.")
                {
                    ApplicationArea = All;
                }
                field(type; Rec.Type)
                {
                    ApplicationArea = All;
                }
                field(itemReferenceNo; Rec."Item Reference No. TNP")
                {
                    ApplicationArea = All;
                }
                field(no; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field(quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                }
                field(unitOfMeasureCode; Rec."Unit of Measure Code")
                {
                    ApplicationArea = All;
                }
                field(width; Rec."Width TNP")
                {
                    ApplicationArea = All;
                }
                field(length; Rec."Length TNP")
                {
                    ApplicationArea = All;
                }
                field(unitPrice; Rec."Unit Price")
                {
                    ApplicationArea = All;
                }
                field(totalLineAmountExclVAT; Rec."Total Line Amt Exc. VAT TNP")
                {
                    ApplicationArea = All;
                }
                field(systemId; Rec.SystemId)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}