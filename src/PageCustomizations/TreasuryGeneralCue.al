pagecustomization "Treasury General Cue" customizes "General Cue"
{
    layout
    {
        modify(BlockedInstantLoanMembers)
        {
            Visible = true;
        }
        modify("Requests Sent for Approval")
        {
            Visible = false;
        }
        modify("Requests Sent for Approval Al.")
        {
            Visible = false;
        }
        modify("Leave Approval Requests")
        {
            Visible = false;
        }
        modify("MemberApp Requests to Approve")
        {
            Visible = false;
        }
    }
}
