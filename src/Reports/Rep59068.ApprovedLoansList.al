report 59068 "Approved Loans List-Grouped"
{
    Caption = 'Approved Loans List-Grouped';
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = './Layout/ApprovedLoansListGrouped.rdl';

    dataset
    {
        dataitem(LoansRegister; "Loans Register")
        {
            DataItemTableView = where("Approval Status" = const(Approved));

            column(Date; DateToShow) { }
            column(Member_Name; MemberNameToShow) { }
            column(Loan_Type; LoanTypeToShow) { }
            column(Amount_Applied; AmountAppliedToShow) { Caption = 'Amount Applied'; }
            column(Amount_Payable; AmountPayableToShow) { Caption = 'Amount Disbursed'; }
            column(Amount_Paid; AmountPaidToShow) { Caption = 'Amount Paid'; }
            column(Amount_Due_For_Payment; AmountDueToShow) { Caption = 'Amount Due'; }
            column(Repayment_Period; RepaymentPeriodToShow) { Caption = 'Repayment Period'; }
            column(Status; StatusToShow) { Caption = 'Status'; }
            column(Company_Name; Company.Name) { }
            column(Company_Address; Company.Address) { }
            column(Company_Address_2; Company."Address 2") { }
            column(Company_Phone_No; Company."Phone No.") { }
            column(Company_Fax_No; Company."Fax No.") { }
            column(Company_Picture; Company.Picture) { }
            column(Company_Email; Company."E-Mail") { }

            trigger OnPreDataItem()
            var
                LoanProductsSetup: Record "Loan Products Setup";
            begin
                // Apply date filter
                if (StartDateFilter <> 0D) and (EndDateFilter <> 0D) then
                    SetRange("Application Date", StartDateFilter, EndDateFilter)
                else if StartDateFilter <> 0D then
                    SetFilter("Application Date", '>=%1', StartDateFilter)
                else if EndDateFilter <> 0D then
                    SetFilter("Application Date", '<=%1', EndDateFilter);

                // Apply loan type filter - SIMPLIFIED LOGIC
                if SelectedLoanProductCode <> '' then begin
                    // Filter by the selected loan product code
                    SetRange("Loan Product Type", SelectedLoanProductCode);
                end;
                // If SelectedLoanProductCode is empty, show ALL loan types (no filter applied)

                // Init totals
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
                if TotalRowProcessed then
                    exit;

                TotalTopUpDeductions := 0;
                totalloandeductions := 0;
                netdisbursed := 0;
                netpaid := 0;
                netdueamount := 0;

                // Top-up deductions
                LoanTopUp.Reset;
                LoanTopUp.SetRange("Loan No.", LoansRegister."Loan  No.");
                if LoanTopUp.Find('-') then
                    repeat
                        TotalTopUpDeductions += LoanTopUp."Principle Top Up" + LoanTopUp."Interest Top Up" + LoanTopUp.Commision;
                    until LoanTopUp.Next() = 0;

                // Loan deductions
                totalloandeductions := LoansRegister."Facilitation Cost" + LoansRegister."Valuation Cost" + LoansRegister."Loan Insurance";

                // Net disbursed
                netdisbursed := LoansRegister."Approved Amount" - totalloandeductions - TotalTopUpDeductions;

                // Paid vs due
                if LoansRegister."Loan Status" = LoansRegister."Loan Status"::Issued then begin
                    netpaid := netdisbursed;
                    netdueamount := 0;
                end else begin
                    netpaid := 0;
                    netdueamount := netdisbursed;
                end;

                // Display values
                DateToShow := LoansRegister."Application Date";
                MemberNameToShow := LoansRegister."Client Name";
                LoanTypeToShow := LoansRegister."Loan Product Type Name";
                AmountAppliedToShow := LoansRegister."Requested Amount";
                AmountPayableToShow := netdisbursed;
                AmountPaidToShow := netpaid;
                AmountDueToShow := netdueamount;
                RepaymentPeriodToShow := LoansRegister.Installments;
                StatusToShow := Format(LoansRegister."Approval Status");

                // Accumulate totals
                GrandTotalAmountApplied += LoansRegister."Requested Amount";
                GrandTotalNetDisbursed += netdisbursed;
                GrandTotalNetPaid += netpaid;
                GrandTotalNetDueAmount += netdueamount;
            end;

            trigger OnPostDataItem()
            begin
                if Count > 0 then begin
                    TotalRowProcessed := true;
                    Clear(LoansRegister);

                    // Totals row
                    DateToShow := 0D;
                    MemberNameToShow := 'GRAND TOTALS';
                    LoanTypeToShow := '';
                    AmountAppliedToShow := GrandTotalAmountApplied;
                    AmountPayableToShow := GrandTotalNetDisbursed;
                    AmountPaidToShow := GrandTotalNetPaid;
                    AmountDueToShow := GrandTotalNetDueAmount;
                    RepaymentPeriodToShow := 0;
                    StatusToShow := '';
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
                    }

                    field(EndDate; EndDateFilter)
                    {
                        ApplicationArea = All;
                        Caption = 'End Date';
                    }
                }

                group(LoanFilters)
                {
                    Caption = 'Loan Type Filter';

                    field(LoanProductType; SelectedLoanProductCode)
                    {
                        ApplicationArea = All;
                        Caption = 'Loan Product Type';
                        TableRelation = "Loan Products Setup";
                    }
                }
            }
        }

        trigger OnOpenPage()
        begin
            StartDateFilter := CalcDate('<-CM>', Today);
            EndDateFilter := Today;
            SelectedLoanProductCode := ''; // Empty = Show All
        end;
    }

    trigger OnInitReport()
    begin
        Company.Get();
    end;

    var
        StartDateFilter: Date;
        EndDateFilter: Date;
        SelectedLoanProductCode: Code[20];
        netdisbursed: Decimal;
        netpaid: Decimal;
        netdueamount: Decimal;
        TotalRowProcessed: Boolean;

        GrandTotalAmountApplied: Decimal;
        GrandTotalNetDisbursed: Decimal;
        GrandTotalNetPaid: Decimal;
        GrandTotalNetDueAmount: Decimal;

        DateToShow: Date;
        Company: Record "Company Information";
        MemberNameToShow: Text[100];
        LoanTypeToShow: Text[100];
        AmountAppliedToShow: Decimal;
        AmountPayableToShow: Decimal;
        AmountPaidToShow: Decimal;
        AmountDueToShow: Decimal;
        RepaymentPeriodToShow: Integer;
        StatusToShow: Text[50];
}