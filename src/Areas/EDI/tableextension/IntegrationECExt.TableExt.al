tableextension 51200 "Integration EC ExtTNP" extends "Integration nH"
{
    Description = 'Sales EDI : Sales Order -Solution';

    fields
    {
        field(51200; "Trading Party Code TNP"; Code[20])
        {
            Caption = 'Specify Sender Reference';
            DataClassification = CustomerContent;
            Description = 'OP38050-217 Sales EDI : Sales Order';
            ToolTip = 'Specifies the trading party code for EDI integration.';
        }
        field(51201; "Supplier EAN TNP"; Code[35])
        {
            Caption = 'Specify Supplier EAN';
            DataClassification = CustomerContent;
            Description = 'OP38050-217 Sales EDI : Sales Order';
            ToolTip = 'Specifies the EAN code of the supplier for EDI integration.';
        }
        field(51202; "Ship-To Code Validation TNP"; Boolean)
        {
            Caption = 'Specify if Ship-to Code';
            DataClassification = CustomerContent;
            Description = 'OP38050-217 Sales EDI : Sales Order';
            ToolTip = 'Specifies whether ship-to code validation is required for EDI integration.';
        }
        field(51203; "EDI Sales Price Master TNP"; Boolean)
        {
            Caption = 'EDI Sales Price Master';
            DataClassification = CustomerContent;
            Description = 'OP38050-217 Sales EDI : Sales Order';
            ToolTip = 'Specifies whether EDI is the master source for sales prices.';
        }
        field(51204; "EDI Sales Price Diff.Check TNP"; Boolean)
        {
            Caption = 'EDI Sales Price Difference Check';
            DataClassification = CustomerContent;
            Description = 'OP38050-217 Sales EDI : Sales Order';
            ToolTip = 'Specifies whether to check for sales price differences in EDI integration.';
        }
        field(51205; "Process Handling Codeunit TNP"; integer)
        {
            Caption = 'Process Handling Codeunit';
            DataClassification = CustomerContent;
            Description = 'OP38050-217 Sales EDI : Sales Order';
            TableRelation = AllObjWithCaption."Object ID" where("Object Type" = const(Codeunit));
            ToolTip = 'Specifies the codeunit used for processing handling in EDI integration.';
        }
    }
}
