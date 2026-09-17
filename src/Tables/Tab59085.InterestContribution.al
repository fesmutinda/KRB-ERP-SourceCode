table 59085 "Interest Contribution"
{
    TableType = Temporary;
    DataClassification = CustomerContent;
    fields
    {
        field(1; "Account No."; Code[20]) { }
        field(2; "Account Name"; Text[100]) { }
        field(3; Products; Text[2048]) { }
        field(4; "Net Interest"; Decimal) { AutoFormatType = 1; }
        field(5; "Share of Total"; Text[50]) { }
        field(6; "From Date"; Date) { }
        field(7; "To Date"; Date) { }
    }
    keys
    {
        key(PK; "Account No.") { Clustered = true; }
        key(Contribution; "Net Interest") { }
    }
}
