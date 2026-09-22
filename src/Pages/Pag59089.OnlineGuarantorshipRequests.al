namespace KRBERPSourceCode.KRBERPSourceCode;

page 59089 "Online Guarantorship Requests"
{
    ApplicationArea = All;
    Caption = 'Online Loan Guarantorship Requests';
    PageType = List;
    UsageCategory = Lists;
    SourceTable = "Online Loan Guarantors";
    Editable = true;
    ModifyAllowed = true;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Entry No"; Rec."Entry No")
                {
                    Editable = false;
                    ToolTip = 'Specifies the automatically assigned entry number.';
                }
                field("Loan Application No"; Rec."Loan Application No")
                {
                    ToolTip = 'Specifies the online loan application associated with the request.';
                }
                field("Member No"; Rec."Member No")
                {
                    ToolTip = 'Specifies the member asked to guarantee the loan.';
                }
                field(Names; Rec.Names)
                {
                    ToolTip = 'Specifies the name of the guarantor.';
                }
                field("Email Address"; Rec."Email Address")
                {
                    ToolTip = 'Specifies the email address of the guarantor.';
                }
                field(Telephone; Rec.Telephone)
                {
                    ToolTip = 'Specifies the telephone number of the guarantor.';
                }
                field(Amount; Rec.Amount)
                {
                    ToolTip = 'Specifies the amount to be guaranteed.';
                }
                field(Approved; Rec.Approved)
                {
                    ToolTip = 'Specifies whether the guarantorship request is pending, approved, or rejected.';
                }
                field("Approval Status"; Rec."Approval Status")
                {
                    ToolTip = 'Specifies the approval status flag recorded for the request.';
                }
                field(ApplicantNo; Rec.ApplicantNo)
                {
                    ToolTip = 'Specifies the member number of the loan applicant.';
                }
                field("ID No"; Rec."ID No")
                {
                    ToolTip = 'Specifies the identification number of the guarantor.';
                }
                field(ApplicantName; Rec.ApplicantName)
                {
                    ToolTip = 'Specifies the name of the loan applicant.';
                }
                field("Applicant Mobile"; Rec."Applicant Mobile")
                {
                    ToolTip = 'Specifies the mobile number of the loan applicant.';
                }
                field("Loan Type"; Rec."Loan Type")
                {
                    ToolTip = 'Specifies the loan product associated with the request.';
                }
            }
        }
    }
}
