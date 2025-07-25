page 59067 "KrbscBudget Lines"
{
    Caption = 'Budget Lines';
    PageType = ListPart;
    SourceTable = KrbscBudgetLines;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Line Type"; Rec."Line Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the line type: Detail, Total, or Header';
                }

                field("Account Name"; Rec."Account Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the account name.';
                }

                field("G/L Account No."; Rec."G/L Account No.")
                {
                    ApplicationArea = All;
                    Caption = 'G/L Account No.';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        GLAccountList: Page "G/L Account List";
                        GLAccount: Record "G/L Account";
                    begin
                        GLAccountList.LookupMode(true);
                        if GLAccountList.RunModal() = Action::LookupOK then begin
                            GLAccountList.GetRecord(GLAccount);
                            Rec."G/L Account No." := GLAccount."No.";
                            Rec."G/L Account Name" := GLAccount.Name;
                            CurrPage.Update();
                        end;
                    end;
                }

                field("G/L Account Name"; Rec."G/L Account Name")
                {
                    ApplicationArea = All;
                    Caption = 'G/L Account Name';
                }

                field("Actuals Previous Year"; Rec."Actuals Previous Year")
                {
                    ApplicationArea = All;
                    ToolTip = 'Actuals Figures 2024';
                    DecimalPlaces = 0 : 2;
                    Editable = LineEditable;
                }

                field("Approved Budget Current"; Rec."Approved Budget Current")
                {
                    ApplicationArea = All;
                    ToolTip = 'Approved Budget 2024';
                    DecimalPlaces = 0 : 2;
                    Editable = LineEditable;
                }

                field("Revised Budget Current"; Rec."Revised Budget Current")
                {
                    ApplicationArea = All;
                    ToolTip = 'Revised Budget 2025';
                    DecimalPlaces = 0 : 2;
                    Editable = LineEditable;
                }

                field("Proposed Budget Next"; Rec."Proposed Budget Next")
                {
                    ApplicationArea = All;
                    ToolTip = 'Proposed Budget 2026';
                    DecimalPlaces = 0 : 2;
                    Editable = LineEditable;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Initialize Budget Lines")
            {
                ApplicationArea = All;
                Caption = 'Initialize Budget Lines';
                Image = NewRow;
                ToolTip = 'Create budget lines from CSV structure.';

                trigger OnAction()
                begin
                    InitializeBudgetLines();
                    CurrPage.Update(false);
                    Message('Budget lines have been initialized.');
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        LineEditable := Rec."Line Type" = "Budget Line Type"::Detail;
    end;

    local procedure InitializeBudgetLines()
    var
        BudgetLineRec: Record KrbscBudgetLines;
        LineNo: Integer;
        BudgetNo: Code[20];
    begin
        // Get the Budget No. from the current context (should be passed from parent page)
        BudgetNo := GetBudgetNo();

        if BudgetNo = '' then begin
            Error('Cannot initialize budget lines without a valid Budget No.');
            exit;
        end;

        // Delete existing lines for this budget
        BudgetLineRec.SetRange("Budget No.", BudgetNo);
        BudgetLineRec.DeleteAll();

        LineNo := 10000;

        // INCOME SECTION
        CreateBudgetLine(BudgetNo, LineNo, 'Income', "Account Category"::Income, "Budget Line Type"::Header, '', 0, 0, 0, 0);
        LineNo += 10000;
        CreateBudgetLine(BudgetNo, LineNo, 'Interest Income', "Account Category"::Income, "Budget Line Type"::Detail, '', 13959025, 15000000, 15000000, 16000000);
        LineNo += 10000;
        CreateBudgetLine(BudgetNo, LineNo, 'Interest from Stima Sacco', "Account Category"::Income, "Budget Line Type"::Detail, '', 12460, 12000, 12000, 13706);
        LineNo += 10000;
        CreateBudgetLine(BudgetNo, LineNo, 'Less: Interest Expense', "Account Category"::Income, "Budget Line Type"::Detail, '', -9100000, -10000000, -11000000, -11000000);
        LineNo += 10000;
        CreateBudgetLine(BudgetNo, LineNo, 'Interest from Stima Sacco savings', "Account Category"::Income, "Budget Line Type"::Detail, '', 420620, 550000, 550000, 600000);
        LineNo += 10000;
        CreateBudgetLine(BudgetNo, LineNo, 'Dividends - Safaricom', "Account Category"::Income, "Budget Line Type"::Detail, '', 12198, 12000, 12000, 14028);
        LineNo += 10000;
        CreateBudgetLine(BudgetNo, LineNo, 'Dividends - Coopholding Society', "Account Category"::Income, "Budget Line Type"::Detail, '', 21395, 18000, 18000, 20000);
        LineNo += 10000;
        CreateBudgetLine(BudgetNo, LineNo, 'Entrance Fees', "Account Category"::Income, "Budget Line Type"::Detail, '', 13000, 13000, 15000, 15000);
        LineNo += 10000;
        CreateBudgetLine(BudgetNo, LineNo, 'Total Income', "Account Category"::Income, "Budget Line Type"::Total, '', 5338698, 5605000, 4607000, 5662734);
        LineNo += 10000;

        // EXPENSES SECTION
        CreateBudgetLine(BudgetNo, LineNo, 'Expenses', "Account Category"::Expenses, "Budget Line Type"::Header, '', 0, 0, 0, 0);
        LineNo += 10000;
        CreateBudgetLine(BudgetNo, LineNo, 'Interest on loans', "Account Category"::Expenses, "Budget Line Type"::Detail, '', 619422, 900000, 500000, 1000000);
        LineNo += 10000;
        CreateBudgetLine(BudgetNo, LineNo, 'Bank Charges', "Account Category"::Expenses, "Budget Line Type"::Detail, '', 69162, 90000, 90000, 100000);
        LineNo += 10000;
        CreateBudgetLine(BudgetNo, LineNo, 'Board Sitting Allowance', "Account Category"::Expenses, "Budget Line Type"::Detail, '', 420000, 600000, 600000, 600000);
        LineNo += 10000;
        CreateBudgetLine(BudgetNo, LineNo, 'Website', "Account Category"::Expenses, "Budget Line Type"::Detail, '', 4599, 0, 10000, 20000);
        LineNo += 10000;
        CreateBudgetLine(BudgetNo, LineNo, 'Printing and stationery', "Account Category"::Expenses, "Budget Line Type"::Detail, '', 4470, 0, 10000, 15000);
        LineNo += 10000;
        CreateBudgetLine(BudgetNo, LineNo, 'AGM Expenses', "Account Category"::Expenses, "Budget Line Type"::Detail, '', 60000, 100000, 100000, 150000);
        LineNo += 10000;
        CreateBudgetLine(BudgetNo, LineNo, 'Salaries & Wages', "Account Category"::Expenses, "Budget Line Type"::Detail, '', 1345741, 1440000, 1800000, 1560000);
        LineNo += 10000;
        CreateBudgetLine(BudgetNo, LineNo, 'Staff travel & subsistance', "Account Category"::Expenses, "Budget Line Type"::Detail, '', 13500, 20000, 20000, 30000);
        LineNo += 10000;
        CreateBudgetLine(BudgetNo, LineNo, 'Staff education', "Account Category"::Expenses, "Budget Line Type"::Detail, '', 44200, 100000, 150000, 200000);
        LineNo += 10000;
        CreateBudgetLine(BudgetNo, LineNo, 'Staff welfare', "Account Category"::Expenses, "Budget Line Type"::Detail, '', 8700, 24000, 24000, 36000);
        LineNo += 10000;
        CreateBudgetLine(BudgetNo, LineNo, 'Software Licenses', "Account Category"::Expenses, "Budget Line Type"::Detail, '', 84100, 100000, 150000, 200000);
        LineNo += 10000;
        CreateBudgetLine(BudgetNo, LineNo, 'Telephone & Postage', "Account Category"::Expenses, "Budget Line Type"::Detail, '', 12000, 18000, 18000, 24000);
        LineNo += 10000;
        CreateBudgetLine(BudgetNo, LineNo, 'Repairs & Maintenance', "Account Category"::Expenses, "Budget Line Type"::Detail, '', 0, 30000, 30000, 40000);
        LineNo += 10000;
        CreateBudgetLine(BudgetNo, LineNo, 'Staff medical Insurance', "Account Category"::Expenses, "Budget Line Type"::Detail, '', 193234, 220000, 220000, 250000);
        LineNo += 10000;
        CreateBudgetLine(BudgetNo, LineNo, 'Audit fee & VAT and Audit Expenses', "Account Category"::Expenses, "Budget Line Type"::Detail, '', 120000, 150000, 150000, 170000);
        LineNo += 10000;
        CreateBudgetLine(BudgetNo, LineNo, 'Capacity Building/ Growth of SACCO', "Account Category"::Expenses, "Budget Line Type"::Detail, '', 350000, 100000, 250000, 300000);
        LineNo += 10000;
        CreateBudgetLine(BudgetNo, LineNo, 'KRA Tax', "Account Category"::Expenses, "Budget Line Type"::Detail, '', 1503633, 1503631, 200000, 350000);
        LineNo += 10000;
        CreateBudgetLine(BudgetNo, LineNo, 'Supervision & Recoverable Expenses', "Account Category"::Expenses, "Budget Line Type"::Detail, '', 10200, 16000, 16000, 26000);
        LineNo += 10000;
        CreateBudgetLine(BudgetNo, LineNo, 'Proposed Honoraria', "Account Category"::Expenses, "Budget Line Type"::Detail, '', 132000, 165000, 165000, 165000);
        LineNo += 10000;
        CreateBudgetLine(BudgetNo, LineNo, 'Total Expenditure', "Account Category"::Expenses, "Budget Line Type"::Total, '', 4994961, 5576631, 4503000, 5236000);
        LineNo += 10000;
        CreateBudgetLine(BudgetNo, LineNo, 'Profit before tax', "Account Category"::Expenses, "Budget Line Type"::Total, '', 343737, 28369, 104000, 426734);
        LineNo += 10000;

        // CAPITAL EXPENDITURE SECTION
        CreateBudgetLine(BudgetNo, LineNo, 'Capital Expenditure', "Account Category"::Capital, "Budget Line Type"::Header, '', 0, 0, 0, 0);
        LineNo += 10000;
        CreateBudgetLine(BudgetNo, LineNo, 'New Financial Software', "Account Category"::Capital, "Budget Line Type"::Detail, '', 0, 0, 1500000, 500000);
    end;

    local procedure CreateBudgetLine(BudgetNo: Code[20]; LineNo: Integer; AccountName: Text; Category: Enum "Account Category"; LineType: Enum "Budget Line Type"; GLAccountNo: Code[20]; ActualsPrev: Decimal; ApprovedCurr: Decimal; RevisedCurr: Decimal; ProposedNext: Decimal)
    var
        BudgetLineRec: Record KrbscBudgetLines;
    begin
        BudgetLineRec.Init();
        BudgetLineRec."Budget No." := BudgetNo;
        BudgetLineRec."Line No." := LineNo;
        BudgetLineRec."Account Category" := Category;
        BudgetLineRec."Account Name" := CopyStr(AccountName, 1, MaxStrLen(BudgetLineRec."Account Name"));
        BudgetLineRec."Line Type" := LineType;
        BudgetLineRec."Sort Order" := LineNo;
        BudgetLineRec."G/L Account No." := GLAccountNo;
        BudgetLineRec."Actuals Previous Year" := ActualsPrev;
        BudgetLineRec."Approved Budget Current" := ApprovedCurr;
        BudgetLineRec."Revised Budget Current" := RevisedCurr;
        BudgetLineRec."Proposed Budget Next" := ProposedNext;
        BudgetLineRec.Insert(true);
    end;

    local procedure GetBudgetNo(): Code[20]
    var
        BudgetHeader: Record KrbscCustomBudget;
    begin
        // This should be implemented based on how you pass the Budget No. from the parent page
        // Option 1: If this page is used as a subpage, get from SubPageLink
        // Option 2: Use a global variable set by the parent page
        // Option 3: Get from current record context

        // For now, you'll need to implement this based on your specific setup
        // Example implementation if you have a way to get the current budget:
        if Rec."Budget No." <> '' then
            exit(Rec."Budget No.");

        // Alternative: Get from a filter or parent page context
        exit(''); // Return empty if no budget context
    end;

    var
        LineEditable: Boolean;
}