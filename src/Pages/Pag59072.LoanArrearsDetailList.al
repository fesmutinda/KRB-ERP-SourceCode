

page 59072 "Loan Arrears Detail List"
{

    PageType = List;

    SourceTable = "Loans Register";

    SourceTableView = Where("Amount in Arrears" = FILTER('>0'));

    layout
    {
        area(content)
        {


            repeater(group)
            {


                field("Loan No"; Rec."Loan  No.")
                {


                    ApplicationArea = Basic;
                }


                field("Loan Product Type Name"; Rec."Loan Product Type Name")
                {

                    ApplicationArea = Basic;
                }


                field("Outstanding Balance"; Rec."Outstanding Balance")
                {

                    ApplicationArea = Basic;
                }


                field("Amount in Arrears"; Rec."Amount in Arrears")
                {

                    ApplicationArea = Basic;
                }


                field("Days In Arrears"; Rec."Days In Arrears")

                {

                    ApplicationArea = Basic;
                }


                field("Mark For Arrear Recovery"; Rec."Mark For Arrear Recovery")
                {

                    ApplicationArea = Basic;
                    Caption = 'Recover Arrears';

                }

            }

        }

    }



    actions
    {


        area(Processing)
        {


            action("Recover Arrears")
            {


                ApplicationArea = Basic;
                Image = Document;

                trigger onAction()

                begin




                end;

            }
        }
    }
}