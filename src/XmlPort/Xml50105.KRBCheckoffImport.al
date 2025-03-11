// namespace KRBERPSourceCode.KRBERPSourceCode;

xmlport 50105 "KRB Checkoff Import"
{
    Format = VariableText;
    Caption = 'KRB Checkoff Import';
    schema
    {
        textelement(RootNodeName)
        {
            tableelement(KRBCheckoffLines; "KRB CheckoffLines")
            {
                fieldelement(ReceiptHeader; KRBCheckoffLines."Receipt Header No") { }

                fieldelement(Code; KRBCheckoffLines."Staff/Payroll No") { }
                fieldelement(Name; KRBCheckoffLines.Name) { }
                fieldelement(Co_op_Shares; KRBCheckoffLines."Co-op - Shares") { }
                fieldelement(Co_op_Devt_Loan; KRBCheckoffLines."Co-op - Devt Loan") { }
                fieldelement(Flexi; KRBCheckoffLines.Flexi) { }
                fieldelement(Muslim_Loan; KRBCheckoffLines."Muslim Loan") { }
                fieldelement(Co_op_Emergency_Loan; KRBCheckoffLines."Co-op Emergency Loan") { }
                fieldelement(Co_op_Investment_Loan; KRBCheckoffLines."Co-op - Investment Loan") { }
                fieldelement(Co_op_School_Fees_Loan; KRBCheckoffLines."Co-op School Fees Loan") { }
                fieldelement(Instant; KRBCheckoffLines.Instant) { }
                fieldelement(Childrens_Savings; KRBCheckoffLines."Childrens Savings") { }
                fieldelement(Withdrwable_svgs; KRBCheckoffLines."Withdrwable svgs") { }
                // fieldelement(merry_goround; KRBCheckoffLines."merry goround") { }
                // fieldelement(Dev2; KRBCheckoffLines.Dev2) { }
                // fieldelement(Share_cap; KRBCheckoffLines."Share cap") { }
                // fieldelement(Entrance; KRBCheckoffLines.Entrance) { }
                // fieldelement(Insurance; KRBCheckoffLines.Insurance) { }
                // fieldelement(Refinance; KRBCheckoffLines.Refinance) { }

            }
        }
    }
}
