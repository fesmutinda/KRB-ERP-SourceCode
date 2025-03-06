#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
table 50540 "CloudPESA Paybill Buffer"
{

    fields
    {
        field(1; "Receipt No."; Code[20])
        {
        }
        field(2; "Completion Time"; Text[30])
        {
        }
        field(3; "Initiation Time"; Text[50])
        {
        }
        field(4; Details; Text[250])
        {
        }
        field(5; "Transaction Status"; Text[250])
        {
        }
        field(6; "Paid In"; Decimal)
        {
        }
        field(7; Withdrawn; Text[250])
        {
        }
        field(8; Balance; Decimal)
        {
        }
        field(9; "Balance Confirmed"; Text[30])
        {
        }
        field(10; "Reason Type"; Text[250])
        {
        }
        field(11; "Other Party Info"; Text[250])
        {
        }
        field(12; "Linked Transaction ID"; Text[250])
        {
        }
        field(13; "A/C No."; Text[250])
        {
        }
    }

    keys
    {
        key(Key1; "Receipt No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

