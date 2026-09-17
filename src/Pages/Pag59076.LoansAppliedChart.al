namespace KRBERPSourceCode.KRBERPSourceCode;

using System.Integration;
using System.Visualization;

page 59076 "Loans Applied Chart"
{
    ApplicationArea = All;
    Caption = 'Loans Applied (Count)';
    PageType = CardPart;

    layout
    {
        area(Content)
        {
            usercontrol(Chart; BusinessChart)
            {
                ApplicationArea = All;

                trigger AddInReady()
                begin
                    LoadAndDisplayChart();
                end;

                trigger Refresh()
                begin
                    LoadAndDisplayChart();
                end;

                trigger DataPointClicked(Point: JsonObject)
                var
                    Loans: Record "Loans Register";
                    MonthIndex: Integer;
                    SeriesIndex: Integer;
                begin
                    BusinessChartBuffer.SetDrillDownIndexes(Point);
                    MonthIndex := BusinessChartBuffer."Drill-Down X Index" + 1;
                    SeriesIndex := BusinessChartBuffer."Drill-Down Measure Index" + 1;
                    if (MonthIndex < 1) or (MonthIndex > 12) or
                       (SeriesIndex < 1) or (SeriesIndex > SeriesProductFilters.Count()) then
                        exit;
                    Loans.SetRange("Application Date", PeriodStarts[MonthIndex], PeriodEnds[MonthIndex]);
                    Loans.SetFilter("Loan Product Type", SeriesProductFilters.Get(SeriesIndex));
                    Page.Run(Page::"Loans  List All", Loans);
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
                ToolTip = 'Open the monthly applied-loans trend on a dedicated page with more space for product bars and the legend.';
                RunObject = page "Loans Applied Overview";
            }
            action(RefreshChart)
            {
                ApplicationArea = All;
                Caption = 'Refresh';
                Image = Refresh;
                ToolTip = 'Show monthly loan application counts for the last 12 months, including the current month to date, regardless of approval or posting status.';

                trigger OnAction()
                begin
                    LoadAndDisplayChart();
                end;
            }
        }
    }

    local procedure LoadAndDisplayChart()
    var
        Loans: Record "Loans Register";
        ProductFilterRecord: Record "Loans Register";
        ProductCaptions: Dictionary of [Code[250], Text];
        SeriesIndexes: Dictionary of [Text, Integer];
        SeriesNames: List of [Text];
        Counts: Dictionary of [Text, Integer];
        ProductName: Text;
        CountKey: Text;
        CountValue: Integer;
        SeriesIndex: Integer;
        MonthIndex: Integer;
        CurrentPeriod: Date;
        ChartStart: Date;
        AsAtDate: Date;
        PeriodCaption: Text;
    begin
        BusinessChartBuffer.Initialize();
        BusinessChartBuffer.SetChartCondensed(false);
        Clear(SeriesProductFilters);
        BusinessChartBuffer.SetXAxis('Application Month', BusinessChartBuffer."Data Type"::String);
        AsAtDate := Today();
        ChartStart := CalcDate('<-11M>', CalcDate('<-CM>', AsAtDate));

        // Read each application once. All statuses count, matching the original chart.
        Loans.SetCurrentKey("Application Date");
        Loans.SetRange("Application Date", ChartStart, AsAtDate);
        Loans.SetLoadFields("Application Date", "Loan Product Type", "Loan Product Type Name");
        if Loans.FindSet() then
            repeat
                if not ProductCaptions.Get(Loans."Loan Product Type", ProductName) then begin
                    ProductName := GetProductDescription(Loans);
                    ProductCaptions.Add(Loans."Loan Product Type", ProductName);
                    ProductFilterRecord.SetRange("Loan Product Type", Loans."Loan Product Type");
                    // Equal descriptions share a series without exposing product codes.
                    if SeriesIndexes.Get(ProductName, SeriesIndex) then
                        SeriesProductFilters.Set(SeriesIndex,
                            SeriesProductFilters.Get(SeriesIndex) + '|' + ProductFilterRecord.GetFilter("Loan Product Type"))
                    else begin
                        SeriesNames.Add(ProductName);
                        SeriesIndex := SeriesNames.Count();
                        SeriesIndexes.Add(ProductName, SeriesIndex);
                        SeriesProductFilters.Add(ProductFilterRecord.GetFilter("Loan Product Type"));
                        BusinessChartBuffer.AddMeasure(ProductName, SeriesIndex - 1,
                            BusinessChartBuffer."Data Type"::Integer, BusinessChartBuffer."Chart Type"::Column);
                    end;
                end else
                    SeriesIndex := SeriesIndexes.Get(ProductName);
                MonthIndex := (Date2DMY(Loans."Application Date", 3) - Date2DMY(ChartStart, 3)) * 12 +
                    Date2DMY(Loans."Application Date", 2) - Date2DMY(ChartStart, 2) + 1;
                CountKey := Format(SeriesIndex) + '/' + Format(MonthIndex);
                if Counts.Get(CountKey, CountValue) then
                    Counts.Set(CountKey, CountValue + 1)
                else
                    Counts.Add(CountKey, 1);
            until Loans.Next() = 0;

        CurrentPeriod := ChartStart;
        for MonthIndex := 1 to 12 do begin
            PeriodStarts[MonthIndex] := CurrentPeriod;
            PeriodEnds[MonthIndex] := CalcDate('<CM>', CurrentPeriod);
            if PeriodEnds[MonthIndex] > AsAtDate then
                PeriodEnds[MonthIndex] := AsAtDate;
            PeriodCaption := Format(CurrentPeriod, 0, '<Month Text,3> <Year4>');
            if MonthIndex = 12 then
                PeriodCaption += ' (incomplete)';
            BusinessChartBuffer.AddColumn(PeriodCaption);
            for SeriesIndex := 1 to SeriesNames.Count() do begin
                CountKey := Format(SeriesIndex) + '/' + Format(MonthIndex);
                if not Counts.Get(CountKey, CountValue) then
                    CountValue := 0;
                BusinessChartBuffer.SetValueByIndex(SeriesIndex - 1, MonthIndex - 1, CountValue);
            end;
            CurrentPeriod := CalcDate('<1M>', CurrentPeriod);
        end;
        BusinessChartBuffer.UpdateChart(CurrPage.Chart);
    end;

    local procedure GetProductDescription(Loan: Record "Loans Register"): Text
    var
        Product: Record "Loan Products Setup";
    begin
        if StrLen(Loan."Loan Product Type") <= MaxStrLen(Product.Code) then
            if Product.Get(Loan."Loan Product Type") then
                if Product."Product Description" <> '' then
                    exit(Product."Product Description");
        if Loan."Loan Product Type Name" <> '' then
            exit(Loan."Loan Product Type Name");
        if Loan."Loan Product Type" = '' then
            exit('Unspecified product');
        exit('Unknown product');
    end;

    var
        BusinessChartBuffer: Record "Business Chart Buffer" temporary;
        SeriesProductFilters: List of [Text];
        PeriodStarts: array[12] of Date;
        PeriodEnds: array[12] of Date;
}
