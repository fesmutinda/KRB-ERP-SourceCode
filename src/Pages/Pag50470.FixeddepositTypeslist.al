#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
page 50470 "Fixed deposit Types list"
{
    CardPageID = "Fixed Deposit Types Card";
    Editable = false;
    PageType = List;
    SourceTable = "Fixed Deposit Type";
    SourceTableView = sorting(Code, "Maximum Amount")
                      order(descending);

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Code"; Rec.Code)
                {
                    ApplicationArea = Basic;
                }
                field(Duration; Rec.Duration)
                {
                    ApplicationArea = Basic;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                }
                field("No. of Months"; Rec."No. of Months")
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

