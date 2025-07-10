#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 59062 "Quarter Trial Balance"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/QuarterTrialBalance.rdlc';
    Caption = 'Quarter Trial Balance';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem("G/L Account"; "G/L Account")
        {
            DataItemTableView = sorting("No.") where(Blocked = filter(false));
            RequestFilterFields = "No.", "Account Type", "Date Filter", "Global Dimension 1 Filter", "Global Dimension 2 Filter";
            column(ReportForNavId_6710; 6710)
            {
            }
            column(AccountName; Name) { }
            column(AccountNo; "No.") { }

            column(STRSUBSTNO_Text000_PeriodText_; StrSubstNo(Text000, PeriodText))
            {
            }
            column(CurrReport_PAGENO; CurrReport.PageNo)
            {
            }
            column(COMPANYNAME; COMPANYNAME)
            {
            }

            column(Company_Name; compyinfo.Name)
            {
            }
            column(Company_Address; compyinfo.Address)
            {
            }
            column(Company_Address_2; compyinfo."Address 2")
            {
            }
            column(Company_Phone_No; compyinfo."Phone No.")
            {
            }
            column(Company_Fax_No; compyinfo."Fax No.")
            {
            }
            column(Company_Picture; compyinfo.Picture)
            {
            }
            column(Company_Email; compyinfo."E-Mail")
            {
            }

            column(PeriodText; PeriodText)
            {
            }
            column(G_L_Account__TABLECAPTION__________GLFilter; TableCaption + ': ' + GLFilter)
            {
            }
            column(GLFilter; GLFilter)
            {
            }
            column(G_L_Account_No_; "No.")
            {
            }
            column(Trial_BalanceCaption; Trial_BalanceCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Net_ChangeCaption; Net_ChangeCaptionLbl)
            {
            }
            column(Totaldebit; TotalDebit)
            {
            }
            column(Totalcredit; -Totalcredit)
            {
            }
            column(BalanceCaption; BalanceCaptionLbl)
            {
            }
            column(G_L_Account___No__Caption; FieldCaption("No."))
            {
            }
            column(PADSTR_____G_L_Account__Indentation___2___G_L_Account__NameCaption; PADSTR_____G_L_Account__Indentation___2___G_L_Account__NameCaptionLbl)
            {
            }
            column(G_L_Account___Net_Change_Caption; G_L_Account___Net_Change_CaptionLbl)
            {
            }
            column(G_L_Account___Net_Change__Control22Caption; G_L_Account___Net_Change__Control22CaptionLbl)
            {
            }
            column(G_L_Account___Balance_at_Date_Caption; G_L_Account___Balance_at_Date_CaptionLbl)
            {
            }
            column(G_L_Account___Balance_at_Date__Control24Caption; G_L_Account___Balance_at_Date__Control24CaptionLbl) { }
            column(PageGroupNo; PageGroupNo) { }
            column(COMPANYPICTURE; compyinfo.Picture) { }
            column(DateFilter; DateFilter) { }
            column(StartDate; StartDate) { }
            column(EndDate; EndDate) { }

            // Quarterly columns for Net Change and Balance at Date
            column(Q1_NetChange; QuarterNetChange[1]) { Caption = 'Q1 Net Change'; }
            column(Q2_NetChange; QuarterNetChange[2]) { Caption = 'Q2 Net Change'; }
            column(Q3_NetChange; QuarterNetChange[3]) { Caption = 'Q3 Net Change'; }
            column(Q4_NetChange; QuarterNetChange[4]) { Caption = 'Q4 Net Change'; }

            column(Q1_Balance; QuarterBalance[1]) { Caption = 'Q1 Balance'; }
            column(Q2_Balance; QuarterBalance[2]) { Caption = 'Q2 Balance'; }
            column(Q3_Balance; QuarterBalance[3]) { Caption = 'Q3 Balance'; }
            column(Q4_Balance; QuarterBalance[4]) { Caption = 'Q4 Balance'; }

            // Quarterly totals
            column(Q1_Total_NetChange; Q1TotalNetChange) { Caption = 'Q1 Total Net Change'; }
            column(Q2_Total_NetChange; Q2TotalNetChange) { Caption = 'Q2 Total Net Change'; }
            column(Q3_Total_NetChange; Q3TotalNetChange) { Caption = 'Q3 Total Net Change'; }
            column(Q4_Total_NetChange; Q4TotalNetChange) { Caption = 'Q4 Total Net Change'; }

            dataitem("Integer"; "Integer")
            {
                DataItemTableView = sorting(Number) where(Number = const(1));
                column(ReportForNavId_5444; 5444)
                {
                }
                column(G_L_Account___No__; "G/L Account"."No.")
                {
                }
                column(PADSTR_____G_L_Account__Indentation___2___G_L_Account__Name; PadStr('', "G/L Account".Indentation * 2) + "G/L Account".Name)
                {
                }
                column(G_L_Account___Net_Change_; "G/L Account"."Net Change")
                {
                }
                column(G_L_Account___Net_Change__Control22; -"G/L Account"."Net Change")
                {
                    AutoFormatType = 1;
                }
                column(G_L_Account___Balance_at_Date_; "G/L Account"."Balance at Date")
                {
                }
                column(G_L_Account___Balance_at_Date__Control24; -"G/L Account"."Balance at Date")
                {
                    AutoFormatType = 1;
                }
                column(G_L_Account___Account_Type_; Format("G/L Account"."Account Type", 0, 2))
                {
                }
                column(No__of_Blank_Lines; "G/L Account"."No. of Blank Lines")
                {
                }
                dataitem(BlankLineRepeater; "Integer")
                {
                    column(ReportForNavId_7; 7)
                    {
                    }
                    column(BlankLineNo; BlankLineNo)
                    {
                    }

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
                StartOfQuarter: Date;
                EndOfQuarter: Date;
                GLAccEntry: Record "G/L Entry";
                QuarterStartMonth: array[4] of Integer;
                WorkingStartDate: Date;
                WorkingEndDate: Date;
                BaseYear: Integer;
            begin
                // Set quarter start months
                QuarterStartMonth[1] := 1;
                QuarterStartMonth[2] := 4;
                QuarterStartMonth[3] := 7;
                QuarterStartMonth[4] := 10;

                // Determine date range to use
                if (StartDate <> 0D) and (EndDate <> 0D) then begin
                    WorkingStartDate := StartDate;
                    WorkingEndDate := EndDate;
                    BaseYear := Date2DMY(StartDate, 3);
                end else begin
                    BaseYear := Date2DMY(Today, 3);
                    WorkingStartDate := DMY2Date(1, 1, BaseYear);
                    WorkingEndDate := DMY2Date(31, 12, BaseYear);
                end;


                // Clear previous values
                Clear(QuarterNetChange);
                Clear(QuarterBalance);

                // Calculate quarterly Net Change and Balance at Date for each quarter, only if quarter overlaps with selected range
                for i := 1 to 4 do begin
                    StartOfQuarter := DMY2Date(1, QuarterStartMonth[i], BaseYear);
                    EndOfQuarter := CALCDATE('<CM+2M>', StartOfQuarter);

                    // If the quarter is completely outside the selected range, skip rest of this iteration
                    if (EndOfQuarter < WorkingStartDate) or (StartOfQuarter > WorkingEndDate) then begin
                        // Skip this quarter
                    end else begin
                        // Clamp quarter to selected range
                        if StartOfQuarter < WorkingStartDate then
                            StartOfQuarter := WorkingStartDate;
                        if EndOfQuarter > WorkingEndDate then
                            EndOfQuarter := WorkingEndDate;

                        // Net Change for the quarter
                        GLAccEntry.Reset();
                        GLAccEntry.SetRange("G/L Account No.", "No.");
                        GLAccEntry.SetRange("Posting Date", StartOfQuarter, EndOfQuarter);
                        QuarterNetChange[i] := 0;
                        if GLAccEntry.FindSet() then
                            repeat
                                QuarterNetChange[i] += GLAccEntry.Amount;
                            until GLAccEntry.Next() = 0;

                        // Balance at end of quarter (cumulative from beginning of the period)
                        GLAccEntry.Reset();
                        GLAccEntry.SetRange("G/L Account No.", "No.");
                        GLAccEntry.SetRange("Posting Date", WorkingStartDate, EndOfQuarter);
                        QuarterBalance[i] := 0;
                        if GLAccEntry.FindSet() then
                            repeat
                                QuarterBalance[i] += GLAccEntry.Amount;
                            until GLAccEntry.Next() = 0;

                        // Add to quarterly totals (only for posting accounts)
                        if "Account Type" = "Account Type"::Posting then begin
                            case i of
                                1:
                                    Q1TotalNetChange += QuarterNetChange[i];
                                2:
                                    Q2TotalNetChange += QuarterNetChange[i];
                                3:
                                    Q3TotalNetChange += QuarterNetChange[i];
                                4:
                                    Q4TotalNetChange += QuarterNetChange[i];
                            end;
                        end;
                    end;
                end;

                // Apply date filter to existing calculations
                if (StartDate <> 0D) and (EndDate <> 0D) then begin
                    SetRange("Date Filter", StartDate, EndDate);
                end;

                CalcFields("Net Change", "Balance at Date");
                if not ShowZeroBalances then begin
                    if ("Net Change" = 0) and ("Balance at Date" = 0) and
                       (QuarterNetChange[1] = 0) and (QuarterNetChange[2] = 0) and
                       (QuarterNetChange[3] = 0) and (QuarterNetChange[4] = 0) then
                        CurrReport.Skip();
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

                if "Account Type" = "Account Type"::Posting then begin
                    if "Net Change" > 0 then
                        TotalDebit := TotalDebit + "Net Change";
                    if "Net Change" < 0 then
                        Totalcredit := Totalcredit + "Net Change";
                end;
            end;

            trigger OnPreDataItem()
            begin
                PageGroupNo := 0;
                ChangeGroupNo := false;

                // Clear quarterly totals
                Q1TotalNetChange := 0;
                Q2TotalNetChange := 0;
                Q3TotalNetChange := 0;
                Q4TotalNetChange := 0;
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

                    field(StartDate; StartDate)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Start Date';
                        ToolTip = 'Specify the start date for quarterly calculations. Leave blank for current year.';

                        trigger OnValidate()
                        begin
                            if (StartDate <> 0D) and (EndDate <> 0D) then begin
                                if StartDate > EndDate then
                                    Error('Start Date cannot be later than End Date.');
                            end;
                            // UpdateDateFilter();
                        end;
                    }

                    field(EndDate; EndDate)
                    {
                        ApplicationArea = Basic;
                        Caption = 'End Date';
                        ToolTip = 'Specify the end date for quarterly calculations. Leave blank for current year.';

                        trigger OnValidate()
                        begin
                            if (StartDate <> 0D) and (EndDate <> 0D) then begin
                                if StartDate > EndDate then
                                    Error('Start Date cannot be later than End Date.');
                            end;
                            // UpdateDateFilter();
                        end;
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
        if compyinfo.Get then begin
            compyinfo.CalcFields(compyinfo.Picture);
            compyname := compyinfo.Name;
        end;
        GLFilter := "G/L Account".GetFilters;
        PeriodText := "G/L Account".GetFilter("Date Filter");

        // Set date filter display
        if (StartDate <> 0D) and (EndDate <> 0D) then
            DateFilter := Format(StartDate) + '..' + Format(EndDate)
        else
            DateFilter := 'Current Year (' + Format(Date2DMY(Today, 3)) + ')';

        if PrintToExcel then
            MakeExcelInfo;
    end;

    var
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
        StartDate: Date;
        EndDate: Date;
        DateFilter: Text;

        QuarterNetChange: array[4] of Decimal;
        QuarterBalance: array[4] of Decimal;

        // Quarterly totals
        Q1TotalNetChange: Decimal;
        Q2TotalNetChange: Decimal;
        Q3TotalNetChange: Decimal;
        Q4TotalNetChange: Decimal;

    procedure MakeExcelInfo()
    begin
        ExcelBuf.SetUseInfoSheet;
        // Add date filter information to Excel export
        // ExcelBuf.AddInfoColumn('Date Filter',false,'',true,false,false,'',ExcelBuf."cell type"::Text);
        // ExcelBuf.AddInfoColumn(DateFilter,false,'',false,false,false,'',ExcelBuf."cell type"::Text);
        // ExcelBuf.NewRow;
        // ... rest of existing Excel info code
    end;

    local procedure MakeExcelDataHeader()
    begin
        ExcelBuf.AddColumn("G/L Account".FieldCaption("No."), false, '', true, false, true, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn("G/L Account".FieldCaption(Name), false, '', true, false, true, '', ExcelBuf."cell type"::Text);

        // Add quarterly columns to Excel header
        ExcelBuf.AddColumn('Q1 Net Change', false, '', true, false, true, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn('Q2 Net Change', false, '', true, false, true, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn('Q3 Net Change', false, '', true, false, true, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn('Q4 Net Change', false, '', true, false, true, '', ExcelBuf."cell type"::Text);

        ExcelBuf.AddColumn('Q1 Balance', false, '', true, false, true, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn('Q2 Balance', false, '', true, false, true, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn('Q3 Balance', false, '', true, false, true, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn('Q4 Balance', false, '', true, false, true, '', ExcelBuf."cell type"::Text);

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
          "G/L Account"."No.", false, '', "G/L Account"."Account Type" <> "G/L Account"."account type"::Posting, false, false, '',
          ExcelBuf."cell type"::Text);

        if "G/L Account".Indentation = 0 then
            ExcelBuf.AddColumn(
              "G/L Account".Name, false, '', "G/L Account"."Account Type" <> "G/L Account"."account type"::Posting, false, false, '',
              ExcelBuf."cell type"::Text)
        else
            ExcelBuf.AddColumn(
              CopyStr(BlankFiller, 1, 2 * "G/L Account".Indentation) + "G/L Account".Name,
              false, '', "G/L Account"."Account Type" <> "G/L Account"."account type"::Posting, false, false, '', ExcelBuf."cell type"::Text);

        // Add quarterly data to Excel
        ExcelBuf.AddColumn(QuarterNetChange[1], false, '', "G/L Account"."Account Type" <> "G/L Account"."account type"::Posting, false, false, '#,##0.00', ExcelBuf."cell type"::Number);
        ExcelBuf.AddColumn(QuarterNetChange[2], false, '', "G/L Account"."Account Type" <> "G/L Account"."account type"::Posting, false, false, '#,##0.00', ExcelBuf."cell type"::Number);
        ExcelBuf.AddColumn(QuarterNetChange[3], false, '', "G/L Account"."Account Type" <> "G/L Account"."account type"::Posting, false, false, '#,##0.00', ExcelBuf."cell type"::Number);
        ExcelBuf.AddColumn(QuarterNetChange[4], false, '', "G/L Account"."Account Type" <> "G/L Account"."account type"::Posting, false, false, '#,##0.00', ExcelBuf."cell type"::Number);

        ExcelBuf.AddColumn(QuarterBalance[1], false, '', "G/L Account"."Account Type" <> "G/L Account"."account type"::Posting, false, false, '#,##0.00', ExcelBuf."cell type"::Number);
        ExcelBuf.AddColumn(QuarterBalance[2], false, '', "G/L Account"."Account Type" <> "G/L Account"."account type"::Posting, false, false, '#,##0.00', ExcelBuf."cell type"::Number);
        ExcelBuf.AddColumn(QuarterBalance[3], false, '', "G/L Account"."Account Type" <> "G/L Account"."account type"::Posting, false, false, '#,##0.00', ExcelBuf."cell type"::Number);
        ExcelBuf.AddColumn(QuarterBalance[4], false, '', "G/L Account"."Account Type" <> "G/L Account"."account type"::Posting, false, false, '#,##0.00', ExcelBuf."cell type"::Number);

        // Existing Net Change logic
        case true of
            "G/L Account"."Net Change" = 0:
                begin
                    ExcelBuf.AddColumn(
                      '', false, '', "G/L Account"."Account Type" <> "G/L Account"."account type"::Posting, false, false, '',
                      ExcelBuf."cell type"::Text);
                    ExcelBuf.AddColumn(
                      '', false, '', "G/L Account"."Account Type" <> "G/L Account"."account type"::Posting, false, false, '',
                      ExcelBuf."cell type"::Text);
                end;
            "G/L Account"."Net Change" > 0:
                begin
                    ExcelBuf.AddColumn(
                      "G/L Account"."Net Change", false, '', "G/L Account"."Account Type" <> "G/L Account"."account type"::Posting,
                      false, false, '#,##0.00', ExcelBuf."cell type"::Number);
                    ExcelBuf.AddColumn(
                      '', false, '', "G/L Account"."Account Type" <> "G/L Account"."account type"::Posting, false, false, '',
                      ExcelBuf."cell type"::Text);
                end;
            "G/L Account"."Net Change" < 0:
                begin
                    ExcelBuf.AddColumn(
                      '', false, '', "G/L Account"."Account Type" <> "G/L Account"."account type"::Posting, false, false, '',
                      ExcelBuf."cell type"::Text);
                    ExcelBuf.AddColumn(
                      -"G/L Account"."Net Change", false, '', "G/L Account"."Account Type" <> "G/L Account"."account type"::Posting,
                      false, false, '#,##0.00', ExcelBuf."cell type"::Number);
                end;
        end;

        // Existing Balance at Date logic
        case true of
            "G/L Account"."Balance at Date" = 0:
                begin
                    ExcelBuf.AddColumn(
                      '', false, '', "G/L Account"."Account Type" <> "G/L Account"."account type"::Posting, false, false, '',
                      ExcelBuf."cell type"::Text);
                    ExcelBuf.AddColumn(
                      '', false, '', "G/L Account"."Account Type" <> "G/L Account"."account type"::Posting, false, false, '',
                      ExcelBuf."cell type"::Text);
                end;
            "G/L Account"."Balance at Date" > 0:
                begin
                    ExcelBuf.AddColumn(
                      "G/L Account"."Balance at Date", false, '', "G/L Account"."Account Type" <> "G/L Account"."account type"::Posting,
                      false, false, '#,##0.00', ExcelBuf."cell type"::Number);
                    ExcelBuf.AddColumn(
                      '', false, '', "G/L Account"."Account Type" <> "G/L Account"."account type"::Posting, false, false, '',
                      ExcelBuf."cell type"::Text);
                end;
            "G/L Account"."Balance at Date" < 0:
                begin
                    ExcelBuf.AddColumn(
                      '', false, '', "G/L Account"."Account Type" <> "G/L Account"."account type"::Posting, false, false, '',
                      ExcelBuf."cell type"::Text);
                    ExcelBuf.AddColumn(
                      -"G/L Account"."Balance at Date", false, '', "G/L Account"."Account Type" <> "G/L Account"."account type"::Posting,
                      false, false, '#,##0.00', ExcelBuf."cell type"::Number);
                end;
        end;
    end;

    procedure CreateExcelbook()
    begin
        //ExcelBuf.CreateBookAndOpenExcel(Text002,Text001,COMPANYNAME,USERID);
        //ERROR('');
    end;
    // Removed extra closing brace

}
