codeunit 59085 "Interest Insights Mgt."
{
    procedure BaseAccountFilter(): Text
    begin
        exit('4101..4110&<>4107&<>4109');
    end;

    procedure ResolveAccountFilter(ProductCode: Code[20]): Text
    var
        Product: Record "Loan Products Setup";
        Account: Record "G/L Account";
        ExactFilter: Text;
    begin
        if ProductCode = '' then
            exit(BaseAccountFilter());
        Product.Get(ProductCode);
        Product.TestField("Loan Interest Account");
        Account.SetRange("No.", Product."Loan Interest Account");
        ExactFilter := Account.GetFilter("No.");
        Account.SetFilter("No.", BaseAccountFilter() + '&(' + ExactFilter + ')');
        if Account.IsEmpty() then
            Error('The interest account for product %1 is outside the configured interest-income accounts.', ProductCode);
        exit(ExactFilter);
    end;

    procedure FilterEntries(var Entry: Record "G/L Entry"; AccountFilter: Text; FromDate: Date; ToDate: Date)
    begin
        Entry.Reset();
        Entry.SetCurrentKey("G/L Account No.", "Posting Date");
        Entry.SetFilter("G/L Account No.", AccountFilter);
        Entry.SetRange("Posting Date", FromDate, ToDate);
    end;

    procedure NetInterest(AccountFilter: Text; FromDate: Date; ToDate: Date): Decimal
    var
        Entry: Record "G/L Entry";
        NetAmount: Decimal;
    begin
        FilterEntries(Entry, AccountFilter, FromDate, ToDate);
        Entry.SetLoadFields("Posting Date", Amount);
        if Entry.FindSet() then
            repeat
                // Include corrections and both sides of reversals in their posting periods.
                // Closing entries transfer income to equity; they are not negative earnings.
                if Entry."Posting Date" = NormalDate(Entry."Posting Date") then
                    NetAmount -= Entry.Amount;
            until Entry.Next() = 0;
        exit(NetAmount);
    end;

    procedure ShowEntries(AccountFilter: Text; FromDate: Date; ToDate: Date)
    var
        Entry: Record "G/L Entry";
    begin
        FilterEntries(Entry, AccountFilter, FromDate, ToDate);
        if Entry.FindSet() then
            repeat
                if Entry."Posting Date" = NormalDate(Entry."Posting Date") then
                    Entry.Mark(true);
            until Entry.Next() = 0;
        Entry.MarkedOnly(true);
        Page.Run(Page::"General Ledger Entries", Entry);
    end;

    procedure PriorYearDate(AsAtDate: Date): Date
    begin
        exit(CalcDate('<-1Y>', AsAtDate));
    end;

    procedure ChangeText(CurrentAmount: Decimal; PreviousAmount: Decimal): Text
    var
        ChangePercent: Decimal;
    begin
        if PreviousAmount <= 0 then
            exit('N/A (prior period is zero or negative)');
        ChangePercent := Round((CurrentAmount - PreviousAmount) / PreviousAmount * 100, 0.1);
        if ChangePercent > 0 then
            exit('+' + Format(ChangePercent) + '%');
        exit(Format(ChangePercent) + '%');
    end;

    procedure AccountProductDescriptions(AccountNo: Code[20]): Text
    var
        Product: Record "Loan Products Setup";
        Descriptions: List of [Text];
        Names: Text;
    begin
        Product.SetRange("Loan Interest Account", AccountNo);
        if Product.FindSet() then
            repeat
                if (Product."Product Description" <> '') and
                   not Descriptions.Contains(Product."Product Description") then begin
                    Descriptions.Add(Product."Product Description");
                    if Names <> '' then
                        Names += '; ';
                    Names += Product."Product Description";
                end;
            until Product.Next() = 0;
        exit(Names);
    end;

    procedure AccountProducts(AccountNo: Code[20]): Text
    var
        Product: Record "Loan Products Setup";
        Names: Text;
    begin
        Product.SetRange("Loan Interest Account", AccountNo);
        if Product.FindSet() then
            repeat
                if Names <> '' then
                    Names += '; ';
                Names += Product.Code + ' ' + Product."Product Description";
            until Product.Next() = 0;
        if Names = '' then
            Names := 'No product mapping';
        exit(Names);
    end;
}
