#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
page 50486 "Membership Processor"
{
    PageType = CardPart;
    SourceTable = "Cue Sacco Roles";

    layout
    {
        area(content)
        {
            cuegroup("Member Applications")
            {
                Caption = 'Member Applications';
                field("Open Member Applications"; Rec."Open Member Applications")
                {
                    ApplicationArea = Basic;
                }
                field("Pending Member Applications"; Rec."Pending Member Applications")
                {
                    ApplicationArea = Basic;
                }
                field("Rejected Member Applications"; Rec."Rejected Member Applications")
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

