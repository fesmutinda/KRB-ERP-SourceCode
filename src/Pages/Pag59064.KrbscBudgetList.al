// Page 59064 - KrbscBudget List
page 59064 "KrbscBudget List"
{
    Caption = 'Budget List';
    PageType = List;
    SourceTable = "KrbscCustomBudget";
    UsageCategory = Lists;
    ApplicationArea = All;
    CardPageId = "KrbscBudgetCard";
    Editable = false;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Budget No."; Rec."Budget No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the budget number.';
                }

                field("Budget Name"; Rec."Budget Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the budget name.';
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

                // field("Status"; Rec."Status")
                // {
                //     ApplicationArea = All;
                //     ToolTip = 'Specifies the budget status.';
                // }

                field("Description"; Rec."Description")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the budget description.';
                }

                field("Created By"; Rec."Created By")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies who created the budget.';
                }

                field("Created Date"; Rec."Created Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies when the budget was created.';
                }

                // Summary fields (calculated from budget lines)
                // field("Total Income"; GetTotalAmount("Account Category"::Income))
                // {
                //     ApplicationArea = All;
                //     Caption = 'Total Income';
                //     ToolTip = 'Total income from all budget lines.';
                //     DecimalPlaces = 0 : 2;
                //     Editable = false;
                // }

                // field("Total Expenses"; GetTotalAmount("Account Category"::Expenses))
                // {
                //     ApplicationArea = All;
                //     Caption = 'Total Expenses';
                //     ToolTip = 'Total expenses from all budget lines.';
                //     DecimalPlaces = 0 : 2;
                //     Editable = false;
                // }

                // field("Net Profit"; GetTotalAmount("Account Category"::Income) - GetTotalAmount("Account Category"::Expenses))
                // {
                //     ApplicationArea = All;
                //     Caption = 'Net Profit';
                //     ToolTip = 'Net profit (Income - Expenses).';
                //     DecimalPlaces = 0 : 2;
                //     Editable = false;
                //     Style = StrongAccent;
                // }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("New Budget")
            {
                ApplicationArea = All;
                Caption = 'New Budget';
                Image = New;
                ToolTip = 'Create a new budget.';

                trigger OnAction()
                var
                    BudgetCard: Page "KrbscBudgetCard";
                    NewBudget: Record "KrbscCustomBudget";
                begin
                    NewBudget.Init();
                    NewBudget.Insert(true);
                    BudgetCard.SetRecord(NewBudget);
                    BudgetCard.Run();
                end;
            }

            group("Reports")
            {
                Caption = 'Reports';

                action("Budget Report")
                {
                    ApplicationArea = All;
                    Caption = 'Budget Report';
                    Image = Report;
                    ToolTip = 'Print budget report.';

                    trigger OnAction()
                    begin
                        Message('Budget Report functionality will be implemented.');
                        // TODO: Create and run budget report
                    end;
                }

                action("Budget Comparison")
                {
                    ApplicationArea = All;
                    Caption = 'Budget Comparison';
                    Image = CompareCOA;
                    ToolTip = 'Compare budgets across years.';

                    trigger OnAction()
                    begin
                        Message('Budget Comparison functionality will be implemented.');
                        // TODO: Create and run budget comparison report
                    end;
                }

                action("Export to Excel")
                {
                    ApplicationArea = All;
                    Caption = 'Export to Excel';
                    Image = ExportToExcel;
                    ToolTip = 'Export budget data to Excel.';

                    trigger OnAction()
                    begin
                        ExportBudgetToExcel();
                    end;
                }
            }

            group("Functions")
            {
                Caption = 'Functions';

                action("Copy Budget")
                {
                    ApplicationArea = All;
                    Caption = 'Copy Budget';
                    Image = Copy;
                    ToolTip = 'Copy selected budget to create a new budget.';

                    trigger OnAction()
                    begin
                        CopyBudget();
                    end;
                }

                action("Archive Budget")
                {
                    ApplicationArea = All;
                    Caption = 'Archive Budget';
                    Image = Archive;
                    ToolTip = 'Archive the selected budget.';

                    trigger OnAction()
                    begin
                        ArchiveBudget();
                    end;
                }
            }
        }

        area(navigation)
        {
            action("Budget Card")
            {
                ApplicationArea = All;
                Caption = 'Budget Card';
                Image = Card;
                RunObject = Page "KrbscBudgetCard";
                RunPageLink = "Budget No." = field("Budget No.");
                ToolTip = 'Open the budget card.';
            }

            action("Budget Lines")
            {
                ApplicationArea = All;
                Caption = 'Budget Lines';
                Image = Line;
                RunObject = Page "KrbscBudget Lines";
                RunPageLink = "Budget No." = field("Budget No.");
                ToolTip = 'View budget lines for this budget.';
            }
        }
    }

    local procedure GetTotalAmount(Category: Enum "Account Category"): Decimal
    var
        BudgetLines: Record KrbscBudgetLines;
        TotalAmount: Decimal;
    begin
        BudgetLines.SetRange("Budget No.", Rec."Budget No.");
        BudgetLines.SetRange("Account Category", Category);
        BudgetLines.SetRange("Line Type", "Budget Line Type"::Detail);

        if BudgetLines.FindSet() then begin
            repeat
                TotalAmount += BudgetLines."Proposed Budget Next";
            until BudgetLines.Next() = 0;
        end;

        exit(TotalAmount);
    end;

    local procedure CopyBudget()
    var
        NewBudget: Record "KrbscCustomBudget";
        BudgetLines: Record KrbscBudgetLines;
        NewBudgetLines: Record KrbscBudgetLines;
        NewBudgetNo: Code[20];
    begin
        if not Confirm('Do you want to copy budget %1?', false, Rec."Budget No.") then
            exit;

        // Create new budget header
        NewBudget.Init();
        NewBudget.TransferFields(Rec);
        NewBudget."Budget No." := ''; // Will be assigned by number series or user input
        NewBudget."Budget Name" := Rec."Budget Name" + ' (Copy)';
        //NewBudget."Status" := "Budget Status"::Draft; // Assuming you have a Draft status
        NewBudget.Insert(true);
        NewBudgetNo := NewBudget."Budget No.";

        // Copy budget lines
        BudgetLines.SetRange("Budget No.", Rec."Budget No.");
        if BudgetLines.FindSet() then begin
            repeat
                NewBudgetLines.Init();
                NewBudgetLines.TransferFields(BudgetLines);
                NewBudgetLines."Budget No." := NewBudgetNo;
                NewBudgetLines.Insert(true);
            until BudgetLines.Next() = 0;
        end;

        Message('Budget copied successfully. New Budget No.: %1', NewBudgetNo);
        CurrPage.Update(false);
    end;

    local procedure ArchiveBudget()
    begin
        if not Confirm('Do you want to archive budget %1?', false, Rec."Budget No.") then
            exit;

        // Update status to archived
        //Rec."Status" := "Budget Status"::Archived; // Assuming you have an Archived status
        Rec.Modify();

        Message('Budget %1 has been archived.', Rec."Budget No.");
        CurrPage.Update(false);
    end;

    local procedure ExportBudgetToExcel()
    var
        BudgetLines: Record KrbscBudgetLines;
        TempExcelBuffer: Record "Excel Buffer" temporary;
        FileName: Text;
    begin
        BudgetLines.SetRange("Budget No.", Rec."Budget No.");

        if not BudgetLines.FindSet() then begin
            Message('No budget lines found for budget %1.', Rec."Budget No.");
            exit;
        end;

        TempExcelBuffer.DeleteAll();

        // Create headers
        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn('Budget: ' + Rec."Budget Name", false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn('Year: ' + Format(Rec."Budget Year"), false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.NewRow(); // Empty row

        // Column headers
        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn('Account Name', false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Category', false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Line Type', false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Actuals Previous Year', false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Approved Budget Current', false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Revised Budget Current', false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Proposed Budget Next', false, '', true, false, true, '', TempExcelBuffer."Cell Type"::Text);

        // Data rows
        repeat
            TempExcelBuffer.NewRow();
            TempExcelBuffer.AddColumn(BudgetLines."Account Name", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
            TempExcelBuffer.AddColumn(Format(BudgetLines."Account Category"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
            TempExcelBuffer.AddColumn(Format(BudgetLines."Line Type"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
            TempExcelBuffer.AddColumn(BudgetLines."Actuals Previous Year", false, '', false, false, false, '#,##0.00', TempExcelBuffer."Cell Type"::Number);
            TempExcelBuffer.AddColumn(BudgetLines."Approved Budget Current", false, '', false, false, false, '#,##0.00', TempExcelBuffer."Cell Type"::Number);
            TempExcelBuffer.AddColumn(BudgetLines."Revised Budget Current", false, '', false, false, false, '#,##0.00', TempExcelBuffer."Cell Type"::Number);
            TempExcelBuffer.AddColumn(BudgetLines."Proposed Budget Next", false, '', false, false, false, '#,##0.00', TempExcelBuffer."Cell Type"::Number);
        until BudgetLines.Next() = 0;

        FileName := StrSubstNo('Budget_%1_%2.xlsx', Rec."Budget No.", Format(Today, 0, '<Year4><Month,2><Day,2>'));
        TempExcelBuffer.CreateNewBook(FileName);
        TempExcelBuffer.WriteSheet('Budget Details', CompanyName, UserId);
        TempExcelBuffer.CloseBook();
        TempExcelBuffer.SetFriendlyFilename(FileName);
        TempExcelBuffer.OpenExcel();
    end;
}