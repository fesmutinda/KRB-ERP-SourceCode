pageextension 59082 "Treasury Credit Management" extends "Finance Role Center"
{
    actions
    {
        // Mirrors the main SACCO Credit Management menu; enabled by the treasury profile.
        addafter(SaccoLoansManagement)
        {
            group(TreasuryCreditManagement)
            {
                Visible = false;
                Caption = 'Credit Management';
                ToolTip = 'Manage BOSA Loans Module';

                action(TreasuryOnlineLoanApplications)
                {
                    ApplicationArea = All;
                    Caption = 'Online Loan Applications';
                    Image = List;
                    RunObject = page "Online Loan Applications";
                    RunPageMode = Edit;
                    ToolTip = 'View and edit online loan applications.';
                }

                action(TreasuryOnlineGuarantorship)
                {
                    ApplicationArea = All;
                    Caption = 'Online Loan Guarantorship Requests';
                    Image = List;
                    RunObject = page "Online Guarantorship Requests";
                    RunPageMode = Edit;
                    ToolTip = 'View and edit all online loan guarantorship requests.';
                }

                group("Treasury BOSA Loans Management")

                {
                    Caption = 'New BOSA Loans Applications';
                    ToolTip = 'BOSA Loans'' Management Module';
                    action("Treasury BOSA Loan Application")
                    {
                        ApplicationArea = All;
                        Caption = 'BOSA Loan Application List';
                        Image = Loaners;
                        RunObject = Page "Loan List-New Application BOSA";
                        ToolTip = 'Open BOSA Loan Applications List';
                    }
                    action("Treasury Pending BOSA Loan Application")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'BOSA Loans Pending Approval';
                        Image = CreditCard;
                        RunObject = Page "LoanList-Pending Approval BOSA";
                        ToolTip = 'Open the list of BOSA Loans Pending Approval';
                    }
                    action("Treasury Approved Loans")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'BOSA Loans Pending Disbursement.';
                        RunObject = Page "Loan Application BOSA-Approved";
                        ToolTip = 'Open the list of Approved Loans Pending Disbursement.';
                    }

                    action("Treasury Bosa Loans Partially Disbursed")

                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'BOSA Loans Partially Disbursed.';
                        RunObject = Page BOSAPartialDisbursed;
                        ToolTip = 'Open the list of Partially Disbursed Loans';
                    }
                }

                group("Treasury Instant Loan")

                {
                    Caption = 'Instant Loan Management';
                    ToolTip = 'Instant Loans'' Management Module';
                    action("Treasury Instant Loan Application")
                    {
                        ApplicationArea = All;
                        Caption = 'Instant Loan Application List';
                        Image = Loaners;
                        RunObject = Page "Loan List Application Instant";
                        ToolTip = 'Open Instant Loan Applications List';
                        RunPageView = where(Posted = const(false), "Loan Status" = const(Application));
                    }
                    action("Treasury Instant BOSA Loan Application")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Instant Loans Pending Approval';
                        Image = CreditCard;
                        RunObject = Page "Loans-Pending Approval Instant";
                        ToolTip = 'Open the list of Instant Loans Pending Approval';
                    }
                    action("Treasury Approved Instant Loans")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Instant Loans Pending Disbursement.';
                        RunObject = Page "Instant Loans Applied-Approved";
                        ToolTip = 'Open the list of Approved Instant Loans Pending Disbursement.';
                    }
                }

                group("Treasury Loan Batching")

                {

                    Caption = 'Loan Batching';
                    Visible = FALSE;
                    action("Treasury Loan Batch List")
                    {
                        Caption = 'Loan Batch List';
                        ApplicationArea = Basic, Suite;
                        RunObject = page "Loans Disbursment Batch List";
                    }
                    action("Treasury Posted Loan Batch List")
                    {
                        Caption = 'Posted Loan Batch List';
                        ApplicationArea = Basic, Suite;
                        RunObject = page "Posted Loan Batch - List";
                    }
                }

                group("Treasury Loans Appeals")

                {
                    Visible = false;
                    Caption = 'Loan Restructure';
                    action("Treasury Loan Appeal List")
                    {
                        ApplicationArea = Basic, Suite;
                        RunObject = page "Loan Appeal List";
                        Caption = 'Loans Restructure List';
                    }
                    action("Treasury Loans Appealed Posted")
                    {
                        ApplicationArea = Basic, Suite;
                        RunObject = page "Loan Appeal List";
                        Caption = 'Loans Restructured List';
                    }
                }

                group("Treasury Insights")

                {
                    Visible = true;
                    Caption = 'Loan Analytics';


                    action("Treasury View Loan Performance Chart")


                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Interest Earned (Amount)';
                        Image = Chart;
                        RunObject = Page "Loan Performance Chart";
                        ToolTip = 'View loan performance analytics';
                    }

                    action("Treasury View Loans Applied Chart")

                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Loans Applied (Count)';
                        Image = Chart;
                        RunObject = Page "Loans Applied Chart";
                        ToolTip = 'View monthly loan application counts for the last 12 months, including the current month to date.';
                    }

                    action("Treasury View Loan Arrears Chart")

                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Loan Arrears (Count)';
                        Image = Chart;
                        RunObject = Page "Loan Arrears Chart";
                        ToolTip = 'View loan arrears analytics';
                    }
                }

                group("Treasury Loan Reschedule")

                {
                    Caption = 'Loan Reschedule';
                    action("Treasury Loan Reschedule List")
                    {
                        ApplicationArea = Basic, Suite;
                        RunObject = page "Loans Reschedule  List";
                        Caption = 'Loan Reschedule List';
                        Visible = true;
                    }
                    action("Treasury Approved Loan Reschedule")
                    {
                        ApplicationArea = Basic, Suite;
                        RunObject = page "Loans Reschedule  List";
                        Caption = 'Approved Loan Reschedule';
                        Visible = true;
                        RunPageView = where("Reschedule Approval Status" = const(Approved));
                    }
                }

                action("Treasury PostedLoans")

                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Posted BOSA Loans';
                    RunObject = Page "Loans Posted List";
                    ToolTip = 'Open the list of the Loans Posted.';
                }

                action("Treasury Overpaid Loans")

                {
                    ApplicationArea = All;
                    Caption = 'Overpaid Loans';
                    Image = List;
                    RunObject = page "Overpaid Loans";
                    ToolTip = 'View posted, non-reversed loans with a negative outstanding balance and the amount overpaid.';
                }

                action("Treasury All Loans")

                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'All Loans List';
                    RunObject = page "Loans  List All";

                }



                action("Treasury Loan Calculator")



                {



                    Caption = 'Loan Calculator';
                    RunObject = page "Loans Calculator List";
                }

                group("Treasury Loans Reports")

                {

                    Caption = 'Loans Reports';
                    action("Treasury Loans Balances Report")
                    {
                        ApplicationArea = all;
                        RunObject = Report "Loan Balances Report";
                        Caption = 'Member Loans Book Report';
                        ToolTip = 'Member Loans Book Report';
                        Visible = true;
                    }


                    action("Treasury Loan Collection Targets Report")


                    {
                        ApplicationArea = all;
                        RunObject = report "Loan Monthly Expectation";
                        ToolTip = 'Loan Collection Targets';
                        Caption = 'Loan Collection Targets';
                        Visible = false;
                    }

                    action("Treasury Loans Guard Report")

                    {

                        Caption = 'Loans Guard Report';
                        ApplicationArea = all;
                        RunObject = report "Loan Guard Report";
                        ToolTip = 'Loans Guard Report';
                        Visible = false;
                    }

                    action("Treasury Loan defaulter List")

                    {

                        Caption = 'Loan defaulter List';
                        ApplicationArea = all;
                        RunObject = report "Loan Defaulters List";
                    }

                    action("Treasury Loans Register")

                    {
                        ApplicationArea = all;
                        Caption = 'Member Loan Register';
                        RunObject = Report "Loans Register";
                        ToolTip = 'Loan Register Report';
                        Visible = false;
                    }

                    action("Treasury Loans Arrears Report")

                    {

                        Caption = 'Loans Arrears Report';
                        ApplicationArea = all;
                        RunObject = Report "Loan Arrears Report";
                        ToolTip = 'Loan Arreas Report';
                        Visible = false;
                    }

                    action("Treasury Loans Guarantor Details Report")

                    {

                        Caption = 'Loans Guarantor Details Report';
                        ApplicationArea = all;
                        RunObject = Report "Loans Guarantor Details Report";
                        ToolTip = 'Loans Securities Report';
                    }

                    action("Treasury Member Excess Loan Repayments Report")

                    {
                        ApplicationArea = all;
                        Caption = 'Member Excess Loan Repayments';
                        RunObject = report MemberExcessList2;
                        Visible = false;
                    }

                    action("Treasury Loan Defaulter Aging")

                    {
                        ApplicationArea = all;
                        Caption = 'Loans Defaulter Aging';
                        RunObject = report 51036;
                        visible = true;
                    }


                    action("Treasury Approved Loans Report")


                    {


                        Caption = 'Approved Loans Report';
                        ApplicationArea = all;
                        RunObject = report "Approved Loans List-Grouped";
                        Visible = true;
                    }
                }
            }
        }
    }
}
