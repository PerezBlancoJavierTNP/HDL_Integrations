codeunit 51207 "Sales Inbound Mgt.Ecom TNP"
{

    procedure CheckHeader(var pInboundSalesHeader: Record "Inbound Sales Header nH"; var pValidationToolkit: Codeunit "Validation Toolkit nH")
    var
        IntegrationEC: Record "Integration nH";
    begin
        pValidationToolkit.TestIfFieldNotEmpty(pInboundSalesHeader.FieldNo(pInboundSalesHeader."Sender Code TNP"));
        pValidationToolkit.TestIfFieldNotEmpty(pInboundSalesHeader.FieldNo(pInboundSalesHeader."EDI Creation Date TNP"));
        pValidationToolkit.TestIfFieldNotEmpty(pInboundSalesHeader.FieldNo(pInboundSalesHeader."EDI Creation Time TNP"));

        if IntegrationEC.Get(pInboundSalesHeader."Integration Code") then
            if IntegrationEC."Ship-To Code Validation TNP" Then
                pValidationToolkit.TestIfFieldNotEmpty(pInboundSalesHeader.FieldNo(pInboundSalesHeader."Ship-To-Code TNP"));
    end;

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

    procedure DefaultValuesOnProcessHeader(var InboundSalesHeader: Record "Inbound Sales Header nH"; var SalesHeader: Record "Sales Header")
    begin
        //SalesHeader."SMS Phone No. TNP" := InboundSalesHeader."SMS Phone No. TNP";
        SalesHeader.Modify(false);
    end;

    procedure DefaultValuesOnProcessLine(var pInboundSalesLine: Record "Inbound Sales Line nH"; var pSalesLine: Record "Sales Line")
    begin
        pSalesLine."EDI Line No. TNP" := pInboundSalesLine."EDI Line No. TNP";
        pSalesLine.Modify(false);
    end;
}
