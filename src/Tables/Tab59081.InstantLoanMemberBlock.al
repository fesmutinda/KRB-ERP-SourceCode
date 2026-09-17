table 59081 "Instant Loan Member Block"
{
    Caption = 'Instant Loan Member Block';
    DataClassification = CustomerContent;
    Permissions = tabledata "Instant Loan Block History" = I;

    fields
    {
        field(1; "Member No."; Code[20])
        {
            TableRelation = Customer."No.";
        }
        field(2; Blocked; Boolean) { }
        field(3; "Changed By"; Code[50]) { Editable = false; }
        field(4; "Changed At"; DateTime) { Editable = false; }
    }
    keys
    {
        key(PK; "Member No.") { Clustered = true; }
        key(BlockedMembers; Blocked) { }
    }

    trigger OnInsert()
    var
        Member: Record Customer;
    begin
        TestField("Member No.");
        Member.Get("Member No.");
        RecordChange();
    end;

    trigger OnModify()
    begin
        if Blocked <> xRec.Blocked then
            RecordChange();
    end;

    trigger OnDelete()
    begin
        Error('Uncheck Blocked to unblock the member. Block records cannot be deleted.');
    end;

    trigger OnRename()
    begin
        Error('The member number cannot be changed.');
    end;

    local procedure RecordChange()
    var
        History: Record "Instant Loan Block History";
    begin
        "Changed By" := CopyStr(UserId(), 1, MaxStrLen("Changed By"));
        "Changed At" := CurrentDateTime();
        History.Init();
        History."Member No." := "Member No.";
        History.Blocked := Blocked;
        History."Changed By" := "Changed By";
        History."Changed At" := "Changed At";
        History.Insert(true);
    end;
}
