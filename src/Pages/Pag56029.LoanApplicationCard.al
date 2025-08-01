#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 56029 "Loan Application Card"
{
    DeleteAllowed = true;
    Editable = true;
    PageType = Card;
    PromotedActionCategories = 'New,Process,Reports,Approval,Budgetary Control,Cancellation,Category7_caption,Category8_caption,Category9_caption,Category10_caption';
    SourceTable = "Loans Register";
    SourceTableView = where(Source = const(BOSA),
                            Posted = const(false));

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Loan  No."; Rec."Loan  No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }

                field("Client Code"; Rec."Client Code")
                {
                    ApplicationArea = Basic;
                    Caption = 'Member';
                    Editable = MNoEditable;
                    ShowMandatory = true;
                }
                field("Loan Product Type"; Rec."Loan Product Type")
                {
                    ApplicationArea = Basic;
                    Style = StrongAccent;
                    Editable = LProdTypeEditable;
                    ShowMandatory = true;
                    trigger OnValidate()
                    begin
                        // if FnMemberHasAnExistingLoanSameProduct() = true then begin
                        //     error('Member Has An Existing Loan Of Product-' + Format("Loan Product Type") + ' with an outstanding balance of Ksh. ' + Format(FnGetProductOutstandingBal()));
                        // end;
                    end;
                }
                field("Loan Product Name"; Rec."Loan Product Type Name")
                {
                    ApplicationArea = Basic;
                    Style = StrongAccent;
                    Editable = false;
                    Visible = true;
                }

                field("Account Category"; Rec."Member Category")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("Client Name"; Rec."Client Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Style = StrongAccent;
                }
                field("Member Deposits"; Rec."Member Deposits")
                {
                    ApplicationArea = Basic;
                    Style = Unfavorable;
                    Editable = false;
                }

                field(Mulitiplier; Rec."Loan Deposit Multiplier")
                {
                    ApplicationArea = Basic;
                    Editable = true;
                    Style = StrongAccent;
                }
                // field("Deposits Mulitiplier"; Rec."Deposits Mulitiplier")
                // {
                //     ApplicationArea = Basic;
                //     Editable = true;
                //     Style = StrongAccent;
                // }
                field("Existing Loan"; Rec."Existing Loan")
                {
                    ApplicationArea = basic;
                    Editable = false;
                }
                field("Application Date"; Rec."Application Date")
                {
                    ApplicationArea = Basic;
                    Editable = true;

                    trigger OnValidate()
                    begin
                        Rec.TestField(Posted, false);
                    end;
                }
                field("Estimated Years to Retire"; Rec."Estimated Years to Retire")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field(Installments; Rec.Installments)
                {
                    ApplicationArea = Basic;
                    Editable = InstallmentEditable;
                    ShowMandatory = true;

                    trigger OnValidate()
                    begin
                        Rec.TestField(Posted, false);
                    end;
                }
                field(Interest; Rec.Interest)
                {
                    ApplicationArea = Basic;
                    Editable = EditableField;
                    Caption = 'Interest Rate';
                }
                field("Requested Amount"; Rec."Requested Amount")
                {
                    ApplicationArea = Basic;
                    Caption = 'Amount Applied';
                    Editable = AppliedAmountEditable;
                    ShowMandatory = true;
                    Style = Strong;

                    trigger OnValidate()
                    begin
                        Rec.TestField(Posted, false);
                    end;
                }
                field("Deboost Loan"; Rec."Deboost Loan Applied")
                {
                    Visible = false;
                    ApplicationArea = all;
                    trigger OnValidate()
                    var
                        myInt: Integer;
                        Loanoffeset: Record "Loan Offset Details";
                        OffesetAmount: Decimal;
                    begin
                        if Rec."Deboost Loan Applied" = true then begin
                            begin
                                OffesetAmount := 0;
                                Loanoffeset.Reset();
                                Loanoffeset.SetRange(Loanoffeset."Loan No.", Rec."Loan  No.");
                                if Loanoffeset.FindSet() then begin
                                    repeat
                                        OffesetAmount := OffesetAmount + Loanoffeset."Principle Top Up"
                                    Until Loanoffeset.Next = 0;
                                end;
                                if (Rec."Member Deposits" * Rec."Loan Deposit Multiplier") < ((rec."Requested Amount" + Rec."Existing Loan") - OffesetAmount) then begin
                                    Rec."Deboost Amount" := ((((rec."Requested Amount" + (Rec."Existing Loan" - OffesetAmount))) - (Rec."Member Deposits" * 3)) / 3);
                                    Rec."Deboost Commision" := Rec."Deboost Amount" * 0.05;
                                    //Message('Debost amount %1 %2', "Deboost Amount", "Deboost Commision");
                                    rec.Modify;
                                end;
                            end;
                        end;
                    end;
                }
                field("Deboost Amount"; Rec."Deboost Amount")
                {
                    Visible = false;
                    ApplicationArea = all;
                    Editable = true;

                }
                field("Deboost Commision"; Rec."Deboost Commision")
                {
                    Visible = false;
                    ApplicationArea = all;
                    Editable = true;
                }

                field("Approved Amount"; Rec."Approved Amount")
                {
                    ApplicationArea = Basic;
                    Caption = 'Approved Amount';
                    Editable = false;
                    ShowMandatory = true;
                    Visible = false;

                    trigger OnValidate()
                    begin
                        Rec.TestField(Posted, false);

                    end;
                }
                field("Recommended Amount"; Rec."Recommended Amount")
                {
                    Editable = false;
                    ApplicationArea = all;
                }
                // field("Main Sector"; Rec."Main-Sector")
                // {
                //     ApplicationArea = Basic;
                //     ShowMandatory = false;
                //     Style = Ambiguous;
                //     Editable = MNoEditable;


                //     trigger OnValidate()
                //     begin
                //         Rec.TestField(Posted, false);
                //     end;
                // }
                // field("Sub-Sector"; Rec."Sub-Sector")
                // {
                //     ApplicationArea = Basic;
                //     ShowMandatory = true;
                //     TableRelation = "Sub Sector".Code where(No = field("Main-Sector"));

                //     trigger OnValidate()
                //     begin
                //         Rec.TestField(Posted, false);
                //     end;
                // }
                // field("Specific Sector"; Rec."Specific-Sector")
                // {
                //     ApplicationArea = Basic;
                //     ShowMandatory = true;
                //     TableRelation = "Specific Sector".Code where(No = field("Sub-Sector"));

                //     trigger OnValidate()
                //     begin
                //         Rec.TestField(Posted, false);
                //     end;
                // }

                field(Remarks; Rec.Remarks)
                {
                    Caption = 'Loan Purpose';
                    ApplicationArea = Basic;
                    Editable = MNoEditable;

                }
                field("Repayment Method"; Rec."Repayment Method")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Loan Principle Repayment"; Rec."Loan Principle Repayment")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Loan Interest Repayment"; Rec."Loan Interest Repayment")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Loan Insurance"; Rec."Loan Insurance")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Repayment; Rec.Repayment)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Valuation Cost"; Rec."Valuation Cost")
                {
                    ApplicationArea = Basic;
                }
                field("Faciliation Cost"; Rec."Facilitation Cost")
                {

                    ApplicationArea = Basic;
                    Editable = false;

                }
                field("Bank Transfer Charges"; Rec."Bank Transfer Charges")
                {
                    ApplicationArea = Basic;
                    Editable = true;
                    ShowMandatory = true;
                }
                field("Loan Status"; Rec."Loan Status")
                {
                    ApplicationArea = Basic;
                    Editable = false;

                    trigger OnValidate()
                    begin
                        UpdateControl();
                    end;
                }
                field("Approval Status"; Rec."Approval Status")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Repayment Frequency"; Rec."Repayment Frequency")
                {
                    ApplicationArea = Basic;
                    Editable = RepayFrequencyEditable;
                    Style = StrongAccent;
                    ShowMandatory = true;
                }
                field("Recovery Mode"; Rec."Recovery Mode")
                {
                    ApplicationArea = Basic;
                    Style = StrongAccent;
                    ShowMandatory = true;
                    Editable = MNoEditable;
                    OptionCaption = 'Checkoff,Standing Order,Salary,Dividend';
                }
                field("Mode of Disbursement"; Rec."Mode of Disbursement")
                {
                    ApplicationArea = Basic;
                    Editable = MNoEditable;
                    ShowMandatory = true;
                }
                field("Loan Disbursement Date"; Rec."Loan Disbursement Date")
                {
                    ApplicationArea = Basic;
                    // Editable = MNoEditable;
                    Editable = true;
                    Style = StrongAccent;
                    ShowMandatory = true;
                }
                field("Paying Bank Account No"; Rec."Paying Bank Account No")
                {
                    ApplicationArea = basic;
                    Editable = false;
                }
                field("Repayment Start Date"; Rec."Repayment Start Date")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Expected Date of Completion"; Rec."Expected Date of Completion")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Total TopUp Commission"; Rec."Total TopUp Commission")
                {
                    ApplicationArea = Basic;
                    Editable = MNoEditable;
                    Visible = false;

                }
                field("Captured By"; Rec."Captured By")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
            }
            group("Bank Details")
            {

                field("Bank Code"; Rec."Bank Code")
                {
                    ApplicationArea = Basic;
                    Caption = 'Bank Code';
                    ShowMandatory = true;
                    NotBlank = true;
                }
                field("Bank Name"; Rec."Bank Name")
                {
                    ApplicationArea = Basic;
                    Caption = 'Bank Name';
                    Editable = false;
                }
                field("Bank Branch"; Rec."Bank Branch")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Bank Account No"; Rec."Bank Account")
                {
                    ApplicationArea = Basic;
                }
            }
            part(Control1000000003; "Loans CheckRisk List")
            {
                Caption = 'Loan Risk Checking';
                ApplicationArea = Basic;
                SubPageLink = "Client Code" = field("Client Code");
                Editable = false;
            }
            part(Control1000000004; "Loans Guarantee Details")
            {
                Caption = 'Guarantors  Detail';
                ApplicationArea = Basic;
                SubPageLink = "Loan No" = field("Loan  No.");
                Editable = MNoEditable;
            }

        }
        area(factboxes)
        {
            part("Member Statistics FactBox"; "Member Statistics FactBox")
            {
                SubPageLink = "No." = field("Client Code");
                ApplicationArea = Basic;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Loan)
            {
                Caption = 'Loan';
                Image = AnalysisView;
                action("Loan Appraisal Edit")
                {
                    ApplicationArea = Basic;
                    Caption = 'Loan Appraisal';
                    Enabled = true;
                    Image = Aging;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    PromotedOnly = true;

                    trigger OnAction()
                    var
                        LoanApp: Record "Loans Register";
                        EntryNos: Integer;
                        Audit: Record "Audit Entries";
                    begin
                        //Audit Entries
                        if (UserId <> '') then begin
                            EntryNos := 0;
                            if Audit.FindLast then
                                EntryNos := 1 + Audit."Entry No";
                            Audit.Init;
                            Audit."Entry No" := EntryNos;
                            Audit."Transaction Type" := 'Loan Appraisal';
                            Audit."Loan Number" := Rec."Loan  No.";
                            Audit."Document Number" := Rec."Loan  No.";
                            Audit.UsersId := UserId;
                            Audit.Amount := Rec."Requested Amount";
                            Audit.Date := Today;
                            Audit.Time := Time;
                            Audit.Source := 'LOAN APPLICATION';
                            Audit.Insert;
                            Commit;
                        end;
                        //End Audit Entries

                        LoanApp.Reset;
                        LoanApp.SetRange(LoanApp."Loan  No.", Rec."Loan  No.");
                        if LoanApp.Find('-') then begin
                            Report.Run(56384, true, false, LoanApp);
                        end;

                    end;
                }

                action("Send Approvals")
                {
                    Caption = 'Send For Approval';
                    Enabled = (not OpenApprovalEntriesExist) AND EnabledApprovalWorkflowsExist AND (not RecordApproved);

                    Image = SendApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Process;
                    trigger OnAction()
                    var
                        SystemGenSet: Codeunit "System General Setup";
                    begin
                        //................Ensure than you cant have two loans same product
                        // SystemGenSet.FnCheckNoOfLoansLimit("Loan  No.", "Loan Product Type", "Client Code");
                        //----------------
                        Rec.Get(Rec."Loan  No.");
                        FnCheckForTestFields();
                        if Confirm('Send Approval Request For Loan Application of Ksh. ' + Format(Rec."Approved Amount") + ' applied by ' + Format(Rec."Client Name") + ' ?', false) = false then begin
                            exit;
                        end else begin
                            SwizzApprovalsCodeUnit.SendLoanApplicationsRequestForApproval(rec."Loan  No.", Rec);
                            Rec."Approval Status" := Rec."Approval Status"::Pending;
                            Rec."Loan Status" := Rec."Loan Status"::Appraisal;
                            FnSendLoanApprovalNotifications();
                            CurrPage.close();
                        end;
                    end;
                }
                action("Cancel Approvals")
                {
                    Caption = 'Cancel For Approval';
                    Enabled = CanCancelApprovalForRecord;
                    Image = CancelApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Process;
                    trigger OnAction()
                    begin
                        if Confirm('Cancel Approval?', false) = false then begin
                            exit;
                        end else begin
                            SwizzApprovalsCodeUnit.CancelLoanApplicationsRequestForApproval(rec."Loan  No.", Rec);
                            CurrPage.Close();
                        end;
                    end;
                }
                action("Member Statement")
                {
                    ApplicationArea = Basic;
                    Promoted = true;
                    PromotedCategory = Process;
                    Image = Report;

                    trigger OnAction()
                    begin
                        Cust.Reset;
                        Cust.SetRange(Cust."No.", Rec."Client Code");
                        // Report.Run(50223, true, false, Cust);
                        Report.Run(56886, true, false, Cust);
                    end;
                }
                action("View Schedule")
                {
                    ApplicationArea = Basic;
                    Caption = 'View Schedule';
                    Image = ViewDetails;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        if (Rec."Repayment Start Date" = 0D) then
                            Error('Please enter Disbursement Date to continue');

                        SFactory.FnGenerateRepaymentSchedule(Rec."Loan  No.");

                        LoanApp.Reset;
                        LoanApp.SetRange(LoanApp."Loan  No.", Rec."Loan  No.");
                        if LoanApp.Find('-') then begin
                            Report.Run(50477, true, false, LoanApp);
                        end;
                    end;
                }
                separator(Action1102755012)
                {
                }
                action("Loans to Offset")
                {
                    ApplicationArea = Basic;
                    Caption = 'Loans to Offset';
                    Image = AddAction;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Loan Offset Detail List";
                    RunPageLink = "Loan No." = field("Loan  No."),
                                  "Client Code" = field("Client Code");
                }
                action("Loan Appraisal Salary Details")
                {
                    Visible = false;
                    ApplicationArea = Basic;
                    Caption = 'Loan Appraisal Salary Details';
                    Image = AddAction;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Loan Appraisal Salary Details";
                    RunPageLink = "Loan No" = field("Loan  No."),
                                  "Client Code" = field("Client Code");
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        UpdateControl();
        OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(REC.RecordId);//Return No and allow sending of approval request.

        EnabledApprovalWorkflowsExist := true;

        if IsViewOnlyMode then begin
            CurrPage.Editable := false;
            CanCancelApprovalForRecord := false;
        end;


    end;

    trigger OnAfterGetRecord()
    begin
        UpdateControl();
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        LoansR.Reset;
        LoansR.SetRange(LoansR.Posted, false);
        LoansR.SetRange(LoansR."Captured By", UserId);
        if LoansR."Client Name" = '' then begin
            if LoansR.Count > 1 then begin
                if Confirm('There are still some Unused Loan Nos. Continue?', false) = false then begin
                    Error('There are still some Unused Loan Nos. Please utilise them first');
                end;
            end;
        end;
    end;

    trigger OnModifyRecord(): Boolean
    begin
        LoanAppPermisions();
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.Source := Rec.Source::BOSA;
        Rec."Mode of Disbursement" := Rec."mode of disbursement"::"Cheque";
        Rec."Mode of Disbursement" := Rec."Mode Of Disbursement"::Cash;
    end;

    trigger OnNextRecord(Steps: Integer): Integer
    begin


    end;

    trigger OnOpenPage()
    begin
        Rec.SetRange(Posted, false);

    end;

    var
        LoanGuar: Record "Loans Guarantee Details";
        SMSMessages: Record "SMS Messages";
        i: Integer;
        LoanType: Record "Loan Products Setup";
        PeriodDueDate: Date;
        ScheduleRep: Record "Loan Repayment Schedule";
        RunningDate: Date;
        G: Integer;
        IssuedDate: Date;
        GracePeiodEndDate: Date;
        InstalmentEnddate: Date;
        GracePerodDays: Integer;
        InstalmentDays: Integer;
        NoOfGracePeriod: Integer;
        NewSchedule: Record "Loan Repayment Schedule";
        RSchedule: Record "Loan Repayment Schedule";
        GP: Text[30];
        ScheduleCode: Code[20];
        PreviewShedule: Record "Loan Repayment Schedule";
        PeriodInterval: Code[10];
        CustomerRecord: Record Customer;
        Gnljnline: Record "Gen. Journal Line";
        //  Jnlinepost: Codeunit "Gen. Jnl.-Post Line";
        CumInterest: Decimal;
        NewPrincipal: Decimal;
        PeriodPrRepayment: Decimal;
        GenBatch: Record "Gen. Journal Batch";
        LineNo: Integer;
        GnljnlineCopy: Record "Gen. Journal Line";
        NewLNApplicNo: Code[10];
        Cust: Record Customer;
        EmailCodeunit: Codeunit Emailcodeunit;
        SurestepFactory: Codeunit "Swizzsoft Factory";
        LoanApp: Record "Loans Register";
        TestAmt: Decimal;
        CustRec: Record Customer;
        CustPostingGroup: Record "Customer Posting Group";
        GenSetUp: Record "Sacco General Set-Up";
        PCharges: Record "Loan Product Charges";
        TCharges: Decimal;
        LAppCharges: Record "Loan Applicaton Charges";
        LoansR: Record "Loans Register";
        LoanAmount: Decimal;
        InterestRate: Decimal;
        RepayPeriod: Integer;
        LBalance: Decimal;
        RunDate: Date;
        InstalNo: Decimal;
        RepayInterval: DateFormula;
        TotalMRepay: Decimal;
        LInterest: Decimal;
        LPrincipal: Decimal;
        RepayCode: Code[40];
        GrPrinciple: Integer;
        GrInterest: Integer;
        QPrinciple: Decimal;
        QCounter: Integer;
        InPeriod: DateFormula;
        InitialInstal: Integer;
        InitialGraceInt: Integer;
        GenJournalLine: Record "Gen. Journal Line";
        FOSAComm: Decimal;
        BOSAComm: Decimal;
        LoanTopUp: Record "Loan Offset Details";
        Vend: Record Vendor;
        BOSAInt: Decimal;
        TopUpComm: Decimal;
        DActivity: Code[20];
        DBranch: Code[20];
        TotalTopupComm: Decimal;
        //Notification: Codeunit Mail;
        CustE: Record Customer;
        DocN: Text[50];
        DocM: Text[100];
        DNar: Text[250];
        DocF: Text[50];
        MailBody: Text[250];
        ccEmail: Text[250];
        LoanG: Record "Loans Guarantee Details";
        SpecialComm: Decimal;
        FOSAName: Text[150];
        IDNo: Code[50];
        MovementTracker: Record "Movement Tracker";
        DiscountingAmount: Decimal;
        StatusPermissions: Record "Status Change Permision";
        BridgedLoans: Record "Loan Special Clearance";
        SMSMessage: Record "SMS Messages";
        InstallNo2: Integer;
        currency: Record "Currency Exchange Rate";
        CURRENCYFACTOR: Decimal;
        LoanApps: Record "Loans Register";
        LoanDisbAmount: Decimal;
        BatchTopUpAmount: Decimal;
        BatchTopUpComm: Decimal;
        Disbursement: Record "Loan Disburesment-Batching";
        SchDate: Date;
        DisbDate: Date;
        WhichDay: Integer;
        LBatches: Record "Loans Register";
        SalDetails: Record "Loan Appraisal Salary Details";
        LGuarantors: Record "Loans Guarantee Details";
        Text001: label 'Status Must Be Open';
        DocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None",JV,"Member Closure","Account Opening",Batches,"Payment Voucher","Petty Cash",Requisition,Loan,Interbank,Imprest,Checkoff,"FOSA Account Opening",StandingOrder,HRJob,HRLeave,"HRTransport Request",HRTraining,"HREmp Requsition",MicroTrans,"Account Reactivation","Overdraft ",BLA,"Member Editable","FOSA Opening","Loan Batching",Leave,"Imprest Requisition","Imprest Surrender","Stores Requisition","Funds Transfer","Change Request","Staff Claims","BOSA Transfer","Loan Tranche","Loan TopUp","Memb Opening","Member Withdrawal";
        CurrpageEditable: Boolean;
        LoanStatusEditable: Boolean;
        MNoEditable: Boolean;
        ApplcDateEditable: Boolean;
        LProdTypeEditable: Boolean;
        InstallmentEditable: Boolean;
        AppliedAmountEditable: Boolean;
        ApprovedAmountEditable: Boolean;
        RepayMethodEditable: Boolean;
        RepaymentEditable: Boolean;
        BatchNoEditable: Boolean;
        RepayFrequencyEditable: Boolean;
        ModeofDisburesmentEdit: Boolean;
        DisbursementDateEditable: Boolean;
        AccountNoEditable: Boolean;
        LNBalance: Decimal;
        ApprovalEntries: Record "Approval Entry";
        RejectionRemarkEditable: Boolean;
        ApprovalEntry: Record "Approval Entry";
        Table_id: Integer;
        Doc_No: Code[20];
        Doc_Type: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None","Payment Voucher","Petty Cash",Imprest,Requisition,ImprestSurrender,Interbank,TransportRequest,Maintenance,Fuel,ImporterExporter,"Import Permit","Export Permit",TR,"Safari Notice","Student Applications","Water Research","Consultancy Requests","Consultancy Proposals","Meals Bookings","General Journal","Student Admissions","Staff Claim",KitchenStoreRequisition,"Leave Application","Account Opening","Member Closure",Loan;
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        compinfo: Record "Company Information";
        iEntryNo: Integer;
        eMAIL: Text;
        "Telephone No": Integer;
        Text002: label 'The Loan has already been approved';
        LoanSecurities: Integer;
        EditableField: Boolean;
        SFactory: Codeunit "Swizzsoft Factory";
        OpenApprovalEntriesExist: Boolean;

        EnabledApprovalWorkflowsExist: Boolean;
        RecordApproved: Boolean;
        SwizzApprovalsCodeUnit: Codeunit SwizzsoftApprovalsCodeUnit;
        CanCancelApprovalForRecord: Boolean;
        offsetTable: Record "Loan Offset Details";

        IsViewOnlyMode: Boolean;


    procedure SetViewOnlyMode(ViewOnly: Boolean)
    begin
        IsViewOnlyMode := ViewOnly;
        CurrPage.Editable := not ViewOnly;
    end;

    procedure updateLoanInfo()
    begin
        begin
            offsetTable.reset();
            offsetTable.setrange(offsetTable."Loan No.", Rec."Loan  No.");
            offsetTable.SETFILTER(offsetTable."Total Top Up", '>0');//>0, 0);
            if offsetTable.find('-') then begin
                Rec."Is Top Up" := true;
                rec.Bridging := true;
            end else begin
                Rec."Is Top Up" := false;
            end;
        end;
    end;

    procedure UpdateControl()
    begin
        updateLoanInfo();
        MNoEditable := true;
        if Rec."Loan Status" = Rec."loan status"::Application then begin
            RecordApproved := false;
            MNoEditable := true;
            ApplcDateEditable := false;
            LoanStatusEditable := true;
            LProdTypeEditable := true;
            InstallmentEditable := true;
            AppliedAmountEditable := true;
            ApprovedAmountEditable := true;
            RepayMethodEditable := true;
            RepaymentEditable := true;
            BatchNoEditable := false;
            RepayFrequencyEditable := true;
            ModeofDisburesmentEdit := true;
            DisbursementDateEditable := false;
            CanCancelApprovalForRecord := false;

        end;

        if Rec."Loan Status" = Rec."loan status"::Appraisal then begin
            RecordApproved := true;
            MNoEditable := false;
            ApplcDateEditable := false;
            LoanStatusEditable := false;
            LProdTypeEditable := false;
            InstallmentEditable := false;
            AppliedAmountEditable := false;
            ApprovedAmountEditable := true;
            RepayMethodEditable := true;
            RepaymentEditable := true;
            BatchNoEditable := false;
            RepayFrequencyEditable := false;
            ModeofDisburesmentEdit := true;
            DisbursementDateEditable := false;
            CanCancelApprovalForRecord := true;
        end;

        if Rec."Loan Status" = Rec."loan status"::Rejected then begin
            RecordApproved := true;
            MNoEditable := false;
            AccountNoEditable := false;
            ApplcDateEditable := false;
            LoanStatusEditable := false;
            LProdTypeEditable := false;
            InstallmentEditable := false;
            AppliedAmountEditable := false;
            ApprovedAmountEditable := false;
            RepayMethodEditable := false;
            RepaymentEditable := false;
            BatchNoEditable := false;
            RepayFrequencyEditable := false;
            ModeofDisburesmentEdit := false;
            DisbursementDateEditable := false;
            RejectionRemarkEditable := false;
            CanCancelApprovalForRecord := false;
        end;

        if Rec."Approval Status" = Rec."approval status"::Approved then begin
            RecordApproved := true;
            MNoEditable := false;
            AccountNoEditable := false;
            LoanStatusEditable := false;
            ApplcDateEditable := false;
            LProdTypeEditable := false;
            InstallmentEditable := false;
            AppliedAmountEditable := false;
            ApprovedAmountEditable := false;
            RepayMethodEditable := false;
            RepaymentEditable := false;
            BatchNoEditable := true;
            RepayFrequencyEditable := false;
            ModeofDisburesmentEdit := true;
            DisbursementDateEditable := true;
            RejectionRemarkEditable := false;
            RecordApproved := true;
            CanCancelApprovalForRecord := false;
        end;
    end;


    procedure LoanAppPermisions()
    begin
    end;


    procedure SendSMS()
    begin


        GenSetUp.Get;
        compinfo.Get;


        if GenSetUp."Send SMS Notifications" = true then begin


            //SMS MESSAGE
            SMSMessage.Reset;
            if SMSMessage.Find('+') then begin
                iEntryNo := SMSMessage."Entry No";
                iEntryNo := iEntryNo + 1;
            end
            else begin
                iEntryNo := 1;
            end;

            SMSMessage.Init;
            SMSMessage."Entry No" := iEntryNo;
            SMSMessage."Batch No" := Rec."Batch No.";
            SMSMessage."Document No" := Rec."Loan  No.";
            SMSMessage."Account No" := Rec."Account No";
            SMSMessage."Date Entered" := Today;
            SMSMessage."Time Entered" := Time;
            SMSMessage.Source := 'LOANS';
            SMSMessage."Entered By" := UserId;
            SMSMessage."Sent To Server" := SMSMessage."sent to server"::No;
            SMSMessage."SMS Message" := 'Your ' + Format(Rec."Loan Product Type Name") + ' Loan Application of amount ' + Format(Rec."Requested Amount") + ' for ' +
            Rec."Client Code" + ' ' + Rec."Client Name" + ' has been received and is being Processed ' + compinfo.Name + ' ' + GenSetUp."Customer Care No";
            Cust.Reset;
            Cust.SetRange(Cust."No.", Rec."Client Code");
            if Cust.Find('-') then begin
                SMSMessage."Telephone No" := Cust."Mobile Phone No";
            end;
            SMSMessage.Insert;

        end;
    end;


    procedure SendMail()
    begin
        GenSetUp.Get;

        if Cust.Get(LoanApps."Client Code") then begin
            eMAIL := Cust."E-Mail (Personal)";
        end;

        // if GenSetUp."Send Email Notifications" = true then begin

        //     Notification.CreateMessage('Dynamics NAV', GenSetUp."Sender Address", eMAIL, 'Loan Receipt Notification',
        //                     'Loan application ' + LoanApps."Loan  No." + ' , ' + LoanApps."Loan Product Type" + ' has been received and is being processed'
        //                    + ' (Dynamics NAV ERP)', true, false);

        //     Notification.Send;

        // end;
    end;

    local procedure FnCheckForTestFields()
    var
        LoanType: Record "Loan Products Setup";
        LoanGuarantors: Record "Loans Guarantee Details";
    begin
        //--------------------
        if Rec."Approval Status" = Rec."Approval Status"::Approved then begin
            Error('The loan has already been approved');
        end;
        if Rec."Approval Status" <> Rec."Approval Status"::Open then begin
            Error('Approval status MUST be Open');
        end;
        if Rec.Appraised = false then
            Error('Please Appraise the Loan');
        Rec.TestField("Requested Amount");
        // Rec.TestField("Main-Sector");
        // Rec.TestField("Sub-Sector");
        // Rec.TestField("Specific-Sector");
        Rec.TestField("Loan Product Type");
        Rec.TestField("Mode of Disbursement");
        //----------------------
        // if (LoanType.get("Loan Product Type")) then begin
        //     if LoanType."Appraise Guarantors" = true then begin
        //         LoanGuarantors.Reset();
        //         LoanGuarantors.SetRange(LoanGuarantors."Loan No", "Loan  No.");
        //         if LoanGuarantors.find('-') then begin
        //             Error('Please Insert Loan Applicant Guarantor Details!');
        //         end;
        //     end;
        // end;
    end;

    local procedure FnSendEmailAprovalNottifications()
    var
        EmailBody: Text[700];
        EmailSubject: Text[100];
        Emailaddress: Text[100];
    begin
        ///...............Notify Via Email
        Cust.Reset();
        Cust.SetRange(Cust."No.", Rec."Client Code");
        if Cust.FindSet()
        then begin
            if Cust."E-Mail (Personal)" <> ' ' then begin
                Emailaddress := Cust."E-Mail (Personal)";
                EmailSubject := 'Loan Application Approval';
                EMailBody := 'Dear <b>' + '</b>,</br></br>' + 'Your ' + Rec."Loan Product Type Name" + ' loan application of KSHs. ' + FORMAT(Rec."Requested Amount") +
                          ' has been Approved by Credit. KRB Sacco Ltd.' + '<br></br>' +
'Congratulations';
                EmailCodeunit.SendMail(Emailaddress, EmailSubject, EmailBody);
            end;
        end;

    end;

    local procedure FnSendLoanApprovalNotifications()
    var
    begin
        //...........................Notify Loaner
        SMSMessages.RESET;
        IF SMSMessages.FIND('+') THEN BEGIN
            iEntryNo := SMSMessages."Entry No";
            iEntryNo := iEntryNo + 1;
        END
        ELSE BEGIN
            iEntryNo := 1;
        END;

        SMSMessages.RESET;
        SMSMessages.INIT;
        SMSMessages."Entry No" := iEntryNo;
        SMSMessages."Account No" := Rec."Client Code";
        SMSMessages."Date Entered" := TODAY;
        SMSMessages."Time Entered" := TIME;
        SMSMessages.Source := 'LOAN APPL';
        SMSMessages."Entered By" := USERID;
        SMSMessages."Sent To Server" := SMSMessages."Sent To Server"::No;
        SMSMessages."SMS Message" := 'Your ' + Format(Rec."Loan Product Type Name") + ' loan application of KSHs. ' + FORMAT(Rec."Requested Amount") +
                                  ' has been Approved by Credit. KRB Sacco Ltd.';
        Cust.RESET;
        IF Cust.GET(Rec."Client Code") THEN
            if Cust."Mobile Phone No" <> '' then begin
                SMSMessages."Telephone No" := Cust."Mobile Phone No";
            end else
                if (Cust."Mobile Phone No" = '') and (Cust."Mobile Phone No." <> '') then begin
                    SMSMessages."Telephone No" := Cust."Mobile Phone No.";
                end;
        SMSMessages.INSERT;
        //.......................................Notify Guarantors
        LoanGuar.RESET;
        LoanGuar.SETRANGE(LoanGuar."Loan No", Rec."Loan  No.");
        IF LoanGuar.FIND('-') THEN BEGIN
            REPEAT

                Cust.RESET;
                Cust.SETRANGE(Cust."No.", LoanGuar."Member No");
                IF Cust.FIND('-') THEN BEGIN
                    SMSMessages.RESET;
                    IF SMSMessages.FIND('+') THEN BEGIN
                        iEntryNo := SMSMessages."Entry No";
                        iEntryNo := iEntryNo + 1;
                    END
                    ELSE BEGIN
                        iEntryNo := 1;
                    END;

                    SMSMessages.INIT;
                    SMSMessages."Entry No" := iEntryNo;
                    SMSMessages."Account No" := LoanGuar."Member No";
                    SMSMessages."Date Entered" := TODAY;
                    SMSMessages."Time Entered" := TIME;
                    SMSMessages.Source := 'LOAN GUARANTORS';
                    SMSMessages."Entered By" := USERID;
                    SMSMessages."Sent To Server" := SMSMessages."Sent To Server"::No;
                    IF LoanApp.GET(LoanGuar."Loan No") THEN
                        SMSMessages."SMS Message" := 'You have guaranteed an amount of ' + FORMAT(LoanGuar."Amont Guaranteed")
                        + ' to ' + Rec."Client Name" + '  ' +
                        'Loan Type ' + Rec."Loan Product Type Name" + ' ' + 'of ' + FORMAT(Rec."Requested Amount") + ' at KRB Sacco Ltd. Call 0726050260 if in dispute';
                    ;
                    SMSMessages."Telephone No" := Cust."Phone No.";
                    SMSMessages.INSERT;
                END;
            UNTIL LoanGuar.NEXT = 0;
        END;
    end;

    local procedure FnMemberHasAnExistingLoanSameProduct(): Boolean
    var
        LoansReg: Record "Loans Register";
        Balance: Decimal;
    begin
        Balance := 0;
        LoansReg.Reset();
        LoansReg.SetRange(LoansReg."Client Code", Rec."Client Code");
        LoansReg.SetRange(LoansReg."Loan Product Type", Rec."Loan Product Type");
        LoansReg.SetRange(LoansReg.Posted, true);
        LoansReg.SetAutoCalcFields(LoansReg."Outstanding Balance", LoansReg."Oustanding Interest");
        if LoansReg.Find('-') then begin
            repeat
                Balance += LoansReg."Outstanding Balance" + LoansReg."Oustanding Interest";
            until LoansReg.Next = 0;
        end;
        if Balance > 0 then begin
            exit(true)
        end else
            if Balance <= 0 then begin
                exit(false);
            end;
    end;

    local procedure FnGetProductOutstandingBal(): Decimal
    var
        LoansReg: Record "Loans Register";
        Balance: Decimal;
    begin
        Balance := 0;
        LoansReg.Reset();
        LoansReg.SetRange(LoansReg."Client Code", Rec."Client Code");
        LoansReg.SetRange(LoansReg."Loan Product Type", Rec."Loan Product Type");
        LoansReg.SetRange(LoansReg.Posted, true);
        LoansReg.SetAutoCalcFields(LoansReg."Outstanding Balance", LoansReg."Oustanding Interest");
        if LoansReg.Find('-') then begin
            repeat
                Balance += LoansReg."Outstanding Balance" + LoansReg."Oustanding Interest";
            until LoansReg.Next = 0;
        end;
        exit(Balance);
    end;


}

