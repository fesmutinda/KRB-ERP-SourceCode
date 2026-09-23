codeunit 59079 "Loan Overpayment Transfer"
{
    procedure CollectOverpayments(MemberNo: Code[20]; SourceLoanNo: Code[20]; var Sources: Dictionary of [Code[20], Decimal]): Decimal
    var
        Loan: Record "Loans Register";
        Total: Decimal;
    begin
        if MemberNo = '' then
            Error('Specify the member whose overpayments will be transferred.');
        Clear(Sources);
        Loan.SetRange("Client Code", MemberNo);
        Loan.SetRange(Posted, true);
        Loan.SetRange(Reversed, false);
        if SourceLoanNo <> '' then
            Loan.SetRange("Loan  No.", SourceLoanNo);
        Loan.SetFilter("Outstanding Balance", '<0');
        Loan.SetAutoCalcFields("Outstanding Balance");
        if Loan.FindSet() then
            repeat
                Sources.Add(Loan."Loan  No.", -Loan."Outstanding Balance");
                Total -= Loan."Outstanding Balance";
            until Loan.Next() = 0;
        if Total <= 0 then
            Error('There are no loan overpayments to transfer for member %1.', MemberNo);
        exit(Total);
    end;

    procedure GetAmounts(SourceLoanNo: Code[20]; TargetLoanNo: Code[20]; ToDeposits: Boolean; DepositRemainder: Boolean; var Excess: Decimal; var LoanAmount: Decimal; var DepositAmount: Decimal)
    var
        Loan: Record "Loans Register";
        Sources: Dictionary of [Code[20], Decimal];
        Destination: Enum "Overpayment Destination";
        ShareAmount: Decimal;
    begin
        Loan.Get(SourceLoanNo);
        Excess := CollectOverpayments(Loan."Client Code", SourceLoanNo, Sources);
        if ToDeposits then
            Destination := Destination::Deposits;
        GetDestinationAmounts(Loan."Client Code", Sources, TargetLoanNo, Destination, DepositRemainder, LoanAmount, DepositAmount, ShareAmount);
    end;

    procedure GetDestinationAmounts(MemberNo: Code[20]; Sources: Dictionary of [Code[20], Decimal]; TargetLoanNo: Code[20]; Destination: Enum "Overpayment Destination"; DepositRemainder: Boolean; var LoanAmount: Decimal; var DepositAmount: Decimal; var ShareAmount: Decimal)
    var
        TargetLoan: Record "Loans Register";
        LoanNo: Code[20];
        Total: Decimal;
    begin
        foreach LoanNo in Sources.Keys() do
            Total += Sources.Get(LoanNo);
        if Destination = Destination::Loan then begin
            if Sources.ContainsKey(TargetLoanNo) then
                Error('Choose a destination loan that is not one of the overpaid source loans.');
            TargetLoan.Get(TargetLoanNo);
            TargetLoan.TestField("Client Code", MemberNo);
            TargetLoan.TestField(Posted, true);
            TargetLoan.TestField(Reversed, false);
            TargetLoan.CalcFields("Outstanding Balance");
        end;
        AllocateDestination(Total, TargetLoan."Outstanding Balance", Destination, DepositRemainder, LoanAmount, DepositAmount, ShareAmount);
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

    procedure AllocateDestination(Excess: Decimal; TargetBalance: Decimal; Destination: Enum "Overpayment Destination"; DepositRemainder: Boolean; var LoanAmount: Decimal; var DepositAmount: Decimal; var ShareAmount: Decimal)
    begin
        ShareAmount := 0;
        AllocateAmounts(Excess, TargetBalance, Destination <> Destination::Loan, DepositRemainder, LoanAmount, DepositAmount);
        if Destination = Destination::"Share Capital" then begin
            ShareAmount := DepositAmount;
            DepositAmount := 0;
        end;
    end;

    procedure GetBatchLineCount(): Integer
    var
        Line: Record "Gen. Journal Line";
    begin
        Line.SetRange("Journal Template Name", 'GENERAL');
        Line.SetRange("Journal Batch Name", 'DEFAULT');
        exit(Line.Count());
    end;

    procedure ValidateSnapshot(ExpectedSources: Dictionary of [Code[20], Decimal]; CurrentSources: Dictionary of [Code[20], Decimal])
    var
        LoanNo: Code[20];
    begin
        if ExpectedSources.Count() <> CurrentSources.Count() then
            Error('The source loans have changed. Reopen the transfer and review the updated amounts.');
        foreach LoanNo in ExpectedSources.Keys() do begin
            if not CurrentSources.ContainsKey(LoanNo) then
                Error('The source loans have changed. Reopen the transfer and review the updated amounts.');
            if CurrentSources.Get(LoanNo) <> ExpectedSources.Get(LoanNo) then
                Error('The source loan balances have changed. Reopen the transfer and review the updated amounts.');
        end;
    end;

    procedure PostTransfer(SourceLoanNo: Code[20]; TargetLoanNo: Code[20]; ToDeposits: Boolean; DepositRemainder: Boolean; PostingDate: Date; ExpectedExcess: Decimal; ExpectedLoanAmount: Decimal; ExpectedDepositAmount: Decimal): Code[20]
    var
        Loan: Record "Loans Register";
        Sources: Dictionary of [Code[20], Decimal];
        Destination: Enum "Overpayment Destination";
    begin
        Loan.Get(SourceLoanNo);
        Sources.Add(SourceLoanNo, ExpectedExcess);
        if ToDeposits then
            Destination := Destination::Deposits;
        exit(PostSources(Loan."Client Code", SourceLoanNo, Sources, TargetLoanNo, Destination, DepositRemainder, PostingDate,
            ExpectedLoanAmount, ExpectedDepositAmount, 0, GetBatchLineCount()));
    end;

    [CommitBehavior(CommitBehavior::Error)]
    procedure PostSources(MemberNo: Code[20]; SourceLoanNo: Code[20]; ExpectedSources: Dictionary of [Code[20], Decimal]; TargetLoanNo: Code[20]; Destination: Enum "Overpayment Destination"; DepositRemainder: Boolean; PostingDate: Date; ExpectedLoanAmount: Decimal; ExpectedDepositAmount: Decimal; ExpectedShareAmount: Decimal; ExpectedBatchLines: Integer): Code[20]
    var
        SourceLoan: Record "Loans Register";
        TargetLoan: Record "Loans Register";
        Member: Record Customer;
        LedgerEntry: Record "Cust. Ledger Entry";
        Batch: Record "Gen. Journal Batch";
        Template: Record "Gen. Journal Template";
        JournalLine: Record "Gen. Journal Line";
        PostBatch: Codeunit "Gen. Jnl.-Post Batch";
        CurrentSources: Dictionary of [Code[20], Decimal];
        LoanNo: Code[20];
        LineNo: Integer;
        LoanAmount: Decimal;
        DepositAmount: Decimal;
        ShareAmount: Decimal;
        DepositsBefore: Decimal;
        SharesBefore: Decimal;
        TargetBalanceBefore: Decimal;
        DocumentNo: Code[20];
        TransferDescription: Text;
    begin
        if PostingDate = 0D then
            Error('Specify a posting date.');
        LedgerEntry.LockTable();
        if LedgerEntry.FindLast() then;
        SourceLoan.LockTable();
        CollectOverpayments(MemberNo, SourceLoanNo, CurrentSources);
        ValidateSnapshot(ExpectedSources, CurrentSources);
        GetDestinationAmounts(MemberNo, CurrentSources, TargetLoanNo, Destination, DepositRemainder, LoanAmount, DepositAmount, ShareAmount);
        if (LoanAmount <> ExpectedLoanAmount) or (DepositAmount <> ExpectedDepositAmount) or (ShareAmount <> ExpectedShareAmount) then
            Error('The loan balances have changed. Reopen the transfer and review the updated amounts.');
        Member.Get(MemberNo);
        Member.TestField(Blocked, Member.Blocked::" ");
        Member.TestField("Currency Code", '');
        foreach LoanNo in CurrentSources.Keys() do begin
            SourceLoan.Get(LoanNo);
            CheckLoanForPosting(SourceLoan);
        end;
        if LoanAmount > 0 then begin
            TargetLoan.Get(TargetLoanNo);
            CheckLoanForPosting(TargetLoan);
            TargetLoan.CalcFields("Outstanding Balance");
            TargetBalanceBefore := TargetLoan."Outstanding Balance";
        end;
        if DepositAmount > 0 then
            CheckTransactionSetup("TransactionTypesEnum"::"Deposit Contribution");
        if ShareAmount > 0 then
            CheckTransactionSetup("TransactionTypesEnum"::"Share Capital");
        Member.CalcFields("Current Shares", "Share Capital");
        DepositsBefore := Member."Current Shares";
        SharesBefore := Member."Share Capital";

        Batch.LockTable();
        Batch.Get('GENERAL', 'DEFAULT');
        Template.Get(Batch."Journal Template Name");
        Template.TestField(Recurring, false);
        Template.TestField("Source Code");
        JournalLine.LockTable();
        JournalLine.SetRange("Journal Template Name", Batch."Journal Template Name");
        JournalLine.SetRange("Journal Batch Name", Batch.Name);
        if JournalLine.Count() <> ExpectedBatchLines then
            Error('The entries in GENERAL / DEFAULT have changed. Reopen the transfer and confirm the updated number of entries to delete.');
        // Clear only this batch. Deletion and posting roll back together on any failure.
        JournalLine.DeleteAll(true);

        DocumentNo := GetTransferDocumentNo(Batch, PostingDate);
        TransferDescription := StrSubstNo('Overpayment transfer for member %1', MemberNo);
        foreach LoanNo in CurrentSources.Keys() do begin
            SourceLoan.Get(LoanNo);
            LineNo += 10000;
            InsertLine(Batch, Template, SourceLoan, LineNo, DocumentNo, PostingDate, CurrentSources.Get(LoanNo),
                "TransactionTypesEnum"::"Loan Repayment", TransferDescription);
        end;
        if LoanAmount > 0 then begin
            LineNo += 10000;
            InsertLine(Batch, Template, TargetLoan, LineNo, DocumentNo, PostingDate, -LoanAmount,
                "TransactionTypesEnum"::"Loan Repayment", TransferDescription);
        end;
        if DepositAmount > 0 then begin
            LineNo += 10000;
            InsertLine(Batch, Template, SourceLoan, LineNo, DocumentNo, PostingDate, -DepositAmount,
                "TransactionTypesEnum"::"Deposit Contribution", TransferDescription);
        end;
        if ShareAmount > 0 then begin
            LineNo += 10000;
            InsertLine(Batch, Template, SourceLoan, LineNo, DocumentNo, PostingDate, -ShareAmount,
                "TransactionTypesEnum"::"Share Capital", TransferDescription);
        end;
        JournalLine.FindFirst();
        PostBatch.SetSuppressCommit(true);
        PostBatch.Run(JournalLine);

        foreach LoanNo in CurrentSources.Keys() do begin
            SourceLoan.Get(LoanNo);
            SourceLoan.CalcFields("Outstanding Balance");
            if SourceLoan."Outstanding Balance" <> 0 then
                Error('The transfer did not clear loan %1. No transfer has been posted.', LoanNo);
        end;
        if LoanAmount > 0 then begin
            TargetLoan.CalcFields("Outstanding Balance");
            if TargetLoan."Outstanding Balance" <> TargetBalanceBefore - LoanAmount then
                Error('The destination loan balance did not update as expected. No transfer has been posted.');
        end;
        Member.CalcFields("Current Shares", "Share Capital");
        if Member."Current Shares" <> DepositsBefore + DepositAmount then
            Error('The deposit balance did not update as expected. No transfer has been posted.');
        if Member."Share Capital" <> SharesBefore + ShareAmount then
            Error('The share capital balance did not update as expected. No transfer has been posted.');
        exit(DocumentNo);
    end;

    local procedure CheckTransactionSetup(TransactionType: Enum TransactionTypesEnum)
    var
        Setup: Record "Transaction Types Table";
    begin
        if not Setup.Get(TransactionType) then
            Error('Set up transaction type %1 and its posting group before transferring.', TransactionType);
        Setup.TestField("Posting Group Code");
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

    local procedure InsertLine(Batch: Record "Gen. Journal Batch"; Template: Record "Gen. Journal Template"; Loan: Record "Loans Register"; LineNo: Integer; DocumentNo: Code[20]; PostingDate: Date; Amount: Decimal; TransactionType: Enum TransactionTypesEnum; TransferDescription: Text)
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
        Line.Validate("Transaction Type", TransactionType);
        if TransactionType = TransactionType::"Loan Repayment" then
            Line.Validate("Loan No", Loan."Loan  No.");
        if Loan."Branch Code" <> '' then
            Line.Validate("Shortcut Dimension 2 Code", Loan."Branch Code");
        Line.Validate(Amount, Amount);
        if Line.Amount <> Amount then
            Error('The transfer amount cannot be represented using the configured currency rounding precision.');
        Line.Description := CopyStr(TransferDescription, 1, MaxStrLen(Line.Description));
        Line.Insert(true);
    end;
}
