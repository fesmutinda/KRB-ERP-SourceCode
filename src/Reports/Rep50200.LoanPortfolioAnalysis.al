report 50200 "Loan Portfolio Analysis"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = './Layout/LoanPortfolioAnalysis.rdlc';

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
            column(Company_Name; Company.Name) { }
            column(Company_Address; Company.Address) { }
            column(Company_Address_2; Company."Address 2") { }
            column(Company_Phone_No; Company."Phone No.") { }
            column(Company_Fax_No; Company."Fax No.") { }
            column(Company_Picture; Company.Picture) { }
            column(Company_Email; Company."E-Mail") { }
        }

        dataitem(Loans; "Loans Register")
        {
            //  DataItemLink = "Client Code" = field("No."), "Date filter" = field("Date Filter"), "Loan Product Type" = field("Loan Product Filter");
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
            { }
            column(Amount_in_Arrears; "Amount in Arrears") { DecimalPlaces = 2 : 2; }
            column(Interest_In_Arrears; "Interest In Arrears") { DecimalPlaces = 2 : 2; }
            column(Principal_In_Arrears; "Principal In Arrears") { DecimalPlaces = 2 : 2; }


              trigger OnAfterGetRecord()
    begin
        CalcManualArrears(Loans);
    end;

            
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

            trigger OnAfterGetRecord()
            var
                LoansReg: Record "Loans Register";
                CustLedger: Record "Cust. Ledger Entry";
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

                LoansReg.Reset();
                LoansReg.SetRange("Loan Product Type", Code);
                if (StartDate <> 0D) and (EndDate <> 0D) then
                    LoansReg.SetRange("Application Date", StartDate, EndDate);
                LoansReg.SetRange(Posted, true);

                if LoansReg.FindSet() then begin
                    repeat
                        TotalDisbursed += LoansReg."Approved Amount";
                        LoansReg.CalcFields("Outstanding Balance", "Interest Due", "Oustanding Interest");

                        if LoansReg."Outstanding Balance" > 0 then
                            ActiveLoans += 1;

                        CustLedger.Reset();
                        CustLedger.SetRange("Loan No", LoansReg."Loan  No.");
                        CustLedger.SetRange("Transaction Type", CustLedger."Transaction Type"::"Interest Paid");
                        if (StartDate <> 0D) and (EndDate <> 0D) then
                            CustLedger.SetRange("Posting Date", StartDate, EndDate);
                        if CustLedger.FindSet() then
                            repeat
                                InterestEarned += Abs(CustLedger.Amount);
                            until CustLedger.Next() = 0;

                        InterestEarned += LoansReg."Interest Due" + LoansReg."Oustanding Interest";
                        ArrearsAmount += LoansReg."Amount in Arrears";

                        if IsDefaulted(LoansReg) then
                            DefaultCount += 1;

                        UpdateRepaymentTracking(LoansReg);
                    until LoansReg.Next() = 0;

                    if ActiveLoans > 0 then
                        DefaultRate := (DefaultCount / ActiveLoans) * 100;

                    if TotalRepaymentsDue > 0 then
                        RepaymentRate := (TotalRepaidOnTime / TotalRepaymentsDue) * 100;
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
                }
            }
        }
    }

    trigger OnPreReport()
    begin
        if (StartDate > 0D) and (EndDate > 0D) and (StartDate > EndDate) then
            Error('Start Date must be before End Date');

        Clear(TotalDisbursed);
        Clear(InterestEarned);
        Clear(ArrearsAmount);
        Clear(ActiveLoans);
        Clear(DefaultCount);
        Clear(DefaultRate);
        Clear(TotalRepaymentsDue);
        Clear(TotalRepaidOnTime);
        Clear(RepaymentRate);
    end;

    local procedure IsDefaulted(var Loan: Record "Loans Register"): Boolean
    begin
        exit(GetDaysInArrears(Loan) > 90);
    end;

    local procedure GetDaysInArrears(var Loan: Record "Loans Register"): Integer
    var
        LastPaymentDate: Date;
    begin
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
        if CustLedger.FindLast() then
            exit(CustLedger."Posting Date");
        exit(0D);
    end;

    local procedure UpdateRepaymentTracking(var Loan: Record "Loans Register")
    var
        RepaymentSchedule: Record "Loan Repayment Schedule";
        CustLedger: Record "Cust. Ledger Entry";
        PaymentAmount: Decimal;
    begin
        RepaymentSchedule.Reset();
        RepaymentSchedule.SetRange("Loan No.", Loan."Loan  No.");
        if (StartDate <> 0D) and (EndDate <> 0D) then
            RepaymentSchedule.SetRange("Repayment Date", StartDate, EndDate);

        if RepaymentSchedule.FindSet() then begin
            repeat
                TotalRepaymentsDue += 1;
                PaymentAmount := 0;

                CustLedger.Reset();
                CustLedger.SetRange("Loan No", Loan."Loan  No.");
                CustLedger.SetRange("Transaction Type", CustLedger."Transaction Type"::"Loan Repayment");
                CustLedger.SetRange("Posting Date", 0D, RepaymentSchedule."Repayment Date");
                if CustLedger.FindSet() then begin
                    repeat
                        PaymentAmount += Abs(CustLedger.Amount);
                    until CustLedger.Next() = 0;

                    // A repayment is on time if the payment amount meets or exceeds the scheduled principal
                    if PaymentAmount >= RepaymentSchedule."Principal Repayment" then
                        TotalRepaidOnTime += 1
                    else if PaymentAmount < RepaymentSchedule."Principal Repayment" then
                        ArrearsAmount += (RepaymentSchedule."Principal Repayment" - PaymentAmount);
                end;
            until RepaymentSchedule.Next() = 0;
        end;
    end;

local procedure CalcManualArrears(var Loan: Record "Loans Register")
var
    RepaymentSchedule: Record "Loan Repayment Schedule";
    CustLedger: Record "Cust. Ledger Entry";
    PaidAmount: Decimal;
    PaidInterest: Decimal;
    PaidPrincipal: Decimal;
begin
    CalcAmountInArrears := 0;
    CalcInterestArrears := 0;
    CalcPrincipalArrears := 0;

    RepaymentSchedule.Reset();
    RepaymentSchedule.SetRange("Loan No.", Loan."Loan  No.");
    RepaymentSchedule.SetFilter("Repayment Date", '..%1', Today); // Only past due

    if RepaymentSchedule.FindSet() then
        repeat
            PaidAmount := 0;
            PaidInterest := 0;
            PaidPrincipal := 0;

            CustLedger.Reset();
            CustLedger.SetRange("Loan No", Loan."Loan  No.");
            CustLedger.SetRange("Posting Date", 0D, RepaymentSchedule."Repayment Date");
            CustLedger.SetFilter("Transaction Type", '%1|%2',
                CustLedger."Transaction Type"::"Loan Repayment",
                CustLedger."Transaction Type"::"Interest Paid");

            if CustLedger.FindSet() then
                repeat
                    case CustLedger."Transaction Type" of
                        CustLedger."Transaction Type"::"Loan Repayment":
                            PaidPrincipal += Abs(CustLedger.Amount);
                        CustLedger."Transaction Type"::"Interest Paid":
                            PaidInterest += Abs(CustLedger.Amount);
                    end;
                until CustLedger.Next() = 0;            if PaidPrincipal < RepaymentSchedule."Principal Repayment" then
                CalcPrincipalArrears += (RepaymentSchedule."Principal Repayment" - PaidPrincipal);

            if PaidInterest < RepaymentSchedule."Monthly Interest" then
                CalcInterestArrears += (RepaymentSchedule."Monthly Interest" - PaidInterest);

        until RepaymentSchedule.Next() = 0;

    CalcAmountInArrears := CalcPrincipalArrears + CalcInterestArrears;
end;


    var
        StartDate: Date;
        EndDate: Date;
        TotalDisbursed: Decimal;
        InterestEarned: Decimal;
        ArrearsAmount: Decimal;
        ActiveLoans: Integer;
        DefaultCount: Integer;
        DefaultRate: Decimal;
        TotalRepaymentsDue: Integer;
        TotalRepaidOnTime: Integer;
        RepaymentRate: Decimal;
        Company: Record "Company Information";
        EmployerName: Text[100];
        PrincipleBF: Decimal;
    CalcAmountInArrears: Decimal;
    CalcInterestArrears: Decimal;
    CalcPrincipalArrears: Decimal;


}
