#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
page 50482 "Checkoff Processing Header-D"
{
    DeleteAllowed = false;
    PageType = Card;
    SourceTable = "Checkoff Header-Distributed";
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
                field("Posted By"; Rec."Posted By")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Account Type"; Rec."Account Type")
                {
                    ApplicationArea = Basic;
                }
                field("Account No"; Rec."Account No")
                {
                    ApplicationArea = Basic;
                }
                field("Employer Name"; Rec."Employer Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Employer Code"; Rec."Employer Code")
                {
                    ApplicationArea = Basic;

                    trigger OnValidate()
                    begin
                        if Rec."Employer Code" <> '' then begin
                            BufferTable.Reset;
                            BufferTable.SetRange(BufferTable.UserId, UserId);
                            if BufferTable.Find('-') then begin
                                BufferTable.DeleteAll;
                            end;
                            BufferTable.Init;
                            BufferTable.UserId := UserId;
                            BufferTable.EmployerCode := Rec."Employer Code";
                            BufferTable.Insert;
                        end;
                    end;
                }
                field("Document No"; Rec."Document No")
                {
                    ApplicationArea = Basic;
                    Caption = 'Document No./ Cheque No.';
                    ShowMandatory = true;
                }
                field("CheckOff Period"; Rec."CheckOff Period")
                {
                    ApplicationArea = Basic;
                    ShowMandatory = true;
                }
                field(Posted; Rec.Posted)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Visible = false;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Total Scheduled"; Rec."Total Scheduled")
                {
                    ApplicationArea = Basic;
                    Enabled = false;
                    Importance = Promoted;
                    Style = Strong;
                    StyleExpr = true;
                }
                field("Total Count"; Rec."Total Count")
                {
                    ApplicationArea = Basic;
                    Enabled = false;
                    Importance = Promoted;
                    Style = Favorable;
                    StyleExpr = true;
                }
            }
            part("Checkoff Lines-Distributed"; "Checkoff Processing Lines-D")
            {
                Caption = 'Checkoff Lines-Distributed';
                SubPageLink = "Receipt Header No" = field(No);
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Clear Lines")
            {
                ApplicationArea = Basic;
                Enabled = ActionEnabled;
                Image = CheckList;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;

                trigger OnAction()
                begin
                    if Confirm('This Action will clear all the Lines for the current Check off. Do you want to Continue') = false then
                        exit;
                    ReceiptLine.Reset;
                    ReceiptLine.SetRange(ReceiptLine."Receipt Header No", Rec.No);
                    ReceiptLine.DeleteAll;

                    BATCH_TEMPLATE := 'GENERAL';
                    BATCH_NAME := 'CHECKOFF';
                    DOCUMENT_NO := Rec.Remarks;
                    GenJournalLine.Reset;
                    GenJournalLine.SetRange("Journal Template Name", BATCH_TEMPLATE);
                    GenJournalLine.SetRange("Journal Batch Name", BATCH_NAME);
                    GenJournalLine.DeleteAll;
                end;
            }
            action("Import Checkoff Distributed")
            {
                ApplicationArea = Basic;
                Caption = 'Import Checkoff';
                Enabled = ActionEnabled;
                Image = Import;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                // RunObject = XMLport 51516003;

                trigger OnAction()
                begin
                    ReceiptLine.Reset;
                    ReceiptLine.SetRange(ReceiptLine."Receipt Header No", Rec.No);
                    if Rec.FindSet then
                        ReceiptLine.DeleteAll;
                end;
            }
            group(ActionGroup1102755021)
            {
            }
            action("Validate Checkoff")
            {
                ApplicationArea = Basic;
                Caption = 'Validate Checkoff';
                Enabled = ActionEnabled;
                Image = ViewCheck;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;

                trigger OnAction()
                var
                    DevlLoan: Decimal;
                    DevLoanInt: Decimal;
                    PremiumLoan: Decimal;
                    PremiumLoanInt: Decimal;
                    QuickLoan: Decimal;
                    EmergencyLoan: Decimal;
                    SchoolFees: Decimal;
                    SuperQuickLoan: Decimal;
                    SuperSchool: Decimal;
                    SalaryAdvance: Decimal;
                    InvestLoan: Decimal;
                    HomeAppliance: Decimal;
                    Refinanced: Decimal;
                    BankBailOut: Decimal;
                    QuickLoanInt: Decimal;
                    EmergencyLoanInt: Decimal;
                    SchoolFeesInt: Decimal;
                    GuarantorLoanInt: Decimal;
                    SuperSchoolInt: Decimal;
                    SalaryAdvanceInt: Decimal;
                    InvestLoanInt: Decimal;
                    HomeApplianceInt: Decimal;
                    RefinancedInt: Decimal;
                    BankBailOutInt: Decimal;
                    DepositContribution: Decimal;
                    ShareCapital: Decimal;
                    Stock: Decimal;
                    DemandSav: Decimal;
                    Insurance: Decimal;
                    CompanyInfo: Record "Company Information";
                    PeriodName: Text;
                    ObjCheckoffLines: Record 51415;
                    DeamndSavings: Decimal;
                    TotalAmount: Decimal;
                    TotalLines: Decimal;
                    SuperEmergencyLoan: Decimal;
                    SuperEmergencyLoanInt: Decimal;
                    SuperQuickLoanInt: Decimal;
                begin
                    // TESTFIELD("Document No");
                    // TESTFIELD(Amount);
                    //MESSAGE('test');
                    Rec.TestField("CheckOff Period");


                    BATCH_TEMPLATE := 'GENERAL';
                    BATCH_NAME := 'CHECKOFF';
                    DOCUMENT_NO := Rec.Remarks;

                    GenJournalLine.Reset;
                    GenJournalLine.SetRange("Journal Template Name", BATCH_TEMPLATE);
                    GenJournalLine.SetRange("Journal Batch Name", BATCH_NAME);
                    GenJournalLine.DeleteAll;

                    MembLedg.Reset;
                    MembLedg.SetRange(MembLedg."Document No.", Rec."Document No");
                    if MembLedg.Find('-') = true then
                        Error('Sorry,You have already posted this Document. Validation not Allowed.');


                    ReceiptLine.Reset;
                    ReceiptLine.SetRange(ReceiptLine."Receipt Header No", Rec.No);
                    if ReceiptLine.Find('-') then begin//1
                                                       // MESSAGE('Header No %1',No);
                        Window.Open('@1@');
                        TotalCount := ReceiptLine.Count;

                        repeat
                            Vend.Reset;
                            Vend.SetRange("Payroll/Staff No", ReceiptLine."Staff/Payroll No");
                            if Vend.Find('-') then begin
                                //MESSAGE('"Staff/Payroll No" %1',ReceiptLine."Staff/Payroll No");

                                LoanApp.Reset;
                                LoanApp.SetRange("Client Code", Vend."No.");
                                if LoanApp.FindSet then begin

                                    ReceiptLine."Member No." := Vend."No.";
                                    ReceiptLine."Member Name" := Vend.Name;

                                    ReceiptLine."Loan No." := LoanApp."Loan  No.";//MESSAGE('%1',ReceiptLine."Loan No.");
                                    MemberTotal := ObjCheckoffLines."EMERGENCY LOAN" + ObjCheckoffLines."Int EMERGENCY LOAN" + ObjCheckoffLines."SUPER EMERGENCY LOAN" + ObjCheckoffLines."Int SUPER EMERGENCY LOAN"
                                   + ObjCheckoffLines."QUICK LOAN" + ObjCheckoffLines."Int QUICK LOAN" + ObjCheckoffLines."SUPER QUICK" + ObjCheckoffLines."Int SUPER QUICK"
                                   + ObjCheckoffLines."SCHOOL FEES" + ObjCheckoffLines."Int SCHOOL FEES" + ObjCheckoffLines."SUPER SCHOOL FEES" + ObjCheckoffLines."Int SUPER SCHOOL FEES"
                                   + ObjCheckoffLines."INVESTMENT LOAN" + ObjCheckoffLines."Int INVESTMENT LOAN" + ObjCheckoffLines."DEVELOPMENT LOAN" + ObjCheckoffLines."Int DEVELOPMENT LOAN" + ObjCheckoffLines."Insurance Contribution"
                                   + ObjCheckoffLines."Deposit contribution" + ObjCheckoffLines."Shares Capital";
                                    //MESSAGE('"Deposit contribution"',ObjCheckoffLines."Deposit contribution");

                                end;

                            end;
                            ReceiptLine.Modify(true);
                        until ReceiptLine.Next = 0;
                        Window.Close;
                        Message('Validation was successfully completed.');
                    end;//1
                    MemberTotal := 0;
                    //Validate Amounts
                    ObjCheckoffLines.Reset;
                    ObjCheckoffLines.SetRange(ObjCheckoffLines."Receipt Header No", Rec.No);
                    if ObjCheckoffLines.Find('-') then begin
                        repeat
                            MemberTotal := ObjCheckoffLines."EMERGENCY LOAN" + ObjCheckoffLines."Int EMERGENCY LOAN" + ObjCheckoffLines."SUPER EMERGENCY LOAN" + ObjCheckoffLines."Int SUPER EMERGENCY LOAN"
                            + ObjCheckoffLines."QUICK LOAN" + ObjCheckoffLines."Int QUICK LOAN" + ObjCheckoffLines."SUPER QUICK" + ObjCheckoffLines."Int SUPER QUICK"
                            + ObjCheckoffLines."SCHOOL FEES" + ObjCheckoffLines."Int SCHOOL FEES" + ObjCheckoffLines."SUPER SCHOOL FEES" + ObjCheckoffLines."Int SUPER SCHOOL FEES"
                            + ObjCheckoffLines."INVESTMENT LOAN" + ObjCheckoffLines."Int INVESTMENT LOAN" + ObjCheckoffLines."DEVELOPMENT LOAN" + ObjCheckoffLines."Int DEVELOPMENT LOAN" + ObjCheckoffLines."Insurance Contribution"
                            + ObjCheckoffLines."Deposit contribution" + ObjCheckoffLines."Shares Capital";
                            Rec.Amount := MemberTotal;
                            //VALIDATE(Amount);
                            ObjCheckoffLines.Amount := MemberTotal;
                            ObjCheckoffLines.Modify;
                        //IF MemberTotal<>ObjCheckoffLines.Amount THEN
                        // ERROR('Amount for Staff/Payroll No '+ObjCheckoffLines."Staff/Payroll No"+' and the total breakdown must be the the same');
                        until ObjCheckoffLines.Next = 0;
                    end;
                    ObjCheckoffLines.Reset;
                    ObjCheckoffLines.SetRange(ObjCheckoffLines."Receipt Header No", Rec.No);
                    if ObjCheckoffLines.FindSet then begin
                        ObjCheckoffLines.CalcSums(ObjCheckoffLines."Deposit contribution", ObjCheckoffLines."Shares Capital",
                        ObjCheckoffLines."EMERGENCY LOAN", ObjCheckoffLines."Int EMERGENCY LOAN", ObjCheckoffLines."SUPER EMERGENCY LOAN", ObjCheckoffLines."Int SUPER EMERGENCY LOAN"
                        , ObjCheckoffLines."QUICK LOAN", ObjCheckoffLines."Int QUICK LOAN", ObjCheckoffLines."SUPER QUICK", ObjCheckoffLines."Int SUPER QUICK"
                        , ObjCheckoffLines."SCHOOL FEES", ObjCheckoffLines."Int SCHOOL FEES", ObjCheckoffLines."SUPER SCHOOL FEES", ObjCheckoffLines."Int SUPER SCHOOL FEES"
                        , ObjCheckoffLines."INVESTMENT LOAN", ObjCheckoffLines."Int INVESTMENT LOAN", ObjCheckoffLines."DEVELOPMENT LOAN", ObjCheckoffLines."Int DEVELOPMENT LOAN", ObjCheckoffLines."Insurance Contribution", ObjCheckoffLines."Deposit contribution");


                        DepositContribution := ObjCheckoffLines."Deposit contribution";
                        //Stock:=ObjCheckoffLines.Stocks;
                        //By
                        //DeamndSavings:=ObjCheckoffLines.Demand;
                        ShareCapital := ObjCheckoffLines."Shares Capital";
                        Insurance := ObjCheckoffLines."Insurance Contribution";


                        EmergencyLoan := ObjCheckoffLines."EMERGENCY LOAN";
                        EmergencyLoanInt := ObjCheckoffLines."Int EMERGENCY LOAN";
                        SuperEmergencyLoan := ObjCheckoffLines."SUPER EMERGENCY LOAN";
                        SuperEmergencyLoanInt := ObjCheckoffLines."Int SUPER EMERGENCY LOAN";
                        QuickLoan := ObjCheckoffLines."QUICK LOAN";
                        QuickLoanInt := ObjCheckoffLines."Int QUICK LOAN";
                        SuperQuickLoan := ObjCheckoffLines."SUPER QUICK";
                        SuperQuickLoanInt := ObjCheckoffLines."Int SUPER QUICK";
                        SchoolFees := ObjCheckoffLines."SCHOOL FEES";
                        SchoolFeesInt := ObjCheckoffLines."Int SCHOOL FEES";
                        SuperSchool := ObjCheckoffLines."SUPER SCHOOL FEES";
                        SuperSchoolInt := ObjCheckoffLines."Int SUPER SCHOOL FEES";
                        InvestLoan := ObjCheckoffLines."INVESTMENT LOAN";
                        InvestLoanInt := ObjCheckoffLines."Int INVESTMENT LOAN";
                        DevlLoan := ObjCheckoffLines."DEVELOPMENT LOAN";
                        DevLoanInt := ObjCheckoffLines."Int DEVELOPMENT LOAN";


                        ObjCheckoffLines.CalcSums(ObjCheckoffLines.Amount);
                        TotalAmount := ObjCheckoffLines.Amount;
                        TotalLines := +EmergencyLoan + EmergencyLoanInt + SuperEmergencyLoan + SuperEmergencyLoanInt + QuickLoan + QuickLoanInt + SuperQuickLoan + SuperQuickLoanInt
                        + SchoolFees + SchoolFeesInt + SuperSchool + SuperSchoolInt + InvestLoan + InvestLoanInt + DevlLoan + DevLoanInt + ObjCheckoffLines."Deposit contribution"
                        + ObjCheckoffLines."Shares Capital";
                    end;
                end;
            }
            action("Unallocated Funds")
            {
                ApplicationArea = Basic;
                Promoted = true;
                PromotedCategory = "Report";
                Visible = false;

                trigger OnAction()
                begin
                    ReptProcHeader.Reset;
                    ReptProcHeader.SetRange(ReptProcHeader.No, Rec.No);
                    if ReptProcHeader.Find('-') then
                        Report.Run(51516542, true, false, ReptProcHeader);
                end;
            }
            group(ActionGroup1102755019)
            {
            }
            action("Process Checkoff Distributed")
            {
                ApplicationArea = Basic;
                Caption = 'Process Checkoff';
                Enabled = ActionEnabled;
                Image = Apply;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                Visible = false;

                trigger OnAction()
                var
                    LoanT: Record 51371;
                    LoanProdType: Code[30];
                begin
                    if Rec."Loan CutOff Date" = 0D then
                        Error('Posting Date cannot be blank');

                    Rec.CalcFields("Total Scheduled");
                    if Rec."Total Scheduled" <> Rec.Amount then
                        if Confirm('Total schedule is not equal to cheque amount, do you wish to continue?') = false then
                            exit;
                    if Confirm('Are you sure you want to Transfer this Checkoff to Journals ?') = true then begin
                        Rec.TestField("Document No");

                        //Temp.GET(USERID);
                        Jtemplate := 'GENERAL';
                        JBatch := 'CHECKOFF';
                        //"Loan CutOff Date":=ReptProcHeader."Loan CutOff Date";

                        if Jtemplate = '' then begin
                            Error('Ensure the Imprest Template is set up in Cash Office Setup');
                        end;

                        if JBatch = '' then begin
                            Error('Ensure the Imprest Batch is set up in the Cash Office Setup')
                        end;


                        Datefilter := '..' + Format(Rec."Loan CutOff Date");

                        MembLedg.Reset;
                        MembLedg.SetRange(MembLedg."Document No.", Rec.Remarks);
                        MembLedg.SetRange(MembLedg.Reversed, false);
                        if MembLedg.Find('-') = true then
                            //ERROR('Sorry,You have already posted this Document. Validation not Allowed.');

                            //BATCH_TEMPLATE:='GENERAL';
                            //BATCH_NAME:='CHECKOFF';
                            DOCUMENT_NO := Rec.Remarks;
                        Counter := 0;
                        Percentage := 0;
                        TotalCount := 0;
                        //"Loan CutOff Date":=ReptProcHeader."Loan CutOff Date";
                        GenJournalLine.Reset;
                        GenJournalLine.SetRange("Journal Template Name", Jtemplate);
                        GenJournalLine.SetRange("Journal Batch Name", JBatch);
                        GenJournalLine.DeleteAll;

                        //LineNo:=0;

                        ReceiptLine.Reset;
                        ReceiptLine.SetRange("Receipt Header No", Rec.No);
                        if ReceiptLine.FindSet then begin//1
                                                         //MESSAGE('No %1',No);
                            Window.Open('@1@');
                            TotalCount := ReceiptLine.Count;
                            //Copy data

                            CheckoffLinesBuffer.Reset;
                            CheckoffLinesBuffer.SetRange("Member No.", ReceiptLine."Member No.");
                            CheckoffLinesBuffer.SetRange("Receipt Header No", ReceiptLine."Receipt Header No");
                            if CheckoffLinesBuffer.Find('-') then begin
                                CheckoffLinesBuffer.Delete;
                            end;

                            CheckoffLinesBuffer.TransferFields(ReceiptLine);
                            CheckoffLinesBuffer.Insert(true);
                            repeat
                                FnUpdateProgressBar();
                                UnallocatedFunds := 0;
                                //Deposits
                                LineNo := LineNo + 10000;
                                SwizzsoftFactory.FnCreateGnlJournalLine(Jtemplate, JBatch, Rec.No, LineNo, GenJournalLine."transaction type"::"Benevolent Fund", GenJournalLine."account type"::Customer,
                                                                     ReceiptLine."Member No.", Rec."Loan CutOff Date", -ReceiptLine."Deposit contribution", 'BOSA', '', 'Deposit contribution Checkoff for ' +
                                                                     KnGetPeriodDescription(Rec."CheckOff Period") + ' ' + CheckoffLinesBuffer."Member No." + ' ' + Rec."Employer Code", '');
                                //share capital
                                LineNo := LineNo + 10000;
                                SwizzsoftFactory.FnCreateGnlJournalLine(Jtemplate, JBatch, Rec.No, LineNo, GenJournalLine."transaction type"::"Share Capital", GenJournalLine."account type"::Customer,
                                                                     ReceiptLine."Member No.", Rec."Loan CutOff Date", -ReceiptLine."Shares Capital", 'BOSA', '', 'Shares capital checkofffor '
                                                                     + KnGetPeriodDescription(Rec."CheckOff Period") + ' ' + CheckoffLinesBuffer."Member No." + ' ' + Rec."Employer Code", '');

                                //Reg/fess
                                LineNo := LineNo + 10000;
                                SwizzsoftFactory.FnCreateGnlJournalLine(Jtemplate, JBatch, Rec.No, LineNo, GenJournalLine."transaction type"::"Registration Fee", GenJournalLine."account type"::Customer,
                                                                     ReceiptLine."Member No.", Rec."Loan CutOff Date", -ReceiptLine."Entrance Fees", 'BOSA', '', 'Registration fees checkoff for' +
                                                                     KnGetPeriodDescription(Rec."CheckOff Period") + ' ' + CheckoffLinesBuffer."Member No." + ' ' + Rec."Employer Code", '');
                                LNNO := '';
                                LoanProductsSetup.Reset;
                                LoanProductsSetup.SetFilter(LoanProductsSetup.Code, '<>%1', '');
                                if LoanProductsSetup.Find('-') then begin
                                    repeat
                                        LoansRegister6.Reset;
                                        LoansRegister6.SetRange("Client Code", ReceiptLine."Member No.");
                                        LoansRegister6.SetRange("Loan Product Type", LoanProductsSetup.Code);
                                        if LoansRegister6.FindFirst then
                                            LNNO := LoansRegister6."Loan  No.";

                                        UnallocatedPerLoanProd := 0;
                                        UpdateInterest := 0;
                                        UpdatePrinciple := 0;

                                        case LoanProductsSetup.Code of
                                            '12':
                                                begin
                                                    UnallocatedPerLoanProd := ReceiptLine."EMERGENCY LOAN";
                                                    LoanProdType := LoanProductsSetup.Code;
                                                    UpdatePrinciple := ReceiptLine."EMERGENCY LOAN";
                                                    UpdateInterest := ReceiptLine."Int EMERGENCY LOAN";


                                                end;
                                            '13':
                                                begin
                                                    UnallocatedPerLoanProd := ReceiptLine."SUPER EMERGENCY LOAN";
                                                    LoanProdType := LoanProductsSetup.Code;
                                                    UpdatePrinciple := ReceiptLine."SUPER EMERGENCY LOAN";
                                                    UpdateInterest := ReceiptLine."Int SUPER EMERGENCY LOAN";
                                                end;
                                            '15':
                                                begin
                                                    UnallocatedPerLoanProd := ReceiptLine."QUICK LOAN";
                                                    LoanProdType := LoanProductsSetup.Code;
                                                    UpdatePrinciple := ReceiptLine."QUICK LOAN";
                                                    UpdateInterest := ReceiptLine."Int QUICK LOAN";
                                                end;

                                            '16':
                                                begin
                                                    UnallocatedPerLoanProd := ReceiptLine."SUPER QUICK";
                                                    LoanProdType := LoanProductsSetup.Code;
                                                    UpdatePrinciple := ReceiptLine."SUPER QUICK";
                                                    UpdateInterest := ReceiptLine."Int SUPER QUICK";
                                                end;
                                            '17':
                                                begin
                                                    UnallocatedPerLoanProd := ReceiptLine."SCHOOL FEES";
                                                    LoanProdType := LoanProductsSetup.Code;
                                                    UpdatePrinciple := ReceiptLine."SCHOOL FEES";
                                                    UpdateInterest := ReceiptLine."Int SCHOOL FEES";
                                                end;
                                            '18':
                                                begin
                                                    UnallocatedPerLoanProd := ReceiptLine."SUPER SCHOOL FEES";
                                                    LoanProdType := LoanProductsSetup.Code;
                                                    UpdatePrinciple := ReceiptLine."SUPER SCHOOL FEES";
                                                    UpdateInterest := ReceiptLine."Int SUPER SCHOOL FEES";
                                                end;
                                            '19':
                                                begin
                                                    UnallocatedPerLoanProd := ReceiptLine."INVESTMENT LOAN";
                                                    LoanProdType := LoanProductsSetup.Code;
                                                    UpdatePrinciple := ReceiptLine."INVESTMENT LOAN";
                                                    UpdateInterest := ReceiptLine."Int INVESTMENT LOAN";
                                                end;
                                            '20':
                                                begin
                                                    UnallocatedPerLoanProd := ReceiptLine."DEVELOPMENT LOAN";
                                                    LoanProdType := LoanProductsSetup.Code;
                                                    UpdatePrinciple := ReceiptLine."DEVELOPMENT LOAN";
                                                    UpdateInterest := ReceiptLine."Int DEVELOPMENT LOAN";
                                                end;

                                        end;
                                        LineNo := LineNo + 10000;
                                        SwizzsoftFactory.FnCreateGnlJournalLine(Jtemplate, JBatch, Rec.No, LineNo, GenJournalLine."transaction type"::"Loan Repayment", GenJournalLine."account type"::Customer,
                                                                                    ReceiptLine."Member No.", Rec."Loan CutOff Date", -UpdatePrinciple, 'BOSA', '', 'loan repayment checkoff for ' +
                                                                                    KnGetPeriodDescription(Rec."CheckOff Period") + ' ' + CheckoffLinesBuffer."Member No." + ' ' + Rec."Employer Code", LNNO);//LoanApp."Loan  No.");
                                                                                                                                                                                                              //Int normal loan
                                        LineNo := LineNo + 10000;
                                        //AmountToPay:=FnGetLoanInterestToPay(ReceiptLine."Int normal loan",ReceiptLine."NLoan No");
                                        SwizzsoftFactory.FnCreateGnlJournalLine(Jtemplate, JBatch, Rec.No, LineNo, GenJournalLine."transaction type"::"Interest Paid", GenJournalLine."account type"::Customer,
                                                                              ReceiptLine."Member No.", Rec."Loan CutOff Date", -UpdateInterest, 'BOSA', '', 'Interest payment checkoff for ' +
                                                                              KnGetPeriodDescription(Rec."CheckOff Period") + ' ' + CheckoffLinesBuffer."Member No." + ' ' + Rec."Employer Code", LNNO);//LLoanApp."Loan  No.");
                                    until LoanProductsSetup.Next = 0;
                                end;//END LoanProductsSetup

                                // Principal

                                //Unallocated Funds
                                LineNo := LineNo + 10000;
                                SwizzsoftFactory.FnCreateGnlJournalLine(Jtemplate, JBatch, Rec.No, LineNo, GenJournalLine."transaction type"::"Unallocated Funds", GenJournalLine."account type"::Customer,
                                                                  ReceiptLine."Member No.", Rec."Loan CutOff Date", -UnallocatedFunds, 'BOSA', '', 'Unallocated Funds checkoff for ' +
                                                                  KnGetPeriodDescription(Rec."CheckOff Period") + ' ' + CheckoffLinesBuffer."Member No." + ' ' + Rec."Employer Code", '');

                            until ReceiptLine.Next = 0;
                        end;//1

                        //Balance
                        LineNo := LineNo + 10000;
                        SwizzsoftFactory.FnCreateGnlJournalLine(Jtemplate, JBatch, Rec.No, LineNo, GenJournalLine."transaction type"::" ", GenJournalLine."account type"::Customer,
                                                          Rec."Account No", Rec."Loan CutOff Date", Rec."Total Scheduled", 'BOSA', '', 'Checkoff balancing off for ' +
                                                          KnGetPeriodDescription(Rec."CheckOff Period") + ' ' + CheckoffLinesBuffer."Member No." + ' ' + Rec."Employer Code", '');

                        Window.Close;

                        /*Gnljnline.RESET;
                        Gnljnline.SETRANGE("Journal Template Name",Jtemplate);
                        Gnljnline.SETRANGE("Journal Batch Name",JBatch);
                        IF Gnljnline.FIND('-') THEN BEGIN
                         CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post Batch",Gnljnline);
                        END;

                        Posted:=TRUE;
                        MODIFY;
                        COMMIT;*/
                        Message('Checkoff successfully Generated.');

                    end;

                end;
            }
            action("Process Checkoff Unallocated")
            {
                ApplicationArea = Basic;
                Visible = false;

                trigger OnAction()
                begin
                    MembLedg.Reset;
                    MembLedg.SetRange(MembLedg."Document No.", Rec.Remarks);
                    if MembLedg.Find('-') = false then begin
                        Error('You Can Only do this process on Already Posted Checkoffs')
                    end;
                    ReceiptLine.Reset;
                end;
            }
            action("Process Annual Charge")
            {
                ApplicationArea = Basic;
                Image = AuthorizeCreditCard;
                Promoted = true;
                PromotedCategory = Process;
                Visible = false;

                trigger OnAction()
                begin
                    Rec.TestField("Document No");
                    Rec.TestField(Amount);
                    ReceiptLine.Reset;
                end;
            }
            action("Mark as Posted")
            {
                ApplicationArea = Basic;
                Enabled = not ActionEnabled;
                Image = PostBatch;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                Visible = false;

                trigger OnAction()
                begin
                    if Confirm('Are you sure you want to mark this Checkoff as Posted ?', false) = true then begin
                        MembLedg.Reset;
                        MembLedg.SetRange(MembLedg."Document No.", Rec.Remarks);
                        if MembLedg.Find('-') = false then
                            Error('Sorry,You can only do this process on already posted Checkoffs');
                        Rec.Posted := true;
                        Rec."Posted By" := UserId;
                        Rec."Loan CutOff Date" := Rec."Loan CutOff Date";
                        Rec.Modify;
                    end;
                end;
            }
            action(Journals)
            {
                ApplicationArea = Basic;
                Caption = 'General Journal';
                Image = Journals;
                Promoted = true;
                PromotedCategory = Category5;
                PromotedOnly = true;
                RunObject = Page "General Journal";
            }
            action("Print Preview")
            {
                ApplicationArea = Basic;
                Caption = 'Print Preview';
                Image = PrintReport;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    if Confirm('kindly confirm if allocation have been correctly done before posting') = false then
                        exit;
                    /*
                    ReptProcHeader.RESET;
                    ReptProcHeader.SETRANGE(ReptProcHeader.No,No);
                    IF ReptProcHeader.FIND('-') THEN
                    REPORT.RUN(51516972,TRUE,FALSE,ReptProcHeader)
                    */

                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        ActionEnabled := true;
        MembLedg.Reset;
        MembLedg.SetRange(MembLedg."Document No.", Rec.Remarks);
        MembLedg.SetRange(MembLedg."External Document No.", "Cheque No.");
        if MembLedg.Find('-') then begin
            //ActionEnabled:=FALSE;
        end;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Rec."Posting date" := Today;
        Rec."Date Entered" := Today;
        if Rec."Employer Code" <> '' then begin
            BufferTable.Reset;
            BufferTable.SetRange(BufferTable.UserId, UserId);
            if BufferTable.Find('-') then begin
                BufferTable.DeleteAll;
            end;
            BufferTable.Init;
            BufferTable.UserId := UserId;
            BufferTable.EmployerCode := Rec."Employer Code";
            BufferTable.Insert;
        end;
    end;

    trigger OnOpenPage()
    begin
        if Rec."Employer Code" <> '' then begin
            BufferTable.Reset;
            BufferTable.SetRange(BufferTable.UserId, UserId);
            if BufferTable.Find('-') then begin
                BufferTable.DeleteAll;
            end;
            BufferTable.Init;
            BufferTable.UserId := UserId;
            BufferTable.EmployerCode := Rec."Employer Code";
            BufferTable.Insert;
        end;
    end;

    var
        Gnljnline: Record "Gen. Journal Line";
        PDate: Date;
        DocNo: Code[20];
        RunBal: Decimal;
        ReceiptsProcessingLines: Record "Checkoff Lines-Distributed";
        LineNo: Integer;
        LBatches: Record "Loan Disburesment-Batching";
        Jtemplate: Code[30];
        JBatch: Code[30];
        "Cheque No.": Code[20];
        DActivityBOSA: Code[20];
        DBranchBOSA: Code[20];
        ReptProcHeader: Record "Checkoff Header-Distributed";
        Cust: Record Customer;
        MembPostGroup: Record "Customer Posting Group";
        Loantable: Record "Loans Register";
        LRepayment: Decimal;
        RcptBufLines: Record "Checkoff Lines-Distributed";
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
        ReceiptLine: Record "Checkoff Lines-Distributed";
        MembLedg: Record "Cust. Ledger Entry";
        SFactory: Codeunit "Swizzsoft Factory.";
        BATCH_NAME: Code[50];
        BATCH_TEMPLATE: Code[50];
        DOCUMENT_NO: Code[40];
        GenJournalLine: Record "Gen. Journal Line";
        ActionEnabled: Boolean;
        // XMLCheckOff: XmlPort 51516003;
        Window: Dialog;
        TotalCount: Integer;
        Counter: Integer;
        Percentage: Integer;
        ObjCust: Record Customer;
        ObjSaccoGenSetUp: Record "Sacco General Set-Up";
        MemberNumber: Code[20];
        SwizzsoftFactory: Codeunit "Swizzsoft Factory.";
        Temp: Record "Funds User Setup";
        DefaulterPaymentType: Option;
        KNFactory: Codeunit "Poly Factory";
        BufferTable: Record "Checkoff Code Buffer";
        UnallocatedFunds: Decimal;
        LoanOutstandingBalance: Decimal;
        LoanOutstandingInterest: Decimal;
        AmountToPay: Decimal;
        InterestTopay: Decimal;
        MemberTotal: Decimal;
        UnallocatedPerLoanProd: Decimal;
        LoanProductsSetup: Record "Loan Products Setup";
        UpdateInterest: Decimal;
        UpdatePrinciple: Decimal;
        CheckoffLinesBuffer: Record "Checkoff Lines-Buffer";
        Vend: Record Customer;
        LNNO: Code[20];
        LoansRegister6: Record "Loans Register";
        Postingdate: Date;

    local procedure FnInitiateProgressBar()
    begin
    end;

    local procedure FnUpdateProgressBar()
    begin
        Percentage := (ROUND(Counter / TotalCount * 10000, 1));
        Counter := Counter + 1;
        Window.Update(1, Percentage);
    end;

    local procedure FnGetLoanNo(MemberNo: Code[20]; LoanType: Code[20]) LoanNo: Code[20]
    var
        ObjLoansRegister: Record 51371;
    begin
        ObjLoansRegister.Reset;
        ObjLoansRegister.SetRange(ObjLoansRegister."Client Code", MemberNo);
        ObjLoansRegister.SetRange(ObjLoansRegister."Loan Product Type", LoanType);
        ObjLoansRegister.SetFilter(ObjLoansRegister."Outstanding Balance", '>%1', 0);
        if ObjLoansRegister.FindFirst then begin
            LoanNo := ObjLoansRegister."Loan  No.";
        end;
        exit(LoanNo);
    end;

    local procedure FnGetMemberNo(PayrollNo: Code[30]; EmployerCode: Code[30]) MemberNo: Code[20]
    var
        ObjMembersReg: Record Customer;
    begin
        ObjMembersReg.Reset;
        // ObjMembersReg.SetRange(ObjMembersReg."Payroll/Staff No", PayrollNo);
        // ObjMembersReg.SetRange(ObjMembersReg."Employer Code", EmployerCode);
        // if ObjMembersReg.Find('-') then begin
        //     MemberNo := ObjMembersReg."No.";
        // end;
        // exit(MemberNo);
    end;

    local procedure KnGetPeriodDescription(Period: Date): Text
    var
        ObjCheckOffPeriods: Record 51428;
        Description: Text;
    begin
        ObjCheckOffPeriods.Reset;
        ObjCheckOffPeriods.SetRange(ObjCheckOffPeriods."Date Opened", Period);
        if ObjCheckOffPeriods.Find('-') then begin
            Description := ObjCheckOffPeriods."Period Name";
        end;

        exit(Description);
    end;

    local procedure FnGetLoanAmountToPay(LoanAmount: Decimal; LoanNo_: Code[30]) AmountToPay_: Decimal
    begin
        //___________________________Loan_______________________

        AmountToPay := 0;
        LoanOutstandingBalance := KNFactory.KnGetLoanBalanceOneLoan(LoanNo_);

        //LoanOutstandingBalance:=KNFactory.KnGetLoanBalanceOneLoan(LoanNo_);
        if (LoanOutstandingBalance > 0) and (LoanOutstandingBalance < LoanAmount) then begin
            AmountToPay_ := LoanOutstandingBalance;
            //UnallocatedPerLoanProd:=UnallocatedPerLoanProd-AmountToPay_;//Added
        end else if LoanOutstandingBalance <= 0 then begin
            AmountToPay_ := 0;
            //UnallocatedPerLoanProd:=UnallocatedPerLoanProd+LoanAmount;
        end else begin
            AmountToPay_ := LoanAmount;
            //UnallocatedPerLoanProd:=UnallocatedPerLoanProd-AmountToPay_;//Addded
        end;
        exit(AmountToPay_);
    end;

    local procedure FnGetLoanInterestToPay(InterestAmount: Decimal; LoanNo_: Code[30]) InterestToPay_: Decimal
    begin
        //__________________________Interest___________________

        AmountToPay := 0;
        LoanOutstandingInterest := KNFactory.KnGetLoanBalance(LoanNo_);
        if (LoanOutstandingInterest > 0) and (LoanOutstandingInterest < InterestAmount) then begin
            InterestToPay_ := LoanOutstandingInterest;
            //UnallocatedPerLoanProd:=UnallocatedPerLoanProd-InterestToPay_;//Added
        end else if LoanOutstandingInterest <= 0 then begin
            InterestToPay_ := 0;
            //UnallocatedPerLoanProd:=InterestAmount;
        end else begin
            InterestToPay_ := InterestAmount;
            //UnallocatedPerLoanProd:=UnallocatedPerLoanProd-InterestToPay_;//added
        end;
        exit(InterestToPay_);
    end;
}

