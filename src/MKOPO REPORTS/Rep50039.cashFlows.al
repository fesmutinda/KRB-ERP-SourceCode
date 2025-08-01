report 50039 cashFlows
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    Caption = 'satement of changes in equity Previous Period';
    RDLCLayout = './Layout/cashflowsreport2.rdlc';

    dataset
    {
        dataitem("Sacco Information"; "Sacco Information")
        {
            column(Code; Code)
            {

            }
            column(Cashatbank; Cashatbank) { }
            column(LCashatbank; LCashatbank) { }
            column(endCashatbank; endCashatbank) { }
            column(EndLCashatbank; EndLCashatbank) { }

            column(IncreaseDecreaseInCashatbank; endCashatbank - EndLCashatbank)
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
            column(LoanandAdvances; LoanandAdvances)
            {
            }
            column(LLoanandAdvances; LLoanandAdvances)
            {
            }

            column(IncreaseDecreaseInLoanandAdvances; LoanandAdvances - LLoanandAdvances)
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


            column(PurchaseOfInvestments; PurchaseOfInvestments)
            {

            }

            column(LPurchaseOfInvestments; LPurchaseOfInvestments)
            {

            }
            column(TradeandOtherPayables; TradeandOtherPayables)
            {
            }

            column(TradeAndOtherReceivables; TradeAndOtherReceivables)
            {

            }

            column(LTradeAndOtherReceivables; LTradeAndOtherReceivables)
            {

            }

            column(IncreaseDecreaseTradeReceivables; TradeAndOtherReceivables - LTradeAndOtherReceivables)
            {
                Caption = '(Increase)/Decrease in Trade & Other Receivables';
            }

            column(TaxPayable; TaxPayable)
            {

            }

            column(LTaxPayable; LTaxPayable)
            { }

            column(IncreaseDecreaseTaxPayable; TaxPayable - LTaxPayable)
            {

            }

            column(PayablesAndAccruals; PayablesAndAccruals)
            {
            }

            column(LPayablesAndAccruals; LPayablesAndAccruals)
            {
            }

            column(IncreaseDecreasePayablesAndAccruals; PayablesAndAccruals - LPayablesAndAccruals)
            {

            }
            column(LTradeandOtherPayables; LTradeandOtherPayables)
            {
            }
            column(Honoraria; Honoraria)
            {
            }
            column(LHonoraria; LHonoraria)
            {
            }
            column(Nonwithdrawabledeposits; Nonwithdrawabledeposits)
            {
            }
            column(LNonwithdrawabledeposits; LNonwithdrawabledeposits)
            {
            }

            column(IncreaseDecreaseinNonWithdrawabledeposits; Nonwithdrawabledeposits - LNonwithdrawabledeposits)
            {

            }
            column(InterestonMemberdeposits; InterestonMemberdeposits)
            {

            }
            column(LInterestonMemberDeposits; LInterestonMemberDeposits)
            {

            }
            column(InvestmentIncome; InvestmentIncome)
            {

            }
            column(LInvestmentIncome; LInvestmentIncome)
            {

            }
            column(ShareCapital; ShareCapital)
            {
            }
            column(LShareCapital; LShareCapital)
            { }
            column(LOtherOperatingincome; LOtherOperatingincome)
            {

            }
            column(OtherOperatingincome; OtherOperatingincome)
            {

            }
            column(InterestonLoans; InterestonLoans) { }
            column(LInterestonLoans; LInterestonLoans) { }
            column(LInterestExpenses; LInterestExpenses) { }
            column(InterestExpenses; InterestExpenses) { }

            column(PersonnelExpenses; PersonnelExpenses) { }

            column(LPersonnelExpenses; LPersonnelExpenses) { }
            column(ReceivableandPrepayments; ReceivableandPrepayments) { }
            column(LReceivableandPrepayments; LReceivableandPrepayments) { }
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
            var
                myInt: Integer;
                InputDate: Date;
                DateFormula: Text;
                DateExpr: Text;
                StartofcurrentYear: Date;
                StartofPreviousYear: Date;
                DateExpr2: Text;


            begin
                DateFormula := '<-CY-1D>';
                DateExpr := '<-1y>';
                InputDate := Asat;
                DateExpr2 := '<-CY>';

                ThisYear := InputDate;
                StartofcurrentYear := CalcDate(DateExpr2, ThisYear);

                CurrentYear := Date2DMY(ThisYear, 3);
                EndofLastyear := CalcDate(DateFormula, ThisYear);
                StartofPreviousYear := CalcDate(DateExpr2, EndofLastyear);
                PreviousYear := CurrentYear - 1;

                //Interest on Loans
                InterestonLoans := 0;
                GLAccount.Reset;
                GLAccount.SetFilter(GLAccount.CashFlowCategory, '%1', GLAccount.CashFlowCategory::InterestIncomeReceipts);
                if GLAccount.FindSet then begin
                    repeat
                        GLEntry.Reset;
                        GLEntry.SetRange(GLEntry."G/L Account No.", GLAccount."No.");
                        GLEntry.SetFilter(GLEntry."Posting Date", '..%1', ThisYear);
                        if GLEntry.FindSet then begin
                            GLEntry.CalcSums(Amount);
                            InterestonLoans += -1 * GLEntry.Amount;
                        end;

                    until GLAccount.Next = 0;
                end;

                LInterestonLoans := 0;
                GLAccount.Reset;
                GLAccount.SetFilter(GLAccount.CashFlowCategory, '%1', GLAccount.CashFlowCategory::InterestIncomeReceipts);
                if GLAccount.FindSet then begin
                    repeat
                        GLEntry.Reset;
                        GLEntry.SetRange(GLEntry."G/L Account No.", GLAccount."No.");
                        GLEntry.SetFilter(GLEntry."Posting Date", '..%1', EndofLastyear);
                        if GLEntry.FindSet then begin
                            GLEntry.CalcSums(Amount);
                            LInterestonLoans += -1 * GLEntry.Amount;
                        end;

                    until GLAccount.Next = 0;
                end;



                //Other Income from loans
                OtherInterestonLoans := 0;
                GLAccount.Reset;
                GLAccount.SetFilter(GLAccount.CashFlowCategory, '%1', GLAccount.CashFlowCategory::OtherIncomeReceipts);
                if GLAccount.FindSet then begin
                    repeat
                        GLEntry.Reset;
                        GLEntry.SetRange(GLEntry."G/L Account No.", GLAccount."No.");
                        GLEntry.SetFilter(GLEntry."Posting Date", '..%1', ThisYear);
                        if GLEntry.FindSet then begin
                            GLEntry.CalcSums(Amount);
                            OtherInterestonLoans += -1 * GLEntry.Amount;
                        end;

                    until GLAccount.Next = 0;
                end;

                LOtherInterestonLoans := 0;
                GLAccount.Reset;
                GLAccount.SetFilter(GLAccount.CashFlowCategory, '%1', GLAccount.CashFlowCategory::OtherIncomeReceipts);
                if GLAccount.FindSet then begin
                    repeat
                        GLEntry.Reset;
                        GLEntry.SetRange(GLEntry."G/L Account No.", GLAccount."No.");
                        GLEntry.SetFilter(GLEntry."Posting Date", '..%1', EndofLastyear);
                        if GLEntry.FindSet then begin
                            GLEntry.CalcSums(Amount);
                            LOtherInterestonLoans += -1 * GLEntry.Amount;
                        end;

                    until GLAccount.Next = 0;
                end;
                //Personnel Expenses (Payments to Employees and Suppliers)
                PersonnelExpenses := 0;
                GLAccount.Reset;
                GLAccount.SetFilter(GLAccount.CashFlowCategory, '%1', GLAccount.CashFlowCategory::PaymentsToEmployeesAndSuppliers);
                if GLAccount.FindSet() then begin
                    repeat
                        GLEntry.Reset;
                        GLEntry.SetRange(GLEntry."G/L Account No.", GLAccount."No.");
                        GLEntry.SetFilter(GLEntry."Posting Date", '..%1', ThisYear);
                        if GLEntry.FindSet then begin
                            GLEntry.CalcSums(Amount);
                            PersonnelExpenses += -1 * GLEntry.Amount;
                        end;
                    until GLAccount.Next() = 0
                end;


                LPersonnelExpenses := 0;
                GLAccount.Reset;
                GLAccount.SetFilter(GLAccount.CashFlowCategory, '%1', GLAccount.CashFlowCategory::PaymentsToEmployeesAndSuppliers);
                if GLAccount.FindSet then begin
                    repeat
                        GLEntry.Reset;
                        GLEntry.SetRange(GLEntry."G/L Account No.", GLAccount."No.");
                        GLEntry.SetFilter(GLEntry."Posting Date", '..%1', EndofLastyear);
                        if GLEntry.FindSet then begin
                            GLEntry.CalcSums(Amount);
                            LPersonnelExpenses += -1 * GLEntry.Amount;
                        end;

                    until GLAccount.Next = 0;
                end;



                //Otheroperatingincome
                OtherOperatingincome := 0;
                GLAccount.Reset;
                GLAccount.SetFilter(GLAccount.CashFlowCategory, '%1', GLAccount.CashFlowCategory::OtherIncomeReceipts);
                if GLAccount.FindSet then begin
                    repeat
                        GLEntry.Reset;
                        GLEntry.SetRange(GLEntry."G/L Account No.", GLAccount."No.");
                        GLEntry.SetFilter(GLEntry."Posting Date", '..%1', ThisYear);
                        if GLEntry.FindSet then begin
                            GLEntry.CalcSums(Amount);
                            OtherOperatingincome += -1 * GLEntry.Amount;
                        end;

                    until GLAccount.Next = 0;
                end;

                LOtherOperatingincome := 0;
                GLAccount.Reset;
                GLAccount.SetFilter(GLAccount.CashFlowCategory, '%1', GLAccount.CashFlowCategory::OtherIncomeReceipts);
                if GLAccount.FindSet then begin
                    repeat
                        GLEntry.Reset;
                        GLEntry.SetRange(GLEntry."G/L Account No.", GLAccount."No.");
                        GLEntry.SetFilter(GLEntry."Posting Date", '..%1', EndofLastyear);
                        if GLEntry.FindSet then begin
                            GLEntry.CalcSums(Amount);
                            LOtherOperatingincome += -1 * GLEntry.Amount;
                        end;

                    until GLAccount.Next = 0;
                end;

                //Receivables And Prepayments
                // ReceivableandPrepayments := 0;
                // LReceivableandPrepayments := 0;
                // GLAccount.Reset;
                // GLAccount.SetFilter(GLAccount.Assets, '%1', GLAccount.Assets::ReceivablesAndPrepayements);
                // if GLAccount.FindSet then begin
                //     repeat

                //         GLEntry.Reset;
                //         GLEntry.SetRange(GLEntry."G/L Account No.", GLAccount."No.");
                //         GLEntry.SetFilter(GLEntry."Posting Date", '%1..%2', StartofcurrentYear, ThisYear);
                //         if GLEntry.FindSet then begin
                //             GLEntry.CalcSums(Amount);
                //             ReceivableandPrepayments += GLEntry.Amount;
                //         end;

                //     until GLAccount.Next = 0;
                // end;

                // GLAccount.Reset;
                // GLAccount.SetFilter(GLAccount.Assets, '%1', GLAccount.Assets::ReceivablesAndPrepayements);
                // if GLAccount.FindSet then begin
                //     repeat

                //         GLEntry.Reset;
                //         GLEntry.SetRange(GLEntry."G/L Account No.", GLAccount."No.");
                //         GLEntry.SetFilter(GLEntry."Posting Date", '%1..%2', StartofPreviousYear, EndofLastyear);
                //         if GLEntry.FindSet then begin
                //             GLEntry.CalcSums(Amount);
                //             LReceivableandPrepayments += GLEntry.Amount;
                //         end;

                //     until GLAccount.Next = 0;
                // end;
                //End of Receivables and Prepayments


                //LoanandAdvances
                LoanandAdvances := 0;
                LLoanandAdvances := 0;
                GLAccount.Reset;
                GLAccount.SetFilter(GLAccount.CashFlowCategory, '%1', GLAccount.CashFlowCategory::MembersLoans);
                if GLAccount.FindSet then begin
                    repeat

                        GLEntry.Reset;
                        GLEntry.SetRange(GLEntry."G/L Account No.", GLAccount."No.");
                        GLEntry.SetFilter(GLEntry."Posting Date", '%1..%2', StartofcurrentYear, ThisYear);
                        if GLEntry.FindSet then begin
                            GLEntry.CalcSums(Amount);
                            LoanandAdvances += -1 * GLEntry.Amount;
                        end;

                    until GLAccount.Next = 0;
                end;

                GLAccount.Reset;
                GLAccount.SetFilter(GLAccount.CashFlowCategory, '%1', GLAccount.CashFlowCategory::MembersLoans);
                if GLAccount.FindSet then begin
                    repeat

                        GLEntry.Reset;
                        GLEntry.SetRange(GLEntry."G/L Account No.", GLAccount."No.");
                        GLEntry.SetFilter(GLEntry."Posting Date", '%1..%2', StartofPreviousYear, EndofLastyear);
                        if GLEntry.FindSet then begin
                            GLEntry.CalcSums(Amount);
                            LLoanandAdvances += -1 * GLEntry.Amount;
                        end;

                    until GLAccount.Next = 0;
                end;
                //EndofLoanandAdavances

                //Purchase of Assets
                PurchaseOfAssets := 0;
                LPurchaseOfAssets := 0;
                GLAccount.Reset;
                GLAccount.SetFilter(GLAccount.CashFlowCategory, '%1', GLAccount.CashFlowCategory::PurchaseOfAssets);
                if GLAccount.FindSet then begin
                    repeat

                        GLEntry.Reset;
                        GLEntry.SetRange(GLEntry."G/L Account No.", GLAccount."No.");
                        GLEntry.SetFilter(GLEntry."Posting Date", '%1..%2', StartofcurrentYear, ThisYear);
                        if GLEntry.FindSet then begin
                            GLEntry.CalcSums(Amount);
                            PurchaseOfAssets += GLEntry.Amount;
                        end;
                    until GLAccount.Next = 0;
                end;

                GLAccount.Reset;
                GLAccount.SetFilter(GLAccount.CashFlowCategory, '%1', GLAccount.CashFlowCategory::PurchaseOfAssets);
                if GLAccount.FindSet then begin
                    repeat

                        GLEntry.Reset;
                        GLEntry.SetRange(GLEntry."G/L Account No.", GLAccount."No.");
                        GLEntry.SetFilter(GLEntry."Posting Date", '%1..%2', StartofPreviousYear, EndofLastyear);
                        if GLEntry.FindSet then begin
                            GLEntry.CalcSums(Amount);
                            LPurchaseOfAssets += GLEntry.Amount;
                        end;

                    until GLAccount.Next = 0;
                end;


                //PurchaseOfInvestments
                PurchaseOfInvestments := 0;
                LPurchaseOfInvestments := 0;
                GLAccount.Reset;
                GLAccount.SetFilter(GLAccount.CashFlowCategory, '%1', GLAccount.CashFlowCategory::PurchaseOfInvestments);
                if GLAccount.FindSet then begin
                    repeat
                        GLEntry.Reset;
                        GLEntry.SetRange(GLEntry."G/L Account No.", GLAccount."No.");
                        GLEntry.SetFilter(GLEntry."Posting Date", '%1..%2', StartofcurrentYear, ThisYear);
                        if GLEntry.FindSet then begin
                            GLEntry.CalcSums(Amount);
                            PurchaseOfInvestments += GLEntry.Amount;
                        end;
                    until GLAccount.Next = 0;
                end;

                GLAccount.Reset;
                GLAccount.SetFilter(GLAccount.CashFlowCategory, '%1', GLAccount.CashFlowCategory::PurchaseOfInvestments);
                if GLAccount.FindSet then begin
                    repeat
                        GLEntry.Reset;
                        GLEntry.SetRange(GLEntry."G/L Account No.", GLAccount."No.");
                        GLEntry.SetFilter(GLEntry."Posting Date", '%1..%2', StartofPreviousYear, EndofLastyear);
                        if GLEntry.FindSet then begin
                            GLEntry.CalcSums(Amount);
                            LPurchaseOfInvestments += GLEntry.Amount;
                        end;
                    until GLAccount.Next = 0;
                end;


                //Financial Assets
                // FinancialAssets := 0;
                // LFinancialAssets := 0;
                // GLAccount.Reset;
                // GLAccount.SetFilter(GLAccount.Assets, '%1', GLAccount.Assets::FinancialAssets);
                // if GLAccount.FindSet then begin
                //     repeat

                //         GLEntry.Reset;
                //         GLEntry.SetRange(GLEntry."G/L Account No.", GLAccount."No.");
                //         GLEntry.SetFilter(GLEntry."Posting Date", '%1..%2', StartofcurrentYear, ThisYear);
                //         if GLEntry.FindSet then begin
                //             GLEntry.CalcSums(Amount);
                //             FinancialAssets += GLEntry.Amount;
                //         end;
                //     until GLAccount.Next = 0;
                // end;

                // GLAccount.Reset;
                // GLAccount.SetFilter(GLAccount.Assets, '%1', GLAccount.Assets::FinancialAssets);
                // if GLAccount.FindSet then begin
                //     repeat

                //         GLEntry.Reset;
                //         GLEntry.SetRange(GLEntry."G/L Account No.", GLAccount."No.");
                //         GLEntry.SetFilter(GLEntry."Posting Date", '%1..%2', StartofPreviousYear, EndofLastyear);
                //         if GLEntry.FindSet then begin
                //             GLEntry.CalcSums(Amount);
                //             LFinancialAssets += GLEntry.Amount;
                //         end;

                //     until GLAccount.Next = 0;
                // end;

                //End Of Financial Assets
                //TradeandOtherPayables
                // TradeandOtherPayables := 0;
                // GLAccount.Reset;
                // GLAccount.SetFilter(GLAccount.MkopoLiabilities, '%1', GLAccount.MkopoLiabilities::TradeandotherPayables);
                // if GLAccount.FindSet then begin
                //     repeat
                //         GLEntry.Reset;
                //         GLEntry.SetRange(GLEntry."G/L Account No.", GLAccount."No.");
                //         GLEntry.SetFilter(GLEntry."Posting Date", '%1..%2', StartofcurrentYear, ThisYear);
                //         if GLEntry.FindSet then begin
                //             GLEntry.CalcSums(Amount);
                //             TradeandOtherPayables += -1 * GLEntry.Amount;
                //         end;
                //     until GLAccount.Next = 0;
                // end;
                // LTradeandOtherPayables := 0;
                // GLAccount.Reset;
                // GLAccount.SetFilter(GLAccount.MkopoLiabilities, '%1', GLAccount.MkopoLiabilities::TradeandotherPayables);
                // if GLAccount.FindSet then begin
                //     repeat
                //         GLEntry.Reset;
                //         GLEntry.SetRange(GLEntry."G/L Account No.", GLAccount."No.");
                //         GLEntry.SetFilter(GLEntry."Posting Date", '%1..%2', StartofPreviousYear, EndofLastyear);
                //         if GLEntry.FindSet then begin
                //             GLEntry.CalcSums(Amount);
                //             LTradeandOtherPayables += -1 * GLEntry.Amount;
                //         end;
                //     until GLAccount.Next = 0;
                // end;
                // //EndofTradeAndotherPayables


                //Honoraria
                Honoraria := 0;
                GLAccount.Reset;
                GLAccount.SetFilter(GLAccount.CashFlowCategory, '%1', GLAccount.CashFlowCategory::HonorariaPaid);
                if GLAccount.FindSet then begin
                    repeat
                        GLEntry.Reset;
                        GLEntry.SetRange(GLEntry."G/L Account No.", GLAccount."No.");
                        GLEntry.SetFilter(GLEntry."Posting Date", '%1..%2', StartofcurrentYear, ThisYear);
                        if GLEntry.FindSet then begin
                            GLEntry.CalcSums(Amount);
                            Honoraria += -1 * GLEntry.Amount;
                        end;
                    until GLAccount.Next = 0;
                end;
                LHonoraria := 0;
                GLAccount.Reset;
                GLAccount.SetFilter(GLAccount.CashFlowCategory, '%1', GLAccount.CashFlowCategory::HonorariaPaid);
                if GLAccount.FindSet then begin
                    repeat
                        GLEntry.Reset;
                        GLEntry.SetRange(GLEntry."G/L Account No.", GLAccount."No.");
                        GLEntry.SetFilter(GLEntry."Posting Date", '%1..%2', StartofPreviousYear, EndofLastyear);
                        if GLEntry.FindSet then begin
                            GLEntry.CalcSums(Amount);
                            LHonoraria += -1 * GLEntry.Amount;
                        end;
                    until GLAccount.Next = 0;
                end;
                //EndofHonaria

                //Member Deposits
                GLAccount.Reset;
                GLAccount.SetFilter(GLAccount.CashFlowCategory, '%1', GLAccount.CashFlowCategory::MembersDeposit);
                if GLAccount.FindSet then begin
                    repeat
                        GLEntry.Reset;
                        GLEntry.SetRange(GLEntry."G/L Account No.", GLAccount."No.");
                        GLEntry.SetFilter(GLEntry."Posting Date", '%1..%2', StartofcurrentYear, ThisYear);
                        if GLEntry.FindSet then begin
                            GLEntry.CalcSums(Amount);
                            Nonwithdrawabledeposits += -1 * GLEntry.Amount;
                        end;
                    until GLAccount.Next = 0;

                end;
                GLAccount.Reset;
                GLAccount.SetFilter(GLAccount.CashFlowCategory, '%1', GLAccount.CashFlowCategory::MembersDeposit);
                if GLAccount.FindSet then begin
                    repeat
                        GLEntry.Reset;
                        GLEntry.SetRange(GLEntry."G/L Account No.", GLAccount."No.");
                        GLEntry.SetFilter(GLEntry."Posting Date", '%1..%2', StartofPreviousYear, EndofLastyear);
                        if GLEntry.FindSet then begin
                            GLEntry.CalcSums(Amount);
                            LNonwithdrawabledeposits += -1 * GLEntry.Amount;
                        end;
                    until GLAccount.Next = 0;

                end;
                // EmdMember deposits

                //Increase in TradeAndOtherReceivables
                TradeAndOtherReceivables := 0;
                GLAccount.Reset;
                GLAccount.SetFilter(GLAccount.CashFlowCategory, '%1', GLAccount.CashFlowCategory::TradeAndOtherReceivables);
                if GLAccount.FindSet then begin
                    repeat
                        GLEntry.Reset;
                        GLEntry.SetRange(GLEntry."G/L Account No.", GLAccount."No.");
                        GLEntry.SetFilter(GLEntry."Posting Date", '%1..%2', StartofcurrentYear, ThisYear);
                        if GLEntry.FindSet then begin
                            GLEntry.CalcSums(Amount);
                            TradeAndOtherReceivables += -1 * GLEntry.Amount;
                        end;
                    until GLAccount.Next = 0;
                end;
                LTradeAndOtherReceivables := 0;
                GLAccount.Reset;
                GLAccount.SetFilter(GLAccount.CashFlowCategory, '%1', GLAccount.CashFlowCategory::TradeAndOtherReceivables);
                if GLAccount.FindSet then begin
                    repeat
                        GLEntry.Reset;
                        GLEntry.SetRange(GLEntry."G/L Account No.", GLAccount."No.");
                        GLEntry.SetFilter(GLEntry."Posting Date", '%1..%2', StartofPreviousYear, EndofLastyear);
                        if GLEntry.FindSet then begin
                            GLEntry.CalcSums(Amount);
                            LTradeAndOtherReceivables += -1 * GLEntry.Amount;
                        end;
                    until GLAccount.Next = 0;
                end;

                //PayablesAndAccruals
                PayablesAndAccruals := 0;
                GLAccount.Reset;
                GLAccount.SetFilter(GLAccount.CashFlowCategory, '%1', GLAccount.CashFlowCategory::PayablesAndAccruals);
                if GLAccount.FindSet then begin
                    repeat
                        GLEntry.Reset;
                        GLEntry.SetRange(GLEntry."G/L Account No.", GLAccount."No.");
                        GLEntry.SetFilter(GLEntry."Posting Date", '%1..%2', StartofcurrentYear, ThisYear);
                        if GLEntry.FindSet then begin
                            GLEntry.CalcSums(Amount);
                            PayablesAndAccruals += -1 * GLEntry.Amount;
                        end;
                    until GLAccount.Next = 0;
                end;

                LPayablesAndAccruals := 0;
                GLAccount.Reset;
                GLAccount.SetFilter(GLAccount.CashFlowCategory, '%1', GLAccount.CashFlowCategory::PayablesAndAccruals);
                if GLAccount.FindSet then begin
                    repeat
                        GLEntry.Reset;
                        GLEntry.SetRange(GLEntry."G/L Account No.", GLAccount."No.");
                        GLEntry.SetFilter(GLEntry."Posting Date", '%1..%2', StartofPreviousYear, EndofLastyear);
                        if GLEntry.FindSet then begin
                            GLEntry.CalcSums(Amount);
                            LPayablesAndAccruals += 1 * GLEntry.Amount;
                        end;
                    until GLAccount.Next = 0;
                end;


                //TaxPayable

                TaxPayable := 0;
                GLAccount.Reset;
                GLAccount.SetFilter(GLAccount.CashFlowCategory, '%1', GLAccount.CashFlowCategory::TaxPaidAdjustment);
                if GLAccount.FindSet then begin
                    repeat
                        GLEntry.Reset;
                        GLEntry.SetRange(GLEntry."G/L Account No.", GLAccount."No.");
                        GLEntry.SetFilter(GLEntry."Posting Date", '%1..%2', StartofcurrentYear, ThisYear);
                        if GLEntry.FindSet then begin
                            GLEntry.CalcSums(Amount);
                            TaxPayable += -1 * GLEntry.Amount;
                        end;
                    until GLAccount.Next = 0;
                end;
                LTaxPayable := 0;
                GLAccount.Reset;
                GLAccount.SetFilter(GLAccount.CashFlowCategory, '%1', GLAccount.CashFlowCategory::TaxPaidAdjustment);
                if GLAccount.FindSet then begin
                    repeat
                        GLEntry.Reset;
                        GLEntry.SetRange(GLEntry."G/L Account No.", GLAccount."No.");
                        GLEntry.SetFilter(GLEntry."Posting Date", '%1..%2', StartofPreviousYear, EndofLastyear);
                        if GLEntry.FindSet then begin
                            GLEntry.CalcSums(Amount);
                            LTaxPayable += 1 * GLEntry.Amount;
                        end;
                    until GLAccount.Next = 0;
                end;



                //Dividends
                InterestonMemberdeposits := 0;
                GLAccount.Reset;
                GLAccount.SetFilter(GLAccount.CashFlowCategory, '%1', GLAccount.CashFlowCategory::MembersInterestPaid);
                if GLAccount.FindSet then begin
                    repeat
                        GLEntry.Reset;
                        GLEntry.SetRange(GLEntry."G/L Account No.", GLAccount."No.");
                        GLEntry.SetFilter(GLEntry."Posting Date", '%1..%2', StartofcurrentYear, ThisYear);
                        if GLEntry.FindSet then begin
                            GLEntry.CalcSums(Amount);
                            InterestonMemberdeposits += -1 * GLEntry.Amount;
                        end;
                    until GLAccount.Next = 0;
                end;
                LInterestonMemberdeposits := 0;
                GLAccount.Reset;
                GLAccount.SetFilter(GLAccount.CashFlowCategory, '%1', GLAccount.CashFlowCategory::MembersInterestPaid);
                if GLAccount.FindSet then begin
                    repeat
                        GLEntry.Reset;
                        GLEntry.SetRange(GLEntry."G/L Account No.", GLAccount."No.");
                        GLEntry.SetFilter(GLEntry."Posting Date", '%1..%2', StartofPreviousYear, EndofLastyear);
                        if GLEntry.FindSet then begin
                            GLEntry.CalcSums(Amount);
                            LInterestonMemberdeposits += -1 * GLEntry.Amount;
                        end;
                    until GLAccount.Next = 0;
                end;

                //End of Dividends


                //repaymentonborrowings

                RepaymentOfBorrowings := 0;
                GLAccount.Reset;
                GLAccount.SetFilter(GLAccount.CashFlowCategory, '%1', GLAccount.CashFlowCategory::RepaymentOfBorrowings);
                if GLAccount.FindSet then begin
                    repeat
                        GLEntry.Reset;
                        GLEntry.SetRange(GLEntry."G/L Account No.", GLAccount."No.");
                        GLEntry.SetFilter(GLEntry."Posting Date", '%1..%2', StartofcurrentYear, ThisYear);
                        if GLEntry.FindSet then begin
                            GLEntry.CalcSums(Amount);
                            RepaymentOfBorrowings += -1 * GLEntry.Amount;
                        end;
                    until GLAccount.Next = 0;
                end;
                LRepaymentOfBorrowings := 0;
                GLAccount.Reset;
                GLAccount.SetFilter(GLAccount.CashFlowCategory, '%1', GLAccount.CashFlowCategory::RepaymentOfBorrowings);
                if GLAccount.FindSet then begin
                    repeat
                        GLEntry.Reset;
                        GLEntry.SetRange(GLEntry."G/L Account No.", GLAccount."No.");
                        GLEntry.SetFilter(GLEntry."Posting Date", '%1..%2', StartofPreviousYear, EndofLastyear);
                        if GLEntry.FindSet then begin
                            GLEntry.CalcSums(Amount);
                            LRepaymentOfBorrowings += -1 * GLEntry.Amount;
                        end;
                    until GLAccount.Next = 0;
                end;


                //OtherInterestIncome
                // InvestmentIncome := 0;
                // GLAccount.Reset;
                // GLAccount.SetFilter(GLAccount.Incomes, '%1', GLAccount.Incomes::InvestmentIncome);
                // if GLAccount.FindSet then begin
                //     repeat
                //         GLEntry.Reset;
                //         GLEntry.SetRange(GLEntry."G/L Account No.", GLAccount."No.");
                //         GLEntry.SetFilter(GLEntry."Posting Date", '..%1', ThisYear);
                //         if GLEntry.FindSet then begin
                //             GLEntry.CalcSums(Amount);
                //             InvestmentIncome += -1 * GLEntry.Amount;
                //         end;

                //     until GLAccount.Next = 0;
                // end;

                // LInvestmentIncome := 0;
                // GLAccount.Reset;
                // GLAccount.SetFilter(GLAccount.Incomes, '%1', GLAccount.Incomes::InvestmentIncome);
                // if GLAccount.FindSet then begin
                //     repeat
                //         GLEntry.Reset;
                //         GLEntry.SetRange(GLEntry."G/L Account No.", GLAccount."No.");
                //         GLEntry.SetFilter(GLEntry."Posting Date", '..%1', EndofLastyear);
                //         if GLEntry.FindSet then begin
                //             GLEntry.CalcSums(Amount);
                //             LInvestmentIncome += -1 * GLEntry.Amount;
                //         end;

                //     until GLAccount.Next = 0;
                // end;


                ShareCapital := 0;
                GLAccount.Reset;
                GLAccount.SetFilter(GLAccount.CashFlowCategory, '%1', GLAccount.CashFlowCategory::ShareCapitalContribution);
                if GLAccount.FindSet then begin
                    repeat
                        GLEntry.Reset;
                        GLEntry.SetRange(GLEntry."G/L Account No.", GLAccount."No.");
                        GLEntry.SetFilter(GLEntry."Posting Date", '..%1', ThisYear);
                        if GLEntry.FindSet then begin
                            GLEntry.CalcSums(Amount);
                            ShareCapital += 1 * GLEntry.Amount;
                        end;
                    until GLAccount.Next = 0;
                end;
                LShareCapital := 0;
                GLAccount.Reset;
                GLAccount.SetFilter(GLAccount.CashFlowCategory, '%1', GLAccount.CashFlowCategory::ShareCapitalContribution);
                if GLAccount.FindSet then begin
                    repeat
                        GLEntry.Reset;
                        GLEntry.SetRange(GLEntry."G/L Account No.", GLAccount."No.");
                        GLEntry.SetFilter(GLEntry."Posting Date", '..%1', EndofLastyear);
                        if GLEntry.FindSet then begin
                            GLEntry.CalcSums(Amount);
                            LShareCapital += 1 * GLEntry.Amount;
                        end;
                    until GLAccount.Next = 0;
                end;
                //Endofsharecapital

                //start of year cash equivalents

                Cashatbank := 0;
                GLAccount.Reset;
                GLAccount.SetFilter(GLAccount.CashFlowCategory, '%1', GLAccount.CashFlowCategory::CashAndEquivalents);
                if GLAccount.FindSet then begin
                    repeat
                        GLEntry.Reset;
                        GLEntry.SetRange(GLEntry."G/L Account No.", GLAccount."No.");
                        GLEntry.SetFilter(GLEntry."Posting Date", '..%1', StartofcurrentYear);
                        if GLEntry.FindSet then begin
                            GLEntry.CalcSums(Amount);
                            Cashatbank += GLEntry.Amount;
                        end;
                    until GLAccount.Next = 0;

                end;
                LCashatbank := 0;
                GLAccount.Reset;
                GLAccount.SetFilter(GLAccount.CashFlowCategory, '%1', GLAccount.CashFlowCategory::CashAndEquivalents);
                if GLAccount.FindSet then begin
                    repeat
                        GLEntry.Reset;
                        GLEntry.SetRange(GLEntry."G/L Account No.", GLAccount."No.");
                        GLEntry.SetFilter(GLEntry."Posting Date", '..%1', StartofPreviousYear);
                        if GLEntry.FindSet then begin
                            GLEntry.CalcSums(Amount);
                            LCashatbank += GLEntry.Amount;

                        end;
                    until GLAccount.Next = 0;
                end;

                //End of year cash and Equivalents

                EndCashatbank := 0;
                GLAccount.Reset;
                GLAccount.SetFilter(GLAccount.CashFlowCategory, '%1', GLAccount.CashFlowCategory::CashAndEquivalents);
                if GLAccount.FindSet then begin
                    repeat
                        GLEntry.Reset;
                        GLEntry.SetRange(GLEntry."G/L Account No.", GLAccount."No.");
                        GLEntry.SetFilter(GLEntry."Posting Date", '..%1', AsAt);
                        if GLEntry.FindSet then begin
                            GLEntry.CalcSums(Amount);
                            endCashatbank += GLEntry.Amount;
                        end;
                    until GLAccount.Next = 0;

                end;
                EndLCashatbank := 0;
                GLAccount.Reset;
                GLAccount.SetFilter(GLAccount.CashFlowCategory, '%1', GLAccount.CashFlowCategory::CashAndEquivalents);
                if GLAccount.FindSet then begin
                    repeat
                        GLEntry.Reset;
                        GLEntry.SetRange(GLEntry."G/L Account No.", GLAccount."No.");
                        GLEntry.SetFilter(GLEntry."Posting Date", '..%1', EndofLastyear);
                        if GLEntry.FindSet then begin
                            GLEntry.CalcSums(Amount);
                            EndLCashatbank += GLEntry.Amount;

                        end;
                    until GLAccount.Next = 0;

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
                group(GroupName)
                {
                    field(Asat; Asat)
                    {
                        ApplicationArea = All;

                    }
                }
            }
        }

        actions
        {
            area(processing)
            {
                action(ActionName)
                {
                    ApplicationArea = All;

                }
            }
        }
    }



    var
        Cashatbank: Decimal;
        LCashatbank: Decimal;

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
        InterestonLoans: Decimal;
        LInterestonLoans: Decimal;
        GLEntry: Record "G/L Entry";
        GLAccount: Record "G/L Account";
        LoanandAdvances: Decimal;
        LLoanandAdvances: Decimal;
        FinancialAssets: Decimal;
        LFinancialAssets: Decimal;
        Honoraria: Decimal;
        LHonoraria: Decimal;
        InvestmentIncome: Decimal;
        LInvestmentIncome: Decimal;
        TradeandOtherPayables: Decimal;
        LTradeandOtherPayables: Decimal;
        LInterestonMemberDeposits: Decimal;
        InterestonMemberdeposits: Decimal;
        LOtherOperatingincome: Decimal;
        OtherOperatingincome: Decimal;
        Nonwithdrawabledeposits: Decimal;
        LNonwithdrawabledeposits: Decimal;
        ShareCapital: Decimal;
        LShareCapital: Decimal;

        PersonnelExpenses: Decimal;

        LPersonnelExpenses: Decimal;

        OtherInterestonLoans: Decimal;

        LOtherInterestonLoans: Decimal;

        TradeAndOtherReceivables: Decimal;

        LTradeAndOtherReceivables: Decimal;

        PayablesAndAccruals: Decimal;

        LPayablesAndAccruals: Decimal;

        TaxPayable: Decimal;

        LTaxPayable: Decimal;

        PurchaseOfAssets: Decimal;

        LPurchaseOfAssets: Decimal;

        PurchaseOfInvestments: Decimal;

        LPurchaseOfInvestments: Decimal;

        RepaymentOfBorrowings: Decimal;

        LRepaymentOfBorrowings: Decimal;

        Company: Record "Company Information";


    trigger OnPreReport()
    begin

        Company.get();
    end;
}