page 59085 "Interest Contributions"
{
    Caption = 'Interest Contributions by Product / Account';
    PageType = List;
    SourceTable = "Interest Contribution";
    Editable = false;
    layout
    {
        area(Content)
        {
            group(Context)
            {
                field(Period; PeriodText) { ApplicationArea = All; Caption = 'Period'; }
                field(Basis; BasisText)
                {
                    ApplicationArea = All;
                    Caption = 'Basis';
                    ToolTip = 'Products sharing an interest account are grouped. Amounts are net posted income, not cash collected. Negative adjustments are retained.';
                }
            }
            repeater(Contributions)
            {
                field("Account No."; Rec."Account No.") { ApplicationArea = All; }
                field("Account Name"; Rec."Account Name") { ApplicationArea = All; }
                field(Products; Rec.Products) { ApplicationArea = All; }
                field("Net Interest"; Rec."Net Interest")
                {
                    ApplicationArea = All;
                    DrillDown = true;
                    trigger OnDrillDown()
                    begin
                        ShowEntries();
                    end;
                }
                field("Share of Total"; Rec."Share of Total") { ApplicationArea = All; }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(Entries)
            {
                Caption = 'Ledger Entries';
                ApplicationArea = All;
                Image = LedgerEntries;
                trigger OnAction()
                begin
                    ShowEntries();
                end;
            }
        }
    }

    procedure LoadContributions(AccountFilter: Text; FromDate: Date; ToDate: Date; CurrencyCode: Code[10])
    var
        Account: Record "G/L Account";
        Total: Decimal;
    begin
        Rec.Reset();
        Rec.DeleteAll();
        PeriodText := Format(FromDate) + ' - ' + Format(ToDate);
        BasisText := 'Net interest posted (' + CurrencyCode + '); shared accounts grouped';
        Total := Insights.NetInterest(AccountFilter, FromDate, ToDate);
        Account.SetFilter("No.", AccountFilter);
        if Account.FindSet() then
            repeat
                Rec.Init();
                Rec."Account No." := Account."No.";
                Rec."Account Name" := Account.Name;
                Rec.Products := CopyStr(Insights.AccountProducts(Account."No."), 1, MaxStrLen(Rec.Products));
                Rec."Net Interest" := Insights.NetInterest(ExactAccountFilter(Account."No."), FromDate, ToDate);
                Rec."Share of Total" := 'N/A';
                if Total > 0 then
                    Rec."Share of Total" := Format(Round(Rec."Net Interest" / Total * 100, 0.1)) + '%';
                Rec."From Date" := FromDate;
                Rec."To Date" := ToDate;
                Rec.Insert();
            until Account.Next() = 0;
        Rec.SetCurrentKey("Net Interest");
        Rec.Ascending(false);
        if Rec.FindFirst() then;
    end;

    local procedure ExactAccountFilter(AccountNo: Code[20]): Text
    var
        Account: Record "G/L Account";
    begin
        Account.SetRange("No.", AccountNo);
        exit(Account.GetFilter("No."));
    end;

    local procedure ShowEntries()
    begin
        Insights.ShowEntries(ExactAccountFilter(Rec."Account No."), Rec."From Date", Rec."To Date");
    end;

    var
        Insights: Codeunit "Interest Insights Mgt.";
        PeriodText: Text;
        BasisText: Text;
}
