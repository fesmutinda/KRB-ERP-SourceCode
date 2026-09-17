table 59077 "Loan Product Selection"
{
    TableType = Temporary;
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Product Code"; Code[20]) { }
        field(2; Description; Text[30]) { }
        field(3; Selected; Boolean) { }
    }

    keys
    {
        key(PK; "Product Code") { Clustered = true; }
    }
}
