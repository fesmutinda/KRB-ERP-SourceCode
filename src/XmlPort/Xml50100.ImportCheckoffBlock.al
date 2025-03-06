#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
XmlPort 50100 "Import Checkoff Block"
{
    Format = Xml;
    Direction = Import;
    schema
    {
        textelement(root)
        {
            tableelement("ReceiptsProcessing_L-Checkoff"; "ReceiptsProcessing_L-Checkoff")
            {
                // var
                //  ReceiptLineNoCounter: Integer;
                XmlName = 'ReceiptsProcessing_L';
                fieldelement(Code; "ReceiptsProcessing_L-Checkoff"."Staff/Payroll No") { }
                fieldelement(Name; "ReceiptsProcessing_L-Checkoff".Name) { }
                fieldelement(Co_op_Shares; "ReceiptsProcessing_L-Checkoff"."Co-op - Shares")
                {
                }
                fieldelement(Co_op_Devt_Loan; "ReceiptsProcessing_L-Checkoff"."Co-op - Devt Loan") { }
                fieldelement(Flexi; "ReceiptsProcessing_L-Checkoff".Flexi) { }
                fieldelement(Muslim_Loan; "ReceiptsProcessing_L-Checkoff"."Muslim Loan") { }
                fieldelement(Co_op_Emergency_Loan; "ReceiptsProcessing_L-Checkoff"."Co-op Emergency Loan") { }
                fieldelement(Co_op_Investment_Loan; "ReceiptsProcessing_L-Checkoff"."Co-op - Investment Loan") { }
                fieldelement(Co_op_School_Fees_Loan; "ReceiptsProcessing_L-Checkoff"."Co-op School Fees Loan") { }
                fieldelement(Instant; "ReceiptsProcessing_L-Checkoff".Instant) { }
                fieldelement(Childrens_Savings; "ReceiptsProcessing_L-Checkoff"."Childrens Savings") { }
                fieldelement(Withdrwable_svgs; "ReceiptsProcessing_L-Checkoff"."Withdrwable svgs") { }
                fieldelement(merry_goround; "ReceiptsProcessing_L-Checkoff"."merry goround") { }
                fieldelement(Dev2; "ReceiptsProcessing_L-Checkoff".Dev2) { }
                fieldelement(Share_cap; "ReceiptsProcessing_L-Checkoff"."Share cap") { }
                fieldelement(Entrance; "ReceiptsProcessing_L-Checkoff".Entrance) { }
                fieldelement(Insurance; "ReceiptsProcessing_L-Checkoff".Insurance) { }
                fieldelement(Refinance; "ReceiptsProcessing_L-Checkoff".Refinance) { }

            }
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
    var
        ReceiptLineNoCounter: Integer;

    trigger OnPreXmlPort()
    begin

        if "ReceiptsProcessing_L-Checkoff".FindLast() then
            ReceiptLineNoCounter := "ReceiptsProcessing_L-Checkoff"."Receipt Line No" + 1
        else
            ReceiptLineNoCounter := 1;
    end;

    trigger OnInitXmlPort()
    begin
        "ReceiptsProcessing_L-Checkoff"."Receipt Line No" := ReceiptLineNoCounter;
        ReceiptLineNoCounter += 1;
    end;

}

