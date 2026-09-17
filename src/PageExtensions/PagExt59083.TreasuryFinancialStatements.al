pageextension 59083 "Treasury Financial Statements" extends "Finance Role Center"
{
    actions
    {
        // Matches the main SACCO Financial Statements menu; enabled by the treasury profile.
        addafter("Finance Statements")
        {
            group(TreasuryFinancialStatements)
            {
                Caption = 'Financial Statements';
                ToolTip = 'Display Financial Statements.';
                Visible = false;

                action("Treasury KRB Trial Balance")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Trial Balance';
                    RunObject = report "Trial Balance2025";
                    ToolTip = 'Generate Trial Balance for a given period.';
                }

                action("Treasury Detail Trial Balance")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Detail Trial Balance';
                    RunObject = report "Detail Trial Balance";
                    ToolTip = 'Generate Detail Trial Balance for a given period';
                }

                action("Treasury Account Schedules")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Account Schedules';
                    Visible = false;
                    RunObject = page "Financial Reports";

                }



                action("Treasury LiquidityReport")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Liquidity Report';
                    Image = Journal;
                    RunObject = report Liquidity;
                    ToolTip = 'Generate Liquidity Report for a given period.';
                    Visible = false;
                }

                action("Treasury KRB Balance Sheet")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'KRB Financial Position';
                    RunObject = report "KRBFinancialPosition";
                }

                action("Treasury KRB Balance Sheet 2")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = true;
                    Caption = 'KRB Financial Position 2';
                    RunObject = report KRBFinancialPosition2;
                }

                action("Treasury KRB Profit & Loss")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Statement of Comprehensive Income';
                    RunObject = report "KRBProfitAndLoss";
                }


                action("Treasury KRB Profit & Loss 2")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                    Caption = 'Statement of Comprehensive Income 2';
                    RunObject = report "KRBProfitAndLoss2";
                }




                action("Treasury KRB Statement OF Cash Flows")
                {
                    ApplicationArea = All;
                    Caption = 'Statement of Cashflows';
                    RunObject = report cashFlows;
                }


                action("Treasury KRB Bank Rec Summary")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Bank Reconcilliation Summary';
                    RunObject = report "BankReconciliationsummary";
                }

                action("Treasury KRB Account Activity")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'KRB Account Activity';
                    RunObject = report "KRBAccountActivity";
                }


                action("Treasury Member Savings Report")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Member Savings Report';
                    RunObject = report "Member Savings Report";
                }
            }
        }
    }
}
