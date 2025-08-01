namespace KRBERPSourceCode.KRBERPSourceCode;

using System.Integration;
using Microsoft.Finance.GeneralLedger.Ledger;
using System.Visualization;
using Microsoft.Sales.Receivables;
using Microsoft.Finance.GeneralLedger.Account;

page 59060 "Loan Performance Chart"
{
    ApplicationArea = All;
    Caption = 'Interest Earned Trend';
    PageType = Card;

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
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(RefreshChart)
            {
                ApplicationArea = All;
                Caption = 'Refresh';
                Image = Refresh;
                ToolTip = 'Refresh the interest earned trend chart';

                trigger OnAction()
                begin
                    LoadAndDisplayChart();
                end;
            }

            action(ViewPeriod)
            {
                ApplicationArea = All;
                Caption = 'Change Period';
                Image = Period;
                ToolTip = 'Change the time period for the chart';

                trigger OnAction()
                begin
                    if PAGE.RunModal(PAGE::"Chart Period Selection") = ACTION::OK then
                        LoadAndDisplayChart();
                end;
            }

            action(ToggleScaling)
            {
                ApplicationArea = All;
                Caption = 'Toggle Scaling';
                Image = SetupLines;
                ToolTip = 'Switch between logarithmic and linear scaling';

                trigger OnAction()
                begin
                    UseLogarithmicScale := not UseLogarithmicScale;
                    LoadAndDisplayChart();
                end;
            }

            action(SeparateHighValue)
            {
                ApplicationArea = All;
                Caption = 'Separate High Values';
                Image = Split;
                ToolTip = 'Show high-value accounts separately';

                trigger OnAction()
                begin
                    SeparateHighValueAccounts := not SeparateHighValueAccounts;
                    LoadAndDisplayChart();
                end;
            }
        }
    }

    local procedure LoadAndDisplayChart()
    var
        GLEntry: Record "G/L Entry";
        GLAccount: Record "G/L Account";
        CustLedEntry: Record "Cust. Ledger Entry";
        BusinessChartBuffer: Record "Business Chart Buffer" temporary;
        PeriodStart: Date;
        PeriodEnd: Date;
        CurrentPeriod: Date;
        ChartEndDate: Date;
        InterestAmount: Decimal;
        CumulativeAmount: Decimal;
        PeriodText: Text[30];
        ColumnIndex: Integer;
        MeasureIndex: Integer;
        AccountNo: Code[20];
        MaxValue: Decimal;
        MinValue: Decimal;
        AccountValues: array[50] of Decimal; // Store max values per account
        AccountCodes: array[50] of Code[20];
        AccountCount: Integer;
        i: Integer;
        ScaledValue: Decimal;
        HighValueThreshold: Decimal;
    begin
        // Clear any existing data
        BusinessChartBuffer.Reset();
        BusinessChartBuffer.DeleteAll();

        // Initialize the business chart buffer
        BusinessChartBuffer.Initialize();

        // Set chart type to line chart for trend analysis
        BusinessChartBuffer."Chart Type" := BusinessChartBuffer."Chart Type"::Line;

        BusinessChartBuffer.SetXAxis('Period', BusinessChartBuffer."Data Type"::String);

        // First, analyze the data to determine scaling approach
        MaxValue := 0;
        MinValue := 999999999;
        AccountCount := 0;
        HighValueThreshold := 3000000; // 3M threshold

        GLAccount.Reset();
        GLAccount.SetFilter("No.", '4101..4110 & <>4107 & <>4109');

        if GLAccount.FindSet() then begin
            repeat
                AccountCount += 1;
                AccountCodes[AccountCount] := GLAccount."No.";

                // Calculate max value for this account
                GLEntry.Reset();
                GLEntry.SetRange("Posting Date", DMY2Date(1, 1, 2025), CalcDate('<CM>', Today()));
                GLEntry.SetRange("G/L Account No.", GLAccount."No.");
                GLEntry.SetRange(Reversed, false);
                GLEntry.SetFilter("Credit Amount", '>0');

                CumulativeAmount := 0;
                if GLEntry.FindSet() then begin
                    repeat
                        CumulativeAmount += GLEntry."Credit Amount";
                    until GLEntry.Next() = 0;
                end;

                AccountValues[AccountCount] := CumulativeAmount;
                if CumulativeAmount > MaxValue then
                    MaxValue := CumulativeAmount;
                if (CumulativeAmount < MinValue) and (CumulativeAmount > 0) then
                    MinValue := CumulativeAmount;

            until GLAccount.Next() = 0;
        end;

        // Add measures based on scaling option
        MeasureIndex := 0;
        for i := 1 to AccountCount do begin
            GLAccount.Get(AccountCodes[i]);

            // Only add measure if account should be included
            if not (SeparateHighValueAccounts and (AccountValues[i] > HighValueThreshold)) then begin
                if not (SeparateHighValueAccounts and (AccountValues[i] <= HighValueThreshold) and
                       (MaxValue > HighValueThreshold) and ShowHighValuesOnly) then begin
                    BusinessChartBuffer.AddMeasure(GLAccount."No." + ' - ' + GLAccount.Name,
                                                 MeasureIndex,
                                                 BusinessChartBuffer."Data Type"::Decimal,
                                                 BusinessChartBuffer."Chart Type"::Line);
                    MeasureIndex += 1;
                end;
            end;
        end;

        // Set up period parameters
        ChartEndDate := CalcDate('<CM>', Today());
        CurrentPeriod := DMY2Date(1, 1, 2025);

        ColumnIndex := 0;

        // Add all column labels (time periods)
        while CurrentPeriod <= ChartEndDate do begin
            PeriodText := Format(CurrentPeriod, 0, '<Month Text,3> <Year4>');
            BusinessChartBuffer.AddColumn(PeriodText);
            CurrentPeriod := CalcDate('<1M>', CurrentPeriod);
            ColumnIndex += 1;
        end;

        // Add data for each account and each period
        MeasureIndex := 0;
        for i := 1 to AccountCount do begin
            AccountNo := AccountCodes[i];

            // Only process if account should be included (same logic as above)
            if not (SeparateHighValueAccounts and (AccountValues[i] > HighValueThreshold)) then begin
                if not (SeparateHighValueAccounts and (AccountValues[i] <= HighValueThreshold) and
                       (MaxValue > HighValueThreshold) and ShowHighValuesOnly) then begin

                    CurrentPeriod := DMY2Date(1, 1, 2025);
                    ColumnIndex := 0;
                    CumulativeAmount := 0;

                    while CurrentPeriod <= ChartEndDate do begin
                        Clear(InterestAmount);

                        PeriodStart := CalcDate('<-CM>', CurrentPeriod);
                        PeriodEnd := CalcDate('<CM>', CurrentPeriod);

                        GLEntry.Reset();
                        GLEntry.SetRange("Posting Date", PeriodStart, PeriodEnd);
                        GLEntry.SetRange("G/L Account No.", AccountNo);
                        GLEntry.SetRange(Reversed, false);
                        GLEntry.SetFilter("Credit Amount", '>0');

                        if GLEntry.FindSet() then begin
                            repeat
                                InterestAmount += GLEntry."Credit Amount";
                            until GLEntry.Next() = 0;
                        end;

                        CumulativeAmount += InterestAmount;

                        // Apply scaling transformation
                        if UseLogarithmicScale and (CumulativeAmount > 0) then begin
                            // Logarithmic scaling: log10(value + 1) to handle zero values
                            ScaledValue := Log10(CumulativeAmount + 1) * 1000000; // Scale up for visibility
                        end else if UsePercentageScale then begin
                            // Percentage of maximum value
                            if MaxValue > 0 then
                                ScaledValue := (CumulativeAmount / MaxValue) * 100
                            else
                                ScaledValue := 0;
                        end else begin
                            // Original value
                            ScaledValue := CumulativeAmount;
                        end;

                        BusinessChartBuffer.SetValueByIndex(MeasureIndex, ColumnIndex, ScaledValue);

                        CurrentPeriod := CalcDate('<1M>', CurrentPeriod);
                        ColumnIndex += 1;
                    end;

                    MeasureIndex += 1;
                end;
            end;
        end;

        // Update the chart control
        BusinessChartBuffer.Update(CurrPage.Chart);
    end;

    // Helper function for logarithm calculation
    local procedure Log10(Value: Decimal): Decimal
    var
        Result: Decimal;
        TempValue: Decimal;
        Counter: Integer;
    begin
        if Value <= 0 then
            exit(0);

        TempValue := Value;
        Counter := 0;

        // Simple log10 approximation
        while TempValue >= 10 do begin
            TempValue := TempValue / 10;
            Counter += 1;
        end;

        Result := Counter + (TempValue - 1) / 10; // Rough approximation
        exit(Result);
    end;

    var
        ChartPeriodStartDate: Date;
        ChartPeriodEndDate: Date;
        UseLogarithmicScale: Boolean;
        UsePercentageScale: Boolean;
        SeparateHighValueAccounts: Boolean;
        ShowHighValuesOnly: Boolean;
}

// Enhanced helper page for period selection
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