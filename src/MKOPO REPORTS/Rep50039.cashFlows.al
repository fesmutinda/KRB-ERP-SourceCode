report 50039 cashFlows
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    Caption = 'Statement of Cash Flows';
    RDLCLayout = './Layout/cashflowsreport2.rdlc';

    dataset
    {
        dataitem("Company Information"; "Company Information")
        {

            column(RebatesPaid; RebatesPaid) { }

            column(LRebatesPaid; LRebatesPaid) { }


            column(Code; "Primary Key") { }

            column(DateFilterUsed; DateFilterUsed) { }

            column(Name; Name) { }

            column(Cashatbank; Cashatbank) { }
            column(LCashatbank; LCashatbank) { }
            column(endCashatbank; endCashatbank) { }
            column(EndLCashatbank; EndLCashatbank) { }

            column(Dividends; Dividends) { }
            column(LDividends; LDividends) { }

            column(IncreaseDecreaseInCashatbank; endCashatbank - Cashatbank)
            {

            }

            column(PreviousYear; PreviousYear)
            {

            }
            column(CurrentYear; CurrentYear)
            {

            }
            column(EndofLastyear; EndofLastyear)
            {

            }

            column(FinancialAssets; FinancialAssets)
            {
            }
            column(LFinancialAssets; LFinancialAssets)
            {
            }

            column(RepaymentOfBorrowings; RepaymentOfBorrowings)
            {

            }

            column(LRepaymentOfBorrowings; LRepaymentOfBorrowings)
            {
            }


            column(PurchaseOfAssets; PurchaseOfAssets)
            {

            }

            column(LPurchaseOfAssets; LPurchaseOfAssets)
            {

            }



            column(TradeAndOtherReceivables; TradeAndOtherReceivables)
            {

            }

            column(LTradeAndOtherReceivables; LTradeAndOtherReceivables)
            {

            }

            column(LoanandAdvances; LoanAdvances)
            {
            }
            column(LLoanandAdvances; LLoanAdvances)
            {
            }


            column(Honoraria; Honoraria)
            {

            }

            column(LHonoraria; LHonoraria)
            {

            }


            column(TaxPayable; TaxPayable)
            {

            }

            column(LTaxPayable; LTaxPayable)
            { }


            column(TaxPaid; TaxPaid) { }

            column(LTaxPaid; LTaxPaid) { }


            column(PayablesAndAccruals; PayablesAndAccruals)
            {
            }

            column(LPayablesAndAccruals; LPayablesAndAccruals)
            {
            }


            column(Nonwithdrawabledeposits; Nonwithdrawabledeposits)
            {
            }
            column(LNonwithdrawabledeposits; LNonwithdrawabledeposits)
            {
            }


            column(InterestonMemberdeposits; InterestonMemberdeposits)
            {

            }
            column(LInterestonMemberDeposits; LInterestonMemberDeposits)
            {


            }

            column(PurchaseOfInvestments; PurchaseOfInvestments)
            {

            }

            column(LPurchaseOfInvestments; LPurchaseOfInvestments)
            {

            }

            column(ShareCapital; ShareCapital)
            {
            }
            column(LShareCapital; LShareCapital)
            { }

            column(MemberDeposits; MemberDeposits) { }

            column(LMemberDeposits; LMemberDeposits) { }

            column(InterestonLoans; IncomeReceipts) { }
            column(LInterestonLoans; LIncomeReceipts) { }
            column(LInterestExpenses; LInterestExpenses) { }
            column(InterestExpenses; InterestExpenses) { }

            column(PersonnelExpenses; PersonnelExpenses) { }

            column(LPersonnelExpenses; LPersonnelExpenses) { }
            column(ReceivableandPrepayments; ReceivableandPrepayments) { }
            column(LReceivableandPrepayments; LReceivableandPrepayments) { }

            column(OtherOperatingincome; OtherIncome) { }

            column(LOtherOperatingincome; LOtherIncome) { }
            column(ThisYear; ThisYear)
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
            trigger OnAfterGetRecord()
            begin
                LStartDate := CalcDate('<-1Y>', StartDate);
                LEndDate := CalcDate('<-1Y>', EndDate);
                CurrentYear := Date2DMY(StartDate, 3);
                PreviousYear := Date2DMY(LStartDate, 3);

                Honoraria := CalculateCategoryMovement(GLAccount.CashFlowCategory::Honoraria, StartDate, EndDate);
                LHonoraria := CalculateCategoryMovement(GLAccount.CashFlowCategory::Honoraria, LStartDate, LEndDate);

                IncomeReceipts := CalculateCategoryMovement(GLAccount.CashFlowCategory::IncomeReceipts, StartDate, EndDate);
                LIncomeReceipts := CalculateCategoryMovement(GLAccount.CashFlowCategory::IncomeReceipts, LStartDate, LEndDate);

                OtherIncome := CalculateCategoryMovement(GLAccount.CashFlowCategory::OtherIncome, StartDate, EndDate);
                LOtherIncome := CalculateCategoryMovement(GLAccount.CashFlowCategory::OtherIncome, LStartDate, LEndDate);

                InterestonMemberdeposits := CalculateCategoryMovement(GLAccount.CashFlowCategory::MembersInterestPaid, StartDate, EndDate);
                LInterestonMemberdeposits := CalculateCategoryMovement(GLAccount.CashFlowCategory::MembersInterestPaid, LStartDate, LEndDate);

                PersonnelExpenses := CalculateCategoryMovement(GLAccount.CashFlowCategory::PaymentsToEmployeesAndSuppliers, StartDate, EndDate);
                LPersonnelExpenses := CalculateCategoryMovement(GLAccount.CashFlowCategory::PaymentsToEmployeesAndSuppliers, LStartDate, LEndDate);

                TradeAndOtherReceivables := CalculateCategoryMovement(GLAccount.CashFlowCategory::TradeAndOtherReceivables, StartDate, EndDate);
                LTradeAndOtherReceivables := CalculateCategoryMovement(GLAccount.CashFlowCategory::TradeAndOtherReceivables, LStartDate, LEndDate);

                MemberDeposits := CalculateCategoryMovement(GLAccount.CashFlowCategory::MembersDeposit, StartDate, EndDate);
                LMemberDeposits := CalculateCategoryMovement(GLAccount.CashFlowCategory::MembersDeposit, LStartDate, LEndDate);

                PayablesAndAccruals := CalculateCategoryMovement(GLAccount.CashFlowCategory::PayablesAndAccruals, StartDate, EndDate);
                LPayablesAndAccruals := CalculateCategoryMovement(GLAccount.CashFlowCategory::PayablesAndAccruals, LStartDate, LEndDate);

                RepaymentOfBorrowings := CalculateCategoryMovement(GLAccount.CashFlowCategory::RepaymentOfBorrowings, StartDate, EndDate);
                LRepaymentOfBorrowings := CalculateCategoryMovement(GLAccount.CashFlowCategory::RepaymentOfBorrowings, LStartDate, LEndDate);

                TaxPayable := CalculateCategoryMovement(GLAccount.CashFlowCategory::TaxPayable, StartDate, EndDate);
                LTaxPayable := CalculateCategoryMovement(GLAccount.CashFlowCategory::TaxPayable, LStartDate, LEndDate);

                TaxPaid := CalculateCategoryMovement(GLAccount.CashFlowCategory::TaxPaid, StartDate, EndDate);
                LTaxPaid := CalculateCategoryMovement(GLAccount.CashFlowCategory::TaxPaid, LStartDate, LEndDate);

                LoanAdvances := CalculateCategoryMovement(GLAccount.CashFlowCategory::LoanAdvances, StartDate, EndDate);
                LLoanAdvances := CalculateCategoryMovement(GLAccount.CashFlowCategory::LoanAdvances, LStartDate, LEndDate);

                PurchaseOfAssets := CalculateCategoryMovement(GLAccount.CashFlowCategory::PurchaseOfAssets, StartDate, EndDate);
                LPurchaseOfAssets := CalculateCategoryMovement(GLAccount.CashFlowCategory::PurchaseOfAssets, LStartDate, LEndDate);

                PurchaseOfInvestments := CalculateCategoryMovement(GLAccount.CashFlowCategory::PurchaseOfInvestments, StartDate, EndDate);
                LPurchaseOfInvestments := CalculateCategoryMovement(GLAccount.CashFlowCategory::PurchaseOfInvestments, LStartDate, LEndDate);

                ShareCapital := CalculateCategoryMovement(GLAccount.CashFlowCategory::ShareCapitalContribution, StartDate, EndDate);
                LShareCapital := CalculateCategoryMovement(GLAccount.CashFlowCategory::ShareCapitalContribution, LStartDate, LEndDate);

                // Opening cash excludes the first day; closing cash includes the last day.
                Cashatbank := CalculateCashBalance(StartDate - 1);
                LCashatbank := CalculateCashBalance(LStartDate - 1);
                endCashatbank := CalculateCashBalance(EndDate);
                EndLCashatbank := CalculateCashBalance(LEndDate);
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
        actions
        {
            area(Processing)
            {
            }
        }
    }



    trigger OnPreReport()
    begin

        Company.Get();

        If (StartDate = 0D) or (EndDate = 0D) then
            Error('Period Start and End must be provided');

        If ((Date2DMY(StartDate, 3) < 2024)) then
            Error('Period Start should not be less than 2024');

        if (StartDate > EndDate) then
            Error('Start Date cannot be later than End Date');


        If (Date2DMY(StartDate, 3) <> Date2DMY(EndDate, 3)) then
            Error('Start Date and End Date need to be in the same year');






        //if EndDate = 0D then
        // EndDate := WorkDate();

        //if StartDate = 0D then
        //  StartDate := DMY2Date(31, 12, 2024); // opening balances date

        DateFilterUsed := Format(StartDate) + '..' + Format(EndDate);

    end;




    local procedure CalculateCategoryMovement(Category: Integer; PeriodStart: Date; PeriodEnd: Date): Decimal
    var
        CashFlowAccount: Record "G/L Account";
        Movement: Decimal;
    begin
        CashFlowAccount.SetRange(CashFlowCategory, Category);
        CashFlowAccount.SetRange("Date Filter", PeriodStart, PeriodEnd);
        if CashFlowAccount.FindSet() then
            repeat
                CashFlowAccount.CalcFields("Net Change");
                Movement -= CashFlowAccount."Net Change";
            until CashFlowAccount.Next() = 0;

        exit(Movement);
    end;

    local procedure CalculateCashBalance(AsOfDate: Date): Decimal
    var
        CashFlowAccount: Record "G/L Account";
        CashBalance: Decimal;
    begin
        CashFlowAccount.SetRange(CashFlowCategory, CashFlowAccount.CashFlowCategory::CashAndEquivalents);
        CashFlowAccount.SetFilter("Date Filter", '..%1', AsOfDate);
        if CashFlowAccount.FindSet() then
            repeat
                CashFlowAccount.CalcFields("Balance at Date");
                CashBalance += CashFlowAccount."Balance at Date";
            until CashFlowAccount.Next() = 0;

        exit(CashBalance);
    end;


    var

        DateFilterUsed: Text;
        StartDate: Date;
        EndDate: Date;

        LStartDate: Date;

        LEndDate: Date;

        TermDeposits: Decimal;

        LTermDeposits: Decimal;
        TaxPaid: Decimal;

        LTaxPaid: Decimal;

        IncomeReceipts: Decimal;

        LIncomeReceipts: Decimal;

        AvailableForSale: Decimal;

        LAvailableForSale: Decimal;

        Cashatbank: Decimal;
        LCashatbank: Decimal;

        CashOnlyatbank: DECIMAL;

        LCashOnlyAtBank: Decimal;

        MemberDeposits: Decimal;

        LMemberDeposits: Decimal;
        endCashatbank: Decimal;
        EndLCashatbank: Decimal;
        AsAt: Date;
        ReceivableandPrepayments: Decimal;
        LReceivableandPrepayments: Decimal;
        LInterestExpenses: Decimal;
        InterestExpenses: Decimal;
        PreviousYear: Integer;
        CurrentYear: Integer;
        EndofLastyear: date;
        ThisYear: Date;
        GLEntry: Record "G/L Entry";
        GLAccount: Record "G/L Account";
        FinancialAssets: Decimal;
        LFinancialAssets: Decimal;

        InvestmentIncome: Decimal;
        LInvestmentIncome: Decimal;
        TradeandOtherPayables: Decimal;
        LTradeandOtherPayables: Decimal;
        LInterestonMemberDeposits: Decimal;
        InterestonMemberdeposits: Decimal;

        Nonwithdrawabledeposits: Decimal;
        LNonwithdrawabledeposits: Decimal;
        ShareCapital: Decimal;
        LShareCapital: Decimal;

        PersonnelExpenses: Decimal;

        LPersonnelExpenses: Decimal;

        TradeAndOtherReceivables: Decimal;

        LTradeAndOtherReceivables: Decimal;

        PayablesAndAccruals: Decimal;

        LPayablesAndAccruals: Decimal;

        TaxPayable: Decimal;

        LTaxPayable: Decimal;

        Dividends: Decimal;

        LDividends: Decimal;

        PurchaseOfAssets: Decimal;

        LPurchaseOfAssets: Decimal;

        //PurchaseOfInvestments: Decimal;

        //LPurchaseOfInvestments: Decimal;

        RepaymentOfBorrowings: Decimal;

        LRepaymentOfBorrowings: Decimal;

        RebatesPaid: Decimal;

        LRebatesPaid: Decimal;

        Company: Record "Company Information";

        OtherIncome: Decimal;

        LOtherIncome: Decimal;

        Honoraria: Decimal;

        LHonoraria: Decimal;

        LoanAdvances: Decimal;

        LLoanAdvances: Decimal;

        PurchaseOfInvestments: Decimal;

        LPurchaseOfInvestments: Decimal;



}