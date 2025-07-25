codeunit 51208 "Entity AccessPerm.Mgt. ECTNP"
{
    procedure CheckEntityAccessOnDocumentLines(var RecordRefIn: RecordRef; xRecordRefAsVariant: Variant; CurrentFieldNo: Integer)
    var
        SalesHeader: Record "Sales Header";
        PurchaseHeader: Record "Purchase Header";
        SalesLine: Record "Sales Line";
        PurchaseLine: Record "Purchase Line";
        SalesLineRecordRef, PurchaseLineRecordRef : RecordRef;
        DocTypeFieldRef, DocNoFieldRef : FieldRef;
        CurrentFieldNoChecked: Boolean;
    begin
        CurrentFieldNoChecked := false;

        case RecordRefIn.Number() of
            Database::"Sales Header":
                begin
                    CurrentFieldNoChecked := CurrentFieldNo in [SalesHeader.FieldNo("Sell-to Customer No."), SalesHeader.FieldNo("Responsibility Center")];
                    if not CurrentFieldNoChecked then
                        exit;

                    if IsRecordRefAndxRecordRefAreIdentical(RecordRefIn, xRecordRefAsVariant, CurrentFieldNo) then
                        exit;

                    DocTypeFieldRef := RecordRefIn.Field(SalesHeader.FieldNo("Document Type"));
                    DocNoFieldRef := RecordRefIn.Field(SalesHeader.FieldNo("No."));

                    SalesLine.SetRange("Document Type", DocTypeFieldRef.Value());
                    SalesLine.SetRange("Document No.", DocNoFieldRef.Value());
                    SalesLine.SetRange(Type, SalesLine.Type::Item);
                    SalesLine.SetFilter("No.", '<>%1', '');
                    SalesLine.SetRange("System-Created Entry", false);
                    if SalesLine.FindSet() then
                        repeat
                            SalesLineRecordRef.GetTable(SalesLine);
                            CheckEntityAccessOnDocumentLine(SalesLineRecordRef, false, SalesLine.FieldNo("No."));
                        until SalesLine.Next() = 0;
                end;

            Database::"Purchase Header":
                begin
                    CurrentFieldNoChecked := CurrentFieldNo in [PurchaseHeader.FieldNo("Sell-to Customer No.")];
                    if not CurrentFieldNoChecked then
                        exit;

                    if IsRecordRefAndxRecordRefAreIdentical(RecordRefIn, xRecordRefAsVariant, CurrentFieldNo) then
                        exit;

                    DocTypeFieldRef := RecordRefIn.Field(PurchaseHeader.FieldNo("Document Type"));
                    DocNoFieldRef := RecordRefIn.Field(PurchaseHeader.FieldNo("No."));

                    PurchaseLine.SetRange("Document Type", DocTypeFieldRef.Value());
                    PurchaseLine.SetRange("Document No.", DocNoFieldRef.Value());
                    PurchaseLine.SetRange(Type, SalesLine.Type::Item);
                    PurchaseLine.SetFilter("No.", '<>%1', '');
                    PurchaseLine.SetRange("System-Created Entry", false);
                    if PurchaseLine.FindSet() then
                        repeat
                            PurchaseLineRecordRef.GetTable(PurchaseLine);
                            CheckEntityAccessOnDocumentLine(PurchaseLineRecordRef, false, PurchaseLine.FieldNo("No."));
                        until PurchaseLine.Next() = 0;
                end;
        end;
    end;

    procedure CheckEntityAccessOnDocumentLine(RecordRefIn: RecordRef; xRecordRefVariant: Variant; CurrentFieldNo: Integer)
    var
        EntityNoRecordRef, ResponsibilityCenterFieldRef : FieldRef;
        ResponsibilityCenterCode: Code[20];
        AccessCriteriaInDictionary: Dictionary of [Enum "Entity Access Criter. Type TNP", Code[20]];
        EntityType: Enum "Entity Access Type TNP";
        SaleToLbl: Label 'sale';
        PurchaseToLbl: Label 'purchase';
    begin
        if RecordRefIn.IsTemporary() then
            exit;

        if not IsCurrentFieldNoFromItemNo(RecordRefIn, CurrentFieldNo) then
            exit;

        if IsRecordRefAndxRecordRefAreIdentical(RecordRefIn, xRecordRefVariant, CurrentFieldNo) then
            exit;

        if not IsTypeItemOnDocumentLine(RecordRefIn) then
            exit;

        Clear(AccessCriteriaInDictionary);

        InitFieldNos();
        PopulateFieldNos(RecordRefIn);

        case RecordRefIn.Number() of
            Database::"Sales Line":
                begin
                    // Check for Responsibility Center access
                    GetEntityWithResponsibilityCenter(RecordRefIn, EntityNoRecordRef, ResponsibilityCenterFieldRef);
                    if ResponsibilityCenterFieldNo <> 0 then
                        ResponsibilityCenterCode := ResponsibilityCenterFieldRef.Value()
                    else
                        ResponsibilityCenterCode := '';

                    if ResponsibilityCenterCode <> '' then begin
                        AssignFieldRefs(RecordRefIn, AccessCriteriaInDictionary, true);
                        if CheckRecordAccessWithCriteria(EntityType::ResponsibilityCentre, ResponsibilityCenterCode, AccessCriteriaInDictionary) then
                            exit;
                    end;

                    // Check for Customer access
                    AssignFieldRefs(RecordRefIn, AccessCriteriaInDictionary, false);
                    if CheckRecordAccessWithCriteria(EntityType::Customer, EntityNoRecordRef.Value(), AccessCriteriaInDictionary) then
                        exit
                    else
                        ErrorOnRecordRef(RecordRefIn, EntityType::Customer, SaleToLbl);
                end;

            Database::"Purchase Line":
                begin
                    EntityNoRecordRef := RecordRefIn.Field(EntityFieldNo);

                    // Check for Vendor access
                    AssignFieldRefs(RecordRefIn, AccessCriteriaInDictionary, false);
                    if CheckRecordAccessWithCriteria(EntityType::Vendor, EntityNoRecordRef.Value(), AccessCriteriaInDictionary) then
                        exit
                    else
                        ErrorOnRecordRef(RecordRefIn, EntityType::Vendor, PurchaseToLbl);
                end;

            Database::"Inbound Sales Line nH":
                begin
                    // Check for Responsibility Center access
                    GetEntityWithResponsibilityCenter(RecordRefIn, EntityNoRecordRef, ResponsibilityCenterFieldRef);
                    if ResponsibilityCenterFieldNo <> 0 then
                        ResponsibilityCenterCode := ResponsibilityCenterFieldRef.Value()
                    else
                        ResponsibilityCenterCode := '';

                    if ResponsibilityCenterCode <> '' then begin
                        AssignFieldRefs(RecordRefIn, AccessCriteriaInDictionary, true);
                        if CheckRecordAccessWithCriteria(EntityType::ResponsibilityCentre, ResponsibilityCenterCode, AccessCriteriaInDictionary) then
                            exit;
                    end;

                    // Check for Customer access
                    AssignFieldRefs(RecordRefIn, AccessCriteriaInDictionary, false);
                    if CheckRecordAccessWithCriteria(EntityType::Customer, EntityNoRecordRef.Value(), AccessCriteriaInDictionary) then
                        exit
                    else
                        ErrorOnRecordRef(RecordRefIn, EntityType::Customer, SaleToLbl);
                end;

        end;
    end;

    procedure IsEntityAccessAllowed(EntityType: Enum "Entity Access Type TNP";
                                                    EntityNo: Code[20];
                                                    EntityCriteriaType: Enum "Entity Access Criter. Type TNP";
                                                    EntityAllowedCode: Code[20]): Boolean
    var
        EntityAccessPermission: Query "Entity Access Permission TNP";
    begin
        if EntityAllowedCode = '' then
            exit(true);

        EntityAccessPermission.SetRange(EntityType, EntityType);
        EntityAccessPermission.SetRange(EntityNo, EntityNo);
        EntityAccessPermission.SetRange(AllowedCriteriaType, EntityCriteriaType);
        EntityAccessPermission.SetRange(AllowedCode, EntityAllowedCode);
        EntityAccessPermission.SetRange(Enabled, true);

        if EntityAccessPermission.Open() then begin
            if EntityAccessPermission.Read() then begin
                EntityAccessPermission.Close();
                exit(true);
            end;
        end else begin
            EntityAccessPermission.Close();
            exit(false);
        end;
    end;

    local procedure AssignFieldRefs(var RecordRefIn: RecordRef;
                                                var AccessCriteriaInDictionary: Dictionary of [Enum "Entity Access Criter. Type TNP", Code[20]]; ResponsibilityCenterCheck: Boolean)
    var
        Item: Record Item;
        ItemRecordRef: RecordRef;
        ItemNoFieldRef: FieldRef;
        EntityAccessCriterType: Enum "Entity Access Criter. Type TNP";
    begin
        ItemNoFieldRef := RecordRefIn.Field(ItemNoFieldNo);
        Item.Get(Format(ItemNoFieldRef.Value()));
        ItemRecordRef.GetTable(Item);

        if ResponsibilityCenterCheck then begin
            AddToDictionaryBasedOnAccessCriteria(ItemRecordRef, AccessCriteriaInDictionary, EntityAccessCriterType::Brand, ItemBrandCodeFieldNo);
            AddToDictionaryBasedOnAccessCriteria(ItemRecordRef, AccessCriteriaInDictionary, EntityAccessCriterType::ItemFamily, ItemFamilyCodeFieldNo);
        end else begin
            AddToDictionaryBasedOnAccessCriteria(ItemRecordRef, AccessCriteriaInDictionary, EntityAccessCriterType::ItemFamily, ItemFamilyCodeFieldNo);
            AddToDictionaryBasedOnAccessCriteria(ItemRecordRef, AccessCriteriaInDictionary, EntityAccessCriterType::Brand, ItemBrandCodeFieldNo);
        end;

        AddToDictionaryBasedOnAccessCriteria(RecordRefIn, AccessCriteriaInDictionary, EntityAccessCriterType::Item, ItemNoFieldNo);
        AddToDictionaryBasedOnAccessCriteria(RecordRefIn, AccessCriteriaInDictionary, EntityAccessCriterType::Division, DivisionCodeFieldNo);
        AddToDictionaryBasedOnAccessCriteria(RecordRefIn, AccessCriteriaInDictionary, EntityAccessCriterType::ItemCategory, ItemCategoryFieldNo);
        AddToDictionaryBasedOnAccessCriteria(RecordRefIn, AccessCriteriaInDictionary, EntityAccessCriterType::ProductGroup, ProductCodeFieldNo);
    end;

    local procedure AddToDictionaryBasedOnAccessCriteria(var RecordRefIn: RecordRef;
                                                            var AccessCriteriaInDictionaryIn: Dictionary of [Enum "Entity Access Criter. Type TNP", Code[20]];
                                                            CriteriaType: Enum "Entity Access Criter. Type TNP";
                                                            FieldNo: Integer)
    var
        FieldRef: FieldRef;
        FieldValue: Code[20];
    begin
        if AccessCriteriaInDictionaryIn.ContainsKey(CriteriaType) then
            exit;

        FieldRef := RecordRefIn.Field(FieldNo);
        FieldValue := FieldRef.Value();

        if FieldValue = '' then
            exit;

        AccessCriteriaInDictionaryIn.Add(CriteriaType, FieldValue);
    end;

    local procedure CheckRecordAccessWithCriteria(EntityType: Enum "Entity Access Type TNP";
                                                    EntityCode: Code[20];
                                                    var AccessCriteriaInDictionary: Dictionary of [Enum "Entity Access Criter. Type TNP", Code[20]]): Boolean
    var
        CriteriaValueCode: Code[20];
        CriteriaKeyCode: Enum "Entity Access Criter. Type TNP";
    begin
        if AccessCriteriaInDictionary.Count() = 0 then
            exit(false);

        if not CheckCriteriaIsPresent(AccessCriteriaInDictionary, EntityType) then
            exit(true);

        foreach CriteriaKeyCode in AccessCriteriaInDictionary.Keys() do begin
            CriteriaValueCode := AccessCriteriaInDictionary.Get(CriteriaKeyCode);

            if IsEntityAccessAllowed(EntityType, EntityCode, CriteriaKeyCode, CriteriaValueCode) then
                exit(true);
        end;
    end;

    local procedure InitFieldNos()
    begin
        EntityFieldNo := 0;
        ResponsibilityCenterFieldNo := 0;

        ItemNoFieldNo := 0;
        DivisionCodeFieldNo := 0;
        ItemCategoryFieldNo := 0;
        ProductCodeFieldNo := 0;

        ItemBrandCodeFieldNo := 0;
        ItemFamilyCodeFieldNo := 0;
    end;

    local procedure PopulateFieldNos(var RecordRefIn: RecordRef)
    var
        SalesLine: Record "Sales Line";
        PurchaseLine: Record "Purchase Line";
        InboundSalesLine: Record "Inbound Sales Line nH";
        InboundSalesHeader: Record "Inbound Sales Header nH";
        Integration: Record "Integration nH";
    begin
        if RecordRefIn.Number() = Database::"Sales Line" then begin
            EntityFieldNo := SalesLine.FieldNo("Sell-to Customer No.");
            ResponsibilityCenterFieldNo := SalesLine.FieldNo("Responsibility Center");

            ItemNoFieldNo := SalesLine.FieldNo("No.");
            DivisionCodeFieldNo := 9999;
            ItemCategoryFieldNo := SalesLine.FieldNo("Item Category Code");
            ProductCodeFieldNo := 8888;
        end;

        if RecordRefIn.Number() = Database::"Purchase Line" then begin
            EntityFieldNo := PurchaseLine.FieldNo("Buy-from Vendor No.");

            ItemNoFieldNo := PurchaseLine.FieldNo("No.");
            DivisionCodeFieldNo := 9999;
            ItemCategoryFieldNo := PurchaseLine.FieldNo("Item Category Code");
            ProductCodeFieldNo := 8888;
        end;

        if RecordRefIn.Number() = Database::"Inbound Sales Line nH" then begin
            /*InboundSalesHeader.Get(InboundSalesLine."Header ID");
            Integration.Get(InboundSalesHeader."Integration Code");
            ///EntityFieldNo := InboundSalesLine.FieldNo("Sell-to Customer No.");
            //ResponsibilityCenterFieldNo := SalesLine.FieldNo("Responsibility Center");

            ItemNoFieldNo := InboundSalesLine.FieldNo("No.");
            DivisionCodeFieldNo := 9999;
            ItemCategoryFieldNo := SalesLine.FieldNo("Item Category Code");
            ProductCodeFieldNo := 8888;*/
        end;

        PopulateItemFieldNos();
    end;

    local procedure PopulateItemFieldNos()
    var
        Item: Record Item;
    begin
        ItemBrandCodeFieldNo := 7777;
        ItemFamilyCodeFieldNo := 6666;
    end;

    local procedure GetEntityWithResponsibilityCenter(var RecordRefIn: RecordRef; var EntityNoRecordRef: FieldRef; var ResponsibilityCenterFieldRef: FieldRef)
    begin
        EntityNoRecordRef := RecordRefIn.Field(EntityFieldNo);

        if ResponsibilityCenterFieldNo <> 0 then
            ResponsibilityCenterFieldRef := RecordRefIn.Field(ResponsibilityCenterFieldNo);
    end;

    local procedure ErrorOnRecordRef(var RecordRefIn: RecordRef; EntityTypeIn: Enum "Entity Access Type TNP"; DocumentTypeLbl: Text)
    var
        ItemNoFieldRef, EntityFieldRef : FieldRef;
        EntityAccessErr: Label 'Item %1 is restricted for %2 to %3 %4.', Comment = '%1 = Item No., %2 = Document Type, %3 = Entity Type, %4 = Entity No.';
        ErrorText: Text;
    begin
        ItemNoFieldRef := RecordRefIn.Field(ItemNoFieldNo);
        EntityFieldRef := RecordRefIn.Field(EntityFieldNo);

        ErrorText := StrSubstNo(EntityAccessErr,
                                ItemNoFieldRef.Value(),
                                DocumentTypeLbl,
                                Format(EntityTypeIn),
                                EntityFieldRef.Value());

        Error(ErrorText);
    end;

    local procedure IsTypeItemOnDocumentLine(var RecordRefIn: RecordRef): Boolean
    var
        SalesLine: Record "Sales Line";
        PurchaseLine: Record "Purchase Line";
        InboundSalesLine: Record "Inbound Sales Line nH";
        TypeFieldRef, ItemNoFieldRef : FieldRef;
        ItemNo: Code[20];
        PurchaseLineType: Enum "Purchase Line Type";
        SalesLineType: Enum "Sales Line Type";
    begin
        if RecordRefIn.Number() = Database::"Sales Line" then begin
            TypeFieldRef := RecordRefIn.Field(SalesLine.FieldNo("Type"));
            SalesLineType := TypeFieldRef.Value();

            if SalesLineType <> SalesLine.Type::Item then
                exit(false);

            ItemNoFieldRef := RecordRefIn.Field(SalesLine.FieldNo("No."));
            ItemNo := ItemNoFieldRef.Value();
            if ItemNo = '' then
                exit(false);

            exit(true);
        end;

        if RecordRefIn.Number() = Database::"Purchase Line" then begin
            TypeFieldRef := RecordRefIn.Field(PurchaseLine.FieldNo("Type"));
            PurchaseLineType := TypeFieldRef.Value();

            if PurchaseLineType <> InboundSalesLine.Type::Item then
                exit(false);

            ItemNoFieldRef := RecordRefIn.Field(PurchaseLine.FieldNo("No."));
            ItemNo := ItemNoFieldRef.Value();
            if ItemNo = '' then
                exit(false);

            exit(true);
        end;

        if RecordRefIn.Number() = Database::"Inbound Sales Line nH" then begin
            TypeFieldRef := RecordRefIn.Field(InboundSalesLine.FieldNo("Type"));
            SalesLineType := TypeFieldRef.Value();

            if SalesLineType <> InboundSalesLine.Type::Item then
                exit(false);

            ItemNoFieldRef := RecordRefIn.Field(InboundSalesLine.FieldNo("No."));
            ItemNo := ItemNoFieldRef.Value();
            if ItemNo = '' then
                exit(false);

            exit(true);
        end;
    end;

    local procedure IsRecordRefAndxRecordRefAreIdentical(RecordRefIn: RecordRef; xRecordRefVariant: Variant; CurrentFieldNo: Integer): Boolean
    var
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        PurchaseHeader: Record "Purchase Header";
        PurchaseLine: Record "Purchase Line";
        DataTypeManagement: Codeunit "Data Type Management";
        xRecordRefIn: RecordRef;
    begin
        if xRecordRefVariant.IsBoolean() then
            exit(false);

        if not xRecordRefVariant.IsRecordRef() then
            exit(false);

        if not DataTypeManagement.GetRecordRef(xRecordRefVariant, xRecordRefIn) then
            exit(false);

        case RecordRefIn.Number() of
            Database::"Sales Header":
                begin
                    if CurrentFieldNo = SalesHeader.FieldNo("Sell-to Customer No.") then
                        exit(AreFieldValuesIdentical(RecordRefIn, xRecordRefIn, SalesHeader.FieldNo("Sell-to Customer No.")));

                    if CurrentFieldNo = SalesHeader.FieldNo("Responsibility Center") then
                        exit(AreFieldValuesIdentical(RecordRefIn, xRecordRefIn, SalesHeader.FieldNo("Responsibility Center")));
                end;

            Database::"Sales Line":
                begin
                    if CurrentFieldNo = SalesLine.FieldNo("No.") then
                        exit(AreFieldValuesIdentical(RecordRefIn, xRecordRefIn, SalesLine.FieldNo("No.")));

                    if CurrentFieldNo = SalesLine.FieldNo("Responsibility Center") then
                        exit(AreFieldValuesIdentical(RecordRefIn, xRecordRefIn, SalesLine.FieldNo("Responsibility Center")));
                end;

            Database::"Purchase Header":
                if CurrentFieldNo = PurchaseHeader.FieldNo("Buy-from Vendor No.") then
                    exit(AreFieldValuesIdentical(RecordRefIn, xRecordRefIn, PurchaseHeader.FieldNo("Buy-from Vendor No.")));

            Database::"Purchase Line":
                if CurrentFieldNo = PurchaseLine.FieldNo("No.") then
                    exit(AreFieldValuesIdentical(RecordRefIn, xRecordRefIn, PurchaseLine.FieldNo("No.")));

            else
                exit(false);

        end;

        if RecordRefIn.Number() = Database::"Sales Line" then begin
            if CurrentFieldNo = SalesLine.FieldNo("No.") then
                exit(AreFieldValuesIdentical(RecordRefIn, xRecordRefIn, SalesLine.FieldNo("No.")));

            if CurrentFieldNo = SalesLine.FieldNo("Responsibility Center") then
                exit(AreFieldValuesIdentical(RecordRefIn, xRecordRefIn, SalesLine.FieldNo("Responsibility Center")));
        end;

        if RecordRefIn.Number() = Database::"Purchase Line" then
            if CurrentFieldNo = PurchaseLine.FieldNo("No.") then
                exit(AreFieldValuesIdentical(RecordRefIn, xRecordRefIn, PurchaseLine.FieldNo("No.")));
    end;

    local procedure IsCurrentFieldNoFromItemNo(RecordRefIn: RecordRef; CurrentFieldNo: Integer): Boolean
    var
        SalesLine: Record "Sales Line";
        PurchaseLine: Record "Purchase Line";
        InboundSalesLine: Record "Inbound Sales Line nH";
    begin
        if RecordRefIn.Number() = Database::"Sales Line" then
            if CurrentFieldNo = SalesLine.FieldNo("No.") then
                exit(true);


        if RecordRefIn.Number() = Database::"Purchase Line" then
            if CurrentFieldNo = PurchaseLine.FieldNo("No.") then
                exit(true);

        if RecordRefIn.Number() = Database::"Inbound Sales Line nH" then
            if CurrentFieldNo = InboundSalesLine.FieldNo("No.") then
                exit(true);
    end;

    local procedure AreFieldValuesIdentical(RecordRef1: RecordRef; RecordRef2: RecordRef; FieldID: Integer): Boolean
    var
        FieldRef1, FieldRef2 : FieldRef;
    begin
        FieldRef1 := RecordRef1.Field(FieldID);
        FieldRef2 := RecordRef2.Field(FieldID);
        exit(FieldRef1.Value() = FieldRef2.Value());
    end;

    local procedure CheckCriteriaIsPresent(var AccessCriteriaInDictionary: Dictionary of [Enum "Entity Access Criter. Type TNP", Code[20]]; EntityType: Enum "Entity Access Type TNP"): Boolean
    var
        EntityAccessPermission: Record "Entity Access Permission TNP";
        CriteriaValueCode: Code[20];
        CriteriaKeyCode: Enum "Entity Access Criter. Type TNP";
    begin
        EntityAccessPermission.SetRange(Enabled, true);

        case EntityType of
            EntityType::ResponsibilityCentre, EntityType::Customer:
                EntityAccessPermission.SetFilter("Entity Type", '%1|%2', EntityType::ResponsibilityCentre, EntityType::Customer);

            EntityType::Vendor:
                EntityAccessPermission.SetRange("Entity Type", EntityType::Vendor);
        end;

        foreach CriteriaKeyCode in AccessCriteriaInDictionary.Keys() do begin
            CriteriaValueCode := AccessCriteriaInDictionary.Get(CriteriaKeyCode);
            EntityAccessPermission.SetRange("Allowed Criteria Type", CriteriaKeyCode);
            EntityAccessPermission.SetRange("Allowed Code", CriteriaValueCode);

            if not EntityAccessPermission.IsEmpty() then
                exit(true);
        end;

        exit(false);
    end;


    var
        EntityFieldNo, ResponsibilityCenterFieldNo : Integer;
        ItemNoFieldNo, DivisionCodeFieldNo, ItemCategoryFieldNo, ProductCodeFieldNo : Integer;
        ItemBrandCodeFieldNo, ItemFamilyCodeFieldNo : Integer;
}
