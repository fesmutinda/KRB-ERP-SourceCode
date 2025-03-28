#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
page 50550 "Membership App Products"
{
    PageType = List;
    SourceTable = "Membership Reg. Products Appli";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Product; Rec.Product)
                {
                    ApplicationArea = Basic;
                }
                field("Product Name"; Rec."Product Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Product Source"; Rec."Product Source")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
            }
        }
    }

    actions
    {
    }
}

