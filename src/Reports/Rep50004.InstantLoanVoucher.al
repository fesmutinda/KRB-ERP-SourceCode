namespace KRBERPSourceCode.KRBERPSourceCode;

report 50004 InstantLoanVoucher
{
    ApplicationArea = All;
    Caption = 'InstantLoanVoucher';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/InstantLoanVoucher.rdlc';
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem(LoansRegister; "Loans Register")
        {
            column(ClientName; "Client Name")
            {
            }
            column(RequestedAmount; "Requested Amount")
            {
            }
            column(Signature; Signature)
            {
            }
            column(ApplicationDate; "Application Date")
            {
            }
            column(ModeofDisbursement; "Mode of Disbursement")
            {
            }
            column(BankName; "Bank Name")
            {
            }
            column(BankAccount; "Bank Account")
            {
            }
            column(BankBranch; "Bank Branch")
            {
            }
            column(DisbursedBy; "Disbursed By")
            {
            }
            column(ApprovedBy; "Approved By")
            {
            }
            column(DateApproved; "Date Approved")
            {
            }
        }
    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                }
            }
        }
        actions
        {
            area(Processing)
            {
            }
        }
    }
}
