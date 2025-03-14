#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
page 50362 "Membership Application Image"
{
    PageType = Card;
    SourceTable = "Membership Applications";

    layout
    {
        area(content)
        {
            field(Picture; Rec.Picture)
            {
                ApplicationArea = Basic;
            }
            field(Signature; Rec.Signature)
            {
                ApplicationArea = Basic;
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        /*MemberApp.RESET;
        MemberApp.SETRANGE(MemberApp."No.","No.");
        IF MemberApp.FIND('-') THEN BEGIN
         IF MemberApp.Status=MemberApp.Status::Approved THEN BEGIN
          CurrPage.EDITABLE:=FALSE;
         END ELSE
          CurrPage.EDITABLE:=TRUE;
        END;
         */

    end;

    var
        MemberApp: Record "Membership Applications";
}

