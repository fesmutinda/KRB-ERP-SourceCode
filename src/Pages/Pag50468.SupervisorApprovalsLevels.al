#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
page 50468 "Supervisor Approvals Levels"
{
    PageType = Card;
    SourceTable = "Supervisors Approval Levels";

    layout
    {
        area(content)
        {
            repeater(Control4)
            {
                field("Supervisor ID"; Rec."Supervisor ID")
                {
                    ApplicationArea = Basic;
                    Caption = 'User ID';
                }
                field("Supervisor Name"; Rec."Supervisor Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Transaction Type"; Rec."Transaction Type")
                {
                    ApplicationArea = Basic;
                }
                field("Maximum Approval Amount"; Rec."Maximum Approval Amount")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
    }
}
