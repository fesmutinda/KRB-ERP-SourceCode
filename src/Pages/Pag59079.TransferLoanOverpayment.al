page 59079 "Transfer Loan Overpayment"
{
    Caption = 'Transfer Loan Overpayment';
    PageType = StandardDialog;

    layout
    {
        area(Content)
        {
            group(Source)
            {
                Caption = 'Overpaid Loan';
                field(SourceLoanNo; SourceLoanNo) { ApplicationArea = All; Caption = 'Loan No.'; Editable = false; }
                field(MemberNo; MemberNo) { ApplicationArea = All; Caption = 'Member No.'; Editable = false; }
                field(Excess; Excess) { ApplicationArea = All; Caption = 'Overpaid Amount'; Editable = false; }
            }
            group(Transfer)
            {
                field(PostingDate; PostingDate) { ApplicationArea = All; Caption = 'Posting Date'; }
                field(Destination; Destination)
                {
                    ApplicationArea = All;
                    Caption = 'Transfer To';
                    ToolTip = 'Transfer the excess to another loan held by this member, or to the member deposit contributions.';
                    trigger OnValidate()
                    begin
                        Clear(TargetLoanNo);
                        UpdateAmounts();
                    end;
                }
                field(TargetLoanNo; TargetLoanNo)
                {
                    ApplicationArea = All;
                    Caption = 'Destination Loan No.';
                    Enabled = Destination = Destination::Loan;
                    ToolTip = 'Select an outstanding loan belonging to the same member.';
                    trigger OnLookup(var Text: Text): Boolean
                    var
                        Loan: Record "Loans Register";
                    begin
                        Loan.SetRange("Client Code", MemberNo);
                        Loan.SetFilter("Loan  No.", '<>%1', SourceLoanNo);
                        if Page.RunModal(Page::"Overpayment Target Loans", Loan) = Action::LookupOK then begin
                            TargetLoanNo := Loan."Loan  No.";
                            UpdateAmounts();
                            Text := TargetLoanNo;
                            exit(true);
                        end;
                        exit(false);
                    end;
                    trigger OnValidate()
                    begin
                        UpdateAmounts();
                    end;
                }
                field(DepositRemainder; DepositRemainder)
                {
                    ApplicationArea = All;
                    Caption = 'Transfer Remainder to Deposits';
                    Enabled = Destination = Destination::Loan;
                    ToolTip = 'If the excess exceeds the destination loan balance, pay off that loan and transfer the rest to this member deposits.';
                    trigger OnValidate()
                    begin
                        UpdateAmounts();
                    end;
                }
                field(LoanAmount; LoanAmount) { ApplicationArea = All; Caption = 'Amount to Loan'; Editable = false; }
                field(DepositAmount; DepositAmount) { ApplicationArea = All; Caption = 'Amount to Deposits'; Editable = false; }
            }
        }
    }

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    var
        TransferMgt: Codeunit "Loan Overpayment Transfer";
        DocumentNo: Code[20];
    begin
        if CloseAction <> Action::OK then
            exit(true);
        if (Destination = Destination::Loan) and (TargetLoanNo = '') then
            Error('Select the destination loan.');
        if PostingDate = 0D then
            Error('Specify a posting date.');
        if not Confirm('Post overpayment transfer for member %1 on %2?\Clear loan %3 by %4.\Credit loan %5 by %6.\Credit deposits by %7.', false,
            MemberNo, PostingDate, SourceLoanNo, Excess, TargetLoanNo, LoanAmount, DepositAmount) then
            exit(false);
        DocumentNo := TransferMgt.PostTransfer(SourceLoanNo, TargetLoanNo, Destination = Destination::Deposits, DepositRemainder, PostingDate, Excess, LoanAmount, DepositAmount);
        Message('Overpayment transfer %1 posted. Loan %2 now has a zero balance.', DocumentNo, SourceLoanNo);
        exit(true);
    end;

    procedure SetLoan(LoanNo: Code[20])
    var
        Loan: Record "Loans Register";
    begin
        Loan.Get(LoanNo);
        Loan.TestField(Posted, true);
        Loan.TestField(Reversed, false);
        Loan.CalcFields("Outstanding Balance");
        SourceLoanNo := LoanNo;
        MemberNo := Loan."Client Code";
        Excess := -Loan."Outstanding Balance";
        if Excess <= 0 then
            Error('This loan no longer has an overpayment.');
        PostingDate := WorkDate();
        DepositRemainder := true;
    end;

    local procedure UpdateAmounts()
    var
        TransferMgt: Codeunit "Loan Overpayment Transfer";
    begin
        Clear(LoanAmount);
        Clear(DepositAmount);
        if (Destination = Destination::Loan) and (TargetLoanNo = '') then
            exit;
        TransferMgt.GetAmounts(SourceLoanNo, TargetLoanNo, Destination = Destination::Deposits, DepositRemainder, Excess, LoanAmount, DepositAmount);
    end;

    var
        SourceLoanNo: Code[20];
        MemberNo: Code[20];
        TargetLoanNo: Code[20];
        Destination: Option Loan,Deposits;
        DepositRemainder: Boolean;
        PostingDate: Date;
        Excess: Decimal;
        LoanAmount: Decimal;
        DepositAmount: Decimal;
}
