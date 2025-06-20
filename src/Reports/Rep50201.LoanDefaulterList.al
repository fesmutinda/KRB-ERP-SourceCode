report 50201 "Loan Defaulters List Print"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/LoanDefaultersList.rdlc';
    Caption = 'Loan Defaulters List';

    dataset
    {
        dataitem(Customer; Customer)
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.", "Name";

            column(MemberNo; "No.") { }
            column(MemberName; Name) { }
            column(PhoneNo; "Phone No.") { }

            dataitem("Loan Products Setup"; "Loan Products Setup")
            {
                dataitem(LoanReg; "Loans Register")
                {
                    DataItemLink = "Loan Product Type" = field(Code);
                    DataItemTableView = sorting("Loan  No.") where(Posted = const(true));

                    column(LoanNumber; "Loan  No.") { }
                    column(ProductType; "Loan Product Type") { }
                    column(DisbursementDate; "Issued Date") { }
                    column(ApprovedAmount; "Approved Amount") { }
                    column(OutstandingBalance; "Outstanding Balance") { }
                    column(InterestDue; "Interest Due") { }
                    column(AmountInArrears; "Amount in Arrears") { }
                    column(ClientName; "Client Name") { }
                    column(ClientCode; "Client Code") { }
                    column(LoanStatus; "Loan Status") { }

                    dataitem(Schedule; "Loan Repayment Schedule")
                    {
                        DataItemLink = "Loan No." = field("Loan  No.");

                        trigger OnPreDataItem()
                        var
                            LoanRep: Record "Loan Repayment Schedule";
                        begin
                            LoanRep.SetRange("Principal Repayment", 0.01);
                            LoanRep.SetFilter("Repayment Date", '..%1', Today);
                        end;
                    }
                }
            }
        }
    }

    requestpage
    {
        layout
        {
            area(content)
            {
                group(Group)
                {
                    field(MemberNo; Customer."No.") { }
                    field(MemberName; Customer.Name) { }
                }
            }
        }
    }

    labels
    {
        Caption = 'Loan Defaulters List';
    }
}
