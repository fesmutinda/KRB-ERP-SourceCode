namespace KRBERPSourceCode.KRBERPSourceCode;

using Microsoft.Sales.Customer;
using Microsoft.Sales.Receivables;
using Microsoft.Foundation.Company;

report 59060 MemberExcessRepaymentsList
{
    ApplicationArea = All;
    Caption = 'Member Excess Repayments List';
    RDLCLayout = './Layout/Excess Repayments List.rdlc';
    UsageCategory = ReportsAndAnalysis;
    dataset
    {
        dataitem("Cust. Ledger Entry"; "Cust. Ledger Entry")
        {

            DataItemTableView = where("Transaction Type" = filter("Unallocated Funds"), Reversed = const(false));

            column(Customer_No_; "Customer No.") { }

            column(Customer_Name; GetCustomerName("Customer No.")) { }
            column(Credit_Amount; "Credit Amount") { }

            column(Debit_Amount; "Debit Amount") { }

            column(Posting_Date; "Posting Date") { }

            column(Description; Description) { }

            column(Document_No_; "Document No.") { }

            column(Company_Name; Company.Name)
            {
            }
            column(Company_Address; Company.Address)
            {
            }
            column(Company_Address_2; Company."Address 2")
            {
            }
            column(Company_Phone_No; Company."Phone No.")
            {
            }
            column(Company_Fax_No; Company."Fax No.")
            {
            }
            column(Company_Picture; Company.Picture)
            {
            }
            column(Company_Email; Company."E-Mail")
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



    var

        Company: Record "Company Information";


    trigger OnPreReport()
    begin
        Company.Get();
        Company.CalcFields(Company.Picture);
    end;


    procedure GetCustomerName(CustomerNo: Code[20]) CustomerName: Text[100]
    var
        TempCustomerRec: Record Customer;

    begin

        TempCustomerRec.SetRange("No.", CustomerNo);

        if TempCustomerRec.FindFirst() then begin
            exit(TempCustomerRec.Name);
        end;

        exit('Unknown customer');

    end;
}
