page 59070 "Loan Product Simple Lookup"
{
    PageType = List;
    ApplicationArea = All;
    SourceTable = "Loan Products Setup";
    Caption = 'Select Loan Product';
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(Code; Rec.Code)
                {
                    ApplicationArea = All;
                    Caption = 'Code';
                }

                field("Product Description"; Rec."Product Description")
                {
                    ApplicationArea = All;
                    Caption = 'Product Description';
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
                Caption = 'Select All Products';
                Image = SelectEntries;

                trigger OnAction()
                var
                    TempRec: Record "Loan Products Setup" temporary;
                begin
                    TempRec.Init();
                    TempRec.Code := '<ALL>';
                    TempRec."Product Description" := 'All Loan Products';
                    Rec := TempRec;
                    CurrPage.Close();
                end;
            }
        }
    }
}