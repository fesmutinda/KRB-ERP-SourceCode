page 59080 "Overpayment Target Loans"
{
    Caption = 'Select Destination Loan';
    PageType = List;
    SourceTable = "Loans Register";
    SourceTableView = where(Posted = const(true), Reversed = const(false), "Outstanding Balance" = filter('>0'));
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(Loans)
            {
                field("Loan No."; Rec."Loan  No.") { ApplicationArea = All; }
                field("Loan Product Type"; Rec."Loan Product Type") { ApplicationArea = All; }
                field("Product Name"; Rec."Loan Product Type Name") { ApplicationArea = All; }
                field("Member No."; Rec."Client Code") { ApplicationArea = All; }
                field("Member Name"; Rec."Client Name") { ApplicationArea = All; }
                field("Outstanding Balance"; Rec."Outstanding Balance") { ApplicationArea = All; }
            }
        }
    }
}
