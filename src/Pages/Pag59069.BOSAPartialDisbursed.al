namespace KRBERPSourceCode.KRBERPSourceCode;

page 59069 "BOSAPartialDisbursed"
{
    ApplicationArea = All;
    Caption = 'BOSA Loans Partial Disbursed';
    PageType = List;
    SourceTable = "Loans Register";
    CardPageID = "BOSA Loans Disbursement Card";
    UsageCategory = Lists;
    DeleteAllowed = false;
    //Editable = false;
    //InsertAllowed = false;
    //ModifyAllowed = false;
    SourceTableView = where(
                            //Source = filter(BOSA),
                            //"Approval Status" = const(Approved),
                            //"Disbursement Status" = const("Partially Disbursed"),
                            "Remaining Amount" = FILTER('>0')
                            //"Is Partial Disbursement" = const(true),
                            //"Loan Product Type" = const('<>LT007')
                            );

    layout
    {
        area(Content)
        {
            repeater(Group)
            {

                field("Loan  No."; Rec."Loan  No.")
                {
                    ApplicationArea = Basic;
                }
                field("Loan Product Type"; Rec."Loan Product Type")
                {
                    ApplicationArea = Basic;
                }
                field("Application Date"; Rec."Application Date")
                {
                    ApplicationArea = Basic;
                }
                field("Client Name"; Rec."Client Name")
                {
                    ApplicationArea = Basic;
                    Style = StrongAccent;
                }
                field("Client Code"; Rec."Client Code")
                {
                    ApplicationArea = Basic;
                    Caption = 'Member  No';
                }


                field("Requested Amount"; Rec."Requested Amount")
                {
                    ApplicationArea = Basic;
                    Style = StrongAccent;
                }
                field("Approved Amount"; Rec."Approved Amount")
                {
                    ApplicationArea = Basic;
                    visible = false;
                }

                field("Disbursement Status"; Rec."Disbursement Status")
                {

                }


                field("Disbursed Amount"; Rec."Disbursed Amount")
                {

                }

                field("Remaining Amount"; Rec."Remaining Amount")
                {

                }


                field("Loan Status"; Rec."Loan Status")
                {
                    ApplicationArea = Basic;
                    Style = Ambiguous;
                }
                field("Captured By"; Rec."Captured By")
                {

                }


            }
        }
    }
}
