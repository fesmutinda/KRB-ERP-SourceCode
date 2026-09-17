pageextension 59084 "General Cue Loan Blocks" extends "General Cue"
{
    layout
    {
        addlast(ApprovalRequestCue)
        {
            field(BlockedInstantLoanMembers; BlockedMemberCount)
            {
                Caption = 'Blocked Instant Loan Members';
                ApplicationArea = All;
                Visible = false;
                AccessByPermission = tabledata "Instant Loan Member Block" = M;
                DrillDown = true;
                ToolTip = 'View blocked members and check or uncheck instant loan access.';

                trigger OnDrillDown()
                begin
                    Page.RunModal(Page::"Instant Loan Member Blocks");
                    RefreshBlockedMemberCount();
                    CurrPage.Update(false);
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        RefreshBlockedMemberCount();
    end;

    local procedure RefreshBlockedMemberCount()
    var
        MemberBlock: Record "Instant Loan Member Block";
    begin
        BlockedMemberCount := 0;
        // General Cue is shared with profiles that do not have block-list access.
        if not MemberBlock.ReadPermission() then
            exit;
        MemberBlock.SetRange(Blocked, true);
        BlockedMemberCount := MemberBlock.Count();
    end;

    var
        BlockedMemberCount: Integer;
}
