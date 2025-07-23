pageextension 51203 "Integration Card EC ExtTNP" extends "Integration Card nH"
{
    layout
    {
        addlast(InbSOrdersGroup)
        {
            field("Trading Party Code TNP"; Rec."Trading Party Code TNP")
            {
                ApplicationArea = All;
                Caption = 'Trading Party Code';
                Description = 'OP38050-217 Sales EDI : Sales Order';
                ToolTip = 'Specifies the trading party code for EDI integration.';
            }
            field("Supplier EAN TNP"; Rec."Supplier EAN TNP")
            {
                ApplicationArea = All;
                Caption = 'Supplier EAN';
                Description = 'OP38050-217 Sales EDI : Sales Order';
                ToolTip = 'Specifies the EAN code of the supplier for EDI integration.';
            }
            field("Ship-To Code Validation TNP"; Rec."Ship-To Code Validation TNP")
            {
                ApplicationArea = All;
                Caption = 'Ship-To Code Validation';
                Description = 'OP38050-217 Sales EDI : Sales Order';
                ToolTip = 'Specifies whether ship-to code validation is required for EDI integration.';
            }
            field("EDI Sales Price Master TNP"; Rec."EDI Sales Price Master TNP")
            {
                ApplicationArea = All;
                Caption = 'EDI Sales Price Master';
                Description = 'OP38050-217 Sales EDI : Sales Order';
                ToolTip = 'Specifies whether EDI is the master source for sales prices.';
            }
            field("EDI Sales Price Diff.Check TNP"; Rec."EDI Sales Price Diff.Check TNP")
            {
                ApplicationArea = All;
                Caption = 'EDI Sales Price Difference Check';
                Description = 'OP38050-217 Sales EDI : Sales Order';
                ToolTip = 'Specifies whether to check for sales price differences in EDI integration.';
            }
            field("Process Handling Codeunit TNP"; Rec."Process Handling Codeunit TNP")
            {
                ApplicationArea = All;
                Caption = 'Process Handling Codeunit';
                Description = 'OP38050-217 Sales EDI : Sales Order';
                ToolTip = 'Specifies the codeunit used for processing handling in EDI integration.';
            }
        }
    }
}