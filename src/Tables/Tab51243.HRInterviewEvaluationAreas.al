#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Table 51243 "HR Interview Evaluation Areas"
{

    fields
    {
        field(10; "Evaluation Code"; Code[50])
        {
        }
        field(20; "Evaluation Description"; Text[250])
        {
        }
    }

    keys
    {
        key(Key1; "Evaluation Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

