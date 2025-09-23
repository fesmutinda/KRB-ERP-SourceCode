pageextension 52002 EmployeeExt extends "Employee Card"
{
    layout
    {
        addafter("Search Name")
        {
            field(Gender1; Rec.Gender1)
            {
                ApplicationArea = All;
                Caption = 'Gender';
            }
        }
        addafter("Job Title")
        {
            field("Employment Type"; Rec."Employment Type")
            {
                ApplicationArea = All;
            }
            field("Responsibility Center"; Rec."Responsibility Center")
            {
                ApplicationArea = all;
            }
        }
        modify(Gender)
        {
            ApplicationArea = All;
            Visible = false;
        }



    }


}