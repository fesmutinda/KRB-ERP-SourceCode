codeunit 59086 "Interest Insights Tests"
{
    Subtype = Test;

    [Test]
    procedure DebitAdjustmentsReduceInterest()
    begin
        NewAccountFilter();
        AddEntry(DMY2Date(10, 1, 2025), -1000, false);
        AddEntry(DMY2Date(11, 1, 2025), 200, false);
        AssertAmount(800, Insights.NetInterest(AccountNo, DMY2Date(1, 1, 2025), DMY2Date(31, 1, 2025)));
    end;

    [Test]
    procedure SameMonthReversalNetsToZero()
    begin
        NewAccountFilter();
        AddEntry(DMY2Date(10, 1, 2025), -1000, true);
        AddEntry(DMY2Date(11, 1, 2025), 1000, true);
        AssertAmount(0, Insights.NetInterest(AccountNo, DMY2Date(1, 1, 2025), DMY2Date(31, 1, 2025)));
    end;

    [Test]
    procedure ReversalIsRecognizedInItsPostingMonth()
    begin
        NewAccountFilter();
        AddEntry(DMY2Date(10, 1, 2025), -1000, true);
        AddEntry(DMY2Date(11, 2, 2025), 1000, true);
        AssertAmount(1000, Insights.NetInterest(AccountNo, DMY2Date(1, 1, 2025), DMY2Date(31, 1, 2025)));
        AssertAmount(-1000, Insights.NetInterest(AccountNo, DMY2Date(1, 2, 2025), DMY2Date(28, 2, 2025)));
    end;

    [Test]
    procedure ClosingEntriesDoNotEraseIncome()
    begin
        NewAccountFilter();
        AddEntry(DMY2Date(20, 12, 2025), -1000, false);
        AddEntry(ClosingDate(DMY2Date(31, 12, 2025)), 1000, false);
        AssertAmount(1000, Insights.NetInterest(AccountNo, DMY2Date(1, 12, 2025), DMY2Date(1, 1, 2026)));
    end;

    [Test]
    procedure MonthToDateExcludesFutureAndOtherMonths()
    begin
        NewAccountFilter();
        AddEntry(DMY2Date(31, 1, 2025), -500, false);
        AddEntry(DMY2Date(1, 2, 2025), -100, false);
        AddEntry(DMY2Date(15, 2, 2025), -200, false);
        AddEntry(DMY2Date(16, 2, 2025), -300, false);
        AssertAmount(300, Insights.NetInterest(AccountNo, DMY2Date(1, 2, 2025), DMY2Date(15, 2, 2025)));
    end;

    [Test]
    procedure NoEntriesIsZeroAndLossesStayNegative()
    begin
        NewAccountFilter();
        AssertAmount(0, Insights.NetInterest(AccountNo, DMY2Date(1, 1, 2025), DMY2Date(31, 1, 2025)));
        AddEntry(DMY2Date(2, 1, 2025), 250, false);
        AssertAmount(-250, Insights.NetInterest(AccountNo, DMY2Date(1, 1, 2025), DMY2Date(31, 1, 2025)));
    end;

    [Test]
    procedure LeapDayUsesPriorFebruaryEnd()
    begin
        if Insights.PriorYearDate(DMY2Date(29, 2, 2024)) <> DMY2Date(28, 2, 2023) then
            Error('Leap-day comparison must end on 28 February.');
        if Insights.PriorYearDate(DMY2Date(17, 9, 2026)) <> DMY2Date(17, 9, 2025) then
            Error('YTD must compare matching calendar dates.');
    end;

    [Test]
    procedure ComparisonHandlesZeroAndNegativeBaselines()
    begin
        if Insights.ChangeText(120, 100) <> '+20%' then
            Error('Expected a 20 percent increase.');
        if Insights.ChangeText(80, 100) <> '-20%' then
            Error('Expected a 20 percent decrease.');
        if StrPos(Insights.ChangeText(100, 0), 'N/A') <> 1 then
            Error('Zero baseline must not divide by zero.');
        if StrPos(Insights.ChangeText(100, -100), 'N/A') <> 1 then
            Error('Negative baseline must not show a misleading growth percentage.');
    end;

    [Test]
    procedure MissingProductMappingDoesNotShowAllAccounts()
    var
        Product: Record "Loan Products Setup";
        FilterText: Text;
    begin
        NewAccountFilter();
        Product.Init();
        Product.Code := AccountNo;
        Product.Insert(false);
        asserterror FilterText := Insights.ResolveAccountFilter(Product.Code);
        if StrPos(GetLastErrorText(), 'Loan Interest Account') = 0 then
            Error('Expected a missing interest account error.');
    end;

    [Test]
    procedure EightProductSeriesRetainValuesAndDrillDown()
    var
        Chart: Record "Business Chart Buffer" temporary;
        SeriesIndex: Integer;
        ChartValue: Variant;
        Amount: Decimal;
    begin
        Chart.Initialize();
        Chart.SetXAxis('Month', Chart."Data Type"::String);
        for SeriesIndex := 0 to 7 do
            Chart.AddMeasure('Product ' + Format(SeriesIndex), SeriesIndex,
                Chart."Data Type"::Decimal, Chart."Chart Type"::Column);
        Chart.AddColumn('Jan 2025');
        for SeriesIndex := 0 to 7 do
            Chart.SetValueByIndex(SeriesIndex, 0, (SeriesIndex + 1) * 100);
        Chart.GetValue('Product 7', 0, ChartValue);
        Amount := ChartValue;
        AssertAmount(800, Amount);
        Chart.SetDrillDownIndexesByCoordinate('Product 7', 'Jan 2025', 800);
        if (Chart."Drill-Down Measure Index" <> 7) or (Chart."Drill-Down X Index" <> 0) then
            Error('The eighth product must drill down to its own series and month.');
    end;

    local procedure NewAccountFilter()
    begin
        AccountNo := CopyStr(DelChr(Format(CreateGuid()), '=', '{}-'), 1, 20);
    end;

    local procedure AddEntry(PostingDate: Date; Amount: Decimal; Reversed: Boolean)
    var
        Entry: Record "G/L Entry";
        EntryNo: Integer;
    begin
        Entry.LockTable();
        if Entry.FindLast() then
            EntryNo := Entry."Entry No.";
        Entry.Init();
        Entry."Entry No." := EntryNo + 1;
        Entry."G/L Account No." := AccountNo;
        Entry."Posting Date" := PostingDate;
        Entry.Amount := Amount;
        Entry.Reversed := Reversed;
        if Amount < 0 then
            Entry."Credit Amount" := -Amount
        else
            Entry."Debit Amount" := Amount;
        Entry.Insert(false);
    end;

    local procedure AssertAmount(Expected: Decimal; Actual: Decimal)
    begin
        if Expected <> Actual then
            Error('Expected net interest %1, received %2.', Expected, Actual);
    end;

    var
        Insights: Codeunit "Interest Insights Mgt.";
        AccountNo: Code[20];
}
