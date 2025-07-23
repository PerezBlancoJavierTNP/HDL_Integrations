tableextension 51202 "Inbound Sales Line EC ExtTNP" extends "Inbound Sales Line nH"
{
    Description = 'Sales EDI : Sales Order -Solution';

    fields
    {
        field(51200; "EDI Line No. TNP"; Integer)
        {
            Caption = 'EDI Line No.';
            DataClassification = CustomerContent;
            Description = 'OP38050-217 Sales EDI : Sales Order';
            ToolTip = 'Specifies the line number from the EDI system.';
        }
        field(51201; "Item Reference No. TNP"; Code[50])
        {
            Caption = 'Item Reference No.';
            DataClassification = CustomerContent;
            Description = 'OP38050-217 Sales EDI : Sales Order';
            ToolTip = 'Specifies the item reference number used in the EDI system.';
        }
        field(51202; "Width TNP"; decimal)
        {
            Caption = 'Width';
            DataClassification = CustomerContent;
            Description = 'OP38050-217 Sales EDI : Sales Order';
            ToolTip = 'Specifies the width of the item in the sales document.';
        }
        field(51203; "Length TNP"; decimal)
        {
            Caption = 'Length';
            DataClassification = CustomerContent;
            Description = 'OP38050-217 Sales EDI : Sales Order';
            ToolTip = 'Specifies the length of the item in the sales document.';
        }
        field(51204; "Total Line Amt Exc. VAT TNP"; Decimal)
        {
            Caption = 'Total Line Amount Excl. VAT';
            DataClassification = CustomerContent;
            Description = 'OP38050-217 Sales EDI : Sales Order';
            ToolTip = 'Specifies the total line amount excluding VAT.';
        }
    }
}
