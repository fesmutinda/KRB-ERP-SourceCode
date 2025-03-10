#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Table 51376 "Loan Offset Details"
{
    DrillDownPageID = "Loan Offset Detail List";
    LookupPageID = "Loan Offset Detail List";

    fields
    {
        field(1; "Loan No."; Code[20])
        {
            TableRelation = "Loans Register"."Loan  No.";

            trigger OnValidate()
            begin
                // LoanApp.Reset();
                // LoanApp.SetRange(LoanApp."Loan  No.", "Loan No.");
                // if (LoanApp.Find('-')) then begin
                //     Commision := ROUND(((LoanApp."Requested Amount") * GenSetUp."Loan Top Up Commision(%)" / 100), 1, '=');
                // end else begin
                //     Error('Please enter Requested Amount before selecting a Loan to Refinance.');
                // end;
            end;
        }
        field(2; "Loan Top Up"; Code[20])
        {
            TableRelation = "Loans Register"."Loan  No." where("Client Code" = field("Client Code"),
                                                                Posted = const(true),
                                                                "Outstanding Balance" = filter(> 0));

            trigger OnValidate()
            var
                Amtt: Decimal;
            begin
                if Confirm('Are you sure you want to offset this loan?', true) = true then begin

                    "Loan Type" := '';
                    "Principle Top Up" := 0;
                    "Interest Top Up" := 0;
                    "Total Top Up" := 0;

                    ObjRepaymentSchedule.Reset;
                    ObjRepaymentSchedule.SetRange("Loan No.", "Loan Top Up");
                    ObjRepaymentSchedule.SetFilter("Repayment Date", '>%1', Today);
                    if ObjRepaymentSchedule.Find('-') then
                        "Remaining Installments" := ObjRepaymentSchedule.Count;

                    ObjRepaymentSchedule.Reset;
                    ObjRepaymentSchedule.SetRange("Loan No.", "Loan Top Up");
                    ObjRepaymentSchedule.SetFilter("Repayment Date", '<=%1', Today);
                    if ObjRepaymentSchedule.Find('-') then
                        "Loan Age" := ObjRepaymentSchedule.Count;

                    Loans.Reset;
                    Loans.SetRange(Loans."Loan  No.", "Loan No.");
                    if Loans.Find('-') then begin
                        ApplicationDate := Loans."Application Date";
                        RequstedAmount := Loans."Requested Amount";
                        if (Loans."Requested Amount" > 0) then begin
                            // Message('Calculating commision');
                            if GenSetUp."Loan Top Up Commision(%)" > 0 then begin

                                Commision := ROUND(((Loans."Requested Amount") * GenSetUp."Loan Top Up Commision(%)" / 100), 1, '=');
                                // Message('Requested Amount : ' + Format(Loans."Requested Amount"));
                                // Message('Percentage commision is :' + Format(GenSetUp."Loan Top Up Commision(%)"));
                                // Message('Commision here is :' + Format(Commision));
                            end else begin
                                Commision := ROUND(((Loans."Requested Amount") * 0.5 / 100), 1, '=');
                                // Message('New Commision here is :' + Format(Commision));
                            end;
                        end else begin
                            Error('Please enter Requested Amount before selecting a Loan to Refinance.');
                        end;
                    end;
                    Loans.Reset;
                    Loans.SetRange(Loans."Loan  No.", "Loan Top Up");
                    if Loans.Find('-') then begin
                        Loans.CalcFields(Loans."Outstanding Balance", Loans."Interest Due", Loans."Oustanding Interest");

                        if Cust.Get(Loans."Client Code") then begin
                            "ID. NO" := Cust."ID No.";
                            "Staff No" := Cust."Payroll/Staff No";
                        end;
                        "Interest Rate" := Loans.Interest;

                        "Interest Due at Clearance" := ((0.01 * Loans."Approved Amount" + 0.01 * Loans."Outstanding Balance") * Loans.Interest / 12 * ("Loan Age")) / 2 - "Interest Paid";
                        // "Interest Top Up":=((0.01*Loans."Approved Amount"+0.01*Loans."Outstanding Balance")*Loans.Interest/12*("Loan Age"+1))/2-"Interest Paid"; //Nafaka Formula
                        if (Date2dmy(ApplicationDate, 1) > 15) then begin
                            "Interest Due at Clearance" := ((0.01 * Loans."Approved Amount" + 0.01 * Loans."Outstanding Balance") * Loans.Interest / 12 * ("Loan Age" + 1)) / 2 - "Interest Paid";
                            //"Interest Top Up":=((0.01*Loans."Approved Amount"+0.01*Loans."Outstanding Balance")*Loans.Interest/12*("Loan Age"+1))/2-"Interest Paid"; //Nafaka Formula
                        end;
                        "Principle Top Up" := Loans."Outstanding Balance";
                        "Interest Top Up" := Loans."Oustanding Interest";
                        //joel//Commision:=Loans."Outstanding Balance"*0.1;
                        "Total Top Up" := "Principle Top Up" + "Interest Top Up" + Commision;
                        "Outstanding Balance" := Loans."Outstanding Balance";
                        "Monthly Repayment" := Loans.Repayment;
                    end;
                    Loans.Bridged := true;
                    Loans.Modify
                end;
            end;
        }
        field(3; "Client Code"; Code[20])
        {
        }
        field(4; "Loan Type"; Code[30])
        {
        }
        field(5; "Principle Top Up"; Decimal)
        {

            trigger OnValidate()
            begin
                //IF Loantypes.GET("Loan Type") THEN BEGIN
                //"Interest Top Up":="Principle Top Up"*(Loantypes."Interest rate"/100);
                //END;

                //"Interest Top Up":="Principle Top Up"*(1.75/100);


                // Loans.RESET;
                // Loans.SETRANGE(Loans."Loan  No.","Loan Top Up");
                // IF Loans.FIND('-') THEN BEGIN
                // Loans.CALCFIELDS(Loans."Outstanding Balance");
                // IF "Principle Top Up" > Loans."Outstanding Balance" THEN
                //    ERROR(Text00,"Loan Top Up");
                // // "Interest Top Up":="Principle Top Up"*(Loans.Interest/100);
                // END;
                //
                // IF "Principle Top Up" > Loans."Requested Amount" THEN
                //    ERROR(Text001,"Loan No.");
                // //"Interest Top Up":="Principle Top Up"*(Loans.Interest/100);
                // //END;


                // IF  Commision < 500 THEN BEGIN
                // Commision:=500
                // END ELSE BEGIN
                // Commision:=ROUND(("Principle Top Up"+"Interest Top Up")*(GenSetUp."Top up Commission"/100),1,'>');
                //
                // END;

                //Comission re-calculation
                Loans.Reset;
                Loans.SetRange(Loans."Loan  No.", "Loan Top Up");
                if Loans.Find('-') then begin
                    Loans.CalcFields(Loans."Outstanding Balance", Loans."Interest Due", Loans."Oustanding Interest");
                    if ObjLoans.Get("Loan No.") then begin

                        if ObjLoans.Bridging then begin
                            GenSetUp.Get();
                            Loans.CalcFields("Outstanding Balance");
                            //IF Loans."Outstanding Balance"<(Loans."Amount Disbursed") THEN BEGIN
                            // Commision:=ROUND(GenSetUp."Loan Top Up Commision(%)"*Loans."Outstanding Balance"/100,1,'>');
                            //END ELSE BEGIN
                            // Commision:=ROUND(GenSetUp."Loan Top Up Commision2(%)"*"Principle Top Up"/100,1,'>');
                        end;
                        "Loan Type" := Loans."Loan Product Type";
                        ObjLoans.Modify;
                    end;

                    /*s
                      IF ObjLoans.Consolidation THEN BEGIN
                            GenSetUp.GET();
                            Loans.CALCFIELDS("Outstanding Balance");
                              IF Loans."Outstanding Balance">0 THEN BEGIN
                                Commision:=ROUND(GenSetUp."Consolidation Commission(%)"*"Principle Top Up"/100,1,'>');
                                "Loan Type":=Loans."Loan Product Type";
                              END;
                            ObjLoans.MODIFY;
                      END;*/
                end;
                //END;
                "Total Top Up" := "Principle Top Up" + "Interest Top Up";

            end;
        }
        field(6; "Interest Top Up"; Decimal)
        {

            trigger OnValidate()
            begin
                /*"Total Top Up":="Principle Top Up" +"Interest Top Up";
                
                Loans.RESET;
                Loans.SETRANGE(Loans."Loan  No.","Loan Top Up");
                IF Loans.FIND('-') THEN BEGIN
                Loans.CALCFIELDS(Loans."Interest Due");
                IF "Principle Top Up" < Loans."Outstanding Balance" THEN
                ERROR('Amount cannot be greater than the interest due.');
                
                END;
                */
                GenSetUp.Get();
                //Commision:=ROUND(("Principle Top Up"+"Interest Top Up")*(GenSetUp."Top up Commission"/100),1,'>');
                "Total Top Up" := ROUND(("Principle Top Up" + "Interest Top Up"), 1, '=');
                ;
                //Commision:=ROUND(("Principle Top Up"+"Interest Top Up")*(GenSetUp."Top up Commission"/100),1,'>');

                // IF  Commision < 500 THEN BEGIN
                // Commision:=500
                // END ELSE BEGIN
                // Commision:=ROUND(("Principle Top Up"+"Interest Top Up")*(GenSetUp."Top up Commission"/100),1,'>');
                //
                // END;
                // Commision:=Loans."Outstanding Balance"*0.1;

            end;
        }
        field(7; "Total Top Up"; Decimal)
        {
        }
        field(8; "Monthly Repayment"; Decimal)
        {
        }
        field(9; "Interest Paid"; Decimal)
        {
            CalcFormula = - sum("Cust. Ledger Entry"."Amount Posted" where("Customer No." = field("Client Code"),
                                                                   "Loan No" = field("Loan Top Up"),
                                                                   "Transaction Type" = filter("Interest Paid")));
            FieldClass = FlowField;
        }
        field(10; "Outstanding Balance"; Decimal)
        {
            FieldClass = Normal;
        }
        field(11; "Interest Rate"; Decimal)
        {
            CalcFormula = sum("Loans Register".Interest where("Loan  No." = field("Loan Top Up"),
                                                               "Client Code" = field("Client Code")));
            FieldClass = FlowField;
        }
        field(12; "ID. NO"; Code[20])
        {
        }
        field(13; Commision; Decimal)
        {

            trigger OnValidate()
            begin
                // "Total Top Up":="Principle Top Up" +"Interest Top Up";
                // Commision := 0;
                GenSetUp.Get;
                "Total Top Up" := "Principle Top Up" + "Interest Top Up" + Commision;
                // Commision := ROUND(((Loans."Requested Amount") * GenSetUp."Loan Top Up Commision(%)" / 100), 1, '=');
            end;
        }
        field(14; "Partial Bridged"; Boolean)
        {

            trigger OnValidate()
            begin

                LoansTop.Reset;
                LoansTop.SetRange(LoansTop."Loan  No.", "Loan Top Up");
                if LoansTop.Find('-') then begin
                    if "Partial Bridged" = true then
                        LoansTop."partially Bridged" := true;
                    LoansTop.Modify;
                end;
            end;
        }
        field(15; "Remaining Installments"; Decimal)
        {
        }
        field(16; "Finale Instalment"; Decimal)
        {
        }
        field(17; "Penalty Charged"; Decimal)
        {

            trigger OnValidate()
            begin
                //0.1*"Principle Top Up";
            end;
        }
        field(18; "Staff No"; Code[20])
        {
        }
        field(19; "Commissioning Balance"; Decimal)
        {

            trigger OnValidate()
            begin
                // GenSetUp.GET();
                // //Commision:=ROUND(("Commissioning Balance")*(GenSetUp."Top up Commission"/100),1,'>');
                // Commision:=ROUND(GenSetUp."Loan Top Up Commision(%)"*(ObjLoans."Recommended Amount"-Loans."Outstanding Balance")/100,1,'>');//ADDED BY Festus
                // "Total Top Up":="Principle Top Up" +"Interest Top Up";
            end;
        }
        field(20; "Interest Due at Clearance"; Decimal)
        {
        }
        field(21; "Loan Age"; Integer)
        {
        }
        field(22; "BOSA No"; Code[50])
        {
        }
        field(23; "50% of Initial Loan"; Decimal)
        {
        }
        field(24; "FOSA Account"; Code[30])
        {
            TableRelation = Vendor."No." where("BOSA Account No" = field("Client Code"));
        }
        field(25; "Loan Offset From FOSA"; Boolean)
        {
        }
        field(26; "Loan Offset From FOSA Date"; Date)
        {
        }
        field(27; "Loan Offset From FOSA By"; Code[30])
        {
        }
        field(28; "Additional Top Up Commission"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Loan No.", "Client Code", "Loan Top Up")
        {
            Clustered = true;
            SumIndexFields = "Total Top Up", "Principle Top Up";
        }
        key(Key2; "Principle Top Up")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Client Code", "Loan Type", "Principle Top Up", "Interest Top Up", "Total Top Up", "Monthly Repayment", "Interest Paid", "Outstanding Balance", "Interest Rate", Commision)
        {
        }
    }

    var
        Loans: Record "Loans Register";
        Loantypes: Record "Loan Products Setup";
        Interest: Decimal;
        Cust: Record Customer;
        LoansTop: Record "Loans Register";
        GenSetUp: Record "Sacco General Set-Up";
        ObjRepaymentSchedule: Record "Loan Repayment Schedule";
        ApplicationDate: Date;
        ObjLoans: Record "Loans Register";
        ObjLoanType: Record "Loan Products Setup";
        MinAmountforOffset: Decimal;
        LoanBal: Decimal;
        Text00: label 'Amount cannot be greater than the loan oustanding balance for%1.';
        Text001: label 'Amount cannot be greater than the loan oustanding balance for %1';
        LoanApp: Record "Loans Register";
        Loanbalance: Decimal;
        Commision1: Decimal;
        RequstedAmount: Decimal;
}

