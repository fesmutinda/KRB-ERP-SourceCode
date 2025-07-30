namespace KRBERPSourceCode.KRBERPSourceCode;
using System.Integration;
using System.Visualization;
using Microsoft.Sales.Receivables;

page 59062 "Loan Arrears Chart"
{
    ApplicationArea = All;
    Caption = 'Loan Arrears Chart';
    PageType = CardPart;

    layout
    {
        area(Content)
        {
            usercontrol(Chart; BusinessChart)
            {
                ApplicationArea = All;

                trigger AddInReady()
                begin
                    LoadAndDisplayChart();
                end;

                trigger Refresh()
                begin
                    LoadAndDisplayChart();
                end;
            }
        }
    }

    var
        AsAt: Date;
        PeriodFilter: Option Day,Week,Month,Quarter,Year;
        NumberOfPeriods: Integer;
        PeriodStartDate: Date;

    trigger OnOpenPage()
    begin
        AsAt := Today();
        PeriodFilter := PeriodFilter::Month;
        PeriodStartDate := DMY2Date(1, 1, 2025);
        NumberOfPeriods := CalculateNumberOfPeriods(PeriodStartDate, AsAt);
    end;

    local procedure LoadAndDisplayChart()
    var
        LoansRegisterRec: Record "Loans Register";
        LoanProductsRec: Record "Loan Products Setup";
        BusinessChartBuffer: Record "Business Chart Buffer" temporary;
        PeriodStart: Date;
        PeriodEnd: Date;
        CurrentPeriod: Date;
        ChartEndDate: Date;
        ArrearsAmount: Decimal;
        ArrearsCount: Integer;
        PeriodText: Text[30];
        MeasureName: Text[100];
        CountMeasureName: Text[100];
        ColumnIndex: Integer;
        MeasureIndex: Integer;
        ProductCode: Code[20];
        TempDate: Date;
        i: Integer;
    begin
        BusinessChartBuffer.Reset();
        BusinessChartBuffer.DeleteAll();

        BusinessChartBuffer.Initialize();
        BusinessChartBuffer."Chart Type" := BusinessChartBuffer."Chart Type"::Line;
        BusinessChartBuffer.SetXAxis('Period', BusinessChartBuffer."Data Type"::String);

        // Set up the chart dates - start from January 1, 2025 to today
        ChartEndDate := AsAt;
        NumberOfPeriods := CalculateNumberOfPeriods(PeriodStartDate, ChartEndDate);

        // Create columns for each period starting from January 1, 2025, but only up to current date
        CurrentPeriod := PeriodStartDate;
        for i := 0 to NumberOfPeriods - 1 do begin
            TempDate := GetPeriodDateByIndex(PeriodStartDate, i);
            PeriodEnd := GetPeriodEndDate(TempDate);

            // Only add periods that don't extend beyond today
            if PeriodEnd <= AsAt then begin
                PeriodText := FormatPeriodText(TempDate);
                BusinessChartBuffer.AddColumn(PeriodText);
            end else begin
                // Adjust the number of periods to exclude future periods
                NumberOfPeriods := i;
                break;
            end;
        end;

        // Add measures for each loan product (both amount and count)
        MeasureIndex := 0;
        LoanProductsRec.Reset();
        if LoanProductsRec.FindSet() then begin
            repeat
                // Create measure names
                MeasureName := LoanProductsRec."Product Description" + ' (Amount)';
                CountMeasureName := LoanProductsRec."Product Description" + ' (Count)';

                // Add both measures - amount as line chart and count as secondary measure
                BusinessChartBuffer.AddMeasure(MeasureName, 1, BusinessChartBuffer."Data Type"::Decimal, BusinessChartBuffer."Chart Type"::Line);
                BusinessChartBuffer.AddMeasure(CountMeasureName, 2, BusinessChartBuffer."Data Type"::Decimal, BusinessChartBuffer."Chart Type"::Column);

                // Calculate arrears for each period for this product
                for i := 0 to NumberOfPeriods - 1 do begin
                    TempDate := GetPeriodDateByIndex(PeriodStartDate, i);
                    PeriodEnd := GetPeriodEndDate(TempDate);

                    CalculateProductArrearsWithCount(LoanProductsRec.Code, PeriodEnd, ArrearsAmount, ArrearsCount);

                    // Set both amount and count values for this period
                    BusinessChartBuffer.SetValue(MeasureName, i, ArrearsAmount);
                    BusinessChartBuffer.SetValue(CountMeasureName, i, ArrearsCount);
                end;

                MeasureIndex += 2; // Increment by 2 since we added 2 measures per product
            until LoanProductsRec.Next() = 0;
        end;

        // Update the chart
        BusinessChartBuffer.Update(CurrPage.Chart);
    end;

    local procedure CalculateProductArrearsWithCount(ProductID: Code[20]; AsAtDate: Date; var TotalArrears: Decimal; var ArrearsCount: Integer)
    var
        LoansRegisterRec: Record "Loans Register";
        LoanArrears: Decimal;
        ExpectedBalance: Decimal;
        ActualBalance: Decimal;
    begin
        TotalArrears := 0;
        ArrearsCount := 0;

        LoansRegisterRec.Reset();
        LoansRegisterRec.CalcFields("Outstanding Balance");
        LoansRegisterRec.SetRange("Loan Product Type", ProductID);
        LoansRegisterRec.SetFilter("Outstanding Balance", '>0');
        LoansRegisterRec.SetRange(Posted, true);
        LoansRegisterRec.SetRange(Reversed, false);
        LoansRegisterRec.SetFilter("Loan Disbursement Date", '<=%1', AsAtDate);

        if LoansRegisterRec.FindSet() then begin
            repeat
                ExpectedBalance := GetExpectedPaymentAmount(LoansRegisterRec, AsAtDate);
                ActualBalance := GetActualPaymentAmount(LoansRegisterRec, AsAtDate);

                if ActualBalance > ExpectedBalance then begin
                    LoanArrears := ActualBalance - ExpectedBalance;
                    TotalArrears += LoanArrears;
                    ArrearsCount += 1;
                end
            until LoansRegisterRec.Next() = 0;
        end;
    end;

    local procedure CalculateNumberOfPeriods(StartDate: Date; EndDate: Date): Integer
    var
        PeriodCount: Integer;
        TempStartDate: Date;
    begin
        PeriodCount := 0;
        TempStartDate := StartDate;

        case PeriodFilter of
            PeriodFilter::Day:
                PeriodCount := EndDate - StartDate + 1;
            PeriodFilter::Week:
                begin
                    while TempStartDate <= EndDate do begin
                        PeriodCount += 1;
                        TempStartDate := CalcDate('<+1W>', TempStartDate);
                    end;
                end;
            PeriodFilter::Month:
                begin
                    while TempStartDate <= EndDate do begin
                        PeriodCount += 1;
                        TempStartDate := CalcDate('<+1M>', TempStartDate);
                    end;
                end;
            PeriodFilter::Quarter:
                begin
                    while TempStartDate <= EndDate do begin
                        PeriodCount += 1;
                        TempStartDate := CalcDate('<+3M>', TempStartDate);
                    end;
                end;
            PeriodFilter::Year:
                begin
                    while TempStartDate <= EndDate do begin
                        PeriodCount += 1;
                        TempStartDate := CalcDate('<+1Y>', TempStartDate);
                    end;
                end;
        end;

        exit(PeriodCount);
    end;

    local procedure GetPeriodDateByIndex(StartDate: Date; PeriodIndex: Integer): Date
    var
        ResultDate: Date;
    begin
        ResultDate := StartDate;

        case PeriodFilter of
            PeriodFilter::Day:
                ResultDate := CalcDate('<+' + Format(PeriodIndex) + 'D>', StartDate);
            PeriodFilter::Week:
                ResultDate := CalcDate('<+' + Format(PeriodIndex) + 'W>', StartDate);
            PeriodFilter::Month:
                ResultDate := CalcDate('<+' + Format(PeriodIndex) + 'M>', StartDate);
            PeriodFilter::Quarter:
                ResultDate := CalcDate('<+' + Format(PeriodIndex * 3) + 'M>', StartDate);
            PeriodFilter::Year:
                ResultDate := CalcDate('<+' + Format(PeriodIndex) + 'Y>', StartDate);
        end;

        exit(ResultDate);
    end;

    local procedure GetPeriodEndDate(StartDate: Date): Date
    var
        EndDate: Date;
    begin
        case PeriodFilter of
            PeriodFilter::Day:
                EndDate := StartDate;
            PeriodFilter::Week:
                EndDate := CalcDate('<+1W-1D>', StartDate);
            PeriodFilter::Month:
                EndDate := CalcDate('<+1M-1D>', StartDate);
            PeriodFilter::Quarter:
                EndDate := CalcDate('<+3M-1D>', StartDate);
            PeriodFilter::Year:
                EndDate := CalcDate('<+1Y-1D>', StartDate);
        end;

        exit(EndDate);
    end;

    local procedure FormatPeriodText(PeriodDate: Date): Text[30]
    var
        PeriodText: Text[30];
    begin
        case PeriodFilter of
            PeriodFilter::Day:
                PeriodText := Format(PeriodDate, 0, '<Day,2>/<Month,2>');
            PeriodFilter::Week:
                PeriodText := Format(PeriodDate, 0, 'Week <Week,2>');
            PeriodFilter::Month:
                PeriodText := Format(PeriodDate, 0, '<Month Text,3> <Year4>');
            PeriodFilter::Quarter:
                PeriodText := 'Q' + Format(Round((Date2DMY(PeriodDate, 2) - 1) / 3, 1, '>') + 1) + ' ' + Format(Date2DMY(PeriodDate, 3));
            PeriodFilter::Year:
                PeriodText := Format(PeriodDate, 0, '<Year4>');
        end;

        exit(PeriodText);
    end;

    local procedure GetExpectedPaymentAmount(var LoansRegisterRec: Record "Loans Register"; AsAtDate: Date): Decimal
    var
        LoanRepaymentSchedule: Record "Loan Repayment Schedule";
        Swizzfactory: Codeunit 50009;
        TotalExpected: Decimal;
    begin
        TotalExpected := LoansRegisterRec."Approved Amount";

        LoanRepaymentSchedule.Reset();
        LoanRepaymentSchedule.SetRange("Loan No.", LoansRegisterRec."Loan  No.");

        if LoanRepaymentSchedule.FindSet() then begin
            LoanRepaymentSchedule.Reset();
            LoanRepaymentSchedule.SetRange("Loan No.", LoansRegisterRec."Loan  No.");
            LoanRepaymentSchedule.SetFilter("Repayment Date", '<=%1', AsAtDate);

            if LoanRepaymentSchedule.FindLast() then begin
                TotalExpected := LoanRepaymentSchedule."Loan Balance";
            end;
        end else begin
            Swizzfactory.FnGenerateRepaymentSchedule(LoansRegisterRec."Loan  No.");

            LoanRepaymentSchedule.Reset();
            LoanRepaymentSchedule.SetRange("Loan No.", LoansRegisterRec."Loan  No.");
            LoanRepaymentSchedule.SetFilter("Repayment Date", '<=%1', AsAtDate);

            if LoanRepaymentSchedule.FindLast() then begin
                TotalExpected := Round(LoanRepaymentSchedule."Loan Balance");
            end;
        end;

        // Update the expected loan balance
        //LoansRegisterRec."Expected Loan Balance" := TotalExpected;
        exit(TotalExpected);
    end;

    local procedure GetActualPaymentAmount(var LoansRegisterRec: Record "Loans Register"; AsAtDate: Date): Decimal
    var
        LoanLedgerEntry: Record "Cust. Ledger Entry";
        TotalActual: Decimal;
    begin
        TotalActual := 0;

        LoanLedgerEntry.Reset();
        LoanLedgerEntry.SetRange("Customer No.", LoansRegisterRec."Client Code");
        LoanLedgerEntry.SetRange("Loan No", LoansRegisterRec."Loan  No.");
        LoanLedgerEntry.SetFilter("Transaction Type", '%1|%2|%3|%4|%5',
            LoanLedgerEntry."Transaction Type"::"Loan Repayment",
            LoanLedgerEntry."Transaction Type"::"Interest Paid",
            LoanLedgerEntry."Transaction Type"::Loan,
            LoanLedgerEntry."Transaction Type"::"Interest Due",
            LoanLedgerEntry."Transaction Type"::"Loan Transfer Charges");
        LoanLedgerEntry.SetRange(Reversed, false);
        LoanLedgerEntry.SetFilter("Posting Date", '<=%1', AsAtDate);

        if LoanLedgerEntry.FindSet() then begin
            repeat
                TotalActual += LoanLedgerEntry."Amount Posted";
            until LoanLedgerEntry.Next() = 0;
        end;

        exit(TotalActual);
    end;

    local procedure GetLastDueDateBeforeAsAt(var LoansRegisterRec: Record "Loans Register"): Date
    var
        LoanRepaymentSchedule: Record "Loan Repayment Schedule";
        LastDate: Date;
    begin
        LastDate := 0D;
        LoanRepaymentSchedule.Reset();
        LoanRepaymentSchedule.SetRange("Loan No.", LoansRegisterRec."Loan  No.");
        LoanRepaymentSchedule.SetFilter("Repayment Date", '<=%1', AsAt);
        LoanRepaymentSchedule.SetCurrentKey("Repayment Date");

        if LoanRepaymentSchedule.FindLast() then
            LastDate := LoanRepaymentSchedule."Repayment Date";

        exit(LastDate);
    end;

    local procedure GetFirstDateWhereInArrears(var LoansRegisterRec: Record "Loans Register"; ActualBalance: Decimal): Date
    var
        LoanRepaymentSchedule: Record "Loan Repayment Schedule";
        RunningExpectedBalance: Decimal;
    begin
        LoanRepaymentSchedule.Reset();
        LoanRepaymentSchedule.SetRange("Loan No.", LoansRegisterRec."Loan  No.");
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

    // Public procedures for external configuration
    procedure SetPeriodFilter(NewPeriodFilter: Option Day,Week,Month,Quarter,Year)
    begin
        PeriodFilter := NewPeriodFilter;
        NumberOfPeriods := CalculateNumberOfPeriods(PeriodStartDate, AsAt);
        LoadAndDisplayChart();
    end;

    procedure SetNumberOfPeriods(NewNumberOfPeriods: Integer)
    begin
        // This procedure is kept for compatibility but periods are now auto-calculated
        // You can still manually override if needed
        NumberOfPeriods := NewNumberOfPeriods;
        LoadAndDisplayChart();
    end;

    procedure SetAsAtDate(NewAsAtDate: Date)
    begin
        AsAt := NewAsAtDate;
        NumberOfPeriods := CalculateNumberOfPeriods(PeriodStartDate, AsAt);
        LoadAndDisplayChart();
    end;

    procedure SetPeriodStartDate(NewStartDate: Date)
    begin
        PeriodStartDate := NewStartDate;
        NumberOfPeriods := CalculateNumberOfPeriods(PeriodStartDate, AsAt);
        LoadAndDisplayChart();
    end;

    procedure RefreshChart()
    begin
        LoadAndDisplayChart();
    end;
}