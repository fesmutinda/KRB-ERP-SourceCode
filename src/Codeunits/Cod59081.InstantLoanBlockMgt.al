codeunit 59081 "Instant Loan Block Mgt."
{
    procedure IsBlocked(MemberNo: Code[60]; ProductCode: Text): Boolean
    var
        MemberBlock: Record "Instant Loan Member Block";
    begin
        // These are the instant products used by the existing instant loan pages.
        if not (UpperCase(ProductCode) in ['LT006', 'LT007']) then
            exit(false);
        if StrLen(MemberNo) > MaxStrLen(MemberBlock."Member No.") then
            exit(false);
        if MemberBlock.Get(MemberNo) then
            exit(MemberBlock.Blocked);
        exit(false);
    end;

    procedure CheckAvailable(MemberNo: Code[60]; ProductCode: Text)
    begin
        if IsBlocked(MemberNo, ProductCode) then
            Error(UnavailableMessage());
    end;

    procedure UnavailableMessage(): Text
    begin
        exit(LoanUnavailableLbl);
    end;

    procedure SetBlocked(MemberNo: Code[20]; NewBlocked: Boolean; ExpectedBlocked: Boolean)
    var
        MemberBlock: Record "Instant Loan Member Block";
        Member: Record Customer;
    begin
        Member.Get(MemberNo);
        MemberBlock.LockTable();
        if MemberBlock.Get(MemberNo) then begin
            if MemberBlock.Blocked <> ExpectedBlocked then
                Error('The block status has changed. Refresh the list and try again.');
            if MemberBlock.Blocked = NewBlocked then
                exit;
            MemberBlock.Blocked := NewBlocked;
            MemberBlock.Modify(true);
        end else begin
            if ExpectedBlocked then
                Error('The block status has changed. Refresh the list and try again.');
            if not NewBlocked then
                exit;
            MemberBlock.Init();
            MemberBlock."Member No." := MemberNo;
            MemberBlock.Blocked := NewBlocked;
            MemberBlock.Insert(true);
        end;
    end;

    var
        LoanUnavailableLbl: Label 'Loan not available', Locked = true;
}
