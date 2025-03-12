page 56110 "Member Application Card"
{
    ApplicationArea = Basic;
    DeleteAllowed = false;
    PageType = Card;
    SourceTable = "Membership Applications";
    UsageCategory = Tasks;

    layout
    {
        area(content)
        {
            field("Account Type"; Rec."Account Category")
            {
                ApplicationArea = Basic;
                Caption = 'Account Type';
                // Enabled = membertypeEditable;
                ShowMandatory = true;
                ColumnSpan = 0;
                RowSpan = 0;

                Editable = TitleEditable;
                // Visible = false;

                trigger OnValidate()
                begin
                    UpdateControls();
                end;
            }
            group(General)
            {
                Caption = 'General';
                Visible = Individual;
                field("No."; Rec."No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Assigned No"; Rec."Assigned No.")
                {
                    ApplicationArea = all;
                    Editable = false;
                    Visible = false;
                    Caption = 'Assigned No';
                }
                field(Title; Rec.Title)
                {
                    ApplicationArea = Basic;
                    Editable = TitleEditable;
                    Visible = false;
                    ShowMandatory = false;
                }

                field("First Name"; Rec."First Name")
                {
                    ApplicationArea = Basic;
                    Editable = FistnameEditable;


                    trigger OnValidate()
                    begin

                        Rec.Name := Rec."First Name";
                    end;

                }

                field("Middle Name"; Rec."Middle Name")
                {
                    ApplicationArea = Basic;
                    Editable = FistnameEditable;


                    trigger OnValidate()
                    begin
                        Rec.Name := Rec."First Name" + ' ' + Rec."Middle Name";
                    end;

                }
                field("Last Name"; Rec."Last Name")
                {
                    ApplicationArea = Basic;
                    Editable = FistnameEditable;


                    trigger OnValidate()
                    begin
                        Rec.Name := Rec."First Name" + ' ' + Rec."Middle Name" + ' ' + Rec."Last Name";
                    end;

                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = Basic;
                    Editable = false;


                    ShowMandatory = true;
                }
                field("Registration No"; Rec."Registration No")
                {
                    ApplicationArea = Basic;
                    Editable = FistnameEditable;
                    Visible = false;

                }
                field(Address; Rec.Address)
                {
                    ApplicationArea = Basic;
                    Editable = AddressEditable;

                }
                field("Postal Code"; Rec."Postal Code")
                {
                    ApplicationArea = Basic;
                    Editable = PostalCodeEditable;
                    Importance = Promoted;
                    Visible = false;
                }
                field(Nationality; Rec.Nationality)
                {
                    ApplicationArea = Basic;
                    Editable = CityEditable;
                    trigger OnValidate()
                    var
                        myInt: Integer;
                    begin
                        If Rec.Nationality = Rec.Nationality::Kenyan then
                            NationalRe := false
                        else
                            NationalRe := true;
                    end;
                }
                field(Town; Rec.Town)
                {
                    ApplicationArea = Basic;
                    Caption = 'Town';
                    Editable = CityEditable;
                }
                field(IPRS; Rec.IPRS)
                {
                    ApplicationArea = Basic;
                    Caption = 'IPRS';
                    Editable = CityEditable;
                    Visible = false;
                }
                field("Mobile Phone No"; Rec."Mobile Phone No")
                {
                    ApplicationArea = Basic;
                    Editable = PhoneEditable;
                    ShowMandatory = true;

                    trigger OnValidate()
                    begin
                        if StrLen(Rec."Mobile Phone No") <> 10 then
                            Error('Mobile No. Can not be more or less than 10 Characters');
                    end;
                }
                field("Mobile Phone No 2"; Rec."Mobile No. 2")
                {
                    ApplicationArea = Basic;
                    Editable = PhoneEditable;


                    trigger OnValidate()
                    begin
                        if StrLen(Rec."Mobile No. 2") <> 10 then
                            Error('Mobile No. Can not be more or less than 15 Characters');
                    end;
                }
                field("Identity Type"; Rec."Identification Document")
                {
                    ApplicationArea = Basic;
                    Editable = IDNoEditable;
                    ShowMandatory = true;
                    Visible = false;
                }
                field("ID No."; Rec."ID No.")
                {
                    ApplicationArea = Basic;
                    Editable = IDNoEditable;
                    ShowMandatory = true;
                }
                // field("Passport No."; Rec."Passport No.")
                // {
                //     ApplicationArea = all;

                //     Editable = IDNoEditable;
                // }
                field("Date of Birth"; Rec."Date of Birth")
                {
                    ApplicationArea = Basic;
                    Enabled = DOBEditable;
                    ShowMandatory = true;

                    trigger OnValidate()
                    var
                        DateofRetirement: Date;
                    begin
                        Rec.Age := Dates.DetermineAge(Rec."Date of Birth", Today);
                        GenSetUp.Get();
                        DateofRetirement := CalcDate(GenSetUp."Retirement Age", Rec."Date of Birth");
                        Message('Date of Retirement %1', DateofRetirement);
                    end;
                }
                field(Age; Rec.Age)
                {
                    ApplicationArea = Basic;
                    Editable = ageEditable;
                }
                field(Gender; Rec.Gender)
                {
                    Editable = GenderEditable;
                    ShowMandatory = true;
                }
                field("KRA Pin"; Rec."KRA Pin")
                {
                    ApplicationArea = Basic;
                    ShowMandatory = false;
                    StyleExpr = true;
                    Editable = NameEditable;
                }
                field("Marital Status"; Rec."Marital Status")
                {
                    ApplicationArea = Basic;
                    Editable = MaritalstatusEditable;
                }
                // field("Employer Code"; "Employer Code")
                // {
                //     ApplicationArea = Basic;
                //     Editable = EmployerCodeEditable;
                // }
                // field("Employer Name"; "Employer Name")
                // {
                //     ApplicationArea = Basic;
                //     Editable = false;
                // }
                // field("Payroll/Staff No"; "Payroll/Staff No")
                // {
                //     ApplicationArea = Basic;
                //     Editable = NameEditable;
                // }
                field("E-Mail (Personal)"; Rec."E-Mail (Personal)")
                {
                    ApplicationArea = Basic;
                    Editable = EmailEdiatble;
                    ShowMandatory = true;
                }
                field(Location; Rec.Location)
                {
                    ApplicationArea = Basic;
                    Caption = 'Physical Location';
                    ShowMandatory = false;
                    Editable = NameEditable;
                }
                field("Received 1 Copy Of ID"; Rec."Received 1 Copy Of ID")
                {
                    ApplicationArea = Basic;
                    Editable = CopyOFIDEditable;
                    ShowMandatory = false;
                }

                field("Copy of KRA Pin"; Rec."Copy of KRA Pin")
                {
                    ApplicationArea = Basic;
                    Editable = CopyofKRAPinEditable;
                    ShowMandatory = false;
                }
                field("AutoFill Mobile Details"; Rec."AutoFill Mobile Details")
                {
                    ApplicationArea = Basic;
                    Editable = CopyofKRAPinEditable;
                    ShowMandatory = true;
                    Visible = false;
                }
                field("AutoFill Agency Details"; Rec."AutoFill Agency Details")
                {
                    ApplicationArea = Basic;
                    Editable = CopyofKRAPinEditable;
                    ShowMandatory = true;
                    Visible = false;
                }
            }
            group(Junior)
            {

                Visible = Junior;
                field("JuniorNo."; Rec."No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Caption = 'Junior Account Application Number';
                }

                field("JuniorFirst Name"; Rec."First Name")
                {
                    ApplicationArea = Basic;
                    Editable = FistnameEditable;


                    trigger OnValidate()
                    begin

                        Rec.Name := Rec."First Name";
                    end;

                }

                field("JuniorSecond Name"; Rec."Middle Name")
                {
                    ApplicationArea = Basic;
                    Editable = FistnameEditable;


                    trigger OnValidate()
                    begin
                        Rec.Name := Rec."First Name" + ' ' + Rec."Middle Name";
                    end;

                }
                field("JuniorLast Name"; Rec."Last Name")
                {
                    ApplicationArea = Basic;
                    Editable = FistnameEditable;


                    trigger OnValidate()
                    begin
                        Rec.Name := Rec."First Name" + ' ' + Rec."Middle Name" + ' ' + Rec."Last Name";
                    end;

                }
                field(JuniorName; Rec.Name)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ShowMandatory = true;
                }
                field("Birth Certficate No."; Rec."Birth Certficate No.")
                {
                    ApplicationArea = all;
                    Editable = FistnameEditable;
                }
                field("Guardian No."; Rec."Guardian No.")
                {
                    ApplicationArea = all;
                    Editable = FistnameEditable;
                }
                field("Guardian Name"; Rec."Guardian Name")
                {
                    ApplicationArea = all;
                    Editable = false;
                }

            }
            // group("Bank Details")
            // {

            //     field("Bank Code"; Rec."Bank Code")
            //     {
            //         ApplicationArea = Basic;
            //         Caption = 'Bank Code';
            //         ShowMandatory = true;
            //         NotBlank = true;
            //     }
            //     field("Bank Name"; Rec."Bank Name")
            //     {
            //         ApplicationArea = Basic;
            //         Caption = 'Bank Name';
            //         Editable = false;
            //     }
            //     field("Bank Branch"; Rec."Bank Branch")
            //     {
            //         ApplicationArea = Basic;
            //         Editable = false;
            //     }
            //     field("Bank Account No"; Rec."Bank Account No")
            //     {
            //         ApplicationArea = Basic;
            //     }
            // }
            group("Employment Details")
            {
                Visible = Individual;
                field("Employment Info"; Rec."Employment Info")
                {
                    ApplicationArea = Basic;
                    Editable = EmployerCodeEditable;
                    trigger OnValidate()
                    begin
                        if Rec."Employment Info" = Rec."Employment Info"::"KRB Employee" then begin
                            employedMember := true;
                            selfEmployedMember := false;
                            exEmployee := false;
                        end else
                            if Rec."Employment Info" = Rec."Employment Info"::" " then begin
                                employedMember := false;
                                selfEmployedMember := false;
                                exEmployee := false;
                            end else
                                if Rec."Employment Info" = Rec."Employment Info"::"Non KRB" then begin
                                    employedMember := false;
                                    selfEmployedMember := true;
                                    exEmployee := false;
                                end else
                                    if Rec."Employment Info" = Rec."Employment Info"::"Ex KRB Employee" then begin
                                        // employedMember := false;
                                        // selfEmployedMember := false;
                                        // exEmployee := true;
                                        employedMember := false;
                                        selfEmployedMember := true;
                                        exEmployee := false;
                                    end;
                    end;
                }
                field("Income Levels"; Rec."Income Levels")
                {
                    Caption = 'Estimated Monthly Income Levels';
                    ApplicationArea = Basic;
                    Editable = EmployerCodeEditable;
                    Visible = false;
                }
                field("Source of Funds"; Rec."Source of Funds")
                {
                    //Visible = not employedMember and not selfEmployedMember;
                    Visible = false;
                    Caption = 'Source of Funds';
                    ApplicationArea = Basic;
                    Editable = EmployerCodeEditable;
                    trigger OnValidate()
                    begin
                        if Rec."Source of Funds" = Rec."Source of Funds"::Others then begin
                            otherFundsSource := true;
                        end else begin
                            otherFundsSource := false;
                        end;
                    end;
                }
                field("Specific Source of Funds"; Rec."Specific Source of Funds")
                {
                    Visible = false;
                    //Visible = otherFundsSource;
                    Caption = 'Specific Source of Funds';
                    ApplicationArea = Basic;
                    Editable = EmployerCodeEditable;
                    trigger OnValidate()
                    begin

                    end;
                }
                group("Self Employed")
                {
                    Caption = 'Non KRB Employee Details';
                    Visible = false;//selfEmployedMember;//not employedMember;
                    field("Business Name."; Rec.Name)
                    {
                        ApplicationArea = Basic;
                        Editable = BusinessAccount;
                        Caption = 'Business Name';
                        ShowMandatory = true;
                    }
                    field("Street/Building/Estate"; Rec.Address)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Street/Building/Estate';
                        Editable = RecruitedEditable;
                    }
                    field("Office Number"; Rec."Mobile Phone No")
                    {
                        ApplicationArea = Basic;
                        Editable = PhoneEditable;
                        ShowMandatory = true;
                        Caption = 'Office Number';

                        trigger OnValidate()
                        begin
                            if StrLen(Rec."Mobile Phone No") <> 10 then
                                Error('Mobile No. Can not be more or less than 10 Characters');
                        end;
                    }
                    field("Nature of Busines"; Rec."Nature of Business")
                    {
                        Caption = 'Nature of Business';
                        ApplicationArea = Basic;
                        Editable = RecruitedEditable;
                    }
                }
            }
            group("KRB Employee Details")
            {
                Caption = 'KRB Employee Details';
                Visible = employedMember;
                field("Payroll No"; Rec."Payroll No")
                {
                    ApplicationArea = Basic;
                    ShowMandatory = true;
                }
                field("Employer Code"; Rec."Employer Code")
                {
                    ApplicationArea = Basic;
                    Editable = EmployerCodeEditable;
                }
                field("Employer Name"; Rec."Employer Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                // field(Department; Rec.Department)
                // {
                //     ApplicationArea = Basic;
                //     Editable = NameEditable;
                // }
                // field("Office Branch"; Rec."Office Branch")
                // {
                //     ApplicationArea = Basic;
                //     Editable = NameEditable;
                // }
                field("Official Designation"; Rec."Official Designation")
                {
                    ApplicationArea = Basic;
                    Editable = NameEditable;
                    Visible = false;
                }
                // field(Station; Rec.Section)
                // {
                //     Caption = 'Station';
                //     ApplicationArea = Basic;
                // }
                // field("Station Name"; Rec."Station Name")
                // {
                //     ApplicationArea = all;
                // }
                field("Date Employed"; Rec."Date Employed")
                {
                    ApplicationArea = Basic;
                    Editable = NameEditable;
                    Visible = false;
                }
                field("Terms of Employment"; Rec."Terms of Employment")
                {
                    ApplicationArea = Basic;
                    Editable = NameEditable;
                    Visible = false;
                }
            }
            group("Ex-KRB Employee")
            {
                Caption = 'Ex-KRB Employee Details';
                Visible = exEmployee;
                field("Ex-Payroll No"; Rec."Payroll No")
                {
                    ApplicationArea = Basic;
                    ShowMandatory = true;
                }
                field("Ex-Employer Code"; Rec."Employer Code")
                {
                    ApplicationArea = Basic;
                    Editable = EmployerCodeEditable;
                }
                field("Ex-Employer Name"; Rec."Employer Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                // field("Ex-Department"; Rec.Department)
                // {
                //     ApplicationArea = Basic;
                //     Editable = NameEditable;
                // }
                // field("Ex-Office Branch"; Rec."Office Branch")
                // {
                //     ApplicationArea = Basic;
                //     Editable = NameEditable;
                // }
                field("Ex-Official Designation"; Rec."Official Designation")
                {
                    ApplicationArea = Basic;
                    Editable = NameEditable;
                    Visible = false;
                }
                // field("Ex-Station"; Rec.Section)
                // {
                //     Caption = 'Station';
                //     ApplicationArea = Basic;
                // }
                // field("Ex-Station Name"; Rec."Station Name")
                // {
                //     ApplicationArea = all;
                // }
                field("Ex-Terms of Employment"; Rec."Terms of Employment")
                {
                    ApplicationArea = Basic;
                    Editable = NameEditable;
                    Visible = false;
                }
            }
            group("IsSelfEmployed")
            {
                Caption = 'Non-KRB Member';
                Visible = selfEmployedMember;
                field(Occupations; Rec.Occupation)
                {
                    ApplicationArea = Basic;
                    Caption = 'Type Of Activity Engaged';
                    ShowMandatory = true;
                    trigger OnValidate()
                    begin
                    end;
                }
                field("KRAPin"; Rec."KRA Pin")
                {
                    ApplicationArea = Basic;
                    ShowMandatory = false;
                    Caption = 'KRA Pin';
                }
            }

            group("Other Information")
            {
                Caption = 'Other Information';
                field("How Did you know about us ?"; Rec."How Did you know of KANISA")
                {
                    ApplicationArea = Basic;
                    Caption = 'How Did you know about Us?';

                    trigger OnValidate()
                    begin
                    end;
                }
                field("Monthly Contribution"; Rec."Monthly Contribution")
                {
                    ApplicationArea = Basic;
                    Editable = MonthlyContributionEdit;
                    Visible = false;
                }
                field("Recruited By"; Rec."Recruited By")
                {
                    ApplicationArea = Basic;
                    Editable = RecruitedEditable;
                }
                field("Recruiter Name"; Rec."Recruiter Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;//if ("How Did you know of KANISA" = filter("Another Member"))

                }
                field("Captured By"; Rec."Captured By")
                {
                    ApplicationArea = Basic;
                }
                field("Created By"; Rec."Created By")
                {
                    ApplicationArea = Basic;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                    Editable = StatusEditable;

                    trigger OnValidate()
                    begin
                        UpdateControls();
                    end;
                }
                field("Customer Posting Group"; Rec."Customer Posting Group")
                {
                    ApplicationArea = Basic;
                    Editable = true;// CustPostingGroupEdit;
                }
                field("Activity Code"; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                    Editable = GlobalDim2Editable;
                }
                field("Branch Code"; Rec."Global Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                    Editable = GlobalDim2Editable;
                    ShowMandatory = true;
                }
                field("Sms Notification"; Rec."Sms Notification")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                group("User Details")
                {
                    field("User ID"; Rec."User ID")
                    {
                        ApplicationArea = Basic;
                        Editable = false;
                    }
                    field("Registration Date"; Rec."Registration Date")
                    {
                        ApplicationArea = Basic;
                        Editable = true;
                    }
                    field("Client Computer Name"; Rec."Client Computer Name")
                    {
                        ApplicationArea = Basic;
                        Editable = false;
                        Visible = false;
                    }
                }
            }
        }
        //factbox
        area(factboxes)
        {
            // part(Control149; "Applicant Picture")
            // {

            //     ApplicationArea = all;
            //     SubPageLink = "No." = FIELD("No.");
            //     // Visible = Individual;
            //     Enabled = false;

            // }
            part(Control150; "Applicant Document")
            {
                ApplicationArea = all;
                SubPageLink = "No." = FIELD("No.");
                Visible = Individual;
                Enabled = true;
            }
            // part(Control151; "Applicant Signature")
            // {
            //     ApplicationArea = all;
            //     SubPageLink = "No." = FIELD("No.");
            //     //   Visible = (Individual) AND NOT (JuniourAccountType);
            //     Enabled = false;
            // }
            // part(Control152; "Applicant Logo")
            // {
            //     ApplicationArea = all;
            //     SubPageLink = "No." = FIELD("No.");
            //     Visible = (IsCooporateApplication);
            //     Enabled = true;
            // }
        }

    }

    actions
    {
        area(navigation)
        {
            group("Function")
            {
                Caption = 'Function';
                action("Select Products")
                {
                    ApplicationArea = Basic;
                    Image = Accounts;
                    RunObject = page "Membership App Products";// "Member Applied Products List";
                    RunPageLink = "Membership Applicaton No" = field("No.");
                    Enabled = false;
                    Visible = false;

                    trigger OnAction()
                    begin

                        //on opening page,make sure that the accounts set as default are automatically filled in start
                        AccoutTypes.RESET;
                        AccoutTypes.SETRANGE(AccoutTypes."Default Account", TRUE);
                        IF AccoutTypes.Find('-') THEN BEGIN
                            REPEAT
                                IF AccoutTypes."Default Account" = TRUE THEN BEGIN
                                    ObjProductsApp.INIT;
                                    ObjProductsApp."Membership Applicaton No" := xRec."No.";
                                    ObjProductsApp."Applicant Name" := xRec.Name;
                                    // ObjProductsApp."Applicant Age" := xRec.Age;
                                    ObjProductsApp."Applicant Gender" := xRec.Gender;
                                    ObjProductsApp."Applicant ID" := xRec."ID No.";
                                    ObjProductsApp."Product" := AccoutTypes.Code;
                                    ObjProductsApp."Product Name" := AccoutTypes.Description;
                                    ObjProductsApp."Product Category" := AccoutTypes."Activity Code";
                                    ObjProductsApp.INSERT;
                                    ObjProductsApp.VALIDATE(ObjProductsApp."Product");
                                    ObjProductsApp.MODIFY;
                                END;
                            UNTIL AccoutTypes.Next = 0;
                        END;
                        //on opening page,make sure that the accounts set as default are automatically filled in start


                    end;
                }
                action("Next of Kin")
                {
                    ApplicationArea = Basic;
                    Caption = 'Next of Kin';
                    Image = Relationship;
                    RunObject = Page "Membership App Kin Details";
                    RunPageLink = "Account No" = field("No.");
                }
                action("Member Nominees")
                {
                    ApplicationArea = Basic;
                    Caption = 'Member Nominees';
                    Image = Relationship;
                    RunObject = Page "Membership App Nominee Detail";
                    RunPageLink = "Account No" = field("No.");
                }
                action("Account Signatories")
                {
                    ApplicationArea = Basic;
                    Caption = 'Signatories';
                    Image = Group;
                    RunObject = Page "Membership App Signatories";
                    RunPageLink = "Account No" = field("No.");
                    Visible = Jooint;
                }
                action("Group Account Members")
                {
                    ApplicationArea = Basic;
                    Caption = 'Group Account Register';
                    Image = Group;
                    RunObject = Page "Bosa Group Members List";
                    RunPageLink = "Account No" = field("No.");
                    Visible = groupAcc;
                }
                separator(Action6)
                {
                    Caption = '-';
                }

                action("Send Approval Request")
                {
                    ApplicationArea = Basic;
                    Caption = 'Send Approval Request';
                    Image = SendApprovalRequest;
                    Enabled = (not OpenApprovalEntriesExist) AND EnabledApprovalWorkflowsExist AND (not RecordApproved);

                    trigger OnAction()
                    var
                        Text001: label 'This request is already pending approval';
                    begin

                        if Rec."ID No." <> '' then begin
                            Cust.Reset;
                            Cust.SetRange(Cust."ID No.", Rec."ID No.");
                            Cust.SetRange(Cust."Customer Type", Cust."customer type"::Member);
                            if Cust.Find('-') then begin
                                if (Cust."No." <> Rec."No.") and (Cust."Account Category" = Cust."account category"::"Regular Account") then
                                    Error('Member has already been created. Kindly Confirm the ID Number to proceed.');
                            end;
                        end;

                        //*******************Check ID no.******************************
                        if Rec."Account Category" = Rec."Account Category"::"Regular Account" then begin
                            if (Rec."ID No." = '') then
                                Error('You must specify ID No for the applicant');
                        end;
                        if Rec."Account Category" = Rec."Account Category"::"Junior Account" then begin
                            if (Rec."Birth Certficate No." = '') then
                                Error('You must enter the Birth Cert. No');
                        end;
                        //*******************Check ID no.******************************


                        if (Rec."Account Category" = Rec."account category"::"Regular Account") then begin
                            Rec.TestField(Name);
                            Rec.TestField("ID No.");
                            Rec.TestField("Mobile Phone No");
                            // Rec.TestField(Picture);
                            // Rec.TestField(Signature);
                            Rec.TestField(Gender);
                            Rec.TestField("Customer Posting Group");
                            Rec.TestField("Global Dimension 1 Code");
                            // Rec.TestField("Global Dimension 2 Code");
                        end;

                        if (Rec."Account Category" = Rec."account category"::"Regular Account") then begin//end or (Rec."Account Category" = Rec."account category"::Junior) or (Rec."Account Category" = Rec."account category"::Joint) then begin
                            NOkApp.Reset;
                            NOkApp.SetRange(NOkApp."Account No", Rec."No.");
                            if NOkApp.Find('-') = false then begin
                                Error('Please Insert Next Of Kin Information');
                            end;
                        end;

                        if (Rec."Account Category" = Rec."Account Category"::"Regular Account") then begin
                            nomineeApp.Reset();
                            nomineeApp.SetRange(nomineeApp."Account No", Rec."No.");

                            // Check if there is any nominee for the account
                            if not nomineeApp.FindFirst() then begin
                                Error('Please Insert Nominee Information');
                            end else begin
                                // Check if there is a nominee under 18
                                nomineeApp.Reset();
                                nomineeApp.SetRange(nomineeApp."Account No", Rec."No.");

                                if nomineeApp.FindFirst() then begin
                                    repeat
                                        AgeText := nomineeApp.Age; // Get the Age text
                                        YearPart := CopyStr(AgeText, 1, StrPos(AgeText, ' Years') - 1); // Extract the number before " Years"

                                        if YearPart <> '' then begin
                                            Evaluate(IntegerAge, YearPart); // Convert extracted text to integer

                                            if IntegerAge < 18 then begin


                                                // If a nominee under 18 exists, check for at least one guardian nominee above 18
                                                nomineeApp.Reset();
                                                nomineeApp.SetRange(nomineeApp."Account No", Rec."No.");
                                                GuardianFound := false; // Flag to check for a valid guardian

                                                if nomineeApp.FindFirst() then begin
                                                    repeat
                                                        AgeText := nomineeApp.Age;
                                                        YearPart := CopyStr(AgeText, 1, StrPos(AgeText, ' Years') - 1);
                                                        Evaluate(IntegerAge, YearPart);

                                                        if (IntegerAge > 18) and (nomineeApp."Next Of Kin Type" = nomineeApp."Next Of Kin Type"::"Guardian/Trustee") then
                                                            GuardianFound := true;
                                                    until (nomineeApp.Next() = 0) or GuardianFound; // Exit if we find a guardian
                                                end;

                                                if not GuardianFound then begin
                                                    Error('Please Insert at least one guardian nominee (Age > 18) since a nominee under 18 exists.');
                                                end;
                                            end;
                                        end;
                                    until nomineeApp.Next() = 0;
                                end;
                            end;
                        end;


                        if Rec.Status <> Rec.Status::Open then
                            Error(Text001);

                        //................................

                        if Confirm('Are you sure you want to send Membership Application for approval', false) = true then begin
                            SrestepApprovalsCodeUnit.SendMembershipApplicationsRequestForApproval(Rec."No.", Rec);
                            // ApprovalCodeUnit.OnSendMembershipApplicationForApproval(Rec);
                            Rec.Status := Rec.Status::"Pending Approval";
                        end;
                        //.................................

                    end;
                }
                action("Cancel Approval Request")
                {
                    ApplicationArea = Basic;
                    Caption = 'Cancel Approval Request';
                    Image = Cancel;
                    Enabled = CanCancelApprovalForRecord;


                    trigger OnAction()
                    var
                    // Approvalmgt: Codeunit "Export F/O Consolidation";
                    begin
                        if Confirm('Cancel Approval?', false) = true then begin
                            SrestepApprovalsCodeUnit.CancelMembershipApplicationsRequestForApproval(rec."No.", Rec);

                        end;
                    end;
                }
                separator(Action2)
                {
                    Caption = '       -';
                }
                action("Create Account")
                {
                    ApplicationArea = Basic;
                    Caption = 'Create Account';
                    Image = Customer;
                    Visible = true;
                    Enabled = CreateAccount;

                    trigger OnAction()
                    var
                        dialogBox: Dialog;
                        TheMessage: Codeunit "Email Message";
                        Email: Codeunit Email;

                    begin
                        if Rec.Status <> Rec.Status::Approved then
                            Error('This application has not been approved');
                        ///.................
                        if Rec."Global Dimension 2 Code" = '' then begin
                            Error('Branch Code is Mandatory');

                        end;
                        Cust.Reset;
                        Cust.SetRange(Cust."Customer Type", Cust."customer type"::Member);

                        if Rec."Account Category" = Rec."Account Category"::"Regular Account" then begin
                            Cust.SetRange(Cust."ID No.", Rec."ID No.");
                        end;
                        if Rec."Account Category" = Rec."Account Category"::"Junior Account" then begin
                            Cust.SetRange(Cust."Birth Certficate No.", Rec."Birth Certficate No.");
                        end;
                        if Cust.Find('-') then begin
                            if (Cust."No." <> Rec."No.") then
                                Error('Member has already been created');
                        end;
                        if Confirm('Are you sure you want to create account application?', false) = false then begin
                            Message('Aborted');
                            exit;
                        end ELSE begin
                            dialogBox.Open('Creating New BOSA Account for applicant ' + Format(MembApp.Name));
                            FnCreateBOSAMemberAccounts();
                            dialogBox.Close();

                            dialogBox.Open('Registering Next Of Kin for ' + Format(MembApp.Name));
                            FnCreateNextOfKinDetails(Cust."No.");
                            dialogBox.Close();

                            dialogBox.Open('Registering Nominees for ' + Format(MembApp.Name));
                            FnCreateNomineeDetails(Cust."No.");
                            dialogBox.Close();

                            dialogBox.Open('Registering Account Signatories for ' + Format(MembApp.Name));
                            FnCreateAccountSignatories(Cust."No.");
                            dialogBox.Close();

                            dialogBox.Open('Registering Account Group Members for ' + Format(MembApp.Name));
                            FnCreateGroupMembers();
                            dialogBox.Close();

                            //...............................Close The Card
                            //-----Send Email

                            SendMail(Cust."No.");
                            //-----Send SMS
                            FnSendSMSOnAccountOpening();
                            //-----
                            Message('Account created successfully.');
                            Message('The Member Sacco no is %1', Cust."No.");

                            //...............................modify the status of the application to closed
                            rec.Status := Rec.Status::Closed;
                            rec.Modify(true);
                            //.............................................................................
                        end;

                    end;
                }
                separator(Action3)
                {
                    Caption = '       -';
                }
                action("Member Risk Rating")
                {
                    Visible = false;
                    ApplicationArea = Basic;
                    Caption = 'Get Member Risk Rating';
                    Image = Reconcile;
                    RunObject = Page "Individual Member Risk Rating";
                    RunPageLink = "Membership Application No" = field("No.");

                    trigger OnAction()
                    VAR

                    begin
                        SFactory.FnGetMemberApplicationAMLRiskRating(Rec."No.");
                    end;
                }


            }
        }
        area(Promoted)
        {
            group(Category_Process)
            {
                Caption = 'Process', Comment = 'Generated from the PromotedActionCategories property index 1.';

                actionref("Select Products_Promoted"; "Select Products")
                {
                }
                actionref("Next of Kin_Promoted"; "Next of Kin")
                {
                }
                actionref("Member Nominees_Promoted"; "Member Nominees")
                {
                }
                actionref("Account Signatories _Promoted"; "Account Signatories")
                {
                }
                actionref("Group Account Details Promoted"; "Group Account Members")
                {
                }
                actionref("Create Account_Promoted"; "Create Account")
                {
                }
                actionref(MemberRiskRating_Promoted; "Member Risk Rating")
                {
                }
                actionref("Send Approval Request_Promoted"; "Send Approval Request")
                {
                }
                actionref("Cancel Approval Request_Promoted"; "Cancel Approval Request")
                {
                }
            }
            group(Category_Category4)
            {
                Caption = 'Approval', Comment = 'Generated from the PromotedActionCategories property index 3.';


            }
            group(Category_Category5)
            {
                Caption = 'Budgetary Control', Comment = 'Generated from the PromotedActionCategories property index 4.';
            }
            group(Category_Category6)
            {
                Caption = 'Cancellation', Comment = 'Generated from the PromotedActionCategories property index 5.';
            }
            group(Category_Category7)
            {
                Caption = 'Category7_caption', Comment = 'Generated from the PromotedActionCategories property index 6.';
            }
            group(Category_Category8)
            {
                Caption = 'Category8_caption', Comment = 'Generated from the PromotedActionCategories property index 7.';
            }
            group(Category_Category9)
            {
                Caption = 'Category9_caption', Comment = 'Generated from the PromotedActionCategories property index 8.';
            }
            group(Category_Category10)
            {
                Caption = 'Category10_caption', Comment = 'Generated from the PromotedActionCategories property index 9.';
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        UpdateControls();
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    var
        RestrictInsert: ErrorInfo;
    begin
        Rec."Responsibility Centre" := UserMgt.GetSalesFilter;
        Rec."Monthly Contribution" := GenSetUp."Min. Contribution";
        Rec."User ID" := UserId;
        //rec.Reset();
        // Rec.SetRange(rec.Status, Rec.Status::Open);
        // Rec.SetRange(Rec."User ID", UserId);
        // Rec.SetFilter(Rec.Name, '');
        // if rec.Find('-') then begin
        //     if Rec.Count > 3 then begin
        //         Error('Please use the unfinished Member Numbers' +
        //         'Use can Edit or First finish the open applications');
        //         //RestrictInsert.Message:=StrSubstNo('Use can Edit or First finish the open applications');

        //     end;
        // end;
    end;

    trigger OnOpenPage()
    var
    begin
        if UserMgt.GetSalesFilter <> '' then begin
            Rec.FilterGroup(2);
            Rec.SetRange("Responsibility Centre", UserMgt.GetSalesFilter);
            Rec.FilterGroup(0);

        end;
        //Jooint := false;



    end;

    var
        SFactory: Codeunit "Swizzsoft Factory";
        Individual: Boolean;
        groupAcc: Boolean;
        BosaAPPGroup: Record "Bosa Member App Group Members";
        BosacustGroup: Record "Bosa Customer Group Members";
        Junior: Boolean;
        MemberAppliedProducts: Record "Membership Reg. Products Appli";// "Membership Applied Products";
        ObjProductsApp: Record "Membership Reg. Products Appli";
        StatusPermissions: Record "Status Change Permision";
        Cust: Record Customer;
        Accounts: Record Vendor;
        //AcctNo: Code[20];
        NextOfKinApp: Record "Member App Next Of kin";
        NextofKinFOSA: Record "Members Next Kin Details";
        AccountSign: Record "Member Account Signatories";
        AccountSignApp: Record "Member App Signatories";
        Acc: Record Vendor;
        UsersID: Record User;
        Nok: Record "Member App Next Of kin";
        NOKBOSA: Record "Members Next Kin Details";
        BOSAACC: Code[20];
        NextOfKin: Record "Members Next Kin Details";
        PictureExists: Boolean;
        text001: label 'Status must be open';
        UserMgt: Codeunit "User Setup Management";
        //Notification: Codeunit "SMTP Mail";
        NotificationE: Codeunit Mail;
        MailBody: Text[250];
        ccEmail: Text[1000];
        toEmail: Text[1000];
        GenSetUp: Record "Sacco General Set-Up";
        ClearingAcctNo: Code[20];
        AdvrAcctNo: Code[20];
        DocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None",JV,"Member Closure","Account Opening",Batches,"Payment Voucher","Petty Cash",Requisition,Loan,Interbank,Imprest,Checkoff,"FOSA Account Opening",StandingOrder,HRJob,HRLeave,"HRTransport Request",HRTraining,"HREmp Requsition",MicroTrans,"Account Reactivation","Overdraft ",BLA,"Member Editable","FOSA Opening","Loan Batching",Leave,"Imprest Requisition","Imprest Surrender","Stores Requisition","Funds Transfer","Change Request","Staff Claims","BOSA Transfer","Loan Tranche","Loan TopUp","Memb Opening","Member Withdrawal";
        AccountTypes: Record "Account Types-Saving Products";
        DivAcctNo: Code[20];
        NameEditable: Boolean;
        AddressEditable: Boolean;
        NoEditable: Boolean;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        DioceseEditable: Boolean;
        HomeAdressEditable: Boolean;
        GlobalDim1Editable: Boolean;
        GlobalDim2Editable: Boolean;
        CustPostingGroupEdit: Boolean;
        PhoneEditable: Boolean;
        MaritalstatusEditable: Boolean;
        IDNoEditable: Boolean;
        RegistrationDateEdit: Boolean;
        OfficeBranchEditable: Boolean;
        employedMember: Boolean;
        exEmployee: Boolean;
        selfEmployedMember: Boolean;
        otherFundsSource: Boolean;
        DeptEditable: Boolean;
        SectionEditable: Boolean;
        OccupationEditable: Boolean;
        DesignationEdiatble: Boolean;
        EmployerCodeEditable: Boolean;
        DOBEditable: Boolean;
        EmailEdiatble: Boolean;
        StaffNoEditable: Boolean;
        GenderEditable: Boolean;
        MonthlyContributionEdit: Boolean;
        PostCodeEditable: Boolean;
        CityEditable: Boolean;
        WitnessEditable: Boolean;
        StatusEditable: Boolean;
        BankCodeEditable: Boolean;
        BranchCodeEditable: Boolean;
        BankAccountNoEditable: Boolean;
        VillageResidence: Boolean;
        SignatureExists: Boolean;
        NewMembNo: Code[30];
        Saccosetup: Record "Sacco No. Series";
        NOkApp: Record "Member App Next Of kin";
        TitleEditable: Boolean;
        PostalCodeEditable: Boolean;
        HomeAddressPostalCodeEditable: Boolean;
        HomeTownEditable: Boolean;
        RecruitedEditable: Boolean;
        ContactPEditable: Boolean;
        ContactPRelationEditable: Boolean;
        ContactPOccupationEditable: Boolean;
        CopyOFIDEditable: Boolean;
        CopyofPassportEditable: Boolean;
        SpecimenEditable: Boolean;
        ContactPPhoneEditable: Boolean;
        PictureEditable: Boolean;
        SignatureEditable: Boolean;
        PayslipEditable: Boolean;
        RegistrationFeeEditable: Boolean;
        CopyofKRAPinEditable: Boolean;
        membertypeEditable: Boolean;
        FistnameEditable: Boolean;
        ObjNoSeries: Record "Sacco No. Series";
        dateofbirth2: Boolean;
        registrationeditable: Boolean;
        EstablishdateEditable: Boolean;
        RegistrationofficeEditable: Boolean;
        Signature2Editable: Boolean;
        Picture2Editable: Boolean;
        MembApp: Record "Membership Applications";
        title2Editable: Boolean;
        mobile3editable: Boolean;
        emailaddresEditable: Boolean;
        gender2editable: Boolean;
        postal2Editable: Boolean;
        town2Editable: Boolean;
        passpoetEditable: Boolean;
        maritalstatus2Editable: Boolean;
        commonDetails: Boolean;
        payrollno2editable: Boolean;
        Employercode2Editable: Boolean;
        address3Editable: Boolean;
        HomePostalCode2Editable: Boolean;
        Employername2Editable: Boolean;
        ageEditable: Boolean;
        CopyofconstitutionEditable: Boolean;
        Table_id: Integer;
        Doc_No: Code[20];
        Doc_Type: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None","Payment Voucher","Petty Cash",Imprest,Requisition,ImprestSurrender,Interbank,TransportRequest,Maintenance,Fuel,ImporterExporter,"Import Permit","Export Permit",TR,"Safari Notice","Student Applications","Water Research","Consultancy Requests","Consultancy Proposals","Meals Bookings","General Journal","Student Admissions","Staff Claim",KitchenStoreRequisition,"Leave Application","Account Opening";
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        IncrementNo: Code[20];
        // MpesaAppH: Record "MPESA Applications";
        // MpesaAppD: Record "MPESA Application Details";
        // MpesaAppNo: Code[20];
        // ATMApp: Record "ATM Card Applications";
        MpesaMob: Boolean;
        MpesaCop: Boolean;
        CompInfo: Record "Company Information";
        SMSMessages: Record "SMS Messages";
        iEntryNo: Integer;
        SourceOfFunds: Boolean;
        RespCenter: Boolean;
        ShareCapContr: Boolean;
        AccoutTypes: Record "Account Types-Saving Products";
        Mtype: Boolean;
        TaxExemp: Boolean;
        AccountCategory: Boolean;
        DimensionValue: Record "Dimension Value";
        Dates: Codeunit "Dates Calculation";
        // Age: Text[100];

        NationalRe: Boolean;
        Jooint: Boolean;
        BusinessAccount: Boolean;
        Vendor: Record Vendor;
        SrestepApprovalsCodeUnit: Codeunit SurestepApprovalsCodeUnit;
        OpenApprovalEntriesExist: Boolean;
        EnabledApprovalWorkflowsExist: Boolean;
        RecordApproved: Boolean;
        CanCancelApprovalForRecord: Boolean;

        CreateAccount: Boolean;
        IEntry: integer;
        SMSToSend: Text[250];
        CoveragePercentStyle: Text;
        SwizzsoftFactory: Codeunit "Swizzsoft Factory";
        EmailCodeunit: Codeunit Emailcodeunit;

        IntegerAge: Integer;
        GuardianFound: Boolean;
        AgeText: Text[50];
        YearPart: Text[10];

        nomineeApp: Record "Member App Nominee";


    procedure UpdateControls()
    begin


        if Rec."Account Category" = Rec."account category"::"Regular Account" then begin
            groupAcc := false;
            Individual := true;
            Junior := false;
            commonDetails := true;
            Jooint := false;
            BusinessAccount := false;
            NameEditable := true;
            AddressEditable := true;
            GlobalDim1Editable := false;
            GlobalDim2Editable := true;
            CustPostingGroupEdit := false;
            PhoneEditable := true;
            MaritalstatusEditable := true;
            IDNoEditable := true;
            PhoneEditable := true;
            RegistrationDateEdit := true;
            OfficeBranchEditable := true;
            DeptEditable := true;
            SectionEditable := true;
            OccupationEditable := true;
            DesignationEdiatble := true;
            EmployerCodeEditable := true;
            DOBEditable := true;
            EmailEdiatble := true;
            StaffNoEditable := true;
            GenderEditable := true;
            MonthlyContributionEdit := true;
            PostCodeEditable := true;
            CityEditable := true;
            WitnessEditable := true;
            BankCodeEditable := true;
            BranchCodeEditable := true;
            BankAccountNoEditable := true;
            VillageResidence := true;
            TitleEditable := true;
            PostalCodeEditable := true;
            HomeAddressPostalCodeEditable := true;
            HomeTownEditable := true;
            RecruitedEditable := true;
            ContactPEditable := true;
            ContactPRelationEditable := true;
            ContactPOccupationEditable := true;
            CopyOFIDEditable := true;
            CopyofPassportEditable := true;
            SpecimenEditable := true;
            ContactPPhoneEditable := true;
            HomeAdressEditable := true;
            PictureEditable := true;
            SignatureEditable := true;
            PayslipEditable := true;
            RegistrationFeeEditable := true;
            CopyofKRAPinEditable := true;
            membertypeEditable := true;
            FistnameEditable := true;
            registrationeditable := false;
            EstablishdateEditable := false;
            RegistrationofficeEditable := false;
            Picture2Editable := true;
            Signature2Editable := false;
            title2Editable := false;
            emailaddresEditable := false;
            gender2editable := false;
            HomePostalCode2Editable := false;
            town2Editable := false;
            passpoetEditable := false;
            maritalstatus2Editable := false;
            payrollno2editable := false;
            Employercode2Editable := false;
            address3Editable := false;
            Employername2Editable := false;
            ageEditable := false;
            CopyofconstitutionEditable := false;
            commonDetails := true;

        end else
            if Rec."Account Category" = Rec."account category"::"Junior Account" then begin
                groupAcc := false;
                Junior := true;
                Individual := false;
                Jooint := false;
                FistnameEditable := true;
                commonDetails := true;

            end;


        if Rec.Status = Rec.Status::Approved then begin
            CreateAccount := false;
            CanCancelApprovalForRecord := false;
            NameEditable := false;
            NoEditable := false;
            AddressEditable := false;
            GlobalDim1Editable := false;
            GlobalDim2Editable := false;
            CustPostingGroupEdit := false;
            PhoneEditable := false;
            MaritalstatusEditable := false;
            IDNoEditable := false;
            PhoneEditable := false;
            RegistrationDateEdit := false;
            OfficeBranchEditable := false;
            DeptEditable := false;
            SectionEditable := false;
            OccupationEditable := false;
            DesignationEdiatble := false;
            EmployerCodeEditable := false;
            DOBEditable := false;
            EmailEdiatble := false;
            StaffNoEditable := false;
            GenderEditable := false;
            MonthlyContributionEdit := false;
            PostCodeEditable := false;
            CityEditable := false;
            WitnessEditable := false;
            BankCodeEditable := false;
            BranchCodeEditable := false;
            BankAccountNoEditable := false;
            VillageResidence := false;
            TitleEditable := false;
            PostalCodeEditable := false;
            HomeAddressPostalCodeEditable := false;
            HomeTownEditable := false;
            RecruitedEditable := false;
            ContactPEditable := false;
            ContactPRelationEditable := false;
            ContactPOccupationEditable := false;
            CopyOFIDEditable := false;
            CopyofPassportEditable := false;
            SpecimenEditable := false;
            ContactPPhoneEditable := false;
            HomeAdressEditable := false;
            PictureEditable := false;
            SignatureEditable := false;
            PayslipEditable := false;
            RegistrationFeeEditable := false;
            title2Editable := false;
            emailaddresEditable := false;
            gender2editable := false;
            HomePostalCode2Editable := false;
            town2Editable := false;
            passpoetEditable := false;
            maritalstatus2Editable := false;
            payrollno2editable := false;
            Employercode2Editable := false;
            address3Editable := false;
            Employername2Editable := false;
            ageEditable := false;
            CopyofconstitutionEditable := false;
            RecordApproved := true;
            CreateAccount := true;

        end;
        if Rec.Status = Rec.Status::"Pending Approval" then begin
            CreateAccount := false;
            CanCancelApprovalForRecord := ApprovalsMgmt.CanCancelApprovalForRecord(Rec.RecordId);
            NameEditable := false;
            NoEditable := false;
            AddressEditable := false;
            GlobalDim1Editable := false;
            GlobalDim2Editable := false;
            CustPostingGroupEdit := false;
            PhoneEditable := false;
            MaritalstatusEditable := false;
            IDNoEditable := false;
            PhoneEditable := false;
            RegistrationDateEdit := false;
            OfficeBranchEditable := false;
            DeptEditable := false;
            SectionEditable := false;
            OccupationEditable := false;
            DesignationEdiatble := false;
            EmployerCodeEditable := false;
            DOBEditable := false;
            EmailEdiatble := false;
            StaffNoEditable := false;
            GenderEditable := false;
            MonthlyContributionEdit := false;
            PostCodeEditable := false;
            CityEditable := false;
            WitnessEditable := false;
            BankCodeEditable := false;
            BranchCodeEditable := false;
            BankAccountNoEditable := false;
            VillageResidence := false;
            TitleEditable := false;
            PostalCodeEditable := false;
            HomeAddressPostalCodeEditable := false;
            HomeTownEditable := false;
            RecruitedEditable := false;
            ContactPEditable := false;
            ContactPRelationEditable := false;
            ContactPOccupationEditable := false;
            CopyOFIDEditable := false;
            CopyofPassportEditable := false;
            SpecimenEditable := false;
            ContactPPhoneEditable := false;
            HomeAdressEditable := false;
            PictureEditable := false;
            SignatureEditable := false;
            PayslipEditable := false;
            RegistrationFeeEditable := false;
            title2Editable := false;
            emailaddresEditable := false;
            gender2editable := false;
            HomePostalCode2Editable := false;
            town2Editable := false;
            passpoetEditable := false;
            maritalstatus2Editable := false;
            payrollno2editable := false;
            Employercode2Editable := false;
            address3Editable := false;
            Employername2Editable := false;
            ageEditable := false;
            CopyofconstitutionEditable := false;



        end;


        if Rec.Status = Rec.Status::Open then begin
            CreateAccount := false;
            CanCancelApprovalForRecord := ApprovalsMgmt.CanCancelApprovalForRecord(Rec.RecordId);
            NameEditable := true;
            AddressEditable := true;
            GlobalDim1Editable := false;
            GlobalDim2Editable := true;
            CustPostingGroupEdit := false;
            PhoneEditable := true;
            MaritalstatusEditable := true;
            IDNoEditable := true;
            PhoneEditable := true;
            RegistrationDateEdit := true;
            OfficeBranchEditable := true;
            DeptEditable := true;
            SectionEditable := true;
            OccupationEditable := true;
            DesignationEdiatble := true;
            EmployerCodeEditable := true;
            DOBEditable := true;
            EmailEdiatble := true;
            StaffNoEditable := true;
            GenderEditable := true;
            MonthlyContributionEdit := true;
            PostCodeEditable := true;
            CityEditable := true;
            WitnessEditable := true;
            BankCodeEditable := true;
            BranchCodeEditable := true;
            BankAccountNoEditable := true;
            VillageResidence := true;
            TitleEditable := true;
            PostalCodeEditable := true;
            HomeAddressPostalCodeEditable := true;
            HomeTownEditable := true;
            RecruitedEditable := true;
            ContactPEditable := true;
            ContactPRelationEditable := true;
            ContactPOccupationEditable := true;
            CopyOFIDEditable := true;
            CopyofPassportEditable := true;
            SpecimenEditable := true;
            ContactPPhoneEditable := true;
            HomeAdressEditable := true;
            PictureEditable := true;
            SignatureEditable := true;
            PayslipEditable := true;
            RegistrationFeeEditable := true;
            title2Editable := true;
            emailaddresEditable := true;
            gender2editable := true;
            HomePostalCode2Editable := true;
            town2Editable := true;
            passpoetEditable := true;
            maritalstatus2Editable := true;
            payrollno2editable := true;
            Employercode2Editable := true;
            address3Editable := true;
            Employername2Editable := true;
            ageEditable := false;
            mobile3editable := true;
            CopyofconstitutionEditable := true;

        end;

    end;


    procedure SendSMS()
    begin
        CompInfo.Get();
        GenSetUp.Get();
        SMSMessages.Reset;
        if SMSMessages.Find('+') then begin
            iEntryNo := SMSMessages."Entry No";
            iEntryNo := iEntryNo + 1;
        end else begin
            iEntryNo := 1;
        end;

        SMSMessages.Init;
        SMSMessages."Entry No" := iEntryNo;
        SMSMessages."Account No" := Rec."No.";
        SMSMessages."Date Entered" := Today;
        SMSMessages."Time Entered" := Time;
        SMSMessages.Source := 'MEMBERREGISTRATION';
        SMSMessages."Entered By" := UserId;
        SMSMessages."System Created Entry" := true;
        SMSMessages."Document No" := Rec."No.";
        SMSMessages."Telephone No" := Rec."Mobile Phone No";
        SMSMessages."Sent To Server" := SMSMessages."sent to server"::No;
        SMSMessages."SMS Message" := 'Dear Member your account has been created successfully, your Account No is '
        + BOSAACC + '  Account Name ' + Rec.Name + ' .' + 'You can now Deposit Via PayBill 587649. Thank You For Choosing to Save With Us';
        SMSMessages.Insert;

    end;


    procedure SendMail(MemberNumber: Text[70])
    var
        EmailBody: Text[1000];
        EmailSubject: Text[100];
        Emailaddress: Text[100];
        Companyinfo: Record "Company Information";
    begin

        if Rec."Account Category" = Rec."Account Category"::"Junior Account" then begin
            //Send Email to the Guardian
        end else begin

            Emailaddress := Rec."E-Mail (Personal)";



            EmailSubject := 'KRB Membership Application';

            // EMailBody := 'Dear <b>' + Name + '</b>,</br></br>' +
            // 'On behalf of KRB Sacco am pleased to inform you that your application for membership has been accepted. Your Membership Number is' + MemberNumber + '<br></br>' +
            // 'Thank You For Choosing to Save With Us' +'</br>' +
            // 'Kind regards,'+ '<br></br>' +
            // 'KRB Sacco' ;
            EMailBody := 'Dear <b>' + Rec.Name + '</b>,</br></br>' +
                        'On behalf of KRB Sacco am pleased to inform you that your application for membership has been accepted.' + '<br></br>' +
                        'Congratulations' +
                        Companyinfo.Name + '</br>' + Companyinfo.Address + '</br>' + Companyinfo.City + '</br>' +
                        Companyinfo."Post Code" + '</br>' + Companyinfo."Country/Region Code" + '</br>' +
                        Companyinfo."Phone No." + '</br>' + Companyinfo."E-Mail";
            EmailCodeunit.SendMail(Emailaddress, EmailSubject, EmailBody);
        end;
    end;

    local procedure FnCreateBOSAMemberAccounts()
    var
        NoSeriesLine: Record "No. Series Line";

    begin
        Saccosetup.Get();

        //Getting the next Member Number
        if Rec."Account Category" = Rec."Account Category"::"Junior Account" then begin
            NewMembNo := NoSeriesMgt.TryGetNextNo(ObjNoSeries."Junior Account No.", today);
            NoSeriesLine.RESET;
            NoSeriesLine.SETRANGE(NoSeriesLine."Series Code", ObjNoSeries."Junior Account No.");
            IF NoSeriesLine.FINDSET THEN BEGIN
                NoSeriesLine."Last No. Used" := INCSTR(NoSeriesLine."Last No. Used");
                NoSeriesLine."Last Date Used" := TODAY;
                NoSeriesLine.MODIFY;
            END;
        end else begin

            NewMembNo := NoSeriesMgt.TryGetNextNo(ObjNoSeries."Members Nos", today);
            NoSeriesLine.RESET;
            NoSeriesLine.SETRANGE(NoSeriesLine."Series Code", ObjNoSeries."Members Nos");
            IF NoSeriesLine.FINDSET THEN BEGIN
                NoSeriesLine."Last No. Used" := INCSTR(NoSeriesLine."Last No. Used");
                NoSeriesLine."Last Date Used" := TODAY;
                NoSeriesLine.MODIFY;
            END;

        end;


        //Create BOSA account
        Cust.Init;
        Cust."No." := Format(NewMembNo);
        Cust.Name := Rec.Name;

        Cust."Group Account Name" := Rec.Name;
        Cust."Nature of Business" := Rec."Nature of Business";
        Cust.Address := Rec.Address;
        Cust."Post Code" := Rec."Postal Code";
        Cust.Pin := Rec."KRA Pin";
        Cust.County := Rec.City;



        Cust."Phone No." := Rec."Mobile Phone No";
        Cust."Global Dimension 1 Code" := Rec."Global Dimension 1 Code";
        Cust."Global Dimension 2 Code" := Rec."Global Dimension 2 Code";
        Cust."Customer Posting Group" := Rec."Customer Posting Group";
        Cust."Registration Date" := Today;
        Cust."Mobile Phone No" := Rec."Mobile Phone No";
        Cust.Status := Cust.Status::Active;

        Cust."Employment Info" := Rec."Employment Info";
        Cust."Employer Code" := Rec."Employer Code";
        Cust."Employer Name" := Rec."Employer Name";
        Cust."Date of Birth" := Rec."Date of Birth";
        Cust."Station/Department" := Rec."Station/Department";
        Cust."E-Mail" := Rec."E-Mail (Personal)";
        Cust.Location := Rec.Location;
        Cust.Title := Rec.Title;
        Cust."Home Address" := Rec."Home Address";
        Cust."Home Postal Code" := Rec."Home Postal Code";
        Cust."Home Town" := Rec."Home Town";
        Cust."Recruited By" := Rec."Recruited By";
        Cust."Contact Person" := Rec."Contact Person";
        Cust."ContactPerson Relation" := Rec."ContactPerson Relation";
        Cust."ContactPerson Occupation" := Rec."ContactPerson Occupation";
        Cust."Account Category" := Rec."Account Category";
        //---Junior Accounts
        Cust."Guardian No." := Rec."Guardian No.";
        Cust."Guardian Name" := Rec."Guardian Name";
        Cust."Birth Certficate No." := Rec."Birth Certficate No.";

        //**
        Cust."Office Branch" := Rec."Office Branch";
        Cust.Department := Rec.Department;
        Cust.Occupation := Rec.Occupation;
        Cust.Designation := Rec.Designation;
        Cust."Bank Code" := Rec."Bank Code";
        Cust."Bank Branch Code" := Rec."Bank Name";
        Cust."Bank Account No." := Rec."Bank Account No";
        //**
        //Joint
        Cust."Share Of Ownership One" := Rec."Share Of Ownership One";
        Cust."Source of Income Member One" := Rec."Source of Income Member One";
        Cust."ID NO/Passport 2" := Rec."ID NO/Passport 2";
        Cust.JointRelationship := Rec.JointRelationship;
        Cust."Reasontocreatingajointaccount" := Rec.Reasontocreatingajointaccount;
        Cust.Gender2 := Rec.Gender2;
        Cust."Marital Status2" := Rec."Marital Status2";
        Cust."Date of Birth2" := Rec."Date of Birth2";
        Cust."Mobile No. 3" := Rec."Mobile No. 3";
        Cust."E-Mail (Personal2)" := Rec."E-Mail (Personal2)";
        Cust."Home Postal Code2" := Rec."Home Postal Code2";
        Cust."Home Town2" := Rec."Home Town2";
        Cust."Payroll/Staff No2" := Rec."Payroll/Staff No2";
        // Cust."Employer Code2" := Rec."Employer Code2";
        Cust."Share Of Ownership Two" := Rec."Share Of Ownership Two";
        Cust."Employer Name2" := Rec."Employer Name2";
        Cust."Source of IncomeMember Two" := Rec."Source of IncomeMember Two";
        //**

        Cust."Sub-Location" := Rec."Sub-Location";
        Cust.District := Rec.District;
        Cust."Payroll/Staff No" := Rec."Payroll No";
        Cust."ID No." := Rec."ID No.";
        Cust."Mobile Phone No" := Rec."Mobile Phone No";
        Cust."Marital Status" := Rec."Marital Status";
        Cust."Customer Type" := Cust."customer type"::Member;
        Cust.Gender := Rec.Gender;
        Cust."Sms Notification" := Rec."Sms Notification";
        Cust.Age := Rec.Age;

        Cust.Image := Rec.Picture;
        Cust.Signature := Rec.Signature;
        Cust.IPRS := Rec.IPRS;
        //========================================================================Member Risk Rating
        Cust."Individual Category" := Rec."Individual Category";
        Cust."Entities" := Rec.Entities;
        // Cust."Member Risk Level" := (Rec."Member Risk Level");
        // Cust."Due Diligence Measure" := Format(Rec."Due Diligence Measure");
        Cust."Member Residency Status" := Rec."Member Residency Status";
        Cust."Industry Type" := Rec."Industry Type";
        // Cust."Length Of Relationship" := Rec."Length Of Relationship";
        Cust."International Trade" := Rec."International Trade";
        Cust."Electronic Payment" := Rec."Electronic Payment";
        Cust."Accounts Type Taken" := Rec."Accounts Type Taken";
        Cust."Cards Type Taken" := Rec."Cards Type Taken";
        //========================================================================
        Cust."Monthly Contribution" := Rec."Monthly Contribution";
        Cust."Contact Person" := Rec."Contact Person";
        Cust."Contact Person Phone" := Rec."Contact Person Phone";
        Cust."ContactPerson Relation" := Rec."ContactPerson Relation";
        Cust."Recruited By" := Rec."Recruited By";
        Cust."ContactPerson Occupation" := Rec."ContactPerson Occupation";
        Cust."Village/Residence" := Rec."Village/Residence";
        Cust.Insert(true);

        Saccosetup."Last Memb No." := IncStr(NewMembNo);
        Saccosetup.Modify;
        BOSAACC := Cust."No.";

    end;

    local procedure FnGetPostingGroup(ProductCode: Code[40]): Code[20]
    var
        SavingsAccountTypes: Record "Account Types-Saving Products";
    begin
        SavingsAccountTypes.Reset();
        SavingsAccountTypes.SetRange(SavingsAccountTypes.Code, ProductCode);
        if SavingsAccountTypes.find('-') then begin
            exit(SavingsAccountTypes."Posting Group");
        end;
    end;

    local procedure FnCreateNextOfKinDetails(MemberNo: text[70])
    var
        NextofKinBOSA: Record "Members Next Kin Details";
    begin
        NextOfKinApp.Reset;
        NextOfKinApp.SetRange(NextOfKinApp."Account No", Rec."No.");
        if NextOfKinApp.Find('-') then begin
            repeat
                //......................................BOSA
                NextofKinBOSA.Init;
                NextofKinBOSA."Account No" := MemberNo;
                NextofKinBOSA.Name := NextOfKinApp.Name;
                NextofKinBOSA.Relationship := NextOfKinApp.Relationship;
                NextofKinBOSA.Beneficiary := NextOfKinApp.Beneficiary;
                NextofKinBOSA."Date of Birth" := NextOfKinApp."Date of Birth";
                NextofKinBOSA.Address := NextOfKinApp.Address;
                NextofKinBOSA.Telephone := NextOfKinApp.Telephone;
                NextofKinBOSA.Fax := NextOfKinApp.Fax;
                NextofKinBOSA.Email := NextOfKinApp.Email;
                NextofKinBOSA."ID No." := NextOfKinApp."ID No.";
                NextofKinBOSA."%Allocation" := NextOfKinApp."%Allocation";
                NextofKinBOSA.Type := NextOfKin.Type;
                NextofKinBOSA.Insert;

            until NextOfKinApp.Next = 0;
        end;
    end;

    local procedure FnCreateNomineeDetails(MemberNo: text[70])
    var
        // NextofKinBOSA: Record "Members Next Kin Details";
        //nomineeApp: Record "Member App Nominee";
        membersNominee: Record "Members Nominee";
    begin

        nomineeApp.Reset;
        nomineeApp.SetRange(nomineeApp."Account No", Rec."No.");
        if nomineeApp.Find('-') then begin
            repeat
                //......................................BOSA
                membersNominee.Init;
                membersNominee."Account No" := MemberNo;
                membersNominee.Name := nomineeApp.Name;
                membersNominee.Relationship := nomineeApp.Relationship;
                membersNominee.Beneficiary := nomineeApp.Beneficiary;
                membersNominee."Date of Birth" := nomineeApp."Date of Birth";
                // membersNominee.Address := nomineeApp.Address;
                membersNominee.Telephone := nomineeApp.Telephone;
                // membersNominee.Fax := nomineeApp.Fax;
                // membersNominee.Email := nomineeApp.Email;
                membersNominee."ID No." := nomineeApp."ID No.";
                membersNominee."%Allocation" := nomineeApp."%Allocation";
                membersNominee."Next Of Kin Type" := NextOfKin.Type;
                membersNominee.Insert;

            until nomineeApp.Next = 0;
        end;
    end;

    local procedure FnCreateAccountSignatories(MemberNo: text[70])
    begin
        AccountSignApp.Reset;
        AccountSignApp.SetRange(AccountSignApp."Account No", Rec."No.");
        if AccountSignApp.Find('-') then begin
            repeat
                AccountSign.Init;
                AccountSign."Account No" := MemberNo;
                AccountSign.Names := AccountSignApp.Names;
                AccountSign."Date Of Birth" := AccountSignApp."Date Of Birth";
                AccountSign."Staff/Payroll" := AccountSignApp."Staff/Payroll";
                AccountSign."ID No." := AccountSignApp."ID No.";

                AccountSign.Signatory := AccountSignApp.Signatory;
                AccountSign."Must Sign" := AccountSignApp."Must Sign";
                AccountSign."Must be Present" := AccountSignApp."Must be Present";
                AccountSign.Picture := AccountSignApp.Picture;
                AccountSign.Signature := AccountSignApp.Signature;
                AccountSign."Expiry Date" := AccountSignApp."Expiry Date";
                AccountSign."Mobile Phone No" := AccountSignApp."Mobile No.";
            until AccountSignApp.Next = 0;
        end;
    end;

    local procedure FnCreateGroupMembers()

    begin
        BosaAPPGroup.Reset;
        BosaAPPGroup.SetRange(BosaAPPGroup."Account No", Rec."No.");
        if BosaAPPGroup.Find('-') then begin
            repeat
                //......................................BOSA
                BosacustGroup.Init;
                BosacustGroup."Account No" := NewMembNo;
                BosacustGroup."Date of Birth" := BosaAPPGroup."Date of Birth";
                BosacustGroup.E_Mail := BosaAPPGroup.E_Mail;
                BosacustGroup.Employer := BosaAPPGroup.Employer;
                BosacustGroup."ID Number/Passport Number" := BosaAPPGroup."ID Number/Passport Number";
                BosacustGroup."Mobile Phone Number" := BosaAPPGroup."Mobile Phone Number";
                BosacustGroup.Name := BosaAPPGroup.Name;
                BosacustGroup.Nationality := BosaAPPGroup.Nationality;
                BosacustGroup.Occupation := BosaAPPGroup.Occupation;
                BosacustGroup."Specimen Passport" := BosaAPPGroup."Specimen Passport";
                BosacustGroup."Specimen Signature" := BosaAPPGroup."Specimen Signature";
            until BosaAPPGroup.Next = 0;
        end;
    end;


    local procedure FnGenerateNextNumberSeries(): Code[20]
    var
        SaccoNoSeries: Record "Sacco No. Series";
        NoSeriesManagement: Codeunit NoSeriesManagement;
    begin
        SaccoNoSeries.Get();
        SaccoNoSeries.TestField(SaccoNoSeries."SwizzKash Reg No.");
        EXIT(NoSeriesManagement.GetNextNo(SaccoNoSeries."SwizzKash Reg No.", 0D, true));
        exit('Error generating No series of mobile applications');
    end;

    local procedure FnSendSMSOnAccountOpening()
    var
    begin
        SMSToSend := 'Dear Member your account has been created successfully, your Account No is '
        + BOSAACC + '  Account Name ' + Rec.Name + ' .' + 'You can now Deposit Via PayBill 587649. Thank You For Choosing to Bank With Us';
        IEntry := 0;
        SMSMessages.Reset();
        if SMSMessages.Find('+') then begin
            iEntryNo := SMSMessages."Entry No";
            iEntryNo := iEntryNo + 1;
        end else begin
            iEntryNo := 1;
        end;
        SMSMessages.Reset();
        SMSMessages."Entry No" := iEntryNo;
        SMSMessages."Batch No" := '';
        SMSMessages."Document No" := Rec."No.";
        SMSMessages."Account No" := Cust."No.";
        SMSMessages."Date Entered" := Today;
        SMSMessages."Time Entered" := Time;
        SMSMessages.Source := 'MEMBERREGISTRATION';
        SMSMessages."Entered By" := UserId;
        SMSMessages."Sent To Server" := SMSMessages."Sent To Server"::No;
        SMSMessages."SMS Message" := SMSToSend;
        SMSMessages."Telephone No" := Rec."Mobile Phone No";
        SMSMessages.Insert();
    end;

    trigger OnAfterGetRecord()
    begin
        //............................
        SetStyles();

        OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(REC.RecordId);//Return No and allow sending of approval request.

        EnabledApprovalWorkflowsExist := true;
        //............................
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    var
        UserMgt: Codeunit "User Management";
    begin
        //FnUpdateEditableControls();
    end;

    local procedure SetStyles()
    begin
        CoveragePercentStyle := 'Strong';
        if Rec."Member Risk Level" <> Rec."member risk level"::"Low Risk" then
            CoveragePercentStyle := 'Unfavorable';
        if Rec."Member Risk Level" = Rec."member risk level"::"Low Risk" then
            CoveragePercentStyle := 'Favorable';
    end;

}
