#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Table 50017 "Sacco Transfers Schedule"
{

    fields
    {
        field(1; "No."; Code[20])
        {
            TableRelation = "Sacco Transfers".No;
        }
        field(2; "Destination Account No."; Code[20])
        {
            TableRelation = if ("Destination Account Type" = const(FOSA)) Vendor."No."
            else
            if ("Destination Account Type" = const(BANK)) "Bank Account"."No."
            else
            if ("Destination Account Type" = const("G/L ACCOUNT")) "G/L Account"."No."
            else
            if ("Destination Account Type" = const(MEMBER)) customer."No.";

            trigger OnValidate()
            begin
                if "Destination Account Type" = "destination account type"::FOSA then begin
                    Vend.Reset;
                    if Vend.Get("Destination Account No.") then begin
                        "Destination Account Name" := Vend.Name;
                        "Global Dimension 2 Code" := Vend."Global Dimension 2 Code";
                    end;
                end;
                if "Destination Account Type" = "destination account type"::"G/L ACCOUNT" then begin
                    "G/L".Reset;
                    if "G/L".Get("Destination Account No.") then begin
                        "Destination Account Name" := "G/L".Name;
                    end;
                end;

                if "Destination Account Type" = "destination account type"::MEMBER then begin
                    memb.Reset;
                    if memb.Get("Destination Account No.") then begin
                        "Destination Account Name" := memb.Name;
                        "Global Dimension 2 Code" := memb."Global Dimension 2 Code";
                    end;
                end;
                if "Destination Account Type" = "destination account type"::BANK then begin
                    Bank.Reset;
                    if Bank.Get("Destination Account No.") then begin
                        "Destination Account Name" := Bank.Name;
                        "Global Dimension 2 Code" := Bank."Global Dimension 2 Code";
                    end;
                end;

                //validate account pn
                SaccoTransfer.Reset;
                SaccoTransfer.SetRange(No, SaccoTransfer.No);
                if SaccoTransfer.Find('-') then begin
                    if SaccoTransfer."Source Account No" = Rec."Destination Account No." then
                        Error(Text001);


                end;
            end;
        }
        field(3; "Destination Account Name"; Text[100])
        {
        }
        field(4; "Destination Account Type"; Option)
        {
            OptionCaption = 'FOSA,BANK,G/L ACCOUNT,MEMBER';
            OptionMembers = FOSA,BANK,"G/L ACCOUNT",MEMBER;

            trigger OnValidate()
            begin
                /*IF "Destination Account Type"="Destination Account Type"::BANK THEN BEGIN
                "Destination Account No.":='5-02-09276-01';
                VALIDATE("Destination Account No.");
                END;
                   */

            end;
        }
        field(5; "Destination Type"; ENUM TransactionTypesEnum)
        {
        }
        field(6; "Destination Loan"; Code[30])
        {
            TableRelation = if ("Destination Account Type" = filter(MEMBER)) "Loans Register"."Loan  No." where("BOSA No" = field("Destination Account No."),
                                                                                                               "Loan  No." = field("Destination Loan"))
            else
            if ("Destination Account Type" = filter(FOSA)) "Loans Register"."Loan  No." where("Client Code" = field("Destination Account No."));

            trigger OnValidate()
            begin
                if "Destination Type" = "destination type"::"Deposit Contribution" then
                    Error('Destination Loan Must Be Blank');
            end;
        }
        field(7; Amount; Decimal)
        {

            trigger OnValidate()
            begin
                if Loans.Get("Destination Loan") then begin
                    Loans.CalcFields(Loans."Outstanding Balance");
                    if Loans.Posted = true then begin
                        if Loans."Loan Under Debt Collection" = true then begin
                            Message('This Loan is Under Debt Collection');
                            if Confirm('Do you want to charge Debt Collection Fee', false) = true then begin
                                TestField("Cummulative Total Payment Loan");
                                ReceiptAll.Init;
                                ReceiptAll."No." := "No.";
                                ReceiptAll.Amount := "Cummulative Total Payment Loan" * Loans."Loan Debt Collector Interest %";
                                //ReceiptAll."Total Amount":="Cummulative Total Payment Loan"*Loans."Loan Debt Collector Interest %";
                                ReceiptAll."Destination Account Type" := ReceiptAll."destination account type"::FOSA;
                                ReceiptAll."Destination Account No." := Loans."Loan Debt Collector";
                                ReceiptAll."Destination Loan" := "Destination Loan";
                                //ReceiptAll."Destination Account No.":="Destination Account No.";
                                ReceiptAll.Insert;
                            end;
                        end;
                    end;
                end;
            end;
        }
        field(8; Description; Text[100])
        {
        }
        field(9; "Created By"; Code[20])
        {
        }
        field(10; "Cummulative Total Payment Loan"; Decimal)
        {
        }
        field(11; Credit; Text[30])
        {
        }
        field(12; "Global Dimension 1 Code"; Code[10])
        {
            CaptionClass = '1,1,1';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1),
                                                          "Dimension Value Type" = const(Standard));
        }
        field(13; "Global Dimension 2 Code"; Code[10])
        {
            CaptionClass = '1,2,2';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2),
                                                          "Dimension Value Type" = const(Standard));
        }
    }

    keys
    {
        key(Key1; "No.", "Destination Account No.", "Destination Type", "Destination Loan")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        if "Destination Account No." <> '' then begin
            Bosa.Reset;
            if Bosa.Get("No.") then begin
                if (Bosa.Posted) or (Bosa.Approved) then
                    Error('Cannot delete approved or posted batch');
            end;
        end;
    end;

    trigger OnInsert()
    begin
        Credit := 'Debit';
    end;

    trigger OnModify()
    begin
        if "Destination Account No." <> '' then begin
            Bosa.Reset;
            if Bosa.Get("No.") then begin
                if (Bosa.Posted) or (Bosa.Approved) then
                    Error('Cannot modify approved or posted batch');
            end;
        end;
    end;

    trigger OnRename()
    begin
        Bosa.Reset;
        if Bosa.Get("No.") then begin
            if (Bosa.Posted) or (Bosa.Approved) then
                Error('Cannot rename approved or posted batch');
        end;
    end;

    var
        Cust: Record Customer;
        Vend: Record Vendor;
        Bank: Record "Bank Account";
        Bosa: Record "BOSA Transfers";
        "G/L": Record "G/L Account";
        memb: Record Customer;
        Loans: Record "Loans Register";
        ReceiptAll: Record "Sacco Transfers Schedule";
        SaccoTransfer: Record "Sacco Transfers";
        Text001: label 'Source Account Cannot Be Same As Destination Account! Check Accounts....';
}

