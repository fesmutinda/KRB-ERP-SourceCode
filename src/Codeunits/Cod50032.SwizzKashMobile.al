#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 50032 SwizzKashMobile
{

    trigger OnRun()
    begin
        // ammmts:=0;
        // LoansRegister.RESET;
        // //LoansRegister.SETRANGE(LoansRegister.Posted,TRUE);
        // LoansRegister.SETAUTOCALCFIELDS(LoansRegister."Outstanding Balance");
        // //LoansRegister.SETFILTER(LoansRegister."Date filter",'%1..%2',0D,20233112D);
        // IF LoansRegister.FIND('-') THEN BEGIN
        //  REPEAT
        //    ammmts+=LoansRegister."Outstanding Balance";
        //  UNTIL LoansRegister.NEXT=0;
        // END;
        // ERROR('....%1',ammmts);
        //MESSAGE(MinistsatementApp('0722982415'));
        //MESSAGE(AccountBalance('0722982415'));
        //MESSAGE(LoanBalance('0722982415'));
        //MESSAGE(LoanGuarantors('0722982415'));
        //MESSAGE(LoansGuaranteed('0722982415'));
    end;

    var
        Members: Record Customer;
        LoansRegister: Record 51371;
        MemberLedgerEntry: Record "Cust. Ledger Entry";
        LoanProducttype: Record 51381;
        LoanGuaranteeDetails: Record 51372;
        ammmts: Decimal;


    procedure MinistsatementApp(phoneNumber: Text) response: Text
    var
        shareCap: Option;
        depContribution: Option;
        loanRepayment: Option;
        runCount: Integer;
    begin
        Members.Reset;
        Members.SetRange(Members."No.", FnGetMemberNo(phoneNumber));
        if Members.Find('-') then begin
            shareCap := MemberLedgerEntry."transaction type"::"Share Capital";
            depContribution := MemberLedgerEntry."transaction type"::"Deposit Contribution";
            loanRepayment := MemberLedgerEntry."transaction type"::"Loan Repayment";

            MemberLedgerEntry.Reset;
            MemberLedgerEntry.SetRange(MemberLedgerEntry."Customer No.", Members."No.");
            MemberLedgerEntry.SetFilter(MemberLedgerEntry."Transaction Type", '%1|%2|%3', shareCap, depContribution, loanRepayment);
            MemberLedgerEntry.Ascending(false);
            if MemberLedgerEntry.Find('-') then begin
                runCount := 0;
                repeat

                    response := response + Format(MemberLedgerEntry."Posting Date") + '|' + Format(MemberLedgerEntry."Transaction Type") + '|' + Format(MemberLedgerEntry.Amount * -1) + ';';
                    runCount := runCount + 1;
                    if (runCount >= 10) then begin
                        exit(response);
                    end;
                until MemberLedgerEntry.Next = 0;
            end else begin
                response := 'No transactions were found';
            end
        end else begin
            response := 'Member not found';
        end
    end;


    procedure AccountBalance(phoneNumber: Text) response: Text
    begin
        Members.Reset;
        Members.SetRange(Members."No.", FnGetMemberNo(phoneNumber));
        if Members.Find('-') then begin
            Members.CalcFields(Members."Current Shares");
            Members.CalcFields(Members."Shares Retained");

            if Members."Current Shares" > 0 then begin
                response := 'Deposits|' + Format(Members."Current Shares") + ';';
            end;
            if Members."Shares Retained" > 0 then begin
                response += 'Share Capital|' + Format(Members."Shares Retained");
            end;
        end
    end;


    procedure LoanBalance(phoneNumber: Text) response: Text
    var
        loanbal: Decimal;
    begin
        Members.Reset;
        Members.SetRange(Members."No.", FnGetMemberNo(phoneNumber));
        if Members.Find('-') then begin
            LoansRegister.Reset;
            LoansRegister.SetRange(LoansRegister."Client Code", Members."No.");
            if LoansRegister.Find('-') then begin
                repeat
                    LoansRegister.CalcFields(LoansRegister."Outstanding Balance", LoansRegister."Oustanding Interest");
                    loanbal := (LoansRegister."Outstanding Balance" + LoansRegister."Oustanding Interest");
                    if loanbal > 0 then begin
                        response += LoansRegister."Loan  No." + '|' + Format(loanbal) + '|' + Format(LoansRegister."Outstanding Balance") + ';';
                    end else begin
                        response := 'NOOUTSTANDINGLOANS';
                    end
                until LoansRegister.Next = 0;
            end else begin
                response := 'NOLOANSTAKEN';
            end;
        end;
    end;


    procedure LoanGuarantors(phoneNumber: Text) guarantors: Text
    begin
        begin
            Members.Reset;
            Members.SetRange(Members."No.", FnGetMemberNo(phoneNumber));
            if Members.Find('-') then begin
                LoanGuaranteeDetails.Reset;
                LoanGuaranteeDetails.SetRange(LoanGuaranteeDetails."Member No", Members."No.");
                if LoanGuaranteeDetails.Find('-') then begin
                    repeat
                        guarantors := guarantors + LoanGuaranteeDetails.Name + '|' + Format(LoanGuaranteeDetails."Amont Guaranteed") + ';';
                    until LoanGuaranteeDetails.Next = 0;
                end else begin
                    guarantors := 'No guarantors were found';
                end;
            end else begin
                guarantors := 'Member not found';
            end
        end;
    end;


    procedure LoansGuaranteed(phoneNumber: Text) response: Text
    begin
        begin
            Members.Reset;
            Members.SetRange(Members."No.", FnGetMemberNo(phoneNumber));
            if Members.Find('-') then begin
                LoanGuaranteeDetails.Reset;
                LoanGuaranteeDetails.SetRange(LoanGuaranteeDetails."Member No", Members."No.");
                //LoanGuaranteeDetails.SETRANGE(LoanGuaranteeDetails."Loan Balance",'>%1',0);
                if LoanGuaranteeDetails.Find('-') then begin
                    repeat
                        response := response + LoanGuaranteeDetails."Loan No" + '|' + Format(LoanGuaranteeDetails."Amont Guaranteed") + ';';
                    until LoanGuaranteeDetails.Next = 0;
                end else begin
                    response := 'You have not guaranteed any loans';
                end;
            end else begin
                response := 'Member not found';
            end;
        end;
    end;


    procedure GetMemberAccounts(phoneNumber: Text) response: Text
    begin
        Members.Reset;
        Members.SetRange(Members."No.", FnGetMemberNo(phoneNumber));
        if Members.Find('-') then begin
            Members.CalcFields(Members."Current Shares");
            Members.CalcFields(Members."Shares Retained");

            if Members."Current Shares" > 0 then begin
                response := 'Deposit Contribution|';
            end;
            if Members."Shares Retained" > 0 then begin
                response += 'Share Capital';
            end;
        end
    end;


    procedure MemberDetails(phoneNumber: Text) response: Text
    begin
        begin
            Members.Reset;
            Members.SetRange(Members."No.", FnGetMemberNo(phoneNumber));
            if Members.Find('-') then begin
                response := Members."No." + '|' + Members.Name + '|' + Format(Members."ID No.") + '|' + Format(Members."Payroll Updated") + '|' + Members."E-Mail";
            end else begin
                response := 'Member not found';
            end
        end;
    end;


    procedure LoanCalculator(productType: Text) response: Text
    begin
        begin
            LoanProducttype.Reset;
            LoanProducttype.SetRange(LoanProducttype."Product Description", productType);
            LoanProducttype.SetFilter(LoanProducttype."Max. Loan Amount", '<>%1', 0);
            if LoanProducttype.Find('-') then begin
                LoanProducttype.CalcFields(LoanProducttype."Max. Loan Amount", LoanProducttype."Min. Loan Amount");
                repeat
                    response := response + Format(LoanProducttype."Product Description") + '|' + Format(LoanProducttype."Interest rate") + '|' + Format(LoanProducttype."No of Installment") + '|' + Format(LoanProducttype."Max. Loan Amount")
                    + '|' + Format(LoanProducttype."Repayment Method") + ';';
                until LoanProducttype.Next = 0;
            end;
        end;
    end;

    local procedure FnGetMemberNo(phoneNumber: Text) accountId: Text
    begin
        begin
            Members.Reset;
            Members.SetRange(Members."Mobile Phone No", phoneNumber);
            if Members.Find('-') then begin
                accountId := Members."No.";
                exit(accountId);
            end;
            Members.Reset;
            Members.SetRange(Members."Phone No.", phoneNumber);
            if Members.Find('-') then begin
                accountId := Members."No.";
                exit(accountId);
            end;
        end;
    end;
}

