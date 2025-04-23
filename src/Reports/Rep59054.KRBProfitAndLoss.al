namespace KRBERPSourceCode.KRBERPSourceCode;

using Microsoft.Finance.GeneralLedger.Account;
using Microsoft.Foundation.Company;

report 59054 KRBProfitAndLoss
{
    ApplicationArea = All;
    Caption = 'KRBProfitAndLoss';
    UsageCategory = ReportsAndAnalysis;
    RDLCLayout = './Layout/KRBProfitLoss.rdl';
    dataset
    {
        dataitem(GLAccount; "G/L Account")
        {

            DataItemTableView = sorting("No.") where(Blocked = filter(false), "Income/Balance" = const("Income Statement"));

            RequestFilterFields = "No.", "Account Type", "Date Filter", "Account Category";



            column(SurplusOrLoss; Surplus) { }
            column(CorporateTax; CorporateTax) { }
            column(NetProfitAfterTax; NetProfitAfterTax) { }

            column(StartDateCol; Format(StartDate, 0, '<Day,2>/<Month,2>/<Year4>')) { }

            column(EndDateCol; Format(EndDate, 0, '<Day,2>/<Month,2>/<Year4>')) { }

            column(OpeningBalance; GetOpeningBalance(GLAccount, StartDate)) { }

            column(ClosingBalance; GetClosingBalance(GLAccount, EndDate)) { }
            column(TotalBalance; GetTotalBalance(GLAccount)) { }

            column(LevelNo; GetLevelNo("No.", "Account Type")) { }


            column(DisplayName; GetDisplayName("No.", Name, "Account Type", "Account Subcategory Descript.")) { }
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




            column(AccountCategory; "Account Category")
            {
            }
            column(AccountSubcategoryDescript; "Account Subcategory Descript.")
            {
            }
            column(AccountSubcategoryEntryNo; "Account Subcategory Entry No.")
            {
            }
            column(AccountType; "Account Type")
            {
            }
            column(CreditAmount; "Credit Amount")
            {
            }
            column(DebitAmount; "Debit Amount")
            {
            }
            column(DebitCredit; "Debit/Credit")
            {
            }
            column(GLAccountBalance; "GL Account Balance")
            {
            }
            column(IncomeBalance; "Income/Balance")
            {
            }
            column(Name; Name)
            {
            }
            column(No; "No.")
            {
            }
            column(NetChange; "Net Change")
            {
            }
            column(BalanceatDate; "Balance at Date")
            {
            }
            column(Balance; Balance)
            {
            }

            trigger OnPreDataItem()
            begin
                SetRange("Income/Balance", "Income/Balance"::"Income Statement");

                // Apply date filter based on parameters
                SetFilter("Date Filter", '%1..%2', StartDate, EndDate);

                // Initialize variables
                Clear(TotalNetChange);

            end;

            trigger OnAfterGetRecord()
            begin
                // Recalculate fields after filtering
                CalcFields("Net Change", "GL Account Balance", "Balance at Date");
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
    //NetProfit: Decimal;


    trigger OnPreReport()
    begin

        Company.Get();
        Company.CalcFields(Company.Picture);

        if EndDate = 0D then
            EndDate := WorkDate();

        if StartDate = 0D then
            StartDate := CalcDate('<-CY>', EndDate);

        GetSurplusTaxAndNetProfit();

    end;


    local procedure GetAccountNameByLength(AccountNo: Code[20]; LevelLength: Integer): Text
    var
        CoA: Record "G/L Account";
        GroupNo: Code[20];
    begin
        if STRLEN(AccountNo) < LevelLength then
            exit('');

        GroupNo := COPYSTR(AccountNo, 1, LevelLength);

        // Apply filter to only retrieve "Balance Sheet" accounts
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
        //     if AccountType = AccountType::Posting then
        //         exit(4);
        // else if AccountType = AccountType::"End-Total" then
        //     exit(5)
        end;

        // Logical grouping types
        // if AccountType = AccountType::"End-Total" then
        //     exit(5)
        // else if AccountType = AccountType::Total then
        //     exit(6);

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


    local procedure GetOpeningBalance(Account: Record "G/L Account"; OpeningDate: Date): Decimal
    var
        OpeningBalance: Decimal;
    begin
        Account.SetRange("Date Filter", 0D, OpeningDate - 1); // All entries before the opening date
        Account.CalcFields("Net Change");

        OpeningBalance := Account."Net Change"; // Opening balance is sum before OpeningDate

        exit(AbsDecimal(OpeningBalance));
    end;

    local procedure GetClosingBalance(Account: Record "G/L Account"; EndDate: Date): Decimal
    var
        TempAcc: Record "G/L Account";
    begin
        TempAcc := Account;
        TempAcc.SetRange("Date Filter", 0D, EndDate); // Up to closing date
        TempAcc.CalcFields("Net Change");
        exit(AbsDecimal(TempAcc."Net Change"));
    end;


    procedure GetSurplusTaxAndNetProfit()
    var
        GLAccount: Record "G/L Account";
        TotalIncome: Decimal;
        TotalExpenses: Decimal;
    begin
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

    local procedure AbsDecimal(Value: Decimal): Decimal
    begin
        if Value < 0 then
            exit(-Value)
        else
            exit(Value);
    end;



}
