#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 59062 "Loan Portfolio Analysis Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/LoanPortfolioAnalysis.rdlc';
    Caption = 'Loan Portfolio Analysis Report';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    dataset
    {
        dataitem(Company; "Company Information")
        {
            column(ReportForNavId_1; 1)
            {
            }
            column(CompanyName; Company.Name)
            {
            }
            column(CompanyAddress; Company.Address)
            {
            }
            column(CompanyAddress2; Company."Address 2")
            {
            }
            column(CompanyPhone; Company."Phone No.")
            {
            }
            column(CompanyEmail; Company."E-Mail")
            {
            }
            column(CompanyPicture; Company.Picture)
            {
            }
            column(ReportDate; Format(Today, 0, 4))
            {
            }
            column(AsAtDate; AsAtDate)
            {
            }
            column(StartDate; StartDate)
            {
            }
            column(EndDate; EndDate)
            {
            }
            column(ReportTitle; ReportTitleLbl)
            {
            }
            column(AsAtCaption; AsAtCaptionLbl)
            {
            }
            column(ReportGeneratedBy; UserId)
            {
            }
        }

        dataitem(LoanProducts; "Loan Products Setup")
        {
            DataItemTableView = sorting(Code);
            RequestFilterFields = Code, "Product Description", "Interest rate";

            column(ReportForNavId_2; 2)
            {
            }
            column(ProductCode; Code)
            {
            }
            column(ProductDescription; "Product Description")
            {
            }
            column(InterestRate; "Interest rate")
            {
                DecimalPlaces = 2 : 2;
            }
            column(TotalLoans; TotalLoans)
            {
            }
            column(TotalAmount; TotalAmount)
            {
                DecimalPlaces = 2 : 2;
            }
            column(OutstandingAmount; OutstandingAmount)
            {
                DecimalPlaces = 2 : 2;
            }
            column(InterestEarned; InterestEarned)
            {
                DecimalPlaces = 2 : 2;
            }
            column(InterestArrears; InterestArrears)
            {
                DecimalPlaces = 2 : 2;
            }
            column(PrincipalArrears; PrincipalArrears)
            {
                DecimalPlaces = 2 : 2;
            }
            column(ArrearsPercentage; ArrearsPercentage)
            {
                DecimalPlaces = 2 : 2;
            }
            column(InterestReturnRate; InterestReturnRate)
            {
                DecimalPlaces = 2 : 2;
            }
            column(PerformingLoans; PerformingLoans)
            {
            }
            column(WatchLoans; WatchLoans)
            {
            }
            column(SubstandardLoans; SubstandardLoans)
            {
            }
            column(DoubtfulLoans; DoubtfulLoans)
            {
            }
            column(LossLoans; LossLoans)
            {
            }
            column(TotalRiskLoans; TotalRiskLoans)
            {
            }
            column(RiskPercentage; RiskPercentage)
            {
                DecimalPlaces = 2 : 2;
            }
            column(AverageLoanSize; AverageLoanSize)
            {
                DecimalPlaces = 2 : 2;
            }
            column(TotalInterestDue; TotalInterestDue)
            {
                DecimalPlaces = 2 : 2;
            }
            column(InterestCollectionRate; InterestCollectionRate)
            {
                DecimalPlaces = 2 : 2;
            }

            dataitem(LoansRegister; "Loans Register")
            {
                DataItemLink = "Loan Product Type" = field(Code);
                DataItemTableView = sorting("Loan Product Type", "Outstanding Balance")
                                   where(Posted = const(true), "Outstanding Balance" = filter(<> 0));
                RequestFilterFields = "Client Code", "Branch Code", "Issued Date", "Date filter";

                column(ReportForNavId_3; 3)
                {
                }
                column(LoanNo; "Loan  No.")
                {
                }
                column(ClientCode; "Client Code")
                {
                }
                column(ClientName; "Client Name")
                {
                }
                column(ApprovedAmount; "Approved Amount")
                {
                    DecimalPlaces = 2 : 2;
                }
                column(OutstandingBalance; "Outstanding Balance")
                {
                    DecimalPlaces = 2 : 2;
                }
                column(OutstandingInterest; "Oustanding Interest")
                {
                    DecimalPlaces = 2 : 2;
                }
                column(AmountInArrears; "Amount in Arrears")
                {
                    DecimalPlaces = 2 : 2;
                }
                column(DaysInArrears; DaysInArrears)
                {
                }
                column(LoanCategory; "Loans Category-SASRA")
                {
                }
                column(IssuedDate; "Issued Date")
                {
                }
                column(LastPayDate; "Last Pay Date")
                {
                }
                column(ExpectedCompletionDate; "Expected Date of Completion")
                {
                }
                column(Repayment; Repayment)
                {
                    DecimalPlaces = 2 : 2;
                }
                column(Installments; Installments)
                {
                }
                column(Interest; Interest)
                {
                    DecimalPlaces = 2 : 2;
                }
                column(BranchCode; "Branch Code")
                {
                }
                column(EmployerCode; "Employer Code")
                {
                }
                column(StaffNo; "Staff No")
                {
                }
                column(PrincipalPaid; "Principal Paid")
                {
                    DecimalPlaces = 2 : 2;
                }
                column(InterestPaid; "Interest Paid")
                {
                    DecimalPlaces = 2 : 2;
                }
                column(PenaltyPaid; "Penalty Paid")
                {
                    DecimalPlaces = 2 : 2;
                }

                trigger OnAfterGetRecord()
                begin
                    CalculateLoanMetrics();
                end;
            }

            trigger OnAfterGetRecord()
            begin
                CalculateProductMetrics();
                CalculateRiskClassifications();
                CalculateInterestReturns();
            end;

            trigger OnPreDataItem()
            begin
                // Initialize date filters if not set
                if AsAtDate = 0D then
                    AsAtDate := Today;
                if StartDate = 0D then
                    StartDate := CalcDate('-1Y', AsAtDate);
                if EndDate = 0D then
                    EndDate := AsAtDate;
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
                    Caption = 'Report Options';
                    field(AsAtDate; AsAtDate)
                    {
                        ApplicationArea = All;
                        Caption = 'As At Date';
                        ToolTip = 'Specifies the date as of which the report will be generated';
                    }
                    field(StartDate; StartDate)
                    {
                        ApplicationArea = All;
                        Caption = 'Start Date';
                        ToolTip = 'Specifies the start date for interest calculations';
                    }
                    field(EndDate; EndDate)
                    {
                        ApplicationArea = All;
                        Caption = 'End Date';
                        ToolTip = 'Specifies the end date for interest calculations';
                    }
                }
            }
        }

        trigger OnOpenPage()
        begin
            if AsAtDate = 0D then
                AsAtDate := Today;
            if StartDate = 0D then
                StartDate := CalcDate('-1Y', AsAtDate);
            if EndDate = 0D then
                EndDate := AsAtDate;
        end;
    }

    trigger OnPreReport()
    begin
        // Initialize date filters
        if AsAtDate = 0D then
            AsAtDate := Today;
        if StartDate = 0D then
            StartDate := CalcDate('-1Y', AsAtDate);
        if EndDate = 0D then
            EndDate := AsAtDate;
    end;

    var
        // Summary Variables
        TotalLoans: Integer;
        TotalAmount: Decimal;
        OutstandingAmount: Decimal;
        InterestEarned: Decimal;
        InterestArrears: Decimal;
        PrincipalArrears: Decimal;
        ArrearsPercentage: Decimal;
        InterestReturnRate: Decimal;
        TotalInterestDue: Decimal;
        InterestCollectionRate: Decimal;

        // Risk Classification Counts
        PerformingLoans: Integer;
        WatchLoans: Integer;
        SubstandardLoans: Integer;
        DoubtfulLoans: Integer;
        LossLoans: Integer;
        TotalRiskLoans: Integer;
        RiskPercentage: Decimal;

        // Additional Metrics
        AverageLoanSize: Decimal;
        DaysInArrears: Integer;

        // Date Filters
        AsAtDate: Date;
        StartDate: Date;
        EndDate: Date;

        // Labels
        ReportTitleLbl: Label 'Loan Portfolio Analysis Report';
        AsAtCaptionLbl: Label 'As At:';

    procedure InitializeRequest(NewAsAtDate: Date; NewStartDate: Date; NewEndDate: Date)
    begin
        AsAtDate := NewAsAtDate;
        StartDate := NewStartDate;
        EndDate := NewEndDate;
    end;

    procedure CalculateProductMetrics()
    var
        LoansRec: Record "Loans Register";
        CustLedgerEntry: Record "Cust. Ledger Entry";
    begin
        // Reset counters
        TotalLoans := 0;
        TotalAmount := 0;
        OutstandingAmount := 0;
        InterestEarned := 0;
        InterestArrears := 0;
        PrincipalArrears := 0;
        TotalInterestDue := 0;
        AverageLoanSize := 0;

        // Calculate loan counts and amounts
        LoansRec.Reset;
        LoansRec.SetRange("Loan Product Type", LoanProducts.Code);
        LoansRec.SetRange(Posted, true);
        LoansRec.SetFilter("Outstanding Balance", '<>0');

        if LoansRec.FindSet() then begin
            repeat
                TotalLoans += 1;
                TotalAmount += LoansRec."Approved Amount";
                OutstandingAmount += LoansRec."Outstanding Balance";
                InterestArrears += LoansRec."Oustanding Interest";
                PrincipalArrears += LoansRec."Amount in Arrears";
                TotalInterestDue += LoansRec."Oustanding Interest";
            until LoansRec.Next() = 0;

            if TotalLoans > 0 then
                AverageLoanSize := TotalAmount / TotalLoans;
        end;

        // Calculate interest earned from ledger entries
        CustLedgerEntry.Reset;
        CustLedgerEntry.SetRange("Transaction Type", CustLedgerEntry."Transaction Type"::"Interest Paid");
        CustLedgerEntry.SetRange("Posting Date", StartDate, EndDate);

        if CustLedgerEntry.FindSet() then begin
            CustLedgerEntry.CalcSums("Amount Posted");
            InterestEarned := CustLedgerEntry."Amount Posted" * -1;

            // Estimate product-specific interest based on loan amounts
            if TotalAmount > 0 then begin
                InterestEarned := InterestEarned * (TotalAmount / GetTotalPortfolioAmount());
            end;
        end;

        // Calculate percentages
        if TotalAmount > 0 then begin
            ArrearsPercentage := (PrincipalArrears / TotalAmount) * 100;
        end;

        if OutstandingAmount > 0 then begin
            InterestReturnRate := (InterestEarned / OutstandingAmount) * 100;
        end;

        if TotalInterestDue > 0 then begin
            InterestCollectionRate := ((TotalInterestDue - InterestArrears) / TotalInterestDue) * 100;
        end;
    end;

    local procedure GetTotalPortfolioAmount(): Decimal
    var
        LoansRec: Record "Loans Register";
        TotalAmount: Decimal;
    begin
        LoansRec.Reset;
        LoansRec.SetRange(Posted, true);
        LoansRec.SetFilter("Outstanding Balance", '<>0');

        if LoansRec.FindSet() then begin
            LoansRec.CalcSums("Approved Amount");
            TotalAmount := LoansRec."Approved Amount";
        end;

        exit(TotalAmount);
    end;

    procedure CalculateRiskClassifications()
    var
        LoansRec: Record "Loans Register";
    begin
        // Reset counters
        PerformingLoans := 0;
        WatchLoans := 0;
        SubstandardLoans := 0;
        DoubtfulLoans := 0;
        LossLoans := 0;
        TotalRiskLoans := 0;

        LoansRec.Reset;
        LoansRec.SetRange("Loan Product Type", LoanProducts.Code);
        LoansRec.SetRange(Posted, true);
        LoansRec.SetFilter("Outstanding Balance", '<>0');

        if LoansRec.FindSet() then begin
            repeat
                case LoansRec."Loans Category-SASRA" of
                    LoansRec."Loans Category-SASRA"::Perfoming:
                        PerformingLoans += 1;
                    LoansRec."Loans Category-SASRA"::Watch:
                        WatchLoans += 1;
                    LoansRec."Loans Category-SASRA"::Substandard:
                        SubstandardLoans += 1;
                    LoansRec."Loans Category-SASRA"::Doubtful:
                        DoubtfulLoans += 1;
                    LoansRec."Loans Category-SASRA"::Loss:
                        LossLoans += 1;
                    else
                        // If category is not set, treat as performing
                        PerformingLoans += 1;
                end;
            until LoansRec.Next() = 0;
        end;

        TotalRiskLoans := WatchLoans + SubstandardLoans + DoubtfulLoans + LossLoans;

        if TotalLoans > 0 then
            RiskPercentage := (TotalRiskLoans / TotalLoans) * 100;
    end;

    procedure CalculateInterestReturns()
    begin
        // Additional interest return calculations can be added here
        // This method is called after basic metrics are calculated
    end;

    procedure CalculateLoanMetrics()
    begin
        // Calculate days in arrears for individual loans
        if LoansRegister."Last Pay Date" <> 0D then begin
            DaysInArrears := AsAtDate - LoansRegister."Last Pay Date";
            if DaysInArrears < 0 then
                DaysInArrears := 0;
        end else begin
            DaysInArrears := 0;
        end;
    end;
}