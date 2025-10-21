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


            dataitem("Loans Register"; "Loans Register")
            {
                DataItemLink = "Client Code" = FIELD("No.");
                DataItemTableView = WHERE("Loan Status" = CONST(Issued));

                // Member columns in child dataitem
                column(Member_No; "Member Register"."No.") { }
                column(Member_Name; "Member Register".Name) { }
                column(Member_Phone; "Member Register"."Phone No.") { }
                column(Member_Email; "Member Register"."E-Mail") { }
                column(Current_Shares; CurrentSharesValue) { }
                column(Shares_Retained; SharesRetainedValue) { }
                column(Member_Count; LCount) { }

                // Loan columns
                column(Loan_No; "Loans Register"."Loan  No.") { }
                column(Loan_Product_Type; "Loans Register"."Loan Product Type") { }

                // Separate columns for each loan type
                column(Development_Loan_2_Balance; DevLoan2Balance) { }
                column(Development_Loan_1_Balance; DevLoan1Balance) { }
                column(Investment_Loan_Balance; InvestmentLoanBalance) { }
                column(School_Fees_Balance; SchoolFeesBalance) { }
                column(Emergency_Loan_Balance; EmergencyLoanBalance) { }
                column(Flexi_Loan_Balance; FlexiLoanBalance) { }
                column(Instant_Loan_Balance; InstantLoanBalance) { }
                column(Sheria_Loan_Balance; SheriaLoanBalance) { }
                column(Dev_Loan_2_14_Balance; DevLoan214Balance) { }
                column(Loan_Outstanding_Balance; LoanOutstandingBalance) { }

                trigger OnPreDataItem()
                begin
                    // Reset member tracking for this member
                    MemberCounted := false;
                    MemberHasVisibleLoans := false;

                    // Calculate shares once per member
                    "Member Register".CalcFields("Current Shares", "Shares Retained");
                    CurrentSharesValue := "Member Register"."Current Shares";
                    SharesRetainedValue := "Member Register"."Shares Retained";
                end;

                trigger OnAfterGetRecord()
                var
                    LoanTypeCode: Text;
                begin
                    ClearLoanColumns();

                    // Calculate outstanding balance
                    "Loans Register".CalcFields("Outstanding Balance");
                    LoanOutstandingBalance := "Loans Register"."Outstanding Balance";

                    // Skip zero-balance loans when ShowZeroBalances = false
                    if (LoanOutstandingBalance = 0) and (not ShowZeroBalances) then begin
                        CurrReport.Skip();
                        exit;
                    end;

                    // If we reach here, this loan will be visible in the report
                    MemberHasVisibleLoans := true;

                    // Count member only once when first visible loan is processed
                    if not MemberCounted then begin
                        LCount += 1;
                        MemberCounted := true;
                    end;

                    // Get loan type and assign to correct column
                    LoanTypeCode := Format("Loans Register"."Loan Product Type");

                    case LoanTypeCode of
                        'LT001':
                            DevLoan2Balance := LoanOutstandingBalance;
                        'LT002':
                            DevLoan1Balance := LoanOutstandingBalance;
                        'LT003':
                            InvestmentLoanBalance := LoanOutstandingBalance;
                        'LT004':
                            SchoolFeesBalance := LoanOutstandingBalance;
                        'LT005':
                            EmergencyLoanBalance := LoanOutstandingBalance;
                        'LT006':
                            FlexiLoanBalance := LoanOutstandingBalance;
                        'LT007':
                            InstantLoanBalance := LoanOutstandingBalance;
                        'LT008':
                            SheriaLoanBalance := LoanOutstandingBalance;
                        'LT009':
                            DevLoan214Balance := LoanOutstandingBalance;
                    end;
                end;

                trigger OnPostDataItem()
                begin
                    // After all loans processed, if no visible loans found, skip the entire member
                    if not MemberHasVisibleLoans then begin
                        // Decrement count if we counted this member but found no visible loans
                        if MemberCounted then
                            LCount -= 1;
                    end;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                // Check if this member should be skipped entirely
                if ShouldSkipMember() then
                    CurrReport.Skip();
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
                    Caption = 'Options';
                    field(ShowZeroBalances; ShowZeroBalances)
                    {
                        ApplicationArea = All;
                        Caption = 'Show Zero Balances';
                        ToolTip = 'When enabled, includes members and loans with zero balances. When disabled, only shows those with outstanding balances >0 and <0 only.';
                    }
                }
            }
        }
    }

    var
        Company: Record "Company Information";

        // Loan balances
        DevLoan2Balance: Decimal;
        DevLoan1Balance: Decimal;
        InvestmentLoanBalance: Decimal;
        SchoolFeesBalance: Decimal;
        EmergencyLoanBalance: Decimal;
        FlexiLoanBalance: Decimal;
        InstantLoanBalance: Decimal;
        SheriaLoanBalance: Decimal;
        DevLoan214Balance: Decimal;
        LoanOutstandingBalance: Decimal;

        // Member shares
        CurrentSharesValue: Decimal;
        SharesRetainedValue: Decimal;

        // Count and options
        LCount: Integer;
        MemberCounted: Boolean;
        MemberHasVisibleLoans: Boolean;
        ShowZeroBalances: Boolean;

    local procedure ClearLoanColumns()
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
        LoanOutstandingBalance := 0;
    end;

    local procedure ShouldSkipMember(): Boolean
    var
        TempLoansRegister: Record "Loans Register";
        HasAnyLoan: Boolean;
        HasNonZeroLoan: Boolean;
    begin
        HasAnyLoan := false;
        HasNonZeroLoan := false;

        TempLoansRegister.Reset();
        TempLoansRegister.SetRange("Client Code", "Member Register"."No.");
        TempLoansRegister.SetRange("Loan Status", TempLoansRegister."Loan Status"::Issued);

        if TempLoansRegister.FindSet() then begin
            HasAnyLoan := true;
            repeat
                TempLoansRegister.CalcFields("Outstanding Balance");
                if TempLoansRegister."Outstanding Balance" <> 0 then
                    HasNonZeroLoan := true;
            until TempLoansRegister.Next() = 0;
        end;

        // Skip member if:
        // 1. They have no loans at all, OR
        // 2. ShowZeroBalances is false AND they have no non-zero loans
        if not HasAnyLoan then
            exit(true);

        if (not ShowZeroBalances) and (not HasNonZeroLoan) then
            exit(true);

        exit(false);
    end;

    trigger OnPreReport()
    begin
        Company.Get();
        LCount := 0;
    end;
}