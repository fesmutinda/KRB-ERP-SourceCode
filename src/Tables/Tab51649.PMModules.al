#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Table 51649 "PM Modules"
{

    fields
    {
        field(1; "Code"; Code[100])
        {
        }
        field(2; "Module Name"; Text[100])
        {
        }
        field(3; New; Integer)
        {
            CalcFormula = count("Loans reg" where("Customer Status" = filter(New),
                                                   "Module Code" = field(Code)));
            FieldClass = FlowField;
        }
        field(4; WIP; Integer)
        {
            CalcFormula = count("Loans reg" where("Customer Status" = filter(WIP),
                                                   "Module Code" = field(Code)));
            FieldClass = FlowField;
        }
        field(5; Resolved; Integer)
        {
            CalcFormula = count("Loans reg" where("Customer Status" = filter(Resolved),
                                                   "Module Code" = field(Code)));
            FieldClass = FlowField;
        }
        field(6; Rejected; Integer)
        {
            CalcFormula = count("Loans reg" where("Customer Status" = filter(Rejected),
                                                   "Module Code" = field(Code)));
            FieldClass = FlowField;
        }
        field(7; "Total Items"; Integer)
        {
            CalcFormula = count("Loans reg" where("Module Code" = field(Code)));
            FieldClass = FlowField;
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

