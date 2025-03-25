namespace KRBERPSourceCode.KRBERPSourceCode;
using Microsoft.Sales.Customer;
using Microsoft.Purchases.Vendor;
using System.Security.AccessControl;
using Microsoft.Finance.GeneralLedger.Journal;

page 57006 "KRB Checkoff Card"
{
    DeleteAllowed = false;
    PageType = Card;
    SourceTable = "KRB Checkoff Header";
    SourceTableView = where(Posted = const(false));

    layout
    {
        area(content)
        {
            group(General)
            {
                field(No; Rec.No)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Entered By"; Rec."Entered By")
                {
                    ApplicationArea = Basic;
                    Enabled = false;
                }
                field("Date Entered"; Rec."Date Entered")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Posting date"; Rec."Posting date")
                {
                    ApplicationArea = Basic;
                    Editable = true;
                }
                field("Loan CutOff Date"; Rec."Loan CutOff Date")
                {
                    ApplicationArea = Basic;
                }
                field(Remarks; Rec.Remarks)
                {
                    ApplicationArea = Basic;
                }
                field("Total Count"; Rec."Total Count")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Posted By"; Rec."Posted By")
                {
                    ApplicationArea = Basic;
                }
                field("Account Type"; Rec."Account Type")
                {
                    Editable = false;
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Account No"; Rec."Account No")
                {
                    Caption = 'Receiving Bank';
                    ApplicationArea = Basic;
                }
                field("Account Name"; Rec."Account Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Employer Code"; Rec."Employer Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Employer Name"; Rec."Employer Name")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Document No"; Rec."Document No")
                {
                    ApplicationArea = Basic;
                }

                field(Amount; Rec.Amount)
                {
                    Caption = 'Cheque Amount';
                    ApplicationArea = Basic;
                }
                field("Scheduled Amount"; Rec."Scheduled Amount")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                // field("Total Amount"; Rec."Total Amount")
                // {
                //     ApplicationArea = Basic;
                // }
            }
            part("Bosa receipt lines"; "KRB CheckoffLines")
            {
                SubPageLink = "Receipt Header No" = field(No);
            }
        }
    }
    actions
    {
        area(processing)
        {
            group(ActionGroup1102755021)
            {
            }
            action(ImportItems)
            {
                Caption = 'Import CheckOff';
                Promoted = true;
                PromotedCategory = Process;
                Image = Import;
                ApplicationArea = All;

                RunObject = xmlport "KRB Checkoff Import";
            }
            group(ActionGroup1102755019)
            {
            }
            action("Validate Receipts")
            {
                ApplicationArea = Basic;
                Caption = 'Validate Receipts';
                Image = ValidateEmailLoggingSetup;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    RcptBufLines.Reset;
                    RcptBufLines.SetRange(RcptBufLines."Receipt Header No", Rec.No);
                    if RcptBufLines.Find('-') then begin
                        repeat

                            Memb.Reset;
                            Memb.SetRange(Memb."Payroll/Staff No", RcptBufLines."Staff/Payroll No");
                            //Memb.SETRANGE(Memb."Employer Code",RcptBufLines."Employer Code");
                            if Memb.Find('-') then begin

                                RcptBufLines."Member No" := Memb."No.";
                                RcptBufLines.Name := Memb.Name;
                                RcptBufLines."ID No." := Memb."ID No.";
                                RcptBufLines."Member Found" := true;
                                RcptBufLines.Modify;
                            end;
                        until RcptBufLines.Next = 0;
                    end;
                    Message('Successfully validated');
                end;
            }
            action("Post check off")
            {
                ApplicationArea = Basic;
                Caption = 'Post check off';
                Image = Post;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    UsersID: Record User;
                    FundsUSer: Record "Funds User Setup";
                    GenJnlManagement: Codeunit GenJnlManagement;
                    GenBatch: Record "Gen. Journal Batch";
                    dialogBox: Dialog;
                begin
                    Rec.SetRange(Rec.No);
                    genstup.Get();
                    if Rec.Posted = true then
                        Error('This Check Off has already been posted');
                    if Rec."Account No" = '' then
                        Error('You must specify the Account No.');
                    if Rec."Document No" = '' then
                        Error('You must specify the Document No.');
                    if Rec."Posting date" = 0D then
                        Error('You must specify the Posting date.');
                    if Rec."Posting date" = 0D then
                        Error('You must specify the Posting date.');
                    if Rec."Loan CutOff Date" = 0D then
                        Error('You must specify the Loan CutOff Date.');
                    Datefilter := '..' + Format(Rec."Loan CutOff Date");
                    IssueDate := Rec."Loan CutOff Date";
                    //General Journals
                    // if FundsUSer.Get(UserId) then begin
                    Jtemplate := 'GENERAL';
                    Jbatch := 'CHECKOFF';
                    // end;
                    //Delete journal
                    Gnljnline.Reset;
                    Gnljnline.SetRange("Journal Template Name", Jtemplate);
                    Gnljnline.SetRange("Journal Batch Name", Jbatch);
                    if Gnljnline.Find('-') then begin
                        Gnljnline.DeleteAll;
                    end;

                    // Rec.CalcFields("Scheduled Amount");
                    if Rec."Scheduled Amount" <> Rec.Amount then begin
                        ERROR('Scheduled Amount Is Not Equal To Cheque Amount');
                    end;

                    Rec.Validate("Scheduled Amount");
                    LineN := LineN + 10000;
                    Gnljnline.Init;
                    Gnljnline."Journal Template Name" := Jtemplate;
                    Gnljnline."Journal Batch Name" := Jbatch;
                    Gnljnline."Line No." := LineN;
                    Gnljnline."Account Type" := Gnljnline."Account Type"::"Bank Account";// Rec."Account Type";
                    Gnljnline."Account No." := Rec."Account No";
                    Gnljnline.Validate(Gnljnline."Account No.");
                    Gnljnline."Document No." := Rec."Document No";
                    Gnljnline."Posting Date" := Rec."Posting date";
                    Gnljnline.Description := 'CHECKOFF ' + Rec.Remarks;
                    Gnljnline.Amount := Rec."Scheduled Amount";
                    Gnljnline.Validate(Gnljnline.Amount);
                    Gnljnline."Shortcut Dimension 1 Code" := 'BOSA';
                    Gnljnline."Shortcut Dimension 2 Code" := 'NAIROBI';
                    Gnljnline.Validate(Gnljnline."Shortcut Dimension 1 Code");
                    Gnljnline.Validate(Gnljnline."Shortcut Dimension 2 Code");
                    if Gnljnline.Amount <> 0 then
                        Gnljnline.Insert(true);
                    //End Of control


                    RcptBufLines.Reset;
                    RcptBufLines.SetRange(RcptBufLines."Receipt Header No", Rec.No);
                    RcptBufLines.SetRange(RcptBufLines.Posted, false);
                    if RcptBufLines.Find('-') then begin
                        repeat
                            LineN := LineN + 10000;
                            //Co_op_Shares;
                            dialogBox.Open('Processing deposit contribution for ' + Format(RcptBufLines."Member No") + '...');

                            FnInsertDepositContribution(Jtemplate, Jbatch,
                                                        RcptBufLines."Member No", Rec."Document No",
                                                        'Deposits KRB Checkoff',
                                                        RcptBufLines."Co-op - Shares");

                            dialogBox.Close();

                            //Co_op_Devt_Loan;
                            Co_op_Devt_LoanBalance := 0;
                            Co_op_Devt_LoanBalance := RcptBufLines."Co-op - Devt Loan";
                            if Co_op_Devt_LoanBalance > 0 then begin
                                dialogBox.Open('Processing Co_op_Devt_Loan for ' + Format(RcptBufLines."Member No") + '...');

                                // Co_op_Devt_LoanBalance := FnRunInterest(RcptBufLines, Co_op_Devt_LoanBalance, Rec."Loan CutOff Date", 'LT001');
                                // Co_op_Devt_LoanBalance := FnRunPrinciple(RcptBufLines, Co_op_Devt_LoanBalance, Rec."Loan CutOff Date", 'LT001');
                                Co_op_Devt_LoanBalance := FnRunLoanRepayment(RcptBufLines, Co_op_Devt_LoanBalance, Rec."Loan CutOff Date", 'LT002');
                                FnTransferExcessToUnallocatedFunds(RcptBufLines, Co_op_Devt_LoanBalance, 'Excess Payments for Co-op Development Loan');
                                dialogBox.Close();
                            end;

                            //Flexi;
                            FlexiBalance := 0;
                            FlexiBalance := RcptBufLines.Flexi;
                            if FlexiBalance > 0 then begin
                                dialogBox.Open('Processing Flexi for ' + Format(RcptBufLines."Member No") + '...');

                                // FlexiBalance := FnRunInterest(RcptBufLines, FlexiBalance, Rec."Loan CutOff Date", 'LT006');
                                // FlexiBalance := FnRunPrinciple(RcptBufLines, FlexiBalance, Rec."Loan CutOff Date", 'LT006');
                                FlexiBalance := FnRunLoanRepayment(RcptBufLines, FlexiBalance, Rec."Loan CutOff Date", 'LT006');
                                FnTransferExcessToUnallocatedFunds(RcptBufLines, FlexiBalance, 'Excess Payments for Flexi Loan');
                                dialogBox.Close();
                            end;

                            //Muslim_Loan; 
                            Muslim_LoanBalance := 0;
                            Muslim_LoanBalance := RcptBufLines."Muslim Loan";
                            if Muslim_LoanBalance > 0 then begin
                                dialogBox.Open('Processing Muslim_Loan for ' + Format(RcptBufLines."Member No") + '...');

                                // Muslim_LoanBalance := FnRunInterest(RcptBufLines, Muslim_LoanBalance, Rec."Loan CutOff Date", 'LT008');
                                // Muslim_LoanBalance := FnRunPrinciple(RcptBufLines, Muslim_LoanBalance, Rec."Loan CutOff Date", 'LT008');
                                Muslim_LoanBalance := FnRunLoanRepayment(RcptBufLines, Muslim_LoanBalance, Rec."Loan CutOff Date", 'LT008');
                                FnTransferExcessToUnallocatedFunds(RcptBufLines, Muslim_LoanBalance, 'Excess Payments for SHERIA COMPLIANT LOANS');
                                dialogBox.Close();
                            end;

                            //Co_op_Emergency_Loan;
                            Co_op_Emergency_LoanBalance := 0;
                            Co_op_Emergency_LoanBalance := RcptBufLines."Co-op Emergency Loan";
                            if Co_op_Emergency_LoanBalance > 0 then begin
                                dialogBox.Open('Processing Co_op_Emergency_Loan for ' + Format(RcptBufLines."Member No") + '...');

                                // Co_op_Emergency_LoanBalance := FnRunInterest(RcptBufLines, Co_op_Emergency_LoanBalance, Rec."Loan CutOff Date", 'LT005');
                                // Co_op_Emergency_LoanBalance := FnRunPrinciple(RcptBufLines, Co_op_Emergency_LoanBalance, Rec."Loan CutOff Date", 'LT005');
                                Co_op_Emergency_LoanBalance := FnRunLoanRepayment(RcptBufLines, Co_op_Emergency_LoanBalance, Rec."Loan CutOff Date", 'LT005');
                                FnTransferExcessToUnallocatedFunds(RcptBufLines, Co_op_Emergency_LoanBalance, 'Excess Payments for EMERGENCY LOAN');
                                dialogBox.Close();
                            end;

                            //Co_op_Investment_Loan;
                            Co_op_Investment_LoanBalance := 0;
                            Co_op_Investment_LoanBalance := RcptBufLines."Co-op - Investment Loan";
                            if Co_op_Investment_LoanBalance > 0 then begin
                                dialogBox.Open('Processing Co_op_Investment_Loan for ' + Format(RcptBufLines."Member No") + '...');

                                // Co_op_Investment_LoanBalance := FnRunInterest(RcptBufLines, Co_op_Investment_LoanBalance, Rec."Loan CutOff Date", 'LT003');
                                // Co_op_Investment_LoanBalance := FnRunPrinciple(RcptBufLines, Co_op_Investment_LoanBalance, Rec."Loan CutOff Date", 'LT003');
                                Co_op_Investment_LoanBalance := FnRunLoanRepayment(RcptBufLines, Co_op_Investment_LoanBalance, Rec."Loan CutOff Date", 'LT003');
                                FnTransferExcessToUnallocatedFunds(RcptBufLines, Co_op_Investment_LoanBalance, 'Excess Payments for INVESTMENT LOAN');
                                dialogBox.Close();
                            end;

                            //Co_op_School_Fees_Loan; 
                            Co_op_School_Fees_LoanBalance := 0;
                            Co_op_School_Fees_LoanBalance := RcptBufLines."Co-op School Fees Loan";
                            if Co_op_School_Fees_LoanBalance > 0 then begin
                                dialogBox.Open('Processing Co_op_School_Fees_Loan for ' + Format(RcptBufLines."Member No") + '...');

                                // Co_op_School_Fees_LoanBalance := FnRunInterest(RcptBufLines, Co_op_School_Fees_LoanBalance, Rec."Loan CutOff Date", 'LT004');
                                // Co_op_School_Fees_LoanBalance := FnRunPrinciple(RcptBufLines, Co_op_School_Fees_LoanBalance, Rec."Loan CutOff Date", 'LT004');
                                Co_op_School_Fees_LoanBalance := FnRunLoanRepayment(RcptBufLines, Co_op_School_Fees_LoanBalance, Rec."Loan CutOff Date", 'LT004');
                                FnTransferExcessToUnallocatedFunds(RcptBufLines, Co_op_School_Fees_LoanBalance, 'Excess Payments for SCHOOL FEES');
                                dialogBox.Close();
                            end;

                            //Instant; 
                            InstantBalance := 0;
                            InstantBalance := RcptBufLines.Instant;
                            if InstantBalance > 0 then begin
                                dialogBox.Open('Processing Instant for ' + Format(RcptBufLines."Member No") + '...');

                                // InstantBalance := FnRunInterest(RcptBufLines, InstantBalance, Rec."Loan CutOff Date", 'LT007');
                                // InstantBalance := FnRunPrinciple(RcptBufLines, InstantBalance, Rec."Loan CutOff Date", 'LT007');
                                InstantBalance := FnRunLoanRepayment(RcptBufLines, InstantBalance, Rec."Loan CutOff Date", 'LT007');
                                FnTransferExcessToUnallocatedFunds(RcptBufLines, InstantBalance, 'Excess Payments for INSTANT LOAN');
                                dialogBox.Close();
                            end;
                            //Childrens_Savings;
                            dialogBox.Open('Processing Children Savings for ' + Format(RcptBufLines."Member No") + '...');

                            FnInsertChildrenSavings(Jtemplate, Jbatch,
                                                    RcptBufLines."Member No", Rec."Document No",
                                                    'Children Savings KRB Checkoff',
                                                    RcptBufLines."Childrens Savings");

                            dialogBox.Close();
                            //Withdrwable_svgs;
                            dialogBox.Open('Processing Withdrawable Savings for ' + Format(RcptBufLines."Member No") + '...');

                            FnInsertWithdrawableSavings(Jtemplate, Jbatch,
                                                        RcptBufLines."Member No", Rec."Document No",
                                                        'Withdrawable Savings Checkoff',
                                                        RcptBufLines."Withdrwable svgs");

                            dialogBox.Close();

                        until RcptBufLines.Next = 0;
                    end;

                    //Post control
                    Gnljnline.Reset;
                    Gnljnline.SetRange("Journal Template Name", Jtemplate);
                    Gnljnline.SetRange("Journal Batch Name", Jbatch);
                    if Gnljnline.Find('-') then
                        Page.Run(page::"General Journal", Gnljnline);

                    Message('CheckOff Successfully Generated');
                end;
            }
            action("Processed Checkoff")
            {
                ApplicationArea = Basic;
                Image = POST;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    if Confirm('Are you sure you want to mark this Checkoff as Processed', false) = true then begin
                        Rec.Posted := true;
                        Rec."Posted By" := UserId;
                        Rec.Modify;
                    end;
                end;
            }
        }
    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Rec."Posting date" := Today;
        Rec."Date Entered" := Today;
    end;

    var
        Gnljnline: Record "Gen. Journal Line";
        PDate: Date;
        DocNo: Code[20];
        // RunBal: Decimal;
        Co_op_Devt_LoanBalance: Decimal;
        FlexiBalance: Decimal;
        InstantBalance: Decimal;
        Co_op_School_Fees_LoanBalance: Decimal;
        Muslim_LoanBalance: Decimal;
        Co_op_Emergency_LoanBalance: Decimal;
        Co_op_Investment_LoanBalance: Decimal;
        ReceiptsProcessingLines: Record "KRB CheckoffLines";
        // LineNo: Integer;
        LBatches: Record "Loan Disburesment-Batching";
        Jtemplate: Code[30];
        JBatch: Code[30];
        "Cheque No.": Code[20];
        DActivityBOSA: Code[20];
        DBranchBOSA: Code[20];
        ReptProcHeader: Record "KRB Checkoff Header";
        Cust: Record Customer;
        MembPostGroup: Record "Customer Posting Group";
        Loantable: Record "Loans Register";
        LRepayment: Decimal;
        RcptBufLines: Record "KRB CheckoffLines";
        LoanType: Record "Loan Products Setup";
        LoanApp: Record "Loans Register";
        Interest: Decimal;
        LineN: Integer;
        TotalRepay: Decimal;
        MultipleLoan: Integer;
        LType: Text;
        MonthlyAmount: Decimal;
        ShRec: Decimal;
        SHARESCAP: Decimal;
        DIFF: Decimal;
        DIFFPAID: Decimal;
        genstup: Record "Sacco General Set-Up";
        Memb: Record Customer;
        INSURANCE: Decimal;
        GenBatches: Record "Gen. Journal Batch";
        Datefilter: Text[50];
        ReceiptLine: Record "KRB CheckoffLines";
        XMAS: Decimal;
        MemberRec: Record Customer;
        Vendor: Record Vendor;
        IssueDate: Date;
        startDate: Date;
        TotalWelfareAmount: Decimal;
        LoanRepS: Record "Loan Repayment Schedule";
        MonthlyRepay: Decimal;
        cm: Date;
        mm: Code[10];
        Lschedule: Record "Loan Repayment Schedule";
        ScheduleRepayment: Decimal;

    local procedure FnInsertDepositContribution(Jtemplate: Code[30]; Jbatch: code[30]; memberNo: Code[15]; documentNo: code[30];
    transDescription: Code[30]; transAmount: Decimal): Code[50]
    var
    begin
        LineN := LineN + 10000;
        Gnljnline.Init;
        Gnljnline."Journal Template Name" := Jtemplate;
        Gnljnline."Journal Batch Name" := Jbatch;
        Gnljnline."Line No." := LineN;
        Gnljnline."Account Type" := Gnljnline."bal. account type"::Customer;
        Gnljnline."Account No." := memberNo;
        Gnljnline.Validate(Gnljnline."Account No.");
        Gnljnline."Document No." := documentNo;
        Gnljnline."Posting Date" := Today;
        Gnljnline.Description := transDescription;
        Gnljnline.Amount := transAmount * -1;
        Gnljnline.Validate(Gnljnline.Amount);
        Gnljnline."Transaction Type" := Gnljnline."transaction type"::"Deposit Contribution";
        Gnljnline."Shortcut Dimension 1 Code" := 'BOSA';
        Gnljnline."Shortcut Dimension 2 Code" := FnGetMemberBranch(memberNo);
        Gnljnline.Validate(Gnljnline."Shortcut Dimension 1 Code");
        Gnljnline.Validate(Gnljnline."Shortcut Dimension 2 Code");
        if Gnljnline.Amount <> 0 then
            Gnljnline.Insert();
    end;

    local procedure FnInsertShareCapital(Jtemplate: Code[30]; Jbatch: code[30]; memberNo: Code[15]; documentNo: code[30];
        transDescription: Code[30]; transAmount: Decimal): Code[50]
    var
    begin
        LineN := LineN + 10000;
        Gnljnline.Init;
        Gnljnline."Journal Template Name" := Jtemplate;
        Gnljnline."Journal Batch Name" := Jbatch;
        Gnljnline."Line No." := LineN;
        Gnljnline."Account Type" := Gnljnline."bal. account type"::Customer;
        Gnljnline."Account No." := memberNo;
        Gnljnline.Validate(Gnljnline."Account No.");
        Gnljnline."Document No." := documentNo;
        Gnljnline."Posting Date" := Today;
        Gnljnline.Description := transDescription;
        Gnljnline.Amount := transAmount * -1;
        Gnljnline.Validate(Gnljnline.Amount);
        Gnljnline."Transaction Type" := Gnljnline."transaction type"::"Share Capital";
        Gnljnline."Shortcut Dimension 1 Code" := 'BOSA';
        Gnljnline."Shortcut Dimension 2 Code" := FnGetMemberBranch(memberNo);
        Gnljnline.Validate(Gnljnline."Shortcut Dimension 1 Code");
        Gnljnline.Validate(Gnljnline."Shortcut Dimension 2 Code");
        if Gnljnline.Amount <> 0 then
            Gnljnline.Insert();
    end;

    local procedure FnInsertWithdrawableSavings(Jtemplate: Code[30]; Jbatch: code[30]; memberNo: Code[15]; documentNo: code[30];
        transDescription: Code[30]; transAmount: Decimal): Code[50]
    var
    begin
        LineN := LineN + 10000;
        Gnljnline.Init;
        Gnljnline."Journal Template Name" := Jtemplate;
        Gnljnline."Journal Batch Name" := Jbatch;
        Gnljnline."Line No." := LineN;
        Gnljnline."Account Type" := Gnljnline."bal. account type"::Customer;
        Gnljnline."Account No." := memberNo;
        Gnljnline.Validate(Gnljnline."Account No.");
        Gnljnline."Document No." := documentNo;
        Gnljnline."Posting Date" := Today;
        Gnljnline.Description := transDescription;
        Gnljnline.Amount := transAmount * -1;
        Gnljnline.Validate(Gnljnline.Amount);
        Gnljnline."Transaction Type" := Gnljnline."transaction type"::"Withdrawable Savings";
        Gnljnline."Shortcut Dimension 1 Code" := 'BOSA';
        Gnljnline."Shortcut Dimension 2 Code" := FnGetMemberBranch(memberNo);
        Gnljnline.Validate(Gnljnline."Shortcut Dimension 1 Code");
        Gnljnline.Validate(Gnljnline."Shortcut Dimension 2 Code");
        if Gnljnline.Amount <> 0 then
            Gnljnline.Insert();
    end;

    local procedure FnInsertChildrenSavings(Jtemplate: Code[30]; Jbatch: code[30]; memberNo: Code[15]; documentNo: code[30];
    transDescription: Code[30]; transAmount: Decimal): Code[50]
    var
    begin
        LineN := LineN + 10000;
        Gnljnline.Init;
        Gnljnline."Journal Template Name" := Jtemplate;
        Gnljnline."Journal Batch Name" := Jbatch;
        Gnljnline."Line No." := LineN;
        Gnljnline."Account Type" := Gnljnline."bal. account type"::Customer;
        Gnljnline."Account No." := memberNo;
        Gnljnline.Validate(Gnljnline."Account No.");
        Gnljnline."Document No." := documentNo;
        Gnljnline."Posting Date" := Today;
        Gnljnline.Description := transDescription;
        Gnljnline.Amount := transAmount * -1;
        Gnljnline.Validate(Gnljnline.Amount);
        Gnljnline."Transaction Type" := Gnljnline."transaction type"::"Junior Savings";
        Gnljnline."Shortcut Dimension 1 Code" := 'BOSA';
        Gnljnline."Shortcut Dimension 2 Code" := FnGetMemberBranch(memberNo);
        Gnljnline.Validate(Gnljnline."Shortcut Dimension 1 Code");
        Gnljnline.Validate(Gnljnline."Shortcut Dimension 2 Code");
        if Gnljnline.Amount <> 0 then
            Gnljnline.Insert();
    end;

    local procedure FnInsertRegistrationFee(Jtemplate: Code[30]; Jbatch: code[30]; memberNo: Code[15]; documentNo: code[30];
    transDescription: Code[30]; transAmount: Decimal): Code[50]
    var
    begin
        LineN := LineN + 10000;
        Gnljnline.Init;
        Gnljnline."Journal Template Name" := Jtemplate;
        Gnljnline."Journal Batch Name" := Jbatch;
        Gnljnline."Line No." := LineN;
        Gnljnline."Account Type" := Gnljnline."bal. account type"::Customer;
        Gnljnline."Account No." := memberNo;
        Gnljnline.Validate(Gnljnline."Account No.");
        Gnljnline."Document No." := documentNo;
        Gnljnline."Posting Date" := Today;
        Gnljnline.Description := transDescription;
        Gnljnline.Amount := transAmount * -1;
        Gnljnline.Validate(Gnljnline.Amount);
        Gnljnline."Transaction Type" := Gnljnline."transaction type"::"Registration Fee";
        Gnljnline."Shortcut Dimension 1 Code" := 'BOSA';
        Gnljnline."Shortcut Dimension 2 Code" := FnGetMemberBranch(memberNo);
        Gnljnline.Validate(Gnljnline."Shortcut Dimension 1 Code");
        Gnljnline.Validate(Gnljnline."Shortcut Dimension 2 Code");
        if Gnljnline.Amount <> 0 then
            Gnljnline.Insert();
    end;

    local procedure FnInsertLoanRepayment(Jtemplate: Code[30]; Jbatch: Code[30]; memberNo: code[30]; documentNo: Code[30];
        transDescription: Code[50]; transAmount: Decimal)
    var
    begin
        LineN := LineN + 10000;
        Gnljnline.Init;
        Gnljnline."Journal Template Name" := Jtemplate;
        Gnljnline."Journal Batch Name" := Jbatch;
        Gnljnline."Line No." := LineN;
        Gnljnline."Account Type" := Gnljnline."bal. account type"::Customer;
        Gnljnline."Account No." := memberNo;
        Gnljnline.Validate(Gnljnline."Account No.");
        Gnljnline."Document No." := documentNo;
        Gnljnline."Posting Date" := Today;
        Gnljnline.Description := transDescription;
        Gnljnline.Amount := transAmount * -1;
        Gnljnline.Validate(Gnljnline.Amount);
        Gnljnline."Transaction Type" := Gnljnline."transaction type"::"Loan Repayment";
        Gnljnline."Shortcut Dimension 1 Code" := 'BOSA';
        Gnljnline."Shortcut Dimension 2 Code" := FnGetMemberBranch(memberNo);
        Gnljnline.Validate(Gnljnline."Shortcut Dimension 1 Code");
        Gnljnline.Validate(Gnljnline."Shortcut Dimension 2 Code");

        if Gnljnline.Amount <> 0 then
            Gnljnline.Insert();
    end;

    local procedure FnRunInterest(ObjRcptBuffer: Record "KRB CheckoffLines"; RunningBalance: Decimal; LoanCutoffDate: Date; loanCode: Code[10]): Decimal
    var
        AmountToDeduct: Decimal;
        InterestToRecover: Decimal;
    begin
        if RunningBalance > 0 then begin
            LoanApp.Reset;
            LoanApp.SetCurrentkey(Source, "Issued Date", "Loan Product Type", "Client Code", "Staff No");
            LoanApp.SetRange(LoanApp."Client Code", ObjRcptBuffer."Member No");
            // LoanApp.SetRange(LoanApp."Recovery Mode", LoanApp."recovery mode"::"Payroll Deduction");//This now will raise issuess
            LoanApp.SetRange(LoanApp."Loan Product Type", loanCode);
            //LoanApp.SETFILTER(LoanApp."Date filter",Datefilter); //Deduct all interest outstanding regardless of date
            //LoanApp.SETRANGE(LoanApp."Issued Date",startDate,IssueDate);
            if LoanApp.FindSet() then begin
                repeat
                    LoanApp.CalcFields(LoanApp."Oustanding Interest");
                    if (LoanApp."Oustanding Interest" > 0) and (LoanApp."Issued Date" <= LoanCutoffDate) then begin
                        if RunningBalance > 0 then //300
                          begin
                            AmountToDeduct := 0;
                            InterestToRecover := (LoanApp."Oustanding Interest");//100
                            if RunningBalance >= InterestToRecover then
                                AmountToDeduct := InterestToRecover
                            else
                                AmountToDeduct := RunningBalance;

                            LineN := LineN + 10000;
                            Gnljnline.Init;
                            Gnljnline."Journal Template Name" := Jtemplate;
                            Gnljnline."Journal Batch Name" := Jbatch;
                            Gnljnline."Line No." := LineN;
                            Gnljnline."Account Type" := Gnljnline."bal. account type"::Customer;
                            Gnljnline."Account No." := LoanApp."Client Code";
                            Gnljnline.Validate(Gnljnline."Account No.");
                            Gnljnline."Document No." := Rec."Document No";
                            Gnljnline."Posting Date" := Rec."Posting date";
                            Gnljnline.Description := LoanApp."Loan Product Type" + '-Loan Interest Paid ';
                            Gnljnline.Amount := -1 * AmountToDeduct;
                            Gnljnline.Validate(Gnljnline.Amount);
                            Gnljnline."Transaction Type" := Gnljnline."transaction type"::"Interest Paid";
                            Gnljnline."Loan No" := LoanApp."Loan  No.";

                            Gnljnline."Shortcut Dimension 1 Code" := 'BOSA';
                            Gnljnline."Shortcut Dimension 2 Code" := FnGetMemberBranch(LoanApp."Client Code");
                            Gnljnline.Validate(Gnljnline."Shortcut Dimension 1 Code");
                            Gnljnline.Validate(Gnljnline."Shortcut Dimension 2 Code");
                            if Gnljnline.Amount <> 0 then
                                Gnljnline.Insert;
                            RunningBalance := RunningBalance - Abs(Gnljnline.Amount);
                        end;
                    end;
                until LoanApp.Next = 0;
            end;
            exit(RunningBalance);
        end;
    end;

    local procedure FnRunPrinciple(ObjRcptBuffer: Record "KRB CheckoffLines"; RunningBalance: Decimal; LoanCutoffDate: Date; loanCode: Code[10]): Decimal
    var
        varTotalRepay: Decimal;
        varMultipleLoan: Decimal;
        varLRepayment: Decimal;
        AmountToDeduct: Decimal;
        NewOutstandingBal: Decimal;
    begin

        if RunningBalance > 0 then begin
            varTotalRepay := 0;
            varMultipleLoan := 0;
            MonthlyRepay := 0;
            ScheduleRepayment := 0;

            LoanApp.Reset;
            LoanApp.SetCurrentkey(Source, "Issued Date", "Loan Product Type", "Client Code", "Staff No");
            LoanApp.SetRange(LoanApp."Client Code", ObjRcptBuffer."Member No");
            // LoanApp.SetRange(LoanApp."Recovery Mode", LoanApp."recovery mode"::"Payroll Deduction");//Comment kiasi here..Festus
            LoanApp.SetRange(LoanApp."Loan Product Type", loanCode);
            //LoanApp.SETRANGE(LoanApp."Issued Date",startDate,IssueDate);
            if LoanApp.Findset then begin

                repeat
                    if RunningBalance > 0 then begin
                        LoanApp.CalcFields(LoanApp."Outstanding Balance", LoanApp."Oustanding Interest");
                        if (LoanApp."Outstanding Balance" > 0) then begin
                            if (LoanApp."Issued Date" <= LoanCutoffDate) then begin

                                if LoanApp."Oustanding Interest" >= 0 then begin
                                    AmountToDeduct := RunningBalance;
                                    NewOutstandingBal := LoanApp."Outstanding Balance" - RunningBalance;
                                    if AmountToDeduct >= (LoanApp.Repayment - LoanApp."Oustanding Interest") then begin
                                        MonthlyRepay := LoanApp.Repayment - LoanApp."Oustanding Interest";
                                        NewOutstandingBal := LoanApp."Outstanding Balance" - MonthlyRepay;
                                    end else if AmountToDeduct < (LoanApp.Repayment - LoanApp."Oustanding Interest") then begin
                                        MonthlyRepay := AmountToDeduct;
                                        NewOutstandingBal := LoanApp."Outstanding Balance" - MonthlyRepay;
                                    end;
                                end;
                                if MonthlyRepay >= LoanApp."Outstanding Balance" then begin
                                    // AmountToDeduct:=LoanApp."Outstanding Balance";
                                    // NewOutstandingBal:=LoanApp."Outstanding Balance"-AmountToDeduct;
                                    MonthlyRepay := LoanApp."Outstanding Balance";
                                    NewOutstandingBal := LoanApp."Outstanding Balance" - MonthlyRepay;
                                end;


                                //GET SCHEDULE REPYAMENT

                                Lschedule.Reset;
                                Lschedule.SetRange(Lschedule."Loan No.", LoanApp."Loan  No.");
                                //Lschedule.SETRANGE(Lschedule."Repayment Date","Posting date");
                                if Lschedule.FindFirst then begin
                                    LoanApp.CalcFields(LoanApp."Outstanding Balance", LoanApp."Oustanding Interest");
                                    //ScheduleRepayment:=Lschedule."Principal Repayment";
                                    ScheduleRepayment := Lschedule."Monthly Repayment" - LoanApp."Oustanding Interest";
                                    if ScheduleRepayment > LoanApp."Outstanding Balance" then begin
                                        ScheduleRepayment := LoanApp."Outstanding Balance"
                                    end else
                                        ScheduleRepayment := ScheduleRepayment;
                                end;

                                LineN := LineN + 10000;
                                Gnljnline.Init;
                                Gnljnline."Journal Template Name" := Jtemplate;
                                Gnljnline."Journal Batch Name" := Jbatch;
                                Gnljnline."Line No." := LineN;
                                Gnljnline."Account Type" := Gnljnline."bal. account type"::Customer;
                                Gnljnline."Account No." := LoanApp."Client Code";
                                Gnljnline.Validate(Gnljnline."Account No.");
                                Gnljnline."Document No." := Rec."Document No";
                                Gnljnline."Posting Date" := Rec."Posting date";
                                Gnljnline.Description := LoanApp."Loan Product Type" + '-Loan Repayment ';
                                if RunningBalance > ScheduleRepayment then begin
                                    Gnljnline.Amount := ScheduleRepayment * -1//MonthlyRepay*-1;
                                end else
                                    Gnljnline.Amount := RunningBalance * -1;
                                Gnljnline.Validate(Gnljnline.Amount);
                                Gnljnline."Transaction Type" := Gnljnline."transaction type"::"Loan Repayment";
                                Gnljnline."Loan No" := LoanApp."Loan  No.";
                                Gnljnline."Shortcut Dimension 1 Code" := 'BOSA';
                                Gnljnline."Shortcut Dimension 2 Code" := FnGetMemberBranch(LoanApp."Client Code");
                                Gnljnline.Validate(Gnljnline."Shortcut Dimension 1 Code");
                                Gnljnline.Validate(Gnljnline."Shortcut Dimension 2 Code");
                                if Gnljnline.Amount <> 0 then
                                    Gnljnline.Insert();
                                RunningBalance := RunningBalance - Abs(Gnljnline.Amount);
                            end;
                        end;
                    end;
                until LoanApp.Next = 0;
            end;
            exit(RunningBalance);
        end;
    end;

    local procedure FnRunLoanRepayment(ObjRcptBuffer: Record "KRB CheckoffLines"; RunningBalance: Decimal; LoanCutoffDate: Date; loanCode: Code[10]): Decimal
    var
        varTotalRepay: Decimal;
        varMultipleLoan: Decimal;
        varLRepayment: Decimal;
        AmountToDeduct: Decimal;
        NewOutstandingBal: Decimal;
    begin

        if RunningBalance > 0 then begin
            varTotalRepay := 0;
            varMultipleLoan := 0;
            MonthlyRepay := 0;
            ScheduleRepayment := 0;
            AmountToDeduct := 0;

            LoanApp.Reset;
            LoanApp.SetCurrentkey(Source, "Issued Date", "Loan Product Type", "Client Code", "Staff No");
            LoanApp.SetRange(LoanApp."Client Code", ObjRcptBuffer."Member No");
            // LoanApp.SetRange(LoanApp."Recovery Mode", LoanApp."recovery mode"::"Payroll Deduction");//Comment kiasi here..Festus
            LoanApp.SetRange(LoanApp."Loan Product Type", loanCode);
            //LoanApp.SETRANGE(LoanApp."Issued Date",startDate,IssueDate);
            if LoanApp.Findset then begin

                repeat
                    if RunningBalance > 0 then begin
                        LoanApp.CalcFields(LoanApp."Outstanding Balance", LoanApp."Oustanding Interest");
                        if (LoanApp."Outstanding Balance" > 0) then begin
                            // if (LoanApp."Issued Date" <= LoanCutoffDate) then begin

                            if LoanApp."Outstanding Balance" > 0 then begin
                                if LoanApp."Outstanding Balance" >= RunningBalance then begin
                                    AmountToDeduct := RunningBalance;
                                end else if RunningBalance > LoanApp."Outstanding Balance" then begin
                                    AmountToDeduct := LoanApp."Outstanding Balance";
                                end;
                            end else begin
                                AmountToDeduct := 0;
                            end;

                            LineN := LineN + 10000;
                            Gnljnline.Init;
                            Gnljnline."Journal Template Name" := Jtemplate;
                            Gnljnline."Journal Batch Name" := Jbatch;
                            Gnljnline."Line No." := LineN;
                            Gnljnline."Account Type" := Gnljnline."bal. account type"::Customer;
                            Gnljnline."Account No." := LoanApp."Client Code";
                            Gnljnline.Validate(Gnljnline."Account No.");
                            Gnljnline."Document No." := Rec."Document No";
                            Gnljnline."Posting Date" := Rec."Posting date";
                            Gnljnline.Description := LoanApp."Loan Product Type" + '-Loan Repayment ';
                            Gnljnline.Amount := AmountToDeduct * -1;///Just repay the Loan...Festus
                            Gnljnline.Validate(Gnljnline.Amount);
                            Gnljnline."Transaction Type" := Gnljnline."transaction type"::"Loan Repayment";
                            Gnljnline."Loan No" := LoanApp."Loan  No.";
                            Gnljnline."Shortcut Dimension 1 Code" := 'BOSA';
                            Gnljnline."Shortcut Dimension 2 Code" := FnGetMemberBranch(LoanApp."Client Code");
                            Gnljnline.Validate(Gnljnline."Shortcut Dimension 1 Code");
                            Gnljnline.Validate(Gnljnline."Shortcut Dimension 2 Code");
                            if Gnljnline.Amount <> 0 then
                                Gnljnline.Insert();
                            RunningBalance := RunningBalance - Abs(Gnljnline.Amount);
                            // end;
                        end;
                    end;
                until LoanApp.Next = 0;
            end;
            exit(RunningBalance);
        end;
    end;

    local procedure FnRecoverPrincipleFromExcess(ObjRcptBuffer: Record "ReceiptsProcessing_L-Checkoff"; RunningBalance: Decimal): Decimal
    var
        varTotalRepay: Decimal;
        varMultipleLoan: Decimal;
        varLRepayment: Decimal;
        ObjTempLoans: Record "Temp Loans Balances";
        AmountToDeduct: Decimal;
    begin
        if RunningBalance > 0 then begin
            varTotalRepay := 0;
            varMultipleLoan := 0;

            ObjTempLoans.Reset;
            ObjTempLoans.SetRange(ObjTempLoans."Loan No", ObjRcptBuffer."Member No");
            if ObjTempLoans.Find('-') then begin
                repeat
                    if RunningBalance > 0 then begin
                        if ObjTempLoans."Outstanding Balance" > 0 then begin
                            AmountToDeduct := RunningBalance;
                            if AmountToDeduct >= ObjTempLoans."Outstanding Balance" then
                                AmountToDeduct := ObjTempLoans."Outstanding Balance";
                            LineN := LineN + 10000;
                            Gnljnline.Init;
                            Gnljnline."Journal Template Name" := Jtemplate;
                            Gnljnline."Journal Batch Name" := Jbatch;
                            Gnljnline."Line No." := LineN;
                            Gnljnline."Account Type" := Gnljnline."bal. account type"::Customer;
                            Gnljnline."Account No." := LoanApp."Client Code";
                            Gnljnline.Validate(Gnljnline."Account No.");
                            Gnljnline."Document No." := Rec."Document No";
                            Gnljnline."Posting Date" := Rec."Posting date";
                            Gnljnline.Description := LoanApp."Loan Product Type" + '-Repayment from excess checkoff'; //TODO Change the Narrative after testing
                            Gnljnline.Amount := AmountToDeduct * -1;
                            Gnljnline.Validate(Gnljnline.Amount);
                            Gnljnline."Transaction Type" := Gnljnline."transaction type"::"Loan Repayment";
                            Gnljnline."Loan No" := LoanApp."Loan  No.";
                            Gnljnline."Shortcut Dimension 1 Code" := 'BOSA';
                            Gnljnline."Shortcut Dimension 2 Code" := FnGetMemberBranch(ObjTempLoans."Loan No");
                            Gnljnline.Validate(Gnljnline."Shortcut Dimension 1 Code");
                            Gnljnline.Validate(Gnljnline."Shortcut Dimension 2 Code");
                            if Gnljnline.Amount <> 0 then
                                Gnljnline.Insert;
                            RunningBalance := RunningBalance - Abs(Gnljnline.Amount);
                        end;
                    end;
                until ObjTempLoans.Next = 0;
            end;
            exit(RunningBalance);
        end;
    end;

    local procedure FnGetMemberBranch(MemberNo: Code[50]): Code[100]
    var
        MemberBranch: Code[100];
    begin
        Cust.Reset;
        Cust.SetRange(Cust."No.", MemberNo);
        if Cust.Find('-') then begin
            MemberBranch := Cust."Global Dimension 2 Code";
        end;
        exit(MemberBranch);
    end;

    local procedure FnTransferExcessToUnallocatedFunds(ObjRcptBuffer: Record "KRB CheckoffLines"; RunningBalance: Decimal; description: Code[50])
    var
        varTotalRepay: Decimal;
        varMultipleLoan: Decimal;
        varLRepayment: Decimal;
        ObjMember: Record Customer;
        AmountToDeduct: Decimal;
        AmountToTransfer: Decimal;
    begin
        if RunningBalance > 0 then begin
            ObjMember.Reset;
            ObjMember.SetRange(ObjMember."No.", ObjRcptBuffer."Member No");
            // ObjMember.SETRANGE(ObjMember."Employer Code",ObjRcptBuffer."Employer Code");
            ObjMember.SetRange(ObjMember."Customer Type", ObjMember."customer type"::Member);
            if ObjMember.Find('-') then begin
                AmountToTransfer := 0;
                AmountToTransfer := RunningBalance;

                LineN := LineN + 10000;
                Gnljnline.Init;
                Gnljnline."Journal Template Name" := Jtemplate;
                Gnljnline."Journal Batch Name" := Jbatch;
                Gnljnline."Line No." := LineN;
                Gnljnline."Account Type" := Gnljnline."account type"::Customer;
                Gnljnline."Account No." := ObjRcptBuffer."Member No";
                Gnljnline.Validate(Gnljnline."Account No.");
                Gnljnline."Document No." := Rec."Document No";
                Gnljnline."Posting Date" := Rec."Posting date";
                Gnljnline.Description := description;
                Gnljnline.Amount := AmountToTransfer * -1;
                Gnljnline.Validate(Gnljnline.Amount);
                Gnljnline."Transaction Type" := Gnljnline."transaction type"::"Unallocated Funds";
                Gnljnline."Shortcut Dimension 1 Code" := 'BOSA';
                Gnljnline."Shortcut Dimension 2 Code" := ObjMember."Global Dimension 2 Code";
                Gnljnline.Validate(Gnljnline."Shortcut Dimension 1 Code");
                Gnljnline.Validate(Gnljnline."Shortcut Dimension 2 Code");
                if Gnljnline.Amount <> 0 then
                    Gnljnline.Insert;
            end;
        end;
    end;


}
