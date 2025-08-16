namespace KRBERPSourceCode.KRBERPSourceCode;

using Microsoft.Foundation.Company;
using Microsoft.Finance.GeneralLedger.Account;

report 59070 KrbscBudget2
{
    ApplicationArea = All;
    Caption = 'Krbsc Budget Simple';
    UsageCategory = ReportsAndAnalysis;
    RDLCLayout = './Layout/KrbscBudget2.rdlc';

    dataset
    {
        dataitem(KrbscCustomBudget; KrbscCustomBudget)
        {
            DataItemTableView = where("Budget Year" = filter(2025));
            column(BudgetName; "Budget Name")
            {
            }
            column(BudgetNo; "Budget No.")
            {
            }
            column(BudgetType; "Budget Type")
            {
            }
            column(BudgetYear; "Budget Year")
            {
            }
            column(CreatedBy; "Created By")
            {
            }
            column(CreatedDate; "Created Date")
            {
            }
            column(Description; Description)
            {
            }

            column(DisplayBalance; DisplayBalance) { }

            column(Company_Name; Company.Name) { }
            column(Company_Address; Company.Address) { }
            column(Company_Address_2; Company."Address 2") { }
            column(Company_Phone_No; Company."Phone No.") { }
            column(Company_Fax_No; Company."Fax No.") { }
            column(Company_Picture; Company.Picture) { }
            column(Company_Email; Company."E-Mail") { }


            column(Variance; Variance) { }
            column(PercentageDifference; DifferenceInPercent) { }

            dataitem(KrbscBudgetLines; KrbscBudgetLines)
            {
                DataItemLink = "Budget No." = field("Budget No.");

                column(Account_Name; "Account Name") { }

                column(Actuals_Previous_Year; "Actuals Previous Year") { }

                column(Line_No_; "Line No.") { }

                column(Line_Type; "Line Type") { }

                column(Revised_Budget_Current; "Revised Budget Current") { }

                column(Approved_Budget_Current; "Approved Budget Current") { }

                column(Proposed_Budget_Next; "Proposed Budget Next") { }

                column(G_L_Account_Name; "G/L Account Name") { }

                column(G_L_Account_No_; "G/L Account No.") { }


                dataitem("G/L Account"; "G/L Account")
                {
                    DataItemLink = "No." = field("G/L Account No.");

                    column(Balance; Balance) { }

                    column(Net_Change; "Net Change") { }


                    trigger OnAfterGetRecord()
                    begin
                        // Calculate the flowfields for the current G/L Account
                        CalcFields(Balance, "Net Change");
                    end;

                }


                trigger OnAfterGetRecord()
                var
                    ActualAmount: Decimal;
                    GLAccount: Record "G/L Account";
                    TotalBalance: Decimal;
                begin

                    DisplayBalance := 0;
                    // Get the G/L Account record and calculate its fields
                    if GLAccount.Get("G/L Account No.") then begin
                        GLAccount.CalcFields(Balance, "Net Change");
                        DisplayBalance := GLAccount.Balance;
                        ActualAmount := GLAccount."Net Change";
                    end;

                    // Calculate variance and percentage based on account type
                    if IsDebitAccount("G/L Account No.") then begin
                        // For debit accounts (Assets/Expenses), use Net Change as is
                        Variance := KrbscBudgetLines."Revised Budget Current" - ActualAmount;

                        if "G/L Account No." = '4301' then begin
                            Message('Account 4301 Debug Info:\Budget Line G/L Account No: %1\IsDebit Result: %2\Original Balance from G/L Account: %3\DisplayBalance after processing: %4',
                                    "G/L Account No.",
                                    IsDebitAccount("G/L Account No."),
                                    "G/L Account".Balance,
                                    DisplayBalance);
                        end;

                        // Calculate usage percentage for debit accounts
                        if KrbscBudgetLines."Revised Budget Current" <> 0 then
                            DifferenceInPercent := (DisplayBalance / KrbscBudgetLines."Revised Budget Current") * 100
                        else
                            DifferenceInPercent := 0;

                    end else begin
                        // For credit accounts (Liabilities/Equity/Revenue), use absolute values
                        ActualAmount := Abs(ActualAmount);
                        DisplayBalance := Abs(DisplayBalance);

                        // if "G/L Account No." = '4301' then begin
                        //     Message('Account 4301 Debug Info:\Budget Line G/L Account No: %1\IsDebit Result: %2\Original Balance from G/L Account: %3\DisplayBalance after processing: %4',
                        //             "G/L Account No.",
                        //             IsDebitAccount("G/L Account No."),
                        //             "G/L Account".Balance,
                        //             DisplayBalance);
                        // end;

                        Variance := KrbscBudgetLines."Revised Budget Current" - ActualAmount;

                        // Calculate usage percentage for credit accounts
                        if KrbscBudgetLines."Revised Budget Current" <> 0 then
                            DifferenceInPercent := (DisplayBalance / KrbscBudgetLines."Revised Budget Current") * 100
                        else
                            DifferenceInPercent := 0;
                    end;
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

        Company: Record "Company Information";

        Variance: Decimal;

        DifferenceInPercent: Decimal;

        DisplayBalance: Decimal;


    trigger OnPreReport()
    begin

        Company.get()
    end;


    local procedure IsDebitAccount(AccountNo: Code[20]): Boolean
    var
        GLAccount: Record "G/L Account";
    begin
        if GLAccount.Get(AccountNo) then begin
            // Customize this logic based on your chart of accounts structure
            // Example: Assets and Expenses are typically debit accounts
            case true of
                (GLAccount."No." >= '1000') and (GLAccount."No." < '2000'): // Assets
                    exit(true);
                (GLAccount."No." >= '5000') and (GLAccount."No." < '6000'): // Expenses  
                    exit(true);
                else
                    exit(false); // Liabilities, Equity, Revenue are credit accounts
            end;
        end;
        exit(false);
    end;
}
