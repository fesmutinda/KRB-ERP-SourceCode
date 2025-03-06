table 59050 "KRB Checkoff Header"
{

    fields
    {
        field(1; No; Code[20])
        {

            trigger OnValidate()
            begin
                if No = '' then begin
                    NoSetup.Get();
                    NoSetup.TestField(NoSetup."Bosa Transaction Nos");
                    NoSeriesMgt.InitSeries(NoSetup."Bosa Transaction Nos", xRec."No. Series", 0D, No, "No. Series");
                end;
            end;
        }
        field(2; "No. Series"; Code[20])
        {
        }
        field(3; Posted; Boolean)
        {
            Editable = false;
        }
        field(6; "Posted By"; Code[60])
        {
            Editable = false;
        }
        field(7; "Date Entered"; Date)
        {
        }
        field(9; "Entered By"; Text[60])
        {
        }
        field(10; Remarks; Text[150])
        {
        }
        field(19; "Date Filter"; Date)
        {
            FieldClass = FlowFilter;
        }
        field(20; "Time Entered"; Time)
        {
        }
        field(21; "Posting date"; Date)
        {
        }
        field(22; "Account Type"; Option)
        {

            OptionMembers = ,Customer,"G/L Account";//Vendor,"Bank Account","Fixed Asset";
        }
        field(23; "Account No"; Code[30])
        {
            TableRelation = if ("Account Type" = const("G/L Account")) "G/L Account"
            else
            if ("Account Type" = const(Customer)) Customer where("Customer Type" = filter(Checkoff));


            trigger OnValidate()
            begin
                if "Account Type" = "account type"::Customer then begin
                    cust.Reset;
                    cust.SetRange(cust."No.", "Account No");
                    cust.SetFilter(cust."Customer Type", '%1', cust."Customer Type"::Checkoff);
                    if cust.Find('-') then begin
                        "Employer Name" := cust."Employer Name";
                        "Employer Code" := cust."Employer Code";


                    end;
                end;

                if "Account Type" = "account type"::"G/L Account" then begin
                    "GL Account".Reset;
                    "GL Account".SetRange("GL Account"."No.", "Account No");
                    if "GL Account".Find('-') then begin
                        "Account Name" := "GL Account".Name;
                    end;
                end;

                // if "Account Type" = "account type"::"Bank Account" then begin
                //     BANKACC.Reset;
                //     BANKACC.SetRange(BANKACC."No.", "Account No");
                //     if BANKACC.Find('-') then begin
                //         "Account Name" := BANKACC.Name;

                //     end;
                // end;
            end;
        }
        field(24; "Document No"; Code[20])
        {
        }
        field(25; Amount; Decimal)
        {

            trigger OnValidate()
            begin
                /*
              IF Amount<>"Scheduled Amount" THEN
              ERROR('The Amount must be equal to the Scheduled Amount');
                  */

            end;
        }
        field(26; "Scheduled Amount"; Decimal)
        {
            CalcFormula = sum("KRB CheckoffLines"."Co-op - Shares" where("Receipt Header No" = field(No)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(27; "Total Count"; Integer)
        {
            CalcFormula = count("KRB CheckoffLines" where("Receipt Header No" = field(No)));
            FieldClass = FlowField;
        }
        field(28; "Account Name"; Code[50])
        {
        }
        field(29; "Employer Code"; Code[30])
        {
            //TableRelation = "Sacco Employers".Code;
        }
        field(30; "Un Allocated amount-surplus"; Decimal)
        {
        }
        field(31; "Employer Name"; Text[100])
        {
        }
        field(32; "Loan CutOff Date"; Date)
        {
        }
        field(50; "Total Amount"; Decimal)
        {

            Editable = false;
            // FieldClass = FlowField;
        }

    }

    keys
    {
        key(Key1; No)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        if Posted = true then
            Error('You cannot delete a Posted Check Off');
    end;

    trigger OnInsert()
    begin

        if No = '' then begin
            NoSetup.Get();
            NoSetup.TestField(NoSetup."Bosa Transaction Nos");
            NoSeriesMgt.InitSeries(NoSetup."Bosa Transaction Nos", xRec."No. Series", 0D, No, "No. Series");
        end;

        "Date Entered" := Today;
        "Time Entered" := Time;
        "Entered By" := UpperCase(UserId);

    end;

    trigger OnModify()
    begin
        UpdateTotalAmount();
    end;

    trigger OnRename()
    begin
        if Posted = true then
            Error('You cannot rename a Posted Check Off');
    end;

    procedure UpdateTotalAmount()
    var
        Total: Decimal;
        KRBCheckoffLines: Record "KRB CheckoffLines";
    begin
        Total := 0;
        KRBCheckoffLines.SetRange("Receipt Header No", No);

        if KRBCheckoffLines.FindSet() then
            repeat
                Total += KRBCheckoffLines."Co-op - Shares" +
                         KRBCheckoffLines."Co-op - Devt Loan" +
                         KRBCheckoffLines.Flexi +
                         KRBCheckoffLines."Muslim Loan" +
                         KRBCheckoffLines."Co-op Emergency Loan" +
                         KRBCheckoffLines."Co-op - Investment Loan" +
                         KRBCheckoffLines."Co-op School Fees Loan" +
                         KRBCheckoffLines.Instant +
                         KRBCheckoffLines."Childrens Savings" +
                         KRBCheckoffLines."Withdrwable svgs" +
                         KRBCheckoffLines."merry goround" +
                         KRBCheckoffLines.Dev2 +
                         KRBCheckoffLines."Share cap" +
                         KRBCheckoffLines.Entrance +
                         KRBCheckoffLines.Insurance +
                         KRBCheckoffLines.Refinance;
            until KRBCheckoffLines.Next() = 0;

        "Total Amount" := Total;
    end;

    var
        NoSetup: Record "Sacco No. Series";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        cust: Record Customer;
        "GL Account": Record "G/L Account";
        BANKACC: Record "Bank Account";
}

