page 59082 "Instant Loan Block Cue"
{
    PageType = CardPart;
    SourceTable = "Instant Loan Block Cue";
    RefreshOnActivate = true;
    layout
    {
        area(Content)
        {
            cuegroup(InstantLoanAccess)
            {
                Caption = 'Instant Loan Access';
                field("Blocked Members"; Rec."Blocked Members")
                {
                    Caption = 'Blocked Instant Loan Members';
                    ApplicationArea = All;
                    ToolTip = 'View the number of blocked members. Open the member list to check or uncheck instant loan access.';
                    trigger OnDrillDown()
                    begin
                        Page.RunModal(Page::"Instant Loan Member Blocks");
                        Rec.CalcFields("Blocked Members");
                        CurrPage.Update(false);
                    end;
                }
            }
        }
    }
    trigger OnOpenPage()
    begin
        Rec.Init();
        Rec.Insert();
    end;
}
