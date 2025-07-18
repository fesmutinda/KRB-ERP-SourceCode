Report 56522 "Member Statement Deposits"
{
    DefaultLayout = RDLC;
    Caption = 'Member Deposit Statement';
    RDLCLayout = './Layout/Member Statement deposits.rdlc';

    dataset
    {
        dataitem("Members Register"; customer)
        {
            RequestFilterFields = "No.", "Date Filter";
            column(ReportForNavId_1102755000; 1102755000)
            {
            }
            column(USERID; UserId)
            {
            }
            column(PayrollStaffNo_Members; "Members Register"."Payroll/Staff No")
            {
            }
            column(Registration_Date; "Registration Date") { }
            column(Phone_No_; "Phone No.") { }
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
            column(StartDate_Filter; StartDate)
            {
            }
            column(EndDate_Filter; EndDate)
            {
            }
            column(DateRange_Text; 'From ' + Format(StartDate) + ' To ' + Format(EndDate))
            {
            }
            dataitem(ShareCapital; "Cust. Ledger Entry")
            {
                DataItemLink = "Customer No." = field("No."), "Posting Date" = field("Date Filter");
                DataItemTableView = sorting("Posting Date") where("Transaction Type" = filter("Share Capital"), Reversed = const(false));
                column(ReportForNavId_1000000009; 1000000009)
                {
                }
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
                    if (StartDate <> 0D) and (EndDate <> 0D) then
                        ShareCapital.SetFilter("Posting Date", Format(StartDate) + '..' + Format(EndDate));
                end;
            }
            dataitem(Deposits; "Cust. Ledger Entry")
            {
                DataItemLink = "Customer No." = field("No."), "Posting Date" = field("Date Filter");
                DataItemTableView = sorting("Posting Date") where("Transaction Type" = filter("Deposit Contribution"), Reversed = const(false));
                column(ReportForNavId_1000000036; 1000000036)
                {
                }
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
                column(DebitAmount_Deposits; debitamount)
                {
                }
                column(CreditAmount_Deposits; creditamount)
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
                    if (StartDate <> 0D) and (EndDate <> 0D) then
                        Deposits.SetFilter("Posting Date", Format(StartDate) + '..' + Format(EndDate));
                end;
            }
            dataitem(Dividend; "Cust. Ledger Entry")
            {
                DataItemLink = "Customer No." = field("No."), "Posting Date" = field("Date Filter");
                DataItemTableView = sorting("Posting Date") where("Transaction Type" = filter(Dividend), Reversed = const(false));
                column(ReportForNavId_1000000059; 1000000059)
                {
                }
                column(PostingDate_Dividend; Dividend."Posting Date")
                {
                }
                column(DocumentNo_Dividend; Dividend."Document No.")
                {
                }
                column(Description_Dividend; Dividend.Description)
                {
                }
                column(Amount_Dividend; Dividend."Amount Posted")
                {
                }
                column(UserID_Dividend; Dividend."User ID")
                {
                }
                column(TransactionType_Dividend; Dividend."Transaction Type")
                {
                }
                column(DebitAmount_Dividend; debitamount)
                {
                }
                column(CreditAmount_Dividend; creditamount)
                {
                }
                column(OpenBalanceDividend; OpenBalanceDividend)
                {
                }
                column(ClosingBalanceDividend; ClosingBalanceDividend)
                {
                }
                column(DividendBF; DividendBF)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    CreditAmount := 0;
                    DebitAmount := 0;
                    if Dividend."Amount Posted" < 0 then begin
                        CreditAmount := Dividend."Amount Posted" * -1;
                    end else
                        if Dividend."Amount Posted" > 0 then begin
                            DebitAmount := Dividend."Amount Posted";
                        end;
                    ClosingBalanceDividend := ClosingBalanceDividend + (Dividend."Amount Posted" * -1);
                end;

                trigger OnPreDataItem()
                begin
                    ClosingBalanceDividend := DividendBF;
                    OpenBalanceDividend := DividendBF;
                    if (StartDate <> 0D) and (EndDate <> 0D) then
                        Dividend.SetFilter("Posting Date", Format(StartDate) + '..' + Format(EndDate));
                end;
            }
            dataitem(Khoja; "Cust. Ledger Entry")
            {
                DataItemLink = "Customer No." = field("No."), "Posting Date" = field("Date Filter");
                DataItemTableView = sorting("Posting Date") where("Transaction Type" = filter("Withdrawable Savings"), Reversed = const(false));
                column(ReportForNavId_1000000071; 1000000071)
                {
                }
                column(PostingDate_Khoja; Khoja."Posting Date")
                {
                }
                column(DocumentNo_Khoja; Khoja."Document No.")
                {
                }
                column(Description_Khoja; Khoja.Description)
                {
                }
                column(Amount_Khoja; Khoja."Amount Posted")
                {
                }
                column(UserID_Khoja; Khoja."User ID")
                {
                }
                column(DebitAmount_Khoja; debitamount)
                {
                }
                column(CreditAmount_Khoja; creditamount)
                {
                }
                column(TransactionType_Khoja; Khoja."Transaction Type")
                {
                }
                column(OpenBalanceKhoja; OpenBalanceKhoja)
                {
                }
                column(ClosingBalanceKhoja; ClosingBalanceKhoja)
                {
                }
                column(KhojaBF; KhojaBF)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    CreditAmount := 0;
                    DebitAmount := 0;
                    if Khoja."Amount Posted" < 0 then begin
                        CreditAmount := Khoja."Amount Posted" * -1;
                    end else
                        if Khoja."Amount Posted" > 0 then begin
                            DebitAmount := Khoja."Amount Posted";
                        end;
                    ClosingBalanceKhoja := ClosingBalanceKhoja + (Khoja."Amount Posted" * -1);
                end;

                trigger OnPreDataItem()
                begin
                    ClosingBalanceKhoja := KhojaBF;
                    OpenBalanceKhoja := KhojaBF;
                    if (StartDate <> 0D) and (EndDate <> 0D) then
                        Khoja.SetFilter("Posting Date", Format(StartDate) + '..' + Format(EndDate));
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
                column(ProductType; LoanName)
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
                        if (StartDate <> 0D) and (EndDate <> 0D) then
                            loan.SetFilter("Posting Date", Format(StartDate) + '..' + Format(EndDate));
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
                    if (StartDate <> 0D) and (EndDate <> 0D) then
                        Loans.SetFilter("Date filter", Format(StartDate) + '..' + Format(EndDate));
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

    var
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
        KhojaBF: Decimal;
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
        OpenBalanceKhoja: Decimal;
        ClosingBalanceKhoja: Decimal;
        StartDate: Date;
        EndDate: Date;
}

