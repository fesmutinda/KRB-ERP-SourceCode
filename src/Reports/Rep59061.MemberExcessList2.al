namespace KRBERPSourceCode.KRBERPSourceCode;

using Microsoft.Finance.GeneralLedger.Ledger;
using Microsoft.Foundation.Company;
using Microsoft.Sales.Customer;

report 59061 MemberExcessList2
{
    ApplicationArea = All;
    Caption = 'MemberExcessList2';
    DefaultLayout = RDLC;
    RDLCLayout = './Layout/ExcessRepaymentsList.rdlc';
    UsageCategory = ReportsAndAnalysis;
    dataset
    {

        dataitem(GLEntry; "G/L Entry")
        {

            DataItemTableView = where("G/L Account No." = const('2234'), Reversed = const(false));
            column(Amount; Amount)
            {
            }
            column(BalAccountType; "Bal. Account Type")
            {
            }
            column(CreditAmount; "Credit Amount")
            {
            }
            column(DebitAmount; "Debit Amount")
            {
            }
            column(Description; Description)
            {
            }
            column(DocumentNo; "Document No.")
            {
            }
            column(EntryNo; "Entry No.")
            {
            }
            column(GLAccountName; "G/L Account Name")
            {
            }
            column(GLAccountNo; "G/L Account No.")
            {
            }
            column(Reversed; Reversed)
            {
            }
            column(SourceNo; "Source No.")
            {
            }

            column(SourceName; GetSourceName("Source No.")) { }

            column(Company_Name; CompanyInfo.Name)
            {
            }
            column(Company_Address; CompanyInfo.Address)
            {
            }
            column(Company_Address_2; CompanyInfo."Address 2")
            {
            }
            column(Company_Phone_No; CompanyInfo."Phone No.")
            {
            }
            column(Company_Fax_No; CompanyInfo."Fax No.")
            {
            }
            column(Company_Picture; CompanyInfo.Picture)
            {
            }
            column(Company_Email; CompanyInfo."E-Mail")
            {
            }

            column(Posting_Date; "Posting Date") { }
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

        CompanyInfo: Record "Company Information";

    trigger OnPreReport()
    begin
        CompanyInfo.Get();
        CompanyInfo.CalcFields(CompanyInfo.Picture);
    end;

    procedure GetSourceName(AccNo: Code[20]) SourceName: Text[100]
    var
        TempCustomerRec: Record Customer;
    begin


        TempCustomerRec.SetRange("No.", AccNo);

        if TempCustomerRec.FindFirst() then begin
            exit(TempCustomerRec.Name);
        end;

        exit('Unknown Customer');

    end;
}
