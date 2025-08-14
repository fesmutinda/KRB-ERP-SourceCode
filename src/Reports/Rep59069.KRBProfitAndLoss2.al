namespace KRBERPSourceCode.KRBERPSourceCode;

using Microsoft.Finance.GeneralLedger.Account;
using Microsoft.Foundation.Company;

report 59069 KRBProfitAndLoss2
{
    ApplicationArea = All;
    Caption = 'KRBProfitAndLoss2';
    UsageCategory = ReportsAndAnalysis;
    RDLCLayout = './Layout/KRBProfitLoss2.rdl';
    dataset
    {
        dataitem(GLAccount; "G/L Account")
        {

            DataItemTableView = sorting("No.") where(Blocked = filter(false), "Income/Balance" = const("Income Statement"));

            RequestFilterFields = "No.", "Account Type", "Date Filter", "Account Category";

            // Current Year Financial Results
            column(SurplusOrLoss; Abs(Surplus)) { }
            column(CorporateTax; Abs(CorporateTax)) { }
            column(NetProfitAfterTax; Abs(NetProfitAfterTax)) { }

            // Previous Year Financial Results
            column(SurplusOrLossPrevYear; Abs(SurplusPrevYear)) { }
            column(CorporateTaxPrevYear; Abs(CorporateTaxPrevYear)) { }
            column(NetProfitAfterTaxPrevYear; Abs(NetProfitAfterTaxPrevYear)) { }

            // Dynamic Year Headers
            column(CurrentYear; CurrentYear) { }
            column(PreviousYear; PreviousYear) { }

            // Date Columns
            column(StartDateCol; Format(StartDate, 0, '<Day,2>/<Month,2>/<Year4>')) { }
            column(EndDateCol; Format(EndDate, 0, '<Day,2>/<Month,2>/<Year4>')) { }
            column(PreviousYearStartText; Format(PreviousYearStart)) { }
            column(PreviousYearEndText; Format(PreviousYearEnd)) { }

            // Current Year and Previous Year Balance Columns - All Positive
            column(BalanceCurrentYear; Abs(GetYearBalance(GLAccount, CurrentYearStart, CurrentYearEnd))) { }
            column(BalancePreviousYear; Abs(GetYearBalance(GLAccount, PreviousYearStart, PreviousYearEnd))) { }
            column(BalanceVariance; Abs(GetYearBalance(GLAccount, CurrentYearStart, CurrentYearEnd) - GetYearBalance(GLAccount, PreviousYearStart, PreviousYearEnd))) { }
            column(BalanceVariancePercent; GetVariancePercentage(GetYearBalance(GLAccount, CurrentYearStart, CurrentYearEnd), GetYearBalance(GLAccount, PreviousYearStart, PreviousYearEnd))) { }

            // Existing Balance Columns - All Positive
            column(OpeningBalance; Abs(GetOpeningBalance(GLAccount, StartDate))) { }
            column(ClosingBalance; Abs(GetClosingBalance(GLAccount, EndDate))) { }
            column(TotalBalance; Abs(GetTotalBalance(GLAccount))) { }

            column(LevelNo; GetLevelNo("No.", "Account Type")) { }
            column(DisplayName; GetDisplayName("No.", Name, "Account Type", "Account Subcategory Descript.")) { }

            // Flag to identify if this is a category header (should show no amounts)
            column(IsCategoryHeader; IsCategoryHeader("Account Type", "No.", Name)) { }

            // Company Information
            column(Company_Name; Company.Name) { }
            column(Company_Address; Company.Address) { }
            column(Company_Address_2; Company."Address 2") { }
            column(Company_Phone_No; Company."Phone No.") { }
            column(Company_Fax_No; Company."Fax No.") { }
            column(Company_Picture; Company.Picture) { }
            column(Company_Email; Company."E-Mail") { }

            // GL Account Fields - All Positive Values
            column(AccountCategory; "Account Category") { }
            column(AccountSubcategoryDescript; "Account Subcategory Descript.") { }
            column(AccountSubcategoryEntryNo; "Account Subcategory Entry No.") { }
            column(AccountType; "Account Type") { }
            column(CreditAmount; Abs("Credit Amount")) { }
            column(DebitAmount; Abs("Debit Amount")) { }
            column(DebitCredit; "Debit/Credit") { }
            column(GLAccountBalance; Abs("GL Account Balance")) { }
            column(IncomeBalance; "Income/Balance") { }
            column(Name; Name) { }
            column(No; "No.") { }
            column(NetChange; Abs("Net Change")) { }
            column(BalanceatDate; Abs("Balance at Date")) { }
            column(Balance; Abs(Balance)) { }

            trigger OnPreDataItem()
            begin
                SetRange("Income/Balance", "Income/Balance"::"Income Statement");

                // Apply date filter based on parameters
                SetFilter("Date Filter", '%1..%2', StartDate, EndDate);

                // Initialize variables
                Clear(TotalNetChange);

                // Build the list of accounts to hide if ShowZeroBalances is false
                if not ShowZeroBalances then
                    BuildHiddenAccountsList();
            end;

            trigger OnAfterGetRecord()
            begin
                // Recalculate fields after filtering
                CalcFields("Net Change", "GL Account Balance", "Balance at Date");

                if not ShowZeroBalances then begin
                    // Check if this account should be hidden
                    if ShouldHideAccount("No.", "Account Type", "Totaling") then
                        CurrReport.Skip();

                    // Original logic for Posting and End-Total accounts - now includes previous year check
                    if ("Account Type" = "Account Type"::Posting) then begin
                        if ("Net Change" = 0) and ("Balance at Date" = 0) and
                           (GetYearBalance(GLAccount, PreviousYearStart, PreviousYearEnd) = 0) then
                            CurrReport.Skip();
                    end;

                    if ("Account Type" = "Account Type"::"End-Total") then begin
                        if ("Net Change" = 0) and ("Balance at Date" = 0) and
                           (GetYearBalance(GLAccount, PreviousYearStart, PreviousYearEnd) = 0) then
                            CurrReport.Skip();
                    end;
                end;

                // Set up year values for display
                CurrentYear := Date2DMY(EndDate, 3);
                PreviousYear := CurrentYear - 1;
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
                    field(ShowZeroBalances; ShowZeroBalances)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Show Accounts With No Balances';
                    }
                    field(ShowPreviousYearComparison; ShowPreviousYearComparison)
                    {
                        ApplicationArea = All;
                        Caption = 'Show Previous Year Comparison';
                    }
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
        StartDate: Date;
        EndDate: Date;
        TotalNetChange: Decimal;
        SurplusLoss: Decimal;
        NetProfitAfterTax: Decimal;
        Company: Record "Company Information";
        AccountNameIndented: Text[100];
        Surplus: Decimal;
        CorporateTax: Decimal;
        ShowZeroBalances: Boolean;
        ShowPreviousYearComparison: Boolean;
        HiddenAccounts: List of [Code[20]]; // List to store accounts that should be hidden

        // Year Comparison Variables
        CurrentYear: Integer;
        PreviousYear: Integer;
        PreviousYearStart: Date;
        PreviousYearEnd: Date;
        CurrentYearStart: Date;
        CurrentYearEnd: Date;
        SurplusPrevYear: Decimal;
        CorporateTaxPrevYear: Decimal;
        NetProfitAfterTaxPrevYear: Decimal;

    trigger OnPreReport()
    begin
        Company.Get();
        Company.CalcFields(Company.Picture);

        if EndDate = 0D then
            EndDate := WorkDate();

        if StartDate = 0D then
            StartDate := CalcDate('<-CY>', EndDate);

        // Set current year dates
        CurrentYearStart := StartDate;
        CurrentYearEnd := EndDate;

        // Calculate previous year dates
        PreviousYearStart := CalcDate('<-1Y>', StartDate);
        PreviousYearEnd := CalcDate('<-1Y>', EndDate);

        // Calculate current year financial results
        GetSurplusTaxAndNetProfit();

        // Calculate previous year financial results
        GetSurplusTaxAndNetProfitPrevYear();
    end;

    local procedure BuildHiddenAccountsList()
    var
        GLAcc: Record "G/L Account";
        BeginTotalAcc: Record "G/L Account";
        EndTotalAccountNo: Code[20];
        BeginTotalAccountNo: Code[20];
    begin
        // Clear the list
        Clear(HiddenAccounts);

        // First pass: Find End-Total accounts with zero balances
        GLAcc.SetRange("Income/Balance", GLAcc."Income/Balance"::"Income Statement");
        GLAcc.SetFilter("Date Filter", '%1..%2', StartDate, EndDate);
        GLAcc.SetRange("Account Type", GLAcc."Account Type"::"End-Total");

        if GLAcc.FindSet() then
            repeat
                GLAcc.CalcFields("Net Change", "Balance at Date");

                // If End-Total has zero balances, find its corresponding Begin-Total
                if (GLAcc."Net Change" = 0) and (GLAcc."Balance at Date" = 0) then begin
                    EndTotalAccountNo := GLAcc."No.";
                    BeginTotalAccountNo := FindCorrespondingBeginTotal(EndTotalAccountNo, GLAcc.Totaling);

                    if BeginTotalAccountNo <> '' then begin
                        // Add the Begin-Total account to hidden list
                        HiddenAccounts.Add(BeginTotalAccountNo);

                        // Also hide all accounts between Begin-Total and End-Total
                        AddAccountsInRange(BeginTotalAccountNo, EndTotalAccountNo);
                    end;
                end;
            until GLAcc.Next() = 0;
    end;

    local procedure FindCorrespondingBeginTotal(EndTotalAccountNo: Code[20]; TotalingFilter: Text): Code[20]
    var
        GLAcc: Record "G/L Account";
        FilterParts: List of [Text];
        RangeText: Text;
        BeginAccountNo: Code[20];
    begin
        // Parse the Totaling field to find the range
        // Typically format is like "4000..4999" or "4000|4100..4199"
        FilterParts := TotalingFilter.Split('|');

        foreach RangeText in FilterParts do begin
            if RangeText.Contains('..') then begin
                BeginAccountNo := CopyStr(RangeText.Split('..').Get(1), 1, MaxStrLen(BeginAccountNo));

                // Look for Begin-Total account that starts this range
                GLAcc.SetRange("Income/Balance", GLAcc."Income/Balance"::"Income Statement");
                GLAcc.SetRange("Account Type", GLAcc."Account Type"::"Begin-Total");
                GLAcc.SetFilter("No.", '<=%1', BeginAccountNo);
                GLAcc.SetCurrentKey("No.");

                if GLAcc.FindLast() then begin
                    // Verify this Begin-Total corresponds to our End-Total
                    if IsBeginTotalForEndTotal(GLAcc."No.", EndTotalAccountNo) then
                        exit(GLAcc."No.");
                end;
            end;
        end;

        exit('');
    end;

    local procedure IsBeginTotalForEndTotal(BeginTotalNo: Code[20]; EndTotalNo: Code[20]): Boolean
    var
        GLAcc: Record "G/L Account";
        NextEndTotal: Code[20];
    begin
        // Find the next End-Total after this Begin-Total
        GLAcc.SetRange("Income/Balance", GLAcc."Income/Balance"::"Income Statement");
        GLAcc.SetRange("Account Type", GLAcc."Account Type"::"End-Total");
        GLAcc.SetFilter("No.", '>%1', BeginTotalNo);
        GLAcc.SetCurrentKey("No.");

        if GLAcc.FindFirst() then
            NextEndTotal := GLAcc."No."
        else
            NextEndTotal := '';

        exit(NextEndTotal = EndTotalNo);
    end;

    local procedure AddAccountsInRange(BeginTotalNo: Code[20]; EndTotalNo: Code[20])
    var
        GLAcc: Record "G/L Account";
    begin
        // Add all accounts between Begin-Total and End-Total to hidden list
        GLAcc.SetRange("Income/Balance", GLAcc."Income/Balance"::"Income Statement");
        GLAcc.SetFilter("No.", '>%1&<%2', BeginTotalNo, EndTotalNo);

        if GLAcc.FindSet() then
            repeat
                if not HiddenAccounts.Contains(GLAcc."No.") then
                    HiddenAccounts.Add(GLAcc."No.");
            until GLAcc.Next() = 0;
    end;

    local procedure ShouldHideAccount(AccountNo: Code[20]; AccountType: Enum "G/L Account Type"; TotalingFilter: Text): Boolean
    begin
        // Check if this account is in the hidden accounts list
        if HiddenAccounts.Contains(AccountNo) then
            exit(true);

        exit(false);
    end;

    local procedure IsCategoryHeader(AccountType: Enum "G/L Account Type"; AccountNo: Code[20]; AccountName: Text): Boolean
    begin
        // Identify category headers - these should not show amounts
        // Category headers are typically Begin-Total accounts with specific names
        if AccountType = AccountType::"Begin-Total" then begin
            // Check if this is a main category header based on name
            if (UpperCase(AccountName).Contains('INCOME')) or
               (UpperCase(AccountName).Contains('FEES')) or
               (UpperCase(AccountName).Contains('COMMISSION')) or
               (UpperCase(AccountName).Contains('COSTS')) or
               (UpperCase(AccountName).Contains('EXPENSES')) or
               (UpperCase(AccountName).Contains('OPERATING')) or
               (UpperCase(AccountName).Contains('PAYROLL')) then
                exit(true);
        end;

        exit(false);
    end;

    local procedure GetAccountNameByLength(AccountNo: Code[20]; LevelLength: Integer): Text
    var
        CoA: Record "G/L Account";
        GroupNo: Code[20];
    begin
        if STRLEN(AccountNo) < LevelLength then
            exit('');

        GroupNo := COPYSTR(AccountNo, 1, LevelLength);

        // Apply filter to only retrieve "Income Statement" accounts
        CoA.SetFilter("Income/Balance", 'Income Statement');

        if CoA.Get(GroupNo) and (CoA.Name <> '') then
            exit(CoA.Name)
        else
            exit('[Missing]');
    end;

    local procedure GetLevelNo(AccountNo: Code[20]; AccountType: Enum "G/L Account Type"): Integer
    var
        Length: Integer;
    begin
        Length := StrLen(AccountNo);

        // First check for structural levels based on length and type
        case Length of
            1:
                exit(1);
            2:
                exit(2);
            3:
                exit(3);
            4:
                exit(4);
            5:
                exit(4);
        end;

        exit(0); // Fallback
    end;

    local procedure GetDisplayName(AccountNo: Code[20]; AccountName: Text; AccountType: Enum "G/L Account Type"; AccountSubCategory: Text): Text
    var
        Level: Integer;
        Indent: Text;
    begin
        Level := GetLevelNo(AccountNo, AccountType);

        // Indentation logic (spaces for indentation)
        case Level of
            1:
                Indent := ''; // No indentation for level 1
            2:
                Indent := '    '; // 4 spaces for level 2
            3:
                Indent := '        '; // 8 spaces for level 3
            4:
                // Adjust indentation for Level 4 based on AccountType and G/L Account Category
                if (AccountType = AccountType::Total) and (AccountSubCategory <> '') then
                    Indent := '    ' // Same indent as Level 2
                else if AccountType = AccountType::"End-Total" then
                    Indent := '        ' // Same indent as Level 3
                else if (AccountType = AccountType::Total) and (AccountSubCategory = '') then
                    Indent := ''
                else
                    Indent := '            '; // Default indent for Level 4
            5:
                Indent := '        '; // 8 spaces
            6:
                Indent := '    '; // 4 spaces
        end;

        // Return AccountName for levels 1–3, AccountNo for level 4
        case Level of
            1 .. 3:
                exit(Indent + AccountName);
            4:
                if AccountType <> AccountType::Posting then
                    exit(Indent + AccountName) // If not a Posting account, display AccountName
                else
                    exit(Indent + AccountNo); // If Posting, display AccountNo
        end;
    end;

    local procedure GetTotalBalance(Account: Record "G/L Account"): Decimal
    var
        GLAcc: Record "G/L Account";
        TotalBalance: Decimal;
    begin
        if Account."Account Type" in [Account."Account Type"::Total, Account."Account Type"::"End-Total"] then begin
            // This approach uses the standard calculation engine
            Account.CalcFields("Balance at Date");
            TotalBalance := Account."Balance at Date";
        end;

        exit(TotalBalance);
    end;

    local procedure GetYearBalance(Account: Record "G/L Account"; StartDate: Date; EndDate: Date): Decimal
    var
        TempAccount: Record "G/L Account";
    begin
        TempAccount.Get(Account."No.");

        // For Income Statement accounts, we want the period balance
        TempAccount.SetRange("Date Filter", StartDate, EndDate);
        TempAccount.CalcFields("Net Change");
        exit(TempAccount."Net Change");
    end;

    local procedure GetVariancePercentage(CurrentValue: Decimal; PreviousValue: Decimal): Decimal
    begin
        if PreviousValue = 0 then begin
            if CurrentValue = 0 then
                exit(0)
            else
                exit(100); // or return a large number to indicate infinite growth
        end;

        exit(((CurrentValue - PreviousValue) / Abs(PreviousValue)) * 100);
    end;

    local procedure GetOpeningBalance(Account: Record "G/L Account"; OpeningDate: Date): Decimal
    var
        OpeningBalance: Decimal;
    begin
        Account.SetRange("Date Filter", 0D, OpeningDate - 1); // All entries before the opening date
        Account.CalcFields("Net Change");

        OpeningBalance := Account."Net Change"; // Opening balance is sum before OpeningDate

        exit(OpeningBalance);
    end;

    local procedure GetClosingBalance(Account: Record "G/L Account"; EndDate: Date): Decimal
    var
        TempAcc: Record "G/L Account";
    begin
        TempAcc := Account;
        TempAcc.SetRange("Date Filter", 0D, EndDate); // Up to closing date
        TempAcc.CalcFields("Net Change");
        exit(TempAcc."Net Change");
    end;

    procedure GetSurplusTaxAndNetProfit()
    var
        GLAccount: Record "G/L Account";
        TotalIncome: Decimal;
        TotalExpenses: Decimal;
    begin
        GLAccount.Reset();
        GLAccount.SetRange("Income/Balance", GLAccount."Income/Balance"::"Income Statement");
        GLAccount.SetFilter("Date Filter", '%1..%2', StartDate, EndDate);

        if GLAccount.FindSet() then
            repeat
                GLAccount.CalcFields("Net Change");

                if (GLAccount."Account Category" = GLAccount."Account Category"::Income) and
                   (GLAccount."Account Type" = GLAccount."Account Type"::Posting) then
                    TotalIncome += GLAccount."Net Change";

                if (GLAccount."Account Category" = GLAccount."Account Category"::Expense) and
                   (GLAccount."Account Type" = GLAccount."Account Type"::Posting) then
                    TotalExpenses += GLAccount."Net Change";
            until GLAccount.Next() = 0;

        Surplus := -TotalIncome - TotalExpenses;
        CorporateTax := Surplus * (0.00 / 100); // Replace 0.00 with actual tax rate if needed
        NetProfitAfterTax := Surplus - CorporateTax;
    end;

    procedure GetSurplusTaxAndNetProfitPrevYear()
    var
        GLAccount: Record "G/L Account";
        TotalIncomePrev: Decimal;
        TotalExpensesPrev: Decimal;
    begin
        GLAccount.Reset();
        GLAccount.SetRange("Income/Balance", GLAccount."Income/Balance"::"Income Statement");
        GLAccount.SetFilter("Date Filter", '%1..%2', PreviousYearStart, PreviousYearEnd);

        if GLAccount.FindSet() then
            repeat
                GLAccount.CalcFields("Net Change");

                if (GLAccount."Account Category" = GLAccount."Account Category"::Income) and
                   (GLAccount."Account Type" = GLAccount."Account Type"::Posting) then
                    TotalIncomePrev += GLAccount."Net Change";

                if (GLAccount."Account Category" = GLAccount."Account Category"::Expense) and
                   (GLAccount."Account Type" = GLAccount."Account Type"::Posting) then
                    TotalExpensesPrev += GLAccount."Net Change";
            until GLAccount.Next() = 0;

        SurplusPrevYear := -TotalIncomePrev - TotalExpensesPrev;
        CorporateTaxPrevYear := SurplusPrevYear * (0.00 / 100);
        NetProfitAfterTaxPrevYear := SurplusPrevYear - CorporateTaxPrevYear;
    end;
}