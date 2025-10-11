codeunit 52012 "Count Condition"
{
    procedure FnOnSendLoanApplicationForApproval(var LoansRegister: Record "Loans Register")
    var
        ApprovalMgmt: Codeunit "Approvals Mgmt."; // If ambiguous, use the full extension name or alias
        RecRef: RecordRef;
        WorkflowStepInstance: Record "Workflow Step Instance";
    begin
        RecRef.GetTable(LoansRegister);
        ApprovalMgmt.ApproveApprovalRequestsForRecord(RecRef, WorkflowStepInstance);
    end;
    // Event subscriber that monitors approval entry modifications
    [EventSubscriber(ObjectType::Table, Database::"Approval Entry", 'OnAfterModifyEvent', '', false, false)]
    local procedure OnAfterModifyApprovalEntry(var Rec: Record "Approval Entry"; var xRec: Record "Approval Entry"; RunTrigger: Boolean)
    var
        ApprovalEntry: Record "Approval Entry";
        RemainingEntry: Record "Approval Entry";
        NextSequenceEntry: Record "Approval Entry";
        ApprovalUserSetup: Record "User Setup";
        LoansRegister: Record "Loans Register";
        RecRef: RecordRef;
        ApprovedCount: Integer;
        RequiredApprovals: Integer;
        NextSequenceNo: Integer;
    begin
        // Only process when status changes TO Approved
        if (Rec.Status <> Rec.Status::Approved) or (xRec.Status = Rec.Status::Approved) then
            exit;

        // Sequence 1: Wait for 2 out of 3 approvals
        if Rec."Sequence No." = 1 then begin
            ApprovalEntry.Reset();
            ApprovalEntry.SetRange("Table ID", Rec."Table ID");
            ApprovalEntry.SetRange("Record ID to Approve", Rec."Record ID to Approve");
            ApprovalEntry.SetRange("Sequence No.", Rec."Sequence No.");
            ApprovalEntry.SetRange(Status, ApprovalEntry.Status::Approved);
            ApprovedCount := ApprovalEntry.Count();

            RequiredApprovals := 2;
            if ApprovedCount >= RequiredApprovals then begin
                // Cancel all remaining pending entries in current sequence
                CancelRemainingEntriesInSequence(Rec."Table ID", Rec."Record ID to Approve", Rec."Sequence No.");

                // Move to Sequence 2 (single approver)
                NextSequenceNo := Rec."Sequence No." + 1;
                NextSequenceEntry.Reset();
                NextSequenceEntry.SetRange("Table ID", Rec."Table ID");
                NextSequenceEntry.SetRange("Record ID to Approve", Rec."Record ID to Approve");
                NextSequenceEntry.SetRange("Sequence No.", NextSequenceNo);

                // If next sequence doesn't exist, create it with one approver
                if NextSequenceEntry.IsEmpty then
                    CreateNextSequenceApproval(Rec."Table ID", Rec."Record ID to Approve", NextSequenceNo, Rec."Sender ID")
                else
                    ActivateNextSequenceApprovals(Rec."Table ID", Rec."Record ID to Approve", NextSequenceNo);

                UpdateDocumentStatus(Rec."Table ID", Rec."Record ID to Approve", NextSequenceNo);
                Message('Approval threshold reached (%1 of %2 approvals). Moving to Sequence %3.',
                        ApprovedCount, RequiredApprovals, NextSequenceNo);
            end;
        end;

        // Sequence 2: Wait for single approval
        if Rec."Sequence No." = 2 then begin
            if Rec.Status = Rec.Status::Approved then begin
                UpdateDocumentStatus(Rec."Table ID", Rec."Record ID to Approve", Rec."Sequence No.");
                Message('Final approval done for Sequence 2. Document is now fully approved.');
            end;
        end;
    end;

    local procedure CancelRemainingEntriesInSequence(TableID: Integer; RecordIDToApprove: RecordID; SequenceNo: Integer)
    var
        RemainingEntry: Record "Approval Entry";
    begin
        // Find all pending (Created/Open) entries in current sequence
        RemainingEntry.Reset();
        RemainingEntry.SetRange("Table ID", TableID);
        RemainingEntry.SetRange("Record ID to Approve", RecordIDToApprove);
        RemainingEntry.SetRange("Sequence No.", SequenceNo);
        RemainingEntry.SetFilter(Status, '%1|%2',
                                 RemainingEntry.Status::Created,
                                 RemainingEntry.Status::Open);

        if RemainingEntry.FindSet(true) then
            repeat
                // Cancel the entry (not approve it!)
                RemainingEntry.Status := RemainingEntry.Status::Canceled;
                RemainingEntry."Last Date-Time Modified" := CurrentDateTime;
                RemainingEntry."Last Modified By User ID" := UserId;

                // Add explanation in comment
                if RemainingEntry.Comment then
                    RemainingEntry.Comment := false; // Reset to add new comment

                RemainingEntry.Modify(true);

                // Add comment explaining cancellation
                AddApprovalComment(RemainingEntry, 'Approval not required - threshold of 2 approvals already met.');

            until RemainingEntry.Next() = 0;
    end;

    local procedure CreateNextSequenceApproval(TableID: Integer; RecordIDToApprove: RecordID; NextSequenceNo: Integer; SenderID: Code[50])
    var
        ApprovalEntry: Record "Approval Entry";
        UserSetup: Record "User Setup";
        NewApprovalEntry: Record "Approval Entry";
        NextApproverID: Code[50];
        EntryNo: Integer;
    begin
        // Find the next approver from User Setup
        NextApproverID := GetNextApprover(SenderID, NextSequenceNo);

        if NextApproverID = '' then begin
            Message('No approver found for Sequence %1. Please check User Setup.', NextSequenceNo);
            exit;
        end;

        // Get last entry number
        ApprovalEntry.Reset();
        if ApprovalEntry.FindLast() then
            EntryNo := ApprovalEntry."Entry No." + 1
        else
            EntryNo := 1;

        // Create new approval entry for next sequence
        NewApprovalEntry.Init();
        NewApprovalEntry."Entry No." := EntryNo;
        NewApprovalEntry."Table ID" := TableID;
        NewApprovalEntry."Record ID to Approve" := RecordIDToApprove;
        NewApprovalEntry."Sequence No." := NextSequenceNo;
        NewApprovalEntry."Approval Code" := 'LOANAPP-01'; // Use your workflow code
        NewApprovalEntry."Sender ID" := SenderID;
        NewApprovalEntry."Approver ID" := NextApproverID;
        NewApprovalEntry.Status := NewApprovalEntry.Status::Open;
        NewApprovalEntry."Date-Time Sent for Approval" := CurrentDateTime;
        NewApprovalEntry."Last Date-Time Modified" := CurrentDateTime;
        NewApprovalEntry."Last Modified By User ID" := UserId;
        NewApprovalEntry."Due Date" := CalcDate('<+7D>', Today); // 7 days to approve

        NewApprovalEntry.Insert(true);

        // Send notification to next approver
        SendApprovalNotification(NewApprovalEntry);
    end;

    local procedure ActivateNextSequenceApprovals(TableID: Integer; RecordIDToApprove: RecordID; NextSequenceNo: Integer)
    var
        NextEntry: Record "Approval Entry";
    begin
        // Find entries in next sequence that are pending
        NextEntry.Reset();
        NextEntry.SetRange("Table ID", TableID);
        NextEntry.SetRange("Record ID to Approve", RecordIDToApprove);
        NextEntry.SetRange("Sequence No.", NextSequenceNo);
        NextEntry.SetRange(Status, NextEntry.Status::Created);

        if NextEntry.FindSet(true) then
            repeat
                // Activate the entry (change from Created to Open)
                NextEntry.Status := NextEntry.Status::Open;
                NextEntry."Date-Time Sent for Approval" := CurrentDateTime;
                NextEntry."Last Date-Time Modified" := CurrentDateTime;
                NextEntry."Last Modified By User ID" := UserId;
                NextEntry.Modify(true);

                // Send notification
                SendApprovalNotification(NextEntry);
            until NextEntry.Next() = 0;
    end;

    local procedure UpdateDocumentStatus(TableID: Integer; RecordIDToApprove: RecordID; CurrentSequence: Integer)
    var
        LoansRegister: Record "Loans Register";
        RecRef: RecordRef;
    begin
        // Only update if it's Loans Register table
        if TableID <> Database::"Loans Register" then
            exit;

        RecRef := RecordIDToApprove.GetRecord();
        RecRef.SetTable(LoansRegister);

        if LoansRegister.Get(LoansRegister."Loan  No.") then begin
            // Update status based on sequence
            if CurrentSequence = 2 then
                LoansRegister."Loan Status" := LoansRegister."Loan Status"::Appraisal // Or your custom status for Level 2
            else if CurrentSequence > 2 then
                LoansRegister."Loan Status" := LoansRegister."Loan Status"::Approved; // Final approval

            LoansRegister.Modify(true);
        end;
    end;

    local procedure GetNextApprover(CurrentApproverID: Code[50]; SequenceNo: Integer): Code[50]
    var
        UserSetup: Record "User Setup";
    begin
        // Find next approver from User Setup based on sequence
        UserSetup.Reset();
        UserSetup.SetRange("User ID", CurrentApproverID);
        if UserSetup.FindFirst() then begin
            // For Sequence 2, return the Approver ID from User Setup
            if SequenceNo = 2 then
                exit(UserSetup."Approver ID");
        end;

        exit('');
    end;

    local procedure AddApprovalComment(ApprovalEntry: Record "Approval Entry"; CommentText: Text[80])
    var
        ApprovalCommentLine: Record "Approval Comment Line";
        EntryNo: Integer;
    begin
        ApprovalCommentLine.Reset();
        if ApprovalCommentLine.FindLast() then
            EntryNo := ApprovalCommentLine."Entry No." + 1
        else
            EntryNo := 1;

        ApprovalCommentLine.Init();
        ApprovalCommentLine."Entry No." := EntryNo;
        ApprovalCommentLine."Table ID" := ApprovalEntry."Table ID";
        ApprovalCommentLine."Record ID to Approve" := ApprovalEntry."Record ID to Approve";
        ApprovalCommentLine."User ID" := UserId;
        ApprovalCommentLine."Date and Time" := CurrentDateTime;
        ApprovalCommentLine.Comment := CommentText;
        ApprovalCommentLine.Insert(true);
    end;

    local procedure SendApprovalNotification(ApprovalEntry: Record "Approval Entry")
    var
        NotificationMgt: Codeunit "Notification Management";
    begin
        // Send notification to approver
        // You can customize this based on your notification setup
        // This is a placeholder - implement based on your system

        // Option 1: Use standard BC notification
        // NotificationMgt.SendNotification(ApprovalEntry);

        // Option 2: Custom notification/email
        // SendEmailToApprover(ApprovalEntry."Approver ID");
    end;

    // Event subscriber for when final approval is done
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnApproveApprovalRequest', '', false, false)]
    local procedure OnFinalApproval(var ApprovalEntry: Record "Approval Entry")
    var
        AllApprovalEntries: Record "Approval Entry";
        LoansRegister: Record "Loans Register";
        RecRef: RecordRef;
        AllApproved: Boolean;
    begin
        // Check if this is the last approval needed
        AllApproved := true;
        AllApprovalEntries.Reset();
        AllApprovalEntries.SetRange("Table ID", ApprovalEntry."Table ID");
        AllApprovalEntries.SetRange("Record ID to Approve", ApprovalEntry."Record ID to Approve");
        AllApprovalEntries.SetFilter(Status, '<>%1&<>%2',
                                     AllApprovalEntries.Status::Approved,
                                     AllApprovalEntries.Status::Canceled);

        if AllApprovalEntries.IsEmpty then begin
            // All approvals complete - set final status
            if ApprovalEntry."Table ID" = Database::"Loans Register" then begin
                RecRef := ApprovalEntry."Record ID to Approve".GetRecord();
                RecRef.SetTable(LoansRegister);

                if LoansRegister.Get(LoansRegister."Loan  No.") then begin
                    LoansRegister."Loan Status" := LoansRegister."Loan Status"::Approved;
                    LoansRegister.Modify(true);

                    Message('Loan Application %1 has been fully approved!', LoansRegister."Loan  No.");
                end;
            end;
        end;
    end;
}