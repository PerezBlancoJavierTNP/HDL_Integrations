codeunit 51206 "Sales Inb.Evts.Subscr Ecom TNP"
{

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Inbound Sales Doc. Proces. nH", OnBeforeSalesDocumentProcessing, '', false, false)]
    local procedure InboundSalesDocProcesnH_OnBeforeSalesDocumentProcessing(var pInboundSalesHeader: Record "Inbound Sales Header nH"; var pDoNotProcess: Boolean; var SubscriberDidProcess: Boolean; var SuppressFinalMessage: Boolean)
    var
        SalesInboundEcomMgt: Codeunit "Sales Inbound Mgt.Ecom TNP";
    begin
        // Skip processing if already handled or marked to not process
        if pDoNotProcess or SubscriberDidProcess then
            exit;

        SalesInboundEcomMgt.TriggerPreprocessorCduBeforeSalesDocumentProcessing(pInboundSalesHeader);

        // We don't set SubscriberDidProcess to true because we want to allow other subscribers to run
        // This is just for default value population, not full document processing
    end;
    #region OnCheck Staging

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Inbound Sales Doc. Proces. nH", OnCheckHeader, '', true, true)]
    local procedure InboundSalesDocProcesnH_OnCheckHeader(pInboundSalesHeader: Record "Inbound Sales Header nH"; var pValidationToolkit: Codeunit "Validation Toolkit nH");
    var
        SalesInboundEcomMgt: Codeunit "Sales Inbound Mgt.Ecom TNP";
    begin
        SalesInboundEcomMgt.CheckHeader(pInboundSalesHeader, pValidationToolkit);
    end;

    /*[EventSubscriber(ObjectType::Codeunit, Codeunit::"Inbound Sales Doc. Proces. nH", OnBeforeCheckLine, '', false, false)]
    local procedure InboundSalesDocProcesnH_OnBeforeCheckLine(pInboundSalesHeader: Record "Inbound Sales Header nH"; var pInboundSalesLine: Record "Inbound Sales Line nH");
    var
    SalesInboundEcomMgt: Codeunit "Sales Inbound Mgt.Ecom TNP";
    begin
        SalesInboundEcomMgt.SetItemNoFromItemReferenceNo(pInboundSalesHeader, pInboundSalesLine);
    end;*/

    #endregion OnCheck Staging

    #region OnProcess Staging

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Inbound Sales Doc. Proces. nH", OnProcessHeader, '', false, false)]
    local procedure InboundSalesDocProcesnH_OnProcessHeader(var pInboundSalesHeader: Record "Inbound Sales Header nH"; var pSalesHeader: Record "Sales Header")
    var
        SalesInboundEcomMgt: Codeunit "Sales Inbound Mgt.Ecom TNP";
    begin
        SalesInboundEcomMgt.DefaultValuesOnProcessHeader(pInboundSalesHeader, pSalesHeader);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Inbound Sales Doc. Proces. nH", OnProcessLine, '', false, false)]
    local procedure InboundSalesDocProcesnH_OnProcessLine(var pInboundSalesHeader: Record "Inbound Sales Header nH"; var pInboundSalesLine: Record "Inbound Sales Line nH"; var pSalesHeader: Record "Sales Header"; var pSalesLine: Record "Sales Line")
    var
        SalesInboundEcomMgt: Codeunit "Sales Inbound Mgt.Ecom TNP";
    begin
        SalesInboundEcomMgt.DefaultValuesOnProcessLine(pInboundSalesLine, pSalesLine);
    end;

    #endregion OnProcess Staging

}
