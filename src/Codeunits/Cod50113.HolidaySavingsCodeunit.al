#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 50113 "Holiday Savings Codeunit"
{

    trigger OnRun()
    begin
        FnProcessHolidaySavings('2297', 20230101D, Today);
    end;

    var
        LineNo: Integer;
        SFactory: Codeunit "Swizzsoft Factory.";
        GenJournalLine: Record "Gen. Journal Line";
        HolidayTable: Record 51070;


    procedure FnProcessHolidaySavings(MemberNo: Code[50]; StartDate: Date; PostingDate: Date)
    var
        MembersTable: Record Customer;
        MonthAmountSaved: Decimal;
        InterestEarned: Decimal;
        SaccoGeneralSetUp: Record 51398;
        NewMonth: Date;
        MemberHolidaySaving: Decimal;
        MembersTable2: Record Customer;
    begin
        StartDate := CalcDate('-CM', StartDate);
        InterestEarned := 0;
        SaccoGeneralSetUp.Get();
        MembersTable.Reset;
        MembersTable.SetAutocalcFields(MembersTable."Withdrawable Savings");
        MembersTable.SetRange(MembersTable."No.", MemberNo);
        if MembersTable.Find('-') then begin
            MemberHolidaySaving := 0;
            MemberHolidaySaving := (MembersTable."Withdrawable Savings");
            //.........................12
            MembersTable2.Reset;
            MembersTable2.SetRange(MembersTable2."No.", MemberNo);
            MembersTable2.SetAutocalcFields(MembersTable2."Withdrawable Savings");
            MembersTable2.SetFilter(MembersTable2."Date Filter", '%1..%2', StartDate, CalcDate('CM', StartDate));
            if MembersTable2.Find('-') then begin
                MonthAmountSaved := 0;
                MonthAmountSaved := MembersTable2."Withdrawable Savings";
                if MonthAmountSaved > 0 then begin
                    InterestEarned := (InterestEarned + (((SaccoGeneralSetUp."HolidaySavings(%)" / 100) * MonthAmountSaved)) * 12 / 12);
                end else if MonthAmountSaved <= 0 then begin
                    InterestEarned := 0;
                end;
            end;
            //.........................11
            NewMonth := 0D;
            NewMonth := CalcDate('1M', StartDate);
            MembersTable2.Reset;
            MembersTable2.SetRange(MembersTable2."No.", MemberNo);
            MembersTable2.SetAutocalcFields(MembersTable2."Withdrawable Savings");
            MembersTable2.SetFilter(MembersTable2."Date Filter", '%1..%2', NewMonth, CalcDate('CM', NewMonth));
            if MembersTable2.Find('-') then begin
                MonthAmountSaved := 0;
                MonthAmountSaved := MembersTable2."Withdrawable Savings";
                if MonthAmountSaved > 0 then begin
                    InterestEarned := (InterestEarned + (((SaccoGeneralSetUp."HolidaySavings(%)" / 100) * MonthAmountSaved)) * 11 / 12);
                end else if MonthAmountSaved <= 0 then begin
                    InterestEarned := 0 + InterestEarned;
                end;

            end;
            //.........................10
            NewMonth := 0D;
            NewMonth := CalcDate('2M', StartDate);
            MembersTable2.Reset;
            MembersTable2.SetRange(MembersTable2."No.", MemberNo);
            MembersTable2.SetAutocalcFields(MembersTable2."Withdrawable Savings");
            MembersTable2.SetFilter(MembersTable2."Date Filter", '%1..%2', NewMonth, CalcDate('CM', NewMonth));
            if MembersTable2.Find('-') then begin
                MonthAmountSaved := 0;
                MonthAmountSaved := MembersTable2."Withdrawable Savings";
                if MonthAmountSaved > 0 then begin
                    InterestEarned := (InterestEarned + (((SaccoGeneralSetUp."HolidaySavings(%)" / 100) * MonthAmountSaved)) * 10 / 12);
                end else if MonthAmountSaved <= 0 then begin
                    InterestEarned := 0 + InterestEarned;
                end;

            end;
            //.........................9
            NewMonth := 0D;
            NewMonth := CalcDate('3M', StartDate);
            MembersTable2.Reset;
            MembersTable2.SetRange(MembersTable2."No.", MemberNo);
            MembersTable2.SetAutocalcFields(MembersTable2."Withdrawable Savings");
            MembersTable2.SetFilter(MembersTable2."Date Filter", '%1..%2', NewMonth, CalcDate('CM', NewMonth));
            if MembersTable2.Find('-') then begin
                MonthAmountSaved := 0;
                MonthAmountSaved := MembersTable2."Withdrawable Savings";
                if MonthAmountSaved > 0 then begin
                    InterestEarned := (InterestEarned + (((SaccoGeneralSetUp."HolidaySavings(%)" / 100) * MonthAmountSaved)) * 9 / 12);
                end else if MonthAmountSaved <= 0 then begin
                    InterestEarned := 0 + InterestEarned;
                end;

            end;
            //.........................8
            NewMonth := 0D;
            NewMonth := CalcDate('4M', StartDate);
            MembersTable2.Reset;
            MembersTable2.SetRange(MembersTable2."No.", MemberNo);
            MembersTable2.SetAutocalcFields(MembersTable2."Withdrawable Savings");
            MembersTable2.SetFilter(MembersTable2."Date Filter", '%1..%2', NewMonth, CalcDate('CM', NewMonth));
            if MembersTable2.Find('-') then begin
                MonthAmountSaved := 0;
                MonthAmountSaved := MembersTable2."Withdrawable Savings";
                if MonthAmountSaved > 0 then begin
                    InterestEarned := (InterestEarned + (((SaccoGeneralSetUp."HolidaySavings(%)" / 100) * MonthAmountSaved)) * 8 / 12);
                end else if MonthAmountSaved <= 0 then begin
                    InterestEarned := 0 + InterestEarned;
                end;

            end;
            //.........................7
            NewMonth := 0D;
            NewMonth := CalcDate('5M', StartDate);
            MembersTable2.Reset;
            MembersTable2.SetRange(MembersTable2."No.", MemberNo);
            MembersTable2.SetAutocalcFields(MembersTable2."Withdrawable Savings");
            MembersTable2.SetFilter(MembersTable2."Date Filter", '%1..%2', NewMonth, CalcDate('CM', NewMonth));
            if MembersTable2.Find('-') then begin
                MonthAmountSaved := 0;
                MonthAmountSaved := MembersTable2."Withdrawable Savings";
                if MonthAmountSaved > 0 then begin
                    InterestEarned := (InterestEarned + (((SaccoGeneralSetUp."HolidaySavings(%)" / 100) * MonthAmountSaved)) * 7 / 12);
                end else if MonthAmountSaved <= 0 then begin
                    InterestEarned := 0 + InterestEarned;
                end;

            end;
            //.........................6
            NewMonth := 0D;
            NewMonth := CalcDate('6M', StartDate);
            MembersTable2.Reset;
            MembersTable2.SetRange(MembersTable2."No.", MemberNo);
            MembersTable2.SetAutocalcFields(MembersTable2."Withdrawable Savings");
            MembersTable2.SetFilter(MembersTable2."Date Filter", '%1..%2', NewMonth, CalcDate('CM', NewMonth));
            if MembersTable2.Find('-') then begin
                MonthAmountSaved := 0;
                MonthAmountSaved := MembersTable2."Withdrawable Savings";
                if MonthAmountSaved > 0 then begin
                    InterestEarned := (InterestEarned + (((SaccoGeneralSetUp."HolidaySavings(%)" / 100) * MonthAmountSaved)) * 6 / 12);
                end else if MonthAmountSaved <= 0 then begin
                    InterestEarned := 0 + InterestEarned;
                end;

            end;
            //.........................5
            NewMonth := 0D;
            NewMonth := CalcDate('7M', StartDate);
            MembersTable2.Reset;
            MembersTable2.SetRange(MembersTable2."No.", MemberNo);
            MembersTable2.SetAutocalcFields(MembersTable2."Withdrawable Savings");
            MembersTable2.SetFilter(MembersTable2."Date Filter", '%1..%2', NewMonth, CalcDate('CM', NewMonth));
            if MembersTable2.Find('-') then begin
                MonthAmountSaved := 0;
                MonthAmountSaved := MembersTable2."Withdrawable Savings";
                if MonthAmountSaved > 0 then begin
                    InterestEarned := (InterestEarned + (((SaccoGeneralSetUp."HolidaySavings(%)" / 100) * MonthAmountSaved)) * 5 / 12);
                end else if MonthAmountSaved <= 0 then begin
                    InterestEarned := 0 + InterestEarned;
                end;

            end;
            //.........................4
            NewMonth := 0D;
            NewMonth := CalcDate('8M', StartDate);
            MembersTable2.Reset;
            MembersTable2.SetRange(MembersTable2."No.", MemberNo);
            MembersTable2.SetAutocalcFields(MembersTable2."Withdrawable Savings");
            MembersTable2.SetFilter(MembersTable2."Date Filter", '%1..%2', NewMonth, CalcDate('CM', NewMonth));
            if MembersTable2.Find('-') then begin
                MonthAmountSaved := 0;
                MonthAmountSaved := MembersTable2."Withdrawable Savings";
                if MonthAmountSaved > 0 then begin
                    InterestEarned := (InterestEarned + (((SaccoGeneralSetUp."HolidaySavings(%)" / 100) * MonthAmountSaved)) * 4 / 12);
                end else if MonthAmountSaved <= 0 then begin
                    InterestEarned := 0 + InterestEarned;
                end;

            end;
            //.........................3
            NewMonth := 0D;
            NewMonth := CalcDate('9M', StartDate);
            MembersTable2.Reset;
            MembersTable2.SetRange(MembersTable2."No.", MemberNo);
            MembersTable2.SetAutocalcFields(MembersTable2."Withdrawable Savings");
            MembersTable2.SetFilter(MembersTable2."Date Filter", '%1..%2', NewMonth, CalcDate('CM', NewMonth));
            if MembersTable2.Find('-') then begin
                MonthAmountSaved := 0;
                MonthAmountSaved := MembersTable2."Withdrawable Savings";
                if MonthAmountSaved > 0 then begin
                    InterestEarned := (InterestEarned + (((SaccoGeneralSetUp."HolidaySavings(%)" / 100) * MonthAmountSaved)) * 3 / 12);
                end else if MonthAmountSaved <= 0 then begin
                    InterestEarned := 0 + InterestEarned;
                end;

            end;
            //.........................2
            NewMonth := 0D;
            NewMonth := CalcDate('10M', StartDate);
            MembersTable2.Reset;
            MembersTable2.SetRange(MembersTable2."No.", MemberNo);
            MembersTable2.SetAutocalcFields(MembersTable2."Withdrawable Savings");
            MembersTable2.SetFilter(MembersTable2."Date Filter", '%1..%2', NewMonth, CalcDate('CM', NewMonth));
            if MembersTable2.Find('-') then begin
                MonthAmountSaved := 0;
                MonthAmountSaved := MembersTable2."Withdrawable Savings";
                if MonthAmountSaved > 0 then begin
                    InterestEarned := (InterestEarned + (((SaccoGeneralSetUp."HolidaySavings(%)" / 100) * MonthAmountSaved)) * 2 / 12);
                end else if MonthAmountSaved <= 0 then begin
                    InterestEarned := 0 + InterestEarned;
                end;

            end;
            //.........................1
            NewMonth := 0D;
            NewMonth := CalcDate('11M', StartDate);
            MembersTable2.Reset;
            MembersTable2.SetRange(MembersTable2."No.", MemberNo);
            MembersTable2.SetAutocalcFields(MembersTable2."Withdrawable Savings");
            MembersTable2.SetFilter(MembersTable2."Date Filter", '%1..%2', NewMonth, CalcDate('CM', NewMonth));
            if MembersTable2.Find('-') then begin
                MonthAmountSaved := 0;
                MonthAmountSaved := MembersTable2."Withdrawable Savings";
                if MonthAmountSaved > 0 then begin
                    InterestEarned := (InterestEarned + (((SaccoGeneralSetUp."HolidaySavings(%)" / 100) * MonthAmountSaved)) * 1 / 12);
                end else if MonthAmountSaved <= 0 then begin
                    InterestEarned := 0 + InterestEarned;
                end;
            end;
            //.............................
            FnInsertHolidayJournalLines(MemberNo, InterestEarned, MemberHolidaySaving, PostingDate);
            FnINsertAmountsToTable(MemberNo, InterestEarned, MemberHolidaySaving, PostingDate);
        end;
    end;

    local procedure FnInsertHolidayJournalLines(MemberNo: Code[10]; InterestEarned: Decimal; MemberHolidaySaving: Decimal; PostingDate: Date)
    begin
        //....................................Insert Member Saved Amounts start
        //...Dr Member Holiday Account
        LineNo := LineNo + 10000;
        SFactory.FnCreateGnlJournalLine('PAYMENTS', 'HOLIDAY', (Format(Date2dmy(Today, 3)) + '-HOLID'), LineNo, GenJournalLine."transaction type"::"Withdrawable Savings",
        GenJournalLine."account type"::Customer, MemberNo, PostingDate, MemberHolidaySaving, 'BOSA', '',
        'Holiday Savings Transferred To Bank- ' + Format(PostingDate) + 'BNK_0001', '');
        //...Cr Bank Account Paying Out
        LineNo := LineNo + 10000;
        SFactory.FnCreateGnlJournalLine('PAYMENTS', 'HOLIDAY', (Format(Date2dmy(Today, 3)) + '-HOLID'), LineNo, GenJournalLine."transaction type"::"Withdrawable Savings",
        GenJournalLine."account type"::"Bank Account", 'BNK_0001', PostingDate, MemberHolidaySaving * -1, 'BOSA', '',
        'Holiday Savings Paid Out To Member- ' + Format(PostingDate), '');
        //.....................................Insert Member Saved Amounts Stop
        //.....................................Insert Member Interest Earned Amounts Start
        //...Dr Provision Account for Holiday Savings
        LineNo := LineNo + 10000;
        SFactory.FnCreateGnlJournalLine('PAYMENTS', 'HOLIDAY', (Format(Date2dmy(Today, 3)) + '-HOLID'), LineNo, GenJournalLine."transaction type"::"Withdrawable Savings",
        GenJournalLine."account type"::"G/L Account", '201216', PostingDate, InterestEarned, 'BOSA', '',
        'Holiday Savings Interest Earned- ' + Format(PostingDate), '');
        //...Cr Bank Account Paying Out
        LineNo := LineNo + 10000;
        SFactory.FnCreateGnlJournalLine('PAYMENTS', 'HOLIDAY', (Format(Date2dmy(Today, 3)) + '-HOLID'), LineNo, GenJournalLine."transaction type"::"Withdrawable Savings",
        GenJournalLine."account type"::"Bank Account", 'BNK_0001', PostingDate, InterestEarned * -1, 'BOSA', '',
        'Holiday Savings Interest Earned Paid Out To Member- ' + Format(PostingDate), '');
        //....................................Insert Member Interest Earned Amounts stop
    end;

    local procedure FnINsertAmountsToTable(MemberNo: Code[10]; InterestEarned: Decimal; MemberHolidaySaving: Decimal; PostingDate: Date)
    begin
        HolidayTable.Init;
        HolidayTable."Member No" := MemberNo;
        HolidayTable.Year := (Format(Date2dmy(Today, 3)));
        HolidayTable."Holiday Savings Paid Out" := MemberHolidaySaving;
        HolidayTable."Holiday Interest Paid Out" := InterestEarned;
        HolidayTable.Insert(true);
    end;
}

