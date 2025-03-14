#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Table 51565 "MWithdrawal Graduated Charges"
{
    Caption = 'Member Exit Graduated Charges';
    DrillDownPageID = 50040;
    LookupPageID = 50040;

    fields
    {
        field(1; "Minimum Amount"; Decimal)
        {
        }
        field(2; "Maximum Amount"; Decimal)
        {
        }
        field(3; Amount; Decimal)
        {
        }
        field(4; "Use Percentage"; Boolean)
        {
        }
        field(5; "Percentage of Amount"; Decimal)
        {
            DecimalPlaces = 3 : 3;
        }
        field(6; "Charge Account"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(7; "Notice Status"; Option)
        {
            OptionCaption = ' ,Notified,Prior Notice';
            OptionMembers = " ",Notified,"Prior Notice";
        }
    }

    keys
    {
        key(Key1; "Minimum Amount", "Maximum Amount", "Percentage of Amount", Amount)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

