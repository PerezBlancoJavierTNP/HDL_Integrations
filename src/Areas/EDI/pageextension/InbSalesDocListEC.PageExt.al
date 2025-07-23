pageextension 51201 "Inb. Sales Doc. List EC TNP" extends "Inbound Sales Document List nH"
{
    layout
    {
        addbefore(Status)
        {
            field("EDI Creation Date TNP"; Rec."EDI Creation Date TNP")
            {
                ApplicationArea = All;
                Description = 'OP38050-217 Sales EDI : Sales Order';
                StyleExpr = Style;
                ToolTip = 'Specifies the date when the EDI document was created.';
            }
            field("EDI Creation Time TNP"; Rec."EDI Creation Time TNP")
            {
                ApplicationArea = All;
                Description = 'OP38050-217 Sales EDI : Sales Order';
                StyleExpr = Style;
                ToolTip = 'Specifies the time when the EDI document was created.';
            }
            field("External Document No. TNP"; Rec."External Document No. TNP")
            {
                ApplicationArea = All;
                Description = 'OP38050-217 Sales EDI : Sales Order';
                StyleExpr = Style;
                ToolTip = 'Specifies the external document number from the EDI system.';
            }
            field("Ship-To-Code TNP"; Rec."Ship-To-Code TNP")
            {
                ApplicationArea = All;
                Description = 'OP38050-217 Sales EDI : Sales Order';
                StyleExpr = Style;
                ToolTip = 'Specifies the ship-to code for the sales order.';
            }
            field("Your Reference TNP"; Rec."Your Reference TNP")
            {
                ApplicationArea = All;
                Description = 'OP38050-217 Sales EDI : Sales Order';
                StyleExpr = Style;
                ToolTip = 'Specifies the reference provided by the trading partner for the sales order.';
            }
            field("EDI Inbound TransactionRef TNP"; Rec."EDI Inbound TransactionRef TNP")
            {
                ApplicationArea = All;
                Description = 'OP38050-217 Sales EDI : Sales Order';
                StyleExpr = Style;
                ToolTip = 'Specifies the transaction reference for the EDI inbound document.';
            }

        }
    }
    var
        Style: Text;

    trigger OnAfterGetRecord()
    begin
        Style := Rec.GetStyle();
    end;
}
