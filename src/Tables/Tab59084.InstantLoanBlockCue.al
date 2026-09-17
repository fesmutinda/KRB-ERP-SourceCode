table 59084 "Instant Loan Block Cue"
{
    TableType = Temporary;
    DataClassification = SystemMetadata;
    fields
    {
        field(1; "Primary Key"; Code[10]) { }
        field(2; "Blocked Members"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count("Instant Loan Member Block" where(Blocked = const(true)));
        }
    }
    keys
    {
        key(PK; "Primary Key") { Clustered = true; }
    }
}
