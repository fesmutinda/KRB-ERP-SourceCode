// // #pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings


// #pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings

// Codeunit 56011 "Dividends Processing Codeunit2"
// {

//     trigger OnRun()
//     begin
//         //FnGetTheDivTotalPayable('1001');
//     end;

//     var
//         jsavings: Decimal;
//         Deposits: Decimal;
//         walletAccount: Code[20];
//         ShareCapital: Decimal;
//         MemberExitedTable: Record "Membership Exit";
//         DivProg: Record "Dividends Progression";
//         DivTotal: Decimal;
//         "W/Tax": Decimal;
//         CommDiv: Decimal;
//         chargge: Decimal;
//         GenSetUp: Record "Sacco General Set-Up";
//         BDate: Date;
//         FromDate: Date;
//         ToDate: Date;
//         FromDateS: Text;
//         ToDateS: Text;
//         DateFilter: Text;
//         CDiv: Decimal;
//         CInterest: Decimal;
//         Accountclosedon: Date;
//         PayableAmount: Decimal;
//         Amountss: Decimal;
//         // DivProgressionTable: Record "Dividends Progression";
//         GrossTotalDiv: Decimal;
//         LineNo: Integer;
//         SFactory: Codeunit "SWIZZSOFT Factory.";
//         GenJournalLine: Record "Gen. Journal Line";
//         GrossDivOnShares: Decimal;
//         TotalWhtax: Decimal;
//         chargges: Decimal;
//         YearCalc: Text;
//         NetPayableAmount: Decimal;
//         NetPayableAmountFinal: Decimal;
//         ExciseDuty: Decimal;
//         LastDateOfTheDividendYear: Date;
//         MembersReg2: Record Customer;


//         qualifyingShareCapital: Decimal;
//         grossDividendShareCapital: Decimal;
//         qualifyingDeposits: Decimal;
//         grossInterestDeposits: Decimal;
//         totalDividendPaid: Decimal;
//         ShareCapitalBalance: Decimal;
//         Dividends_Posting_Breakdown: Record "Dividends Posting Breakdown";

//     procedure FnAnalyseMemberCategory(MemberNo: Code[30]; StartDate: Date; PostingDate: Date)
//     var
//         MembersReg: Record Customer;
//     begin

//         //start processing
//         //get the last day of the year from startdate
//         LastDateOfTheDividendYear :=
//                             DMY2Date(31, 12, Date2DMY(StartDate, 3));


//         //Reset the table figures
//         MembersReg2.Reset;
//         MembersReg2.SetRange(MembersReg2."No.", MemberNo);
//         if MembersReg2.Find('-') then begin
//             MembersReg2."Qualifying Deposits" := 0;
//             MembersReg2."Qualifying share Capital" := 0;
//             MembersReg2."Gross Dividend Amount Payable" := 0;
//             MembersReg2."Gross Div on share Capital" := 0;
//             MembersReg2."Gross Int On Deposits" := 0;
//             MembersReg2."Bank Charges on processings" := 0;
//             MembersReg2."WithholdingTax on gross div" := 0;
//             MembersReg2."Net Dividend Payable" := 0;
//             MembersReg2.Modify();
//         end;
//         //clean dividends progression table for the member =====Festus
//         MembersReg.Reset;
//         MembersReg.SetRange(MembersReg."No.", MemberNo);
//         MembersReg.SetAutocalcFields(MembersReg."Current Shares", MembersReg."Shares Retained");

//         MembersReg.SetRange(NotDividendEligible, FALSE);
//         //  MembersReg.SetFilter(MembersReg."Shares Retained", '>%1', 0);
//         if MembersReg.Find('-') then begin
//             //declare variables
//             Deposits := 0;
//             ShareCapital := 0;

//             qualifyingShareCapital := 0;
//             grossDividendShareCapital := 0;
//             qualifyingDeposits := 0;
//             grossInterestDeposits := 0;
//             totalDividendPaid := 0;

//             //reset the dividends progression table for the member
//             DivProg.Reset;
//             DivProg.SetCurrentkey("Member No");
//             DivProg.SetRange(DivProg."Member No", MemberNo);
//             if DivProg.Find('-') then begin
//                 DivProg.DeleteAll();
//             end;

//             //process for the 12 months
//             // else if MembersReg.Status <> MembersReg.Status::Withdrawal then begin
//             //Member is not equal to withdrwal
//             Deposits := MembersReg."Current Shares";
//             ShareCapital := MembersReg."Shares Retained";


//             MembersReg."Dividend Amount" := 0;

//             DivProg.Reset;
//             DivProg.SetCurrentkey("Member No");
//             DivProg.SetRange(DivProg."Member No", MemberNo);
//             if DivProg.Find('-') then begin
//                 DivProg.DeleteAll;
//             end;

//             DivTotal := 0;
//             "W/Tax" := 0;
//             CommDiv := 0;
//             chargge := 0;
//             GenSetUp.Get(0);

//             if MembersReg.Status = MembersReg.Status::Withdrawal then begin

//                 //1)Find account closure date
//                 MemberExitedTable.Reset;
//                 MemberExitedTable.SetRange(MemberExitedTable."Member No.", MemberNo);
//                 if MemberExitedTable.FindLast then begin
//                     Accountclosedon := MemberExitedTable."Closing Date";
//                     // if Accountclosedon < LastDateOfTheDividendYear then begin
//                     if (Accountclosedon = 0D) or (Accountclosedon < LastDateOfTheDividendYear) then begin

//                         if MembersReg."Account Category" = MembersReg."Account Category"::"Junior Account" then begin


//                             FnJuniorMemberAnalysis(MembersReg, MemberNo, StartDate, PostingDate);

//                         end else begin




//                             FnWithdrawnMemberAnalysis(MembersReg, MemberNo, StartDate, PostingDate);


//                         end;



//                     end else begin
//                         //Member exited after the year, so prorate dividends


//                         if MembersReg."Account Category" = MembersReg."Account Category"::"Junior Account" then begin


//                             FnJuniorMemberAnalysis(MembersReg, MemberNo, StartDate, PostingDate);

//                         end else begin




//                             FnactiveMemberAnalysis(MembersReg, MemberNo, StartDate, PostingDate);


//                         end;



//                     end;
//                 end else begin
//                     //No record in exit table, but status is withdrawal, so no dividends
//                     //                    FnWithdrawnMemberAnalysis(MembersReg, MemberNo, StartDate, PostingDate);
//                     if MembersReg."Account Category" = MembersReg."Account Category"::"Junior Account" then begin


//                         FnJuniorMemberAnalysis(MembersReg, MemberNo, StartDate, PostingDate);

//                     end else begin




//                         FnWithdrawnMemberAnalysis(MembersReg, MemberNo, StartDate, PostingDate);


//                     end;

//                 end;

//             end else if MembersReg.Status <> MembersReg.Status::Withdrawal then begin
//                 //Active members or any other status apart from withdrawal
//                 if MembersReg."Account Category" = MembersReg."Account Category"::"Junior Account" then begin


//                     FnJuniorMemberAnalysis(MembersReg, MemberNo, StartDate, PostingDate);

//                 end else begin


//                     FnActiveMemberAnalysis(MembersReg, MemberNo, StartDate, PostingDate);


//                 end;

//             end;

//         end;

//     end;

//     procedure FnWithdrawnMemberAnalysis(MembersReg: Record Customer; MemberNo: Code[30]; StartDate: Date; PostingDate: Date)
//     begin
//         //.......Update dividends reg for withdrawn members//1073
//         Deposits := MembersReg."Current Shares";

//         // MembersReg."Account Category" = MembersReg."Account Category"::"Junior Account" then
//         //  Deposits := MembersReg."Current Shares";
//         //ShareCapital := MembersReg."Shares Retained";
//         MembersReg."Dividend Amount" := 0;

//         MembersReg.CalcFields(MembersReg."Current Shares", MembersReg."Shares Retained");


//         if (MembersReg."Shares Retained" > 0.01) then begin
//             CDiv := 0;
//             CDiv := (GenSetUp."Dividend (%)" / 100) * MembersReg."Shares Retained";
//             // CDiv := (((GenSetUp."Dividend (%)" / 100) * ((MembersReg."Shares Retained"))) * (12 / 12));
//         end else if (MembersReg."Shares Retained" < 0.01) then begin
//             CDiv := 0;
//         end;

//         qualifyingShareCapital := MembersReg."Shares Retained";
//         grossDividendShareCapital := grossDividendShareCapital + CDiv;


//         DivProg.Reset;
//         DivProg.SetCurrentkey("Member No");
//         DivProg.SetRange(DivProg."Member No", MemberNo);
//         if DivProg.Find('-') then begin
//             DivProg.DeleteAll;
//         end;

//         DivTotal := 0;
//         "W/Tax" := 0;
//         CommDiv := 0;
//         chargge := 0;
//         GenSetUp.Get();
//         //.................................START ON COMPUTATION

//         //IstMonth START
//         Evaluate(BDate, '01/01/05');
//         FromDate := BDate;
//         ToDate := CalcDate('-1D', StartDate);
//         Evaluate(FromDateS, Format(FromDate));
//         Evaluate(ToDateS, Format(ToDate));

//         MembersReg.Reset;
//         MembersReg.SetCurrentkey("No.");
//         MembersReg.SetRange(MembersReg."No.", MemberNo);
//         MembersReg.SetFilter(MembersReg."Date Filter", '%1..%2', FromDate, CalcDate('CY', StartDate));
//         if MembersReg.Find('-') then begin
//             Evaluate(BDate, '01/01/05');
//             FromDate := BDate;
//             ToDate := CalcDate('-1D', StartDate);
//             Evaluate(FromDateS, Format(FromDate));
//             Evaluate(ToDateS, Format(ToDate));
//             DateFilter := FromDateS + '..' + ToDateS;
//             MembersReg.Reset;
//             MembersReg.SetCurrentkey("No.");
//             MembersReg.SetRange(MembersReg."No.", MemberNo);
//             MembersReg.SetFilter(MembersReg."Date Filter", DateFilter);
//             //.....................
//             if MembersReg.Find('-') then begin
//                 MembersReg.CalcFields(MembersReg."Current Shares", MembersReg."Shares Retained");
//                 CInterest := 0;
//                 // CInterest:=(((GenSetUp."Interest on Deposits (%)"/100)*((MembersReg."Shares Retained")))*(12/12));
//                 //...
//                 // if (MembersReg."Shares Retained" > 0.01) then begin
//                 //     CDiv := 0;
//                 //     CDiv := (GenSetUp."Dividend (%)" / 100) * MembersReg."Shares Retained";

//                 //     // CDiv := (((GenSetUp."Dividend (%)" / 100) * ((MembersReg."Shares Retained"))) * (12 / 12));
//                 // end else if (MembersReg."Shares Retained" < 0.01) then begin
//                 //     CDiv := 0;
//                 // end;
//                 //............
//                 //qualifyingShareCapital := qualifyingShareCapital + ((MembersReg."Shares Retained")) * (12 / 12);
//                 //qualifyingShareCapital := MembersReg."Shares Retained";
//                 grossDividendShareCapital := grossDividendShareCapital + CDiv;

//                 DivTotal := (CDiv + CInterest);
//                 DivProg.Init;
//                 DivProg."Member No" := MembersReg."No.";
//                 DivProg.Date := ToDate;
//                 DivProg."Gross Dividends" := CDiv;
//                 //DivProg."Gross Interest On Deposit":=CInterest;
//                 //MESSAGE('%1',CInterest);
//                 //DivProg."Qualifying Share Capital" := ((MembersReg."Shares Retained")) * (12 / 12);
//                 DivProg."Qualifying Share Capital" := MembersReg."Shares Retained";
//                 DivProg."Witholding Tax" := (CDiv + CInterest) * (GenSetUp."Withholding Tax (%)" / 100);
//                 DivProg."Net Dividends" := (DivProg."Gross Dividends" + DivProg."Gross Interest On Deposit") - DivProg."Witholding Tax";
//                 DivProg."Qualifying Shares" := ((MembersReg."Current Shares")) * (12 / 12);
//                 DivProg.Shares := MembersReg."Current Shares";
//                 DivProg."Share Capital" := MembersReg."Shares Retained";
//                 DivProg.Insert;
//             end;
//             //............................
//         end;
//         //.iST MONTH END

//         //2nd month start
//         FromDate := StartDate;
//         ToDate := CalcDate('-1D', CalcDate('1M', StartDate));
//         Evaluate(FromDateS, Format(FromDate));
//         Evaluate(ToDateS, Format(ToDate));
//         Evaluate(BDate, '01/01/05');

//         DateFilter := FromDateS + '..' + ToDateS;
//         if MembersReg.Find('-') then begin

//             MembersReg.Reset;
//             MembersReg.SetCurrentkey("No.");
//             MembersReg.SetRange(MembersReg."No.", MemberNo);
//             MembersReg.SetFilter(MembersReg."Date Filter", DateFilter);
//             //.....................

//             if MembersReg.Find('-') then begin
//                 MembersReg.CalcFields(MembersReg."Current Shares", MembersReg."Shares Retained");
//                 CInterest := 0;
//                 if (MembersReg."Shares Retained" > 0.01) then begin
//                     CDiv := 0;
//                     //  CDiv := (((GenSetUp."Dividend (%)" / 100) * ((MembersReg."Shares Retained"))) * (11 / 12));
//                 end else if (MembersReg."Shares Retained" < 0.01) then begin
//                     CDiv := 0;
//                 end;
//                 //............
//                 //qualifyingShareCapital := qualifyingShareCapital + ((MembersReg."Shares Retained")) * (11 / 12);
//                 //qualifyingShareCapital := MembersReg."Shares Retained";
//                 //grossDividendShareCapital := grossDividendShareCapital + CDiv;

//                 DivTotal := (CDiv + CInterest);
//                 DivProg.Init;
//                 DivProg."Member No" := MembersReg."No.";
//                 DivProg.Date := ToDate;
//                 DivProg."Gross Dividends" := CDiv;
//                 //DivProg."Gross Interest On Deposit":=CInterest;
//                 //DivProg."Qualifying Share Capital" := ((MembersReg."Shares Retained")) * (11 / 12);
//                 DivProg."Qualifying Share Capital" := MembersReg."Shares Retained";
//                 DivProg."Witholding Tax" := (CDiv + CInterest) * (GenSetUp."Withholding Tax (%)" / 100);
//                 DivProg."Net Dividends" := (DivProg."Gross Dividends" + DivProg."Gross Interest On Deposit") - DivProg."Witholding Tax";
//                 DivProg."Qualifying Shares" := ((MembersReg."Current Shares")) * (11 / 12);
//                 DivProg.Shares := MembersReg."Current Shares";
//                 DivProg."Share Capital" := MembersReg."Shares Retained";
//                 DivProg.Insert;
//             end;
//             //............................
//         end;
//         //2end

//         //.........................3 start
//         FromDate := CalcDate('1M', StartDate);
//         ToDate := CalcDate('-1D', CalcDate('2M', StartDate));
//         Evaluate(FromDateS, Format(FromDate));
//         Evaluate(ToDateS, Format(ToDate));

//         Evaluate(BDate, '01/01/05');

//         DateFilter := FromDateS + '..' + ToDateS;
//         if MembersReg.Find('-') then begin

//             MembersReg.Reset;
//             MembersReg.SetCurrentkey("No.");
//             MembersReg.SetRange(MembersReg."No.", MemberNo);
//             MembersReg.SetFilter(MembersReg."Date Filter", DateFilter);
//             //.....................

//             if MembersReg.Find('-') then begin
//                 MembersReg.CalcFields(MembersReg."Current Shares", MembersReg."Shares Retained");
//                 CInterest := 0;
//                 //...
//                 if (MembersReg."Shares Retained" > 0.01) then begin
//                     CDiv := 0;
//                     //CDiv := (((GenSetUp."Dividend (%)" / 100) * ((MembersReg."Shares Retained"))) * (10 / 12));
//                 end else if (MembersReg."Shares Retained" < 0.01) then begin
//                     CDiv := 0;
//                 end;
//                 //............
//                 //qualifyingShareCapital := qualifyingShareCapital + ((MembersReg."Shares Retained")) * (10 / 12);
//                 //qualifyingShareCapital := MembersReg."Shares Retained";
//                 //grossDividendShareCapital := grossDividendShareCapital + CDiv;

//                 DivTotal := (CDiv + CInterest);
//                 DivProg.Init;
//                 DivProg."Member No" := MembersReg."No.";
//                 DivProg.Date := ToDate;
//                 DivProg."Gross Dividends" := CDiv;
//                 // DivProg."Gross Interest On Deposit":=CInterest;
//                 //DivProg."Qualifying Share Capital" := ((MembersReg."Shares Retained")) * (10 / 12);
//                 DivProg."Qualifying Share Capital" := MembersReg."Shares Retained";
//                 DivProg."Witholding Tax" := (CDiv + CInterest) * (GenSetUp."Withholding Tax (%)" / 100);
//                 DivProg."Net Dividends" := (DivProg."Gross Dividends" + DivProg."Gross Interest On Deposit") - DivProg."Witholding Tax";
//                 DivProg."Qualifying Shares" := ((MembersReg."Current Shares")) * (10 / 12);
//                 DivProg.Shares := MembersReg."Current Shares";
//                 DivProg."Share Capital" := MembersReg."Shares Retained";
//                 DivProg.Insert;
//             end;
//             //............................
//         end;
//         //..............................3 stop

//         //.................4 START
//         FromDate := CalcDate('2M', StartDate);
//         ToDate := CalcDate('-1D', CalcDate('3M', StartDate));
//         Evaluate(FromDateS, Format(FromDate));
//         Evaluate(ToDateS, Format(ToDate));

//         Evaluate(BDate, '01/01/05');

//         DateFilter := FromDateS + '..' + ToDateS;
//         if MembersReg.Find('-') then begin

//             MembersReg.Reset;
//             MembersReg.SetCurrentkey("No.");
//             MembersReg.SetRange(MembersReg."No.", MemberNo);
//             MembersReg.SetFilter(MembersReg."Date Filter", DateFilter);
//             //.....................

//             if MembersReg.Find('-') then begin
//                 MembersReg.CalcFields(MembersReg."Current Shares", MembersReg."Shares Retained");
//                 CInterest := 0;
//                 //...
//                 if (MembersReg."Shares Retained" > 0.01) then begin
//                     CDiv := 0;
//                     //CDiv := (((GenSetUp."Dividend (%)" / 100) * ((MembersReg."Shares Retained"))) * (9 / 12));
//                 end else if (MembersReg."Shares Retained" < 0.01) then begin
//                     CDiv := 0;
//                 end;
//                 //............
//                 //qualifyingShareCapital := qualifyingShareCapital + ((MembersReg."Shares Retained")) * (9 / 12);
//                 //qualifyingShareCapital := MembersReg."Shares Retained";
//                 //grossDividendShareCapital := grossDividendShareCapital + CDiv;

//                 DivTotal := (CDiv + CInterest);
//                 DivProg.Init;
//                 DivProg."Member No" := MembersReg."No.";
//                 DivProg.Date := ToDate;
//                 DivProg."Gross Dividends" := CDiv;
//                 DivProg."Gross Interest On Deposit" := CInterest;
//                 //DivProg."Qualifying Share Capital" := ((MembersReg."Shares Retained")) * (9 / 12);
//                 DivProg."Qualifying Share Capital" := MembersReg."Shares Retained";
//                 DivProg."Witholding Tax" := (CDiv + CInterest) * (GenSetUp."Withholding Tax (%)" / 100);
//                 DivProg."Net Dividends" := (DivProg."Gross Dividends" + DivProg."Gross Interest On Deposit") - DivProg."Witholding Tax";
//                 DivProg."Qualifying Shares" := ((MembersReg."Current Shares")) * (9 / 12);
//                 DivProg.Shares := MembersReg."Current Shares";
//                 DivProg."Share Capital" := MembersReg."Shares Retained";
//                 DivProg.Insert;
//             end;
//             //............................
//         end;
//         //......................4 END
//         /////////////////////5 START
//         FromDate := CalcDate('3M', StartDate);
//         ToDate := CalcDate('-1D', CalcDate('4M', StartDate));
//         Evaluate(FromDateS, Format(FromDate));
//         Evaluate(ToDateS, Format(ToDate));

//         Evaluate(BDate, '01/01/05');

//         DateFilter := FromDateS + '..' + ToDateS;
//         if MembersReg.Find('-') then begin

//             MembersReg.Reset;
//             MembersReg.SetCurrentkey("No.");
//             MembersReg.SetRange(MembersReg."No.", MemberNo);
//             MembersReg.SetFilter(MembersReg."Date Filter", DateFilter);
//             //.....................

//             if MembersReg.Find('-') then begin
//                 MembersReg.CalcFields(MembersReg."Current Shares", MembersReg."Shares Retained");
//                 CInterest := 0;
//                 //...
//                 if (MembersReg."Shares Retained" > 0.01) then begin
//                     CDiv := 0;
//                     //  CDiv := (((GenSetUp."Dividend (%)" / 100) * ((MembersReg."Shares Retained"))) * (8 / 12));
//                 end else if (MembersReg."Shares Retained" < 0.01) then begin
//                     CDiv := 0;
//                 end;
//                 //............
//                 //qualifyingShareCapital := qualifyingShareCapital + ((MembersReg."Shares Retained")) * (8 / 12);
//                 // qualifyingShareCapital := MembersReg."Shares Retained";
//                 //grossDividendShareCapital := grossDividendShareCapital + CDiv;

//                 DivTotal := (CDiv + CInterest);
//                 DivProg.Init;
//                 DivProg."Member No" := MembersReg."No.";
//                 DivProg.Date := ToDate;
//                 DivProg."Gross Dividends" := CDiv;
//                 DivProg."Gross Interest On Deposit" := CInterest;
//                 //DivProg."Qualifying Share Capital" := ((MembersReg."Shares Retained")) * (8 / 12);
//                 DivProg."Qualifying Share Capital" := MembersReg."Shares Retained";
//                 DivProg."Witholding Tax" := (CDiv + CInterest) * (GenSetUp."Withholding Tax (%)" / 100);
//                 DivProg."Net Dividends" := (DivProg."Gross Dividends" + DivProg."Gross Interest On Deposit") - DivProg."Witholding Tax";
//                 DivProg."Qualifying Shares" := ((MembersReg."Current Shares")) * (8 / 12);
//                 DivProg.Shares := MembersReg."Current Shares";
//                 DivProg."Share Capital" := MembersReg."Shares Retained";
//                 DivProg.Insert;
//             end;
//             //............................
//         end;
//         //....................5 END;
//         //........6 START
//         FromDate := CalcDate('4M', StartDate);
//         ToDate := CalcDate('-1D', CalcDate('5M', StartDate));
//         Evaluate(FromDateS, Format(FromDate));
//         Evaluate(ToDateS, Format(ToDate));

//         Evaluate(BDate, '01/01/05');

//         DateFilter := FromDateS + '..' + ToDateS;
//         if MembersReg.Find('-') then begin

//             MembersReg.Reset;
//             MembersReg.SetCurrentkey("No.");
//             MembersReg.SetRange(MembersReg."No.", MemberNo);
//             MembersReg.SetFilter(MembersReg."Date Filter", DateFilter);
//             //.....................

//             if MembersReg.Find('-') then begin
//                 MembersReg.CalcFields(MembersReg."Current Shares", MembersReg."Shares Retained");
//                 CInterest := 0;
//                 //...
//                 if (MembersReg."Shares Retained" > 0.01) then begin
//                     CDiv := 0;
//                     //CDiv := (((GenSetUp."Dividend (%)" / 100) * ((MembersReg."Shares Retained"))) * (7 / 12));
//                 end else if (MembersReg."Shares Retained" < 0.01) then begin
//                     CDiv := 0;
//                 end;
//                 //............
//                 // qualifyingShareCapital := qualifyingShareCapital + ((MembersReg."Shares Retained")) * (7 / 12);
//                 //qualifyingShareCapital := MembersReg."Shares Retained";
//                 //grossDividendShareCapital := grossDividendShareCapital + CDiv;

//                 DivTotal := (CDiv + CInterest);
//                 DivProg.Init;
//                 DivProg."Member No" := MembersReg."No.";
//                 DivProg.Date := ToDate;
//                 DivProg."Gross Dividends" := CDiv;
//                 DivProg."Gross Interest On Deposit" := CInterest;
//                 //DivProg."Qualifying Share Capital" := ((MembersReg."Shares Retained")) * (7 / 12);
//                 DivProg."Qualifying Share Capital" := MembersReg."Shares Retained";
//                 DivProg."Witholding Tax" := (CDiv + CInterest) * (GenSetUp."Withholding Tax (%)" / 100);
//                 DivProg."Net Dividends" := (DivProg."Gross Dividends" + DivProg."Gross Interest On Deposit") - DivProg."Witholding Tax";
//                 DivProg."Qualifying Shares" := ((MembersReg."Current Shares")) * (7 / 12);
//                 DivProg.Shares := MembersReg."Current Shares";
//                 DivProg."Share Capital" := MembersReg."Shares Retained";
//                 DivProg.Insert;
//             end;
//             //............................
//         end;
//         //........6 END

//         //...........7 SART
//         FromDate := CalcDate('5M', StartDate);
//         ToDate := CalcDate('-1D', CalcDate('6M', StartDate));
//         Evaluate(FromDateS, Format(FromDate));
//         Evaluate(ToDateS, Format(ToDate));

//         Evaluate(BDate, '01/01/05');

//         DateFilter := FromDateS + '..' + ToDateS;
//         if MembersReg.Find('-') then begin

//             MembersReg.Reset;
//             MembersReg.SetCurrentkey("No.");
//             MembersReg.SetRange(MembersReg."No.", MemberNo);
//             MembersReg.SetFilter(MembersReg."Date Filter", DateFilter);
//             //.....................

//             if MembersReg.Find('-') then begin
//                 MembersReg.CalcFields(MembersReg."Current Shares", MembersReg."Shares Retained");
//                 CInterest := 0;
//                 //...
//                 if (MembersReg."Shares Retained" > 0.01) then begin
//                     CDiv := 0;
//                     //CDiv := (((GenSetUp."Dividend (%)" / 100) * ((MembersReg."Shares Retained"))) * (6 / 12));
//                 end else if (MembersReg."Shares Retained" < 0.01) then begin
//                     CDiv := 0;
//                 end;
//                 //............
//                 //qualifyingShareCapital := qualifyingShareCapital + ((MembersReg."Shares Retained")) * (6 / 12);
//                 //qualifyingShareCapital := MembersReg."Shares Retained";
//                 //grossDividendShareCapital := grossDividendShareCapital + CDiv;

//                 DivTotal := (CDiv + CInterest);
//                 DivProg.Init;
//                 DivProg."Member No" := MembersReg."No.";
//                 DivProg.Date := ToDate;
//                 DivProg."Gross Dividends" := CDiv;
//                 DivProg."Gross Interest On Deposit" := CInterest;
//                 //DivProg."Qualifying Share Capital" := ((MembersReg."Shares Retained")) * (6 / 12);
//                 DivProg."Qualifying Share Capital" := MembersReg."Shares Retained";
//                 DivProg."Witholding Tax" := (CDiv + CInterest) * (GenSetUp."Withholding Tax (%)" / 100);
//                 DivProg."Net Dividends" := (DivProg."Gross Dividends" + DivProg."Gross Interest On Deposit") - DivProg."Witholding Tax";
//                 DivProg."Qualifying Shares" := ((MembersReg."Current Shares")) * (6 / 12);
//                 DivProg.Shares := MembersReg."Current Shares";
//                 DivProg."Share Capital" := MembersReg."Shares Retained";
//                 DivProg.Insert;
//             end;
//             //............................
//         end;
//         //................7 END
//         //.....8 START
//         FromDate := CalcDate('6M', StartDate);
//         ToDate := CalcDate('-1D', CalcDate('7M', StartDate));
//         Evaluate(FromDateS, Format(FromDate));
//         Evaluate(ToDateS, Format(ToDate));

//         Evaluate(BDate, '01/01/05');

//         DateFilter := FromDateS + '..' + ToDateS;
//         if MembersReg.Find('-') then begin

//             MembersReg.Reset;
//             MembersReg.SetCurrentkey("No.");
//             MembersReg.SetRange(MembersReg."No.", MemberNo);
//             MembersReg.SetFilter(MembersReg."Date Filter", DateFilter);
//             //.....................

//             if MembersReg.Find('-') then begin
//                 MembersReg.CalcFields(MembersReg."Current Shares", MembersReg."Shares Retained");
//                 CInterest := 0;
//                 //...
//                 if (MembersReg."Shares Retained" > 0.01) then begin
//                     CDiv := 0;
//                     //    CDiv := (((GenSetUp."Dividend (%)" / 100) * ((MembersReg."Shares Retained"))) * (5 / 12));
//                 end else if (MembersReg."Shares Retained" < 0.01) then begin
//                     CDiv := 0;
//                 end;
//                 //............
//                 //qualifyingShareCapital := qualifyingShareCapital + ((MembersReg."Shares Retained")) * (5 / 12);
//                 //qualifyingShareCapital := MembersReg."Shares Retained";
//                 //grossDividendShareCapital := grossDividendShareCapital + CDiv;

//                 DivTotal := (CDiv + CInterest);
//                 DivProg.Init;
//                 DivProg."Member No" := MembersReg."No.";
//                 DivProg.Date := ToDate;
//                 DivProg."Gross Dividends" := CDiv;
//                 DivProg."Gross Interest On Deposit" := CInterest;
//                 //DivProg."Qualifying Share Capital" := ((MembersReg."Shares Retained")) * (5 / 12);
//                 DivProg."Qualifying Share Capital" := MembersReg."Shares Retained";
//                 DivProg."Witholding Tax" := (CDiv + CInterest) * (GenSetUp."Withholding Tax (%)" / 100);
//                 DivProg."Net Dividends" := (DivProg."Gross Dividends" + DivProg."Gross Interest On Deposit") - DivProg."Witholding Tax";
//                 DivProg."Qualifying Shares" := ((MembersReg."Current Shares")) * (5 / 12);
//                 DivProg.Shares := MembersReg."Current Shares";
//                 DivProg."Share Capital" := MembersReg."Shares Retained";
//                 DivProg.Insert;
//             end;
//             //............................
//         end;
//         //.......8 END

//         //9 START
//         FromDate := CalcDate('7M', StartDate);
//         ToDate := CalcDate('-1D', CalcDate('8M', StartDate));
//         Evaluate(FromDateS, Format(FromDate));
//         Evaluate(ToDateS, Format(ToDate));

//         Evaluate(BDate, '01/01/05');

//         DateFilter := FromDateS + '..' + ToDateS;
//         if MembersReg.Find('-') then begin

//             MembersReg.Reset;
//             MembersReg.SetCurrentkey("No.");
//             MembersReg.SetRange(MembersReg."No.", MemberNo);
//             MembersReg.SetFilter(MembersReg."Date Filter", DateFilter);
//             //.....................

//             if MembersReg.Find('-') then begin
//                 MembersReg.CalcFields(MembersReg."Current Shares", MembersReg."Shares Retained");
//                 CInterest := 0;
//                 //...
//                 if (MembersReg."Shares Retained" > 0.01) then begin
//                     CDiv := 0;
//                     //CDiv := (((GenSetUp."Dividend (%)" / 100) * ((MembersReg."Shares Retained"))) * (4 / 12));
//                 end else if (MembersReg."Shares Retained" < 0.01) then begin
//                     CDiv := 0;
//                 end;
//                 //............
//                 //qualifyingShareCapital := qualifyingShareCapital + ((MembersReg."Shares Retained")) * (4 / 12);
//                 //qualifyingShareCapital := MembersReg."Shares Retained";
//                 //grossDividendShareCapital := grossDividendShareCapital + CDiv;

//                 DivTotal := (CDiv + CInterest);
//                 DivProg.Init;
//                 DivProg."Member No" := MembersReg."No.";
//                 DivProg.Date := ToDate;
//                 DivProg."Gross Dividends" := CDiv;
//                 DivProg."Gross Interest On Deposit" := CInterest;
//                 //DivProg."Qualifying Share Capital" := ((MembersReg."Shares Retained")) * (4 / 12);
//                 DivProg."Qualifying Share Capital" := MembersReg."Shares Retained";
//                 DivProg."Witholding Tax" := (CDiv + CInterest) * (GenSetUp."Withholding Tax (%)" / 100);
//                 DivProg."Net Dividends" := (DivProg."Gross Dividends" + DivProg."Gross Interest On Deposit") - DivProg."Witholding Tax";
//                 DivProg."Qualifying Shares" := ((MembersReg."Current Shares")) * (4 / 12);
//                 DivProg.Shares := MembersReg."Current Shares";
//                 DivProg."Share Capital" := MembersReg."Shares Retained";
//                 DivProg.Insert;
//             end;
//             //............................
//         end;
//         //.9 END
//         //10 START
//         FromDate := CalcDate('8M', StartDate);
//         ToDate := CalcDate('-1D', CalcDate('9M', StartDate));
//         Evaluate(FromDateS, Format(FromDate));
//         Evaluate(ToDateS, Format(ToDate));

//         Evaluate(BDate, '01/01/05');

//         DateFilter := FromDateS + '..' + ToDateS;
//         if MembersReg.Find('-') then begin

//             MembersReg.Reset;
//             MembersReg.SetCurrentkey("No.");
//             MembersReg.SetRange(MembersReg."No.", MemberNo);
//             MembersReg.SetFilter(MembersReg."Date Filter", DateFilter);
//             //.....................

//             if MembersReg.Find('-') then begin
//                 MembersReg.CalcFields(MembersReg."Current Shares", MembersReg."Shares Retained");
//                 CInterest := 0;
//                 //...
//                 if (MembersReg."Shares Retained" > 0.01) then begin
//                     CDiv := 0;
//                     // CDiv := (((GenSetUp."Dividend (%)" / 100) * ((MembersReg."Shares Retained"))) * (3 / 12));
//                 end else if (MembersReg."Shares Retained" < 0.01) then begin
//                     CDiv := 0;
//                 end;
//                 //............
//                 //qualifyingShareCapital := qualifyingShareCapital + ((MembersReg."Shares Retained")) * (3 / 12);
//                 //qualifyingShareCapital := MembersReg."Shares Retained";
//                 //grossDividendShareCapital := grossDividendShareCapital + CDiv;

//                 DivTotal := (CDiv + CInterest);
//                 DivProg.Init;
//                 DivProg."Member No" := MembersReg."No.";
//                 DivProg.Date := ToDate;
//                 DivProg."Gross Dividends" := CDiv;
//                 DivProg."Gross Interest On Deposit" := CInterest;
//                 //DivProg."Qualifying Share Capital" := ((MembersReg."Shares Retained")) * (3 / 12);

//                 DivProg."Qualifying Share Capital" := MembersReg."Shares Retained";
//                 DivProg."Witholding Tax" := (CDiv + CInterest) * (GenSetUp."Withholding Tax (%)" / 100);
//                 DivProg."Net Dividends" := (DivProg."Gross Dividends" + DivProg."Gross Interest On Deposit") - DivProg."Witholding Tax";
//                 DivProg."Qualifying Shares" := ((MembersReg."Current Shares")) * (3 / 12);
//                 DivProg.Shares := MembersReg."Current Shares";
//                 DivProg."Share Capital" := MembersReg."Shares Retained";
//                 DivProg.Insert;
//             end;
//             //............................
//         end;
//         //10 END
//         //..11 START
//         FromDate := CalcDate('9M', StartDate);
//         ToDate := CalcDate('-1D', CalcDate('10M', StartDate));
//         Evaluate(FromDateS, Format(FromDate));
//         Evaluate(ToDateS, Format(ToDate));

//         Evaluate(BDate, '01/01/05');

//         DateFilter := FromDateS + '..' + ToDateS;
//         if MembersReg.Find('-') then begin

//             MembersReg.Reset;
//             MembersReg.SetCurrentkey("No.");
//             MembersReg.SetRange(MembersReg."No.", MemberNo);
//             MembersReg.SetFilter(MembersReg."Date Filter", DateFilter);
//             //.....................

//             if MembersReg.Find('-') then begin
//                 MembersReg.CalcFields(MembersReg."Current Shares", MembersReg."Shares Retained");
//                 CInterest := 0;
//                 //...
//                 if (MembersReg."Shares Retained" > 0.01) then begin
//                     CDiv := 0;
//                     // CDiv := (((GenSetUp."Dividend (%)" / 100) * ((MembersReg."Shares Retained"))) * (2 / 12));
//                 end else if (MembersReg."Shares Retained" < 0.01) then begin
//                     CDiv := 0;
//                 end;
//                 //............
//                 //qualifyingShareCapital := qualifyingShareCapital + ((MembersReg."Shares Retained")) * (2 / 12);
//                 //qualifyingShareCapital := MembersReg."Shares Retained";
//                 //grossDividendShareCapital := grossDividendShareCapital + CDiv;

//                 DivTotal := (CDiv + CInterest);
//                 DivProg.Init;
//                 DivProg."Member No" := MembersReg."No.";
//                 DivProg.Date := ToDate;
//                 DivProg."Gross Dividends" := CDiv;
//                 DivProg."Gross Interest On Deposit" := CInterest;
//                 //DivProg."Qualifying Share Capital" := ((MembersReg."Shares Retained")) * (2 / 12);
//                 DivProg."Qualifying Share Capital" := MembersReg."Shares Retained";
//                 DivProg."Witholding Tax" := (CDiv + CInterest) * (GenSetUp."Withholding Tax (%)" / 100);
//                 DivProg."Net Dividends" := (DivProg."Gross Dividends" + DivProg."Gross Interest On Deposit") - DivProg."Witholding Tax";
//                 DivProg."Qualifying Shares" := ((MembersReg."Current Shares")) * (2 / 12);
//                 DivProg.Shares := MembersReg."Current Shares";
//                 DivProg."Share Capital" := MembersReg."Shares Retained";
//                 DivProg.Insert;
//             end;
//             //............................
//         end;
//         //.11 END
//         //12 START
//         FromDate := CalcDate('10M', StartDate);
//         ToDate := CalcDate('-1D', CalcDate('11M', StartDate));
//         Evaluate(FromDateS, Format(FromDate));
//         Evaluate(ToDateS, Format(ToDate));

//         Evaluate(BDate, '01/01/05');

//         DateFilter := FromDateS + '..' + ToDateS;
//         if MembersReg.Find('-') then begin

//             MembersReg.Reset;
//             MembersReg.SetCurrentkey("No.");
//             MembersReg.SetRange(MembersReg."No.", MemberNo);
//             MembersReg.SetFilter(MembersReg."Date Filter", DateFilter);
//             //.....................

//             if MembersReg.Find('-') then begin
//                 MembersReg.CalcFields(MembersReg."Current Shares", MembersReg."Shares Retained");
//                 CInterest := 0;
//                 //...
//                 if (MembersReg."Shares Retained" > 0.01) then begin
//                     CDiv := 0;
//                     // CDiv := (((GenSetUp."Dividend (%)" / 100) * ((MembersReg."Shares Retained"))) * (1 / 12));
//                 end else if (MembersReg."Shares Retained" < 0.01) then begin
//                     CDiv := 0;
//                 end;
//                 //............
//                 //qualifyingShareCapital := qualifyingShareCapital + ((MembersReg."Shares Retained")) * (1 / 12);
//                 //qualifyingShareCapital := MembersReg."Shares Retained";
//                 //grossDividendShareCapital := grossDividendShareCapital + CDiv;

//                 DivTotal := (CDiv + CInterest);
//                 DivProg.Init;
//                 DivProg."Member No" := MembersReg."No.";
//                 DivProg.Date := ToDate;
//                 DivProg."Gross Dividends" := CDiv;
//                 DivProg."Gross Interest On Deposit" := CInterest;
//                 //DivProg."Qualifying Share Capital" := ((MembersReg."Shares Retained")) * (1 / 12);
//                 DivProg."Qualifying Share Capital" := MembersReg."Shares Retained";
//                 DivProg."Witholding Tax" := (CDiv + CInterest) * (GenSetUp."Withholding Tax (%)" / 100);
//                 DivProg."Net Dividends" := (DivProg."Gross Dividends" + DivProg."Gross Interest On Deposit") - DivProg."Witholding Tax";
//                 DivProg."Qualifying Shares" := ((MembersReg."Current Shares")) * (1 / 12);
//                 DivProg.Shares := MembersReg."Current Shares";
//                 DivProg."Share Capital" := MembersReg."Shares Retained";
//                 DivProg.Insert;
//             end;
//             //............................
//         end;
//         //12 END
//         //....................get the sum amounts
//         //2030
//         //.................................................Pass GL START
//         PayableAmount := 0;
//         PayableAmount := FnGetTheDivTotalPayable(MemberNo);//Net Amount Paybale to member
//         GrossTotalDiv := 0;
//         GrossTotalDiv := FnGetTheGrossDivPayable(MemberNo);
//         GrossDivOnShares := 0;
//         GrossDivOnShares := (FnGetTheGrossDivOnSharesPayable(MemberNo));
//         TotalWhtax := 0;
//         TotalWhtax := FnGetTotalWhtax(MemberNo);
//         NetPayableAmount := 0;
//         NetPayableAmount := FnGetTheNetPayable(MemberNo);

//         walletAccount := SFactory.FnGetFosaAccount(MemberNo);
//         //POST Dividends here
//         LineNo := LineNo + 10000;
//         //do not deduct 200 for withdrawn members, or members with no interest on deposits


//         totalDividendPaid := grossDividendShareCapital + grossInterestDeposits;
//         if totalDividendPaid < 500 then exit;

//         Dividends_Posting_Breakdown.Init();
//         Dividends_Posting_Breakdown.Entry := GetNextEntryNo();
//         Dividends_Posting_Breakdown."Member Number" := MemberNo;
//         Dividends_Posting_Breakdown."Payroll Number" := MembersReg."Payroll/Staff No";
//         Dividends_Posting_Breakdown.Name := MembersReg.Name;
//         Dividends_Posting_Breakdown."Qualifying Shares" := qualifyingShareCapital;
//         Dividends_Posting_Breakdown."Qualifying Deposits" := qualifyingDeposits;
//         Dividends_Posting_Breakdown."Dividends On Shares" := grossDividendShareCapital;
//         Dividends_Posting_Breakdown."Interest on Deposits" := grossInterestDeposits;



//         FnPostWithdrawnDividends(MemberNo,
//                                 PostingDate,
//                                 GrossTotalDiv,
//                                 TotalWhtax,
//                                 StartDate,
//                                 fnGetMemberShareCapital(MemberNo)
//                                 );
//         ExciseDuty := 0;
//         ExciseDuty := (GenSetUp."Dividend Processing Fee" * (GenSetUp."Excise Duty(%)" / 100));

//         NetPayableAmountFinal := NetPayableAmount - ExciseDuty;

//         //withdrawn members update =they get only grossDividendShareCapital
//         MembersReg."Qualifying Deposits" := 0;// qualifyingDeposits;
//         MembersReg."Qualifying share Capital" := qualifyingShareCapital;
//         MembersReg."Gross Dividend Amount Payable" := grossDividendShareCapital;// totalDividendPaid;
//         MembersReg."Gross Div on share Capital" := grossDividendShareCapital;
//         MembersReg."Gross Int On Deposits" := 0;// grossInterestDeposits;
//         MembersReg."Bank Charges on processings" := 0;//no bank charges on dividend processing
//         MembersReg."WithholdingTax on gross div" := TotalWhtax;
//         MembersReg."Net Dividend Payable" := NetPayableAmountFinal;
//         MembersReg.Modify();

//         Dividends_Posting_Breakdown."Total Earnings" := totalDividendPaid;
//         Dividends_Posting_Breakdown.Insert();

//     end;

//     procedure FnActiveMemberAnalysis(MembersReg: Record Customer; MemberNo: Code[30]; StartDate: Date; PostingDate: Date)
//     begin
//         //............................   //1st Month december previous year
//         Evaluate(BDate, '01/01/05');
//         FromDate := BDate;
//         ToDate := CalcDate('-1D', StartDate);
//         Evaluate(FromDateS, Format(FromDate));
//         Evaluate(ToDateS, Format(ToDate));

//         MembersReg.CalcFields(MembersReg."Current Shares", MembersReg."Shares Retained");


//         if (MembersReg."Shares Retained" > 0.01) then begin
//             CDiv := 0;
//             CDiv := (GenSetUp."Dividend (%)" / 100) * MembersReg."Shares Retained";
//             // CDiv := (((GenSetUp."Dividend (%)" / 100) * ((MembersReg."Shares Retained"))) * (12 / 12));
//         end else if (MembersReg."Shares Retained" < 0.01) then begin
//             CDiv := 0;
//         end;


//         qualifyingShareCapital := MembersReg."Shares Retained";
//         grossDividendShareCapital := grossDividendShareCapital + CDiv;


//         //January
//         MembersReg.Reset;
//         MembersReg.SetCurrentkey("No.");
//         MembersReg.SetRange(MembersReg."No.", MemberNo);
//         MembersReg.SetFilter(MembersReg."Date Filter", '%1..%2', FromDate, CalcDate('CY', StartDate));
//         if MembersReg.Find('-') then begin
//             Evaluate(BDate, '01/01/05');
//             FromDate := BDate;
//             ToDate := CalcDate('-1D', StartDate);
//             Evaluate(FromDateS, Format(FromDate));
//             Evaluate(ToDateS, Format(ToDate));
//             DateFilter := FromDateS + '..' + ToDateS;
//             MembersReg.Reset;
//             MembersReg.SetCurrentkey("No.");
//             MembersReg.SetRange(MembersReg."No.", MemberNo);
//             MembersReg.SetFilter(MembersReg."Date Filter", DateFilter);
//             //.....................

//             if MembersReg.Find('-') then begin
//                 MembersReg.CalcFields(MembersReg."Current Shares", MembersReg."Shares Retained");
//                 if ((MembersReg."Current Shares") > 0.01) then begin
//                     CInterest := 0;
//                     CInterest := (((GenSetUp."Interest on Deposits (%)" / 100) * ((MembersReg."Current Shares"))) * (12 / 12));
//                 end else if (MembersReg."Current Shares" < 0.01) then begin
//                     CInterest := 0;
//                 end;
//                 //...
//                 // if (MembersReg."Shares Retained" > 0.01) then begin
//                 //     CDiv := 0;
//                 //     CDiv := (GenSetUp."Dividend (%)" / 100) * MembersReg."Shares Retained";
//                 //     // CDiv := (((GenSetUp."Dividend (%)" / 100) * ((MembersReg."Shares Retained"))) * (12 / 12));
//                 // end else if (MembersReg."Shares Retained" < 0.01) then begin
//                 //     CDiv := 0;
//                 // end;
//                 //............
//                 //qualifyingShareCapital := qualifyingShareCapital + ((MembersReg."Shares Retained")) * (12 / 12);
//                 qualifyingShareCapital := MembersReg."Shares Retained";
//                 grossDividendShareCapital := grossDividendShareCapital + CDiv;
//                 qualifyingDeposits := qualifyingDeposits + ((MembersReg."Current Shares")) * (12 / 12);
//                 grossInterestDeposits := grossInterestDeposits + CInterest;

//                 DivTotal := (CDiv + CInterest);
//                 DivProg.Init;
//                 DivProg."Member No" := MembersReg."No.";
//                 DivProg.Date := ToDate;
//                 DivProg."Gross Dividends" := CDiv;
//                 DivProg."Gross Interest On Deposit" := CInterest;
//                 //DivProg."Qualifying Share Capital" := ((MembersReg."Shares Retained")) * (12 / 12);
//                 DivProg."Qualifying Share Capital" := MembersReg."Shares Retained";
//                 DivProg."Witholding Tax" := (CDiv + CInterest) * (GenSetUp."Withholding Tax (%)" / 100);
//                 DivProg."Net Dividends" := (DivProg."Gross Dividends" + DivProg."Gross Interest On Deposit") - DivProg."Witholding Tax";
//                 DivProg."Qualifying Shares" := ((MembersReg."Current Shares")) * (12 / 12);
//                 DivProg.Shares := MembersReg."Current Shares";
//                 DivProg."Share Capital" := MembersReg."Shares Retained";
//                 DivProg.Insert;
//             end;
//             //............................
//         end;
//         //............................end first month

//         //.........................February start
//         FromDate := StartDate;
//         ToDate := CalcDate('-1D', CalcDate('1M', StartDate));
//         Evaluate(FromDateS, Format(FromDate));
//         Evaluate(ToDateS, Format(ToDate));
//         Evaluate(BDate, '01/01/05');

//         DateFilter := FromDateS + '..' + ToDateS;
//         if MembersReg.Find('-') then begin

//             MembersReg.Reset;
//             MembersReg.SetCurrentkey("No.");
//             MembersReg.SetRange(MembersReg."No.", MemberNo);
//             MembersReg.SetFilter(MembersReg."Date Filter", DateFilter);
//             //.....................

//             if MembersReg.Find('-') then begin
//                 MembersReg.CalcFields(MembersReg."Current Shares", MembersReg."Shares Retained");
//                 if (MembersReg."Current Shares" > 0.01) then begin
//                     CInterest := 0;
//                     CInterest := (((GenSetUp."Interest on Deposits (%)" / 100) * ((MembersReg."Current Shares"))) * (11 / 12));
//                 end else if (MembersReg."Current Shares" < 0.01) then begin
//                     CInterest := 0;
//                 end;
//                 //...
//                 // if (MembersReg."Shares Retained" > 0.01) then begin
//                 //     CDiv := 0;
//                 //     //CDiv := (((GenSetUp."Dividend (%)" / 100) * ((MembersReg."Shares Retained"))) * (11 / 12));
//                 // end else if (MembersReg."Shares Retained" < 0.01) then begin
//                 //     CDiv := 0;
//                 // end;
//                 //............
//                 //qualifyingShareCapital := qualifyingShareCapital + ((MembersReg."Shares Retained")) * (11 / 12);
//                 //qualifyingShareCapital := MembersReg."Shares Retained";
//                 //grossDividendShareCapital := grossDividendShareCapital + CDiv;
//                 qualifyingDeposits := qualifyingDeposits + ((MembersReg."Current Shares")) * (11 / 12);
//                 grossInterestDeposits := grossInterestDeposits + CInterest;

//                 DivTotal := (CDiv + CInterest);
//                 DivProg.Init;
//                 DivProg."Member No" := MembersReg."No.";
//                 DivProg.Date := ToDate;
//                 DivProg."Gross Dividends" := CDiv;
//                 DivProg."Gross Interest On Deposit" := CInterest;
//                 //DivProg."Qualifying Share Capital" := ((MembersReg."Shares Retained")) * (11 / 12);
//                 DivProg."Qualifying Share Capital" := MembersReg."Shares Retained";
//                 DivProg."Witholding Tax" := (CDiv + CInterest) * (GenSetUp."Withholding Tax (%)" / 100);
//                 DivProg."Net Dividends" := (DivProg."Gross Dividends" + DivProg."Gross Interest On Deposit") - DivProg."Witholding Tax";
//                 DivProg."Qualifying Shares" := ((MembersReg."Current Shares")) * (11 / 12);
//                 DivProg.Shares := MembersReg."Current Shares";
//                 DivProg."Share Capital" := MembersReg."Shares Retained";
//                 DivProg.Insert;
//             end;
//             //............................
//         end;
//         //.........................2 end

//         //.........................3 start
//         FromDate := CalcDate('1M', StartDate);
//         ToDate := CalcDate('-1D', CalcDate('2M', StartDate));
//         Evaluate(FromDateS, Format(FromDate));
//         Evaluate(ToDateS, Format(ToDate));

//         Evaluate(BDate, '01/01/05');

//         DateFilter := FromDateS + '..' + ToDateS;
//         if MembersReg.Find('-') then begin

//             MembersReg.Reset;
//             MembersReg.SetCurrentkey("No.");
//             MembersReg.SetRange(MembersReg."No.", MemberNo);
//             MembersReg.SetFilter(MembersReg."Date Filter", DateFilter);
//             //.....................

//             if MembersReg.Find('-') then begin
//                 MembersReg.CalcFields(MembersReg."Current Shares", MembersReg."Shares Retained");
//                 if (MembersReg."Current Shares" > 0.01) then begin
//                     CInterest := 0;
//                     CInterest := (((GenSetUp."Interest on Deposits (%)" / 100) * ((MembersReg."Current Shares"))) * (10 / 12));
//                 end else if (MembersReg."Current Shares" < 0.01) then begin
//                     CInterest := 0;
//                 end;
//                 //...
//                 // if (MembersReg."Shares Retained" > 0.01) then begin
//                 //     CDiv := 0;
//                 //     //CDiv := (((GenSetUp."Dividend (%)" / 100) * ((MembersReg."Shares Retained"))) * (10 / 12));
//                 // end else if (MembersReg."Shares Retained" < 0.01) then begin
//                 //     CDiv := 0;
//                 // end;
//                 //............
//                 //qualifyingShareCapital := qualifyingShareCapital + ((MembersReg."Shares Retained")) * (10 / 12);
//                 //qualifyingShareCapital := MembersReg."Shares Retained";
//                 //grossDividendShareCapital := grossDividendShareCapital + CDiv;
//                 qualifyingDeposits := qualifyingDeposits + ((MembersReg."Current Shares")) * (10 / 12);
//                 grossInterestDeposits := grossInterestDeposits + CInterest;

//                 DivTotal := (CDiv + CInterest);
//                 DivProg.Init;
//                 DivProg."Member No" := MembersReg."No.";
//                 DivProg.Date := ToDate;
//                 DivProg."Gross Dividends" := CDiv;
//                 DivProg."Gross Interest On Deposit" := CInterest;
//                 // DivProg."Qualifying Share Capital" := ((MembersReg."Shares Retained")) * (10 / 12);
//                 DivProg."Qualifying Share Capital" := MembersReg."Shares Retained";
//                 DivProg."Witholding Tax" := (CDiv + CInterest) * (GenSetUp."Withholding Tax (%)" / 100);
//                 DivProg."Net Dividends" := (DivProg."Gross Dividends" + DivProg."Gross Interest On Deposit") - DivProg."Witholding Tax";
//                 DivProg."Qualifying Shares" := ((MembersReg."Current Shares")) * (10 / 12);
//                 DivProg.Shares := MembersReg."Current Shares";
//                 DivProg."Share Capital" := MembersReg."Shares Retained";
//                 DivProg.Insert;
//             end;
//             //............................
//         end;
//         //..............................3 stop

//         //.................4 START
//         FromDate := CalcDate('2M', StartDate);
//         ToDate := CalcDate('-1D', CalcDate('3M', StartDate));
//         Evaluate(FromDateS, Format(FromDate));
//         Evaluate(ToDateS, Format(ToDate));

//         Evaluate(BDate, '01/01/05');

//         DateFilter := FromDateS + '..' + ToDateS;
//         if MembersReg.Find('-') then begin

//             MembersReg.Reset;
//             MembersReg.SetCurrentkey("No.");
//             MembersReg.SetRange(MembersReg."No.", MemberNo);
//             MembersReg.SetFilter(MembersReg."Date Filter", DateFilter);
//             //.....................

//             if MembersReg.Find('-') then begin
//                 MembersReg.CalcFields(MembersReg."Current Shares", MembersReg."Shares Retained");
//                 if (MembersReg."Current Shares" > 0.01) then begin
//                     CInterest := 0;
//                     CInterest := (((GenSetUp."Interest on Deposits (%)" / 100) * ((MembersReg."Current Shares"))) * (9 / 12));
//                 end else if (MembersReg."Current Shares" < 0.01) then begin
//                     CInterest := 0;
//                 end;
//                 //...
//                 // if (MembersReg."Shares Retained" > 0.01) then begin
//                 //     CDiv := 0;
//                 //     //CDiv := (((GenSetUp."Dividend (%)" / 100) * ((MembersReg."Shares Retained"))) * (9 / 12));
//                 // end else if (MembersReg."Shares Retained" < 0.01) then begin
//                 //     CDiv := 0;
//                 // end;
//                 //............
//                 //qualifyingShareCapital := qualifyingShareCapital + ((MembersReg."Shares Retained")) * (9 / 12);
//                 // qualifyingShareCapital := qualifyingShareCapital + MembersReg."Shares Retained";
//                 //grossDividendShareCapital := grossDividendShareCapital + CDiv;
//                 qualifyingDeposits := qualifyingDeposits + ((MembersReg."Current Shares")) * (9 / 12);
//                 grossInterestDeposits := grossInterestDeposits + CInterest;

//                 DivTotal := (CDiv + CInterest);
//                 DivProg.Init;
//                 DivProg."Member No" := MembersReg."No.";
//                 DivProg.Date := ToDate;
//                 DivProg."Gross Dividends" := CDiv;
//                 DivProg."Gross Interest On Deposit" := CInterest;
//                 //DivProg."Qualifying Share Capital" := ((MembersReg."Shares Retained")) * (9 / 12);
//                 DivProg."Qualifying Share Capital" := MembersReg."Shares Retained";
//                 DivProg."Witholding Tax" := (CDiv + CInterest) * (GenSetUp."Withholding Tax (%)" / 100);
//                 DivProg."Net Dividends" := (DivProg."Gross Dividends" + DivProg."Gross Interest On Deposit") - DivProg."Witholding Tax";
//                 DivProg."Qualifying Shares" := ((MembersReg."Current Shares")) * (9 / 12);
//                 DivProg.Shares := MembersReg."Current Shares";
//                 DivProg."Share Capital" := MembersReg."Shares Retained";
//                 DivProg.Insert;
//             end;
//             //............................
//         end;
//         //......................4 END

//         /////////////////////5 START
//         FromDate := CalcDate('3M', StartDate);
//         ToDate := CalcDate('-1D', CalcDate('4M', StartDate));
//         Evaluate(FromDateS, Format(FromDate));
//         Evaluate(ToDateS, Format(ToDate));

//         Evaluate(BDate, '01/01/05');

//         DateFilter := FromDateS + '..' + ToDateS;
//         if MembersReg.Find('-') then begin

//             MembersReg.Reset;
//             MembersReg.SetCurrentkey("No.");
//             MembersReg.SetRange(MembersReg."No.", MemberNo);
//             MembersReg.SetFilter(MembersReg."Date Filter", DateFilter);
//             //.....................

//             if MembersReg.Find('-') then begin
//                 MembersReg.CalcFields(MembersReg."Current Shares", MembersReg."Shares Retained");
//                 if (MembersReg."Current Shares" > 0.01) then begin
//                     CInterest := 0;
//                     CInterest := (((GenSetUp."Interest on Deposits (%)" / 100) * ((MembersReg."Current Shares"))) * (8 / 12));
//                 end else if (MembersReg."Current Shares" < 0.01) then begin
//                     CInterest := 0;
//                 end;
//                 //...
//                 // if (MembersReg."Shares Retained" > 0.01) then begin
//                 //     CDiv := 0;
//                 //     //  CDiv := (((GenSetUp."Dividend (%)" / 100) * ((MembersReg."Shares Retained"))) * (8 / 12));
//                 // end else if (MembersReg."Shares Retained" < 0.01) then begin
//                 //     CDiv := 0;
//                 // end;
//                 //............
//                 //   qualifyingShareCapital := qualifyingShareCapital + ((MembersReg."Shares Retained")) * (8 / 12);
//                 //qualifyingShareCapital := MembersReg."Shares Retained";
//                 //grossDividendShareCapital := grossDividendShareCapital + CDiv;
//                 qualifyingDeposits := qualifyingDeposits + ((MembersReg."Current Shares")) * (8 / 12);
//                 grossInterestDeposits := grossInterestDeposits + CInterest;

//                 DivTotal := (CDiv + CInterest);
//                 DivProg.Init;
//                 DivProg."Member No" := MembersReg."No.";
//                 DivProg.Date := ToDate;
//                 DivProg."Gross Dividends" := CDiv;
//                 DivProg."Gross Interest On Deposit" := CInterest;
//                 // DivProg."Qualifying Share Capital" := ((MembersReg."Shares Retained")) * (8 / 12);
//                 DivProg."Qualifying Share Capital" := MembersReg."Shares Retained";
//                 DivProg."Witholding Tax" := (CDiv + CInterest) * (GenSetUp."Withholding Tax (%)" / 100);
//                 DivProg."Net Dividends" := (DivProg."Gross Dividends" + DivProg."Gross Interest On Deposit") - DivProg."Witholding Tax";
//                 DivProg."Qualifying Shares" := ((MembersReg."Current Shares")) * (8 / 12);
//                 DivProg.Shares := MembersReg."Current Shares";
//                 DivProg."Share Capital" := MembersReg."Shares Retained";
//                 DivProg.Insert;
//             end;
//             //............................
//         end;
//         //....................5 END;

//         //........6 START
//         FromDate := CalcDate('4M', StartDate);
//         ToDate := CalcDate('-1D', CalcDate('5M', StartDate));
//         Evaluate(FromDateS, Format(FromDate));
//         Evaluate(ToDateS, Format(ToDate));

//         Evaluate(BDate, '01/01/05');

//         DateFilter := FromDateS + '..' + ToDateS;
//         if MembersReg.Find('-') then begin

//             MembersReg.Reset;
//             MembersReg.SetCurrentkey("No.");
//             MembersReg.SetRange(MembersReg."No.", MemberNo);
//             MembersReg.SetFilter(MembersReg."Date Filter", DateFilter);
//             //.....................

//             if MembersReg.Find('-') then begin
//                 MembersReg.CalcFields(MembersReg."Current Shares", MembersReg."Shares Retained");
//                 if (MembersReg."Current Shares" > 0.01) then begin
//                     CInterest := 0;
//                     CInterest := (((GenSetUp."Interest on Deposits (%)" / 100) * ((MembersReg."Current Shares"))) * (7 / 12));
//                 end else if (MembersReg."Current Shares" < 0.01) then begin
//                     CInterest := 0;
//                 end;
//                 //...
//                 // if (MembersReg."Shares Retained" > 0.01) then begin
//                 //     CDiv := 0;
//                 //     //CDiv := (((GenSetUp."Dividend (%)" / 100) * ((MembersReg."Shares Retained"))) * (7 / 12));
//                 // end else if (MembersReg."Shares Retained" < 0.01) then begin
//                 //     CDiv := 0;
//                 // end;
//                 //............
//                 // qualifyingShareCapital := qualifyingShareCapital + ((MembersReg."Shares Retained")) * (7 / 12);
//                 //qualifyingShareCapital := MembersReg."Shares Retained";
//                 //grossDividendShareCapital := grossDividendShareCapital + CDiv;
//                 qualifyingDeposits := qualifyingDeposits + ((MembersReg."Current Shares")) * (7 / 12);
//                 grossInterestDeposits := grossInterestDeposits + CInterest;

//                 DivTotal := (CDiv + CInterest);
//                 DivProg.Init;
//                 DivProg."Member No" := MembersReg."No.";
//                 DivProg.Date := ToDate;
//                 DivProg."Gross Dividends" := CDiv;
//                 DivProg."Gross Interest On Deposit" := CInterest;
//                 // DivProg."Qualifying Share Capital" := ((MembersReg."Shares Retained")) * (7 / 12);
//                 DivProg."Qualifying Share Capital" := MembersReg."Shares Retained";
//                 DivProg."Witholding Tax" := (CDiv + CInterest) * (GenSetUp."Withholding Tax (%)" / 100);
//                 DivProg."Net Dividends" := (DivProg."Gross Dividends" + DivProg."Gross Interest On Deposit") - DivProg."Witholding Tax";
//                 DivProg."Qualifying Shares" := ((MembersReg."Current Shares")) * (7 / 12);
//                 DivProg.Shares := MembersReg."Current Shares";
//                 DivProg."Share Capital" := MembersReg."Shares Retained";
//                 DivProg.Insert;
//             end;
//             //............................
//         end;
//         //........6 END

//         //...........7 SART
//         FromDate := CalcDate('5M', StartDate);
//         ToDate := CalcDate('-1D', CalcDate('6M', StartDate));
//         Evaluate(FromDateS, Format(FromDate));
//         Evaluate(ToDateS, Format(ToDate));

//         Evaluate(BDate, '01/01/05');

//         DateFilter := FromDateS + '..' + ToDateS;
//         if MembersReg.Find('-') then begin

//             MembersReg.Reset;
//             MembersReg.SetCurrentkey("No.");
//             MembersReg.SetRange(MembersReg."No.", MemberNo);
//             MembersReg.SetFilter(MembersReg."Date Filter", DateFilter);
//             //.....................

//             if MembersReg.Find('-') then begin
//                 MembersReg.CalcFields(MembersReg."Current Shares", MembersReg."Shares Retained");
//                 if (MembersReg."Current Shares" > 0.01) then begin
//                     CInterest := 0;
//                     CInterest := (((GenSetUp."Interest on Deposits (%)" / 100) * ((MembersReg."Current Shares"))) * (6 / 12));
//                 end else if (MembersReg."Current Shares" < 0.01) then begin
//                     CInterest := 0;
//                 end;
//                 //...
//                 // if (MembersReg."Shares Retained" > 0.01) then begin
//                 //     CDiv := 0;
//                 //     // CDiv := (((GenSetUp."Dividend (%)" / 100) * ((MembersReg."Shares Retained"))) * (6 / 12));
//                 // end else if (MembersReg."Shares Retained" < 0.01) then begin
//                 //     CDiv := 0;
//                 // end;
//                 //............
//                 //qualifyingShareCapital := qualifyingShareCapital + ((MembersReg."Shares Retained")) * (6 / 12);
//                 //qualifyingShareCapital := MembersReg."Shares Retained";
//                 //grossDividendShareCapital := grossDividendShareCapital + CDiv;
//                 qualifyingDeposits := qualifyingDeposits + ((MembersReg."Current Shares")) * (6 / 12);
//                 grossInterestDeposits := grossInterestDeposits + CInterest;

//                 DivTotal := (CDiv + CInterest);
//                 DivProg.Init;
//                 DivProg."Member No" := MembersReg."No.";
//                 DivProg.Date := ToDate;
//                 DivProg."Gross Dividends" := CDiv;
//                 DivProg."Gross Interest On Deposit" := CInterest;
//                 //DivProg."Qualifying Share Capital" := ((MembersReg."Shares Retained")) * (6 / 12);
//                 DivProg."Qualifying Share Capital" := MembersReg."Shares Retained";
//                 DivProg."Witholding Tax" := (CDiv + CInterest) * (GenSetUp."Withholding Tax (%)" / 100);
//                 DivProg."Net Dividends" := (DivProg."Gross Dividends" + DivProg."Gross Interest On Deposit") - DivProg."Witholding Tax";
//                 DivProg."Qualifying Shares" := ((MembersReg."Current Shares")) * (6 / 12);
//                 DivProg.Shares := MembersReg."Current Shares";
//                 DivProg."Share Capital" := MembersReg."Shares Retained";
//                 DivProg.Insert;
//             end;
//             //............................
//         end;
//         //................7 END

//         //.....8 START
//         FromDate := CalcDate('6M', StartDate);
//         ToDate := CalcDate('-1D', CalcDate('7M', StartDate));
//         Evaluate(FromDateS, Format(FromDate));
//         Evaluate(ToDateS, Format(ToDate));

//         Evaluate(BDate, '01/01/05');

//         DateFilter := FromDateS + '..' + ToDateS;
//         if MembersReg.Find('-') then begin

//             MembersReg.Reset;
//             MembersReg.SetCurrentkey("No.");
//             MembersReg.SetRange(MembersReg."No.", MemberNo);
//             MembersReg.SetFilter(MembersReg."Date Filter", DateFilter);
//             //.....................

//             if MembersReg.Find('-') then begin
//                 MembersReg.CalcFields(MembersReg."Current Shares", MembersReg."Shares Retained");
//                 if (MembersReg."Current Shares" > 0.01) then begin
//                     CInterest := 0;
//                     CInterest := (((GenSetUp."Interest on Deposits (%)" / 100) * ((MembersReg."Current Shares"))) * (5 / 12));
//                 end else if (MembersReg."Current Shares" < 0.01) then begin
//                     CInterest := 0;
//                 end;
//                 //...
//                 // if (MembersReg."Shares Retained" > 0.01) then begin
//                 //     CDiv := 0;
//                 //     // CDiv := (((GenSetUp."Dividend (%)" / 100) * ((MembersReg."Shares Retained"))) * (5 / 12));
//                 // end else if (MembersReg."Shares Retained" < 0.01) then begin
//                 //     CDiv := 0;
//                 // end;
//                 //............
//                 // qualifyingShareCapital := qualifyingShareCapital + ((MembersReg."Shares Retained")) * (5 / 12);
//                 //qualifyingShareCapital := MembersReg."Shares Retained";
//                 //grossDividendShareCapital := grossDividendShareCapital + CDiv;
//                 qualifyingDeposits := qualifyingDeposits + ((MembersReg."Current Shares")) * (5 / 12);
//                 grossInterestDeposits := grossInterestDeposits + CInterest;

//                 DivTotal := (CDiv + CInterest);
//                 DivProg.Init;
//                 DivProg."Member No" := MembersReg."No.";
//                 DivProg.Date := ToDate;
//                 DivProg."Gross Dividends" := CDiv;
//                 DivProg."Gross Interest On Deposit" := CInterest;
//                 //DivProg."Qualifying Share Capital" := ((MembersReg."Shares Retained")) * (5 / 12);
//                 DivProg."Qualifying Share Capital" := MembersReg."Shares Retained";
//                 DivProg."Witholding Tax" := (CDiv + CInterest) * (GenSetUp."Withholding Tax (%)" / 100);
//                 DivProg."Net Dividends" := (DivProg."Gross Dividends" + DivProg."Gross Interest On Deposit") - DivProg."Witholding Tax";
//                 DivProg."Qualifying Shares" := ((MembersReg."Current Shares")) * (5 / 12);
//                 DivProg.Shares := MembersReg."Current Shares";
//                 DivProg."Share Capital" := MembersReg."Shares Retained";
//                 DivProg.Insert;
//             end;
//             //............................
//         end;
//         //.......8 END

//         //9 START
//         FromDate := CalcDate('7M', StartDate);
//         ToDate := CalcDate('-1D', CalcDate('8M', StartDate));
//         Evaluate(FromDateS, Format(FromDate));
//         Evaluate(ToDateS, Format(ToDate));

//         Evaluate(BDate, '01/01/05');

//         DateFilter := FromDateS + '..' + ToDateS;
//         if MembersReg.Find('-') then begin

//             MembersReg.Reset;
//             MembersReg.SetCurrentkey("No.");
//             MembersReg.SetRange(MembersReg."No.", MemberNo);
//             MembersReg.SetFilter(MembersReg."Date Filter", DateFilter);
//             //.....................

//             if MembersReg.Find('-') then begin
//                 MembersReg.CalcFields(MembersReg."Current Shares", MembersReg."Shares Retained");
//                 if (MembersReg."Current Shares" > 0.01) then begin
//                     CInterest := 0;
//                     CInterest := (((GenSetUp."Interest on Deposits (%)" / 100) * ((MembersReg."Current Shares"))) * (4 / 12));
//                 end else if (MembersReg."Current Shares" < 0.01) then begin
//                     CInterest := 0;
//                 end;
//                 //...
//                 // if (MembersReg."Shares Retained" > 0.01) then begin
//                 //     CDiv := 0;
//                 //     // CDiv := (((GenSetUp."Dividend (%)" / 100) * ((MembersReg."Shares Retained"))) * (4 / 12));
//                 // end else if (MembersReg."Shares Retained" < 0.01) then begin
//                 //     CDiv := 0;
//                 // end;
//                 //............
//                 //qualifyingShareCapital := qualifyingShareCapital + ((MembersReg."Shares Retained")) * (4 / 12);
//                 //qualifyingShareCapital := MembersReg."Shares Retained";
//                 //grossDividendShareCapital := grossDividendShareCapital + CDiv;
//                 qualifyingDeposits := qualifyingDeposits + ((MembersReg."Current Shares")) * (4 / 12);
//                 grossInterestDeposits := grossInterestDeposits + CInterest;


//                 DivTotal := (CDiv + CInterest);
//                 DivProg.Init;
//                 DivProg."Member No" := MembersReg."No.";
//                 DivProg.Date := ToDate;
//                 DivProg."Gross Dividends" := CDiv;
//                 DivProg."Gross Interest On Deposit" := CInterest;
//                 //DivProg."Qualifying Share Capital" := ((MembersReg."Shares Retained")) * (4 / 12);
//                 DivProg."Qualifying Share Capital" := MembersReg."Shares Retained";
//                 DivProg."Witholding Tax" := (CDiv + CInterest) * (GenSetUp."Withholding Tax (%)" / 100);
//                 DivProg."Net Dividends" := (DivProg."Gross Dividends" + DivProg."Gross Interest On Deposit") - DivProg."Witholding Tax";
//                 DivProg."Qualifying Shares" := ((MembersReg."Current Shares")) * (4 / 12);
//                 DivProg.Shares := MembersReg."Current Shares";
//                 DivProg."Share Capital" := MembersReg."Shares Retained";
//                 DivProg.Insert;
//             end;
//             //............................
//         end;
//         //.9 END

//         //10 START
//         FromDate := CalcDate('8M', StartDate);
//         ToDate := CalcDate('-1D', CalcDate('9M', StartDate));
//         Evaluate(FromDateS, Format(FromDate));
//         Evaluate(ToDateS, Format(ToDate));

//         Evaluate(BDate, '01/01/05');

//         DateFilter := FromDateS + '..' + ToDateS;
//         if MembersReg.Find('-') then begin

//             MembersReg.Reset;
//             MembersReg.SetCurrentkey("No.");
//             MembersReg.SetRange(MembersReg."No.", MemberNo);
//             MembersReg.SetFilter(MembersReg."Date Filter", DateFilter);
//             //.....................

//             if MembersReg.Find('-') then begin
//                 MembersReg.CalcFields(MembersReg."Current Shares", MembersReg."Shares Retained");
//                 if (MembersReg."Current Shares" > 0.01) then begin
//                     CInterest := 0;
//                     CInterest := (((GenSetUp."Interest on Deposits (%)" / 100) * ((MembersReg."Current Shares"))) * (3 / 12));
//                 end else if (MembersReg."Current Shares" < 0.01) then begin
//                     CInterest := 0;
//                 end;
//                 //...
//                 // if (MembersReg."Shares Retained" > 0.01) then begin
//                 //     CDiv := 0;

//                 //     //  CDiv := (((GenSetUp."Dividend (%)" / 100) * ((MembersReg."Shares Retained"))) * (3 / 12));
//                 // end else if (MembersReg."Shares Retained" < 0.01) then begin
//                 //     CDiv := 0;
//                 // end;
//                 //............
//                 // qualifyingShareCapital := qualifyingShareCapital + ((MembersReg."Shares Retained")) * (3 / 12);
//                 //qualifyingShareCapital := MembersReg."Shares Retained";
//                 //grossDividendShareCapital := grossDividendShareCapital + CDiv;
//                 qualifyingDeposits := qualifyingDeposits + ((MembersReg."Current Shares")) * (3 / 12);
//                 grossInterestDeposits := grossInterestDeposits + CInterest;

//                 DivTotal := (CDiv + CInterest);
//                 DivProg.Init;
//                 DivProg."Member No" := MembersReg."No.";
//                 DivProg.Date := ToDate;
//                 DivProg."Gross Dividends" := CDiv;
//                 DivProg."Gross Interest On Deposit" := CInterest;
//                 //DivProg."Qualifying Share Capital" := ((MembersReg."Shares Retained")) * (3 / 12);
//                 DivProg."Qualifying Share Capital" := MembersReg."Shares Retained";
//                 DivProg."Witholding Tax" := (CDiv + CInterest) * (GenSetUp."Withholding Tax (%)" / 100);
//                 DivProg."Net Dividends" := (DivProg."Gross Dividends" + DivProg."Gross Interest On Deposit") - DivProg."Witholding Tax";
//                 DivProg."Qualifying Shares" := ((MembersReg."Current Shares")) * (3 / 12);
//                 DivProg.Shares := MembersReg."Current Shares";
//                 DivProg."Share Capital" := MembersReg."Shares Retained";
//                 DivProg.Insert;
//             end;
//             //............................
//         end;
//         //10 END

//         //..11 START
//         FromDate := CalcDate('9M', StartDate);
//         ToDate := CalcDate('-1D', CalcDate('10M', StartDate));
//         Evaluate(FromDateS, Format(FromDate));
//         Evaluate(ToDateS, Format(ToDate));

//         Evaluate(BDate, '01/01/05');

//         DateFilter := FromDateS + '..' + ToDateS;
//         if MembersReg.Find('-') then begin

//             MembersReg.Reset;
//             MembersReg.SetCurrentkey("No.");
//             MembersReg.SetRange(MembersReg."No.", MemberNo);
//             MembersReg.SetFilter(MembersReg."Date Filter", DateFilter);
//             //.....................

//             if MembersReg.Find('-') then begin
//                 MembersReg.CalcFields(MembersReg."Current Shares", MembersReg."Shares Retained");
//                 if (MembersReg."Current Shares" > 0.01) then begin
//                     CInterest := 0;
//                     CInterest := (((GenSetUp."Interest on Deposits (%)" / 100) * ((MembersReg."Current Shares"))) * (2 / 12));
//                 end else if (MembersReg."Current Shares" < 0.01) then begin
//                     CInterest := 0;
//                 end;
//                 //...
//                 // if (MembersReg."Shares Retained" > 0.01) then begin
//                 //     CDiv := 0;
//                 //     //CDiv := (((GenSetUp."Dividend (%)" / 100) * ((MembersReg."Shares Retained"))) * (2 / 12));
//                 // end else if (MembersReg."Shares Retained" < 0.01) then begin
//                 //     CDiv := 0;
//                 // end;
//                 //............
//                 //qualifyingShareCapital := qualifyingShareCapital + ((MembersReg."Shares Retained")) * (2 / 12);
//                 //qualifyingShareCapital := MembersReg."Shares Retained";
//                 //grossDividendShareCapital := grossDividendShareCapital + CDiv;
//                 qualifyingDeposits := qualifyingDeposits + ((MembersReg."Current Shares")) * (2 / 12);
//                 grossInterestDeposits := grossInterestDeposits + CInterest;

//                 DivTotal := (CDiv + CInterest);
//                 DivProg.Init;
//                 DivProg."Member No" := MembersReg."No.";
//                 DivProg.Date := ToDate;
//                 DivProg."Gross Dividends" := CDiv;
//                 DivProg."Gross Interest On Deposit" := CInterest;
//                 //DivProg."Qualifying Share Capital" := ((MembersReg."Shares Retained")) * (2 / 12);
//                 DivProg."Qualifying Share Capital" := MembersReg."Shares Retained";
//                 DivProg."Witholding Tax" := (CDiv + CInterest) * (GenSetUp."Withholding Tax (%)" / 100);
//                 DivProg."Net Dividends" := (DivProg."Gross Dividends" + DivProg."Gross Interest On Deposit") - DivProg."Witholding Tax";
//                 DivProg."Qualifying Shares" := ((MembersReg."Current Shares")) * (2 / 12);
//                 DivProg.Shares := MembersReg."Current Shares";
//                 DivProg."Share Capital" := MembersReg."Shares Retained";
//                 DivProg.Insert;
//             end;
//             //............................
//         end;
//         //.11 END

//         //12 START
//         FromDate := CalcDate('10M', StartDate);
//         ToDate := CalcDate('-1D', CalcDate('11M', StartDate));
//         Evaluate(FromDateS, Format(FromDate));
//         Evaluate(ToDateS, Format(ToDate));

//         Evaluate(BDate, '01/01/05');

//         DateFilter := FromDateS + '..' + ToDateS;
//         if MembersReg.Find('-') then begin

//             MembersReg.Reset;
//             MembersReg.SetCurrentkey("No.");
//             MembersReg.SetRange(MembersReg."No.", MemberNo);
//             MembersReg.SetFilter(MembersReg."Date Filter", DateFilter);
//             //.....................

//             if MembersReg.Find('-') then begin
//                 MembersReg.CalcFields(MembersReg."Current Shares", MembersReg."Shares Retained");
//                 if (MembersReg."Current Shares" > 0.01) then begin
//                     CInterest := 0;
//                     CInterest := (((GenSetUp."Interest on Deposits (%)" / 100) * ((MembersReg."Current Shares"))) * (1 / 12));
//                 end else if (MembersReg."Current Shares" < 0.01) then begin
//                     CInterest := 0;
//                 end;
//                 //...
//                 // if (MembersReg."Shares Retained" > 0.01) then begin
//                 //     CDiv := 0;
//                 //     //CDiv := (((GenSetUp."Dividend (%)" / 100) * ((MembersReg."Shares Retained"))) * (1 / 12));
//                 // end else if (MembersReg."Shares Retained" < 0.01) then begin
//                 //     CDiv := 0;
//                 // end;
//                 //............
//                 // qualifyingShareCapital := qualifyingShareCapital + ((MembersReg."Shares Retained")) * (1 / 12);
//                 //qualifyingShareCapital := MembersReg."Shares Retained";
//                 //grossDividendShareCapital := grossDividendShareCapital + CDiv;
//                 qualifyingDeposits := qualifyingDeposits + ((MembersReg."Current Shares")) * (1 / 12);
//                 grossInterestDeposits := grossInterestDeposits + CInterest;

//                 DivTotal := (CDiv + CInterest);
//                 DivProg.Init;
//                 DivProg."Member No" := MembersReg."No.";
//                 DivProg.Date := ToDate;
//                 DivProg."Gross Dividends" := CDiv;
//                 DivProg."Gross Interest On Deposit" := CInterest;
//                 //DivProg."Qualifying Share Capital" := ((MembersReg."Shares Retained")) * (1 / 12);
//                 DivProg."Qualifying Share Capital" := MembersReg."Shares Retained";
//                 DivProg."Witholding Tax" := (CDiv + CInterest) * (GenSetUp."Withholding Tax (%)" / 100);
//                 DivProg."Net Dividends" := (DivProg."Gross Dividends" + DivProg."Gross Interest On Deposit") - DivProg."Witholding Tax";
//                 DivProg."Qualifying Shares" := ((MembersReg."Current Shares")) * (1 / 12);
//                 DivProg.Shares := MembersReg."Current Shares";
//                 DivProg."Share Capital" := MembersReg."Shares Retained";
//                 DivProg.Insert;
//             end;
//             //............................
//         end;


//         //12 END
//         PayableAmount := 0;
//         PayableAmount := FnGetTheDivTotalPayable(MemberNo);//Net Amount Paybale to member
//         GrossTotalDiv := 0;
//         GrossTotalDiv := FnGetTheGrossDivPayable(MemberNo);
//         GrossDivOnShares := 0;
//         GrossDivOnShares := (FnGetTheGrossDivOnSharesPayable(MemberNo));
//         TotalWhtax := 0;
//         TotalWhtax := FnGetTotalWhtax(MemberNo);
//         NetPayableAmount := 0;
//         NetPayableAmount := FnGetTheNetPayable(MemberNo);

//         totalDividendPaid := grossDividendShareCapital + grossInterestDeposits;
//         if totalDividendPaid < 500 then exit;


//         Dividends_Posting_Breakdown.Init();
//         Dividends_Posting_Breakdown.Entry := GetNextEntryNo();
//         Dividends_Posting_Breakdown."Member Number" := MemberNo;
//         Dividends_Posting_Breakdown."Payroll Number" := MembersReg."Payroll/Staff No";
//         Dividends_Posting_Breakdown.Name := MembersReg.Name;
//         Dividends_Posting_Breakdown."Qualifying Shares" := qualifyingShareCapital;
//         Dividends_Posting_Breakdown."Qualifying Deposits" := qualifyingDeposits;
//         Dividends_Posting_Breakdown."Dividends On Shares" := grossDividendShareCapital;
//         Dividends_Posting_Breakdown."Interest on Deposits" := grossInterestDeposits;


//         FnPostDividendstoWallet(MemberNo,
//                                 PostingDate,
//                                 GrossTotalDiv,
//                                 TotalWhtax,
//                                 StartDate
//                                 );

//         //.................................................Pass GL START



//         ExciseDuty := 0;
//         ExciseDuty := (GenSetUp."Dividend Processing Fee" * (GenSetUp."Excise Duty(%)" / 100));
//         //.................................................END PASS GL

//         NetPayableAmountFinal := NetPayableAmount - ExciseDuty;

//         MembersReg."Qualifying Deposits" := qualifyingDeposits;
//         MembersReg."Qualifying share Capital" := qualifyingShareCapital;
//         MembersReg."Gross Dividend Amount Payable" := totalDividendPaid;
//         MembersReg."Gross Div on share Capital" := grossDividendShareCapital;
//         MembersReg."Gross Int On Deposits" := grossInterestDeposits;
//         MembersReg."Bank Charges on processings" := 0;//no bank charges on dividend processing
//         MembersReg."WithholdingTax on gross div" := TotalWhtax;
//         MembersReg."Net Dividend Payable" := NetPayableAmountFinal;
//         MembersReg.Modify();


//         Dividends_Posting_Breakdown."Total Earnings" := totalDividendPaid;
//         Dividends_Posting_Breakdown.Insert();

//     end;



//     // procedure FnWithdrawnMemberAnalysis(MembersReg: Record Customer; MemberNo: Code[30]; StartDate: Date; PostingDate: Date)
//     // begin
//     //     //.......Update dividends reg for withdrawn members//1073
//     //     Deposits := MembersReg."Current Shares";

//     //     if MembersReg."Account Category" = MembersReg."Account Category"::"Junior Account" then
//     //         Deposits := MembersReg."Junior Savings";
//     //     ShareCapital := MembersReg."Shares Retained";
//     //     MembersReg."Dividend Amount" := 0;

//     //     DivProg.Reset;
//     //     DivProg.SetCurrentkey("Member No");
//     //     DivProg.SetRange(DivProg."Member No", MemberNo);
//     //     if DivProg.Find('-') then begin
//     //         DivProg.DeleteAll;
//     //     end;

//     //     DivTotal := 0;
//     //     "W/Tax" := 0;
//     //     CommDiv := 0;
//     //     chargge := 0;
//     //     GenSetUp.Get();
//     //     //.................................START ON COMPUTATION

//     //     //IstMonth START
//     //     Evaluate(BDate, '01/01/05');
//     //     FromDate := BDate;
//     //     ToDate := CalcDate('-1D', StartDate);
//     //     Evaluate(FromDateS, Format(FromDate));
//     //     Evaluate(ToDateS, Format(ToDate));

//     //     MembersReg.Reset;
//     //     MembersReg.SetCurrentkey("No.");
//     //     MembersReg.SetRange(MembersReg."No.", MemberNo);
//     //     MembersReg.SetFilter(MembersReg."Date Filter", '%1..%2', FromDate, CalcDate('CY', StartDate));
//     //     if MembersReg.Find('-') then begin
//     //         Evaluate(BDate, '01/01/05');
//     //         FromDate := BDate;
//     //         ToDate := CalcDate('-1D', StartDate);
//     //         Evaluate(FromDateS, Format(FromDate));
//     //         Evaluate(ToDateS, Format(ToDate));
//     //         DateFilter := FromDateS + '..' + ToDateS;
//     //         MembersReg.Reset;
//     //         MembersReg.SetCurrentkey("No.");
//     //         MembersReg.SetRange(MembersReg."No.", MemberNo);
//     //         MembersReg.SetFilter(MembersReg."Date Filter", DateFilter);
//     //         //.....................
//     //         if MembersReg.Find('-') then begin
//     //             MembersReg.CalcFields(MembersReg."Current Shares", MembersReg."Shares Retained");
//     //             CInterest := 0;
//     //             // CInterest:=(((GenSetUp."Interest on Deposits (%)"/100)*((MembersReg."Shares Retained")))*(12/12));
//     //             //...
//     //             if (MembersReg."Shares Retained" > 0.01) then begin
//     //                 CDiv := 0;
//     //                 CDiv := (((GenSetUp."Dividend (%)" / 100) * ((MembersReg."Shares Retained"))) * (12 / 12));
//     //             end else if (MembersReg."Shares Retained" < 0.01) then begin
//     //                 CDiv := 0;
//     //             end;
//     //             //............
//     //             qualifyingShareCapital := qualifyingShareCapital + ((MembersReg."Shares Retained")) * (12 / 12);
//     //             grossDividendShareCapital := grossDividendShareCapital + CDiv;

//     //             DivTotal := (CDiv + CInterest);
//     //             DivProg.Init;
//     //             DivProg."Member No" := MembersReg."No.";
//     //             DivProg.Date := ToDate;
//     //             DivProg."Gross Dividends" := CDiv;
//     //             //DivProg."Gross Interest On Deposit":=CInterest;
//     //             //MESSAGE('%1',CInterest);
//     //             DivProg."Qualifying Share Capital" := ((MembersReg."Shares Retained")) * (12 / 12);
//     //             DivProg."Witholding Tax" := (CDiv + CInterest) * (GenSetUp."Withholding Tax (%)" / 100);
//     //             DivProg."Net Dividends" := (DivProg."Gross Dividends" + DivProg."Gross Interest On Deposit") - DivProg."Witholding Tax";
//     //             DivProg."Qualifying Shares" := ((MembersReg."Current Shares" + MembersReg."Junior Savings")) * (12 / 12);
//     //             DivProg.Shares := MembersReg."Current Shares" + MembersReg."Junior Savings";
//     //             DivProg."Share Capital" := MembersReg."Shares Retained";
//     //             DivProg.Insert;
//     //         end;
//     //         //............................
//     //     end;
//     //     //.iST MONTH END

//     //     //2nd month start
//     //     FromDate := StartDate;
//     //     ToDate := CalcDate('-1D', CalcDate('1M', StartDate));
//     //     Evaluate(FromDateS, Format(FromDate));
//     //     Evaluate(ToDateS, Format(ToDate));
//     //     Evaluate(BDate, '01/01/05');

//     //     DateFilter := FromDateS + '..' + ToDateS;
//     //     if MembersReg.Find('-') then begin

//     //         MembersReg.Reset;
//     //         MembersReg.SetCurrentkey("No.");
//     //         MembersReg.SetRange(MembersReg."No.", MemberNo);
//     //         MembersReg.SetFilter(MembersReg."Date Filter", DateFilter);
//     //         //.....................

//     //         if MembersReg.Find('-') then begin
//     //             MembersReg.CalcFields(MembersReg."Current Shares", MembersReg."Shares Retained");
//     //             CInterest := 0;
//     //             if (MembersReg."Shares Retained" > 0.01) then begin
//     //                 CDiv := 0;
//     //                 CDiv := (((GenSetUp."Dividend (%)" / 100) * ((MembersReg."Shares Retained"))) * (11 / 12));
//     //             end else if (MembersReg."Shares Retained" < 0.01) then begin
//     //                 CDiv := 0;
//     //             end;
//     //             //............
//     //             qualifyingShareCapital := qualifyingShareCapital + ((MembersReg."Shares Retained")) * (11 / 12);
//     //             grossDividendShareCapital := grossDividendShareCapital + CDiv;

//     //             DivTotal := (CDiv + CInterest);
//     //             DivProg.Init;
//     //             DivProg."Member No" := MembersReg."No.";
//     //             DivProg.Date := ToDate;
//     //             DivProg."Gross Dividends" := CDiv;
//     //             //DivProg."Gross Interest On Deposit":=CInterest;
//     //             DivProg."Qualifying Share Capital" := ((MembersReg."Shares Retained")) * (11 / 12);
//     //             DivProg."Witholding Tax" := (CDiv + CInterest) * (GenSetUp."Withholding Tax (%)" / 100);
//     //             DivProg."Net Dividends" := (DivProg."Gross Dividends" + DivProg."Gross Interest On Deposit") - DivProg."Witholding Tax";
//     //             DivProg."Qualifying Shares" := ((MembersReg."Current Shares")) * (11 / 12);
//     //             DivProg.Shares := MembersReg."Current Shares";
//     //             DivProg."Share Capital" := MembersReg."Shares Retained";
//     //             DivProg.Insert;
//     //         end;
//     //         //............................
//     //     end;
//     //     //2end

//     //     //.........................3 start
//     //     FromDate := CalcDate('1M', StartDate);
//     //     ToDate := CalcDate('-1D', CalcDate('2M', StartDate));
//     //     Evaluate(FromDateS, Format(FromDate));
//     //     Evaluate(ToDateS, Format(ToDate));

//     //     Evaluate(BDate, '01/01/05');

//     //     DateFilter := FromDateS + '..' + ToDateS;
//     //     if MembersReg.Find('-') then begin

//     //         MembersReg.Reset;
//     //         MembersReg.SetCurrentkey("No.");
//     //         MembersReg.SetRange(MembersReg."No.", MemberNo);
//     //         MembersReg.SetFilter(MembersReg."Date Filter", DateFilter);
//     //         //.....................

//     //         if MembersReg.Find('-') then begin
//     //             MembersReg.CalcFields(MembersReg."Current Shares", MembersReg."Shares Retained");
//     //             CInterest := 0;
//     //             //...
//     //             if (MembersReg."Shares Retained" > 0.01) then begin
//     //                 CDiv := 0;
//     //                 CDiv := (((GenSetUp."Dividend (%)" / 100) * ((MembersReg."Shares Retained"))) * (10 / 12));
//     //             end else if (MembersReg."Shares Retained" < 0.01) then begin
//     //                 CDiv := 0;
//     //             end;
//     //             //............
//     //             qualifyingShareCapital := qualifyingShareCapital + ((MembersReg."Shares Retained")) * (10 / 12);
//     //             grossDividendShareCapital := grossDividendShareCapital + CDiv;

//     //             DivTotal := (CDiv + CInterest);
//     //             DivProg.Init;
//     //             DivProg."Member No" := MembersReg."No.";
//     //             DivProg.Date := ToDate;
//     //             DivProg."Gross Dividends" := CDiv;
//     //             // DivProg."Gross Interest On Deposit":=CInterest;
//     //             DivProg."Qualifying Share Capital" := ((MembersReg."Shares Retained")) * (10 / 12);
//     //             DivProg."Witholding Tax" := (CDiv + CInterest) * (GenSetUp."Withholding Tax (%)" / 100);
//     //             DivProg."Net Dividends" := (DivProg."Gross Dividends" + DivProg."Gross Interest On Deposit") - DivProg."Witholding Tax";
//     //             DivProg."Qualifying Shares" := ((MembersReg."Current Shares") + (MembersReg."Junior Savings")) * (10 / 12);
//     //             DivProg.Shares := MembersReg."Current Shares" + MembersReg."Junior Savings";
//     //             DivProg."Share Capital" := MembersReg."Shares Retained";
//     //             DivProg.Insert;
//     //         end;
//     //         //............................
//     //     end;
//     //     //..............................3 stop

//     //     //.................4 START
//     //     FromDate := CalcDate('2M', StartDate);
//     //     ToDate := CalcDate('-1D', CalcDate('3M', StartDate));
//     //     Evaluate(FromDateS, Format(FromDate));
//     //     Evaluate(ToDateS, Format(ToDate));

//     //     Evaluate(BDate, '01/01/05');

//     //     DateFilter := FromDateS + '..' + ToDateS;
//     //     if MembersReg.Find('-') then begin

//     //         MembersReg.Reset;
//     //         MembersReg.SetCurrentkey("No.");
//     //         MembersReg.SetRange(MembersReg."No.", MemberNo);
//     //         MembersReg.SetFilter(MembersReg."Date Filter", DateFilter);
//     //         //.....................

//     //         if MembersReg.Find('-') then begin
//     //             MembersReg.CalcFields(MembersReg."Current Shares", MembersReg."Shares Retained");
//     //             CInterest := 0;
//     //             //...
//     //             if (MembersReg."Shares Retained" > 0.01) then begin
//     //                 CDiv := 0;
//     //                 CDiv := (((GenSetUp."Dividend (%)" / 100) * ((MembersReg."Shares Retained"))) * (9 / 12));
//     //             end else if (MembersReg."Shares Retained" < 0.01) then begin
//     //                 CDiv := 0;
//     //             end;
//     //             //............
//     //             qualifyingShareCapital := qualifyingShareCapital + ((MembersReg."Shares Retained")) * (9 / 12);
//     //             grossDividendShareCapital := grossDividendShareCapital + CDiv;

//     //             DivTotal := (CDiv + CInterest);
//     //             DivProg.Init;
//     //             DivProg."Member No" := MembersReg."No.";
//     //             DivProg.Date := ToDate;
//     //             DivProg."Gross Dividends" := CDiv;
//     //             DivProg."Gross Interest On Deposit" := CInterest;
//     //             DivProg."Qualifying Share Capital" := ((MembersReg."Shares Retained")) * (9 / 12);
//     //             DivProg."Witholding Tax" := (CDiv + CInterest) * (GenSetUp."Withholding Tax (%)" / 100);
//     //             DivProg."Net Dividends" := (DivProg."Gross Dividends" + DivProg."Gross Interest On Deposit") - DivProg."Witholding Tax";
//     //             DivProg."Qualifying Shares" := ((MembersReg."Current Shares") + (MembersReg."Junior Savings")) * (9 / 12);
//     //             DivProg.Shares := MembersReg."Current Shares" + MembersReg."Junior Savings";
//     //             DivProg."Share Capital" := MembersReg."Shares Retained";
//     //             DivProg.Insert;
//     //         end;
//     //         //............................
//     //     end;
//     //     //......................4 END
//     //     /////////////////////5 START
//     //     FromDate := CalcDate('3M', StartDate);
//     //     ToDate := CalcDate('-1D', CalcDate('4M', StartDate));
//     //     Evaluate(FromDateS, Format(FromDate));
//     //     Evaluate(ToDateS, Format(ToDate));

//     //     Evaluate(BDate, '01/01/05');

//     //     DateFilter := FromDateS + '..' + ToDateS;
//     //     if MembersReg.Find('-') then begin

//     //         MembersReg.Reset;
//     //         MembersReg.SetCurrentkey("No.");
//     //         MembersReg.SetRange(MembersReg."No.", MemberNo);
//     //         MembersReg.SetFilter(MembersReg."Date Filter", DateFilter);
//     //         //.....................

//     //         if MembersReg.Find('-') then begin
//     //             MembersReg.CalcFields(MembersReg."Current Shares", MembersReg."Shares Retained");
//     //             CInterest := 0;
//     //             //...
//     //             if (MembersReg."Shares Retained" > 0.01) then begin
//     //                 CDiv := 0;
//     //                 CDiv := (((GenSetUp."Dividend (%)" / 100) * ((MembersReg."Shares Retained"))) * (8 / 12));
//     //             end else if (MembersReg."Shares Retained" < 0.01) then begin
//     //                 CDiv := 0;
//     //             end;
//     //             //............
//     //             qualifyingShareCapital := qualifyingShareCapital + ((MembersReg."Shares Retained")) * (8 / 12);
//     //             grossDividendShareCapital := grossDividendShareCapital + CDiv;

//     //             DivTotal := (CDiv + CInterest);
//     //             DivProg.Init;
//     //             DivProg."Member No" := MembersReg."No.";
//     //             DivProg.Date := ToDate;
//     //             DivProg."Gross Dividends" := CDiv;
//     //             DivProg."Gross Interest On Deposit" := CInterest;
//     //             DivProg."Qualifying Share Capital" := ((MembersReg."Shares Retained")) * (8 / 12);
//     //             DivProg."Witholding Tax" := (CDiv + CInterest) * (GenSetUp."Withholding Tax (%)" / 100);
//     //             DivProg."Net Dividends" := (DivProg."Gross Dividends" + DivProg."Gross Interest On Deposit") - DivProg."Witholding Tax";
//     //             DivProg."Qualifying Shares" := ((MembersReg."Current Shares") + (MembersReg."Junior Savings")) * (8 / 12);
//     //             DivProg.Shares := MembersReg."Current Shares" + MembersReg."Junior Savings";
//     //             DivProg."Share Capital" := MembersReg."Shares Retained";
//     //             DivProg.Insert;
//     //         end;
//     //         //............................
//     //     end;
//     //     //....................5 END;
//     //     //........6 START
//     //     FromDate := CalcDate('4M', StartDate);
//     //     ToDate := CalcDate('-1D', CalcDate('5M', StartDate));
//     //     Evaluate(FromDateS, Format(FromDate));
//     //     Evaluate(ToDateS, Format(ToDate));

//     //     Evaluate(BDate, '01/01/05');

//     //     DateFilter := FromDateS + '..' + ToDateS;
//     //     if MembersReg.Find('-') then begin

//     //         MembersReg.Reset;
//     //         MembersReg.SetCurrentkey("No.");
//     //         MembersReg.SetRange(MembersReg."No.", MemberNo);
//     //         MembersReg.SetFilter(MembersReg."Date Filter", DateFilter);
//     //         //.....................

//     //         if MembersReg.Find('-') then begin
//     //             MembersReg.CalcFields(MembersReg."Current Shares", MembersReg."Shares Retained");
//     //             CInterest := 0;
//     //             //...
//     //             if (MembersReg."Shares Retained" > 0.01) then begin
//     //                 CDiv := 0;
//     //                 CDiv := (((GenSetUp."Dividend (%)" / 100) * ((MembersReg."Shares Retained"))) * (7 / 12));
//     //             end else if (MembersReg."Shares Retained" < 0.01) then begin
//     //                 CDiv := 0;
//     //             end;
//     //             //............
//     //             qualifyingShareCapital := qualifyingShareCapital + ((MembersReg."Shares Retained")) * (7 / 12);
//     //             grossDividendShareCapital := grossDividendShareCapital + CDiv;

//     //             DivTotal := (CDiv + CInterest);
//     //             DivProg.Init;
//     //             DivProg."Member No" := MembersReg."No.";
//     //             DivProg.Date := ToDate;
//     //             DivProg."Gross Dividends" := CDiv;
//     //             DivProg."Gross Interest On Deposit" := CInterest;
//     //             DivProg."Qualifying Share Capital" := ((MembersReg."Shares Retained")) * (7 / 12);
//     //             DivProg."Witholding Tax" := (CDiv + CInterest) * (GenSetUp."Withholding Tax (%)" / 100);
//     //             DivProg."Net Dividends" := (DivProg."Gross Dividends" + DivProg."Gross Interest On Deposit") - DivProg."Witholding Tax";
//     //             DivProg."Qualifying Shares" := ((MembersReg."Current Shares") + (MembersReg."Junior Savings")) * (7 / 12);
//     //             DivProg.Shares := MembersReg."Current Shares" + MembersReg."Junior Savings";
//     //             DivProg."Share Capital" := MembersReg."Shares Retained";
//     //             DivProg.Insert;
//     //         end;
//     //         //............................
//     //     end;
//     //     //........6 END

//     //     //...........7 SART
//     //     FromDate := CalcDate('5M', StartDate);
//     //     ToDate := CalcDate('-1D', CalcDate('6M', StartDate));
//     //     Evaluate(FromDateS, Format(FromDate));
//     //     Evaluate(ToDateS, Format(ToDate));

//     //     Evaluate(BDate, '01/01/05');

//     //     DateFilter := FromDateS + '..' + ToDateS;
//     //     if MembersReg.Find('-') then begin

//     //         MembersReg.Reset;
//     //         MembersReg.SetCurrentkey("No.");
//     //         MembersReg.SetRange(MembersReg."No.", MemberNo);
//     //         MembersReg.SetFilter(MembersReg."Date Filter", DateFilter);
//     //         //.....................

//     //         if MembersReg.Find('-') then begin
//     //             MembersReg.CalcFields(MembersReg."Current Shares", MembersReg."Shares Retained");
//     //             CInterest := 0;
//     //             //...
//     //             if (MembersReg."Shares Retained" > 0.01) then begin
//     //                 CDiv := 0;
//     //                 CDiv := (((GenSetUp."Dividend (%)" / 100) * ((MembersReg."Shares Retained"))) * (6 / 12));
//     //             end else if (MembersReg."Shares Retained" < 0.01) then begin
//     //                 CDiv := 0;
//     //             end;
//     //             //............
//     //             qualifyingShareCapital := qualifyingShareCapital + ((MembersReg."Shares Retained")) * (6 / 12);
//     //             grossDividendShareCapital := grossDividendShareCapital + CDiv;

//     //             DivTotal := (CDiv + CInterest);
//     //             DivProg.Init;
//     //             DivProg."Member No" := MembersReg."No.";
//     //             DivProg.Date := ToDate;
//     //             DivProg."Gross Dividends" := CDiv;
//     //             DivProg."Gross Interest On Deposit" := CInterest;
//     //             DivProg."Qualifying Share Capital" := ((MembersReg."Shares Retained")) * (6 / 12);
//     //             DivProg."Witholding Tax" := (CDiv + CInterest) * (GenSetUp."Withholding Tax (%)" / 100);
//     //             DivProg."Net Dividends" := (DivProg."Gross Dividends" + DivProg."Gross Interest On Deposit") - DivProg."Witholding Tax";
//     //             DivProg."Qualifying Shares" := ((MembersReg."Current Shares") + (MembersReg."Junior Savings")) * (6 / 12);
//     //             DivProg.Shares := MembersReg."Current Shares" + MembersReg."Junior Savings";
//     //             DivProg."Share Capital" := MembersReg."Shares Retained";
//     //             DivProg.Insert;
//     //         end;
//     //         //............................
//     //     end;
//     //     //................7 END
//     //     //.....8 START
//     //     FromDate := CalcDate('6M', StartDate);
//     //     ToDate := CalcDate('-1D', CalcDate('7M', StartDate));
//     //     Evaluate(FromDateS, Format(FromDate));
//     //     Evaluate(ToDateS, Format(ToDate));

//     //     Evaluate(BDate, '01/01/05');

//     //     DateFilter := FromDateS + '..' + ToDateS;
//     //     if MembersReg.Find('-') then begin

//     //         MembersReg.Reset;
//     //         MembersReg.SetCurrentkey("No.");
//     //         MembersReg.SetRange(MembersReg."No.", MemberNo);
//     //         MembersReg.SetFilter(MembersReg."Date Filter", DateFilter);
//     //         //.....................

//     //         if MembersReg.Find('-') then begin
//     //             MembersReg.CalcFields(MembersReg."Current Shares", MembersReg."Shares Retained");
//     //             CInterest := 0;
//     //             //...
//     //             if (MembersReg."Shares Retained" > 0.01) then begin
//     //                 CDiv := 0;
//     //                 CDiv := (((GenSetUp."Dividend (%)" / 100) * ((MembersReg."Shares Retained"))) * (5 / 12));
//     //             end else if (MembersReg."Shares Retained" < 0.01) then begin
//     //                 CDiv := 0;
//     //             end;
//     //             //............
//     //             qualifyingShareCapital := qualifyingShareCapital + ((MembersReg."Shares Retained")) * (5 / 12);
//     //             grossDividendShareCapital := grossDividendShareCapital + CDiv;

//     //             DivTotal := (CDiv + CInterest);
//     //             DivProg.Init;
//     //             DivProg."Member No" := MembersReg."No.";
//     //             DivProg.Date := ToDate;
//     //             DivProg."Gross Dividends" := CDiv;
//     //             DivProg."Gross Interest On Deposit" := CInterest;
//     //             DivProg."Qualifying Share Capital" := ((MembersReg."Shares Retained")) * (5 / 12);
//     //             DivProg."Witholding Tax" := (CDiv + CInterest) * (GenSetUp."Withholding Tax (%)" / 100);
//     //             DivProg."Net Dividends" := (DivProg."Gross Dividends" + DivProg."Gross Interest On Deposit") - DivProg."Witholding Tax";
//     //             DivProg."Qualifying Shares" := ((MembersReg."Current Shares") + (MembersReg."Junior Savings")) * (5 / 12);
//     //             DivProg.Shares := MembersReg."Current Shares" + MembersReg."Junior Savings";
//     //             DivProg."Share Capital" := MembersReg."Shares Retained";
//     //             DivProg.Insert;
//     //         end;
//     //         //............................
//     //     end;
//     //     //.......8 END

//     //     //9 START
//     //     FromDate := CalcDate('7M', StartDate);
//     //     ToDate := CalcDate('-1D', CalcDate('8M', StartDate));
//     //     Evaluate(FromDateS, Format(FromDate));
//     //     Evaluate(ToDateS, Format(ToDate));

//     //     Evaluate(BDate, '01/01/05');

//     //     DateFilter := FromDateS + '..' + ToDateS;
//     //     if MembersReg.Find('-') then begin

//     //         MembersReg.Reset;
//     //         MembersReg.SetCurrentkey("No.");
//     //         MembersReg.SetRange(MembersReg."No.", MemberNo);
//     //         MembersReg.SetFilter(MembersReg."Date Filter", DateFilter);
//     //         //.....................

//     //         if MembersReg.Find('-') then begin
//     //             MembersReg.CalcFields(MembersReg."Current Shares", MembersReg."Shares Retained");
//     //             CInterest := 0;
//     //             //...
//     //             if (MembersReg."Shares Retained" > 0.01) then begin
//     //                 CDiv := 0;
//     //                 CDiv := (((GenSetUp."Dividend (%)" / 100) * ((MembersReg."Shares Retained"))) * (4 / 12));
//     //             end else if (MembersReg."Shares Retained" < 0.01) then begin
//     //                 CDiv := 0;
//     //             end;
//     //             //............
//     //             qualifyingShareCapital := qualifyingShareCapital + ((MembersReg."Shares Retained")) * (4 / 12);
//     //             grossDividendShareCapital := grossDividendShareCapital + CDiv;

//     //             DivTotal := (CDiv + CInterest);
//     //             DivProg.Init;
//     //             DivProg."Member No" := MembersReg."No.";
//     //             DivProg.Date := ToDate;
//     //             DivProg."Gross Dividends" := CDiv;
//     //             DivProg."Gross Interest On Deposit" := CInterest;
//     //             DivProg."Qualifying Share Capital" := ((MembersReg."Shares Retained")) * (4 / 12);
//     //             DivProg."Witholding Tax" := (CDiv + CInterest) * (GenSetUp."Withholding Tax (%)" / 100);
//     //             DivProg."Net Dividends" := (DivProg."Gross Dividends" + DivProg."Gross Interest On Deposit") - DivProg."Witholding Tax";
//     //             DivProg."Qualifying Shares" := ((MembersReg."Current Shares") + (MembersReg."Junior Savings")) * (4 / 12);
//     //             DivProg.Shares := MembersReg."Current Shares" + MembersReg."Junior Savings";
//     //             DivProg."Share Capital" := MembersReg."Shares Retained";
//     //             DivProg.Insert;
//     //         end;
//     //         //............................
//     //     end;
//     //     //.9 END
//     //     //10 START
//     //     FromDate := CalcDate('8M', StartDate);
//     //     ToDate := CalcDate('-1D', CalcDate('9M', StartDate));
//     //     Evaluate(FromDateS, Format(FromDate));
//     //     Evaluate(ToDateS, Format(ToDate));

//     //     Evaluate(BDate, '01/01/05');

//     //     DateFilter := FromDateS + '..' + ToDateS;
//     //     if MembersReg.Find('-') then begin

//     //         MembersReg.Reset;
//     //         MembersReg.SetCurrentkey("No.");
//     //         MembersReg.SetRange(MembersReg."No.", MemberNo);
//     //         MembersReg.SetFilter(MembersReg."Date Filter", DateFilter);
//     //         //.....................

//     //         if MembersReg.Find('-') then begin
//     //             MembersReg.CalcFields(MembersReg."Current Shares", MembersReg."Shares Retained");
//     //             CInterest := 0;
//     //             //...
//     //             if (MembersReg."Shares Retained" > 0.01) then begin
//     //                 CDiv := 0;
//     //                 CDiv := (((GenSetUp."Dividend (%)" / 100) * ((MembersReg."Shares Retained"))) * (3 / 12));
//     //             end else if (MembersReg."Shares Retained" < 0.01) then begin
//     //                 CDiv := 0;
//     //             end;
//     //             //............
//     //             qualifyingShareCapital := qualifyingShareCapital + ((MembersReg."Shares Retained")) * (3 / 12);
//     //             grossDividendShareCapital := grossDividendShareCapital + CDiv;

//     //             DivTotal := (CDiv + CInterest);
//     //             DivProg.Init;
//     //             DivProg."Member No" := MembersReg."No.";
//     //             DivProg.Date := ToDate;
//     //             DivProg."Gross Dividends" := CDiv;
//     //             DivProg."Gross Interest On Deposit" := CInterest;
//     //             DivProg."Qualifying Share Capital" := ((MembersReg."Shares Retained")) * (3 / 12);
//     //             DivProg."Witholding Tax" := (CDiv + CInterest) * (GenSetUp."Withholding Tax (%)" / 100);
//     //             DivProg."Net Dividends" := (DivProg."Gross Dividends" + DivProg."Gross Interest On Deposit") - DivProg."Witholding Tax";
//     //             DivProg."Qualifying Shares" := ((MembersReg."Current Shares") + (MembersReg."Junior Savings")) * (3 / 12);
//     //             DivProg.Shares := MembersReg."Current Shares" + MembersReg."Junior Savings";
//     //             DivProg."Share Capital" := MembersReg."Shares Retained";
//     //             DivProg.Insert;
//     //         end;
//     //         //............................
//     //     end;
//     //     //10 END
//     //     //..11 START
//     //     FromDate := CalcDate('9M', StartDate);
//     //     ToDate := CalcDate('-1D', CalcDate('10M', StartDate));
//     //     Evaluate(FromDateS, Format(FromDate));
//     //     Evaluate(ToDateS, Format(ToDate));

//     //     Evaluate(BDate, '01/01/05');

//     //     DateFilter := FromDateS + '..' + ToDateS;
//     //     if MembersReg.Find('-') then begin

//     //         MembersReg.Reset;
//     //         MembersReg.SetCurrentkey("No.");
//     //         MembersReg.SetRange(MembersReg."No.", MemberNo);
//     //         MembersReg.SetFilter(MembersReg."Date Filter", DateFilter);
//     //         //.....................

//     //         if MembersReg.Find('-') then begin
//     //             MembersReg.CalcFields(MembersReg."Current Shares", MembersReg."Shares Retained");
//     //             CInterest := 0;
//     //             //...
//     //             if (MembersReg."Shares Retained" > 0.01) then begin
//     //                 CDiv := 0;
//     //                 CDiv := (((GenSetUp."Dividend (%)" / 100) * ((MembersReg."Shares Retained"))) * (2 / 12));
//     //             end else if (MembersReg."Shares Retained" < 0.01) then begin
//     //                 CDiv := 0;
//     //             end;
//     //             //............
//     //             qualifyingShareCapital := qualifyingShareCapital + ((MembersReg."Shares Retained")) * (2 / 12);
//     //             grossDividendShareCapital := grossDividendShareCapital + CDiv;

//     //             DivTotal := (CDiv + CInterest);
//     //             DivProg.Init;
//     //             DivProg."Member No" := MembersReg."No.";
//     //             DivProg.Date := ToDate;
//     //             DivProg."Gross Dividends" := CDiv;
//     //             DivProg."Gross Interest On Deposit" := CInterest;
//     //             DivProg."Qualifying Share Capital" := ((MembersReg."Shares Retained")) * (2 / 12);
//     //             DivProg."Witholding Tax" := (CDiv + CInterest) * (GenSetUp."Withholding Tax (%)" / 100);
//     //             DivProg."Net Dividends" := (DivProg."Gross Dividends" + DivProg."Gross Interest On Deposit") - DivProg."Witholding Tax";
//     //             DivProg."Qualifying Shares" := ((MembersReg."Current Shares") + (MembersReg."Junior Savings")) * (2 / 12);
//     //             DivProg.Shares := MembersReg."Current Shares" + MembersReg."Junior Savings";
//     //             DivProg."Share Capital" := MembersReg."Shares Retained";
//     //             DivProg.Insert;
//     //         end;
//     //         //............................
//     //     end;
//     //     //.11 END
//     //     //12 START
//     //     FromDate := CalcDate('10M', StartDate);
//     //     ToDate := CalcDate('-1D', CalcDate('11M', StartDate));
//     //     Evaluate(FromDateS, Format(FromDate));
//     //     Evaluate(ToDateS, Format(ToDate));

//     //     Evaluate(BDate, '01/01/05');

//     //     DateFilter := FromDateS + '..' + ToDateS;
//     //     if MembersReg.Find('-') then begin

//     //         MembersReg.Reset;
//     //         MembersReg.SetCurrentkey("No.");
//     //         MembersReg.SetRange(MembersReg."No.", MemberNo);
//     //         MembersReg.SetFilter(MembersReg."Date Filter", DateFilter);
//     //         //.....................

//     //         if MembersReg.Find('-') then begin
//     //             MembersReg.CalcFields(MembersReg."Current Shares", MembersReg."Shares Retained");
//     //             CInterest := 0;
//     //             //...
//     //             if (MembersReg."Shares Retained" > 0.01) then begin
//     //                 CDiv := 0;
//     //                 CDiv := (((GenSetUp."Dividend (%)" / 100) * ((MembersReg."Shares Retained"))) * (1 / 12));
//     //             end else if (MembersReg."Shares Retained" < 0.01) then begin
//     //                 CDiv := 0;
//     //             end;
//     //             //............
//     //             qualifyingShareCapital := qualifyingShareCapital + ((MembersReg."Shares Retained")) * (1 / 12);
//     //             grossDividendShareCapital := grossDividendShareCapital + CDiv;

//     //             DivTotal := (CDiv + CInterest);
//     //             DivProg.Init;
//     //             DivProg."Member No" := MembersReg."No.";
//     //             DivProg.Date := ToDate;
//     //             DivProg."Gross Dividends" := CDiv;
//     //             DivProg."Gross Interest On Deposit" := CInterest;
//     //             DivProg."Qualifying Share Capital" := ((MembersReg."Shares Retained")) * (1 / 12);
//     //             DivProg."Witholding Tax" := (CDiv + CInterest) * (GenSetUp."Withholding Tax (%)" / 100);
//     //             DivProg."Net Dividends" := (DivProg."Gross Dividends" + DivProg."Gross Interest On Deposit") - DivProg."Witholding Tax";
//     //             DivProg."Qualifying Shares" := ((MembersReg."Current Shares") + (MembersReg."Junior Savings")) * (1 / 12);
//     //             DivProg.Shares := MembersReg."Current Shares" + MembersReg."Junior Savings";
//     //             DivProg."Share Capital" := MembersReg."Shares Retained";
//     //             DivProg.Insert;
//     //         end;
//     //         //............................
//     //     end;
//     //     //12 END
//     //     //....................get the sum amounts
//     //     //2030
//     //     //.................................................Pass GL START
//     //     PayableAmount := 0;
//     //     PayableAmount := FnGetTheDivTotalPayable(MemberNo);//Net Amount Paybale to member
//     //     GrossTotalDiv := 0;
//     //     GrossTotalDiv := FnGetTheGrossDivPayable(MemberNo);
//     //     GrossDivOnShares := 0;
//     //     GrossDivOnShares := (FnGetTheGrossDivOnSharesPayable(MemberNo));
//     //     TotalWhtax := 0;
//     //     TotalWhtax := FnGetTotalWhtax(MemberNo);
//     //     NetPayableAmount := 0;
//     //     NetPayableAmount := FnGetTheNetPayable(MemberNo);

//     //     walletAccount := SFactory.FnGetFosaAccount(MemberNo);
//     //     //POST Dividends here
//     //     LineNo := LineNo + 10000;
//     //     //do not deduct 200 for withdrawn members, or members with no interest on deposits


//     //     totalDividendPaid := grossDividendShareCapital + grossInterestDeposits;
//     //     if totalDividendPaid < 500 then exit;

//     //     Dividends_Posting_Breakdown.Init();
//     //     Dividends_Posting_Breakdown.Entry := GetNextEntryNo();
//     //     Dividends_Posting_Breakdown."Member Number" := MemberNo;
//     //     Dividends_Posting_Breakdown."Payroll Number" := MembersReg."Payroll/Staff No";
//     //     Dividends_Posting_Breakdown.Name := MembersReg.Name;
//     //     Dividends_Posting_Breakdown."Qualifying Shares" := qualifyingShareCapital;
//     //     Dividends_Posting_Breakdown."Qualifying Deposits" := qualifyingDeposits;
//     //     Dividends_Posting_Breakdown."Dividends On Shares" := grossDividendShareCapital;
//     //     Dividends_Posting_Breakdown."Interest on Deposits" := grossInterestDeposits;



//     //     FnPostWithdrawnDividends(MemberNo,
//     //                             PostingDate,
//     //                             GrossTotalDiv,
//     //                             TotalWhtax,
//     //                             StartDate,
//     //                             fnGetMemberShareCapital(MemberNo)
//     //                             );
//     //     ExciseDuty := 0;
//     //     ExciseDuty := (GenSetUp."Dividend Processing Fee" * (GenSetUp."Excise Duty(%)" / 100));

//     //     NetPayableAmountFinal := NetPayableAmount - ExciseDuty;

//     //     //withdrawn members update =they get only grossDividendShareCapital
//     //     MembersReg."Qualifying Deposits" := 0;// qualifyingDeposits;
//     //     MembersReg."Qualifying share Capital" := qualifyingShareCapital;
//     //     MembersReg."Gross Dividend Amount Payable" := grossDividendShareCapital;// totalDividendPaid;
//     //     MembersReg."Gross Div on share Capital" := grossDividendShareCapital;
//     //     MembersReg."Gross Int On Deposits" := 0;// grossInterestDeposits;
//     //     MembersReg."Bank Charges on processings" := 0;//no bank charges on dividend processing
//     //     MembersReg."WithholdingTax on gross div" := TotalWhtax;
//     //     MembersReg."Net Dividend Payable" := NetPayableAmountFinal;
//     //     MembersReg.Modify();

//     //     Dividends_Posting_Breakdown."Total Earnings" := totalDividendPaid;
//     //     Dividends_Posting_Breakdown.Insert();

//     // end;

//     procedure FnJuniorMemberAnalysis(MembersReg: Record Customer; MemberNo: Code[30]; StartDate: Date; PostingDate: Date)
//     begin
//         //............................   //1st Month december previous year
//         Evaluate(BDate, '01/01/05');
//         FromDate := BDate;
//         ToDate := CalcDate('-1D', StartDate);
//         Evaluate(FromDateS, Format(FromDate));
//         Evaluate(ToDateS, Format(ToDate));


//         //January
//         MembersReg.Reset;
//         MembersReg.SetCurrentkey("No.");
//         MembersReg.SetRange(MembersReg."No.", MemberNo);
//         MembersReg.SetRange(MembersReg."Account Category", MembersReg."Account Category"::"Junior Account");
//         MembersReg.SetFilter(MembersReg."Date Filter", '%1..%2', FromDate, CalcDate('CY', StartDate));
//         if MembersReg.Find('-') then begin
//             Evaluate(BDate, '01/01/05');
//             FromDate := BDate;
//             ToDate := CalcDate('-1D', StartDate);
//             Evaluate(FromDateS, Format(FromDate));
//             Evaluate(ToDateS, Format(ToDate));
//             DateFilter := FromDateS + '..' + ToDateS;
//             MembersReg.Reset;
//             MembersReg.SetCurrentkey("No.");
//             MembersReg.SetRange(MembersReg."No.", MemberNo);
//             MembersReg.SetFilter(MembersReg."Date Filter", DateFilter);
//             //.....................

//             if MembersReg.Find('-') then begin
//                 //MembersReg.CalcFields(MembersReg."Current Shares", MembersReg."Shares Retained");
//                 MembersReg.CalculateJuniorSavings();

//                 if ((MembersReg."Junior Savings") > 0.01) then begin
//                     CInterest := 0;
//                     CInterest := (((GenSetUp."Interest on Deposits (%)" / 100) * ((MembersReg."Junior Savings"))) * (12 / 12));
//                 end else if (MembersReg."Junior Savings" < 0.01) then begin
//                     CInterest := 0;
//                 end;
//                 //...
//                 if (MembersReg."Shares Retained" > 0.01) then begin
//                     CDiv := 0;
//                     CDiv := (((GenSetUp."Dividend (%)" / 100) * ((MembersReg."Shares Retained"))) * (12 / 12));
//                 end else if (MembersReg."Shares Retained" < 0.01) then begin
//                     CDiv := 0;
//                 end;
//                 //............
//                 qualifyingShareCapital := qualifyingShareCapital + ((MembersReg."Shares Retained")) * (12 / 12);
//                 grossDividendShareCapital := grossDividendShareCapital + CDiv;
//                 qualifyingDeposits := qualifyingDeposits + ((MembersReg."Junior Savings")) * (12 / 12);
//                 grossInterestDeposits := grossInterestDeposits + CInterest;

//                 DivTotal := (CDiv + CInterest);
//                 DivProg.Init;
//                 DivProg."Member No" := MembersReg."No.";
//                 DivProg.Date := ToDate;
//                 DivProg."Gross Dividends" := CDiv;
//                 DivProg."Gross Interest On Deposit" := CInterest;
//                 DivProg."Qualifying Share Capital" := ((MembersReg."Shares Retained")) * (12 / 12);
//                 DivProg."Witholding Tax" := (CDiv + CInterest) * (GenSetUp."Withholding Tax (%)" / 100);
//                 DivProg."Net Dividends" := (DivProg."Gross Dividends" + DivProg."Gross Interest On Deposit") - DivProg."Witholding Tax";
//                 DivProg."Qualifying Shares" := ((MembersReg."Junior Savings")) * (12 / 12);
//                 DivProg.Shares := MembersReg."Junior Savings";
//                 DivProg."Share Capital" := MembersReg."Shares Retained";
//                 DivProg.Insert;
//             end;
//             //............................
//         end;
//         //............................end first month

//         //.........................February start
//         FromDate := StartDate;
//         ToDate := CalcDate('-1D', CalcDate('1M', StartDate));
//         Evaluate(FromDateS, Format(FromDate));
//         Evaluate(ToDateS, Format(ToDate));
//         Evaluate(BDate, '01/01/05');

//         DateFilter := FromDateS + '..' + ToDateS;
//         if MembersReg.Find('-') then begin

//             MembersReg.Reset;
//             MembersReg.SetCurrentkey("No.");
//             MembersReg.SetRange(MembersReg."No.", MemberNo);
//             MembersReg.SetFilter(MembersReg."Date Filter", DateFilter);
//             //.....................

//             if MembersReg.Find('-') then begin
//                 //MembersReg.CalcFields(MembersReg."Current Shares", MembersReg."Shares Retained");
//                 MembersReg.CalculateJuniorSavings();
//                 if (MembersReg."Junior Savings" > 0.01) then begin
//                     CInterest := 0;
//                     CInterest := (((GenSetUp."Interest on Deposits (%)" / 100) * ((MembersReg."Junior Savings"))) * (11 / 12));
//                 end else if (MembersReg."Junior Savings" < 0.01) then begin
//                     CInterest := 0;
//                 end;
//                 //...
//                 if (MembersReg."Shares Retained" > 0.01) then begin
//                     CDiv := 0;
//                     CDiv := (((GenSetUp."Dividend (%)" / 100) * ((MembersReg."Shares Retained"))) * (11 / 12));
//                 end else if (MembersReg."Shares Retained" < 0.01) then begin
//                     CDiv := 0;
//                 end;
//                 //............
//                 qualifyingShareCapital := qualifyingShareCapital + ((MembersReg."Shares Retained")) * (11 / 12);
//                 grossDividendShareCapital := grossDividendShareCapital + CDiv;
//                 qualifyingDeposits := qualifyingDeposits + ((MembersReg."Junior Savings")) * (11 / 12);
//                 grossInterestDeposits := grossInterestDeposits + CInterest;

//                 DivTotal := (CDiv + CInterest);
//                 DivProg.Init;
//                 DivProg."Member No" := MembersReg."No.";
//                 DivProg.Date := ToDate;
//                 DivProg."Gross Dividends" := CDiv;
//                 DivProg."Gross Interest On Deposit" := CInterest;
//                 DivProg."Qualifying Share Capital" := ((MembersReg."Shares Retained")) * (11 / 12);
//                 DivProg."Witholding Tax" := (CDiv + CInterest) * (GenSetUp."Withholding Tax (%)" / 100);
//                 DivProg."Net Dividends" := (DivProg."Gross Dividends" + DivProg."Gross Interest On Deposit") - DivProg."Witholding Tax";
//                 DivProg."Qualifying Shares" := ((MembersReg."Junior Savings")) * (11 / 12);
//                 DivProg.Shares := MembersReg."Junior Savings";
//                 DivProg."Share Capital" := MembersReg."Shares Retained";
//                 DivProg.Insert;
//             end;
//             //............................
//         end;
//         //.........................2 end

//         //.........................3 start
//         FromDate := CalcDate('1M', StartDate);
//         ToDate := CalcDate('-1D', CalcDate('2M', StartDate));
//         Evaluate(FromDateS, Format(FromDate));
//         Evaluate(ToDateS, Format(ToDate));

//         Evaluate(BDate, '01/01/05');

//         DateFilter := FromDateS + '..' + ToDateS;
//         if MembersReg.Find('-') then begin

//             MembersReg.Reset;
//             MembersReg.SetCurrentkey("No.");
//             MembersReg.SetRange(MembersReg."No.", MemberNo);
//             MembersReg.SetFilter(MembersReg."Date Filter", DateFilter);
//             //.....................

//             if MembersReg.Find('-') then begin
//                 // MembersReg.CalcFields(MembersReg."Current Shares", MembersReg."Shares Retained");
//                 MembersReg.CalculateJuniorSavings();

//                 if (MembersReg."Junior Savings" > 0.01) then begin
//                     CInterest := 0;
//                     CInterest := (((GenSetUp."Interest on Deposits (%)" / 100) * ((MembersReg."Junior Savings"))) * (10 / 12));
//                 end else if (MembersReg."Junior Savings" < 0.01) then begin
//                     CInterest := 0;
//                 end;
//                 //...
//                 if (MembersReg."Shares Retained" > 0.01) then begin
//                     CDiv := 0;
//                     CDiv := (((GenSetUp."Dividend (%)" / 100) * ((MembersReg."Shares Retained"))) * (10 / 12));
//                 end else if (MembersReg."Shares Retained" < 0.01) then begin
//                     CDiv := 0;
//                 end;
//                 //............
//                 qualifyingShareCapital := qualifyingShareCapital + ((MembersReg."Shares Retained")) * (10 / 12);
//                 grossDividendShareCapital := grossDividendShareCapital + CDiv;
//                 qualifyingDeposits := qualifyingDeposits + ((MembersReg."Junior Savings")) * (10 / 12);
//                 grossInterestDeposits := grossInterestDeposits + CInterest;

//                 DivTotal := (CDiv + CInterest);
//                 DivProg.Init;
//                 DivProg."Member No" := MembersReg."No.";
//                 DivProg.Date := ToDate;
//                 DivProg."Gross Dividends" := CDiv;
//                 DivProg."Gross Interest On Deposit" := CInterest;
//                 DivProg."Qualifying Share Capital" := ((MembersReg."Shares Retained")) * (10 / 12);
//                 DivProg."Witholding Tax" := (CDiv + CInterest) * (GenSetUp."Withholding Tax (%)" / 100);
//                 DivProg."Net Dividends" := (DivProg."Gross Dividends" + DivProg."Gross Interest On Deposit") - DivProg."Witholding Tax";
//                 DivProg."Qualifying Shares" := ((MembersReg."Junior Savings")) * (10 / 12);
//                 DivProg.Shares := MembersReg."Junior Savings";
//                 DivProg."Share Capital" := MembersReg."Shares Retained";
//                 DivProg.Insert;
//             end;
//             //............................
//         end;
//         //..............................3 stop

//         //.................4 START
//         FromDate := CalcDate('2M', StartDate);
//         ToDate := CalcDate('-1D', CalcDate('3M', StartDate));
//         Evaluate(FromDateS, Format(FromDate));
//         Evaluate(ToDateS, Format(ToDate));

//         Evaluate(BDate, '01/01/05');

//         DateFilter := FromDateS + '..' + ToDateS;
//         if MembersReg.Find('-') then begin

//             MembersReg.Reset;
//             MembersReg.SetCurrentkey("No.");
//             MembersReg.SetRange(MembersReg."No.", MemberNo);
//             MembersReg.SetFilter(MembersReg."Date Filter", DateFilter);
//             //.....................

//             if MembersReg.Find('-') then begin
//                 // MembersReg.CalcFields(MembersReg."Current Shares", MembersReg."Shares Retained");
//                 MembersReg.CalculateJuniorSavings();

//                 if (MembersReg."Junior Savings" > 0.01) then begin
//                     CInterest := 0;
//                     CInterest := (((GenSetUp."Interest on Deposits (%)" / 100) * ((MembersReg."Junior Savings"))) * (9 / 12));
//                 end else if (MembersReg."Junior Savings" < 0.01) then begin
//                     CInterest := 0;
//                 end;
//                 //...
//                 if (MembersReg."Shares Retained" > 0.01) then begin
//                     CDiv := 0;
//                     CDiv := (((GenSetUp."Dividend (%)" / 100) * ((MembersReg."Shares Retained"))) * (9 / 12));
//                 end else if (MembersReg."Shares Retained" < 0.01) then begin
//                     CDiv := 0;
//                 end;
//                 //............
//                 qualifyingShareCapital := qualifyingShareCapital + ((MembersReg."Shares Retained")) * (9 / 12);
//                 grossDividendShareCapital := grossDividendShareCapital + CDiv;
//                 qualifyingDeposits := qualifyingDeposits + ((MembersReg."Junior Savings")) * (9 / 12);
//                 grossInterestDeposits := grossInterestDeposits + CInterest;

//                 DivTotal := (CDiv + CInterest);
//                 DivProg.Init;
//                 DivProg."Member No" := MembersReg."No.";
//                 DivProg.Date := ToDate;
//                 DivProg."Gross Dividends" := CDiv;
//                 DivProg."Gross Interest On Deposit" := CInterest;
//                 DivProg."Qualifying Share Capital" := ((MembersReg."Shares Retained")) * (9 / 12);
//                 DivProg."Witholding Tax" := (CDiv + CInterest) * (GenSetUp."Withholding Tax (%)" / 100);
//                 DivProg."Net Dividends" := (DivProg."Gross Dividends" + DivProg."Gross Interest On Deposit") - DivProg."Witholding Tax";
//                 DivProg."Qualifying Shares" := ((MembersReg."Junior Savings")) * (9 / 12);
//                 DivProg.Shares := MembersReg."Junior Savings";
//                 DivProg."Share Capital" := MembersReg."Shares Retained";
//                 DivProg.Insert;
//             end;
//             //............................
//         end;
//         //......................4 END

//         /////////////////////5 START
//         FromDate := CalcDate('3M', StartDate);
//         ToDate := CalcDate('-1D', CalcDate('4M', StartDate));
//         Evaluate(FromDateS, Format(FromDate));
//         Evaluate(ToDateS, Format(ToDate));

//         Evaluate(BDate, '01/01/05');

//         DateFilter := FromDateS + '..' + ToDateS;
//         if MembersReg.Find('-') then begin

//             MembersReg.Reset;
//             MembersReg.SetCurrentkey("No.");
//             MembersReg.SetRange(MembersReg."No.", MemberNo);
//             MembersReg.SetFilter(MembersReg."Date Filter", DateFilter);
//             //.....................

//             if MembersReg.Find('-') then begin
//                 //MembersReg.CalcFields(MembersReg."Current Shares", MembersReg."Shares Retained");
//                 MembersReg.CalculateJuniorSavings();

//                 if (MembersReg."Current Shares" > 0.01) then begin
//                     CInterest := 0;
//                     CInterest := (((GenSetUp."Interest on Deposits (%)" / 100) * ((MembersReg."Junior Savings"))) * (8 / 12));
//                 end else if (MembersReg."Junior Savings" < 0.01) then begin
//                     CInterest := 0;
//                 end;
//                 //...
//                 if (MembersReg."Shares Retained" > 0.01) then begin
//                     CDiv := 0;
//                     CDiv := (((GenSetUp."Dividend (%)" / 100) * ((MembersReg."Shares Retained"))) * (8 / 12));
//                 end else if (MembersReg."Shares Retained" < 0.01) then begin
//                     CDiv := 0;
//                 end;
//                 //............
//                 qualifyingShareCapital := qualifyingShareCapital + ((MembersReg."Shares Retained")) * (8 / 12);
//                 grossDividendShareCapital := grossDividendShareCapital + CDiv;
//                 qualifyingDeposits := qualifyingDeposits + ((MembersReg."Junior Savings")) * (8 / 12);
//                 grossInterestDeposits := grossInterestDeposits + CInterest;

//                 DivTotal := (CDiv + CInterest);
//                 DivProg.Init;
//                 DivProg."Member No" := MembersReg."No.";
//                 DivProg.Date := ToDate;
//                 DivProg."Gross Dividends" := CDiv;
//                 DivProg."Gross Interest On Deposit" := CInterest;
//                 DivProg."Qualifying Share Capital" := ((MembersReg."Shares Retained")) * (8 / 12);
//                 DivProg."Witholding Tax" := (CDiv + CInterest) * (GenSetUp."Withholding Tax (%)" / 100);
//                 DivProg."Net Dividends" := (DivProg."Gross Dividends" + DivProg."Gross Interest On Deposit") - DivProg."Witholding Tax";
//                 DivProg."Qualifying Shares" := ((MembersReg."Junior Savings")) * (8 / 12);
//                 DivProg.Shares := MembersReg."Junior Savings";
//                 DivProg."Share Capital" := MembersReg."Shares Retained";
//                 DivProg.Insert;
//             end;
//             //............................
//         end;
//         //....................5 END;

//         //........6 START
//         FromDate := CalcDate('4M', StartDate);
//         ToDate := CalcDate('-1D', CalcDate('5M', StartDate));
//         Evaluate(FromDateS, Format(FromDate));
//         Evaluate(ToDateS, Format(ToDate));

//         Evaluate(BDate, '01/01/05');

//         DateFilter := FromDateS + '..' + ToDateS;
//         if MembersReg.Find('-') then begin

//             MembersReg.Reset;
//             MembersReg.SetCurrentkey("No.");
//             MembersReg.SetRange(MembersReg."No.", MemberNo);
//             MembersReg.SetFilter(MembersReg."Date Filter", DateFilter);
//             //.....................

//             if MembersReg.Find('-') then begin
//                 MembersReg.CalcFields(MembersReg."Current Shares", MembersReg."Shares Retained");
//                 MembersReg.CalculateJuniorSavings();

//                 if (MembersReg."Current Shares" > 0.01) then begin
//                     CInterest := 0;
//                     CInterest := (((GenSetUp."Interest on Deposits (%)" / 100) * ((MembersReg."Junior Savings"))) * (7 / 12));
//                 end else if (MembersReg."Junior Savings" < 0.01) then begin
//                     CInterest := 0;
//                 end;
//                 //...
//                 if (MembersReg."Shares Retained" > 0.01) then begin
//                     CDiv := 0;
//                     CDiv := (((GenSetUp."Dividend (%)" / 100) * ((MembersReg."Shares Retained"))) * (7 / 12));
//                 end else if (MembersReg."Shares Retained" < 0.01) then begin
//                     CDiv := 0;
//                 end;
//                 //............
//                 qualifyingShareCapital := qualifyingShareCapital + ((MembersReg."Shares Retained")) * (7 / 12);
//                 grossDividendShareCapital := grossDividendShareCapital + CDiv;
//                 qualifyingDeposits := qualifyingDeposits + ((MembersReg."Junior Savings")) * (7 / 12);
//                 grossInterestDeposits := grossInterestDeposits + CInterest;

//                 DivTotal := (CDiv + CInterest);
//                 DivProg.Init;
//                 DivProg."Member No" := MembersReg."No.";
//                 DivProg.Date := ToDate;
//                 DivProg."Gross Dividends" := CDiv;
//                 DivProg."Gross Interest On Deposit" := CInterest;
//                 DivProg."Qualifying Share Capital" := ((MembersReg."Shares Retained")) * (7 / 12);
//                 DivProg."Witholding Tax" := (CDiv + CInterest) * (GenSetUp."Withholding Tax (%)" / 100);
//                 DivProg."Net Dividends" := (DivProg."Gross Dividends" + DivProg."Gross Interest On Deposit") - DivProg."Witholding Tax";
//                 DivProg."Qualifying Shares" := ((MembersReg."Junior Savings")) * (7 / 12);
//                 DivProg.Shares := MembersReg."Junior Savings";
//                 DivProg."Share Capital" := MembersReg."Shares Retained";
//                 DivProg.Insert;
//             end;
//             //............................
//         end;
//         //........6 END

//         //...........7 SART
//         FromDate := CalcDate('5M', StartDate);
//         ToDate := CalcDate('-1D', CalcDate('6M', StartDate));
//         Evaluate(FromDateS, Format(FromDate));
//         Evaluate(ToDateS, Format(ToDate));

//         Evaluate(BDate, '01/01/05');

//         DateFilter := FromDateS + '..' + ToDateS;
//         if MembersReg.Find('-') then begin

//             MembersReg.Reset;
//             MembersReg.SetCurrentkey("No.");
//             MembersReg.SetRange(MembersReg."No.", MemberNo);
//             MembersReg.SetFilter(MembersReg."Date Filter", DateFilter);
//             //.....................

//             if MembersReg.Find('-') then begin
//                 //MembersReg.CalcFields(MembersReg."Current Shares", MembersReg."Shares Retained");
//                 MembersReg.CalculateJuniorSavings();

//                 if (MembersReg."Junior Savings" > 0.01) then begin
//                     CInterest := 0;
//                     CInterest := (((GenSetUp."Interest on Deposits (%)" / 100) * ((MembersReg."Junior Savings"))) * (6 / 12));
//                 end else if (MembersReg."Junior Savings" < 0.01) then begin
//                     CInterest := 0;
//                 end;
//                 //...
//                 if (MembersReg."Shares Retained" > 0.01) then begin
//                     CDiv := 0;
//                     CDiv := (((GenSetUp."Dividend (%)" / 100) * ((MembersReg."Shares Retained"))) * (6 / 12));
//                 end else if (MembersReg."Shares Retained" < 0.01) then begin
//                     CDiv := 0;
//                 end;
//                 //............
//                 qualifyingShareCapital := qualifyingShareCapital + ((MembersReg."Shares Retained")) * (6 / 12);
//                 grossDividendShareCapital := grossDividendShareCapital + CDiv;
//                 qualifyingDeposits := qualifyingDeposits + ((MembersReg."Junior Savings")) * (6 / 12);
//                 grossInterestDeposits := grossInterestDeposits + CInterest;

//                 DivTotal := (CDiv + CInterest);
//                 DivProg.Init;
//                 DivProg."Member No" := MembersReg."No.";
//                 DivProg.Date := ToDate;
//                 DivProg."Gross Dividends" := CDiv;
//                 DivProg."Gross Interest On Deposit" := CInterest;
//                 DivProg."Qualifying Share Capital" := ((MembersReg."Shares Retained")) * (6 / 12);
//                 DivProg."Witholding Tax" := (CDiv + CInterest) * (GenSetUp."Withholding Tax (%)" / 100);
//                 DivProg."Net Dividends" := (DivProg."Gross Dividends" + DivProg."Gross Interest On Deposit") - DivProg."Witholding Tax";
//                 DivProg."Qualifying Shares" := ((MembersReg."Junior Savings")) * (6 / 12);
//                 DivProg.Shares := MembersReg."Junior Savings";
//                 DivProg."Share Capital" := MembersReg."Shares Retained";
//                 DivProg.Insert;
//             end;
//             //............................
//         end;
//         //................7 END

//         //.....8 START
//         FromDate := CalcDate('6M', StartDate);
//         ToDate := CalcDate('-1D', CalcDate('7M', StartDate));
//         Evaluate(FromDateS, Format(FromDate));
//         Evaluate(ToDateS, Format(ToDate));

//         Evaluate(BDate, '01/01/05');

//         DateFilter := FromDateS + '..' + ToDateS;
//         if MembersReg.Find('-') then begin

//             MembersReg.Reset;
//             MembersReg.SetCurrentkey("No.");
//             MembersReg.SetRange(MembersReg."No.", MemberNo);
//             MembersReg.SetFilter(MembersReg."Date Filter", DateFilter);
//             //.....................

//             if MembersReg.Find('-') then begin
//                 // MembersReg.CalcFields(MembersReg."Current Shares", MembersReg."Shares Retained");
//                 MembersReg.CalculateJuniorSavings();

//                 if (MembersReg."Junior Savings" > 0.01) then begin
//                     CInterest := 0;
//                     CInterest := (((GenSetUp."Interest on Deposits (%)" / 100) * ((MembersReg."Junior Savings"))) * (5 / 12));
//                 end else if (MembersReg."Junior Savings" < 0.01) then begin
//                     CInterest := 0;
//                 end;
//                 //...
//                 if (MembersReg."Shares Retained" > 0.01) then begin
//                     CDiv := 0;
//                     CDiv := (((GenSetUp."Dividend (%)" / 100) * ((MembersReg."Shares Retained"))) * (5 / 12));
//                 end else if (MembersReg."Shares Retained" < 0.01) then begin
//                     CDiv := 0;
//                 end;
//                 //............
//                 qualifyingShareCapital := qualifyingShareCapital + ((MembersReg."Shares Retained")) * (5 / 12);
//                 grossDividendShareCapital := grossDividendShareCapital + CDiv;
//                 qualifyingDeposits := qualifyingDeposits + ((MembersReg."Junior Savings")) * (5 / 12);
//                 grossInterestDeposits := grossInterestDeposits + CInterest;

//                 DivTotal := (CDiv + CInterest);
//                 DivProg.Init;
//                 DivProg."Member No" := MembersReg."No.";
//                 DivProg.Date := ToDate;
//                 DivProg."Gross Dividends" := CDiv;
//                 DivProg."Gross Interest On Deposit" := CInterest;
//                 DivProg."Qualifying Share Capital" := ((MembersReg."Shares Retained")) * (5 / 12);
//                 DivProg."Witholding Tax" := (CDiv + CInterest) * (GenSetUp."Withholding Tax (%)" / 100);
//                 DivProg."Net Dividends" := (DivProg."Gross Dividends" + DivProg."Gross Interest On Deposit") - DivProg."Witholding Tax";
//                 DivProg."Qualifying Shares" := ((MembersReg."Junior Savings")) * (5 / 12);
//                 DivProg.Shares := MembersReg."Junior Savings";
//                 DivProg."Share Capital" := MembersReg."Shares Retained";
//                 DivProg.Insert;
//             end;
//             //............................
//         end;
//         //.......8 END

//         //9 START
//         FromDate := CalcDate('7M', StartDate);
//         ToDate := CalcDate('-1D', CalcDate('8M', StartDate));
//         Evaluate(FromDateS, Format(FromDate));
//         Evaluate(ToDateS, Format(ToDate));

//         Evaluate(BDate, '01/01/05');

//         DateFilter := FromDateS + '..' + ToDateS;
//         if MembersReg.Find('-') then begin

//             MembersReg.Reset;
//             MembersReg.SetCurrentkey("No.");
//             MembersReg.SetRange(MembersReg."No.", MemberNo);
//             MembersReg.SetFilter(MembersReg."Date Filter", DateFilter);
//             //.....................

//             if MembersReg.Find('-') then begin
//                 // MembersReg.CalcFields(MembersReg."Current Shares", MembersReg."Shares Retained");
//                 MembersReg.CalculateJuniorSavings();

//                 if (MembersReg."Junior Savings" > 0.01) then begin
//                     CInterest := 0;
//                     CInterest := (((GenSetUp."Interest on Deposits (%)" / 100) * ((MembersReg."Junior Savings"))) * (4 / 12));
//                 end else if (MembersReg."Junior Savings" < 0.01) then begin
//                     CInterest := 0;
//                 end;
//                 //...
//                 if (MembersReg."Shares Retained" > 0.01) then begin
//                     CDiv := 0;
//                     CDiv := (((GenSetUp."Dividend (%)" / 100) * ((MembersReg."Shares Retained"))) * (4 / 12));
//                 end else if (MembersReg."Shares Retained" < 0.01) then begin
//                     CDiv := 0;
//                 end;
//                 //............
//                 qualifyingShareCapital := qualifyingShareCapital + ((MembersReg."Shares Retained")) * (4 / 12);
//                 grossDividendShareCapital := grossDividendShareCapital + CDiv;
//                 qualifyingDeposits := qualifyingDeposits + ((MembersReg."Junior Savings")) * (4 / 12);
//                 grossInterestDeposits := grossInterestDeposits + CInterest;


//                 DivTotal := (CDiv + CInterest);
//                 DivProg.Init;
//                 DivProg."Member No" := MembersReg."No.";
//                 DivProg.Date := ToDate;
//                 DivProg."Gross Dividends" := CDiv;
//                 DivProg."Gross Interest On Deposit" := CInterest;
//                 DivProg."Qualifying Share Capital" := ((MembersReg."Shares Retained")) * (4 / 12);
//                 DivProg."Witholding Tax" := (CDiv + CInterest) * (GenSetUp."Withholding Tax (%)" / 100);
//                 DivProg."Net Dividends" := (DivProg."Gross Dividends" + DivProg."Gross Interest On Deposit") - DivProg."Witholding Tax";
//                 DivProg."Qualifying Shares" := ((MembersReg."Junior Savings")) * (4 / 12);
//                 DivProg.Shares := MembersReg."Junior Savings";
//                 DivProg."Share Capital" := MembersReg."Shares Retained";
//                 DivProg.Insert;
//             end;
//             //............................
//         end;
//         //.9 END

//         //10 START
//         FromDate := CalcDate('8M', StartDate);
//         ToDate := CalcDate('-1D', CalcDate('9M', StartDate));
//         Evaluate(FromDateS, Format(FromDate));
//         Evaluate(ToDateS, Format(ToDate));

//         Evaluate(BDate, '01/01/05');

//         DateFilter := FromDateS + '..' + ToDateS;
//         if MembersReg.Find('-') then begin

//             MembersReg.Reset;
//             MembersReg.SetCurrentkey("No.");
//             MembersReg.SetRange(MembersReg."No.", MemberNo);
//             MembersReg.SetFilter(MembersReg."Date Filter", DateFilter);
//             //.....................

//             if MembersReg.Find('-') then begin
//                 //MembersReg.CalcFields(MembersReg."Current Shares", MembersReg."Shares Retained");
//                 MembersReg.CalculateJuniorSavings();
//                 if (MembersReg."Junior Savings" > 0.01) then begin
//                     CInterest := 0;
//                     CInterest := (((GenSetUp."Interest on Deposits (%)" / 100) * ((MembersReg."Junior Savings"))) * (3 / 12));
//                 end else if (MembersReg."Junior Savings" < 0.01) then begin
//                     CInterest := 0;
//                 end;
//                 //...
//                 if (MembersReg."Shares Retained" > 0.01) then begin
//                     CDiv := 0;
//                     CDiv := (((GenSetUp."Dividend (%)" / 100) * ((MembersReg."Shares Retained"))) * (3 / 12));
//                 end else if (MembersReg."Shares Retained" < 0.01) then begin
//                     CDiv := 0;
//                 end;
//                 //............
//                 qualifyingShareCapital := qualifyingShareCapital + ((MembersReg."Shares Retained")) * (3 / 12);
//                 grossDividendShareCapital := grossDividendShareCapital + CDiv;
//                 qualifyingDeposits := qualifyingDeposits + ((MembersReg."Junior Savings")) * (3 / 12);
//                 grossInterestDeposits := grossInterestDeposits + CInterest;

//                 DivTotal := (CDiv + CInterest);
//                 DivProg.Init;
//                 DivProg."Member No" := MembersReg."No.";
//                 DivProg.Date := ToDate;
//                 DivProg."Gross Dividends" := CDiv;
//                 DivProg."Gross Interest On Deposit" := CInterest;
//                 DivProg."Qualifying Share Capital" := ((MembersReg."Shares Retained")) * (3 / 12);
//                 DivProg."Witholding Tax" := (CDiv + CInterest) * (GenSetUp."Withholding Tax (%)" / 100);
//                 DivProg."Net Dividends" := (DivProg."Gross Dividends" + DivProg."Gross Interest On Deposit") - DivProg."Witholding Tax";
//                 DivProg."Qualifying Shares" := ((MembersReg."Junior Savings")) * (3 / 12);
//                 DivProg.Shares := MembersReg."Junior Savings";
//                 DivProg."Share Capital" := MembersReg."Shares Retained";
//                 DivProg.Insert;
//             end;
//             //............................
//         end;
//         //10 END

//         //..11 START
//         FromDate := CalcDate('9M', StartDate);
//         ToDate := CalcDate('-1D', CalcDate('10M', StartDate));
//         Evaluate(FromDateS, Format(FromDate));
//         Evaluate(ToDateS, Format(ToDate));

//         Evaluate(BDate, '01/01/05');

//         DateFilter := FromDateS + '..' + ToDateS;
//         if MembersReg.Find('-') then begin

//             MembersReg.Reset;
//             MembersReg.SetCurrentkey("No.");
//             MembersReg.SetRange(MembersReg."No.", MemberNo);
//             MembersReg.SetFilter(MembersReg."Date Filter", DateFilter);
//             //.....................

//             if MembersReg.Find('-') then begin
//                 //MembersReg.CalcFields(MembersReg."Current Shares", MembersReg."Shares Retained");
//                 MembersReg.CalculateJuniorSavings();
//                 if (MembersReg."Junior Savings" > 0.01) then begin
//                     CInterest := 0;
//                     CInterest := (((GenSetUp."Interest on Deposits (%)" / 100) * ((MembersReg."Junior Savings"))) * (2 / 12));
//                 end else if (MembersReg."Junior Savings" < 0.01) then begin
//                     CInterest := 0;
//                 end;
//                 //...
//                 if (MembersReg."Shares Retained" > 0.01) then begin
//                     CDiv := 0;
//                     CDiv := (((GenSetUp."Dividend (%)" / 100) * ((MembersReg."Shares Retained"))) * (2 / 12));
//                 end else if (MembersReg."Shares Retained" < 0.01) then begin
//                     CDiv := 0;
//                 end;
//                 //............
//                 qualifyingShareCapital := qualifyingShareCapital + ((MembersReg."Shares Retained")) * (2 / 12);
//                 grossDividendShareCapital := grossDividendShareCapital + CDiv;
//                 qualifyingDeposits := qualifyingDeposits + ((MembersReg."Junior Savings")) * (2 / 12);
//                 grossInterestDeposits := grossInterestDeposits + CInterest;

//                 DivTotal := (CDiv + CInterest);
//                 DivProg.Init;
//                 DivProg."Member No" := MembersReg."No.";
//                 DivProg.Date := ToDate;
//                 DivProg."Gross Dividends" := CDiv;
//                 DivProg."Gross Interest On Deposit" := CInterest;
//                 DivProg."Qualifying Share Capital" := ((MembersReg."Shares Retained")) * (2 / 12);
//                 DivProg."Witholding Tax" := (CDiv + CInterest) * (GenSetUp."Withholding Tax (%)" / 100);
//                 DivProg."Net Dividends" := (DivProg."Gross Dividends" + DivProg."Gross Interest On Deposit") - DivProg."Witholding Tax";
//                 DivProg."Qualifying Shares" := ((MembersReg."Junior Savings")) * (2 / 12);
//                 DivProg.Shares := MembersReg."Junior Savings";
//                 DivProg."Share Capital" := MembersReg."Shares Retained";
//                 DivProg.Insert;
//             end;
//             //............................
//         end;
//         //.11 END

//         //12 START
//         FromDate := CalcDate('10M', StartDate);
//         ToDate := CalcDate('-1D', CalcDate('11M', StartDate));
//         Evaluate(FromDateS, Format(FromDate));
//         Evaluate(ToDateS, Format(ToDate));

//         Evaluate(BDate, '01/01/05');

//         DateFilter := FromDateS + '..' + ToDateS;
//         if MembersReg.Find('-') then begin

//             MembersReg.Reset;
//             MembersReg.SetCurrentkey("No.");
//             MembersReg.SetRange(MembersReg."No.", MemberNo);
//             MembersReg.SetFilter(MembersReg."Date Filter", DateFilter);
//             //.....................

//             if MembersReg.Find('-') then begin
//                 //        MembersReg.CalcFields(MembersReg."Current Shares", MembersReg."Shares Retained");
//                 MembersReg.CalculateJuniorSavings();

//                 if (MembersReg."Junior Savings" > 0.01) then begin
//                     CInterest := 0;
//                     CInterest := (((GenSetUp."Interest on Deposits (%)" / 100) * ((MembersReg."Junior Savings"))) * (1 / 12));
//                 end else if (MembersReg."Junior Savings" < 0.01) then begin
//                     CInterest := 0;
//                 end;
//                 //...
//                 if (MembersReg."Shares Retained" > 0.01) then begin
//                     CDiv := 0;
//                     CDiv := (((GenSetUp."Dividend (%)" / 100) * ((MembersReg."Shares Retained"))) * (1 / 12));
//                 end else if (MembersReg."Shares Retained" < 0.01) then begin
//                     CDiv := 0;
//                 end;
//                 //............
//                 qualifyingShareCapital := qualifyingShareCapital + ((MembersReg."Shares Retained")) * (1 / 12);
//                 grossDividendShareCapital := grossDividendShareCapital + CDiv;
//                 qualifyingDeposits := qualifyingDeposits + ((MembersReg."Junior Savings")) * (1 / 12);
//                 grossInterestDeposits := grossInterestDeposits + CInterest;

//                 DivTotal := (CDiv + CInterest);
//                 DivProg.Init;
//                 DivProg."Member No" := MembersReg."No.";
//                 DivProg.Date := ToDate;
//                 DivProg."Gross Dividends" := CDiv;
//                 DivProg."Gross Interest On Deposit" := CInterest;
//                 DivProg."Qualifying Share Capital" := ((MembersReg."Shares Retained")) * (1 / 12);
//                 DivProg."Witholding Tax" := (CDiv + CInterest) * (GenSetUp."Withholding Tax (%)" / 100);
//                 DivProg."Net Dividends" := (DivProg."Gross Dividends" + DivProg."Gross Interest On Deposit") - DivProg."Witholding Tax";
//                 DivProg."Qualifying Shares" := ((MembersReg."Junior Savings")) * (1 / 12);
//                 DivProg.Shares := MembersReg."Junior Savings";
//                 DivProg."Share Capital" := MembersReg."Shares Retained";
//                 DivProg.Insert;
//             end;
//             //............................
//         end;


//         //12 END
//         PayableAmount := 0;
//         PayableAmount := FnGetTheDivTotalPayable(MemberNo);//Net Amount Paybale to member
//         GrossTotalDiv := 0;
//         GrossTotalDiv := FnGetTheGrossDivPayable(MemberNo);
//         GrossDivOnShares := 0;
//         GrossDivOnShares := (FnGetTheGrossDivOnSharesPayable(MemberNo));
//         TotalWhtax := 0;
//         TotalWhtax := FnGetTotalWhtax(MemberNo);
//         NetPayableAmount := 0;
//         NetPayableAmount := FnGetTheNetPayable(MemberNo);

//         totalDividendPaid := grossDividendShareCapital + grossInterestDeposits;
//         if totalDividendPaid < 500 then exit;


//         Dividends_Posting_Breakdown.Init();
//         Dividends_Posting_Breakdown.Entry := GetNextEntryNo();
//         Dividends_Posting_Breakdown."Member Number" := MemberNo;
//         Dividends_Posting_Breakdown."Payroll Number" := MembersReg."Payroll/Staff No";
//         Dividends_Posting_Breakdown.Name := MembersReg.Name;
//         Dividends_Posting_Breakdown."Qualifying Shares" := qualifyingShareCapital;
//         Dividends_Posting_Breakdown."Qualifying Deposits" := qualifyingDeposits;
//         Dividends_Posting_Breakdown."Dividends On Shares" := grossDividendShareCapital;
//         Dividends_Posting_Breakdown."Interest on Deposits" := grossInterestDeposits;


//         FnPostDividendstoWallet(MemberNo,
//                                 PostingDate,
//                                 GrossTotalDiv,
//                                 TotalWhtax,
//                                 StartDate
//                                 );

//         //.................................................Pass GL START



//         ExciseDuty := 0;
//         ExciseDuty := (GenSetUp."Dividend Processing Fee" * (GenSetUp."Excise Duty(%)" / 100));
//         //.................................................END PASS GL

//         NetPayableAmountFinal := NetPayableAmount - ExciseDuty;

//         MembersReg."Qualifying Deposits" := qualifyingDeposits;
//         MembersReg."Qualifying share Capital" := qualifyingShareCapital;
//         MembersReg."Gross Dividend Amount Payable" := totalDividendPaid;
//         MembersReg."Gross Div on share Capital" := grossDividendShareCapital;
//         MembersReg."Gross Int On Deposits" := grossInterestDeposits;
//         MembersReg."Bank Charges on processings" := 0;//no bank charges on dividend processing
//         MembersReg."WithholdingTax on gross div" := TotalWhtax;
//         MembersReg."Net Dividend Payable" := NetPayableAmountFinal;
//         MembersReg.Modify();


//         Dividends_Posting_Breakdown."Total Earnings" := totalDividendPaid;
//         Dividends_Posting_Breakdown.Insert();

//     end;






//     procedure GetNextEntryNo(): Integer
//     var
//         DividendReceipt: Record "Dividends Posting Breakdown";
//     begin
//         DividendReceipt.Reset();
//         if DividendReceipt.FindLast() then
//             exit(DividendReceipt.Entry + 1)
//         else
//             exit(1);
//     end;

//     local procedure fnGetMemberShareCapital(memberNumber: Code[20]) sharesCapital: Decimal
//     var
//         membersTable: Record Customer;
//     begin
//         sharesCapital := 0;

//         membersTable.Reset();
//         membersTable.SetRange("No.", memberNumber);
//         if membersTable.Find('-') then begin
//             membersTable.CalcFields("Shares Retained");
//             sharesCapital := membersTable."Shares Retained";
//         end;
//     end;

//     procedure FnPostWithdrawnDividends(MemberNo: Code[20]; PostingDate: Date; GrossTotalDiv: Decimal; TotalWhtax: Decimal; StartDate: Date; sharesCapital: Decimal)
//     var
//         DividendAmount: Decimal;
//         smsText: Text[1000];
//         loanRecovered: Decimal;
//         sharesToPay: Decimal;
//     begin
//         //Declaration....
//         smsText := '';
//         DividendAmount := GrossTotalDiv;
//         walletAccount := SFactory.FnGetFosaAccount(MemberNo);
//         YearCalc := Format(Date2dmy(StartDate, 3));
//         GenSetUp.Get();
//         ExciseDuty := 0;
//         ExciseDuty := (GenSetUp."Dividend Processing Fee" * (GenSetUp."Excise Duty(%)" / 100));

//         ////### -- 1.1 CREDIT MEMBER DIVIDEND -GrossTotalDiv
//         LineNo := LineNo + 10000;
//         SFactory.FnCreateGnlJournalLine('PAYMENTS', 'DIVIDEND', 'DIV ' + Format(YearCalc), LineNo, GenJournalLine."transaction type"::Dividend,
//         GenJournalLine."account type"::Customer, MemberNo, PostingDate, GrossTotalDiv * -1, 'BOSA', '',
//         'Gross Dividend and Interest on Deposits - ' + Format(YearCalc), '');

//         ////## --- 1.2 DEBIT DIVIDEND PAYABLE GL - GrossTotalDiv
//         LineNo := LineNo + 10000;
//         GenSetUp.Get();
//         SFactory.FnCreateGnlJournalLine('PAYMENTS', 'DIVIDEND', 'DIV ' + Format(YearCalc), LineNo, GenJournalLine."transaction type"::" ",
//         GenJournalLine."Account Type"::"G/L Account", GenSetUp."Dividend Payable Account", PostingDate, GrossTotalDiv, 'BOSA', '',
//         'Gross Dividend and Interest on Deposits - ' + MemberNo, '');

//         ///######## 3.1 CREDIT WTX GL ACC
//         LineNo := LineNo + 10000;
//         SFactory.FnCreateGnlJournalLine('PAYMENTS', 'DIVIDEND', 'DIV ' + Format(YearCalc), LineNo, GenJournalLine."transaction type"::" ",
//         GenJournalLine."account type"::"G/L Account", GenSetUp."WithHolding Tax Account", PostingDate, (TotalWhtax) * -1, 'BOSA', '',
//         'Witholding Tax on Dividend- ' + MemberNo, '');

//         //########## 3.2 DEBIT Div Membe Acc ON WTX
//         LineNo := LineNo + 10000;
//         SFactory.FnCreateGnlJournalLine('PAYMENTS', 'DIVIDEND', 'DIV ' + Format(YearCalc), LineNo, GenJournalLine."transaction type"::Dividend,
//         GenJournalLine."account type"::Customer, MemberNo, PostingDate, (TotalWhtax), 'BOSA', '',
//         'Witholding Tax on Dividend- ' + YearCalc, '');
//         DividendAmount := DividendAmount - TotalWhtax;


//         ////######## 4.1 DEBIT Member Number ON PROCESSSING FEE
//         // LineNo := LineNo + 10000;
//         // SFactory.FnCreateGnlJournalLine('PAYMENTS', 'DIVIDEND', 'DIV ' + Format(YearCalc), LineNo, GenJournalLine."transaction type"::Dividend,
//         // GenJournalLine."account type"::Customer, MemberNo, PostingDate, GenSetUp."Dividend Processing Fee", 'BOSA', '',
//         // 'Processing Fee- ' + MemberNo, '');
//         // ///##### 4.2 CREDIT PROCESSING FEE GL ACC
//         // LineNo := LineNo + 10000;
//         // SFactory.FnCreateGnlJournalLine('PAYMENTS', 'DIVIDEND', 'DIV ' + Format(YearCalc), LineNo, GenJournalLine."transaction type"::" ",
//         // GenJournalLine."account type"::"G/L Account", GenSetUp."Dividend Process Fee Account", PostingDate, GenSetUp."Dividend Processing Fee" * -1, 'BOSA', '',
//         // 'Processing Fee- ' + Format(PostingDate), '');
//         // DividendAmount := DividendAmount - GenSetUp."Dividend Processing Fee";


//         // //###### 5.1 DEBIT M-WALLET ON EXCISE DUTY ON PROCESSING FEE 
//         // LineNo := LineNo + 10000;
//         // SFactory.FnCreateGnlJournalLine('PAYMENTS', 'DIVIDEND', 'DIV ' + Format(YearCalc), LineNo, GenJournalLine."transaction type"::Dividend,
//         // GenJournalLine."account type"::Vendor, walletAccount, PostingDate, ExciseDuty, 'BOSA', '',
//         // 'Excise on DivProcessing Fee ' + MemberNo, '');
//         // //###### 5.2 CREDIT EXCISE DUTY GL ACC
//         // LineNo := LineNo + 10000;
//         // SFactory.FnCreateGnlJournalLine('PAYMENTS', 'DIVIDEND', 'DIV ' + Format(YearCalc), LineNo, GenJournalLine."transaction type"::" ",
//         // GenJournalLine."account type"::"G/L Account", GenSetUp."Dividend Process Fee Account", PostingDate, ExciseDuty * -1, 'BOSA', '',
//         // 'Excise on DivProcessing Fee ' + Format(PostingDate), '');
//         // DividendAmount := DividendAmount - ExciseDuty;

//         //POST the sharesCapital for members with less than 15,000
//         if (sharesCapital < 15000) and (DividendAmount > 0) then begin
//             sharesToPay := 0;
//             sharesToPay := 15000 - sharesCapital;
//             if sharesToPay >= DividendAmount then
//                 sharesToPay := DividendAmount;

//             /////######## 2.1 Shares Capital
//             LineNo := LineNo + 10000;
//             SFactory.FnCreateGnlJournalLine('PAYMENTS', 'DIVIDEND', 'DIV ' + Format(YearCalc), LineNo, GenJournalLine."transaction type"::"Share Capital",
//             GenJournalLine."Account Type"::Customer, MemberNo, PostingDate, (sharesToPay) * -1, 'BOSA', '',
//             'Dividend Capitalization ' + Format(YearCalc), '');
//             //#########  2.2 DEBIT MEMBER DIVIDEND
//             LineNo := LineNo + 10000;
//             SFactory.FnCreateGnlJournalLine('PAYMENTS', 'DIVIDEND', 'DIV ' + Format(YearCalc), LineNo, GenJournalLine."transaction type"::Dividend,
//             GenJournalLine."account type"::Customer, MemberNo, PostingDate, (sharesToPay), 'BOSA', '',
//             'Dividend Capitalization  ' + Format(PostingDate), '');

//             Dividends_Posting_Breakdown.ShareCapitalization := sharesToPay;

//             // Reduce remaining dividend
//             DividendAmount := DividendAmount - sharesToPay;
//         end;



//         Dividends_Posting_Breakdown."Processing Fee" := 50;// GenSetUp."Dividend Processing Fee"; WITHDRAWN MEMBERS CHARGED 50 BOB
//         Dividends_Posting_Breakdown."Withholding Tax" := TotalWhtax;

//         Dividends_Posting_Breakdown."Loan Arrears Recovered" := loanRecovered;
//         Dividends_Posting_Breakdown."Net Paid to Wallets" := DividendAmount;

//     end;

//     procedure FnPostDividendstoWallet(MemberNo: Code[20]; PostingDate: Date; GrossTotalDiv: Decimal; TotalWhtax: Decimal; StartDate: Date)
//     var
//         DividendAmount: Decimal;
//         smsText: Text[1000];
//         loanRecovered: Decimal;
//     begin
//         //Declaration....
//         smsText := '';
//         DividendAmount := GrossTotalDiv;
//         walletAccount := SFactory.FnGetFosaAccount(MemberNo);
//         YearCalc := Format(Date2dmy(StartDate, 3));
//         GenSetUp.Get();
//         ExciseDuty := 0;
//         ExciseDuty := (GenSetUp."Dividend Processing Fee" * (GenSetUp."Excise Duty(%)" / 100));

//         ////### -- 1.1 CREDIT MEMBER DIVIDEND -GrossTotalDiv
//         LineNo := LineNo + 10000;
//         SFactory.FnCreateGnlJournalLine('PAYMENTS', 'DIVIDEND', 'DIV ' + Format(YearCalc), LineNo, GenJournalLine."transaction type"::Dividend,
//         GenJournalLine."account type"::Customer, MemberNo, PostingDate, GrossTotalDiv * -1, 'BOSA', '',
//         'Gross Dividend and Interest on Deposits - ' + Format(YearCalc), '');

//         ////## --- 1.2 DEBIT DIVIDEND PAYABLE GL - GrossTotalDiv
//         LineNo := LineNo + 10000;
//         GenSetUp.Get();
//         SFactory.FnCreateGnlJournalLine('PAYMENTS', 'DIVIDEND', 'DIV ' + Format(YearCalc), LineNo, GenJournalLine."transaction type"::" ",
//         GenJournalLine."Account Type"::"G/L Account", GenSetUp."Dividend Payable Account", PostingDate, GrossTotalDiv, 'BOSA', '',
//         'Gross Dividend and Interest on Deposits - ' + MemberNo, '');

//         ///######## 3.1 CREDIT WTX GL ACC
//         LineNo := LineNo + 10000;
//         SFactory.FnCreateGnlJournalLine('PAYMENTS', 'DIVIDEND', 'DIV ' + Format(YearCalc), LineNo, GenJournalLine."transaction type"::" ",
//         GenJournalLine."account type"::"G/L Account", GenSetUp."WithHolding Tax Account", PostingDate, (TotalWhtax) * -1, 'BOSA', '',
//         'Witholding Tax on Dividend- ' + MemberNo, '');

//         //########## 3.2 DEBIT Div Membe Acc ON WTX
//         LineNo := LineNo + 10000;
//         SFactory.FnCreateGnlJournalLine('PAYMENTS', 'DIVIDEND', 'DIV ' + Format(YearCalc), LineNo, GenJournalLine."transaction type"::Dividend,
//         GenJournalLine."account type"::Customer, MemberNo, PostingDate, (TotalWhtax), 'BOSA', '',
//         'Witholding Tax on Dividend- ' + YearCalc, '');
//         DividendAmount := DividendAmount - TotalWhtax;


//         //######## 4.1 DEBIT Member Number ON PROCESSSING FEE
//         LineNo := LineNo + 10000;
//         SFactory.FnCreateGnlJournalLine('PAYMENTS', 'DIVIDEND', 'DIV ' + Format(YearCalc), LineNo, GenJournalLine."transaction type"::Dividend,
//         GenJournalLine."account type"::Customer, MemberNo, PostingDate, GenSetUp."Dividend Processing Fee", 'BOSA', '',
//         'Processing Fee- ' + MemberNo, '');
//         ///##### 4.2 CREDIT PROCESSING FEE GL ACC
//         LineNo := LineNo + 10000;
//         SFactory.FnCreateGnlJournalLine('PAYMENTS', 'DIVIDEND', 'DIV ' + Format(YearCalc), LineNo, GenJournalLine."transaction type"::" ",
//         GenJournalLine."account type"::"G/L Account", GenSetUp."Dividend Process Fee Account", PostingDate, GenSetUp."Dividend Processing Fee" * -1, 'BOSA', '',
//         'Processing Fee- ' + Format(PostingDate), '');
//         DividendAmount := DividendAmount - GenSetUp."Dividend Processing Fee";

//         // /////######## 2.1 CREDIT M-WALLET ACC
//         // LineNo := LineNo + 10000;
//         // SFactory.FnCreateGnlJournalLine('PAYMENTS', 'DIVIDEND', 'DIV ' + Format(YearCalc), LineNo, GenJournalLine."transaction type"::Dividend,
//         // GenJournalLine."Account Type"::Vendor, walletAccount, PostingDate, (DividendAmount) * -1, 'BOSA', '',
//         // 'Net Dividend and Interest on Deposits transfered to M-Wallet ' + Format(YearCalc), '');
//         // //#########  2.2 DEBIT MEMBER DIVIDEND
//         // LineNo := LineNo + 10000;
//         // SFactory.FnCreateGnlJournalLine('PAYMENTS', 'DIVIDEND', 'DIV ' + Format(YearCalc), LineNo, GenJournalLine."transaction type"::Dividend,
//         // GenJournalLine."account type"::Customer, MemberNo, PostingDate, (DividendAmount), 'BOSA', '',
//         // 'Net Dividend and Interest on Deposits transfered to M-Wallet  ' + Format(PostingDate), '');




//         Dividends_Posting_Breakdown."Processing Fee" := GenSetUp."Dividend Processing Fee";
//         Dividends_Posting_Breakdown."Withholding Tax" := TotalWhtax;

//         Dividends_Posting_Breakdown."Loan Arrears Recovered" := loanRecovered;
//         Dividends_Posting_Breakdown."Net Paid to Wallets" := DividendAmount;

//     end;

//     procedure FnGetTheDivTotalPayable(MemberNo: Code[30]): Decimal
//     var
//         DivProgressionTable: Record "Dividends Progression";
//         Amountss: Decimal;
//     begin

//         Amountss := 0;
//         DivProgressionTable.Reset;
//         DivProgressionTable.SetRange(DivProgressionTable."Member No", MemberNo);
//         if DivProgressionTable.Find('-') then begin
//             repeat
//                 Amountss += ROUND(DivProgressionTable."Net Dividends");
//             //...........................
//             until DivProgressionTable.Next = 0;
//         end;
//         exit(Amountss);
//     end;


//     procedure FnGetTheGrossDivPayable(MemberNo: Code[30]): Decimal
//     var
//         DivProgressionTable: Record "Dividends Progression";
//         GrossDivAmount: Decimal;
//     begin
//         GrossTotalDiv := 0;
//         DivProgressionTable.Reset;
//         DivProgressionTable.SetRange(DivProgressionTable."Member No", MemberNo);
//         if DivProgressionTable.Find('-') then begin
//             repeat
//                 GrossTotalDiv += ROUND(DivProgressionTable."Gross Dividends" + DivProgressionTable."Gross Interest On Deposit");
//             //...........................
//             until DivProgressionTable.Next = 0;
//         end;
//         exit(GrossTotalDiv);
//     end;

//     procedure FnGetTheGrossDividends(MemberNo: Code[30]): Decimal
//     var
//         DivProgressionTable: Record "Dividends Progression";
//         GrossDivAmount: Decimal;
//     begin
//         GrossTotalDiv := 0;
//         DivProgressionTable.Reset;
//         DivProgressionTable.SetRange(DivProgressionTable."Member No", MemberNo);
//         if DivProgressionTable.Find('-') then begin
//             repeat
//                 GrossTotalDiv += ROUND(DivProgressionTable."Gross Dividends");
//             //...........................
//             until DivProgressionTable.Next = 0;
//         end;
//         exit(GrossTotalDiv);
//     end;

//     procedure FnGetTheGrossDivOnSharesPayable(MemberNo: Code[30]): Decimal
//     var
//         DivProgressionTable: Record "Dividends Progression";
//         GrossDivAmountOnShares: Decimal;
//     begin
//         GrossDivAmountOnShares := 0;
//         DivProgressionTable.Reset;
//         DivProgressionTable.SetRange(DivProgressionTable."Member No", MemberNo);
//         if DivProgressionTable.Find('-') then begin
//             repeat
//                 GrossDivAmountOnShares += ROUND(DivProgressionTable."Gross Dividends");
//             //...........................
//             until DivProgressionTable.Next = 0;
//         end;
//         exit(GrossDivAmountOnShares);
//     end;


//     procedure FnGetTotalWhtax(MemberNo: Code[30]): Decimal
//     var
//         DivProgressionTable: Record "Dividends Progression";
//         TotalTax: Decimal;
//     begin
//         TotalTax := 0;
//         DivProgressionTable.Reset;
//         DivProgressionTable.SetRange(DivProgressionTable."Member No", MemberNo);
//         if DivProgressionTable.Find('-') then begin
//             repeat
//                 TotalTax += ROUND(DivProgressionTable."Witholding Tax");
//             //...........................
//             until DivProgressionTable.Next = 0;
//         end;
//         exit(TotalTax);
//     end;


//     procedure FnGetTheNetPayable(MemberNo: Code[30]): Decimal
//     var
//         DivProgressionTable: Record "Dividends Progression";
//         TotalNetPay: Decimal;
//     begin
//         TotalNetPay := 0;
//         DivProgressionTable.Reset;
//         DivProgressionTable.SetRange(DivProgressionTable."Member No", MemberNo);
//         if DivProgressionTable.Find('-') then begin
//             repeat
//                 TotalNetPay += ROUND(DivProgressionTable."Gross Interest On Deposit") + ROUND(DivProgressionTable."Gross Dividends") - ROUND(DivProgressionTable."Witholding Tax");
//             //...........................
//             until DivProgressionTable.Next = 0;
//         end;
//         exit(TotalNetPay);
//     end;


//     procedure FnDontAccountForWithdrwnMemberInt()
//     begin
//     end;


//     procedure FnAccountForWithdrwnMemberInt()
//     begin
//     end;
// }

#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings

Codeunit 56011 "Dividends Processing Codeunit2"
{

    trigger OnRun()
    begin
        //FnGetTheDivTotalPayable('1001');
    end;

    var
        jsavings: Decimal;
        Deposits: Decimal;
        walletAccount: Code[20];
        ShareCapital: Decimal;
        MemberExitedTable: Record "Membership Exit";
        DivProg: Record "Dividends Progression";
        DivTotal: Decimal;
        "W/Tax": Decimal;
        CommDiv: Decimal;
        chargge: Decimal;
        GenSetUp: Record "Sacco General Set-Up";
        BDate: Date;
        FromDate: Date;
        ToDate: Date;
        FromDateS: Text;
        ToDateS: Text;
        DateFilter: Text;
        CDiv: Decimal;
        CInterest: Decimal;
        Accountclosedon: Date;
        PayableAmount: Decimal;
        Amountss: Decimal;
        // DivProgressionTable: Record "Dividends Progression";
        GrossTotalDiv: Decimal;
        LineNo: Integer;
        SFactory: Codeunit "SWIZZSOFT Factory.";
        GenJournalLine: Record "Gen. Journal Line";
        GrossDivOnShares: Decimal;
        TotalWhtax: Decimal;
        chargges: Decimal;
        YearCalc: Text;
        NetPayableAmount: Decimal;
        NetPayableAmountFinal: Decimal;
        ExciseDuty: Decimal;
        LastDateOfTheDividendYear: Date;



        qualifyingShareCapital: Decimal;
        grossDividendShareCapital: Decimal;
        qualifyingDeposits: Decimal;
        grossInterestDeposits: Decimal;
        totalDividendPaid: Decimal;
        ShareCapitalBalance: Decimal;
        Dividends_Posting_Breakdown: Record "Dividends Posting Breakdown";

        MembersReg2: Record Customer;


    procedure FnAnalyseMemberCategory(MemberNo: Code[30]; StartDate: Date; PostingDate: Date)
    var
        MembersReg: Record Customer;
    begin

        //start processing
        //get the last day of the year from startdate
        LastDateOfTheDividendYear :=
                            DMY2Date(31, 12, Date2DMY(StartDate, 3));


        //Reset the table figures
        MembersReg2.Reset;
        MembersReg2.SetRange(MembersReg2."No.", MemberNo);
        if MembersReg2.Find('-') then begin
            MembersReg2."Qualifying Deposits" := 0;
            MembersReg2."Qualifying share Capital" := 0;
            MembersReg2."Gross Dividend Amount Payable" := 0;
            MembersReg2."Gross Div on share Capital" := 0;
            MembersReg2."Gross Int On Deposits" := 0;
            MembersReg2."Bank Charges on processings" := 0;
            MembersReg2."WithholdingTax on gross div" := 0;
            MembersReg2."Net Dividend Payable" := 0;
            MembersReg2."Dividend Amount" := 0;

            MembersReg2.Modify();
        end;


        DivProg.Reset;
        DivProg.SetCurrentkey("Member No");
        DivProg.SetRange(DivProg."Member No", MemberNo);
        if DivProg.Find('-') then begin
            DivProg.DeleteAll();
        end;



        //clean dividends progression table for the member =====Festus
        MembersReg.Reset;
        MembersReg.SetRange(MembersReg."No.", MemberNo);
        MembersReg.SetAutocalcFields(MembersReg."Current Shares", MembersReg."Shares Retained");

        MembersReg.SetRange(NotDividendEligible, FALSE);
        //  MembersReg.SetFilter(MembersReg."Shares Retained", '>%1', 0);
        if MembersReg.Find('-') then begin
            //declare variables
            Deposits := 0;
            ShareCapital := 0;

            qualifyingShareCapital := 0;
            grossDividendShareCapital := 0;
            qualifyingDeposits := 0;
            grossInterestDeposits := 0;
            totalDividendPaid := 0;

            //process for the 12 months
            // else if MembersReg.Status <> MembersReg.Status::Withdrawal then begin
            //Member is not equal to withdrwal
            Deposits := MembersReg."Current Shares";
            ShareCapital := MembersReg."Shares Retained";


            DivTotal := 0;
            "W/Tax" := 0;
            CommDiv := 0;
            chargge := 0;
            GenSetUp.Get(0);

            if MembersReg.Status = MembersReg.Status::Withdrawal then begin

                //1)Find account closure date
                MemberExitedTable.Reset;
                MemberExitedTable.SetRange(MemberExitedTable."Member No.", MemberNo);
                if MemberExitedTable.FindLast then begin
                    Accountclosedon := MemberExitedTable."Closing Date";
                    // if Accountclosedon < LastDateOfTheDividendYear then begin
                    if (Accountclosedon = 0D) or (Accountclosedon < LastDateOfTheDividendYear) then begin

                        if MembersReg."Account Category" = MembersReg."Account Category"::"Junior Account" then begin


                            FnJuniorMemberAnalysis2(MembersReg, MemberNo, StartDate, PostingDate);

                        end else begin




                            FnWithdrawnMemberAnalysis(MembersReg, MemberNo, StartDate, PostingDate);


                        end;



                    end else begin
                        //Member exited after the year, so prorate dividends


                        if MembersReg."Account Category" = MembersReg."Account Category"::"Junior Account" then begin


                            FnJuniorMemberAnalysis2(MembersReg, MemberNo, StartDate, PostingDate);

                        end else begin




                            FnactiveMemberAnalysis2(MembersReg, MemberNo, StartDate, PostingDate);


                        end;



                    end;
                end else begin
                    //No record in exit table, but status is withdrawal, so no dividends
                    //                    FnWithdrawnMemberAnalysis(MembersReg, MemberNo, StartDate, PostingDate);
                    if MembersReg."Account Category" = MembersReg."Account Category"::"Junior Account" then begin


                        FnJuniorMemberAnalysis2(MembersReg, MemberNo, StartDate, PostingDate);

                    end else begin




                        FnWithdrawnMemberAnalysis(MembersReg, MemberNo, StartDate, PostingDate);


                    end;

                end;

            end else if MembersReg.Status <> MembersReg.Status::Withdrawal then begin
                //Active members or any other status apart from withdrawal
                if MembersReg."Account Category" = MembersReg."Account Category"::"Junior Account" then begin


                    FnJuniorMemberAnalysis2(MembersReg, MemberNo, StartDate, PostingDate);

                end else begin


                    FnActiveMemberAnalysis2(MembersReg, MemberNo, StartDate, PostingDate);


                end;

            end;

        end;

    end;

    procedure FnWithdrawnMemberAnalysis(MembersReg: Record Customer; MemberNo: Code[30]; StartDate: Date; PostingDate: Date)
    begin
        //.......Update dividends reg for withdrawn members//1073
        Deposits := MembersReg."Current Shares";

        // MembersReg."Account Category" = MembersReg."Account Category"::"Junior Account" then
        //  Deposits := MembersReg."Current Shares";
        //ShareCapital := MembersReg."Shares Retained";
        MembersReg."Dividend Amount" := 0;

        DivProg.Reset;
        DivProg.SetCurrentkey("Member No");
        DivProg.SetRange(DivProg."Member No", MemberNo);
        if DivProg.Find('-') then begin
            DivProg.DeleteAll;
        end;

        DivTotal := 0;
        "W/Tax" := 0;
        CommDiv := 0;
        chargge := 0;
        GenSetUp.Get();
        //.................................START ON COMPUTATION

        //IstMonth START
        Evaluate(BDate, '01/01/05');
        FromDate := BDate;
        ToDate := CalcDate('-1D', StartDate);
        Evaluate(FromDateS, Format(FromDate));
        Evaluate(ToDateS, Format(ToDate));

        MembersReg.Reset;
        MembersReg.SetCurrentkey("No.");
        MembersReg.SetRange(MembersReg."No.", MemberNo);
        MembersReg.SetFilter(MembersReg."Date Filter", '%1..%2', FromDate, CalcDate('CY', StartDate));
        if MembersReg.Find('-') then begin
            Evaluate(BDate, '01/01/05');
            FromDate := BDate;
            ToDate := CalcDate('-1D', StartDate);
            Evaluate(FromDateS, Format(FromDate));
            Evaluate(ToDateS, Format(ToDate));
            DateFilter := FromDateS + '..' + ToDateS;
            MembersReg.Reset;
            MembersReg.SetCurrentkey("No.");
            MembersReg.SetRange(MembersReg."No.", MemberNo);
            MembersReg.SetFilter(MembersReg."Date Filter", DateFilter);
            //.....................
            if MembersReg.Find('-') then begin
                MembersReg.CalcFields(MembersReg."Current Shares", MembersReg."Shares Retained");
                CInterest := 0;
                // CInterest:=(((GenSetUp."Interest on Deposits (%)"/100)*((MembersReg."Shares Retained")))*(12/12));
                //...
                MembersReg2.Reset();
                MembersReg2.SetRange("No.", MembersReg."No.");

                IF MembersReg2.FindFirst() THEN BEGIN
                    CDiv := 0;
                    CDiv := (GenSetUp."Dividend (%)" / 100) * MembersReg."Shares Retained";
                END;
                // if (MembersReg."Shares Retained" > 0.01) then begin
                //     CDiv := 0;
                //     CDiv := (GenSetUp."Dividend (%)" / 100) * MembersReg."Shares Retained";

                //     // CDiv := (((GenSetUp."Dividend (%)" / 100) * ((MembersReg."Shares Retained"))) * (12 / 12));
                // end else if (MembersReg."Shares Retained" < 0.01) then begin
                //     CDiv := 0;
                // end;
                //............
                //qualifyingShareCapital := qualifyingShareCapital + ((MembersReg."Shares Retained")) * (12 / 12);
                qualifyingShareCapital := MembersReg."Shares Retained";
                grossDividendShareCapital := grossDividendShareCapital + CDiv;

                DivTotal := (CDiv + CInterest);
                DivProg.Init;
                DivProg."Member No" := MembersReg."No.";
                DivProg.Date := ToDate;
                DivProg."Gross Dividends" := CDiv;
                //DivProg."Gross Interest On Deposit":=CInterest;
                //MESSAGE('%1',CInterest);
                //DivProg."Qualifying Share Capital" := ((MembersReg."Shares Retained")) * (12 / 12);
                DivProg."Qualifying Share Capital" := MembersReg."Shares Retained";
                DivProg."Witholding Tax" := (CDiv + CInterest) * (GenSetUp."Withholding Tax (%)" / 100);
                DivProg."Net Dividends" := (DivProg."Gross Dividends" + DivProg."Gross Interest On Deposit") - DivProg."Witholding Tax";
                DivProg."Qualifying Shares" := ((MembersReg."Current Shares")) * (12 / 12);
                DivProg.Shares := MembersReg."Current Shares";
                DivProg."Share Capital" := MembersReg."Shares Retained";
                DivProg.Insert;
            end;
            //............................
        end;
        //.iST MONTH END

        //2nd month start
        FromDate := StartDate;
        ToDate := CalcDate('-1D', CalcDate('1M', StartDate));
        Evaluate(FromDateS, Format(FromDate));
        Evaluate(ToDateS, Format(ToDate));
        Evaluate(BDate, '01/01/05');

        DateFilter := FromDateS + '..' + ToDateS;
        if MembersReg.Find('-') then begin

            MembersReg.Reset;
            MembersReg.SetCurrentkey("No.");
            MembersReg.SetRange(MembersReg."No.", MemberNo);
            MembersReg.SetFilter(MembersReg."Date Filter", DateFilter);
            //.....................

            if MembersReg.Find('-') then begin
                MembersReg.CalcFields(MembersReg."Current Shares", MembersReg."Shares Retained");
                CInterest := 0;
                if (MembersReg."Shares Retained" > 0.01) then begin
                    CDiv := 0;
                    //  CDiv := (((GenSetUp."Dividend (%)" / 100) * ((MembersReg."Shares Retained"))) * (11 / 12));
                end else if (MembersReg."Shares Retained" < 0.01) then begin
                    CDiv := 0;
                end;
                //............
                //qualifyingShareCapital := qualifyingShareCapital + ((MembersReg."Shares Retained")) * (11 / 12);
                qualifyingShareCapital := MembersReg."Shares Retained";
                grossDividendShareCapital := grossDividendShareCapital + CDiv;

                DivTotal := (CDiv + CInterest);
                DivProg.Init;
                DivProg."Member No" := MembersReg."No.";
                DivProg.Date := ToDate;
                DivProg."Gross Dividends" := CDiv;
                //DivProg."Gross Interest On Deposit":=CInterest;
                //DivProg."Qualifying Share Capital" := ((MembersReg."Shares Retained")) * (11 / 12);
                DivProg."Qualifying Share Capital" := MembersReg."Shares Retained";
                DivProg."Witholding Tax" := (CDiv + CInterest) * (GenSetUp."Withholding Tax (%)" / 100);
                DivProg."Net Dividends" := (DivProg."Gross Dividends" + DivProg."Gross Interest On Deposit") - DivProg."Witholding Tax";
                DivProg."Qualifying Shares" := ((MembersReg."Current Shares")) * (11 / 12);
                DivProg.Shares := MembersReg."Current Shares";
                DivProg."Share Capital" := MembersReg."Shares Retained";
                DivProg.Insert;
            end;
            //............................
        end;
        //2end

        //.........................3 start
        FromDate := CalcDate('1M', StartDate);
        ToDate := CalcDate('-1D', CalcDate('2M', StartDate));
        Evaluate(FromDateS, Format(FromDate));
        Evaluate(ToDateS, Format(ToDate));

        Evaluate(BDate, '01/01/05');

        DateFilter := FromDateS + '..' + ToDateS;
        if MembersReg.Find('-') then begin

            MembersReg.Reset;
            MembersReg.SetCurrentkey("No.");
            MembersReg.SetRange(MembersReg."No.", MemberNo);
            MembersReg.SetFilter(MembersReg."Date Filter", DateFilter);
            //.....................

            if MembersReg.Find('-') then begin
                MembersReg.CalcFields(MembersReg."Current Shares", MembersReg."Shares Retained");
                CInterest := 0;
                //...
                if (MembersReg."Shares Retained" > 0.01) then begin
                    CDiv := 0;
                    //CDiv := (((GenSetUp."Dividend (%)" / 100) * ((MembersReg."Shares Retained"))) * (10 / 12));
                end else if (MembersReg."Shares Retained" < 0.01) then begin
                    CDiv := 0;
                end;
                //............
                //qualifyingShareCapital := qualifyingShareCapital + ((MembersReg."Shares Retained")) * (10 / 12);
                qualifyingShareCapital := MembersReg."Shares Retained";
                grossDividendShareCapital := grossDividendShareCapital + CDiv;

                DivTotal := (CDiv + CInterest);
                DivProg.Init;
                DivProg."Member No" := MembersReg."No.";
                DivProg.Date := ToDate;
                DivProg."Gross Dividends" := CDiv;
                // DivProg."Gross Interest On Deposit":=CInterest;
                //DivProg."Qualifying Share Capital" := ((MembersReg."Shares Retained")) * (10 / 12);
                DivProg."Qualifying Share Capital" := MembersReg."Shares Retained";
                DivProg."Witholding Tax" := (CDiv + CInterest) * (GenSetUp."Withholding Tax (%)" / 100);
                DivProg."Net Dividends" := (DivProg."Gross Dividends" + DivProg."Gross Interest On Deposit") - DivProg."Witholding Tax";
                DivProg."Qualifying Shares" := ((MembersReg."Current Shares")) * (10 / 12);
                DivProg.Shares := MembersReg."Current Shares";
                DivProg."Share Capital" := MembersReg."Shares Retained";
                DivProg.Insert;
            end;
            //............................
        end;
        //..............................3 stop

        //.................4 START
        FromDate := CalcDate('2M', StartDate);
        ToDate := CalcDate('-1D', CalcDate('3M', StartDate));
        Evaluate(FromDateS, Format(FromDate));
        Evaluate(ToDateS, Format(ToDate));

        Evaluate(BDate, '01/01/05');

        DateFilter := FromDateS + '..' + ToDateS;
        if MembersReg.Find('-') then begin

            MembersReg.Reset;
            MembersReg.SetCurrentkey("No.");
            MembersReg.SetRange(MembersReg."No.", MemberNo);
            MembersReg.SetFilter(MembersReg."Date Filter", DateFilter);
            //.....................

            if MembersReg.Find('-') then begin
                MembersReg.CalcFields(MembersReg."Current Shares", MembersReg."Shares Retained");
                CInterest := 0;
                //...
                if (MembersReg."Shares Retained" > 0.01) then begin
                    CDiv := 0;
                    //CDiv := (((GenSetUp."Dividend (%)" / 100) * ((MembersReg."Shares Retained"))) * (9 / 12));
                end else if (MembersReg."Shares Retained" < 0.01) then begin
                    CDiv := 0;
                end;
                //............
                //qualifyingShareCapital := qualifyingShareCapital + ((MembersReg."Shares Retained")) * (9 / 12);
                qualifyingShareCapital := MembersReg."Shares Retained";
                grossDividendShareCapital := grossDividendShareCapital + CDiv;

                DivTotal := (CDiv + CInterest);
                DivProg.Init;
                DivProg."Member No" := MembersReg."No.";
                DivProg.Date := ToDate;
                DivProg."Gross Dividends" := CDiv;
                DivProg."Gross Interest On Deposit" := CInterest;
                //DivProg."Qualifying Share Capital" := ((MembersReg."Shares Retained")) * (9 / 12);
                DivProg."Qualifying Share Capital" := MembersReg."Shares Retained";
                DivProg."Witholding Tax" := (CDiv + CInterest) * (GenSetUp."Withholding Tax (%)" / 100);
                DivProg."Net Dividends" := (DivProg."Gross Dividends" + DivProg."Gross Interest On Deposit") - DivProg."Witholding Tax";
                DivProg."Qualifying Shares" := ((MembersReg."Current Shares")) * (9 / 12);
                DivProg.Shares := MembersReg."Current Shares";
                DivProg."Share Capital" := MembersReg."Shares Retained";
                DivProg.Insert;
            end;
            //............................
        end;
        //......................4 END
        /////////////////////5 START
        FromDate := CalcDate('3M', StartDate);
        ToDate := CalcDate('-1D', CalcDate('4M', StartDate));
        Evaluate(FromDateS, Format(FromDate));
        Evaluate(ToDateS, Format(ToDate));

        Evaluate(BDate, '01/01/05');

        DateFilter := FromDateS + '..' + ToDateS;
        if MembersReg.Find('-') then begin

            MembersReg.Reset;
            MembersReg.SetCurrentkey("No.");
            MembersReg.SetRange(MembersReg."No.", MemberNo);
            MembersReg.SetFilter(MembersReg."Date Filter", DateFilter);
            //.....................

            if MembersReg.Find('-') then begin
                MembersReg.CalcFields(MembersReg."Current Shares", MembersReg."Shares Retained");
                CInterest := 0;
                //...
                if (MembersReg."Shares Retained" > 0.01) then begin
                    CDiv := 0;
                    //  CDiv := (((GenSetUp."Dividend (%)" / 100) * ((MembersReg."Shares Retained"))) * (8 / 12));
                end else if (MembersReg."Shares Retained" < 0.01) then begin
                    CDiv := 0;
                end;
                //............
                //qualifyingShareCapital := qualifyingShareCapital + ((MembersReg."Shares Retained")) * (8 / 12);
                qualifyingShareCapital := MembersReg."Shares Retained";
                grossDividendShareCapital := grossDividendShareCapital + CDiv;

                DivTotal := (CDiv + CInterest);
                DivProg.Init;
                DivProg."Member No" := MembersReg."No.";
                DivProg.Date := ToDate;
                DivProg."Gross Dividends" := CDiv;
                DivProg."Gross Interest On Deposit" := CInterest;
                //DivProg."Qualifying Share Capital" := ((MembersReg."Shares Retained")) * (8 / 12);
                DivProg."Qualifying Share Capital" := MembersReg."Shares Retained";
                DivProg."Witholding Tax" := (CDiv + CInterest) * (GenSetUp."Withholding Tax (%)" / 100);
                DivProg."Net Dividends" := (DivProg."Gross Dividends" + DivProg."Gross Interest On Deposit") - DivProg."Witholding Tax";
                DivProg."Qualifying Shares" := ((MembersReg."Current Shares")) * (8 / 12);
                DivProg.Shares := MembersReg."Current Shares";
                DivProg."Share Capital" := MembersReg."Shares Retained";
                DivProg.Insert;
            end;
            //............................
        end;
        //....................5 END;
        //........6 START
        FromDate := CalcDate('4M', StartDate);
        ToDate := CalcDate('-1D', CalcDate('5M', StartDate));
        Evaluate(FromDateS, Format(FromDate));
        Evaluate(ToDateS, Format(ToDate));

        Evaluate(BDate, '01/01/05');

        DateFilter := FromDateS + '..' + ToDateS;
        if MembersReg.Find('-') then begin

            MembersReg.Reset;
            MembersReg.SetCurrentkey("No.");
            MembersReg.SetRange(MembersReg."No.", MemberNo);
            MembersReg.SetFilter(MembersReg."Date Filter", DateFilter);
            //.....................

            if MembersReg.Find('-') then begin
                MembersReg.CalcFields(MembersReg."Current Shares", MembersReg."Shares Retained");
                CInterest := 0;
                //...
                if (MembersReg."Shares Retained" > 0.01) then begin
                    CDiv := 0;
                    //CDiv := (((GenSetUp."Dividend (%)" / 100) * ((MembersReg."Shares Retained"))) * (7 / 12));
                end else if (MembersReg."Shares Retained" < 0.01) then begin
                    CDiv := 0;
                end;
                //............
                // qualifyingShareCapital := qualifyingShareCapital + ((MembersReg."Shares Retained")) * (7 / 12);
                qualifyingShareCapital := MembersReg."Shares Retained";
                grossDividendShareCapital := grossDividendShareCapital + CDiv;

                DivTotal := (CDiv + CInterest);
                DivProg.Init;
                DivProg."Member No" := MembersReg."No.";
                DivProg.Date := ToDate;
                DivProg."Gross Dividends" := CDiv;
                DivProg."Gross Interest On Deposit" := CInterest;
                //DivProg."Qualifying Share Capital" := ((MembersReg."Shares Retained")) * (7 / 12);
                DivProg."Qualifying Share Capital" := MembersReg."Shares Retained";
                DivProg."Witholding Tax" := (CDiv + CInterest) * (GenSetUp."Withholding Tax (%)" / 100);
                DivProg."Net Dividends" := (DivProg."Gross Dividends" + DivProg."Gross Interest On Deposit") - DivProg."Witholding Tax";
                DivProg."Qualifying Shares" := ((MembersReg."Current Shares")) * (7 / 12);
                DivProg.Shares := MembersReg."Current Shares";
                DivProg."Share Capital" := MembersReg."Shares Retained";
                DivProg.Insert;
            end;
            //............................
        end;
        //........6 END

        //...........7 SART
        FromDate := CalcDate('5M', StartDate);
        ToDate := CalcDate('-1D', CalcDate('6M', StartDate));
        Evaluate(FromDateS, Format(FromDate));
        Evaluate(ToDateS, Format(ToDate));

        Evaluate(BDate, '01/01/05');

        DateFilter := FromDateS + '..' + ToDateS;
        if MembersReg.Find('-') then begin

            MembersReg.Reset;
            MembersReg.SetCurrentkey("No.");
            MembersReg.SetRange(MembersReg."No.", MemberNo);
            MembersReg.SetFilter(MembersReg."Date Filter", DateFilter);
            //.....................

            if MembersReg.Find('-') then begin
                MembersReg.CalcFields(MembersReg."Current Shares", MembersReg."Shares Retained");
                CInterest := 0;
                //...
                if (MembersReg."Shares Retained" > 0.01) then begin
                    CDiv := 0;
                    //CDiv := (((GenSetUp."Dividend (%)" / 100) * ((MembersReg."Shares Retained"))) * (6 / 12));
                end else if (MembersReg."Shares Retained" < 0.01) then begin
                    CDiv := 0;
                end;
                //............
                //qualifyingShareCapital := qualifyingShareCapital + ((MembersReg."Shares Retained")) * (6 / 12);
                qualifyingShareCapital := MembersReg."Shares Retained";
                grossDividendShareCapital := grossDividendShareCapital + CDiv;

                DivTotal := (CDiv + CInterest);
                DivProg.Init;
                DivProg."Member No" := MembersReg."No.";
                DivProg.Date := ToDate;
                DivProg."Gross Dividends" := CDiv;
                DivProg."Gross Interest On Deposit" := CInterest;
                //DivProg."Qualifying Share Capital" := ((MembersReg."Shares Retained")) * (6 / 12);
                DivProg."Qualifying Share Capital" := MembersReg."Shares Retained";
                DivProg."Witholding Tax" := (CDiv + CInterest) * (GenSetUp."Withholding Tax (%)" / 100);
                DivProg."Net Dividends" := (DivProg."Gross Dividends" + DivProg."Gross Interest On Deposit") - DivProg."Witholding Tax";
                DivProg."Qualifying Shares" := ((MembersReg."Current Shares")) * (6 / 12);
                DivProg.Shares := MembersReg."Current Shares";
                DivProg."Share Capital" := MembersReg."Shares Retained";
                DivProg.Insert;
            end;
            //............................
        end;
        //................7 END
        //.....8 START
        FromDate := CalcDate('6M', StartDate);
        ToDate := CalcDate('-1D', CalcDate('7M', StartDate));
        Evaluate(FromDateS, Format(FromDate));
        Evaluate(ToDateS, Format(ToDate));

        Evaluate(BDate, '01/01/05');

        DateFilter := FromDateS + '..' + ToDateS;
        if MembersReg.Find('-') then begin

            MembersReg.Reset;
            MembersReg.SetCurrentkey("No.");
            MembersReg.SetRange(MembersReg."No.", MemberNo);
            MembersReg.SetFilter(MembersReg."Date Filter", DateFilter);
            //.....................

            if MembersReg.Find('-') then begin
                MembersReg.CalcFields(MembersReg."Current Shares", MembersReg."Shares Retained");
                CInterest := 0;
                //...
                if (MembersReg."Shares Retained" > 0.01) then begin
                    CDiv := 0;
                    //    CDiv := (((GenSetUp."Dividend (%)" / 100) * ((MembersReg."Shares Retained"))) * (5 / 12));
                end else if (MembersReg."Shares Retained" < 0.01) then begin
                    CDiv := 0;
                end;
                //............
                //qualifyingShareCapital := qualifyingShareCapital + ((MembersReg."Shares Retained")) * (5 / 12);
                qualifyingShareCapital := MembersReg."Shares Retained";
                grossDividendShareCapital := grossDividendShareCapital + CDiv;

                DivTotal := (CDiv + CInterest);
                DivProg.Init;
                DivProg."Member No" := MembersReg."No.";
                DivProg.Date := ToDate;
                DivProg."Gross Dividends" := CDiv;
                DivProg."Gross Interest On Deposit" := CInterest;
                //DivProg."Qualifying Share Capital" := ((MembersReg."Shares Retained")) * (5 / 12);
                DivProg."Qualifying Share Capital" := MembersReg."Shares Retained";
                DivProg."Witholding Tax" := (CDiv + CInterest) * (GenSetUp."Withholding Tax (%)" / 100);
                DivProg."Net Dividends" := (DivProg."Gross Dividends" + DivProg."Gross Interest On Deposit") - DivProg."Witholding Tax";
                DivProg."Qualifying Shares" := ((MembersReg."Current Shares")) * (5 / 12);
                DivProg.Shares := MembersReg."Current Shares";
                DivProg."Share Capital" := MembersReg."Shares Retained";
                DivProg.Insert;
            end;
            //............................
        end;
        //.......8 END

        //9 START
        FromDate := CalcDate('7M', StartDate);
        ToDate := CalcDate('-1D', CalcDate('8M', StartDate));
        Evaluate(FromDateS, Format(FromDate));
        Evaluate(ToDateS, Format(ToDate));

        Evaluate(BDate, '01/01/05');

        DateFilter := FromDateS + '..' + ToDateS;
        if MembersReg.Find('-') then begin

            MembersReg.Reset;
            MembersReg.SetCurrentkey("No.");
            MembersReg.SetRange(MembersReg."No.", MemberNo);
            MembersReg.SetFilter(MembersReg."Date Filter", DateFilter);
            //.....................

            if MembersReg.Find('-') then begin
                MembersReg.CalcFields(MembersReg."Current Shares", MembersReg."Shares Retained");
                CInterest := 0;
                //...
                if (MembersReg."Shares Retained" > 0.01) then begin
                    CDiv := 0;
                    //CDiv := (((GenSetUp."Dividend (%)" / 100) * ((MembersReg."Shares Retained"))) * (4 / 12));
                end else if (MembersReg."Shares Retained" < 0.01) then begin
                    CDiv := 0;
                end;
                //............
                //qualifyingShareCapital := qualifyingShareCapital + ((MembersReg."Shares Retained")) * (4 / 12);
                qualifyingShareCapital := MembersReg."Shares Retained";
                grossDividendShareCapital := grossDividendShareCapital + CDiv;

                DivTotal := (CDiv + CInterest);
                DivProg.Init;
                DivProg."Member No" := MembersReg."No.";
                DivProg.Date := ToDate;
                DivProg."Gross Dividends" := CDiv;
                DivProg."Gross Interest On Deposit" := CInterest;
                //DivProg."Qualifying Share Capital" := ((MembersReg."Shares Retained")) * (4 / 12);
                DivProg."Qualifying Share Capital" := MembersReg."Shares Retained";
                DivProg."Witholding Tax" := (CDiv + CInterest) * (GenSetUp."Withholding Tax (%)" / 100);
                DivProg."Net Dividends" := (DivProg."Gross Dividends" + DivProg."Gross Interest On Deposit") - DivProg."Witholding Tax";
                DivProg."Qualifying Shares" := ((MembersReg."Current Shares")) * (4 / 12);
                DivProg.Shares := MembersReg."Current Shares";
                DivProg."Share Capital" := MembersReg."Shares Retained";
                DivProg.Insert;
            end;
            //............................
        end;
        //.9 END
        //10 START
        FromDate := CalcDate('8M', StartDate);
        ToDate := CalcDate('-1D', CalcDate('9M', StartDate));
        Evaluate(FromDateS, Format(FromDate));
        Evaluate(ToDateS, Format(ToDate));

        Evaluate(BDate, '01/01/05');

        DateFilter := FromDateS + '..' + ToDateS;
        if MembersReg.Find('-') then begin

            MembersReg.Reset;
            MembersReg.SetCurrentkey("No.");
            MembersReg.SetRange(MembersReg."No.", MemberNo);
            MembersReg.SetFilter(MembersReg."Date Filter", DateFilter);
            //.....................

            if MembersReg.Find('-') then begin
                MembersReg.CalcFields(MembersReg."Current Shares", MembersReg."Shares Retained");
                CInterest := 0;
                //...
                if (MembersReg."Shares Retained" > 0.01) then begin
                    CDiv := 0;
                    // CDiv := (((GenSetUp."Dividend (%)" / 100) * ((MembersReg."Shares Retained"))) * (3 / 12));
                end else if (MembersReg."Shares Retained" < 0.01) then begin
                    CDiv := 0;
                end;
                //............
                //qualifyingShareCapital := qualifyingShareCapital + ((MembersReg."Shares Retained")) * (3 / 12);
                qualifyingShareCapital := MembersReg."Shares Retained";
                grossDividendShareCapital := grossDividendShareCapital + CDiv;

                DivTotal := (CDiv + CInterest);
                DivProg.Init;
                DivProg."Member No" := MembersReg."No.";
                DivProg.Date := ToDate;
                DivProg."Gross Dividends" := CDiv;
                DivProg."Gross Interest On Deposit" := CInterest;
                //DivProg."Qualifying Share Capital" := ((MembersReg."Shares Retained")) * (3 / 12);

                DivProg."Qualifying Share Capital" := MembersReg."Shares Retained";
                DivProg."Witholding Tax" := (CDiv + CInterest) * (GenSetUp."Withholding Tax (%)" / 100);
                DivProg."Net Dividends" := (DivProg."Gross Dividends" + DivProg."Gross Interest On Deposit") - DivProg."Witholding Tax";
                DivProg."Qualifying Shares" := ((MembersReg."Current Shares")) * (3 / 12);
                DivProg.Shares := MembersReg."Current Shares";
                DivProg."Share Capital" := MembersReg."Shares Retained";
                DivProg.Insert;
            end;
            //............................
        end;
        //10 END
        //..11 START
        FromDate := CalcDate('9M', StartDate);
        ToDate := CalcDate('-1D', CalcDate('10M', StartDate));
        Evaluate(FromDateS, Format(FromDate));
        Evaluate(ToDateS, Format(ToDate));

        Evaluate(BDate, '01/01/05');

        DateFilter := FromDateS + '..' + ToDateS;
        if MembersReg.Find('-') then begin

            MembersReg.Reset;
            MembersReg.SetCurrentkey("No.");
            MembersReg.SetRange(MembersReg."No.", MemberNo);
            MembersReg.SetFilter(MembersReg."Date Filter", DateFilter);
            //.....................

            if MembersReg.Find('-') then begin
                MembersReg.CalcFields(MembersReg."Current Shares", MembersReg."Shares Retained");
                CInterest := 0;
                //...
                if (MembersReg."Shares Retained" > 0.01) then begin
                    CDiv := 0;
                    // CDiv := (((GenSetUp."Dividend (%)" / 100) * ((MembersReg."Shares Retained"))) * (2 / 12));
                end else if (MembersReg."Shares Retained" < 0.01) then begin
                    CDiv := 0;
                end;
                //............
                //qualifyingShareCapital := qualifyingShareCapital + ((MembersReg."Shares Retained")) * (2 / 12);
                qualifyingShareCapital := MembersReg."Shares Retained";
                grossDividendShareCapital := grossDividendShareCapital + CDiv;

                DivTotal := (CDiv + CInterest);
                DivProg.Init;
                DivProg."Member No" := MembersReg."No.";
                DivProg.Date := ToDate;
                DivProg."Gross Dividends" := CDiv;
                DivProg."Gross Interest On Deposit" := CInterest;
                //DivProg."Qualifying Share Capital" := ((MembersReg."Shares Retained")) * (2 / 12);
                DivProg."Qualifying Share Capital" := MembersReg."Shares Retained";
                DivProg."Witholding Tax" := (CDiv + CInterest) * (GenSetUp."Withholding Tax (%)" / 100);
                DivProg."Net Dividends" := (DivProg."Gross Dividends" + DivProg."Gross Interest On Deposit") - DivProg."Witholding Tax";
                DivProg."Qualifying Shares" := ((MembersReg."Current Shares")) * (2 / 12);
                DivProg.Shares := MembersReg."Current Shares";
                DivProg."Share Capital" := MembersReg."Shares Retained";
                DivProg.Insert;
            end;
            //............................
        end;
        //.11 END
        //12 START
        FromDate := CalcDate('10M', StartDate);
        ToDate := CalcDate('-1D', CalcDate('11M', StartDate));
        Evaluate(FromDateS, Format(FromDate));
        Evaluate(ToDateS, Format(ToDate));

        Evaluate(BDate, '01/01/05');

        DateFilter := FromDateS + '..' + ToDateS;
        if MembersReg.Find('-') then begin

            MembersReg.Reset;
            MembersReg.SetCurrentkey("No.");
            MembersReg.SetRange(MembersReg."No.", MemberNo);
            MembersReg.SetFilter(MembersReg."Date Filter", DateFilter);
            //.....................

            if MembersReg.Find('-') then begin
                MembersReg.CalcFields(MembersReg."Current Shares", MembersReg."Shares Retained");
                CInterest := 0;
                //...
                if (MembersReg."Shares Retained" > 0.01) then begin
                    CDiv := 0;
                    // CDiv := (((GenSetUp."Dividend (%)" / 100) * ((MembersReg."Shares Retained"))) * (1 / 12));
                end else if (MembersReg."Shares Retained" < 0.01) then begin
                    CDiv := 0;
                end;
                //............
                //qualifyingShareCapital := qualifyingShareCapital + ((MembersReg."Shares Retained")) * (1 / 12);
                qualifyingShareCapital := MembersReg."Shares Retained";
                grossDividendShareCapital := grossDividendShareCapital + CDiv;

                DivTotal := (CDiv + CInterest);
                DivProg.Init;
                DivProg."Member No" := MembersReg."No.";
                DivProg.Date := ToDate;
                DivProg."Gross Dividends" := CDiv;
                DivProg."Gross Interest On Deposit" := CInterest;
                //DivProg."Qualifying Share Capital" := ((MembersReg."Shares Retained")) * (1 / 12);
                DivProg."Qualifying Share Capital" := MembersReg."Shares Retained";
                DivProg."Witholding Tax" := (CDiv + CInterest) * (GenSetUp."Withholding Tax (%)" / 100);
                DivProg."Net Dividends" := (DivProg."Gross Dividends" + DivProg."Gross Interest On Deposit") - DivProg."Witholding Tax";
                DivProg."Qualifying Shares" := ((MembersReg."Current Shares")) * (1 / 12);
                DivProg.Shares := MembersReg."Current Shares";
                DivProg."Share Capital" := MembersReg."Shares Retained";
                DivProg.Insert;
            end;
            //............................
        end;
        //12 END

        if (MembersReg."Shares Retained" > 0.01) then begin

            CDiv := (GenSetUp."Dividend (%)" / 100) * MembersReg."Shares Retained";
        end;
        //....................get the sum amounts
        //2030
        //.................................................Pass GL START
        PayableAmount := 0;
        PayableAmount := FnGetTheDivTotalPayable(MemberNo);//Net Amount Paybale to member
        GrossTotalDiv := 0;
        //GrossTotalDiv := FnGetTheGrossDivPayable(MemberNo);
        GrossDivOnShares := 0;
        GrossDivOnShares := (FnGetTheGrossDivOnSharesPayable(MemberNo));
        TotalWhtax := 0;
        //  TotalWhtax := FnGetTotalWhtax(MemberNo);
        NetPayableAmount := 0;
        NetPayableAmount := FnGetTheNetPayable(MemberNo);

        walletAccount := SFactory.FnGetFosaAccount(MemberNo);
        //POST Dividends here
        LineNo := LineNo + 10000;
        //do not deduct 200 for withdrawn members, or members with no interest on deposits


        totalDividendPaid := grossDividendShareCapital + grossInterestDeposits;
        if totalDividendPaid < 500 then exit;

        Dividends_Posting_Breakdown.Init();
        Dividends_Posting_Breakdown.Entry := GetNextEntryNo();
        Dividends_Posting_Breakdown."Member Number" := MemberNo;
        Dividends_Posting_Breakdown."Payroll Number" := MembersReg."Payroll/Staff No";
        Dividends_Posting_Breakdown.Name := MembersReg.Name;
        Dividends_Posting_Breakdown."Qualifying Shares" := qualifyingShareCapital;
        Dividends_Posting_Breakdown."Qualifying Deposits" := qualifyingDeposits;
        Dividends_Posting_Breakdown."Dividends On Shares" := grossDividendShareCapital;
        Dividends_Posting_Breakdown."Interest on Deposits" := grossInterestDeposits;


        TotalWhtax := totalDividendPaid * (GenSetUp."Withholding Tax (%)" / 100);
        GrossTotalDiv := totalDividendPaid;


        FnPostWithdrawnDividends(MemberNo,
                                PostingDate,
                                GrossTotalDiv,
                                TotalWhtax,
                                StartDate,
                                fnGetMemberShareCapital(MemberNo)
                                );
        ExciseDuty := 0;
        ExciseDuty := (GenSetUp."Dividend Processing Fee" * (GenSetUp."Excise Duty(%)" / 100));

        NetPayableAmountFinal := NetPayableAmount - ExciseDuty;

        //withdrawn members update =they get only grossDividendShareCapital
        MembersReg."Qualifying Deposits" := 0;// qualifyingDeposits;
        MembersReg."Qualifying share Capital" := qualifyingShareCapital;
        MembersReg."Gross Dividend Amount Payable" := grossDividendShareCapital;// totalDividendPaid;
        MembersReg."Gross Div on share Capital" := grossDividendShareCapital;
        MembersReg."Gross Int On Deposits" := 0;// grossInterestDeposits;
        MembersReg."Bank Charges on processings" := 0;//no bank charges on dividend processing
        MembersReg."WithholdingTax on gross div" := TotalWhtax;
        MembersReg."Net Dividend Payable" := NetPayableAmountFinal;
        MembersReg.Modify();

        Dividends_Posting_Breakdown."Total Earnings" := totalDividendPaid;
        Dividends_Posting_Breakdown.Insert();

    end;


    procedure FnActiveMemberAnalysis2(MembersReg: Record Customer; MemberNo: Code[30]; StartDate: Date; PostingDate: Date)
    var
        RunningBalance: Decimal;
        DividendEndDate: Date;
        MonthWeight: Decimal;
        i: Integer;
        PreviousYearEndDate: Date;
        MonthIncrement: Text;
        DividendStartDate: Date;
    begin
        CInterest := 0;
        CDiv := 0;
        qualifyingDeposits := 0;
        grossInterestDeposits := 0;
        grossDividendShareCapital := 0;

        MembersReg.Reset();
        MembersReg.SetCurrentKey("No.");
        MembersReg.SetRange("No.", MemberNo);

        if MembersReg.FindFirst() then begin

            // Share capital dividend — flat annual,
            MembersReg.CalcFields("Shares Retained", "Current Shares");

            DivProg.Shares := MembersReg."Current Shares";



            CDiv := (GenSetUp."Dividend (%)" / 100) * MembersReg."Shares Retained";
            QualifyingShareCapital := MembersReg."Shares Retained";
            grossDividendShareCapital := CDiv;

            for i := 1 to 12 do begin
                DividendEndDate := CalcDate('<' + Format(i) + 'M-1D>', StartDate);

                MembersReg.SetRange("Date Filter");
                MembersReg.SetFilter("Date Filter", '..%1', DividendEndDate);
                MembersReg.CalcFields("Current Shares");

                RunningBalance := MembersReg."Current Shares";

                //MonthWeight := (13 - i) / 12;
                MonthWeight := 12;


                CInterest += (GenSetUp."Interest on Deposits (%)" / 100 / MonthWeight) * RunningBalance;

                DivProg.Init();
                DivProg."Member No" := MemberNo;
                DivProg.Date := DividendEndDate;
                DivProg."Gross Interest On Deposit" := (GenSetUp."Interest on Deposits (%)" / 100 / MonthWeight) * RunningBalance;
                DivProg."Qualifying Shares" := RunningBalance;
                // DivProg.Shares := RunningBalance;
                DivProg."Witholding Tax" :=
                    DivProg."Gross Interest On Deposit" * (GenSetUp."Withholding Tax (%)" / 100);
                DivProg."Net Dividends" :=
                    DivProg."Gross Interest On Deposit" - DivProg."Witholding Tax";

                DivProg.Insert();
            end;

            qualifyingDeposits := RunningBalance;
            grossInterestDeposits := CInterest;
        end;


        PayableAmount := 0;
        PayableAmount := FnGetTheDivTotalPayable(MemberNo);//Net Amount Paybale to member
        GrossTotalDiv := 0;
        //GrossTotalDiv := FnGetTheGrossDivPayable(MemberNo);
        GrossDivOnShares := 0;
        GrossDivOnShares := (FnGetTheGrossDivOnSharesPayable(MemberNo));
        TotalWhtax := 0;
        //TotalWhtax := FnGetTotalWhtax(MemberNo);
        NetPayableAmount := 0;
        NetPayableAmount := FnGetTheNetPayable(MemberNo);


        totalDividendPaid := grossDividendShareCapital + grossInterestDeposits;
        if totalDividendPaid < 500 then exit;


        Dividends_Posting_Breakdown.Init();
        Dividends_Posting_Breakdown.Entry := GetNextEntryNo();
        Dividends_Posting_Breakdown."Member Number" := MemberNo;
        Dividends_Posting_Breakdown."Payroll Number" := MembersReg."Payroll/Staff No";
        Dividends_Posting_Breakdown.Name := MembersReg.Name;
        Dividends_Posting_Breakdown."Qualifying Shares" := qualifyingShareCapital;
        Dividends_Posting_Breakdown."Qualifying Deposits" := qualifyingDeposits;
        Dividends_Posting_Breakdown."Dividends On Shares" := grossDividendShareCapital;
        Dividends_Posting_Breakdown."Interest on Deposits" := grossInterestDeposits;


        TotalWhtax := totalDividendPaid * (GenSetUp."Withholding Tax (%)" / 100);

        GrossTotalDiv := totalDividendPaid;


        FnPostDividendstoWallet(MemberNo,
                                PostingDate,
                                GrossTotalDiv,
                                TotalWhtax,
                                StartDate
                                );

        //.................................................Pass GL START



        ExciseDuty := 0;
        ExciseDuty := (GenSetUp."Dividend Processing Fee" * (GenSetUp."Excise Duty(%)" / 100));
        //.................................................END PASS GL

        NetPayableAmountFinal := NetPayableAmount - ExciseDuty;

        MembersReg."Qualifying Deposits" := qualifyingDeposits;
        MembersReg."Qualifying share Capital" := qualifyingShareCapital;
        MembersReg."Gross Dividend Amount Payable" := totalDividendPaid;
        MembersReg."Gross Div on share Capital" := grossDividendShareCapital;
        MembersReg."Gross Int On Deposits" := grossInterestDeposits;
        MembersReg."Bank Charges on processings" := 150;// 0;//no bank charges on dividend processing
        MembersReg."WithholdingTax on gross div" := TotalWhtax;
        MembersReg."Net Dividend Payable" := NetPayableAmountFinal;
        MembersReg.Modify();


        Dividends_Posting_Breakdown."Total Earnings" := totalDividendPaid;
        Dividends_Posting_Breakdown.Insert();
    end;



    procedure FnJuniorMemberAnalysis2(MembersReg: Record Customer; MemberNo: Code[30]; StartDate: Date; PostingDate: Date)
    var
        RunningBalance: Decimal;
        DividendEndDate: Date;
        MonthWeight: Decimal;
        i: Integer;
        PreviousYearEndDate: Date;
        MonthIncrement: Text;
        DividendStartDate: Date;
    begin
        CInterest := 0;
        CDiv := 0;
        qualifyingDeposits := 0;
        grossInterestDeposits := 0;
        grossDividendShareCapital := 0;

        MembersReg.Reset();
        MembersReg.SetCurrentKey("No.");
        MembersReg.SetRange("No.", MemberNo);

        if MembersReg.FindFirst() then begin

            // Share capital dividend — flat annual,
            //  MembersReg.CalcFields("Shares Retained", "Current Shares");

            MembersReg.CalculateJuniorSavings();

            DivProg.Shares := MembersReg."Junior Savings";



            CDiv := (GenSetUp."Dividend (%)" / 100) * MembersReg."Shares Retained";
            QualifyingShareCapital := MembersReg."Shares Retained";
            grossDividendShareCapital := CDiv;

            for i := 1 to 12 do begin
                DividendEndDate := CalcDate('<' + Format(i) + 'M-1D>', StartDate);

                MembersReg.SetRange("Date Filter");
                MembersReg.SetFilter("Date Filter", '..%1', DividendEndDate);
                //MembersReg.CalcFields("Current Shares");
                MembersReg.CalculateJuniorSavings();

                RunningBalance := MembersReg."Junior Savings";

                //MonthWeight := (13 - i) / 12;
                MonthWeight := 12;


                CInterest += (GenSetUp."Interest on Deposits (%)" / 100 / MonthWeight) * RunningBalance;

                DivProg.Init();
                DivProg."Member No" := MemberNo;
                DivProg.Date := DividendEndDate;
                DivProg."Gross Interest On Deposit" := (GenSetUp."Interest on Deposits (%)" / 100 / MonthWeight) * RunningBalance;
                DivProg."Qualifying Shares" := RunningBalance;
                // DivProg.Shares := RunningBalance;
                DivProg."Witholding Tax" :=
                    DivProg."Gross Interest On Deposit" * (GenSetUp."Withholding Tax (%)" / 100);
                DivProg."Net Dividends" :=
                    DivProg."Gross Interest On Deposit" - DivProg."Witholding Tax";

                DivProg.Insert();
            end;

            qualifyingDeposits := RunningBalance;
            grossInterestDeposits := CInterest;
        end;


        PayableAmount := 0;
        PayableAmount := FnGetTheDivTotalPayable(MemberNo);//Net Amount Paybale to member
        GrossTotalDiv := 0;
        // GrossTotalDiv := FnGetTheGrossDivPayable(MemberNo);
        GrossDivOnShares := 0;
        GrossDivOnShares := (FnGetTheGrossDivOnSharesPayable(MemberNo));
        TotalWhtax := 0;
        //   TotalWhtax := FnGetTotalWhtax(MemberNo);
        NetPayableAmount := 0;
        NetPayableAmount := FnGetTheNetPayable(MemberNo);


        totalDividendPaid := grossDividendShareCapital + grossInterestDeposits;
        if totalDividendPaid < 500 then exit;


        Dividends_Posting_Breakdown.Init();
        Dividends_Posting_Breakdown.Entry := GetNextEntryNo();
        Dividends_Posting_Breakdown."Member Number" := MemberNo;
        Dividends_Posting_Breakdown."Payroll Number" := MembersReg."Payroll/Staff No";
        Dividends_Posting_Breakdown.Name := MembersReg.Name;
        Dividends_Posting_Breakdown."Qualifying Shares" := qualifyingShareCapital;
        Dividends_Posting_Breakdown."Qualifying Deposits" := qualifyingDeposits;
        Dividends_Posting_Breakdown."Dividends On Shares" := grossDividendShareCapital;
        Dividends_Posting_Breakdown."Interest on Deposits" := grossInterestDeposits;


        TotalWhtax := totalDividendPaid * (GenSetUp."Withholding Tax (%)" / 100);
        GrossTotalDiv := totalDividendPaid;



        FnPostDividendstoWallet(MemberNo,
                                PostingDate,
                                GrossTotalDiv,
                                TotalWhtax,
                                StartDate
                                );

        //.................................................Pass GL START



        ExciseDuty := 0;
        ExciseDuty := (GenSetUp."Dividend Processing Fee" * (GenSetUp."Excise Duty(%)" / 100));
        //.................................................END PASS GL

        NetPayableAmountFinal := NetPayableAmount - ExciseDuty;

        MembersReg."Qualifying Deposits" := qualifyingDeposits;
        MembersReg."Qualifying share Capital" := qualifyingShareCapital;
        MembersReg."Gross Dividend Amount Payable" := totalDividendPaid;
        MembersReg."Gross Div on share Capital" := grossDividendShareCapital;
        MembersReg."Gross Int On Deposits" := grossInterestDeposits;
        MembersReg."Bank Charges on processings" := 150;// 0;//no bank charges on dividend processing
        MembersReg."WithholdingTax on gross div" := TotalWhtax;
        MembersReg."Net Dividend Payable" := NetPayableAmountFinal;
        MembersReg.Modify();


        Dividends_Posting_Breakdown."Total Earnings" := totalDividendPaid;
        Dividends_Posting_Breakdown.Insert();
    end;








    procedure GetNextEntryNo(): Integer
    var
        DividendReceipt: Record "Dividends Posting Breakdown";
    begin
        DividendReceipt.Reset();
        if DividendReceipt.FindLast() then
            exit(DividendReceipt.Entry + 1)
        else
            exit(1);
    end;

    local procedure fnGetMemberShareCapital(memberNumber: Code[20]) sharesCapital: Decimal
    var
        membersTable: Record Customer;
    begin
        sharesCapital := 0;

        membersTable.Reset();
        membersTable.SetRange("No.", memberNumber);
        if membersTable.Find('-') then begin
            membersTable.CalcFields("Shares Retained");
            sharesCapital := membersTable."Shares Retained";
        end;
    end;

    procedure FnPostWithdrawnDividends(MemberNo: Code[20]; PostingDate: Date; GrossTotalDiv: Decimal; TotalWhtax: Decimal; StartDate: Date; sharesCapital: Decimal)
    var
        DividendAmount: Decimal;
        smsText: Text[1000];
        loanRecovered: Decimal;
        sharesToPay: Decimal;
    begin
        //Declaration....
        smsText := '';
        DividendAmount := GrossTotalDiv;
        walletAccount := SFactory.FnGetFosaAccount(MemberNo);
        YearCalc := Format(Date2dmy(StartDate, 3));
        GenSetUp.Get();
        ExciseDuty := 0;
        ExciseDuty := (GenSetUp."Dividend Processing Fee" * (GenSetUp."Excise Duty(%)" / 100));

        ////### -- 1.1 CREDIT MEMBER DIVIDEND -GrossTotalDiv
        LineNo := LineNo + 10000;
        SFactory.FnCreateGnlJournalLine('PAYMENTS', 'DIVIDEND', 'DIV ' + Format(YearCalc), LineNo, GenJournalLine."transaction type"::Dividend,
        GenJournalLine."account type"::Customer, MemberNo, PostingDate, GrossTotalDiv * -1, 'BOSA', '',
        'Gross Dividend and Interest on Deposits - ' + Format(YearCalc), '');

        ////## --- 1.2 DEBIT DIVIDEND PAYABLE GL - GrossTotalDiv
        LineNo := LineNo + 10000;
        GenSetUp.Get();
        SFactory.FnCreateGnlJournalLine('PAYMENTS', 'DIVIDEND', 'DIV ' + Format(YearCalc), LineNo, GenJournalLine."transaction type"::" ",
        GenJournalLine."Account Type"::"G/L Account", GenSetUp."Dividend Payable Account", PostingDate, GrossTotalDiv, 'BOSA', '',
        'Gross Dividend and Interest on Deposits - ' + MemberNo, '');

        ///######## 3.1 CREDIT WTX GL ACC
        LineNo := LineNo + 10000;
        SFactory.FnCreateGnlJournalLine('PAYMENTS', 'DIVIDEND', 'DIV ' + Format(YearCalc), LineNo, GenJournalLine."transaction type"::" ",
        GenJournalLine."account type"::"G/L Account", GenSetUp."WithHolding Tax Account", PostingDate, (TotalWhtax) * -1, 'BOSA', '',
        'Witholding Tax on Dividend- ' + MemberNo, '');

        //########## 3.2 DEBIT Div Membe Acc ON WTX
        LineNo := LineNo + 10000;
        SFactory.FnCreateGnlJournalLine('PAYMENTS', 'DIVIDEND', 'DIV ' + Format(YearCalc), LineNo, GenJournalLine."transaction type"::Dividend,
        GenJournalLine."account type"::Customer, MemberNo, PostingDate, (TotalWhtax), 'BOSA', '',
        'Witholding Tax on Dividend- ' + YearCalc, '');
        DividendAmount := DividendAmount - TotalWhtax;


        ////######## 4.1 DEBIT Member Number ON PROCESSSING FEE
        LineNo := LineNo + 10000;
        SFactory.FnCreateGnlJournalLine('PAYMENTS', 'DIVIDEND', 'DIV ' + Format(YearCalc), LineNo, GenJournalLine."transaction type"::Dividend,
        GenJournalLine."account type"::Customer, MemberNo, PostingDate, GenSetUp."Dividend Processing Fee", 'BOSA', '',
        'Processing Fee- ' + MemberNo, '');
        ///##### 4.2 CREDIT PROCESSING FEE GL ACC
        LineNo := LineNo + 10000;
        SFactory.FnCreateGnlJournalLine('PAYMENTS', 'DIVIDEND', 'DIV ' + Format(YearCalc), LineNo, GenJournalLine."transaction type"::" ",
        GenJournalLine."account type"::"G/L Account", GenSetUp."Dividend Process Fee Account", PostingDate, GenSetUp."Dividend Processing Fee" * -1, 'BOSA', '',
        'Processing Fee- ' + Format(PostingDate), '');
        DividendAmount := DividendAmount - GenSetUp."Dividend Processing Fee";


        // //###### 5.1 DEBIT M-WALLET ON EXCISE DUTY ON PROCESSING FEE 
        // LineNo := LineNo + 10000;
        // SFactory.FnCreateGnlJournalLine('PAYMENTS', 'DIVIDEND', 'DIV ' + Format(YearCalc), LineNo, GenJournalLine."transaction type"::Dividend,
        // GenJournalLine."account type"::Vendor, walletAccount, PostingDate, ExciseDuty, 'BOSA', '',
        // 'Excise on DivProcessing Fee ' + MemberNo, '');
        // //###### 5.2 CREDIT EXCISE DUTY GL ACC
        // LineNo := LineNo + 10000;
        // SFactory.FnCreateGnlJournalLine('PAYMENTS', 'DIVIDEND', 'DIV ' + Format(YearCalc), LineNo, GenJournalLine."transaction type"::" ",
        // GenJournalLine."account type"::"G/L Account", GenSetUp."Dividend Process Fee Account", PostingDate, ExciseDuty * -1, 'BOSA', '',
        // 'Excise on DivProcessing Fee ' + Format(PostingDate), '');
        // DividendAmount := DividendAmount - ExciseDuty;

        //POST the sharesCapital for members with less than 15,000
        if (sharesCapital < 15000) and (DividendAmount > 0) then begin
            sharesToPay := 0;
            sharesToPay := 15000 - sharesCapital;
            if sharesToPay >= DividendAmount then
                sharesToPay := DividendAmount;

            /////######## 2.1 Shares Capital
            LineNo := LineNo + 10000;
            SFactory.FnCreateGnlJournalLine('PAYMENTS', 'DIVIDEND', 'DIV ' + Format(YearCalc), LineNo, GenJournalLine."transaction type"::"Share Capital",
            GenJournalLine."Account Type"::Customer, MemberNo, PostingDate, (sharesToPay) * -1, 'BOSA', '',
            'Dividend Capitalization ' + Format(YearCalc), '');
            //#########  2.2 DEBIT MEMBER DIVIDEND
            LineNo := LineNo + 10000;
            SFactory.FnCreateGnlJournalLine('PAYMENTS', 'DIVIDEND', 'DIV ' + Format(YearCalc), LineNo, GenJournalLine."transaction type"::Dividend,
            GenJournalLine."account type"::Customer, MemberNo, PostingDate, (sharesToPay), 'BOSA', '',
            'Dividend Capitalization  ' + Format(PostingDate), '');

            Dividends_Posting_Breakdown.ShareCapitalization := sharesToPay;

            // Reduce remaining dividend
            DividendAmount := DividendAmount - sharesToPay;
        end;



        Dividends_Posting_Breakdown."Processing Fee" := 50;// GenSetUp."Dividend Processing Fee"; WITHDRAWN MEMBERS CHARGED 50 BOB
        Dividends_Posting_Breakdown."Withholding Tax" := TotalWhtax;

        Dividends_Posting_Breakdown."Loan Arrears Recovered" := loanRecovered;
        Dividends_Posting_Breakdown."Net Paid to Wallets" := DividendAmount;

    end;

    procedure FnPostDividendstoWallet(MemberNo: Code[20]; PostingDate: Date; GrossTotalDiv: Decimal; TotalWhtax: Decimal; StartDate: Date)
    var
        DividendAmount: Decimal;
        smsText: Text[1000];
        loanRecovered: Decimal;
    begin
        //Declaration....
        smsText := '';
        DividendAmount := GrossTotalDiv;
        walletAccount := SFactory.FnGetFosaAccount(MemberNo);
        YearCalc := Format(Date2dmy(StartDate, 3));
        GenSetUp.Get();
        ExciseDuty := 0;
        ExciseDuty := (GenSetUp."Dividend Processing Fee" * (GenSetUp."Excise Duty(%)" / 100));

        ////### -- 1.1 CREDIT liability holding -GrossTotalDiv
        LineNo := LineNo + 10000;
        SFactory.FnCreateGnlJournalLine('PAYMENTS', 'DIVIDEND', 'DIV ' + Format(YearCalc), LineNo, GenJournalLine."transaction type"::Dividend,
        GenJournalLine."account type"::Customer, MemberNo, PostingDate, GrossTotalDiv * -1, 'BOSA', '',
        'Gross Dividend and Interest on Deposits - ' + Format(YearCalc), '');

        ////## --- 1.2 DEBIT DIVIDEND PAYABLE GL-2215 - GrossTotalDiv
        LineNo := LineNo + 10000;
        GenSetUp.Get();
        SFactory.FnCreateGnlJournalLine('PAYMENTS', 'DIVIDEND', 'DIV ' + Format(YearCalc), LineNo, GenJournalLine."transaction type"::" ",
        GenJournalLine."Account Type"::"G/L Account", GenSetUp."Dividend Payable Account", PostingDate, GrossTotalDiv, 'BOSA', '',
        'Gross Dividend and Interest on Deposits - ' + MemberNo, '');

        ///######## 3.1 CREDIT WTX GL ACC
        LineNo := LineNo + 10000;
        SFactory.FnCreateGnlJournalLine('PAYMENTS', 'DIVIDEND', 'DIV ' + Format(YearCalc), LineNo, GenJournalLine."transaction type"::" ",
        GenJournalLine."account type"::"G/L Account", GenSetUp."WithHolding Tax Account", PostingDate, (TotalWhtax) * -1, 'BOSA', '',
        'Witholding Tax on Dividend- ' + MemberNo, '');

        //########## 3.2 DEBIT Div Membe Acc ON WTX
        LineNo := LineNo + 10000;
        SFactory.FnCreateGnlJournalLine('PAYMENTS', 'DIVIDEND', 'DIV ' + Format(YearCalc), LineNo, GenJournalLine."transaction type"::Dividend,
        GenJournalLine."account type"::Customer, MemberNo, PostingDate, (TotalWhtax), 'BOSA', '',
        'Witholding Tax on Dividend- ' + YearCalc, '');
        DividendAmount := DividendAmount - TotalWhtax;


        //######## 4.1 DEBIT Member Number ON PROCESSSING FEE
        LineNo := LineNo + 10000;
        SFactory.FnCreateGnlJournalLine('PAYMENTS', 'DIVIDEND', 'DIV ' + Format(YearCalc), LineNo, GenJournalLine."transaction type"::Dividend,
        GenJournalLine."account type"::Customer, MemberNo, PostingDate, GenSetUp."Dividend Processing Fee", 'BOSA', '',
        'Bank Fee- ' + MemberNo, '');
        ///##### 4.2 CREDIT PROCESSING FEE GL ACC
        LineNo := LineNo + 10000;
        SFactory.FnCreateGnlJournalLine('PAYMENTS', 'DIVIDEND', 'DIV ' + Format(YearCalc), LineNo, GenJournalLine."transaction type"::" ",
        GenJournalLine."account type"::"G/L Account", GenSetUp."Dividend Process Fee Account", PostingDate, GenSetUp."Dividend Processing Fee" * -1, 'BOSA', '',
        'Bank Fee- ' + Format(PostingDate), '');
        DividendAmount := DividendAmount - GenSetUp."Dividend Processing Fee";

        // /////######## 2.1 CREDIT M-WALLET ACC
        // LineNo := LineNo + 10000;
        // SFactory.FnCreateGnlJournalLine('PAYMENTS', 'DIVIDEND', 'DIV ' + Format(YearCalc), LineNo, GenJournalLine."transaction type"::Dividend,
        // GenJournalLine."Account Type"::Vendor, walletAccount, PostingDate, (DividendAmount) * -1, 'BOSA', '',
        // 'Net Dividend and Interest on Deposits transfered to M-Wallet ' + Format(YearCalc), '');
        // //#########  2.2 DEBIT MEMBER DIVIDEND
        // LineNo := LineNo + 10000;
        // SFactory.FnCreateGnlJournalLine('PAYMENTS', 'DIVIDEND', 'DIV ' + Format(YearCalc), LineNo, GenJournalLine."transaction type"::Dividend,
        // GenJournalLine."account type"::Customer, MemberNo, PostingDate, (DividendAmount), 'BOSA', '',
        // 'Net Dividend and Interest on Deposits transfered to M-Wallet  ' + Format(PostingDate), '');




        Dividends_Posting_Breakdown."Processing Fee" := GenSetUp."Dividend Processing Fee";
        Dividends_Posting_Breakdown."Withholding Tax" := TotalWhtax;

        Dividends_Posting_Breakdown."Loan Arrears Recovered" := loanRecovered;
        Dividends_Posting_Breakdown."Net Paid to Wallets" := DividendAmount;

    end;

    procedure FnGetTheDivTotalPayable(MemberNo: Code[30]): Decimal
    var
        DivProgressionTable: Record "Dividends Progression";
        Amountss: Decimal;
    begin

        Amountss := 0;
        DivProgressionTable.Reset;
        DivProgressionTable.SetRange(DivProgressionTable."Member No", MemberNo);
        if DivProgressionTable.Find('-') then begin
            repeat
                Amountss += ROUND(DivProgressionTable."Net Dividends");
            //...........................
            until DivProgressionTable.Next = 0;
        end;
        exit(Amountss);
    end;


    procedure FnGetTheGrossDivPayable(MemberNo: Code[30]): Decimal
    var
        DivProgressionTable: Record "Dividends Progression";
        GrossDivAmount: Decimal;
    begin
        GrossTotalDiv := 0;
        DivProgressionTable.Reset;
        DivProgressionTable.SetRange(DivProgressionTable."Member No", MemberNo);
        if DivProgressionTable.Find('-') then begin
            repeat
                GrossTotalDiv += ROUND(DivProgressionTable."Gross Dividends" + DivProgressionTable."Gross Interest On Deposit");
            //...........................
            until DivProgressionTable.Next = 0;
        end;
        exit(GrossTotalDiv);
    end;

    procedure FnGetTheGrossDividends(MemberNo: Code[30]): Decimal
    var
        DivProgressionTable: Record "Dividends Progression";
        GrossDivAmount: Decimal;
    begin
        GrossTotalDiv := 0;
        DivProgressionTable.Reset;
        DivProgressionTable.SetRange(DivProgressionTable."Member No", MemberNo);
        if DivProgressionTable.Find('-') then begin
            repeat
                GrossTotalDiv += ROUND(DivProgressionTable."Gross Dividends");
            //...........................
            until DivProgressionTable.Next = 0;
        end;
        exit(GrossTotalDiv);
    end;

    procedure FnGetTheGrossDivOnSharesPayable(MemberNo: Code[30]): Decimal
    var
        DivProgressionTable: Record "Dividends Progression";
        GrossDivAmountOnShares: Decimal;
    begin
        GrossDivAmountOnShares := 0;
        DivProgressionTable.Reset;
        DivProgressionTable.SetRange(DivProgressionTable."Member No", MemberNo);
        if DivProgressionTable.Find('-') then begin
            repeat
                GrossDivAmountOnShares += ROUND(DivProgressionTable."Gross Dividends");
            //...........................
            until DivProgressionTable.Next = 0;
        end;
        exit(GrossDivAmountOnShares);
    end;


    procedure FnGetTotalWhtax(MemberNo: Code[30]): Decimal
    var
        DivProgressionTable: Record "Dividends Progression";
        TotalTax: Decimal;
    begin
        TotalTax := 0;
        DivProgressionTable.Reset;
        DivProgressionTable.SetRange(DivProgressionTable."Member No", MemberNo);
        if DivProgressionTable.Find('-') then begin
            repeat
                TotalTax += ROUND(DivProgressionTable."Witholding Tax");
            //...........................
            until DivProgressionTable.Next = 0;
        end;
        exit(TotalTax);
    end;


    procedure FnGetTheNetPayable(MemberNo: Code[30]): Decimal
    var
        DivProgressionTable: Record "Dividends Progression";
        TotalNetPay: Decimal;
    begin
        TotalNetPay := 0;
        DivProgressionTable.Reset;
        DivProgressionTable.SetRange(DivProgressionTable."Member No", MemberNo);
        if DivProgressionTable.Find('-') then begin
            repeat
                TotalNetPay += ROUND(DivProgressionTable."Gross Interest On Deposit") + ROUND(DivProgressionTable."Gross Dividends") - ROUND(DivProgressionTable."Witholding Tax");
            //...........................
            until DivProgressionTable.Next = 0;
        end;
        exit(TotalNetPay);
    end;


    procedure FnDontAccountForWithdrwnMemberInt()
    begin
    end;


    procedure FnAccountForWithdrwnMemberInt()
    begin
    end;
}








