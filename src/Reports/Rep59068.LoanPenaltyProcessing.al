Report 59068 "Loan Penalty Processing"
{
    //ApplicationArea = All;
    //Caption = 'Loan Defaulters List';
    //UsageCategory = ReportsAndAnalysis;
    //DefaultLayout = RDLC;
    //RDLCLayout = './Layouts/LoanDefualterList.rdlc';
    ProcessingOnly = true;
    dataset
    {
        dataitem(Loans; "Loans Register")
        {
            DataItemTableView = sorting("Loan  No.") order(ascending) where(Posted = const(true), "Outstanding Balance" = filter('>0'), "Amount in Arrears" = filter('>0'));
            RequestFilterFields = "Application Date", "Issued Date";
            column(ReportForNavId_4645; 4645)
            {
            }
            column(FORMAT_TODAY_0_4_; Format(Today, 0, 4))
            {
            }
            column(Top_Up_Amount; "Top Up Amount")
            {
            }
            column(COMPANYNAME; Company.Name)
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
            column(EmployerCode; CompanyCode)
            {
            }
            column(StaffNo; "Staff No")
            {
            }
            column(Loans__Loan__No__; "Loan  No.")
            {
            }
            column(AccountNo_Loans; Loans."Account No")
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
            column(Loans__Approved_Amount_; Round("Approved Amount", 1, '>'))
            {
            }
            column(Repayment; Repayment)
            {
            }

            column(No_of_Months_in_Arrears; "No of Months in Arrears") { }

            column(Days_In_Arrears; "No of Days In Arrears") { }
            column(Loans_Installments; Installments)
            {
            }
            column(Loans__Loan_Status_; "Loan Status")
            {
            }


            column(Loans__Arrears_; Round("Amount in Arrears", 1, '>'))
            {
            }
            column(Loans_Loans__Outstanding_Balance_; Round(Loans."Outstanding Balance", 1, '>'))
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
            column(Loans_Loans__Loan_Product_Type_; Loans."Loan Product Type Name")
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

            column(Company_Name; Company.Name)
            {
            }
            column(Company_Address; Company.Address)
            {
            }
            column(Company_Address_2; Company."Address 2")
            {
            }
            column(Company_Phone_No; Company."Phone No.")
            {
            }
            column(Company_Fax_No; Company."Fax No.")
            {
            }
            column(Company_Picture; Company.Picture)
            {
            }
            column(Company_Email; Company."E-Mail")
            {
            }
            column(Lbal; Round(LBalance, 1, '>'))
            {
            }

            column(Expected_Loan_Balance; Round("Expected Loan Balance", 1, '>'))
            {

            }


            trigger OnAfterGetRecord()
            var
                LoanRepaymentScheduleRec: Record "Loan Repayment Schedule";
            begin
                LCount := LCount + 1;
                //penalty
                LoanRepaymentScheduleRec.Reset();
                LoanRepaymentScheduleRec.SetRange("Loan No.", Loans."Loan  No.");
                LoanRepaymentScheduleRec.SetFilter(Penalty, '>0');
                LoanRepaymentScheduleRec.setrange(PenaltyCharged, false);
                LoanRepaymentScheduleRec.SetFilter("Repayment Date", '<=%1', Loans."Loan Aging Run Date");
                if LoanRepaymentScheduleRec.FindSet() then begin

                    repeat

                        ChargePenaltyOnLatePayment(LoanRepaymentScheduleRec);

                    until LoanRepaymentScheduleRec.Next() = 0;
                end;
            end;

            trigger OnPreDataItem()
            begin

                //delete journal line
                GenJournalLine.Reset;
                GenJournalLine.SetRange("Journal Template Name", 'GENERAL');
                GenJournalLine.SetRange("Journal Batch Name", 'PENALTY');
                GenJournalLine.DeleteAll;
                //end of deletion
                if LoanProductTypeCode <> '' then
                    Loans.SetRange("Loan Product Type", LoanProductTypeCode);


                case ArrearsFilterOption of
                    ArrearsFilterOption::"All Arrears":
                        Loans.SetFilter("Days In Arrears", '>0');
                    ArrearsFilterOption::"Over 90 Days Only":
                        Loans.SetFilter("Days In Arrears", '>90');
                end;

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


                Company.Get();



                //Datefilter:=Loans.GETRANGEMAX(Loans."Date filter");
                //Loans.SETRANGE(Loans."Date filter",0D,Datefilter);
            end;


            trigger OnPostDataItem()
            begin

                GenJournalLine.Reset;
                GenJournalLine.SetRange("Journal Template Name", 'GENERAL');
                GenJournalLine.SetRange("Journal Batch Name", 'PENALTY');
                page.Run(Page::"General Journal");

            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Options)
                {

                    field(ArrearsFilter; ArrearsFilterOption)
                    {
                        Caption = 'Filter Arrears';
                        ApplicationArea = All;
                    }


                    field(LoanProductTypeFilter; LoanProductTypeCode)
                    {
                        Caption = 'Loan Product Type';
                        ApplicationArea = All;
                        TableRelation = "Loan Products Setup".Code;
                    }

                }
            }
        }

    }

    labels
    {
    }

    var

        ArrearsFilterOption: Option "All Arrears","Over 90 Days Only";
        RPeriod: Decimal;
        BatchL: Code[100];
        Batches: Record "Loan Disburesment-Batching";
        LocationFilter: Code[20];
        TotalApproved: Decimal;
        cust: Record Customer;
        BOSABal: Decimal;
        SuperBal: Decimal;
        LAppl: Record "Loans Register";
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
        Datefilter: Date;
        CustLedger: Record "Cust. Ledger Entry";
        DateFilterr: Date;
        LBalance: Decimal;

        Company: Record "Company Information";


        LoanProductTypeCode: Code[20];

        LoanApp: Record "Loans Register";
        GenJournalLine: Record "Gen. Journal Line";

    local procedure ChargePenaltyOnLatePayment(var LoanScheduleRec: Record "Loan Repayment Schedule")
    var

        GenJournalLine: Record "Gen. Journal Line";
        GenJournalBatch: Record "Gen. Journal Batch";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        DocumentNo: Code[20];
        LineNo: Integer;
        AsAt: dATE;
        LoanType: Record "Loan Products Setup";

    begin

        AsAt := lOANS."Loan Aging Run Date";

        GenJournalBatch.Get('GENERAL', 'PENALTY');


        DocumentNo := NoSeriesMgt.GetNextNo(GenJournalBatch."No. Series", AsAt, false);


        GenJournalLine.SetRange("Journal Template Name", 'GENERAL');
        GenJournalLine.SetRange("Journal Batch Name", 'PENALTY');
        if GenJournalLine.FindLast() then
            LineNo := GenJournalLine."Line No." + 10000
        else
            LineNo := 10000;


        // Create penalty charge entry (Debit customer)
        GenJournalLine.Init();
        GenJournalLine."Journal Template Name" := 'GENERAL';
        GenJournalLine."Journal Batch Name" := 'PENALTY';
        GenJournalLine."Line No." := LineNo;
        //GenJournalLine."Document Type" := GenJournalLine."Document Type"::Invoice;
        GenJournalLine."Document No." := DocumentNo;
        GenJournalLine."Posting Date" := AsAt;
        GenJournalLine."Account Type" := GenJournalLine."Account Type"::Customer;
        GenJournalLine."Account No." := Loans."Client Code";
        GenJournalLine.Amount := LoanScheduleRec.Penalty;
        GenJournalLine.Validate(GenJournalLine."Account No.");
        GenJournalLine."Loan No" := Loans."Loan  No.";
        GenJournalLine.Validate(GenJournalLine."Loan No");
        GenJournalLine."Transaction Type" := GenJournalLine."Transaction Type"::"Penalty Charged";
        GenJournalLine.Description := 'Late penalty for: ' + Loans."Loan Product Type Name" + ' - ' + Format(LoanScheduleRec."Repayment Date", 0, '<Month Text> <Year4>') + ' (Due: ' + Format(LoanScheduleRec."Monthly Repayment") + ')';

        if LoanType.Get(Loans."Loan Product Type") then begin
            GenJournalLine.Validate(GenJournalLine.Amount);

            GenJournalLine."Bal. Account Type" := GenJournalLine."bal. account type"::"G/L Account";
            GenJournalLine."Bal. Account No." := '4002';
            GenJournalLine."Loan Product Type" := LoanType.Code;
            GenJournalLine.Validate(GenJournalLine."Bal. Account No.");
        end;
        if loanapp.Source = loanapp.Source::BOSA then begin
            GenJournalLine."Shortcut Dimension 1 Code" := Cust."Global Dimension 1 Code";
            GenJournalLine."Shortcut Dimension 2 Code" := Cust."Global Dimension 2 Code";
        end;
        GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 1 Code");
        GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 2 Code");



        GenJournalLine.Insert();

        // Create corresponding credit entry (Income account)
        // LineNo += 10000;
        // GenJournalLine.Init();
        // GenJournalLine."Journal Template Name" := 'GENERAL';
        // GenJournalLine."Journal Batch Name" := 'PENALTY';
        // GenJournalLine."Line No." := LineNo;
        // GenJournalLine."Document Type" := GenJournalLine."Document Type"::Invoice;
        // GenJournalLine."Document No." := DocumentNo;
        // GenJournalLine."Posting Date" := AsAt;
        // GenJournalLine."Account Type" := GenJournalLine."Account Type"::"G/L Account";
        // GenJournalLine."Account No." := '4002'; // Penalty Income Account - adjust as needed
        // GenJournalLine.Amount := -LoanScheduleRec.Penalty;
        // GenJournalLine.Description := 'Late Payment Penalty Income - ' + Loans."Loan  No.";
        // GenJournalLine.Insert();

        //Codeunit.Run(Codeunit::"Gen. Jnl.-Post Batch", GenJournalLine);

        //LoanScheduleRec.PenaltyCharged := true;
        //LoanScheduleRec.Modify(true);

    end;



}

