namespace KRBERPSourceCode.KRBERPSourceCode;

using Microsoft.Finance.GeneralLedger.Account;
using Microsoft.Foundation.Company;
using System.Utilities;

report 59065 KRBFinancialPosition2
{
    ApplicationArea = All;
    Caption = 'KRBFinancialPosition';
    UsageCategory = ReportsAndAnalysis;
    RDLCLayout = './Layout/KRBFinancialPosition2.rdl';
    dataset
    {

        dataitem(GLAccount; "G/L Account")
        {
            DataItemTableView = sorting("No.") where(Blocked = filter(false), "Income/Balance" = const("Balance Sheet"));

            column(SurplusOrLoss; AbsDecimal(Surplus)) { }
            column(CorporateTax; AbsDecimal(CorporateTax)) { }
            column(NetProfitAfterTax; AbsDecimal(NetProfitAfterTax)) { }

            // Previous Year Comparison Columns (All Positive)
            column(SurplusOrLossPrevYear; AbsDecimal(SurplusPrevYear)) { }
            column(CorporateTaxPrevYear; AbsDecimal(CorporateTaxPrevYear)) { }
            column(NetProfitAfterTaxPrevYear; AbsDecimal(NetProfitAfterTaxPrevYear)) { }

            column(TotalBalance; AbsDecimal(GetTotalBalance(GLAccount))) { }
            column(Balance2026; AbsDecimal(GetYearBalance(GLAccount, Year2026Start, Year2026End))) { }
            column(Balance2027; AbsDecimal(GetYearBalance(GLAccount, Year2027Start, Year2027End))) { }
            column(Balance2028; AbsDecimal(GetYearBalance(GLAccount, Year2028Start, Year2028End))) { }

            // Current Year and Previous Year Balance Columns (All Positive Values)
            column(BalanceCurrentYear; AbsDecimal(GetYearBalance(GLAccount, CurrentYearStart, CurrentYearEnd))) { }
            column(BalancePreviousYear; AbsDecimal(GetYearBalance(GLAccount, PreviousYearStart, PreviousYearEnd))) { }
            column(BalanceVariance; AbsDecimal(GetYearBalance(GLAccount, CurrentYearStart, CurrentYearEnd) - GetYearBalance(GLAccount, PreviousYearStart, PreviousYearEnd))) { }
            column(BalanceVariancePercent; AbsDecimal(GetVariancePercentage(GetYearBalance(GLAccount, CurrentYearStart, CurrentYearEnd), GetYearBalance(GLAccount, PreviousYearStart, PreviousYearEnd)))) { }

            // Cumulative Balance Fields (like original GLAccountBalance) - All Positive
            column(BalanceAsOfCurrentDate; AbsDecimal(GetCumulativeBalance(GLAccount, CurrentYearEnd))) { }
            column(BalanceAsOfPreviousDate; AbsDecimal(GetCumulativeBalance(GLAccount, PreviousYearEnd))) { }

            column(Level1; GetAccountNameByLength("No.", 1)) { }
            column(Level2; GetAccountNameByLength("No.", 2)) { }
            column(Level3; GetAccountNameByLength("No.", 3)) { }

            column(LevelNo; GetLevelNo("No.", "Account Type")) { }

            column(DisplayName; GetDisplayName("No.", Name, "Account Type", "Account Subcategory Descript.")) { }

            column(Name; Name) { }

            column(NetChange; AbsDecimal("Net Change"))
            {
                AutoFormatType = 1;
            }

            column(GLAccountBalance; AbsDecimal("GL Account Balance"))
            {
                AutoFormatType = 1;
            }

            column(Balance_at_Date; AbsDecimal("Balance at Date"))
            {
                AutoFormatType = 1;
            }

            column(Account_Subcategory_Entry_No_; "Account Subcategory Entry No.") { }
            column(Account_Subcategory_Descript_; "Account Subcategory Descript.") { }
            column(No; "No.") { }
            column(AccountCategory; "Account Category") { }
            column(Account_Type; "Account Type") { }
            column(Account_Category; "Account Category") { }

            column(StartDateText; Format(StartDate)) { }
            column(EndDateText; Format(Today, 0, '<Month,2>/<Day,2>/<Year4>')) { }
            column(PreviousYearStartText; Format(PreviousYearStart)) { }
            column(PreviousYearEndText; Format(PreviousYearEnd)) { }

            column(Company_Name; Company.Name) { }
            column(Company_Address; Company.Address) { }
            column(Company_Address_2; Company."Address 2") { }
            column(Company_Phone_No; Company."Phone No.") { }
            column(Company_Fax_No; Company."Fax No.") { }
            column(Company_Picture; Company.Picture) { }
            column(Company_Email; Company."E-Mail") { }
            column(CurrentYear; CurrentYear) { }
            column(PreviousYear; PreviousYear) { }

            trigger OnPreDataItem()
            begin
                SetRange("Income/Balance", "Income/Balance"::"Balance Sheet");
                SetFilter("Date Filter", '%1..%2', StartDate, EndDate);
                Clear(TotalNetChange);
            end;

            trigger OnAfterGetRecord()
            var
                InputDate: Date;
                DateFormula: Text;
                DateExpr2: Text;
                StartOfCurrentYear: Date;
                StartOfPreviousYear: Date;
                EndOfLastYear: Date;
            begin
                // Calculate financial values with proper date filter for current period
                SetRange("Date Filter", StartDate, EndDate);
                CalcFields("Net Change", "GL Account Balance", "Balance at Date");

                // Skip zero-balance records (except for headings/totals)
                if not ShowZeroBalances then begin
                    // Check both current and previous year balances before skipping
                    if ("Account Type" <> "Account Type"::"Heading") and
                       ("Account Type" <> "Account Type"::"Begin-Total") and
                       ("Net Change" = 0) and
                       ("Balance at Date" = 0) and
                       (GetYearBalance(GLAccount, PreviousYearStart, PreviousYearEnd) = 0)
                    then
                        CurrReport.Skip();
                end;

                // Set up year values using current EndDate
                InputDate := EndDate;

                // Extract year numbers for layout display
                CurrentYear := Date2DMY(InputDate, 3);
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
                    field(StartDateReq; StartDate)
                    {
                        ApplicationArea = All;
                        Caption = 'Start Date';
                    }
                    field(EndDateReq; EndDate)
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
    }

    var
        Asat: Date;
        ThisYear: Date;
        CurrentYear: Integer;
        PreviousYear: Integer;
        StartDate: Date;
        EndDate: Date;
        TotalNetChange: Decimal;
        Company: Record "Company Information";
        AccountNameIndented: Text[100];
        SurplusLoss: Decimal;
        NetProfitAfterTax: Decimal;
        Surplus: Decimal;
        CorporateTax: Decimal;
        ShowZeroBalances: Boolean;
        ShowPreviousYearComparison: Boolean;

        // Previous Year Variables
        PreviousYearStart: Date;
        PreviousYearEnd: Date;
        CurrentYearStart: Date;
        CurrentYearEnd: Date;
        SurplusPrevYear: Decimal;
        CorporateTaxPrevYear: Decimal;
        NetProfitAfterTaxPrevYear: Decimal;

        // Fixed Year Variables
        Year2026Start: Date;
        Year2026End: Date;
        Year2027Start: Date;
        Year2027End: Date;
        Year2028Start: Date;
        Year2028End: Date;

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

        // Calculate previous year dates - CORRECTED
        PreviousYearStart := CalcDate('<-1Y>', StartDate);
        PreviousYearEnd := CalcDate('<-1Y>', EndDate);

        // Alternative method if the above doesn't work:
        // PreviousYearEnd := CalcDate('<-1D>', DMY2DATE(1, 1, Date2DMY(EndDate, 3)));
        // PreviousYearStart := DMY2DATE(1, 1, Date2DMY(PreviousYearEnd, 3));

        // Fixed years
        Year2026Start := DMY2DATE(1, 1, 2026);
        Year2026End := DMY2DATE(31, 12, 2026);
        Year2027Start := DMY2DATE(1, 1, 2027);
        Year2027End := DMY2DATE(31, 12, 2027);
        Year2028Start := DMY2DATE(1, 1, 2028);
        Year2028End := DMY2DATE(31, 12, 2028);

        // Calculate current year figures
        GetSurplusTaxAndNetProfit();

        // Calculate previous year figures
        GetSurplusTaxAndNetProfitPrevYear();

        // Debug dates - uncomment to test
        // DebugDates();
    end;

    local procedure GetAccountNameByLength(AccountNo: Code[20]; LevelLength: Integer): Text
    var
        CoA: Record "G/L Account";
        GroupNo: Code[20];
    begin
        if STRLEN(AccountNo) < LevelLength then
            exit('');

        GroupNo := COPYSTR(AccountNo, 1, LevelLength);
        CoA.SetFilter("Income/Balance", 'Balance Sheet');

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

        exit(0);
    end;

    local procedure GetDisplayName(AccountNo: Code[20]; AccountName: Text; AccountType: Enum "G/L Account Type"; AccountSubCategory: Text): Text
    var
        Level: Integer;
        Indent: Text;
    begin
        Level := GetLevelNo(AccountNo, AccountType);

        case Level of
            1:
                Indent := '';
            2:
                Indent := '    ';
            3:
                Indent := '        ';
            4:
                if (AccountType = AccountType::Total) and (AccountSubCategory <> '') then
                    Indent := '    '
                else if AccountType = AccountType::"End-Total" then
                    Indent := '        '
                else if (AccountType = AccountType::Total) and (AccountSubCategory = '') then
                    Indent := ''
                else
                    Indent := '            ';
            5:
                Indent := '        ';
            6:
                Indent := '    ';
        end;

        case Level of
            1 .. 3:
                exit(Indent + AccountName);
            4:
                if AccountType <> AccountType::Posting then
                    exit(Indent + AccountName)
                else
                    exit(Indent + AccountNo);
        end;
    end;

    local procedure GetTotalBalance(Account: Record "G/L Account"): Decimal
    var
        TotalBalance: Decimal;
    begin
        if Account."Account Type" in [Account."Account Type"::Total, Account."Account Type"::"End-Total"] then begin
            Account.CalcFields("Balance at Date");
            TotalBalance := Account."Balance at Date";
        end;

        exit(AbsDecimal(TotalBalance));
    end;

    local procedure GetYearBalance(Account: Record "G/L Account"; StartDate: Date; EndDate: Date): Decimal
    var
        TempAccount: Record "G/L Account";
    begin
        TempAccount.Get(Account."No.");

        // For Balance Sheet accounts, we want balance as of the end date
        if Account."Income/Balance" = Account."Income/Balance"::"Balance Sheet" then begin
            TempAccount.SetRange("Date Filter", 0D, EndDate); // From beginning of time to end date
            TempAccount.CalcFields("Balance at Date");
            exit(TempAccount."Balance at Date");
        end else begin
            // For Income Statement accounts, we want the period balance
            TempAccount.SetRange("Date Filter", StartDate, EndDate);
            TempAccount.CalcFields("Net Change");
            exit(TempAccount."Net Change");
        end;
    end;

    local procedure GetVariancePercentage(CurrentValue: Decimal; PreviousValue: Decimal): Decimal
    begin
        if PreviousValue = 0 then begin
            if CurrentValue = 0 then
                exit(0)
            else
                exit(100); // or return a large number to indicate infinite growth
        end;

        exit(((CurrentValue - PreviousValue) / AbsDecimal(PreviousValue)) * 100);
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
        CorporateTax := Surplus * (0.00 / 100);
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

    local procedure GetCumulativeBalance(Account: Record "G/L Account"; AsOfDate: Date): Decimal
    var
        TempAccount: Record "G/L Account";
    begin
        TempAccount.Get(Account."No.");
        TempAccount.SetRange("Date Filter", 0D, AsOfDate);
        TempAccount.CalcFields("Balance at Date");
        exit(TempAccount."Balance at Date");
    end;

    local procedure AbsDecimal(Value: Decimal): Decimal
    begin
        if Value < 0 then
            exit(-Value)
        else
            exit(Value);
    end;

    // Add this helper function to debug date calculations
    local procedure DebugDates()
    begin
        Message('Current Year: %1 to %2\Previous Year: %3 to %4',
            CurrentYearStart, CurrentYearEnd,
            PreviousYearStart, PreviousYearEnd);
    end;
}