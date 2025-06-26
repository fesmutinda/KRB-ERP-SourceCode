Report 50014 "Loan Arrears Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Loan Arrears Report.rdlc';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem(Loans; "Loans Register")
        {
            DataItemTableView = where(Posted = const(true));
            RequestFilterFields = Source, "Loan Product Type", "Issued Date";
            column(Counting; Counting)
            {
            }
            column(Client_Name; "Client Name")
            {
            }
            column(ReportForNavId_1000000000; 1000000000)
            {
            }
            column(BranchCode_Loans; Loans."Branch Code")
            {
            }
            column(EmployerCode_Loans; Loans."Employer Code")
            {
            }
            column(LoanProductType_Loans; Loans."Loan Product Type Name")
            {
            }
            column(LoanNo_Loans; Loans."Loan  No.")
            {
            }
            column(ApplicationDate_Loans; Loans."Application Date")
            {
            }
            column(ClientCode_Loans; Loans."Client Code")
            {
            }
            column(GroupCode_Loans; Loans."Group Code")
            {
            }
            column(Source_Loans; Loans.Source)
            {
            }
            column(RequestedAmount_Loans; "Loans"."Requested Amount")
            {
            }
            column(ApprovedAmount_Loans; "Loans"."Approved Amount")
            {
            }
            column(OustandingInterest_Loans; "Loans"."Oustanding Interest")
            {
            }
            column(OutstandingBalance_Loans; "Loans"."Outstanding Balance")
            {
            }
            column(IssuedDate_Loans; "Loans"."Issued Date")
            {
            }
            column(Amount_in_Arrears; LoanARREARS)
            {
            }
            column(No_of_Months_in_Arrears; "No of Months in Arrears")
            {
            }
            column(Principal_In_Arrears; "Principal In Arrears")
            {
            }
            column(Interest_In_Arrears; "Interest In Arrears")
            {
            }
            column(Month; Month)
            {
            }

            column(Company_Name; CompanyInfo.Name)
            {
            }
            column(Company_Address; CompanyInfo.Address)
            {
            }
            column(Company_Address_2; CompanyInfo."Address 2")
            {
            }
            column(Company_Phone_No; CompanyInfo."Phone No.")
            {
            }
            column(Company_Fax_No; CompanyInfo."Fax No.")
            {
            }
            column(Company_Picture; CompanyInfo.Picture)
            {
            }
            column(Company_Email; CompanyInfo."E-Mail")
            {
            }



            trigger OnAfterGetRecord()
            begin
                Counting := Counting + 1;
                ClientBranchCode := '';



                ScheduleBalance := 0;

                if LoanSetup.Get(Loans."Loan Product Type") then
                    LoanName := LoanSetup."Product Description";

                if DateFilterBF <> '' then begin
                    LoansR.Reset();
                    LoansR.SetRange(LoansR."Loan  No.", Loans."Loan  No.");
                    LoansR.SetFilter(LoansR."Date filter", DateFilterBF);

                    if LoansR.Find('-') then begin
                        LoansR.CalcFields(LoansR."Outstanding Balance", LoansR."Oustanding Interest");
                        PrincipleBF := LoansR."Outstanding Balance";
                        InterestBF := LoansR."Oustanding Interest";
                    end;
                end;

                Loans.CalcFields("Outstanding Balance", "Oustanding Interest");
                DueDate := CalcDate(Format(Loans.Installments) + 'M', Loans."Issued Date");

                if (Loans."Outstanding Balance" + Loans."Oustanding Interest") <= 0 then
                    CurrReport.Skip;

                LoanRepaymentSchedule.Reset();
                LoanRepaymentSchedule.SetRange("Loan No.", Loans."Loan  No.");
                LoanRepaymentSchedule.SetFilter("Repayment Date", '<=%1', Today);

                if LoanRepaymentSchedule.FindLast() then begin
                    ScheduleBalance := LoanRepaymentSchedule."Loan Balance";
                end;
                // Correct Calculation of Amount in Arrears
                LoanArrears := Loans."Oustanding Interest" + (Loans."Outstanding Balance" - ScheduleBalance);

                // Add after your LoanArrears calculation
                if (LoanArrears > 0) and (Loans.Repayment > 0) then
                    "No of Months in Arrears" := Round(LoanArrears / Loans.Repayment, 1, '<')
                else
                    "No of Months in Arrears" := 0;


                if LoanArrears < 0 then
                    LoanArrears := 0;

                //       Message('Amount in ARREars %1, Schedule balance of %2, Approved amount %3, outstanding interest', LoanArrears, ScheduleBalance, Loans."Approved Amount", Loans."Oustanding Interest");

                // Pass 1: Reset all fields to 0 for this loan
                LoansR.Reset();
                LoansR.SetRange("Loan  No.", Loans."Loan  No.");

                if LoansR.FindSet() then
                    repeat
                        LoansR."Amount in Arrears" := 0;
                        LoansR."Oustanding Interest" := 0;
                        LoansR.Modify();
                    until LoansR.Next() = 0;

                // Pass 2: Update relevant record(s) with correct arrears
                LoansR.Reset();
                LoansR.SetRange("Loan  No.", Loans."Loan  No.");
                // Optionally add filters to update only the most recent record if needed

                if LoansR.FindSet() then
                    repeat
                        LoansR."Amount in Arrears" := LoanArrears;
                        LoansR."Oustanding Interest" := Loans."Oustanding Interest";
                        LoansR.Modify();
                    until LoansR.Next() = 0;


                DefaultNotices.Reset();
                DefaultNotices.SetRange("Loan In Default", Loans."Loan  No.");
                if DefaultNotices.FindLast() then begin
                    DefaultNotices."Amount in Arrears" := LoanArrears;
                    DefaultNotices."Outstanding Interest" := Loans."Oustanding Interest";
                    DefaultNotices.Modify();
                    COMMIT;
                end;
                // Message('DefaultNotices AMount in arrears %1', DefaultNotices."Amount In Arrears");



            end;

            trigger OnPreDataItem()
            begin
                CompanyInfo.Get;
                CompanyInfo.CalcFields(CompanyInfo.Picture);
                Counting := 0;

            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        Month: Integer;
        CompanyInfo: Record "Company Information";
        Counting: integer;
        ClientBranchCode: code[100];

        SwizzsoftFactory: Codeunit 50007;

        DefaultNotices: Record "Default Notices Register";
        OpenBalance: Decimal;
        CLosingBalance: Decimal;
        OpenBalanceXmas: Decimal;
        CLosingBalanceXmas: Decimal;
        Cust: Record Customer;
        OpeningBal: Decimal;
        ClosingBal: Decimal;
        FirstRec: Boolean;
        PrevBal: Integer;
        BalBF: Decimal;
        LoansR: Record "Loans Register";
        DateFilterBF: Text[150];
        SharesBF: Decimal;
        InsuranceBF: Decimal;
        LoanBF: Decimal;
        PrincipleBF: Decimal;
        InterestBF: Decimal;
        ShowZeroBal: Boolean;
        ClosingBalSHCAP: Decimal;
        ShareCapBF: Decimal;
        RiskBF: Decimal;
        DividendBF: Decimal;
        Company: Record "Company Information";
        OpenBalanceHse: Decimal;
        CLosingBalanceHse: Decimal;
        OpenBalanceDep1: Decimal;
        CLosingBalanceDep1: Decimal;
        OpenBalanceDep2: Decimal;
        CLosingBalanceDep2: Decimal;
        HseBF: Decimal;
        Dep1BF: Decimal;
        Dep2BF: Decimal;
        OpeningBalInt: Decimal;
        ClosingBalInt: Decimal;
        InterestPaid: Decimal;
        SumInterestPaid: Decimal;
        OpenBalanceRisk: Decimal;
        CLosingBalanceRisk: Decimal;
        OpenBalanceDividend: Decimal;
        ClosingBalanceDividend: Decimal;
        OpenBalanceHoliday: Decimal;
        ClosingBalanceHoliday: Decimal;
        LoanSetup: Record "Loan Products Setup";
        LoanName: Text[50];
        SaccoEmp: Record "Sacco Employers";
        EmployerName: Text[100];
        LoanArrears: Decimal;
        LoanRepaymentSchedule: Record "Loan Repayment Schedule";
        TotalArrears: Decimal;
        ScheduleBalance: Decimal;
        DueDate: Date;
}

