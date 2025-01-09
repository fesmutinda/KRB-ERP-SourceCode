Report 50856 "Actual Vs Budget"
{
    ApplicationArea = All;
    Caption = 'Actual Vs Budget ';
    RDLCLayout = './Layouts/ActualVsBalancesheet.rdlc';
    UsageCategory = ReportsAndAnalysis;
    dataset
    {
        dataitem("G/L Account"; "G/L Account")
        {
            DataItemTableView = sorting("No.") where(Blocked = filter(false));
            RequestFilterFields = "Date Filter";
            column(ReportForNavId_6710; 6710)
            {
            }
            column(STRSUBSTNO_Text000_PeriodText_; StrSubstNo(Text000, PeriodText))
            {
            }
            column(CurrReport_PAGENO; CurrReport.PageNo)
            {
            }
            column(COMPANYNAME; COMPANYNAME)
            {
            }
            column(PeriodText; PeriodText)
            {
            }
            column(company_Picture; company.Picture)
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
            column(G_L_Account___Balance_at_Date__Control24Caption; G_L_Account___Balance_at_Date__Control24CaptionLbl)
            {
            }
            column(Budgeted_Credit_Amount; "Budgeted Credit Amount")
            {

            }
            column(Budgeted_Amount; "Budgeted Amount") { }
            column(Net_Change; "Net Change") { }
            column(Budgeted_Debit_Amount; "Budgeted Debit Amount") { }
            column(Variance; Variance) { }
            column(CurrAmount; CurrAmount) { }
            column(PrevAmount; PrevAmount) { }
            column(PageGroupNo; PageGroupNo)
            {
            }

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
                var
                    InputDate: Date;
                    DateFormula: Text;
                    DateFormula2: Text;
                    DateExpr: Text;
                    DatefilterOne: Text;
                    DatefilterTwo: Text;
                begin
                    BlankLineNo := "G/L Account"."No. of Blank Lines" + 1;
                    Variance := "G/L Account"."Budgeted Amount" - "G/L Account"."Net Change";

                    // ///Budget comparison
                    // DateFormula2 := '-CY';
                    // DateFormula := '<CY>';
                    // DateExpr := '<-1y>';


                    // InputDate := Asat;
                    // CurrentStartofYear := CalcDate(DateFormula2, Asat);
                    // CurrentEndofYear := CalcDate(DateFormula, Asat);
                    // CurrentYear := Date2DMY(CurrentEndofYear, 3);
                    // previousEndofYear := CalcDate(DateExpr, CurrentEndofYear);
                    // previousStartofYear := CalcDate(DateFormula2, previousEndofYear);
                    // PreviousYear := CurrentYear - 1;
                    // DatefilterOne := Format(CurrentStartofYear) + '..' + Format(CurrentEndofYear);
                    // DatefilterTwo := Format(previousStartofYear) + '..' + Format(previousEndofYear);

                    // GLAccount.Reset();
                    // GLAccount.SetFilter(GLAccount."Date Filter", DatefilterOne);
                    // if Find('-') then begin
                    //     repeat
                    //         GLAccount.CalcFields(GLAccount."Budgeted Amount");
                    //         CurrAmount := GLAccount."Budgeted Amount";
                    //     until GLAccount.Next = 0;
                    // end;
                    // GLAccount.Reset();
                    // GLAccount.SetFilter(GLAccount."Date Filter", DatefilterTwo);
                    // if Find('-') then begin
                    //     repeat
                    //         GLAccount.CalcFields(GLAccount."Budgeted Amount");
                    //         PrevAmount := GLAccount."Budgeted Amount";
                    //     until GLAccount.Next = 0;
                    // end;

                end;

            }

            trigger OnAfterGetRecord()
            begin
                CalcFields("Net Change", "Balance at Date");
                if PrintToExcel then
                    MakeExcelDataBody;

                if ChangeGroupNo then begin
                    PageGroupNo += 1;
                    ChangeGroupNo := false;
                end;

                ChangeGroupNo := "New Page";
                TotalDebit := 0;
                //Totalcreditbal:=0;
                Totalcredit := 0;
                //Totaldebitbal:=0;
                CalcFields("Net Change", "Balance at Date");
                //CurrReport.CREATETOTALS("Net Change","Balance at Date");
                if "G/L Account"."Account Type" = "G/L Account"."account type"::Posting then begin
                    if "Net Change" > 0 then
                        TotalDebit := TotalDebit + "Net Change";
                    if "Net Change" < 0 then
                        Totalcredit := Totalcredit + "Net Change";
                end;
                if (("Budgeted Amount" = 0) or ("G/L Account"."Account Type" <> "G/L Account"."Account Type"::Posting)) then
                    CurrReport.Skip;
            end;

            trigger OnPreDataItem()
            begin
                PageGroupNo := 0;
                ChangeGroupNo := false;

                company.Get();
                company.CalcFields(company.Picture);

            end;
        }
    }

    requestpage
    {

        layout
        {
            // area(content)
            // {
            //     group(Options)
            //     {
            //         Caption = 'Options';
            //         field(Asat; Asat)
            //         {
            //             ApplicationArea = Basic;
            //             // Visible = false;
            //             // Caption = 'Print to Excel';
            //         }
            //     }
            // }
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
        // if PrintToExcel then
        //   CreateExcelbook;
    end;

    trigger OnPreReport()
    begin
        GLFilter := "G/L Account".GetFilters;
        PeriodText := "G/L Account".GetFilter("Date Filter");
        // if PrintToExcel then
        //   MakeExcelInfo;
    end;

    var
        GLAccount: Record "G/L Account";
        Text000: label 'Period: %1';
        ExcelBuf: Record "Excel Buffer" temporary;
        GLFilter: Text;
        Variance: Decimal;
        PeriodText: Text[30];
        PrintToExcel: Boolean;
        Text001: label 'Trial Balance';
        Text002: label 'Data';
        Text003: label 'Debit';
        Text004: label 'Credit';
        Text005: label 'Company Name';
        company: Record "Company Information";
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
        CurrYearBudgetAmount: Decimal;
        LastYearBudgetAmount: Decimal;
        Asat: Date;
        PreviousYear: Integer;
        CurrentEndofYear: date;
        CurrentStartofYear: date;
        previousEndofYear: Date;
        previousStartofYear: Date;
        CurrentYear: Integer;
        CurrAmount: Decimal;
        PrevAmount: Decimal;




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
}