report 50209 "BankReconciliationSummary"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    Caption = 'Bank Account Reconciliation Summary';

    RDLCLayout = './Layouts/BankRecsummary.rdlc';

    dataset
    {
        dataitem("Bank Account Statement"; "Bank Account Statement")
        {
            column(StatementNo; "Statement No.") { }
            column(BankAccountNo; "Bank Account No.") { }
            column(StatementDate; "Statement Date") { }

            column(StatementDateFormatted; Format("Statement Date", 0, 4)) { }

            column(BalanceLastStatement; "Balance Last Statement") { }
            column(StatementEndingBalance; "Statement Ending Balance") { }

            column(BalanceBroughtForward; BalanceBroughtForward) { }
            column(BalanceCarriedForward; BalanceCarriedForward) { }

            column(TotalDebits; TotalDebits) { }
            column(TotalCredits; TotalCredits) { }

            column(TotalDifference; TotalDifference) { }

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

            column(ReconStartDate; ReconStartDate)
            {
            }


            trigger OnAfterGetRecord()
            var
                BankAccountLedgerEntry: Record "Bank Account Ledger Entry";
                StartDate: Date;
                EndDate: Date;
            begin

                //StartDate := CalcDate('-1M', "Statement Date"); // One month ago
                StartDate := DMY2Date(1, Date2DMY("Statement Date", 2), Date2DMY("Statement Date", 3));

                ReconStartDate := Format(StartDate, 0, 4);
                EndDate := "Statement Date";

                // Reset totals for each statement
                BalanceBroughtForward := 0;
                BalanceCarriedForward := 0;
                TotalDebits := 0;
                TotalCredits := 0;
                TotalDifference := 0;

                // Get Balance B/F (Opening Balance before period start)
                if "Balance Last Statement" <> 0 then begin

                    BalanceBroughtForward := "Balance Last Statement"

                end else begin

                    BankAccountLedgerEntry.SetRange("Bank Account No.", "Bank Account No.");
                    BankAccountLedgerEntry.SetFilter("Posting Date", '<%1', StartDate);
                    if BankAccountLedgerEntry.FindSet() then
                        repeat
                            BalanceBroughtForward += BankAccountLedgerEntry.Amount;
                        until BankAccountLedgerEntry.Next() = 0;

                end;


                // Calculate Debits, Credits & Balance for the period
                BankAccountLedgerEntry.SetRange("Bank Account No.", "Bank Account No.");
                BankAccountLedgerEntry.SetRange("Posting Date", StartDate, EndDate);
                if BankAccountLedgerEntry.FindSet() then
                    repeat
                        if BankAccountLedgerEntry.Amount > 0 then
                            TotalDebits += BankAccountLedgerEntry.Amount // Deposits
                        else
                            TotalCredits += Abs(BankAccountLedgerEntry.Amount); // Withdrawals

                        BalanceCarriedForward += BankAccountLedgerEntry.Amount; // Update closing balance

                    until BankAccountLedgerEntry.Next() = 0;


                // Final Balance C/F
                BalanceCarriedForward += BalanceBroughtForward;

                StatementEndingBalance := 0;
                if "Bank Account Statement"."Statement Ending Balance" <> 0 then
                    StatementEndingBalance := "Bank Account Statement"."Statement Ending Balance";

                // Calculate TotalDifference
                TotalDifference := BalanceCarriedForward - StatementEndingBalance;


            end;


        }
    }

    trigger OnPreReport()
    begin
        Company.Get();
        Company.CalcFields(Company.Picture);
    end;

    var

        BalanceBroughtForward: Decimal;
        BalanceCarriedForward: Decimal;
        TotalDebits: Decimal;
        TotalCredits: Decimal;
        TotalDifference: Decimal;

        StatementEndingBalance: Decimal;

        Company: Record "Company Information";

        ReconStartDate: Text;
}
