#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51314 "Payroll JournalTransfer."
{
    ProcessingOnly = true;
    ApplicationArea = all;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Payroll Employee."; "Payroll Employee.")
        {
            RequestFilterFields = "Current Month Filter", "No.";
            column(ReportForNavId_6207; 6207)
            {
            }

            trigger OnAfterGetRecord()
            begin
                //For use when posting Pension and NSSF
                PostingGroup.Get('KRB');
                PostingGroup.TestField("SSF Employer Account");
                PostingGroup.TestField("SSF Employee Account");
                objEmp.SetRange(objEmp."No.", "No.");
                if objEmp.Find('-') then begin
                    strEmpName := '[' + "No." + '] ' + objEmp."Full Name";
                end;
                LineNumber := LineNumber + 1000;
                PeriodTrans.Reset;
                PeriodTrans.SetRange(PeriodTrans."Employee Code", "No.");
                PeriodTrans.SetRange(PeriodTrans."Payroll Period", SelectedPeriod);
                if PeriodTrans.Find('-') then begin
                    repeat
                        PeriodText := PeriodName;//Format(PeriodTrans."Payroll Period") + ' to ' + Format(CALCDATE('CM', PeriodTrans."Payroll Period"));
                        if PeriodTrans."Journal Account Code" <> '' then begin
                            AmountToDebit := 0;
                            AmountToCredit := 0;
                            if PeriodTrans."Post As" = PeriodTrans."post as"::Debit then
                                AmountToDebit := PeriodTrans.Amount;

                            if PeriodTrans."Post As" = PeriodTrans."post as"::Credit then
                                AmountToCredit := PeriodTrans.Amount;
                            if PeriodTrans."Journal Account Type" = 1 then
                                IntegerPostAs := 0;
                            if PeriodTrans."Journal Account Type" = 2 then
                                IntegerPostAs := 1;
                            if PeriodTrans."Transaction Code" = 'BPAY' then
                                IntegerPostAs := 2;

                            SaccoTransactionType := Saccotransactiontype::" ";

                            if PeriodTrans."coop parameters" = PeriodTrans."coop parameters"::loan then
                                SaccoTransactionType := Tntype::"Loan Repayment";
                            if PeriodTrans."coop parameters" = PeriodTrans."coop parameters"::"loan Interest" then
                                SaccoTransactionType := Tntype::"Interest Paid";
                            if PeriodTrans."coop parameters" = PeriodTrans."coop parameters"::shares then
                                SaccoTransactionType := Tntype::"Deposit Contribution";
                            if PeriodTrans."coop parameters" = PeriodTrans."coop parameters"::Welfare then
                                SaccoTransactionType := Tntype::"Benevolent Fund";
                            // if PeriodTrans."coop parameters" = PeriodTrans."coop parameters"::Likizo then
                            //     SaccoTransactionType := Tntype::Holiday_Savers;
                            if PeriodTrans."coop parameters" = PeriodTrans."coop parameters"::"Share Capital" then
                                SaccoTransactionType := Tntype::"Share Capital";

                            if PeriodTrans."Journal Account Type" = PeriodTrans."journal account type"::Customer then begin
                                PeriodTrans."Journal Account Type" := PeriodTrans."journal account type"::Customer;
                            end else
                                if PeriodTrans."Journal Account Type" = PeriodTrans."journal account type"::"G/L Account" then begin
                                    PeriodTrans."Journal Account Type" := PeriodTrans."journal account type"::"G/L Account";

                                end;
                            if PeriodTrans."Transaction Code" = 'BENEV' then begin //LOAN APP FEE //LOAN INSURANCE
                                PeriodTrans."Journal Account Type" := PeriodTrans."journal account type"::Customer;
                                SaccoTransactionType := Tntype::"Benevolent Fund";
                            end;
                            if (PeriodTrans."Transaction Code" <> 'BPAY')
                        then begin
                                CreateJnlEntry(IntegerPostAs, PeriodTrans."Journal Account Code",
                                GlobalDim1, '', CopyStr(PeriodText + ' ' + PeriodTrans."Transaction Name" + '-' + PeriodTrans."Employee Code", 1, 30), AmountToDebit, AmountToCredit,
                                PeriodTrans."Post As", PeriodTrans."Loan Number", SaccoTransactionType, GlobalDim3, "No.");
                            end
                        end;


                    until PeriodTrans.Next = 0;
                end;

            end;

            trigger OnPostDataItem()
            begin

                Message('Journals Created Successfully');
                GeneraljnlLine.Reset;
                GeneraljnlLine.SetRange("Journal Template Name", 'GENERAL');
                GeneraljnlLine.SetRange("Journal Batch Name", 'SALARY');
                if GeneraljnlLine.Find('-') then
                    Page.Run(page::"General Journal", GeneraljnlLine);
            end;

            trigger OnPreDataItem()
            begin

                //Create batch*****************************************************************************
                GenJnlBatch.Reset;
                GenJnlBatch.SetRange(GenJnlBatch."Journal Template Name", 'GENERAL');
                GenJnlBatch.SetRange(GenJnlBatch.Name, 'SALARY');
                if GenJnlBatch.Find('-') = false then begin
                    GenJnlBatch.Init;
                    GenJnlBatch."Journal Template Name" := 'GENERAL';
                    GenJnlBatch.Name := 'SALARY';
                    GenJnlBatch.Insert;
                end;
                // End Create Batch

                // Clear the journal Lines
                GeneraljnlLine.SetRange(GeneraljnlLine."Journal Batch Name", 'SALARY');
                if GeneraljnlLine.Find('-') then
                    GeneraljnlLine.DeleteAll;
                "Slip/Receipt No" := kk."Period Name";
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(SelectedPeriod; SelectedPeriod)
                {
                    ApplicationArea = Basic;
                    Caption = 'Period';
                    TableRelation = "Payroll Calender."."Date Opened";
                }
                field("Document No"; DocumentNo)
                {
                    ApplicationArea = Basic;
                }
                field("Posting Date"; varPostingDate)
                {
                    ApplicationArea = Basic;
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport()
    begin

        PeriodFilter := "Payroll Employee.".GetFilter("Current Month Filter");
        if PeriodFilter = '' then Error('You must specify the period filter');

        SelectedPeriod := "Payroll Employee.".GetRangeMin("Current Month Filter");
        objPeriod.Reset;
        if objPeriod.Get(SelectedPeriod) then PeriodName := objPeriod."Period Name";

        PostingDate := CalcDate('1M-1D', SelectedPeriod);

        if UserSetup.Get(UserId) then begin
            if UserSetup."Payroll User" = false then Error('You dont have permissions for payroll, Contact your system administrator! ')
        end;
    end;

    var
        PeriodText: Text[100];
        TNtype: enum TransactionTypesEnum;//" ","Deposit Contribution","Interest Paid","Benevolent Fund","Loan Repayment","Loan Application Fee Paid","Loan Insurance Paid";
        PeriodTrans: Record "prPeriod Transactions.";
        objEmp: Record "Payroll Employee.";
        PeriodName: Text[30];
        PeriodFilter: Text[30];
        SelectedPeriod: Date;
        objPeriod: Record "Payroll Calender.";
        ControlInfo: Record "Control-Information.";
        strEmpName: Text[150];
        GeneraljnlLine: Record "Gen. Journal Line";
        GenJnlBatch: Record "Gen. Journal Batch";
        "Slip/Receipt No": Code[50];
        LineNumber: Integer;
        "Salary Card": Record "Payroll Employee.";
        TaxableAmount: Decimal;
        PostingGroup: Record "Payroll Posting Groups.";
        GlobalDim1: Code[10];
        GlobalDim2: Code[10];
        TransCode: Record "Payroll Transaction Code.";
        PostingDate: Date;
        AmountToDebit: Decimal;
        AmountToCredit: Decimal;
        IntegerPostAs: Integer;
        SaccoTransactionType: Enum TransactionTypesEnum; //Option " ","Deposit Contribution","Interest Paid","Benevolent Fund","Loan Repayment","Loan Application Fee Paid","Loan Insurance Paid";
        EmployerDed: Record "Payroll Employer Deductions.";
        GlobalDim3: Code[10];
        kk: Record "Payroll Calender.";
        UserSetup: Record "User Setup";
        DocumentNo: Code[10];
        varPostingDate: Date;
        "Account type": Option " ","G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner",Staff,"None",Member;


    procedure CreateJnlEntry(AccountType: Option " ","G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner",Staff,"None",Member; AccountNo: Code[20]; GlobalDime1: Code[20]; GlobalDime2: Code[20]; Description: Text[50]; DebitAmount: Decimal; CreditAmount: Decimal; PostAs: Option " ",Debit,Credit; LoanNo: Code[20]; TransType: Option " ","Deposit Contribution","Interest Paid","Benevolent Fund","Loan Repayment","Loan Application Fee Paid","Loan Insurance Paid"; BalAccountNo: Code[20]; MemberNo: Code[50])
    begin

        if AccountType = Accounttype::Customer then begin
            AccountType := Accounttype::Customer;
            AccountNo := MemberNo;

            GlobalDime1 := 'BOSA';
        end;
        LineNumber := LineNumber + 1000;
        GeneraljnlLine.Init;
        GeneraljnlLine."Journal Template Name" := 'GENERAL';
        GeneraljnlLine."Journal Batch Name" := 'SALARY';
        GeneraljnlLine."Line No." := LineNumber;
        GeneraljnlLine."Document No." := DocumentNo;
        GeneraljnlLine."Transaction Type" := TransType;
        GeneraljnlLine."Posting Date" := varPostingDate;
        GeneraljnlLine."Loan No" := LoanNo;
        if TransType <> Transtype::" " then begin
            GeneraljnlLine."Account Type" := GeneraljnlLine."account type"::Customer;
            GeneraljnlLine."Account No." := AccountNo;
        end;
        if GeneraljnlLine."Account Type" = GeneraljnlLine."account type"::"G/L Account" then
            GeneraljnlLine."Account No." := AccountNo;
        GeneraljnlLine.Description := Description;
        if PostAs = Postas::Debit then begin
            GeneraljnlLine."Debit Amount" := ROUND(DebitAmount, 0.01, '=');
            GeneraljnlLine.Validate("Debit Amount");
        end else begin
            GeneraljnlLine."Credit Amount" := ROUND(CreditAmount, 0.01, '=');
            GeneraljnlLine.Validate("Credit Amount");
        end;
        if GeneraljnlLine.Amount <> 0 then
            GeneraljnlLine.Insert;
    end;
}

