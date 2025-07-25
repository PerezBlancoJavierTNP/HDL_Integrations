codeunit 51207 "Sales Inbound Mgt.Ecom TNP"
{
    var
        ErrorMessage: Text;

    procedure CheckHeader(var InboundSalesHeader: Record "Inbound Sales Header nH"; var ValidationToolkit: Codeunit "Validation Toolkit nH")
    var
        IntegrationEC: Record "Integration nH";
    begin
        ValidationToolkit.TestIfFieldNotEmpty(InboundSalesHeader.FieldNo(InboundSalesHeader."Sender Code TNP"));
        ValidationToolkit.TestIfFieldNotEmpty(InboundSalesHeader.FieldNo(InboundSalesHeader."EDI Creation Date TNP"));
        ValidationToolkit.TestIfFieldNotEmpty(InboundSalesHeader.FieldNo(InboundSalesHeader."EDI Creation Time TNP"));
        ValidationToolkit.TestIfFieldNotEmpty(InboundSalesHeader.FieldNo(InboundSalesHeader."External Document No. TNP"));

        if IntegrationEC.Get(InboundSalesHeader."Integration Code") then
            if IntegrationEC."Ship-To Code Validation TNP" Then
                ValidationToolkit.TestIfFieldNotEmpty(InboundSalesHeader.FieldNo(InboundSalesHeader."Ship-To-Code TNP"));

        if FindDuplicateTransactionReference(InboundSalesHeader."EDI Inbound TransactionRef TNP") then
            ValidationToolkit.AddError(GetErrorMessage());
    end;

    procedure TriggerPreprocessorCduBeforeSalesDocumentProcessing(var InboundSalesHeader: Record "Inbound Sales Header nH")
    var
        IntegrationEC: Record "Integration nH";
        IsHandled: Boolean;
    begin
        if not IntegrationEC.Get(InboundSalesHeader."Integration Code") then
            exit;

        IntegrationEC.SetLoadFields("Process Handling Codeunit TNP");
        if IntegrationEC."Process Handling Codeunit TNP" = 0 then
            exit;

        if not TryRunProcessHandlingCodeunit(IntegrationEC."Process Handling Codeunit TNP", InboundSalesHeader, IsHandled) then
            if GuiAllowed() then
                // Only display error in UI sessions
                Error(GetLastErrorText());
    end;

    local procedure TryRunProcessHandlingCodeunit(ProcessHandlingCodeunitID: Integer; var InboundSalesHeader: Record "Inbound Sales Header nH"; var IsHandled: Boolean): Boolean
    begin
        IsHandled := false;
        exit(Codeunit.Run(ProcessHandlingCodeunitID, InboundSalesHeader));
    end;

    procedure DefaultValuesOnProcessHeader(var InboundSalesHeader: Record "Inbound Sales Header nH"; var SalesHeader: Record "Sales Header")
    begin
        SalesHeader."SMS Phone No. TNP" := InboundSalesHeader."SMS Phone No. TNP";
        SalesHeader.Modify(false);
    end;

    procedure DefaultValuesOnProcessLine(var pInboundSalesLine: Record "Inbound Sales Line nH"; var pSalesLine: Record "Sales Line")
    begin
        pSalesLine."EDI Line No. TNP" := pInboundSalesLine."EDI Line No. TNP";
        pSalesLine.Modify(false);
    end;

    local procedure FindDuplicateTransactionReference(EDIInboundTransactionRef: Text[50]): Boolean
    var
        InboundSalesHeader: Record "Inbound Sales Header nH";
        DuplicateTransactionReferenceErr: Label 'EDI Inbound Transaction Reference %1 already exists in the %2. ID: %3';
    begin
        Clear(ErrorMessage);

        if EDIInboundTransactionRef <> '' then begin
            InboundSalesHeader.Reset();
            InboundSalesHeader.SetRange("EDI Inbound TransactionRef TNP", EDIInboundTransactionRef);
            InboundSalesHeader.SetLoadFields(ID);
            if InboundSalesHeader.FindFirst() then
                ErrorMessage := StrSubstNo(DuplicateTransactionReferenceErr, EDIInboundTransactionRef, InboundSalesHeader.TableCaption(), Format(InboundSalesHeader.ID));
            exit(true);
        end;
    end;

    procedure GetErrorMessage(): Text;
    begin
        exit(ErrorMessage);
    end;
}
