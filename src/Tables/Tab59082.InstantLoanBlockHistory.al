table 59082 "Instant Loan Block History"
{
    Caption = 'Instant Loan Block History';
    DataClassification = CustomerContent;
    fields
    {
        field(1; "Entry No."; Integer) { AutoIncrement = true; }
        field(2; "Member No."; Code[20]) { TableRelation = Customer."No."; }
        field(3; Blocked; Boolean) { }
        field(4; "Changed By"; Code[50]) { }
        field(5; "Changed At"; DateTime) { }
    }
    keys
    {
        key(PK; "Entry No.") { Clustered = true; }
        key(MemberHistory; "Member No.", "Entry No.") { }
    }
}
