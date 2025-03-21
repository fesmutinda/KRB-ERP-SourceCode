#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
page 50501 "Loans  List All"
{
    Editable = false;
    PageType = List;
    SourceTable = "Loans Register";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Loan  No."; Rec."Loan  No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Application Date"; Rec."Application Date")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Loan Product Type"; Rec."Loan Product Type")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Client Code"; Rec."Client Code")
                {
                    ApplicationArea = Basic;
                    Caption = 'Member  No';
                    Editable = false;
                }
                field("Client Name"; Rec."Client Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Staff No"; Rec."Staff No")
                {
                    ApplicationArea = Basic;
                    Caption = 'Payroll No.';
                }
                field("ID NO"; Rec."ID NO")
                {
                    ApplicationArea = Basic;
                }
                field("Account No"; Rec."Account No")
                {
                    ApplicationArea = Basic;
                    Caption = 'FOSA Account No.';
                }
                field("Approved Amount"; Rec."Approved Amount")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Loan Status"; Rec."Loan Status")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Issued Date"; Rec."Issued Date")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Expected Date of Completion"; Rec."Expected Date of Completion")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Outstanding Balance"; Rec."Outstanding Balance")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Oustanding Interest"; Rec."Oustanding Interest")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Deductible; Rec.Deductible)
                {
                    ApplicationArea = Basic;
                }
            }
        }
        area(factboxes)
        {
            part(Control1000000001; "Member Statistics FactBox")
            {
                SubPageLink = "No." = field("Client Code");
            }
        }
    }

    actions
    {
    }
}

