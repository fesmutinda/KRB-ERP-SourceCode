#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 56193 "Member Account Card - Editable"
{
    Caption = 'Member Card';
    DeleteAllowed = false;
    Editable = true;
    InsertAllowed = true;
    PageType = Card;
    PromotedActionCategories = 'New,Process,Reports,Approval,Budgetary Control,Cancellation,Category7_caption,Category8_caption,Category9_caption,Category10_caption';
    RefreshOnActivate = true;
    SourceTable = Customer;
    // SourceTableView = sorting("Employer Code")
    //                   where("Customer Type" = const(Member));

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                Editable = true;
                field("No."; Rec."No.")
                {
                    ApplicationArea = Basic;
                    Editable = true;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = Basic;
                    Editable = true;
                }
                field("Payroll/Staff No"; Rec."Payroll/Staff No")
                {
                    ApplicationArea = Basic;
                    Editable = true;
                }
                // field("FOSA Account"; Rec."FOSA Account")
                // {
                //     ApplicationArea = Basic;
                //     Editable = true;

                //     trigger OnValidate()
                //     begin
                //         FosaName := '';

                //         if Rec."FOSA Account" <> '' then begin
                //             if Vend.Get(Rec."FOSA Account") then begin
                //                 FosaName := Vend.Name;
                //             end;
                //         end;
                //     end;
                // }
                // field(FosaName; FosaName)
                // {
                //     ApplicationArea = Basic;
                //     Caption = 'FOSA Account Name';
                //     Editable = true;
                // }
                field("Account Category"; Rec."Account Category")
                {
                    ApplicationArea = Basic;
                    Editable = true;

                    // trigger OnValidate()
                    // begin
                    //     lblIDVisible := true;
                    //     lblDOBVisible := true;
                    //     lblRegNoVisible := false;
                    //     lblRegDateVisible := false;
                    //     lblGenderVisible := true;
                    //     txtGenderVisible := true;
                    //     lblMaritalVisible := true;
                    //     txtMaritalVisible := true;
                    //     if "Account Category" <> "account category"::SINGLE then begin
                    //         lblIDVisible := false;
                    //         lblDOBVisible := false;
                    //         lblRegNoVisible := true;
                    //         lblRegDateVisible := true;
                    //         lblGenderVisible := false;
                    //         txtGenderVisible := false;
                    //         lblMaritalVisible := false;
                    //         txtMaritalVisible := false;

                    //     end;
                    // end;
                }
                field("Old Account No."; Rec."Old Account No.")
                {
                    ApplicationArea = Basic;
                }
                field("ID No."; Rec."ID No.")
                {
                    ApplicationArea = Basic;
                    Caption = 'ID Number';
                    Editable = true;
                }
                field("Passport No."; Rec."Passport No.")
                {
                    ApplicationArea = Basic;
                    Editable = true;
                }
                field(Address; Rec.Address)
                {
                    ApplicationArea = Basic;
                    Editable = true;
                }
                field("Post Code"; Rec."Post Code")
                {
                    ApplicationArea = Basic;
                    Caption = 'Post Code/City';
                    Editable = true;
                }
                field(Gender; Rec.Gender)
                {
                    ApplicationArea = Basic;
                }
                field(City; Rec.City)
                {
                    ApplicationArea = Basic;
                }
                field("User ID"; StatusPermissions."User Id")
                {
                    ApplicationArea = Basic;
                    Caption = 'User ID';
                    Editable = true;
                }
                field("Phone No."; Rec."Phone No.")
                {
                    ApplicationArea = Basic;
                    Caption = 'Mobile No.';
                    Editable = true;
                }
                field("Employer Code"; Rec."Employer Code")
                {
                    ApplicationArea = Basic;
                    Caption = 'Employer';
                    Editable = true;
                }
                field("Job Title"; Rec."Job title")
                {
                    ApplicationArea = Basic;
                    Caption = 'Job Title';
                    Editable = true;
                }
                field(PIN; Rec.Pin)
                {
                    ApplicationArea = Basic;
                    Caption = 'PIN';
                    Editable = true;
                }
                field("Registration Date"; Rec."Registration Date")
                {
                    ApplicationArea = Basic;
                    Editable = true;
                }
                field(txtMarital; Rec."Marital Status")
                {
                    ApplicationArea = Basic;
                    Caption = 'Marital Status';
                    Visible = txtMaritalVisible;
                }
                field("Date of Birth"; Rec."Date of Birth")
                {
                    ApplicationArea = Basic;
                    Caption = 'Company Registration Date';
                    Editable = true;
                }
                field(Image; Rec.Image)
                {
                    ApplicationArea = Basic;
                }
                field(Signature; Rec.Signature)
                {
                    ApplicationArea = Basic;
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                    // Editable = false;
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                    // Editable = false;
                }
                field("Customer Posting Group"; Rec."Customer Posting Group")
                {
                    ApplicationArea = Basic;
                    // Editable = false;
                }
                field("Customer Type"; Rec."Customer Type") { ApplicationArea = Basic; }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                    Editable = true;

                    trigger OnValidate()
                    begin
                        StatusPermissions.Reset;
                        StatusPermissions.SetRange(StatusPermissions."User Id", UserId);
                        StatusPermissions.SetRange(StatusPermissions."Function", StatusPermissions."function"::Edit);
                        if StatusPermissions.Find('-') = false then
                            Error('You do not have permissions to change the account status.');
                    end;
                }
                field(Blocked; Rec.Blocked)
                {
                    ApplicationArea = Basic;
                }
                field("Last Date Modified"; Rec."Last Date Modified")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
            }
            group("Other Details")
            {
                Caption = 'Other Details';
                Editable = true;
                field("Contact Person"; Rec."Contact Person")
                {
                    ApplicationArea = Basic;
                }
                field("Contact Person Phone"; Rec."Contact Person Phone")
                {
                    ApplicationArea = Basic;
                }
                field("E-Mail"; Rec."E-Mail")
                {
                    ApplicationArea = Basic;
                }
                field("Village/Residence"; Rec."Village/Residence")
                {
                    ApplicationArea = Basic;
                }
                field("Home Page"; Rec."Home Page")
                {
                    ApplicationArea = Basic;
                }
                field("Address 2"; Rec."Address 2")
                {
                    ApplicationArea = Basic;
                    Caption = 'Physical Address';
                }
                field("Withdrawal Application Date"; Rec."Withdrawal Application Date")
                {
                    ApplicationArea = Basic;
                }
                field("Withdrawal Date"; Rec."Withdrawal Date")
                {
                    ApplicationArea = Basic;
                }
                field("Withdrawal Fee"; Rec."Withdrawal Fee")
                {
                    ApplicationArea = Basic;
                }
                field("Status - Withdrawal App."; Rec."Status - Withdrawal App.")
                {
                    ApplicationArea = Basic;
                }
                field("Mode of Dividend Payment"; Rec."Mode of Dividend Payment")
                {
                    ApplicationArea = Basic;
                }
                field("Recruited By"; Rec."Recruited By")
                {
                    ApplicationArea = Basic;
                }
                field("Sms Notification"; Rec."Sms Notification")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Member")
            {
                Caption = '&Member';
                action("Member Ledger Entries")
                {
                    ApplicationArea = Basic;
                    Caption = 'Member Ledger Entries';
                    Image = CustomerLedger;
                }
                action(Dimensions)
                {
                    ApplicationArea = Basic;
                    Image = Dimensions;
                }
                action("Bank Account")
                {
                    ApplicationArea = Basic;
                    Image = Card;
                }
                action(Contacts)
                {
                    ApplicationArea = Basic;
                    Image = ContactPerson;

                    trigger OnAction()
                    begin
                        Rec.ShowContact;
                    end;
                }
            }
            group(ActionGroup22)
            {
                action("Members Kin Details List")
                {
                    ApplicationArea = Basic;
                    Caption = 'Members Kin Details List';
                    Image = Relationship;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                }
                action("SPouse & Children")
                {
                    ApplicationArea = Basic;
                    Caption = 'SPouse & Children';
                    Image = relationship;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                }
                action("Account Signatories")
                {
                    ApplicationArea = Basic;
                    Caption = 'Signatories Details';
                    Promoted = true;
                    PromotedCategory = Process;
                }
                action("Members Statistics")
                {
                    ApplicationArea = Basic;
                    Image = Statistics;
                    Promoted = true;
                    PromotedCategory = Process;
                }
                group(ActionGroup18)
                {
                }
                action("Detailed Statement")
                {
                    ApplicationArea = Basic;
                    Caption = 'Detailed Statement';
                    Image = "Report";
                    Promoted = true;
                    PromotedCategory = "Report";

                    trigger OnAction()
                    begin
                        Cust.Reset;
                        Cust.SetRange(Cust."No.", Rec."No.");
                        if Cust.Find('-') then
                            Report.Run(50151, true, false, Cust);
                    end;
                }
                action("Detailed Interest Statement")
                {
                    ApplicationArea = Basic;
                    Caption = 'Detailed Interest Statement';
                    Image = "Report";

                    trigger OnAction()
                    begin
                        Cust.Reset;
                        Cust.SetRange(Cust."No.", Rec."No.");
                        if Cust.Find('-') then
                            Report.Run(50151, true, false, Cust);
                    end;
                }
                action("Account Closure Slip")
                {
                    ApplicationArea = Basic;
                    Caption = 'Account Closure Slip';
                    Image = "Report";
                    Promoted = true;
                    PromotedCategory = "Report";

                    trigger OnAction()
                    begin
                        Cust.Reset;
                        Cust.SetRange(Cust."No.", Rec."No.");
                        if Cust.Find('-') then
                            Report.Run(50033, true, false, Cust);
                    end;
                }
                action("Recover Loans from Gurantors")
                {
                    ApplicationArea = Basic;
                    Caption = 'Recover Loans from Gurantors';
                    Image = "Report";

                    trigger OnAction()
                    begin
                        /*IF ("Current Shares" * -1) > 0 THEN
                        ERROR('Please recover the loans from the members shares before recovering from gurantors.');
                        
                        IF CONFIRM('Are you absolutely sure you want to recover the loans from the guarantors as loans?') = FALSE THEN
                        EXIT;
                        
                        RoundingDiff:=0;
                        
                        //delete journal line
                        Gnljnline.RESET;
                        Gnljnline.SETRANGE("Journal Template Name",'GENERAL');
                        Gnljnline.SETRANGE("Journal Batch Name",'Recoveries');
                        Gnljnline.DELETEALL;
                        //end of deletion
                        
                        TotalRecovered:=0;
                        
                        DActivity:="Global Dimension 1 Code";
                        DBranch:="Global Dimension 2 Code";
                        
                        CALCFIELDS("Outstanding Balance","FOSA Outstanding Balance","Accrued Interest","Insurance Fund","Current Shares");
                        
                        
                        
                        CALCFIELDS("Outstanding Balance","Accrued Interest","Current Shares");
                        
                        
                        
                        LoansR.RESET;
                        LoansR.SETRANGE(LoansR."Client Code","No.");
                        LoansR.SETRANGE(LoansR.Source,LoansR.Source::BOSA);
                        IF LoansR.FIND('-') THEN BEGIN
                        REPEAT
                        LoansR.CALCFIELDS(LoansR."Outstanding Balance",LoansR."Oustanding Interest",LoansR."No. Of Guarantors");
                        
                        IF ((LoansR."Outstanding Balance" ) > 0) AND (LoansR."No. Of Guarantors" > 0) THEN BEGIN
                        
                        LoanAllocation:=ROUND((LoansR."Outstanding Balance")/LoansR."No. Of Guarantors",0.01)+
                                        ROUND((LoansR."Oustanding Interest")/LoansR."No. Of Guarantors",0.01);
                        
                        
                        LGurantors.RESET;
                        LGurantors.SETRANGE(LGurantors."Loan No",LoansR."Loan  No.");
                        LGurantors.SETRANGE(LGurantors.Substituted,FALSE);
                        IF LGurantors.FIND('-') THEN BEGIN
                        REPEAT
                        
                        
                        
                        IF Cust.GET(LGurantors."Member No") THEN BEGIN
                        Cust.CALCFIELDS(Cust."Current Shares");
                        "Remaining Amount":=Cust."Current Shares";
                        END;
                        
                        LineNo:=LineNo+10000;
                        
                        GenJournalLine.INIT;
                        GenJournalLine."Journal Template Name":='GENERAL';
                        GenJournalLine."Journal Batch Name":='Recoveries';
                        GenJournalLine."Line No.":=LineNo;
                        GenJournalLine."Document No.":='GL-'+LoansR."Client Code";
                        GenJournalLine."Posting Date":=TODAY;
                        GenJournalLine."External Document No.":=LoansR."Loan  No.";
                        GenJournalLine."Account Type":=GenJournalLine."Bal. Account Type"::"6";
                        GenJournalLine."Account No.":=LGurantors."Member No";
                        GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                        GenJournalLine.Description:='Loan Default: ' + LGurantors."Loanees  No";
                        IF LoanAllocation >"Remaining Amount" THEN BEGIN
                        GenJournalLine.Amount:="Remaining Amount";
                        END ELSE BEGIN
                        GenJournalLine.Amount:=LoanAllocation ;
                        END;
                        GenJournalLine.VALIDATE(GenJournalLine.Amount);
                        GenJournalLine."Transaction Type":=GenJournalLine."Transaction Type"::"Deposit Contribution";
                        GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
                        GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
                        GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                        GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                        IF GenJournalLine.Amount<>0 THEN
                        GenJournalLine.INSERT;
                        
                        
                        
                        //Off Set BOSA Loans
                        
                        //Principle
                        LineNo:=LineNo+10000;
                        
                        GenJournalLine.INIT;
                        GenJournalLine."Journal Template Name":='GENERAL';
                        GenJournalLine."Journal Batch Name":='Recoveries';
                        GenJournalLine."Line No.":=LineNo;
                        GenJournalLine."Document No.":='GL-'+LoansR."Client Code";
                        GenJournalLine."Posting Date":=TODAY;
                        GenJournalLine."External Document No.":=Loans."Loan  No.";
                        GenJournalLine."Account Type":=GenJournalLine."Bal. Account Type"::"6";
                        GenJournalLine."Account No.":=LoansR."Client Code";
                        GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                        GenJournalLine.Description:='Cleared by Guarantor Deposits: ' + LGurantors."Member No";
                        IF LoanAllocation >"Remaining Amount" THEN BEGIN
                        GenJournalLine.Amount:=-"Remaining Amount";
                        END ELSE BEGIN
                        GenJournalLine.Amount:=-LoanAllocation ;
                        END;
                        
                        GenJournalLine.VALIDATE(GenJournalLine.Amount);
                        GenJournalLine."Transaction Type":=GenJournalLine."Transaction Type"::Repayment;
                        GenJournalLine."Loan No":=LoansR."Loan  No.";
                        GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
                        GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
                        GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                        GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                        IF GenJournalLine.Amount<>0 THEN
                        GenJournalLine.INSERT;
                        
                        UNTIL LGurantors.NEXT = 0;
                        END;
                        END;
                        UNTIL LoansR.NEXT = 0;
                        END;
                        
                        
                        "Defaulted Loans Recovered":=TRUE;
                        MODIFY;
                        
                        {
                        //Post New
                        GenJournalLine.RESET;
                        GenJournalLine.SETRANGE("Journal Template Name",'GENERAL');
                        GenJournalLine.SETRANGE("Journal Batch Name",'Recoveries');
                        IF GenJournalLine.FIND('-') THEN BEGIN
                        CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post Batch",GenJournalLine);
                        END;
                        
                         }
                        
                        MESSAGE('Loan recovery from guarantors posted successfully.');
                        */

                    end;
                }
                action("Recover Loans from Deposit")
                {
                    ApplicationArea = Basic;
                    Caption = 'Recover Loans from Deposit';

                    trigger OnAction()
                    begin
                        /*IF CONFIRM('Are you absolutely sure you want to recover the loans from member deposit') = FALSE THEN
                        EXIT;
                        
                        "Withdrawal Fee":=1000;
                        
                        //delete journal line
                        Gnljnline.RESET;
                        Gnljnline.SETRANGE("Journal Template Name",'GENERAL');
                        Gnljnline.SETRANGE("Journal Batch Name",'Recoveries');
                        Gnljnline.DELETEALL;
                        //end of deletion
                        
                        TotalRecovered:=0;
                        TotalInsuarance:=0;
                        
                        DActivity:="Global Dimension 1 Code";
                        DBranch:="Global Dimension 2 Code";
                        CALCFIELDS("Outstanding Balance","Accrued Interest","Current Shares");
                        
                        CALCFIELDS("Outstanding Balance","Outstanding Interest","FOSA Outstanding Balance","Accrued Interest","Insurance Fund","Current Shares");
                        TotalOustanding:="Outstanding Balance"+"Outstanding Interest";
                           // GETTING WITHDRAWAL FEE
                         IF (0.15*("Current Shares")) > 1000 THEN BEGIN
                         "Withdrawal Fee":=1000;
                         END ELSE BEGIN
                          "Withdrawal Fee":=0.15*("Current Shares");
                         END;
                        // END OF GETTING WITHDRWAL FEE
                        LineNo:=LineNo+10000;
                        
                        GenJournalLine.INIT;
                        GenJournalLine."Journal Template Name":='GENERAL';
                        GenJournalLine."Journal Batch Name":='Recoveries';
                        GenJournalLine."Line No.":=LineNo;
                        GenJournalLine."Document No.":="No.";
                        GenJournalLine."Posting Date":=TODAY;
                        GenJournalLine."External Document No.":="No.";
                        GenJournalLine."Account Type":=GenJournalLine."Bal. Account Type"::"6";
                        GenJournalLine."Account No.":="No.";
                        GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                        GenJournalLine.Description:='WITHDRAWAL FEE';
                        GenJournalLine.Amount:="Withdrawal Fee";
                        GenJournalLine.VALIDATE(GenJournalLine.Amount);
                        GenJournalLine."Transaction Type":=GenJournalLine."Transaction Type"::"Deposit Contribution";
                        GenJournalLine."Bal. Account No." :='103102';
                        GenJournalLine."Bal. Account Type":=GenJournalLine."Bal. Account Type"::"G/L Account";
                        GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
                        GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
                        GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                        GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                        IF GenJournalLine.Amount<>0 THEN
                        GenJournalLine.INSERT;
                        
                        
                        TotalRecovered:=TotalRecovered+GenJournalLine.Amount;
                        
                        
                        "Closing Deposit Balance":=("Current Shares"-"Withdrawal Fee");
                        
                        
                        IF "Closing Deposit Balance" > 0 THEN BEGIN
                         "Remaining Amount":="Closing Deposit Balance";
                        
                        LoansR.RESET;
                        LoansR.SETRANGE(LoansR."Client Code","No.");
                        LoansR.SETRANGE(LoansR.Source,LoansR.Source::BOSA);
                        IF LoansR.FIND('-') THEN BEGIN
                        REPEAT
                        //"AMOUNTTO BE RECOVERED":=0;
                        LoansR.CALCFIELDS(LoansR."Outstanding Balance",LoansR."Oustanding Interest",LoansR."Loans Insurance");
                        TotalInsuarance:=TotalInsuarance+LoansR."Loans Insurance";
                        UNTIL LoansR.NEXT=0;
                        END;
                        
                        LoansR.RESET;
                        LoansR.SETRANGE(LoansR."Client Code","No.");
                        LoansR.SETRANGE(LoansR.Source,LoansR.Source::BOSA);
                        IF LoansR.FIND('-') THEN BEGIN
                        REPEAT
                        "AMOUNTTO BE RECOVERED":=0;
                        LoansR.CALCFIELDS(LoansR."Outstanding Balance",LoansR."Oustanding Interest",LoansR."Loans Insurance");
                        
                        
                        
                        //Loan Insurance
                        LineNo:=LineNo+10000;
                        GenJournalLine.INIT;
                        GenJournalLine."Journal Template Name":='GENERAL';
                        GenJournalLine."Journal Batch Name":='Recoveries';
                        GenJournalLine."Line No.":=LineNo;
                        GenJournalLine."Document No.":="No.";
                        GenJournalLine."Posting Date":=TODAY;
                        GenJournalLine."External Document No.":="No.";
                        GenJournalLine."Account Type":=GenJournalLine."Bal. Account Type"::"6";
                        GenJournalLine."Account No.":="No.";
                        GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                        GenJournalLine.Description:='Cleared by deposits: ' + "No.";
                        GenJournalLine.Amount:=-ROUND(LoansR."Loans Insurance");
                        GenJournalLine.VALIDATE(GenJournalLine.Amount);
                        GenJournalLine."Transaction Type":=GenJournalLine."Transaction Type"::"Insurance Paid";
                        GenJournalLine."Loan No":=LoansR."Loan  No.";
                        GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
                        GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
                        GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                        GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                        IF GenJournalLine.Amount<>0 THEN
                        GenJournalLine.INSERT;
                        
                        {
                        LineNo:=LineNo+10000;
                        GenJournalLine.INIT;
                        GenJournalLine."Journal Template Name":='GENERAL';
                        GenJournalLine."Journal Batch Name":='LOANS';
                        GenJournalLine."Line No.":=LineNo;
                        GenJournalLine."Document No.":="No.";
                        GenJournalLine."Posting Date":=TODAY;
                        GenJournalLine."External Document No.":="No.";
                        GenJournalLine."Account Type":=GenJournalLine."Bal. Account Type"::Member;
                        GenJournalLine."Account No.":="No.";
                        GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                        GenJournalLine.Description:='Cleared by deposits: ' + "No.";
                        GenJournalLine.Amount:=ROUND(LoansR."Loans Insurance");
                        GenJournalLine.VALIDATE(GenJournalLine.Amount);
                        GenJournalLine."Transaction Type":=GenJournalLine."Transaction Type"::"Deposit Contribution";
                        GenJournalLine."Loan No":=LoansR."Loan  No.";
                        GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
                        GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
                        GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                        GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                        IF GenJournalLine.Amount<>0 THEN
                        GenJournalLine.INSERT;}
                        
                        
                        
                        {LoansR.RESET;
                        LoansR.SETRANGE(LoansR."Client Code","No.");
                        LoansR.SETRANGE(LoansR.Source,LoansR.Source::BOSA);
                        IF LoansR.FIND('-') THEN BEGIN
                        //REPEAT
                        "AMOUNTTO BE RECOVERED":=0;
                        LoansR.CALCFIELDS(LoansR."Outstanding Balance",LoansR."Oustanding Interest");}
                        
                        
                        //Off Set BOSA Loans
                        //Interest
                        LineNo:=LineNo+10000;
                        GenJournalLine.INIT;
                        GenJournalLine."Journal Template Name":='GENERAL';
                        GenJournalLine."Journal Batch Name":='Recoveries';
                        GenJournalLine."Line No.":=LineNo;
                        GenJournalLine."Document No.":="No.";
                        GenJournalLine."Posting Date":=TODAY;
                        GenJournalLine."External Document No.":="No.";
                        GenJournalLine."Account Type":=GenJournalLine."Bal. Account Type"::"6";
                        GenJournalLine."Account No.":="No.";
                        GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                        GenJournalLine.Description:='Interest Capitalized: ' + "No.";
                        GenJournalLine.Amount:=-ROUND(LoansR."Oustanding Interest");
                        GenJournalLine.VALIDATE(GenJournalLine.Amount);
                        GenJournalLine."Transaction Type":=GenJournalLine."Transaction Type"::"Interest Paid";
                        GenJournalLine."Loan No":=LoansR."Loan  No.";
                        GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
                        GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
                        GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                        GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                        IF GenJournalLine.Amount<>0 THEN
                        GenJournalLine.INSERT;
                        
                        
                        LineNo:=LineNo+10000;
                        GenJournalLine.INIT;
                        GenJournalLine."Journal Template Name":='GENERAL';
                        GenJournalLine."Journal Batch Name":='Recoveries';
                        GenJournalLine."Line No.":=LineNo;
                        GenJournalLine."Document No.":="No.";
                        GenJournalLine."Posting Date":=TODAY;
                        GenJournalLine."External Document No.":="No.";
                        GenJournalLine."Account Type":=GenJournalLine."Bal. Account Type"::"6";
                        GenJournalLine."Account No.":="No.";
                        GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                        GenJournalLine.Description:='Interest Capitalized: ' + "No.";
                        GenJournalLine.Amount:=ROUND(LoansR."Oustanding Interest");
                        GenJournalLine.VALIDATE(GenJournalLine.Amount);
                        GenJournalLine."Transaction Type":=GenJournalLine."Transaction Type"::Loan;
                        GenJournalLine."Loan No":=LoansR."Loan  No.";
                        GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
                        GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
                        GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                        GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                        IF GenJournalLine.Amount<>0 THEN
                        GenJournalLine.INSERT;
                        
                        PrincipInt:=0;
                        TotalLoansOut:=0;
                        "Closing Deposit Balance":=("Current Shares"-"Withdrawal Fee"-TotalInsuarance);
                        
                        IF "Remaining Amount" > 0 THEN BEGIN
                        PrincipInt:=(LoansR."Outstanding Balance"+LoansR."Oustanding Interest");
                        TotalLoansOut:=("Outstanding Balance"+"Outstanding Interest");
                        
                        //Principle
                        LineNo:=LineNo+10000;
                        //"AMOUNTTO BE RECOVERED":=ROUND(((LoansR."Outstanding Balance"+LoansR."Oustanding Interest")/("Outstanding Balance"+"Outstanding Interest")))*"Closing Deposit Balance";
                        "AMOUNTTO BE RECOVERED":=ROUND((PrincipInt/TotalLoansOut)*"Closing Deposit Balance",0.01,'=');
                        GenJournalLine.INIT;
                        GenJournalLine."Journal Template Name":='GENERAL';
                        GenJournalLine."Journal Batch Name":='Recoveries';
                        GenJournalLine."Line No.":=LineNo;
                        GenJournalLine."Document No.":="No.";
                        GenJournalLine."Posting Date":=TODAY;
                        GenJournalLine."External Document No.":="No.";
                        GenJournalLine."Account Type":=GenJournalLine."Bal. Account Type"::"6";
                        GenJournalLine."Account No.":="No.";
                        GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                        GenJournalLine.Description:='Loan Against Deposits: ' + "No.";
                        IF "AMOUNTTO BE RECOVERED" > (LoansR."Outstanding Balance"+LoansR."Oustanding Interest") THEN BEGIN
                        IF "Remaining Amount" > (LoansR."Outstanding Balance"+LoansR."Oustanding Interest") THEN BEGIN
                        GenJournalLine.Amount:=-ROUND(LoansR."Outstanding Balance"+LoansR."Oustanding Interest");
                        END ELSE BEGIN
                        GenJournalLine.Amount:=-"Remaining Amount";
                        
                        END;
                        
                        END ELSE BEGIN
                        IF "Remaining Amount" > "AMOUNTTO BE RECOVERED" THEN BEGIN
                        GenJournalLine.Amount:=-"AMOUNTTO BE RECOVERED";
                        END ELSE BEGIN
                        GenJournalLine.Amount:=-"Remaining Amount";
                        END;
                        END;
                        GenJournalLine.VALIDATE(GenJournalLine.Amount);
                        GenJournalLine."Transaction Type":=GenJournalLine."Transaction Type"::Repayment;
                        GenJournalLine."Loan No":=LoansR."Loan  No.";
                        GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
                        GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
                        GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                        GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                        IF GenJournalLine.Amount<>0 THEN
                        GenJournalLine.INSERT;
                        "Remaining Amount":="Remaining Amount"+GenJournalLine.Amount;
                        
                        TotalRecovered:=TotalRecovered+((GenJournalLine.Amount));
                        
                        END;
                        
                        
                        
                        
                        UNTIL LoansR.NEXT = 0;
                        END;
                        END;
                        //Deposit
                        LineNo:=LineNo+10000;
                        GenJournalLine.INIT;
                        GenJournalLine."Journal Template Name":='GENERAL';
                        GenJournalLine."Journal Batch Name":='Recoveries';
                        GenJournalLine."Line No.":=LineNo;
                        GenJournalLine."Document No.":="No.";
                        GenJournalLine."Posting Date":=TODAY;
                        GenJournalLine."External Document No.":="No.";
                        GenJournalLine."Account Type":=GenJournalLine."Bal. Account Type"::"6";
                        GenJournalLine."Account No.":="No.";
                        GenJournalLine.VALIDATE(GenJournalLine."Account No.");
                        GenJournalLine.Description:='Defaulted Loans Against Deposits';
                        GenJournalLine.Amount:=(TotalRecovered-"Withdrawal Fee"-TotalInsuarance)*-1;
                        GenJournalLine.VALIDATE(GenJournalLine.Amount);
                        GenJournalLine."Transaction Type":=GenJournalLine."Transaction Type"::"Deposit Contribution";
                        GenJournalLine."Shortcut Dimension 1 Code":=DActivity;
                        GenJournalLine."Shortcut Dimension 2 Code":=DBranch;
                        GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 1 Code");
                        GenJournalLine.VALIDATE(GenJournalLine."Shortcut Dimension 2 Code");
                        IF GenJournalLine.Amount<>0 THEN
                        GenJournalLine.INSERT;
                        
                        
                        
                        "Defaulted Loans Recovered":=TRUE;
                        MODIFY;
                        
                        {
                        //Post New
                        GenJournalLine.RESET;
                        GenJournalLine.SETRANGE("Journal Template Name",'GENERAL');
                        GenJournalLine.SETRANGE("Journal Batch Name",'Recoveries');
                        IF GenJournalLine.FIND('-') THEN BEGIN
                        CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post Batch",GenJournalLine);
                        END;
                        }
                        
                        
                        MESSAGE('Loan recovery from Deposits posted successfully.');
                         */

                    end;
                }
                action("FOSA Statement")
                {
                    ApplicationArea = Basic;
                    Promoted = true;
                    PromotedCategory = "Report";

                    trigger OnAction()
                    begin
                        /*Vend.RESET;
                        Vend.SETRANGE(Vend."BOSA Account No","No.");
                        IF Vend.FIND('-') THEN
                        REPORT.RUN(,TRUE,FALSE,Vend);
                        */

                    end;
                }
                action("Member is  a Guarantor")
                {
                    ApplicationArea = Basic;
                    Caption = 'Member is  a Guarantor';
                    Image = "Report";

                    trigger OnAction()
                    begin

                        Cust.Reset;
                        Cust.SetRange(Cust."No.", Rec."No.");
                        if Cust.Find('-') then
                            Report.Run(50032, true, false, Cust);
                    end;
                }
                action("Member is  Guaranteed")
                {
                    ApplicationArea = Basic;
                    Caption = 'Member is  Guaranteed';
                    Image = "Report";

                    trigger OnAction()
                    begin
                        Cust.Reset;
                        Cust.SetRange(Cust."No.", Rec."No.");
                        if Cust.Find('-') then
                            Report.Run(50035, true, false, Cust);
                    end;
                }
                group("Issued Documents")
                {
                    Caption = 'Issued Documents';
                    Visible = false;
                }
                action("Dispatch Physical File")
                {
                    ApplicationArea = Basic;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        /*

                       IF Status <> Status::Active THEN
                       ERROR('you cannot dispatch an inactive file, kindly contact the administrator');

                       IF "File Movement Remarks"='' THEN

                       "File Movement Remarks":=FORMAT("File Movement Remarks1");
                       //TESTFIELD("File Movement Remarks");
                       User:=USERID;
                       TESTFIELD(User);
                       //TESTFIELD("Folio Number");
                       Cust.RESET;
                       Cust.SETRANGE(Cust."No.","No.");
                       IF Cust.FIND('-') THEN BEGIN
                       IF "Bank Code"='' THEN BEGIN
                       //Cust."Current file location":='REGISTRY';
                       //"Bank Code":='REGISTRY';
                       MODIFY;


                       END;
                       IF (Cust."File MVT Time"<>0T) AND (Cust."file Received"<>TRUE) THEN
                       ERROR('Please inform this user to receive this file before use %1',Cust.User);

                       IF Cust."Current file location"='' THEN
                       Cust."Current file location":='REGISTRY';
                       //IF "File Received by"<>USERID THEN ERROR('You do not have permissions to MOVE the file.');

                         ApprovalUsers.RESET;
                         ApprovalUsers.SETRANGE(ApprovalUsers."User ID",USERID);
                         IF ApprovalUsers.FIND('-') THEN BEGIN
                         REPEAT
                          //IF ApprovalUsers."User ID"<>"File Received by" THEN
                          //ERROR('You do not have permissions to MOVE the file.');
                         IF CONFIRM('Are You sure you want to move the phisical file to the selected location?')=FALSE THEN
                          EXIT;


                       {MOVESTATUS.RESET;
                       MOVESTATUS.SETRANGE(MOVESTATUS."User ID",USERID);
                       IF MOVESTATUS.FIND('-') THEN BEGIN
                       REPEAT
                       IF MOVESTATUS."User ID"<>"File Received by" THEN
                       ERROR('You do not have permissions to MOVE the file.');
                       IF CONFIRM('Are You sure you want to move the phisical file to the selected location?')=FALSE THEN
                       EXIT;}
                         {
                       FileMovementTracker.RESET;
                       FileMovementTracker.SETRANGE(FileMovementTracker."Member No.","No.");
                       IF FileMovementTracker.FIND('+') THEN BEGIN
                       IF FileMovementTracker.Stage = "Move to" THEN
                       ERROR('File already in %1',FileMovementTracker.Station);
                        }
                       "File MVT User ID":=USERID;
                       User:=USERID;
                       "File MVT Time":=TIME;
                       "File MVT Date":=TODAY;
                       "File Previous Location":=FORMAT(Filelocc);
                       "Current file location":=Cust."Move to description";
                       "file Received":=FALSE;
                       "File Received by":='';
                       "file received date":=0D;
                       "File received Time":=0T;
                       MODIFY;
                       //"Current file location":="Move to";
                       //MODIFY;


                       ApprovalsSetup.RESET;
                       ApprovalsSetup.SETRANGE(ApprovalsSetup."Approval Type",ApprovalsSetup."Approval Type"::"File Movement");
                       ApprovalsSetup.SETRANGE(ApprovalsSetup.Stage,Cust."Move to");
                       IF ApprovalsSetup.FIND('-') THEN BEGIN





                       FileMovementTracker.RESET;
                       IF FileMovementTracker.FIND('+') THEN BEGIN
                       FileMovementTracker."Current Location":=FALSE;
                       EntryNo:=FileMovementTracker."Entry No.";
                       END;
                       FileMovementTracker.INIT;
                       FileMovementTracker."Entry No.":=EntryNo+1;
                       FileMovementTracker."Member No.":="No.";
                       FileMovementTracker."Approval Type":=ApprovalsSetup."Approval Type";
                       FileMovementTracker.Stage:=ApprovalsSetup.Stage;
                       FileMovementTracker."Current Location":=TRUE;
                       FileMovementTracker.Description:=ApprovalsSetup.Description;
                       FileMovementTracker.Station:=ApprovalsSetup.Station;
                       FileMovementTracker."Date/Time In":=CREATEDATETIME(TODAY,TIME);
                       //FileMovementTracker."Date/Time Out":= CREATEDATETIME(TODAY,TIME);
                       FileMovementTracker."USER ID":=USERID;
                       FileMovementTracker.Remarks:=Cust."File Movement Remarks";
                       FileMovementTracker.INSERT(TRUE);

                       //END;
                       END;

                       UNTIL ApprovalUsers.NEXT=0;
                       END;
                       END;

                       {

                                      Cust."File MVT User ID":=USERID;
                                      Cust."File MVT Time":=TIME;
                                      Cust."File MVT Date":=TODAY;
                                      Cust."File Previous Location":=Cust."Current file location";
                                      Cust."Current file location":=Cust."Move to description";
                                      Cust.MODIFY;
                       MESSAGE('done');



                        MOVESTATUS.RESET;
                         MOVESTATUS.SETRANGE(MOVESTATUS."User ID",USERID);
                          //MOVESTATUS.SETRANGE(MOVESTATUS.Description,"Current file location");
                         IF MOVESTATUS.FIND('-') THEN  BEGIN
                         REPEAT
                        //IF MOVESTATUS.Description<>"Current file location" THEN
                         //ERROR('You do not have permissions to MOVE the file.');



                       IF CONFIRM('Are you sure you want to move the physical file to the selected location?') = FALSE THEN
                       EXIT;



                       FileMovementTracker.RESET;
                       FileMovementTracker.SETRANGE(FileMovementTracker."Member No.","No.");
                       IF FileMovementTracker.FIND('+') THEN BEGIN
                       IF FileMovementTracker.Stage = "Move to" THEN
                       ERROR('File already in %1',FileMovementTracker.Station);
                       END;


                       "File MVT User ID":=USERID;
                       "File MVT Date":=TODAY;
                       "File MVT Time":=TIME;
                       "File Previous Location":="Current file location";
                       "file Received":=FALSE;
                       "file received date":=0D;
                       "File received Time":=0T;
                       "File Received by":='';
                       MODIFY;


                       ApprovalsSetup.RESET;
                       ApprovalsSetup.SETRANGE(ApprovalsSetup."Approval Type",ApprovalsSetup."Approval Type"::"File Movement");
                       ApprovalsSetup.SETRANGE(ApprovalsSetup.Stage,"Move to");
                       IF ApprovalsSetup.FIND('-') THEN BEGIN
                       FileMovementTracker.RESET;
                       IF FileMovementTracker.FIND('+') THEN
                       EntryNo:=FileMovementTracker."Entry No.";


                       FileMovementTracker.INIT;
                       FileMovementTracker."Entry No.":=EntryNo+1;
                       FileMovementTracker."Member No.":="No.";
                       FileMovementTracker."Approval Type":=ApprovalsSetup."Approval Type";
                       FileMovementTracker.Stage:=ApprovalsSetup.Stage;
                       FileMovementTracker."Current Location":=TRUE;
                       FileMovementTracker.Description:=ApprovalsSetup.Description;
                       FileMovementTracker.Station:=ApprovalsSetup.Station;
                       FileMovementTracker."Date/Time In":=CREATEDATETIME(TODAY,TIME);
                       FileMovementTracker."Date/Time Out":=CREATEDATETIME(TODAY,TIME);
                       FileMovementTracker."USER ID":=USERID;
                       FileMovementTracker.Remarks2:="File Movement Remarks";
                       FileMovementTracker.INSERT(TRUE);

                       //END;
                       END ELSE
                         ERROR('SORRY YOU ARE NOT AUTHORISED TO MOVE THIS FILE');

                       UNTIL MOVESTATUS.NEXT=0;
                                END;

                       }
                        */

                    end;
                }
                action("Receive Physical File")
                {
                    ApplicationArea = Basic;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        /*
                        IF Status <> Status::Active THEN
                        ERROR('You cannot receive an inactive file, kindly contact the administrator');
                        
                        
                          Approvals.RESET;
                          Approvals.SETRANGE(Approvals.Stage,"Move to");
                          IF Approvals.FIND('-') THEN BEGIN
                         Description:=Approvals.Description;
                         station:=Approvals.Station;
                        
                          END;
                        
                          ApprovalUsers.RESET;
                          ApprovalUsers.SETRANGE(ApprovalUsers."User ID",USERID);
                        
                          IF NOT ApprovalUsers.FIND('-') THEN BEGIN
                          REPEAT
                         IF ApprovalUsers."User ID" <> USERID THEN
                         ERROR ('You do not have permission to receive a file');
                        
                         UNTIL ApprovalUsers.NEXT=0;
                          END;
                        
                        
                          ApprovalUsers.RESET;
                          ApprovalUsers.SETRANGE(ApprovalUsers."User ID",USERID);
                          ApprovalUsers.SETRANGE(ApprovalUsers."Approval Type",ApprovalUsers."Approval Type"::"File Movement");
                          IF ApprovalUsers.FIND('-') THEN BEGIN
                        
                          REPEAT
                        
                          IF ApprovalUsers.Stage<>"Move to" THEN
                         ERROR('You do not have permissions to Receive this file.');
                        FileMovementTracker.RESET;
                        
                        IF FileMovementTracker.FIND('+') THEN BEGIN
                        FileMovementTracker."Current Location":=FALSE;
                        EntryNo:=FileMovementTracker."Entry No.";
                        END;
                        FileMovementTracker.INIT;
                        FileMovementTracker."Entry No.":=EntryNo+1;
                        FileMovementTracker."Member No.":="No.";
                        //FileMovementTracker."Approval Type":=ApprovalsSetup."Approval Type";
                        FileMovementTracker."Approval Type":=ApprovalUsers."Approval Type";
                        FileMovementTracker.Stage:=ApprovalUsers.Stage;
                        FileMovementTracker."Current Location":=TRUE;
                        FileMovementTracker.Description:=Description;
                        FileMovementTracker.Station:=station;
                        FileMovementTracker."Date/Time In":=CREATEDATETIME(TODAY,TIME);
                        FileMovementTracker."USER ID":=USERID;
                        FileMovementTracker.Remarks:=Cust."File Movement Remarks";
                        FileMovementTracker.INSERT(TRUE);
                        
                        
                        
                         {MOVESTATUS.RESET;
                          MOVESTATUS.SETRANGE(MOVESTATUS."User ID",USERID);
                           //MOVESTATUS.SETRANGE(MOVESTATUS.Description,"Current file location");
                          IF MOVESTATUS.FIND('-') THEN  BEGIN
                          REPEAT
                          IF MOVESTATUS.Description<>"Current file location" THEN
                          //ERROR('You do not have permissions to Receive this file.');
                        
                        
                        MESSAGE('THE FILE HAS BEEN SUCCESSFULLY RECEIVED');
                        UNTIL MOVESTATUS.NEXT=0;
                        END;
                        }
                        
                        
                        IF ("file Received"=TRUE) THEN
                        ERROR('THE FILE HAS  BEEN RECIEVED')
                        ELSE
                        IF CONFIRM('HAVE YOU RECEIVED THE PHISICAL FILE',FALSE)=FALSE THEN
                        EXIT;
                        IF "file Received"=TRUE THEN
                        ERROR('THE FILE HAS  BEEN RECIEVED')
                        ELSE
                        "file Received":=TRUE;
                        "File Received by":=USERID;
                        "file received date":=TODAY;
                        "File received Time":=TIME;
                        "file Received":=TRUE;
                        MODIFY;
                        MODIFY;
                         UNTIL ApprovalUsers.NEXT=0;
                          END;
                         */

                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        FosaName := '';

        // if "FOSA Account" <> '' then begin
        //     if Vend.Get("FOSA Account") then begin
        //         FosaName := Vend.Name;
        //     end;
        // end;

        // lblIDVisible := true;
        // lblDOBVisible := true;
        // lblRegNoVisible := false;
        // lblRegDateVisible := false;
        // lblGenderVisible := true;
        // txtGenderVisible := true;
        // lblMaritalVisible := true;
        // txtMaritalVisible := true;

        // if "Account Category" <> "account category"::SINGLE then begin
        //     lblIDVisible := false;
        //     lblDOBVisible := false;
        //     lblRegNoVisible := true;
        //     lblRegDateVisible := true;
        //     lblGenderVisible := false;
        //     txtGenderVisible := false;
        //     lblMaritalVisible := false;
        //     txtMaritalVisible := false;

        // end;
        OnAfterGetCurrRec;
    end;

    trigger OnFindRecord(Which: Text): Boolean
    var
        RecordFound: Boolean;
    begin
        RecordFound := Rec.Find(Which);
        CurrPage.Editable := RecordFound or (Rec.GetFilter("No.") = '');
        exit(RecordFound);
    end;

    trigger OnInit()
    begin
        txtMaritalVisible := true;
        lblMaritalVisible := true;
        txtGenderVisible := true;
        lblGenderVisible := true;
        lblRegDateVisible := true;
        lblRegNoVisible := true;
        lblDOBVisible := true;
        lblIDVisible := true;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Customer Type" := Rec."customer type"::Member;
        Rec.Status := Rec.Status::Active;
        Rec."Customer Posting Group" := 'BOSA';
        Rec."Registration Date" := Today;
        Rec.Advice := true;
        Rec."Advice Type" := Rec."advice type"::"New Member";
        if GeneralSetup.Get(0) then begin
            Rec."Insurance Contribution" := GeneralSetup."Welfare Contribution";
            Rec."Registration Fee" := GeneralSetup."Registration Fee";

        end;
        OnAfterGetCurrRec;
    end;

    trigger OnOpenPage()
    var
        MapMgt: Codeunit "Online Map Management";
    begin
        ActivateFields;
        /*
        IF NOT MapMgt.TestSetup THEN
          CurrForm.MapPoint.VISIBLE(FALSE);
        */


        StatusPermissions.Reset;
        StatusPermissions.SetRange(StatusPermissions."User Id", UserId);
        StatusPermissions.SetRange(StatusPermissions."Function", StatusPermissions."function"::Edit);
        if StatusPermissions.Find('-') = false then
            Error('You do not have permissions to edit member information.');

    end;

    var
        Text001: label 'Do you want to allow payment tolerance for entries that are currently open?';
        Text002: label 'Do you want to remove payment tolerance from entries that are currently open?';
        CustomizedCalEntry: Record "Customized Calendar Entry";
        CustomizedCalendar: Record "Customized Calendar Change";
        CalendarMgmt: Codeunit "Calendar Management";
        PaymentToleranceMgt: Codeunit "Payment Tolerance Management";
        PictureExists: Boolean;
        GenJournalLine: Record "Gen. Journal Line";
        GLPosting: Codeunit "Gen. Jnl.-Post Line";
        StatusPermissions: Record "Status Change Permision";
        Charges: Record Charges;
        Vend: Record Vendor;
        Cust: Record Customer;
        LineNo: Integer;
        UsersID: Record User;
        GeneralSetup: Record "Sacco General Set-Up";
        Loans: Record "Loans Register";
        AvailableShares: Decimal;
        Gnljnline: Record "Gen. Journal Line";
        Interest: Decimal;
        LineN: Integer;
        LRepayment: Decimal;
        TotalRecovered: Decimal;
        LoanAllocation: Decimal;
        LGurantors: Record "Loans Guarantee Details";
        LoansR: Record "Loans Register";
        DActivity: Code[20];
        DBranch: Code[20];
        Accounts: Record Vendor;
        FosaName: Text[50];
        [InDataSet]
        lblIDVisible: Boolean;
        [InDataSet]
        lblDOBVisible: Boolean;
        [InDataSet]
        lblRegNoVisible: Boolean;
        [InDataSet]
        lblRegDateVisible: Boolean;
        [InDataSet]
        lblGenderVisible: Boolean;
        [InDataSet]
        txtGenderVisible: Boolean;
        [InDataSet]
        lblMaritalVisible: Boolean;
        [InDataSet]
        txtMaritalVisible: Boolean;
        AccNo: Code[20];
        Vendor: Record Vendor;
        TotalAvailable: Decimal;
        TotalFOSALoan: Decimal;
        TotalOustanding: Decimal;
        TotalDefaulterR: Decimal;
        value2: Decimal;
        Value1: Decimal;
        RoundingDiff: Decimal;
        Statuschange: Record "Status Change Permision";
        "WITHDRAWAL FEE": Decimal;
        "AMOUNTTO BE RECOVERED": Decimal;
        "Remaining Amount": Decimal;
        TotalInsuarance: Decimal;
        PrincipInt: Decimal;
        TotalLoansOut: Decimal;
        // FileMovementTracker: Record UnknownRecord51516254;
        EntryNo: Integer;
        ApprovalsSetup: Record "Approvals Users Set Up";
        // MovementTracker: Record UnknownRecord51516253;
        ApprovalUsers: Record "Approvals Users Set Up";
        "Change Log": Integer;
        openf: File;
        //FMTRACK: Record UnknownRecord51516254;
        CurrLocation: Code[30];
        "Number of days": Integer;
        Approvals: Record "Approval Setup";
        Description: Text[30];
        Section: Code[10];
        station: Code[10];


    procedure ActivateFields()
    begin
    end;

    local procedure OnAfterGetCurrRec()
    begin
        xRec := Rec;
        ActivateFields;
    end;
}

