#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Table 51908 "Package Types"
{
    DrillDownPageID = 50941;
    LookupPageID = 50941;

    fields
    {
        field(1; "Code"; Code[20])
        {
        }
        field(2; "Package Description"; Text[30])
        {
        }
        field(3; "Package Charge"; Decimal)
        {
        }
        field(4; "Package Charge Account"; Code[20])
        {
            TableRelation = "G/L Account"."No.";
        }
        field(5; "Package Retrieval Fee"; Decimal)
        {
        }
        field(6; "Package Retrieval Fee Account"; Code[20])
        {
            TableRelation = "G/L Account"."No.";
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

