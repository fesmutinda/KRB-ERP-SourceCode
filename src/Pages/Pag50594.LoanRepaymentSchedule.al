#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
page 50594 "Loan Repayment Schedule"
{
    PageType = List;
    SourceTable = "Loan Repay Schedule-Calc";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Loan Balance"; Rec."Loan Balance")
                {
                    ApplicationArea = Basic;
                }
                field("Principal Repayment"; Rec."Principal Repayment")
                {
                    ApplicationArea = Basic;
                }
                field("Monthly Interest"; Rec."Monthly Interest")
                {
                    ApplicationArea = Basic;
                }
                field("Monthly Insurance"; Rec."Monthly Insurance")
                {
                    ApplicationArea = Basic;
                }
                field("Monthly Repayment"; Rec."Monthly Repayment")
                {
                    ApplicationArea = Basic;
                }
                field("Repayment Date"; Rec."Repayment Date")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
    }
}
