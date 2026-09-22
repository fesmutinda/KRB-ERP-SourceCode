report 59080 "Member Loan Book Guarantors"
{
    Caption = 'Member Loan Books - Guarantor Details';
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/MemberLoanBookGuarantors.rdlc';

    dataset
    {
        dataitem(Guarantee; "Loans Guarantee Details")
        {
            RequestFilterFields = "Loan No", "Member No", Substituted;
            // Export guarantee values, calculating each guarantor's share of the issued amount.
            // Shares is the recorded deposit balance, not a live customer balance.
            column(LoanReference; Guarantee."Loan No") { }
            column(GuarantorMemberNo; Guarantee."Member No") { }
            column(TotalShares; Guarantee.Shares) { }
            column(CommittedShares; CalculatedCommittedShares) { }
            column(AmountGuaranteed; Guarantee."Amont Guaranteed") { }

            trigger OnAfterGetRecord()
            begin
                // Reset for every row so a missing loan cannot reuse the previous amount.
                CalculatedCommittedShares := 0;
                if not Loan.Get(Guarantee."Loan No") then
                    exit;

                // Count the whole loan, independently of the report's member filters.
                LoanGuarantors.Reset();
                LoanGuarantors.SetRange("Loan No", Guarantee."Loan No");
                GuarantorCount := LoanGuarantors.Count();
                if GuarantorCount > 0 then
                    // The Loans Book report presents Approved Amount as Issued Amount.
                    CalculatedCommittedShares := Loan."Approved Amount" / GuarantorCount;
            end;
        }
    }

    var
        Loan: Record "Loans Register";
        LoanGuarantors: Record "Loans Guarantee Details";
        GuarantorCount: Integer;
        CalculatedCommittedShares: Decimal;
}
