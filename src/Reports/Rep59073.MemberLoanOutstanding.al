report 59073 "Member Loans Outstanding Rep"
{
    RDLCLayout = './Layout/Member Loans Outstanding Report.rdlc';
    DefaultLayout = RDLC;
    Caption = 'Member Loans Outstanding Balance';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = all;

    dataset
    {
        dataitem("Member Register"; Customer)
        {
            DataItemTableView = WHERE("Account Category" = CONST("Regular Account"));
            RequestFilterFields = "No.", "Name", "Date Filter";

            // Per member fields
            column(Member_No; "Member Register"."No.") { }
            column(Member_Name; "Member Register".Name) { }
            column(Member_Phone; "Member Register"."Phone No.") { }
            column(Member_Email; "Member Register"."E-Mail") { }

            column(Development_Loan_2_Balance; DevLoan2Balance) { }
            column(Development_Loan_1_Balance; DevLoan1Balance) { }
            column(Investment_Loan_Balance; InvestmentLoanBalance) { }
            column(School_Fees_Balance; SchoolFeesBalance) { }
            column(Emergency_Loan_Balance; EmergencyLoanBalance) { }
            column(Flexi_Loan_Balance; FlexiLoanBalance) { }
            column(Instant_Loan_Balance; InstantLoanBalance) { }
            column(Sheria_Loan_Balance; SheriaLoanBalance) { }
            column(Dev_Loan_2_14_Balance; DevLoan214Balance) { }
            column(Total_Outstanding; TotalOutstanding) { }

            trigger OnAfterGetRecord()
            begin
                // Calculate balances for this member
                CalculateLoanBalances();

                if (TotalOutstanding = 0) and (not ShowZeroBalances) then
                    CurrReport.Skip();

                // Add to grand totals
                TotalDevLoan2 += DevLoan2Balance;
                TotalDevLoan1 += DevLoan1Balance;
                TotalInvestmentLoan += InvestmentLoanBalance;
                TotalSchoolFees += SchoolFeesBalance;
                TotalEmergencyLoan += EmergencyLoanBalance;
                TotalFlexiLoan += FlexiLoanBalance;
                TotalInstantLoan += InstantLoanBalance;
                TotalSheriaLoan += SheriaLoanBalance;
                TotalDevLoan214 += DevLoan214Balance;
                GrandTotalOutstanding += TotalOutstanding;
            end;
        }

        // ✅ DataItem for one-time totals row

    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(ShowZeroBalances; ShowZeroBalances)
                    {
                        ApplicationArea = All;
                        Caption = 'Show Members with Zero Outstanding Balance';
                    }
                }
            }
        }
    }

    var
        Company: Record "Company Information";
        LoansRegister: Record "Loans Register";

        // Per member balances
        DevLoan2Balance: Decimal;
        DevLoan1Balance: Decimal;
        InvestmentLoanBalance: Decimal;
        SchoolFeesBalance: Decimal;
        EmergencyLoanBalance: Decimal;
        FlexiLoanBalance: Decimal;
        InstantLoanBalance: Decimal;
        SheriaLoanBalance: Decimal;
        DevLoan214Balance: Decimal;
        TotalOutstanding: Decimal;

        // Grand totals
        TotalDevLoan2: Decimal;
        TotalDevLoan1: Decimal;
        TotalInvestmentLoan: Decimal;
        TotalSchoolFees: Decimal;
        TotalEmergencyLoan: Decimal;
        TotalFlexiLoan: Decimal;
        TotalInstantLoan: Decimal;
        TotalSheriaLoan: Decimal;
        TotalDevLoan214: Decimal;
        GrandTotalOutstanding: Decimal;

        ShowZeroBalances: Boolean;

    local procedure CalculateLoanBalances()
    begin
        ClearBalances();

        LoansRegister.Reset();
        LoansRegister.SetRange("Client Code", "Member Register"."No.");
        LoansRegister.SetRange("Loan Status", LoansRegister."Loan Status"::Issued);
        LoansRegister.SetFilter("Outstanding Balance", '>0');

        if LoansRegister.FindSet() then
            repeat
                LoansRegister.CalcFields("Outstanding Balance");
                if LoansRegister."Outstanding Balance" > 0 then begin
                    case Format(LoansRegister."Loan Product Type") of
                        'LT001':
                            DevLoan2Balance += LoansRegister."Outstanding Balance";
                        'LT002':
                            DevLoan1Balance += LoansRegister."Outstanding Balance";
                        'LT003':
                            InvestmentLoanBalance += LoansRegister."Outstanding Balance";
                        'LT004':
                            SchoolFeesBalance += LoansRegister."Outstanding Balance";
                        'LT005':
                            EmergencyLoanBalance += LoansRegister."Outstanding Balance";
                        'LT006':
                            FlexiLoanBalance += LoansRegister."Outstanding Balance";
                        'LT007':
                            InstantLoanBalance += LoansRegister."Outstanding Balance";
                        'LT008':
                            SheriaLoanBalance += LoansRegister."Outstanding Balance";
                        'LT009':
                            DevLoan214Balance += LoansRegister."Outstanding Balance";
                    end;
                end;
            until LoansRegister.Next() = 0;

        TotalOutstanding :=
            DevLoan2Balance + DevLoan1Balance + InvestmentLoanBalance +
            SchoolFeesBalance + EmergencyLoanBalance + FlexiLoanBalance +
            InstantLoanBalance + SheriaLoanBalance + DevLoan214Balance;
    end;

    local procedure ClearBalances()
    begin
        DevLoan2Balance := 0;
        DevLoan1Balance := 0;
        InvestmentLoanBalance := 0;
        SchoolFeesBalance := 0;
        EmergencyLoanBalance := 0;
        FlexiLoanBalance := 0;
        InstantLoanBalance := 0;
        SheriaLoanBalance := 0;
        DevLoan214Balance := 0;
        TotalOutstanding := 0;
    end;

    trigger OnPreReport()
    begin
        Company.Get();
    end;
}
