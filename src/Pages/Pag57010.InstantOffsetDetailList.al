page 57010 "Instant Offset Detail List"
{
    PageType = List;
    SourceTable = "Instant Offset Details";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Loan No."; Rec."Loan No.")
                {
                    ApplicationArea = Basic;
                    Enabled = false;
                }
                field("Loan Top Up"; Rec."Loan Top Up")
                {
                    ApplicationArea = Basic;
                    Caption = 'Loan to Offset';
                }

                field("Loan Type"; Rec."Loan Type")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }

                field("Loan Product Type Name"; Rec."Loan Product Type Name")
                {
                }
                field("Principle Top Up"; Rec."Principle Top Up")
                {
                    ApplicationArea = Basic;
                }
                field("Remaining Installments"; Rec."Remaining Installments")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Monthly Repayment"; Rec."Monthly Repayment")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Outstanding Balance"; Rec."Outstanding Balance")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Total Top Up"; Rec."Total Top Up")
                {
                    ApplicationArea = Basic;
                    Caption = 'Total Recovery';
                    Editable = false;
                    Importance = Promoted;
                    Style = Attention;
                    StyleExpr = true;
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action("Loan Payoff")
            {
                ApplicationArea = Basic;
                Image = Document;
                Promoted = true;
                RunObject = Page "Loan PayOff List";
            }
            action(ReduceLoanBalance)
            {
                ApplicationArea = Basic;
                Image = Post;
                Promoted = true;

                trigger OnAction()
                begin

                    ObjLoanOffset.Reset;
                    ObjLoanOffset.SetRange(ObjLoanOffset."Loan Top Up", Rec."Loan Top Up");
                    ObjLoanOffset.SetRange(ObjLoanOffset."FOSA Account", Rec."FOSA Account");
                    if ObjLoanOffset.Find('-') then begin
                        if ObjLoanOffset."FOSA Account" = '' then begin
                            Error('Specify the FOSA Account to be Debited When reducing the Loan');
                        end;
                        Report.Run(51516934, true, false, ObjLoanOffset);
                    end;
                end;
            }
        }
    }

    var
        ObjLoanOffset: Record "Loan Offset Details";
}
