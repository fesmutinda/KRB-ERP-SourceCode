codeunit 56130 "LoansClassificationCodeUnit"
{

    trigger OnRun()
    begin
        //FnClassifyLoan
    end;

    var
        LoansReg: Record "Loans Register";
        RepaymentSchedule: Record "Loan Repayment Schedule";
        MemberLedgerEntry: Record "Cust. Ledger Entry";
        LoanBalAsAtFilterDate: Decimal;
        ScheduleExpectedLoanBal: Decimal;
        ArreasPresent: Decimal;
        LoansRegTablw: Record "Loans Register";
        PrincipalRepaymentAmount: Decimal;
        RepaymentScheduleAmount: Decimal;


    procedure FnClassifyLoan(LoanNo: Code[30]; AsAt: Date)

    begin
        //..................Check if Loan expected date of completion is attained,if yes loan is loss

        LoansRegTablw.Reset;
        LoansRegTablw.SetAutocalcFields(LoansRegTablw."Outstanding Balance");
        LoansRegTablw.SetRange(LoansRegTablw."Loan  No.", LoanNo);
        if LoansRegTablw.Find('-') then begin
            LoanBalAsAtFilterDate := GetLoanBalAsAtFilterDate(LoanNo, AsAt);
            IF LoanBalAsAtFilterDate > 0 then begin
                //Check repayment schedule to know the expected balance
                ScheduleExpectedLoanBal := 0;
                if LoansRegTablw."Expected Date of Completion" < AsAt then begin
                    ScheduleExpectedLoanBal := 0;
                end else begin
                    ScheduleExpectedLoanBal := GetExpectedBalAsPerSchedule(LoanNo, AsAt);
                end;

                //Determine if any areas
                ArreasPresent := 0;
                if LoanBalAsAtFilterDate > ScheduleExpectedLoanBal then begin
                    ArreasPresent := LoanBalAsAtFilterDate - ScheduleExpectedLoanBal;
                end
                else
                    if (LoanBalAsAtFilterDate <= ScheduleExpectedLoanBal) then begin
                        ArreasPresent := 0;
                    end;
                //if there are areas then,,determine the days in areas
                if ArreasPresent > 0 then begin
                    //--Function to Get Days In Arrears and modify;
                    FnUpdateLoanStatusWithArrears(LoanNo, ArreasPresent, AsAt);
                end
                else
                    if ArreasPresent <= 0 then begin
                        FnUpdateLoanStatusNonArrears(LoanNo);
                    end;
            end else
                if LoanBalAsAtFilterDate <= 0 then begin
                    LoansRegTablw."Amount in Arrears" := 0;
                    LoansRegTablw."No of Months in Arrears" := 0;
                    LoansRegTablw."Loans Category-SASRA" := LoansRegTablw."Loans Category-SASRA"::Perfoming;
                end;
        end;
    end;

    local procedure GetLoanBalAsAtFilterDate(LoanNos: Code[30]; FilterDate: Date): Decimal
    var
        TotalPayments: Decimal;
    begin
        TotalPayments := 0;
        MemberLedgerEntry.Reset;
        MemberLedgerEntry.SetFilter(MemberLedgerEntry."Transaction Type", '%1|%2|%3|%4|%5', MemberLedgerEntry."transaction type"::Loan, MemberLedgerEntry."transaction type"::"Loan Repayment", MemberLedgerEntry."Transaction Type"::"Interest Due", MemberLedgerEntry."Transaction Type"::"Interest Paid", MemberLedgerEntry."Transaction Type"::"Loan Transfer Charges");
        MemberLedgerEntry.SetRange(MemberLedgerEntry."Loan No", LoanNos);
        MemberLedgerEntry.SetFilter(MemberLedgerEntry."Posting Date", '%1..%2', 0D, FilterDate);
        MemberLedgerEntry.SetRange(MemberLedgerEntry.Reversed, false);
        if MemberLedgerEntry.Find('-') then begin
            repeat
                TotalPayments += MemberLedgerEntry."Amount Posted";
            until MemberLedgerEntry.Next = 0;
        end;
        exit(TotalPayments);
    end;

    local procedure GetExpectedBalAsPerSchedule(LoanNos: Code[20]; DateFiltering: Date): Decimal
    var
        ScheduleExpectedBal: Decimal;
        ActualDate: Date;
        DateFormula: Text;
        i: Integer;
        PrincipalRepayment: Decimal;
        LoanBalance: Decimal;
    begin
        ScheduleExpectedBal := 0;
        DateFormula := '<-1M>';
        ActualDate := CalcDate(DateFormula, DateFiltering);
        RepaymentSchedule.Reset;
        RepaymentSchedule.SetRange(RepaymentSchedule."Loan No.", LoanNos);
        RepaymentSchedule.SetFilter(RepaymentSchedule."Repayment Date", '%1..%2', 0D, DateFiltering);
        if RepaymentSchedule.FindLast then begin
            repeat
                //ScheduleExpectedBal := ROUND(RepaymentSchedule."Loan Balance" + RepaymentSchedule."Principal Repayment");
                ScheduleExpectedBal := ROUND(RepaymentSchedule."Loan Balance");

            until RepaymentSchedule.Next = 0;
        end;
        exit(ScheduleExpectedBal);
    end;



    local procedure FnUpdateLoanStatusNonArrears(LoanNo: Code[30])
    begin
        LoansReg.Reset;
        LoansReg.SetRange(LoansReg."Loan  No.", LoanNo);
        if LoansReg.Find('-') then begin
            LoansReg."Amount in Arrears" := 0;
            LoansReg."No of Months in Arrears" := 0;
            LoansReg."Loans Category" := LoansReg."loans category"::Perfoming;
            LoansReg."Loans Category-SASRA" := LoansReg."Loans Category-SASRA"::Perfoming;
            LoansReg.Modify(true);
            Commit();
        end;
    end;

    local procedure FnUpdateLoanStatusWithArrears(LoanNo: Code[30]; AmountInArearsPassed: Decimal; Datefilter: Date)

    var
        DaysInArreas: Integer;

    begin
        DaysInArreas := 0;
        LoansReg.Reset;
        LoansReg.SetRange(LoansReg."Loan  No.", LoanNo);
        if LoansReg.Find('-') then begin
            if LoansReg."Repayment Start Date" >= Datefilter then begin
                LoansReg."Amount in Arrears" := 0
            end else begin
                LoansReg."Amount in Arrears" := AmountInArearsPassed;
            end;
            RepaymentScheduleAmount := 0;
            RepaymentScheduleAmount := GetRepayment(LoanNo, Datefilter);
            if RepaymentScheduleAmount <= 0 then
                RepaymentScheduleAmount := LoansReg."Loan Principle Repayment";
            //..................................................................................Repayment
            IF LoansReg.Installments = 0 THEN begin
                LoansReg.Installments := 12;
            end;

            if RepaymentScheduleAmount > 0 then begin
                LoansReg."No of Months in Arrears" := ROUND(LoansReg."Amount in Arrears" / RepaymentScheduleAmount, 1, '=');
                DaysInArreas := LoansReg."No of Months in Arrears" * 30;
                LoansReg."Days In Arrears" := DaysInArreas;
            end else begin
                LoansReg."No of Months in Arrears" := 0;
                LoansReg."Days In Arrears" := 0;
            end;

            if (DaysInArreas <= 30) then begin
                LoansReg."Loans Category-SASRA" := LoansReg."Loans Category-SASRA"::Perfoming;
                LoansReg."Loans Category" := LoansReg."Loans Category"::Perfoming;
            end else
                if (DaysInArreas > 30) and (DaysInArreas <= 60) then begin
                    LoansReg."Loans Category-SASRA" := LoansReg."loans category-sasra"::Watch;
                    LoansReg."Loans Category" := LoansReg."Loans Category"::Watch;
                end
                else
                    if (DaysInArreas > 60) and (DaysInArreas <= 180) then begin
                        LoansReg."Loans Category-SASRA" := LoansReg."loans category-sasra"::Substandard;
                        LoansReg."Loans Category" := LoansReg."Loans Category"::Substandard;
                    end else
                        if (DaysInArreas > 180) and (DaysInArreas <= 360) then begin
                            LoansReg."Loans Category-SASRA" := LoansReg."loans category-sasra"::Doubtful;
                            LoansReg."Loans Category" := LoansReg."Loans Category"::Doubtful;
                        end else
                            if (DaysInArreas > 360) then begin
                                LoansReg."Loans Category-SASRA" := LoansReg."loans category-sasra"::Loss;
                                LoansReg."Loans Category" := LoansReg."Loans Category"::Loss;
                            end;

            LoansReg."Days In Arrears" := DaysInArreas;
            LoansReg.Modify(true);
            Commit();
        end;
    end;

    local procedure GetRepayment(LoanNos: Code[20]; DateFiltering: Date): Decimal
    var
        RepaymentAmount: Decimal;
        ActualDate: Date;
        DateFormula: Text;
    begin
        RepaymentAmount := 0;
        DateFormula := '<-1M>';
        ActualDate := CalcDate(DateFormula, DateFiltering);
        RepaymentSchedule.Reset;
        RepaymentSchedule.SetRange(RepaymentSchedule."Loan No.", LoanNos);
        RepaymentSchedule.SetFilter(RepaymentSchedule."Repayment Date", '%1..%2', 0D, DateFiltering);
        if RepaymentSchedule.FindLast then begin
            repeat
                RepaymentAmount := ROUND(RepaymentSchedule."Principal Repayment");
            until RepaymentSchedule.Next = 0;
        end;
        exit(RepaymentAmount);
    end;

    local procedure IsLoanSupposedToBeCompleted(LoanNoss: Code[20]; datefilter: Date): Boolean
    begin
        LoansReg.Reset;
        LoansReg.SetRange(LoansReg."Loan  No.", LoanNoss);
        if LoansReg.Find('-') then begin
            if LoansReg."Expected Date of Completion" < datefilter then begin
                exit(true);
            end
            else
                if LoansReg."Expected Date of Completion" >= datefilter then begin
                    exit(false);
                end;
        end;
    end;


    local procedure GetExpectedPaymentAmount(var LoansRegisterRec: Record "Loans Register"; AsAtDate: Date): Decimal
    var
        LoanRepaymentSchedule: Record "Loan Repayment Schedule";
        Swizzfactory: Codeunit 50009;
        TotalExpected: Decimal;
    begin
        TotalExpected := LoansRegisterRec."Approved Amount";

        LoanRepaymentSchedule.Reset();
        LoanRepaymentSchedule.SetRange("Loan No.", LoansRegisterRec."Loan  No.");

        if LoanRepaymentSchedule.FindSet() then begin
            LoanRepaymentSchedule.Reset();
            LoanRepaymentSchedule.SetRange("Loan No.", LoansRegisterRec."Loan  No.");
            LoanRepaymentSchedule.SetFilter("Repayment Date", '<=%1', AsAtDate);

            if LoanRepaymentSchedule.FindLast() then begin
                TotalExpected := LoanRepaymentSchedule."Loan Balance";
            end;
        end else begin
            Swizzfactory.FnGenerateRepaymentSchedule(LoansRegisterRec."Loan  No.");

            LoanRepaymentSchedule.Reset();
            LoanRepaymentSchedule.SetRange("Loan No.", LoansRegisterRec."Loan  No.");
            LoanRepaymentSchedule.SetFilter("Repayment Date", '<=%1', AsAtDate);

            if LoanRepaymentSchedule.FindLast() then begin
                TotalExpected := Round(LoanRepaymentSchedule."Loan Balance");
            end;
        end;

        // Update the expected loan balance
        //LoansRegisterRec."Expected Loan Balance" := TotalExpected;
        exit(TotalExpected);
    end;

    local procedure GetActualPaymentAmount(var LoansRegisterRec: Record "Loans Register"; AsAtDate: Date): Decimal
    var
        LoanLedgerEntry: Record "Cust. Ledger Entry";
        TotalActual: Decimal;
    begin
        TotalActual := 0;

        LoanLedgerEntry.Reset();
        LoanLedgerEntry.SetRange("Customer No.", LoansRegisterRec."Client Code");
        LoanLedgerEntry.SetRange("Loan No", LoansRegisterRec."Loan  No.");
        LoanLedgerEntry.SetFilter("Transaction Type", '%1|%2|%3|%4|%5',
            LoanLedgerEntry."Transaction Type"::"Loan Repayment",
            LoanLedgerEntry."Transaction Type"::"Interest Paid",
            LoanLedgerEntry."Transaction Type"::Loan,
            LoanLedgerEntry."Transaction Type"::"Interest Due",
            LoanLedgerEntry."Transaction Type"::"Loan Transfer Charges");
        LoanLedgerEntry.SetRange(Reversed, false);
        LoanLedgerEntry.SetFilter("Posting Date", '<=%1', AsAtDate);

        if LoanLedgerEntry.FindSet() then begin
            repeat
                TotalActual += LoanLedgerEntry."Amount Posted";
            until LoanLedgerEntry.Next() = 0;
        end;

        exit(TotalActual);
    end;

    local procedure GetLastDueDateBeforeAsAt(var LoansRegisterRec: Record "Loans Register"; Asat: Date): Date
    var
        LoanRepaymentSchedule: Record "Loan Repayment Schedule";
        LastDate: Date;
    begin
        LastDate := 0D;
        LoanRepaymentSchedule.Reset();
        LoanRepaymentSchedule.SetRange("Loan No.", LoansRegisterRec."Loan  No.");
        LoanRepaymentSchedule.SetFilter("Repayment Date", '<=%1', AsAt);
        LoanRepaymentSchedule.SetCurrentKey("Repayment Date");

        if LoanRepaymentSchedule.FindLast() then
            LastDate := LoanRepaymentSchedule."Repayment Date";

        exit(LastDate);
    end;

    local procedure GetFirstDateWhereInArrears(var LoansRegisterRec: Record "Loans Register"; ActualBalance: Decimal; AsAt: Date): Date
    var
        LoanRepaymentSchedule: Record "Loan Repayment Schedule";
        RunningExpectedBalance: Decimal;
    begin
        LoanRepaymentSchedule.Reset();
        LoanRepaymentSchedule.SetRange("Loan No.", LoansRegisterRec."Loan  No.");
        LoanRepaymentSchedule.SetFilter("Repayment Date", '<=%1', AsAt);
        LoanRepaymentSchedule.SetCurrentKey("Repayment Date");

        if LoanRepaymentSchedule.FindSet() then
            repeat
                // Calculate what balance should be after this repayment
                RunningExpectedBalance := LoanRepaymentSchedule."Loan Balance";

                // First date where actual balance exceeds expected balance
                if ActualBalance > RunningExpectedBalance then
                    exit(LoanRepaymentSchedule."Repayment Date");

            until LoanRepaymentSchedule.Next() = 0;

        exit(0D); // Not in arrears
    end;

}

