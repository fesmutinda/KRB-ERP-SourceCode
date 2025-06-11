codeunit 59057 "Post Interest Journal Job"
{
    trigger OnRun()
    var
        GenJnlLine: Record "Gen. Journal Line";
        GenJnlPostBatch: Codeunit "Gen. Jnl.-Post Batch";
        JournalTemplateName: Code[10];
        JournalBatchName: Code[10];
    begin
        JournalTemplateName := 'General';
        JournalBatchName := 'INT DUE';

        GenJnlLine.SetRange("Journal Template Name", JournalTemplateName);
        GenJnlLine.SetRange("Journal Batch Name", JournalBatchName);

        if GenJnlLine.IsEmpty then
            exit; // Nothing to post

        GenJnlPostBatch.Run(GenJnlLine);
    end;
}

