#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 56010 "Loans Calculator"
{
    PageType = Card;
    SourceTable = "Loans Calculator";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Loan Product Type"; Rec."Loan Product Type")
                {
                    ApplicationArea = Basic;
                }
                field("Product Description"; Rec."Product Description")
                {
                    ApplicationArea = Basic;
                }
                field("Interest rate"; Rec."Interest rate")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Installments; Rec.Installments)
                {
                    ApplicationArea = Basic;
                }
                field("Instalment Period"; Rec."Instalment Period")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Repayment Method"; Rec."Repayment Method")
                {
                    ApplicationArea = Basic;
                }
                field("Requested Amount"; Rec."Requested Amount")
                {
                    ApplicationArea = Basic;
                }
                field("Principle Repayment"; Rec."Principle Repayment")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Interest Repayment"; Rec."Interest Repayment")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Repayment Start Date"; Rec."Repayment Start Date")
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
            group(ViewSchedule)
            {
                action("View Schedule")
                {
                    ApplicationArea = Basic;
                    Image = ViewDetails;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    PromotedOnly = true;

                    trigger OnAction()
                    begin
                        InstallNo2 := 3;
                        QCounter := 0;
                        QCounter := 3;
                        Evaluate(InPeriod, '1Q');
                        GrPrinciple := Rec."Grace Period - Principle (M)";
                        GrInterest := Rec."Grace Period - Interest (M)";
                        InitialGraceInt := Rec."Grace Period - Interest (M)";


                        LoansR.Reset;
                        LoansR.SetRange(LoansR."Loan Product Type", Rec."Loan Product Type");
                        if LoansR.Find('-') then begin

                            RSchedule.Reset;
                            RSchedule.DeleteAll;


                            LBalance := LoansR."Requested Amount";
                            LoanAmount := LoansR."Requested Amount";
                            InterestRate := Rec."Interest rate";
                            RepayPeriod := Rec.Installments;
                            RunDate := Rec."Repayment Start Date";
                            InstalNo := 0;
                            Evaluate(RepayInterval, '1M');
                            repeat
                                InstallNo2 := InstallNo2 - 1;
                                InstalNo := InstalNo + 1;


                                if Rec."Repayment Method" = Rec."repayment method"::Amortised then begin
                                    Rec.TestField("Interest rate");
                                    Rec.TestField(Installments);
                                    TotalMRepay := ROUND((InterestRate / 12 / 100) / (1 - Power((1 + (InterestRate / 12 / 100)), -(RepayPeriod))) * (LoanAmount), 0.05, '>');
                                    LInterest := ROUND(LBalance / 100 / 12 * InterestRate, 0.05, '>');
                                    LPrincipal := TotalMRepay - LInterest;
                                end;

                                if Rec."Repayment Method" = Rec."repayment method"::"Straight Line" then begin
                                    if Rec."Loan Product Type" = 'LT008' then begin
                                        // Rec.TestField(Rec.Interest);
                                        Rec.TestField(Rec.Installments);
                                        LPrincipal := LoanAmount / RepayPeriod;
                                        LInterest := 0;
                                    end else begin
                                        Rec.TestField(Rec."Interest rate");
                                        Rec.TestField(Rec.Installments);
                                        LPrincipal := LoanAmount / RepayPeriod;
                                        LInterest := (InterestRate / 12 / 100) * LoanAmount / RepayPeriod;
                                    end;
                                end;
                                if Rec."Repayment Method" = Rec."repayment method"::"Reducing Balance" then begin
                                    Rec.TestField("Interest rate");
                                    Rec.TestField(Installments);
                                    LPrincipal := ROUND(LoanAmount / RepayPeriod, 0.05, '>');
                                    LInterest := ROUND((InterestRate / 12 / 100) * LBalance, 0.05, '>');
                                end;

                                if Rec."Repayment Method" = Rec."repayment method"::Constants then begin
                                    Rec.TestField(Repayment);
                                    if LBalance < Rec.Repayment then
                                        LPrincipal := LBalance
                                    else
                                        LPrincipal := Rec.Repayment;
                                    LInterest := Rec."Interest rate";
                                end;


                                //Grace Period
                                if GrPrinciple > 0 then begin
                                    LPrincipal := 0
                                end else begin
                                    if Rec."Instalment Period" <> InPeriod then
                                        LBalance := LBalance - LPrincipal;

                                end;

                                if GrInterest > 0 then
                                    LInterest := 0;

                                GrPrinciple := GrPrinciple - 1;
                                GrInterest := GrInterest - 1;
                                //Grace Period

                                //Q Principle
                                if Rec."Instalment Period" = InPeriod then begin
                                    //ADDED
                                    if GrPrinciple <> 0 then
                                        GrPrinciple := GrPrinciple - 1;
                                    if QCounter = 1 then begin
                                        QCounter := 3;
                                        LPrincipal := QPrinciple + LPrincipal;
                                        if LPrincipal > LBalance then
                                            LPrincipal := LBalance;
                                        LBalance := LBalance - LPrincipal;
                                        QPrinciple := 0;
                                    end else begin
                                        QCounter := QCounter - 1;
                                        QPrinciple := QPrinciple + LPrincipal;
                                        //IF QPrinciple > LBalance THEN
                                        //QPrinciple:=LBalance;
                                        LPrincipal := 0;
                                    end

                                end;
                                //Q Principle

                                Evaluate(RepayCode, Format(InstalNo));

                                if rec."Loan Product Type" = 'LT008' then begin
                                    RSchedule.Init;
                                    RSchedule."Repayment Code" := RepayCode;
                                    RSchedule."Loan Amount" := LoanAmount;
                                    RSchedule."Instalment No" := InstalNo;
                                    RSchedule."Repayment Date" := CalcDate('CM', RunDate);
                                    RSchedule."Loan Category" := Rec."Loan Product Type";
                                    RSchedule."Monthly Repayment" := LInterest + LPrincipal + Rec."Administration Fee";
                                    RSchedule."Monthly Interest" := LInterest;
                                    RSchedule."Principal Repayment" := LPrincipal;
                                    RSchedule.Insert;


                                    RunDate := CalcDate('1M', RunDate);
                                end else begin

                                    RSchedule.Init;
                                    RSchedule."Repayment Code" := RepayCode;
                                    RSchedule."Loan Amount" := LoanAmount;
                                    RSchedule."Instalment No" := InstalNo;
                                    RSchedule."Repayment Date" := CalcDate('CM', RunDate);
                                    RSchedule."Loan Category" := Rec."Loan Product Type";
                                    RSchedule."Monthly Repayment" := LInterest + LPrincipal + Rec."Administration Fee";
                                    RSchedule."Monthly Interest" := LInterest;
                                    RSchedule."Principal Repayment" := LPrincipal;
                                    RSchedule.Insert;


                                    RunDate := CalcDate('1M', RunDate);
                                end;
                            until LBalance < 1;

                        end;

                        Commit;

                        LoansR.Reset;
                        LoansR.SetRange(LoansR."Loan Product Type", Rec."Loan Product Type");
                        if LoansR.Find('-') then
                            Report.Run(50436, true, false, LoansR);
                    end;
                }
            }
        }
    }

    var
        i: Integer;
        LoanType: Record "Loan Products Setup";
        PeriodDueDate: Date;
        // ScheduleRep: Record "Loan Repayment Calculator";
        RunningDate: Date;
        G: Integer;
        IssuedDate: Date;
        GracePeiodEndDate: Date;
        InstalmentEnddate: Date;
        GracePerodDays: Integer;
        InstalmentDays: Integer;
        NoOfGracePeriod: Integer;
        // NewSchedule: Record "Loan Repayment Calculator";
        RSchedule: Record "Loan Repayment Calculator";
        GP: Text[30];
        ScheduleCode: Code[20];
        // PreviewShedule: Record "Loan Repayment Calculator";
        PeriodInterval: Code[10];
        CustomerRecord: Record Customer;
        Gnljnline: Record "Gen. Journal Line";
        //Jnlinepost: Codeunit "Gen. Jnl.-Post Line";
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
        GenSetUp: Record "Sales & Receivables Setup";
        PCharges: Record "Loan Product Charges";
        TCharges: Decimal;
        LAppCharges: Record "Loan Applicaton Charges";
        LoansR: Record "Loans Calculator";
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
        // GLPosting: Codeunit "Gen. Jnl.-Post Line";
        LoanTopUp: Record "Loan Offset Details";
        Vend: Record Vendor;
        BOSAInt: Decimal;
        TopUpComm: Decimal;
        DActivity: Code[20];
        DBranch: Code[20];
        UsersID: Record User;
        TotalTopupComm: Decimal;
        //Notification: Codeunit Mail;
        CustE: Record "Loans Register";
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
        ApprovalUsers: Record "Approvals Users Set Up";
        MovementTracker: Record "Movement Tracker";
        DiscountingAmount: Decimal;
        StatusPermissions: Record "Status Change Permision";
        BridgedLoans: Record "Loans Register";
        SMSMessage: Record "SMS Messages";
        InstallNo2: Integer;
        currency: Record "Currency Exchange Rate";
        CURRENCYFACTOR: Decimal;
        LoanApps: Record "Loans Register";
        LoanDisbAmount: Decimal;
        BatchTopUpAmount: Decimal;
        BatchTopUpComm: Decimal;
        Disbursement: Record "Loan Disburesment-Batching";
        LoansCalc: Record "Loans Calculator";

    procedure FnGenerateRepaymentSchedule(LoanNumber: Code[50]): Boolean
    var
        ObjLoans: Record "Loans Register";
        ObjRepaymentschedule: Record "Loan Repayment Schedule";
        ObjLoansII: Record "Loans Register";
        VarPeriodDueDate: Date;
        VarRunningDate: Date;
        VarGracePeiodEndDate: Date;
        VarInstalmentEnddate: Date;
        VarGracePerodDays: Integer;
        VarInstalmentDays: Integer;
        VarNoOfGracePeriod: Integer;
        VarLoanAmount: Decimal;
        VarInterestRate: Decimal;
        VarRepayPeriod: Integer;
        VarLBalance: Decimal;
        VarRunDate: Date;
        VarInstalNo: Decimal;
        VarRepayInterval: DateFormula;
        VarTotalMRepay: Decimal;
        VarLInterest: Decimal;
        VarLPrincipal: Decimal;
        VarLInsurance: Decimal;
        VarRepayCode: Code[30];
        VarGrPrinciple: Integer;
        VarGrInterest: Integer;
        VarQPrinciple: Decimal;
        VarQCounter: Integer;
        VarInPeriod: DateFormula;
        VarInitialInstal: Integer;
        VarInitialGraceInt: Integer;
        VarScheduleBal: Decimal;
        VarLNBalance: Decimal;
        ObjProductCharge: Record "Loan Product Charges";
        VarWhichDay: Integer;
        VarRepaymentStartDate: Date;
        VarMonthIncreament: Text;
        ScheduleEntryNo: Integer;
        saccogen: Record "Sacco General Set-Up";
    begin
        ObjLoans.Reset;
        ObjLoans.SetRange(ObjLoans."Loan  No.", LoanNumber);
        if ObjLoans.FindSet then begin
            if ObjLoans."Repayment Frequency" = ObjLoans."repayment frequency"::Daily then
                Evaluate(VarInPeriod, '1D')
            else
                if ObjLoans."Repayment Frequency" = ObjLoans."repayment frequency"::Weekly then
                    Evaluate(VarInPeriod, '1W')
                else
                    if ObjLoans."Repayment Frequency" = ObjLoans."repayment frequency"::Monthly then
                        Evaluate(VarInPeriod, '1M')
                    else
                        if ObjLoans."Repayment Frequency" = ObjLoans."repayment frequency"::Quaterly then
                            Evaluate(VarInPeriod, '1Q');

            VarRunDate := 0D;
            VarQCounter := 0;
            VarQCounter := 3;
            VarScheduleBal := 0;

            VarGrPrinciple := ObjLoans."Grace Period - Principle (M)";
            VarGrInterest := ObjLoans."Grace Period - Interest (M)";
            VarInitialGraceInt := ObjLoans."Grace Period - Interest (M)";


            ObjLoansII.Reset;
            ObjLoansII.SetRange(ObjLoansII."Loan  No.", LoanNumber);
            if ObjLoansII.Find('-') then begin
                ObjLoansII.CalcFields(ObjLoansII."Outstanding Balance");

                ObjLoans.TestField(ObjLoans."Loan Disbursement Date");
                ObjLoans.TestField(ObjLoans."Repayment Start Date");

                //=================================================================Delete From Tables
                ObjRepaymentschedule.Reset;
                ObjRepaymentschedule.SetRange(ObjRepaymentschedule."Loan No.", LoanNumber);
                if ObjRepaymentschedule.Find('-') then begin
                    ObjRepaymentschedule.DeleteAll;
                end;

                VarLoanAmount := ObjLoansII."Approved Amount";
                VarInterestRate := ObjLoansII.Interest;
                VarRepayPeriod := ObjLoansII.Installments;
                VarInitialInstal := ObjLoansII.Installments + ObjLoansII."Grace Period - Principle (M)";
                VarLBalance := VarLoanAmount;
                VarLNBalance := ObjLoansII."Outstanding Balance";
                VarRunDate := ObjLoansII."Repayment Start Date";
                VarRepaymentStartDate := ObjLoansII."Repayment Start Date";

                VarInstalNo := 0;
                Evaluate(VarRepayInterval, '1W');

                repeat
                    VarInstalNo := VarInstalNo + 1;
                    VarScheduleBal := VarLBalance;
                    ScheduleEntryNo := ScheduleEntryNo + 1;

                    //=======================================================================================Amortised
                    if ObjLoans."Repayment Method" = ObjLoans."repayment method"::Amortised
                       then begin
                        ObjLoans.TestField(ObjLoans.Installments);
                        ObjLoans.TestField(ObjLoans.Interest);
                        ObjLoans.TestField(ObjLoans.Installments);
                        VarTotalMRepay := ROUND((VarInterestRate / 12 / 100) / (1 - Power((1 + (VarInterestRate / 12 / 100)), -VarRepayPeriod)) * VarLoanAmount, 1, '>');
                        VarTotalMRepay := (VarInterestRate / 12 / 100) / (1 - Power((1 + (VarInterestRate / 12 / 100)), -VarRepayPeriod)) * VarLoanAmount;
                        VarLInterest := ROUND(VarLBalance / 100 / 12 * VarInterestRate);

                        VarLPrincipal := VarTotalMRepay - VarLInterest;
                    end;

                    //=======================================================================================Strainght Line
                    if ObjLoans."Repayment Method" = ObjLoans."repayment method"::"Straight Line" then begin
                        // ObjLoans.TestField(ObjLoans.Installments);
                        // VarLPrincipal := ROUND(VarLoanAmount / VarRepayPeriod, 1, '>');
                        // VarLInterest := ROUND((VarInterestRate / 1200) * VarLoanAmount, 1, '>');
                        // if VarInstalNo - ObjLoans."Grace Period - Interest (M)" = 1 then
                        //     VarLInterest := VarLInterest * VarInstalNo;

                        // ObjLoans.Repayment := VarLPrincipal + VarLInterest;
                        // ObjLoans."Loan Principle Repayment" := VarLPrincipal;
                        // ObjLoans."Loan Interest Repayment" := VarLInterest;
                        // ObjLoans.Modify;

                        if ObjLoans."Loan Product Type" = 'LT008' then begin
                            ObjLoans.TestField(ObjLoans.Installments);
                            VarLPrincipal := ROUND(VarLoanAmount / VarRepayPeriod, 1, '>');
                            // VarLInterest := ROUND((VarInterestRate / 1200) * VarLoanAmount, 1, '>');
                            // if VarInstalNo - ObjLoans."Grace Period - Interest (M)" = 1 then
                            //     VarLInterest := VarLInterest * VarInstalNo;

                            ObjLoans.Repayment := VarLPrincipal + VarLInterest;
                            ObjLoans."Loan Principle Repayment" := VarLPrincipal;
                            ObjLoans."Loan Interest Repayment" := 0;// VarLInterest;
                            ObjLoans.Modify;
                        end else begin
                            ObjLoans.TestField(ObjLoans.Installments);
                            VarLPrincipal := ROUND(VarLoanAmount / VarRepayPeriod, 1, '>');
                            VarLInterest := ROUND((VarInterestRate / 1200) * VarLoanAmount, 1, '>');
                            if VarInstalNo - ObjLoans."Grace Period - Interest (M)" = 1 then
                                VarLInterest := VarLInterest * VarInstalNo;

                            ObjLoans.Repayment := VarLPrincipal + VarLInterest;
                            ObjLoans."Loan Principle Repayment" := VarLPrincipal;
                            ObjLoans."Loan Interest Repayment" := VarLInterest;
                            ObjLoans.Modify;
                        end;
                    end;

                    //=======================================================================================Reducing Balance
                    if ObjLoans."Repayment Method" = ObjLoans."repayment method"::"Reducing Balance" then begin
                        ObjLoans.TestField(ObjLoans.Interest);
                        ObjLoans.TestField(ObjLoans.Installments);//2828
                        VarLPrincipal := ROUND(VarLoanAmount / VarRepayPeriod, 1, '>');
                        VarLInterest := ROUND((VarInterestRate / 12 / 100) * VarLBalance, 1, '>');

                    end;

                    //=======================================================================================Constant
                    if ObjLoans."Repayment Method" = ObjLoans."repayment method"::Constants then begin
                        ObjLoans.Repayment := ObjLoans."Approved Amount" / ObjLoans.Installments;
                        ObjLoans.Modify(true);
                        ObjLoans.TestField(ObjLoans.Repayment);
                        if VarLBalance < ObjLoans.Repayment then
                            VarLPrincipal := VarLBalance
                        else
                            VarLPrincipal := ObjLoans.Repayment;

                        VarLInterest := ObjLoans.Interest;

                    end;

                    VarLPrincipal := ROUND(VarLPrincipal, 1, '>');
                    Evaluate(VarRepayCode, Format(VarInstalNo));
                    //======================================================================================Grace Period
                    if VarLBalance < VarLPrincipal then
                        VarLPrincipal := VarLBalance
                    else
                        VarLPrincipal := VarLPrincipal;
                    if VarGrPrinciple > 0 then begin
                        VarLPrincipal := 0;
                        VarLInsurance := 0
                    end else begin
                        VarLBalance := VarLBalance - VarLPrincipal;
                        VarScheduleBal := VarScheduleBal - VarLPrincipal;
                    end;

                    if VarGrInterest > 0 then
                        VarLInterest := 0;

                    VarGrPrinciple := VarGrPrinciple - 1;
                    VarGrInterest := VarGrInterest - 1;


                    //======================================================================================Insert Repayment Schedule Table
                    if VarInstalNo <> 1 then begin
                        VarLInsurance := 0;
                    end;

                    ObjRepaymentschedule.Init;
                    //ObjRepaymentschedule."Entry No" := ScheduleEntryNo;
                    ObjRepaymentschedule."Repayment Code" := VarRepayCode;
                    ObjRepaymentschedule."Loan No." := ObjLoans."Loan  No.";
                    ObjRepaymentschedule."Loan Amount" := VarLoanAmount;
                    ObjRepaymentschedule."Interest Rate" := ObjLoans.Interest;
                    ObjRepaymentschedule."Instalment No" := VarInstalNo;
                    ObjRepaymentschedule."Repayment Date" := VarRunDate;//CALCDATE('CM',RunDate);
                    ObjRepaymentschedule."Member No." := ObjLoans."Client Code";
                    ObjRepaymentschedule."Loan Category" := ObjLoans."Loan Product Type";
                    ObjRepaymentschedule."Monthly Repayment" := VarLInterest + VarLPrincipal;
                    ObjRepaymentschedule."Monthly Interest" := VarLInterest;
                    ObjRepaymentschedule."Principal Repayment" := VarLPrincipal;
                    //ERROR(FORMAT(VarLPrincipal));
                    //ObjRepaymentschedule."Monthly Insurance" := VarLInsurance;
                    ObjRepaymentschedule."Loan Balance" := VarLBalance;
                    ObjRepaymentschedule.Insert;
                    VarWhichDay := Date2dwy(ObjRepaymentschedule."Repayment Date", 1);
                    //=======================================================================Get Next Repayment Date
                    VarMonthIncreament := Format(VarInstalNo) + 'M';
                    if ObjLoans."Repayment Frequency" = ObjLoans."repayment frequency"::Daily then
                        VarRunDate := CalcDate('1D', VarRunDate)
                    else
                        if ObjLoans."Repayment Frequency" = ObjLoans."repayment frequency"::Weekly then
                            VarRunDate := CalcDate('1W', VarRunDate)
                        else
                            if ObjLoans."Repayment Frequency" = ObjLoans."repayment frequency"::Monthly then
                                VarRunDate := CalcDate(VarMonthIncreament, VarRepaymentStartDate)
                            else
                                if ObjLoans."Repayment Frequency" = ObjLoans."repayment frequency"::Quaterly then
                                    VarRunDate := CalcDate('1Q', VarRunDate);

                until VarLBalance < 1
            end;
            Commit();
        end;
    end;

}

