page 59078 "Overpaid Loans"
{
    ApplicationArea = All;
    Caption = 'Overpaid Loans';
    PageType = List;
    UsageCategory = Lists;
    SourceTable = "Loans Register";
    SourceTableView = sorting("Loan  No.") where(Posted = const(true), Reversed = const(false), "Outstanding Balance" = filter('<0'));
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(Loans)
            {
                field("Loan No."; Rec."Loan  No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the overpaid loan number.';
                }
                field("Member No."; Rec."Client Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the member who holds the loan.';
                }
                field("Member Name"; Rec."Client Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the member name.';
                }
                field("Loan Product Type"; Rec."Loan Product Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the loan product code.';
                }
                field("Loan Product Name"; Rec."Loan Product Type Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the loan product name.';
                }
                field("Issued Date"; Rec."Issued Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies when the loan was issued.';
                }
                field("Approved Amount"; Rec."Approved Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the approved loan amount.';
                }
                field("Outstanding Balance"; Rec."Outstanding Balance")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the negative loan balance after repayments, interest, and charges, excluding reversed entries.';
                }
                field("Overpaid Amount"; OverpaidAmount)
                {
                    ApplicationArea = All;
                    DecimalPlaces = 2 : 2;
                    ToolTip = 'Specifies the excess payment as a positive amount, equal to the negative outstanding balance multiplied by -1.';
                }
                field("Last Pay Date"; Rec."Last Pay Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the last payment date for the loan.';
                }
                field("Branch Code"; Rec."Branch Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the branch for the loan.';
                }
                field(Source; Rec.Source)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the source of the loan.';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(TransferCustomerOverpayments)
            {
                ApplicationArea = All;
                Caption = 'Transfer Customer Overpayments';
                Image = TransferFunds;
                ToolTip = 'Combine all overpaid loans for this member and transfer the total to an outstanding loan, deposits, or share capital. Includes loans hidden by list filters.';

                trigger OnAction()
                var
                    TransferDialog: Page "Transfer Loan Overpayment";
                begin
                    TransferDialog.SetMember(Rec."Client Code");
                    TransferDialog.RunModal();
                    CurrPage.Update(false);
                end;
            }

            action(TransferOverpayment)
            {
                ApplicationArea = All;
                Caption = 'Transfer Overpayment';
                Image = TransferFunds;
                ToolTip = 'Clear the excess loan balance by transferring it to another outstanding loan, deposits, or share capital belonging to the same member.';

                trigger OnAction()
                var
                    TransferDialog: Page "Transfer Loan Overpayment";
                begin
                    TransferDialog.SetLoan(Rec."Loan  No.");
                    TransferDialog.RunModal();
                    CurrPage.Update(false);
                end;
            }
        }
        area(Navigation)
        {
            action(LedgerEntries)
            {
                ApplicationArea = All;
                Caption = 'Loan Ledger Entries';
                Image = Ledger;
                RunObject = page "Member Ledger Entries";
                RunPageLink = "Customer No." = field("Client Code"), "Loan No" = field("Loan  No."), Reversed = const(false);
                ToolTip = 'View the non-reversed ledger entries for the selected loan to investigate the overpayment.';
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        Rec.CalcFields("Outstanding Balance");
        OverpaidAmount := -Rec."Outstanding Balance";
    end;

    var
        OverpaidAmount: Decimal;
}
