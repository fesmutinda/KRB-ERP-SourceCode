pageextension 59085 "Sacco Member Loan Books" extends "KRB Sacco Role Center"
{
    actions
    {
        addafter("Loans Balances Report")
        {
            action(MemberLoanBookGuarantors)
            {
                ApplicationArea = All;
                Caption = 'Member Loan Books - Guarantor Details';
                Image = Report;
                RunObject = report "Member Loan Book Guarantors";
                ToolTip = 'View guarantor details with committed shares calculated as the issued loan amount divided by the total number of guarantors.';
            }
            action(MemberLoanBooksDetails)
            {
                ApplicationArea = All;
                Caption = 'Member Loan Books - Repayment Details';
                Image = Report;
                RunObject = report "Member Loan Books Details";
                ToolTip = 'View the loans book with member numbers, product codes, monthly repayments and annual interest rates.';
            }
        }
    }
}
