pageextension 51202 "Inb.SalesDoc.CardLn EC ExtTNP" extends "Inbound Sales Doc. Card Ln nH"
{
    layout
    {
        addafter("No.")
        {
            field("Item Reference No. TNP"; Rec."Item Reference No. TNP")
            {
                ApplicationArea = All;
                Description = 'OP38050-217 Sales EDI : Sales Order';
                ToolTip = 'Specifies the reference number for the item in the sales document.';
            }
        }
        addafter(Description)
        {
            field("Width TNP"; Rec."Width TNP")
            {
                ApplicationArea = All;
                Description = 'OP38050-217 Sales EDI : Sales Order';
                ToolTip = 'Specifies the width of the item in the sales document.';
            }
            field("Length TNP"; Rec."Length TNP")
            {
                ApplicationArea = All;
                Description = 'OP38050-217 Sales EDI : Sales Order';
                ToolTip = 'Specifies the length of the item in the sales document.';
            }
        }
        addafter("Amount with Tax")
        {
            field("Total Line Amt Exc. VAT TNP"; Rec."Total Line Amt Exc. VAT TNP")
            {
                ApplicationArea = All;
                Description = 'OP38050-217 Sales EDI : Sales Order';
                ToolTip = 'Specifies the total line amount excluding VAT for the sales document.';
            }
        }
    }
}
