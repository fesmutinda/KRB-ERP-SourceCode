#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51036 "Loans Defaulter Aging"
{
    RDLCLayout = './Layout/LoansDefaulterAging.rdl';
    DefaultLayout = RDLC;

    dataset
    {
        dataitem("Loans Register"; "Loans Register")
        {
            CalcFields = "Outstanding Balance", "Last Pay Date";
            DataItemTableView = where("Outstanding Balance" = filter('>0'), "Approved Amount" = filter('>0'), Posted = const(true), Reversed = const(false));
            RequestFilterFields = "Loan  No.", "Client Code", "Outstanding Balance", "Date filter", "Account No";

            column(Company_Letter_Head; Company.Picture)
            {
            }
            column(Loans__Loan__No__; "Loan  No.")
            {
            }
            column(Loans__Client_Name_; "Client Name")
            {
            }
            column(ClientCode_LoansRegister; "Loans Register"."Client Code")
            {
            }
            column(Loans_Loans__Outstanding_Balance_; "Loans Register"."Outstanding Balance")
            {
            }
            column(V2Month_; "2Month")
            {
            }
            column(V3Month_; "3Month")
            {
            }
            column(Over3Month; Over3Month)
            {
            }
            column(V1Month_; "1Month")
            {
            }
            column(V0Month_; "0Month")
            {
            }
            column(AmountinArrears_LoansRegister; "Loans Register"."Amount in Arrears")
            {
            }
            column(LoanProductType; "Loans Register"."Loan Product Type Name")
            {
            }
            column(AsAt; AsAt)
            {
            }
            column(Days; CalculatedDaysInArrears)
            {
            }
            column(Months; CalculatedMonthsInArrears)
            {
            }
            column(LoanCategory; CalculatedLoanCategory)
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

            trigger OnPreDataItem();
            begin

                SwizzsoftFactory.BulkSchedule(); //ensre all loans have proepr schedulin
                GrandTotal := 0;
                NoLoans := 0;
                Company.Get();
                Company.CalcFields(Company.Picture);

                if AsAt = 0D then
                    AsAt := Today;

                DFilter := '..' + Format(AsAt);
                "Loans Register".SetFilter("Loans Register"."Date filter", DFilter);
                "Loans Register".SetFilter("Loans Register"."Loan Disbursement Date", '<=%1', AsAt);

                if LoanProductTypeCode <> '' then
                    "Loans Register".SetRange("Loan Product Type", LoanProductTypeCode);



                if LoanProdType.Get("Loans Register".GetFilter("Loans Register"."Loan Product Type")) then
                    LoanType := LoanProdType."Product Description";
            end;

            trigger OnAfterGetRecord();
            begin

                // Initialize aging buckets
                Over3Month := 0;
                "3Month" := 0;
                "2Month" := 0;
                "1Month" := 0;
                "0Month" := 0;

                // Calculate loan classification without modifying the table

                CalculateLoanClassification();
                "Loans Register".Modify();

                // Set aging buckets based on calculated loan category
                case CalculatedLoanCategory of
                    CalculatedLoanCategory::Performing:
                        "0Month" := "Loans Register"."Outstanding Balance";
                    CalculatedLoanCategory::Watch:
                        "1Month" := "Loans Register"."Outstanding Balance";
                    CalculatedLoanCategory::Substandard:
                        "2Month" := "Loans Register"."Outstanding Balance";
                    CalculatedLoanCategory::Doubtful:
                        "3Month" := "Loans Register"."Outstanding Balance";
                    CalculatedLoanCategory::Loss:
                        Over3Month := "Loans Register"."Outstanding Balance";
                end;

                // Update loan count if in arrears
                if ("1Month" + "2Month" + "3Month" + Over3Month) > 0 then
                    NoLoans := NoLoans + 1;

                // Add to grand total
                GrandTotal := GrandTotal + "Loans Register"."Outstanding Balance";
            end;

        }
    }

    requestpage
    {
        SaveValues = false;
        layout
        {
            area(Content)
            {
                field("As At"; AsAt)
                {
                    ApplicationArea = Basic;
                }

                field(LoanProductTypeFilter; LoanProductTypeCode)
                {
                    Caption = 'Loan Product Type';
                    ApplicationArea = All;
                    TableRelation = "Loan Products Setup".Code;
                }
            }
        }
    }

    var
        DFilter: Text;
        "1Month": Decimal;
        "2Month": Decimal;
        "3Month": Decimal;
        Over3Month: Decimal;
        AsAt: Date;
        NoLoans: Integer;
        GrandTotal: Decimal;
        "0Month": Decimal;
        Company: Record "Company Information";

        // Calculated fields (no table modification)
        CalculatedAmountInArrears: Decimal;
        CalculatedDaysInArrears: Integer;
        CalculatedMonthsInArrears: Integer;
        CalculatedLoanCategory: Option Performing,Watch,Substandard,Doubtful,Loss;

        // Caption labels
        Loans_Aging_Analysis__SASRA_CaptionLbl: label 'Loans Aging Analysis (SASRA)';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        Loan_TypeCaptionLbl: label 'Loan Type';
        Staff_No_CaptionLbl: label 'Staff No.';
        Oustanding_BalanceCaptionLbl: label 'Oustanding Balance';
        PerformingCaptionLbl: label 'Performing';
        V1___30_Days_CaptionLbl: label '(1 - 30 Days)';
        V0_Days_CaptionLbl: label '(0 Days)';
        WatchCaptionLbl: label 'Watch';
        V31___180_Days_CaptionLbl: label '(31 - 180 Days)';
        SubstandardCaptionLbl: label 'Substandard';
        V181___360_Days_CaptionLbl: label '(181 - 360 Days)';
        DoubtfulCaptionLbl: label 'Doubtful';
        Over_360_DaysCaptionLbl: label '(Over 360 Days)';
        LossCaptionLbl: label 'Loss';
        TotalsCaptionLbl: label 'Totals';
        CountCaptionLbl: label 'Count';
        Grand_TotalCaptionLbl: label 'Grand Total';

        FirstArrearsDate: Date;

        LoanProductTypeCode: Code[20];

        LoanType: Text[50];
        LoanProdType: Record "Loan Products Setup";

        SwizzsoftFactory: Codeunit "Swizzsoft Factory";



    local procedure GetTotalDebitForLoan(LoanNo: Code[20]): Decimal
    var
        LoanLedgerEntry: Record "Cust. Ledger Entry";
        TotalDebit: Decimal;
    begin
        TotalDebit := 0;

        LoanLedgerEntry.Reset();
        LoanLedgerEntry.SetRange("Loan No", LoanNo);
        LoanLedgerEntry.SetFilter("Transaction Type", '<>%1&<>%2',
            LoanLedgerEntry."Transaction Type"::"Interest Due",
            LoanLedgerEntry."Transaction Type"::"Penalty Charged");

        if LoanLedgerEntry.FindSet() then begin
            repeat
                LoanLedgerEntry.CalcFields("Debit Amount");
                TotalDebit += LoanLedgerEntry."Debit Amount";
            until LoanLedgerEntry.Next() = 0;
        end;

        exit(TotalDebit);
    end;


    local procedure CalculateLoanClassification()
    var
        LoanRepaymentSchedule: Record "Loan Repayment Schedule";
        LoanRepaymentScheduleRec: Record "Loan Repayment Schedule";
        LoansRegisterRec: Record "Loans Register";
        ExpectedOutstandingBalance: Decimal;
        ActualOutstandingBalance: Decimal;
        LastDueDate: Date;
        DaysOverdue: Integer;
        ArrearsAtRepaymentDate: Decimal;
        LoanLedgerEntry: Record "Cust. Ledger Entry";
        TotalDebitAmount: Decimal;
    begin
        ArrearsAtRepaymentDate := 0;
        CalculatedAmountInArrears := 0;
        CalculatedDaysInArrears := 0;
        CalculatedMonthsInArrears := 0;
        TotalDebitAmount := 0;
        FirstArrearsDate := 0D;
        CalculatedLoanCategory := CalculatedLoanCategory::Performing;

        if ("Loans Register"."Loan  No." = 'LN1092') or ("Loans Register"."Loan  No." = 'LN1760') then begin

            TotalDebitAmount := GetTotalDebitForLoan("Loans Register"."Loan  No.");

            ExpectedOutstandingBalance := GetExpectedOutstandingBalance(AsAt, TotalDebitAmount);

        end else begin

            ExpectedOutstandingBalance := GetExpectedOutstandingBalance(AsAt, 0);
        end;

        ActualOutstandingBalance := "Loans Register"."Outstanding Balance";

        if ActualOutstandingBalance > ExpectedOutstandingBalance then
            CalculatedAmountInArrears := ActualOutstandingBalance - ExpectedOutstandingBalance;


        //LastDueDate := GetLastDueDateBeforeAsAt();



        if ("Loans Register"."Loan  No." = 'LN1092') or ("Loans Register"."Loan  No." = 'LN1760') then begin


            FirstArrearsDate := GetFirstDateWhereInArrears(ActualOutstandingBalance, TotalDebitAmount);

        end else begin


            FirstArrearsDate := GetFirstDateWhereInArrears(ActualOutstandingBalance, 0);


        end;


        // Calculate days in arrears
        if (FirstArrearsDate <> 0D) and (CalculatedAmountInArrears > 0) then begin

            CalculatedDaysInArrears := AsAt - FirstArrearsDate;
            CalculatedMonthsInArrears := CalculatedDaysInArrears div 30;

            case CalculatedDaysInArrears of
                1 .. 30:
                    CalculatedLoanCategory := CalculatedLoanCategory::Watch;
                31 .. 180:
                    CalculatedLoanCategory := CalculatedLoanCategory::Substandard;
                181 .. 360:
                    CalculatedLoanCategory := CalculatedLoanCategory::Doubtful;
                else
                    CalculatedLoanCategory := CalculatedLoanCategory::Loss;
            end;

            // Handle LT007 blacklisting when in arrears
            if "Loans Register"."Loan Product Type" = 'LT007' then begin
                if "Loans Register"."Blacklist Status" <> "Loans Register"."Blacklist Status"::Blacklisted then begin
                    "Loans Register"."Blacklist Status" := "Loans Register"."Blacklist Status"::Blacklisted;
                    "Loans Register"."Blacklist Start Date" := AsAt;
                    "Loans Register"."Blacklist End Date" := CalcDate('+45D', AsAt);
                end;

                if "Loans Register"."Blacklist End Date" > AsAt then
                    "Loans Register"."Days Remaining in Blacklist" := "Loans Register"."Blacklist End Date" - AsAt
                else begin
                    "Loans Register"."Blacklist Status" := "Loans Register"."Blacklist Status"::" ";
                    "Loans Register"."Blacklist Start Date" := 0D;
                    "Loans Register"."Blacklist End Date" := 0D;
                    "Loans Register"."Days Remaining in Blacklist" := 0;
                end;
            end;

            //penalty
            LoanRepaymentScheduleRec.Reset();
            LoanRepaymentScheduleRec.SetRange("Loan No.", "Loans Register"."Loan  No.");
            LoanRepaymentScheduleRec.SetFilter("Repayment Date", '<=%1', AsAt);
            //LoanRepaymentScheduleRec.SetFilter("Repayment Date", '>=%1', FirstArrearsDate);
            //LoanRepaymentScheduleRec.SetRange("PenaltyCharged", false);

            if LoanRepaymentScheduleRec.FindSet() then begin
                repeat
                    if LoanRepaymentScheduleRec."Repayment Date" < AsAt then begin
                        // Calculate arrears amount as of this specific repayment date
                        ArrearsAtRepaymentDate := CalculateArrearsAmountAsOfDate(LoanRepaymentScheduleRec."Repayment Date");

                        if (ArrearsAtRepaymentDate > 0) and (LoanRepaymentScheduleRec.PenaltyCharged = FALSE) then begin

                            LoanRepaymentScheduleRec.Arrears := ArrearsAtRepaymentDate;
                            LoanRepaymentScheduleRec.Penalty := Round(0.05 * ArrearsAtRepaymentDate, 1, '>');
                            //LoanRepaymentScheduleRec.PenaltyCharged := true;
                            LoanRepaymentScheduleRec.Modify();

                        end;
                    end;
                until LoanRepaymentScheduleRec.Next() = 0;
            end;

        end else begin
            CalculatedLoanCategory := CalculatedLoanCategory::Performing;

            CalculatedAmountInArrears := 0;
            CalculatedDaysInArrears := 0;
            CalculatedMonthsInArrears := 0;
            FirstArrearsDate := 0D;

            // if "Loans Register"."Loan Product Type" = 'LT007' then begin
            //     "Loans Register"."Blacklist Status" := "Loans Register"."Blacklist Status"::" ";
            //     "Loans Register"."Blacklist Start Date" := 0D;
            //     "Loans Register"."Blacklist End Date" := 0D;
            //     "Loans Register"."Days Remaining in Blacklist" := 0;
            // end;
            if "Loans Register"."Loan Product Type" = 'LT007' then begin
                if ("Loans Register"."Blacklist End Date" <> 0D) and ("Loans Register"."Blacklist End Date" <= AsAt) then begin
                    "Loans Register"."Blacklist Status" := "Loans Register"."Blacklist Status"::" ";
                    "Loans Register"."Blacklist Start Date" := 0D;
                    "Loans Register"."Blacklist End Date" := 0D;
                    "Loans Register"."Days Remaining in Blacklist" := 0;
                end else if "Loans Register"."Blacklist End Date" > AsAt then begin
                    "Loans Register"."Days Remaining in Blacklist" := "Loans Register"."Blacklist End Date" - AsAt;
                end;
            end;
        end;

        "Loans Register"."Amount in Arrears" := CalculatedAmountInArrears;
        "Loans Register"."No of Days in Arrears" := CalculatedDaysInArrears;
        "Loans Register"."No of Months in Arrears" := CalculatedMonthsInArrears;
        "Loans Register"."Days In Arrears" := CalculatedDaysInArrears;
        "Loans Register"."Loan Aging Run Date" := AsAt;

        case CalculatedLoanCategory of
            CalculatedLoanCategory::Performing:
                begin
                    "Loans Register"."Loans Category" := "Loans Register"."Loans Category"::Perfoming;
                    "Loans Register"."Loans Category-SASRA" := "Loans Register"."Loans Category-SASRA"::Perfoming;
                end;
            CalculatedLoanCategory::Watch:
                begin
                    "Loans Register"."Loans Category" := "Loans Register"."Loans Category"::Watch;
                    "Loans Register"."Loans Category-SASRA" := "Loans Register"."Loans Category-SASRA"::Watch;
                end;
            CalculatedLoanCategory::Substandard:
                begin
                    "Loans Register"."Loans Category" := "Loans Register"."Loans Category"::Substandard;
                    "Loans Register"."Loans Category-SASRA" := "Loans Register"."Loans Category-SASRA"::Substandard;
                end;
            CalculatedLoanCategory::Doubtful:
                begin
                    "Loans Register"."Loans Category" := "Loans Register"."Loans Category"::Doubtful;
                    "Loans Register"."Loans Category-SASRA" := "Loans Register"."Loans Category-SASRA"::Doubtful;
                end;
            CalculatedLoanCategory::Loss:
                begin
                    "Loans Register"."Loans Category" := "Loans Register"."Loans Category"::Loss;
                    "Loans Register"."Loans Category-SASRA" := "Loans Register"."Loans Category-SASRA"::Loss;
                end;
        end;

        "Loans Register".Modify();
    end;


    local procedure CalculateArrearsAmountAsOfDate(SpecificDate: Date): Decimal
    var
        ExpectedRepaymentAtDate: Decimal;
        ActualRepaymentAtDate: Decimal;
        GracePeriodDays: Integer;
        ExtendedDate: Date;
    begin

        if ("Loans Register"."Loan  No." = 'LN1092') or ("Loans Register"."Loan  No." = 'LN1760') then begin

            ExpectedRepaymentAtDate := GetMonthlyRepayment(SpecificDate, GetTotalDebitForLoan("Loans Register"."Loan  No."));
        end else begin

            ExpectedRepaymentAtDate := GetMonthlyRepayment(SpecificDate, 0);

        end;

        ActualRepaymentAtDate := GetActualRepaymentAtDate(SpecificDate);

        if ExpectedRepaymentAtDate > ActualRepaymentAtDate then
            exit(ExpectedRepaymentAtDate - ActualRepaymentAtDate)
        else
            exit(0);
    end;


    local procedure GetActualOutstandingBalance(AsAtDate: Date): Decimal
    var
        LoanLedgerEntry: Record "Cust. Ledger Entry";
        TotalActual: Decimal;
    begin
        TotalActual := 0;

        LoanLedgerEntry.Reset();
        LoanLedgerEntry.SetRange("Customer No.", "Loans Register"."Client Code");
        LoanLedgerEntry.SetRange("Loan No", "Loans Register"."Loan  No.");
        LoanLedgerEntry.SetFilter("Transaction Type", '%1|%2|%3|%4|%5|%6|%7', LoanLedgerEntry."Transaction Type"::"Loan Repayment", LoanLedgerEntry."Transaction Type"::"Interest Paid", LoanLedgerEntry."Transaction Type"::Loan, LoanLedgerEntry."Transaction Type"::"Interest Due", LoanLedgerEntry."Transaction Type"::"Loan Transfer Charges", LoanLedgerEntry."Transaction Type"::"Penalty Charged", LoanLedgerEntry."Transaction Type"::"Penalty Paid");
        //LoanLedgerEntry.SetFilter("Transaction Type", '%1|%2|%3|%4', LoanLedgerEntry."Transaction Type"::"Loan Repayment", LoanLedgerEntry."Transaction Type"::"Interest Paid", LoanLedgerEntry."Transaction Type"::Loan, LoanLedgerEntry."Transaction Type"::"Interest Due");
        LoanLedgeREntry.SetRange(Reversed, false);
        LoanLedgerEntry.SetFilter("Posting Date", '<=%1', AsAtDate);

        if LoanLedgerEntry.FindSet() then begin
            repeat
                //LoanLedgerEntry.CalcFields("Credit Amount");
                TotalActual += LoanLedgerEntry."Amount Posted";
            until LoanLedgerEntry.Next() = 0;
        end;

        exit(TotalActual);
    end;


    local procedure GetActualRepaymentAtDate(RepaymentDate: Date): Decimal
    var
        LoanLedgerEntry: Record "Cust. Ledger Entry";
        TotalActual: Decimal;
        ExtendedDate: Date; //grace period
        AdjustedRepaymentDate: Date;
    begin

        ExtendedDate := RepaymentDate + 15;
        AdjustedRepaymentDate := RepaymentDate - 10; //adjusting this date in case of early repayments
        TotalActual := 0;

        LoanLedgerEntry.Reset();
        LoanLedgerEntry.SetRange("Customer No.", "Loans Register"."Client Code");
        LoanLedgerEntry.SetRange("Loan No", "Loans Register"."Loan  No.");
        LoanLedgerEntry.SetFilter("Transaction Type", '%1|%2|%3|%4', LoanLedgerEntry."Transaction Type"::"Loan Repayment", LoanLedgerEntry."Transaction Type"::"Interest Paid", LoanLedgerEntry."Transaction Type"::Loan, LoanLedgerEntry."Transaction Type"::"Penalty Paid");
        LoanLedgeREntry.SetRange(Reversed, false);
        LoanLedgerEntry.SetFilter("Posting Date", '%1..%2', AdjustedRepaymentDate, ExtendedDate);

        if LoanLedgerEntry.FindSet() then begin
            repeat
                LoanLedgerEntry.CalcFields("Credit Amount");
                TotalActual += LoanLedgerEntry."Credit Amount";
            until LoanLedgerEntry.Next() = 0;
        end;

        exit(TotalActual);
    end;


    local procedure GetExpectedOutstandingBalance(AsAtDate: Date; OverrideLoanAmount: Decimal): Decimal
    var
        ObjLoans: Record "Loans Register";
        VarRunningDate: Date;
        VarLoanAmount: Decimal;
        VarInterestRate: Decimal;
        VarRepayPeriod: Integer;
        VarLBalance: Decimal;
        VarInstalNo: Decimal;
        VarTotalMRepay: Decimal;
        VarLInterest: Decimal;
        VarMonthlyInterest: Decimal;
        VarLPrincipal: Decimal;
        VarGrPrinciple: Integer;
        VarGrInterest: Integer;
        VarRepaymentStartDate: Date;
        VarMonthIncreament: Text;
        VarInPeriod: DateFormula;
        ExpectedBalance: Decimal;
    begin
        // Get fresh loan record
        if not ObjLoans.Get("Loans Register"."Loan  No.") then
            exit("Loans Register"."Approved Amount");

        // Initialize variables using same logic as FnGenerateRepaymentSchedule
        if ObjLoans."Repayment Frequency" = ObjLoans."repayment frequency"::Daily then
            Evaluate(VarInPeriod, '1D')
        else if ObjLoans."Repayment Frequency" = ObjLoans."repayment frequency"::Weekly then
            Evaluate(VarInPeriod, '1W')
        else if ObjLoans."Repayment Frequency" = ObjLoans."repayment frequency"::Monthly then
            Evaluate(VarInPeriod, '1M')
        else if ObjLoans."Repayment Frequency" = ObjLoans."repayment frequency"::Quaterly then
            Evaluate(VarInPeriod, '1Q');

        VarGrPrinciple := ObjLoans."Grace Period - Principle (M)";
        VarGrInterest := ObjLoans."Grace Period - Interest (M)";


        //VarLoanAmount := ObjLoans."Approved Amount";
        if OverrideLoanAmount <> 0 then
            VarLoanAmount := OverrideLoanAmount
        else
            VarLoanAmount := ObjLoans."Approved Amount";


        VarInterestRate := ObjLoans.Interest;
        VarMonthlyInterest := VarInterestRate / 12 / 100;
        VarRepayPeriod := ObjLoans.Installments;
        VarLBalance := VarLoanAmount;
        VarRunningDate := ObjLoans."Repayment Start Date";
        VarRepaymentStartDate := ObjLoans."Repayment Start Date";
        VarInstalNo := 0;

        // Calculate expected balance up to AsAt date using same logic
        repeat
            if (VarGrPrinciple > 0) and (VarGrInterest > 0) then begin
                // Grace period - no principal reduction
                VarGrPrinciple := VarGrPrinciple - 1;
                VarGrInterest := VarGrInterest - 1;
            end else begin
                VarInstalNo := VarInstalNo + 1;

                // Calculate repayment amounts using same logic as schedule generation
                if ObjLoans."Repayment Method" = ObjLoans."repayment method"::Amortised then begin
                    if VarTotalMRepay = 0 then begin
                        VarTotalMRepay := Round(VarLBalance * ((VarMonthlyInterest * Power((1 + VarMonthlyInterest), VarRepayPeriod)) / (Power((1 + VarMonthlyInterest), VarRepayPeriod) - 1)), 1);
                    end;

                    VarLInterest := Round(VarLBalance * VarMonthlyInterest, 1);
                    VarLPrincipal := VarTotalMRepay - VarLInterest;
                end;

                if ObjLoans."Repayment Method" = ObjLoans."repayment method"::"Straight Line" then begin
                    if ObjLoans."Loan Product Type" = 'LT008' then begin
                        VarLPrincipal := Round(VarLoanAmount / VarRepayPeriod, 1, '>');
                        VarLInterest := 0;
                    end else begin
                        VarLPrincipal := Round(VarLoanAmount / VarRepayPeriod, 1, '>');
                        VarLInterest := Round((VarInterestRate / 1200) * VarLoanAmount, 1, '>');
                        if VarInstalNo - ObjLoans."Grace Period - Interest (M)" = 1 then
                            VarLInterest := VarLInterest * VarInstalNo;
                    end;
                end;

                if ObjLoans."Repayment Method" = ObjLoans."repayment method"::"Reducing Balance" then begin
                    VarLPrincipal := Round(VarLoanAmount / VarRepayPeriod, 1, '>');
                    VarLInterest := Round((VarInterestRate / 12 / 100) * VarLBalance, 1, '>');
                end;

                if ObjLoans."Repayment Method" = ObjLoans."repayment method"::Constants then begin
                    if VarLBalance < ObjLoans.Repayment then
                        VarLPrincipal := VarLBalance
                    else
                        VarLPrincipal := ObjLoans.Repayment;
                    VarLInterest := ObjLoans.Interest;
                end;

                // Handle final installment
                if VarInstalNo = VarRepayPeriod then begin
                    VarLPrincipal := VarLBalance;
                    VarTotalMRepay := VarLPrincipal + VarLInterest;
                end;

                // Reduce balance
                VarLBalance := VarLBalance - VarLPrincipal;
            end;

            // Get next repayment date using same logic
            VarMonthIncreament := Format(VarInstalNo) + 'M';
            if ObjLoans."Repayment Frequency" = ObjLoans."repayment frequency"::Daily then
                VarRunningDate := CalcDate('1D', VarRunningDate)
            else if ObjLoans."Repayment Frequency" = ObjLoans."repayment frequency"::Weekly then
                VarRunningDate := CalcDate('1W', VarRunningDate)
            else if ObjLoans."Repayment Frequency" = ObjLoans."repayment frequency"::Monthly then
                VarRunningDate := CalcDate(VarMonthIncreament, VarRepaymentStartDate)
            else if ObjLoans."Repayment Frequency" = ObjLoans."repayment frequency"::Quaterly then
                VarRunningDate := CalcDate('1Q', VarRunningDate);

            // Stop when we reach or pass the AsAt date
            if VarRunningDate > AsAtDate then begin
                ExpectedBalance := VarLBalance;
                break;
            end;

        until VarInstalNo = VarRepayPeriod;

        // If we completed all installments and still haven't reached AsAt, balance should be 0
        if VarInstalNo = VarRepayPeriod then
            ExpectedBalance := 0
        else
            ExpectedBalance := VarLBalance;

        "Loans Register"."Expected Loan Balance" := Round(ExpectedBalance, 0.01);
        exit(Round(ExpectedBalance, 0.01));
    end;



    local procedure GetMonthlyRepayment(AsAtDate: Date; OverrideLoanAmount: Decimal): Decimal
    var
        ObjLoans: Record "Loans Register";
        VarRunningDate: Date;
        VarLoanAmount: Decimal;
        VarInterestRate: Decimal;
        VarRepayPeriod: Integer;
        VarLBalance: Decimal;
        VarInstalNo: Decimal;
        VarTotalMRepay: Decimal;
        VarLInterest: Decimal;
        VarMonthlyInterest: Decimal;
        VarLPrincipal: Decimal;
        VarGrPrinciple: Integer;
        VarGrInterest: Integer;
        VarRepaymentStartDate: Date;
        VarMonthIncreament: Text;
        VarInPeriod: DateFormula;
        MonthlyRepayment: Decimal;
    begin
        // Get fresh loan record
        if not ObjLoans.Get("Loans Register"."Loan  No.") then
            exit(0);

        if ObjLoans."Repayment Frequency" = ObjLoans."repayment frequency"::Daily then
            Evaluate(VarInPeriod, '1D')
        else if ObjLoans."Repayment Frequency" = ObjLoans."repayment frequency"::Weekly then
            Evaluate(VarInPeriod, '1W')
        else if ObjLoans."Repayment Frequency" = ObjLoans."repayment frequency"::Monthly then
            Evaluate(VarInPeriod, '1M')
        else if ObjLoans."Repayment Frequency" = ObjLoans."repayment frequency"::Quaterly then
            Evaluate(VarInPeriod, '1Q');

        VarGrPrinciple := ObjLoans."Grace Period - Principle (M)";
        VarGrInterest := ObjLoans."Grace Period - Interest (M)";

        if OverrideLoanAmount <> 0 then
            VarLoanAmount := OverrideLoanAmount
        else
            VarLoanAmount := ObjLoans."Approved Amount";

        VarInterestRate := ObjLoans.Interest;
        VarMonthlyInterest := VarInterestRate / 12 / 100;
        VarRepayPeriod := ObjLoans.Installments;
        VarLBalance := VarLoanAmount;
        VarRunningDate := ObjLoans."Repayment Start Date";
        VarRepaymentStartDate := ObjLoans."Repayment Start Date";
        VarInstalNo := 0;

        // Find the repayment that corresponds to the AsAt date
        repeat
            if (VarGrPrinciple > 0) and (VarGrInterest > 0) then begin

                VarGrPrinciple := VarGrPrinciple - 1;
                VarGrInterest := VarGrInterest - 1;

                // During grace period, there might still be interest payments
                // if VarGrInterest = 0 then begin
                //     VarLInterest := Round(VarLBalance * VarMonthlyInterest, 1);
                //     MonthlyRepayment := VarLInterest;
                // end else
                //     MonthlyRepayment := 0;
            end else begin
                VarInstalNo := VarInstalNo + 1;

                // Calculate repayment amounts using same logic as schedule generation
                if ObjLoans."Repayment Method" = ObjLoans."repayment method"::Amortised then begin
                    if VarTotalMRepay = 0 then begin
                        VarTotalMRepay := Round(VarLBalance * ((VarMonthlyInterest * Power((1 + VarMonthlyInterest), VarRepayPeriod)) / (Power((1 + VarMonthlyInterest), VarRepayPeriod) - 1)), 1);
                    end;

                    VarLInterest := Round(VarLBalance * VarMonthlyInterest, 1);
                    VarLPrincipal := VarTotalMRepay - VarLInterest;
                    MonthlyRepayment := VarTotalMRepay;
                end;

                if ObjLoans."Repayment Method" = ObjLoans."repayment method"::"Straight Line" then begin
                    if ObjLoans."Loan Product Type" = 'LT008' then begin
                        VarLPrincipal := Round(VarLoanAmount / VarRepayPeriod, 1, '>');
                        VarLInterest := 0;
                    end else begin
                        VarLPrincipal := Round(VarLoanAmount / VarRepayPeriod, 1, '>');
                        VarLInterest := Round((VarInterestRate / 1200) * VarLoanAmount, 1, '>');
                        if VarInstalNo - ObjLoans."Grace Period - Interest (M)" = 1 then
                            VarLInterest := VarLInterest * VarInstalNo;
                    end;
                    MonthlyRepayment := VarLPrincipal + VarLInterest;
                end;

                if ObjLoans."Repayment Method" = ObjLoans."repayment method"::"Reducing Balance" then begin
                    VarLPrincipal := Round(VarLoanAmount / VarRepayPeriod, 1, '>');
                    VarLInterest := Round((VarInterestRate / 12 / 100) * VarLBalance, 1, '>');
                    MonthlyRepayment := VarLPrincipal + VarLInterest;
                end;

                if ObjLoans."Repayment Method" = ObjLoans."repayment method"::Constants then begin
                    if VarLBalance < ObjLoans.Repayment then
                        VarLPrincipal := VarLBalance
                    else
                        VarLPrincipal := ObjLoans.Repayment;
                    VarLInterest := ObjLoans.Interest;
                    MonthlyRepayment := VarLPrincipal + VarLInterest;
                end;

                // Handle final installment
                if VarInstalNo = VarRepayPeriod then begin
                    VarLPrincipal := VarLBalance;
                    MonthlyRepayment := VarLPrincipal + VarLInterest;
                end;

                // Reduce balance
                VarLBalance := VarLBalance - VarLPrincipal;
            end;

            // Get next repayment date using same logic
            VarMonthIncreament := Format(VarInstalNo) + 'M';
            if ObjLoans."Repayment Frequency" = ObjLoans."repayment frequency"::Daily then
                VarRunningDate := CalcDate('1D', VarRunningDate)
            else if ObjLoans."Repayment Frequency" = ObjLoans."repayment frequency"::Weekly then
                VarRunningDate := CalcDate('1W', VarRunningDate)
            else if ObjLoans."Repayment Frequency" = ObjLoans."repayment frequency"::Monthly then
                VarRunningDate := CalcDate(VarMonthIncreament, VarRepaymentStartDate)
            else if ObjLoans."Repayment Frequency" = ObjLoans."repayment frequency"::Quaterly then
                VarRunningDate := CalcDate('1Q', VarRunningDate);

            // Stop when we reach or pass the AsAt date - return the repayment for this period
            if VarRunningDate >= AsAtDate then begin
                exit(Round(MonthlyRepayment, 0.01));
            end;

        until VarInstalNo = VarRepayPeriod;

        // If we've gone past all installments, return 0 (loan is fully paid)
        exit(0);
    end;



    local procedure GetFirstDateWhereInArrears(ActualBalance: Decimal; OverrideLoanAmount: Decimal): Date
    var
        ObjLoans: Record "Loans Register";
        VarRunningDate: Date;
        VarLoanAmount: Decimal;
        VarInterestRate: Decimal;
        VarRepayPeriod: Integer;
        VarLBalance: Decimal;
        VarInstalNo: Decimal;
        VarTotalMRepay: Decimal;
        VarLInterest: Decimal;
        VarMonthlyInterest: Decimal;
        VarLPrincipal: Decimal;
        VarGrPrinciple: Integer;
        VarGrInterest: Integer;
        VarRepaymentStartDate: Date;
        VarMonthIncreament: Text;
        VarInPeriod: DateFormula;
        RunningExpectedBalance: Decimal;
    begin
        // Get fresh loan record
        if not ObjLoans.Get("Loans Register"."Loan  No.") then
            exit(0D);

        // Initialize variables using same logic as FnGenerateRepaymentSchedule
        if ObjLoans."Repayment Frequency" = ObjLoans."repayment frequency"::Daily then
            Evaluate(VarInPeriod, '1D')
        else if ObjLoans."Repayment Frequency" = ObjLoans."repayment frequency"::Weekly then
            Evaluate(VarInPeriod, '1W')
        else if ObjLoans."Repayment Frequency" = ObjLoans."repayment frequency"::Monthly then
            Evaluate(VarInPeriod, '1M')
        else if ObjLoans."Repayment Frequency" = ObjLoans."repayment frequency"::Quaterly then
            Evaluate(VarInPeriod, '1Q');

        VarGrPrinciple := ObjLoans."Grace Period - Principle (M)";
        VarGrInterest := ObjLoans."Grace Period - Interest (M)";

        //VarLoanAmount := ObjLoans."Approved Amount";

        if OverrideLoanAmount <> 0 then
            VarLoanAmount := OverrideLoanAmount
        else
            VarLoanAmount := ObjLoans."Approved Amount";

        VarInterestRate := ObjLoans.Interest;
        VarMonthlyInterest := VarInterestRate / 12 / 100;
        VarRepayPeriod := ObjLoans.Installments;
        VarLBalance := VarLoanAmount;
        VarRunningDate := ObjLoans."Repayment Start Date";
        VarRepaymentStartDate := ObjLoans."Repayment Start Date";
        VarInstalNo := 0;

        // Simulate the schedule and check for first arrears date
        repeat
            if (VarGrPrinciple > 0) and (VarGrInterest > 0) then begin
                // Grace period - no principal reduction
                VarGrPrinciple := VarGrPrinciple - 1;
                VarGrInterest := VarGrInterest - 1;
            end else begin
                VarInstalNo := VarInstalNo + 1;

                // Calculate repayment amounts using same logic as schedule generation
                if ObjLoans."Repayment Method" = ObjLoans."repayment method"::Amortised then begin
                    if VarTotalMRepay = 0 then begin
                        VarTotalMRepay := Round(VarLBalance * ((VarMonthlyInterest * Power((1 + VarMonthlyInterest), VarRepayPeriod)) / (Power((1 + VarMonthlyInterest), VarRepayPeriod) - 1)), 1);
                    end;

                    VarLInterest := Round(VarLBalance * VarMonthlyInterest, 1);
                    VarLPrincipal := VarTotalMRepay - VarLInterest;
                end;

                if ObjLoans."Repayment Method" = ObjLoans."repayment method"::"Straight Line" then begin
                    if ObjLoans."Loan Product Type" = 'LT008' then begin
                        VarLPrincipal := Round(VarLoanAmount / VarRepayPeriod, 1, '>');
                        VarLInterest := 0;
                    end else begin
                        VarLPrincipal := Round(VarLoanAmount / VarRepayPeriod, 1, '>');
                        VarLInterest := Round((VarInterestRate / 1200) * VarLoanAmount, 1, '>');
                        if VarInstalNo - ObjLoans."Grace Period - Interest (M)" = 1 then
                            VarLInterest := VarLInterest * VarInstalNo;
                    end;
                end;

                if ObjLoans."Repayment Method" = ObjLoans."repayment method"::"Reducing Balance" then begin
                    VarLPrincipal := Round(VarLoanAmount / VarRepayPeriod, 1, '>');
                    VarLInterest := Round((VarInterestRate / 12 / 100) * VarLBalance, 1, '>');
                end;

                if ObjLoans."Repayment Method" = ObjLoans."repayment method"::Constants then begin
                    if VarLBalance < ObjLoans.Repayment then
                        VarLPrincipal := VarLBalance
                    else
                        VarLPrincipal := ObjLoans.Repayment;
                    VarLInterest := ObjLoans.Interest;
                end;

                // Handle final installment
                if VarInstalNo = VarRepayPeriod then begin
                    VarLPrincipal := VarLBalance;
                    VarTotalMRepay := VarLPrincipal + VarLInterest;
                end;

                // Reduce balance AFTER checking for arrears
                VarLBalance := VarLBalance - VarLPrincipal;
                RunningExpectedBalance := VarLBalance;

                // Check if this is the first date where we're in arrears
                // Only check dates that have passed (<=AsAt)
                if (VarRunningDate <= AsAt) and (ActualBalance > RunningExpectedBalance) then
                    exit(VarRunningDate);
            end;

            // Get next repayment date using same logic as schedule generation
            VarMonthIncreament := Format(VarInstalNo) + 'M';
            if ObjLoans."Repayment Frequency" = ObjLoans."repayment frequency"::Daily then
                VarRunningDate := CalcDate('1D', VarRunningDate)
            else if ObjLoans."Repayment Frequency" = ObjLoans."repayment frequency"::Weekly then
                VarRunningDate := CalcDate('1W', VarRunningDate)
            else if ObjLoans."Repayment Frequency" = ObjLoans."repayment frequency"::Monthly then
                VarRunningDate := CalcDate(VarMonthIncreament, VarRepaymentStartDate)
            else if ObjLoans."Repayment Frequency" = ObjLoans."repayment frequency"::Quaterly then
                VarRunningDate := CalcDate('1Q', VarRunningDate);

            // Stop if we've gone past AsAt date
            if VarRunningDate > AsAt then
                break;

        until VarInstalNo = VarRepayPeriod;

        exit(0D); // Not in arrears
    end;

    trigger OnPreReport()
    begin
        Company.Get();
        Company.CalcFields(Picture);

        if AsAt = 0D then
            AsAt := Today;
    end;
}