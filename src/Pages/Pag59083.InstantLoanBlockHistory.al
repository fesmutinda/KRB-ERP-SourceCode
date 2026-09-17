page 59083 "Instant Loan Block History"
{
    Caption = 'Instant Loan Block History';
    PageType = List;
    SourceTable = "Instant Loan Block History";
    SourceTableView = sorting("Entry No.") order(descending);
    Editable = false;
    ApplicationArea = All;
    UsageCategory = History;
    layout
    {
        area(Content)
        {
            repeater(Changes)
            {
                field("Entry No."; Rec."Entry No.") { ApplicationArea = All; }
                field("Member No."; Rec."Member No.") { ApplicationArea = All; }
                field(Blocked; Rec.Blocked) { ApplicationArea = All; }
                field("Changed By"; Rec."Changed By") { ApplicationArea = All; }
                field("Changed At"; Rec."Changed At") { ApplicationArea = All; }
            }
        }
    }
}
