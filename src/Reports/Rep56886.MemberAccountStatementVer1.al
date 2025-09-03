#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 56886 "Member Account Statement(Ver1)"
{
    DefaultLayout = RDLC;
    Caption = 'Detailed Member Statement';
    RDLCLayout = './Layout/Member Account Statement(Ver1).rdlc';

    dataset
    {
        dataitem("Members Register"; customer)
        {
            RequestFilterFields = "No.", "Loan Product Filter", "Outstanding Balance", "Date Filter";

            // Main member columns
            column(USERID; UserId) { }
            column(PayrollStaffNo_Members; "Members Register"."Payroll/Staff No") { }
            column(No_Members; "Members Register"."No.") { }
            column(Name_Members; "Members Register".Name) { }
            column(Phone_No_; "Phone No.") { }
            column(Registration_Date; "Registration Date") { }
            column(EmployerCode_Members; "Members Register"."Employer Code") { }
            column(EmployerName; EmployerName) { }
            column(PageNo_Members; CurrReport.PageNo) { }
            column(Shares_Retained; "Members Register"."Shares Retained") { }
            column(IDNo_Members; "Members Register"."ID No.") { }
            column(GlobalDimension2Code_Members; "Members Register"."Global Dimension 2 Code") { }

            // Company information columns
            column(Company_Name; Company.Name) { }
            column(Company_Address; Company.Address) { }
            column(Company_Address_2; Company."Address 2") { }
            column(Company_Phone_No; Company."Phone No.") { }
            column(Company_Fax_No; Company."Fax No.") { }
            column(Company_Picture; Company.Picture) { }
            column(Company_Email; Company."E-Mail") { }

            // Share Capital Section
            dataitem(ShareCapital; "Cust. Ledger Entry")
            {
                DataItemLink = "Customer No." = field("No."), "Posting Date" = field("Date Filter");
                DataItemTableView = sorting("Posting Date") where("Transaction Type" = filter("Share Capital"), Reversed = const(false));

                column(PostingDate_ShareCapital; ShareCapital."Posting Date") { }
                column(DocumentNo_ShareCapital; ShareCapital."Document No.") { }
                column(Description_ShareCapital; ShareCapital.Description) { }
                column(DebitAmount_ShareCapital; ShareCap_DebitAmount) { }
                column(CreditAmount_ShareCapital; ShareCap_CreditAmount) { }
                column(Amount_ShareCapital; ShareCapital."Amount Posted") { }
                column(TransactionType_ShareCapital; ShareCapital."Transaction Type") { }
                column(UserID_ShareCapital; ShareCapital."User ID") { }
                column(OpenBalanceShareCap; OpenBalanceShareCap) { }
                column(ClosingBalanceShareCap; ClosingBalanceShareCap) { }
                column(ShareCapBF; ShareCapBF) { }

                trigger OnAfterGetRecord()
                begin
                    ShareCap_CreditAmount := 0;
                    ShareCap_DebitAmount := 0;

                    if ShareCapital."Amount Posted" < 0 then
                        ShareCap_CreditAmount := ShareCapital."Amount Posted" * -1
                    else if ShareCapital."Amount Posted" > 0 then
                        ShareCap_DebitAmount := ShareCapital."Amount Posted";

                    ClosingBalanceShareCap := ClosingBalanceShareCap + (ShareCapital."Amount Posted" * -1);
                end;

                trigger OnPreDataItem()
                begin
                    ClosingBalanceShareCap := ShareCapBF;
                    OpenBalanceShareCap := ShareCapBF;
                end;
            }

            // Deposits Section
            dataitem(Deposits; "Cust. Ledger Entry")
            {
                DataItemLink = "Customer No." = field("No."), "Posting Date" = field("Date Filter");
                DataItemTableView = sorting("Posting Date") where("Transaction Type" = filter("Deposit Contribution"), Reversed = const(false));

                column(PostingDate_Deposits; Deposits."Posting Date") { }
                column(DocumentNo_Deposits; Deposits."Document No.") { }
                column(Description_Deposits; Deposits.Description) { }
                column(Amount_Deposits; Deposits."Amount Posted") { }
                column(DebitAmount_Deposits; Deposits_DebitAmount) { }
                column(CreditAmount_Deposits; Deposits_CreditAmount) { }
                column(TransactionType_Deposits; Deposits."Transaction Type") { }
                column(UserID_Deposits; Deposits."User ID") { }
                column(OpenBalanceDeposits; OpenBalanceDeposits) { }
                column(ClosingBalanceDeposits; ClosingBalanceDeposits) { }
                column(SharesBF; SharesBF) { }

                trigger OnAfterGetRecord()
                begin
                    Deposits_CreditAmount := 0;
                    Deposits_DebitAmount := 0;

                    if Deposits."Amount Posted" < 0 then
                        Deposits_CreditAmount := Deposits."Amount Posted" * -1
                    else if Deposits."Amount Posted" > 0 then
                        Deposits_DebitAmount := Deposits."Amount Posted";

                    ClosingBalanceDeposits := ClosingBalanceDeposits + (Deposits."Amount Posted" * -1);
                end;

                trigger OnPreDataItem()
                begin
                    ClosingBalanceDeposits := SharesBF;
                    OpenBalanceDeposits := SharesBF;
                end;
            }

            // Withdrawable Savings Section
            dataitem(WithdrawableSavings; "Cust. Ledger Entry")
            {
                DataItemLink = "Customer No." = field("No."), "Posting Date" = field("Date Filter");
                DataItemTableView = sorting("Posting Date") where("Transaction Type" = filter("Withdrawable Savings"), Reversed = const(false));

                column(PostingDate_Withdrawable; WithdrawableSavings."Posting Date") { }
                column(DocumentNo_Withdrawable; WithdrawableSavings."Document No.") { }
                column(Description_Withdrawable; WithdrawableSavings.Description) { }
                column(Amount_Withdrawable; WithdrawableSavings."Amount Posted") { }
                column(UserID_Withdrawable; WithdrawableSavings."User ID") { }
                column(DebitAmount_Withdrawable; Withdrawable_DebitAmount) { }
                column(CreditAmount_Withdrawable; Withdrawable_CreditAmount) { }
                column(TransactionType_Withdrawable; WithdrawableSavings."Transaction Type") { }
                column(OpenBalanceWithdrawable; OpenBalanceWithdrawable) { }
                column(ClosingBalanceWithdrawable; ClosingBalanceWithdrawable) { }
                column(WithdrawableBF; WithdrawableBF) { }

                trigger OnAfterGetRecord()
                begin
                    Withdrawable_CreditAmount := 0;
                    Withdrawable_DebitAmount := 0;

                    if WithdrawableSavings."Amount Posted" < 0 then
                        Withdrawable_CreditAmount := WithdrawableSavings."Amount Posted" * -1
                    else if WithdrawableSavings."Amount Posted" > 0 then
                        Withdrawable_DebitAmount := WithdrawableSavings."Amount Posted";

                    ClosingBalanceWithdrawable := ClosingBalanceWithdrawable + (WithdrawableSavings."Amount Posted" * -1);
                end;

                trigger OnPreDataItem()
                begin
                    ClosingBalanceWithdrawable := WithdrawableBF;
                    OpenBalanceWithdrawable := WithdrawableBF;
                end;
            }

            // RESTRUCTURED JUNIOR SAVINGS SECTION - Clean and Organized
            dataitem(JuniorAccounts; Customer)
            {
                DataItemLink = "Guardian No." = field("No.");
                RequestFilterFields = "No.", "Name";

                // === JUNIOR ACCOUNT HEADER INFORMATION ===
                column(Junior_AccountNo; JuniorAccounts."No.") { }
                column(Junior_MemberName; JuniorAccounts.Name) { }
                column(Junior_GuardianNo; JuniorAccounts."Guardian No.") { }
                column(Junior_IDNo; JuniorAccounts."ID No.") { }
                column(Junior_RegistrationDate; JuniorAccounts."Registration Date") { }
                column(Junior_PhoneNo; JuniorAccounts."Phone No.") { }
                column(Junior_Address; JuniorAccounts.Address) { }

                // === JUNIOR ACCOUNT BALANCES ===
                column(Junior_OpeningBalance; JuniorOpeningBalance) { }
                column(Junior_ClosingBalance; JuniorClosingBalance) { }
                column(Junior_RunningBalance; JuniorCurrentBalance) { }

                // === SUMMARY INFORMATION ===
                column(Junior_AccountsCount; JuniorAccountsCount) { }
                column(Junior_TotalOpeningBalance; TotalJuniorOpeningBalance) { }
                column(Junior_TotalClosingBalance; TotalJuniorClosingBalance) { }

                // Individual Junior Account Transactions
                dataitem(JuniorSavingsTransactions; "Cust. Ledger Entry")
                {
                    DataItemLink = "Customer No." = field("No."), "Posting Date" = field("Date Filter");
                    DataItemTableView = sorting("Posting Date") where("Transaction Type" = filter("Junior Savings"), Reversed = const(false));

                    // === TRANSACTION DETAILS ===
                    column(JuniorTrans_PostingDate; JuniorSavingsTransactions."Posting Date") { }
                    column(JuniorTrans_DocumentNo; JuniorSavingsTransactions."Document No.") { }
                    column(JuniorTrans_Description; JuniorSavingsTransactions.Description) { }
                    column(JuniorTrans_Amount; JuniorSavingsTransactions."Amount Posted") { }
                    column(JuniorTrans_ExternalDocNo; JuniorSavingsTransactions."External Document No.") { }
                    column(JuniorTrans_UserID; JuniorSavingsTransactions."User ID") { }
                    column(JuniorTrans_TransactionType; JuniorSavingsTransactions."Transaction Type") { }
                    column(JuniorBF; JuniorBF) { }

                    // === DEBIT/CREDIT AMOUNTS ===
                    column(JuniorTrans_DebitAmount; JuniorTrans_DebitAmount) { }
                    column(JuniorTrans_CreditAmount; JuniorTrans_CreditAmount) { }

                    // === RUNNING BALANCE ===
                    column(JuniorTrans_RunningBalance; JuniorTransRunningBalance) { }

                    // === ACCOUNT IDENTIFICATION (for RDLC grouping) ===
                    column(JuniorTrans_AccountNo; JuniorAccounts."No.") { }
                    column(JuniorTrans_AccountName; JuniorAccounts.Name) { }
                    column(JuniorTrans_GuardianNo; JuniorAccounts."Guardian No.") { }

                    // === TRANSACTION SEQUENCE ===
                    column(JuniorTrans_SequenceNo; JuniorTransSequenceNo) { }

                    trigger OnAfterGetRecord()
                    begin
                        // Increment transaction sequence for this account
                        JuniorTransSequenceNo += 1;

                        // Calculate Debit/Credit amounts
                        JuniorTrans_DebitAmount := 0;
                        JuniorTrans_CreditAmount := 0;

                        if JuniorSavingsTransactions."Amount Posted" > 0 then
                            JuniorTrans_DebitAmount := JuniorSavingsTransactions."Amount Posted"
                        else if JuniorSavingsTransactions."Amount Posted" < 0 then
                            JuniorTrans_CreditAmount := Abs(JuniorSavingsTransactions."Amount Posted");

                        // Update running balance (proper calculation)
                        JuniorTransRunningBalance += (JuniorSavingsTransactions."Amount Posted" * -1);

                        // Validation check
                        if JuniorTransRunningBalance < -999999 then
                            Message('Warning: Junior account %1 has unusual balance: %2', JuniorAccounts."No.", JuniorTransRunningBalance);
                    end;

                    trigger OnPreDataItem()
                    begin
                        // Initialize running balance with opening balance for this specific account
                        JuniorTransRunningBalance := JuniorOpeningBalance;
                        JuniorTransSequenceNo := 0;

                        // Apply date filter from main member if exists
                        if "Members Register".GetFilter("Date Filter") <> '' then
                            JuniorSavingsTransactions.SetFilter("Posting Date", "Members Register".GetFilter("Date Filter"));

                        // Ensure only valid transactions
                        JuniorSavingsTransactions.SetRange(Reversed, false);
                    end;

                    trigger OnPostDataItem()
                    begin
                        // Set final closing balance for this account
                        JuniorClosingBalance := JuniorTransRunningBalance;
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    // Calculate opening balance for this specific junior account
                    JuniorOpeningBalance := CalculateJuniorAccountOpeningBalance(JuniorAccounts."No.", DateFilterBF);

                    // Initialize closing balance
                    JuniorClosingBalance := JuniorOpeningBalance;
                    JuniorCurrentBalance := JuniorOpeningBalance;

                    // Update summary counters
                    JuniorAccountsCount += 1;
                    TotalJuniorOpeningBalance += JuniorOpeningBalance;

                    // Validate data integrity
                    if JuniorAccounts."Guardian No." <> "Members Register"."No." then
                        Error('Data integrity error: Junior account %1 guardian mismatch. Expected: %2, Found: %3',
                              JuniorAccounts."No.", "Members Register"."No.", JuniorAccounts."Guardian No.");
                end;

                trigger OnPreDataItem()
                begin
                    // Filter for junior accounts where current member is the guardian
                    JuniorAccounts.SetRange("Guardian No.", "Members Register"."No.");

                    // Apply date filter if exists
                    if "Members Register".GetFilter("Date Filter") <> '' then
                        JuniorAccounts.SetFilter("Date Filter", "Members Register".GetFilter("Date Filter"));

                    // Initialize summary counters
                    JuniorAccountsCount := 0;
                    TotalJuniorOpeningBalance := 0;
                    TotalJuniorClosingBalance := 0;

                    // Clear any previous filters that might interfere
                    JuniorAccounts.SetRange(Blocked, JuniorAccounts.Blocked::" ");
                end;

                trigger OnPostDataItem()
                begin
                    // Update final totals
                    TotalJuniorClosingBalance := TotalJuniorOpeningBalance;

                    // Calculate total closing balance from all individual account balances
                    if JuniorAccountsCount > 0 then begin
                        JuniorAccounts.Reset();
                        JuniorAccounts.SetRange("Guardian No.", "Members Register"."No.");
                        if JuniorAccounts.FindSet() then
                            repeat
                                TotalJuniorClosingBalance += CalculateJuniorAccountClosingBalance(JuniorAccounts."No.");
                            until JuniorAccounts.Next() = 0;
                    end;
                end;
            }

            // Loans Section
            dataitem(Loans; "Loans Register")
            {
                DataItemLink = "Client Code" = field("No."), "Date filter" = field("Date Filter"), "Loan Product Type" = field("Loan Product Filter");
                DataItemTableView = sorting("Loan  No.") where(Posted = const(true), Reversed = const(false));

                column(PrincipleBF; PrincipleBF) { }
                column(LoanNumber; Loans."Loan  No.") { }
                column(ProductType; Loans."Loan Product Type Name") { }
                column(RequestedAmount; Loans."Requested Amount") { }
                column(Interest; Loans.Interest) { }
                column(Installments; Loans.Installments) { }
                column(LoanPrincipleRepayment; Loans."Loan Principle Repayment") { }
                column(ApprovedAmount_Loans; Loans."Approved Amount") { }
                column(LoanProductTypeName_Loans; Loans."Loan Product Type Name") { }
                column(Repayment_Loans; Loans.Repayment) { }
                column(ModeofDisbursement_Loans; Loans."Mode of Disbursement") { }
                column(OutstandingBalance_Loans; Loans."Outstanding Balance") { }
                column(OustandingInterest_Loans; Loans."Oustanding Interest") { }

                dataitem(loan; "Cust. Ledger Entry")
                {
                    DataItemLink = "Customer No." = field("Client Code"), "Loan No" = field("Loan  No."), "Posting Date" = field("Date filter");
                    DataItemTableView = sorting("Posting Date") where("Transaction Type" = filter(Loan | "Loan Repayment" | "Interest Due" | "Interest Paid" | "Loan Transfer Charges" | "Unallocated Funds"), Reversed = const(false));

                    column(PostingDate_loan; loan."Posting Date") { }
                    column(DocumentNo_loan; loan."Document No.") { }
                    column(Description_loan; loan.Description) { }
                    column(DebitAmount_Loan; Loan_DebitAmount) { }
                    column(CreditAmount_Loan; Loan_CreditAmount) { }
                    column(Amount_Loan; loan.Amount) { }
                    column(openBalance_loan; Loan_OpenBalance) { }
                    column(CLosingBalance_loan; Loan_ClosingBalance) { }
                    column(TransactionType_loan; loan."Transaction Type") { }
                    column(LoanNo; loan."Loan No") { }
                    column(PrincipleBF_loans; PrincipleBF) { }
                    column(Loan_Description; loan.Description) { }
                    column(User7; loan."User ID") { }

                    trigger OnAfterGetRecord()
                    begin
                        Loan_CreditAmount := 0;
                        Loan_DebitAmount := 0;

                        Loan_ClosingBalance := Loan_ClosingBalance + (loan."Amount Posted");

                        if loan."Amount Posted" < 0 then
                            Loan_CreditAmount := (loan."Amount Posted" * -1)
                        else if loan."Amount Posted" > 0 then
                            Loan_DebitAmount := (loan."Amount Posted");

                        if loan."Transaction Type" = loan."transaction type"::"Interest Paid" then begin
                            InterestPaid := 0;
                            if loan."Amount Posted" < 0 then
                                InterestPaid := loan."Amount Posted" * -1;
                            SumInterestPaid := InterestPaid + SumInterestPaid;
                        end;

                        if loan."Transaction Type" = loan."transaction type"::"Loan Repayment" then
                            if loan."Amount Posted" < 0 then
                                Loan_CreditAmount := loan."Amount Posted" * -1;
                    end;

                    trigger OnPreDataItem()
                    begin
                        Loan_ClosingBalance := PrincipleBF;
                        Loan_OpenBalance := PrincipleBF;
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

                trigger OnPreDataItem()
                begin
                    Loans.SetFilter(Loans."Date filter", "Members Register".GetFilter("Members Register"."Date Filter"));
                end;
            }

            trigger OnAfterGetRecord()
            begin
                // Get employer information
                SaccoEmp.Reset;
                SaccoEmp.SetRange(SaccoEmp.Code, "Members Register"."Employer Code");
                if SaccoEmp.Find('-') then
                    EmployerName := SaccoEmp.Description;

                // Initialize all BF (Brought Forward) values
                InitializeBFValues();

                // Calculate BF values if date filter exists
                if DateFilterBF <> '' then begin
                    CalculateMainMemberBFValues();
                    JuniorBF := CalculateJuniorSavingsBF("No.", DateFilterBF);
                    WithdrawableBF := CalculateWithdrawableSavingsBF("No.", DateFilterBF);
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
            area(Content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(ShowZeroBalances; ShowZeroBal)
                    {
                        ApplicationArea = All;
                        Caption = 'Show Zero Balances';
                        ToolTip = 'Include accounts with zero balances in the report';
                    }
                }
            }
        }
    }

    labels
    {
        ReportTitle = 'Member Account Statement';
        MemberDetails = 'Member Details';
        JuniorAccounts = 'Junior Savings Accounts';
        Transactions = 'Transactions';
        Summary = 'Summary';
    }

    trigger OnPreReport()
    begin
        Company.Get();
        Company.CalcFields(Company.Picture);

        // Initialize global variables
        Clear(JuniorAccountsCount);
        Clear(TotalJuniorOpeningBalance);
        Clear(TotalJuniorClosingBalance);
    end;

    // === SUPPORTING FUNCTIONS ===

    // Calculate opening balance for specific junior account
    local procedure CalculateJuniorAccountOpeningBalance(JuniorAccountNo: Code[20]; DateFilter: Text): Decimal
    var
        CustLedgerEntry: Record "Cust. Ledger Entry";
        OpeningBalance: Decimal;
    begin
        OpeningBalance := 0;

        if DateFilter <> '' then begin
            CustLedgerEntry.Reset();
            CustLedgerEntry.SetRange("Customer No.", JuniorAccountNo);
            CustLedgerEntry.SetRange("Transaction Type", CustLedgerEntry."Transaction Type"::"Junior Savings");
            CustLedgerEntry.SetRange(Reversed, false);
            CustLedgerEntry.SetFilter("Posting Date", DateFilter);

            if CustLedgerEntry.FindSet() then
                repeat
                    OpeningBalance += (CustLedgerEntry."Amount Posted" * -1);
                until CustLedgerEntry.Next() = 0;
        end;

        exit(OpeningBalance);
    end;

    // Calculate closing balance for specific junior account
    local procedure CalculateJuniorAccountClosingBalance(JuniorAccountNo: Code[20]): Decimal
    var
        CustLedgerEntry: Record "Cust. Ledger Entry";
        ClosingBalance: Decimal;
    begin
        ClosingBalance := 0;

        CustLedgerEntry.Reset();
        CustLedgerEntry.SetRange("Customer No.", JuniorAccountNo);
        CustLedgerEntry.SetRange("Transaction Type", CustLedgerEntry."Transaction Type"::"Junior Savings");
        CustLedgerEntry.SetRange(Reversed, false);

        // Apply date filter if exists
        if "Members Register".GetFilter("Date Filter") <> '' then
            CustLedgerEntry.SetFilter("Posting Date", "Members Register".GetFilter("Date Filter"));

        if CustLedgerEntry.FindSet() then
            repeat
                ClosingBalance += (CustLedgerEntry."Amount Posted" * -1);
            until CustLedgerEntry.Next() = 0;

        exit(ClosingBalance);
    end;

    // ENHANCED: Function to calculate consolidated junior savings BF (for summary purposes)
    local procedure CalculateJuniorSavingsBF(MemberNo: Code[20]; DateFilter: Text): Decimal
    var
        TempMember: Record Customer;
        TotalBF: Decimal;
    begin
        TotalBF := 0;

        if DateFilter <> '' then begin
            TempMember.Reset();
            TempMember.SetRange("Guardian No.", MemberNo);
            if TempMember.FindSet() then
                repeat
                    TotalBF += CalculateJuniorAccountOpeningBalance(TempMember."No.", DateFilter);
                until TempMember.Next() = 0;
        end;

        exit(TotalBF);
    end;

    // Function to calculate withdrawable savings BF
    local procedure CalculateWithdrawableSavingsBF(MemberNo: Code[20]; DateFilter: Text): Decimal
    var
        CustLedgerEntry: Record "Cust. Ledger Entry";
        TotalBF: Decimal;
    begin
        TotalBF := 0;

        if DateFilter <> '' then begin
            CustLedgerEntry.Reset();
            CustLedgerEntry.SetRange("Customer No.", MemberNo);
            CustLedgerEntry.SetRange("Transaction Type", CustLedgerEntry."Transaction Type"::"Withdrawable Savings");
            CustLedgerEntry.SetRange(Reversed, false);
            CustLedgerEntry.SetFilter("Posting Date", DateFilter);

            if CustLedgerEntry.FindSet() then
                repeat
                    TotalBF := TotalBF + (CustLedgerEntry."Amount Posted" * -1);
                until CustLedgerEntry.Next() = 0;
        end;

        exit(TotalBF);
    end;

    // Helper function to initialize BF values
    local procedure InitializeBFValues()
    begin
        SharesBF := 0;
        InsuranceBF := 0;
        ShareCapBF := 0;
        RiskBF := 0;
        HseBF := 0;
        Dep1BF := 0;
        Dep2BF := 0;
        JuniorBF := 0;
        WithdrawableBF := 0;
        DividendBF := 0;
        ExcessBF := 0;
        PrincipleBF := 0;
        InterestBF := 0;
    end;

    // Helper function to calculate main member BF values
    local procedure CalculateMainMemberBFValues()
    begin
        Cust.Reset;
        Cust.SetRange(Cust."No.", "Members Register"."No.");
        Cust.SetFilter(Cust."Date Filter", DateFilterBF);
        if Cust.Find('-') then begin
            Cust.CalcFields(Cust."Shares Retained", Cust."Current Shares", Cust."Insurance Fund", Cust."Dividend Amount");
            SharesBF := (Cust."Current Shares" * -1);
            ShareCapBF := (Cust."Shares Retained" * -1);
            RiskBF := Cust."Insurance Fund";
            DividendBF := Cust."Dividend Amount";
        end;
    end;

    // Function to get junior account count for a guardian
    local procedure GetJuniorAccountCount(GuardianNo: Code[20]): Integer
    var
        TempMember: Record Customer;
        Count: Integer;
    begin
        Count := 0;
        TempMember.Reset();
        TempMember.SetRange("Guardian No.", GuardianNo);
        if TempMember.FindSet() then
            repeat
                Count += 1;
            until TempMember.Next() = 0;

        exit(Count);
    end;

    var
        // === CLEAN VARIABLE DECLARATIONS ===

        // Share Capital specific variables
        ShareCap_CreditAmount: Decimal;
        ShareCap_DebitAmount: Decimal;
        OpenBalanceShareCap: Decimal;
        ClosingBalanceShareCap: Decimal;
        ShareCapBF: Decimal;

        // Deposits specific variables  
        Deposits_CreditAmount: Decimal;
        Deposits_DebitAmount: Decimal;
        OpenBalanceDeposits: Decimal;
        ClosingBalanceDeposits: Decimal;
        SharesBF: Decimal;

        // Withdrawable Savings specific variables
        Withdrawable_CreditAmount: Decimal;
        Withdrawable_DebitAmount: Decimal;
        OpenBalanceWithdrawable: Decimal;
        ClosingBalanceWithdrawable: Decimal;
        WithdrawableBF: Decimal;

        // Junior Savings specific variables - Clean and organized
        JuniorTrans_DebitAmount: Decimal;
        JuniorTrans_CreditAmount: Decimal;
        JuniorOpeningBalance: Decimal;
        JuniorClosingBalance: Decimal;
        JuniorCurrentBalance: Decimal;
        JuniorTransRunningBalance: Decimal;
        JuniorTransSequenceNo: Integer;

        // Junior Summary variables
        JuniorAccountsCount: Integer;
        TotalJuniorOpeningBalance: Decimal;
        TotalJuniorClosingBalance: Decimal;
        JuniorBF: Decimal;  // Keep for compatibility

        // Loan specific variables
        Loan_CreditAmount: Decimal;
        Loan_DebitAmount: Decimal;
        Loan_OpenBalance: Decimal;
        Loan_ClosingBalance: Decimal;

        // Other existing variables
        Cust: Record Customer;
        OpeningBal: Decimal;
        ClosingBal: Decimal;
        FirstRec: Boolean;
        PrevBal: Integer;
        BalBF: Decimal;
        LoansR: Record "Loans Register";
        DateFilterBF: Text[150];
        InsuranceBF: Decimal;
        LoanBF: Decimal;
        PrincipleBF: Decimal;
        InterestBF: Decimal;
        ShowZeroBal: Boolean;
        ClosingBalSHCAP: Decimal;
        RiskBF: Decimal;
        DividendBF: Decimal;
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
        OpenBalanceDividend: Decimal;
        ClosingBalanceDividend: Decimal;
        ExcessBF: Decimal;
        ClosingBalanceExcess: Decimal;
        OpenBalanceExcess: Decimal;

    protected var
        StartDate: Date;
        EndDate: Date;
}