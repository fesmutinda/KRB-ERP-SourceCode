report 50200 "Loan Portfolio Analysis"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = './Layout/LoanPortfolioAnalysis.rdlc';

    dataset
    {

        dataitem("Loan Products Setup"; "Loan Products Setup")
        {

            column(Code; Code) { }

            column(Product_Description; "Product Description") { }

            column(Interest_rate; "Interest rate") { }

            column(Total_Outstanding_Balance; ProductTotalOutstandingBalance) { }

            //arrears count
            column(Loans_in_Arrears; ProductLoansInArrears) { }

            column(Total_Arrears_Balance; ProductTotalArrearsBalance) { }

            column(TotalRepayments; ProductTotalRepayments) { }

            column(TotalInterestDue; ProductTotalInterestDue) { }

            column(TotalInterestEarned; TotalInterestEstimate) { }

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

                //CalculateProductTotalOutstandingBalance(Code);
                //CalculateExpectedInterest(Code);

                SetFilter("Date Filter", '%1..%2', StartDate, EndDate);

                ProductTotalRepayments := CalculateTotalProductRepayments(code, StartDate, EndDate);

                // CalcFields("Total Outstanding Balance");
                // ProductTotalOutstandingBalance := "Total Outstanding Balance";

                CalcFields(TotalInterestDue);
                ProductTotalInterestDue := TotalInterestDue;

                CalcFields("Total Arrears Balance");
                ProductTotalArrearsBalance := "Total Arrears Balance";


                CalcFields("Loans in Arrears");
                ProductLoansInArrears := "Loans in Arrears";


                TotalInterestEstimate := CalculateActualEarnedInterest(Code, ProductTotalRepayments, StartDate, EndDate)

            end;
        }
    }


    requestpage
    {

        layout
        {

            area(content)
            {

                group(options)
                {


                    field(StartDateField; StartDate)
                    {
                        ApplicationArea = All;
                        Caption = 'Start Date';
                    }
                    field(EndDateField; EndDate)
                    {
                        ApplicationArea = All;
                        Caption = 'End Date';
                    }


                }

            }
        }
    }


    trigger OnPreReport()
    begin
        CompanyInfo.Get();
        CompanyInfo.CalcFields(CompanyInfo.Picture);

        if EndDate = 0D then
            EndDate := WorkDate();

        if StartDate = 0D then
            StartDate := CalcDate('<-CY>', EndDate);

        if StartDate > EndDate then
            Error('Start Date cannot be later than End Date')
    end;



    var



        TotalInterestEstimate: Decimal;

        ProductTotalRepayments: Decimal;

        ProductTotalInterestDue: Decimal;

        ProductTotalOutstandingBalance: Decimal;

        ProductLoansInArrears: Integer;

        ProductTotalArrearsBalance: Decimal;
        StartDate: Date;
        EndDate: Date;

        AsAt: Date;
        CompanyInfo: Record "Company Information";


    local procedure CalculateActualEarnedInterest(ProductCode: Code[20]; TotalProductRepayments: Decimal; StartDate: Date; EndDate: Date): Decimal
    var
        recLoanRepaymentSchedule: Record "Loan Repayment Schedule";
        CustLedgerEntryRec: Record "Cust. Ledger Entry";
        ExpectedPrincipalRepayMents: Decimal;
    begin

        ExpectedPrincipalRepayMents := 0;


        recLoanRepaymentSchedule.SetRange("Loan Category", ProductCode);
        recLoanRepaymentSchedule.SetRange("Repayment Date", StartDate, EndDate);

        if recLoanRepaymentSchedule.FindSet() then begin

            repeat

                ExpectedPrincipalRepayMents += recLoanRepaymentSchedule."Principal Repayment";

            until recLoanRepaymentSchedule.Next() = 0;

        end;


        exit(TotalProductRepayments - ExpectedPrincipalRepayMents);


    end;


    local procedure CalculateTotalProductRepayments(ProductCode: Code[20]; StartDate: Date; EndDate: Date): Decimal
    var
        Total: Decimal;
        CustLedgerEntryRec: Record "Cust. Ledger Entry";

    begin

        Total := 0;

        CustLedgerEntryRec.SetRange("Loan product Type", ProductCode);

        CustLedgerEntryRec.SetRange("Posting Date", StartDate, EndDate);

        CustLedgerEntryRec.SetFilter("Transaction Type", 'Loan|Loan Repayment');

        if CustLedgerEntryRec.FindSet() then begin

            repeat

                CustLedgerEntryRec.CalcFields("Credit Amount");
                Total += CustLedgerEntryRec."Credit Amount";

            until CustLedgerEntryRec.Next() = 0;
        end;



        exit(total);

    end;

}
