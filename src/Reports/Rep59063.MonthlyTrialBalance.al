#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 59063 "Monthly Trial Balance"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/MonthlyTrial Balance.rdlc';
    Caption = 'Monthly Trial Balance';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem("G/L Account"; "G/L Account")
        {
            DataItemTableView = sorting("No.") where(Blocked = filter(false));
            RequestFilterFields = "No.", "Account Type", "Date Filter", "Global Dimension 1 Filter", "Global Dimension 2 Filter";

            // Company info columns (unchanged)
            column(Company_Name; compyinfo.Name) { }
            column(AccountName; Name) { }
            column(Company_Address; compyinfo.Address) { }
            column(Company_Address_2; compyinfo."Address 2") { }
            column(Company_Phone_No; compyinfo."Phone No.") { }
            column(Company_Fax_No; compyinfo."Fax No.") { }
            column(Company_Picture; compyinfo.Picture) { }
            column(Company_Email; compyinfo."E-Mail") { }

            // General columns (unchanged)
            column(PeriodText; PeriodText) { }
            column(GLFilter; GLFilter) { }
            column(G_L_Account_No_; "No.") { }
            column(Trial_BalanceCaption; Trial_BalanceCaptionLbl) { }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl) { }
            column(Net_ChangeCaption; Net_ChangeCaptionLbl) { }
            column(Totaldebit; TotalDebit) { }
            column(Totalcredit; -Totalcredit) { }
            column(BalanceCaption; BalanceCaptionLbl) { }
            column(G_L_Account___No__Caption; FieldCaption("No.")) { }
            column(PADSTR_____G_L_Account__Indentation___2___G_L_Account__NameCaption; PADSTR_____G_L_Account__Indentation___2___G_L_Account__NameCaptionLbl) { }
            column(G_L_Account___Net_Change_Caption; G_L_Account___Net_Change_CaptionLbl) { }
            column(G_L_Account___Net_Change__Control22Caption; G_L_Account___Net_Change__Control22CaptionLbl) { }
            column(G_L_Account___Balance_at_Date_Caption; G_L_Account___Balance_at_Date_CaptionLbl) { }
            column(G_L_Account___Balance_at_Date__Control24Caption; G_L_Account___Balance_at_Date__Control24CaptionLbl) { }
            column(PageGroupNo; PageGroupNo) { }
            column(COMPANYPICTURE; compyinfo.Picture) { }

            // Monthly columns for Net Change and Balance at Date
            column(Jan_NetChange; MonthNetChange[1]) { Caption = 'Jan Net Change'; }
            column(Feb_NetChange; MonthNetChange[2]) { Caption = 'Feb Net Change'; }
            column(Mar_NetChange; MonthNetChange[3]) { Caption = 'Mar Net Change'; }
            column(Apr_NetChange; MonthNetChange[4]) { Caption = 'Apr Net Change'; }
            column(May_NetChange; MonthNetChange[5]) { Caption = 'May Net Change'; }
            column(Jun_NetChange; MonthNetChange[6]) { Caption = 'Jun Net Change'; }
            column(Jul_NetChange; MonthNetChange[7]) { Caption = 'Jul Net Change'; }
            column(Aug_NetChange; MonthNetChange[8]) { Caption = 'Aug Net Change'; }
            column(Sep_NetChange; MonthNetChange[9]) { Caption = 'Sep Net Change'; }
            column(Oct_NetChange; MonthNetChange[10]) { Caption = 'Oct Net Change'; }
            column(Nov_NetChange; MonthNetChange[11]) { Caption = 'Nov Net Change'; }
            column(Dec_NetChange; MonthNetChange[12]) { Caption = 'Dec Net Change'; }

            column(Jan_Balance; MonthBalance[1]) { Caption = 'Jan Balance'; }
            column(Feb_Balance; MonthBalance[2]) { Caption = 'Feb Balance'; }
            column(Mar_Balance; MonthBalance[3]) { Caption = 'Mar Balance'; }
            column(Apr_Balance; MonthBalance[4]) { Caption = 'Apr Balance'; }
            column(May_Balance; MonthBalance[5]) { Caption = 'May Balance'; }
            column(Jun_Balance; MonthBalance[6]) { Caption = 'Jun Balance'; }
            column(Jul_Balance; MonthBalance[7]) { Caption = 'Jul Balance'; }
            column(Aug_Balance; MonthBalance[8]) { Caption = 'Aug Balance'; }
            column(Sep_Balance; MonthBalance[9]) { Caption = 'Sep Balance'; }
            column(Oct_Balance; MonthBalance[10]) { Caption = 'Oct Balance'; }
            column(Nov_Balance; MonthBalance[11]) { Caption = 'Nov Balance'; }
            column(Dec_Balance; MonthBalance[12]) { Caption = 'Dec Balance'; }

            dataitem("Integer"; "Integer")
            {
                DataItemTableView = sorting(Number) where(Number = const(99));

                column(Total_Jan_NetChange; GrandMonthNetChange[1]) { Caption = 'Total Jan Net Change'; }
                column(Total_Feb_NetChange; GrandMonthNetChange[2]) { Caption = 'Total Feb Net Change'; }
                column(Total_Mar_NetChange; GrandMonthNetChange[3]) { Caption = 'Total Mar Net Change'; }
                column(Total_Apr_NetChange; GrandMonthNetChange[4]) { Caption = 'Total Apr Net Change'; }
                column(Total_May_NetChange; GrandMonthNetChange[5]) { Caption = 'Total May Net Change'; }
                column(Total_Jun_NetChange; GrandMonthNetChange[6]) { Caption = 'Total Jun Net Change'; }
                column(Total_Jul_NetChange; GrandMonthNetChange[7]) { Caption = 'Total Jul Net Change'; }
                column(Total_Aug_NetChange; GrandMonthNetChange[8]) { Caption = 'Total Aug Net Change'; }
                column(Total_Sep_NetChange; GrandMonthNetChange[9]) { Caption = 'Total Sep Net Change'; }
                column(Total_Oct_NetChange; GrandMonthNetChange[10]) { Caption = 'Total Oct Net Change'; }
                column(Total_Nov_NetChange; GrandMonthNetChange[11]) { Caption = 'Total Nov Net Change'; }
                column(Total_Dec_NetChange; GrandMonthNetChange[12]) { Caption = 'Total Dec Net Change'; }
                column(ReportForNavId_5444; 5444) { }

                column(G_L_Account___No__; "G/L Account"."No.") { }
                column(PADSTR_____G_L_Account__Indentation___2___G_L_Account__Name; PadStr('', "G/L Account".Indentation * 2) + "G/L Account".Name) { }
                column(G_L_Account___Net_Change_; "G/L Account"."Net Change") { }
                column(G_L_Account___Net_Change__Control22; -"G/L Account"."Net Change")
                {
                    AutoFormatType = 1;
                }
                column(G_L_Account___Balance_at_Date_; "G/L Account"."Balance at Date") { }
                column(G_L_Account___Balance_at_Date__Control24; -"G/L Account"."Balance at Date")
                {
                    AutoFormatType = 1;
                }
                column(G_L_Account___Account_Type_; Format("G/L Account"."Account Type", 0, 2)) { }
                column(No__of_Blank_Lines; "G/L Account"."No. of Blank Lines") { }

                dataitem(BlankLineRepeater; "Integer")
                {
                    column(ReportForNavId_7; 7) { }
                    column(BlankLineNo; BlankLineNo) { }

                    trigger OnAfterGetRecord()
                    begin
                        if BlankLineNo = 0 then
                            CurrReport.Break;
                        BlankLineNo -= 1;
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    BlankLineNo := "G/L Account"."No. of Blank Lines" + 1;
                end;
            }

            trigger OnAfterGetRecord()
            var
                i: Integer;
                StartOfMonth: Date;
                EndOfMonth: Date;
                GLAccEntry: Record "G/L Entry";
            begin
                // Reset monthly arrays for each account
                for i := 1 to 12 do begin
                    MonthNetChange[i] := 0;
                    MonthTotal[i] := 0;
                    MonthBalance[i] := 0;
                end;

                // Set default dates if not provided
                if (StartDate = 0D) then
                    StartDate := DMY2Date(1, 1, Date2DMY(Today, 3));
                if (EndDate = 0D) then
                    EndDate := DMY2Date(31, 12, Date2DMY(Today, 3));

                // Calculate monthly Net Change and Balance at Date for each month within the selected date range
                for i := 1 to 12 do begin
                    StartOfMonth := DMY2Date(1, i, Date2DMY(StartDate, 3));
                    EndOfMonth := CalcDate('<CM>', StartOfMonth);
                    // Only process months within the selected range
                    if (StartOfMonth > EndDate) or (EndOfMonth < StartDate) then begin
                        MonthNetChange[i] := 0;
                        MonthTotal[i] := 0;
                        MonthBalance[i] := 0;
                        // skip this month
                    end else begin
                        // Clamp month to selected range
                        if StartOfMonth < StartDate then
                            StartOfMonth := StartDate;
                        if EndOfMonth > EndDate then
                            EndOfMonth := EndDate;

                        // Net Change for the month
                        GLAccEntry.Reset();
                        GLAccEntry.SetRange("G/L Account No.", "No.");
                        GLAccEntry.SetRange("Posting Date", StartOfMonth, EndOfMonth);
                        GLAccEntry.CalcSums(Amount);
                        MonthNetChange[i] := GLAccEntry.Amount;

                        // Sum monthly total (absolute value of debits and credits)
                        MonthTotal[i] := Abs(MonthNetChange[i]);

                        // Balance at end of month (cumulative from beginning of time to end of month)
                        GLAccEntry.Reset();
                        GLAccEntry.SetRange("G/L Account No.", "No.");
                        GLAccEntry.SetRange("Posting Date", 0D, EndOfMonth);
                        GLAccEntry.CalcSums(Amount);
                        MonthBalance[i] := GLAccEntry.Amount;
                    end;
                end;

                // Accumulate monthly net changes for grand totals
                for i := 1 to 12 do
                    GrandMonthNetChange[i] += MonthNetChange[i];

                // Set the date filter for the G/L Account record to match the selected year
                SetRange("Date Filter", StartDate, EndDate);
                CalcFields("Net Change", "Balance at Date");

                if not ShowZeroBalances then begin
                    if ("Net Change" = 0) and ("Balance at Date" = 0) then begin
                        // Also check if all monthly values are zero
                        if CheckAllMonthlyValuesZero() then
                            CurrReport.Skip();
                    end;
                end;

                if PrintToExcel then
                    MakeExcelDataBody;

                if ChangeGroupNo then begin
                    PageGroupNo += 1;
                    ChangeGroupNo := false;
                end;
                ChangeGroupNo := "New Page";

                TotalDebit := 0;
                Totalcredit := 0;

                if "G/L Account"."Account Type" = "G/L Account"."Account Type"::Posting then begin
                    if "Net Change" > 0 then
                        TotalDebit := TotalDebit + "Net Change";
                    if "Net Change" < 0 then
                        Totalcredit := Totalcredit + "Net Change";
                end;
            end;

            trigger OnPreDataItem()
            var
                i: Integer;
            begin
                PageGroupNo := 0;
                ChangeGroupNo := false;
                // Reset grand totals at the start of the report
                for i := 1 to 12 do
                    GrandMonthNetChange[i] := 0;
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(StartDate; StartDate)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Start Date';
                        ToolTip = 'Select the start date for the monthly trial balance.';
                    }
                    field(EndDate; EndDate)
                    {
                        ApplicationArea = Basic;
                        Caption = 'End Date';
                        ToolTip = 'Select the end date for the monthly trial balance.';
                    }
                    field(PrintToExcel; PrintToExcel)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Print to Excel';
                    }
                    field(ShowZeroBalances; ShowZeroBalances)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Show Accounts With No Balances';
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPostReport()
    begin
        if PrintToExcel then
            CreateExcelbook;
    end;

    trigger OnPreReport()
    begin
        // Set default dates if not provided
        if (StartDate = 0D) then
            StartDate := DMY2Date(1, 1, Date2DMY(Today, 3));
        if (EndDate = 0D) then
            EndDate := DMY2Date(31, 12, Date2DMY(Today, 3));

        if compyinfo.Get then begin
            compyinfo.CalcFields(compyinfo.Picture);
            compyname := compyinfo.Name;
        end;
        "G/L Account".SetRange("Date Filter", StartDate, EndDate);
        PeriodText := Format(StartDate) + ' .. ' + Format(EndDate);
        GLFilter := "G/L Account".GetFilters;
        if PrintToExcel then
            MakeExcelInfo;
    end;

    var
        GrandMonthNetChange: array[12] of Decimal;
        Text000: label 'Period: %1';
        ExcelBuf: Record "Excel Buffer" temporary;
        GLFilter: Text;
        PeriodText: Text[30];
        PrintToExcel: Boolean;
        Text001: label 'Trial Balance';
        Text002: label 'Data';
        Text003: label 'Debit';
        Text004: label 'Credit';
        Text005: label 'Company Name';
        Text006: label 'Report No.';
        Text007: label 'Report Name';
        Text008: label 'User ID';
        Text009: label 'Date';
        Text010: label 'G/L Filter';
        Text011: label 'Period Filter';
        PeriodType: Enum "Analysis Period Type";
        // StartDate, EndDate: Date; (removed duplicate declaration)
        Trial_BalanceCaptionLbl: label 'Trial Balance';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        Net_ChangeCaptionLbl: label 'Net Change';
        BalanceCaptionLbl: label 'Balance';
        PADSTR_____G_L_Account__Indentation___2___G_L_Account__NameCaptionLbl: label 'Name';
        G_L_Account___Net_Change_CaptionLbl: label 'Debit';
        G_L_Account___Net_Change__Control22CaptionLbl: label 'Credit';
        G_L_Account___Balance_at_Date_CaptionLbl: label 'Debit';
        G_L_Account___Balance_at_Date__Control24CaptionLbl: label 'Credit';
        PageGroupNo: Integer;
        ChangeGroupNo: Boolean;
        BlankLineNo: Integer;
        Totalcredit: Decimal;
        TotalDebit: Decimal;
        compyinfo: Record "Company Information";
        compyname: Text;
        ShowZeroBalances: Boolean;
        MonthNetChange: array[12] of Decimal;
        MonthBalance: array[12] of Decimal;
        MonthTotal: array[12] of Decimal;
        StartDate: Date;
        EndDate: Date;

    local procedure CheckAllMonthlyValuesZero(): Boolean
    var
        i: Integer;
    begin
        for i := 1 to 12 do begin
            if (MonthNetChange[i] <> 0) or (MonthBalance[i] <> 0) then
                exit(false);
        end;
        exit(true);
    end;

    procedure MakeExcelInfo()
    begin
        ExcelBuf.SetUseInfoSheet;
    end;

    local procedure MakeExcelDataHeader()
    begin
        ExcelBuf.AddColumn("G/L Account".FieldCaption("No."), false, '', true, false, true, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn("G/L Account".FieldCaption(Name), false, '', true, false, true, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(
          Format("G/L Account".FieldCaption("Net Change") + ' - ' + Text003), false, '', true, false, true, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(
          Format("G/L Account".FieldCaption("Net Change") + ' - ' + Text004), false, '', true, false, true, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(
          Format("G/L Account".FieldCaption("Balance at Date") + ' - ' + Text003), false, '', true, false, true, '',
          ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(
          Format("G/L Account".FieldCaption("Balance at Date") + ' - ' + Text004), false, '', true, false, true, '',
          ExcelBuf."cell type"::Text);
    end;

    procedure MakeExcelDataBody()
    var
        BlankFiller: Text[250];
    begin
        BlankFiller := PadStr(' ', MaxStrLen(BlankFiller), ' ');
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn(
          "G/L Account"."No.", false, '', "G/L Account"."Account Type" <> "G/L Account"."Account Type"::Posting, false, false, '',
          ExcelBuf."cell type"::Text);
        if "G/L Account".Indentation = 0 then
            ExcelBuf.AddColumn(
              "G/L Account".Name, false, '', "G/L Account"."Account Type" <> "G/L Account"."Account Type"::Posting, false, false, '',
              ExcelBuf."cell type"::Text)
        else
            ExcelBuf.AddColumn(
              CopyStr(BlankFiller, 1, 2 * "G/L Account".Indentation) + "G/L Account".Name,
              false, '', "G/L Account"."Account Type" <> "G/L Account"."Account Type"::Posting, false, false, '', ExcelBuf."cell type"::Text);

        case true of
            "G/L Account"."Net Change" = 0:
                begin
                    ExcelBuf.AddColumn(
                      '', false, '', "G/L Account"."Account Type" <> "G/L Account"."Account Type"::Posting, false, false, '',
                      ExcelBuf."cell type"::Text);
                    ExcelBuf.AddColumn(
                      '', false, '', "G/L Account"."Account Type" <> "G/L Account"."Account Type"::Posting, false, false, '',
                      ExcelBuf."cell type"::Text);
                end;
            "G/L Account"."Net Change" > 0:
                begin
                    ExcelBuf.AddColumn(
                      "G/L Account"."Net Change", false, '', "G/L Account"."Account Type" <> "G/L Account"."Account Type"::Posting,
                      false, false, '#,##0.00', ExcelBuf."cell type"::Number);
                    ExcelBuf.AddColumn(
                      '', false, '', "G/L Account"."Account Type" <> "G/L Account"."Account Type"::Posting, false, false, '',
                      ExcelBuf."cell type"::Text);
                end;
            "G/L Account"."Net Change" < 0:
                begin
                    ExcelBuf.AddColumn(
                      '', false, '', "G/L Account"."Account Type" <> "G/L Account"."Account Type"::Posting, false, false, '',
                      ExcelBuf."cell type"::Text);
                    ExcelBuf.AddColumn(
                      -"G/L Account"."Net Change", false, '', "G/L Account"."Account Type" <> "G/L Account"."Account Type"::Posting,
                      false, false, '#,##0.00', ExcelBuf."cell type"::Number);
                end;
        end;

        case true of
            "G/L Account"."Balance at Date" = 0:
                begin
                    ExcelBuf.AddColumn(
                      '', false, '', "G/L Account"."Account Type" <> "G/L Account"."Account Type"::Posting, false, false, '',
                      ExcelBuf."cell type"::Text);
                    ExcelBuf.AddColumn(
                      '', false, '', "G/L Account"."Account Type" <> "G/L Account"."Account Type"::Posting, false, false, '',
                      ExcelBuf."cell type"::Text);
                end;
            "G/L Account"."Balance at Date" > 0:
                begin
                    ExcelBuf.AddColumn(
                      "G/L Account"."Balance at Date", false, '', "G/L Account"."Account Type" <> "G/L Account"."Account Type"::Posting,
                      false, false, '#,##0.00', ExcelBuf."cell type"::Number);
                    ExcelBuf.AddColumn(
                      '', false, '', "G/L Account"."Account Type" <> "G/L Account"."Account Type"::Posting, false, false, '',
                      ExcelBuf."cell type"::Text);
                end;
            "G/L Account"."Balance at Date" < 0:
                begin
                    ExcelBuf.AddColumn(
                      '', false, '', "G/L Account"."Account Type" <> "G/L Account"."Account Type"::Posting, false, false, '',
                      ExcelBuf."cell type"::Text);
                    ExcelBuf.AddColumn(
                      -"G/L Account"."Balance at Date", false, '', "G/L Account"."Account Type" <> "G/L Account"."Account Type"::Posting,
                      false, false, '#,##0.00', ExcelBuf."cell type"::Number);
                end;
        end;
    end;

    procedure CreateExcelbook()
    begin
        //ExcelBuf.CreateBookAndOpenExcel(Text002,Text001,COMPANYNAME,USERID);
        //ERROR('');
    end;
}