pageextension 59081 "Treasury Instant Loan Blocks" extends "Finance Role Center"
{
    layout
    {
        movefirst(rolecenter; "General Cue")
        modify(Emails)
        {
            Visible = false;
        }
        moveafter("General Cue"; LoansCue)
        addafter(BOSACue)
        {
            group(TreasuryInterestSection)
            {
                Caption = 'Interest Earned';
                part(TreasuryInterestEarned; "Loan Performance Chart")
                {
                    ApplicationArea = All;
                    Caption = 'Interest Earned';
                }
            }
            group(TreasuryApplicationsSection)
            {
                Caption = 'Applied Loans';
                part(TreasuryLoansApplied; "Loans Applied Chart")
                {
                    ApplicationArea = All;
                    Caption = 'Applied Loans';
                }
            }
        }
    }
    actions
    {
        addfirst(embedding)
        {
            action(InstantLoanMemberBlocks)
            {
                Caption = 'Instant Loan Member Blocks';
                ApplicationArea = All;
                RunObject = page "Instant Loan Member Blocks";
                AccessByPermission = tabledata "Instant Loan Member Block" = M;
                ToolTip = 'Check or uncheck members to block or unblock instant loan applications.';
            }
        }
    }
}
