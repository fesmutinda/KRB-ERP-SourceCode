// report 50039 cashFlows
// {
//     UsageCategory = ReportsAndAnalysis;
//     ApplicationArea = All;
//     DefaultLayout = RDLC;
//     Caption = 'Statement of Cash Flows';
//     RDLCLayout = './Layout/cashflowsreport2.rdlc';

//     dataset
//     {
//         dataitem("Sacco Information"; "Sacco Information")
//         {
//             column(Code; Code)
//             {

//             }
//             column(Cashatbank; Cashatbank) { }
//             column(LCashatbank; LCashatbank) { }
//             column(endCashatbank; endCashatbank) { }
//             column(EndLCashatbank; EndLCashatbank) { }

//             column(IncreaseDecreaseInCashatbank; endCashatbank - EndLCashatbank)
//             {

//             }
//             column(PreviousYear; PreviousYear)
//             {

//             }
//             column(CurrentYear; CurrentYear)
//             {

//             }
//             column(EndofLastyear; EndofLastyear)
//             {

//             }
//             column(LoanandAdvances; LoanandAdvances)
//             {
//             }
//             column(LLoanandAdvances; LLoanandAdvances)
//             {
//             }

//             column(IncreaseDecreaseInLoanandAdvances; LoanandAdvances - LLoanandAdvances)
//             {

//             }
//             column(FinancialAssets; FinancialAssets)
//             {
//             }
//             column(LFinancialAssets; LFinancialAssets)
//             {
//             }

//             column(RepaymentOfBorrowings; RepaymentOfBorrowings)
//             {

//             }

//             column(LRepaymentOfBorrowings; LRepaymentOfBorrowings)
//             {
//             }


//             column(PurchaseOfAssets; PurchaseOfAssets)
//             {

//             }

//             column(LPurchaseOfAssets; LPurchaseOfAssets)
//             {

//             }


//             column(PurchaseOfInvestments; PurchaseOfInvestments)
//             {

//             }

//             column(LPurchaseOfInvestments; LPurchaseOfInvestments)
//             {

//             }
//             column(TradeandOtherPayables; TradeandOtherPayables)
//             {
//             }

//             column(TradeAndOtherReceivables; TradeAndOtherReceivables)
//             {

//             }

//             column(LTradeAndOtherReceivables; LTradeAndOtherReceivables)
//             {

//             }

//             // column(IncreaseDecreaseTradeReceivables; TradeAndOtherReceivables - LTradeAndOtherReceivables)
//             // {
//             //     Caption = '(Increase)/Decrease in Trade & Other Receivables';
//             // }

//             column(TaxAdjustment; TaxAdjustment)
//             {

//             }

//             column(LTaxAdjustment; LTaxAdjustment)
//             { }

//             column(TaxPayable; TaxPayable)
//             {

//             }

//             column(LTaxPayable; LTaxPayable)
//             { }

//             column(IncreaseDecreaseTaxPayable; TaxPayable - LTaxPayable)
//             {

//             }

//             column(PayablesAndAccruals; PayablesAndAccruals)
//             {
//             }

//             column(LPayablesAndAccruals; LPayablesAndAccruals)
//             {
//             }

//             column(IncreaseDecreasePayablesAndAccruals; PayablesAndAccruals - LPayablesAndAccruals)
//             {

//             }
//             column(LTradeandOtherPayables; LTradeandOtherPayables)
//             {
//             }
//             column(Honoraria; Honoraria)
//             {
//             }
//             column(LHonoraria; LHonoraria)
//             {
//             }
//             column(Nonwithdrawabledeposits; Nonwithdrawabledeposits)
//             {
//             }
//             column(LNonwithdrawabledeposits; LNonwithdrawabledeposits)
//             {
//             }

//             column(IncreaseDecreaseinNonWithdrawabledeposits; Nonwithdrawabledeposits - LNonwithdrawabledeposits)
//             {

//             }
//             column(InterestonMemberdeposits; InterestonMemberdeposits)
//             {

//             }
//             column(LInterestonMemberDeposits; LInterestonMemberDeposits)
//             {

//             }
//             column(InvestmentIncome; InvestmentIncome)
//             {

//             }
//             column(LInvestmentIncome; LInvestmentIncome)
//             {

//             }
//             column(ShareCapital; ShareCapital)
//             {
//             }
//             column(LShareCapital; LShareCapital)
//             { }
//             column(LOtherOperatingincome; LOtherOperatingincome)
//             {

//             }
//             column(OtherOperatingincome; OtherOperatingincome)
//             {

//             }
//             column(InterestonLoans; InterestonLoans) { }
//             column(LInterestonLoans; LInterestonLoans) { }
//             column(LInterestExpenses; LInterestExpenses) { }
//             column(InterestExpenses; InterestExpenses) { }

//             column(PersonnelExpenses; PersonnelExpenses) { }

//             column(LPersonnelExpenses; LPersonnelExpenses) { }
//             column(ReceivableandPrepayments; ReceivableandPrepayments) { }
//             column(LReceivableandPrepayments; LReceivableandPrepayments) { }
//             column(ThisYear; ThisYear)
//             {

//             }


//             column(Company_Name; Company.Name)
//             {
//             }
//             column(Company_Address; Company.Address)
//             {
//             }
//             column(Company_Address_2; Company."Address 2")
//             {
//             }
//             column(Company_Phone_No; Company."Phone No.")
//             {
//             }
//             column(Company_Fax_No; Company."Fax No.")
//             {
//             }
//             column(Company_Picture; Company.Picture)
//             {
//             }
//             column(Company_Email; Company."E-Mail")
//             {
//             }
//             trigger OnAfterGetRecord()
//             var
//                 myInt: Integer;
//                 InputDate: Date;
//                 DateFormula: Text;
//                 DateExpr: Text;
//                 StartofcurrentYear: Date;
//                 StartofPreviousYear: Date;
//                 DateExpr2: Text;
//                 CashFlowCategory: Option " ",InterestIncomeReceipts,OtherIncomeReceipts,PaymentsToEmployeesAndSuppliers,HonorariaPaid,TaxPaidAdjustment,TradeAndOtherReceivables,PayablesAndAccruals,MembersLoans,PurchaseOfAssets,PurchaseOfInvestments,MembersInterestPaid,RepaymentOfBorrowings,ShareCapitalContribution,MembersDeposit,CashAndEquivalents,TaxPayable;


//             begin
//                 DateFormula := '<-CY-1D>';
//                 DateExpr := '<-1y>';
//                 InputDate := Asat;
//                 DateExpr2 := '<-CY>';

//                 ThisYear := InputDate;
//                 StartofcurrentYear := CalcDate(DateExpr2, ThisYear);

//                 CurrentYear := Date2DMY(ThisYear, 3);
//                 EndofLastyear := CalcDate(DateFormula, ThisYear);
//                 StartofPreviousYear := CalcDate(DateExpr2, EndofLastyear);
//                 PreviousYear := CurrentYear - 1;


//                 //Interest on Loans
//                 InterestonLoans := 0;
//                 GLAccount.Reset;
//                 GLAccount.SetFilter(CashFlowCategory, '%1|%2', GLAccount.CashFlowCategory::InterestIncomeReceipts, GLAccount.CashFlowCategory2::InterestIncomeReceipts);
//                 repeat
//                     GLEntry.Reset;
//                     GLEntry.SetRange(GLEntry."G/L Account No.", GLAccount."No.");
//                     GLEntry.SetFilter(GLEntry."Posting Date", '..%1', ThisYear);
//                     if GLEntry.FindSet then begin
//                         GLEntry.CalcSums(Amount);
//                         InterestonLoans += -1 * GLEntry.Amount;
//                     end;

//                 until GLAccount.Next = 0;


//                 LInterestonLoans := 0;
//                 GLAccount.Reset;
//                 GLAccount.SetFilter(GLAccount.CashFlowCategory, '%1', GLAccount.CashFlowCategory::InterestIncomeReceipts);
//                 if GLAccount.FindSet then begin
//                     repeat
//                         GLEntry.Reset;
//                         GLEntry.SetRange(GLEntry."G/L Account No.", GLAccount."No.");
//                         GLEntry.SetFilter(GLEntry."Posting Date", '..%1', EndofLastyear);
//                         if GLEntry.FindSet then begin
//                             GLEntry.CalcSums(Amount);
//                             LInterestonLoans += -1 * GLEntry.Amount;
//                         end;

//                     until GLAccount.Next = 0;
//                 end;



//                 //Other Income from loans
//                 OtherInterestonLoans := 0;
//                 GLAccount.Reset;
//                 GLAccount.SetFilter(GLAccount.CashFlowCategory, '%1', GLAccount.CashFlowCategory::OtherIncomeReceipts);
//                 if GLAccount.FindSet then begin
//                     repeat
//                         GLEntry.Reset;
//                         GLEntry.SetRange(GLEntry."G/L Account No.", GLAccount."No.");
//                         GLEntry.SetFilter(GLEntry."Posting Date", '..%1', ThisYear);
//                         if GLEntry.FindSet then begin
//                             GLEntry.CalcSums(Amount);
//                             OtherInterestonLoans += -1 * GLEntry.Amount;
//                         end;

//                     until GLAccount.Next = 0;
//                 end;

//                 LOtherInterestonLoans := 0;
//                 GLAccount.Reset;
//                 GLAccount.SetFilter(GLAccount.CashFlowCategory, '%1', GLAccount.CashFlowCategory::OtherIncomeReceipts);
//                 if GLAccount.FindSet then begin
//                     repeat
//                         GLEntry.Reset;
//                         GLEntry.SetRange(GLEntry."G/L Account No.", GLAccount."No.");
//                         GLEntry.SetFilter(GLEntry."Posting Date", '..%1', EndofLastyear);
//                         if GLEntry.FindSet then begin
//                             GLEntry.CalcSums(Amount);
//                             LOtherInterestonLoans += -1 * GLEntry.Amount;
//                         end;

//                     until GLAccount.Next = 0;
//                 end;
//                 //Personnel Expenses (Payments to Employees and Suppliers)
//                 PersonnelExpenses := 0;
//                 GLAccount.Reset;
//                 GLAccount.SetFilter(GLAccount.CashFlowCategory, '%1', GLAccount.CashFlowCategory::PaymentsToEmployeesAndSuppliers);
//                 if GLAccount.FindSet() then begin
//                     repeat
//                         GLEntry.Reset;
//                         GLEntry.SetRange(GLEntry."G/L Account No.", GLAccount."No.");
//                         GLEntry.SetFilter(GLEntry."Posting Date", '..%1', ThisYear);
//                         if GLEntry.FindSet then begin
//                             GLEntry.CalcSums(Amount);
//                             PersonnelExpenses += -1 * GLEntry.Amount;
//                         end;
//                     until GLAccount.Next() = 0
//                 end;


//                 LPersonnelExpenses := 0;
//                 GLAccount.Reset;
//                 GLAccount.SetFilter(GLAccount.CashFlowCategory, '%1', GLAccount.CashFlowCategory::PaymentsToEmployeesAndSuppliers);
//                 if GLAccount.FindSet then begin
//                     repeat
//                         GLEntry.Reset;
//                         GLEntry.SetRange(GLEntry."G/L Account No.", GLAccount."No.");
//                         GLEntry.SetFilter(GLEntry."Posting Date", '..%1', EndofLastyear);
//                         if GLEntry.FindSet then begin
//                             GLEntry.CalcSums(Amount);
//                             LPersonnelExpenses += -1 * GLEntry.Amount;
//                         end;

//                     until GLAccount.Next = 0;
//                 end;



//                 //Otheroperatingincome
//                 OtherOperatingincome := 0;
//                 GLAccount.Reset;
//                 GLAccount.SetFilter(GLAccount.CashFlowCategory, '%1', GLAccount.CashFlowCategory::OtherIncomeReceipts);
//                 if GLAccount.FindSet then begin
//                     repeat
//                         GLEntry.Reset;
//                         GLEntry.SetRange(GLEntry."G/L Account No.", GLAccount."No.");
//                         GLEntry.SetFilter(GLEntry."Posting Date", '..%1', ThisYear);
//                         if GLEntry.FindSet then begin
//                             GLEntry.CalcSums(Amount);
//                             OtherOperatingincome += -1 * GLEntry.Amount;
//                         end;

//                     until GLAccount.Next = 0;
//                 end;

//                 LOtherOperatingincome := 0;
//                 GLAccount.Reset;
//                 GLAccount.SetFilter(GLAccount.CashFlowCategory, '%1', GLAccount.CashFlowCategory::OtherIncomeReceipts);
//                 if GLAccount.FindSet then begin
//                     repeat
//                         GLEntry.Reset;
//                         GLEntry.SetRange(GLEntry."G/L Account No.", GLAccount."No.");
//                         GLEntry.SetFilter(GLEntry."Posting Date", '..%1', EndofLastyear);
//                         if GLEntry.FindSet then begin
//                             GLEntry.CalcSums(Amount);
//                             LOtherOperatingincome += -1 * GLEntry.Amount;
//                         end;

//                     until GLAccount.Next = 0;
//                 end;


//                 //LoanandAdvances
//                 LoanandAdvances := 0;
//                 LLoanandAdvances := 0;
//                 GLAccount.Reset;
//                 GLAccount.SetFilter(GLAccount.CashFlowCategory, '%1', GLAccount.CashFlowCategory::MembersLoans);
//                 if GLAccount.FindSet then begin
//                     repeat

//                         GLEntry.Reset;
//                         GLEntry.SetRange(GLEntry."G/L Account No.", GLAccount."No.");
//                         GLEntry.SetFilter(GLEntry."Posting Date", '%1..%2', StartofcurrentYear, ThisYear);
//                         if GLEntry.FindSet then begin
//                             GLEntry.CalcSums(Amount);
//                             LoanandAdvances += GLEntry.Amount;
//                         end;

//                     until GLAccount.Next = 0;
//                 end;

//                 GLAccount.Reset;
//                 GLAccount.SetFilter(GLAccount.CashFlowCategory, '%1', GLAccount.CashFlowCategory::MembersLoans);
//                 if GLAccount.FindSet then begin
//                     repeat

//                         GLEntry.Reset;
//                         GLEntry.SetRange(GLEntry."G/L Account No.", GLAccount."No.");
//                         GLEntry.SetFilter(GLEntry."Posting Date", '%1..%2', StartofPreviousYear, EndofLastyear);
//                         if GLEntry.FindSet then begin
//                             GLEntry.CalcSums(Amount);
//                             LLoanandAdvances += GLEntry.Amount;
//                         end;

//                     until GLAccount.Next = 0;
//                 end;
//                 //EndofLoanandAdavances

//                 //Purchase of Assets
//                 PurchaseOfAssets := 0;
//                 LPurchaseOfAssets := 0;
//                 GLAccount.Reset;
//                 GLAccount.SetFilter(GLAccount.CashFlowCategory, '%1', GLAccount.CashFlowCategory::PurchaseOfAssets);
//                 if GLAccount.FindSet then begin
//                     repeat

//                         GLEntry.Reset;
//                         GLEntry.SetRange(GLEntry."G/L Account No.", GLAccount."No.");
//                         GLEntry.SetFilter(GLEntry."Posting Date", '%1..%2', StartofcurrentYear, ThisYear);
//                         if GLEntry.FindSet then begin
//                             GLEntry.CalcSums(Amount);
//                             PurchaseOfAssets += GLEntry.Amount;
//                         end;
//                     until GLAccount.Next = 0;
//                 end;

//                 GLAccount.Reset;
//                 GLAccount.SetFilter(GLAccount.CashFlowCategory, '%1', GLAccount.CashFlowCategory::PurchaseOfAssets);
//                 if GLAccount.FindSet then begin
//                     repeat

//                         GLEntry.Reset;
//                         GLEntry.SetRange(GLEntry."G/L Account No.", GLAccount."No.");
//                         GLEntry.SetFilter(GLEntry."Posting Date", '%1..%2', StartofPreviousYear, EndofLastyear);
//                         if GLEntry.FindSet then begin
//                             GLEntry.CalcSums(Amount);
//                             LPurchaseOfAssets += GLEntry.Amount;
//                         end;

//                     until GLAccount.Next = 0;
//                 end;


//                 //PurchaseOfInvestments
//                 PurchaseOfInvestments := 0;
//                 LPurchaseOfInvestments := 0;
//                 GLAccount.Reset;
//                 GLAccount.SetFilter(GLAccount.CashFlowCategory, '%1', GLAccount.CashFlowCategory::PurchaseOfInvestments);
//                 if GLAccount.FindSet then begin
//                     repeat
//                         GLEntry.Reset;
//                         GLEntry.SetRange(GLEntry."G/L Account No.", GLAccount."No.");
//                         GLEntry.SetFilter(GLEntry."Posting Date", '%1..%2', StartofcurrentYear, ThisYear);
//                         if GLEntry.FindSet then begin
//                             GLEntry.CalcSums(Amount);
//                             PurchaseOfInvestments += GLEntry.Amount;
//                         end;
//                     until GLAccount.Next = 0;
//                 end;

//                 GLAccount.Reset;
//                 GLAccount.SetFilter(GLAccount.CashFlowCategory, '%1', GLAccount.CashFlowCategory::PurchaseOfInvestments);
//                 if GLAccount.FindSet then begin
//                     repeat
//                         GLEntry.Reset;
//                         GLEntry.SetRange(GLEntry."G/L Account No.", GLAccount."No.");
//                         GLEntry.SetFilter(GLEntry."Posting Date", '%1..%2', StartofPreviousYear, EndofLastyear);
//                         if GLEntry.FindSet then begin
//                             GLEntry.CalcSums(Amount);
//                             LPurchaseOfInvestments += GLEntry.Amount;
//                         end;
//                     until GLAccount.Next = 0;
//                 end;

//                 //Honoraria
//                 Honoraria := 0;
//                 GLAccount.Reset;
//                 GLAccount.SetFilter(GLAccount.CashFlowCategory, '%1', GLAccount.CashFlowCategory::HonorariaPaid);
//                 if GLAccount.FindSet then begin
//                     repeat
//                         GLEntry.Reset;
//                         GLEntry.SetRange(GLEntry."G/L Account No.", GLAccount."No.");
//                         GLEntry.SetFilter(GLEntry."Posting Date", '%1..%2', StartofcurrentYear, ThisYear);
//                         if GLEntry.FindSet then begin
//                             GLEntry.CalcSums(Amount);
//                             Honoraria += -1 * GLEntry.Amount;
//                         end;
//                     until GLAccount.Next = 0;
//                 end;
//                 LHonoraria := 0;
//                 GLAccount.Reset;
//                 GLAccount.SetFilter(GLAccount.CashFlowCategory, '%1', GLAccount.CashFlowCategory::HonorariaPaid);
//                 if GLAccount.FindSet then begin
//                     repeat
//                         GLEntry.Reset;
//                         GLEntry.SetRange(GLEntry."G/L Account No.", GLAccount."No.");
//                         GLEntry.SetFilter(GLEntry."Posting Date", '%1..%2', StartofPreviousYear, EndofLastyear);
//                         if GLEntry.FindSet then begin
//                             GLEntry.CalcSums(Amount);
//                             LHonoraria += -1 * GLEntry.Amount;
//                         end;
//                     until GLAccount.Next = 0;
//                 end;
//                 //EndofHonaria

//                 //Member Deposits
//                 GLAccount.Reset;
//                 GLAccount.SetFilter(GLAccount.CashFlowCategory, '%1', GLAccount.CashFlowCategory::MembersDeposit);
//                 if GLAccount.FindSet then begin
//                     repeat
//                         GLEntry.Reset;
//                         GLEntry.SetRange(GLEntry."G/L Account No.", GLAccount."No.");
//                         GLEntry.SetFilter(GLEntry."Posting Date", '%1..%2', StartofcurrentYear, ThisYear);
//                         if GLEntry.FindSet then begin
//                             GLEntry.CalcSums(Amount);
//                             Nonwithdrawabledeposits += -1 * GLEntry.Amount;
//                         end;
//                     until GLAccount.Next = 0;

//                 end;
//                 GLAccount.Reset;
//                 GLAccount.SetFilter(GLAccount.CashFlowCategory, '%1', GLAccount.CashFlowCategory::MembersDeposit);
//                 if GLAccount.FindSet then begin
//                     repeat
//                         GLEntry.Reset;
//                         GLEntry.SetRange(GLEntry."G/L Account No.", GLAccount."No.");
//                         GLEntry.SetFilter(GLEntry."Posting Date", '%1..%2', StartofPreviousYear, EndofLastyear);
//                         if GLEntry.FindSet then begin
//                             GLEntry.CalcSums(Amount);
//                             LNonwithdrawabledeposits += -1 * GLEntry.Amount;
//                         end;
//                     until GLAccount.Next = 0;

//                 end;
//                 // EmdMember deposits

//                 //Increase in TradeAndOtherReceivables
//                 TradeAndOtherReceivables := 0;
//                 GLAccount.Reset;
//                 GLAccount.SetFilter(GLAccount.CashFlowCategory, '%1', GLAccount.CashFlowCategory::TradeAndOtherReceivables);
//                 if GLAccount.FindSet then begin
//                     repeat
//                         GLEntry.Reset;
//                         GLEntry.SetRange(GLEntry."G/L Account No.", GLAccount."No.");
//                         GLEntry.SetFilter(GLEntry."Posting Date", '%1..%2', StartofcurrentYear, ThisYear);
//                         if GLEntry.FindSet then begin
//                             GLEntry.CalcSums(Amount);
//                             TradeAndOtherReceivables += GLEntry.Amount;
//                         end;
//                     until GLAccount.Next = 0;
//                 end;
//                 LTradeAndOtherReceivables := 0;
//                 GLAccount.Reset;
//                 GLAccount.SetFilter(GLAccount.CashFlowCategory, '%1', GLAccount.CashFlowCategory::TradeAndOtherReceivables);
//                 if GLAccount.FindSet then begin
//                     repeat
//                         GLEntry.Reset;
//                         GLEntry.SetRange(GLEntry."G/L Account No.", GLAccount."No.");
//                         GLEntry.SetFilter(GLEntry."Posting Date", '%1..%2', StartofPreviousYear, EndofLastyear);
//                         if GLEntry.FindSet then begin
//                             GLEntry.CalcSums(Amount);
//                             LTradeAndOtherReceivables += GLEntry.Amount;
//                         end;
//                     until GLAccount.Next = 0;
//                 end;

//                 //PayablesAndAccruals
//                 PayablesAndAccruals := 0;
//                 GLAccount.Reset;
//                 GLAccount.SetFilter(GLAccount.CashFlowCategory, '%1', GLAccount.CashFlowCategory::PayablesAndAccruals);
//                 if GLAccount.FindSet then begin
//                     repeat
//                         GLEntry.Reset;
//                         GLEntry.SetRange(GLEntry."G/L Account No.", GLAccount."No.");
//                         GLEntry.SetFilter(GLEntry."Posting Date", '%1..%2', StartofcurrentYear, ThisYear);
//                         if GLEntry.FindSet then begin
//                             GLEntry.CalcSums(Amount);
//                             PayablesAndAccruals += -1 * GLEntry.Amount;
//                         end;
//                     until GLAccount.Next = 0;
//                 end;

//                 LPayablesAndAccruals := 0;
//                 GLAccount.Reset;
//                 GLAccount.SetFilter(GLAccount.CashFlowCategory, '%1', GLAccount.CashFlowCategory::PayablesAndAccruals);
//                 if GLAccount.FindSet then begin
//                     repeat
//                         GLEntry.Reset;
//                         GLEntry.SetRange(GLEntry."G/L Account No.", GLAccount."No.");
//                         GLEntry.SetFilter(GLEntry."Posting Date", '%1..%2', StartofPreviousYear, EndofLastyear);
//                         if GLEntry.FindSet then begin
//                             GLEntry.CalcSums(Amount);
//                             LPayablesAndAccruals += -1 * GLEntry.Amount;
//                         end;
//                     until GLAccount.Next = 0;
//                 end;

//                 //TaxAdjustment
//                 TaxAdjustment := 0;
//                 GLAccount.Reset;
//                 GLAccount.SetFilter(GLAccount.CashFlowCategory, '%1', GLAccount.CashFlowCategory::TaxPaidAdjustment);
//                 if GLAccount.FindSet then begin
//                     repeat
//                         GLEntry.Reset;
//                         GLEntry.SetRange(GLEntry."G/L Account No.", GLAccount."No.");
//                         GLEntry.SetFilter(GLEntry."Posting Date", '%1..%2', StartofcurrentYear, ThisYear);
//                         if GLEntry.FindSet then begin
//                             GLEntry.CalcSums(Amount);
//                             TaxAdjustment += -1 * GLEntry.Amount;
//                         end;
//                     until GLAccount.Next = 0;
//                 end;
//                 LTaxAdjustment := 0;
//                 GLAccount.Reset;
//                 GLAccount.SetFilter(GLAccount.CashFlowCategory, '%1', GLAccount.CashFlowCategory::TaxPaidAdjustment);
//                 if GLAccount.FindSet then begin
//                     repeat
//                         GLEntry.Reset;
//                         GLEntry.SetRange(GLEntry."G/L Account No.", GLAccount."No.");
//                         GLEntry.SetFilter(GLEntry."Posting Date", '%1..%2', StartofPreviousYear, EndofLastyear);
//                         if GLEntry.FindSet then begin
//                             GLEntry.CalcSums(Amount);
//                             LTaxAdjustment += 1 * GLEntry.Amount;
//                         end;
//                     until GLAccount.Next = 0;
//                 end;


//                 //TaxPayable

//                 TaxPayable := 0;
//                 GLAccount.Reset;
//                 GLAccount.SetFilter(GLAccount.CashFlowCategory, '%1', GLAccount.CashFlowCategory::TaxPayable);
//                 if GLAccount.FindSet then begin
//                     repeat
//                         GLEntry.Reset;
//                         GLEntry.SetRange(GLEntry."G/L Account No.", GLAccount."No.");
//                         GLEntry.SetFilter(GLEntry."Posting Date", '%1..%2', StartofcurrentYear, ThisYear);
//                         if GLEntry.FindSet then begin
//                             GLEntry.CalcSums(Amount);
//                             TaxPayable += -1 * GLEntry.Amount;
//                         end;
//                     until GLAccount.Next = 0;
//                 end;
//                 LTaxPayable := 0;
//                 GLAccount.Reset;
//                 GLAccount.SetFilter(GLAccount.CashFlowCategory, '%1', GLAccount.CashFlowCategory::TaxPayable);
//                 if GLAccount.FindSet then begin
//                     repeat
//                         GLEntry.Reset;
//                         GLEntry.SetRange(GLEntry."G/L Account No.", GLAccount."No.");
//                         GLEntry.SetFilter(GLEntry."Posting Date", '%1..%2', StartofPreviousYear, EndofLastyear);
//                         if GLEntry.FindSet then begin
//                             GLEntry.CalcSums(Amount);
//                             LTaxPayable += -1 * GLEntry.Amount;
//                         end;
//                     until GLAccount.Next = 0;
//                 end;

//                 //Dividends
//                 InterestonMemberdeposits := 0;
//                 GLAccount.Reset;
//                 GLAccount.SetFilter(GLAccount.CashFlowCategory, '%1', GLAccount.CashFlowCategory::MembersInterestPaid);
//                 if GLAccount.FindSet then begin
//                     repeat
//                         GLEntry.Reset;
//                         GLEntry.SetRange(GLEntry."G/L Account No.", GLAccount."No.");
//                         GLEntry.SetFilter(GLEntry."Posting Date", '%1..%2', StartofcurrentYear, ThisYear);
//                         if GLEntry.FindSet then begin
//                             GLEntry.CalcSums(Amount);
//                             InterestonMemberdeposits += GLEntry.Amount;
//                         end;
//                     until GLAccount.Next = 0;
//                 end;
//                 LInterestonMemberdeposits := 0;
//                 GLAccount.Reset;
//                 GLAccount.SetFilter(GLAccount.CashFlowCategory, '%1', GLAccount.CashFlowCategory::MembersInterestPaid);
//                 if GLAccount.FindSet then begin
//                     repeat
//                         GLEntry.Reset;
//                         GLEntry.SetRange(GLEntry."G/L Account No.", GLAccount."No.");
//                         GLEntry.SetFilter(GLEntry."Posting Date", '%1..%2', StartofPreviousYear, EndofLastyear);
//                         if GLEntry.FindSet then begin
//                             GLEntry.CalcSums(Amount);
//                             LInterestonMemberdeposits += GLEntry.Amount;
//                         end;
//                     until GLAccount.Next = 0;
//                 end;

//                 //End of Dividends


//                 //repaymentonborrowings

//                 RepaymentOfBorrowings := 0;
//                 GLAccount.Reset;
//                 GLAccount.SetFilter(GLAccount.CashFlowCategory, '%1', GLAccount.CashFlowCategory::RepaymentOfBorrowings);
//                 if GLAccount.FindSet then begin
//                     repeat
//                         GLEntry.Reset;
//                         GLEntry.SetRange(GLEntry."G/L Account No.", GLAccount."No.");
//                         GLEntry.SetFilter(GLEntry."Posting Date", '%1..%2', StartofcurrentYear, ThisYear);
//                         if GLEntry.FindSet then begin
//                             GLEntry.CalcSums(Amount);
//                             RepaymentOfBorrowings += -1 * GLEntry.Amount;
//                         end;
//                     until GLAccount.Next = 0;
//                 end;
//                 LRepaymentOfBorrowings := 0;
//                 GLAccount.Reset;
//                 GLAccount.SetFilter(GLAccount.CashFlowCategory, '%1', GLAccount.CashFlowCategory::RepaymentOfBorrowings);
//                 if GLAccount.FindSet then begin
//                     repeat
//                         GLEntry.Reset;
//                         GLEntry.SetRange(GLEntry."G/L Account No.", GLAccount."No.");
//                         GLEntry.SetFilter(GLEntry."Posting Date", '%1..%2', StartofPreviousYear, EndofLastyear);
//                         if GLEntry.FindSet then begin
//                             GLEntry.CalcSums(Amount);
//                             LRepaymentOfBorrowings += -1 * GLEntry.Amount;
//                         end;
//                     until GLAccount.Next = 0;
//                 end;



//                 ShareCapital := 0;
//                 GLAccount.Reset;
//                 GLAccount.SetFilter(GLAccount.CashFlowCategory, '%1', GLAccount.CashFlowCategory::ShareCapitalContribution);
//                 if GLAccount.FindSet then begin
//                     repeat
//                         GLEntry.Reset;
//                         GLEntry.SetRange(GLEntry."G/L Account No.", GLAccount."No.");
//                         GLEntry.SetFilter(GLEntry."Posting Date", '..%1', ThisYear);
//                         if GLEntry.FindSet then begin
//                             GLEntry.CalcSums(Amount);
//                             ShareCapital += -1 * GLEntry.Amount;
//                         end;
//                     until GLAccount.Next = 0;
//                 end;
//                 LShareCapital := 0;
//                 GLAccount.Reset;
//                 GLAccount.SetFilter(GLAccount.CashFlowCategory, '%1', GLAccount.CashFlowCategory::ShareCapitalContribution);
//                 if GLAccount.FindSet then begin
//                     repeat
//                         GLEntry.Reset;
//                         GLEntry.SetRange(GLEntry."G/L Account No.", GLAccount."No.");
//                         GLEntry.SetFilter(GLEntry."Posting Date", '..%1', EndofLastyear);
//                         if GLEntry.FindSet then begin
//                             GLEntry.CalcSums(Amount);
//                             LShareCapital += -1 * GLEntry.Amount;
//                         end;
//                     until GLAccount.Next = 0;
//                 end;
//                 //Endofsharecapital

//                 //start of year cash equivalents

//                 Cashatbank := 0;
//                 GLAccount.Reset;
//                 GLAccount.SetFilter(GLAccount.CashFlowCategory, '%1', GLAccount.CashFlowCategory::CashAndEquivalents);
//                 if GLAccount.FindSet then begin
//                     repeat
//                         GLEntry.Reset;
//                         GLEntry.SetRange(GLEntry."G/L Account No.", GLAccount."No.");
//                         // GLEntry.SetFilter(GLEntry."Posting Date", '..%1', StartofcurrentYear);
//                         GLEntry.SetFilter(GLEntry."Posting Date", '..%1', EndofLastyear);
//                         if GLEntry.FindSet then begin
//                             GLEntry.CalcSums(Amount);
//                             Cashatbank += GLEntry.Amount;
//                         end;
//                     until GLAccount.Next = 0;

//                 end;
//                 LCashatbank := 0;
//                 GLAccount.Reset;
//                 GLAccount.SetFilter(GLAccount.CashFlowCategory, '%1', GLAccount.CashFlowCategory::CashAndEquivalents);
//                 if GLAccount.FindSet then begin
//                     repeat
//                         GLEntry.Reset;
//                         GLEntry.SetRange(GLEntry."G/L Account No.", GLAccount."No.");
//                         GLEntry.SetFilter(GLEntry."Posting Date", '..%1', StartofPreviousYear);
//                         if GLEntry.FindSet then begin
//                             GLEntry.CalcSums(Amount);
//                             LCashatbank += GLEntry.Amount;

//                         end;
//                     until GLAccount.Next = 0;
//                 end;

//                 //End of year cash and Equivalents

//                 EndCashatbank := 0;
//                 GLAccount.Reset;
//                 GLAccount.SetFilter(GLAccount.CashFlowCategory, '%1', GLAccount.CashFlowCategory::CashAndEquivalents);
//                 if GLAccount.FindSet then begin
//                     repeat
//                         GLEntry.Reset;
//                         GLEntry.SetRange(GLEntry."G/L Account No.", GLAccount."No.");
//                         GLEntry.SetFilter(GLEntry."Posting Date", '..%1', AsAt);
//                         if GLEntry.FindSet then begin
//                             GLEntry.CalcSums(Amount);
//                             endCashatbank += GLEntry.Amount;
//                         end;
//                     until GLAccount.Next = 0;

//                 end;
//                 EndLCashatbank := 0;
//                 GLAccount.Reset;
//                 GLAccount.SetFilter(GLAccount.CashFlowCategory, '%1', GLAccount.CashFlowCategory::CashAndEquivalents);
//                 if GLAccount.FindSet then begin
//                     repeat
//                         GLEntry.Reset;
//                         GLEntry.SetRange(GLEntry."G/L Account No.", GLAccount."No.");
//                         GLEntry.SetFilter(GLEntry."Posting Date", '..%1', EndofLastyear);
//                         if GLEntry.FindSet then begin
//                             GLEntry.CalcSums(Amount);
//                             EndLCashatbank += GLEntry.Amount;

//                         end;
//                     until GLAccount.Next = 0;

//                 end;
//             end;
//         }
//     }

//     requestpage
//     {
//         layout
//         {
//             area(Content)
//             {
//                 group(GroupName)
//                 {
//                     field(Asat; Asat)
//                     {
//                         ApplicationArea = All;

//                     }
//                 }
//             }
//         }

//         actions
//         {
//             area(processing)
//             {
//                 action(ActionName)
//                 {
//                     ApplicationArea = All;

//                 }
//             }
//         }
//     }



//     var
//         Cashatbank: Decimal;
//         LCashatbank: Decimal;

//         endCashatbank: Decimal;
//         EndLCashatbank: Decimal;
//         AsAt: Date;
//         ReceivableandPrepayments: Decimal;
//         LReceivableandPrepayments: Decimal;
//         LInterestExpenses: Decimal;
//         InterestExpenses: Decimal;
//         PreviousYear: Integer;
//         CurrentYear: Integer;
//         EndofLastyear: date;
//         ThisYear: Date;
//         InterestonLoans: Decimal;
//         LInterestonLoans: Decimal;
//         GLEntry: Record "G/L Entry";
//         GLAccount: Record "G/L Account";
//         LoanandAdvances: Decimal;
//         LLoanandAdvances: Decimal;
//         FinancialAssets: Decimal;
//         LFinancialAssets: Decimal;
//         Honoraria: Decimal;
//         LHonoraria: Decimal;
//         InvestmentIncome: Decimal;
//         LInvestmentIncome: Decimal;
//         TradeandOtherPayables: Decimal;
//         LTradeandOtherPayables: Decimal;
//         LInterestonMemberDeposits: Decimal;
//         InterestonMemberdeposits: Decimal;
//         LOtherOperatingincome: Decimal;
//         OtherOperatingincome: Decimal;
//         Nonwithdrawabledeposits: Decimal;
//         LNonwithdrawabledeposits: Decimal;
//         ShareCapital: Decimal;
//         LShareCapital: Decimal;

//         PersonnelExpenses: Decimal;

//         LPersonnelExpenses: Decimal;

//         OtherInterestonLoans: Decimal;

//         LOtherInterestonLoans: Decimal;

//         TradeAndOtherReceivables: Decimal;

//         LTradeAndOtherReceivables: Decimal;

//         PayablesAndAccruals: Decimal;

//         LPayablesAndAccruals: Decimal;

//         TaxPayable: Decimal;

//         LTaxPayable: Decimal;

//         PurchaseOfAssets: Decimal;

//         LPurchaseOfAssets: Decimal;

//         PurchaseOfInvestments: Decimal;

//         LPurchaseOfInvestments: Decimal;

//         RepaymentOfBorrowings: Decimal;

//         LRepaymentOfBorrowings: Decimal;

//         TaxAdjustment: Decimal;

//         LTaxAdjustment: Decimal;

//         Company: Record "Company Information";


//     trigger OnPreReport()
//     begin

//         Company.get();
//     end;
// }


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
            var



            begin


                LStartDate := CalcDate('<-1Y>', StartDate);
                LEndDate := CalcDate('<-1Y>', EndDate);





                CurrentYear := Date2DMY(StartDate, 3);
                PreviousYear := Date2DMY(LStartDate, 3);

                //adjust for opening baalnce figures entred on 31.12.2024

                if StartDate = DMY2Date(1, 1, 2025) then
                    ModStartDate := CalcDate('<-1D>', StartDate)
                else
                    ModStartDate := StartDate;


                if LStartDate = DMY2Date(1, 1, 2025) then
                    ModLStartDate := CalcDate('<-1D>', LStartDate)
                else
                    ModLStartDate := LStartDate;


                // Start of Honoraria 

                Honoraria := 0;
                GLAccount.Reset;
                GLAccount.SetFilter(CashFlowCategory, '%1', GLAccount.CashFlowCategory::Honoraria);


                if (StartDate < DMY2DATE(1, 1, 2025)) then begin
                    Honoraria := 132000 * -1;
                end

                else if GLAccount.FindSet then begin

                    repeat

                        GLAccount.SetFilter("Date Filter", '%1..%2', ModStartDate, EndDate);
                        GLAccount.CalcFields("Net Change");

                        Honoraria += GLAccount."Net Change" * -1;

                    until GLAccount.Next = 0;
                end;

                LHonoraria := 0;
                GLAccount.Reset;
                GLAccount.SetFilter(GLAccount.CashFlowCategory, '%1', GLAccount.CashFlowCategory::Honoraria);

                if (LStartDate < DMY2DATE(1, 1, 2024)) then
                    LHonoraria := 132000 * -1
                else if LStartDate < DMY2DATE(1, 1, 2025) then
                    LHonoraria := 132000 * -1

                else if GLAccount.FindSet then begin
                    repeat

                        GLAccount.SetFilter("Date Filter", '%1..%2', ModLStartDate, LEndDate);
                        GLAccount.CalcFields("Net Change");

                        LHonoraria += GLAccount."Net Change" * -1;

                    until GLAccount.Next = 0;
                end;

                //End of Honoraria


                // Start of IncomeReceipts

                IncomeReceipts := 0;
                GLAccount.Reset;
                GLAccount.SetFilter(CashFlowCategory, '%1', GLAccount.CashFlowCategory::IncomeReceipts);


                if (StartDate < DMY2DATE(1, 1, 2025)) then
                    IncomeReceipts := 13954025

                else if GLAccount.FindSet then begin
                    repeat

                        GLAccount.SetFilter("Date Filter", '%1..%2', ModStartDate, EndDate);
                        GLAccount.CalcFields("Net Change");

                        IncomeReceipts += GLAccount."Net Change" * -1;

                    until GLAccount.Next = 0;
                end;


                LIncomeReceipts := 0;
                GLAccount.Reset;
                GLAccount.SetFilter(GLAccount.CashFlowCategory, '%1', GLAccount.CashFlowCategory::IncomeReceipts);

                if (LStartDate < DMY2DATE(1, 1, 2024)) then
                    LIncomeReceipts := 13288510
                else if (LStartDate < DMY2DATE(1, 1, 2025)) then
                    LIncomeReceipts := 13954025

                else if GLAccount.FindSet then begin
                    repeat
                        GLAccount.SetFilter("Date Filter", '%1..%2', ModLStartDate, LEndDate);
                        GLAccount.CalcFields("Net Change");

                        LIncomeReceipts += GLAccount."Net Change" * -1;
                    until GLAccount.Next = 0;
                end;

                //End of Income


                //Start of Other Income

                OtherIncome := 0;
                GLAccount.Reset;
                GLAccount.SetFilter(CashFlowCategory, '%1', GLAccount.CashFlowCategory::OtherIncome);

                if (StartDate < DMY2DATE(1, 1, 2025)) then begin
                    OtherIncome := 484673;
                end

                else if GLAccount.FindSet then begin
                    repeat

                        GLAccount.SetFilter("Date Filter", '%1..%2', ModStartDate, EndDate);
                        GLAccount.CalcFields("Net Change");

                        OtherIncome += GLAccount."Net Change" * -1;

                    until GLAccount.Next = 0;
                end;


                LOtherIncome := 0;
                GLAccount.Reset;
                GLAccount.SetFilter(GLAccount.CashFlowCategory, '%1', GLAccount.CashFlowCategory::OtherIncome);

                if (LStartDate < DMY2DATE(1, 1, 2024)) then
                    LOtherIncome := 479758
                else if (LStartDate < DMY2DATE(1, 1, 2025)) then
                    LOtherIncome := 484673
                else if GLAccount.FindSet then begin
                    repeat

                        GLAccount.SetFilter("Date Filter", '%1..%2', ModLStartDate, LEndDate);

                        GLAccount.CalcFields("Net Change");

                        LOtherIncome += GLAccount."Net Change" * -1;

                    until GLAccount.Next = 0;
                end;



                //End of Other Income


                //INTERESTONMEBERDEPOSITS
                InterestonMemberdeposits := 0;
                GLAccount.Reset;
                GLAccount.SetFilter(CashFlowCategory, '%1', GLAccount.CashFlowCategory::MembersInterestPaid);


                if (StartDate < DMY2DATE(1, 1, 2025)) then begin
                    InterestonMemberdeposits := 9600000 * -1;
                end

                else if GLAccount.FindSet then begin
                    repeat

                        GLAccount.SetFilter("Date Filter", '%1..%2', ModStartDate, EndDate);
                        GLAccount.CalcFields("Net Change");

                        InterestonMemberdeposits += GLAccount."Net Change" * -1;

                    until GLAccount.Next = 0;
                end;



                LInterestonMemberDeposits := 0;
                GLAccount.Reset;
                GLAccount.SetFilter(GLAccount.CashFlowCategory, '%1', GLAccount.CashFlowCategory::MembersInterestPaid);

                //override

                if (LStartDate < DMY2DATE(1, 1, 2024)) then
                    LInterestonMemberDeposits := 9890000 * -1
                else if (LStartDate < DMY2DATE(1, 1, 2024)) then
                    LInterestonMemberDeposits := 9600000 * -1

                else if GLAccount.FindSet then begin
                    repeat


                        GLAccount.SetFilter("Date Filter", '%1..%2', ModLStartDate, LEndDate);
                        GLAccount.CalcFields("Net Change");

                        LInterestonMemberdeposits += GLAccount."Net Change" * -1;


                    until GLAccount.Next = 0;

                end;

                //payments to employees and suppliers

                PersonnelExpenses := 0;
                GLAccount.Reset;
                GLAccount.SetFilter(CashFlowCategory, '%1', GLAccount.CashFlowCategory::PaymentsToEmployeesAndSuppliers);


                if (StartDate < DMY2DATE(1, 1, 2025)) then begin
                    PersonnelExpenses := 4736592 * -1;
                end

                else if GLAccount.FindSet then begin
                    repeat

                        GLAccount.SetFilter("Date Filter", '%1..%2', ModStartDate, EndDate);
                        GLAccount.CalcFields("Net Change");

                        PersonnelExpenses += GLAccount."Net Change" * -1;
                    until GLAccount.Next = 0;
                end;


                LPersonnelExpenses := 0;
                GLAccount.Reset;
                GLAccount.SetFilter(GLAccount.CashFlowCategory, '%1', GLAccount.CashFlowCategory::PaymentsToEmployeesAndSuppliers);

                if (LStartDate < DMY2DATE(1, 1, 2024)) then
                    LPersonnelExpenses := 3812802 * -1
                else if (LStartDate < DMY2DATE(1, 1, 2025)) then
                    LPersonnelExpenses := 4736592 * -1

                else if GLAccount.FindSet then begin
                    repeat

                        GLAccount.SetFilter("Date Filter", '%1..%2', ModLStartDate, LEndDate);
                        GLAccount.CalcFields("Net Change");

                        LPersonnelExpenses += GLAccount."Net Change" * -1;

                    until GLAccount.Next = 0;
                end;





                //trade and other recievables

                TradeAndOtherReceivables := 0;
                GLAccount.Reset;
                GLAccount.SetFilter(CashFlowCategory, '%1', GLAccount.CashFlowCategory::TradeAndOtherReceivables);


                if (StartDate < DMY2DATE(1, 1, 2025)) then begin
                    TradeAndOtherReceivables := 414376 * -1;
                end

                else if GLAccount.FindSet then begin
                    repeat

                        GLAccount.SetFilter("Date Filter", '%1..%2', ModStartDate, EndDate);
                        GLAccount.CalcFields("Net Change");

                        TradeAndOtherReceivables += GLAccount."Net Change" * -1;


                    until GLAccount.Next = 0;
                end;


                LTradeAndOtherReceivables := 0;
                GLAccount.Reset;
                GLAccount.SetFilter(GLAccount.CashFlowCategory, '%1', GLAccount.CashFlowCategory::TradeAndOtherReceivables);

                if (LStartDate < DMY2DATE(1, 1, 2024)) then
                    LTradeAndOtherReceivables := 64393
                else if (LStartDate < DMY2DATE(1, 1, 2025)) then
                    LTradeAndOtherReceivables := 414376 * -1

                else if GLAccount.FindSet then begin
                    repeat

                        GLAccount.SetFilter("Date Filter", '%1..%2', ModLStartDate, LEndDate);
                        GLAccount.CalcFields("Net Change");

                        LTradeAndOtherReceivables += GLAccount."Net Change" * -1;

                    until GLAccount.Next = 0;
                end;


                //MembersDeposits

                MemberDeposits := 0;
                GLAccount.Reset;
                GLAccount.SetFilter(CashFlowCategory, '%1', GLAccount.CashFlowCategory::MembersDeposit);


                if (StartDate < DMY2DATE(1, 1, 2025)) then begin
                    MemberDeposits := 14928450;
                end

                else if GLAccount.FindSet then begin
                    repeat


                        GLAccount.SetFilter("Date Filter", '%1..%2', ModStartDate, EndDate);
                        GLAccount.CalcFields("Net Change");

                        MemberDeposits += GLAccount."Net Change" * -1;

                    until GLAccount.Next = 0;
                end;



                LMemberDeposits := 0;
                GLAccount.Reset;
                GLAccount.SetFilter(GLAccount.CashFlowCategory, '%1', GLAccount.CashFlowCategory::MembersDeposit);


                if (LStartDate < DMY2DATE(1, 1, 2024)) then
                    LMemberDeposits := 7546756
                else if (LStartDate < DMY2DATE(1, 1, 2025)) then
                    LMemberDeposits := 14928450

                else if GLAccount.FindSet then begin
                    repeat

                        GLAccount.SetFilter("Date Filter", '%1..%2', ModLStartDate, EndDate);
                        GLAccount.CalcFields("Net Change");

                        LMemberDeposits += GLAccount."Net Change" * -1;

                    until GLAccount.Next = 0;
                end;

                // End Member deposits

                //payable and accruals
                PayablesAndAccruals := 0;
                GLAccount.Reset;
                GLAccount.SetFilter(CashFlowCategory, '%1', GLAccount.CashFlowCategory::PayablesAndAccruals);

                if (StartDate < DMY2DATE(1, 1, 2025)) then begin
                    PayablesAndAccruals := 6466 * -1;
                end

                else if GLAccount.FindSet then begin
                    repeat

                        GLAccount.SetFilter("Date Filter", '%1..%2', ModStartDate, EndDate);
                        GLAccount.CalcFields("Net Change");

                        PayablesAndAccruals += GLAccount."Net Change" * -1;

                    until GLAccount.Next = 0;
                end;


                LPayablesAndAccruals := 0;
                GLAccount.Reset;
                GLAccount.SetFilter(GLAccount.CashFlowCategory, '%1', GLAccount.CashFlowCategory::PayablesAndAccruals);


                if (LStartDate < DMY2DATE(1, 1, 2024)) then
                    LPayablesAndAccruals := 315846
                else if (LStartDate < DMY2DATE(1, 1, 2025)) then
                    LPayablesAndAccruals := 6466 * -1

                else if GLAccount.FindSet then begin
                    repeat

                        GLAccount.SetFilter("Date Filter", '%1..%2', ModLStartDate, LEndDate);
                        GLAccount.CalcFields("Net Change");

                        LPayablesAndAccruals += GLAccount."Net Change" * -1;
                    until GLAccount.Next = 0;

                end;


                //end of payable and accruals


                //repayments of borrowings 
                RepaymentOfBorrowings := 0;
                GLAccount.Reset;
                GLAccount.SetFilter(CashFlowCategory, '%1', GLAccount.CashFlowCategory::RepaymentOfBorrowings);


                if (StartDate < DMY2DATE(1, 1, 2025)) then begin
                    RepaymentOfBorrowings := 1776435 * -1;
                end

                else if GLAccount.FindSet then begin
                    repeat

                        GLAccount.SetFilter("Date Filter", '%1..%2', ModStartDate, EndDate);
                        GLAccount.CalcFields("Net Change");

                        RepaymentOfBorrowings += GLAccount."Net Change" * -1;

                    until GLAccount.Next = 0;
                end;


                LRepaymentOfBorrowings := 0;
                GLAccount.Reset;
                GLAccount.SetFilter(GLAccount.CashFlowCategory, '%1', GLAccount.CashFlowCategory::RepaymentOfBorrowings);



                if (LStartDate < DMY2DATE(1, 1, 2024)) then
                    LRepaymentOfBorrowings := 438767 * -1
                else if (LStartDate < DMY2DATE(1, 1, 2025)) then
                    LRepaymentOfBorrowings := 1776435 * -1

                else if GLAccount.FindSet then begin
                    repeat

                        GLAccount.SetFilter("Date Filter", '%1..%2', ModLStartDate, LEndDate);
                        GLAccount.CalcFields("Net Change");

                        LRepaymentOfBorrowings += GLAccount."Net Change" * -1;

                    until GLAccount.Next = 0;

                end;


                //end of repayments of borrowings
                //Start of TaxPayable

                TaxPayable := 0;
                GLAccount.Reset;
                GLAccount.SetFilter(CashFlowCategory, '%1', GLAccount.CashFlowCategory::TaxPayable);


                if (StartDate < DMY2DATE(1, 1, 2025)) then begin
                    TaxPayable := 6885;
                end

                else if GLAccount.FindSet then begin
                    repeat

                        GLAccount.SetFilter("Date Filter", '%1..%2', ModStartDate, EndDate);
                        GLAccount.CalcFields("Net Change");

                        TaxPayable += GLAccount."Net Change" * -1;

                    until GLAccount.Next = 0;
                end;



                LTaxPayable := 0;
                GLAccount.Reset;
                GLAccount.SetFilter(GLAccount.CashFlowCategory, '%1', GLAccount.CashFlowCategory::TaxPayable);

                if (LStartDate < DMY2DATE(1, 1, 2024)) then
                    LTaxPayable := 4038
                else if (LStartDate < DMY2DATE(1, 1, 2025)) then
                    LTaxPayable := 6885

                else if GLAccount.FindSet then begin
                    repeat

                        GLAccount.SetFilter("Date Filter", '%1..%2', ModLStartDate, LEndDate);
                        GLAccount.CalcFields("Net Change");

                        LTaxPayable += GLAccount."Net Change" * -1;

                    until GLAccount.Next = 0;
                end;

                //END OF TAXPAYABLE


                TaxPaid := 0;
                GLAccount.Reset;
                GLAccount.SetFilter(CashFlowCategory, '%1', GLAccount.CashFlowCategory::TaxPaid);


                if (StartDate < DMY2DATE(1, 1, 2025)) then begin
                    TaxPaid := 0;
                end

                else if GLAccount.FindSet then begin
                    repeat
                        GLAccount.SetFilter("Date Filter", '%1..%2', ModStartDate, EndDate);
                        GLAccount.CalcFields("Net Change");

                        TaxPaid += GLAccount."Net Change" * -1;

                    until GLAccount.Next = 0;
                end;



                LTaxPaid := 0;
                GLAccount.Reset;
                GLAccount.SetFilter(GLAccount.CashFlowCategory, '%1', GLAccount.CashFlowCategory::TaxPaid);

                if ((LStartDate < DMY2DATE(1, 1, 2024)) and (LStartDate > DMY2DATE(31, 12, 2023))) then
                    LTaxPaid := 0
                else if (LStartDate < DMY2DATE(1, 1, 2025)) then
                    LTaxPaid := 0
                else if GLAccount.FindSet then begin
                    repeat
                        GLAccount.SetFilter("Date Filter", '%1..%2', ModLStartDate, LEndDate);
                        GLAccount.CalcFields("Net Change");

                        LTaxPaid += GLAccount."Net Change" * -1;

                    until GLAccount.Next = 0;

                end;

                //END OF TAXPAID

                LoanAdvances := 0;
                GLAccount.Reset;
                GLAccount.SetFilter(CashFlowCategory, '%1', GLAccount.CashFlowCategory::LoanAdvances);


                if (StartDate < DMY2DATE(1, 1, 2025)) then begin
                    LoanAdvances := 14452231 * -1;
                end

                else if GLAccount.FindSet then begin
                    repeat

                        GLAccount.SetFilter("Date Filter", '%1..%2', ModStartDate, EndDate);
                        GLAccount.CalcFields("Net Change");

                        LoanAdvances += GLAccount."Net Change" * -1;

                    until GLAccount.Next = 0;
                end;



                LLoanAdvances := 0;
                GLAccount.Reset;
                GLAccount.SetFilter(GLAccount.CashFlowCategory, '%1', GLAccount.CashFlowCategory::LoanAdvances);


                if (LStartDate < DMY2DATE(1, 1, 2024)) then
                    LLoanAdvances := 11874947 * -1
                else if (LEndDate < DMY2DATE(1, 1, 2025)) then
                    LLoanAdvances := 14452231 * -1

                else if GLAccount.FindSet then begin
                    repeat

                        GLAccount.SetFilter("Date Filter", '%1..%2', ModLStartDate, LEndDate);
                        GLAccount.CalcFields("Net Change");

                        LLoanAdvances += GLAccount."Net Change" * -1;
                    until GLAccount.Next = 0;

                end;


                // end of loan advances


                // Purchase of Assets

                PurchaseOfAssets := 0;
                GLAccount.Reset;
                GLAccount.SetFilter(CashFlowCategory, '%1', GLAccount.CashFlowCategory::PurchaseOfAssets);


                if (StartDate < DMY2DATE(1, 1, 2025)) then begin
                    PurchaseOfAssets := 187920 * -1;
                end

                else if GLAccount.FindSet then begin
                    repeat
                        GLAccount.SetFilter("Date Filter", '%1..%2', ModStartDate, EndDate);
                        GLAccount.CalcFields("Net Change");

                        PurchaseOfAssets += GLAccount."Net Change" * -1;
                    until GLAccount.Next = 0;
                end;


                LPurchaseOfAssets := 0;
                GLAccount.Reset;
                GLAccount.SetFilter(GLAccount.CashFlowCategory, '%1', GLAccount.CashFlowCategory::PurchaseOfAssets);

                if (LStartDate < DMY2DATE(1, 1, 2024)) then
                    LPurchaseOfAssets := 13500 * -1
                else if (LStartDate < DMY2DATE(1, 1, 2025)) then
                    LPurchaseOfAssets := 187920 * -1

                else if GLAccount.FindSet then begin
                    repeat

                        GLAccount.SetFilter("Date Filter", '%1..%2', ModLStartDate, LEndDate);
                        GLAccount.CalcFields("Net Change");

                        LPurchaseOfAssets += GLAccount."Net Change" * -1;
                    until GLAccount.Next = 0;
                end;

                // end of purchase of assets


                // Purchase of Investments

                PurchaseOfInvestments := 0;
                GLAccount.Reset;
                GLAccount.SetFilter(CashFlowCategory, '%1', GLAccount.CashFlowCategory::PurchaseOfInvestments);


                if (StartDate < DMY2DATE(1, 1, 2025)) then begin
                    PurchaseOfInvestments := 320032 * -1;
                end

                else if GLAccount.FindSet then begin
                    repeat

                        GLAccount.SetFilter("Date Filter", '%1..%2', ModStartDate, EndDate);
                        GLAccount.CalcFields("Net Change");

                        PurchaseOfInvestments += GLAccount."Net Change" * -1;

                    until GLAccount.Next = 0;
                end;



                LPurchaseOfInvestments := 0;
                GLAccount.Reset;
                GLAccount.SetFilter(GLAccount.CashFlowCategory, '%1', GLAccount.CashFlowCategory::PurchaseOfInvestments);

                if (LStartDate < DMY2DATE(1, 1, 2024)) then
                    LPurchaseOfInvestments := 199929 * -1
                else if (LStartDate < DMY2DATE(1, 1, 2025)) then
                    LPurchaseOfInvestments := 320032 * -1
                else if GLAccount.FindSet then begin
                    repeat

                        GLAccount.SetFilter("Date Filter", '%1..%2', ModLStartDate, LEndDate);
                        GLAccount.CalcFields("Net Change");

                        LPurchaseOfInvestments += GLAccount."Net Change" * -1;

                    until GLAccount.Next = 0;
                end;



                // start of sharecap 
                ShareCapital := 0;
                GLAccount.Reset;
                GLAccount.SetFilter(CashFlowCategory, '%1', GLAccount.CashFlowCategory::ShareCapitalContribution);


                if (StartDate < DMY2DATE(1, 1, 2025)) then begin
                    ShareCapital := 669000;
                end

                else if GLAccount.FindSet then begin
                    repeat
                        GLAccount.SetFilter("Date Filter", '%1..%2', ModStartDate, EndDate);
                        GLAccount.CalcFields("Net Change");

                        ShareCapital += GLAccount."Net Change" * -1;

                    until GLAccount.Next = 0;
                end;



                LShareCapital := 0;
                GLAccount.Reset;
                GLAccount.SetFilter(GLAccount.CashFlowCategory, '%1', GLAccount.CashFlowCategory::ShareCapitalContribution);

                if (LStartDate < DMY2DATE(1, 1, 2024)) then
                    LShareCapital := 105000
                else if (LStartDate < DMY2DATE(1, 1, 2025)) then
                    LShareCapital := 669000
                else if GLAccount.FindSet then begin
                    repeat

                        GLAccount.SetFilter("Date Filter", '%1..%2', ModLStartDate, LEndDate);
                        GLAccount.CalcFields("Net Change");

                        LShareCapital += GLAccount."Net Change" * -1;

                    until GLAccount.Next = 0;
                end;






                //start of year cash equivalents

                Cashatbank := 0;
                GLAccount.Reset;
                GLAccount.SetFilter(GLAccount.CashFlowCategory, '%1', GLAccount.CashFlowCategory::CashAndEquivalents);

                // if (StartDate = DMY2Date(1, 1, 2025)) then
                //     Cashatbank := 1645189

                if ((StartDate > DMY2DATE(31, 12, 2023)) and (EndDate < DMY2Date(1, 1, 2025))) then
                    Cashatbank := 3228208



                else if GLAccount.FindSet then begin
                    repeat

                        GLAccount.SetFilter("Date Filter", '..%1', StartDate);

                        GLAccount.CalcFields("Balance at Date");

                        Cashatbank += GLAccount."Balance at Date";
                    //GLEntry.Reset;
                    //GLEntry.SetRange(GLEntry."G/L Account No.", GLAccount."No.");

                    //GLEntry.SetFilter(GLEntry."Posting Date", '..%1', StartDate);

                    // GLEntry.CalcSums(Amount);
                    //GLEntry.CalcSums("Credit Amount", "Debit Amount");

                    //Cashatbank += (GLEntry."Debit Amount" - GLEntry."Credit Amount");

                    until GLAccount.Next = 0;

                end;

                LCashatbank := 0;
                GLAccount.Reset;
                GLAccount.SetFilter(GLAccount.CashFlowCategory, '%1', GLAccount.CashFlowCategory::CashAndEquivalents);

                if (LStartDate < DMY2DATE(1, 1, 2024)) then
                    LCashatbank := 7785852
                else

                    if ((LStartDate < DMY2Date(1, 1, 2025)) and (LstartDate > DMY2Date(31, 12, 2023))) then
                        LCashatbank := 3228208

                    else if GLAccount.FindSet then begin
                        repeat

                            GLAccount.SetFilter("Date Filter", '..%1', LStartDate);
                            GLAccount.CalcFields("Balance at Date");
                            LCashatbank += GLAccount."Balance at Date";
                        // GLEntry.Reset;
                        // GLEntry.SetRange(GLEntry."G/L Account No.", GLAccount."No.");
                        // GLEntry.SetFilter(GLEntry."Posting Date", '..%1', LStartDate);

                        // // GLEntry.CalcSums(Amount);
                        // GLEntry.CalcSums("Credit Amount", "Debit Amount");

                        // LCashatbank += (GLEntry."Debit Amount" - GLEntry."Credit Amount");

                        until GLAccount.Next = 0;
                    end;


                //End of year cash and Equivalents

                EndCashatbank := 0;
                GLAccount.Reset;
                GLAccount.SetFilter(GLAccount.CashFlowCategory, '%1', GLAccount.CashFlowCategory::CashAndEquivalents);

                if ((EndDate < DMY2DATE(1, 1, 2025)) AND (EndDate > DMY2Date(31, 12, 2023))) then
                    endCashatbank := 1645189

                else if (EndDate < DMY2Date(1, 1, 2024)) then
                    endCashatbank := 3228208

                else if GLAccount.FindSet then begin
                    repeat
                        // GLEntry.Reset;
                        // GLEntry.SetRange(GLEntry."G/L Account No.", GLAccount."No.");
                        // GLEntry.SetFilter(GLEntry."Posting Date", '..%1', EndDate);

                        // //GLEntry.CalcSums(Amount);
                        // GLEntry.CalcSums("Credit Amount", "Debit Amount");

                        // endCashatbank += (GLEntry."Debit Amount" - GLEntry."Credit Amount");

                        GLAccount.SetFilter("Date Filter", '..%1', EndDate);
                        GLAccount.CalcFields("Balance at Date");
                        endCashatbank += GLAccount."Balance at Date";

                    until GLAccount.Next = 0;
                end;

                EndLCashatbank := 0;
                GLAccount.Reset;
                GLAccount.SetFilter(GLAccount.CashFlowCategory, '%1', GLAccount.CashFlowCategory::CashAndEquivalents);

                if (LEndDate < DMY2DATE(1, 1, 2024)) then begin
                    EndLCashatbank := 3228208;
                end

                else if GLAccount.FindSet then begin
                    repeat
                        // GLEntry.Reset;
                        // GLEntry.SetRange(GLEntry."G/L Account No.", GLAccount."No.");
                        // GLEntry.SetFilter(GLEntry."Posting Date", '..%1', LEndDate);

                        // GLEntry.CalcSums("Credit Amount", "Debit Amount");
                        // EndLCashatbank += (GLEntry."Debit Amount" - GLEntry."Credit Amount");
                        GLAccount.SetFilter("Date Filter", '..%1', LEndDate);
                        GLAccount.CalcFields("Balance at Date");
                        EndLCashatbank += GLAccount."Balance at Date";
                    until GLAccount.Next = 0;
                end;

            END;
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

        ModStartDate: Date;

        ModLStartDate: Date;


}