table 59053 "KrbscCustomBudget"
{
    Caption = 'Custom Budget';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Budget No."; Code[20])
        {
            Caption = 'Budget No.';
        }

        field(2; "Budget Name"; Text[100])
        {
            Caption = 'Budget Name';
        }

        field(3; "Budget Year"; Integer)
        {
            Caption = 'Budget Year';
            NotBlank = true;
        }

        field(4; "Budget Type"; Enum "Budget Type")
        {
            Caption = 'Budget Type';
        }

        // field(5; "Status"; Enum "Budget Status")
        // {
        //     Caption = 'Status';
        // }

        field(6; "Description"; Text[250])
        {
            Caption = 'Description';
        }

        field(10; "Created By"; Code[50])
        {
            Caption = 'Created By';
            Editable = false;
        }

        field(11; "Created Date"; DateTime)
        {
            Caption = 'Created Date';
            Editable = false;
        }

        // Add other header-level fields like department, responsible person, etc.
    }

    keys
    {
        key(PK; "Budget No.")
        {
            Clustered = true;
        }
    }
}