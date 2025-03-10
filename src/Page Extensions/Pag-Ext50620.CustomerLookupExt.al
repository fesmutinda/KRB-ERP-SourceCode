pageextension 50620 "CustomerLookupExt" extends "Customer Lookup"
{
    layout
    {
        addafter(Name)
        {

            field("ID No."; Rec."ID No.")
            {

            }
            field("Payroll/Staff No"; Rec."Payroll/Staff No")
            {

            }
            field("Mobile Phone No"; Rec."Mobile Phone No")
            {

            }
            field("Account Category"; Rec."Account Category")
            {

            }

            field("Posting Group"; Rec."Customer Posting Group")
            {

            }
            field("Group Account"; Rec."Group Account")
            {

            }


        }
        modify("Phone No.")
        {
            Visible = false;
        }
        modify(Contact)
        {
            Visible = false;
        }


    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}
