#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 50226 "Loans Guaranteed"
{
    ApplicationArea = all;
    RDLCLayout = './Layouts/LoansGuaranteed.rdl';
    UsageCategory = ReportsAndAnalysis;
    Caption = 'Loans Guaranteed Report';

    dataset
    {
        dataitem(Customer; Customer)
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.";
            // column(ReportForNavId_7301; 7301)
            // {
            // }
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

            column(No_Members; Customer."No.")
            {
            }
            column(Name_Members; Customer.Name)
            {
            }
            column(CurrentShares_Members; Customer."Current Shares")
            {
            }
            column(Status_Members; Customer.Status)
            {
            }
            dataitem("Loan Guarantors"; "Loans Guarantee Details")
            {
                DataItemLink = "Member No" = field("No.");
                DataItemTableView = where("Outstanding Balance" = filter(> 0), Substituted = FILTER(false));
                //RequestFilterFields = Substituted, "Amont Guaranteed";
                RequestFilterFields = "Member No", "Loan No";

                column(LoanNo_LoanGuarantors; "Loan Guarantors"."Loan No")
                {
                }
                column(Loan_Product; "Loan Guarantors"."Loan Product")
                {
                }
                column(MemberNo_LoanGuarantors; "Loan Guarantors"."Member No")
                {
                }
                column(Name_LoanGuarantors; "Loan Guarantors".Name)
                {
                }

                column(AmontGuaranteed_LoanGuarantors; "Loan Guarantors"."Amont Guaranteed")
                {
                }
                column(LoanBalance_LoanGuarantors; "Loan Guarantors"."Loans Outstanding")
                {
                }
                column(Shares_LoanGuarantors; "Loan Guarantors".Shares)
                {
                }
                column(NoOfLoansGuaranteed_LoanGuarantors; "Loan Guarantors"."No Of Loans Guaranteed")
                {
                }
                column(Substituted_LoanGuarantors; "Loan Guarantors".Substituted)
                {
                }
                column(Date_LoanGuarantors; "Loan Guarantors".Date)
                {
                }
                column(SharesRecovery_LoanGuarantors; "Loan Guarantors"."Shares Recovery")
                {
                }
                column(NewUpload_LoanGuarantors; "Loan Guarantors"."New Upload")
                {
                }

                column(StaffPayrollNo_LoanGuarantors; "Loan Guarantors"."Staff/Payroll No.")
                {
                }
                column(AccountNo_LoanGuarantors; "Loan Guarantors"."Account No.")
                {
                }
                column(SelfGuarantee_LoanGuarantors; "Loan Guarantors"."Self Guarantee")
                {
                }
                column(IDNo_LoanGuarantors; "Loan Guarantors"."ID No.")
                {
                }
                column(OutstandingBalance_LoanGuarantors; "Loan Guarantors"."Outstanding Balance")
                {
                }
                // column(MemberGuaranteed_LoanGuarantors; "Loan Guarantors"."Transferable shares")
                // {
                // }
                column(MemberGuar; MemberGuar)
                {
                }
                column(MemberNo; MemberNo)
                {
                }
                column(DuePeriod; Period)
                {
                }
                dataitem("Loans Register"; "Loans Register")
                {
                    DataItemLink = "Loan  No." = field("Loan No");
                    DataItemTableView = sorting("Loan  No.") order(ascending) where(Posted = const(true));
                    /* column(ReportForNavId_1120054000; 1120054000)
                    {
                    } */
                    column(ClientCode_LoansRegister; "Loans Register"."Client Code")
                    {
                    }
                    column(ClientName_LoansRegister; "Loans Register"."Client Name")
                    {
                    }
                    column(OutstandingBalance_LoansRegister; "Loans Register"."Outstanding Balance")
                    {
                    }
                    column(ApprovedAmount_LoansRegister; "Loans Register"."Approved Amount")
                    {
                    }
                    column(EmployerCode_LoansRegister; "Loans Register"."Employer Code")
                    {
                    }

                    column(Repay_Count; "Repay Count") { }

                    column(Loan_Product_Type_Name; "Loan Product Type Name") { }

                    column(RemainingRepayment; RemainingRepayment) { }
                }

                trigger OnAfterGetRecord()
                var
                    LoanSchedule: Record "Loan Repayment Schedule";
                begin
                    Shares := 0;
                    RemainingRepayment := 0;

                    // Use "Loan Guarantors"."Loan No" instead of "Loans Register"."Loan  No."
                    if Loans.Get("Loan Guarantors"."Loan No") then begin
                        Loans.CalcFields(Loans."Outstanding Balance");
                        MemberGuar := Loans."Client Name";
                        MemberNo := Loans."Client Code";

                        if Loans."Issued Date" <> 0D then begin
                            expected := ROUND((Currdate - Loans."Issued Date") / 30, 1.0, '<');
                            Period := Loans.Installments - expected;
                        end;

                        if Cust.Get(Customer."No.") then begin
                            Cust.CalcFields(Cust."Current Shares");
                            Shares := -1 * Cust."Current Shares";
                        end;

                        // Use the Loans record data instead of "Loans Register" 
                        // LoanSchedule.SetRange("Loan No.", Loans."Loan  No.");
                        // LoanSchedule.SetRange("Loan Balance", Loans."Outstanding Balance");

                        // if LoanSchedule.FindFirst() then begin
                        //     RemainingRepayment := Loans.Installments - LoanSchedule."Instalment No";
                        // end;

                        RemainingRepayment := FnCalculateLoanRemainingPeriod(
                            Loans."Outstanding Balance",
                            Loans."Approved Amount",
                            Loans.Installments,
                            Loans.Interest
                        );
                    end;
                end;

                trigger OnPreDataItem()
                begin
                    if (StartDate <> 0D) and (EndDate <> 0D) then
                        "Loan Guarantors".SetFilter("Date", Format(StartDate) + '..' + Format(EndDate));
                end;
            }
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
        if Customer."Date Filter" = 0D then begin
            Currdate := Today
        end
        else begin
            Currdate := Customer."Date Filter";
        end;

        Company.Get();
        Company.CalcFields(Company.Picture);

    end;

    var
        Loans: Record "Loans Register";
        Cust: Record Customer;
        Shares: Decimal;
        Cust2: Record Customer;
        LoanGaurantors: Record "Loans Guarantee Details";
        LCount: Integer;
        A: Decimal;
        T: Decimal;
        LoanApps: Record "Loans Register";
        Lamount: Decimal;
        LGBalance: Decimal;
        "Account No": Code[10];
        Loan_GuaranteedCaptionLbl: label 'Loan Guaranteed';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        Personal_No_CaptionLbl: label 'Personal No.';
        NameCaptionLbl: label 'Name';
        Oustanding_BalanceCaptionLbl: label 'Oustanding Balance';
        Loan_AmountCaptionLbl: label 'Loan Amount';
        Current_SharesCaptionLbl: label 'Current Shares';
        Staff_No_CaptionLbl: label 'Staff No.';
        Loan_TypeCaptionLbl: label 'Loan Type';
        Total_DepositsCaptionLbl: label 'Total Deposits';
        MNo_CaptionLbl: label 'MNo.';
        MemberGuar: Text;
        MemberNo: Code[10];
        "No.LoansGuaranteed": Integer;
        Guar: Record "Loans Guarantee Details";
        Period: Decimal;
        expected: Decimal;
        Currdate: Date;
        Company: Record "Company Information";

        RemainingRepayment: Decimal;
        Amortized: Boolean;
        TotalGuaranteed: Decimal;
        GuaBalance: Decimal;
        StartDate: Date;
        EndDate: Date;

    procedure FnCalculateLoanRemainingPeriod(
    LoanOutstandingBalance: Decimal;
    OriginalAmount: Decimal;
    TotalInstallments: Integer;
    InterestRate: Decimal): Integer
    var
        RemainingPeriods: Integer;
        MonthlyInterestRate: Decimal;
        MonthlyPayment: Decimal;
        Numerator: Decimal;
        Denominator: Decimal;
    begin

        if (LoanOutstandingBalance <= 0) or (OriginalAmount <= 0) or (TotalInstallments <= 0) then
            exit(0);

        if LoanOutstandingBalance >= OriginalAmount then
            exit(TotalInstallments);

        // Handle zero interest rate loans
        if InterestRate = 0 then begin
            RemainingPeriods := Round((LoanOutstandingBalance / OriginalAmount) * TotalInstallments, 1, '>');
            exit(RemainingPeriods);
        end;


        MonthlyInterestRate := InterestRate / 12 / 100;

        MonthlyPayment := OriginalAmount *
            (MonthlyInterestRate * Power(1 + MonthlyInterestRate, TotalInstallments)) /
            (Power(1 + MonthlyInterestRate, TotalInstallments) - 1);


        if MonthlyPayment > 0 then begin
            RemainingPeriods := Round(LoanOutstandingBalance / MonthlyPayment, 1, '>');

            // Adjust for interest effect (loans with interest need fewer periods than simple division)
            if MonthlyInterestRate > 0 then begin
                // Apply a correction factor based on interest rate
                // Higher interest rates mean more of each payment goes to interest initially
                RemainingPeriods := Round(RemainingPeriods * 0.95, 1, '>'); // Reduce by ~5%
            end;
        end else begin
            RemainingPeriods := Round((LoanOutstandingBalance / OriginalAmount) * TotalInstallments, 1, '>');
        end;

        if RemainingPeriods > TotalInstallments then
            RemainingPeriods := TotalInstallments;
        if RemainingPeriods < 0 then
            RemainingPeriods := 0;

        exit(RemainingPeriods);
    end;
}


