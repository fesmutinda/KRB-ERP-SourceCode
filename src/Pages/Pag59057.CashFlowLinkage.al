page 59057 "Cash Flow Category Linkage"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "G/L Account";
    Caption = 'Cash Flow Account Mapping';

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("G/L Account No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Select the G/L Account';
                }
                field(Description; Rec.Name)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Cash Flow Category"; Rec."Cash Flow Category")
                {
                    ApplicationArea = All;
                    ToolTip = 'Classify as Operating/Investing/Financing';
                }
            }
        }
    }

    // actions
    // {
    //     area(Processing)
    //     {
    //         action(ImportCOA)
    //         {
    //             Caption = 'Import Chart of Accounts';
    //             ApplicationArea = All;
    //             Image = Import;

    //             trigger OnAction()
    //             var
    //                 GLAccount: Record "G/L Account";
    //             begin
    //                 GLAccount.SetRange("Account Type", GLAccount."Account Type"::Posting);
    //                 if GLAccount.FindSet() then
    //                     repeat
    //                         if not Setup.Get(GLAccount."No.") then begin
    //                             Setup.Init();
    //                             Setup."G/L Account No." := GLAccount."No.";
    //                             Setup.Insert();
    //                         end;
    //                     until GLAccount.Next() = 0;
    //                 Message('Imported %1 posting accounts', GLAccount.Count);
    //             end;
    //         }
    //     }
    // }
}