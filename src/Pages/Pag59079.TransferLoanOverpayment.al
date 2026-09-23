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
                Caption = 'Overpayments';
                field(SourceLoanNo; SourceLoanNo)
                {
                    ApplicationArea = All;
                    Caption = 'Loan No.';
                    Editable = false;
                    Visible = not Cumulative;
                }
                field(MemberNo; MemberNo) { ApplicationArea = All; Caption = 'Member No.'; Editable = false; }
                field(MemberName; MemberName) { ApplicationArea = All; Caption = 'Member Name'; Editable = false; }
                field(SourceCount; SourceCount)
                {
                    ApplicationArea = All;
                    Caption = 'Overpaid Loans Included';
                    Editable = false;
                    ToolTip = 'The number of overpaid loans included. Customer transfers include all posted, non-reversed overpaid loans for this member, regardless of list filters.';
                }
                field(Excess; Excess) { ApplicationArea = All; Caption = 'Total Overpaid Amount'; Editable = false; }
            }
            group(Transfer)
            {
                field(PostingDate; PostingDate) { ApplicationArea = All; Caption = 'Posting Date'; }
                field(Destination; Destination)
                {
                    ApplicationArea = All;
                    Caption = 'Transfer To';
                    ToolTip = 'Transfer the excess to an outstanding loan, deposits, or share capital belonging to this member.';
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
                        if SourceLoanNo <> '' then
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
                    ToolTip = 'If the excess exceeds the destination loan balance, pay off that loan and transfer the remainder to this member deposits.';
                    trigger OnValidate()
                    begin
                        UpdateAmounts();
                    end;
                }
                field(LoanAmount; LoanAmount) { ApplicationArea = All; Caption = 'Amount to Loan'; Editable = false; }
                field(DepositAmount; DepositAmount) { ApplicationArea = All; Caption = 'Amount to Deposits'; Editable = false; }
                field(ShareAmount; ShareAmount) { ApplicationArea = All; Caption = 'Amount to Share Capital'; Editable = false; }
            }
        }
    }

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    var
        TransferMgt: Codeunit "Loan Overpayment Transfer";
        DocumentNo: Code[20];
        BatchLineCount: Integer;
        ConfirmationText: Text;
    begin
        if CloseAction <> Action::OK then
            exit(true);
        if (Destination = Destination::Loan) and (TargetLoanNo = '') then
            Error('Select the destination loan.');
        if PostingDate = 0D then
            Error('Specify a posting date.');
        BatchLineCount := TransferMgt.GetBatchLineCount();
        ConfirmationText := StrSubstNo('Post overpayment transfer for member %1 on %2?\Clear %3 overpaid loan(s), totalling %4.',
            MemberNo, PostingDate, SourceCount, Excess);
        if LoanAmount > 0 then
            ConfirmationText += StrSubstNo('\Credit loan %1 by %2.', TargetLoanNo, LoanAmount);
        if DepositAmount > 0 then
            ConfirmationText += StrSubstNo('\Credit deposits by %1.', DepositAmount);
        if ShareAmount > 0 then
            ConfirmationText += StrSubstNo('\Credit share capital by %1.', ShareAmount);
        ConfirmationText += StrSubstNo('\Delete %1 existing journal line(s) from GENERAL / DEFAULT before posting.', BatchLineCount);
        if not Confirm(ConfirmationText, false) then
            exit(false);
        DocumentNo := TransferMgt.PostSources(MemberNo, SourceLoanNo, Sources, TargetLoanNo, Destination, DepositRemainder,
            PostingDate, LoanAmount, DepositAmount, ShareAmount, BatchLineCount);
        Message('Overpayment transfer %1 posted. All %2 included source loans now have zero balances.', DocumentNo, SourceCount);
        exit(true);
    end;

    procedure SetLoan(LoanNo: Code[20])
    var
        Loan: Record "Loans Register";
    begin
        Loan.Get(LoanNo);
        InitializeTransfer(Loan."Client Code", LoanNo);
    end;

    procedure SetMember(CustomerNo: Code[20])
    begin
        InitializeTransfer(CustomerNo, '');
    end;

    local procedure InitializeTransfer(CustomerNo: Code[20]; LoanNo: Code[20])
    var
        TransferMgt: Codeunit "Loan Overpayment Transfer";
        Member: Record Customer;
    begin
        Member.Get(CustomerNo);
        MemberNo := CustomerNo;
        MemberName := Member.Name;
        SourceLoanNo := LoanNo;
        Cumulative := LoanNo = '';
        Excess := TransferMgt.CollectOverpayments(MemberNo, SourceLoanNo, Sources);
        SourceCount := Sources.Count();
        PostingDate := WorkDate();
        DepositRemainder := true;
        Destination := Destination::Loan;
        Clear(TargetLoanNo);
        UpdateAmounts();
    end;

    local procedure UpdateAmounts()
    var
        TransferMgt: Codeunit "Loan Overpayment Transfer";
    begin
        Clear(LoanAmount);
        Clear(DepositAmount);
        Clear(ShareAmount);
        if (Destination = Destination::Loan) and (TargetLoanNo = '') then
            exit;
        TransferMgt.GetDestinationAmounts(MemberNo, Sources, TargetLoanNo, Destination, DepositRemainder, LoanAmount, DepositAmount, ShareAmount);
    end;

    var
        SourceLoanNo: Code[20];
        MemberNo: Code[20];
        MemberName: Text[100];
        TargetLoanNo: Code[20];
        Destination: Enum "Overpayment Destination";
        Sources: Dictionary of [Code[20], Decimal];
        Cumulative: Boolean;
        SourceCount: Integer;
        DepositRemainder: Boolean;
        PostingDate: Date;
        Excess: Decimal;
        LoanAmount: Decimal;
        DepositAmount: Decimal;
        ShareAmount: Decimal;
}
