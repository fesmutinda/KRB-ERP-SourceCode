namespace KRBERPSourceCode.KRBERPSourceCode;
using Microsoft.Foundation.Company;

report 59067 "Loan Disbursement Voucher"
{
    ApplicationArea = All;
    Caption = 'Loan Disbursement Voucher';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/LoanDisbursementVoucher.rdlc';
    dataset
    {
        dataitem(LoansRegister; "Loans Register")
        {
            DataItemTableView = sorting("Loan  No.");
            RequestFilterFields = "Loan  No.";

            column(LoanApplied; "Approved Amount") { }
            column(InsuranceDeduction; "Loan Insurance") { }
            column(OutstandingBalance; "Outstanding Balance") { }
            column(PayingBankAccountNo; "Paying Bank Account No") { }
            column(ClientCode; "Client Code") { }
            column(ClientName; "Client Name") { }
            column(DisbursedAmt; "Disbursed Amt") { }
            column(DisbursedBy; "Disbursed By") { }
            column(DisbursementStatus; "Disbursement Status") { }
            column(LoanNo; "Loan  No.") { }
            column(Loan_Product_Type_Name; "Loan Product Type Name") { }
            column(LoanDisbursedAmount; "Loan Disbursed Amount") { }
            column(LoanDisbursementDate; "Loan Disbursement Date") { }
            column(ApprovedAmount; "Approved Amount") { }
            column(total_fees_and_commisions; Upfronts) { }
            column(total_deductions; total_deductions) { }
            column(Netdisbursed; Netdisbursed) { }
            column(USERID; UserId) { }
            column(Company_Name; CompanyInfo.Name) { }
            column(Company_Address; CompanyInfo.Address) { }
            column(Company_Address_2; CompanyInfo."Address 2") { }
            column(Company_Phone_No; CompanyInfo."Phone No.") { }
            column(Company_Fax_No; CompanyInfo."Fax No.") { }
            column(Company_Picture; CompanyInfo.Picture) { }
            column(Company_Email; CompanyInfo."E-Mail") { }

            column(NetdisbursedInWords; FormatAmount(Netdisbursed)) { }

            dataitem("Loan Offset Details"; "Loan Offset Details")
            {
                DataItemLink = "Loan No." = field("Loan  No.");
                DataItemTableView = where("Principle Top Up" = filter(> 0));

                column(ReportForNavId_4717; 4717) { }
                column(Loans_Top_Up_OutstandingBal; "Outstanding Balance") { }
                column(Loans_Top_up__Principle_Top_Up_; "Principle Top Up") { }
                column(Loans_Top_up__Loan_Type_; "Loan Type") { }
                column(Loans_Top_up__Client_Code_; "Client Code") { }
                column(Loans_Top_up__Loan_No__; "Loan No.") { }
                column(Loans_Top_up__Total_Top_Up_; "Total Top Up") { }
                column(Loans_Top_up__Interest_Top_Up_; "Interest Top Up") { }
                column(Loan_Type; "Loan Offset Details"."Loan Type") { }
                column(Loans_Top_up_Commision; Commision) { }
                column(Loans_Top_up__Principle_Top_Up__Control1102760116; "Principle Top Up") { }
                column(Loans_Top_up__Total_Top_Up__Control1102755050; "Total Top Up") { }
                column(Loans_Top_up_Commision_Control1102755053; Commision) { }
                column(Loans_Top_up__Interest_Top_Up__Control1102755055; "Interest Top Up") { }
                column(Loans_Top_up_CommisionCaption; FieldCaption(Commision)) { }
                column(Loans_Top_up_Loan_Top_Up; "Loan Top Up") { }
                column(LoanoffsetInterest; "Loan Offset Details".Commision) { }

                trigger OnPreDataItem()
                begin
                    TotalTopUpDeductions := 0;
                end;

                trigger OnAfterGetRecord()
                begin
                    // Accumulate totals (don't reset here!)
                    TotalTopUpDeductions += "Principle Top Up" + "Interest Top Up" + Commision;
                end;
            }

            trigger OnPreDataItem()
            begin
                NetDisbursed := 0;
                Upfronts := 0;
            end;

            trigger OnAfterGetRecord()
            begin
                if "Approved Amount" > 0 then begin
                    Upfronts := "Facilitation Cost" + "Valuation Cost";
                    total_deductions := Upfronts + TotalTopUpDeductions + "Loan Insurance";
                    Netdisbursed := "Approved Amount" - total_deductions;
                end;
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                }
            }
        }
        actions
        {
            area(Processing)
            {
            }
        }
    }

    var
        CompanyInfo: Record "Company Information";
        TotalTopUpDeductions: Decimal;
        NetDisbursed: Decimal;
        total_deductions: Decimal;
        Upfronts: Decimal;


    local procedure FormatAmount(Amount: Decimal): Text
    begin
        exit(Format(Amount, 0, '<Sign><Integer Thousand><Decimals,3>') + ' Only');
    end;

    trigger OnPreReport()
    begin
        CompanyInfo.Get();
    end;
}