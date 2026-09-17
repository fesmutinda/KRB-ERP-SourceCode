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
