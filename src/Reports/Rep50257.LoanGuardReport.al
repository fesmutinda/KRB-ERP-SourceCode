#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 50257 "Loan Guard Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Loan Guard Report.rdlc';

    dataset
    {
        dataitem(Loans; "Loans Register")
        {
            DataItemTableView = sorting("Staff No") order(ascending) where(Posted = const(true));
            RequestFilterFields = "Date filter", "Issued Date";
            column(ReportForNavId_4645; 4645)
            {
            }
            column(FORMAT_TODAY_0_4_; Format(Today, 0, 4))
            {
            }
            column(COMPANYNAME; COMPANYNAME)
            {
            }
            column(CurrReport_PAGENO; CurrReport.PageNo)
            {
            }
            column(USERID; UserId)
            {
            }
            column(LoanType; LoanType)
            {
            }
            column(RFilters; RFilters)
            {
            }
            column(Loans__Loan__No__; "Loan  No.")
            {
            }
            column(Loans__Client_Code_; "Client Code")
            {
            }
            column(Loans__Client_Name_; "Client Name")
            {
            }
            column(Loans__Requested_Amount_; "Requested Amount")
            {
            }
            column(Loans__Approved_Amount_; "Approved Amount")
            {
            }
            column(Loans_Installments; Installments)
            {
            }
            column(Loans__Loan_Status_; "Loan Status")
            {
            }
            column(Loans_Loans__Outstanding_Balance_; Loans."Outstanding Balance")
            {
            }
            column(Loans__Application_Date_; "Application Date")
            {
            }
            column(Loans__Issued_Date_; "Issued Date")
            {
            }
            column(Loans__Oustanding_Interest_; "Oustanding Interest")
            {
            }
            column(Loans_Loans__Loan_Product_Type_; Loans."Loan Product Type")
            {
            }
            column(Loans__Last_Pay_Date_; "Last Pay Date")
            {
            }
            column(Loans__Top_Up_Amount_; "Top Up Amount")
            {
            }
            column(Loans__Approved_Amount__Control1102760017; "Approved Amount")
            {
            }
            column(Loans__Requested_Amount__Control1102760038; "Requested Amount")
            {
            }
            column(LCount; LCount)
            {
            }
            column(Loans_Loans__Outstanding_Balance__Control1102760040; Loans."Outstanding Balance")
            {
            }
            column(Loans__Oustanding_Interest__Control1102760041; "Oustanding Interest")
            {
            }
            column(Loans__Top_Up_Amount__Control1000000001; "Top Up Amount")
            {
            }
            column(RPeriod; RPeriod)
            {

            }
            column(currentBalance; currentBalance)
            {

            }
            column(Loans_RegisterCaption; Loans_RegisterCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Loan_TypeCaption; Loan_TypeCaptionLbl)
            {
            }
            column(Loans__Loan__No__Caption; FieldCaption("Loan  No."))
            {
            }
            column(Client_No_Caption; Client_No_CaptionLbl)
            {
            }
            column(Loans__Client_Name_Caption; FieldCaption("Client Name"))
            {
            }
            column(Loans__Requested_Amount_Caption; FieldCaption("Requested Amount"))
            {
            }
            column(Loans__Approved_Amount_Caption; FieldCaption("Approved Amount"))
            {
            }
            column(Loans__Loan_Status_Caption; FieldCaption("Loan Status"))
            {
            }
            column(Outstanding_LoanCaption; Outstanding_LoanCaptionLbl)
            {
            }
            column(PeriodCaption; PeriodCaptionLbl)
            {
            }
            column(Loans__Application_Date_Caption; FieldCaption("Application Date"))
            {
            }
            column(Approved_DateCaption; Approved_DateCaptionLbl)
            {
            }
            column(Loans__Oustanding_Interest_Caption; FieldCaption("Oustanding Interest"))
            {
            }
            column(Loan_TypeCaption_Control1102760043; Loan_TypeCaption_Control1102760043Lbl)
            {
            }
            column(Loans__Last_Pay_Date_Caption; FieldCaption("Last Pay Date"))
            {
            }
            column(Loans__Top_Up_Amount_Caption; FieldCaption("Top Up Amount"))
            {
            }
            column(Verified_By__________________________________________________Caption; Verified_By__________________________________________________CaptionLbl)
            {
            }
            column(Confirmed_By__________________________________________________Caption; Confirmed_By__________________________________________________CaptionLbl)
            {
            }
            column(Sign________________________Caption; Sign________________________CaptionLbl)
            {
            }
            column(Sign________________________Caption_Control1102755003; Sign________________________Caption_Control1102755003Lbl)
            {
            }
            column(Date________________________Caption; Date________________________CaptionLbl)
            {
            }
            column(Date________________________Caption_Control1102755005; Date________________________Caption_Control1102755005Lbl)
            {
            }
            column(Idno; IDno)
            {
            }
            column(Dob; Dob)
            {
            }

            trigger OnAfterGetRecord()
            begin

                CompanyCode := '';
                if cust.Get(Loans."BOSA No") then
                    CompanyCode := cust."Employer Code";

                LCount := LCount + 1;

                if Loans.Source = Loans.Source::BOSA then begin
                    cust.Reset;
                    cust.SetRange(cust."No.", Loans."Client Code");
                    if cust.Find('-') then begin
                        Dob := cust."Date of Birth";
                        IDno := cust."ID No.";
                    end;
                end;
                AsAt := GetRangeMax("Date filter");


                //RPeriod := 0;

                currentBalance := 0;
                LoanRec.Reset();
                LoanRec.SetRange(LoanRec."Loan  No.", Loans."Loan  No.");
                if LoanRec.FindSet() then begin
                    repeat
                        Loans.CalcFields(Loans."Outstanding Balance");
                        currentBalance := Loans."Outstanding Balance";
                        If Loans."Outstanding Balance" <= 0 then
                            RPeriod := 0 else begin
                            RPeriod := Installments - GetRepayment("Loan  No.", AsAt);
                        end;


                    until LoanRec.Next = 0;
                end;
            end;

            trigger OnPreDataItem()
            begin
                if LoanProdType.Get(Loans.GetFilter(Loans."Loan Product Type")) then
                    LoanType := LoanProdType."Product Description";
                LCount := 0;

                if Loans.GetFilter(Loans."Branch Code") <> '' then begin
                    DValue.Reset;
                    DValue.SetRange(DValue."Global Dimension No.", 2);
                    DValue.SetRange(DValue.Code, Loans.GetFilter(Loans."Branch Code"));
                    if DValue.Find('-') then
                        RFilters := 'Branch: ' + DValue.Name;

                end;
            end;
        }
    }

    requestpage
    {

        layout
        {
            // area(content)
            // {
            //     field(AsAt; AsAt)
            //     {
            //         ApplicationArea = Basic;
            //         Caption = 'AsAt';
            //     }
            // }
        }

        actions
        {
        }
    }

    labels
    {
    }
    local procedure GetRepayment(LoanNos: Code[20]; DateFiltering: Date): Decimal
    var
        RepaymentInstallments: Decimal;
    begin
        RepaymentInstallments := 0;
        RepaymentSchedule.Reset;
        RepaymentSchedule.SetRange(RepaymentSchedule."Loan No.", LoanNos);
        RepaymentSchedule.SetFilter(RepaymentSchedule."Repayment Date", '%1..%2', 0D, DateFiltering);
        if RepaymentSchedule.FindLast then begin
            repeat
                Evaluate(RepaymentInstallments, RepaymentSchedule."Repayment Code");
            until RepaymentSchedule.Next = 0;
        end;
        exit(RepaymentInstallments);
    end;


    var
        RPeriod: Decimal;

        currentBalance: Decimal;
        AsAt: Date;
        ExpextedRepayment: Decimal;
        RepaymentSchedule: Record "Loan Repayment Schedule";
        BatchL: Code[100];
        Batches: Record "Loan Disburesment-Batching";
        ApprovalSetup: Record "Approval Setup";
        LocationFilter: Code[20];
        TotalApproved: Decimal;
        cust: Record Customer;
        BOSABal: Decimal;
        SuperBal: Decimal;
        LoanRec: Record "Loans Register";
        Deposits: Decimal;
        CompanyCode: Code[20];
        LoanType: Text[50];
        LoanProdType: Record "Loan Products Setup";
        LCount: Integer;
        RFilters: Text[250];
        DValue: Record "Dimension Value";
        VALREPAY: Record "Cust. Ledger Entry";
        Loans_RegisterCaptionLbl: label 'Loans Register';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        Loan_TypeCaptionLbl: label 'Loan Type';
        Client_No_CaptionLbl: label 'Client No.';
        Outstanding_LoanCaptionLbl: label 'Outstanding Loan';
        PeriodCaptionLbl: label 'Period';
        Approved_DateCaptionLbl: label 'Approved Date';
        Loan_TypeCaption_Control1102760043Lbl: label 'Loan Type';
        Verified_By__________________________________________________CaptionLbl: label 'Verified By..................................................';
        Confirmed_By__________________________________________________CaptionLbl: label 'Confirmed By..................................................';
        Sign________________________CaptionLbl: label 'Sign........................';
        Sign________________________Caption_Control1102755003Lbl: label 'Sign........................';
        Date________________________CaptionLbl: label 'Date........................';
        Date________________________Caption_Control1102755005Lbl: label 'Date........................';
        IDno: Code[50];
        Dob: Date;
        vend: Record Vendor;
}

