tableextension 51207 "Sales Cr.Memo Line EC ExtTNP" extends "Sales Cr.Memo Line"
{
    Description = 'Sales EDI : Sales Order -Solution';

    fields
    {
        field(51200; "EDI Line No. TNP"; Integer)
        {
            Caption = 'EDI Line No.';
            DataClassification = CustomerContent;
            Description = 'OP38050-217 Sales EDI : Sales Order';
            ToolTip = 'Specifies the line number from the EDI system for tracking and reference purposes in posted sales credit memos.';
        }
    }
}
