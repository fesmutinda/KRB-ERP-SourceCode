#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
page 50841 "Change Request Card"
{
    PageType = Card;
    SourceTable = 51552;

    layout
    {
        area(content)
        {
            group(General)
            {
                field(No; Rec.No)
                {
                    ApplicationArea = Basic;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = Basic;
                    Editable = TypeEditable;

                    trigger OnValidate()
                    begin
                        AccountVisible := false;
                        MobileVisible := false;
                        nxkinvisible := false;

                        if Rec.Type = Rec.Type::"Mobile Change" then begin
                            MobileVisible := true;
                        end;

                        if Rec.Type = Rec.Type::"ATM Change" then begin
                            AccountVisible := true;
                            nxkinvisible := true;
                        end;

                        if Rec.Type = Rec.Type::"Backoffice Change" then begin
                            AccountVisible := true;
                            nxkinvisible := true;
                        end;
                    end;
                }
                field("Account No"; Rec."Account No")
                {
                    ApplicationArea = Basic;
                    Editable = AccountNoEditable;
                }
                field("Captured by"; Rec."Captured by")
                {
                    ApplicationArea = Basic;
                }
                field("Capture Date"; Rec."Capture Date")
                {
                    ApplicationArea = Basic;
                }
                field("Approved by"; Rec."Approved by")
                {
                    ApplicationArea = Basic;
                }
                field("Approval Date"; Rec."Approval Date")
                {
                    ApplicationArea = Basic;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                }
                field("Reason for change"; Rec."Reason for change")
                {
                    ApplicationArea = Basic;
                    ShowMandatory = true;
                }
            }
            group(Mobile)
            {
                Caption = 'Phone No Details';
                Visible = Mobilevisible;
                field("Mobile No"; Rec."Mobile No")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Mobile No(New Value)"; Rec."Mobile No(New Value)")
                {
                    ApplicationArea = Basic;
                    Caption = 'Mobile No(New Value)';
                    Editable = MobileNoEditable;
                }
                field("S-Mobile No"; Rec."S-Mobile No")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("S-Mobile No(New Value)"; Rec."S-Mobile No(New Value)")
                {
                    ApplicationArea = Basic;
                    Caption = 'S-Mobile No(New Value)';
                    Editable = SMobileNoEditable;
                }
            }
            group("Atm Details")
            {
                Caption = 'ATM Card Details';
                Visible = Atmvisible;
                field("ATM Approve"; Rec."ATM Approve")
                {
                    ApplicationArea = Basic;
                    Editable = ATMApproveEditable;
                }
                field("Card Expiry Date"; Rec."Card Expiry Date")
                {
                    ApplicationArea = Basic;
                    Editable = CardExpiryDateEditable;
                }
                field("Card Valid From"; Rec."Card Valid From")
                {
                    ApplicationArea = Basic;
                    Editable = CardValidFromEditable;
                }
                field("Card Valid To"; Rec."Card Valid To")
                {
                    ApplicationArea = Basic;
                    Editable = CardValidToEditable;
                }
                field("Date ATM Linked"; Rec."Date ATM Linked")
                {
                    ApplicationArea = Basic;
                }
                field("ATM No."; Rec."ATM No.")
                {
                    ApplicationArea = Basic;
                    Editable = ATMNOEditable;
                }
                field("ATM Issued"; Rec."ATM Issued")
                {
                    ApplicationArea = Basic;
                    Editable = ATMIssuedEditable;
                }
                field("ATM Self Picked"; Rec."ATM Self Picked")
                {
                    ApplicationArea = Basic;
                    Editable = ATMSelfPickedEditable;
                }
                field("ATM Collector Name"; Rec."ATM Collector Name")
                {
                    ApplicationArea = Basic;
                    Editable = ATMCollectorNameEditable;
                }
                field("ATM Collectors ID"; Rec."ATM Collectors ID")
                {
                    ApplicationArea = Basic;
                    Editable = ATMCollectorIDEditable;
                }
                field("Atm Collectors Moile"; Rec."Atm Collectors Moile")
                {
                    ApplicationArea = Basic;
                    Editable = ATMCollectorMobileEditable;
                }
                field("Responsibility Centers"; Rec."Responsibility Centers")
                {
                    ApplicationArea = Basic;
                    Editable = ResponsibilityCentreEditable;
                }
            }
            group("Account Info")
            {
                Caption = 'Account Details';
                Visible = Accountvisible;
                field(Name; Rec.Name)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Name(New Value)"; Rec."Name(New Value)")
                {
                    ApplicationArea = Basic;
                    Caption = 'Name(New Value)';
                    Editable = NameEditable;
                }
                field(Picture; Rec.Picture)
                {
                    ApplicationArea = Basic;
                    Editable = PictureEditable;
                }
                field(signinature; Rec.signinature)
                {
                    ApplicationArea = Basic;
                    Editable = SignatureEditable;
                }
                field(Address; Rec.Address)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Address(New Value)"; Rec."Address(New Value)")
                {
                    ApplicationArea = Basic;
                    Caption = 'Address(New Value)';
                    Editable = AddressEditable;
                }
                field(City; Rec.City)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("City(New Value)"; Rec."City(New Value)")
                {
                    ApplicationArea = Basic;
                    Caption = 'City(New Value)';
                    Editable = CityEditable;
                }
                field("E-mail"; Rec."E-mail")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Email(New Value)"; Rec."Email(New Value)")
                {
                    ApplicationArea = Basic;
                    Caption = 'Email(New Value)';
                    Editable = EmailEditable;
                }
                field("Personal No"; Rec."Personal No")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Personal No(New Value)"; Rec."Personal No(New Value)")
                {
                    ApplicationArea = Basic;
                    Caption = 'Personal No(New Value)';
                    Editable = PersonalNoEditable;
                }
                field("ID No"; Rec."ID No")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("ID No(New Value)"; Rec."ID No(New Value)")
                {
                    ApplicationArea = Basic;
                    Caption = 'ID No(New Value)';
                    Editable = IDNoEditable;
                }
                field("Marital Status"; Rec."Marital Status")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Marital Status(New Value)"; Rec."Marital Status(New Value)")
                {
                    ApplicationArea = Basic;
                    Caption = 'Marital Status(New Value)';
                    Editable = MaritalStatusEditable;
                    ToolTip = 'Please enter your marital status';
                }
                field("Passport No."; Rec."Passport No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Passport No.(New Value)"; Rec."Passport No.(New Value)")
                {
                    ApplicationArea = Basic;
                    Caption = 'Passport No.(New Value)';
                    Editable = PassPortNoEditbale;
                }
                field("Account Type"; Rec."Account Type")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Account Type(New Value)"; Rec."Account Type(New Value)")
                {
                    ApplicationArea = Basic;
                    Caption = 'Account Type(New Value)';
                    Editable = AccountTypeEditible;
                }
                field("Account Category"; Rec."Account Category")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Account Category(New Value)"; Rec."Account Category(New Value)")
                {
                    ApplicationArea = Basic;
                    Caption = 'Account Category(New Value)';
                    Editable = AccountCategoryEditable;
                }
                field(Section; Rec.Section)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Section(New Value)"; Rec."Section(New Value)")
                {
                    ApplicationArea = Basic;
                    Caption = 'Section(New Value)';
                    Editable = SectionEditable;
                }
                field("Card No"; Rec."Card No")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Card No(New Value)"; Rec."Card No(New Value)")
                {
                    ApplicationArea = Basic;
                    Caption = 'Card No(New Value)';
                    Editable = CardNoEditable;
                }
                field("Home Address"; Rec."Home Address")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Home Address(New Value)"; Rec."Home Address(New Value)")
                {
                    ApplicationArea = Basic;
                    Caption = 'Home Address(New Value)';
                    Editable = HomeAddressEditable;
                }
                field(Loaction; Rec.Loaction)
                {
                    ApplicationArea = Basic;
                    Caption = '<Locaction>';
                    Editable = false;
                }
                field("Loaction(New Value)"; Rec."Loaction(New Value)")
                {
                    ApplicationArea = Basic;
                    Caption = 'Location(New Value)';
                    Editable = LocationEditable;
                }
                field("Sub-Location"; Rec."Sub-Location")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Sub-Location(New Value)"; Rec."Sub-Location(New Value)")
                {
                    ApplicationArea = Basic;
                    Caption = 'Sub-Location(New Value)';
                    Editable = SubLocationEditable;
                }
                field(District; Rec.District)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("District(New Value)"; Rec."District(New Value)")
                {
                    ApplicationArea = Basic;
                    Caption = 'District(New Value)';
                    Editable = DistrictEditable;
                }
                field("Status."; Rec."Status.")
                {
                    ApplicationArea = Basic;
                }
                field("Status.(New)"; Rec."Status.(New)")
                {
                    ApplicationArea = Basic;
                }
                field("Employer Code"; Rec."Employer Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Employer Code(New)"; Rec."Employer Code(New)")
                {
                    ApplicationArea = Basic;
                }
                field(Blocked; Rec.Blocked)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    OptionCaption = ' ,Payment,All';
                }
                field("Blocked (New)"; Rec."Blocked (New)")
                {
                    ApplicationArea = Basic;
                    OptionCaption = ' ,Payment,All';
                }
                field("Charge Reactivation Fee"; Rec."Charge Reactivation Fee")
                {
                    ApplicationArea = Basic;
                    Editable = ReactivationFeeEditable;
                }
                field("Signing Instructions"; Rec."Signing Instructions")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Retirement Date"; Rec."Retirement Date")
                {
                    ApplicationArea = Basic;
                    Editable = RetirementDateEditable;
                }
                field("Retirement Date(New)"; Rec."Retirement Date(New)")
                {
                    ApplicationArea = Basic;
                }
                field("Signing Instructions(NewValue)"; Rec."Signing Instructions(NewValue)")
                {
                    ApplicationArea = Basic;
                    Caption = 'Signing Instructions(New Value)';
                    Editable = SigningInstructionEditable;
                }
                field("Monthly Contributions"; Rec."Monthly Contributions")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Monthly Contributions(NewValu)"; Rec."Monthly Contributions(NewValu)")
                {
                    ApplicationArea = Basic;
                    Caption = 'Monthly Contributions(New Value)';
                    Editable = MonthlyContributionEditable;
                }
                field("Member Cell Group"; Rec."Member Cell Group")
                {
                    ApplicationArea = Basic;
                    Editable = MemberCellEditable;
                }
                field("Group Account No"; Rec."Group Account No")
                {
                    ApplicationArea = Basic;
                }
                field("Group Account Name"; Rec."Group Account Name")
                {
                    ApplicationArea = Basic;
                }
                field("Phone No.(Old)"; Rec."Phone No.(Old)")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(pin; Rec.pin)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("pin new"; Rec.pin2)
                {
                    ApplicationArea = Basic;
                }
                field("bank accno"; Rec."bank accno")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("BANK accno New"; Rec.bankacc1)
                {
                    ApplicationArea = Basic;
                }
                field("Bank code"; Rec."Bank code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Bank code (new)"; Rec.bankcode1)
                {
                    ApplicationArea = Basic;
                }
                field("Phone No.(New)"; Rec."Phone No.(New)")
                {
                    ApplicationArea = Basic;
                    Editable = true;
                }
            }
        }
        area(factboxes)
        {
            part(Control1000000082; "Member Picture-Change Req")
            {
                Caption = 'Picture';
                Visible = false;
            }
            part(Control1000000083; "Member Signature-Change Req")
            {
                Caption = 'Signature';
                Visible = false;
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Update Changes")
            {
                ApplicationArea = Basic;
                Caption = 'Update Changes';
                Image = UserInterface;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedOnly = true;

                trigger OnAction()
                begin
                    if (Rec.Status <> Rec.Status::Approved) then begin
                        Error('Change Request Must be Approved First');
                    end;
                    if ((Rec.Type = Rec.Type::"Mobile Change") or (Rec.Type = Rec.Type::"ATM Change") or (Rec.Type = Rec.Type::"Agile Change") or (Rec.Type = Rec.Type::"Backoffice Change")) then begin

                        vend.Reset;
                        vend.SetRange(vend."No.", Rec."Account No");
                        if vend.Find('-') then begin
                            if Rec."Name(New Value)" <> '' then
                                vend.Name := Rec."Name(New Value)";
                            vend."Global Dimension 2 Code" := Rec.Branch;
                            if Rec."Address(New Value)" <> '' then
                                vend.Address := Rec."Address(New Value)";

                            if Rec."Email(New Value)" <> '' then
                                vend."E-Mail" := Rec."Email(New Value)";
                            vend."E-Mail (Personal)" := Rec."Email(New Value)";
                            vend.Status := Rec."Status (New Value)";
                            if Rec."Mobile No(New Value)" <> '' then
                                vend."Mobile Phone No" := Rec."Mobile No(New Value)";
                            vend."Mobile Phone No" := Memb."Mobile Phone No";
                            vend."Phone No." := Rec."Mobile No(New Value)";
                            if Rec."S-Mobile No(New Value)" <> '' then
                                vend."S-Mobile No" := Rec."S-Mobile No(New Value)";
                            if Rec."ATM Collector Name" <> '' then
                                vend."ATM Collector Name" := Rec."ATM Collector Name";
                            if Rec."ID No(New Value)" <> '' then
                                vend."ID No." := Rec."ID No(New Value)";
                            if Rec."Personal No(New Value)" <> '' then
                                vend."Personal No." := Rec."Personal No(New Value)";
                            if Rec."City(New Value)" <> '' then
                                vend.City := Rec."City(New Value)";
                            if Rec."Section(New Value)" <> '' then
                                vend.Section := Rec."Section(New Value)";
                            if Rec."Card Expiry Date" <> 0D then
                                vend."Card Expiry Date" := Rec."Card Expiry Date";
                            if Rec."Card No(New Value)" <> '' then
                                vend."Card No." := Rec."Card No(New Value)";
                            if Rec."Card No(New Value)" <> '' then
                                vend."ATM No." := Rec."Card No(New Value)";
                            if Rec."Card Valid From" <> 0D then
                                vend."Card Valid From" := Rec."Card Valid From";
                            if Rec."Card Valid To" <> 0D then
                                vend."Card Valid To" := Rec."Card Valid To";
                            if Rec."Marital Status(New Value)" <> Rec."marital status(new value)"::" " then
                                vend."Marital Status" := Rec."Marital Status(New Value)";
                            if Rec."Responsibility Centers" <> '' then
                                vend."Responsibility Center" := Rec."Responsibility Centers";
                            if Rec."Phone No.(New)" <> '' then
                                vend."Phone No." := Rec."Phone No.(New)";
                            vend."Phone No." := Rec."Mobile No(New Value)";
                            vend.Blocked := Rec."Blocked (New)";
                            vend.Status := Rec."Status.(New)";
                            vend.Modify;
                            /*
                         IF (Type=Type::"Agile Change") THEN BEGIN
                            ProductNxK.RESET;
                            ProductNxK.SETRANGE(ProductNxK."Account No","Account No");
                            IF ProductNxK.FIND('-') THEN

                             REPEAT;

                              ProductNxK.Name:= Kinchangedetails.Name;
                              ProductNxK.Relationship:=Kinchangedetails.Relationship;
                              ProductNxK.Beneficiary:=Kinchangedetails.Beneficiary;
                              ProductNxK."Date of Birth":=Kinchangedetails."Date of Birth";
                              ProductNxK.Address:=Kinchangedetails.Address;
                              ProductNxK.Telephone:=Kinchangedetails.Telephone;
                              //ProductNxK.Fax:=Kinchangedetails.Fax;
                              ProductNxK.Email:=Kinchangedetails.Email;
                              ProductNxK."ID No.":=Kinchangedetails."ID No.";
                              ProductNxK."%Allocation":=Kinchangedetails."%Allocation";
                              ProductNxK.MODIFY;

                             UNTIL ProductNxK.NEXT=0;

                             END
                       */
                        end;
                    end;


                    if Rec.Type = Rec.Type::"Backoffice Change" then begin
                        Memb.Reset;
                        Memb.SetRange(Memb."No.", Rec."Account No");
                        if Memb.Find('-') then begin
                            if Rec."Name(New Value)" <> '' then
                                Memb.Name := Rec."Name(New Value)";
                            Memb."Global Dimension 2 Code" := Rec.Branch;
                            if Rec."Address(New Value)" <> '' then
                                Memb.Address := Rec."Address(New Value)";
                            if Rec."Email(New Value)" <> '' then
                                Memb."E-Mail" := Rec."Email(New Value)";
                            Memb."E-Mail (Personal)" := Rec."Email(New Value)";
                            if Rec."Mobile No(New Value)" <> '' then
                                Memb."Mobile Phone No" := Rec."Mobile No(New Value)";
                            if Rec."Retirement Date(New)" <> 0D then
                                Memb."Retirement Date" := Rec."Retirement Date(New)";
                            if Rec."Phone No.(New)" <> '' then
                                Memb."Mobile Phone No" := Rec."Phone No.(New)";
                            Memb."Phone No." := Rec."Phone No.(New)";
                            if Rec."ID No(New Value)" <> '' then
                                Memb."ID No." := Rec."ID No(New Value)";
                            if Rec."Personal No(New Value)" <> '' then begin
                                Memb."Personal No" := Rec."Personal No(New Value)";
                                Memb.Validate("Personal No");
                            end;
                            if Rec."City(New Value)" <> '' then
                                Memb.City := Rec."City(New Value)";
                            Memb.Status := Rec."Status(New Value)";
                            if Rec."Section(New Value)" <> '' then
                                Memb.Section := Rec."Section(New Value)";
                            Memb.Blocked := Rec."Blocked (New)";
                            if Rec."Marital Status(New Value)" <> Rec."marital status(new value)"::" " then
                                Memb."Marital Status" := Rec."Marital Status(New Value)";
                            if Rec."Responsibility Centers" <> '' then
                                Memb."Responsibility Center" := Rec."Responsibility Centers";
                            if Rec."Group Account No" <> '' then
                                Memb."Group Account No" := Rec."Group Account No";
                            if Rec.pin2 <> '' then
                                Memb.Pin := Rec.pin2;
                            if Rec.bankacc1 <> '' then
                                Memb."Bank Account No." := Rec.bankacc1;
                            if Rec.bankcode1 <> '' then
                                Memb."Bank Code" := Rec.bankcode1;
                            //Memb."Retirement Date":=ret;
                            if Rec."Group Account Name" <> '' then
                                Memb."Group Account Name" := Rec."Group Account Name";
                            if Rec."Employer Code(New)" <> '' then
                                Memb."Employer Code" := Rec."Employer Code(New)";
                            Memb.Image := Rec."Picture.";
                            Memb.Status := Rec."Status.(New)";
                            Memb.Modify;

                            if Rec."Charge Reactivation Fee" = true then begin
                                if Confirm('The System Is going to Charge Reactivation Fee', false) = true then begin
                                    GenSetUp.Get();
                                    GenJournalLine.Reset;
                                    GenJournalLine.SetRange(GenJournalLine."Journal Template Name", 'PURCHASES');
                                    GenJournalLine.SetRange(GenJournalLine."Journal Batch Name", 'FTRANS');
                                    if GenJournalLine.FindSet then begin
                                        GenJournalLine.DeleteAll;
                                    end;

                                    LineNo := LineNo + 10000;
                                    GenJournalLine.Reset;
                                    GenJournalLine.SetRange("Journal Template Name", 'PURCHASES');
                                    GenJournalLine.SetRange("Journal Batch Name", 'FTRANS');
                                    GenJournalLine.DeleteAll;

                                    GenJournalLine.Init;
                                    GenJournalLine."Journal Template Name" := 'PURCHASES';
                                    GenJournalLine."Journal Batch Name" := 'FTRANS';
                                    GenJournalLine."Line No." := GenJournalLine."Line No." + 1000;
                                    GenJournalLine."Account Type" := GenJournalLine."account type"::Customer;
                                    GenJournalLine."Account No." := Rec."Account No";
                                    GenJournalLine."Transaction Type" := GenJournalLine."transaction type"::Loan;
                                    GenJournalLine."Posting Date" := Today;
                                    GenJournalLine."Document No." := Rec.No;
                                    GenJournalLine.Description := 'Account Reactivation Fee' + ' ' + Rec.No;
                                    GenJournalLine.Amount := GenSetUp."Rejoining Fee";
                                    GenJournalLine."Bal. Account Type" := GenJournalLine."bal. account type"::"G/L Account";
                                    GenJournalLine."Bal. Account No." := GenSetUp."Rejoining Fees Account";
                                    GenJournalLine."Shortcut Dimension 1 Code" := 'BOSA';
                                    GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 1 Code");
                                    if GenJournalLine.Amount <> 0 then
                                        GenJournalLine.Insert;

                                    GenJournalLine.Reset;
                                    GenJournalLine.SetRange(GenJournalLine."Journal Template Name", 'PURCHASES');
                                    GenJournalLine.SetRange(GenJournalLine."Journal Batch Name", 'FTRANS');
                                    if GenJournalLine.FindSet then begin
                                        Codeunit.Run(Codeunit::"Gen. Jnl.-Post", GenJournalLine);
                                    end;
                                    Message('Reactivation Fee Charged Successfuly');
                                end;
                            end;



                        end;

                    end;

                    Rec.Changed := true;
                    Rec.Modify;
                    Message('Changes have been updated Successfully');

                end;
            }
            action("Send Approval Request")
            {
                ApplicationArea = Basic;
                Caption = 'Send A&pproval Request';
                Image = SendApprovalRequest;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedOnly = true;

                trigger OnAction()
                var
                    text001: label 'This batch is already pending approval';
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    SrestepApprovalsCodeUnit: codeunit SurestepApprovalsCodeUnit;

                begin

                    if Rec.Status <> Rec.Status::Open then
                        Error(text001);
                    Rec.TestField("Reason for change");
                    //if ApprovalsMgmt.CheckChangeRequestApprovalsWorkflowEnabled(Rec) then
                    // ApprovalsMgmt.OnSendChangeRequestForApproval(Rec);

                    if confirm('Are you sure you want to send this change request doc for Approval?', false) = true then begin
                        SrestepApprovalsCodeUnit.SendMemberChangeRequestForApproval(rec.No, Rec);
                        Message('Approval Request Sent!');
                        CurrPage.Close();
                    end;
                end;
            }
            action("Cancel Approval Request")
            {
                ApplicationArea = Basic;
                Caption = 'Cancel A&pproval Request';
                Image = CancelApprovalRequest;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedOnly = true;

                trigger OnAction()
                var
                    text001: label 'This batch is already pending approval';
                    ApprovalMgt: Codeunit "Approvals Mgmt.";
                begin
                    if Rec.Status <> Rec.Status::Open then
                        Error(text001);
                end;
            }
            action(Approvals)
            {
                ApplicationArea = Basic;
                Caption = 'Approvals';
                Image = Approvals;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedOnly = true;

                trigger OnAction()
                var
                    ApprovalEntries: Page "Approval Entries";
                begin
                    DocumentType := Documenttype::ChangeRequest;

                    ApprovalEntries.SetRecordFilters(Database::"Change Request", DocumentType, Rec.No);
                    ApprovalEntries.Run;
                end;
            }
            separator(Action1000000047)
            {
            }
            action(Populate)
            {
                ApplicationArea = Basic;
                Caption = 'Populate';
                Image = GetLines;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                Visible = false;

                trigger OnAction()
                begin
                    /*IF ("No. Series"="No. Series"::"1") OR ("No. Series"="No. Series"::"2") THEN BEGIN
                     ERROR('Only Backoffice change or Agile Change allows you to Populate Next of Kin');
                    END;
                    IF ("No. Series"="No. Series"::"3") THEN BEGIN

                    END;

                  IF ("No. Series"="No. Series"::"4") THEN BEGIN
                    ProductNxK.RESET;
                    ProductNxK.SETRANGE(ProductNxK."Account No",Posted);
                    IF ProductNxK.FIND('-') THEN
                      MESSAGE(FORMAT(Posted));
                      REPEAT;
                        Kinchangedetails.INIT;
                        Kinchangedetails."Member No":=Posted;
                        Kinchangedetails."Dividend year":=ProductNxK.Name;
                        Kinchangedetails.Amount:=ProductNxK.Relationship;
                        Kinchangedetails."Member Name":=ProductNxK.Beneficiary;
                        Kinchangedetails.Message:=ProductNxK."Date of Birth";
                        Kinchangedetails."Message Sent":=ProductNxK.Address;
                        Kinchangedetails."Account No.":=ProductNxK.Telephone;
                        Kinchangedetails.Fax:=ProductNxK.Fax;
                        Kinchangedetails.Email:=ProductNxK.Email;
                        Kinchangedetails."ID No.":=ProductNxK."ID No.";
                        Kinchangedetails."%Allocation":=ProductNxK."%Allocation";
                        Kinchangedetails.INSERT;

                      UNTIL ProductNxK.NEXT=0;
                      MESSAGE('Next of Kin Details Populated Successfully');
                    END;
                    */

                end;
            }
            separator(Action1000000055)
            {
            }
            action("Next of Kin")
            {
                ApplicationArea = Basic;
                Caption = 'Next of Kin';
                Image = View;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                RunObject = Page "Next of Kin-Change";
                RunPageLink = "Account No" = field("Account No");
                Visible = false;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        AccountVisible := false;
        MobileVisible := false;
        nxkinvisible := false;

        if Rec.Type = Rec.Type::"Mobile Change" then begin
            MobileVisible := true;
        end;

        if Rec.Type = Rec.Type::"ATM Change" then begin
            AccountVisible := true;
            nxkinvisible := true;
        end;

        if Rec.Type = Rec.Type::"Backoffice Change" then begin
            AccountVisible := true;
            nxkinvisible := true;
        end;


        UpdateControl();
    end;

    trigger OnOpenPage()
    begin
        AccountVisible := false;
        MobileVisible := false;
        nxkinvisible := false;

        if Rec.Type = Rec.Type::"Mobile Change" then begin
            MobileVisible := true;
        end;

        if Rec.Type = Rec.Type::"ATM Change" then begin
            AccountVisible := true;
            nxkinvisible := false;
        end;

        if Rec.Type = Rec.Type::"Backoffice Change" then begin
            AccountVisible := true;
            nxkinvisible := true;
        end;


        UpdateControl();
    end;

    var
        vend: Record Vendor;
        Memb: Record Customer;
        MobileVisible: Boolean;
        AtmVisible: Boolean;
        AccountVisible: Boolean;
        ProductNxK: Record 51433;
        MembNxK: Record 51366;
        cloudRequest: Record 51552;
        nxkinvisible: Boolean;
        Kinchangedetails: Record 51366;
        DocumentType: Option " ",Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None",JV,"Member Withdrawal","Membership Reg","Loan Batches","Payment Voucher","Petty Cash",Loan,Interbank,Checkoff,"Savings Product Opening","Standing Order",ChangeRequest;
        MemberNxK: Record 51366;
        GenSetUp: Record 51398;
        GenJournalLine: Record "Gen. Journal Line";
        LineNo: Integer;
        NameEditable: Boolean;
        PictureEditable: Boolean;
        SignatureEditable: Boolean;
        AddressEditable: Boolean;
        CityEditable: Boolean;
        EmailEditable: Boolean;
        PersonalNoEditable: Boolean;
        IDNoEditable: Boolean;
        MaritalStatusEditable: Boolean;
        PassPortNoEditbale: Boolean;
        AccountTypeEditible: Boolean;
        SectionEditable: Boolean;
        CardNoEditable: Boolean;
        HomeAddressEditable: Boolean;
        LocationEditable: Boolean;
        SubLocationEditable: Boolean;
        DistrictEditable: Boolean;
        MemberStatusEditable: Boolean;
        ReasonForChangeEditable: Boolean;
        SigningInstructionEditable: Boolean;
        MonthlyContributionEditable: Boolean;
        MemberCellEditable: Boolean;
        ATMApproveEditable: Boolean;
        CardExpiryDateEditable: Boolean;
        CardValidFromEditable: Boolean;
        CardValidToEditable: Boolean;
        ATMNOEditable: Boolean;
        ATMIssuedEditable: Boolean;
        ATMSelfPickedEditable: Boolean;
        ATMCollectorNameEditable: Boolean;
        ATMCollectorIDEditable: Boolean;
        ATMCollectorMobileEditable: Boolean;
        ResponsibilityCentreEditable: Boolean;
        MobileNoEditable: Boolean;
        SMobileNoEditable: Boolean;
        TypeEditable: Boolean;
        AccountNoEditable: Boolean;
        AccountCategoryEditable: Boolean;
        ReactivationFeeEditable: Boolean;
        RetirementDateEditable: Boolean;

    local procedure UpdateControl()
    begin
        if Rec.Status = Rec.Status::Open then begin
            NameEditable := true;
            PictureEditable := true;
            SignatureEditable := true;
            AddressEditable := true;
            CityEditable := true;
            EmailEditable := true;
            PersonalNoEditable := true;
            IDNoEditable := true;
            MaritalStatusEditable := true;
            PassPortNoEditbale := true;
            AccountTypeEditible := true;
            EmailEditable := true;
            SectionEditable := true;
            CardNoEditable := true;
            HomeAddressEditable := true;
            LocationEditable := true;
            SubLocationEditable := true;
            DistrictEditable := true;
            MemberStatusEditable := true;
            ReasonForChangeEditable := true;
            SigningInstructionEditable := true;
            MonthlyContributionEditable := true;
            MemberCellEditable := true;
            ATMApproveEditable := true;
            CardExpiryDateEditable := true;
            CardValidFromEditable := true;
            CardValidToEditable := true;
            ATMNOEditable := true;
            ATMIssuedEditable := true;
            ATMSelfPickedEditable := true;
            ATMCollectorNameEditable := true;
            ATMCollectorIDEditable := true;
            ATMCollectorMobileEditable := true;
            ResponsibilityCentreEditable := true;
            MobileNoEditable := true;
            SMobileNoEditable := true;
            AccountNoEditable := true;
            ReactivationFeeEditable := true;
            TypeEditable := true;
            AccountCategoryEditable := true
        end else
            if Rec.Status = Rec.Status::Pending then begin
                NameEditable := false;
                PictureEditable := false;
                SignatureEditable := false;
                AddressEditable := false;
                CityEditable := false;
                EmailEditable := false;
                PersonalNoEditable := false;
                IDNoEditable := false;
                MaritalStatusEditable := false;
                PassPortNoEditbale := false;
                AccountTypeEditible := false;
                EmailEditable := false;
                SectionEditable := false;
                CardNoEditable := false;
                HomeAddressEditable := false;
                LocationEditable := false;
                SubLocationEditable := false;
                DistrictEditable := false;
                MemberStatusEditable := false;
                ReasonForChangeEditable := false;
                SigningInstructionEditable := false;
                MonthlyContributionEditable := false;
                MemberCellEditable := false;
                ATMApproveEditable := false;
                CardExpiryDateEditable := false;
                CardValidFromEditable := false;
                CardValidToEditable := false;
                ATMNOEditable := false;
                ATMIssuedEditable := false;
                ATMSelfPickedEditable := false;
                ATMCollectorNameEditable := false;
                ATMCollectorIDEditable := false;
                ATMCollectorMobileEditable := false;
                ResponsibilityCentreEditable := false;
                MobileNoEditable := false;
                SMobileNoEditable := false;
                AccountNoEditable := false;
                TypeEditable := false;
                ReactivationFeeEditable := false;
                AccountCategoryEditable := false
            end else
                if Rec.Status = Rec.Status::Approved then begin
                    NameEditable := false;
                    PictureEditable := false;
                    SignatureEditable := false;
                    AddressEditable := false;
                    CityEditable := false;
                    EmailEditable := false;
                    PersonalNoEditable := false;
                    IDNoEditable := false;
                    MaritalStatusEditable := false;
                    PassPortNoEditbale := false;
                    AccountTypeEditible := false;
                    EmailEditable := false;
                    SectionEditable := false;
                    CardNoEditable := false;
                    HomeAddressEditable := false;
                    LocationEditable := false;
                    SubLocationEditable := false;
                    DistrictEditable := false;
                    MemberStatusEditable := false;
                    ReasonForChangeEditable := false;
                    SigningInstructionEditable := false;
                    MonthlyContributionEditable := false;
                    MemberCellEditable := false;
                    ATMApproveEditable := false;
                    CardExpiryDateEditable := false;
                    CardValidFromEditable := false;
                    CardValidToEditable := false;
                    ATMNOEditable := false;
                    ATMIssuedEditable := false;
                    ATMSelfPickedEditable := false;
                    ATMCollectorNameEditable := false;
                    ATMCollectorIDEditable := false;
                    ATMCollectorMobileEditable := false;
                    ResponsibilityCentreEditable := false;
                    MobileNoEditable := false;
                    SMobileNoEditable := false;
                    AccountNoEditable := false;
                    ReactivationFeeEditable := false;
                    TypeEditable := false;
                    AccountCategoryEditable := false
                end;
    end;
}

