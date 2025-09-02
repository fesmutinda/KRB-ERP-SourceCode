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

            // ENHANCED JUNIOR SAVINGS SECTION - Completely updated for proper functionality
            dataitem(JuniorAccountsList; Customer)
            {
                DataItemLink = "Guardian No." = field("No.");
                RequestFilterFields = "No.", "Name";

                // Junior Account Summary Columns - Account Level Information
                column(JuniorAccountNo; JuniorAccountsList."No.") { }
                column(JuniorMemberName; JuniorAccountsList.Name) { }
                column(JuniorMemberName9; JuniorAccountsList.Name) { }  // Alternative name for RDLC
                column(JuniorGuardianNo; JuniorAccountsList."Guardian No.") { }
                column(JuniorAccountOpeningBalance; JuniorAccountOpeningBalance) { }
                column(JuniorAccountClosingBalance; JuniorAccountClosingBalance) { }
                column(JuniorIDNo; JuniorAccountsList."ID No.") { }
                column(JuniorRegistrationDate; JuniorAccountsList."Registration Date") { }
                column(JuniorPhoneNo; JuniorAccountsList."Phone No.") { }
                column(JuniorAddress; JuniorAccountsList.Address) { }

                // Summary columns for totals
                column(JuniorAccountsCount; JuniorAccountsCount) { }
                column(TotalJuniorOpeningBalance; TotalJuniorOpeningBalance) { }
                column(TotalJuniorClosingBalance; TotalJuniorClosingBalance) { }

                // Individual Junior Savings Transactions for each junior account
                dataitem(JuniorTransactions; "Cust. Ledger Entry")
                {
                    DataItemLink = "Customer No." = field("No."), "Posting Date" = field("Date Filter");
                    DataItemTableView = sorting("Posting Date") where("Transaction Type" = filter("Junior Savings"), Reversed = const(false));

                    // Core Transaction Detail Columns
                    column(PostingDate_JuniorTrans; JuniorTransactions."Posting Date") { }
                    column(DocumentNo_JuniorTrans; JuniorTransactions."Document No.") { }
                    column(Description_JuniorTrans; JuniorTransactions.Description) { }
                    column(Amount_JuniorTrans; JuniorTransactions."Amount Posted") { }
                    column(UserID_JuniorTrans; JuniorTransactions."User ID") { }
                    column(DebitAmount_JuniorTrans; Junior_DebitAmount) { }
                    column(CreditAmount_JuniorTrans; Junior_CreditAmount) { }
                    column(TransactionType_JuniorTrans; JuniorTransactions."Transaction Type") { }
                    column(RunningBalance_JuniorTrans; JuniorRunningBalance) { }
                    column(ExternalDocumentNo_JuniorTrans; JuniorTransactions."External Document No.") { }

                    // CRITICAL: Junior account identification fields for RDLC grouping
                    column(CurrentJuniorAccountNo; CurrentJuniorAccountNo) { }
                    column(CurrentJuniorMemberName; CurrentJuniorMemberName) { }
                    column(CurrentJuniorGuardianNo; CurrentJuniorGuardianNo) { }

                    // Alternative field names for RDLC compatibility and flexibility
                    column(JuniorMemberNo; CurrentJuniorAccountNo) { }
                    column(JuniorAccountNumber; CurrentJuniorAccountNo) { }
                    column(JuniorNo; CurrentJuniorAccountNo) { }
                    column(JuniorName; CurrentJuniorMemberName) { }
                    column(JuniorAccountName; CurrentJuniorMemberName) { }

                    // Balance information repeated at transaction level for grouping
                    column(OpenBalanceJunior; JuniorAccountOpeningBalance) { }
                    column(ClosingBalanceJunior; JuniorAccountClosingBalance) { }
                    column(JuniorBF; JuniorAccountOpeningBalance) { }
                    column(JuniorOpeningBalance; JuniorAccountOpeningBalance) { }
                    column(JuniorClosingBalance; JuniorAccountClosingBalance) { }

                    // Legacy field names for backward compatibility
                    column(TransactionType_Junior; JuniorTransactions."Transaction Type") { }
                    column(PostingDate_Junior; JuniorTransactions."Posting Date") { }
                    column(DocumentNo_Junior; JuniorTransactions."Document No.") { }
                    column(Description_Junior; JuniorTransactions.Description) { }
                    column(Amount_Junior; JuniorTransactions."Amount Posted") { }
                    column(UserID_Junior; JuniorTransactions."User ID") { }
                    column(DebitAmount_Junior; Junior_DebitAmount) { }
                    column(CreditAmount_Junior; Junior_CreditAmount) { }

                    // Transaction sequence and identification
                    column(JuniorTransactionSequence; JuniorTransactionSequence) { }

                    trigger OnAfterGetRecord()
                    begin
                        // CRITICAL: Populate the junior account identification fields for each transaction
                        CurrentJuniorAccountNo := JuniorAccountsList."No.";
                        CurrentJuniorMemberName := JuniorAccountsList.Name;
                        CurrentJuniorGuardianNo := JuniorAccountsList."Guardian No.";

                        // Increment transaction sequence
                        JuniorTransactionSequence += 1;

                        // Reset and calculate debit/credit amounts properly with Junior-specific variables
                        Junior_CreditAmount := 0;
                        Junior_DebitAmount := 0;

                        if JuniorTransactions."Amount Posted" > 0 then
                            Junior_DebitAmount := JuniorTransactions."Amount Posted"
                        else if JuniorTransactions."Amount Posted" < 0 then
                            Junior_CreditAmount := Abs(JuniorTransactions."Amount Posted");

                        // Update running balance for this specific junior account
                        JuniorRunningBalance := JuniorRunningBalance + (JuniorTransactions."Amount Posted" * -1);

                        // Validation: Ensure balance calculations are consistent
                        if JuniorRunningBalance < 0 then begin
                            // Log potential issue but continue processing
                            Message('Warning: Junior account %1 has negative balance: %2', CurrentJuniorAccountNo, JuniorRunningBalance);
                        end;
                    end;

                    trigger OnPreDataItem()
                    begin
                        // Initialize running balance with the opening balance for this specific junior account
                        JuniorRunningBalance := JuniorAccountOpeningBalance;
                        JuniorTransactionSequence := 0;

                        // Apply date filter if exists from main member filter
                        if "Members Register".GetFilter("Date Filter") <> '' then
                            JuniorTransactions.SetFilter("Posting Date", "Members Register".GetFilter("Date Filter"));

                        // Additional filter for data integrity
                        JuniorTransactions.SetRange(Reversed, false);
                    end;

                    trigger OnPostDataItem()
                    begin
                        // Set closing balance for this junior account after all transactions
                        JuniorAccountClosingBalance := JuniorRunningBalance;

                        // Update totals for summary reporting
                        TotalJuniorClosingBalance += JuniorAccountClosingBalance;
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    // Calculate opening balance for this specific junior account independently
                    JuniorAccountOpeningBalance := CalculateJuniorAccountOpeningBalance(JuniorAccountsList."No.", DateFilterBF);

                    // Initialize closing balance with opening balance
                    JuniorAccountClosingBalance := JuniorAccountOpeningBalance;

                    // Initialize the current account variables at the account level
                    CurrentJuniorAccountNo := JuniorAccountsList."No.";
                    CurrentJuniorMemberName := JuniorAccountsList.Name;
                    CurrentJuniorGuardianNo := JuniorAccountsList."Guardian No.";

                    // Update counters and totals
                    JuniorAccountsCount += 1;
                    TotalJuniorOpeningBalance += JuniorAccountOpeningBalance;

                    // Validate guardian relationship
                    if JuniorAccountsList."Guardian No." <> "Members Register"."No." then
                        Error('Data integrity error: Junior account %1 guardian mismatch', JuniorAccountsList."No.");
                end;

                trigger OnPreDataItem()
                begin
                    // Filter for junior accounts where this member is the guardian
                    JuniorAccountsList.SetRange("Guardian No.", "Members Register"."No.");

                    // Apply date filter if exists
                    if "Members Register".GetFilter("Date Filter") <> '' then
                        JuniorAccountsList.SetFilter("Date Filter", "Members Register".GetFilter("Date Filter"));

                    // Initialize counters
                    JuniorAccountsCount := 0;
                    TotalJuniorOpeningBalance := 0;
                    TotalJuniorClosingBalance := 0;
                end;

                trigger OnPostDataItem()
                begin
                    // Final validation and summary calculations
                    if JuniorAccountsCount > 0 then begin
                        Message('Processed %1 junior accounts for member %2', JuniorAccountsCount, "Members Register"."No.");
                    end;
                end;
            }

            // Loans Section (existing code preserved)
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

    // ENHANCED: Function to calculate opening balance for individual junior account
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
                    OpeningBalance := OpeningBalance + (CustLedgerEntry."Amount Posted" * -1);
                until CustLedgerEntry.Next() = 0;
        end;

        exit(OpeningBalance);
    end;

    // ENHANCED: Function to calculate consolidated junior savings BF (for summary purposes)
    local procedure CalculateJuniorSavingsBF(MemberNo: Code[20]; DateFilter: Text): Decimal
    var
        CustLedgerEntry: Record "Cust. Ledger Entry";
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

    // NEW: Helper function to initialize BF values
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

    // NEW: Helper function to calculate main member BF values
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

    // NEW: Function to get junior account count for a guardian
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
        // UPDATED: Separate variables for each transaction type to prevent contamination

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

        // ENHANCED: Junior Savings specific variables
        Junior_CreditAmount: Decimal;
        Junior_DebitAmount: Decimal;
        CurrentJuniorAccountNo: Code[20];
        CurrentJuniorMemberName: Text[100];
        CurrentJuniorGuardianNo: Code[20];
        JuniorAccountOpeningBalance: Decimal;
        JuniorAccountClosingBalance: Decimal;
        JuniorRunningBalance: Decimal;
        JuniorBF: Decimal;
        JuniorAccountsCount: Integer;
        TotalJuniorOpeningBalance: Decimal;
        TotalJuniorClosingBalance: Decimal;
        JuniorTransactionSequence: Integer;

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