table 59049 "KRB CheckoffLines"
{
    DataClassification = ToBeClassified;
    fields
    {
        field(1; "Receipt Header No"; Code[20])
        {
            TableRelation = "KRB Checkoff Header".No;
        }
        field(2; "Receipt Line No"; Integer)
        {
            AutoIncrement = true;
        }
        field(3; "Staff/Payroll No"; Code[20])
        {
            // TableRelation = Customer."Payroll/Staff No" where("Customer Type" = filter(Member));
        }
        field(4; "Member No"; Code[50])
        {
            TableRelation = Customer."No." where("Customer Type" = filter(Member));
        }
        field(17; "Member Found"; Boolean)
        {
        }
        field(5; "Name"; Code[50])
        {
        }
        field(6; "ID No."; Code[20])
        {
        }
        field(7; Posted; Boolean) { }
        field(34; "Co-op - Shares"; Decimal) { }
        field(35; "Co-op - Devt Loan"; Decimal) { }
        field(36; "Flexi"; Decimal) { }
        field(37; "Muslim Loan"; Decimal) { }
        field(38; "Co-op Emergency Loan"; Decimal) { }
        field(39; "Co-op - Investment Loan"; Decimal) { }
        field(40; "Co-op School Fees Loan"; Decimal) { }
        field(41; "Instant"; Decimal) { }
        field(42; "Childrens Savings"; Decimal) { }
        field(43; "Withdrwable svgs"; Decimal) { }
        field(44; "merry goround"; Decimal) { }
        field(45; "Dev2"; Decimal) { }
        field(46; "Share cap"; Decimal) { }
        field(47; "Entrance"; Decimal) { }
        field(48; "Insurance"; Decimal) { }
        field(49; "Refinance"; Decimal) { }
    }

    keys
    {
        key(Key1; "Receipt Header No", "Receipt Line No", "Staff/Payroll No")
        {
            Clustered = true;
        }
        key(Key2; "Receipt Line No")
        {
        }
        key(Key3; "Staff/Payroll No")
        {
        }
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}