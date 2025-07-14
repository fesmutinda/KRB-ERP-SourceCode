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

            // RequestFilterFields = "No.", "Account Type", "Date Filter", "Account Category";


            column(SurplusOrLoss; Surplus) { }
            column(CorporateTax; CorporateTax) { }
            column(NetProfitAfterTax; NetProfitAfterTax) { }

            column(TotalBalance; GetTotalBalance(GLAccount)) { }


            column(Level1; GetAccountNameByLength("No.", 1)) { }
            column(Level2; GetAccountNameByLength("No.", 2)) { }
            column(Level3; GetAccountNameByLength("No.", 3)) { }

            column(LevelNo; GetLevelNo("No.", "Account Type")) { }

            column(DisplayName; GetDisplayName("No.", Name, "Account Type", "Account Subcategory Descript.")) { }




            column(Name; Name)
            {
            }

            column(NetChange; "Net Change")
            {
                AutoFormatType = 1; // Standard thousand separator, 2 decimal places

            }

            column(GLAccountBalance; "GL Account Balance")
            {
                AutoFormatType = 1;
            }

            column(Balance_at_Date; "Balance at Date")
            {
                AutoFormatType = 1;
            }



            column(Account_Subcategory_Entry_No_; "Account Subcategory Entry No.") { }

            column(Account_Subcategory_Descript_; "Account Subcategory Descript.") { }
            column(No; "No.")
            {
            }

            column(AccountCategory; "Account Category")
            {
            }

            column(Account_Type; "Account Type") { }

            column(Account_Category; "Account Category") { }
            //column(Account_Subcategory; "Account SubCategory") { }
            column(StartDateText; Format(StartDate)) { }
            // column(EndDateText; Format("Date Filter")) { }

            column(EndDateText; Format(Today, 0, '<Month,2>/<Day,2>/<Year4>')) { }


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


            trigger OnPreDataItem()
            begin
                SetRange("Income/Balance", "Income/Balance"::"Balance Sheet");

                // Apply date filter based on parameters
                SetFilter("Date Filter", '%1..%2', StartDate, EndDate);

                // Initialize variables
                Clear(TotalNetChange);

            end;

            // trigger OnPreDataItem()
            // begin
            //     // 1. Set base filters (Income/Balance = "Balance Sheet")
            //     SetRange("Income/Balance", "Income/Balance"::"Balance Sheet");

            //     // 2. Apply user's date filter from request page
            //     SetRange("Date Filter", StartDate, EndDate);

            //     // 3. Preserve any additional date filtering from the UI
            //     if GetFilter("Date Filter") <> '' then
            //         SetFilter("Date Filter", GetFilter("Date Filter") + ' & %1..%2', StartDate, EndDate)
            //     else
            //         SetFilter("Date Filter", '%1..%2', StartDate, EndDate);

            //     // Initialize variables
            //     Clear(TotalNetChange);
            // end;

            trigger OnAfterGetRecord()
            begin
                // Recalculate fields after filtering
                CalcFields("Net Change", "GL Account Balance", "Balance at Date");

                if not ShowZeroBalances then begin
                    if ("Account Type" <> "Account Type"::"Heading") and ("Account Type" <> "Account Type"::"Begin-Total") and ("Net Change" = 0) and ("Balance at Date" = 0) then
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
                    // field(StartDateReq; StartDate)
                    // {
                    //     ApplicationArea = All;
                    //     Caption = 'Start Date';
                    // }
                    // field(EndDateReq; EndDate)
                    // {
                    //     ApplicationArea = All;
                    //     Caption = 'End Date';
                    // }
                    field(ShowZeroBalances; ShowZeroBalances)
                    {
                        ApplicationArea = Basoc;
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



    // local procedure GetTotalBalance(Account: Record "G/L Account"): Decimal
    // var
    //     GLAcc: Record "G/L Account";
    //     TotalBalance: Decimal;
    // begin
    //     if Account."Account Type" in [Account."Account Type"::Total, Account."Account Type"::"End-Total"] then begin
    //         GLAcc.Reset();
    //         GLAcc.SetFilter("No.", Account.Totaling); // assumes Totaling is a filter like '1000..1999'
    //         if GLAcc.FindSet() then
    //             repeat
    //                 if GLAcc."Account Type" = GLAcc."Account Type"::Posting then
    //                     TotalBalance += GLAcc."Balance";
    //             until GLAcc.Next() = 0;
    //     end;

    //     exit(TotalBalance);
    // end;

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
