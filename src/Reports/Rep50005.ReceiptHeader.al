#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 50005 "Receipt Header"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Receipt Header.rdlc';

    dataset
    {
        dataitem("Receipt Header"; "Receipt Header")
        {
            column(ReportForNavId_1; 1)
            {
            }
            column(No; "Receipt Header"."No.")
            {
            }
            column(Date; "Receipt Header"."Posting Date")
            {
            }
            column(TimePosted_ReceiptHeader; "Receipt Header"."Time Posted")
            {
            }
            column(Department; "Receipt Header"."Global Dimension 1 Code")
            {
            }
            column(CostCenter; "Receipt Header"."Global Dimension 2 Code")
            {
            }
            column(RHAmount; "Receipt Header"."Amount Received(LCY)")
            {
            }
            column(RHAmountLCY; "Receipt Header"."Total Amount")
            {
            }
            column(RHDescription; "Receipt Header"."Received From")
            {
            }
            column(RHDesc; "Receipt Header".Description)
            {
            }
            column(Payee; "Receipt Header"."On Behalf of")
            {
            }
            column(TotalAmount; TotalAmount)
            {
            }
            column(TotalAmountText; TotalAmountText[1])
            {
            }
            column(USERID_Control1102755012; UserId)
            {
            }
            column(CI_Name; CI.Name)
            {
                IncludeCaption = true;
            }
            column(CI_Address; CI.Address)
            {
                IncludeCaption = true;
            }
            column(CI_Address2; CI."Address 2")
            {
                IncludeCaption = true;
            }
            column(CI_PhoneNo; CI."Phone No.")
            {
                IncludeCaption = true;
            }
            column(CI_Picture; CI.Picture)
            {
                IncludeCaption = true;
            }
            column(CI_City; CI.City)
            {
                IncludeCaption = true;
            }
            dataitem("Receipt Line"; "Receipt Line")
            {
                DataItemLink = "Document No" = field("No.");
                column(ReportForNavId_11; 11)
                {
                }
                column(no_1; "Receipt Line"."Account Code")
                {
                }
                column(Name; "Receipt Line"."Account Name")
                {
                }
                column(TType; "Receipt Line"."Transaction Type")
                {
                }
                column(Description; "Receipt Line".Description)
                {
                }
                column(Amount; "Receipt Line".Amount)
                {
                }
                column(AmountLCY; "Receipt Line"."Amount(LCY)")
                {
                }
                column(PayMode; "Receipt Line"."Pay Mode")
                {
                }
                column(ChequeNo; "Receipt Line"."Cheque No")
                {
                }
            }

            trigger OnAfterGetRecord()
            begin
                CalcFields("Receipt Header"."Total Amount");
                EnglishLanguageCode := 1033;
                CheckReport.InitTextVariable();
                CheckReport.FormatNoText(TotalAmountText, ("Receipt Header"."Total Amount"), '');
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

    trigger OnPreReport()
    begin
        CI.Get;
        CI.CalcFields(CI.Picture);
    end;

    var
        CI: Record "Company Information";
        CheckReport: Report Check;
        TotalLegalFee: Decimal;
        TotalMembershipFee: Decimal;
        TotalAmount: Decimal;
        TotalInvestment: Decimal;
        TotalAmountText: array[2] of Text[80];
        TotalInvestmentText: array[2] of Text[80];
        Percentage: Decimal;
        Interest: Decimal;
        InterestText: array[2] of Text;
        user: Record User;
        userid: Text;
        EnglishLanguageCode: Integer;
}

