namespace KRBERPSourceCode.KRBERPSourceCode;

using System.Integration;
using System.Visualization;
using Microsoft.Finance.GeneralLedger.Setup;
using Microsoft.Finance.GeneralLedger.Account;

page 59060 "Loan Performance Chart"
{
    ApplicationArea = All;
    Caption = 'Net Interest Income';
    PageType = CardPart;
    RefreshOnActivate = true;

    layout
    {
        area(Content)
        {
            usercontrol(Chart; BusinessChart)
            {
                ApplicationArea = All;
                trigger AddInReady()
                begin
                    ChartReady := true;
                    LoadInsights();
                end;
                trigger Refresh()
                begin
                    LoadInsights();
                end;
                trigger DataPointClicked(Point: JsonObject)
                var
                    Index: Integer;
                    SeriesIndex: Integer;
                begin
                    ChartBuffer.SetDrillDownIndexes(Point);
                    Index := ChartBuffer."Drill-Down X Index" + 1;
                    SeriesIndex := ChartBuffer."Drill-Down Measure Index" + 1;
                    if (Index >= 1) and (Index <= 12) and
                       (SeriesIndex >= 1) and (SeriesIndex <= ChartAccountFilters.Count()) then
                        Insights.ShowEntries(ChartAccountFilters.Get(SeriesIndex), PeriodStarts[Index], PeriodEnds[Index]);
                end;
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(OpenExpandedView)
            {
                ApplicationArea = All;
                Caption = 'Open Expanded View';
                Image = View;
                ToolTip = 'Open the interest insights on a dedicated page with more space for product bars and the legend.';
                trigger OnAction()
                var
                    Overview: Page "Interest Income Overview";
                begin
                    Overview.Run();
                end;
            }
            action(RefreshChart)
            {
                ApplicationArea = All;
                Caption = 'Refresh';
                Image = Refresh;
                ToolTip = 'Refresh monthly net interest by product for the last 12 months through today.';
                trigger OnAction()
                begin
                    LoadInsights();
                end;
            }


        }
    }

    trigger OnOpenPage()
    begin
        LoadInsights();
    end;

    local procedure LoadInsights()
    var
        GLSetup: Record "General Ledger Setup";
    begin
        AccountFilter := Insights.BaseAccountFilter();
        AsAtDate := Today();
        MonthStart := CalcDate('<-CM>', AsAtDate);
        ChartStart := CalcDate('<-11M>', MonthStart);
        GLSetup.Get();
        CurrencyCode := GLSetup."LCY Code";
        if CurrencyCode = '' then
            CurrencyCode := 'LCY';
        if ChartReady then
            DrawChart();
    end;

    local procedure DrawChart()
    var
        Account: Record "G/L Account";
        ExactAccount: Record "G/L Account";
        Index: Integer;
        MeasureIndex: Integer;
        CurrentPeriod: Date;
        CaptionText: Text;
        ProductNames: Text;
        SeriesCaption: Text;
        SeriesIndexes: Dictionary of [Text, Integer];
        SeriesNames: List of [Text];
    begin
        ChartBuffer.Initialize();
        Clear(ChartAccountFilters);
        ChartBuffer.SetChartCondensed(false);
        ChartBuffer.SetXAxis('Month - net interest (' + CurrencyCode + ')', ChartBuffer."Data Type"::String);

        // One series per income account avoids counting shared product income twice.
        Account.SetFilter("No.", AccountFilter);
        if Account.FindSet() then
            repeat
                ProductNames := Insights.AccountProductDescriptions(Account."No.");
                if ProductNames = '' then
                    ProductNames := Account.Name;
                if ProductNames = '' then
                    ProductNames := 'Interest income';
                SeriesCaption := CopyStr(ProductNames, 1, 249);
                ExactAccount.SetRange("No.", Account."No.");
                // Identical descriptions share a series, without adding codes to the legend.
                if SeriesIndexes.Get(SeriesCaption, MeasureIndex) then
                    ChartAccountFilters.Set(MeasureIndex + 1,
                        ChartAccountFilters.Get(MeasureIndex + 1) + '|' + ExactAccount.GetFilter("No."))
                else begin
                    MeasureIndex := ChartAccountFilters.Count();
                    SeriesNames.Add(SeriesCaption);
                    ChartAccountFilters.Add(ExactAccount.GetFilter("No."));
                    SeriesIndexes.Add(SeriesCaption, MeasureIndex);
                end;
            until Account.Next() = 0;

        for Index := 1 to SeriesNames.Count() do
            ChartBuffer.AddMeasure(SeriesNames.Get(Index), Index - 1,
                ChartBuffer."Data Type"::Decimal, ChartBuffer."Chart Type"::Column);
        CurrentPeriod := ChartStart;
        for Index := 1 to 12 do begin
            PeriodStarts[Index] := CurrentPeriod;
            PeriodEnds[Index] := CalcDate('<CM>', CurrentPeriod);
            CaptionText := Format(CurrentPeriod, 0, '<Month Text,3> <Year4>');
            if PeriodEnds[Index] > AsAtDate then
                PeriodEnds[Index] := AsAtDate;
            if CurrentPeriod = MonthStart then
                CaptionText += ' (incomplete)';
            ChartBuffer.AddColumn(CaptionText);
            for MeasureIndex := 1 to ChartAccountFilters.Count() do
                ChartBuffer.SetValueByIndex(MeasureIndex - 1, Index - 1,
                    Insights.NetInterest(ChartAccountFilters.Get(MeasureIndex), PeriodStarts[Index], PeriodEnds[Index]));
            CurrentPeriod := CalcDate('<1M>', CurrentPeriod);
        end;
        ChartBuffer.UpdateChart(CurrPage.Chart);
    end;

    var
        Insights: Codeunit "Interest Insights Mgt.";
        ChartBuffer: Record "Business Chart Buffer" temporary;
        ChartReady: Boolean;
        ChartAccountFilters: List of [Text];
        AccountFilter: Text;
        CurrencyCode: Code[10];
        AsAtDate: Date;
        MonthStart: Date;
        ChartStart: Date;
        PeriodStarts: array[12] of Date;
        PeriodEnds: array[12] of Date;
}

page 59061 "Chart Period Selection"
{
    PageType = StandardDialog;
    Caption = 'Select Chart Period and Scaling';

    layout
    {
        area(Content)
        {
            group(Period)
            {
                field(PeriodType; PeriodTypeOption)
                {
                    Caption = 'Period Type';
                    OptionCaption = 'Month,Quarter,Year';

                    trigger OnValidate()
                    begin
                        UpdatePeriodDates();
                    end;
                }

                field(NumberOfPeriods; NumberOfPeriods)
                {
                    Caption = 'Number of Periods';
                    MinValue = 1;
                    MaxValue = 36;

                    trigger OnValidate()
                    begin
                        UpdatePeriodDates();
                    end;
                }

                field(StartDate; StartDate)
                {
                    Caption = 'Start Date';
                    Editable = false;
                }

                field(EndDate; EndDate)
                {
                    Caption = 'End Date';
                    Editable = false;
                }
            }

            group(Scaling)
            {
                Caption = 'Chart Scaling Options';

                field(ScalingType; ScalingTypeOption)
                {
                    Caption = 'Scaling Type';
                    OptionCaption = 'Linear,Logarithmic,Percentage';
                }

                field(SeparateHighValues; SeparateHighValues)
                {
                    Caption = 'Separate High Value Accounts';
                    ToolTip = 'Show accounts with values above 3M separately';
                }
            }
        }
    }

    local procedure UpdatePeriodDates()
    begin
        case PeriodTypeOption of
            PeriodTypeOption::Month:
                begin
                    StartDate := CalcDate('<-' + Format(NumberOfPeriods) + 'M+1D>', Today());
                    EndDate := Today();
                end;
            PeriodTypeOption::Quarter:
                begin
                    StartDate := CalcDate('<-' + Format(NumberOfPeriods * 3) + 'M+1D>', Today());
                    EndDate := Today();
                end;
            PeriodTypeOption::Year:
                begin
                    StartDate := CalcDate('<-' + Format(NumberOfPeriods) + 'Y+1D>', Today());
                    EndDate := Today();
                end;
        end;
    end;

    trigger OnOpenPage()
    begin
        PeriodTypeOption := PeriodTypeOption::Month;
        NumberOfPeriods := 12;
        ScalingTypeOption := ScalingTypeOption::Linear;
        SeparateHighValues := false;
        UpdatePeriodDates();
    end;

    var
        PeriodTypeOption: Option Month,Quarter,Year;
        ScalingTypeOption: Option Linear,Logarithmic,Percentage;
        NumberOfPeriods: Integer;
        StartDate: Date;
        EndDate: Date;
        SeparateHighValues: Boolean;
}
