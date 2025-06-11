namespace KRBERPSourceCode.KRBERPSourceCode;

using Microsoft.Finance.GeneralLedger.Account;
using Microsoft.Sales.Receivables;
using Microsoft.Foundation.Company;
using Microsoft.Finance.GeneralLedger.Ledger;
using Microsoft.Sales.Customer;
using System.Utilities;

report 59058 "Member Savings Report2"
{
    ApplicationArea = All;
    Caption = 'Member Savings Report';
    UsageCategory = ReportsAndAnalysis;

    DefaultLayout = RDLC;
    RDLCLayout = './Layout/MemberSavingsReport.rdlc';

    dataset
    {
        dataitem(GLAccount; "G/L Account")
        {
            column(No_GLAccount; "No.")
            {
            }
            column(Name_GLAccount; Name)
            {
            }
            column(AccountCategory; "Account Category")
            {
            }
            column(AccountType; "Account Type")
            {
            }
            column(BalanceatDate; "Balance at Date")
            {
            }
            column(DebitCredit; "Debit/Credit")
            {
            }
            column(DateCreated; "Date Created")
            {
            }
            column(NetChange; "Net Change")
            {
            }
            column(IncomeBalance; "Income/Balance")
            {
            }

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

            column(Account_Total_Transactions; AccountTotalTransactions)
            {
            }
            column(Non_Customer_Transactions; NonCustomerTransactions)
            {
            }

            column(TotalDebits; TotalDebits) { }

            dataitem(CustomerTotals; Integer)
            {
                column(CustomerPayroll; CustomerPayroll) { }
                column(CustomerCode; CustomerCode) { }
                column(CustomerName; CustomerName) { }
                column(TotalContributions; TotalContributions) { }
                column(OpeningBalance; OpeningBalance) { }
                column(ClosingBalance; ClosingBalance) { }
                column(G_L_Account_No_; GLAccount."No.") { }
                column(G_L_Account_Name; GLAccount.Name) { }

                trigger OnPreDataItem()
                begin
                    // Clear the temporary buffer and populate it
                    TempCustomerBuffer.Reset();
                    TempCustomerBuffer.DeleteAll();
                    GetUniqueCustomers();

                    // Set the range for the Integer dataitem
                    SetRange(Number, 1, CustomerCount);
                end;

                trigger OnAfterGetRecord()
                var
                    Counter: Integer;
                begin
                    // Navigate to the correct customer record
                    TempCustomerBuffer.Reset();
                    if TempCustomerBuffer.FindSet() then begin
                        Counter := 1;
                        repeat
                            if Counter = Number then begin
                                CustomerCode := TempCustomerBuffer."No.";
                                CustomerName := TempCustomerBuffer.Name;
                                CustomerPayroll := TempCustomerBuffer."Payroll/Staff No";
                                CalculateCustomerTotals(GLAccount."No.", CustomerCode);
                                exit;
                            end;
                            Counter += 1;
                        until TempCustomerBuffer.Next() = 0;
                    end;
                end;
            }

            trigger OnPreDataItem()
            begin
                case SelectedGLAccount of
                    SelectedGLAccount::"2231":
                        SetRange("No.", '2231');
                    SelectedGLAccount::"2232":
                        SetRange("No.", '2232');
                    SelectedGLAccount::"2233":
                        SetRange("No.", '2233');
                    SelectedGLAccount::"2310":
                        SetRange("No.", '2310');
                    SelectedGLAccount::"2234":
                        SetRange("No.", '2234');
                    SelectedGLAccount::"1211":
                        SetRange("No.", '1211');
                    SelectedGLAccount::"1212":
                        SetRange("No.", '1212');
                    SelectedGLAccount::"1213":
                        SetRange("No.", '1213');
                    SelectedGLAccount::"1214":
                        SetRange("No.", '1214');
                    SelectedGLAccount::"1215":
                        SetRange("No.", '1215');
                    SelectedGLAccount::"1217":
                        SetRange("No.", '1217');
                    SelectedGLAccount::"1218":
                        SetRange("No.", '1218');
                    SelectedGLAccount::"1219":
                        SetRange("No.", '1219');
                    else begin
                        // If no selection made, include the 4 savings accounts
                        SetFilter("No.", '%1|%2|%3|%4', '2231', '2232', '2233', '2310');
                    end;
                end;
            end;

            trigger OnAfterGetRecord()
            begin
                // Calculate account-level totals for this G/L Account
                CalculateAccountTotals("No.");
                FnCalculateTotalDebits("No.");
            end;

        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(Options)
                {
                    field(StartDateField; StartDate)
                    {
                        ApplicationArea = All;
                        Caption = 'Start Date';
                    }
                    field(EndDateField; EndDate)
                    {
                        ApplicationArea = All;
                        Caption = 'End Date';
                    }
                }

                group("G/L Account Selection")
                {
                    Caption = 'Select Account';

                    field(SelectedGLAccount; SelectedGLAccount)
                    {
                        ApplicationArea = All;
                        Caption = 'G/L Account';
                        OptionCaption = ' ,2231 - Children Savings,2232 - Withdrawable Savings,2233 - Members Deposits,2310 - Share Capital,2234 - Excess,1211 - Development Loan,1212 - Development Loan 2, 1213 - Investment Loan,1214 - Emergency Loan,1215 - School Fee Loan,1217 - Instant Loan,1218 - Sheria Compliant Loan,1219 - Development Loan 2 (14%)';
                    }
                }
            }
        }
    }

    trigger OnPreReport()
    begin
        CompanyInfo.Get();
        CompanyInfo.CalcFields(CompanyInfo.Picture);

        if EndDate = 0D then
            EndDate := WorkDate();

        if StartDate = 0D then
            StartDate := CalcDate('<-CY>', EndDate);
    end;

    var
        StartDate: Date;
        EndDate: Date;
        CompanyInfo: Record "Company Information";
        CustomerCode: Code[20];
        CustomerName: Text[100];
        TotalContributions: Decimal;
        OpeningBalance: Decimal;
        ClosingBalance: Decimal;
        SelectedGLAccount: Option " ","2231","2232","2233","2310","2234","1211","1212","1213","1214","1215","1217","1218","1219";
        TempCustomerBuffer: Record Customer temporary;
        CustomerCount: Integer;

        AccountOpeningBalance: Decimal;
        AccountTotalTransactions: Decimal;
        AccountClosingBalance: Decimal;
        NonCustomerTransactions: Decimal;

        CustomerPayroll: Code[20];

        TotalDebits: Decimal;


    procedure GetUniqueCustomers()
    var
        GLEntryRec: Record "G/L Entry";
        CustomerRec: Record Customer;
        CustomerNo: Code[20];
    begin
        CustomerCount := 0;
        GLEntryRec.SetRange("G/L Account No.", GLAccount."No.");
        GLEntryRec.SetRange("Posting Date", StartDate, EndDate);

        if GLEntryRec.FindSet() then
            repeat
                CustomerNo := GLEntryRec."Source No.";
                if CustomerNo <> '' then begin
                    // Check if customer already exists in temp buffer
                    TempCustomerBuffer.Reset();
                    TempCustomerBuffer.SetRange("No.", CustomerNo);
                    if TempCustomerBuffer.IsEmpty() then begin
                        // Get customer details and add to buffer
                        if CustomerRec.Get(CustomerNo) then begin
                            TempCustomerBuffer.Init();
                            TempCustomerBuffer."No." := CustomerRec."No.";
                            TempCustomerBuffer.Name := CustomerRec.Name;
                            TempCustomerBuffer."Payroll/Staff No" := CustomerRec."Payroll/Staff No";
                            TempCustomerBuffer.Insert();
                            CustomerCount += 1;
                        end else begin
                            // If customer doesn't exist, create a placeholder
                            TempCustomerBuffer.Init();
                            TempCustomerBuffer."No." := CustomerNo;
                            TempCustomerBuffer.Name := 'Unknown Customer';
                            TempCustomerBuffer.Insert();
                            CustomerCount += 1;
                        end;
                    end;
                end;
            until GLEntryRec.Next() = 0;
    end;

    procedure CalculateCustomerTotals(GLAccountNo: Code[20]; CustomerNo: Code[20])
    var
        GLEntryRec: Record "G/L Entry";
    begin
        TotalContributions := 0;
        // OpeningBalance := 0;
        // ClosingBalance := 0;

        // Calculate opening balance (before start date)
        // GLEntryRec.Reset();
        // GLEntryRec.SetRange("G/L Account No.", GLAccountNo);
        // GLEntryRec.SetRange("Source No.", CustomerNo);
        // GLEntryRec.SetFilter("Posting Date", '<%1', StartDate);
        // if GLEntryRec.FindSet() then
        //     repeat
        //         // Skip reversed entries
        //         if GLEntryRec."Reversed Entry No." = 0 then begin
        //             if not IsEntryReversed(GLEntryRec."Entry No.") then
        //                 OpeningBalance += GLEntryRec.Amount;
        //         end;
        //     until GLEntryRec.Next() = 0;

        // Calculate contributions within the date range
        GLEntryRec.Reset();
        GLEntryRec.SetRange("G/L Account No.", GLAccountNo);
        GLEntryRec.SetRange("Source No.", CustomerNo);
        GLEntryRec.SetRange("Posting Date", StartDate, EndDate);
        if GLEntryRec.FindSet() then
            repeat
                // Skip reversed entries
                if GLEntryRec."Reversed Entry No." = 0 then begin
                    if not IsEntryReversed(GLEntryRec."Entry No.") then
                        TotalContributions += GLEntryRec."Credit Amount";
                    //TotalDebits += GLEntryRec."Debit Amount";
                end;
            until GLEntryRec.Next() = 0;

        // Calculate closing balance
        //ClosingBalance := OpeningBalance + TotalContributions;
    end;

    procedure IsEntryReversed(EntryNo: Integer): Boolean
    var
        GLEntryRec: Record "G/L Entry";
    begin
        GLEntryRec.SetRange("Reversed Entry No.", EntryNo);
        exit(not GLEntryRec.IsEmpty());
    end;

    procedure CalculateAccountTotals(GLAccountNo: Code[20])
    var
        GLEntryRec: Record "G/L Entry";
    begin
        AccountOpeningBalance := 0;
        AccountTotalTransactions := 0;
        AccountClosingBalance := 0;
        NonCustomerTransactions := 0;



        // Calculate account total transactions in period (ONLY entries with empty Source No.)
        GLEntryRec.Reset();
        GLEntryRec.SetRange("G/L Account No.", GLAccountNo);
        GLEntryRec.SetRange("Source No.", ''); // Only non-customer transactions
        GLEntryRec.SetRange("Posting Date", StartDate, EndDate);
        if GLEntryRec.FindSet() then
            repeat
                if GLEntryRec."Reversed Entry No." = 0 then begin
                    if not IsEntryReversed(GLEntryRec."Entry No.") then begin
                        AccountTotalTransactions += GLEntryRec."Credit Amount";
                        NonCustomerTransactions += GLEntryRec."Credit Amount";
                        //TotalDebits += GLEntryRec."Debit Amount";
                    end;
                end;
            until GLEntryRec.Next() = 0;
    end;

    procedure FnCalculateTotalDebits(GLAccountNo: Code[20])
    var
        GLEntryRec: Record "G/L Entry";

    begin

        TotalDebits := 0;

        GLEntryRec.Reset();
        GLEntryRec.SetRange("G/L Account No.", GLAccountNo);
        GLEntryRec.SetRange("Posting Date", StartDate, EndDate);
        if GLEntryRec.FindSet() then
            repeat
                if GLEntryRec."Reversed Entry No." = 0 then begin
                    if not IsEntryReversed(GLEntryRec."Entry No.") then begin

                        TotalDebits += GLEntryRec."Debit Amount";
                    end;
                end;
            until GLEntryRec.Next() = 0;

    end;
}