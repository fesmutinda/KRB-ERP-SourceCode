#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 56504 "Members Loans Guarantors"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layout/Members Loans Guarantors.rdlc';

    dataset
    {
        dataitem("Members Register"; Customer)
        {
            RequestFilterFields = "No.", Name, "FOSA Account No.";
            column(ReportForNavId_1000000000; 1000000000)
            {
            }
            column(FORMAT_TODAY_0_4_; Format(Today, 0, 4))
            {
            }
            column(COMPANYNAME; COMPANYNAME)
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
            column(CurrReport_PAGENO; CurrReport.PageNo)
            {
            }
            column(USERID; UserId)
            {
            }
            column(No_Members; "Members Register"."No.")
            {
            }
            column(Name_Members; "Members Register".Name)
            {
            }
            column(PhoneNo_Members; "Members Register"."Phone No.")
            {
            }
            column(OutstandingBalance_Members; "Members Register"."Outstanding Balance")
            {
            }
            column(FNo; FNo)
            {
            }
            dataitem("Loans Guarantee Details"; "Loans Guarantee Details")
            {
                DataItemLink = "Loanees  No" = field("No.");
                DataItemTableView = where("Outstanding Balance" = filter(<> 0), Substituted = filter(false));
                RequestFilterFields = "Member No", "Loan No";
                column(ReportForNavId_1000000001; 1000000001)
                {
                }
                column(AmontGuaranteed_LoanGuarantors; "Loans Guarantee Details"."Amont Guaranteed")
                {
                }
                column(NoOfLoansGuaranteed_LoanGuarantors; "Loans Guarantee Details"."No Of Loans Guaranteed")
                {
                }
                column(Name_LoanGuarantors; "Loans Guarantee Details".Name)
                {
                }
                column(MemberNo_LoanGuarantors; "Loans Guarantee Details"."Member No")
                {
                }
                column(LoanNo_LoanGuarantors; "Loans Guarantee Details"."Loan No")
                {
                }
                column(EntryNo; EntryNo)
                {
                }
                column(OutStandingBal; "Loans Guarantee Details"."Outstanding Balance")
                {
                }
                column(TotalOutstandingBal; TotalOutstandingBal)
                {
                }
                column(EmployerCode; EmployerCode)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    //Loan.GET();

                    Loansr.Reset;
                    Loansr.SetRange(Loansr."Loan  No.", "Loan No");

                    if Loansr.Find('-') then begin

                        Loansr.CalcFields("Outstanding Balance", "Oustanding Interest");
                        MemberNo := Loansr."Client Code";
                        MemberName := Loansr."Client Name";
                        EmployerCode := Loansr."Employer Code"


                    end;
                end;
            }

            trigger OnAfterGetRecord()
            begin

                //Members.CALCFIELDS(Members."Outstanding Balance",Members."Current Shares",Members."Loans Guaranteed");
                //AvailableSH:=Members."Current Shares"-Members."Loans Guaranteed";

                FNo := FNo + 1;
            end;

            trigger OnPreDataItem()
            begin
                LastFieldNo := FieldNo("No.");
                Company.Get();
                Company.CalcFields(Company.Picture);
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
        LastFieldNo: Integer;
        FooterPrinted: Boolean;
        AvailableSH: Decimal;
        MemberNo: Text;
        MemberName: Text;
        EmployerCode: Text;
        Loansr: Record "Loans Register";
        EntryNo: Integer;
        TotalOutstandingBal: Decimal;
        OutStandingBal: Decimal;
        FNo: Integer;
        Company: Record "Company Information";
}

