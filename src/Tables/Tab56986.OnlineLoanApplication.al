#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Table 59047 "Online Loan Application"
{

    fields
    {
        field(1; "Application No"; Integer)
        {
            AutoIncrement = true;
        }
        field(2; "Loan Type"; Code[20]) { }
        field(3; "BOSA No"; Code[20]) { }
        field(4; "Id No"; Code[20]) { }
        field(5; "Employment No"; Code[20]) { }
        field(6; "Member Names"; Code[20]) { }
        field(7; "Date of Birth"; Date) { }
        field(8; "Membership No"; Code[20]) { }
        field(9; "Application Date"; DateTime) { }
        field(10; Email; Code[20]) { }
        field(11; Telephone; Code[20]) { }
        field(12; "Home Address"; Code[20]) { }
        field(13; Station; Code[20]) { }
        field(14; "Loan Amount"; Decimal) { }
        field(15; "Repayment Period"; Integer) { }
        field(16; Source; Option)
        {
            OptionCaption = ' ,BOSA,FOSA,Investment,MICRO';
            OptionMembers = " ",BOSA,FOSA,Investment,MICRO;
        }
        field(17; "Interest Rate"; Decimal) { }
        field(18; "Loan Purpose"; Code[50]) { }
        field(19; "Sent To Bosa Loans"; Boolean) { }
        field(20; submitted; Boolean) { }
        field(21; Posted; Boolean) { }
        field(22; Refno; Code[20]) { }
        field(23; "Loan No"; Code[20]) { }
        // field(7; Email; Code[20]) { }
    }

    keys
    {
        key(Key1; "Application No")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
    end;

    var
        MyRecRef: RecordRef;
        OnlineLoanTable: Record "Online Loan Application";
        RecordLink: Record "Record Link";
}

