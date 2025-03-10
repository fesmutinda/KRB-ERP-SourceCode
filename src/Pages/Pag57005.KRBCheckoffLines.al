namespace KRBERPSourceCode.KRBERPSourceCode;

page 57005 "KRB CheckoffLines"
{
    ApplicationArea = All;
    Caption = 'KRB CheckoffLines';
    PageType = ListPart;
    SourceTable = "KRB CheckoffLines";
    RefreshOnActivate = true;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Receipt Line No"; Rec."Receipt Line No")
                {
                    Visible = false;
                }
                field("Staff/Payroll No"; Rec."Staff/Payroll No")
                {
                    ApplicationArea = Basic;
                }
                field("Member No"; Rec."Member No")
                {
                    ApplicationArea = Basic;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = Basic;
                }
                field("ID No."; Rec."ID No.")
                {
                    ApplicationArea = Basic;
                }
                field("Member Found"; Rec."Member Found")
                {
                    ApplicationArea = Basic;
                }
                field("Childrens Savings"; Rec."Childrens Savings")
                { ApplicationArea = Basic; }
                field("Co-op - Devt Loan"; Rec."Co-op - Devt Loan")
                { ApplicationArea = Basic; }
                field("Co-op - Investment Loan"; Rec."Co-op - Investment Loan")
                { ApplicationArea = Basic; }
                field("Co-op - Shares"; Rec."Co-op - Shares")
                { ApplicationArea = Basic; }
                field("Co-op Emergency Loan"; Rec."Co-op Emergency Loan")
                { ApplicationArea = Basic; }
                field("Co-op School Fees Loan"; Rec."Co-op School Fees Loan")
                { ApplicationArea = Basic; }
                field(Dev2; Rec.Dev2)
                { ApplicationArea = Basic; }
                field(Entrance; Rec.Entrance)
                { ApplicationArea = Basic; }
                field(Flexi; Rec.Flexi)
                { ApplicationArea = Basic; }
                field(Instant; Rec.Instant)
                { ApplicationArea = Basic; }
                field(Insurance; Rec.Insurance)
                { ApplicationArea = Basic; }
                field("Muslim Loan"; Rec."Muslim Loan")
                { ApplicationArea = Basic; }
                field(Refinance; Rec.Refinance)
                { ApplicationArea = Basic; }
                field("Share cap"; Rec."Share cap")
                { ApplicationArea = Basic; }
                field("Withdrwable svgs"; Rec."Withdrwable svgs")
                { ApplicationArea = Basic; }
                field("merry goround"; Rec."merry goround")
                { ApplicationArea = Basic; }
            }
        }
    }
}
