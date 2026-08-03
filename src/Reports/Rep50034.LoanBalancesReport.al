report 50034 "Loan Balances Report"
{
    ApplicationArea = All;
    Caption = 'Kenya Roads Board Sacco - Loans Book Report';
    UsageCategory = ReportsAndAnalysis;
    RDLCLayout = './Layouts/LoanBalancesReport.rdlc';
    dataset
    {
        dataitem(LoansRegister; "Loans Register")
        {
            DataItemTableView = sorting("Loan  No.") order(ascending) where(Posted = const(true));
            RequestFilterFields = Source, "Client Code", "Branch Code", "Outstanding Balance", "Issued Date", "Date filter";

            column(EntryNo; EntryNo)
            {
            }

            column(DateFilterUsed; DateFilterUsed) { }

            column(LoanProductTypeFilter; LoanProductTypeFilter) { }
            column(CompanyName; CompanyInfo.Name)
            {
            }
            column(CompanyAddress; CompanyInfo.Address)
            {
            }
            column(CompanyAddress2; CompanyInfo."Address 2")
            {
            }
            column(CompanyPhone; CompanyInfo."Phone No.")
            {
            }
            column(CompanyPic; CompanyInfo.Picture)
            {
            }
            column(CompanyEmail; CompanyInfo."E-Mail")
            {
            }
            column(ClientCode; MemberNo)
            {
            }
            column(ClientName; MemberName)
            {
            }
            column(Loan_Product_Type_Name; "Loan Product Type Name") { }
            column(Loan__No_; LoanNo)
            {
            }
            column(Installments; Installements)
            {
            }
            column(IssuedDate; "Issued Date")
            {
            }
            column(ApprovedAmount; IssuedAmount)
            {
            }
            column(PrincipalPaid; "Principal Paid")
            {
            }
            column(Outstanding_Balance; OutstandingBalance)
            {
            }
            column(InterestPaid; "Interest Paid" * -1)
            {
            }
            column(Oustanding_Interest; OutstandingInterest)
            {
            }
            column(Issued_Date; "Issued Date") { }
            column(RemainingRepayment; RemainingRepayment) { }

            dataitem(Customer; Customer)
            {
                DataItemLink = "No." = FIELD("Client Code");

                column(ID_No_; "ID No.") { }
                column(Phone_No_; "Phone No.") { }
                column(Date_of_Birth; "Date of Birth") { }
                column(Gender; Gender) { }
            }

            trigger OnPreDataItem()
            begin
                MemberNo := '';
                MemberName := '';
                LoanProductType := '';
                LoanNo := '';
                Installements := 0;
                IssuedAmount := 0;
                OutstandingBalance := 0;
                OutstandingInterest := 0;
                EntryNo := 0;

                // Apply Loan Product Type filter if selected
                if SelectedLoanProductType <> '' then begin
                    LoansRegister.SetRange("Loan Product Type", SelectedLoanProductType);
                end;
            end;

            trigger OnAfterGetRecord();
            begin
                if LoansTable.get(LoansRegister."Loan  No.") then begin
                    // Apply date range filter for balance calculations
                    LoansTable.SetRange("Date filter", StartDate, EndDate);

                    LoansTable.CalcFields(
                        LoansTable."Outstanding Balance",
                        LoansTable."Oustanding Interest"
                    );


                    if LoansTable."Outstanding Balance" = 0 then
                        CurrReport.Skip();

                    // Process the record
                    MemberNo := LoansTable."Client Code";
                    MemberName := LoansTable."Client Name";
                    LoanProductType := LoansTable."Loan Product Type";
                    LoanNo := LoansTable."Loan  No.";
                    Installements := LoansTable.Installments;
                    IssuedAmount := LoansTable."Approved Amount";
                    OutstandingBalance := LoansTable."Outstanding Balance";
                    OutstandingInterest := LoansTable."Oustanding Interest";
                    EntryNo := EntryNo + 1;

                    RemainingRepayment := FnCalculateLoanRemainingPeriod(
                        LoansTable."Outstanding Balance",
                        LoansTable."Approved Amount",
                        LoansTable.Installments,
                        LoansTable.Interest
                    );
                end;
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(content)
            {
                group("Filter Options")
                {
                    Caption = 'Filter Options';

                    field(LoanProductTypeFilter; SelectedLoanProductType)
                    {
                        ApplicationArea = All;
                        Caption = 'Loan Product Type';
                        TableRelation = "Loan Products Setup";
                    }


                    field(StartDate; StartDate)
                    {
                        ApplicationArea = All;
                        Caption = 'Start Date';
                        ToolTip = 'Select the start date for the period';

                        trigger OnValidate()
                        begin
                            if (StartDate <> 0D) and (EndDate <> 0D) and (StartDate > EndDate) then
                                Error('Start Date cannot be later than End Date');
                        end;
                    }

                    field(EndDate; EndDate)
                    {
                        ApplicationArea = All;
                        Caption = 'End Date';
                        ToolTip = 'Select the end date for the period';

                        trigger OnValidate()
                        begin
                            if (StartDate <> 0D) and (EndDate <> 0D) and (StartDate > EndDate) then
                                Error('End Date cannot be earlier than Start Date');
                        end;
                    }



                }
            }
        }

        actions
        {
            area(processing)
            {
            }
        }
    }

    trigger OnInitReport()
    begin
        SelectedLoanProductType := '';
    end;



    trigger OnPreReport()
    begin
        CompanyInfo.Get();

        if (StartDate <> 0D) and (EndDate <> 0D) and (StartDate > EndDate) then
            Error('Start Date cannot be later than End Date');

        if EndDate = 0D then
            EndDate := WorkDate();

        if StartDate <> 0D then
            DateFilterUsed := Format(StartDate) + '..' + Format(EndDate)
        else
            DateFilterUsed := '..' + Format(EndDate);

        if SelectedLoanProductType <> '' then begin
            LoansRegister.SetRange("Loan Product Type", SelectedLoanProductType);

            if SelectedLoanProductType = 'LT003' then
                LoanProductTypeFilter := 'Sacco Investment Loans Report'
            else if SelectedLoanProductType = 'LT004' then
                LoanProductTypeFilter := 'Sacco School Fees Loans Report'
            else if SelectedLoanProductType = 'LT005' then
                LoanProductTypeFilter := 'Sacco Emergency Loans Report'
            else if SelectedLoanProductType = 'LT006' then
                LoanProductTypeFilter := 'Sacco Instant Sharia Loans Report'
            else if SelectedLoanProductType = 'LT007' then
                LoanProductTypeFilter := 'Sacco Instant Loans Report'
            else if SelectedLoanProductType = 'LT001' then
                LoanProductTypeFilter := 'Sacco Development Loans 2 Report'
            else if SelectedLoanProductType = 'LT002' then
                LoanProductTypeFilter := 'Sacco Development Loans 1 Report'
            else if SelectedLoanProductType = 'LT008' then
                LoanProductTypeFilter := 'Sacco Sharia Compliant Loans Report'
            else if SelectedLoanProductType = 'LT009' then
                LoanProductTypeFilter := 'Sacco Development Loans 3 Report'

        end else
            LoanProductTypeFilter := 'Loans Register Report';

        LoansRegister.SetFilter("Issued Date", '<=%1', EndDate);
    end;

    var
        EntryNo: Integer;
        LoansTable: Record "Loans Register";
        DateFilterUsed: Text;
        SelectedLoanProductType: Code[20];
        CompanyInfo: Record "Company Information";
        LoanRegister: Record "Loans Register";
        OutstandingBal: Decimal;
        OutstandingInt: Decimal;
        IssuedDateUsed: Text;
        MemberNo: code[100];
        MemberName: text;
        LoanProductType: Code[100];
        LoanNo: code[100];
        Installements: Integer;
        IssuedAmount: Decimal;
        OutstandingBalance: Decimal;
        OutstandingInterest: Decimal;
        RemainingRepayment: Decimal;
        StartDate: Date;
        EndDate: Date;

        LoanProductTypeFilter: Text;


    procedure FnCalculateLoanRemainingPeriod(
        LoanOutstandingBalance: Decimal;
        OriginalAmount: Decimal;
        TotalInstallments: Integer;
        InterestRate: Decimal): Integer
    var
        RemainingPeriods: Integer;
        MonthlyInterestRate: Decimal;
        MonthlyPayment: Decimal;
        Numerator: Decimal;
        Denominator: Decimal;
    begin
        if (LoanOutstandingBalance <= 0) or (OriginalAmount <= 0) or (TotalInstallments <= 0) then
            exit(0);

        if LoanOutstandingBalance >= OriginalAmount then
            exit(TotalInstallments);

        // Handle zero interest rate loans
        if InterestRate = 0 then begin
            RemainingPeriods := Round((LoanOutstandingBalance / OriginalAmount) * TotalInstallments, 1, '>');
            exit(RemainingPeriods);
        end;

        MonthlyInterestRate := InterestRate / 12 / 100;

        MonthlyPayment := OriginalAmount *
            (MonthlyInterestRate * Power(1 + MonthlyInterestRate, TotalInstallments)) /
            (Power(1 + MonthlyInterestRate, TotalInstallments) - 1);

        if MonthlyPayment > 0 then begin
            RemainingPeriods := Round(LoanOutstandingBalance / MonthlyPayment, 1, '>');

            // Adjust for interest effect (loans with interest need fewer periods than simple division)
            if MonthlyInterestRate > 0 then begin
                // Apply a correction factor based on interest rate
                // Higher interest rates mean more of each payment goes to interest initially
                RemainingPeriods := Round(RemainingPeriods * 0.95, 1, '>'); // Reduce by ~5%
            end;
        end else begin
            RemainingPeriods := Round((LoanOutstandingBalance / OriginalAmount) * TotalInstallments, 1, '>');
        end;

        if RemainingPeriods > TotalInstallments then
            RemainingPeriods := TotalInstallments;
        if RemainingPeriods < 0 then
            RemainingPeriods := 0;

        exit(RemainingPeriods);
    end;
}