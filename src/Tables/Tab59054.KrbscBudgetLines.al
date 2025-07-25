table 59054 "KrbscBudgetLines"
{
    Caption = 'Budget Lines';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Budget No."; Code[20])
        {
            Caption = 'Budget No.';
            TableRelation = "KrbscCustomBudget"."Budget No.";
        }

        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }

        field(3; "Account Category"; Enum "Account Category")
        {
            Caption = 'Account Category';
        }

        field(4; "Account Name"; Text[100])
        {
            Caption = 'Account Name';
        }

        field(5; "G/L Account No."; Code[20])
        {
            Caption = 'G/L Account No.';
            TableRelation = "G/L Account";

            trigger OnValidate()
            var
                GLAccount: Record "G/L Account";
            begin
                if "G/L Account No." <> '' then begin
                    GLAccount.Get("G/L Account No.");
                    "G/L Account Name" := GLAccount.Name;
                end else
                    "G/L Account Name" := '';
            end;
        }

        field(6; "G/L Account Name"; Text[100])
        {
            Caption = 'G/L Account Name';
            Editable = false;
        }

        field(10; "Actuals Previous Year"; Decimal)
        {
            Caption = 'Actuals Previous Year';
            DecimalPlaces = 2 : 2;
        }

        field(11; "Approved Budget Current"; Decimal)
        {
            Caption = 'Approved Budget Current';
            DecimalPlaces = 2 : 2;
        }

        field(12; "Revised Budget Current"; Decimal)
        {
            Caption = 'Revised Budget Current';
            DecimalPlaces = 2 : 2;
        }

        field(13; "Proposed Budget Next"; Decimal)
        {
            Caption = 'Proposed Budget Next';
            DecimalPlaces = 2 : 2;
        }

        field(20; "Line Type"; Enum "Budget Line Type")
        {
            Caption = 'Line Type';
        }

        field(21; "Sort Order"; Integer)
        {
            Caption = 'Sort Order';
        }

    }

    keys
    {
        key(PK; "Budget No.", "Line No.")
        {
            Clustered = true;
        }

        key(Sorting; "Budget No.", "Account Category", "Sort Order")
        {
        }
    }
}