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

            // Own Junior Savings Account (if member has junior savings)
            dataitem(OwnJuniorSavings; "Cust. Ledger Entry")
            {
                DataItemLink = "Customer No." = field("No."), "Posting Date" = field("Date Filter");
                DataItemTableView = sorting("Posting Date") where("Transaction Type" = filter("Junior Savings"), Reversed = const(false));

                column(ReportForNavId_1000000071; 1000000071)
                {
                }
                column(PostingDate_Own; OwnJuniorSavings."Posting Date")
                {
                }
                column(DocumentNo_Own; OwnJuniorSavings."Document No.")
                {
                }
                column(Description_Own; OwnJuniorSavings.Description)
                {
                }
                column(Amount_Own; OwnJuniorSavings."Amount Posted")
                {
                }
                column(UserID_Own; OwnJuniorSavings."User ID")
                {
                }
                column(DebitAmount_Own; OwnDebitAmount)
                {
                }
                column(CreditAmount_Own; OwnCreditAmount)
                {
                }
                column(TransactionType_Own; OwnJuniorSavings."Transaction Type")
                {
                }
                column(OpenBalanceOwnJunior; OpenBalanceOwnJunior)
                {
                }
                column(ClosingBalanceOwnJunior; ClosingBalanceOwnJunior)
                {
                }
                column(OwnJuniorBF; OwnJuniorBF)
                {
                }
                column(AccountHolder; "Members Register".Name) // Own account
                {
                }
                column(AccountNo; "Members Register"."No.") // Own account number
                {
                }

                trigger OnAfterGetRecord()
                begin
                    OwnCreditAmount := 0;
                    OwnDebitAmount := 0;
                    if OwnJuniorSavings."Amount Posted" < 0 then begin
                        OwnCreditAmount := OwnJuniorSavings."Amount Posted" * -1;
                    end else
                        if OwnJuniorSavings."Amount Posted" > 0 then begin
                            OwnDebitAmount := OwnJuniorSavings."Amount Posted";
                        end;
                    ClosingBalanceOwnJunior := ClosingBalanceOwnJunior + (OwnJuniorSavings."Amount Posted" * -1);
                end;

                trigger OnPreDataItem()
                begin
                    ClosingBalanceOwnJunior := OwnJuniorBF;
                    OpenBalanceOwnJunior := OwnJuniorBF;
                end;
            }

            // Guardian Junior Accounts (junior accounts where this member is the guardian)
            dataitem(GuardianJuniorSavings; "Cust. Ledger Entry")
            {
                DataItemLink = "Posting Date" = field("Date Filter");
                DataItemTableView = sorting("Posting Date") where("Transaction Type" = filter("Junior Savings"), Reversed = const(false));

                column(ReportForNavId_1000000072; 1000000072)
                {
                }
                column(PostingDate_Guardian; GuardianJuniorSavings."Posting Date")
                {
                }
                column(DocumentNo_Guardian; GuardianJuniorSavings."Document No.")
                {
                }
                column(Description_Guardian; GuardianJuniorSavings.Description)
                {
                }
                column(Amount_Guardian; GuardianJuniorSavings."Amount Posted")
                {
                }
                column(UserID_Guardian; GuardianJuniorSavings."User ID")
                {
                }
                column(DebitAmount_Guardian; GuardianDebitAmount)
                {
                }
                column(CreditAmount_Guardian; GuardianCreditAmount)
                {
                }
                column(JuniorAccountNo; GuardianJuniorSavings."Customer No.")
                {
                }
                column(JuniorAccountName; GuardianJuniorAccountName)
                {
                }
                column(IsGuardianAccount; true) // Flag to identify guardian accounts
                {
                }
                column(OpenBalanceGuardianJunior; OpenBalanceGuardianJunior)
                {
                }
                column(ClosingBalanceGuardianJunior; ClosingBalanceGuardianJunior)
                {
                }
                column(GuardianJuniorBF; GuardianJuniorBF)
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

                    ClosingBalanceGuardianJunior := ClosingBalanceGuardianJunior + (GuardianJuniorSavings."Amount Posted" * -1);

                    // Get junior account holder name
                    if JuniorMember.Get(GuardianJuniorSavings."Customer No.") then
                        GuardianJuniorAccountName := JuniorMember.Name
                    else
                        GuardianJuniorAccountName := '';
                end;

                trigger OnPreDataItem()
                begin
                    // Initialize balances
                    ClosingBalanceGuardianJunior := GuardianJuniorBF;
                    OpenBalanceGuardianJunior := GuardianJuniorBF;

                    // Get junior accounts for this guardian
                    GuardianJuniorFilter := GetJuniorAccountsForGuardian("Members Register"."No.");

                    // If no junior accounts found, skip this dataitem
                    if GuardianJuniorFilter = '' then
                        CurrReport.Break();

                    // Apply filters
                    GuardianJuniorSavings.SetFilter("Customer No.", GuardianJuniorFilter);

                    // Apply date filter if exists
                    if "Members Register".GetFilter("Date Filter") <> '' then
                        GuardianJuniorSavings.SetFilter("Posting Date", "Members Register".GetFilter("Date Filter"));
                end;
            }

            // Keep loan section as is
            dataitem(Loans; "Loans Register")
            {
                DataItemLink = "Client Code" = field("No."), "Date filter" = field("Date Filter");
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
                column(ApprovedAmount_Loans; Loans."Approved Amount")
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
                    DataItemTableView = sorting("Posting Date") where("Transaction Type" = filter(Loan | "Loan Repayment" | "Interest Due" | "Interest Paid"));

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
                    column(TransactionType_loan; loan."Transaction Type")
                    {
                    }
                    column(LoanNo; loan."Loan No")
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        if loan."Amount Posted" < 0 then begin
                            loan."Credit Amount" := (loan."Amount Posted" * -1);
                        end else
                            if loan."Amount Posted" > 0 then begin
                                loan."Debit Amount" := (loan."Amount Posted");
                            end;
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
                end;
            }

            trigger OnAfterGetRecord()
            begin
                // Get employer name
                SaccoEmp.Reset;
                SaccoEmp.SetRange(SaccoEmp.Code, "Members Register"."Employer Code");
                if SaccoEmp.Find('-') then
                    EmployerName := SaccoEmp.Description;

                // Initialize brought forward balances
                OwnJuniorBF := 0;
                GuardianJuniorBF := 0;

                if DateFilterBF <> '' then begin
                    // Calculate own junior savings BF
                    OwnJuniorBF := CalculateOwnJuniorSavingsBF("No.", DateFilterBF);

                    // Calculate guardian junior savings BF
                    GuardianJuniorBF := CalculateGuardianJuniorSavingsBF("No.", DateFilterBF);
                end;
            end;

            trigger OnPreDataItem()
            begin
                if "Members Register".GetFilter("Members Register"."Date Filter") <> '' then
                    DateFilterBF := '..' + Format(CalcDate('-1D', "Members Register".GetRangeMin("Members Register"."Date Filter")));
            end;
        }
    }

    requestpage
    {
        layout
        {
        }

        actions
        {
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

    // Function to get junior accounts where this member is the guardian
    local procedure GetJuniorAccountsForGuardian(GuardianNo: Code[20]): Text
    var
        JuniorAccounts: Text;
        TempMember: Record Customer;
    begin
        JuniorAccounts := '';

        // Find junior accounts where this member is the guardian
        // Adjust the field name based on your actual field name for guardian
        TempMember.Reset();
        TempMember.SetRange("Guardian No.", GuardianNo); // Replace with your actual guardian field
        if TempMember.FindSet() then
            repeat
                if JuniorAccounts <> '' then
                    JuniorAccounts := JuniorAccounts + '|' + TempMember."No."
                else
                    JuniorAccounts := TempMember."No.";
            until TempMember.Next() = 0;

        exit(JuniorAccounts);
    end;

    // Calculate own junior savings brought forward
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

    // Calculate guardian junior savings brought forward
    local procedure CalculateGuardianJuniorSavingsBF(GuardianNo: Code[20]; DateFilter: Text): Decimal
    var
        CustLedgerEntry: Record "Cust. Ledger Entry";
        JuniorAccountFilter: Text;
        TotalBF: Decimal;
    begin
        TotalBF := 0;
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

    var
        // Balance variables
        OpenBalanceOwnJunior: Decimal;
        OwnJuniorBF: Decimal;
        ClosingBalanceOwnJunior: Decimal;
        OpenBalanceGuardianJunior: Decimal;
        GuardianJuniorBF: Decimal;
        ClosingBalanceGuardianJunior: Decimal;

        // Amount variables
        OwnCreditAmount: Decimal;
        OwnDebitAmount: Decimal;
        GuardianCreditAmount: Decimal;
        GuardianDebitAmount: Decimal;

        // Records
        Company: Record "Company Information";
        JuniorMember: Record Customer;
        SaccoEmp: Record "Sacco Employers";
        LoanSetup: Record "Loan Products Setup";
        LoansR: Record "Loans Register";
        Cust: Record Customer;

        // Text variables
        GuardianJuniorFilter: Text;
        GuardianJuniorAccountName: Text[100];
        EmployerName: Text[100];
        LoanName: Text[50];
        DateFilterBF: Text[150];

        // Other variables
        PrincipleBF: Decimal;
        SharesBF: Decimal;
        InsuranceBF: Decimal;
        ShareCapBF: Decimal;
        RiskBF: Decimal;
        HseBF: Decimal;
        Dep1BF: Decimal;
        Dep2BF: Decimal;
        DividendBF: Decimal;
        OpeningBal: Decimal;
        InterestPaid: Decimal;
        SumInterestPaid: Decimal;
}