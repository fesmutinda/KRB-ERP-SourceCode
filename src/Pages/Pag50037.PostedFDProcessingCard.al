#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
page 50037 "Posted FD Processing Card"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = Card;
    SourceTable = "FD Processing";
    SourceTableView = where(Posted = const(true));

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = Basic;
                    Caption = 'Document No.';
                }
                field("BOSA Account No"; Rec."BOSA Account No")
                {
                    ApplicationArea = Basic;
                    Caption = 'Member No';
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = Basic;
                    Caption = 'Member Name';
                }
                field("Personal No."; Rec."Personal No.")
                {
                    ApplicationArea = Basic;
                }
                field("ID No."; Rec."ID No.")
                {
                    ApplicationArea = Basic;
                }
                field("Mobile Phone No"; Rec."Mobile Phone No")
                {
                    ApplicationArea = Basic;
                }
                field("Application Date"; Rec."Application Date")
                {
                    ApplicationArea = Basic;
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                }
                field("FDR Deposit Status Type"; Rec."FDR Deposit Status Type")
                {
                    ApplicationArea = Basic;
                }
                field("Date Posted"; Rec."Date Posted")
                {
                    ApplicationArea = Basic;
                }
                field("Account Type"; Rec."Account Type")
                {
                    ApplicationArea = Basic;
                }
                field("Savings Account No."; Rec."Savings Account No.")
                {
                    ApplicationArea = Basic;
                    Caption = 'Current Account No';
                }
                field("Current Account Balance"; Rec."Current Account Balance")
                {
                    ApplicationArea = Basic;
                }
                field("Destination Account"; Rec."Destination Account")
                {
                    ApplicationArea = Basic;
                }
                field("Call Deposit"; Rec."Call Deposit")
                {
                    ApplicationArea = Basic;
                }
                field("User ID"; Rec."User ID")
                {
                    ApplicationArea = Basic;
                }
                field(Posted; Rec.Posted)
                {
                    ApplicationArea = Basic;
                }
            }
            group("Term Deposit Details")
            {
                Caption = 'Term Deposit Details';
                field("Fixed Deposit Status"; Rec."Fixed Deposit Status")
                {
                    ApplicationArea = Basic;
                }
                field("Fixed Deposit Start Date"; Rec."Fixed Deposit Start Date")
                {
                    ApplicationArea = Basic;
                }
                field("Fixed Deposit Type"; Rec."Fixed Deposit Type")
                {
                    ApplicationArea = Basic;
                }
                field("Fixed Duration"; Rec."Fixed Duration")
                {
                    ApplicationArea = Basic;
                }
                field("Interest Earned"; Rec."Interest Earned")
                {
                    ApplicationArea = Basic;
                }
                field("Untranfered Interest"; Rec."Untranfered Interest")
                {
                    ApplicationArea = Basic;
                }
                field("FD Maturity Date"; Rec."FD Maturity Date")
                {
                    ApplicationArea = Basic;
                }
                field("Expected Maturity Date"; Rec."Expected Maturity Date")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Amount to Transfer"; Rec."Amount to Transfer")
                {
                    ApplicationArea = Basic;
                }
                field("Interest rate"; Rec."Interest rate")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Last Interest Earned Date"; Rec."Last Interest Earned Date")
                {
                    ApplicationArea = Basic;
                }
                field("Expected Interest On Term Dep"; Rec."Expected Interest On Term Dep")
                {
                    ApplicationArea = Basic;
                }
                field("On Term Deposit Maturity"; Rec."On Term Deposit Maturity")
                {
                    ApplicationArea = Basic;
                }
            }
            group("Previous Term Deposits")
            {
                Caption = 'Previous Term Deposits';
                field("Prevous Fixed Deposit Type"; Rec."Prevous Fixed Deposit Type")
                {
                    ApplicationArea = Basic;
                }
                field("Prevous FD Start Date"; Rec."Prevous FD Start Date")
                {
                    ApplicationArea = Basic;
                }
                field("Prevous Fixed Duration"; Rec."Prevous Fixed Duration")
                {
                    ApplicationArea = Basic;
                }
                field("Prevous Expected Int On FD"; Rec."Prevous Expected Int On FD")
                {
                    ApplicationArea = Basic;
                }
                field("Prevous FD Maturity Date"; Rec."Prevous FD Maturity Date")
                {
                    ApplicationArea = Basic;
                }
                field("Prevous FD Deposit Status Type"; Rec."Prevous FD Deposit Status Type")
                {
                    ApplicationArea = Basic;
                }
                field("Prevous Interest Rate FD"; Rec."Prevous Interest Rate FD")
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
            action("Print Certificate")
            {
                ApplicationArea = Basic;
                Promoted = true;
                PromotedCategory = "Report";

                trigger OnAction()
                begin
                    FDProcess.Reset;
                    FDProcess.SetRange(FDProcess."Document No.", Rec."Document No.");
                    if FDProcess.Find('-') then
                        Report.Run(51516711, true, false, FDProcess);
                end;
            }
            action("Terminate Term Deposit")
            {
                ApplicationArea = Basic;
                Promoted = true;

                trigger OnAction()
                begin
                    //Transfer Balance if Fixed Deposit

                    Rec.TestField("Fixed Deposit Status", Rec."fixed deposit status"::Active);
                    Rec.TestField("FDR Deposit Status Type", Rec."fdr deposit status type"::Running);

                    AccountTypes.Reset;
                    AccountTypes.SetRange(AccountTypes.Code, Rec."Account Type");
                    if AccountTypes.Find('-') then begin
                        if AccountTypes."Fixed Deposit" = true then begin
                            if Vend.Get(Rec."Destination Account") then begin
                                if Confirm('Are you sure you want to Terminate this Fixed Deposit Contract?', false) = false then
                                    exit;

                                GenJournalLine.Reset;
                                GenJournalLine.SetRange(GenJournalLine."Journal Template Name", 'PURCHASES');
                                GenJournalLine.SetRange(GenJournalLine."Journal Batch Name", 'TERM');
                                if GenJournalLine.Find('-') then
                                    GenJournalLine.DeleteAll;
                                GenSetup.Get();
                                //IF CALCDATE(GenSetup."Min. Member Age","Date of Birth") > TODAY THEN
                                Vend.CalcFields(Vend."Balance (LCY)", "Interest Earned");
                                if (Vend."Balance (LCY)") < Rec."Transfer Amount to Savings" then
                                    Error('Fixed Deposit account does not have enough money to facilate the requested trasfer.');

                                //Transfer Interest from The Payable Account
                                if AccountType.Get(Rec."Account Type") then
                                    LineNo := LineNo + 10000;
                                Rec.CalcFields("Interest Earned");
                                GenJournalLine.Init;
                                GenJournalLine."Journal Template Name" := 'PURCHASES';
                                GenJournalLine."Line No." := LineNo;
                                GenJournalLine."Journal Batch Name" := 'TERM';
                                GenJournalLine."Document No." := Rec."Document No.";
                                GenJournalLine."External Document No." := Rec."Document No.";
                                if CalcDate(AccountType."Minimum Interest Period (M)", Rec."Fixed Deposit Start Date") < Today then begin
                                    GenJournalLine."Account Type" := GenJournalLine."account type"::"G/L Account";
                                    GenJournalLine."Account No." := AccountType."Interest Forfeited Account"
                                end else
                                    GenJournalLine."Account Type" := GenJournalLine."account type"::Vendor;
                                GenJournalLine."Account Type" := GenJournalLine."account type"::Vendor;
                                GenJournalLine."Account No." := Rec."Destination Account";

                                GenJournalLine.Validate(GenJournalLine."Account No.");
                                GenJournalLine."Posting Date" := Today;
                                GenJournalLine.Description := 'Gross Interest Earned';
                                GenJournalLine.Validate(GenJournalLine."Currency Code");
                                GenJournalLine.Amount := (Rec."Interest Earned") * -1;
                                GenJournalLine.Validate(GenJournalLine.Amount);
                                GenJournalLine."Bal. Account Type" := GenJournalLine."bal. account type"::"G/L Account";
                                GenJournalLine."Bal. Account No." := AccountType."Interest Payable Account";
                                if GenJournalLine.Amount <> 0 then
                                    GenJournalLine.Insert;

                                LineNo := LineNo + 10000;
                                Rec.CalcFields("Interest Earned");
                                GenJournalLine.Init;
                                GenJournalLine."Journal Template Name" := 'PURCHASES';
                                GenJournalLine."Line No." := LineNo;
                                GenJournalLine."Journal Batch Name" := 'TERM';
                                GenJournalLine."Document No." := Rec."Document No.";
                                GenJournalLine."External Document No." := Rec."Document No.";
                                GenJournalLine."Account Type" := GenJournalLine."account type"::Vendor;
                                GenJournalLine."Account No." := Rec."Destination Account";
                                GenJournalLine.Validate(GenJournalLine."Account No.");
                                GenJournalLine."Posting Date" := Today;
                                GenJournalLine.Description := 'FD Termination Tranfer';
                                GenJournalLine.Validate(GenJournalLine."Currency Code");
                                if CalcDate(AccountType."Minimum Interest Period (M)", Rec."Fixed Deposit Start Date") < Today then begin
                                    GenJournalLine.Amount := Rec."Amount to Transfer";
                                end else
                                    GenJournalLine.Amount := (Rec."Amount to Transfer" + (Rec."Interest Earned" - (Rec."Interest Earned" * (AccountType."Term terminatination fee" / 100)) - (Rec."Interest Earned" * (GenSetup."Withholding Tax (%)" / 100))));
                                GenJournalLine.Validate(GenJournalLine.Amount);
                                if GenJournalLine.Amount <> 0 then
                                    GenJournalLine.Insert;

                                Rec.CalcFields("Interest Earned");
                                LineNo := LineNo + 10000;

                                GenJournalLine.Init;
                                GenJournalLine."Journal Template Name" := 'PURCHASES';
                                GenJournalLine."Line No." := LineNo;
                                GenJournalLine."Journal Batch Name" := 'TERM';
                                GenJournalLine."Document No." := Rec."Document No.";
                                GenJournalLine."External Document No." := Rec."Document No.";
                                GenJournalLine."Account Type" := GenJournalLine."account type"::Vendor;
                                GenJournalLine."Account No." := Rec."Savings Account No.";
                                GenJournalLine.Validate(GenJournalLine."Account No.");
                                GenJournalLine."Posting Date" := Today;
                                GenJournalLine.Description := 'FD Termination Tranfer';
                                GenJournalLine.Validate(GenJournalLine."Currency Code");
                                if CalcDate(AccountType."Minimum Interest Period (M)", Rec."Fixed Deposit Start Date") < Today then begin
                                    GenJournalLine.Amount := Rec."Amount to Transfer" * -1
                                end else
                                    GenJournalLine.Amount := (Rec."Amount to Transfer" + (Rec."Interest Earned" - (Rec."Interest Earned" * (AccountType."Term terminatination fee" / 100)) - (Rec."Interest Earned" * (GenSetup."Withholding Tax (%)" / 100)))) * -1;
                                GenJournalLine.Validate(GenJournalLine.Amount);
                                if GenJournalLine.Amount <> 0 then
                                    GenJournalLine.Insert;

                                //Transfer Interest to Paying Accout
                                if AccountType.Get(Rec."Account Type") then
                                    LineNo := LineNo + 10000;
                                Rec.CalcFields("Interest Earned");
                                GenJournalLine.Init;
                                GenJournalLine."Journal Template Name" := 'PURCHASES';
                                GenJournalLine."Line No." := LineNo;
                                GenJournalLine."Journal Batch Name" := 'TERM';
                                GenJournalLine."Document No." := Rec."Document No.";
                                GenJournalLine."External Document No." := Rec."Document No.";
                                GenJournalLine."Account Type" := GenJournalLine."account type"::Vendor;
                                GenJournalLine."Account No." := Rec."Destination Account";
                                GenJournalLine.Validate(GenJournalLine."Account No.");
                                GenJournalLine."Posting Date" := Today;
                                GenJournalLine.Description := 'Net Interest Earned';
                                GenJournalLine.Validate(GenJournalLine."Currency Code");
                                GenJournalLine.Amount := Rec."Interest Earned" - (Rec."Interest Earned" * (AccountType."Term terminatination fee" / 100)) - (Rec."Interest Earned" * (GenSetup."Withholding Tax (%)" / 100));
                                GenJournalLine.Validate(GenJournalLine.Amount);
                                //GenJournalLine."Bal. Account Type":=GenJournalLine."Bal. Account Type"::Vendor;
                                //GenJournalLine."Bal. Account No.":="Savings Account No.";
                                if GenJournalLine.Amount <> 0 then
                                    GenJournalLine.Insert;

                                LineNo := LineNo + 10000;
                                if AccountType.Get(Rec."Account Type") then
                                    LineNo := LineNo + 10000;
                                Rec.CalcFields("Interest Earned");
                                GenJournalLine.Init;
                                GenJournalLine."Journal Template Name" := 'PURCHASES';
                                GenJournalLine."Line No." := LineNo;
                                GenJournalLine."Journal Batch Name" := 'TERM';
                                GenJournalLine."Document No." := Rec."Document No.";
                                GenJournalLine."External Document No." := Rec."Document No.";
                                GenJournalLine."Account Type" := GenJournalLine."account type"::Vendor;
                                GenJournalLine."Account No." := Rec."Savings Account No.";
                                GenJournalLine.Validate(GenJournalLine."Account No.");
                                GenJournalLine."Posting Date" := Today;
                                GenJournalLine.Description := 'Net Interest Earned';
                                GenJournalLine.Validate(GenJournalLine."Currency Code");
                                GenJournalLine.Amount := (Rec."Interest Earned" - (Rec."Interest Earned" * (AccountType."Term terminatination fee" / 100)) - (Rec."Interest Earned" * (GenSetup."Withholding Tax (%)" / 100))) * -1;
                                GenJournalLine.Validate(GenJournalLine.Amount);
                                //GenJournalLine."Bal. Account Type":=GenJournalLine."Bal. Account Type"::Vendor;
                                //GenJournalLine."Bal. Account No.":="Savings Account No.";
                                if GenJournalLine.Amount <> 0 then
                                    GenJournalLine.Insert;

                                //End Transfer Interest to Paying Account

                                LineNo := LineNo + 10000;

                                if AccountType.Get(Rec."Account Type") then begin
                                    //IF CALCDATE(AccountType."Minimum Interest Period (M)","Fixed Deposit Start Date") > TODAY THEN BEGIN
                                    Rec.CalcFields("Interest Earned");
                                    GenJournalLine.Init;
                                    GenJournalLine."Journal Template Name" := 'PURCHASES';
                                    GenJournalLine."Line No." := LineNo;
                                    GenJournalLine."Journal Batch Name" := 'TERM';
                                    GenJournalLine."Document No." := Rec."Document No.";
                                    GenJournalLine."External Document No." := Rec."Document No.";
                                    GenJournalLine."Account Type" := GenJournalLine."account type"::"G/L Account";
                                    GenJournalLine."Account No." := AccountType."Term Termination Account";
                                    GenJournalLine.Validate(GenJournalLine."Account No.");
                                    GenJournalLine."Posting Date" := Today;
                                    GenJournalLine.Description := 'FD Termination Charge';
                                    GenJournalLine.Validate(GenJournalLine."Currency Code");
                                    GenJournalLine.Amount := (Rec."Interest Earned" * (AccountType."Term terminatination fee" / 100)) * -1;
                                    GenJournalLine.Validate(GenJournalLine.Amount);
                                    GenJournalLine."Bal. Account Type" := GenJournalLine."bal. account type"::Vendor;
                                    GenJournalLine."Bal. Account No." := Rec."Destination Account";
                                    if GenJournalLine.Amount <> 0 then
                                        GenJournalLine.Insert;
                                    //END;


                                    //IF CALCDATE(AccountType."Minimum Interest Period (M)","Fixed Deposit Start Date") > TODAY THEN BEGIN
                                    LineNo := LineNo + 10000;
                                    //Withholding Tax
                                    GenJournalLine.Init;
                                    GenJournalLine."Journal Template Name" := 'PURCHASES';
                                    GenJournalLine."Line No." := LineNo;
                                    GenJournalLine."Journal Batch Name" := 'TERM';
                                    GenJournalLine."Document No." := Rec."Document No.";
                                    GenJournalLine."External Document No." := Rec."Document No.";
                                    GenJournalLine."Account Type" := GenJournalLine."account type"::"G/L Account";
                                    GenJournalLine."Account No." := GenSetup."WithHolding Tax Account";
                                    GenJournalLine.Validate(GenJournalLine."Account No.");
                                    GenJournalLine."Posting Date" := Today;
                                    GenJournalLine.Description := 'Withholding Tax';
                                    GenJournalLine.Validate(GenJournalLine."Currency Code");
                                    GenJournalLine.Amount := (Rec."Interest Earned" * (GenSetup."Withholding Tax (%)" / 100)) * -1;
                                    GenJournalLine.Validate(GenJournalLine.Amount);
                                    GenJournalLine."Bal. Account Type" := GenJournalLine."bal. account type"::Vendor;
                                    GenJournalLine."Bal. Account No." := Rec."Destination Account";
                                    if GenJournalLine.Amount <> 0 then
                                        GenJournalLine.Insert;
                                    //END;
                                end;
                            end;
                        end;
                    end;

                    GenJournalLine.Reset;
                    GenJournalLine.SetRange("Journal Template Name", 'PURCHASES');
                    GenJournalLine.SetRange("Journal Batch Name", 'TERM');
                    if GenJournalLine.Find('-') then begin
                        repeat
                            Codeunit.Run(Codeunit::"Gen. Jnl.-Post Sacco", GenJournalLine);
                        until GenJournalLine.Next = 0;
                    end;

                    /*
                    GenJournalLine.RESET;
                    GenJournalLine.SETRANGE("Journal Template Name",'PURCHASES');
                    GenJournalLine.SETRANGE("Journal Batch Name",'TERM');
                    GenJournalLine.DELETEALL;
                    */

                    InterestBuffer.Reset;
                    InterestBuffer.SetRange(InterestBuffer."Account No", Rec."Destination Account");
                    if InterestBuffer.Find('-') then
                        InterestBuffer.ModifyAll(InterestBuffer.Transferred, true);

                    Rec."FDR Deposit Status Type" := Rec."fdr deposit status type"::Terminated;
                    Rec."Fixed Deposit Status" := Rec."fixed deposit status"::Closed;
                    Rec.Posted := true;
                    Rec."Date Posted" := Today;
                    Rec.Modify;
                    Message('Amount transfered successfully back to the savings Account.');



                    /*
                   //Renew Fixed deposit - OnAction()

                   IF AccountTypes.GET("Account Type") THEN BEGIN
                   IF AccountTypes."Fixed Deposit" = TRUE THEN BEGIN
                   IF CONFIRM('Are you sure you want to renew the fixed deposit.',FALSE) = FALSE THEN
                   EXIT;

                   TESTFIELD("FD Maturity Date");
                   IF FDType.GET("Fixed Deposit Type") THEN BEGIN
                   "FD Maturity Date":=CALCDATE(FDType.Duration,"FD Maturity Date");
                   "Date Renewed":=TODAY;
                   "FDR Deposit Status Type":="FDR Deposit Status Type"::Renewed;
                   MODIFY;

                   MESSAGE('Fixed deposit renewed successfully');
                   END;
                   END;
                   END;
                     */

                end;
            }
        }
    }

    var
        FDProcess: Record 51435;
        CalendarMgmt: Codeunit "Calendar Management";
        PaymentToleranceMgt: Codeunit "Payment Tolerance Management";
        CustomizedCalEntry: Record "Customized Calendar Entry";
        CustomizedCalendar: Record "Customized Calendar Change";
        PictureExists: Boolean;
        AccountTypes: Record 51436;
        GenJournalLine: Record "Gen. Journal Line";
        GLPosting: Codeunit "Gen. Jnl.-Post Line";
        StatusPermissions: Record 51452;
        Charges: Record 51439;
        ForfeitInterest: Boolean;
        InterestBuffer: Record 51467;
        FDType: Record 51447;
        Vend: Record Vendor;
        Cust: Record Customer;
        LineNo: Integer;
        UsersID: Record User;
        DActivity: Code[20];
        DBranch: Code[20];
        MinBalance: Decimal;
        OBalance: Decimal;
        OInterest: Decimal;
        Gnljnline: Record "Gen. Journal Line";
        TotalRecovered: Decimal;
        LoansR: Record 51371;
        LoanAllocation: Decimal;
        LGurantors: Record 51462;
        Loans: Record 51371;
        DefaulterType: Code[20];
        LastWithdrawalDate: Date;
        AccountType: Record 51436;
        ReplCharge: Decimal;
        Acc: Record Vendor;
        SearchAcc: Code[10];
        Searchfee: Decimal;
        Statuschange: Record 51452;
        UnclearedLoan: Decimal;
        LineN: Integer;
        Joint2DetailsVisible: Boolean;
        Joint3DetailsVisible: Boolean;
        GenSetup: Record 51398;
        TerminateTxt: label 'The Term Deposit Has Already Been Terminated';


    procedure UpdateControls()
    begin

        if Rec.Posted = true then begin
            //      NameEditable:=FALSE;
            //      NoEditable:=FALSE;
            //      AddressEditable:=FALSE;
            //      GlobalDim1Editable:=FALSE;
            //      GlobalDim2Editable:=FALSE;
            //      VendorPostingGroupEdit:=FALSE;
            //      PhoneEditable:=FALSE;
            //      MaritalstatusEditable:=FALSE;
            //      IDNoEditable:=FALSE;
            //      PhoneEditable:=FALSE;
            //      RegistrationDateEdit:=FALSE;
            //      //OfficeBranchEditable:=FALSE;
            //      //DeptEditable:=FALSE;
            //      //SectionEditable:=FALSE;
            //      //OccupationEditable:=FALSE;
            //      //DesignationEdiatble:=FALSE;
            //      EmployerCodeEditable:=FALSE;
            //      DOBEditable:=FALSE;
            //      EmailEdiatble:=FALSE;
            //      StaffNoEditable:=FALSE;
            //      GenderEditable:=FALSE;
            //      MonthlyContributionEdit:=FALSE;
            //      PostCodeEditable:=FALSE;
            //      CityEditable:=FALSE;
            //      //WitnessEditable:=FALSE;
            //      //BankCodeEditable:=FALSE;
            //      //BranchCodeEditable:=FALSE;
            //      //BankAccountNoEditable:=FALSE;
            //      //VillageResidence:=FALSE;
            //      //TitleEditable:=FALSE;
            //      //PostalCodeEditable:=FALSE;
            //      //HomeAddressPostalCodeEditable:=FALSE;
            //      //HomeTownEditable:=FALSE;
            //      RecruitedEditable:=FALSE;
            //      ContactPEditable:=FALSE;
            //      ContactPRelationEditable:=FALSE;
            //      ContactPOccupationEditable:=FALSE;
            //      //CopyOFIDEditable:=FALSE;
            //      //CopyofPassportEditable:=FALSE;
            //      //SpecimenEditable:=FALSE;
            //      ContactPPhoneEditable:=FALSE;
            //      //HomeAdressEditable:=FALSE;
            //      //PictureEditable:=FALSE;
            //      //SignatureEditable:=FALSE;
            //      Accountype:=TRUE;
            //
            //      END;
            //
            //
            //      IF Status=Status::Open THEN BEGIN
            //      NameEditable:=TRUE;
            //      NoEditable:=TRUE;
            //      AddressEditable:=TRUE;
            //      GlobalDim1Editable:=TRUE;
            //      GlobalDim2Editable:=TRUE;
            //      VendorPostingGroupEdit:=TRUE;
            //      PhoneEditable:=TRUE;
            //      MaritalstatusEditable:=TRUE;
            //      IDNoEditable:=TRUE;
            //      PhoneEditable:=TRUE;
            //      RegistrationDateEdit:=TRUE;
            //      //OfficeBranchEditable:=FALSE;
            //      //DeptEditable:=FALSE;
            //      //SectionEditable:=FALSE;
            //      //OccupationEditable:=FALSE;
            //      //DesignationEdiatble:=FALSE;
            //      EmployerCodeEditable:=TRUE;
            //      DOBEditable:=TRUE;
            //      EmailEdiatble:=TRUE;
            //      StaffNoEditable:=TRUE;
            //      GenderEditable:=TRUE;
            //      MonthlyContributionEdit:=TRUE;
            //      PostCodeEditable:=TRUE;
            //      CityEditable:=TRUE;
            //      Accountype:=TRUE;
            //      //WitnessEditable:=FALSE;
            //      //BankCodeEditable:=FALSE;
            //      //BranchCodeEditable:=FALSE;
            //      //BankAccountNoEditable:=FALSE;
            //      //VillageResidence:=FALSE;
            //      //TitleEditable:=FALSE;
            //      //PostalCodeEditable:=FALSE;
            //      //HomeAddressPostalCodeEditable:=FALSE;
            //      //HomeTownEditable:=FALSE;
            //      RecruitedEditable:=TRUE;
            //      ContactPEditable:=TRUE;
            //      ContactPRelationEditable:=TRUE;
            //      ContactPOccupationEditable:=TRUE;
            //      //CopyOFIDEditable:=FALSE;
            //      //CopyofPassportEditable:=FALSE;
            //      //SpecimenEditable:=FALSE;
            //      ContactPPhoneEditable:=TRUE;
            //      //HomeAdressEditable:=FALSE;
            //      //PictureEditable:=FALSE;
            //      //SignatureEditable:=FALSE;
            //
            //      END;
        end;
    end;
}

