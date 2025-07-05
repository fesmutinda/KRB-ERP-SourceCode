report 59099 "Multi-Period Variance Report"
{
    ApplicationArea = All;
    Caption = 'Multi-Period Variance Report';
    UsageCategory = ReportsAndAnalysis;
    RDLCLayout = './Layouts/MultiPeriodVariance.rdlc';

    dataset
    {
        dataitem(GLAccount; "G/L Account")
        {
            DataItemTableView = sorting("No.") where(Blocked = filter(false));
            RequestFilterFields = "No.", "Account Type", "Global Dimension 1 Filter", "Global Dimension 2 Filter";

            column(AccountNo; "No.") { }
            column(AccountName; Name) { }
            column(AccountType; "Account Type") { }
            column(IncomeBalance; "Income/Balance") { }
            column(AccountCategory; "Account Category") { }
            column(DisplayName; GetDisplayName("No.", Name, "Account Type", Indentation)) { }
            column(LevelNo; GetLevelNo("No.", "Account Type")) { }

            // Period 1 (Base/Current Period)
            column(Period1Balance; Period1Balance) { }
            column(Period1NetChange; Period1NetChange) { }
            column(Period1Label; Period1Label) { }

            // Period 2 (Comparison Period)
            column(Period2Balance; Period2Balance) { }
            column(Period2NetChange; Period2NetChange) { }
            column(Period2Label; Period2Label) { }

            // Period 3 (Optional third period)
            column(Period3Balance; Period3Balance) { }
            column(Period3NetChange; Period3NetChange) { }
            column(Period3Label; Period3Label) { }

            // Variance Calculations
            column(VarianceAmount; VarianceAmount) { }
            column(VariancePercent; VariancePercent) { }
            column(Variance2Amount; Variance2Amount) { }
            column(Variance2Percent; Variance2Percent) { }

            // Monthly Breakdown Columns
            column(Month1Balance; Month1Balance) { }
            column(Month2Balance; Month2Balance) { }
            column(Month3Balance; Month3Balance) { }
            column(Month4Balance; Month4Balance) { }
            column(Month5Balance; Month5Balance) { }
            column(Month6Balance; Month6Balance) { }
            column(Month7Balance; Month7Balance) { }
            column(Month8Balance; Month8Balance) { }
            column(Month9Balance; Month9Balance) { }
            column(Month10Balance; Month10Balance) { }
            column(Month11Balance; Month11Balance) { }
            column(Month12Balance; Month12Balance) { }

            // Monthly Labels
            column(Month1Label; Month1Label) { }
            column(Month2Label; Month2Label) { }
            column(Month3Label; Month3Label) { }
            column(Month4Label; Month4Label) { }
            column(Month5Label; Month5Label) { }
            column(Month6Label; Month6Label) { }
            column(Month7Label; Month7Label) { }
            column(Month8Label; Month8Label) { }
            column(Month9Label; Month9Label) { }
            column(Month10Label; Month10Label) { }
            column(Month11Label; Month11Label) { }
            column(Month12Label; Month12Label) { }

            // Quarterly Breakdown Columns
            column(Q1Balance; Q1Balance) { }
            column(Q2Balance; Q2Balance) { }
            column(Q3Balance; Q3Balance) { }
            column(Q4Balance; Q4Balance) { }
            column(Q1Label; Q1Label) { }
            column(Q2Label; Q2Label) { }
            column(Q3Label; Q3Label) { }
            column(Q4Label; Q4Label) { }

            // Yearly Breakdown Columns
            column(Year1Balance; Year1Balance) { }
            column(Year2Balance; Year2Balance) { }
            column(Year3Balance; Year3Balance) { }
            column(Year1Label; Year1Label) { }
            column(Year2Label; Year2Label) { }
            column(Year3Label; Year3Label) { }

            // Company Information
            column(CompanyName; Company.Name) { }
            column(CompanyAddress; Company.Address) { }
            column(CompanyAddress2; Company."Address 2") { }
            column(CompanyPhoneNo; Company."Phone No.") { }
            column(CompanyEmail; Company."E-Mail") { }
            column(CompanyPicture; Company.Picture) { }

            // Report Parameters
            column(ReportTitle; ReportTitle) { }
            column(ComparisonType; Format(ComparisonType)) { }
            column(ShowVarianceOnly; ShowVarianceOnly) { }
            column(ShowPercentages; ShowPercentages) { }
            column(ShowMonthlyBreakdown; ShowMonthlyBreakdown) { }
            column(ShowQuarterlyBreakdown; ShowQuarterlyBreakdown) { }
            column(ShowYearlyBreakdown; ShowYearlyBreakdown) { }

            trigger OnPreDataItem()
            begin
                // Apply filters based on report type
                case ReportType of
                    ReportType::"Trial Balance":
                        begin
                            // No additional filter needed for trial balance
                            ReportTitle := 'Trial Balance Variance Report';
                        end;
                    ReportType::"Income Statement":
                        begin
                            SetRange("Income/Balance", "Income/Balance"::"Income Statement");
                            ReportTitle := 'Income Statement Variance Report';
                        end;
                    ReportType::"Balance Sheet":
                        begin
                            SetRange("Income/Balance", "Income/Balance"::"Balance Sheet");
                            ReportTitle := 'Balance Sheet Variance Report';
                        end;
                end;

                // Build period labels
                BuildPeriodLabels();

                // Build breakdown period labels if enabled
                if ShowMonthlyBreakdown then
                    BuildMonthlyLabels();
                if ShowQuarterlyBreakdown then
                    BuildQuarterlyLabels();
                if ShowYearlyBreakdown then
                    BuildYearlyLabels();
            end;

            trigger OnAfterGetRecord()
            begin
                // Calculate balances for each period
                CalculatePeriodBalances();

                // Calculate breakdown balances if enabled
                if ShowMonthlyBreakdown then
                    CalculateMonthlyBalances();
                if ShowQuarterlyBreakdown then
                    CalculateQuarterlyBalances();
                if ShowYearlyBreakdown then
                    CalculateYearlyBalances();

                // Calculate variances
                CalculateVariances();

                // Skip zero balances if requested
                if not ShowZeroBalances then begin
                    if (Period1Balance = 0) and (Period2Balance = 0) and (Period3Balance = 0) and
                       (Period1NetChange = 0) and (Period2NetChange = 0) and (Period3NetChange = 0) then
                        CurrReport.Skip();
                end;

                // Skip non-variance records if requested
                if ShowVarianceOnly then begin
                    if (VarianceAmount = 0) and (Variance2Amount = 0) then
                        CurrReport.Skip();
                end;
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(ReportOptions)
                {
                    Caption = 'Report Options';

                    field(ReportType; ReportType)
                    {
                        ApplicationArea = All;
                        Caption = 'Report Type';
                        ToolTip = 'Select the type of financial report to compare';
                    }

                    field(ComparisonType; ComparisonType)
                    {
                        ApplicationArea = All;
                        Caption = 'Comparison Type';
                        ToolTip = 'Select what type of period comparison to perform';
                    }
                }

                group(Period1)
                {
                    Caption = 'Current Period';

                    field(Period1StartDate; Period1StartDate)
                    {
                        ApplicationArea = All;
                        Caption = 'Start Date';
                        trigger OnValidate()
                        begin
                            ValidatePeriodDates();
                        end;
                    }

                    field(Period1EndDate; Period1EndDate)
                    {
                        ApplicationArea = All;
                        Caption = 'End Date';
                        trigger OnValidate()
                        begin
                            ValidatePeriodDates();
                        end;
                    }
                }

                group(Period2)
                {
                    Caption = 'Comparison Period';

                    field(Period2StartDate; Period2StartDate)
                    {
                        ApplicationArea = All;
                        Caption = 'Start Date';
                        trigger OnValidate()
                        begin
                            ValidatePeriodDates();
                        end;
                    }

                    field(Period2EndDate; Period2EndDate)
                    {
                        ApplicationArea = All;
                        Caption = 'End Date';
                        trigger OnValidate()
                        begin
                            ValidatePeriodDates();
                        end;
                    }
                }

                group(Period3)
                {
                    Caption = 'Third Period (Optional)';

                    field(EnableThirdPeriod; EnableThirdPeriod)
                    {
                        ApplicationArea = All;
                        Caption = 'Enable Third Period';
                    }

                    field(Period3StartDate; Period3StartDate)
                    {
                        ApplicationArea = All;
                        Caption = 'Start Date';
                        Enabled = EnableThirdPeriod;
                    }

                    field(Period3EndDate; Period3EndDate)
                    {
                        ApplicationArea = All;
                        Caption = 'End Date';
                        Enabled = EnableThirdPeriod;
                    }
                }

                group(BreakdownOptions)
                {
                    Caption = 'Trial Balance Breakdown Options';

                    field(ShowMonthlyBreakdown; ShowMonthlyBreakdown)
                    {
                        ApplicationArea = All;
                        Caption = 'Show Monthly Breakdown';
                        ToolTip = 'Display trial balance data broken down by months';
                    }

                    field(ShowQuarterlyBreakdown; ShowQuarterlyBreakdown)
                    {
                        ApplicationArea = All;
                        Caption = 'Show Quarterly Breakdown';
                        ToolTip = 'Display trial balance data broken down by quarters';
                    }

                    field(ShowYearlyBreakdown; ShowYearlyBreakdown)
                    {
                        ApplicationArea = All;
                        Caption = 'Show Yearly Breakdown';
                        ToolTip = 'Display trial balance data broken down by years';
                    }

                    field(BreakdownBaseYear; BreakdownBaseYear)
                    {
                        ApplicationArea = All;
                        Caption = 'Breakdown Base Year';
                        ToolTip = 'Base year for generating breakdown periods';
                    }
                }

                group(DisplayOptions)
                {
                    Caption = 'Display Options';

                    field(ShowZeroBalances; ShowZeroBalances)
                    {
                        ApplicationArea = All;
                        Caption = 'Show Accounts With No Balances';
                    }

                    field(ShowVarianceOnly; ShowVarianceOnly)
                    {
                        ApplicationArea = All;
                        Caption = 'Show Only Accounts With Variances';
                    }

                    field(ShowPercentages; ShowPercentages)
                    {
                        ApplicationArea = All;
                        Caption = 'Show Percentage Variances';
                    }

                    field(MinimumVarianceAmount; MinimumVarianceAmount)
                    {
                        ApplicationArea = All;
                        Caption = 'Minimum Variance Amount';
                        ToolTip = 'Only show variances above this amount';
                    }
                }

                group(QuickPeriods)
                {
                    Caption = 'Quick Period Selection';

                    field(QuickPeriodType; QuickPeriodType)
                    {
                        ApplicationArea = All;
                        Caption = 'Quick Period Type';
                        ToolTip = 'Select a predefined period comparison';

                        trigger OnValidate()
                        begin
                            SetQuickPeriods();
                        end;
                    }

                    field(BaseYear; BaseYear)
                    {
                        ApplicationArea = All;
                        Caption = 'Base Year';
                        ToolTip = 'Year to use for quick period calculations';

                        trigger OnValidate()
                        begin
                            if QuickPeriodType <> QuickPeriodType::Custom then
                                SetQuickPeriods();
                        end;
                    }
                }
            }
        }
    }

    var
        Company: Record "Company Information";

        // Period dates
        Period1StartDate: Date;
        Period1EndDate: Date;
        Period2StartDate: Date;
        Period2EndDate: Date;
        Period3StartDate: Date;
        Period3EndDate: Date;

        // Period labels
        Period1Label: Text[50];
        Period2Label: Text[50];
        Period3Label: Text[50];

        // Calculated values
        Period1Balance: Decimal;
        Period1NetChange: Decimal;
        Period2Balance: Decimal;
        Period2NetChange: Decimal;
        Period3Balance: Decimal;
        Period3NetChange: Decimal;

        // Variance calculations
        VarianceAmount: Decimal;
        VariancePercent: Decimal;
        Variance2Amount: Decimal;
        Variance2Percent: Decimal;

        // Monthly breakdown variables
        Month1Balance: Decimal;
        Month2Balance: Decimal;
        Month3Balance: Decimal;
        Month4Balance: Decimal;
        Month5Balance: Decimal;
        Month6Balance: Decimal;
        Month7Balance: Decimal;
        Month8Balance: Decimal;
        Month9Balance: Decimal;
        Month10Balance: Decimal;
        Month11Balance: Decimal;
        Month12Balance: Decimal;

        // Monthly labels
        Month1Label: Text[20];
        Month2Label: Text[20];
        Month3Label: Text[20];
        Month4Label: Text[20];
        Month5Label: Text[20];
        Month6Label: Text[20];
        Month7Label: Text[20];
        Month8Label: Text[20];
        Month9Label: Text[20];
        Month10Label: Text[20];
        Month11Label: Text[20];
        Month12Label: Text[20];

        // Quarterly breakdown variables
        Q1Balance: Decimal;
        Q2Balance: Decimal;
        Q3Balance: Decimal;
        Q4Balance: Decimal;
        Q1Label: Text[20];
        Q2Label: Text[20];
        Q3Label: Text[20];
        Q4Label: Text[20];

        // Yearly breakdown variables
        Year1Balance: Decimal;
        Year2Balance: Decimal;
        Year3Balance: Decimal;
        Year1Label: Text[20];
        Year2Label: Text[20];
        Year3Label: Text[20];

        // Options
        ReportType: Enum "Variance Report Type";
        ComparisonType: Enum "Comparison Type";
        QuickPeriodType: Enum "Quick Period Type";
        ShowZeroBalances: Boolean;
        ShowVarianceOnly: Boolean;
        ShowPercentages: Boolean;
        EnableThirdPeriod: Boolean;
        ShowMonthlyBreakdown: Boolean;
        ShowQuarterlyBreakdown: Boolean;
        ShowYearlyBreakdown: Boolean;
        MinimumVarianceAmount: Decimal;
        BaseYear: Integer;
        BreakdownBaseYear: Integer;
        ReportTitle: Text[100];

    trigger OnPreReport()
    begin
        Company.Get();
        Company.CalcFields(Company.Picture);

        // Set default dates if not specified
        if Period1EndDate = 0D then
            Period1EndDate := WorkDate();

        if Period1StartDate = 0D then
            Period1StartDate := CalcDate('<-CY>', Period1EndDate);

        // Validate required fields-
        if (Period1StartDate = 0D) or (Period1EndDate = 0D) or
           (Period2StartDate = 0D) or (Period2EndDate = 0D) then
            Error('Please specify valid date ranges for both periods.');

        if BaseYear = 0 then
            BaseYear := Date2DMY(WorkDate(), 3);

        if BreakdownBaseYear = 0 then
            BreakdownBaseYear := Date2DMY(WorkDate(), 3);
    end;

    local procedure CalculatePeriodBalances()
    var
        TempGLAccount: Record "G/L Account";
    begin
        // Period 1 calculations
        TempGLAccount := GLAccount;
        TempGLAccount.SetRange("Date Filter", Period1StartDate, Period1EndDate);
        TempGLAccount.CalcFields("Net Change", "Balance at Date");
        Period1NetChange := TempGLAccount."Net Change";
        Period1Balance := TempGLAccount."Balance at Date";

        // Period 2 calculations
        TempGLAccount := GLAccount;
        TempGLAccount.SetRange("Date Filter", Period2StartDate, Period2EndDate);
        TempGLAccount.CalcFields("Net Change", "Balance at Date");
        Period2NetChange := TempGLAccount."Net Change";
        Period2Balance := TempGLAccount."Balance at Date";

        // Period 3 calculations (if enabled)
        if EnableThirdPeriod then begin
            TempGLAccount := GLAccount;
            TempGLAccount.SetRange("Date Filter", Period3StartDate, Period3EndDate);
            TempGLAccount.CalcFields("Net Change", "Balance at Date");
            Period3NetChange := TempGLAccount."Net Change";
            Period3Balance := TempGLAccount."Balance at Date";
        end else begin
            Period3NetChange := 0;
            Period3Balance := 0;
        end;
    end;

    local procedure CalculateMonthlyBalances()
    var
        TempGLAccount: Record "G/L Account";
        MonthStartDate: Date;
        MonthEndDate: Date;
        i: Integer;
    begin
        // Calculate balance for each month of the breakdown base year
        for i := 1 to 12 do begin
            MonthStartDate := DMY2Date(1, i, BreakdownBaseYear);
            MonthEndDate := CalcDate('<CM>', MonthStartDate);

            TempGLAccount := GLAccount;
            TempGLAccount.SetRange("Date Filter", MonthStartDate, MonthEndDate);
            TempGLAccount.CalcFields("Balance at Date");

            case i of
                1:
                    Month1Balance := TempGLAccount."Balance at Date";
                2:
                    Month2Balance := TempGLAccount."Balance at Date";
                3:
                    Month3Balance := TempGLAccount."Balance at Date";
                4:
                    Month4Balance := TempGLAccount."Balance at Date";
                5:
                    Month5Balance := TempGLAccount."Balance at Date";
                6:
                    Month6Balance := TempGLAccount."Balance at Date";
                7:
                    Month7Balance := TempGLAccount."Balance at Date";
                8:
                    Month8Balance := TempGLAccount."Balance at Date";
                9:
                    Month9Balance := TempGLAccount."Balance at Date";
                10:
                    Month10Balance := TempGLAccount."Balance at Date";
                11:
                    Month11Balance := TempGLAccount."Balance at Date";
                12:
                    Month12Balance := TempGLAccount."Balance at Date";
            end;
        end;
    end;

    local procedure CalculateQuarterlyBalances()
    var
        TempGLAccount: Record "G/L Account";
        QuarterStartDate: Date;
        QuarterEndDate: Date;
    begin
        // Q1 (Jan-Mar)
        QuarterStartDate := DMY2Date(1, 1, BreakdownBaseYear);
        QuarterEndDate := DMY2Date(31, 3, BreakdownBaseYear);
        TempGLAccount := GLAccount;
        TempGLAccount.SetRange("Date Filter", QuarterStartDate, QuarterEndDate);
        TempGLAccount.CalcFields("Balance at Date");
        Q1Balance := TempGLAccount."Balance at Date";

        // Q2 (Apr-Jun)
        QuarterStartDate := DMY2Date(1, 4, BreakdownBaseYear);
        QuarterEndDate := DMY2Date(30, 6, BreakdownBaseYear);
        TempGLAccount := GLAccount;
        TempGLAccount.SetRange("Date Filter", QuarterStartDate, QuarterEndDate);
        TempGLAccount.CalcFields("Balance at Date");
        Q2Balance := TempGLAccount."Balance at Date";

        // Q3 (Jul-Sep)
        QuarterStartDate := DMY2Date(1, 7, BreakdownBaseYear);
        QuarterEndDate := DMY2Date(30, 9, BreakdownBaseYear);
        TempGLAccount := GLAccount;
        TempGLAccount.SetRange("Date Filter", QuarterStartDate, QuarterEndDate);
        TempGLAccount.CalcFields("Balance at Date");
        Q3Balance := TempGLAccount."Balance at Date";

        // Q4 (Oct-Dec)
        QuarterStartDate := DMY2Date(1, 10, BreakdownBaseYear);
        QuarterEndDate := DMY2Date(31, 12, BreakdownBaseYear);
        TempGLAccount := GLAccount;
        TempGLAccount.SetRange("Date Filter", QuarterStartDate, QuarterEndDate);
        TempGLAccount.CalcFields("Balance at Date");
        Q4Balance := TempGLAccount."Balance at Date";
    end;

    local procedure CalculateYearlyBalances()
    var
        TempGLAccount: Record "G/L Account";
        YearStartDate: Date;
        YearEndDate: Date;
        i: Integer;
    begin
        // Calculate balance for 3 consecutive years
        for i := 0 to 2 do begin
            YearStartDate := DMY2Date(1, 1, BreakdownBaseYear - i);
            YearEndDate := DMY2Date(31, 12, BreakdownBaseYear - i);

            TempGLAccount := GLAccount;
            TempGLAccount.SetRange("Date Filter", YearStartDate, YearEndDate);
            TempGLAccount.CalcFields("Balance at Date");

            case i of
                0:
                    Year1Balance := TempGLAccount."Balance at Date";
                1:
                    Year2Balance := TempGLAccount."Balance at Date";
                2:
                    Year3Balance := TempGLAccount."Balance at Date";
            end;
        end;
    end;

    local procedure BuildMonthlyLabels()
    var
        MonthNames: array[12] of Text[10];
    begin
        MonthNames[1] := 'Jan';
        MonthNames[2] := 'Feb';
        MonthNames[3] := 'Mar';
        MonthNames[4] := 'Apr';
        MonthNames[5] := 'May';
        MonthNames[6] := 'Jun';
        MonthNames[7] := 'Jul';
        MonthNames[8] := 'Aug';
        MonthNames[9] := 'Sep';
        MonthNames[10] := 'Oct';
        MonthNames[11] := 'Nov';
        MonthNames[12] := 'Dec';

        Month1Label := MonthNames[1] + ' ' + Format(BreakdownBaseYear);
        Month2Label := MonthNames[2] + ' ' + Format(BreakdownBaseYear);
        Month3Label := MonthNames[3] + ' ' + Format(BreakdownBaseYear);
        Month4Label := MonthNames[4] + ' ' + Format(BreakdownBaseYear);
        Month5Label := MonthNames[5] + ' ' + Format(BreakdownBaseYear);
        Month6Label := MonthNames[6] + ' ' + Format(BreakdownBaseYear);
        Month7Label := MonthNames[7] + ' ' + Format(BreakdownBaseYear);
        Month8Label := MonthNames[8] + ' ' + Format(BreakdownBaseYear);
        Month9Label := MonthNames[9] + ' ' + Format(BreakdownBaseYear);
        Month10Label := MonthNames[10] + ' ' + Format(BreakdownBaseYear);
        Month11Label := MonthNames[11] + ' ' + Format(BreakdownBaseYear);
        Month12Label := MonthNames[12] + ' ' + Format(BreakdownBaseYear);
    end;

    local procedure BuildQuarterlyLabels()
    begin
        Q1Label := 'Q1 ' + Format(BreakdownBaseYear);
        Q2Label := 'Q2 ' + Format(BreakdownBaseYear);
        Q3Label := 'Q3 ' + Format(BreakdownBaseYear);
        Q4Label := 'Q4 ' + Format(BreakdownBaseYear);
    end;

    local procedure BuildYearlyLabels()
    begin
        Year1Label := Format(BreakdownBaseYear);
        Year2Label := Format(BreakdownBaseYear - 1);
        Year3Label := Format(BreakdownBaseYear - 2);
    end;

    local procedure CalculateVariances()
    begin
        // Primary variance (Period 1 vs Period 2)
        case ComparisonType of
            ComparisonType::"Net Change":
                begin
                    VarianceAmount := Period1NetChange - Period2NetChange;
                    if Period2NetChange <> 0 then
                        VariancePercent := (VarianceAmount / Abs(Period2NetChange)) * 100
                    else
                        VariancePercent := 0;
                end;
            ComparisonType::"Balance":
                begin
                    VarianceAmount := Period1Balance - Period2Balance;
                    if Period2Balance <> 0 then
                        VariancePercent := (VarianceAmount / Abs(Period2Balance)) * 100
                    else
                        VariancePercent := 0;
                end;
        end;

        // Secondary variance (Period 1 vs Period 3, if enabled)
        if EnableThirdPeriod then begin
            case ComparisonType of
                ComparisonType::"Net Change":
                    begin
                        Variance2Amount := Period1NetChange - Period3NetChange;
                        if Period3NetChange <> 0 then
                            Variance2Percent := (Variance2Amount / Abs(Period3NetChange)) * 100
                        else
                            Variance2Percent := 0;
                    end;
                ComparisonType::"Balance":
                    begin
                        Variance2Amount := Period1Balance - Period3Balance;
                        if Period3Balance <> 0 then
                            Variance2Percent := (Variance2Amount / Abs(Period3Balance)) * 100
                        else
                            Variance2Percent := 0;
                    end;
            end;
        end else begin
            Variance2Amount := 0;
            Variance2Percent := 0;
        end;

        // Apply minimum variance filter
        if MinimumVarianceAmount > 0 then begin
            if (Abs(VarianceAmount) < MinimumVarianceAmount) and
               (Abs(Variance2Amount) < MinimumVarianceAmount) then
                CurrReport.Skip();
        end;
    end;

    local procedure BuildPeriodLabels()
    begin
        Period1Label := StrSubstNo('%1 - %2',
            Format(Period1StartDate, 0, '<Day,2>/<Month,2>/<Year4>'),
            Format(Period1EndDate, 0, '<Day,2>/<Month,2>/<Year4>'));

        Period2Label := StrSubstNo('%1 - %2',
            Format(Period2StartDate, 0, '<Day,2>/<Month,2>/<Year4>'),
            Format(Period2EndDate, 0, '<Day,2>/<Month,2>/<Year4>'));

        if EnableThirdPeriod then
            Period3Label := StrSubstNo('%1 - %2',
                Format(Period3StartDate, 0, '<Day,2>/<Month,2>/<Year4>'),
                Format(Period3EndDate, 0, '<Day,2>/<Month,2>/<Year4>'))
        else
            Period3Label := '';
    end;

    local procedure SetQuickPeriods()
    begin
        case QuickPeriodType of
            QuickPeriodType::"Current Year vs Previous Year":
                begin
                    Period1StartDate := DMY2Date(1, 1, BaseYear);
                    Period1EndDate := DMY2Date(31, 12, BaseYear);
                    Period2StartDate := DMY2Date(1, 1, BaseYear - 1);
                    Period2EndDate := DMY2Date(31, 12, BaseYear - 1);
                end;
            QuickPeriodType::"Current Quarter vs Previous Quarter":
                begin
                    SetCurrentQuarter();
                    SetPreviousQuarter();
                end;
            QuickPeriodType::"Current Month vs Previous Month":
                begin
                    SetCurrentMonth();
                    SetPreviousMonth();
                end;
            QuickPeriodType::"YTD Current vs YTD Previous":
                begin
                    Period1StartDate := DMY2Date(1, 1, BaseYear);
                    Period1EndDate := WorkDate();
                    Period2StartDate := DMY2Date(1, 1, BaseYear - 1);
                    Period2EndDate := CalcDate('<-1Y>', WorkDate());
                end;
            QuickPeriodType::"Three Year Comparison":
                begin
                    EnableThirdPeriod := true;
                    Period1StartDate := DMY2Date(1, 1, BaseYear);
                    Period1EndDate := DMY2Date(31, 12, BaseYear);
                    Period2StartDate := DMY2Date(1, 1, BaseYear - 1);
                    Period2EndDate := DMY2Date(31, 12, BaseYear - 1);
                    Period3StartDate := DMY2Date(1, 1, BaseYear - 2);
                    Period3EndDate := DMY2Date(31, 12, BaseYear - 2);
                end;
        end;
    end;

    local procedure SetCurrentQuarter()
    var
        CurrentDate: Date;
        CurrentMonth: Integer;
        QuarterStartMonth: Integer;
    begin
        CurrentDate := WorkDate();
        CurrentMonth := Date2DMY(CurrentDate, 2);

        case CurrentMonth of
            1 .. 3:
                QuarterStartMonth := 1;
            4 .. 6:
                QuarterStartMonth := 4;
            7 .. 9:
                QuarterStartMonth := 7;
            10 .. 12:
                QuarterStartMonth := 10;
        end;

        Period1StartDate := DMY2Date(1, QuarterStartMonth, BaseYear);
        Period1EndDate := CalcDate('<+3M-1D>', Period1StartDate);
    end;

    local procedure SetPreviousQuarter()
    begin
        Period2StartDate := CalcDate('<-3M>', Period1StartDate);
        Period2EndDate := CalcDate('<-3M>', Period1EndDate);
    end;

    local procedure SetCurrentMonth()
    var
        CurrentDate: Date;
    begin
        CurrentDate := WorkDate();
        Period1StartDate := CalcDate('<-CM>', CurrentDate);
        Period1EndDate := CalcDate('<CM>', CurrentDate);
    end;

    local procedure SetPreviousMonth()
    begin
        Period2StartDate := CalcDate('<-1M-CM>', Period1StartDate);
        Period2EndDate := CalcDate('<-1M+CM>', Period1StartDate);
    end;

    local procedure ValidatePeriodDates()
    begin
        // Add validation logic for date ranges
        if (Period1StartDate <> 0D) and (Period1EndDate <> 0D) then
            if Period1StartDate > Period1EndDate then
                Error('Start date cannot be later than end date.');
    end;

    local procedure GetLevelNo(AccountNo: Code[20]; AccountType: Enum "G/L Account Type"): Integer
    begin
        // Reuse logic from original files
        case StrLen(AccountNo) of
            1:
                exit(1);
            2:
                exit(2);
            3:
                exit(3);
            4:
                exit(4);
            5:
                exit(4);
        end;
        exit(0);
    end;

    local procedure GetDisplayName(AccountNo: Code[20]; AccountName: Text; AccountType: Enum "G/L Account Type"; IndentationLevel: Integer): Text
    var
        Indent: Text;
    begin
        // Create indentation based on level
        case IndentationLevel of
            0:
                Indent := '';
            1:
                Indent := '    ';
            2:
                Indent := '        ';
            3:
                Indent := '            ';
            else
                Indent := '                ';
        end;

        exit(Indent + AccountName);
    end;
}

// Supporting Enums
enum 59055 "Variance Report Type"
{
    Extensible = true;

    value(0; "Trial Balance") { Caption = 'Trial Balance'; }
    value(1; "Income Statement") { Caption = 'Income Statement'; }
    value(2; "Balance Sheet") { Caption = 'Balance Sheet'; }
}

enum 59056 "Comparison Type"
{
    Extensible = true;

    value(0; "Net Change") { Caption = 'Net Change'; }
    value(1; "Balance") { Caption = 'Balance'; }
}

enum 59057 "Quick Period Type"
{
    Extensible = true;

    value(0; "Custom") { Caption = 'Custom Periods'; }
    value(1; "Current Year vs Previous Year") { Caption = 'Current Year vs Previous Year'; }
    value(2; "Current Quarter vs Previous Quarter") { Caption = 'Current Quarter vs Previous Quarter'; }
    value(3; "Current Month vs Previous Month") { Caption = 'Current Month vs Previous Month'; }
    value(4; "YTD Current vs YTD Previous") { Caption = 'YTD Current vs YTD Previous'; }
    value(5; "Three Year Comparison") { Caption = 'Three Year Comparison'; }
}