Report 59052 "Member Statement Junior"
{
    DefaultLayout = RDLC;
    Caption = 'Member Junior Savings Statement';
    RDLCLayout = './Layout/Member Statement Junior.rdlc';

    dataset
    {
        dataitem("Members Register"; customer)
        {
            RequestFilterFields = "No.", "Date Filter";

            column(ReportForNavId_1102755000; 1102755000)
            {
            }

            column(Phone_No_; "Phone No.")
            {
            }

            column(Registration_Date; "Registration Date")
            {
            }
            column(USERID; UserId)
            {
            }
            column(PayrollStaffNo_Members; "Members Register"."Payroll/Staff No")
            {
            }
            column(No_Members; "Members Register"."No.")
            {
            }
            column(Name_Members; "Members Register".Name)
            {
            }
            column(EmployerCode_Members; "Members Register"."Employer Code")
            {
            }
            column(EmployerName; EmployerName)
            {
            }
            column(PageNo_Members; CurrReport.PageNo)
            {
            }
            column(Shares_Retained; "Members Register"."Shares Retained")
            {
            }
            column(IDNo_Members; "Members Register"."ID No.")
            {
            }
            column(GlobalDimension2Code_Members; "Members Register"."Global Dimension 2 Code")
            {
            }
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
            // Add guardian indicator columns
            column(IsGuardian; IsGuardian)
            {
            }
            column(HasJuniorAccounts; HasJuniorAccounts)
            {
            }
            column(GuardianInfo; GuardianInfo)
            {
            }

            // Modified JuniorSavings dataitem to include guardian relationships
            dataitem(JuniorSavings; "Cust. Ledger Entry")
            {
                DataItemLink = "Customer No." = field("No."), "Posting Date" = field("Date Filter");
                DataItemTableView = sorting("Posting Date") where("Transaction Type" = filter("Junior Savings"), Reversed = const(false));
                column(ReportForNavId_1000000071; 1000000071)
                {
                }
                column(PostingDate_Junior; JuniorSavings."Posting Date")
                {
                }
                column(DocumentNo_Junior; JuniorSavings."Document No.")
                {
                }
                column(Description_Junior; JuniorSavings.Description)
                {
                }
                column(Amount_Junior; JuniorSavings."Amount Posted")
                {
                }
                column(UserID_Junior; JuniorSavings."User ID")
                {
                }
                column(DebitAmount_Junior; debitamount)
                {
                }
                column(CreditAmount_Junior; creditamount)
                {
                }
                column(TransactionType_Junior; JuniorSavings."Transaction Type")
                {
                }
                column(OpenBalanceJunior; OpenBalanceJunior)
                {
                }
                column(ClosingBalanceJunior; ClosingBalanceJunior)
                {
                }
                column(JuniorBF; JuniorBF)
                {
                }
                // Add junior member details
                column(JuniorMemberNo; JuniorMemberNo)
                {
                }
                column(JuniorMemberName; JuniorMemberName)
                {
                }
                column(IsOwnAccount; IsOwnAccount)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    CreditAmount := 0;
                    DebitAmount := 0;
                    if JuniorSavings."Amount Posted" < 0 then begin
                        CreditAmount := JuniorSavings."Amount Posted" * -1;
                    end else
                        if JuniorSavings."Amount Posted" > 0 then begin
                            DebitAmount := JuniorSavings."Amount Posted";
                        end;
                    ClosingBalanceJunior := ClosingBalanceJunior + (JuniorSavings."Amount Posted" * -1);

                    // Get junior member details
                    JuniorMemberNo := JuniorSavings."Customer No.";
                    IsOwnAccount := (JuniorMemberNo = "Members Register"."No.");

                    if JuniorMember.Get(JuniorMemberNo) then
                        JuniorMemberName := JuniorMember.Name
                    else
                        JuniorMemberName := '';
                end;

                trigger OnPreDataItem()
                begin
                    ClosingBalanceJunior := JuniorBF;
                    OpenBalanceJunior := JuniorBF;

                    // Apply filters for junior savings
                    JuniorSavings.Reset();
                    JuniorSavings.SetCurrentKey("Posting Date");
                    JuniorSavings.SetRange("Transaction Type", JuniorSavings."Transaction Type"::"Junior Savings");
                    JuniorSavings.SetRange(Reversed, false);

                    // Apply date filter if exists
                    if "Members Register".GetFilter("Date Filter") <> '' then
                        JuniorSavings.SetFilter("Posting Date", "Members Register".GetFilter("Date Filter"));

                    // Filter for appropriate accounts based on guardian status
                    JuniorAccountFilter := GetJuniorAccountFilter("Members Register"."No.");
                    if JuniorAccountFilter = '' then
                        CurrReport.Break();

                    JuniorSavings.SetFilter("Customer No.", JuniorAccountFilter);
                end;
            }

            // Enhanced Guardian's Junior Accounts dataitem
            dataitem(GuardianJuniorSavings; "Cust. Ledger Entry")
            {
                DataItemLink = "Posting Date" = field("Date Filter");
                DataItemTableView = sorting("Posting Date") where("Transaction Type" = filter("Junior Savings"), Reversed = const(false));
                column(ReportForNavId_1000000072; 1000000072)
                {
                }
                column(PostingDate_GuardianJunior; GuardianJuniorSavings."Posting Date")
                {
                }
                column(DocumentNo_GuardianJunior; GuardianJuniorSavings."Document No.")
                {
                }
                column(Description_GuardianJunior; GuardianJuniorSavings.Description)
                {
                }
                column(Amount_GuardianJunior; GuardianJuniorSavings."Amount Posted")
                {
                }
                column(UserID_GuardianJunior; GuardianJuniorSavings."User ID")
                {
                }
                column(DebitAmount_GuardianJunior; GuardianDebitAmount)
                {
                }
                column(CreditAmount_GuardianJunior; GuardianCreditAmount)
                {
                }
                column(JuniorAccountNo_Guardian; GuardianJuniorSavings."Customer No.")
                {
                }
                column(JuniorAccountName_Guardian; GuardianJuniorAccountName)
                {
                }
                column(GuardianJuniorBF; GuardianJuniorBF)
                {
                }
                column(GuardianJuniorClosing; GuardianJuniorClosing)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    GuardianCreditAmount := 0;
                    GuardianDebitAmount := 0;
                    if GuardianJuniorSavings."Amount Posted" < 0 then begin
                        GuardianCreditAmount := GuardianJuniorSavings."Amount Posted" * -1;
                    end else
                        if GuardianJuniorSavings."Amount Posted" > 0 then begin
                            GuardianDebitAmount := GuardianJuniorSavings."Amount Posted";
                        end;

                    // Update running balance
                    GuardianJuniorClosing := GuardianJuniorClosing + (GuardianJuniorSavings."Amount Posted" * -1);

                    // Get junior account holder name
                    if JuniorMember.Get(GuardianJuniorSavings."Customer No.") then
                        GuardianJuniorAccountName := JuniorMember.Name
                    else
                        GuardianJuniorAccountName := '';
                end;

                trigger OnPreDataItem()
                begin
                    // Only show if member is a guardian
                    if not IsGuardian then
                        CurrReport.Break();

                    // Initialize balances
                    GuardianJuniorBF := 0;
                    GuardianJuniorClosing := 0;

                    // Filter for junior accounts where current member is the guardian
                    GuardianJuniorSavings.Reset();
                    GuardianJuniorSavings.SetCurrentKey("Posting Date");
                    GuardianJuniorSavings.SetRange("Transaction Type", GuardianJuniorSavings."Transaction Type"::"Junior Savings");
                    GuardianJuniorSavings.SetRange(Reversed, false);

                    // Apply date filter
                    if "Members Register".GetFilter("Date Filter") <> '' then
                        GuardianJuniorSavings.SetFilter("Posting Date", "Members Register".GetFilter("Date Filter"));

                    // Get junior accounts for this guardian
                    GuardianJuniorFilter := GetJuniorAccountsForGuardian("Members Register"."No.");
                    if GuardianJuniorFilter = '' then
                        CurrReport.Break();

                    GuardianJuniorSavings.SetFilter("Customer No.", GuardianJuniorFilter);

                    // Calculate brought forward balance
                    GuardianJuniorBF := CalculateGuardianJuniorBF("Members Register"."No.", DateFilterBF);
                    GuardianJuniorClosing := GuardianJuniorBF;
                end;
            }

            // Add summary dataitem for guardian's junior accounts
            dataitem(JuniorAccountsSummary; "Integer")
            {
                DataItemTableView = sorting(Number) where(Number = const(1));
                column(ReportForNavId_1000000073; 1000000073)
                {
                }
                column(TotalJuniorAccounts; TotalJuniorAccounts)
                {
                }
                column(TotalJuniorBalance; TotalJuniorBalance)
                {
                }
                column(JuniorAccountsList; JuniorAccountsList)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    if IsGuardian then begin
                        CalculateJuniorAccountsSummary("Members Register"."No.");
                    end;
                end;

                trigger OnPreDataItem()
                begin
                    if not IsGuardian then
                        CurrReport.Break();
                end;
            }

            dataitem(Loans; "Loans Register")
            {
                DataItemLink = "Client Code" = field("No."), "Date filter" = field("Date Filter"), "Loan Product Type" = field("Loan Product Filter");
                DataItemTableView = sorting("Loan  No.") where(Posted = const(true), Reversed = const(false));
                column(ReportForNavId_1102755024; 1102755024)
                {
                }
                column(PrincipleBF; PrincipleBF)
                {
                }
                column(LoanNumber; Loans."Loan  No.")
                {
                }
                column(ProductType; Loans."Loan Product Type Name")
                {
                }
                column(RequestedAmount; Loans."Requested Amount")
                {
                }
                column(Interest; Loans.Interest)
                {
                }
                column(Installments; Loans.Installments)
                {
                }
                column(LoanPrincipleRepayment; Loans."Loan Principle Repayment")
                {
                }
                column(ApprovedAmount_Loans; Loans."Approved Amount")
                {
                }
                column(LoanProductTypeName_Loans; Loans."Loan Product Type Name")
                {
                }
                column(Repayment_Loans; Loans.Repayment)
                {
                }
                column(ModeofDisbursement_Loans; Loans."Mode of Disbursement")
                {
                }
                column(IsGuardianLoan; IsGuardianLoan)
                {
                }
                column(JuniorAccountNo; JuniorAccountNo)
                {
                }
                column(JuniorAccountName; JuniorAccountName)
                {
                }
                column(LoanDate; Loans."Date filter")
                {
                }
                column(OutstandingBalance_Loans; Loans."Outstanding Balance")
                {
                }
                column(OustandingInterest_Loans; Loans."Oustanding Interest")
                {
                }

                dataitem(loan; "Cust. Ledger Entry")
                {
                    DataItemLink = "Customer No." = field("Client Code"), "Loan No" = field("Loan  No."), "Posting Date" = field("Date filter");
                    DataItemTableView = sorting("Posting Date") where("Transaction Type" = filter(Loan | "Loan Repayment" | "Interest Due" | "Interest Paid" | "Loan Transfer Charges"));
                    column(ReportForNavId_1102755031; 1102755031)
                    {
                    }
                    column(PostingDate_loan; loan."Posting Date")
                    {
                    }
                    column(DocumentNo_loan; loan."Document No.")
                    {
                    }
                    column(Description_loan; loan.Description)
                    {
                    }
                    column(DebitAmount_Loan; loan."Debit Amount")
                    {
                    }
                    column(CreditAmount_Loan; loan."Credit Amount")
                    {
                    }
                    column(Amount_Loan; loan.Amount)
                    {
                    }
                    column(openBalance_loan; OpenBalance)
                    {
                    }
                    column(CLosingBalance_loan; CLosingBalance)
                    {
                    }
                    column(TransactionType_loan; loan."Transaction Type")
                    {
                    }
                    column(LoanNo; loan."Loan No")
                    {
                    }
                    column(PrincipleBF_loans; PrincipleBF)
                    {
                    }
                    column(Loan_Description; loan.Description)
                    {
                    }
                    column(User7; loan."User ID")
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        CLosingBalance := CLosingBalance + (loan."Amount Posted");
                        if loan."Amount Posted" < 0 then begin
                            loan."Credit Amount" := (loan."Amount Posted" * -1);
                        end else
                            if loan."Amount Posted" > 0 then begin
                                loan."Debit Amount" := (loan."Amount Posted");
                            end;
                        if loan."Transaction Type" = loan."transaction type"::"Interest Paid" then begin
                            InterestPaid := 0;
                            if loan."Amount Posted" < 0 then begin
                                InterestPaid := loan."Amount Posted" * -1;
                            end;
                            SumInterestPaid := InterestPaid + SumInterestPaid;
                        end;
                        if loan."Transaction Type" = loan."transaction type"::"Loan Repayment" then begin
                            if loan."Amount Posted" < 0 then begin
                                loan."Credit Amount" := loan."Amount Posted" * -1;
                            end;
                        end;
                    end;

                    trigger OnPreDataItem()
                    begin
                        CLosingBalance := PrincipleBF;
                        OpeningBal := PrincipleBF;
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    if LoanSetup.Get(Loans."Loan Product Type") then
                        LoanName := LoanSetup."Product Description";
                    if DateFilterBF <> '' then begin
                        LoansR.Reset;
                        LoansR.SetRange(LoansR."Loan  No.", "Loan  No.");
                        LoansR.SetFilter(LoansR."Date filter", DateFilterBF);
                        if LoansR.Find('-') then begin
                            LoansR.CalcFields(LoansR."Outstanding Balance");
                            PrincipleBF := LoansR."Outstanding Balance";
                        end;
                    end;

                    // Check if this is a loan for a junior account where member is guardian
                    IsGuardianLoan := false;
                    JuniorAccountNo := '';
                    JuniorAccountName := '';

                    if IsGuardian then begin
                        TempMember.Reset();
                        TempMember.SetRange("Guardian No.", "Members Register"."No.");
                        if TempMember.FindSet() then
                            repeat
                                if Loans."Client Code" = TempMember."No." then begin
                                    IsGuardianLoan := true;
                                    JuniorAccountNo := TempMember."No.";
                                    JuniorAccountName := TempMember.Name;
                                    break;
                                end;
                            until TempMember.Next() = 0;
                    end;
                end;

                trigger OnPreDataItem()
                begin
                    // Apply date filter
                    Loans.SetFilter(Loans."Date filter", "Members Register".GetFilter("Members Register"."Date Filter"));

                    // If member is a guardian, include loans from junior accounts
                    if IsGuardian then begin
                        GuardianLoanFilter := GetGuardianLoanFilter("Members Register"."No.");
                        if GuardianLoanFilter <> '' then
                            Loans.SetFilter("Client Code", GuardianLoanFilter);
                    end;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                SaccoEmp.Reset;
                SaccoEmp.SetRange(SaccoEmp.Code, "Members Register"."Employer Code");
                if SaccoEmp.Find('-') then
                    EmployerName := SaccoEmp.Description;

                // Initialize variables
                SharesBF := 0;
                InsuranceBF := 0;
                ShareCapBF := 0;
                RiskBF := 0;
                HseBF := 0;
                Dep1BF := 0;
                Dep2BF := 0;
                JuniorBF := 0;

                // Enhanced guardian check
                IsGuardian := CheckIfGuardian("No.");
                HasJuniorAccounts := (GetJuniorAccountsForGuardian("No.") <> '');

                // Set guardian info with more details
                if IsGuardian then begin
                    GuardianInfo := 'This member is a guardian for junior accounts';
                    // Get list of junior accounts
                    JuniorAccountsList := GetJuniorAccountsList("No.");
                end else
                    GuardianInfo := '';

                // Calculate balances
                if DateFilterBF <> '' then begin
                    Cust.Reset;
                    Cust.SetRange(Cust."No.", "No.");
                    Cust.SetFilter(Cust."Date Filter", DateFilterBF);
                    if Cust.Find('-') then begin
                        Cust.CalcFields(Cust."Current Shares");
                        SharesBF := (Cust."Current Shares" * -1);
                        RiskBF := Cust."Insurance Fund";
                        DividendBF := Cust."Dividend Amount";
                    end;

                    // Calculate Junior Savings BF with enhanced guardian handling
                    if IsGuardian then
                        JuniorBF := CalculateGuardianJuniorBF("No.", DateFilterBF)
                    else
                        JuniorBF := CalculateOwnJuniorSavingsBF("No.", DateFilterBF);
                end;
            end;

            trigger OnPreDataItem()
            begin
                if "Members Register".GetFilter("Members Register"."Date Filter") <> '' then
                    DateFilterBF := '..' + Format(CalcDate('-1D', "Members Register".GetRangeMin("Members Register"."Date Filter")));
                if (StartDate <> 0D) and (EndDate <> 0D) then
                    "Members Register".SetFilter("Date Filter", Format(StartDate) + '..' + Format(EndDate));
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(content)
            {
                group(DateRange)
                {
                    Caption = 'Date Range';
                    field(StartDate; StartDate)
                    {
                        ApplicationArea = All;
                        Caption = 'Start Date';
                        ToolTip = 'Select the start date for the report.';
                    }
                    field(EndDate; EndDate)
                    {
                        ApplicationArea = All;
                        Caption = 'End Date';
                        ToolTip = 'Select the end date for the report.';
                    }
                }
            }
        }
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        Company.Get();
        Company.CalcFields(Company.Picture);
    end;

    // Enhanced functions to handle guardian-junior relationships
    local procedure GetJuniorAccountFilter(MemberNo: Code[20]): Text
    var
        JuniorAccounts: Text;
        TempMember: Record Customer;
    begin
        // Always include the member's own account for junior savings
        JuniorAccounts := MemberNo;

        // If member is a guardian, include junior accounts
        if CheckIfGuardian(MemberNo) then begin
            TempMember.Reset();
            TempMember.SetRange("Guardian No.", MemberNo);
            if TempMember.FindSet() then
                repeat
                    if JuniorAccounts <> '' then
                        JuniorAccounts := JuniorAccounts + '|' + TempMember."No."
                    else
                        JuniorAccounts := TempMember."No.";
                until TempMember.Next() = 0;
        end;

        exit(JuniorAccounts);
    end;

    local procedure GetJuniorAccountsList(GuardianNo: Code[20]): Text
    var
        TempMember: Record Customer;
        AccountList: Text;
    begin
        AccountList := '';
        TempMember.Reset();
        TempMember.SetRange("Guardian No.", GuardianNo);
        if TempMember.FindSet() then
            repeat
                if AccountList <> '' then
                    AccountList := AccountList + ', ';
                AccountList := AccountList + TempMember."No." + ' (' + TempMember.Name + ')';
            until TempMember.Next() = 0;
        exit(AccountList);
    end;

    local procedure CheckIfGuardian(MemberNo: Code[20]): Boolean
    var
        TempMember: Record Customer;
    begin
        TempMember.Reset();
        TempMember.SetRange("Guardian No.", MemberNo);
        exit(TempMember.FindFirst());
    end;

    local procedure CalculateGuardianJuniorBF(GuardianNo: Code[20]; DateFilter: Text): Decimal
    var
        CustLedgerEntry: Record "Cust. Ledger Entry";
        JuniorAccountFilter: Text;
        TotalBF: Decimal;
    begin
        TotalBF := 0;

        // Include guardian's own junior savings
        TotalBF := CalculateOwnJuniorSavingsBF(GuardianNo, DateFilter);

        // Add junior accounts managed by guardian
        JuniorAccountFilter := GetJuniorAccountsForGuardian(GuardianNo);
        if JuniorAccountFilter <> '' then begin
            CustLedgerEntry.Reset();
            CustLedgerEntry.SetFilter("Customer No.", JuniorAccountFilter);
            CustLedgerEntry.SetRange("Transaction Type", CustLedgerEntry."Transaction Type"::"Junior Savings");
            CustLedgerEntry.SetRange(Reversed, false);
            CustLedgerEntry.SetFilter("Posting Date", DateFilter);

            if CustLedgerEntry.FindSet() then
                repeat
                    TotalBF := TotalBF + (CustLedgerEntry."Amount Posted" * -1);
                until CustLedgerEntry.Next() = 0;
        end;

        exit(TotalBF);
    end;

    local procedure CalculateOwnJuniorSavingsBF(MemberNo: Code[20]; DateFilter: Text): Decimal
    var
        CustLedgerEntry: Record "Cust. Ledger Entry";
        TotalBF: Decimal;
    begin
        TotalBF := 0;
        CustLedgerEntry.Reset();
        CustLedgerEntry.SetRange("Customer No.", MemberNo);
        CustLedgerEntry.SetRange("Transaction Type", CustLedgerEntry."Transaction Type"::"Junior Savings");
        CustLedgerEntry.SetRange(Reversed, false);
        CustLedgerEntry.SetFilter("Posting Date", DateFilter);

        if CustLedgerEntry.FindSet() then
            repeat
                TotalBF := TotalBF + (CustLedgerEntry."Amount Posted" * -1);
            until CustLedgerEntry.Next() = 0;

        exit(TotalBF);
    end;

    // Enhanced loan handling for guardians
    local procedure GetGuardianLoanFilter(MemberNo: Code[20]): Text
    var
        LoanFilter: Text;
        TempMember: Record Customer;
    begin
        LoanFilter := MemberNo; // Include guardian's own loans

        // Add loans from junior accounts where this member is guardian
        if CheckIfGuardian(MemberNo) then begin
            TempMember.Reset();
            TempMember.SetRange("Guardian No.", MemberNo);
            if TempMember.FindSet() then
                repeat
                    if LoanFilter <> '' then
                        LoanFilter := LoanFilter + '|' + TempMember."No."
                    else
                        LoanFilter := TempMember."No.";
                until TempMember.Next() = 0;
        end;

        exit(LoanFilter);
    end;

    local procedure GetJuniorAccountsForGuardian(GuardianNo: Code[20]): Text
    var
        JuniorAccounts: Text;
        TempMember: Record Customer;
    begin
        // Find junior accounts where this member is the guardian
        TempMember.Reset();
        TempMember.SetRange("Guardian No.", GuardianNo);
        if TempMember.FindSet() then
            repeat
                if JuniorAccounts <> '' then
                    JuniorAccounts := JuniorAccounts + '|' + TempMember."No."
                else
                    JuniorAccounts := TempMember."No.";
            until TempMember.Next() = 0;

        exit(JuniorAccounts);
    end;

    local procedure CalculateJuniorAccountsSummary(GuardianNo: Code[20])
    var
        TempMember: Record Customer;
        CustLedgerEntry: Record "Cust. Ledger Entry";
        CurrentBalance: Decimal;
    begin
        TotalJuniorAccounts := 0;
        TotalJuniorBalance := 0;
        JuniorAccountsList := '';

        TempMember.Reset();
        TempMember.SetRange("Guardian No.", GuardianNo);
        if TempMember.FindSet() then
            repeat
                TotalJuniorAccounts += 1;

                // Calculate current balance for this junior account
                CurrentBalance := 0;
                CustLedgerEntry.Reset();
                CustLedgerEntry.SetRange("Customer No.", TempMember."No.");
                CustLedgerEntry.SetRange("Transaction Type", CustLedgerEntry."Transaction Type"::"Junior Savings");
                CustLedgerEntry.SetRange(Reversed, false);

                if CustLedgerEntry.FindSet() then
                    repeat
                        CurrentBalance := CurrentBalance + (CustLedgerEntry."Amount Posted" * -1);
                    until CustLedgerEntry.Next() = 0;

                TotalJuniorBalance += CurrentBalance;

                // Build accounts list
                if JuniorAccountsList <> '' then
                    JuniorAccountsList := JuniorAccountsList + ', ';
                JuniorAccountsList := JuniorAccountsList + TempMember."No." + ' (' + TempMember.Name + ')';

            until TempMember.Next() = 0;
    end;

    var
        OpenBalance: Decimal;
        OpenBalanceJunior: Decimal;
        JuniorBF: Decimal;
        ClosingBalanceJunior: Decimal;
        CLosingBalance: Decimal;
        OpenBalanceXmas: Decimal;
        CLosingBalanceXmas: Decimal;
        Cust: Record Customer;
        OpeningBal: Decimal;
        ClosingBal: Decimal;
        FirstRec: Boolean;
        PrevBal: Integer;
        BalBF: Decimal;
        CreditAmount: Decimal;
        DebitAmount: Decimal;
        LoansR: Record "Loans Register";
        DateFilterBF: Text[150];
        SharesBF: Decimal;
        InsuranceBF: Decimal;
        LoanBF: Decimal;
        PrincipleBF: Decimal;
        InterestBF: Decimal;
        ShowZeroBal: Boolean;
        ClosingBalSHCAP: Decimal;
        ShareCapBF: Decimal;
        RiskBF: Decimal;
        DividendBF: Decimal;
        JuniorSavingsBF: Decimal;
        Company: Record "Company Information";
        OpenBalanceHse: Decimal;
        CLosingBalanceHse: Decimal;
        OpenBalanceDep1: Decimal;
        CLosingBalanceDep1: Decimal;
        OpenBalanceDep2: Decimal;
        CLosingBalanceDep2: Decimal;
        HseBF: Decimal;
        Dep1BF: Decimal;
        Dep2BF: Decimal;
        OpeningBalInt: Decimal;
        ClosingBalInt: Decimal;
        InterestPaid: Decimal;
        SumInterestPaid: Decimal;
        OpenBalanceRisk: Decimal;
        CLosingBalanceRisk: Decimal;
        OpenBalanceHoliday: Decimal;
        ClosingBalanceHoliday: Decimal;
        LoanSetup: Record "Loan Products Setup";
        LoanName: Text[50];
        SaccoEmp: Record "Sacco Employers";
        EmployerName: Text[100];
        OpenBalanceShareCap: Decimal;
        ClosingBalanceShareCap: Decimal;
        OpenBalanceDeposits: Decimal;
        ClosingBalanceDeposits: Decimal;
        OpenBalanceDividend: Decimal;
        ClosingBalanceDividend: Decimal;
        OpenBalanceJuniorSavings: Decimal;
        ClosingBalanceJuniorSavings: Decimal;

        // Enhanced variables for guardian functionality
        JuniorMember: Record Customer;
        JuniorMemberNo: Code[20];
        JuniorMemberName: Text[100];
        GuardianJuniorFilter: Text;
        GuardianCreditAmount: Decimal;
        GuardianDebitAmount: Decimal;
        GuardianJuniorAccountName: Text[100];
        JuniorAccountFilter: Text;
        IsOwnAccount: Boolean;

        // New guardian status variables
        IsGuardian: Boolean;
        HasJuniorAccounts: Boolean;
        GuardianInfo: Text[100];
        GuardianJuniorBF: Decimal;
        GuardianJuniorClosing: Decimal;

        // Summary variables
        TotalJuniorAccounts: Integer;
        TotalJuniorBalance: Decimal;
        JuniorAccountsList: Text[500];
        IsGuardianLoan: Boolean;
        JuniorAccountNo: Code[20];
        JuniorAccountName: Text[100];
        GuardianLoanFilter: Text;
        TempMember: Record Customer;
        StartDate: Date;
        EndDate: Date;
}