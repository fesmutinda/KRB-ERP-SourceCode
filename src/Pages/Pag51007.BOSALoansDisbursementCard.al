Page 51007 "BOSA Loans Disbursement Card"
{
    DeleteAllowed = true;
    // Editable = false;
    // ModifyAllowed = false;
    PageType = Card;
    InsertAllowed = false;
    PromotedActionCategories = 'New,Process,Reports,Approval,Budgetary Control,Cancellation,Category7_caption,Category8_caption,Category9_caption,Category10_caption';
    SourceTable = "Loans Register";
    //SourceTableView = where(Source = const(BOSA), Posted = const(false));

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
                    Caption = 'Member No';
                    Editable = MNoEditable;
                    ShowMandatory = true;
                }
                field("Account No"; Rec."Account No")
                {
                    ApplicationArea = Basic;
                    Editable = AccountNoEditable;
                    Style = StrongAccent;
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
                }
                field("Application Date"; Rec."Application Date")
                {
                    ApplicationArea = Basic;
                    Editable = true;

                    trigger OnValidate()
                    begin
                        //TestField(Posted, false);
                    end;
                }
                field("Loan Product Type"; Rec."Loan Product Type")
                {
                    ApplicationArea = Basic;
                    Style = StrongAccent;
                    Editable = LProdTypeEditable;
                    ShowMandatory = true;

                    trigger OnValidate()
                    begin
                    end;
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
                field("Approved Amount"; Rec."Approved Amount")
                {
                    ApplicationArea = Basic;
                    Caption = 'Approved Amount';
                    Editable = false;
                    ShowMandatory = true;

                    trigger OnValidate()
                    begin
                        Rec.TestField(Posted, false);


                    end;
                }

                field("Amount To Disburse"; Rec."Amount to Disburse")
                {
                    ApplicationArea = Basic;
                    Caption = 'Amount to Disburse';
                    Editable = true;

                    trigger OnValidate()
                    begin
                        // if Rec."Disbursed Amount" > Rec."Approved Amount" then
                        //     Error('Disbursed amount cannot exceed approved amount');

                        // if Rec."Disbursed Amount" <= 0 then
                        //     Error('Disbursed amount must be greater than zero');

                        // Rec.TestField(Posted, false);
                        if Rec."Disbursement Status" = Rec."Disbursement Status"::"Partially Disbursed" then begin
                            // For subsequent disbursements, validate against remaining amount
                            if Rec."Amount To Disburse" > Rec."Remaining Amount" then
                                Error('Disbursement amount cannot exceed remaining amount of %1', Rec."Remaining Amount");
                        end else begin
                            // For first disbursement, validate against approved amount
                            if Rec."Amount To Disburse" > Rec."Approved Amount" then
                                Error('Disbursed amount cannot exceed approved amount');
                        end;

                        if Rec."Amount To Disburse" <= 0 then
                            Error('Disbursed amount must be greater than zero');

                        Rec.TestField(Posted, false);
                    end;
                }

                field("Remaining Amount"; Rec."Remaining Amount")
                {
                    ApplicationArea = Basic;
                    Caption = 'Remaining Amount';
                    Editable = false;
                }

                field("Is Partial Disbursement"; Rec."Is Partial Disbursement")
                {
                    ApplicationArea = Basic;
                    Caption = 'Partial Disbursement';
                    Editable = true;

                    trigger OnValidate()
                    begin
                        if Rec."Is Partial Disbursement" then begin
                            if Rec."Disbursed Amount" = 0 then
                                Rec."Disbursed Amount" := Rec."Approved Amount";
                        end else begin
                            Rec."Disbursed Amount" := Rec."Approved Amount";
                        end;
                    end;
                }

                field("Disbursement Status"; Rec."Disbursement Status")
                {
                    ApplicationArea = Basic;
                    Caption = 'Disbursement Status';
                    Editable = false;
                    OptionCaption = 'Not Disbursed,Partially Disbursed,Fully Disbursed';
                }
                field("Main Sector"; Rec."Main-Sector")
                {
                    ApplicationArea = Basic;
                    ShowMandatory = true;
                    Style = Ambiguous;
                    Editable = MNoEditable;

                    trigger OnValidate()
                    begin
                        Rec.TestField(Posted, false);
                    end;
                }
                field("Sub-Sector"; Rec."Sub-Sector")
                {
                    ApplicationArea = Basic;
                    ShowMandatory = true;
                    Style = Ambiguous;
                    Editable = MNoEditable;

                    trigger OnValidate()
                    begin
                        Rec.TestField(Posted, false);
                    end;
                }
                field("Specific Sector"; Rec."Specific-Sector")
                {
                    ApplicationArea = Basic;
                    ShowMandatory = true;
                    Style = Ambiguous;
                    Editable = MNoEditable;

                    trigger OnValidate()
                    begin
                        Rec.TestField(Posted, false);
                    end;
                }
                field(Remarks; Rec.Remarks)
                {
                    Caption = 'Loan Purpose';
                    ApplicationArea = Basic;
                    Editable = MNoEditable;
                    Visible = true;
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
                field("Facilitation Cost"; Rec."Facilitation Cost")
                {
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
                    Editable = true;
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
                    OptionCaption = 'Checkoff,Standing Order,Salary,Pension,Direct Debits,Tea,Milk,Tea Bonus,Dividend,Christmas';
                }
                field("Mode of Disbursement"; Rec."Mode of Disbursement")
                {
                    ApplicationArea = Basic;
                    Editable = MNoEditable;
                    ShowMandatory = true;
                }
                field("Paying Bank Account No"; Rec."Paying Bank Account No")
                {
                    ApplicationArea = Basic;
                    Editable = true;
                }
                field("Batch No."; Rec."Batch No.")
                {
                    Editable = true;
                    ApplicationArea = Basic;
                }
                field("Loan Disbursement Date"; Rec."Loan Disbursement Date")
                {
                    ApplicationArea = Basic;
                    // Editable = MNoEditable;
                    Editable = true;
                    Style = StrongAccent;
                    ShowMandatory = true;
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

            group("Mobile Money Details")
            {

                visible = true;

                field("Mobile Money Service"; Rec."Mobile Money Service")
                {
                    ApplicationArea = Basic;
                }

                field("Mobile Money Receiving Number"; Rec."Mobile Money Receiving Number")
                {
                    ApplicationArea = Basic;
                }

            }

            part(Control1000000004; "Loans Guarantee Details")
            {
                Caption = 'Guarantors  Detail';
                SubPageLink = "Loan No" = field("Loan  No.");
                Editable = MNoEditable;
            }
        }
        area(factboxes)
        {
            part("Member Statistics FactBox"; "Member Statistics FactBox")
            {
                SubPageLink = "No." = field("Client Code");
            }
        }
    }
    actions
    {
        area(navigation)
        {
            group(Loan)
            {

                action("POST")
                {
                    Caption = 'POST LOAN';
                    Enabled = true;
                    Image = PrepaymentPostPrint;
                    PromotedIsBig = true;
                    Promoted = true;
                    PromotedCategory = Process;
                    Visible = true;

                    trigger OnAction()
                    var
                        FundsUserSetup: Record "Funds User Setup";
                        CustLed: Record "Cust. Ledger Entry";
                        DisbursementAmount: Decimal;
                        ConfirmMessage: Text;
                    begin
                        // Permission check
                        If FnCanPostLoans(UserId) = false then begin
                            Error('Prohibited ! You are not allowed to POST this Loan');
                        end;

                        // Status validations
                        if Rec.Posted = true then begin
                            Error('Prohibited ! The loan is already Posted');
                        end;

                        if Rec."Loan Status" <> Rec."Loan Status"::Approved then begin
                            Error('Prohibited ! The loan Status MUST be Approved');
                        end;

                        // Handle partial disbursement logic
                        if Rec."Is Partial Disbursement" then begin
                            if Rec."Amount To Disburse" = 0 then
                                Error('Please specify the amount to disburse');

                            if Rec."Amount To Disburse" > 0 then begin


                                if not Rec."Is Partial Disbursement" then
                                    Error('Please toggle Is Partial Dibursement')
                            end;

                            DisbursementAmount := Rec."Amount To Disburse";
                            ConfirmMessage := 'Are you sure you want to PARTIALLY DISBURSE Loan amount of Ksh. ' +
                                             Format(DisbursementAmount) + ' to member - ' + Format(Rec."Client Name") + ' ?';
                        end else begin
                            DisbursementAmount := Rec."Approved Amount";
                            Rec.CalcFields("Top Up Amount");
                            ConfirmMessage := 'Are you sure you want to POST Loan Net amount of Ksh. ' +
                                             Format(Rec."Approved Amount" - (Rec."Loan Processing Fee" +
                                             Rec."Loan Dirbusement Fee" + Rec."Loan Insurance" +
                                             REC."Top Up Amount" + Rec."Valuation Cost")) +
                                             ' to member - ' + Format(Rec."Client Name") + ' ?';
                        end;

                        if Confirm(ConfirmMessage, false) = false then begin
                            exit;
                        end else begin
                            TemplateName := 'GENERAL';
                            BatchName := 'LOANS';
                            LoanApps.Reset;
                            LoanApps.SetRange(LoanApps."Loan  No.", Rec."Loan  No.");

                            if LoanApps.FindSet then begin
                                repeat
                                    // Call modified function with disbursement amount
                                    FnInsertBOSALines(LoanApps, LoanApps."Loan  No.", DisbursementAmount);

                                    GenJournalLine.RESET;
                                    GenJournalLine.SETRANGE("Journal Template Name", TemplateName);
                                    GenJournalLine.SETRANGE("Journal Batch Name", BatchName);

                                    if GenJournalLine.Find('-') then begin
                                        CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post Batch", GenJournalLine);
                                        FnSendNotifications();

                                        Rec.Get(Rec."Loan  No.");

                                        // Update disbursement status
                                        if Rec."Is Partial Disbursement" then begin
                                            Rec."Disbursement Status" := Rec."Disbursement Status"::"Partially Disbursed";
                                            Rec."Remaining Amount" := Rec."Approved Amount" - DisbursementAmount;
                                            Rec."Loan Status" := Rec."Loan Status"::Issued;
                                            Rec.Posted := true;

                                            // If this completes the disbursement
                                            if Rec."Remaining Amount" <= 0 then begin
                                                Rec."Disbursement Status" := Rec."Disbursement Status"::"Fully Disbursed";
                                                Rec."Loan Status" := Rec."Loan Status"::Issued;
                                                Rec.Posted := true;
                                            end;
                                        end else begin
                                            Rec."Disbursement Status" := Rec."Disbursement Status"::"Fully Disbursed";
                                            Rec."Loan Status" := Rec."Loan Status"::Issued;
                                            Rec.Posted := true;
                                        end;

                                        Rec."Posted By" := UserId;
                                        Rec."Disbursed Amount" += DisbursementAmount;
                                        Rec."Posting Date" := Today;
                                        Rec."Issued Date" := Rec."Loan Disbursement Date";
                                        Rec."Approval Status" := Rec."Approval Status"::Approved;
                                        Rec."Loans Category-SASRA" := Rec."Loans Category-SASRA"::Perfoming;
                                        //Rec.Modify();


                                        if Rec.Modify() then begin
                                            Commit;
                                            CurrPage.Update(false);
                                        end;

                                        // Recover Overdraft Loan On Loan
                                        SFactory.FnRecoverOnLoanOverdrafts(Rec."Client Code");
                                    end;
                                until LoanApps.Next = 0;

                                Message('Loan disbursement has been processed successfully and member notified');
                                CurrPage.close();
                            end;
                        end;
                    end;
                }

                action("Disburse Remaining")
                {
                    Caption = 'Disburse Remaining Amount';
                    Enabled = Rec."Disbursement Status" = Rec."Disbursement Status"::"Partially Disbursed";
                    Image = PaymentLines;
                    Promoted = true;
                    PromotedCategory = Process;


                    trigger OnAction()
                    var
                        ConfirmMessage: Text;
                    begin

                        if Rec."Disbursement Status" <> Rec."Disbursement Status"::"Partially Disbursed" then
                            Error('Can only disburse remaining amount for partially disbursed loans');

                        if Rec."Remaining Amount" <= 0 then
                            Error('No remaining amount to disburse');

                        if Rec."Loan Status" <> Rec."Loan Status"::Issued then
                            Error('Loan must be in Issued status to disburse remaining amount');

                        if Rec."Remaining Amount" <= 0 then
                            Error('No remaining amount to disburse');

                        // Set up for final disbursement
                        ConfirmMessage := 'Are you sure you want to disburse the remaining amount of Ksh. ' +
                                         Format(Rec."Remaining Amount") + ' to member - ' +
                                         Format(Rec."Client Name") + ' ?';

                        if Confirm(ConfirmMessage, false) = false then
                            exit;

                        // Set disbursement amount to remaining amount
                        //Rec."Disbursed Amount" := Rec."Remaining Amount";

                        // Trigger the posting process
                        PostRemainingDisbursement();
                    end;
                }
                action("Loan Appraisal Edit")
                {
                    ApplicationArea = Basic;
                    Caption = 'View Appraisal';
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
                        // if (UserId <> '') then begin
                        //     EntryNos := 0;
                        //     if Audit.FindLast then
                        //         EntryNos := 1 + Audit."Entry No";
                        //     Audit.Init;
                        //     Audit."Entry No" := EntryNos;
                        //     Audit."Transaction Type" := 'Loan Appraisal';
                        //     Audit."Loan Number" := Rec."Loan  No.";
                        //     Audit."Document Number" := Rec."Loan  No.";
                        //     Audit.UsersId := UserId;
                        //     Audit.Amount := Rec."Requested Amount";
                        //     Audit.Date := Today;
                        //     Audit.Time := Time;
                        //     Audit.Source := 'LOAN APPLICATION';
                        //     Audit.Insert;
                        //     Commit;
                        // end;
                        //End Audit Entries

                        LoanApp.Reset;
                        LoanApp.SetRange(LoanApp."Loan  No.", Rec."Loan  No.");
                        if LoanApp.Find('-') then begin
                            Report.Run(56384, true, false, LoanApp);
                        end;

                    end;
                }
                // action("Send Approvals")
                // {
                //     Caption = 'Send For Approval';
                //     Visible = false;
                //     Enabled = (not OpenApprovalEntriesExist) AND EnabledApprovalWorkflowsExist AND (not RecordApproved);
                //     Image = SendApprovalRequest;
                //     Promoted = true;
                //     PromotedCategory = Process;

                //     trigger OnAction()
                //     begin
                //         FnCheckForTestFields();
                //         if Confirm('Send Approval Request For Loan Application of Ksh. ' + Format(Rec."Approved Amount") + ' applied by ' + Format(Rec."Client Name") + ' ?', false) = false then begin
                //             exit;
                //         end
                //         else begin
                //             SwizzApprovalsCodeUnit.SendLoanApplicationsRequestForApproval(rec."Loan  No.", Rec);
                //             FnSendLoanApprovalNotifications();
                //             CurrPage.close();
                //         end;
                //     end;
                // }
                action("Cancel Approvals")
                {
                    Caption = 'Cancel For Approval';
                    Enabled = CanCancelApprovalForRecord;
                    Image = CancelApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Process;
                    visible = false;

                    trigger OnAction()
                    begin
                        if Confirm('Cancel Approval?', false) = false then begin
                            exit;
                        end
                        else begin
                            SwizzApprovalsCodeUnit.CancelLoanApplicationsRequestForApproval(rec."Loan  No.", Rec);
                            CurrPage.Close();
                        end;
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
                        if (Rec."Repayment Start Date" = 0D) then Error('Please enter Disbursement Date to continue');
                        SFactory.FnGenerateRepaymentSchedule(Rec."Loan  No.");
                        LoanApp.Reset;
                        LoanApp.SetRange(LoanApp."Loan  No.", Rec."Loan  No.");
                        if LoanApp.Find('-') then begin
                            Report.Run(50477, true, false, LoanApp);
                        end;
                    end;
                }

                action("Print Voucher")
                {
                    ApplicationArea = Basic;
                    Caption = 'Print Voucher';
                    Image = Print; // More appropriate icon for printing
                    Promoted = true;
                    PromotedCategory = Process;
                    ToolTip = 'Print the loan disbursement voucher for this application';

                    trigger OnAction()
                    begin
                        LoanApp.Reset;
                        LoanApp.SetRange(LoanApp."Loan  No.", Rec."Loan  No.");

                        if LoanApp.FindSet() then begin
                            Report.Run(Report::"Loan Disbursement Voucher", true, false, LoanApp);
                        end
                    end;
                }
                action("Loans to Offset")
                {
                    ApplicationArea = Basic;
                    Caption = 'Loans to Offset';
                    //Enabled = (not OpenApprovalEntriesExist) AND EnabledApprovalWorkflowsExist AND (not RecordApproved);
                    Image = AddAction;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Loan Offset Detail List";
                    RunPageLink = "Loan No." = field("Loan  No."), "Client Code" = field("Client Code");
                }
            }
        }
    }
    trigger OnAfterGetCurrRecord()
    begin
        UpdateControl();
        OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(REC.RecordId); //Return No and allow sending of approval request.
        EnabledApprovalWorkflowsExist := true;
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

    // trigger OnModifyRecord(): Boolean
    // begin
    //     LoanAppPermisions();
    // end;

    // trigger OnNewRecord(BelowxRec: Boolean)
    // begin
    //     Rec.Source := Rec.Source::BOSA;
    //     Rec."Mode of Disbursement" := Rec."mode of disbursement"::Cheque;
    // end;

    // trigger OnNextRecord(Steps: Integer): Integer
    // begin
    // end;

    // trigger OnOpenPage()
    // begin
    //     Rec.SetRange(Posted, false);
    // end;

    var
        ClientCode: Code[40];
        DirbursementDate: Date;
        VarAmounttoDisburse: Decimal;
        insurancePremium: Decimal;
        bankTransferCharges: Decimal;
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
        Notification: Codeunit Mail;
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
        PepeaShares: Decimal;
        SaccoDeposits: Decimal;
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
        TemplateName: Code[50];
        BatchName: Code[50];
        EnabledApprovalWorkflowsExist: Boolean;
        RecordApproved: Boolean;
        SwizzApprovalsCodeUnit: Codeunit SwizzsoftApprovalsCodeUnit;
        CanCancelApprovalForRecord: Boolean;

    procedure UpdateControl()
    begin
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

        if Rec."Disbursement Status" = Rec."Disbursement Status"::"Partially Disbursed" then begin
            MNoEditable := false;
            DisbursementDateEditable := true;
            // Enable only fields needed for remaining disbursement
        end;

        // Calculate remaining amount
        // if Rec."Is Partial Disbursement" then begin
        //     Rec."Remaining Amount" := Rec."Approved Amount" - Rec."Disbursed Amount";
        //     if Rec."Remaining Amount" < 0 then
        //         Rec."Remaining Amount" := 0;
        // end;
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
            SMSMessage."SMS Message" := 'Your' + Format(Rec."Loan Product Type Name") + 'Loan Application of amount ' + Format(Rec."Requested Amount") + ' for ' + Rec."Client Code" + ' ' + Rec."Client Name" + ' has been received and is being Processed ' + compinfo.Name + ' ' + GenSetUp."Customer Care No";
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
        if GenSetUp."Send Email Notifications" = true then begin
            Notification.CreateMessage('Dynamics NAV', GenSetUp."Sender Address", eMAIL, 'Loan Receipt Notification', 'Loan application ' + LoanApps."Loan  No." + ' , ' + LoanApps."Loan Product Type" + ' has been received and is being processed' + ' (Dynamics NAV ERP)', true, false);
            //Notification.Send;
        end;
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
        Rec.TestField("Requested Amount");
        Rec.TestField("Main-Sector");
        Rec.TestField("Sub-Sector");
        Rec.TestField("Specific-Sector");
        Rec.TestField("Loan Product Type");
        Rec.TestField("Mode of Disbursement");
        //----------------------
        if LoanType.get(Rec."Loan Product Type") then begin
            if LoanType."Appraise Guarantors" = true then begin
                LoanGuarantors.Reset();
                LoanGuarantors.SetRange(LoanGuarantors."Loan No", Rec."Loan  No.");
                if LoanGuarantors.find('-') then begin
                    Error('Please Insert Loan Applicant Guarantor Details!');
                end;
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
        SMSMessages."SMS Message" := 'Your' + Format(Rec."Loan Product Type Name") + 'loan application of KSHs.' + FORMAT(Rec."Requested Amount") + ' has been received. KRB Sacco Ltd.';
        Cust.RESET;
        IF Cust.GET(Rec."Client Code") THEN
            if Cust."Mobile Phone No" <> '' then begin
                SMSMessages."Telephone No" := Cust."Mobile Phone No";
            end
            else
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
                    IF LoanApp.GET(LoanGuar."Loan No") THEN SMSMessages."SMS Message" := 'You have guaranteed an amount of ' + FORMAT(LoanGuar."Amont Guaranteed") + ' to ' + Rec."Client Name" + '  ' + ' Loan Type ' + Rec."Loan Product Type Name" + ' ' + 'of ' + FORMAT(Rec."Requested Amount") + ' at KRB Sacco Ltd. Call 0726050260 if in dispute';
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
        end
        else
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

    local procedure FnInsertBOSALines(var LoanApps: Record "Loans Register"; LoanNo: Code[30]; DisbursementAmount: Decimal)
    var
        EndMonth: Date;
        RemainingDays: Integer;
        TMonthDays: Integer;
        Sfactorycode: Codeunit "Swizzsoft Factory";
        AmountTop: Decimal;
        NetAmount: Decimal;
        ChargeRatio: Decimal;
        Insurance: Decimal;
        Valuation: Decimal;
        SaccoGeneralSetup: Record "Sacco General Set-Up";
        UndisbursedAmount: Decimal;
        TotalApprovedAmount: Decimal;
        RemainingCommitment: Decimal;
        IsFirstDisbursement: Boolean;
    begin
        AmountTop := 0;
        NetAmount := 0;
        bankTransferCharges := 0;

        GenSetUp.GET;
        if not SaccoGeneralSetup.Get() then
            Error('Sacco General Setup record not found. Please configure the setup.');

        if SaccoGeneralSetup."Undisbursed Loan Committments Account" = '' then
            Error('Undisbursed Loan Commitments Account not configured in Sacco General Setup.');

        if SaccoGeneralSetup."Loan Commitment Liability Account" = '' then
            Error('Loan Commitment Liability Account not configured in Sacco General Setup.');

        if LoanApps."Client Code" = '' then
            Error('Client Code cannot be empty for Loan No. %1', LoanApps."Loan  No.");

        if not Cust.Get(LoanApps."Client Code") then
            Error('Customer %1 not found.', LoanApps."Client Code");

        if LoanApps."Paying Bank Account No" = '' then
            Error('Paying Bank Account No. cannot be empty for Loan No. %1', LoanApps."Loan  No.");

        // Determine if this is first disbursement or subsequent
        IsFirstDisbursement := (Rec."Disbursement Status" = Rec."Disbursement Status"::"Not Disbursed") or
                              (Rec."Disbursement Status" = Rec."Disbursement Status"::" ");

        TotalApprovedAmount := Rec."Approved Amount";
        UndisbursedAmount := Abs(Rec."Remaining Amount" - Rec."Approved Amount");

        Insurance := Rec."Loan Insurance";
        Valuation := Rec."Valuation Cost";

        // Generate Schedule (only for first disbursement or full disbursement)
        if IsFirstDisbursement or not Rec."Is Partial Disbursement" then
            Sfactorycode.FnGenerateRepaymentSchedule(Rec."Loan  No.");

        DirbursementDate := Rec."Loan Disbursement Date";
        VarAmounttoDisburse := DisbursementAmount;
        insurancePremium := 0;

        // Prorated Days calculation
        EndMonth := CALCDATE('-1D', CALCDATE('1M', DMY2DATE(1, DATE2DMY(Today, 2), DATE2DMY(Today, 3))));
        RemainingDays := (EndMonth - Today) + 1;
        TMonthDays := DATE2DMY(EndMonth, 1);

        // Ensure batch exists
        IF NOT GenBatch.GET(TemplateName, BatchName) THEN BEGIN
            GenBatch.INIT;
            GenBatch."Journal Template Name" := TemplateName;
            GenBatch.Name := BatchName;
            GenBatch.INSERT;
        END;

        // Reset General Journal Lines
        GenJournalLine.RESET;
        GenJournalLine.SETRANGE("Journal Template Name", TemplateName);
        GenJournalLine.SETRANGE("Journal Batch Name", BatchName);
        GenJournalLine.DELETEALL;

        // Get dimensions
        DActivity := '';
        DBranch := '';
        DActivity := Cust."Global Dimension 1 Code";
        DBranch := Cust."Global Dimension 2 Code";

        // === COMMITMENT ACCOUNTING ENTRIES ===
        if IsFirstDisbursement then begin
            // 1. Record Full Loan Commitment on First Disbursement
            // DR: Member Loan Account (Disbursed Amount)
            LineNo := LineNo + 10000;
            SFactory.FnCreateGnlJournalLine(
                TemplateName, BatchName, Rec."Loan  No.", LineNo,
                GenJournalLine."Transaction Type"::Loan,
                GenJournalLine."Account Type"::Customer,
                LoanApps."Client Code", DirbursementDate, DisbursementAmount,
                'BOSA', LoanApps."Loan  No.",
                'Loan Disbursement' + GetDisbursementSuffix() + Format(LoanApps."Loan Product Type"),
                LoanApps."Loan  No."
            );

            // DR: Undisbursed Loan Commitments (Remaining Amount)
            if UndisbursedAmount > 0 then begin
                // VALIDATION: Check account exists
                if SaccoGeneralSetup."Undisbursed Loan Committments Account" = '' then
                    Error('Undisbursed Loan Commitments Account not configured.');

                LineNo := LineNo + 10000;
                SFactory.FnCreateGnlJournalLine(
                    TemplateName, BatchName, Rec."Loan  No.", LineNo,
                    GenJournalLine."Transaction Type"::" ",
                    GenJournalLine."Account Type"::"G/L Account",
                    SaccoGeneralSetup."Undisbursed Loan Committments Account", DirbursementDate,
                    UndisbursedAmount,
                    'BOSA', LoanApps."Loan  No.",
                    'Undisbursed Loan Commitment - ' + LoanApps."Loan Product Type",
                    LoanApps."Loan  No."
                );
            end;

            // CR: Loan Commitment Liability (Remaining/Undisbursed Amount Only)
            if UndisbursedAmount > 0 then begin
                // VALIDATION: Check account exists
                if SaccoGeneralSetup."Loan Commitment Liability Account" = '' then
                    Error('Loan Commitment Liability Account not configured.');

                LineNo := LineNo + 10000;
                SFactory.FnCreateGnlJournalLine(
                    TemplateName, BatchName, Rec."Loan  No.", LineNo,
                    GenJournalLine."Transaction Type"::" ",
                    GenJournalLine."Account Type"::"G/L Account",
                    SaccoGeneralSetup."Loan Commitment Liability Account", DirbursementDate,
                    UndisbursedAmount * -1,
                    'BOSA', LoanApps."Loan  No.",
                    'Loan Commitment Liability - ' + LoanApps."Loan Product Type",
                    LoanApps."Loan  No."
                );
            end;

        end else begin
            // Subsequent Disbursement - Transfer from Undisbursed to Member Account
            // DR: Member Loan Account (Disbursement Amount)
            LineNo := LineNo + 10000;
            SFactory.FnCreateGnlJournalLine(
                TemplateName, BatchName, Rec."Loan  No.", LineNo,
                GenJournalLine."Transaction Type"::Loan,
                GenJournalLine."Account Type"::Customer,
                LoanApps."Client Code", DirbursementDate, DisbursementAmount,
                'BOSA', LoanApps."Loan  No.",
                'Loan Disbursement (Subsequent) - ' + LoanApps."Loan Product Type",
                LoanApps."Loan  No."
            );

            // CR: Undisbursed Loan Commitments (Disbursement Amount)
            if SaccoGeneralSetup."Undisbursed Loan Committments Account" <> '' then begin
                LineNo := LineNo + 10000;
                SFactory.FnCreateGnlJournalLine(
                    TemplateName, BatchName, Rec."Loan  No.", LineNo,
                    GenJournalLine."Transaction Type"::" ",
                    GenJournalLine."Account Type"::"G/L Account",
                    SaccoGeneralSetup."Undisbursed Loan Committments Account", DirbursementDate,
                    DisbursementAmount * -1,
                    'BOSA', LoanApps."Loan  No.",
                    'Release Undisbursed Commitment - ' + LoanApps."Loan Product Type",
                    LoanApps."Loan  No."
                );
            end;
        end;

        // Handle Loan Offset for full disbursements only
        if not Rec."Is Partial Disbursement" then begin
            Rec.CalcFields("Top Up Amount");
            if Rec."Top Up Amount" > 0 then begin
                LoanTopUp.RESET;
                LoanTopUp.SETRANGE(LoanTopUp."Loan No.", Rec."Loan  No.");
                IF LoanTopUp.FIND('-') THEN BEGIN
                    repeat
                        LineNo := LineNo + 10000;
                        SFactory.FnCreateGnlJournalLine(
                            TemplateName, BatchName, Rec."Loan  No.", LineNo,
                            GenJournalLine."Transaction Type"::"Loan Repayment",
                            GenJournalLine."Account Type"::Customer,
                            LoanApps."Client Code", DirbursementDate,
                            LoanTopUp."Principle Top Up" * -1,
                            'BOSA', LoanApps."Loan  No.",
                            'Loan OffSet By - ' + LoanApps."Loan  No.",
                            LoanTopUp."Loan Top Up"
                        );

                        // Interest on Top Up
                        LineNo := LineNo + 10000;
                        SFactory.FnCreateGnlJournalLine(
                            TemplateName, BatchName, Rec."Loan  No.", LineNo,
                            GenJournalLine."Transaction Type"::"Interest Paid",
                            GenJournalLine."Account Type"::Customer,
                            LoanApps."Client Code", DirbursementDate,
                            LoanTopUp."Interest Top Up" * -1,
                            'BOSA', LoanApps."Loan  No.",
                            'Interest Due Paid on top up - ',
                            LoanTopUp."Loan Top Up"
                        );

                        // Top up commission (with validation)
                        if GenSetUp."Top up Account" <> '' then begin
                            LineNo := LineNo + 10000;
                            SFactory.FnCreateGnlJournalLine(
                                TemplateName, BatchName, LoanApps."Loan  No.", LineNo,
                                GenJournalLine."Transaction Type"::" ",
                                GenJournalLine."Account Type"::"G/L Account",
                                GenSetUp."Top up Account", DirbursementDate,
                                LoanTopUp.Commision * -1,
                                'BOSA', Rec."Batch No.",
                                'Commision on top up - ',
                                LoanTopUp."Loan Top Up"
                            );
                        end;

                        AmountTop := (LoanTopUp."Principle Top Up" + LoanTopUp."Interest Top Up" + LoanTopUp.Commision);
                        VarAmounttoDisburse := VarAmounttoDisburse - AmountTop;
                    UNTIL LoanTopUp.NEXT = 0;
                END;
            end;
        end;

        // Calculate net amount
        NetAmount := VarAmounttoDisburse - (Insurance + Valuation);

        // Bank Transfer Charges (only on first disbursement for partial loans)
        bankTransferCharges := Rec."Bank Transfer Charges";
        if Rec."Is Partial Disbursement" and not IsFirstDisbursement then begin
            bankTransferCharges := 0; // No charges on subsequent disbursements
            Insurance := 0;
            Valuation := 0;

        end;

        if bankTransferCharges > 0 then begin
            // Credit Bank (with validation)
            if LoanApps."Paying Bank Account No" <> '' then begin
                LineNo := LineNo + 10000;
                SFactory.FnCreateGnlJournalLine(
                    TemplateName, BatchName, LoanApps."Loan  No.", LineNo,
                    GenJournalLine."Transaction Type"::" ",
                    GenJournalLine."Account Type"::"Bank Account",
                    LoanApps."Paying Bank Account No", DirbursementDate,
                    bankTransferCharges * -1,
                    'BOSA', Rec."Batch No.",
                    'Bank transfer charges ' + GetDisbursementSuffix() + Format(LoanApps."Loan  No."),
                    ''
                );
            end;

            // Debit member
            LineNo := LineNo + 10000;
            SFactory.FnCreateGnlJournalLine(
                TemplateName, BatchName, Rec."Loan  No.", LineNo,
                GenJournalLine."Transaction Type"::"Loan Transfer Charges",
                GenJournalLine."Account Type"::Customer,
                LoanApps."Client Code", DirbursementDate, bankTransferCharges,
                'BOSA', LoanApps."Loan  No.",
                'Bank transfer charges ' + GetDisbursementSuffix() + Format(LoanApps."Loan  No."),
                LoanApps."Loan  No."
            );

            //VarAmounttoDisburse := VarAmounttoDisburse - bankTransferCharges;
        end;

        // Insurance (only on first disbursement)
        if Insurance > 0 then begin
            if GenSetUp."Insurance Retension Account" <> '' then begin
                LineNo := LineNo + 10000;
                SFactory.FnCreateGnlJournalLine(
                    TemplateName, BatchName, LoanApps."Loan  No.", LineNo,
                    GenJournalLine."Transaction Type"::" ",
                    GenJournalLine."Account Type"::"G/L Account",
                    GenSetUp."Insurance Retension Account", DirbursementDate,
                    Insurance * -1,
                    'BOSA', Rec."Batch No.",
                    'Loan Insurance Amount ' + GetDisbursementSuffix() + Format(LoanApps."Loan  No."),
                    ''
                );
                VarAmounttoDisburse := VarAmounttoDisburse - Insurance;
            end else begin
                Error('Insurance Retension Account not configured in General Setup.');
            end;
        end;

        // Valuation costs (only on first disbursement)
        if Valuation > 0 then begin
            if GenSetUp."Asset Valuation Cost" <> '' then begin
                LineNo := LineNo + 10000;
                SFactory.FnCreateGnlJournalLine(
                    TemplateName, BatchName, LoanApps."Loan  No.", LineNo,
                    GenJournalLine."Transaction Type"::" ",
                    GenJournalLine."Account Type"::"G/L Account",
                    GenSetUp."Asset Valuation Cost", DirbursementDate,
                    Valuation * -1,
                    'BOSA', Rec."Batch No.",
                    'Loan valuation fee ' + GetDisbursementSuffix() + Format(LoanApps."Loan  No."),
                    ''
                );
                VarAmounttoDisburse := VarAmounttoDisburse - Valuation;
            end else begin
                Error('Asset Valuation Cost Account not configured in General Setup.');
            end;
        end;

        // Facilitation Fee (only for full disbursements)
        if not Rec."Is Partial Disbursement" and (LoanApps."Facilitation Cost" > 0) then begin
            if GenSetUp."Facilitation Fee" <> '' then begin
                LineNo := LineNo + 10000;
                SFactory.FnCreateGnlJournalLine(
                    TemplateName, BatchName, LoanApps."Loan  No.", LineNo,
                    GenJournalLine."Transaction Type"::" ",
                    GenJournalLine."Account Type"::"G/L Account",
                    GenSetUp."Facilitation Fee", DirbursementDate,
                    LoanApps."Facilitation Cost" * -1,
                    'BOSA', Rec."Batch No.",
                    'Loan facilitation fees ' + Format(LoanApps."Loan  No."),
                    ''
                );
                VarAmounttoDisburse := VarAmounttoDisburse - LoanApps."Facilitation Cost";
            end else begin
                Error('Facilitation Fee Account not configured in General Setup.');
            end;
        end;

        // credit bank account
        if VarAmounttoDisburse > 0 then begin
            if LoanApps."Paying Bank Account No" <> '' then begin
                LineNo := LineNo + 10000;
                SFactory.FnCreateGnlJournalLine(
                    TemplateName, BatchName, Rec."Loan  No.", LineNo,
                    GenJournalLine."Transaction Type"::" ",
                    GenJournalLine."Account Type"::"Bank Account",
                    LoanApps."Paying Bank Account No", DirbursementDate,
                    VarAmounttoDisburse * -1,
                    'BOSA', LoanApps."Loan  No.",
                    'Loan net amount disbursement ' + GetDisbursementSuffix() + Format(Rec."Loan  No."),
                    ''
                );
            end else begin
                Error('Paying Bank Account No. is not configured for Loan No. %1', LoanApps."Loan  No.");
            end;
        end;

        // === FINAL COMMITMENT CLEANUP ===
        // If this is the final disbursement, close the remaining commitment liability
        if not Rec."Is Partial Disbursement" or (UndisbursedAmount - Rec."Remaining Amount" = 0) then begin
            // Calculate the remaining commitment to close
            RemainingCommitment := Rec."Remaining Amount";
            if RemainingCommitment > 0 then begin
                if SaccoGeneralSetup."Loan Commitment Liability Account" <> '' then begin
                    LineNo := LineNo + 10000;
                    SFactory.FnCreateGnlJournalLine(
                        TemplateName, BatchName, Rec."Loan  No.", LineNo,
                        GenJournalLine."Transaction Type"::" ",
                        GenJournalLine."Account Type"::"G/L Account",
                        SaccoGeneralSetup."Loan Commitment Liability Account", DirbursementDate,
                        RemainingCommitment,
                        'BOSA', LoanApps."Loan  No.",
                        'Close Loan Commitment Liability - ' + LoanApps."Loan Product Type",
                        LoanApps."Loan  No."
                    );
                end;
            end;
        end;
    end;

    // Helper function to add disbursement suffix
    local procedure GetDisbursementSuffix(): Text[20]
    begin
        if Rec."Is Partial Disbursement" then begin
            if (Rec."Disbursement Status" = Rec."Disbursement Status"::"Not Disbursed") or
               (Rec."Disbursement Status" = Rec."Disbursement Status"::" ") then
                exit('(1st Partial) ')
            else
                exit('(Subsequent) ');
        end else
            exit('');
    end;

    local procedure FnSendNotifications()
    var
        msg: Text[250];
        PhoneNo: Text[250];
    begin
        LoansR.Reset();
        LoansR.SetRange(LoansR."Loan  No.", Rec."Loan  No.");
        if LoansR.Find('-') then begin
            msg := '';
            msg := 'Dear Member, Your ' + Format(LoansR."Loan Product Type Name") + ' loan application of KSHs.' + Format(Rec."Requested Amount") + ' has been processed and it will be deposited to your Bank Account.';
            PhoneNo := FnGetPhoneNo(Rec."Client Code");
            SendSMSMessage(Rec."Client Code", msg, PhoneNo);
        end;
    end;

    local procedure SendSMSMessage(BOSANo: Code[20]; msg: Text[250]; PhoneNo: Text[250])
    begin
        SMSMessages.Reset;
        if SMSMessages.Find('+') then begin
            iEntryNo := SMSMessages."Entry No";
            iEntryNo := iEntryNo + 1;
        end
        else begin
            iEntryNo := 1;
        end;
        //--------------------------------------------------
        SMSMessages.Reset;
        SMSMessages.Init;
        SMSMessages."Entry No" := iEntryNo;
        SMSMessages."Account No" := BOSANo;
        SMSMessages."Date Entered" := Today;
        SMSMessages."Time Entered" := Time;
        SMSMessages.Source := 'LOANDISB';
        SMSMessages."Entered By" := UserId;
        SMSMessages."Sent To Server" := SMSMessages."sent to server"::No;
        SMSMessages."SMS Message" := msg;
        SMSMessages."Telephone No" := PhoneNo;
        SMSMessages.Insert;
    end;

    local procedure FnGetPhoneNo(ClientCode: Code[50]): Text[250]
    var
        Member: Record Customer;
        Vendor: Record Vendor;
    begin
        Member.Reset();
        Member.SetRange(Member."No.", ClientCode);
        if Member.Find('-') = true then begin
            if (Member."Mobile Phone No." <> '') and (Member."Mobile Phone No." <> '0') then begin
                exit(Member."Mobile Phone No.");
            end;
            if (Member."Mobile Phone No" <> '') and (Member."Mobile Phone No" <> '0') then begin
                exit(Member."Mobile Phone No");
            end;
            if (Member."Phone No." <> '') and (Member."Phone No." <> '0') then begin
                exit(Member."Phone No.");
            end;
            Vendor.Reset();
            Vendor.SetRange(Vendor."BOSA Account No", ClientCode);
            if Vendor.Find('-') then begin
                if (Vendor."Mobile Phone No." <> '') or (Vendor."Mobile Phone No." <> '0') then begin
                    exit(Vendor."Mobile Phone No.");
                end;
                if (Vendor."Mobile Phone No" <> '') or (Vendor."Mobile Phone No" <> '0') then begin
                    exit(Vendor."Mobile Phone No");
                end;
            end;
        end
        else
            if Member.find('-') = false then begin
                Vendor.Reset();
                Vendor.SetRange(Vendor."BOSA Account No", ClientCode);
                if Vendor.Find('-') then begin
                    if (Vendor."Mobile Phone No." <> '') or (Vendor."Mobile Phone No." <> '0') then begin
                        exit(Vendor."Mobile Phone No.");
                    end;
                    if (Vendor."Mobile Phone No" <> '') or (Vendor."Mobile Phone No" <> '0') then begin
                        exit(Vendor."Mobile Phone No");
                    end;
                end;
            end;
    end;

    local procedure FnCanPostLoans(UserId: Text): Boolean
    var
        UserSetUp: Record "User Setup";
    begin
        if UserSetUp.get(UserId) then begin
            if UserSetUp."Can POST Loans" = true then begin
                exit(true);
            end;
        end;
        exit(false);
    end;


    local procedure PostRemainingDisbursement()
    var
        DisbursementAmount: Decimal;
    begin
        DisbursementAmount := Rec."Remaining Amount";

        // Permission check
        If FnCanPostLoans(UserId) = false then begin
            Error('Prohibited ! You are not allowed to POST this Loan');
        end;

        TemplateName := 'GENERAL';
        BatchName := 'LOANS';
        LoanApps.Reset;
        LoanApps.SetRange(LoanApps."Loan  No.", Rec."Loan  No.");

        if LoanApps.FindSet then begin
            repeat
                // Call disbursement function with remaining amount
                FnInsertBOSALines(LoanApps, LoanApps."Loan  No.", DisbursementAmount);

                GenJournalLine.RESET;
                GenJournalLine.SETRANGE("Journal Template Name", TemplateName);
                GenJournalLine.SETRANGE("Journal Batch Name", BatchName);

                if GenJournalLine.Find('-') then begin
                    CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post Batch", GenJournalLine);

                    // Update loan record for final disbursement
                    Rec.Get(Rec."Loan  No.");
                    Rec."Disbursement Status" := Rec."Disbursement Status"::"Fully Disbursed";
                    Rec."Remaining Amount" := 0;
                    Rec."Disbursed Amount" := Rec."Approved Amount"; // Total disbursed
                    Rec."Disbursed Amount" += DisbursementAmount;
                    Rec."Is Partial Disbursement" := false;
                    //Rec.Modify();


                    if Rec.Modify() then begin
                        Commit;
                        CurrPage.Update(false);
                    end;

                    FnSendNotifications();
                end;
            until LoanApps.Next = 0;

            Message('Remaining loan amount has been disbursed successfully and member notified');
            CurrPage.close();
        end;
    end;



}
