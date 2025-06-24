report 50200 "Loan Portfolio Analysis"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = './Layout/LoanPortfolioAnalysis.rdlc';
    ProcessingOnly = false;

    dataset
    {
        dataitem("Members Register"; Customer)
        {
            RequestFilterFields = "No.", "Loan Product Filter", "Outstanding Balance", "Date Filter";
            DataItemTableView = sorting("No.");

            column(CustomerName; Name) { }
            column(CustomerNo; "No.") { }
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
            column(Company_Name; CompanyInfo.Name) { }
            column(Company_Address; CompanyInfo.Address) { }
            column(Company_Address_2; CompanyInfo."Address 2") { }
            column(Company_Phone_No; CompanyInfo."Phone No.") { }
            column(Company_Fax_No; CompanyInfo."Fax No.") { }
            column(Company_Picture; CompanyInfo.Picture) { }
            column(Company_Email; CompanyInfo."E-Mail") { }
            column(TotalMemberOutstandingBalance; TotalMemberOutstandingBalance) { DecimalPlaces = 2 : 2; }

            dataitem(Loans; "Loans Register")
            {
                DataItemLink = "Client Code" = field("No."),
                             "Date Filter" = field("Date Filter"),
                             "Loan Product Type" = field("Loan Product Filter");
                DataItemTableView = sorting("Loan  No.") where(Posted = const(true), Reversed = const(false));

                column(LoanNumber; "Loan  No.") { }
                column(ProductType; "Loan Product Type Name") { }
                column(Amount_in_Arrears; "Amount in Arrears") { DecimalPlaces = 2 : 2; }
                column(Interest_In_Arrears; "Interest In Arrears") { DecimalPlaces = 2 : 2; }
                column(Principal_In_Arrears; "Principal In Arrears") { DecimalPlaces = 2 : 2; }
                column(DaysInArrears; DaysInArrears) { }
                column(IsDefaulted; IsLoanDefaulted)
                {
                }

                column(RepaymentCompliance; RepaymentCompliance) { DecimalPlaces = 2 : 2; }
                column(Outstanding_Balance; "Outstanding Balance") { DecimalPlaces = 2 : 2; }
                column(Outstanding_Interest; "Oustanding Interest") { DecimalPlaces = 2 : 2; }
                column(ExpectedOutstandingBalance; ExpectedOutstandingBalance) { DecimalPlaces = 2 : 2; }
                column(ExpectedOutstandingInterest; ExpectedOutstandingInterest) { DecimalPlaces = 2 : 2; }

                trigger OnPreDataItem()
                var
                    RecordCount: Integer;
                begin
                    RecordCount := Count;
                    if RecordCount > BatchSize then
                        ProcessInBatches := true;
                end;

                trigger OnAfterGetRecord()
                begin
                    if not ProcessCurrentRecord() then
                        CurrReport.Skip();

                    CalcFields("Outstanding Balance", "Interest Due", "Oustanding Interest");

                    // Calculate key metrics
                    DaysInArrears := GetDaysInArrears(Loans);
                    IsLoanDefaulted := IsDefaulted(Loans);
                    RepaymentCompliance := CalcRepaymentCompliance(Loans);

                    // Update loan status
                    UpdateLoanStatus();

                    // Calculate and update arrears
                    CalcManualArrears(Loans);

                    // Calculate expected outstanding balance and interest
                    ExpectedOutstandingBalance := GetExpectedOutstandingBalance(Loans, Today);
                    ExpectedOutstandingInterest := GetExpectedOutstandingInterest(Loans, Today);
                end;
            }
        }
        dataitem("Loan Products Setup"; "Loan Products Setup")
        {
            RequestFilterFields = "Code", Source;

            column(ProductCode; "Code") { }
            column(ProductDescription; "Product Description") { }
            column(Interest_rate; "Interest rate") { DecimalPlaces = 2 : 2; }
            column(TotalDisbursed; TotalDisbursed) { DecimalPlaces = 2 : 2; }
            column(InterestEarned; InterestEarned) { DecimalPlaces = 2 : 2; }
            column(ArrearsAmount; ArrearsAmount) { DecimalPlaces = 2 : 2; }
            column(Max__Loan_Amount; "Max. Loan Amount") { DecimalPlaces = 2 : 2; }
            column(Loan_Account; "Loan Account") { }
            column(ActiveLoans; ActiveLoans) { }
            column(Repayment_Method; "Repayment Method") { }
            column(DefaultRate; DefaultRate) { DecimalPlaces = 2 : 2; }
            // column(RepaymentRate; RepaymentRate) { DecimalPlaces = 2 : 2; }
            column(Instalment_Period; "Instalment Period") { }
            column(Max_Installments; "No of Installment") { }
            column(TotalRepaymentsDue; TotalRepaymentsDue) { }
            column(TotalRepaidOnTime; TotalRepaidOnTime) { }
            column(Issued_Amount; "Issued Amount") { DecimalPlaces = 2 : 2; }
            column(MemberLoanNumber; MemberLoanNumber) { }
            column(MemberOutstandingBalance; MemberOutstandingBalance) { DecimalPlaces = 2 : 2; }
            column(MemberOutstandingInterest; MemberOutstandingInterest) { DecimalPlaces = 2 : 2; }
            column(MemberExpectedOustandingBalance; MemberExpectedOustandingBalance) { DecimalPlaces = 2 : 2; }
            column(MemberExpectedOustandingInterest; MemberExpectedOustandingInterest) { DecimalPlaces = 2 : 2; }

            trigger OnAfterGetRecord()
            var
                Loans: Record "Loans Register";
            begin
                Clear(TotalDisbursed);
                Clear(InterestEarned);
                Clear(ArrearsAmount);
                Clear(ActiveLoans);
                Clear(DefaultCount);
                Clear(DefaultRate);
                Clear(TotalRepaymentsDue);
                Clear(TotalRepaidOnTime);
                Clear(RepaymentRate);
                Clear(MemberLoanNumber);
                Clear(MemberOutstandingBalance);
                Clear(MemberOutstandingInterest);
                Clear(MemberExpectedOustandingBalance);
                Clear(MemberExpectedOustandingInterest);

                Loans.Reset();
                Loans.SetRange("Client Code", "Members Register"."No.");
                Loans.SetRange("Loan Product Type", "Loan Products Setup".Code);
                Loans.SetRange(Posted, true);
                Loans.SetRange(Reversed, false);
                if Loans.FindFirst() then begin
                    Loans.CalcFields("Outstanding Balance", "Oustanding Interest");

                    MemberLoanNumber := Loans."Loan  No.";
                    MemberOutstandingBalance := Loans."Outstanding Balance";
                    MemberOutstandingInterest := Loans."Oustanding Interest";

                    MemberExpectedOustandingBalance := GetExpectedOutstandingBalance(Loans, Today);
                    MemberExpectedOustandingInterest := GetExpectedOutstandingInterest(Loans, Today);

                    TotalMemberOutstandingBalance += MemberOutstandingBalance;
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
                group(Filters)
                {
                    field(StartDateField; StartDate)
                    {
                        ApplicationArea = All;
                        Caption = 'Start Date';
                    }
                    field(EndDateField; EndDate)
                    {
                        ApplicationArea = All;
                        Caption = 'End Date';
                    }
                    field(BatchSizeField; BatchSize)
                    {
                        ApplicationArea = All;
                        Caption = 'Batch Size';
                        ToolTip = 'Specify the number of records to process in each batch';
                        MinValue = 100;
                        MaxValue = 5000;
                    }
                }
            }
        }

        trigger OnOpenPage()
        begin
            if BatchSize = 0 then
                BatchSize := 1000;
        end;
    }

    trigger OnPreReport()
    begin
        if (StartDate > EndDate) and (StartDate <> 0D) and (EndDate <> 0D) then
            Error('Start Date must be before End Date');

        CompanyInfo.Get();
        CompanyInfo.TestField(Name);

        InitializeVariables();
    end;

    var
        CompanyInfo: Record "Company Information";
        StartDate: Date;
        EndDate: Date;
        BatchSize: Integer;
        ProcessInBatches: Boolean;
        Window: Dialog;
        DaysInArrears: Integer;
        IsLoanDefaulted: Boolean;
        RepaymentCompliance: Decimal;
        EmployerName: Text[100];
        TotalRecords: Integer;
        CurrentRecord: Integer;
        DialogText: Label 'Processing Record #@1@@ of @2@@';
        ExpectedOutstandingBalance: Decimal;
        ExpectedOutstandingInterest: Decimal;
        TotalMemberOutstandingBalance: Decimal;
        MemberLoanNumber: Code[20];
        MemberOutstandingBalance: Decimal;
        MemberOutstandingInterest: Decimal;
        MemberExpectedOustandingBalance: Decimal;
        MemberExpectedOustandingInterest: Decimal;

    local procedure InitializeVariables()
    begin
        ProcessInBatches := false;
        TotalRecords := 0;
        CurrentRecord := 0;

        if GuiAllowed then
            Window.Open(DialogText);
    end;

    local procedure ProcessCurrentRecord(): Boolean
    begin
        CurrentRecord += 1;

        if GuiAllowed then begin
            Window.Update(1, CurrentRecord);
            Window.Update(2, TotalRecords);
        end;

        exit(true);
    end;

    local procedure IsDefaulted(var Loan: Record "Loans Register"): Boolean
    var
        MinimumPaymentsMissed: Integer;
        ConsecutiveMissedPayments: Integer;
    begin
        if GetDaysInArrears(Loan) > 90 then
            exit(true);

        MinimumPaymentsMissed := GetMissedPayments(Loan);
        ConsecutiveMissedPayments := GetConsecutiveMissedPayments(Loan);

        exit((MinimumPaymentsMissed >= 3) or (ConsecutiveMissedPayments >= 2));
    end;

    local procedure GetDaysInArrears(var Loan: Record "Loans Register"): Integer
    var
        LastPaymentDate: Date;
    begin
        if Loan."Issued Date" = 0D then
            exit(0);

        LastPaymentDate := GetLastPaymentDate(Loan);
        if LastPaymentDate = 0D then
            exit(Today - Loan."Issued Date")
        else
            exit(Today - LastPaymentDate);
    end;

    local procedure GetLastPaymentDate(var Loan: Record "Loans Register"): Date
    var
        CustLedger: Record "Cust. Ledger Entry";
    begin
        CustLedger.Reset();
        CustLedger.SetRange("Loan No", Loan."Loan  No.");
        CustLedger.SetRange("Transaction Type", CustLedger."Transaction Type"::"Loan Repayment");
        CustLedger.SetRange(Reversed, false);
        if CustLedger.FindLast() then
            exit(CustLedger."Posting Date");
        exit(0D);
    end;

    local procedure GetMissedPayments(var Loan: Record "Loans Register"): Integer
    var
        RepaymentSchedule: Record "Loan Repayment Schedule";
        MissedCount: Integer;
    begin
        RepaymentSchedule.Reset();
        RepaymentSchedule.SetRange("Loan No.", Loan."Loan  No.");
        RepaymentSchedule.SetFilter("Repayment Date", '..%1', Today);

        if RepaymentSchedule.FindSet() then
            repeat
                if not IsPaymentMade(Loan."Loan  No.", RepaymentSchedule."Repayment Date") then
                    MissedCount += 1;
            until RepaymentSchedule.Next() = 0;

        exit(MissedCount);
    end;

    local procedure GetConsecutiveMissedPayments(var Loan: Record "Loans Register"): Integer
    var
        RepaymentSchedule: Record "Loan Repayment Schedule";
        ConsecutiveCount: Integer;
        MaxConsecutive: Integer;
    begin
        RepaymentSchedule.Reset();
        RepaymentSchedule.SetRange("Loan No.", Loan."Loan  No.");
        RepaymentSchedule.SetFilter("Repayment Date", '..%1', Today);
        RepaymentSchedule.SetCurrentKey("Repayment Date");

        if RepaymentSchedule.FindSet() then
            repeat
                if not IsPaymentMade(Loan."Loan  No.", RepaymentSchedule."Repayment Date") then
                    ConsecutiveCount += 1
                else begin
                    if ConsecutiveCount > MaxConsecutive then
                        MaxConsecutive := ConsecutiveCount;
                    ConsecutiveCount := 0;
                end;
            until RepaymentSchedule.Next() = 0;

        if ConsecutiveCount > MaxConsecutive then
            MaxConsecutive := ConsecutiveCount;

        exit(MaxConsecutive);
    end;

    local procedure IsPaymentMade(LoanNo: Code[20]; DueDate: Date): Boolean
    var
        CustLedger: Record "Cust. Ledger Entry";
        PaymentAmount: Decimal;
    begin
        CustLedger.Reset();
        CustLedger.SetRange("Loan No", LoanNo);
        CustLedger.SetRange("Transaction Type", CustLedger."Transaction Type"::"Loan Repayment");
        CustLedger.SetRange("Posting Date", 0D, DueDate);
        CustLedger.SetRange(Reversed, false);

        if CustLedger.FindSet() then begin
            repeat
                PaymentAmount += Abs(CustLedger.Amount);
            until CustLedger.Next() = 0;
            exit(PaymentAmount > 0);
        end;
        exit(false);
    end;

    local procedure CalcManualArrears(var Loan: Record "Loans Register")
    var
        TotalExpected: Decimal;
        TotalPaid: Decimal;
    begin
        if Loan."Issued Date" = 0D then
            exit;

        // Calculate total expected payments
        TotalExpected := GetTotalExpectedPayments(Loan);

        // Calculate total actual payments
        TotalPaid := GetTotalActualPayments(Loan);

        // Update arrears with proper validation
        if TotalExpected > TotalPaid then begin
            Loan."Amount in Arrears" := TotalExpected - TotalPaid;
            Loan."Principal In Arrears" := GetPrincipalInArrears(Loan);
            Loan."Interest In Arrears" := GetInterestInArrears(Loan);
            Loan.Modify();
        end;
    end;

    local procedure GetTotalExpectedPayments(var Loan: Record "Loans Register"): Decimal
    var
        RepaymentSchedule: Record "Loan Repayment Schedule";
        TotalExpected: Decimal;
    begin
        RepaymentSchedule.Reset();
        RepaymentSchedule.SetRange("Loan No.", Loan."Loan  No.");
        RepaymentSchedule.SetFilter("Repayment Date", '..%1', Today);

        if RepaymentSchedule.FindSet() then
            repeat
                TotalExpected += RepaymentSchedule."Principal Repayment" + RepaymentSchedule."Monthly Interest";
            until RepaymentSchedule.Next() = 0;

        exit(TotalExpected);
    end;

    local procedure GetTotalActualPayments(var Loan: Record "Loans Register"): Decimal
    var
        CustLedger: Record "Cust. Ledger Entry";
        TotalPaid: Decimal;
    begin
        CustLedger.Reset();
        CustLedger.SetRange("Loan No", Loan."Loan  No.");
        CustLedger.SetRange("Transaction Type", CustLedger."Transaction Type"::"Loan Repayment");
        CustLedger.SetRange(Reversed, false);

        if CustLedger.FindSet() then
            repeat
                TotalPaid += Abs(CustLedger.Amount);
            until CustLedger.Next() = 0;

        exit(TotalPaid);
    end;

    local procedure GetPrincipalInArrears(var Loan: Record "Loans Register"): Decimal
    var
        RepaymentSchedule: Record "Loan Repayment Schedule";
        ExpectedPrincipal: Decimal;
        PaidPrincipal: Decimal;
    begin
        RepaymentSchedule.Reset();
        RepaymentSchedule.SetRange("Loan No.", Loan."Loan  No.");
        RepaymentSchedule.SetFilter("Repayment Date", '..%1', Today);

        if RepaymentSchedule.FindSet() then
            repeat
                ExpectedPrincipal += RepaymentSchedule."Principal Repayment";
            until RepaymentSchedule.Next() = 0;

        PaidPrincipal := GetPaidPrincipal(Loan);

        if ExpectedPrincipal > PaidPrincipal then
            exit(ExpectedPrincipal - PaidPrincipal)
        else
            exit(0);
    end;

    local procedure GetInterestInArrears(var Loan: Record "Loans Register"): Decimal
    var
        RepaymentSchedule: Record "Loan Repayment Schedule";
        ExpectedInterest: Decimal;
        PaidInterest: Decimal;
    begin
        RepaymentSchedule.Reset();
        RepaymentSchedule.SetRange("Loan No.", Loan."Loan  No.");
        RepaymentSchedule.SetFilter("Repayment Date", '..%1', Today);

        if RepaymentSchedule.FindSet() then
            repeat
                ExpectedInterest += RepaymentSchedule."Monthly Interest";
            until RepaymentSchedule.Next() = 0;

        PaidInterest := GetPaidInterest(Loan);

        if ExpectedInterest > PaidInterest then
            exit(ExpectedInterest - PaidInterest)
        else
            exit(0);
    end;

    local procedure GetPaidPrincipal(var Loan: Record "Loans Register"): Decimal
    var
        CustLedger: Record "Cust. Ledger Entry";
        PaidAmount: Decimal;
    begin
        CustLedger.Reset();
        CustLedger.SetRange("Loan No", Loan."Loan  No.");
        CustLedger.SetRange("Transaction Type", CustLedger."Transaction Type"::"Loan Repayment");
        CustLedger.SetRange(Reversed, false);

        if CustLedger.FindSet() then
            repeat
                PaidAmount += Abs(CustLedger.Amount);
            until CustLedger.Next() = 0;

        exit(PaidAmount);
    end;

    local procedure GetPaidInterest(var Loan: Record "Loans Register"): Decimal
    var
        CustLedger: Record "Cust. Ledger Entry";
        PaidAmount: Decimal;
    begin
        CustLedger.Reset();
        CustLedger.SetRange("Loan No", Loan."Loan  No.");
        CustLedger.SetRange("Transaction Type", CustLedger."Transaction Type"::"Interest Paid");
        CustLedger.SetRange(Reversed, false);

        if CustLedger.FindSet() then
            repeat
                PaidAmount += Abs(CustLedger.Amount);
            until CustLedger.Next() = 0;

        exit(PaidAmount);
    end;

    local procedure CalcRepaymentCompliance(var Loan: Record "Loans Register"): Decimal
    var
        TotalScheduled: Integer;
        OnTimePayments: Integer;
    begin
        GetRepaymentStats(Loan, TotalScheduled, OnTimePayments);

        if TotalScheduled > 0 then
            exit(Round((OnTimePayments / TotalScheduled) * 100, 0.01))
        else
            exit(0);
    end;

    local procedure GetRepaymentStats(var Loan: Record "Loans Register"; var TotalScheduled: Integer; var OnTimePayments: Integer)
    var
        RepaymentSchedule: Record "Loan Repayment Schedule";
    begin
        RepaymentSchedule.Reset();
        RepaymentSchedule.SetRange("Loan No.", Loan."Loan  No.");
        RepaymentSchedule.SetFilter("Repayment Date", '..%1', Today);

        if RepaymentSchedule.FindSet() then
            repeat
                TotalScheduled += 1;
                if IsPaymentOnTime(Loan."Loan  No.", RepaymentSchedule."Repayment Date",
                   RepaymentSchedule."Principal Repayment" + RepaymentSchedule."Monthly Interest") then
                    OnTimePayments += 1;
            until RepaymentSchedule.Next() = 0;
    end;

    local procedure IsPaymentOnTime(LoanNo: Code[20]; DueDate: Date; ExpectedAmount: Decimal): Boolean
    var
        CustLedger: Record "Cust. Ledger Entry";
        PaymentAmount: Decimal;
        GracePeriod: Integer;
        LastPaymentDate: Date;
    begin
        GracePeriod := 5; // 5 days grace period for payment

        CustLedger.Reset();
        CustLedger.SetRange("Loan No", LoanNo);
        CustLedger.SetRange("Transaction Type", CustLedger."Transaction Type"::"Loan Repayment");
        CustLedger.SetRange("Posting Date", 0D, DueDate + GracePeriod);
        CustLedger.SetRange(Reversed, false);

        if CustLedger.FindSet() then begin
            repeat
                PaymentAmount += Abs(CustLedger.Amount);
                if CustLedger."Posting Date" > LastPaymentDate then
                    LastPaymentDate := CustLedger."Posting Date";
            until CustLedger.Next() = 0;

            exit((PaymentAmount >= ExpectedAmount) and (LastPaymentDate <= (DueDate + GracePeriod)));
        end;
        exit(false);
    end;

    local procedure UpdateLoanStatus()
    begin
        if IsLoanDefaulted then begin
            Loans."Loan Status" := Loans."Loan Status"::Rejected;
            Loans.Modify();
        end;
    end;

    var
        TotalDisbursed: Decimal;
        InterestEarned: Decimal;
        ArrearsAmount: Decimal;
        ActiveLoans: Integer;
        DefaultCount: Integer;
        DefaultRate: Decimal;
        TotalRepaymentsDue: Integer;
        TotalRepaidOnTime: Integer;
        RepaymentRate: Decimal;
        PrincipleBF: Decimal;
        CalcAmountInArrears: Decimal;
        CalcInterestArrears: Decimal;
        CalcPrincipalArrears: Decimal;

    local procedure GetExpectedOutstandingBalance(var Loan: Record "Loans Register"; AsOfDate: Date): Decimal
    var
        RepaymentSchedule: Record "Loan Repayment Schedule";
        ScheduledPrincipalPaid: Decimal;
    begin
        RepaymentSchedule.Reset();
        RepaymentSchedule.SetRange("Loan No.", Loan."Loan  No.");
        RepaymentSchedule.SetFilter("Repayment Date", '..%1', AsOfDate);

        if RepaymentSchedule.FindSet() then
            repeat
                ScheduledPrincipalPaid += RepaymentSchedule."Principal Repayment";
            until RepaymentSchedule.Next() = 0;

        exit(Loan."Approved Amount" - ScheduledPrincipalPaid);
    end;

    local procedure GetExpectedOutstandingInterest(var Loan: Record "Loans Register"; AsOfDate: Date): Decimal
    var
        RepaymentSchedule: Record "Loan Repayment Schedule";
        ScheduledInterestUnpaid: Decimal;
    begin
        RepaymentSchedule.Reset();
        RepaymentSchedule.SetRange("Loan No.", Loan."Loan  No.");
        RepaymentSchedule.SetFilter("Repayment Date", '%1..', AsOfDate + 1); // Payments after AsOfDate

        if RepaymentSchedule.FindSet() then
            repeat
                ScheduledInterestUnpaid += RepaymentSchedule."Monthly Interest";
            until RepaymentSchedule.Next() = 0;

        exit(ScheduledInterestUnpaid);
    end;
}

