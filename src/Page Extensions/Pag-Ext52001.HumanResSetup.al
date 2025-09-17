pageextension 52001 HumanResSetupExt extends "Human Resources Setup"
{
    layout
    {
        addafter(Numbering)
        {
            group(LeaveNos)
            {
                Caption = 'Leave';
                field("Leave Application Nos."; Rec."Leave Application Nos.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Leave Application Nos. field';
                }
                field("Leave Recall Nos"; Rec."Leave Recall Nos")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Leave Recall Nos field';
                }
                field("Leave Adjustment Nos"; Rec."Leave Adjustment Nos")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Leave Adjustment Nos field';
                }
                field("Leave Plan Nos"; Rec."Leave Plan Nos")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Leave Plan Nos field';
                }
                field("Default Base Calendar"; Rec."Default Base Calendar")
                {
                    ApplicationArea = All;
                    //   ToolTip = 'Specifies the value of the Default Base Calendar field';
                }

            }
        }
    }


}