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
            DataItemTableView = where("Outstanding Balance" = filter(> 0), Posted = const(true), Reversed = const(false));
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
            column(AmountinArrears_LoansRegister; CalculatedAmountInArrears)
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
                GrandTotal := 0;
                NoLoans := 0;
                Company.Get();
                Company.CalcFields(Company.Picture);

                if AsAt = 0D then
                    AsAt := Today;

                DFilter := '..' + Format(AsAt);
                "Loans Register".SetFilter("Loans Register"."Date filter", DFilter);
                "Loans Register".SetFilter("Loans Register"."Issued Date", '<=%1', AsAt);
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

    local procedure CalculateLoanClassification()
    var
        LoanRepaymentSchedule: Record "Loan Repayment Schedule";
        ExpectedAmount: Decimal;
        ActualAmount: Decimal;
        LastDueDate: Date;
        DaysOverdue: Integer;
    begin

        CalculatedAmountInArrears := 0;
        CalculatedDaysInArrears := 0;
        CalculatedMonthsInArrears := 0;
        CalculatedLoanCategory := CalculatedLoanCategory::Performing;

        // Calculate expected vs actual payments as of AsAt date
        ExpectedAmount := GetExpectedPaymentAmount();
        ActualAmount := GetActualPaymentAmount();


        //lets use outstanding balance
        if ActualAmount > ExpectedAmount then
            CalculatedAmountInArrears := ActualAmount - ExpectedAmount;


        //LastDueDate := GetLastDueDateBeforeAsAt();
        FirstArrearsDate := GetFirstDateWhereInArrears(ActualAmount);


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
        end else
            CalculatedLoanCategory := CalculatedLoanCategory::Performing;

        "Loans Register"."Amount in Arrears" := CalculatedAmountInArrears;
        "Loans Register"."No of Days in Arrears" := CalculatedDaysInArrears;
        "Loans Register"."No of Months in Arrears" := CalculatedMonthsInArrears;
        "Loans Register"."Days In Arrears" := CalculatedDaysInArrears;

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



    local procedure GetExpectedPaymentAmount(): Decimal
    var
        LoanRepaymentSchedule: Record "Loan Repayment Schedule";
        Swizzfactory: Codeunit 50009;
        TotalExpected: Decimal;

    begin

        TotalExpected := "Loans Register"."Approved Amount";

        LoanRepaymentSchedule.Reset();
        LoanRepaymentSchedule.SetRange("Loan No.", "Loans Register"."Loan  No.");

        if LoanRepaymentSchedule.Findset() then begin

            LoanRepaymentSchedule.Reset();
            LoanRepaymentSchedule.SetRange("Loan No.", "Loans Register"."Loan  No.");
            LoanRepaymentSchedule.SetFilter("Repayment Date", '<=%1', AsAt);

            IF LoanRepaymentSchedule.FindLast() THEN begin

                TotalExpected := LoanRepaymentSchedule."Loan Balance";

            end;
        end ELSE begin

            Swizzfactory.FnGenerateRepaymentSchedule("Loans Register"."Loan  No.");

            LoanRepaymentSchedule.Reset();
            LoanRepaymentSchedule.Reset();
            LoanRepaymentSchedule.SetRange("Loan No.", "Loans Register"."Loan  No.");
            LoanRepaymentSchedule.SetFilter("Repayment Date", '<=%1', AsAt);

            IF LoanRepaymentSchedule.FindLast() THEN begin

                TotalExpected := Round(LoanRepaymentSchedule."Loan Balance", 0.4, '>');

            end;

        end;

        //lets use outstanding balance
        "Loans Register"."Expected Loan Balance" := TotalExpected;
        exit(TotalExpected);

    end;

    local procedure GetActualPaymentAmount(): Decimal
    var
        LoanLedgerEntry: Record "Cust. Ledger Entry";
        TotalActual: Decimal;
    begin
        TotalActual := 0;

        LoanLedgerEntry.Reset();
        LoanLedgerEntry.SetRange("Customer No.", "Loans Register"."Client Code");
        LoanLedgerEntry.SetRange("Loan No", "Loans Register"."Loan  No.");
        LoanLedgerEntry.SetFilter("Transaction Type", '%1|%2|%3|%4|%5', LoanLedgerEntry."Transaction Type"::"Loan Repayment", LoanLedgerEntry."Transaction Type"::"Interest Paid", LoanLedgerEntry."Transaction Type"::Loan, LoanLedgerEntry."Transaction Type"::"Interest Due", LoanLedgerEntry."Transaction Type"::"Loan Transfer Charges");
        //LoanLedgerEntry.SetFilter("Transaction Type", '%1|%2|%3|%4', LoanLedgerEntry."Transaction Type"::"Loan Repayment", LoanLedgerEntry."Transaction Type"::"Interest Paid", LoanLedgerEntry."Transaction Type"::Loan, LoanLedgerEntry."Transaction Type"::"Interest Due");
        LoanLedgeREntry.SetRange(Reversed, false);
        LoanLedgerEntry.SetFilter("Posting Date", '<=%1', AsAt);

        if LoanLedgerEntry.FindSet() then begin
            repeat
                //LoanLedgerEntry.CalcFields("Credit Amount");
                TotalActual += LoanLedgerEntry."Amount Posted";
            until LoanLedgerEntry.Next() = 0;
        end;

        exit(TotalActual);
    end;

    local procedure GetLastDueDateBeforeAsAt(): Date
    var
        LoanRepaymentSchedule: Record "Loan Repayment Schedule";
        LastDate: Date;
    begin
        LastDate := 0D;
        LoanRepaymentSchedule.Reset();
        LoanRepaymentSchedule.SetRange("Loan No.", "Loans Register"."Loan  No.");
        LoanRepaymentSchedule.SetFilter("Repayment Date", '<=%1', AsAt);
        LoanRepaymentSchedule.SetCurrentKey("Repayment Date");

        if LoanRepaymentSchedule.FindLast() then
            LastDate := LoanRepaymentSchedule."Repayment Date";

        exit(LastDate);
    end;


    local procedure GetFirstDateWhereInArrears(ActualBalance: Decimal): Date
    var
        LoanRepaymentSchedule: Record "Loan Repayment Schedule";
        RunningExpectedBalance: Decimal;
    begin

        LoanRepaymentSchedule.Reset();
        LoanRepaymentSchedule.SetRange("Loan No.", "Loans Register"."Loan  No.");
        LoanRepaymentSchedule.SetFilter("Repayment Date", '<=%1', AsAt);
        LoanRepaymentSchedule.SetCurrentKey("Repayment Date");

        if LoanRepaymentSchedule.FindSet() then
            repeat
                // Calculate what balance should be after this repayment
                RunningExpectedBalance := LoanRepaymentSchedule."Loan Balance";

                // First date where actual balance exceeds expected balance
                if ActualBalance > RunningExpectedBalance then
                    exit(LoanRepaymentSchedule."Repayment Date");

            until LoanRepaymentSchedule.Next() = 0;

        exit(0D); // Not in arrears
    end;

    // local procedure LoanArrearsCalculator() 
    // var

    // LoanScheduleRec: Record "Loan Repayment Schedule";
    // CustLedgerRec: Record "Cust. Ledger Entry";
    // Month: Date;

    // begin 


    //     LoanScheduleRec.Reset();
    //     LoanScheduleRec.SetRange("Loan No.","Loans Register"."Loan  No.");
    //     LoanScheduleRec.SetFilter("Repayment Date", '<=%1', AsAt);
    //     LoanScheduleRec.SetCurrentKey("Repayment Date");


    //     if LoanScheduleRec.FindSet() then begin

    //         repeat

    //            Month := CalcDate('M', LoanScheduleRec."Repayment Date");

    //            CustLedgerRec.Reset();
    //            CustLedgerRec.SetRange("Customer No.", "Loans Register"."Client Code");
    //            CustLedgerRec.SetRange("Loan No", "Loans Register"."Loan  No.");
    //            CustLedgerRec.SetFilter("Transaction Type", '%1|%2', CustLedgerRec."Transaction Type"::Loan, CustLedgerRec."Transaction Type"::"Loan Repayment");

    //            CustLedgerRec.SetRange("Posting Date", );  

    //         until LoanScheduleRec.Next() = 0; 
    //     end;
    // end;    

    trigger OnPreReport()
    begin
        Company.Get();
        Company.CalcFields(Picture);

        if AsAt = 0D then
            AsAt := Today;
    end;
}