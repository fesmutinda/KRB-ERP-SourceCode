#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Table 51018 "Loans Classification2."
{

    fields
    {
        field(1; "Sasra Category"; Option)
        {
            OptionCaption = 'Perfoming,Watch,Substandard,Doubtful,Loss';
            OptionMembers = Perfoming,Watch,Substandard,Doubtful,Loss;
        }
        field(2; "Num Account"; Integer)
        {
            CalcFormula = count("Loans Register" where("Loans Category" = field("Sasra Category"),
                                                        "Outstanding Balance" = filter(> 0)));
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Sasra Category")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

