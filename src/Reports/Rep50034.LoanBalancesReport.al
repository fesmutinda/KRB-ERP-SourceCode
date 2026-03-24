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

            column(EntryNo; EntryNo) { }
            column(CompanyName; CompanyInfo.Name) { }
            column(CompanyAddress; CompanyInfo.Address) { }
            column(CompanyAddress2; CompanyInfo."Address 2") { }
            column(CompanyPhone; CompanyInfo."Phone No.") { }
            column(CompanyPic; CompanyInfo.Picture) { }
            column(CompanyEmail; CompanyInfo."E-Mail") { }
            column(ClientCode; MemberNo) { }
            column(ClientName; MemberName) { }
            column(Loan_Product_Type_Name; "Loan Product Type Name") { }
            column(Loan__No_; LoanNo) { }
            column(Installments; Installements) { }
            column(ApprovedAmount; IssuedAmount) { }
            column(PrincipalPaid; "Principal Paid") { }
            column(Outstanding_Balance; OutstandingBalance) { }
            column(InterestPaid; "Interest Paid" * -1) { }
            column(Oustanding_Interest; OutstandingInterest) { }
            column(RemainingRepayment; RemainingRepayment) { }
            column(DateFilterText; DateFilterText) { } // Show date range

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
                if SelectedLoanProductType <> '' then
                    LoansRegister.SetRange("Loan Product Type", SelectedLoanProductType);

                // Apply Customer filter if selected
                if SelectedCustomer <> '' then
                    LoansRegister.SetRange("Client Code", SelectedCustomer);

                // Apply date filter if user selected dates
                if (StartDate <> 0D) and (EndDate <> 0D) then
                    LoansRegister.SetRange("Issued Date", StartDate, EndDate);
            end;

            trigger OnAfterGetRecord()
            begin
                if LoansTable.get(LoansRegister."Loan  No.") then begin
                    LoansTable.CalcFields(LoansTable."Outstanding Balance", LoansTable."Oustanding Interest");

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

                    // Set the date filter text for display
                    if (StartDate = 0D) and (EndDate = 0D) then
                        DateFilterText := Format(Today)
                    else
                        DateFilterText := Format(StartDate) + ' to ' + Format(EndDate);
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

                    field(CustomerFilter; SelectedCustomer)
                    {
                        ApplicationArea = All;
                        Caption = 'Customer';
                        TableRelation = Customer;
                    }

                    field(StartDate; StartDate)
                    {
                        ApplicationArea = All;
                        Caption = 'Start Date';
                    }

                    field(EndDate; EndDate)
                    {
                        ApplicationArea = All;
                        Caption = 'End Date';
                    }
                }
            }
        }
    }

    trigger OnInitReport()
    begin
        SelectedLoanProductType := '';
        SelectedCustomer := '';
        StartDate := 0D;
        EndDate := 0D;
    end;

    trigger OnPreReport()
    begin
        CompanyInfo.Get();
        // Apply Loan Product Type filter again in case user selected
        if SelectedLoanProductType <> '' then
            LoansRegister.SetRange("Loan Product Type", SelectedLoanProductType);

        // Apply Customer filter again in case user selected
        if SelectedCustomer <> '' then
            LoansRegister.SetRange("Client Code", SelectedCustomer);
    end;

    var
        EntryNo: Integer;
        LoansTable: Record "Loans Register";
        CompanyInfo: Record "Company Information";
        SelectedLoanProductType: Code[20];
        SelectedCustomer: Code[20]; // New variable for Customer filter
        MemberNo: Code[100];
        MemberName: Text;
        LoanProductType: Code[100];
        LoanNo: Code[100];
        Installements: Integer;
        IssuedAmount: Decimal;
        OutstandingBalance: Decimal;
        OutstandingInterest: Decimal;
        RemainingRepayment: Decimal;

        // Variables for date filtering
        StartDate: Date;
        EndDate: Date;
        DateFilterText: Text;

    procedure FnCalculateLoanRemainingPeriod(
        LoanOutstandingBalance: Decimal;
        OriginalAmount: Decimal;
        TotalInstallments: Integer;
        InterestRate: Decimal): Integer
    var
        RemainingPeriods: Integer;
        MonthlyInterestRate: Decimal;
        MonthlyPayment: Decimal;
    begin
        if (LoanOutstandingBalance <= 0) or (OriginalAmount <= 0) or (TotalInstallments <= 0) then
            exit(0);

        if LoanOutstandingBalance >= OriginalAmount then
            exit(TotalInstallments);

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
            if MonthlyInterestRate > 0 then
                RemainingPeriods := Round(RemainingPeriods * 0.95, 1, '>');
        end else
            RemainingPeriods := Round((LoanOutstandingBalance / OriginalAmount) * TotalInstallments, 1, '>');

        if RemainingPeriods > TotalInstallments then
            RemainingPeriods := TotalInstallments;
        if RemainingPeriods < 0 then
            RemainingPeriods := 0;

        exit(RemainingPeriods);
    end;
}
