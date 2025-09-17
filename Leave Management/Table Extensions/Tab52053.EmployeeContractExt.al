tableextension 52053 "EmployeeContractTableExt" extends "Employment Contract"
{
    fields
    {
        field(52000; "Employee Type"; Option)
        {
            OptionCaption = 'Permanent,Partime,Locum,Casual,Contract,Trustees';
            OptionMembers = Permanent,Partime,Locum,Casual,Contract,Trustees;
            DataClassification = CustomerContent;
            Caption = 'Employee Type';
        }
    }
}