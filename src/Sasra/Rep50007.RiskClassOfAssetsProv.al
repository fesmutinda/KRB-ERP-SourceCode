#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 50007 "Risk Class Of Assets & Prov"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Risk Class Of Assets & Prov.rdlc';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
#pragma warning disable AL0275
        dataitem(Company; "Company Information")
#pragma warning restore AL0275
        {
            column(ReportForNavId_1; 1)
            {
            }
            column(COMPANYNAME; Company.Name)
            {
            }
            column(AsAt; AsAt)
            {
            }
            column(LoanCount; LoanCount)
            {
            }
            column(LoanCountSubstandard; LoanCountSubstandard)
            {
            }
            column(LoanCountDoubtful; LoanCountDoubtful)
            {
            }
            column(LoanCountWatch; LoanCountWatch)
            {
            }
            column(LoanCountLoss; LoanCountLoss)
            {
            }
            column(OutstandingLoanPer; OutstandingLoanPer)
            {
            }
            column(OutstandingLoanwatch; OutstandingLoanwatch)
            {
            }
            column(OutstandingLoandoubtful; OutstandingLoandoubtful)
            {
            }
            column(OutstandingLoanSub; OutstandingLoanSub)
            {
            }
            column(OutstandingLoanloss; OutstandingLoanloss)
            {
            }
            column(LoanCountResch; LoanCountResch)
            {
            }
            column(OutstandingLoanPerResc; OutstandingLoanPerResc)
            {
            }
            column(LoanCountWatchResc; LoanCountWatchResc)
            {
            }
            column(OutstandingLoanwatchResc; OutstandingLoanwatchResc)
            {
            }
            column(LoanCountDoubtfulResc; LoanCountDoubtfulResc)
            {
            }
            column(OutstandingLoandoubtfulResc; OutstandingLoandoubtfulResc)
            {
            }
            column(LoanCountSubstandardResc; LoanCountSubstandardResc)
            {
            }
            column(OutstandingLoanSubResc; OutstandingLoanSubResc)
            {
            }
            column(LoanCountLossRec; LoanCountLossRec)
            {
            }
            column(OutstandingLoanlossResc; OutstandingLoanlossResc)
            {
            }
            column(ClassifiedNonRescheduledper; ClassifiedNonRescheduledper)
            {
            }
            column(ClassifiedNonRescheduledDoubtful; ClassifiedNonRescheduledDoubtful)
            {
            }
            column(ClassifiedNonRescheduledLoss; ClassifiedNonRescheduledLoss)
            {
            }
            column(ClassifiedNonRescheduledsubstandard; ClassifiedNonRescheduledsubstandard)
            {
            }
            column(ClassifiedNonRescheduledWatch; ClassifiedNonRescheduledWatch)
            {
            }
            column(ClassifiedRescheduledLoss; ClassifiedRescheduledLoss)
            {
            }
            column(ClassifiedRescheduledPer; ClassifiedRescheduledPer)
            {
            }
            column(ClassifiedRescheduledSubstandard; ClassifiedRescheduledSubstandard)
            {
            }
            column(ClassifiedRescheduledWatch; ClassifiedRescheduledWatch)
            {
            }
            column(ClassifiedRescheduledDoubtful; ClassifiedRescheduledDoubtful)
            {
            }
            column(subtotal; subtotal)
            {
            }
            column(TotalClassffiedRecheduled; TotalClassffiedRecheduled)
            {
            }
            column(TotalClassffied; TotalClassffied)
            {
            }
            column(subtotalRescheduled; subtotalRescheduled)
            {
            }
            column(Subtotalcount; Subtotalcount)
            {
            }
            column(SubtotalcountResc; SubtotalcountResc)
            {
            }
            column(GRANDTOTAL; GRANDTOTAL)
            {
            }
            column(GRANDTOTALCOUNT; GRANDTOTALCOUNT)
            {
            }
            column(GRANDTOTALCLASSIF; GRANDTOTALCLASSIF)
            {
            }
            column(YearBeginDate; YearBeginDate)
            {
            }
            column(FinancialYear; FinancialYear)
            {
            }

            trigger OnAfterGetRecord()
            begin
                //DateFilter:='..'+FORMAT(CALCDATE('-CM-1D',AsAt));
                DateFilter := '..' + Format(AsAt);
                FinancialYear := Date2dmy(AsAt, 3);
                YearBeginDate := CalcDate('-CY', AsAt);
                if LoansRegister.Find('-') then begin
                    repeat
                        LoansClassificationCodeUnit.FnClassifyLoan(LoansRegister."Loan  No.", AsAt);
                    until LoansRegister.Next = 0;
                end;
                LoanCount := 0;
                OutstandingLoanPer := 0;
                LoansRegister.Reset;
                LoansRegister.SetRange(LoansRegister.Rescheduled, false);
                LoansRegister.SetFilter(LoansRegister."Loans Category-SASRA", '%1', LoansRegister."Loans Category-SASRA"::Perfoming);
                LoansRegister.SetFilter(LoansRegister."Outstanding Balance", '<>%1', 0);
                LoansRegister.SetRange(LoansRegister.Posted, true);
                LoansRegister.SetAutocalcFields(LoansRegister."Outstanding Balance");
                LoansRegister.SETFILTER(LoansRegister."Date filter", '..%1', AsAt);
                if LoansRegister.FindSet() then begin
                    repeat
                        LoanCount := LoanCount + 1;
                        OutstandingLoanPer += LoansRegister."Outstanding Balance";
                    until LoansRegister.Next = 0;
                end;

                LoanCountWatch := 0;
                OutstandingLoanwatch := 0;
                LoansRegister.Reset;
                LoansRegister.SetRange(LoansRegister.Rescheduled, false);
                LoansRegister.SetFilter(LoansRegister."Loans Category-SASRA", '%1', LoansRegister."Loans Category-SASRA"::Watch);
                LoansRegister.SetFilter(LoansRegister."Outstanding Balance", '>%1', 0);
                LoansRegister.SetRange(LoansRegister.Posted, true);
                LoansRegister.SetAutocalcFields("Outstanding Balance");
                LoansRegister.SETFILTER(LoansRegister."Date filter", '..%1', AsAt);
                if LoansRegister.FindSet then begin
                    repeat
                        LoanCountWatch := LoanCountWatch + 1;
                        OutstandingLoanwatch += LoansRegister."Outstanding Balance";
                    until LoansRegister.Next = 0;
                end;
                LoanCountDoubtful := 0;
                OutstandingLoandoubtful := 0;
                LoansRegister.Reset;
                LoansRegister.SetRange(LoansRegister.Rescheduled, false);
                LoansRegister.SetFilter(LoansRegister."Loans Category-SASRA", '%1', LoansRegister."Loans Category-SASRA"::Doubtful);
                LoansRegister.SetFilter(LoansRegister."Outstanding Balance", '>%1', 0);
                LoansRegister.SetFilter(LoansRegister."Issued Date", '<=%1', AsAt);
                LoansRegister.SetAutocalcFields("Outstanding Balance");
                LoansRegister.SETFILTER(LoansRegister."Date filter", '..%1', AsAt);
                if LoansRegister.FindSet then begin
                    repeat
                        LoanCountDoubtful := LoanCountDoubtful + 1;
                        OutstandingLoandoubtful += LoansRegister."Outstanding Balance";
                    until LoansRegister.Next = 0;
                end;
                LoanCountSubstandard := 0;
                OutstandingLoanSub := 0;
                LoansRegister.Reset;
                LoansRegister.SetRange(LoansRegister.Rescheduled, false);
                LoansRegister.SetFilter(LoansRegister."Loans Category-SASRA", '%1', LoansRegister."Loans Category-SASRA"::Substandard);
                LoansRegister.SetFilter(LoansRegister."Outstanding Balance", '>%1', 0);
                LoansRegister.SetFilter(LoansRegister."Issued Date", '<=%1', AsAt);
                LoansRegister.SetAutocalcFields("Outstanding Balance");
                LoansRegister.SETFILTER(LoansRegister."Date filter", '..%1', AsAt);
                if LoansRegister.FindSet then begin
                    repeat
                        LoanCountSubstandard := LoanCountSubstandard + 1;
                        OutstandingLoanSub += LoansRegister."Outstanding Balance";
                    until LoansRegister.Next = 0;
                end;
                LoanCountLoss := 0;
                OutstandingLoanloss := 0;
                LoansRegister.Reset;
                LoansRegister.SetRange(LoansRegister.Rescheduled, false);

                LoansRegister.SetFilter(LoansRegister."Loans Category-SASRA", '%1', LoansRegister."Loans Category-SASRA"::Loss);
                LoansRegister.SetFilter(LoansRegister."Outstanding Balance", '>%1', 0);
                LoansRegister.SetFilter(LoansRegister."Issued Date", '<=%1', AsAt);
                LoansRegister.SetAutocalcFields("Outstanding Balance");
                LoansRegister.SETFILTER(LoansRegister."Date filter", '..%1', AsAt);
                if LoansRegister.FindSet then begin
                    repeat
                        LoanCountLoss := LoanCountLoss + 1;
                        OutstandingLoanloss += LoansRegister."Outstanding Balance";
                    until LoansRegister.Next = 0;
                end;

                //rescheduled loans
                LoanCountResch := 0;
                OutstandingLoanPerResc := 0;
                LoansRegister.Reset;
                LoansRegister.SetRange(LoansRegister.Rescheduled, true);
                LoansRegister.SETFILTER(LoansRegister."Date filter", DateFilter);
                LoansRegister.SetFilter(LoansRegister."Loans Category-SASRA", '%1', LoansRegister."Loans Category-SASRA"::Perfoming);
                LoansRegister.SetFilter(LoansRegister."Outstanding Balance", '>%1', 0);
                LoansRegister.SetFilter(LoansRegister."Issued Date", '<=%1', AsAt);
                LoansRegister.SetAutocalcFields("Outstanding Balance");
                if LoansRegister.FindSet then begin
                    repeat
                        LoanCountResch := LoanCountResch + 1;
                        OutstandingLoanPerResc += LoansRegister."Outstanding Balance";
                    until LoansRegister.Next = 0;
                end;
                LoanCountWatchResc := 0;
                OutstandingLoanwatchResc := 0;
                LoansRegister.Reset;
                LoansRegister.SetRange(LoansRegister.Rescheduled, true);
                LoansRegister.SETFILTER(LoansRegister."Date filter", DateFilter);
                LoansRegister.SetFilter(LoansRegister."Loans Category-SASRA", '%1', LoansRegister."Loans Category-SASRA"::Watch);
                LoansRegister.SetFilter(LoansRegister."Outstanding Balance", '>%1', 0);
                LoansRegister.SetFilter(LoansRegister."Issued Date", '<=%1', AsAt);
                LoansRegister.SetAutocalcFields("Outstanding Balance");
                if LoansRegister.FindSet then begin
                    repeat
                        LoanCountWatchResc := LoanCountWatchResc + 1;
                        OutstandingLoanwatchResc += LoansRegister."Outstanding Balance";
                    until LoansRegister.Next = 0;
                end;
                LoanCountDoubtfulResc := 0;
                OutstandingLoandoubtfulResc := 0;
                LoansRegister.Reset;
                LoansRegister.SetRange(LoansRegister.Rescheduled, true);
                LoansRegister.SETFILTER(LoansRegister."Date filter", DateFilter);
                LoansRegister.SetFilter(LoansRegister."Loans Category-SASRA", '%1', LoansRegister."Loans Category-SASRA"::Doubtful);
                LoansRegister.SetFilter(LoansRegister."Outstanding Balance", '>%1', 0);
                LoansRegister.SetFilter(LoansRegister."Issued Date", '<=%1', AsAt);
                LoansRegister.SetAutocalcFields("Outstanding Balance");
                if LoansRegister.FindSet then begin
                    repeat
                        LoanCountDoubtfulResc := LoanCountDoubtfulResc + 1;
                        OutstandingLoandoubtfulResc += LoansRegister."Outstanding Balance";
                    until LoansRegister.Next = 0;
                end;
                LoanCountSubstandardResc := 0;
                OutstandingLoanSubResc := 0;
                LoansRegister.Reset;
                LoansRegister.SetRange(LoansRegister.Rescheduled, true);
                LoansRegister.SETFILTER(LoansRegister."Date filter", DateFilter);
                LoansRegister.SetFilter(LoansRegister."Loans Category-SASRA", '%1', LoansRegister."Loans Category-SASRA"::Substandard);
                LoansRegister.SetFilter(LoansRegister."Outstanding Balance", '>%1', 0);
                LoansRegister.SetFilter(LoansRegister."Issued Date", '<=%1', AsAt);
                LoansRegister.SetAutocalcFields("Outstanding Balance");
                if LoansRegister.FindSet then begin
                    repeat
                        LoanCountSubstandardResc := LoanCountSubstandardResc + 1;
                        OutstandingLoanSubResc += LoansRegister."Outstanding Balance";
                    until LoansRegister.Next = 0;
                end;
                LoanCountLossRec := 0;
                OutstandingLoanlossResc := 0;
                LoansRegister.Reset;
                LoansRegister.SetRange(LoansRegister.Rescheduled, true);
                LoansRegister.SETFILTER(LoansRegister."Date filter", DateFilter);
                LoansRegister.SetFilter(LoansRegister."Loans Category-SASRA", '%1', LoansRegister."Loans Category-SASRA"::Loss);
                LoansRegister.SetFilter(LoansRegister."Outstanding Balance", '>%1', 0);
                LoansRegister.SetFilter(LoansRegister."Issued Date", '<=%1', AsAt);
                LoansRegister.SetAutocalcFields("Outstanding Balance");
                if LoansRegister.FindSet then begin
                    repeat
                        LoanCountLossRec := LoanCountLossRec + 1;
                        OutstandingLoanlossResc += LoansRegister."Outstanding Balance";
                    until LoansRegister.Next = 0;
                end;

                ClassifiedNonRescheduledper := ROUND(OutstandingLoanPer * 1 / 100, 0.01, '<');
                ClassifiedNonRescheduledDoubtful := ROUND(OutstandingLoandoubtful * 50 / 100, 0.01, '<');
                ClassifiedNonRescheduledLoss := ROUND(OutstandingLoanloss * 100 / 100, 0.01, '<');
                ClassifiedNonRescheduledsubstandard := ROUND(OutstandingLoanSub * 25 / 100, 0.01, '<');
                ClassifiedNonRescheduledWatch := ROUND(OutstandingLoanwatch * 5 / 100, 0.01, '<');
                ClassifiedRescheduledLoss := ROUND(OutstandingLoanlossResc * 100 / 100, 0.01, '<');
                ClassifiedRescheduledPer := ROUND(OutstandingLoanPerResc * 1 / 100, 0.01, '<');
                ClassifiedRescheduledSubstandard := ROUND(OutstandingLoanSubResc * 25 / 100, 0.01, '<');
                ClassifiedRescheduledWatch := ROUND(OutstandingLoanwatchResc * 5 / 100, 0.01, '<');
                ClassifiedRescheduledDoubtful := ROUND(OutstandingLoandoubtfulResc * 50 / 100, 0.01, '<');

                subtotal := OutstandingLoandoubtful + OutstandingLoanloss + OutstandingLoanPer + OutstandingLoanSub + OutstandingLoanwatch;
                subtotalRescheduled := OutstandingLoandoubtfulResc + OutstandingLoanlossResc + OutstandingLoanPerResc + OutstandingLoanSubResc + OutstandingLoanwatchResc;
                TotalClassffied := ClassifiedNonRescheduledDoubtful + ClassifiedNonRescheduledLoss + ClassifiedNonRescheduledper + ClassifiedNonRescheduledsubstandard + ClassifiedNonRescheduledWatch;
                TotalClassffiedRecheduled := ClassifiedRescheduledDoubtful + ClassifiedRescheduledPer + ClassifiedRescheduledSubstandard + ClassifiedRescheduledWatch + ClassifiedRescheduledLoss;
                Subtotalcount := LoanCount + LoanCountDoubtful + LoanCountLoss + LoanCountSubstandard + LoanCountWatch;
                SubtotalcountResc := LoanCountDoubtfulResc + LoanCountLossRec + LoanCountResch + LoanCountSubstandardResc + LoanCountWatchResc;

                GRANDTOTAL := subtotal + subtotalRescheduled;
                GRANDTOTALCOUNT := Subtotalcount + SubtotalcountResc;
                GRANDTOTALCLASSIF := TotalClassffied + TotalClassffiedRecheduled;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(AsAt; AsAt)
                {
                    ApplicationArea = Basic;
                    Caption = 'AsAt';
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

    var
        LoansRegister: Record "Loans Register";
        LoanCount: Integer;
        DateFilter: Text;
        AsAt: Date;
        LoanCountWatch: Integer;
        FinancialYear: Integer;
        YearBeginDate: Date;
        LoanCountDoubtful: Integer;
        LoanCountSubstandard: Integer;
        LoanCountLoss: Integer;
        OutstandingLoanPer: Decimal;
        OutstandingLoanwatch: Decimal;
        OutstandingLoanSub: Decimal;
        OutstandingLoanloss: Decimal;
        OutstandingLoandoubtful: Decimal;
        LoanCountResch: Integer;
        OutstandingLoanPerResc: Decimal;
        LoanCountWatchResc: Integer;
        OutstandingLoanwatchResc: Decimal;
        LoanCountDoubtfulResc: Integer;
        OutstandingLoandoubtfulResc: Decimal;
        LoanCountSubstandardResc: Integer;
        OutstandingLoanSubResc: Decimal;
        LoanCountLossRec: Integer;
        OutstandingLoanlossResc: Decimal;
        ClassifiedNonRescheduledper: Decimal;
        ClassifiedNonRescheduledWatch: Decimal;
        ClassifiedNonRescheduledDoubtful: Decimal;
        ClassifiedNonRescheduledsubstandard: Decimal;
        ClassifiedNonRescheduledLoss: Decimal;
        ClassifiedRescheduledPer: Decimal;
        ClassifiedRescheduledWatch: Decimal;
        ClassifiedRescheduledDoubtful: Decimal;
        ClassifiedRescheduledSubstandard: Decimal;
        ClassifiedRescheduledLoss: Decimal;
        subtotal: Decimal;
        subtotalRescheduled: Decimal;
        TotalClassffied: Decimal;
        TotalClassffiedRecheduled: Decimal;
        Subtotalcount: Integer;
        SubtotalcountResc: Integer;
        GRANDTOTALCLASSIF: Decimal;
        GRANDTOTAL: Decimal;
        GRANDTOTALCOUNT: Integer;
        PrevMonthDate: Date;
        // Classify: Codeunit "Loan Classification-SASRA";
        LoansClassificationCodeUnit: Codeunit LoansClassificationCodeUnit;

}

