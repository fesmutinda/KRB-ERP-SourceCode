// Page 59063 - KrbscBudgetCard (Your existing page with subpage added)
page 59063 "KrbscBudgetCard"
{
    Caption = 'Budget Card';
    PageType = Card;
    SourceTable = "KrbscCustomBudget";
    UsageCategory = Documents;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General Information';

                field("Budget No."; Rec."Budget No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Budget number.';
                }

                field("Budget Name"; Rec."Budget Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Budget number.';
                }

                field("Budget Year"; Rec."Budget Year")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the budget year.';
                }

                field("Budget Type"; Rec."Budget Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the budget type.';
                }

                field("Account Category"; Rec."Description")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the account category.';
                }

            }


            part(BudgetLines; "KrbscBudget Lines")
            {
                ApplicationArea = All;
                Caption = 'Budget Lines';
                SubPageLink = "Budget No." = field("Budget No.");
            }

            group(Tracking)
            {
                Caption = 'Tracking Information';

                field("Created By"; Rec."Created By")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies who created the record.';
                }

                field("Created Date"; Rec."Created Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies when the record was created.';
                }

                // field("Modified By"; Rec."Modified By")
                // {
                //     ApplicationArea = All;
                //     ToolTip = 'Specifies who last modified the record.';
                // }

                // field("Modified Date"; Rec."Modified Date")
                // {
                //     ApplicationArea = All;
                //     ToolTip = 'Specifies when the record was last modified.';
                // }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Calculate Totals")
            {
                ApplicationArea = All;
                Caption = 'Calculate Totals';
                Image = Calculate;
                ToolTip = 'Calculate budget totals.';
            }
        }

        area(navigation)
        {
            action("Budget List")
            {
                ApplicationArea = All;
                Caption = 'Budget List';
                Image = List;
                RunObject = Page "KrbscBudget List";
                ToolTip = 'Open the budget list.';
            }
        }
    }
}