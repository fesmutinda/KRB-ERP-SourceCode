Report 59066 "Approved Loans List"
{
    Caption = 'Approved Loans List';
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = Excel;
    ExcelLayout = './Layout/ApprovedLoansList.xlsx';

    dataset
    {
        dataitem(LoansRegister; "Loans Register")
        {
            DataItemTableView = where(
                    "Approval Status" = const(Approved),
                    "Loan Product Type Name" = filter(<> 'INSTANT LOAN'));

            column(Date; DateToShow) { }
            column(Member_Name; MemberNameToShow) { }
            column(Loan_Type; LoanTypeToShow) { }
            column(Amount_Applied; AmountAppliedToShow)
            {
                Caption = 'Amount Applied';
            }
            column(Amount_Payable; AmountPayableToShow) { Caption = 'Amount Disbursed'; }
            column(Amount_Paid; AmountPaidToShow) { Caption = 'Amount Paid'; }
            column(Amount_Due_For_Payment; AmountDueToShow) { Caption = 'Amount Due For Payment'; }
            column(Repayment_Period; RepaymentPeriodToShow) { Caption = 'Repayment Period'; }
            column(Status; StatusToShow) { Caption = 'Status'; }

            trigger OnPreDataItem()
            begin
                // Apply date filter
                if (StartDateFilter <> 0D) and (EndDateFilter <> 0D) then
                    SetRange("Application Date", StartDateFilter, EndDateFilter)
                else if StartDateFilter <> 0D then
                    SetFilter("Application Date", '>=%1', StartDateFilter)
                else if EndDateFilter <> 0D then
                    SetFilter("Application Date", '<=%1', EndDateFilter);

                // Exclude instant loans (redundant safety for runtime)
                SetFilter("Loan Product Type Name", '<>INSTANT');

                // Initialize totals
                GrandTotalAmountApplied := 0;
                GrandTotalNetDisbursed := 0;
                GrandTotalNetPaid := 0;
                GrandTotalNetDueAmount := 0;
                TotalRowProcessed := false;
            end;

            trigger OnAfterGetRecord()
            var
                LoanTopUp: Record "Loan Offset Details";
                TotalTopUpDeductions: Decimal;
                totalloandeductions: Decimal;
            begin
                // Don't process if this is our fake totals record
                if TotalRowProcessed then
                    exit;

                // Initialize variables for each record
                TotalTopUpDeductions := 0;
                totalloandeductions := 0;
                netdisbursed := 0;
                netpaid := 0;
                netdueamount := 0;

                // Calculate top-up deductions
                LoanTopUp.Reset;
                LoanTopUp.SetRange(LoanTopUp."Loan No.", LoansRegister."Loan  No.");
                if LoanTopUp.Find('-') then
                    repeat
                        TotalTopUpDeductions := TotalTopUpDeductions + LoanTopUp."Principle Top Up" + LoanTopUp."Interest Top Up" + LoanTopUp.Commision;
                    until LoanTopUp.Next = 0;

                // Calculate total loan deductions
                totalloandeductions := LoansRegister."Facilitation Cost" + LoansRegister."Valuation Cost" + LoansRegister."Loan Insurance";

                // Calculate net disbursed amount
                netdisbursed := LoansRegister."Approved Amount" - totalloandeductions - TotalTopUpDeductions;

                // Set values based on loan status
                if LoansRegister."Loan Status" = LoansRegister."Loan Status"::Issued then begin
                    netpaid := netdisbursed;
                    netdueamount := 0;
                end else begin
                    netpaid := 0;
                    netdueamount := netdisbursed;
                end;

                // Set display values for regular records
                DateToShow := LoansRegister."Application Date";
                MemberNameToShow := LoansRegister."Client Name";
                LoanTypeToShow := LoansRegister."Loan Product Type Name";
                AmountAppliedToShow := LoansRegister."Requested Amount";
                AmountPayableToShow := netdisbursed;
                AmountPaidToShow := netpaid;
                AmountDueToShow := netdueamount;
                RepaymentPeriodToShow := LoansRegister.Installments;
                StatusToShow := Format(LoansRegister."Approval Status");

                // Accumulate grand totals
                GrandTotalAmountApplied += LoansRegister."Requested Amount";
                GrandTotalNetDisbursed += netdisbursed;
                GrandTotalNetPaid += netpaid;
                GrandTotalNetDueAmount += netdueamount;
            end;

            trigger OnPostDataItem()
            begin
                // After processing all records, add one more "fake" record for totals
                if Count > 0 then begin
                    TotalRowProcessed := true;

                    // Clear the record and set totals values
                    Clear(LoansRegister);

                    // Set display values for totals row
                    DateToShow := 0D; // Blank date
                    MemberNameToShow := 'GRAND TOTALS';
                    LoanTypeToShow := '';
                    AmountAppliedToShow := GrandTotalAmountApplied;
                    AmountPayableToShow := GrandTotalNetDisbursed;
                    AmountPaidToShow := GrandTotalNetPaid;
                    AmountDueToShow := GrandTotalNetDueAmount;
                    RepaymentPeriodToShow := 0;
                    StatusToShow := '';

                    // This will trigger OnAfterGetRecord one more time for the totals row
                    // But OnAfterGetRecord will exit early due to TotalRowProcessed flag
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
                group(DateFilters)
                {
                    Caption = 'Date Filters';

                    field(StartDate; StartDateFilter)
                    {
                        ApplicationArea = All;
                        Caption = 'Start Date';
                        ToolTip = 'Select the start date for filtering loans by application date';
                    }

                    field(EndDate; EndDateFilter)
                    {
                        ApplicationArea = All;
                        Caption = 'End Date';
                        ToolTip = 'Select the end date for filtering loans by application date';
                    }
                }
            }
        }

        trigger OnOpenPage()
        begin
            StartDateFilter := CalcDate('<-CM>', Today);
            EndDateFilter := Today;
        end;
    }

    var
        StartDateFilter: Date;
        EndDateFilter: Date;
        netdisbursed: Decimal;
        netpaid: Decimal;
        netdueamount: Decimal;
        TotalRowProcessed: Boolean;

        // Grand total variables
        GrandTotalAmountApplied: Decimal;
        GrandTotalNetDisbursed: Decimal;
        GrandTotalNetPaid: Decimal;
        GrandTotalNetDueAmount: Decimal;

        // Display variables
        DateToShow: Date;
        MemberNameToShow: Text[100];
        LoanTypeToShow: Text[100];
        AmountAppliedToShow: Decimal;
        AmountPayableToShow: Decimal;
        AmountPaidToShow: Decimal;
        AmountDueToShow: Decimal;
        RepaymentPeriodToShow: Integer;
        StatusToShow: Text[50];
}