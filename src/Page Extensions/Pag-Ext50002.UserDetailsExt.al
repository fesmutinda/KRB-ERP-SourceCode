namespace KRBERPSourceCode.KRBERPSourceCode;

using System.Security.User;

pageextension 50002 "UserDetailsExt" extends "User Card"
{


    layout
    {


        addafter("Control17")
        {
            part(Control234; "SignatureDocument")
            {
                ApplicationArea = all;
                SubPageLink = "User ID" = FIELD("User Name");
                //Visible = Individual;
                Enabled = true;
            }
        }
    }
}
