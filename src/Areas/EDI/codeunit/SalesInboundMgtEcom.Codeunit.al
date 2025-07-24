codeunit 51207 "Sales Inbound Mgt.Ecom TNP"
{
    procedure TriggerPreprocessorCduBeforeSalesDocumentProcessing(var InboundSalesHeader: Record "Inbound Sales Header nH")
    var
        IntegrationEC: Record "Integration nH";
    begin
        if not IntegrationEC.Get(InboundSalesHeader."Integration Code") then
            exit;

        IntegrationEC.SetLoadFields("Process Handling Codeunit TNP");
        if IntegrationEC."Process Handling Codeunit TNP" = 0 then
            exit;

        Codeunit.Run(IntegrationEC."Process Handling Codeunit TNP", InboundSalesHeader);
    end;

    procedure DefaultValuesOnProcessLine(var pInboundSalesLine: Record "Inbound Sales Line nH"; var pSalesLine: Record "Sales Line")
    begin
        pSalesLine."EDI Line No. TNP" := pInboundSalesLine."EDI Line No. TNP";
        pSalesLine.Modify(false)
    end;
}
