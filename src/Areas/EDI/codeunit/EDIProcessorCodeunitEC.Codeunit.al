codeunit 51200 "EDI Processor Codeunit EC TNP"
{
    TableNo = "Inbound Sales Header nH";

    trigger OnRun()
    begin
        Process(Rec);
    end;

    procedure Process(InboundSalesHeader: Record "Inbound Sales Header nH")
    var
        InboundSalesLine: Record "Inbound Sales Line nH";
        Integration: Record "Integration nH";
        ProcessedCount: Integer;
        BatchSize: Integer;
    begin
        if not Integration.Get(InboundSalesHeader."Integration Code") then
            exit;

        InboundSalesLine.Reset();
        InboundSalesLine.SetRange("Header ID", InboundSalesHeader.ID);
        InboundSalesLine.SetLoadFields("EDI Line No. TNP", "Variant Code", "Unit of Measure Code", "Item Reference No. TNP", "No.", Type);

        if InboundSalesLine.IsEmpty() then
            exit;

        ProcessedCount := 0;
        BatchSize := 50;
        if InboundSalesLine.FindSet() then
            repeat
                ProcessedCount += 1;
                SetRequiredFieldsBeforeProcessing(InboundSalesLine, Integration."Inb. Cust. No.");

                if ProcessedCount mod BatchSize = 0 then
                    Commit();
            until InboundSalesLine.Next() = 0;
    end;

    procedure SetRequiredFieldsBeforeProcessing(var InboundSalesLine: Record "Inbound Sales Line nH"; InboundCustNo: Code[20])
    var
        ItemReference: Record "Item Reference";
    begin
        if (InboundSalesLine."Item Reference No. TNP" <> '') and
           (InboundSalesLine."No." = '') and
           (InboundSalesLine.Type = InboundSalesLine.Type::Item) then begin

            ItemReference.SetRange("Reference Type", ItemReference."Reference Type"::Customer);
            ItemReference.SetRange("Reference Type No.", InboundCustNo);
            ItemReference.SetRange("Reference No.", InboundSalesLine."Item Reference No. TNP");
            ItemReference.SetRange("Variant Code", InboundSalesLine."Variant Code");
            ItemReference.SetRange("Unit of Measure", InboundSalesLine."Unit of Measure Code");
            ItemReference.SetLoadFields("Item No.");
            if ItemReference.FindFirst() then
                InboundSalesLine."No." := ItemReference."Item No.";
        end;

        InboundSalesLine."EDI Line No. TNP" := InboundSalesLine."Line No.";
        InboundSalesLine.Modify();
    end;
}
