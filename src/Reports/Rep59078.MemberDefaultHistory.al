Report 59078 "Member Arrear History"
{
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;

    RDLCLayout = './Layout/MemberArrearHistory.rdlc';

    dataset
    {
        dataitem(Member; "Customer")
        {
            RequestFilterFields = "No.", "Loan Product Filter", "Outstanding Balance";

            column(USERID; UserId) { }
            column(PayrollStaffNo_Members; Member."Payroll/Staff No") { }
            column(No_Members; Member."No.") { }
            column(Name_Members; Member.Name) { }
            column(Phone_No_; "Phone No.") { }
            column(Registration_Date; "Registration Date") { }
            column(EmployerCode_Members; Member."Employer Code") { }
            //  column(EmployerName; EmployerName) { }
            column(PageNo_Members; CurrReport.PageNo) { }
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

            column(Company_Phone_No; Company."Phone No.") { }

            column(Company_Email; Company."E-Mail")
            {
            }

            column(Company_Address_2; Company."Address 2") { }

            column(Company_Fax_No; Company."Fax No.") { }

            column(Company_SMS; Company."Phone No.")
            {
            }

            column(IDNo_Members; Member."ID No.") { }




            dataitem(Loans; "Loans Register")
            {
                DataItemLink = "Client Code" = field("No."), "Date filter" = field("Date Filter"), "Loan Product Type" = field("Loan Product Filter");
                DataItemTableView = sorting("Loan  No.") where(Posted = const(true), "Outstanding Balance" = filter('>0'), Reversed = const(false));


                column("LoanNo"; "Loan  No.")
                {
                }

                column("LoanProductType"; "Loan Product Type")
                {
                }

                column(Loan_Product_Type_Name; "Loan Product Type Name")
                {

                }

                dataitem(LoanRepaymentSchedule; "Loan Repayment Schedule")
                {
                    //DataItemLink = "Member No." = field("No."), "Loan Category" = field("Loan Product Filter");
                    //DataItemTableView = SORTING("Member No.", "Loan No.");
                    DataItemLink = "Member No." = field("Client Code"), "Loan No." = field("Loan  No."), "Repayment Date" = field("Date filter");
                    DataItemTableView = sorting("Repayment Date");

                    column(InstallmentNo; "Instalment No")
                    {
                    }

                    column("DueDate"; "Repayment Date")
                    {
                    }
                    column("AmountDue"; "Monthly Repayment")
                    {
                    }

                    column("AmountPaid"; AmountPaid)
                    {
                    }

                    column(Arrears; AmountInArrears)
                    {
                    }

                    column(Penalty; Penalty)
                    {

                    }

                    column(ExpectedLoanBalance; ExpectedLoanBalance)
                    {

                    }

                    column(ActualLoanBalance; ActualLoanBalance)
                    {

                    }

                    trigger OnPreDataItem()
                    begin
                        SetRange("Repayment Date", 0D, Today);
                    end;

                    trigger OnAfterGetRecord()
                    var
                        LoanRegister: Record "Loans Register";
                        LoanLedgerEntry: Record "Cust. Ledger Entry";
                        StartDate: Date;

                    begin

                        AmountInArrears := 0;
                        LoanRepayDate := LoanRepaymentSchedule."Repayment Date";
                        ActualLoanBalance := 0;
                        Penalty := 0;
                        ExpectedLoanBalance := 0;
                        AmountPaid := 0;

                        StartDate := DMY2Date(1, Date2DMY(LoanRepaymentSchedule."Repayment Date", 2), Date2DMY(LoanRepaymentSchedule."Repayment Date", 3));
                        ExpectedLoanBalance := LoanRepaymentSchedule."Loan Balance";



                        LoanLedgerEntry.Reset();
                        LoanLedgerEntry.SetRange(LoanLedgerEntry."Customer No.", LoanRepaymentSchedule."Member No.");
                        LoanLedgerEntry.SetRange(LoanLedgerEntry."Loan No", LoanRepaymentSchedule."Loan No.");
                        //LoanLedgerEntry.SetFilter("Posting Date", '<=%1', LoanRepayDate);
                        LoanLedgerEntry.SetRange("Posting Date", StartDate, LoanRepayDate);
                        LoanLedgerEntry.SetFilter("Transaction Type", '%1|%2|%3|%4|%5|%6|%7', LoanLedgerEntry."Transaction Type"::"Loan Repayment", LoanLedgerEntry."Transaction Type"::"Interest Paid", LoanLedgerEntry."Transaction Type"::Loan, LoanLedgerEntry."Transaction Type"::"Interest Due", LoanLedgerEntry."Transaction Type"::"Loan Transfer Charges", LoanLedgerEntry."Transaction Type"::"Penalty Charged", LoanLedgerEntry."Transaction Type"::"Penalty Paid");



                        if LoanLedgerEntry.FindSet() then begin
                            repeat
                                LoanLedgerEntry.CalcFields("Credit Amount");
                                AmountPaid += LoanLedgerEntry."Credit Amount";
                                ActualLoanBalance += LoanLedgerEntry."Amount Posted";
                            until LoanLedgerEntry.Next() = 0;
                        end;

                        // if ActualLoanBalance > ExpectedLoanBalance then begin
                        //     AmountInArrears := ActualLoanBalance - ExpectedLoanBalance;
                        //     Penalty := Round(0.05 * AmountInArrears, 1, '>');
                        if AmountPaid < LoanRepaymentSchedule."Monthly Repayment" then begin
                            AmountInArrears := LoanRepaymentSchedule."Monthly Repayment" - AmountPaid;
                            Penalty := Round(0.05 * AmountInArrears, 1, '>');
                        end;
                    end;
                }

            }
        }
    }


    trigger OnPreReport()
    begin
        Company.Get();
        Company.CalcFields(Company.Picture);
    end;


    var

        AmountPaid: Decimal;

        AmountInArrears: Decimal;

        LoanRepayDate: Date;

        ExpectedLoanBalance: Decimal;

        ActualLoanBalance: Decimal;

        Penalty: Decimal;

        Company: Record "Company Information";




}