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

            column(Phone_No_; "Phone No.")
            {

            }

            column(Registration_Date; "Registration Date")
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
            dataitem(ShareCapital; "Cust. Ledger Entry")
            {
                DataItemLink = "Customer No." = field("No."), "Posting Date" = field("Date Filter");
                DataItemTableView = sorting("Posting Date") where("Transaction Type" = filter("Share Capital"), Reversed = const(false));

                column(PostingDate_ShareCapital; ShareCapital."Posting Date")
                {
                }
                column(DocumentNo_ShareCapital; ShareCapital."Document No.")
                {
                }
                column(Description_ShareCapital; ShareCapital.Description)
                {
                }
                column(DebitAmount_ShareCapital; DebitAmount)
                {
                }
                column(CreditAmount_ShareCapital; CreditAmount)
                {
                }
                column(Amount_ShareCapital; ShareCapital."Amount Posted")
                {
                }
                column(TransactionType_ShareCapital; ShareCapital."Transaction Type")
                {
                }
                column(UserID_ShareCapital; ShareCapital."User ID")
                {
                }
                column(OpenBalanceShareCap; OpenBalanceShareCap)
                {
                }
                column(ClosingBalanceShareCap; ClosingBalanceShareCap)
                {
                }
                column(ShareCapBF; ShareCapBF)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    CreditAmount := 0;
                    DebitAmount := 0;
                    if ShareCapital."Amount Posted" < 0 then begin
                        CreditAmount := ShareCapital."Amount Posted" * -1;
                    end else
                        if ShareCapital."Amount Posted" > 0 then begin
                            DebitAmount := ShareCapital."Amount Posted";
                        end;
                    ClosingBalanceShareCap := ClosingBalanceShareCap + (ShareCapital."Amount Posted" * -1);
                end;

                trigger OnPreDataItem()
                begin
                    ClosingBalanceShareCap := ShareCapBF;
                    OpenBalanceShareCap := ShareCapBF;
                end;
            }
            dataitem(Deposits; "Cust. Ledger Entry")
            {
                DataItemLink = "Customer No." = field("No."), "Posting Date" = field("Date Filter");
                DataItemTableView = sorting("Posting Date") where("Transaction Type" = filter("Deposit Contribution"), Reversed = const(false));

                column(PostingDate_Deposits; Deposits."Posting Date")
                {
                }
                column(DocumentNo_Deposits; Deposits."Document No.")
                {
                }
                column(Description_Deposits; Deposits.Description)
                {
                }
                column(Amount_Deposits; Deposits."Amount Posted")
                {
                }
                column(DebitAmount_Deposits; DebitAmount)
                {
                }
                column(CreditAmount_Deposits; CreditAmount)
                {
                }
                column(TransactionType_Deposits; Deposits."Transaction Type")
                {
                }
                column(UserID_Deposits; Deposits."User ID")
                {
                }
                column(OpenBalanceDeposits; OpenBalanceDeposits)
                {
                }
                column(ClosingBalanceDeposits; ClosingBalanceDeposits)
                {
                }
                column(SharesBF; SharesBF)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    CreditAmount := 0;
                    DebitAmount := 0;
                    if Deposits."Amount Posted" < 0 then begin
                        CreditAmount := Deposits."Amount Posted" * -1;
                    end else
                        if Deposits."Amount Posted" > 0 then begin
                            DebitAmount := Deposits."Amount Posted";
                        end;
                    ClosingBalanceDeposits := ClosingBalanceDeposits + (Deposits."Amount Posted" * -1);
                end;

                trigger OnPreDataItem()
                begin
                    ClosingBalanceDeposits := SharesBF;
                    OpenBalanceDeposits := SharesBF;
                end;
            }

            // dataitem(ExcessLoanRepayments; "Cust. Ledger Entry")
            // {
            //     DataItemLink = "Customer No." = field("No."), "Posting Date" = field("Date Filter");
            //     DataItemTableView = sorting("Posting Date") where("Transaction Type" = filter("Unallocated Funds"), Reversed = const(false));

            //     column(PostingDate_Excess; ExcessLoanRepayments."Posting Date")
            //     {
            //     }
            //     column(DocumentNo_Excess; ExcessLoanRepayments."Document No.")
            //     {
            //     }
            //     column(Description_Excess; ExcessLoanRepayments.Description)
            //     {
            //     }
            //     column(Amount_Excess; ExcessLoanRepayments."Amount Posted")
            //     {
            //     }
            //     column(UserID_Excess; ExcessLoanRepayments."User ID")
            //     {
            //     }
            //     column(DebitAmount_Excess; DebitAmount)
            //     {
            //     }
            //     column(CreditAmount_Excess; CreditAmount)
            //     {
            //     }
            //     column(TransactionType_Excess; ExcessLoanRepayments."Transaction Type")
            //     {
            //     }
            //     column(OpenBalanceExcess; OpenBalanceExcess)
            //     {
            //     }
            //     column(ClosingBalanceExcess; ClosingBalanceExcess)
            //     {
            //     }
            //     column(ExcessBF; ExcessBF)
            //     {
            //     }

            //     trigger OnAfterGetRecord()
            //     begin
            //         CreditAmount := 0;
            //         DebitAmount := 0;
            //         if ExcessLoanRepayments."Amount Posted" < 0 then begin
            //             CreditAmount := ExcessLoanRepayments."Amount Posted" * -1;
            //         end else
            //             if ExcessLoanRepayments."Amount Posted" > 0 then begin
            //                 DebitAmount := ExcessLoanRepayments."Amount Posted";
            //             end;
            //         ClosingBalanceExcess := ClosingBalanceExcess + (ExcessLoanRepayments."Amount Posted" * -1);
            //     end;

            //     trigger OnPreDataItem()
            //     begin
            //         ClosingBalanceExcess := ExcessBF;
            //         OpenBalanceExcess := ExcessBF;
            //     end;
            // }
            dataitem(WithdrawableSavings; "Cust. Ledger Entry")
            {
                DataItemLink = "Customer No." = field("No."), "Posting Date" = field("Date Filter");
                DataItemTableView = sorting("Posting Date") where("Transaction Type" = filter("Withdrawable Savings"), Reversed = const(false));

                column(PostingDate_Withdrawable; WithdrawableSavings."Posting Date")
                {
                }
                column(DocumentNo_Withdrawable; WithdrawableSavings."Document No.")
                {
                }
                column(Description_Withdrawable; WithdrawableSavings.Description)
                {
                }
                column(Amount_Withdrawable; WithdrawableSavings."Amount Posted")
                {
                }
                column(UserID_Withdrawable; WithdrawableSavings."User ID")
                {
                }
                column(DebitAmount_Withdrawable; DebitAmount)
                {
                }
                column(CreditAmount_Withdrawable; CreditAmount)
                {
                }
                column(TransactionType_Withdrawable; WithdrawableSavings."Transaction Type")
                {
                }
                column(OpenBalanceWithdrawable; OpenBalanceWithdrawable)
                {
                }
                column(ClosingBalanceWithdrawable; ClosingBalanceWithdrawable)
                {
                }
                column(WithdrawableBF; WithdrawableBF)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    CreditAmount := 0;
                    DebitAmount := 0;
                    if WithdrawableSavings."Amount Posted" < 0 then begin
                        CreditAmount := WithdrawableSavings."Amount Posted" * -1;
                    end else
                        if WithdrawableSavings."Amount Posted" > 0 then begin
                            DebitAmount := WithdrawableSavings."Amount Posted";
                        end;
                    ClosingBalanceWithdrawable := ClosingBalanceWithdrawable + (WithdrawableSavings."Amount Posted" * -1);
                end;

                trigger OnPreDataItem()
                begin
                    ClosingBalanceWithdrawable := WithdrawableBF;
                    OpenBalanceWithdrawable := WithdrawableBF;
                end;
            }

            // Fixed and Enhanced Junior Savings Section
            dataitem(JuniorSavings; "Cust. Ledger Entry")
            {
                DataItemLink = "Posting Date" = field("Date Filter");
                DataItemTableView = sorting("Posting Date") where("Transaction Type" = filter("Junior Savings"), Reversed = const(false));

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
                column(DebitAmount_Junior; DebitAmount)
                {
                }
                column(CreditAmount_Junior; CreditAmount)
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
                column(JuniorAccountNo_Junior; JuniorSavings."Customer No.")
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
                    if JuniorMember.Get(JuniorMemberNo) then
                        JuniorMemberName := JuniorMember.Name
                    else
                        JuniorMemberName := '';
                end;

                trigger OnPreDataItem()
                begin
                    ClosingBalanceJunior := JuniorBF;
                    OpenBalanceJunior := JuniorBF;

                    // Get junior accounts filter for this member (both own and as guardian)
                    JuniorAccountFilter := GetJuniorAccountFilter("Members Register"."No.");

                    if JuniorAccountFilter = '' then
                        CurrReport.Break();

                    JuniorSavings.SetFilter("Customer No.", JuniorAccountFilter);

                    // Apply date filter if exists
                    if "Members Register".GetFilter("Date Filter") <> '' then
                        JuniorSavings.SetFilter("Posting Date", "Members Register".GetFilter("Date Filter"));
                end;
            }

            dataitem(Loans; "Loans Register")
            {
                DataItemLink = "Client Code" = field("No."), "Date filter" = field("Date Filter"), "Loan Product Type" = field("Loan Product Filter");
                DataItemTableView = sorting("Loan  No.") where(Posted = const(true), Reversed = const(false));

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
                column(OutstandingBalance_Loans; Loans."Outstanding Balance")
                {
                }
                column(OustandingInterest_Loans; Loans."Oustanding Interest")
                {
                }
                dataitem(loan; "Cust. Ledger Entry")
                {
                    DataItemLink = "Customer No." = field("Client Code"), "Loan No" = field("Loan  No."), "Posting Date" = field("Date filter");
                    DataItemTableView = sorting("Posting Date") where("Transaction Type" = filter(Loan | "Loan Repayment" | "Interest Due" | "Interest Paid" | "Loan Transfer Charges" | "Unallocated Funds"), Reversed = const(false));

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
                end;

                trigger OnPreDataItem()
                begin
                    Loans.SetFilter(Loans."Date filter", "Members Register".GetFilter("Members Register"."Date Filter"));
                end;
            }

            trigger OnAfterGetRecord()
            begin
                SaccoEmp.Reset;
                SaccoEmp.SetRange(SaccoEmp.Code, "Members Register"."Employer Code");
                if SaccoEmp.Find('-') then
                    EmployerName := SaccoEmp.Description;

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

                if DateFilterBF <> '' then begin
                    Cust.Reset;
                    Cust.SetRange(Cust."No.", "No.");
                    Cust.SetFilter(Cust."Date Filter", DateFilterBF);
                    if Cust.Find('-') then begin
                        Cust.CalcFields(Cust."Shares Retained", Cust."Current Shares", Cust."Insurance Fund", Cust."Dividend Amount");
                        SharesBF := (Cust."Current Shares" * -1);
                        ShareCapBF := (Cust."Shares Retained" * -1);
                        RiskBF := Cust."Insurance Fund";
                        DividendBF := Cust."Dividend Amount";
                    end;

                    // Calculate Junior Savings BF (own and as guardian)
                    JuniorBF := CalculateJuniorSavingsBF("No.", DateFilterBF);

                    // Calculate Withdrawable Savings BF
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

    // Add functions to handle guardian-junior relationships
    local procedure GetJuniorAccountFilter(MemberNo: Code[20]): Text
    var
        JuniorAccounts: Text;
        TempMember: Record Customer;
    begin
        JuniorAccounts := MemberNo; // Include member's own account

        // Add junior accounts where this member is the guardian
        // Assuming you have a "Guardian No." field in Customer table
        TempMember.Reset();
        TempMember.SetRange("Guardian No.", MemberNo);
        if TempMember.FindSet() then
            repeat
                if JuniorAccounts <> '' then
                    JuniorAccounts := JuniorAccounts + '|' + TempMember."No."
                else
                    JuniorAccounts := TempMember."No.";
            until TempMember.Next() = 0;

        exit(JuniorAccounts);
    end;

    local procedure CalculateJuniorSavingsBF(MemberNo: Code[20]; DateFilter: Text): Decimal
    var
        CustLedgerEntry: Record "Cust. Ledger Entry";
        JuniorAccountFilter: Text;
        TotalBF: Decimal;
    begin
        TotalBF := 0;
        JuniorAccountFilter := GetJuniorAccountFilter(MemberNo);

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

    local procedure CalculateWithdrawableSavingsBF(MemberNo: Code[20]; DateFilter: Text): Decimal
    var
        CustLedgerEntry: Record "Cust. Ledger Entry";
        TotalBF: Decimal;
    begin
        TotalBF := 0;

        CustLedgerEntry.Reset();
        CustLedgerEntry.SetRange("Customer No.", MemberNo);
        CustLedgerEntry.SetRange("Transaction Type", CustLedgerEntry."Transaction Type"::"Withdrawable Savings");
        CustLedgerEntry.SetRange(Reversed, false);
        CustLedgerEntry.SetFilter("Posting Date", DateFilter);

        if CustLedgerEntry.FindSet() then
            repeat
                TotalBF := TotalBF + (CustLedgerEntry."Amount Posted" * -1);
            until CustLedgerEntry.Next() = 0;

        exit(TotalBF);
    end;

    var
        OpenBalanceWithdrawable: Decimal;
        WithdrawableBF: Decimal;
        ClosingBalanceWithdrawable: Decimal;
        OpenBalanceJunior: Decimal;
        JuniorBF: Decimal;
        ClosingBalanceJunior: Decimal;
        OpenBalance: Decimal;
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

        // New variables for junior savings functionality
        JuniorMember: Record Customer;
        JuniorMemberNo: Code[20];
        JuniorMemberName: Text[100];
        JuniorAccountFilter: Text;
        ExcessBF: Decimal;
        ClosingBalanceExcess: Decimal;
        OpenBalanceExcess: Decimal;

    protected var
        StartDate: Date;
        EndDate: Date;
}