namespace KRBERPSourceCode.KRBERPSourceCode;

page 57015 "Online Loan Applications"
{
    ApplicationArea = All;
    Caption = 'Online Loan Applications';
    PageType = List;
    UsageCategory = Lists;
    Editable = true;
    ModifyAllowed = true;
    CardPageId = "Online Loan Application Card";
    SourceTable = "Online Loan Application";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Application No"; Rec."Application No")
                {
                }
                field("BOSA No"; Rec."BOSA No")
                {
                }
                field("Member Names"; Rec."Member Names")
                {
                    ToolTip = 'Specifies the name of the member applying for the loan.';
                }
                field("Loan Type"; Rec."Loan Type")
                {
                    ToolTip = 'Specifies the loan product for this application.';
                }
                field("Loan Product Type Name"; Rec."Loan Product Type Name")
                {
                    ToolTip = 'Specifies the description of the selected loan product.';
                }
                field("Loan No"; Rec."Loan No")
                {
                }
                field("Loan Amount"; Rec."Loan Amount")
                {
                }
                field("Installments"; Rec."Installments")
                {
                    ToolTip = 'Specifies the number of installments for the loan.';
                }
                field("Loan Purpose"; Rec."Loan Purpose")
                {
                    ToolTip = 'Specifies the purpose of the loan.';
                }
                field("Application Date"; Rec."Application Date")
                {
                }
                field(Posted; Rec.Posted)
                {
                }
                field("Id No"; Rec."Id No")
                {
                    ToolTip = 'Specifies the id no for this online loan application.';
                }
                field("Employment No"; Rec."Employment No")
                {
                    ToolTip = 'Specifies the employment no for this online loan application.';
                }
                field("Date of Birth"; Rec."Date of Birth")
                {
                    ToolTip = 'Specifies the date of birth for this online loan application.';
                }
                field("Membership No"; Rec."Membership No")
                {
                    ToolTip = 'Specifies the membership no for this online loan application.';
                }
                field(Email; Rec.Email)
                {
                    ToolTip = 'Specifies the email for this online loan application.';
                }
                field(Telephone; Rec.Telephone)
                {
                    ToolTip = 'Specifies the telephone for this online loan application.';
                }
                field("Home Address"; Rec."Home Address")
                {
                    ToolTip = 'Specifies the home address for this online loan application.';
                }
                field(Station; Rec.Station)
                {
                    ToolTip = 'Specifies the station for this online loan application.';
                }
                field("Repayment Period"; Rec."Repayment Period")
                {
                    ToolTip = 'Specifies the repayment period for this online loan application.';
                }
                field(Source; Rec.Source)
                {
                    ToolTip = 'Specifies the source for this online loan application.';
                }
                field("Interest Rate"; Rec."Interest Rate")
                {
                    ToolTip = 'Specifies the interest rate for this online loan application.';
                }
                field("Sent To Bosa Loans"; Rec."Sent To Bosa Loans")
                {
                    ToolTip = 'Specifies the sent to bosa loans for this online loan application.';
                }
                field(submitted; Rec.submitted)
                {
                    ToolTip = 'Specifies the submitted for this online loan application.';
                }
                field(Refno; Rec.Refno)
                {
                    ToolTip = 'Specifies the refno for this online loan application.';
                }
                field("Interest Calculation Method"; Rec."Interest Calculation Method")
                {
                    ToolTip = 'Specifies the interest calculation method for this online loan application.';
                }
                field("Captured By"; Rec."Captured By")
                {
                    ToolTip = 'Specifies the captured by for this online loan application.';
                }
                field("No. Series"; Rec."No. Series")
                {
                    ToolTip = 'Specifies the no. series for this online loan application.';
                }
                field("Application Status"; Rec."Application Status")
                {
                    ToolTip = 'Specifies the application status for this online loan application.';
                }
                field("Guarantorship Requested"; Rec."Guarantorship Requested")
                {
                    ToolTip = 'Specifies the guarantorship requested for this online loan application.';
                }
                field("Mode of Disbursement"; Rec."Mode of Disbursement")
                {
                    ToolTip = 'Specifies the mode of disbursement for this online loan application.';
                }
                field("Recovery Mode"; Rec."Recovery Mode")
                {
                    ToolTip = 'Specifies the recovery mode for this online loan application.';
                }
                field("Mobile Money Service"; Rec."Mobile Money Service")
                {
                    ToolTip = 'Specifies the mobile money service for this online loan application.';
                }
                field("Mobile Money Receiving Number"; Rec."Mobile Money Receiving Number")
                {
                    ToolTip = 'Specifies the mobile money receiving number for this online loan application.';
                }
                field("Bank Account"; Rec."Bank Account")
                {
                    ToolTip = 'Specifies the bank account for this online loan application.';
                }
                field("Customer Bank"; Rec."Customer Bank")
                {
                    ToolTip = 'Specifies the customer bank for this online loan application.';
                }
                field("Min No. Of Guarantors"; Rec."Min No. Of Guarantors")
                {
                    ToolTip = 'Specifies the min no. of guarantors for this online loan application.';
                }
            }
        }
    }
}
