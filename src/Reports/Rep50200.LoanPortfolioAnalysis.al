report 50200 "Loan Portfolio Analysis"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = './Layout/LoanPortfolioAnalysis.rdlc';
    Caption = 'Loan Portfolio Analysis';

    dataset
    {
        dataitem("Members Register"; Customer)
        {
            RequestFilterFields = "No.", "Loan Product Filter", "Outstanding Balance", "Date Filter";
            DataItemTableView = sorting("No.");

            column(No_; "No.") { }
            column(Name; Name) { }
            column(PayrollStaffNo; "Payroll/Staff No") { }
            column(Phone_No; "Phone No.") { }
            column(Registration_Date; "Registration Date") { }
            column(Employer_Code; "Employer Code") { }
            column(Employer_Name; gEmployerName) { }
            column(PageNo; CurrReport.PAGENO) { }
            column(Shares_Retained; "Shares Retained") { }
            column(ID_No; "ID No.") { }
            column(Global_Dimension_2_Code; "Global Dimension 2 Code") { }
            column(CompanyName; gCompanyInfo.Name) { }
            column(CompanyAddress; gCompanyInfo.Address) { }
            column(CompanyAddress2; gCompanyInfo."Address 2") { }
            column(CompanyPhoneNo; gCompanyInfo."Phone No.") { }
            column(CompanyFaxNo; gCompanyInfo."Fax No.") { }
            column(CompanyPicture; gCompanyInfo.Picture) { }
            column(CompanyEmail; gCompanyInfo."E-Mail") { }
            column(UserID; USERID) { }

            dataitem(Loans; "Loans Register")
            {
                DataItemLink = "Client Code" = field("No.");
                DataItemTableView = sorting("Loan  No.") where(Posted = const(true), Reversed = const(false));

                column(LoanNumber; "Loan  No.") { }
                column(ProductType; "Loan Product Type Name") { }
                column(Amount_in_Arrears; "Amount in Arrears") { }
                column(Interest_In_Arrears; "Interest In Arrears") { }
                column(Principal_In_Arrears; "Principal In Arrears") { }
                column(Outstanding_Balance; "Outstanding Balance") { }
                column(Active_Loans; gActiveLoanCount) { }
                column(Interest_Earned; gInterestEarned) { }

                trigger OnAfterGetRecord()
                var
                    LoansReg: Record "Loans Register";
                    CustLedger: Record "Cust. Ledger Entry";
                begin
                    Clear(LoansReg);
                    Clear(CustLedger);

                    if GetFilter("Date Filter") <> '' then begin
                        gStartDate := GetRangeMin("Date Filter");
                        gEndDate := GetRangeMax("Date Filter");
                    end;

                    // Count active loans
                    gActiveLoanCount := 0;
                    LoansReg.SetRange("Loan Product Type", "Loan Product Type");
                    LoansReg.SetFilter("Outstanding Balance", '>0');
                    if LoansReg.FindSet() then
                        repeat
                            if LoansReg.Posted then
                                gActiveLoanCount += 1;
                        until LoansReg.Next() = 0;

                    // Calculate interest earned
                    gInterestEarned := 0;
                    CustLedger.SetRange("Customer No.", "Client Code");
                    CustLedger.SetRange("Document No.", "Loan  No.");
                    if gStartDate <> 0D then
                        CustLedger.SetRange("Posting Date", gStartDate, gEndDate);
                    CustLedger.SetFilter("Document Type", '%1|%2',
                        CustLedger."Document Type"::"Finance Charge Memo",
                        CustLedger."Document Type"::Invoice);
                    if CustLedger.FindSet() then
                        repeat
                            gInterestEarned += Abs(CustLedger.Amount);
                        until CustLedger.Next() = 0;
                    if CheckLoanDefaulted(Loans) then
                        UpdateLoanStatus(Loans);
                end;
            }

            trigger OnAfterGetRecord()
            var
                Employer: Record Customer;
            begin
                gEmployerName := '';
                if Employer.Get("Employer Code") then
                    gEmployerName := Employer.Name;
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(Options)
                {
                    field(StartDateField; gStartDate)
                    {
                        ApplicationArea = All;
                        Caption = 'Start Date';
                    }
                    field(EndDateField; gEndDate)
                    {
                        ApplicationArea = All;
                        Caption = 'End Date';
                    }
                }
            }
        }

        trigger OnOpenPage()
        begin
            if (gStartDate = 0D) then
                gStartDate := WORKDATE;
            if (gEndDate = 0D) then
                gEndDate := WORKDATE;
        end;

        trigger OnQueryClosePage(CloseAction: Action): Boolean
        begin
            if CloseAction = ACTION::OK then
                if (gStartDate > gEndDate) and (gStartDate <> 0D) and (gEndDate <> 0D) then begin
                    ERROR('Start Date must be before End Date');
                    exit(false);
                end;
            exit(true);
        end;
    }

    var
        gCompanyInfo: Record "Company Information";
        gEmployerName: Text[100];
        gStartDate: Date;
        gEndDate: Date;
        gActiveLoanCount: Integer;
        gInterestEarned: Decimal;

    local procedure CheckLoanDefaulted(LoanRec: Record "Loans Register"): Boolean
    begin
        exit(LoanRec."Amount in Arrears" > 0);
    end;

    local procedure UpdateLoanStatus(var LoanRec: Record "Loans Register")
    begin
        if LoanRec."Amount in Arrears" > 0 then begin
            // Mark loan as having arrears without changing status
            LoanRec."Principal In Arrears" := LoanRec."Amount in Arrears";
            LoanRec.Modify(true);
        end;
    end;

    trigger OnPreReport()
    begin
        gCompanyInfo.Get();
    end;
}
