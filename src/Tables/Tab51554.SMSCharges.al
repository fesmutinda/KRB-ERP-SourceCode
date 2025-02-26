#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Table 51554 "SMS Charges"
{
    LookupPageID = 50871;

    fields
    {
        field(1; "Charge Code"; Code[20])
        {
        }
        field(2; Source; Text[50])
        {
            FieldClass = Normal;
        }
        field(3; Amount; Decimal)
        {
        }
        field(4; "Charge Account"; Code[30])
        {
            TableRelation = "G/L Account"."No.";
        }
    }

    keys
    {
        key(Key1; "Charge Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

