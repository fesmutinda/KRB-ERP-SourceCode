#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
page 50400 "BOSA Receipt Card"
{
    DeleteAllowed = true;
    InsertAllowed = true;
    Editable = true;
    PageType = Card;
    SourceTable = "Receipts & Payments";
    SourceTableView = where(Posted = filter(false));

    layout
    {
        area(content)
        {
            group(Transaction)
            {
                Caption = 'Transaction';
                field("Transaction No."; Rec."Transaction No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Account Type"; Rec."Account Type")
                {
                    ApplicationArea = Basic;

                }
                field(Source; Rec.Source)
                {
                    ApplicationArea = Basic;
                }
                field("Account No."; Rec."Account No.")
                {
                    ApplicationArea = Basic;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = Basic;
                }
                field("Receipt Mode"; Rec."Receipt Mode")
                {
                    ApplicationArea = Basic;
                }
                field("Excess Transaction Type"; Rec."Excess Transaction Type")
                {
                    ApplicationArea = Basic;
                }
                field(Remarks; Rec.Remarks)
                {
                    ApplicationArea = Basic;
                }
                field("Allocated Amount"; Rec."Allocated Amount")
                {
                    ApplicationArea = Basic;
                }

                field("Employer No."; Rec."Employer No.")
                {
                    ApplicationArea = Basic;
                    Caption = 'Bank Account No.';
                }
                field("Cheque No."; Rec."Cheque No.")
                {
                    ApplicationArea = Basic;
                    Caption = 'Cheque / Slip  No.';
                }
                field("Transaction Date"; Rec."Transaction Date")
                {
                    ApplicationArea = Basic;
                    Editable = true;
                    Caption = 'Receipting Date';
                }
                field("Cheque Date"; Rec."Cheque Date")
                {
                    ApplicationArea = Basic;
                    Caption = 'Banking Date';
                }
                field("User ID"; Rec."User ID")
                {
                    ApplicationArea = Basic;
                }

                field("Transaction Time"; Rec."Transaction Time")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }

            }
            part("Receipt Allocation"; "Receipt Allocation-BOSA")
            {
                ApplicationArea = Basic;
                SubPageLink = "Document No" = field("Transaction No."),
                              "Member No" = field("Account No.");
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Suggest)
            {
                Caption = 'Suggest';
                action("Cash/Cheque Clearance")
                {
                    ApplicationArea = Basic;
                    Caption = 'Cash/Cheque Clearance';
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedOnly = true;
                    Visible = false;

                    trigger OnAction()
                    begin
                        Cheque := false;
                        //SuggestBOSAEntries();
                    end;
                }
                separator(Action1102760032)
                {
                }
                action("Suggest Payments")
                {
                    ApplicationArea = Basic;
                    Caption = 'Suggest Monthy Repayments';
                    Image = Suggest;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedOnly = true;

                    trigger OnAction()
                    var
                        ObjTransactions: Record "Receipt Allocation";
                        RunBal: Decimal;
                        Datefilter: Text;
                    begin

                        Rec.TestField(Posted, false);
                        Rec.TestField("Account No.");
                        Rec.TestField(Amount);
                        // ,Registration Fee,Share Capital,Interest Paid,Loan Repayment,Deposit Contribution,Insurance Contribution,Benevolent Fund,Loan,Unallocated Funds,Dividend,FOSA Account

                        ObjTransactions.Reset;
                        ObjTransactions.SetRange(ObjTransactions."Document No", Rec."Transaction No.");
                        if ObjTransactions.Find('-') then
                            ObjTransactions.DeleteAll;

                        Datefilter := '..' + Format(Rec."Transaction Date");
                        RunBal := 0;
                        RunBal := Rec.Amount;
                        RunBal := FnRunEntranceFee(Rec, RunBal);
                        RunBal := FnRunInterest(Rec, RunBal);
                        RunBal := FnRunPrinciple(Rec, RunBal);
                        RunBal := FnRunShareCapital(Rec, RunBal);
                        RunBal := FnRunDepositContribution(Rec, RunBal);

                        if RunBal > 0 then begin
                            if Confirm('Excess Money will allocated to ' + Format(Rec."Excess Transaction Type") + '.Do you want to Continue?', true) = false then
                                exit;
                            case Rec."Excess Transaction Type" of
                                Rec."excess transaction type"::"Deposit Contribution":
                                    FnRunDepositContributionFromExcess(Rec, RunBal);
                                Rec."excess transaction type"::"Withdrawable Savings":
                                    FnRunSavingsProductExcess(Rec, RunBal, 'Withdrawable Savings');
                                Rec."excess transaction type"::"Junior Savings":
                                    FnRunSavingsProductExcess(Rec, RunBal, 'Junior Savings');
                            end;

                        end;


                        Rec.CalcFields("Allocated Amount");
                        Rec."Un allocated Amount" := (Rec.Amount - Rec."Allocated Amount");
                        Rec.Modify;
                    end;
                }
            }
        }
        area(processing)
        {
            action(Post)
            {
                ApplicationArea = Basic;
                Caption = 'Post (F11)';
                Image = Post;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                ShortcutKey = 'F11';

                trigger OnAction()
                begin
                    if Rec.Posted then
                        Error('This receipt is already posted');

                    Rec.TestField("Account No.");
                    Rec.TestField(Amount);

                    if (Rec."Account Type" = Rec."account type"::"G/L Account") then
                        TransType := 'Withdrawal'
                    else
                        TransType := 'Deposit';
                    if FundsUSer.Get(UserId) then begin
                        Jtemplate := FundsUSer."Receipt Journal Template";
                        Jbatch := FundsUSer."Receipt Journal Batch";
                    end;
                    BOSABank := Rec."Employer No.";
                    if (Rec."Account Type" = Rec."account type"::Customer) then begin

                        if Rec.Amount <> Rec."Allocated Amount" then
                            Error('Receipt amount must be equal to the allocated amount.');
                    end;

                    GenJournalLine.Reset;
                    GenJournalLine.SetRange("Journal Template Name", Jtemplate);
                    GenJournalLine.SetRange("Journal Batch Name", Jbatch);
                    GenJournalLine.DeleteAll;


                    LineNo := LineNo + 10000;
                    GenJournalLine.Init;
                    GenJournalLine."Journal Template Name" := Jtemplate;
                    GenJournalLine."Journal Batch Name" := Jbatch;
                    GenJournalLine."Document No." := Rec."Transaction No.";
                    GenJournalLine."External Document No." := Rec."Cheque No.";
                    GenJournalLine."Line No." := LineNo;
                    GenJournalLine."Account Type" := GenJournalLine."account type"::"Bank Account";
                    GenJournalLine."Account No." := Rec."Employer No.";
                    GenJournalLine.Validate(GenJournalLine."Account No.");
                    GenJournalLine."Posting Date" := Rec."Cheque Date";
                    //GenJournalLine."Posting Date":="Transaction Date";
                    GenJournalLine.Description := Rec."Account No." + '-' + Rec.Name;
                    GenJournalLine.Validate(GenJournalLine."Currency Code");
                    ReceiptAllocations."Global Dimension 1 Code" := Rec."Global Dimension 1 Code";
                    ReceiptAllocations."Global Dimension 2 Code" := Rec."Global Dimension 2 Code";
                    if TransType = 'Withdrawal' then
                        GenJournalLine.Amount := -Rec.Amount
                    else
                        GenJournalLine.Amount := Rec.Amount;
                    GenJournalLine.Validate(GenJournalLine.Amount);
                    if GenJournalLine.Amount <> 0 then
                        GenJournalLine.Insert;

                    if (Rec."Account Type" <> Rec."account type"::Customer) then begin
                        LineNo := LineNo + 10000;
                        GenJournalLine.Init;
                        GenJournalLine."Journal Template Name" := Jtemplate;
                        GenJournalLine."Journal Batch Name" := Jbatch;
                        GenJournalLine."Document No." := Rec."Transaction No.";
                        GenJournalLine."External Document No." := Rec."Cheque No.";
                        GenJournalLine."Line No." := LineNo;
                        if Rec."Account Type" = Rec."account type"::"G/L Account" then
                            GenJournalLine."Account Type" := Rec."Account Type"
                        else if Rec."Account Type" = Rec."account type"::Customer then
                            GenJournalLine."Account Type" := Rec."Account Type";
                        GenJournalLine."Account No." := ReceiptAllocations."Member No";
                        GenJournalLine.Validate(GenJournalLine."Account No.");
                        GenJournalLine."Posting Date" := Rec."Cheque Date";
                        //GenJournalLine."Posting Date":="Transaction Date";
                        GenJournalLine.Description := 'BT-' + Rec.Name + '-' + Rec."Account No." + '-' + Rec.Name;
                        GenJournalLine.Validate(GenJournalLine."Currency Code");
                        if TransType = 'Withdrawal' then
                            GenJournalLine.Amount := Rec.Amount
                        else
                            GenJournalLine.Amount := -Rec.Amount;
                        GenJournalLine.Validate(GenJournalLine.Amount);
                        ReceiptAllocations."Global Dimension 1 Code" := Rec."Global Dimension 1 Code";
                        ReceiptAllocations."Global Dimension 2 Code" := Rec."Global Dimension 2 Code";
                        if GenJournalLine.Amount <> 0 then
                            GenJournalLine.Insert;
                    end;

                    GenSetup.Get();

                    if (Rec."Account Type" = Rec."account type"::Customer) then begin
                        ReceiptAllocations.Reset;
                        ReceiptAllocations.SetRange(ReceiptAllocations."Document No", Rec."Transaction No.");
                        if ReceiptAllocations.Find('-') then begin
                            repeat
                                LineNo := LineNo + 10000;
                                GenJournalLine.Init;
                                GenJournalLine."Journal Template Name" := Jtemplate;
                                GenJournalLine."Journal Batch Name" := Jbatch;
                                GenJournalLine."Line No." := LineNo;
                                GenJournalLine."Document No." := Rec."Transaction No.";
                                GenJournalLine."External Document No." := Rec."Cheque No.";
                                GenJournalLine."Posting Date" := Rec."Cheque Date";
                                //GenJournalLine."Posting Date":="Transaction Date";
                                if ReceiptAllocations."Account No" <> '' then begin
                                    GenJournalLine."Account Type" := GenJournalLine."account type"::Customer;
                                    GenJournalLine."Account No." := ReceiptAllocations."Member No";
                                    GenJournalLine.Validate(GenJournalLine."Account No.");
                                end else begin
                                    GenJournalLine."Account Type" := GenJournalLine."account type"::Customer;
                                    GenJournalLine."Account No." := ReceiptAllocations."Member No";
                                    GenJournalLine.Validate(GenJournalLine."Account No.");
                                end;

                                GenJournalLine."Posting Date" := Rec."Cheque Date";
                                GenJournalLine.Description := ReceiptAllocations.Description;//'BT-' + '-' + Rec."Account No." + '-' + Rec.Name;
                                ReceiptAllocations."Global Dimension 1 Code" := 'BOSA';
                                ReceiptAllocations."Global Dimension 2 Code" := SURESTEPFactory.FnGetUserBranch();
                                GenJournalLine.Amount := -ReceiptAllocations.Amount;
                                GenJournalLine."Shortcut Dimension 1 Code" := ReceiptAllocations."Global Dimension 1 Code";
                                GenJournalLine."Shortcut Dimension 2 Code" := ReceiptAllocations."Global Dimension 2 Code";
                                GenJournalLine.Validate(GenJournalLine.Amount);
                                GenJournalLine."Transaction Type" := ReceiptAllocations."Transaction Type";
                                GenJournalLine."Loan No" := ReceiptAllocations."Loan No.";
                                if GenJournalLine.Amount <> 0 then
                                    GenJournalLine.Insert;
                            until ReceiptAllocations.Next = 0;
                        end;


                    end;

                    //Post New
                    GenJournalLine.Reset;
                    GenJournalLine.SetRange("Journal Template Name", Jtemplate);
                    GenJournalLine.SetRange("Journal Batch Name", Jbatch);
                    if GenJournalLine.Find('-') then begin
                        Codeunit.Run(Codeunit::"Gen. Jnl.-Post Sacco", GenJournalLine);
                    end;
                    //Post New
                    Message('Transaction posted successfully');
                    Rec.Posted := true;
                    rec.Modify;
                    Commit;


                    // BOSARcpt.Reset;
                    // BOSARcpt.SetRange(BOSARcpt."Transaction No.", "Transaction No.");
                    // if BOSARcpt.Find('-') then
                    //     Report.Run(50259, true, false, BOSARcpt);

                    CurrPage.Close;
                end;
            }
            action("Reprint Frecipt")
            {
                ApplicationArea = Basic;
                Caption = 'Reprint Receipt';
                Promoted = true;
                PromotedCategory = Process;
                Visible = false;

                trigger OnAction()
                begin
                    Rec.TestField(Posted);

                    BOSARcpt.Reset;
                    BOSARcpt.SetRange(BOSARcpt."Transaction No.", Rec."Transaction No.");
                    if BOSARcpt.Find('-') then
                        Report.Run(50259, true, true, BOSARcpt)
                end;
            }
        }
    }

    // trigger OnAfterGetCurrRecord()
    // begin
    //     CalcFields("Allocated Amount");
    //     "Un allocated Amount" := Amount - "Allocated Amount";
    // end;

    var
        GenJournalLine: Record "Gen. Journal Line";
        InterestPaid: Decimal;
        PaymentAmount: Decimal;
        RunBal: Decimal;
        Recover: Boolean;
        Cheque: Boolean;
        ReceiptAllocations: Record "Receipt Allocation";
        Loans: Record "Loans Register";
        Commision: Decimal;
        LOustanding: Decimal;
        TotalCommision: Decimal;
        TotalOustanding: Decimal;
        Cust: Record Customer;
        BOSABank: Code[20];
        LineNo: Integer;
        BOSARcpt: Record "Receipts & Payments";
        TellerTill: Record "Bank Account";
        CurrentTellerAmount: Decimal;
        TransType: Text[30];
        RCPintdue: Decimal;
        Text001: label 'This member has reached a maximum share contribution of Kshs. 5,000/=. Do you want to post this transaction as shares contribution?';
        BosaSetUp: Record "Sacco General Set-Up";
        MpesaCharge: Decimal;
        CustPostingGrp: Record "Customer Posting Group";
        MpesaAc: Code[30];
        GenSetup: Record "Sacco General Set-Up";
        ShareCapDefecit: Decimal;
        LoanApp: Record "Loans Register";
        Datefilter: Text;
        SURESTEPFactory: Codeunit "SURESTEP Factory";
        Tdate: Date;
        Exp: Text;
        Pdate: Date;

        UsersID: Record User;
        FundsUSer: Record "Funds User Setup";
        Jtemplate: Code[10];
        Jbatch: Code[10];

    local procedure AllocatedAmountOnDeactivate()
    begin
        CurrPage.Update := true;
    end;

    local procedure FnRunInterest(ObjRcptBuffer: Record "Receipts & Payments"; RunningBalance: Decimal): Decimal
    var
        AmountToDeduct: Decimal;
        ObjReceiptTransactions: Record "Receipt Allocation";

    begin
        if RunningBalance > 0 then begin
            LoanApp.Reset;
            LoanApp.SetCurrentkey(Source, "Issued Date", "Loan Product Type", "Client Code", "Staff No", "Employer Code");
            LoanApp.SetRange(LoanApp."Client Code", ObjRcptBuffer."Account No.");
            LoanApp.SetFilter(LoanApp."Date filter", Datefilter);
            if LoanApp.Find('-') then begin
                repeat
                    LoanApp.CALCFIELDS(LoanApp."Oustanding Interest");
                    if (LoanApp."Oustanding Interest" > 0) then begin
                        if RunningBalance > 0 then begin
                            AmountToDeduct := 0;
                            AmountToDeduct := ROUND(LoanApp."Oustanding Interest", 0.05, '>');
                            if RunningBalance <= AmountToDeduct then
                                AmountToDeduct := RunningBalance;
                            ObjReceiptTransactions.Init;
                            ObjReceiptTransactions."Document No" := ObjRcptBuffer."Transaction No.";
                            ObjReceiptTransactions."Account Type" := ObjReceiptTransactions."account type"::Customer;
                            ObjReceiptTransactions."Member No" := ObjRcptBuffer."Account No.";
                            ObjReceiptTransactions."Loan No." := LoanApp."Loan  No.";
                            ObjReceiptTransactions."Transaction Type" := ObjReceiptTransactions."transaction type"::"Interest Paid";
                            ObjReceiptTransactions."Global Dimension 1 Code" := 'BOSA';
                            ObjReceiptTransactions."Global Dimension 2 Code" := SURESTEPFactory.FnGetMemberBranch(ObjRcptBuffer."Account No.");
                            ObjReceiptTransactions.Amount := AmountToDeduct;
                            if ObjReceiptTransactions.Amount > 0 then //"Document No", "Transaction Type", Amount, "Account Type", "Account No", "Member No", "Loan No.")
                                if not ObjReceiptTransactions.Get(ObjReceiptTransactions."Document No", ObjReceiptTransactions."Transaction Type", ObjReceiptTransactions.Amount, ObjReceiptTransactions."Account Type", ObjReceiptTransactions."Account No", ObjReceiptTransactions."Member No", ObjReceiptTransactions."Loan No.") then
                                    ObjReceiptTransactions.Insert(true)
                                else
                                    ObjRcptBuffer.Modify();
                            RunningBalance := RunningBalance - Abs(ObjReceiptTransactions.Amount);
                        end;
                    end;
                until LoanApp.Next = 0;
            end;
            exit(RunningBalance);
        end;
    end;

    // local procedure FnRunLoanInsurance(ObjRcptBuffer: Record "Receipts & Payments"; RunningBalance: Decimal): Decimal
    // var
    //     AmountToDeduct: Decimal;
    //     ObjReceiptTransactions: Record "Receipt Allocation";
    // begin
    //     if RunningBalance > 0 then begin
    //         LoanApp.Reset;
    //         LoanApp.SetCurrentkey(Source, "Issued Date", "Loan Product Type", "Client Code", "Staff No", "Employer Code");
    //         LoanApp.SetRange(LoanApp."Client Code", ObjRcptBuffer."Account No.");
    //         LoanApp.SetFilter(LoanApp."Date filter", Datefilter);
    //         LoanApp.SetAutoCalcFields(LoanApp."Outstanding Insurance");
    //         if LoanApp.Find('-') then begin
    //             repeat
    //                 LoanApp.CALCFIELDS(LoanApp."Outstanding Insurance");
    //                 if LoanApp."Outstanding Insurance" > 0 then begin
    //                     if RunningBalance > 0 then begin
    //                         AmountToDeduct := 0;
    //                         AmountToDeduct := ROUND(LoanApp."Outstanding Insurance", 0.05, '>');
    //                         if RunningBalance <= AmountToDeduct then
    //                             AmountToDeduct := RunningBalance;
    //                         ObjReceiptTransactions.Init;
    //                         ObjReceiptTransactions."Document No" := ObjRcptBuffer."Transaction No.";
    //                         ObjReceiptTransactions."Account Type" := ObjReceiptTransactions."account type"::Customer;
    //                         ObjReceiptTransactions."Member No" := ObjRcptBuffer."Account No.";
    //                         ObjReceiptTransactions."Loan No." := LoanApp."Loan  No.";
    //                         ObjReceiptTransactions."Transaction Type" := ObjReceiptTransactions."transaction type"::"Loan Insurance Paid";
    //                         ObjReceiptTransactions."Global Dimension 1 Code" := 'BOSA';
    //                         ObjReceiptTransactions."Global Dimension 2 Code" := SURESTEPFactory.FnGetMemberBranch(ObjRcptBuffer."Account No.");
    //                         ObjReceiptTransactions.Amount := AmountToDeduct;
    //                         if ObjReceiptTransactions.Amount > 0 then
    //                             ObjReceiptTransactions.Insert(true);
    //                         RunningBalance := RunningBalance - Abs(ObjReceiptTransactions.Amount);
    //                     end;
    //                 end;
    //             until LoanApp.Next = 0;
    //         end;
    //         exit(RunningBalance);
    //     end;
    // end;

    // protected procedure FnRunLoanApplicationFee(ObjRcptBuffer: Record "Receipts & Payments"; RunningBalance: Decimal): Decimal
    // var
    //     AmountToDeduct: Decimal;
    //     ObjReceiptTransactions: Record "Receipt Allocation";
    // begin
    //     if RunningBalance > 0 then begin
    //         LoanApp.Reset;
    //         LoanApp.SetCurrentkey(Source, "Issued Date", "Loan Product Type", "Client Code", "Staff No", "Employer Code");
    //         LoanApp.SetRange(LoanApp."Client Code", ObjRcptBuffer."Account No.");
    //         LoanApp.SetFilter(LoanApp."Date filter", Datefilter);
    //         LoanApp.SetAutoCalcFields(LoanApp."Out. Loan Application fee");
    //         if LoanApp.Find('-') then begin
    //             repeat
    //                 LoanApp.CALCFIELDS(LoanApp."Out. Loan Application fee");
    //                 if LoanApp."Out. Loan Application fee" > 0 then begin
    //                     if RunningBalance > 0 then begin
    //                         AmountToDeduct := 0;
    //                         AmountToDeduct := ROUND(LoanApp."Out. Loan Application fee", 0.05, '>');
    //                         if RunningBalance <= AmountToDeduct then
    //                             AmountToDeduct := RunningBalance;
    //                         ObjReceiptTransactions.Init;
    //                         ObjReceiptTransactions."Document No" := ObjRcptBuffer."Transaction No.";
    //                         ObjReceiptTransactions."Account Type" := ObjReceiptTransactions."account type"::Customer;
    //                         ObjReceiptTransactions."Member No" := ObjRcptBuffer."Account No.";
    //                         ObjReceiptTransactions."Loan No." := LoanApp."Loan  No.";
    //                         ObjReceiptTransactions."Transaction Type" := ObjReceiptTransactions."transaction type"::"Loan Application Fee Paid";
    //                         ObjReceiptTransactions."Global Dimension 1 Code" := 'BOSA';
    //                         ObjReceiptTransactions."Global Dimension 2 Code" := SURESTEPFactory.FnGetMemberBranch(ObjRcptBuffer."Account No.");
    //                         ObjReceiptTransactions.Amount := AmountToDeduct;
    //                         if ObjReceiptTransactions.Amount > 0 then
    //                             ObjReceiptTransactions.Insert(true);
    //                         RunningBalance := RunningBalance - Abs(ObjReceiptTransactions.Amount);
    //                     end;
    //                 end;
    //             until LoanApp.Next = 0;
    //         end;
    //         exit(RunningBalance);
    //     end;
    // end;

    local procedure FnRunPrinciple(ObjRcptBuffer: Record "Receipts & Payments"; RunningBalance: Decimal): Decimal
    var
        AmountToDeduct: Decimal;
        ObjReceiptTransactions: Record "Receipt Allocation";
        varTotalRepay: Decimal;
        varMultipleLoan: Decimal;
        varLRepayment: Decimal;
        PRpayment: Decimal;
    begin
        if RunningBalance > 0 then begin
            LoanApp.Reset;
            LoanApp.SetCurrentkey(Source, "Issued Date", "Loan Product Type", "Client Code", "Staff No", "Employer Code");
            LoanApp.SetRange(LoanApp."Client Code", ObjRcptBuffer."Account No.");
            LoanApp.SetFilter(LoanApp."Date filter", Datefilter);

            if LoanApp.Find('-') then begin
                repeat
                    AmountToDeduct := 0;
                    if RunningBalance > 0 then begin
                        LoanApp.CalcFields(LoanApp."Outstanding Balance", LoanApp."Oustanding Interest");
                        if LoanApp."Outstanding Balance" > 0 then begin
                            AmountToDeduct := (LoanApp.Repayment - LoanApp."Oustanding Interest");
                            if AmountToDeduct > 0 then begin
                                if AmountToDeduct > LoanApp."Outstanding Balance" then
                                    AmountToDeduct := LoanApp."Outstanding Balance";
                                if AmountToDeduct > RunningBalance then
                                    AmountToDeduct := RunningBalance;
                                ObjReceiptTransactions.Init;
                                ObjReceiptTransactions."Document No" := ObjRcptBuffer."Transaction No.";
                                ObjReceiptTransactions."Account Type" := ObjReceiptTransactions."account type"::Customer;
                                ObjReceiptTransactions."Member No" := LoanApp."Client Code";
                                ObjReceiptTransactions."Transaction Type" := ObjReceiptTransactions."transaction type"::"Loan Repayment";
                                ObjReceiptTransactions.Validate(ObjReceiptTransactions."Transaction Type");
                                ObjReceiptTransactions."Loan No." := LoanApp."Loan  No.";
                                ObjReceiptTransactions.Validate(ObjReceiptTransactions."Loan No.");
                                ObjReceiptTransactions."Global Dimension 1 Code" := Format(LoanApp.Source);
                                ObjReceiptTransactions."Global Dimension 2 Code" := SURESTEPFactory.FnGetMemberBranch(ObjRcptBuffer."Account No.");
                                ObjReceiptTransactions.Amount := AmountToDeduct;
                                if ObjReceiptTransactions.Amount > 0 then
                                    ObjReceiptTransactions.Insert(true);
                                RunningBalance := RunningBalance - AmountToDeduct;
                            end;
                        end;
                    end;
                until LoanApp.Next = 0;
            end;
            exit(RunningBalance);
        end;
    end;






    local procedure FnRunEntranceFee(ObjRcptBuffer: Record "Receipts & Payments"; RunningBalance: Decimal): Decimal
    var
        AmountToDeduct: Decimal;
        ObjReceiptTransactions: Record "Receipt Allocation";
        varTotalRepay: Decimal;
        varMultipleLoan: Decimal;
        varLRepayment: Decimal;
        PRpayment: Decimal;
        ObjMember: Record Customer;
    begin
        if RunningBalance > 0 then begin
            GenSetup.Get();
            ObjMember.Reset;
            ObjMember.SetRange(ObjMember."No.", ObjRcptBuffer."Account No.");
            ObjMember.SetFilter(ObjMember."Registration Date", '>%1', GenSetup."Go Live Date"); //To Ensure deduction is for New Members Only
            if ObjMember.Find('-') then begin
                ObjMember.CalcFields(ObjMember."Registration Fee Paid");
                if Abs(ObjMember."Registration Fee Paid") < GenSetup."Registration Fee" then begin
                    if ObjMember."Registration Date" <> 0D then begin

                        AmountToDeduct := 0;
                        AmountToDeduct := GenSetup."Registration Fee" - Abs(ObjMember."Registration Fee Paid");
                        if RunningBalance <= AmountToDeduct then
                            AmountToDeduct := RunningBalance;
                        ObjReceiptTransactions.Init;
                        ObjReceiptTransactions."Account Type" := ObjReceiptTransactions."account type"::Customer;
                        ObjReceiptTransactions."Account No" := '';
                        ObjReceiptTransactions."Document No" := ObjRcptBuffer."Transaction No.";
                        ObjReceiptTransactions."Member No" := ObjRcptBuffer."Account No.";
                        ObjReceiptTransactions."Transaction Type" := ObjReceiptTransactions."transaction type"::"Registration Fee";
                        ObjReceiptTransactions."Global Dimension 1 Code" := 'BOSA';
                        ObjReceiptTransactions."Global Dimension 2 Code" := SURESTEPFactory.FnGetMemberBranch(ObjRcptBuffer."Account No.");
                        ObjReceiptTransactions.Amount := AmountToDeduct;
                        if ObjReceiptTransactions.Amount <> 0 then
                            ObjReceiptTransactions.Insert(true);
                        RunningBalance := RunningBalance - Abs(ObjReceiptTransactions.Amount);
                    end;
                end;
            end;
            exit(RunningBalance);
        end;
    end;

    local procedure FnRunShareCapital(ObjRcptBuffer: Record "Receipts & Payments"; RunningBalance: Decimal): Decimal
    var
        AmountToDeduct: Decimal;
        ObjReceiptTransactions: Record "Receipt Allocation";
        varTotalRepay: Decimal;
        varMultipleLoan: Decimal;
        varLRepayment: Decimal;
        PRpayment: Decimal;
        ObjMember: Record Customer;
        SharesCap: Decimal;
        DIFF: Decimal;
    begin
        if RunningBalance > 0 then begin
            GenSetup.Get();
            ObjMember.Reset;
            ObjMember.SetRange(ObjMember."No.", ObjRcptBuffer."Account No.");

            if ObjMember.Find('-') then begin
                //REPEAT Deducted once unless otherwise advised
                ObjMember.CalcFields(ObjMember."Shares Retained");
                if ObjMember."Shares Retained" < GenSetup."Retained Shares" then begin
                    SharesCap := GenSetup."Retained Shares";
                    DIFF := ObjMember."Monthly ShareCap Cont.";  //SharesCap - ObjMember."Shares Retained";

                    if DIFF > 1 then begin
                        if RunningBalance > 0 then begin
                            AmountToDeduct := 0;
                            AmountToDeduct := DIFF;
                            if RunningBalance <= AmountToDeduct then
                                AmountToDeduct := RunningBalance;

                            ObjReceiptTransactions.Init;
                            ObjReceiptTransactions."Account Type" := ObjReceiptTransactions."account type"::Customer;
                            // ObjReceiptTransactions."Account No" := ObjMember."Share Capital No";
                            ObjReceiptTransactions."Document No" := ObjRcptBuffer."Transaction No.";
                            ObjReceiptTransactions."Member No" := ObjRcptBuffer."Account No.";
                            ObjReceiptTransactions."Transaction Type" := ObjReceiptTransactions."transaction type"::"Share Capital";
                            ObjReceiptTransactions."Global Dimension 1 Code" := 'BOSA';
                            ObjReceiptTransactions."Global Dimension 2 Code" := SURESTEPFactory.FnGetMemberBranch(ObjRcptBuffer."Account No.");
                            ObjReceiptTransactions.Amount := AmountToDeduct;
                            if ObjReceiptTransactions.Amount <> 0 then
                                ObjReceiptTransactions.Insert(true);
                            RunningBalance := RunningBalance - Abs(ObjReceiptTransactions.Amount);
                        end;
                    end;
                end;
                //UNTIL RcptBufLines.NEXT=0;
            end;

            exit(RunningBalance);
        end;

    end;

    local procedure FnRunDepositContribution(ObjRcptBuffer: Record "Receipts & Payments"; RunningBalance: Decimal): Decimal
    var
        AmountToDeduct: Decimal;
        ObjReceiptTransactions: Record "Receipt Allocation";
        varTotalRepay: Decimal;
        varMultipleLoan: Decimal;
        varLRepayment: Decimal;
        PRpayment: Decimal;
        ObjMember: Record Customer;
        SharesCap: Decimal;
        DIFF: Decimal;
    begin
        if RunningBalance > 0 then begin
            ObjMember.Reset;
            ObjMember.SetRange(ObjMember."No.", ObjRcptBuffer."Account No.");

            if ObjMember.Find('-') then begin
                AmountToDeduct := 0;
                AmountToDeduct := ROUND(ObjMember."Monthly Contribution", 0.05, '>');
                if RunningBalance <= AmountToDeduct then
                    AmountToDeduct := RunningBalance;

                ObjReceiptTransactions.Init;
                ObjReceiptTransactions."Account Type" := ObjReceiptTransactions."account type"::Customer;

                ObjReceiptTransactions."Document No" := ObjRcptBuffer."Transaction No.";
                ObjReceiptTransactions."Member No" := ObjRcptBuffer."Account No.";
                ObjReceiptTransactions."Transaction Type" := ObjReceiptTransactions."transaction type"::"Deposit Contribution";
                ObjReceiptTransactions."Global Dimension 1 Code" := 'BOSA';
                ObjReceiptTransactions."Global Dimension 2 Code" := SURESTEPFactory.FnGetMemberBranch(ObjRcptBuffer."Account No.");
                ObjReceiptTransactions.Amount := AmountToDeduct;
                if ObjReceiptTransactions.Amount <> 0 then
                    ObjReceiptTransactions.Insert(true);
                RunningBalance := RunningBalance - Abs(ObjReceiptTransactions.Amount);
            end;

            exit(RunningBalance);
        end;
    end;

    local procedure FnRunUnallocatedAmount(ObjRcptBuffer: Record "Receipts & Payments"; RunningBalance: Decimal): Decimal
    var
        AmountToDeduct: Decimal;
        ObjReceiptTransactions: Record "Receipt Allocation";
        varTotalRepay: Decimal;
        varMultipleLoan: Decimal;
        varLRepayment: Decimal;
        PRpayment: Decimal;
        ObjMember: Record Customer;
    begin
        ObjMember.Reset;
        ObjMember.SetRange(ObjMember."No.", ObjRcptBuffer."Account No.");
        if ObjMember.Find('-') then begin
            begin
                AmountToDeduct := 0;
                AmountToDeduct := RunningBalance;
                ObjReceiptTransactions.Init;
                ObjReceiptTransactions."Document No" := ObjRcptBuffer."Transaction No.";
                ObjReceiptTransactions."Account Type" := ObjReceiptTransactions."account type"::Customer;

                ObjReceiptTransactions."Member No" := ObjRcptBuffer."Account No.";
                ObjReceiptTransactions."Transaction Type" := ObjReceiptTransactions."transaction type"::"Unallocated Funds";
                ObjReceiptTransactions."Global Dimension 1 Code" := 'BOSA';
                ObjReceiptTransactions."Global Dimension 2 Code" := SURESTEPFactory.FnGetMemberBranch(ObjRcptBuffer."Account No.");
                ObjReceiptTransactions.Amount := AmountToDeduct;
                if ObjReceiptTransactions.Amount <> 0 then
                    ObjReceiptTransactions.Insert(true);
            end;
        end;
    end;

    local procedure FnRunDepositContributionFromExcess(ObjRcptBuffer: Record "Receipts & Payments"; RunningBalance: Decimal): Decimal
    var
        AmountToDeduct: Decimal;
        ObjReceiptTransactions: Record "Receipt Allocation";
        varTotalRepay: Decimal;
        varMultipleLoan: Decimal;
        varLRepayment: Decimal;
        PRpayment: Decimal;
        ObjMember: Record Customer;
        SharesCap: Decimal;
        DIFF: Decimal;
        TransType: Enum TransactionTypesEnum;
    begin

        ObjMember.Reset;
        ObjMember.SetRange(ObjMember."No.", ObjRcptBuffer."Account No.");
        // ObjMember.SetRange(ObjMember."Account Type", ObjMember."Account Type"::Single);
        if ObjMember.Find('-') then begin
            AmountToDeduct := 0;
            AmountToDeduct := RunningBalance + FnReturnAmountToClear(Transtype::"Deposit Contribution");
            ObjReceiptTransactions.Init;
            ObjReceiptTransactions."Document No" := ObjRcptBuffer."Transaction No.";
            ObjReceiptTransactions."Account Type" := ObjReceiptTransactions."account type"::Customer;
            //
            ObjReceiptTransactions."Member No" := ObjRcptBuffer."Account No.";
            ObjReceiptTransactions."Transaction Type" := ObjReceiptTransactions."transaction type"::"Deposit Contribution";
            ObjReceiptTransactions."Global Dimension 1 Code" := 'BOSA';
            ObjReceiptTransactions."Global Dimension 2 Code" := SURESTEPFactory.FnGetMemberBranch(ObjRcptBuffer."Account No.");
            ObjReceiptTransactions.Amount := AmountToDeduct;
            if ObjReceiptTransactions.Amount <> 0 then
                ObjReceiptTransactions.Insert(true);
        end;
    end;

    local procedure FnReturnAmountToClear(TransType: Option " ","Registration Fee","Share Capital","Interest Paid",Repayment,"Deposit Contribution","Insurance Contribution","Benevolent Fund",Loan,"Unallocated Funds",Dividend,"FOSA Account") AmountReturned: Decimal
    var
        ObjReceiptAllocation: Record "Receipt Allocation";
    begin
        ObjReceiptAllocation.Reset;
        ObjReceiptAllocation.SetRange("Document No", Rec."Transaction No.");
        ObjReceiptAllocation.SetRange("Transaction Type", TransType);
        if ObjReceiptAllocation.Find('-') then begin
            AmountReturned := ObjReceiptAllocation.Amount;
            ObjReceiptAllocation.Delete;
        end;
        exit;
    end;

    local procedure FnRunSavingsProductExcess(ObjRcptBuffer: Record "Receipts & Payments"; RunningBalance: Decimal; SavingsProduct: Code[100]): Decimal
    var
        AmountToDeduct: Decimal;
        ObjReceiptTransactions: Record "Receipt Allocation";
        varTotalRepay: Decimal;
        varMultipleLoan: Decimal;
        varLRepayment: Decimal;
        PRpayment: Decimal;
        ObjMember: Record Customer;
        SharesCap: Decimal;
        DIFF: Decimal;
        TransType: Option " ","Registration Fee","Share Capital","Interest Paid",Repayment,"Deposit Contribution","Insurance Contribution","Benevolent Fund",Loan,"Unallocated Funds",Dividend,"FOSA Account";
    begin

        ObjMember.Reset;
        ObjMember.SetRange(ObjMember."No.", ObjRcptBuffer."Account No.");

        if ObjMember.Find('-') then begin
            AmountToDeduct := 0;
            AmountToDeduct := RunningBalance + FnReturnAmountToClear(Transtype::"FOSA Account");
            ObjReceiptTransactions.Init;
            ObjReceiptTransactions."Document No" := ObjRcptBuffer."Transaction No.";
            ObjReceiptTransactions."Member No" := ObjMember."No.";
            ObjReceiptTransactions."Account Type" := ObjReceiptTransactions."account type"::Customer;
            ObjReceiptTransactions."Account No" := ObjReceiptTransactions."Member No";
            if Rec."Excess Transaction Type" = Rec."excess transaction type"::"Junior Savings" then
                ObjReceiptTransactions."Transaction Type" := ObjReceiptTransactions."transaction type"::"Junior Savings";
            if Rec."Excess Transaction Type" = Rec."excess transaction type"::"Withdrawable Savings" then
                ObjReceiptTransactions."Transaction Type" := ObjReceiptTransactions."transaction type"::"Withdrawable Savings";
            // if "Excess Transaction Type" = "excess transaction type"::"Safari Saving" then
            //     ObjReceiptTransactions."Transaction Type" := ObjReceiptTransactions."transaction type"::"Safari Savings";
            ObjReceiptTransactions."Global Dimension 1 Code" := 'BOSA';
            ObjReceiptTransactions."Global Dimension 2 Code" := SURESTEPFactory.FnGetMemberBranch(ObjRcptBuffer."Account No.");
            ObjReceiptTransactions.Amount := AmountToDeduct;
            if ObjReceiptTransactions.Amount <> 0 then
                ObjReceiptTransactions.Insert(true);
        end;
    end;
}

