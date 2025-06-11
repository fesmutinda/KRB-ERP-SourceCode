tableextension 59052 "Cash Flow Category Setup" extends "G/L Account"
{
    fields
    {
        field(59052; "Cash Flow Category"; Option)
        {
            OptionMembers = "Operating","Investing","Financing";
        }
    }
}