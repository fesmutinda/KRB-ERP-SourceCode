#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
page 50610 "Funeral Expense Card"
{
    SourceTable = "Funeral Expense Payment";

    layout
    {
        area(content)
        {
            field("No."; Rec."No.")
            {
                ApplicationArea = Basic;
                Editable = false;
            }
            field("Member No."; Rec."Member No.")
            {
                ApplicationArea = Basic;
            }
            field("Member Name"; Rec."Member Name")
            {
                ApplicationArea = Basic;
                Editable = false;
            }
            field("Member ID No"; Rec."Member ID No")
            {
                ApplicationArea = Basic;
                Editable = false;
            }
            field("Member Status"; Rec."Member Status")
            {
                ApplicationArea = Basic;
                Editable = false;
            }
            field("Death Date"; Rec."Death Date")
            {
                ApplicationArea = Basic;
            }
            field("Date Reported"; Rec."Date Reported")
            {
                ApplicationArea = Basic;
            }
            field("Reported By"; Rec."Reported By")
            {
                ApplicationArea = Basic;
            }
            field("Reporter ID No."; Rec."Reporter ID No.")
            {
                ApplicationArea = Basic;
            }
            field("Reporter Mobile No"; Rec."Reporter Mobile No")
            {
                ApplicationArea = Basic;
            }
            field("Reporter Address"; Rec."Reporter Address")
            {
                ApplicationArea = Basic;
            }
            field("Relationship With Deceased"; Rec."Relationship With Deceased")
            {
                ApplicationArea = Basic;
            }
            field("Received Burial Permit"; Rec."Received Burial Permit")
            {
                ApplicationArea = Basic;
            }
            field("Mode Of Disbursement"; Rec."Mode Of Disbursement")
            {
                ApplicationArea = Basic;
            }
            field("Paying Bank"; Rec."Paying Bank")
            {
                ApplicationArea = Basic;
            }
            field("Received Letter From Chief"; Rec."Received Letter From Chief")
            {
                ApplicationArea = Basic;
            }
            field(Posted; Rec.Posted)
            {
                ApplicationArea = Basic;
                Editable = false;
            }
            field("Date Posted"; Rec."Date Posted")
            {
                ApplicationArea = Basic;
                Editable = false;
            }
            field("Time Posted"; Rec."Time Posted")
            {
                ApplicationArea = Basic;
                Editable = false;
            }
            field("Posted By"; Rec."Posted By")
            {
                ApplicationArea = Basic;
                Editable = false;
            }
            field(Status; Rec.Status)
            {
                ApplicationArea = Basic;
                Editable = false;
            }
        }
    }

    actions
    {
        area(creation)
        {
            
            action("Send Approval Request")
            {
                ApplicationArea = Basic;
                Caption = 'Send A&pproval Request';
                Image = SendApprovalRequest;
                Promoted = true;
                PromotedCategory = Category4;

                trigger OnAction()
                var
                    text001: label 'This batch is already pending approval';
                    ApprovalMgt: Codeunit "Approvals Mgmt.";
                begin
                    if Rec.Status <> Rec.Status::Open then
                        Error(text001);

                    //End allocate batch number
                    Doc_Type := Doc_type::"Member Closure";
                    Table_id := Database::"Membership Exit";
                    //IF ApprovalMgt.SendApproval(Table_id,"No.",Doc_Type,Status)THEN;
                end;
            }
            action("Cancel Approval Request")
            {
                ApplicationArea = Basic;
                Caption = 'Cancel A&pproval Request';
                Image = Cancel;
                Promoted = true;
                PromotedCategory = Category4;

                trigger OnAction()
                var
                    text001: label 'This batch is already pending approval';
                    ApprovalMgt: Codeunit "Approvals Mgmt.";
                begin
                    if Rec.Status <> Rec.Status::Open then
                        Error(text001);

                    //End allocate batch number
                    //ApprovalMgt.CancelClosureApprovalRequest(Rec);
                end;
            }
            action(Post)
            {
                ApplicationArea = Basic;
                Caption = 'Post';
                Image = Post;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin

                    //Delete journal line
                    Gnljnline.Reset;
                    Gnljnline.SetRange("Journal Template Name", 'GENERAL');
                    Gnljnline.SetRange("Journal Batch Name", 'FRIDER');
                    Gnljnline.DeleteAll;
                    //End of deletion


                    DActivity := Cust."Global Dimension 1 Code";
                    DBranch := Cust."Global Dimension 2 Code";
                    Cust.CalcFields(Cust."Outstanding Balance", "Accrued Interest", "Current Shares");

                    Cust.CalcFields(Cust."Outstanding Balance", Cust."Outstanding Interest", "FOSA Outstanding Balance", "Accrued Interest", "Insurance Fund", "Current Shares");

                    Generalsetup.Get();

                    LineNo := LineNo + 10000;
                    GenJournalLine.Init;
                    GenJournalLine."Journal Template Name" := 'GENERAL';
                    GenJournalLine."Journal Batch Name" := 'FRIDER';
                    GenJournalLine."Line No." := LineNo;
                    GenJournalLine."Document No." := Rec."No.";
                    GenJournalLine."Posting Date" := Today;
                    GenJournalLine."External Document No." := Rec."No.";
                    GenJournalLine."Account Type" := GenJournalLine."account type"::Customer;
                    GenJournalLine."Account No." := Rec."Member No.";
                    GenJournalLine.Validate(GenJournalLine."Account No.");
                    GenJournalLine.Description := 'Funeral Rider';
                    GenJournalLine.Amount := Generalsetup."Funeral Expense Amount";
                    GenJournalLine.Validate(GenJournalLine.Amount);
                    GenJournalLine."Transaction Type" := GenJournalLine."transaction type"::"Benevolent Fund";
                    GenJournalLine."Bal. Account No." := Rec."Paying Bank";
                    GenJournalLine."Bal. Account Type" := GenJournalLine."bal. account type"::"Bank Account";
                    GenJournalLine."Shortcut Dimension 1 Code" := DActivity;
                    GenJournalLine."Shortcut Dimension 2 Code" := DBranch;
                    GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 1 Code");
                    GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 2 Code");
                    if GenJournalLine.Amount <> 0 then
                        GenJournalLine.Insert;

                    //Post New
                    GenJournalLine.Reset;
                    GenJournalLine.SetRange("Journal Template Name", 'GENERAL');
                    GenJournalLine.SetRange("Journal Batch Name", 'FRIDER');
                    if GenJournalLine.Find('-') then begin
                        Codeunit.Run(Codeunit::"Gen. Jnl.-Post Batch", GenJournalLine);
                    end;


                    Rec.Posted := true;
                    Rec."Posted By" := UserId;
                    Rec."Time Posted" := Time;
                    Rec.Modify;
                    Message('Funeral Rider posted successfully.');

                    //CHANGE ACCOUNT STATUS
                    Cust.Reset;
                    Cust.SetRange(Cust."No.", Rec."Member No.");
                    if Cust.Find('-') then begin
                        Cust.Status := Cust.Status::Deceased;
                        Cust.Blocked := Cust.Blocked::All;
                        Cust.Modify;
                    end;
                end;
            }
        }
    }

    var
        Generalsetup: Record "Sacco General Set-Up";
        Gnljnline: Record "Gen. Journal Line";
        DocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None",JV,"Member Closure","Account Opening",Batches,"Payment Voucher","Petty Cash",Requisition,Loan,Interbank,Imprest,Checkoff;
        DActivity: Code[30];
        DBranch: Code[30];
        LineNo: Integer;
        GenJournalLine: Record "Gen. Journal Line";
        Table_id: Integer;
        Doc_No: Code[20];
        Doc_Type: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None","Payment Voucher","Petty Cash",Imprest,Requisition,ImprestSurrender,Interbank,TransportRequest,Maintenance,Fuel,ImporterExporter,"Import Permit","Export Permit",TR,"Safari Notice","Student Applications","Water Research","Consultancy Requests","Consultancy Proposals","Meals Bookings","General Journal","Student Admissions","Staff Claim",KitchenStoreRequisition,"Leave Application","Account Opening","Member Closure",Loan,"Loan Batch";
        Cust: Record Customer;
}

