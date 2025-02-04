#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Table 51372 "Loans Guarantee Details"
{
    DrillDownPageID = "Loans Guarantee Details";
    LookupPageID = "Loans Guarantee Details";

    fields
    {
        field(1; "Loan No"; Code[20])
        {
            NotBlank = true;
            TableRelation = "Loans Register"."Loan  No.";
        }
        field(2; "Member No"; Code[20])
        {
            NotBlank = false;
            TableRelation = Customer."No." where(Status = filter(Active | "Re-instated"));

            trigger OnValidate()
            var
                RefDate: Date;
            begin
                GenSetUp.Get();
                if Cust.Get("Member No") then begin
                    if Cust."Registration Date" <> 0D then
                        RefDate := CalcDate('<' + GenSetUp."Share Capital Period" + '>', Cust."Registration Date");
                    if RefDate > Today then begin
                        Error('Member has not finished 6 Months in the sacco and therefore cannot guarantee any loan!');
                    end;
                end;

                Cust.SetRange(Cust."No.", "Member No");
                if Cust.FindSet then begin
                    if Cust.Status <> Cust.Status::Active then begin
                        Error('Only Active Members can guarantee Loans');
                    end;
                end;

                /*ObjWithApp.RESET;
                ObjWithApp.SETRANGE(ObjWithApp."Member No.","Member No");
                IF ObjWithApp.FINDSET=TRUE THEN BEGIN
                 ERROR('The Member has a pending Withdrawal Application');
                 END;*/

                MemberCust.Reset;
                MemberCust.SetRange(MemberCust."No.", "Member No");
                if MemberCust.Find('-') then begin
                    if MemberCust.Status = MemberCust.Status::Defaulter then
                        Error('THE MEMBER  IS  A  DEFAULTER');
                end;


                LnGuarantor.Reset;
                LnGuarantor.SetRange(LnGuarantor."Loan  No.", "Loan No");
                if LnGuarantor.Find('-') then begin
                    if LnGuarantor."Client Code" = "Member No" then begin

                        "Self Guarantee" := true;
                        Self := true;
                        //MODIFY;
                    end;
                end;
                LoanGuarantors.SetRange(LoanGuarantors."Self Guarantee", true);
                LoanGuarantors.SetRange(LoanGuarantors."Member No", "Member No");
                SelfGuaranteedA := 0;
                Date := Date;

                LoanApps.Reset;
                LoanApps.SetRange(LoanApps."Client Code", "Member No");
                LoanApps.SetRange(LoanApps."Loan Product Type", 'SUKUMA');
                LoanApps.SetRange(LoanApps.Posted, true);
                if LoanApps.Find('-') then begin
                    repeat
                        LoanApps.CalcFields(LoanApps."Outstanding Balance");
                    until LoanApps.Next = 0;
                end;


                MemberCust.Reset;
                MemberCust.SetRange(MemberCust."No.", "Member No");
                if MemberCust.Find('-') then begin

                    MemberCust.CalcFields(MemberCust.TLoansGuaranteed, MemberCust."Current Savings");
                    "Shares *3" := (MemberCust."Current Savings");
                    "TotalLoan Guaranteed" := MemberCust.TLoansGuaranteed;
                end;

                if Cust.Get("Member No") then begin
                    Cust.CalcFields(Cust."Outstanding Balance", Cust."Current Shares", Cust.TLoansGuaranteed);
                    Name := Cust.Name;
                    "Staff/Payroll No." := Cust."Personal No";
                    "Loan Balance" := Cust."Outstanding Balance";
                    Shares := Cust."Current Shares" * 1;
                    Amont := 0;
                    //    IF Self THEN BEGIN
                    //      Amont:=Shares-SwizzsoftFactory.FnGetMemberLiability("Member No");
                    //    END ELSE BEGIN
                    //      SelfGuaranteeAmount:=SwizzsoftFactory.FnGetMemberSelfLiability("Member No");
                    //        IF SelfGuaranteeAmount<=0 THEN BEGIN
                    //          Amont:=Shares*3-SwizzsoftFactory.FnGetMemberLiability("Member No");
                    //          IF Amont>Shares THEN
                    //            Amont:=Shares;
                    //        END ELSE BEGIN
                    //          Amont:=Shares-SwizzsoftFactory.FnGetMemberLiability("Member No");
                    //          END;
                    //    END;
                    //    "Amont Guaranteed":="Amont Guaranteed";
                    //
                    //  "TotalLoan Guaranteed":=Cust.TLoansGuaranteed;
                    //  "Free Shares":=(Shares*3)-"TotalLoan Guaranteed";
                    //***********************************************************************************************
                    "Free Shares" := 0;
                    if "Self Guarantee" = true then begin
                        Amont := SwizzsoftFactory.FnGetMemberSelfLiability("Member No");
                        "TotalLoan Guaranteed" := Cust.TLoansGuaranteedS;
                        "Free Shares" := (Shares) - "TotalLoan Guaranteed";
                        // MESSAGE('Sharesis %1',Shares);

                        //MESSAGE('"Free Shares"is %1....| amont is %2  ',"Free Shares",Amont);

                        // MESSAGE('"Free Shares"is %1',"Free Shares");

                    end else begin
                        if "Self Guarantee" = false then
                            Message('deposi is %1', Shares);
                        Amont := Shares * 1 - SwizzsoftFactory.FnGetMemberLiability("Member No");
                        //MESSAGE('amont is %1',Amont);
                        "TotalLoan Guaranteed" := Cust.TLoansGuaranteed;
                        //MESSAGE('"TotalLoan Guaranteed" is %1', "TotalLoan Guaranteed");

                        "Free Shares" := (Shares * 1) - "TotalLoan Guaranteed";

                        // MESSAGE(' Free Shares is %1',"Free Shares");
                    end;
                    "Amont Guaranteed" := "Amont Guaranteed";
                    // IF "Self Guarantee" = TRUE  THEN BEGIN
                    //  "TotalLoan Guaranteed":=Cust.TLoansGuaranteedS;
                    //      "Free Shares":=(Shares)-"TotalLoan Guaranteed";
                    //
                    //   END ELSE
                    //    "TotalLoan Guaranteed":=Cust.TLoansGuaranteed;
                    //    "Free Shares":=(Shares*3)-"TotalLoan Guaranteed";
                end;
                //IF "Total Loans Guaranteed" > GenSetUp."Maximum No of Guarantees" THEN
                //ERROR('This member has guaranteed more than %1 loans therefore cannot guarantee any more loans',GenSetUp."Maximum No of Guarantees");
                if "Shares *3" < 1 then
                    Error('Member Must have Deposits');


            end;
        }
        field(3; Name; Text[200])
        {
            Editable = false;
        }
        field(4; "Loan Balance"; Decimal)
        {
            Editable = false;
        }
        field(5; Shares; Decimal)
        {
            Editable = false;
        }
        field(6; "No Of Loans Guaranteed"; Integer)
        {
            CalcFormula = count("Loans Guarantee Details" where("Member No" = field("Member No"),
                                                                 "Outstanding Balance" = filter(> 1)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(7; Substituted; Boolean)
        {

            trigger OnValidate()
            begin
                //TESTFIELD("Substituted Guarantor");
            end;
        }
        field(8; Date; Date)
        {
        }
        field(9; "Shares Recovery"; Boolean)
        {
        }
        field(10; "New Upload"; Boolean)
        {
        }
        field(11; "Amont Guaranteed"; Decimal)
        {

            trigger OnValidate()
            begin

                //*******************************************************************************SELF
                // LoanGuarantors.RESET;
                // LoanGuarantors.SETCURRENTKEY(LoanGuarantors."Member No");
                // LoanGuarantors.SETRANGE(LoanGuarantors."Member No","Member No");
                // LoanGuarantors.SETRANGE(LoanGuarantors."Application Statu",TRUE);
                // LoanGuarantors.SETRANGE(LoanGuarantors."Self Guarantee",TRUE);
                // IF LoanGuarantors.FIND('-') THEN BEGIN
                // REPEAT
                //
                // MAmounttoG:=MAmounttoG+LoanGuarantors."Amont Guaranteed";
                //  MDeposit:=MAmounttoG;
                // UNTIL LoanGuarantors.NEXT=0;
                // END;


                //*************************************************************************
                MAmounttoG := 0;
                LoanGuarantors.Reset;
                LoanGuarantors.SetCurrentkey(LoanGuarantors."Member No");
                LoanGuarantors.SetRange(LoanGuarantors."Member No", "Member No");
                LoanGuarantors.SetRange(LoanGuarantors."Application Statu", true);
                //LoanGuarantors.SETRANGE(LoanGuarantors."Self Guarantee",FALSE);

                if LoanGuarantors.Find('-') then begin
                    repeat
                        /// MESSAGE('loan is %1',LoanGuarantors."Amont Guaranteed");

                        MAmounttoG := MAmounttoG + LoanGuarantors."Amont Guaranteed";
                        MDeposit := MAmounttoG;
                    until LoanGuarantors.Next = 0;
                end;
                ///END;
                Message('Amount Guarantee is Still In Application Process %1', MDeposit);


                //*********************************************************************

                MemberLedgerEntry.Reset;
                MemberLedgerEntry.SetRange(MemberLedgerEntry."Loan No", "Loan No");
                MemberLedgerEntry.SetRange(Reversed, false);
                if MemberLedgerEntry.Find() = false then
                    "Original Amount" := "Amont Guaranteed";
                //**********************************************************************************************88

                AmountGuar := 0;
                AmountGuarT := 0;
                LoanGuarantors.Reset;
                LoanGuarantors.SetRange(LoanGuarantors."Member No", "Member No");
                if LoanGuarantors.FindSet then begin
                    repeat
                        // MESSAGE(FORMAT(LoanGuarantors."Amont Guaranteed"));
                        AmountGuar := LoanGuarantors."Amont Guaranteed";
                    //AmountGuarT:=AmountGuar;

                    until LoanGuarantors.Next = 0;
                    //MESSAGE ('AmountGuar is 1%',AmountGuarT);
                end;
                //MESSAGE ('AmountGuar is 1%',AmountGuar);


                ///***********************************************88




                SharesVariance := 0;
                LoanGuarantors.Reset;
                LoanGuarantors.SetRange(LoanGuarantors."Member No", "Member No");
                if LoanGuarantors.Find('-') then begin

                    repeat
                        LoanGuarantors.CalcFields(LoanGuarantors."Outstanding Balance");
                        if LoanGuarantors."Outstanding Balance" > 0 then begin
                            Totals := Totals + LoanGuarantors."Amont Guaranteed";
                            //MESSAGE('AmountGuar Totals is %1',Totals);
                        end;
                    until LoanGuarantors.Next = 0;
                end;


                //"Free Shares":=(Shares*3)-"TotalLoan Guaranteed";

                //**************************************************************************************************SEPH

                //**************************************************************************************************SEPH


                //  IF Cust.GET("Member No") THEN BEGIN
                //  Cust.CALCFIELDS(Cust."Outstanding Balance",Cust."Current Shares",Cust.TLoansGuaranteed);
                //  Shares:=Cust."Current Shares"*1;
                //  Amont:=0;
                //    IF "Self Guarantee" THEN BEGIN
                //      Amont:=Shares-SwizzsoftFactory.FnGetMemberLiability("Member No");
                //      "Free Shares":=Shares-SwizzsoftFactory.FnGetMemberLiability("Member No");
                //           MESSAGE('"Free Shares" is %1',"Free Shares");
                //
                //    END ELSE BEGIN
                //
                //
                //
                //      SelfGuaranteeAmount:=SwizzsoftFactory.FnGetMemberSelfLiability("Member No");
                //     MESSAGE('sef is %1',SelfGuaranteeAmount);
                //
                //        IF SelfGuaranteeAmount<=0 THEN BEGIN
                //
                //          Amont:=Shares*3-SwizzsoftFactory.FnGetMemberLiability("Member No");
                //          IF Amont>Shares THEN
                //
                //            Amont:=Shares;
                //          "Free Shares":=(Shares*3)-SwizzsoftFactory.FnGetMemberLiability("Member No");
                //        END ELSE BEGIN
                //          Amont:=Shares-SwizzsoftFactory.FnGetMemberLiability("Member No");
                //          "Free Shares":=Shares-SwizzsoftFactory.FnGetMemberLiability("Member No");
                //          END;
                //
                //    END;
                // IF "Self Guarantee" = TRUE THEN BEGIN
                //    IF "Amont Guaranteed">Amont THEN
                //      ERROR('Amount guaranteed cannot exceed '+FORMAT(Amont));
                // END ELSE BEGIN
                //    IF "Amont Guaranteed">Amont THEN
                //      MESSAGE('Amount guaranteed cannot exceed '+FORMAT(Amont));
                //   END;
                //   END;
                //MESSAGE('here');
                if Cust.Get("Member No") then begin
                    Cust.CalcFields(Cust."Outstanding Balance", Cust."Current Shares", Cust.TLoansGuaranteed);
                    Shares := Cust."Current Shares" * 1;
                    Amont := 0;
                    // // // // // // //    IF "Self Guarantee" = TRUE THEN BEGIN
                    // // // // // // //    //  MESSAGE('2here');
                    // // // // // // //    //  MESSAGE (FORMAT(Shares));
                    // // // // // // //      Amont:=Shares-SwizzsoftFactory.FnGetMemberSelfLiability("Member No");
                    // // // // // // //     // MESSAGE('3here');
                    // // // // // // //
                    // // // // // // //      "Free Shares":=Shares-SwizzsoftFactory.FnGetMemberSelfLiability("Member No");
                    // // // // // // //           //MESSAGE('"Free Shares11" is %1',"Free Shares");
                    // // // // // // //
                    // // // // // // //    END ELSE BEGIN
                    // // // // // // //                MemberLiability:=SwizzsoftFactory.FnGetMemberLiability("Member No");
                    // // // // // // //                 "Free Shares":=(Shares*1)-SwizzsoftFactory.FnGetMemberLiability("Member No");
                    // // // // // // //
                    // // // // // // //                 Amont:=Shares*1-SwizzsoftFactory.FnGetMemberLiability("Member No");
                    // // // // // // //               IF MemberLiability>Shares THEN
                    // // // // // // //                 ERROR('You do not have enough Deposits to Guarantee');
                    // // // // // // //
                    // // // // // // //
                    // // // // // // // END;


                end;
                if "Self Guarantee" = true then begin
                    LoanApp.Reset;
                    LoanApp.SetRange("Loan  No.", "Loan No");
                    if LoanApp.Find('-') then
                        LoanApp.CalcFields("Self GuarantorShip Liability");
                    Message('amount mj is %1', LoanApp."Self GuarantorShip Liability");
                    if LoanApp."Is Top Up" = true then
                        Amont := LoanApp."Self GuarantorShip Liability"

                    else
                        Amont := Shares - SwizzsoftFactory.FnGetMemberLiability("Member No");
                end else begin
                    if "Self Guarantee" = false then
                        MemberLiability := SwizzsoftFactory.FnGetMemberLiability("Member No");
                    "Free Shares" := (Shares) - SwizzsoftFactory.FnGetMemberLiability("Member No");
                    Amont := Shares - SwizzsoftFactory.FnGetMemberLiability("Member No");
                end;


                // MESSAGE('shares Are %1| Free Shares Are %2',Shares,"Free Shares");

                "free Share" := Amont;
                //MESSAGE('amount is %1',Amont);

                // MESSAGE('MAmounttoG is %1',MAmounttoG);

                vardiff := (Amont - MAmounttoG);
                Message(Format(Amont));


                if "Self Guarantee" = true then begin
                    if "Amont Guaranteed" >= Amont then
                        Error('Amount guaranteed cannot exceed ' + Format(vardiff));
                end else begin
                    vardiff := (Amont - MAmounttoG);
                    Message(Format(vardiff));
                    if "Amont Guaranteed" >= vardiff then
                        Error('Amount guaranteed cannot exceed ' + Format(vardiff));
                end;
            end;
        }
        field(12; "Staff/Payroll No."; Code[20])
        {

            trigger OnValidate()
            begin
                Cust.Reset;
                Cust.SetRange(Cust."Personal No", "Staff/Payroll No.");
                if Cust.Find('-') then begin
                    "Member No" := Cust."No.";
                    Validate("Member No");
                end
                else
                    "Member No" := '';//ERROR('Record not found.')
            end;
        }
        field(13; "Account No."; Code[20])
        {
        }
        field(14; "Self Guarantee"; Boolean)
        {
        }
        field(15; "ID No."; Code[70])
        {
        }
        field(16; "Outstanding Balance"; Decimal)
        {
            CalcFormula = sum("Cust. Ledger Entry"."Amount Posted" where("Transaction Type" = filter(Loan | "Loan Repayment"),
                                                                  "Loan No" = field("Loan No")));
            FieldClass = FlowField;
        }
        field(41; "Transferable shares"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(17; "Total Loans Guaranteed"; Decimal)
        {
            CalcFormula = sum("Loans Guarantee Details"."Original Amount" where("Loan No" = field("Loan No"),
                                                                                 Substituted = const(false)));
            FieldClass = FlowField;
        }
        field(18; "Loans Outstanding"; Decimal)
        {
            CalcFormula = sum("Cust. Ledger Entry"."Amount Posted" where("Transaction Type" = filter(Loan | "Loan Repayment"),
                                                                  "Loan No" = field("Loan No")));
            FieldClass = FlowField;

            trigger OnValidate()
            begin
                /*"Total Loans Guaranteed":="Outstanding Balance";
                MODIFY;
                */

            end;
        }
        field(19; "Guarantor Outstanding"; Decimal)
        {
            CalcFormula = sum("Cust. Ledger Entry"."Amount Posted" where("Customer No." = field("Member No"),
                                                                  "Transaction Type" = filter(Loan | "Loan Repayment")));
            FieldClass = FlowField;
        }
        field(20; "Employer Code"; Code[20])
        {
            TableRelation = Customer."No.";
        }
        field(21; "Employer Name"; Text[100])
        {
        }
        field(22; "Substituted Guarantor"; Code[80])
        {
            TableRelation = Customer."No.";

            trigger OnValidate()
            begin
                GenSetUp.Get();
                if LoansG > GenSetUp."Maximum No of Guarantees" then begin
                    Error('Member has guaranteed more than maximum active loans and  can not Guarantee any other Loans');
                    "Member No" := '';
                    "Staff/Payroll No." := '';
                    Name := '';
                    "Loan Balance" := 0;
                    Date := 0D;
                    exit;
                end;


                Loans.Reset;
                Loans.SetRange(Loans."Client Code", "Member No");
                if Loans.Find('-') then begin
                    if LoanGuarantors."Self Guarantee" = true then
                        Error('This Member has Self Guaranteed and Can not Guarantee another Loan');
                end;
            end;
        }
        field(23; "Loanees  No"; Code[30])
        {
            CalcFormula = lookup("Loans Register"."Client Code" where("Loan  No." = field("Loan No")));
            FieldClass = FlowField;
        }
        field(24; "Loanees  Name"; Text[80])
        {
            CalcFormula = lookup("Loans Register"."Client Name" where("Loan  No." = field("Loan No")));
            FieldClass = FlowField;
        }
        field(25; "Loan Product"; Code[20])
        {
            CalcFormula = lookup("Loans Register"."Loan Product Type" where("Loan  No." = field("Loan No")));
            FieldClass = FlowField;
        }
        field(26; "Entry No."; Integer)
        {
        }
        field(27; "Loan Application Date"; Date)
        {
            CalcFormula = lookup("Loans Register"."Application Date" where("Loan  No." = field("Loan No")));
            FieldClass = FlowField;
        }
        field(28; "Free Shares"; Decimal)
        {
        }
        field(29; "Line No"; Integer)
        {
        }
        field(30; "Member Cell"; Code[10])
        {
        }
        field(31; "Share capital"; Decimal)
        {
        }
        field(32; "TotalLoan Guaranteed"; Decimal)
        {
            Description = '`';
        }
        field(33; Totals; Decimal)
        {
        }
        field(34; "Shares *3"; Decimal)
        {
        }
        field(35; "Deposits variance"; Decimal)
        {
        }
        field(36; "Defaulter Loan Installments"; Code[10])
        {
        }
        field(37; "Defaulter Loan Repayment"; Decimal)
        {
        }
        field(38; "Exempt Defaulter Loan"; Boolean)
        {
        }
        field(39; "Additional Defaulter Amount"; Decimal)
        {
        }
        field(40; "Total Guaranteed"; Decimal)
        {
            CalcFormula = sum("Loans Guarantee Details"."Loan Balance" where("Loan No" = field("Loan No"),
                                                                              Substituted = filter(false)));
            Description = '//>Sum total guaranteed amount for each loan';
            FieldClass = FlowField;
        }
        field(69161; "Total Committed Shares"; Decimal)
        {
            CalcFormula = sum("Loans Guarantee Details"."Amont Guaranteed" where("Member No" = field("Member No")));
            FieldClass = FlowField;
        }
        field(69162; "Oustanding Interest"; Decimal)
        {
            CalcFormula = sum("Cust. Ledger Entry"."Amount Posted" where("Customer No." = field("Member No"),
                                                                  "Transaction Type" = filter("Interest Paid"),
                                                                  "Loan No" = field("Loan No")));
            FieldClass = FlowField;
        }
        field(69163; "Guar Sub Doc No."; Code[20])
        {
        }
        field(69164; "Committed Shares"; Decimal)
        {
        }
        field(69165; "Substituted Guarantor Name"; Text[30])
        {
        }
        field(69166; "Member Liability"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(69167; "Original Amount"; Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                //  CALCFIELDS("Outstanding Balance","Total Loans Guaranteed");
                //  IF "Total Loans Guaranteed">0 THEN
                //  "Amont Guaranteed":=ROUND((("Original Amount"/"Total Loans Guaranteed")*("Outstanding Balance")),1,'=');
                //  MODIFY();
            end;
        }
        field(69168; LoanCount; Integer)
        {
            CalcFormula = count("Loans Guarantee Details" where("Loanees  No" = field("Loanees  No"),
                                                                 "Loan No" = field("Loan No")));
            FieldClass = FlowField;
        }
        field(69169; "Application Statu"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(69170; "free Share"; Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                "free Share" := Amont;
            end;
        }
        field(69171; Posted; Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Loan No", "Staff/Payroll No.", "Member No", "Entry No.")
        {
        }
        key(Key2; "Loan No", "Member No")
        {
            Clustered = true;
            SumIndexFields = Shares;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        "Application Statu" := true;
    end;

    var
        AmountGuarT: Decimal;
        MDeposit: Decimal;
        MAmounttoG: Decimal;
        MLoanReg: Record "Loans Register";
        Cust: Record Customer;
        LoanGuarantors: Record "Loans Guarantee Details";
        Loans: Record "Loans Register";
        LoansR: Record "Loans Register";
        LoansG: Integer;
        GenSetUp: Record "Sacco General Set-Up";
        SelfGuaranteedA: Decimal;
        StatusPermissions: Record "Status Change Permision";
        Employer: Record "Sacco Employers";
        loanG: Record "Loans Guarantee Details";
        CustomerRecord: Record Customer;
        MemberSaccoAge: Date;
        ComittedShares: Decimal;
        LoanApp: Record "Loans Register";
        DefaultInfo: Text;
        ok: Boolean;
        SharesVariance: Decimal;
        MemberCust: Record Customer;
        LnGuarantor: Record "Loans Register";
        LoanApps: Record "Loans Register";
        Text0001: label 'This Member has an Outstanding Defaulter Loan which has never been serviced';
        freeshares: Decimal;
        loanrec: Record "Loans Guarantee Details";
        ObjWithApp: Record "Membership Exit";
        SwizzsoftFactory: Codeunit "Swizzsoft Factory.";
        Self: Boolean;
        SelfGuaranteeAmount: Decimal;
        Amont: Decimal;
        MemberLedgerEntry: Record "Cust. Ledger Entry";
        AmountGuar: Decimal;
        vardiff: Decimal;
        MemberLiability: Decimal;

    local procedure UPDATEG()
    begin
    end;
}

