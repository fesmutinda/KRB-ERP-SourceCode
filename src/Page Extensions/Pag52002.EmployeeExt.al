pageextension 52002 EmployeeExt extends "Employee Card"
{
    layout
    {
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



    }


}