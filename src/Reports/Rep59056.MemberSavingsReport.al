namespace KRBERPSourceCode.KRBERPSourceCode;

using Microsoft.Finance.GeneralLedger.Account;
using Microsoft.Sales.Receivables;
using Microsoft.Foundation.Company;
using Microsoft.Sales.Customer;

report 59056 "Member Savings Report"
{
    ApplicationArea = All;
    Caption = 'Member Savings Report';
    UsageCategory = ReportsAndAnalysis;

    DefaultLayout = RDLC;
    RDLCLayout = './Layout/KRBMemberSavingsReport2.rdl';

    dataset
    {
        dataitem(Customer; Customer)
        {
            column(No_; "No.") { }
            column(Name; Name) { }

            column(Company_Name; CompanyInfo.Name) { }
            column(Company_Address; CompanyInfo.Address) { }
            column(Company_Address_2; CompanyInfo."Address 2") { }
            column(Company_Phone_No; CompanyInfo."Phone No.") { }
            column(Company_Fax_No; CompanyInfo."Fax No.") { }
            column(Company_Email; CompanyInfo."E-Mail") { }
            column(Company_Picture; CompanyInfo.Picture) { }

            column(OpeningBalance; OpeningBalance) { }
            column(TotalCredits; TotalCredits) { }
            column(TotalDebits; TotalDebits) { }
            column(ClosingBalance; ClosingBalance) { }

            trigger OnAfterGetRecord()
            begin
                // Reset totals
                OpeningBalance := 0;
                TotalCredits := 0;
                TotalDebits := 0;
                ClosingBalance := 0;

                CustLedgerEntries.Reset();
                CustLedgerEntries.SetRange("Customer No.", "No.");
                CustLedgerEntries.SetRange("Posting Date", StartDate, EndDate);

                // === TRANSACTION TYPE FILTER (SMART & SAFE) ===
                if TransactionTypeOption <> TransactionTypeOption::" " then begin
                    case TransactionTypeOption of
                        TransactionTypeOption::"Share Capital":
                            CustLedgerEntries.SetRange("Transaction Type", TransactionTypesEnum::"Share Capital");

                        TransactionTypeOption::"Withdrawable Savings":
                            CustLedgerEntries.SetRange("Transaction Type", TransactionTypesEnum::"Withdrawable Savings");

                        TransactionTypeOption::"Junior Savings":
                            CustLedgerEntries.SetRange("Transaction Type", TransactionTypesEnum::"Junior Savings");

                        TransactionTypeOption::"Deposit Contribution":
                            CustLedgerEntries.SetRange("Transaction Type", TransactionTypesEnum::"Deposit Contribution");

                        TransactionTypeOption::"Unallocated Funds":
                            CustLedgerEntries.SetRange("Transaction Type", TransactionTypesEnum::"Unallocated Funds");
                    end;
                end else begin
                    // None selected → include all 5 savings types
                    CustLedgerEntries.SetFilter(
                        "Transaction Type",
                        '%1|%2|%3|%4|%5',
                        TransactionTypesEnum::"Share Capital",
                        TransactionTypesEnum::"Withdrawable Savings",
                        TransactionTypesEnum::"Junior Savings",
                        TransactionTypesEnum::"Deposit Contribution",
                        TransactionTypesEnum::"Unallocated Funds"
                    );
                end;

                if CustLedgerEntries.FindSet() then begin
                    repeat
                        CustLedgerEntries.CalcFields("Credit Amount", "Debit Amount");

                        // Opening balance handling
                        if CustLedgerEntries."Document No." = 'OBDEPOSITS' then
                            OpeningBalance += CustLedgerEntries."Credit Amount"
                        else begin
                            TotalCredits += CustLedgerEntries."Credit Amount";
                            TotalDebits += CustLedgerEntries."Debit Amount";
                        end;

                    until CustLedgerEntries.Next() = 0;

                    ClosingBalance := OpeningBalance + TotalCredits - TotalDebits;
                end;
                // ❌ NO CurrReport.Skip() — prevents empty report error
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(content)
            {
                group(Options)
                {
                    field(StartDate; StartDate)
                    {
                        ApplicationArea = All;
                        Caption = 'Start Date';
                    }
                    field(EndDate; EndDate)
                    {
                        ApplicationArea = All;
                        Caption = 'End Date';
                    }
                    field(TransactionTypeOption; TransactionTypeOption)
                    {
                        ApplicationArea = All;
                        Caption = 'Transaction Type';
                    }
                }
            }
        }
    }

    trigger OnPreReport()
    begin
        CompanyInfo.Get();
        CompanyInfo.CalcFields(Picture);

        if EndDate = 0D then
            EndDate := WorkDate();

        if StartDate = 0D then
            StartDate := DMY2Date(31, 12, 2024); // Opening balance baseline
    end;

    var
        StartDate: Date;
        EndDate: Date;

        CompanyInfo: Record "Company Information";
        CustLedgerEntries: Record "Cust. Ledger Entry";

        OpeningBalance: Decimal;
        TotalCredits: Decimal;
        TotalDebits: Decimal;
        ClosingBalance: Decimal;

        // Request page option (restricted to savings types)
        TransactionTypeOption: Option " ","Share Capital","Withdrawable Savings","Junior Savings","Deposit Contribution","Unallocated Funds";

        // Existing enum (UNCHANGED)
        TransactionTypesEnum: Enum "TransactionTypesEnum";
}
