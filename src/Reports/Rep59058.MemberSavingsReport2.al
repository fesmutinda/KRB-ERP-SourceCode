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


            dataitem(CustomerTotals; Integer)
            {
                column(CustomerPayroll; CustomerPayroll) { }
                column(CustomerCode; CustomerCode) { }
                column(CustomerName; CustomerName) { }
                column(TotalCredits; TotalCredits) { }

                column(TotalDebits; TotalDebits) { }
                column(OpeningBalance; OpeningBalance) { }
                column(ClosingBalance; ClosingBalance) { }
                column(G_L_Account_No_; GLAccount."No.") { }
                column(G_L_Account_Name; GLAccount.Name) { }

                column(TotalAmountReversed; TotalAmountReversed) { }

                column(Balance; Balance) { }

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
                                CalculateCustomerTotals(GLAccount."No.", CustomerCode);
                                exit;
                            end;
                            Counter += 1;
                        until TempCustomerBuffer.Next() = 0;
                    end;

                    OtherCustomerBuffer.Reset();
                    if OtherCustomerBuffer.FindSet() then begin
                        repeat
                            if Counter = Number then begin
                                CustomerCode := OtherCustomerBuffer."No.";
                                CalculateCustomerTotals(GLAccount."No.", CustomerCode);
                                CustomerCode := IdentifiedCustomerNo;
                                CustomerName := IdentifiedCustomerName;
                                exit;
                            end;
                            Counter += 1;
                        until OtherCustomerBuffer.Next() = 0;
                    end
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
        TotalCredits: Decimal;
        OpeningBalance: Decimal;
        ClosingBalance: Decimal;
        SelectedGLAccount: Option " ","2231","2232","2233","2310","2234","1211","1212","1213","1214","1215","1217","1218","1219";
        TempCustomerBuffer: Record Customer temporary;

        OtherCustomerBuffer: Record Customer temporary;

        IdentifiedCustomerNo: Code[20];

        IdentifiedCustomerName: Text[100];
        CustomerCount: Integer;

        AccountOpeningBalance: Decimal;
        AccountTotalTransactions: Decimal;
        AccountClosingBalance: Decimal;
        NonCustomerTransactions: Decimal;

        CustomerPayroll: Code[20];

        TotalDebits: Decimal;

        TotalAmountReversed: Decimal;

        Balance: Decimal;

        CommonCustomerNo: Code[20];

        CommonCustomerName: Text[100];

    procedure GetUniqueCustomers()
    var
        GLEntryRec: Record "G/L Entry";
        TempEntryRec: Record "G/L Entry";
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
                end else begin


                    OtherCustomerBuffer.Reset();
                    TempCustomerBuffer.SetRange("No.", CustomerNo);

                    if OtherCustomerBuffer.IsEmpty() then begin
                        TempEntryRec.SetRange("Transaction No.", GLEntryRec."Transaction No.");
                        TempEntryRec.SetRange("Source No.", CustomerNo);
                        OtherCustomerBuffer.Init();
                        OtherCustomerBuffer."No." := CustomerNo;
                        OtherCustomerBuffer.Name := 'Unknown Customer';
                        OtherCustomerBuffer.Insert();
                        CustomerCount += 1;

                    end;

                end;
            until GLEntryRec.Next() = 0;
    end;

    procedure CalculateCustomerTotals(GLAccountNo: Code[20]; CustomerNo: Code[20])
    var
        GLEntryRec: Record "G/L Entry";
        TempGLEntry: Record "G/L Entry" temporary;
        TransactionSummary: Dictionary of [Integer, Decimal];
        TransactionNo: Integer;
        NetAmount: Decimal;
        IsAssetAccount: Boolean;
        ProcessedTransactions: List of [Integer];
    begin
        // Initialize totals
        TotalCredits := 0;
        TotalDebits := 0;
        OpeningBalance := 0;
        TotalAmountReversed := 0;
        Balance := 0;

        IsAssetAccount := IsAssetGLAccount(GLAccountNo);

        // First pass: Collect all entries and handle reversals
        GLEntryRec.Reset();
        GLEntryRec.SetRange("G/L Account No.", GLAccountNo);
        GLEntryRec.SetRange("Source No.", CustomerNo);
        //GLEntryRec.SetFilter("Source No.", '<>%1', '');
        GLEntryRec.SetRange("Posting Date", StartDate, EndDate);

        if GLEntryRec.FindSet() then
            repeat
                // Handle reversed entries
                if (GLEntryRec."Reversed Entry No." <> 0) or IsEntryReversed(GLEntryRec."Entry No.") then begin
                    TotalAmountReversed += Abs(GLEntryRec.Amount);
                end else begin
                    // Store non-reversed entries for processing
                    TempGLEntry := GLEntryRec;
                    TempGLEntry.Insert();
                end;
            until GLEntryRec.Next() = 0;

        // Second pass: Group by transaction and calculate net amounts
        TempGLEntry.Reset();
        if TempGLEntry.FindSet() then
            repeat
                TransactionNo := TempGLEntry."Transaction No.";

                // Process each transaction only once
                if not TransactionSummary.ContainsKey(TransactionNo) then begin
                    NetAmount := CalculateTransactionNetAmount(TransactionNo, GLAccountNo, CustomerNo);
                    TransactionSummary.Add(TransactionNo, NetAmount);

                    if (NetAmount = 0) and (TempGLEntry."Document No." in ['OBLOANS', 'OBDEPOSITS']) then begin
                        // Opening balance entries
                        OpeningBalance += GetTransactionActualAmount(TransactionNo, GLAccountNo, CustomerNo);
                    end else if NetAmount > 0 then begin
                        // Net debit transaction
                        TotalDebits += NetAmount;
                    end else if NetAmount < 0 then begin
                        // Net credit transaction
                        TotalCredits += Abs(NetAmount);
                    end;
                end;
            until TempGLEntry.Next() = 0;

        // Third pass: Handle direct postings (entries without source)
        // This section processes entries that don't have a Source No. but are part of 
        // transactions that may relate to the customer
        if CustomerNo = '' then begin
            GLEntryRec.Reset();
            GLEntryRec.SetRange("G/L Account No.", GLAccountNo);
            GLEntryRec.SetRange("Source No.", ''); // Direct postings
            GLEntryRec.SetRange("Posting Date", StartDate, EndDate);

            if GLEntryRec.FindSet() then
                repeat
                    TransactionNo := GLEntryRec."Transaction No.";

                    // Only process transactions that haven't been processed yet
                    if not ProcessedTransactions.Contains(TransactionNo) then begin

                        FnCalculateDirectPostingTotals(TransactionNo, CustomerNo, TransactionSummary,
                            NetAmount, TotalDebits, TotalCredits, OpeningBalance, Balance);
                        ProcessedTransactions.Add(TransactionNo);

                        IdentifiedCustomerNo := CustomerNo;
                        IdentifiedCustomerName := 'Unknown Customer';
                    end;
                until GLEntryRec.Next() = 0;
        end;

        // Calculate final balance
        if IsAssetAccount then
            Balance := OpeningBalance + TotalDebits - TotalCredits
        else
            Balance := OpeningBalance + TotalCredits - TotalDebits;
    end;

    local procedure IsAssetGLAccount(GLAccountNo: Code[20]): Boolean
    var
        GLAccount: Record "G/L Account";
    begin
        if GLAccount.Get(GLAccountNo) then
            exit(GLAccount."Account Category" = GLAccount."Account Category"::Assets);

        // Fallback: Check specific account numbers
        exit((GLAccountNo = '1211') or (GLAccountNo = '1212') or (GLAccountNo = '1213') or
             (GLAccountNo = '1214') or (GLAccountNo = '1215') or (GLAccountNo = '1217') or
             (GLAccountNo = '1218') or (GLAccountNo = '1219'));
    end;

    local procedure CalculateTransactionNetAmount(TransactionNo: Integer; GLAccountNo: Code[20]; CustomerNo: Code[20]): Decimal
    var
        GLEntry: Record "G/L Entry";
        NetAmount: Decimal;
    begin
        NetAmount := 0;
        GLEntry.SetRange("Transaction No.", TransactionNo);
        GLEntry.SetRange("G/L Account No.", GLAccountNo);
        GLEntry.SetRange("Source No.", CustomerNo);
        GLEntry.SetRange("Posting Date", StartDate, EndDate);

        if GLEntry.FindSet() then
            repeat
                if not ((GLEntry."Reversed Entry No." <> 0) or IsEntryReversed(GLEntry."Entry No.")) then
                    NetAmount += GLEntry.Amount;
            until GLEntry.Next() = 0;

        exit(NetAmount);
    end;


    local procedure GetTransactionActualAmount(TransactionNo: Integer; GLAccountNo: Code[20]; CustomerNo: Code[20]): Decimal
    var
        GLEntry: Record "G/L Entry";
        ActualAmount: Decimal;
    begin
        ActualAmount := 0;
        GLEntry.SetRange("Transaction No.", TransactionNo);
        GLEntry.SetRange("G/L Account No.", GLAccountNo);
        GLEntry.SetRange("Source No.", CustomerNo);
        GLEntry.SetRange("Bal. Account No.", CustomerNo);

        GLEntry.SetRange("Posting Date", StartDate, EndDate);

        if GLEntry.FindSet() then
            repeat
                if not ((GLEntry."Reversed Entry No." <> 0) or IsEntryReversed(GLEntry."Entry No.")) then
                    if IsAssetGLAccount(GLAccountNo) then begin

                        ActualAmount += -GLEntry.Amount

                    end else begin

                        ActualAmount += GLEntry.Amount;

                    end;


            until GLEntry.Next() = 0;

        exit(ActualAmount);
    end;



    local procedure IsEntryReversed(EntryNo: Integer): Boolean
    var
        GLEntryCheck: Record "G/L Entry";
    begin
        GLEntryCheck.Reset();
        GLEntryCheck.SetRange("Reversed Entry No.", EntryNo);
        exit(not GLEntryCheck.IsEmpty());
    end;


    //special proc to calculate totals involving direct postings between g/ls 
    procedure FnCalculateDirectPostingTotals(TransactionNo: Integer; CustomerNo: Code[20]; var TransactionSummary: Dictionary of [Integer, Decimal]; var TransactionNetAmount: Decimal; var TotalDebits: Decimal; var TotalCredits: Decimal; var OpeningBalance: Decimal; var Balance: Decimal)
    var
        GLEntryRec: Record "G/L Entry";
        NetAmount: Decimal;
        TempGLEntry: Record "G/L Entry" temporary;
    begin


        // First pass: Collect all entries and handle reversals
        GLEntryRec.Reset();
        GLEntryRec.SetRange("Transaction No.", TransactionNo);
        GLEntryRec.SetRange("Source No.", CustomerNo);
        GLEntryRec.SetRange("Posting Date", StartDate, EndDate);


        if GLEntryRec.FindSet() then
            repeat
                // Handle reversed entries
                if (GLEntryRec."Reversed Entry No." <> 0) or IsEntryReversed(GLEntryRec."Entry No.") then begin
                    TotalAmountReversed += Abs(GLEntryRec.Amount);
                end else begin
                    // Store non-reversed entries for processing
                    TempGLEntry := GLEntryRec;
                    TempGLEntry.Insert();
                end;
            until GLEntryRec.Next() = 0;

        // Second pass: Group by transaction and calculate net amounts
        TempGLEntry.Reset();
        if TempGLEntry.FindSet() then
            repeat
                TransactionNo := TempGLEntry."Transaction No.";

                // Process each transaction only once
                if not TransactionSummary.ContainsKey(TransactionNo) then begin



                    NetAmount += TempGLEntry.Amount;

                    TransactionSummary.Add(TransactionNo, NetAmount);

                    if (NetAmount = 0) and (TempGLEntry."Document No." in ['OBLOANS', 'OBDEPOSITS']) then begin
                        // Opening balance entries
                        if IsAssetGLAccount(TempGLEntry."G/L Account No.") then begin

                            OpeningBalance += -TempGLEntry.Amount

                        end else begin

                            OpeningBalance += TempGLEntry.Amount;

                        end;
                    end else if NetAmount > 0 then begin
                        // Net debit transaction
                        TotalDebits += NetAmount;
                    end else begin
                        // Net credit transaction
                        TotalCredits += Abs(NetAmount);
                    end;
                end;
            until TempGLEntry.Next() = 0;
    end;


    procedure FnGetSourceNo(GLAccountNo: Code[20])
    begin

    end;
}