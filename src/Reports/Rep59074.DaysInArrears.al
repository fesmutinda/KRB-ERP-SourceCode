Report 59074 "Days In Arrears"
{
    ApplicationArea = All;
    Caption = 'Days In Arrears';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = './Layout/DaysInArrears.rdl';
    dataset
    {
        dataitem(Loans; "Loans Register")
        {
            DataItemTableView = sorting("Client Code", "Loan  No.") order(ascending) where(Posted = const(true), "Approved Amount" = filter('>0'), "Outstanding Balance" = filter('>0'), Reversed = const(false), "Amount in Arrears" = filter('>0'));
            RequestFilterFields = "Application Date", "Issued Date";
            column(ReportForNavId_4645; 4645)
            {
            }
            column(FORMAT_TODAY_0_4_; Format(Today, 0, 4))
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
            column(LCount; LCount)
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

            column(Repayment; Repayment)
            {
            }

            column(No_of_Months_in_Arrears; "No of Months in Arrears") { }

            column(Days_In_Arrears; "No of Days In Arrears") { }

            // Age bracket columns - Amount in Arrears
            column(Amount_0_30; Amount_0_30)
            {
            }
            column(Amount_31_60; Amount_31_60)
            {
            }
            column(Amount_61_90; Amount_61_90)
            {
            }
            column(Amount_91_120; Amount_91_120)
            {
            }
            column(Amount_Above_120; Amount_Above_120)
            {
            }

            column(Loans_Installments; Installments)
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

            column(Loans__Client_Name_Caption; FieldCaption("Client Name"))
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
                DaysInArrears: Integer;
                AmountInArrears: Decimal;
            begin
                LCount := LCount + 1;

                // Initialize all bracket variables to 0
                Amount_0_30 := 0;
                Amount_31_60 := 0;
                Amount_61_90 := 0;
                Amount_91_120 := 0;
                Amount_Above_120 := 0;

                // Get the days in arrears and amount in arrears
                DaysInArrears := Loans."No of Days In Arrears";
                AmountInArrears := Loans."Amount in Arrears";

                // Categorize amount into appropriate bracket based on days
                if (DaysInArrears >= 1) and (DaysInArrears <= 30) then
                    Amount_0_30 := AmountInArrears
                else if (DaysInArrears >= 31) and (DaysInArrears <= 60) then
                    Amount_31_60 := AmountInArrears
                else if (DaysInArrears >= 61) and (DaysInArrears <= 90) then
                    Amount_61_90 := AmountInArrears
                else if (DaysInArrears >= 91) and (DaysInArrears <= 120) then
                    Amount_91_120 := AmountInArrears
                else if DaysInArrears >= 121 then
                    Amount_Above_120 := AmountInArrears;

                //ChargePenaltyOnLatePayment(LoanRepaymentScheduleRec);
            end;

            trigger OnPreDataItem()
            begin
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
        // Age bracket variables - Amount in Arrears
        Amount_0_30: Decimal;
        Amount_31_60: Decimal;
        Amount_61_90: Decimal;
        Amount_91_120: Decimal;
        Amount_Above_120: Decimal;

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
        Datefilter: Date;
        CustLedger: Record "Cust. Ledger Entry";
        DateFilterr: Date;
        LBalance: Decimal;
        Company: Record "Company Information";
        LoanProductTypeCode: Code[20];

    local procedure ChargePenaltyOnLatePayment(var LoanScheduleRec: Record "Loan Repayment Schedule")
    var
        GenJournalLine: Record "Gen. Journal Line";
        GenJournalBatch: Record "Gen. Journal Batch";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        DocumentNo: Code[20];
        LineNo: Integer;
        AsAt: Date;
    begin
        AsAt := Loans."Loan Aging Run Date";
        GenJournalBatch.Get('GENERAL', 'PENALTY');

        // Get document number
        DocumentNo := NoSeriesMgt.GetNextNo(GenJournalBatch."No. Series", AsAt, false);

        // Get next line number
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
        GenJournalLine."Document Type" := GenJournalLine."Document Type"::Invoice;
        GenJournalLine."Document No." := DocumentNo;
        GenJournalLine."Posting Date" := AsAt;
        GenJournalLine."Account Type" := GenJournalLine."Account Type"::Customer;
        GenJournalLine."Account No." := Loans."Client Code";
        GenJournalLine.Amount := LoanScheduleRec.Penalty;
        GenJournalLine."Loan No" := Loans."Loan  No.";
        GenJournalLine."Transaction Type" := GenJournalLine."Transaction Type"::"Penalty Charged";
        GenJournalLine.Description := 'Late Payment Penalty - ' + Loans."Loan  No." + ' Due: ' + Format(LoanScheduleRec."Monthly Repayment");
        GenJournalLine.Insert();

        // Create corresponding credit entry (Income account)
        LineNo += 10000;
        GenJournalLine.Init();
        GenJournalLine."Journal Template Name" := 'GENERAL';
        GenJournalLine."Journal Batch Name" := 'PENALTY';
        GenJournalLine."Line No." := LineNo;
        GenJournalLine."Document Type" := GenJournalLine."Document Type"::Invoice;
        GenJournalLine."Document No." := DocumentNo;
        GenJournalLine."Posting Date" := AsAt;
        GenJournalLine."Account Type" := GenJournalLine."Account Type"::"G/L Account";
        GenJournalLine."Account No." := '4002'; // Penalty Income Account - adjust as needed
        GenJournalLine.Amount := -LoanScheduleRec.Penalty;
        GenJournalLine.Description := 'Late Payment Penalty Income - ' + Loans."Loan  No.";
        GenJournalLine.Insert();
    end;
}