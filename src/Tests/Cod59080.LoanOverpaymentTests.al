codeunit 59080 "Loan Overpayment Tests"
{
    Subtype = Test;

    [Test]
    procedure FullExcessGoesToDeposits()
    begin
        TransferMgt.AllocateAmounts(1250.25, 0, true, false, LoanAmount, DepositAmount);
        AssertAmounts(0, 1250.25);
    end;

    [Test]
    procedure LargerLoanReceivesFullExcess()
    begin
        TransferMgt.AllocateAmounts(1250.25, 3000, false, false, LoanAmount, DepositAmount);
        AssertAmounts(1250.25, 0);
    end;

    [Test]
    procedure EqualBalancePaysOffLoanWithoutRemainder()
    begin
        TransferMgt.AllocateAmounts(1250.25, 1250.25, false, false, LoanAmount, DepositAmount);
        AssertAmounts(1250.25, 0);
    end;

    [Test]
    procedure SmallerLoanCapsRepaymentAndDepositsRemainder()
    begin
        TransferMgt.AllocateAmounts(1250.25, 1000, false, true, LoanAmount, DepositAmount);
        AssertAmounts(1000, 250.25);
    end;

    [Test]
    procedure SmallerLoanWithoutRemainderOptionIsRejected()
    begin
        asserterror TransferMgt.AllocateAmounts(1250.25, 1000, false, false, LoanAmount, DepositAmount);
        AssertErrorContains('exceeds the destination loan balance');
    end;

    [Test]
    procedure SettledSourceIsRejected()
    begin
        asserterror TransferMgt.AllocateAmounts(0, 1000, false, true, LoanAmount, DepositAmount);
        AssertErrorContains('no longer has an overpayment');
    end;

    [Test]
    procedure SourceOwingMoneyIsRejected()
    begin
        asserterror TransferMgt.AllocateAmounts(-1, 0, true, true, LoanAmount, DepositAmount);
        AssertErrorContains('no longer has an overpayment');
    end;

    [Test]
    procedure SettledDestinationIsRejected()
    begin
        asserterror TransferMgt.AllocateAmounts(100, 0, false, true, LoanAmount, DepositAmount);
        AssertErrorContains('positive outstanding balance');
    end;

    [Test]
    procedure OverpaidDestinationIsRejected()
    begin
        asserterror TransferMgt.AllocateAmounts(100, -1, false, true, LoanAmount, DepositAmount);
        AssertErrorContains('positive outstanding balance');
    end;

    [Test]
    procedure SmallestCurrencyRemainderIsPreserved()
    begin
        TransferMgt.AllocateAmounts(100.01, 100, false, true, LoanAmount, DepositAmount);
        AssertAmounts(100, 0.01);
    end;


    [Test]
    procedure FullExcessGoesToShareCapital()
    var
        ShareAmount: Decimal;
    begin
        TransferMgt.AllocateDestination(1250.25, 0, "Overpayment Destination"::"Share Capital", false, LoanAmount, DepositAmount, ShareAmount);
        AssertAmounts(0, 0);
        if ShareAmount <> 1250.25 then
            Error('Expected share capital 1250.25; received %1.', ShareAmount);
    end;

    [Test]
    procedure SwitchingFromSharesClearsPreviousAllocation()
    var
        ShareAmount: Decimal;
    begin
        ShareAmount := 1250.25;
        TransferMgt.AllocateDestination(1250.25, 0, "Overpayment Destination"::Deposits, false, LoanAmount, DepositAmount, ShareAmount);
        AssertAmounts(0, 1250.25);
        if ShareAmount <> 0 then
            Error('Share capital allocation must be cleared when switching to deposits.');
    end;

    [Test]
    procedure CustomerOverpaymentsAreAccumulatedForDeposits()
    var
        Sources: Dictionary of [Code[20], Decimal];
        ShareAmount: Decimal;
    begin
        Sources.Add('LOAN-A', 1000.25);
        Sources.Add('LOAN-B', 250.50);
        TransferMgt.GetDestinationAmounts('MEMBER-A', Sources, '', "Overpayment Destination"::Deposits, false, LoanAmount, DepositAmount, ShareAmount);
        AssertAmounts(0, 1250.75);
        if ShareAmount <> 0 then
            Error('Deposits must not allocate to share capital.');
    end;

    [Test]
    procedure CustomerOverpaymentsAreAccumulatedForShares()
    var
        Sources: Dictionary of [Code[20], Decimal];
        ShareAmount: Decimal;
    begin
        Sources.Add('LOAN-A', 1000.25);
        Sources.Add('LOAN-B', 250.50);
        TransferMgt.GetDestinationAmounts('MEMBER-A', Sources, '', "Overpayment Destination"::"Share Capital", false, LoanAmount, DepositAmount, ShareAmount);
        AssertAmounts(0, 0);
        if ShareAmount <> 1250.75 then
            Error('Expected combined share capital 1250.75; received %1.', ShareAmount);
    end;

    [Test]
    procedure UnchangedSourceSnapshotIsAccepted()
    var
        ExpectedSources: Dictionary of [Code[20], Decimal];
        CurrentSources: Dictionary of [Code[20], Decimal];
    begin
        ExpectedSources.Add('LOAN-A', 100);
        ExpectedSources.Add('LOAN-B', 200);
        CurrentSources.Add('LOAN-B', 200);
        CurrentSources.Add('LOAN-A', 100);
        TransferMgt.ValidateSnapshot(ExpectedSources, CurrentSources);
    end;

    [Test]
    procedure ChangedSourcesWithSameTotalAreRejected()
    var
        ExpectedSources: Dictionary of [Code[20], Decimal];
        CurrentSources: Dictionary of [Code[20], Decimal];
    begin
        ExpectedSources.Add('LOAN-A', 100);
        ExpectedSources.Add('LOAN-B', 200);
        CurrentSources.Add('LOAN-A', 150);
        CurrentSources.Add('LOAN-B', 150);
        asserterror TransferMgt.ValidateSnapshot(ExpectedSources, CurrentSources);
        AssertErrorContains('source loan balances have changed');
    end;

    [Test]
    procedure AddedOverpaidLoanRequiresNewPreview()
    var
        ExpectedSources: Dictionary of [Code[20], Decimal];
        CurrentSources: Dictionary of [Code[20], Decimal];
    begin
        ExpectedSources.Add('LOAN-A', 100);
        CurrentSources.Add('LOAN-A', 100);
        CurrentSources.Add('LOAN-B', 200);
        asserterror TransferMgt.ValidateSnapshot(ExpectedSources, CurrentSources);
        AssertErrorContains('source loans have changed');
    end;

    [Test]
    procedure ReplacedSourceWithSameAmountIsRejected()
    var
        ExpectedSources: Dictionary of [Code[20], Decimal];
        CurrentSources: Dictionary of [Code[20], Decimal];
    begin
        ExpectedSources.Add('LOAN-A', 100);
        CurrentSources.Add('LOAN-B', 100);
        asserterror TransferMgt.ValidateSnapshot(ExpectedSources, CurrentSources);
        AssertErrorContains('source loans have changed');
    end;

    local procedure AssertAmounts(ExpectedLoan: Decimal; ExpectedDeposit: Decimal)
    begin
        if (LoanAmount <> ExpectedLoan) or (DepositAmount <> ExpectedDeposit) then
            Error('Expected loan/deposits %1/%2; received %3/%4.', ExpectedLoan, ExpectedDeposit, LoanAmount, DepositAmount);
    end;

    local procedure AssertErrorContains(ExpectedText: Text)
    begin
        if StrPos(GetLastErrorText(), ExpectedText) = 0 then
            Error('Unexpected error: %1', GetLastErrorText());
    end;

    var
        TransferMgt: Codeunit "Loan Overpayment Transfer";
        LoanAmount: Decimal;
        DepositAmount: Decimal;
}
