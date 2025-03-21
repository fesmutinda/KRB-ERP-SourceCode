//This codeunit helps in modifying records and isnerting records the way you want them to be before posting to the respective member /customer posting group accounts.

//NB:check line 78,this code is used to check the posting group the system will use in posting the loan
codeunit 50015 "PostCustomerExtension"
{
    var
        LoanApp: Record "Loans Register";
        LoanTypes: Record "Loan Products Setup";
        MemberReg: Record customer;
        productcharges: Record "Loan Product Charges";

    trigger OnRun()
    begin

    end;
    //1)-----------------------------------------------------------------------------------------------------
    [EventSubscriber(ObjectType::codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnAfterInsertDtldCustLedgEntry', '', false, false)]
    procedure InsertCustomfieldstodetailedcustledgerentry(GenJournalLine: Record "Gen. Journal Line"; var DtldCustLedgEntry: Record "Detailed Cust. Ledg. Entry")
    var
        sfactory: Codeunit "Swizzsoft Factory";
    begin
        //Fields to autopopopulate data b4 the posting process is started;
        DtldCustLedgEntry.LockTable();
        DtldCustLedgEntry."Transaction Type" := GenJournalLine."Transaction Type";
        DtldCustLedgEntry."Loan No" := GenJournalLine."Loan No";
        DtldCustLedgEntry."Loan Type" := GenJournalLine."Loan Product Type";
        DtldCustLedgEntry."Amount Posted" := GenJournalLine.Amount;
        DtldCustLedgEntry."Transaction Date" := Today;
        DtldCustLedgEntry."Created On" := CurrentDateTime;
        DtldCustLedgEntry."Time Created" := Time;
        DtldCustLedgEntry."Posting Date" := GenJournalLine."Posting Date";
        DtldCustLedgEntry."Prepayment Date" := GenJournalLine."Prepayment date";
        DtldCustLedgEntry."Group Code" := GenJournalLine."Group Code";
        //DtldCustLedgEntry."BLoan Officer No." := sfactory.FnGetLoanOfficerFromMemberNo(GenJournalLine."Account No.");
    end;

    //2)-----------------------------------------------------------------------------------------------------

    [EventSubscriber(ObjectType::Codeunit, 12, 'OnBeforePostGenJnlLine', '', false, false)]
    procedure ModifyReceivablesAccount(var GenJournalLine: Record "Gen. Journal Line")
    var
        Cust: Record Customer;
        TransactionTypestable: record "Transaction Types Table";
        LoanApp: Record "Loans Register";
        LoanTypes: record "Loan Products Setup";
        CustPostingGroup: record "Customer Posting Group";
    begin
        //1)Cater to make sure that the posting groups that we did setup are now catered for in g/ls
        //They exclude the repayment,interest paid, penalties of loans etc
        TransactionTypestable.reset;
        TransactionTypestable.SetRange(TransactionTypestable."Transaction Type", GenJournalLine."Transaction Type");
        if TransactionTypestable.Find('-') then begin
            GenJournalLine."Posting Group" := TransactionTypestable."Posting Group Code";
            GenJournalLine.Modify();
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, 12, 'OnBeforePostGenJnlLine', '', false, false)]
    local procedure PostGenJournalLine(var GenJournalLine: Record "Gen. Journal Line"; Balancing: Boolean)
    begin
        case GenJournalLine."Account Type" of
            GenJournalLine."Account Type"::Customer:
                begin
                    PostMemb(GenJournalLine, Balancing);
                end;

        end;
    end;

    local procedure PostMemb(var GenJournalLine: Record "Gen. Journal Line"; Balancing: Boolean)
    var
        CreatedPostingGroup: Code[50];
        SurestepFactory: Codeunit "Swizzsoft Factory";
        LoanProductSetUpList: record "Loan Products Setup";
        saccoGeneralSetUp: Record "Sacco General Set-Up";
    begin
        MemberReg.Reset();
        MemberReg.SetCurrentKey(MemberReg."No.");
        MemberReg.SetRange(MemberReg."No.", GenJournalLine."Account No.");
        if MemberReg.FindSet() then begin
            If (MemberReg."Customer Type" <> MemberReg."Customer Type"::Checkoff) and (GenJournalLine."Transaction Type" = GenJournalLine."Transaction Type"::" ") then begin
                Error('Please Input a transaction Type ');
            end;
        end;


        if (GenJournalLine."Transaction Type" = GenJournalLine."transaction type"::Loan) then begin
            if GenJournalLine."Loan No" = '' then begin
                Error('Loan No Field is empty! Loan No must be specified for %1', GenJournalLine."Account No.");
            end;
            LoanApp.Reset;
            LoanApp.SetCurrentkey(LoanApp."Loan  No.");
            LoanApp.SetRange(LoanApp."Loan  No.", GenJournalLine."Loan No");
            if LoanApp.Find('-') then begin
                if LoanTypes.Get(LoanApp."Loan Product Type") then begin
                    LoanTypes.TestField(LoanTypes."Loan Account");
                    GenJournalLine."Posting Group" := FnHandlePostingGroup(LoanTypes."Loan Account", FORMAT(COPYSTR(LoanApp."Loan Product Type", 1, 19)));
                    GenJournalLine.Found := true;
                    GenJournalLine.Modify();
                end;
            end;
        end;

        if (GenJournalLine."Transaction Type" = GenJournalLine."transaction type"::"Loan Transfer Charges") then begin
            if GenJournalLine."Loan No" = '' then begin
                Error('Loan No Field is empty! Loan No must be specified for %1', GenJournalLine."Account No.");
            end;
            // // saccoGeneralSetUp.Reset();
            // saccoGeneralSetUp.Get();
            // saccoGeneralSetUp.TestField(saccoGeneralSetUp."Loan Transfer Fees Account");
            // GenJournalLine."Posting Group" := FnHandlePostingGroup(saccoGeneralSetUp."Loan Transfer Fees Account", FORMAT(COPYSTR(LoanApp."Loan Product Type", 1, 5) + 'TransCharge'));

            // GenJournalLine.Found := true;
            // GenJournalLine.Modify();
            LoanApp.Reset;
            LoanApp.SetCurrentkey(LoanApp."Loan  No.");
            LoanApp.SetRange(LoanApp."Loan  No.", GenJournalLine."Loan No");
            if LoanApp.Find('-') then begin
                if LoanTypes.Get(LoanApp."Loan Product Type") then begin
                    LoanTypes.TestField(LoanTypes."Loan Account");
                    GenJournalLine."Posting Group" := FnHandlePostingGroup(LoanTypes."Loan Account", FORMAT(COPYSTR(LoanApp."Loan Product Type", 1, 19)));
                    GenJournalLine.Found := true;
                    GenJournalLine.Modify();
                end;
            end;
        end;

        if (GenJournalLine."Transaction Type" = GenJournalLine."transaction type"::"Loan Repayment") then begin
            if GenJournalLine."Loan No" = '' then begin
                Error('Loan No Field is empty! Loan No must be specified for %1', GenJournalLine."Account No.");
            end;
            LoanApp.Reset;
            LoanApp.SetCurrentkey(LoanApp."Loan  No.");
            LoanApp.SetRange(LoanApp."Loan  No.", GenJournalLine."Loan No");
            if LoanApp.Find('-') then begin
                repeat
                    if LoanTypes.Get(LoanApp."Loan Product Type") then begin
                        LoanTypes.TestField(LoanTypes."Loan Account");
                        //GenJournalLine."Posting Group" := LoanTypes."Loan Account";
                        // GenJournalLine."Posting Group" := LoanApp."Loan Product Type";

                        //FnCheckIfPostingGroupIsSetUp,If != Then SetUp
                        GenJournalLine."Posting Group" := FnHandlePostingGroup(LoanTypes."Loan Account", FORMAT(COPYSTR(LoanApp."Loan Product Type", 1, 19)));
                        ;
                        GenJournalLine.Modify();
                    end;
                until LoanApp.next = 0;
            end;
        end;

        if (GenJournalLine."Transaction Type" = GenJournalLine."transaction type"::"Interest Paid") then begin
            if GenJournalLine."Loan No" = '' then begin
                Error('Loan No Field is empty! Loan No must be specified for %1', GenJournalLine."Account No.");
            end;
            LoanApp.Reset;
            LoanApp.SetCurrentkey(LoanApp."Loan  No.");
            LoanApp.SetRange(LoanApp."Loan  No.", GenJournalLine."Loan No");
            if LoanApp.Find('-') then begin
                if LoanTypes.Get(LoanApp."Loan Product Type") then begin
                    LoanTypes.TestField(LoanTypes."Receivable Interest Account");
                    //FnCheckIfPostingGroupIsSetUp,If != Then SetUp
                    GenJournalLine."Posting Group" := FnHandlePostingGroup(LoanTypes."Receivable Interest Account", 'INTPAID-' + FORMAT(COPYSTR(LoanTypes.Code, 1, 10)));
                    ;
                    GenJournalLine.Found := true;
                    GenJournalLine.Modify();
                end;
            end;
        end;

        if (GenJournalLine."Transaction Type" = GenJournalLine."transaction type"::"Interest Due") then begin
            if GenJournalLine."Loan No" = '' then begin
                Error('Loan No Field is empty! Loan No must be specified for %1', GenJournalLine."Account No.");
            end;
            LoanApp.Reset;
            LoanApp.SetCurrentkey(LoanApp."Loan  No.");
            LoanApp.SetRange(LoanApp."Loan  No.", GenJournalLine."Loan No");
            if LoanApp.Find('-') then begin
                if LoanTypes.Get(LoanApp."Loan Product Type") then begin
                    LoanTypes.TestField(LoanTypes."Receivable Interest Account");
                    //FnCheckIfPostingGroupIsSetUp,If != Then SetUp
                    GenJournalLine."Posting Group" := FnHandlePostingGroup(LoanTypes."Receivable Interest Account", 'INTDUE-' + FORMAT(COPYSTR(LoanTypes.Code, 1, 10)));
                    GenJournalLine.Found := true;
                    GenJournalLine.Found := true;
                    GenJournalLine.Modify();
                end;
            end;
        end;
        // if (GenJournalLine."Transaction Type" = GenJournalLine."transaction type"::"Partial Disbursement") then begin
        //     if GenJournalLine."Loan No" = '' then begin
        //         Error('Loan No Field is empty! Loan No must be specified for %1', GenJournalLine."Account No.");
        //     end;
        //     LoanApp.Reset;
        //     LoanApp.SetCurrentkey(LoanApp."Loan  No.");
        //     LoanApp.SetRange(LoanApp."Loan  No.", GenJournalLine."Loan No");
        //     if LoanApp.Find('-') then begin
        //         if LoanTypes.Get(LoanApp."Loan Product Type") then begin
        //             // LoanTypes.TestField(LoanTypes."Receivable Interest Account");
        //             // GenJournalLine."Posting Group" := LoanTypes."Receivable Interest Account";
        //             // GenJournalLine.Modify();
        //             Found := true;
        //         end;
        //     end;
        // end;
        // if (GenJournalLine."Transaction Type" = GenJournalLine."transaction type"::"Loan Due") then begin
        //     if GenJournalLine."Loan No" = '' then begin
        //         Error('Loan No Field is empty! Loan No must be specified for %1', GenJournalLine."Account No.");
        //     end;
        //     LoanApp.Reset;
        //     LoanApp.SetCurrentkey(LoanApp."Loan  No.");
        //     LoanApp.SetRange(LoanApp."Loan  No.", GenJournalLine."Loan No");
        //     if LoanApp.Find('-') then begin
        //         if LoanTypes.Get(LoanApp."Loan Product Type") then begin
        //             // LoanTypes.TestField(LoanTypes."Receivable Interest Account");
        //             // GenJournalLine."Posting Group" := LoanTypes."Receivable Interest Account";
        //             // GenJournalLine.Modify();
        //             Found := true;
        //         end;
        //     end;
        // end;
        // if (GenJournalLine."Transaction Type" = GenJournalLine."transaction type"::"Penalty Charged") then begin
        //     if GenJournalLine."Loan No" = '' then begin
        //         Error('Loan No Field is empty! Loan No must be specified for %1', GenJournalLine."Account No.");
        //     end;
        //     LoanApp.Reset;
        //     LoanApp.SetCurrentkey(LoanApp."Loan  No.");
        //     LoanApp.SetRange(LoanApp."Loan  No.", GenJournalLine."Loan No");
        //     if LoanApp.Find('-') then begin
        //         if LoanTypes.Get(LoanApp."Loan Product Type") then begin
        //             LoanTypes.TestField(LoanTypes."Penalty Charged Account");
        //             //FnCheckIfPostingGroupIsSetUp,If != Then SetUp
        //             GenJournalLine."Posting Group" := FnHandlePostingGroup(LoanTypes."Penalty Charged Account", 'PENALTYCHRG-' + FORMAT(COPYSTR(LoanTypes.Code, 1, 7)));
        //             ;
        //             Found := true;
        //             Found := true;
        //             GenJournalLine.Modify();
        //         end;
        //     end;
        // end;
        // if (GenJournalLine."Transaction Type" = GenJournalLine."transaction type"::"Penalty Paid") then begin
        //     if GenJournalLine."Loan No" = '' then begin
        //         Error('Loan No Field is empty! Loan No must be specified for %1', GenJournalLine."Account No.");
        //     end;
        //     LoanApp.Reset;
        //     LoanApp.SetCurrentkey(LoanApp."Loan  No.");
        //     LoanApp.SetRange(LoanApp."Loan  No.", GenJournalLine."Loan No");
        //     if LoanApp.Find('-') then begin
        //         if LoanTypes.Get(LoanApp."Loan Product Type") then begin
        //             LoanTypes.TestField(LoanTypes."Penalty Paid Account");
        //             //FnCheckIfPostingGroupIsSetUp,If != Then SetUp
        //             GenJournalLine."Posting Group" := FnHandlePostingGroup(LoanTypes."Penalty Paid Account", 'PENALTYPAID-' + FORMAT(COPYSTR(LoanTypes.Code, 1, 6)));
        //             ;
        //             Found := true;
        //             GenJournalLine.Modify();
        //         end;
        //     end;
        // end;
        // if (GenJournalLine."Transaction Type" = GenJournalLine."transaction type"::"Application Fee") then begin
        //     if GenJournalLine."Loan No" = '' then begin
        //         Error('Loan No Field is empty! Loan No must be specified for %1', GenJournalLine."Account No.");
        //     end;
        //     LoanApp.Reset;
        //     LoanApp.SetCurrentkey(LoanApp."Loan  No.");
        //     LoanApp.SetRange(LoanApp."Loan  No.", GenJournalLine."Loan No");
        //     if LoanApp.Find('-') then begin
        //         if LoanTypes.Get(LoanApp."Loan Product Type") then begin
        //             productcharges.Reset();
        //             productcharges.SetRange(productcharges."Product Code", LoanTypes.Code);
        //             productcharges.SetRange(productcharges.Code, 'APP');
        //             if productcharges.Find('-') then begin
        //                 productcharges.TestField(productcharges."G/L Account");
        //                 //FnCheckIfPostingGroupIsSetUp,If != Then SetUp
        //                 GenJournalLine."Posting Group" := FnHandlePostingGroup(productcharges."G/L Account", 'APP-' + FORMAT(COPYSTR(LoanTypes.Code, 1, 10)));
        //                 ;
        //                 Found := true;
        //                 GenJournalLine.Modify();
        //             end else begin
        //                 Error('Product Charges Account Not Found. Please Contact System Administrator');
        //             end;
        //         end;
        //     end;
        // end;

        // if (GenJournalLine."Transaction Type" = GenJournalLine."transaction type"::"Appraisal Fee") then begin
        //     if GenJournalLine."Loan No" = '' then begin
        //         Error('Loan No Field is empty! Loan No must be specified for %1', GenJournalLine."Account No.");
        //     end;
        //     LoanApp.Reset;
        //     LoanApp.SetCurrentkey(LoanApp."Loan  No.");
        //     LoanApp.SetRange(LoanApp."Loan  No.", GenJournalLine."Loan No");
        //     if LoanApp.Find('-') then begin
        //         if LoanTypes.Get(LoanApp."Loan Product Type") then begin
        //             productcharges.Reset();
        //             productcharges.SetRange(productcharges."Product Code", LoanTypes.Code);
        //             productcharges.SetRange(productcharges.Code, 'APPR');
        //             if productcharges.Find('-') then begin
        //                 productcharges.TestField(productcharges."G/L Account");
        //                 GenJournalLine."Posting Group" := FnHandlePostingGroup(productcharges."G/L Account", 'APPR-' + FORMAT(COPYSTR(LoanTypes.Code, 1, 10)));
        //                 ;
        //                 Found := true;
        //                 GenJournalLine.Modify();
        //             end else begin
        //                 Error('Product Charges Account Not Found. Please Contact System Administrator');
        //             end;
        //         end;
        //     end;
        // end;
        //................................Ensure that global dimension 2(Branch) is not empty!...critical
        if GenJournalLine."Shortcut Dimension 2 Code" = '' then begin
            GenJournalLine."Shortcut Dimension 2 Code" := '';
            GenJournalLine."Shortcut Dimension 2 Code" := SurestepFactory.FnGetMemberBranch((GenJournalLine."Account No."));
            GenJournalLine.Modify();
        end;
        //................................Ensure that activity code used is accurate
        if GenJournalLine."Loan No" <> '' then begin
            GenJournalLine."Shortcut Dimension 1 Code" := '';
            GenJournalLine."Shortcut Dimension 1 Code" := FnGetActivity(GenJournalLine."Loan No");
            GenJournalLine.Modify();
        end else
            if (GenJournalLine."Loan No" = '') and (GenJournalLine."Transaction Type" <> GenJournalLine."Transaction Type"::" ") then begin
                GenJournalLine."Shortcut Dimension 1 Code" := '';
                GenJournalLine."Shortcut Dimension 1 Code" := 'BOSA';
                GenJournalLine.Modify();
            end;

    end;

    local procedure FnHandlePostingGroup(ReceivableInterestAccount: Code[20]; PostingCode: Text): Code[100]
    var
        CustomerPostingGroup: Record "Customer Posting Group";
        CustomerPostingGroupCreate: Record "Customer Posting Group";
    begin
        CustomerPostingGroup.Reset();
        CustomerPostingGroup.SetRange(CustomerPostingGroup.Code, PostingCode);
        if CustomerPostingGroup.find('-') = true then begin
            exit(CustomerPostingGroup.Code);
        end else
            if CustomerPostingGroup.find('-') = false then begin
                //......Create Customer Posting Group
                CustomerPostingGroupCreate.Init();
                CustomerPostingGroupCreate.Code := PostingCode;
                CustomerPostingGroupCreate."Account Type" := 'MEMBER';
                CustomerPostingGroupCreate.Description := PostingCode + ' Posting Group';
                CustomerPostingGroupCreate."Receivables Account" := ReceivableInterestAccount;
                CustomerPostingGroupCreate.Insert();
                exit(CustomerPostingGroupCreate.Code);
            end;
    end;

    local procedure FnGetLoanProductType(LoanNo: Code[20]): Code[20]
    var
        LoansRegisterRecord: Record "Loans Register";
    begin
        LoansRegisterRecord.Reset();
        LoansRegisterRecord.SetRange(LoansRegisterRecord."Loan  No.", LoanNo);
        if LoansRegisterRecord.Find('-') then begin
            exit(LoansRegisterRecord."Loan Product Type");
        end;
    end;

    local procedure CheckDimensions(var GenJournalLine: Record "Gen. Journal Line"; Balancing: Boolean)
    var
        SurestepFactory: Codeunit "Swizzsoft Factory";
    begin
        if GenJournalLine."Shortcut Dimension 2 Code" = '' then begin
            GenJournalLine."Shortcut Dimension 2 Code" := '';
            GenJournalLine."Shortcut Dimension 2 Code" := SurestepFactory.FnGetMemberBranchUsingFosaAccount(GenJournalLine."Account No.");
            GenJournalLine.Modify();
        end;
    end;

    local procedure FnGetActivity(LoanNo: Code[20]): Code[20]
    var
        LoansRegister: record "Loans Register";
    begin
        LoansRegister.Reset();
        LoansRegister.SetRange(LoansRegister."Loan  No.", LoanNo);
        if LoansRegister.Find('-') then begin
            exit(Format(LoansRegister.Source));
        end;
    end;

    // procedure GetMaxEntryNo(): Integer
    // var
    //     CustLedgerEntry: Record "Cust. Ledger Entry";
    //     MaxEntryNo: Integer;
    // begin
    //     if CustLedgerEntry.FindLast() then
    //         MaxEntryNo := CustLedgerEntry."Entry No.";

    //     // Message('Max Entry No.: %1', MaxEntryNo);
    //     exit(MaxEntryNo);
    // end;

    [EventSubscriber(ObjectType::Codeunit, codeunit::"Gen. Jnl.-Post Line", 'OnAfterInitCustLedgEntry', '', false, false)]
    procedure InsertCustomTransactionFields(GenJournalLine: Record "Gen. Journal Line"; var CustLedgerEntry: Record "Cust. Ledger Entry")
    var
        cust: Record Customer;
        sfactory: Codeunit "Swizzsoft Factory";
    begin
        CustLedgerEntry.LockTable();
        // CustLedgerEntry."Entry No." := GetMaxEntryNo() + 1;
        CustLedgerEntry."Transaction Type" := GenJournalLine."Transaction Type";
        CustLedgerEntry."Loan No" := GenJournalLine."Loan No";
        CustLedgerEntry."Loan product Type" := FnGetLoanProductType(GenJournalLine."Loan No");
        CustLedgerEntry."Amount Posted" := GenJournalLine.Amount;
        CustLedgerEntry."Document No." := GenJournalLine."Document No.";
        CustLedgerEntry."Transaction Date" := Today;
        CustLedgerEntry."Last Date Modified" := Today;
        CustLedgerEntry."Created On" := CurrentDateTime;
        CustLedgerEntry."Time Created" := Time;
        CustLedgerEntry."Posting Date" := GenJournalLine."Posting Date";
        CustLedgerEntry."Prepayment Date" := GenJournalLine."Prepayment date";
        CustLedgerEntry."Group Code" := GenJournalLine."Group Code";
        CustLedgerEntry."Document No." := GenJournalLine."Document No.";
        // CustLedgerEntry."BLoan Officer No." := sfactory.FnGetLoanOfficerFromMemberNo(GenJournalLine."Account No.");
    end;


}