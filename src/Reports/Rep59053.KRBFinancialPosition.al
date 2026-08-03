namespace KRBERPSourceCode.KRBERPSourceCode;

using Microsoft.Finance.GeneralLedger.Account;
using Microsoft.Foundation.Company;
using System.Utilities;

report 59053 KRBFinancialPosition
{
    ApplicationArea = All;
    Caption = 'KRBFinancialPosition';
    UsageCategory = ReportsAndAnalysis;
    RDLCLayout = './Layout/KRBFinancialPosition.rdl';
    dataset
    {
        dataitem(GLAccount; "G/L Account")
        {
            DataItemTableView = sorting("No.") where(Blocked = filter(false), "Income/Balance" = const("Balance Sheet"));

            column(SurplusOrLoss; Surplus) { }
            column(CorporateTax; CorporateTax) { }
            column(NetProfitAfterTax; NetProfitAfterTax) { }
            column(TotalBalance; GetTotalBalance(GLAccount)) { }
            column(Level1; GetAccountNameByLength("No.", 1)) { }
            column(Level2; GetAccountNameByLength("No.", 2)) { }
            column(Level3; GetAccountNameByLength("No.", 3)) { }
            column(LevelNo; GetLevelNo("No.", "Account Type")) { }
            column(DisplayName; GetDisplayName("No.", Name, "Account Type", "Account Subcategory Descript.")) { }
            column(Name; Name) { }
            column(NetChange; "Net Change")
            {
                AutoFormatType = 1;
            }
            column(GLAccountBalance; "Net Change")
            {
                AutoFormatType = 1;
            }
            column(Balance_at_Date; "Net Change")
            {
                AutoFormatType = 1;
            }
            column(Account_Subcategory_Entry_No_; "Account Subcategory Entry No.") { }
            column(Account_Subcategory_Descript_; "Account Subcategory Descript.") { }
            column(No; "No.") { }
            column(AccountCategory; "Account Category") { }
            column(Account_Type; "Account Type") { }
            column(Account_Category; "Account Category") { }
            column(StartDateText; GetStartDateText()) { }
            column(EndDateText; GetEndDateText()) { }
            column(ShowDateRange; ShowDateRange()) { }
            column(Company_Name; Company.Name) { }
            column(Company_Address; Company.Address) { }
            column(Company_Address_2; Company."Address 2") { }
            column(Company_Phone_No; Company."Phone No.") { }
            column(Company_Fax_No; Company."Fax No.") { }
            column(Company_Picture; Company.Picture) { }
            column(Company_Email; Company."E-Mail") { }

            trigger OnPreDataItem()
            begin
                // Ensure Income/Balance filter is set
                SetRange("Income/Balance", "Income/Balance"::"Balance Sheet");

                // Apply date filter ONLY if user provided dates
                if (StartDate <> 0D) and (EndDate <> 0D) then
                    SetFilter("Date Filter", '%1..%2', StartDate, EndDate)
                else if (StartDate <> 0D) then
                    SetFilter("Date Filter", '%1..', StartDate)
                else if (EndDate <> 0D) then
                    SetFilter("Date Filter", '..%1', EndDate);
                // If both are 0D, no date filter = show all data

                // Initialize variables
                Clear(TotalNetChange);
            end;

            trigger OnAfterGetRecord()
            begin
                // Apply date filter ONLY if user provided dates
                if (StartDate <> 0D) and (EndDate <> 0D) then
                    SetFilter("Date Filter", '%1..%2', StartDate, EndDate)
                else if (StartDate <> 0D) then
                    SetFilter("Date Filter", '%1..', StartDate)
                else if (EndDate <> 0D) then
                    SetFilter("Date Filter", '..%1', EndDate);
                // If both are 0D, no date filter = show all data

                // Calculate fields with the correct filter context (or no filter)
                CalcFields("Net Change");

                // Skip zero balance accounts if option is not selected
                if not ShowZeroBalances then begin
                    if ("Account Type" <> "Account Type"::Heading) and
                       ("Account Type" <> "Account Type"::"Begin-Total") and
                       ("Net Change" = 0) then
                        CurrReport.Skip();
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
        Company: Record "Company Information";
        AccountNameIndented: Text[100];
        SurplusLoss: Decimal;
        NetProfitAfterTax: Decimal;
        Surplus: Decimal;
        CorporateTax: Decimal;
        ShowZeroBalances: Boolean;

    trigger OnPreReport()
    begin
        Company.Get();
        Company.CalcFields(Company.Picture);

        // Don't set default dates - allow empty filter to show all data
        // User must explicitly set dates to filter

        // Calculate profit/loss with the date filter
        GetSurplusTaxAndNetProfit();
    end;

    local procedure GetStartDateText(): Text
    begin
        if StartDate = 0D then
            exit('')
        else
            exit(Format(StartDate, 0, '<Month,2>/<Day,2>/<Year4>'));
    end;

    local procedure GetEndDateText(): Text
    begin
        if EndDate = 0D then
            exit(Format(Today(), 0, '<Month,2>/<Day,2>/<Year4>'))
        else
            exit(Format(EndDate, 0, '<Month,2>/<Day,2>/<Year4>'));
    end;

    local procedure ShowDateRange(): Boolean
    begin
        exit((StartDate <> 0D) and (EndDate <> 0D));
    end;

    local procedure GetAccountNameByLength(AccountNo: Code[20]; LevelLength: Integer): Text
    var
        CoA: Record "G/L Account";
        GroupNo: Code[20];
    begin
        if StrLen(AccountNo) < LevelLength then
            exit('');

        GroupNo := CopyStr(AccountNo, 1, LevelLength);

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
        GLAcc: Record "G/L Account";
        TotalBalance: Decimal;
    begin
        if Account."Account Type" in [Account."Account Type"::Total, Account."Account Type"::"End-Total"] then begin
            GLAcc := Account;

            // Apply date filter ONLY if user provided dates
            if (StartDate <> 0D) and (EndDate <> 0D) then
                GLAcc.SetFilter("Date Filter", '%1..%2', StartDate, EndDate)
            else if (StartDate <> 0D) then
                GLAcc.SetFilter("Date Filter", '%1..', StartDate)
            else if (EndDate <> 0D) then
                GLAcc.SetFilter("Date Filter", '..%1', EndDate);
            // If both are 0D, no date filter = all data

            GLAcc.CalcFields("Net Change");
            TotalBalance := GLAcc."Net Change";
        end;

        exit(AbsDecimal(TotalBalance));
    end;

    procedure GetSurplusTaxAndNetProfit()
    var
        GLAccount: Record "G/L Account";
        TotalIncome: Decimal;
        TotalExpenses: Decimal;
    begin
        GLAccount.Reset();
        GLAccount.SetRange("Income/Balance", GLAccount."Income/Balance"::"Income Statement");

        // Apply the date filter consistently
        if (StartDate <> 0D) and (EndDate <> 0D) then
            GLAccount.SetFilter("Date Filter", '%1..%2', StartDate, EndDate)
        else if EndDate <> 0D then
            GLAccount.SetFilter("Date Filter", '..%1', EndDate);

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

    local procedure AbsDecimal(Value: Decimal): Decimal
    begin
        if Value < 0 then
            exit(-Value)
        else
            exit(Value);
    end;
}