table 59083 "Instant Loan Block Buffer"
{
    TableType = Temporary;
    DataClassification = CustomerContent;
    fields
    {
        field(1; "Member No."; Code[20]) { }
        field(2; "Member Name"; Text[100]) { }
        field(3; Blocked; Boolean) { Caption = 'Block Instant Loans'; }
        field(4; "Changed By"; Code[50]) { }
        field(5; "Changed At"; DateTime) { }
    }
    keys
    {
        key(PK; "Member No.") { Clustered = true; }
    }
}
