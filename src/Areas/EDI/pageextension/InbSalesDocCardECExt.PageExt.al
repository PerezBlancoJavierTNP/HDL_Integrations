pageextension 51200 "Inb. SalesDoc.Card EC ExtTNP" extends "Inbound Sales Document Card nH"
{
    layout
    {
        addbefore(CustomerGroup)
        {
            field("Sender Code TNP"; Rec."Sender Code TNP")
            {
                ApplicationArea = All;
                Description = 'OP38050-217 Sales EDI : Sales Order';
                ToolTip = 'Specifies the trading party code for the sales document.';
            }
            field("Ship-To-Code TNP"; Rec."Ship-To-Code TNP")
            {
                ApplicationArea = All;
                Description = 'OP38050-217 Sales EDI : Sales Order';
                ToolTip = 'Specifies the ship-to code for the sales document.';
            }
            field("EDI Inbound TransactionRef TNP"; Rec."EDI Inbound TransactionRef TNP")
            {
                ApplicationArea = All;
                Description = 'OP38050-217 Sales EDI : Sales Order';
                ToolTip = 'Specifies the reference for the inbound EDI transaction.';
            }
            field("External Document No. TNP"; Rec."External Document No. TNP")
            {
                ApplicationArea = All;
                Description = 'OP38050-217 Sales EDI : Sales Order';
                ToolTip = 'Specifies the external document number from the EDI system.';
            }
            field("EDI Creation Date TNP"; Rec."EDI Creation Date TNP")
            {
                ApplicationArea = All;
                Description = 'OP38050-217 Sales EDI : Sales Order';
                ToolTip = 'Specifies the date when the EDI document was created.';
            }
            field("EDI Creation Time TNP"; Rec."EDI Creation Time TNP")
            {
                ApplicationArea = All;
                Description = 'OP38050-217 Sales EDI : Sales Order';
                ToolTip = 'Specifies the time when the EDI document was created.';
            }
            field("SMS Phone No. TNP"; Rec."SMS Phone No. TNP")
            {
                ApplicationArea = All;
                Description = 'OP38050-217 Sales EDI : Sales Order';
                ToolTip = 'Specifies the phone number for SMS notifications related to the sales document.';
            }
        }
    }
}
