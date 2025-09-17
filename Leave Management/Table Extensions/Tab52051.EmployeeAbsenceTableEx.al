tableextension 52051 EmployeeAbsenceExt extends "Employee Absence"
{
    fields
    {
        field(52005; "Affects Leave"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Affects Leave';
        }
    }

    keys
    {
        // Add changes to keys here
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    var
        myInt: Integer;
}