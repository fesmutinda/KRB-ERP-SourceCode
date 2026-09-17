codeunit 59079 "Loan Overpayment Transfer"
{
    procedure GetAmounts(SourceLoanNo: Code[20]; TargetLoanNo: Code[20]; ToDeposits: Boolean; DepositRemainder: Boolean; var Excess: Decimal; var LoanAmount: Decimal; var DepositAmount: Decimal)
    var
        SourceLoan: Record "Loans Register";
        TargetLoan: Record "Loans Register";
        TargetBalance: Decimal;
    begin
        SourceLoan.Get(SourceLoanNo);
        SourceLoan.TestField(Posted, true);
        SourceLoan.TestField(Reversed, false);
        SourceLoan.TestField("Client Code");
        SourceLoan.CalcFields("Outstanding Balance");
        Excess := -SourceLoan."Outstanding Balance";
        if not ToDeposits then begin
            if SourceLoanNo = TargetLoanNo then
                Error('Choose a different destination loan.');
            TargetLoan.Get(TargetLoanNo);
            TargetLoan.TestField("Client Code", SourceLoan."Client Code");
            TargetLoan.TestField(Posted, true);
            TargetLoan.TestField(Reversed, false);
            TargetLoan.CalcFields("Outstanding Balance");
            TargetBalance := TargetLoan."Outstanding Balance";
        end;
        AllocateAmounts(Excess, TargetBalance, ToDeposits, DepositRemainder, LoanAmount, DepositAmount);
    end;

    procedure AllocateAmounts(Excess: Decimal; TargetBalance: Decimal; ToDeposits: Boolean; DepositRemainder: Boolean; var LoanAmount: Decimal; var DepositAmount: Decimal)
    begin
        LoanAmount := 0;
        DepositAmount := 0;
        if Excess <= 0 then
            Error('The source loan no longer has an overpayment. Refresh the Overpaid Loans list.');
        if ToDeposits then begin
            DepositAmount := Excess;
            exit;
        end;
        if TargetBalance <= 0 then
            Error('The destination loan must have a positive outstanding balance.');
        if (TargetBalance < Excess) and not DepositRemainder then
            Error('The excess exceeds the destination loan balance. Choose another loan or enable transfer of the remainder to deposits.');
        LoanAmount := Excess;
        if LoanAmount > TargetBalance then
            LoanAmount := TargetBalance;
        DepositAmount := Excess - LoanAmount;
    end;

    [CommitBehavior(CommitBehavior::Error)]
    procedure PostTransfer(SourceLoanNo: Code[20]; TargetLoanNo: Code[20]; ToDeposits: Boolean; DepositRemainder: Boolean; PostingDate: Date; ExpectedExcess: Decimal; ExpectedLoanAmount: Decimal; ExpectedDepositAmount: Decimal): Code[20]
    var
        SourceLoan: Record "Loans Register";
        TargetLoan: Record "Loans Register";
        Member: Record Customer;
        LedgerEntry: Record "Cust. Ledger Entry";
        Batch: Record "Gen. Journal Batch";
        Template: Record "Gen. Journal Template";
        JournalLine: Record "Gen. Journal Line";
        TransactionTypeSetup: Record "Transaction Types Table";
        PostBatch: Codeunit "Gen. Jnl.-Post Batch";
        Excess: Decimal;
        LoanAmount: Decimal;
        DepositAmount: Decimal;
        DepositsBefore: Decimal;
        TargetBalanceBefore: Decimal;
        DocumentNo: Code[20];
    begin
        if PostingDate = 0D then
            Error('Specify a posting date.');
        // Serialize with ledger posting before reading the balances used for this transfer.
        LedgerEntry.LockTable();
        if LedgerEntry.FindLast() then;
        SourceLoan.LockTable();
        GetAmounts(SourceLoanNo, TargetLoanNo, ToDeposits, DepositRemainder, Excess, LoanAmount, DepositAmount);
        if (Excess <> ExpectedExcess) or (LoanAmount <> ExpectedLoanAmount) or (DepositAmount <> ExpectedDepositAmount) then
            Error('The loan balances have changed. Reopen the transfer and review the updated amounts.');
        SourceLoan.Get(SourceLoanNo);
        Member.Get(SourceLoan."Client Code");
        Member.TestField(Blocked, Member.Blocked::" ");
        Member.TestField("Currency Code", '');
        CheckLoanForPosting(SourceLoan);
        if LoanAmount > 0 then begin
            TargetLoan.Get(TargetLoanNo);
            CheckLoanForPosting(TargetLoan);
            TargetLoan.CalcFields("Outstanding Balance");
            TargetBalanceBefore := TargetLoan."Outstanding Balance";
        end;
        if DepositAmount > 0 then begin
            TransactionTypeSetup.SetRange("Transaction Type", TransactionTypeSetup."Transaction Type"::"Deposit Contribution");
            if not TransactionTypeSetup.FindFirst() then
                Error('Set up the Deposit Contribution transaction type and posting group before transferring to deposits.');
            TransactionTypeSetup.TestField("Posting Group Code");
        end;
        Member.CalcFields("Current Shares");
        DepositsBefore := Member."Current Shares";

        Batch.LockTable();
        Batch.Get('GENERAL', 'DEFAULT');
        Template.Get(Batch."Journal Template Name");
        Template.TestField(Recurring, false);
        Template.TestField("Source Code");
        JournalLine.LockTable();
        JournalLine.SetRange("Journal Template Name", Batch."Journal Template Name");
        JournalLine.SetRange("Journal Batch Name", Batch.Name);
        if not JournalLine.IsEmpty() then
            Error('Journal batch %1 / %2 contains entries. Post or move those entries before transferring this overpayment.', Batch."Journal Template Name", Batch.Name);

        DocumentNo := GetTransferDocumentNo(Batch, PostingDate);
        // Debit reverses the excess repayment; matching credits repay a loan and/or increase deposits.
        InsertLine(Batch, Template, SourceLoan, 10000, DocumentNo, PostingDate, Excess, false, SourceLoanNo);
        if LoanAmount > 0 then
            InsertLine(Batch, Template, TargetLoan, 20000, DocumentNo, PostingDate, -LoanAmount, false, SourceLoanNo);
        if DepositAmount > 0 then
            InsertLine(Batch, Template, SourceLoan, 30000, DocumentNo, PostingDate, -DepositAmount, true, SourceLoanNo);
        JournalLine.FindFirst();
        PostBatch.SetSuppressCommit(true);
        PostBatch.Run(JournalLine);

        // Any mismatch raises an error and rolls back the entire posting.
        SourceLoan.CalcFields("Outstanding Balance");
        if SourceLoan."Outstanding Balance" <> 0 then
            Error('The transfer did not clear the source loan balance. No transfer has been posted.');
        if LoanAmount > 0 then begin
            TargetLoan.CalcFields("Outstanding Balance");
            if TargetLoan."Outstanding Balance" <> TargetBalanceBefore - LoanAmount then
                Error('The destination loan balance did not update as expected. No transfer has been posted.');
        end;
        Member.CalcFields("Current Shares");
        if Member."Current Shares" <> DepositsBefore + DepositAmount then
            Error('The deposit balance did not update as expected. No transfer has been posted.');
        exit(DocumentNo);
    end;

    local procedure GetTransferDocumentNo(Batch: Record "Gen. Journal Batch"; PostingDate: Date): Code[20]
    var
        NoSeriesMgt: Codeunit NoSeriesManagement;
        CustomerEntry: Record "Cust. Ledger Entry";
        GLEntry: Record "G/L Entry";
        JournalLine: Record "Gen. Journal Line";
        DocumentNo: Code[20];
    begin
        if Batch."No. Series" <> '' then
            exit(NoSeriesMgt.GetNextNo(Batch."No. Series", PostingDate, true));

        // General journals support a supplied document number without a number series.
        // Keep one unique reference for every debit and credit in this transfer.
        repeat
            DocumentNo := 'OVT-' + CopyStr(DelChr(Format(CreateGuid()), '=', '{}-'), 1, 16);
            CustomerEntry.SetRange("Document No.", DocumentNo);
            GLEntry.SetRange("Document No.", DocumentNo);
            JournalLine.SetRange("Document No.", DocumentNo);
        until CustomerEntry.IsEmpty() and GLEntry.IsEmpty() and JournalLine.IsEmpty();
        exit(DocumentNo);
    end;

    local procedure CheckLoanForPosting(Loan: Record "Loans Register")
    var
        Entry: Record "Cust. Ledger Entry";
        Product: Record "Loan Products Setup";
    begin
        Product.Get(Loan."Loan Product Type");
        Product.TestField("Loan Account");
        Entry.SetRange("Customer No.", Loan."Client Code");
        Entry.SetRange("Loan No", Loan."Loan  No.");
        Entry.SetRange(Reversed, false);
        Entry.SetFilter("Currency Code", '<>%1', '');
        if not Entry.IsEmpty() then
            Error('Loan %1 has foreign-currency entries. This transfer action supports local-currency loans only.', Loan."Loan  No.");
    end;

    local procedure InsertLine(Batch: Record "Gen. Journal Batch"; Template: Record "Gen. Journal Template"; Loan: Record "Loans Register"; LineNo: Integer; DocumentNo: Code[20]; PostingDate: Date; Amount: Decimal; IsDeposit: Boolean; SourceLoanNo: Code[20])
    var
        Line: Record "Gen. Journal Line";
    begin
        Line.Init();
        Line."Journal Template Name" := Batch."Journal Template Name";
        Line."Journal Batch Name" := Batch.Name;
        Line."Line No." := LineNo;
        Line.Validate("Posting Date", PostingDate);
        Line."Document No." := DocumentNo;
        Line."Source Code" := Template."Source Code";
        Line."Reason Code" := Batch."Reason Code";
        Line.Validate("Account Type", Line."Account Type"::Customer);
        Line.Validate("Account No.", Loan."Client Code");
        if IsDeposit then
            Line.Validate("Transaction Type", Line."Transaction Type"::"Deposit Contribution")
        else begin
            Line.Validate("Transaction Type", Line."Transaction Type"::"Loan Repayment");
            Line.Validate("Loan No", Loan."Loan  No.");
        end;
        if Loan."Branch Code" <> '' then
            Line.Validate("Shortcut Dimension 2 Code", Loan."Branch Code");
        Line.Validate(Amount, Amount);
        if Line.Amount <> Amount then
            Error('The transfer amount cannot be represented using the configured currency rounding precision.');
        Line.Description := CopyStr(StrSubstNo('Overpayment transfer from loan %1', SourceLoanNo), 1, MaxStrLen(Line.Description));
        Line.Insert(true);
    end;
}
