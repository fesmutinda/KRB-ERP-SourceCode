#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 50225 "Member Share Capital Statement"
{
    ApplicationArea = All;
    Caption = 'Member Share Capital Statement';
    RDLCLayout = './Layouts/MemberShareCapitalStatement.rdl';
    UsageCategory = ReportsAndAnalysis;



    dataset
    {
        dataitem(Customer; Customer)
        {
            RequestFilterFields = "No.", "Loan Product Filter", "Outstanding Balance", "Date Filter";


            column(Phone_No_; "Phone No.")
            {

            }


            column(Payroll_Staff_No; "Payroll/Staff No")
            {
            }
            column(Employer_Name; "Employer Name")
            {
            }
            column(PayrollStaffNo_Members; "Payroll/Staff No")
            {
            }
            column(No_Members; "No.")
            {
            }
            column(MobilePhoneNo_MembersRegister; "Mobile Phone No")
            {
            }
            column(Name_Members; Name)
            {
            }
            column(EmployerCode_Members; "Employer Code")
            {
            }
            column(EmployerName; EmployerName)
            {
            }
            // column(PageNo_Members; CurrReport.PageNo)
            // {
            // }
            column(Registration_Date; "Registration Date")
            {
            }
            column(Shares_Retained; "Shares Retained")
            {
            }
            column(ShareCapBF; ShareCapBF)
            {
            }
            column(IDNo_Members; "ID No.")
            {
            }
            column(GlobalDimension2Code_Members; "Global Dimension 2 Code")
            {
            }
            column(Company_Name; Company.Name)
            {
            }
            column(Company_Address; Company.Address)
            {
            }
            column(Company_Picture; Company.Picture)
            {
            }

            column(Company_Phone; Company."Phone No.")
            {
            }
            column(Company_SMS; Company."Phone No.")
            {
            }
            column(Company_Email; Company."E-Mail")
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


            dataitem(Share; "Cust. Ledger Entry")
            {
                DataItemLink = "Customer No." = field("No."), "Posting Date" = field("Date Filter");
                DataItemTableView = sorting("Posting Date") where("Transaction Type" = const("Share Capital"), Reversed = filter(false));
                column(openBalances; OpenBalance)
                {
                }
                column(CLosingBalances; CLosingBalance)
                {
                }
                column(Description_Shares; Share.Description)
                {
                }
                column(DocumentNo_Shares; Share."Document No.")
                {
                }
                column(PostingDate_Shares; Share."Posting Date")
                {
                }
                column(CreditAmount_Shares; Share."Credit Amount")
                {
                }
                column(DebitAmount_Shares; Share."Debit Amount")
                {
                }
                column(Amount_Shares; Share.Amount) //"Amount Posted"
                {
                }
                column(TransactionType_Shares; Share."Transaction Type")
                {
                }
                column(Shares_Description; Share.Description)
                {
                }
                column(BalAccountNo_Shares; Share."Bal. Account No.")
                {
                }
                column(BankCodeShares; BankCodeShares)
                {
                }
                column(USER1; Share."User ID")
                {
                }

                trigger OnAfterGetRecord()
                begin
                    CLosingBalance := CLosingBalance - Share.Amount;
                    BankCodeShares := GetBankCode(Share);
                    //...................................
                    if Share.Amount < 0 then begin
                        Share."Credit Amount" := (Share.Amount * -1);
                    end else
                        if Share.Amount > 0 then begin
                            Share."Debit Amount" := (Share.Amount);
                        end;
                end;

                trigger OnPreDataItem()
                begin
                    CLosingBalance := ShareCapBF;
                    OpenBalance := ShareCapBF;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                SaccoEmp.Reset;
                SaccoEmp.SetRange(SaccoEmp.Code, "Employer Code");
                if SaccoEmp.Find('-') then
                    EmployerName := SaccoEmp.Description;

                HolidayBF := 0;
                SharesBF := 0;
                InsuranceBF := 0;
                ShareCapBF := 0;
                RiskBF := 0;
                HseBF := 0;
                Dep1BF := 0;
                Dep2BF := 0;
                if DateFilterBF <> '' then begin
                    BFCust.Reset;
                    BFCust.SetRange("No.", "No.");
                    BFCust.SetFilter("Date Filter", DateFilterBF);
                    if BFCust.Find('-') then begin
                        BFCust.CalcFields("Shares Retained");
                        ShareCapBF := BFCust."Shares Retained";
                    end;
                end;
            end;

            trigger OnPreDataItem()
            begin
                if Customer.GetFilter("Date Filter") <> '' then
                    DateFilterBF := '..' + Format(CalcDate('-1D', Customer.GetRangeMin("Date Filter")));

                if (StartDate <> 0D) and (EndDate <> 0D) then
                    Customer.SetFilter("Date Filter", Format(StartDate) + '..' + Format(EndDate));
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(content)
            {
                group(DateRange)
                {
                    Caption = 'Date Range';
                    field(StartDate; StartDate)
                    {
                        ApplicationArea = All;
                        Caption = 'Start Date';
                        ToolTip = 'Select the start date for the report.';
                    }
                    field(EndDate; EndDate)
                    {
                        ApplicationArea = All;
                        Caption = 'End Date';
                        ToolTip = 'Select the end date for the report.';
                    }
                }
            }
        }
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        Company.Get();
        Company.CalcFields(Company.Picture);
    end;

    var
        OpenBalance: Decimal;
        CLosingBalance: Decimal;
        OpenBalanceXmas: Decimal;
        CLosingBalanceXmas: Decimal;
        Cust: Record "Cust. Ledger Entry";
        OpeningBal: Decimal;
        ClosingBal: Decimal;
        FirstRec: Boolean;
        PrevBal: Integer;
        BalBF: Decimal;
        BFCust: Record Customer;
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
        OpenBalanceLoan: Decimal;
        ClosingBalanceLoan: Decimal;
        BankCodeShares: Text;
        BankCodeDeposits: Text;
        BankCodeDividend: Text;
        BankCodeRisk: Text;
        BankCodeInsurance: Text;
        BankCodeLoan: Text;
        BankCodeInterest: Text;
        HolidayBF: Decimal;
        BankCodeHoliday: Code[50];
        ClosingBalHoliday: Decimal;
        OpeningBalHoliday: Decimal;
        BankCodeFOSAShares: Code[50];
        ClosingBalanceFOSAShares: Decimal;
        OpenBalanceFOSAShares: Decimal;
        OpenBalancesPepeaShares: Decimal;
        ClosingBalancePepeaShares: Decimal;
        BankCodePepeaShares: Code[50];
        OpenBalancesVanShares: Decimal;
        ClosingBalanceVanShares: Decimal;
        BankCodeVanShares: Code[50];
        ApprovedAmount_Interest: Decimal;
        LonRepaymentSchedule: Record "Loan Repayment Schedule";
        ClosingBalanceShareCap: Decimal;
        OpenBalanceDeposits: Decimal;
        ClosingBalanceDeposits: Decimal;
        StartDate: Date;
        EndDate: Date;


    local procedure GetBankCode(MembLedger: Record "Cust. Ledger Entry"): Text
    var
        BankLedger: Record "Bank Account Ledger Entry";
    begin
        BankLedger.Reset;
        BankLedger.SetRange("Posting Date", MembLedger."Posting Date");
        BankLedger.SetRange("Document No.", MembLedger."Document No.");
        if BankLedger.FindFirst then
            exit(BankLedger."Bank Account No.");
        exit('');
    end;
}

