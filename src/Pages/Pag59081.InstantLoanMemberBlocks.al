page 59081 "Instant Loan Member Blocks"
{
    Caption = 'Instant Loan Member Blocks';
    PageType = List;
    SourceTable = "Instant Loan Block Buffer";
    ApplicationArea = All;
    UsageCategory = Lists;
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(Members)
            {
                field("Member No."; Rec."Member No.") { ApplicationArea = All; Editable = false; }
                field("Member Name"; Rec."Member Name") { ApplicationArea = All; Editable = false; }
                field(Blocked; Rec.Blocked)
                {
                    ApplicationArea = All;
                    ToolTip = 'Select to block this member from applying for instant loans through the portal. Clear to unblock.';
                    trigger OnValidate()
                    var
                        BlockMgt: Codeunit "Instant Loan Block Mgt.";
                        MemberBlock: Record "Instant Loan Member Block";
                    begin
                        BlockMgt.SetBlocked(Rec."Member No.", Rec.Blocked, xRec.Blocked);
                        if MemberBlock.Get(Rec."Member No.") then begin
                            Rec."Changed By" := MemberBlock."Changed By";
                            Rec."Changed At" := MemberBlock."Changed At";
                        end;
                    end;
                }
                field("Changed By"; Rec."Changed By") { ApplicationArea = All; Editable = false; }
                field("Changed At"; Rec."Changed At") { ApplicationArea = All; Editable = false; }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(RefreshMembers)
            {
                Caption = 'Refresh';
                ApplicationArea = All;
                Image = Refresh;
                trigger OnAction()
                begin
                    LoadMembers();
                    CurrPage.Update(false);
                end;
            }
            action(BlockHistory)
            {
                Caption = 'Block History';
                ApplicationArea = All;
                Image = History;
                RunObject = page "Instant Loan Block History";
                RunPageLink = "Member No." = field("Member No.");
            }
        }
    }
    trigger OnOpenPage()
    begin
        LoadMembers();
    end;

    local procedure LoadMembers()
    var
        Member: Record Customer;
        MemberBlock: Record "Instant Loan Member Block";
    begin
        Rec.Reset();
        Rec.DeleteAll();
        Member.SetRange("Customer Type", Member."Customer Type"::Member);
        Member.SetRange("Customer Posting Group", 'MEMBER');
        if Member.FindSet() then
            repeat
                Rec.Init();
                Rec."Member No." := Member."No.";
                Rec."Member Name" := Member.Name;
                if MemberBlock.Get(Member."No.") then begin
                    Rec.Blocked := MemberBlock.Blocked;
                    Rec."Changed By" := MemberBlock."Changed By";
                    Rec."Changed At" := MemberBlock."Changed At";
                end;
                Rec.Insert();
            until Member.Next() = 0;
        if Rec.FindFirst() then;
    end;
}
