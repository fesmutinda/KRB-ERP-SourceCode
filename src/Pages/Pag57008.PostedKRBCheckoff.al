page 57008 "Posted KRB Checkoff"
{
    DeleteAllowed = false;
    PageType = Card;
    SourceTable = "KRB Checkoff Header";
    SourceTableView = where(Posted = const(true));
    Editable = false;

    layout
    {
        area(content)
        {
            group(General)
            {
                field(No; Rec.No)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Entered By"; Rec."Entered By")
                {
                    ApplicationArea = Basic;
                    Enabled = false;
                }
                field("Date Entered"; Rec."Date Entered")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Posting date"; Rec."Posting date")
                {
                    ApplicationArea = Basic;
                    Editable = true;
                }
                field("Loan CutOff Date"; Rec."Loan CutOff Date")
                {
                    ApplicationArea = Basic;
                }
                // field(Remarks; Rec.Remarks)
                // {
                //     ApplicationArea = Basic;
                // }
                field("Total Count"; Rec."Total Count")
                {
                    ApplicationArea = Basic;
                }
                field("Posted By"; Rec."Posted By")
                {
                    ApplicationArea = Basic;
                }
                // field("Account Type"; Rec."Account Type")
                // {
                //     ApplicationArea = Basic;
                // }
                field("Account No"; Rec."Account No")
                {
                    Caption = 'Bank Account';
                    ApplicationArea = Basic;
                }
                field("Employer Code"; Rec."Employer Code")
                {
                    Visible = false;
                    ApplicationArea = Basic;
                }
                field("Document No"; Rec."Document No")
                {
                    ApplicationArea = Basic;
                }
                field(Posted; Rec.Posted)
                {
                    ApplicationArea = Basic;
                    Editable = true;
                }
                field(Amount; Rec.Amount)
                {
                    Caption = 'Cheque Amount';
                    ApplicationArea = Basic;
                }
                field("Scheduled Amount"; Rec."Scheduled Amount")
                {
                    ApplicationArea = Basic;
                }
            }
            part("Bosa receipt lines"; "KRB CheckoffLines")
            {
                SubPageLink = "Receipt Header No" = field(No);
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {

                trigger OnAction()
                begin

                end;
            }
        }
    }

    var
        myInt: Integer;
}