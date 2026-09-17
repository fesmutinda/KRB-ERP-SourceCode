page 59077 "Loan Product Selection"
{
    Caption = 'Select Loan Products';
    PageType = List;
    SourceTable = "Loan Product Selection";
    SourceTableTemporary = true;
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(Products)
            {
                field(Selected; Rec.Selected)
                {
                    ApplicationArea = All;
                    ToolTip = 'Check to include this loan product in the report.';
                }
                field("Product Code"; Rec."Product Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the loan product code.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the loan product description.';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(SelectAll)
            {
                ApplicationArea = All;
                Caption = 'Select All';
                Image = SelectEntries;
                ToolTip = 'Check all loan products, including products hidden by a search or filter.';

                trigger OnAction()
                begin
                    SetAllSelected(true);
                end;
            }
            action(ClearAll)
            {
                ApplicationArea = All;
                Caption = 'Clear All';
                Image = ClearFilter;
                ToolTip = 'Uncheck all loan products so you can select only the products you need.';

                trigger OnAction()
                begin
                    SetAllSelected(false);
                end;
            }
        }
    }

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    var
        Selection: Record "Loan Product Selection" temporary;
    begin
        if CloseAction = Action::LookupOK then begin
            Selection.Copy(Rec, true);
            Selection.Reset();
            Selection.SetRange(Selected, true);
            if Selection.IsEmpty() then
                Error('Select at least one loan product, or choose Cancel to keep the previous selection.');
        end;
        exit(true);
    end;

    procedure SetProductFilter(ProductFilter: Text)
    var
        Product: Record "Loan Products Setup";
    begin
        Rec.Reset();
        Rec.DeleteAll();
        if Product.FindSet() then
            repeat
                Rec.Init();
                Rec."Product Code" := Product.Code;
                Rec.Description := Product."Product Description";
                Rec.Selected := false;
                Rec.Insert();
            until Product.Next() = 0;

        if ProductFilter <> '' then
            Product.SetFilter(Code, ProductFilter);
        if Product.FindSet() then
            repeat
                Rec.Get(Product.Code);
                Rec.Selected := true;
                Rec.Modify();
            until Product.Next() = 0;
        if Rec.FindFirst() then;
    end;

    procedure GetProductFilter(): Text
    var
        Selection: Record "Loan Product Selection" temporary;
        Product: Record "Loan Products Setup";
        ProductFilter: Text;
    begin
        Selection.Copy(Rec, true);
        Selection.Reset();
        Selection.SetRange(Selected, true);
        if Selection.FindSet() then
            repeat
                if ProductFilter <> '' then
                    ProductFilter += '|';
                // Let the platform escape codes containing filter characters.
                Product.SetRange(Code, Selection."Product Code");
                ProductFilter += Product.GetFilter(Code);
            until Selection.Next() = 0;
        exit(ProductFilter);
    end;

    local procedure SetAllSelected(NewSelected: Boolean)
    var
        Selection: Record "Loan Product Selection" temporary;
    begin
        Selection.Copy(Rec, true);
        Selection.Reset();
        Selection.ModifyAll(Selected, NewSelected);
        CurrPage.Update(false);
    end;
}
