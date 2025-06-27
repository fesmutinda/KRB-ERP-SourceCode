namespace KRBERPSourceCode.KRBERPSourceCode;

using Microsoft.Sales.Customer;
using Microsoft.Foundation.Company;
using Microsoft.Sales.Receivables;

report 59059 MemberExcessStatement
{
    DefaultLayout = RDLC;
    Caption = 'Excess Member Statement';
    RDLCLayout = './Layout/Member Excess Statement.rdlc';
    dataset
    {
        dataitem(Customer; Customer)
        {

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

            dataitem(ExcessLoanRepayments; "Cust. Ledger Entry")
            {
                DataItemLink = "Customer No." = field("No."), "Posting Date" = field("Date Filter");
                DataItemTableView = sorting("Posting Date") where("Transaction Type" = filter("Unallocated Funds"), Reversed = const(false));

                column(PostingDate_Excess; ExcessLoanRepayments."Posting Date")
                {
                }
                column(DocumentNo_Excess; ExcessLoanRepayments."Document No.")
                {
                }
                column(Description_Excess; ExcessLoanRepayments.Description)
                {
                }
                column(Amount_Excess; ExcessLoanRepayments."Amount Posted")
                {
                }
                column(UserID_Excess; ExcessLoanRepayments."User ID")
                {
                }
                column(DebitAmount_Excess; DebitAmount)
                {
                }
                column(CreditAmount_Excess; CreditAmount)
                {
                }
                column(TransactionType_Excess; ExcessLoanRepayments."Transaction Type")
                {
                }
                column(OpenBalanceExcess; OpenBalanceExcess)
                {
                }
                column(ClosingBalanceExcess; ClosingBalanceExcess)
                {
                }
                column(ExcessBF; ExcessBF)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    CreditAmount := 0;
                    DebitAmount := 0;
                    if ExcessLoanRepayments."Amount Posted" < 0 then begin
                        CreditAmount := ExcessLoanRepayments."Amount Posted" * -1;
                    end else
                        if ExcessLoanRepayments."Amount Posted" > 0 then begin
                            DebitAmount := ExcessLoanRepayments."Amount Posted";
                        end;
                    ClosingBalanceExcess := ClosingBalanceExcess + (ExcessLoanRepayments."Amount Posted" * -1);
                end;

                trigger OnPreDataItem()
                begin
                    ClosingBalanceExcess := ExcessBF;
                    OpenBalanceExcess := ExcessBF;
                end;
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

        OpenBalance: Decimal;
        CLosingBalance: Decimal;
        OpenBalanceXmas: Decimal;
        CLosingBalanceXmas: Decimal;
        Cust: Record Customer;
        OpeningBal: Decimal;
        ClosingBal: Decimal;

        CreditAmount: Decimal;
        DebitAmount: Decimal;

        Company: Record "Company Information";


        ExcessBF: Decimal;

        ClosingBalanceExcess: Decimal;

        OpenBalanceExcess: Decimal;


    trigger OnPreReport()
    begin
        Company.Get();

        Company.CalcFields(Company.Picture);
    end;

}
