#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
page 50847 "Funeral Expenses."
{
    SourceTable = 51549;

    layout
    {
        area(content)
        {
            group(General)
            {
            }
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
            group(ActionGroup1000000026)
            {
                action("Post Disbursement")
                {
                    ApplicationArea = Basic;
                    Image = Post;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Visible = true;

                    trigger OnAction()
                    begin
                        /*CheckRequiredFields();
                        TESTFIELD(Status,Status::"2");
                        IF CONFIRM('Post Loan Disbursement Document No:'+FORMAT("PI Code")) THEN
                        //Check user exists and has posting rights
                        IF LoanUserSetup.GET(USERID) THEN BEGIN
                          LoanUserSetup.TESTFIELD(LoanUserSetup."Disbursement Journal Template");
                          LoanUserSetup.TESTFIELD(LoanUserSetup."Disbursement Journal Batch");
                          LoanManager.PostTrans("PI Code",LoanUserSetup."Disbursement Journal Template",LoanUserSetup."Disbursement Journal Batch");
                        END ELSE BEGIN
                          ERROR(Txt000,USERID);
                        END;
                        */

                    end;
                }
                action("View Schedule")
                {
                    ApplicationArea = Basic;
                    Caption = 'View Schedule';
                    Image = ViewDetails;
                    Promoted = true;
                    PromotedCategory = "Report";
                    ShortCutKey = 'Ctrl+F7';
                }
            }
            group(Approvals)
            {
                Caption = 'Approvals';
                action(Approval)
                {
                    ApplicationArea = Basic;
                    Caption = 'Approvals';
                    Image = Approval;
                    Promoted = true;
                    PromotedCategory = Category4;

                    trigger OnAction()
                    var
                        ApprovalEntries: Page "Approval Entries";
                    begin
                    end;
                }
                action("Send Approval Request")
                {
                    ApplicationArea = Basic;
                    Caption = 'Send A&pproval Request';
                    Image = SendApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Category4;

                    trigger OnAction()
                    var
                        Text001: label 'This transaction is already pending approval';
                        ApprovalMgt: Codeunit "Approvals Mgmt.";
                    begin
                        /*CheckRequiredFields();
                        TESTFIELD(Status,Status::"0");
                         IF ApprovalsMgmt.CheckLoanDisbursementApprovalsWorkflowEnabled(Rec) THEN
                          ApprovalsMgmt.OnSendLoanDisbursementForApproval(Rec); */

                    end;
                }
                action("Cancel Approval Request")
                {
                    ApplicationArea = Basic;
                    Caption = 'Cancel Approval Request';
                    Image = Cancel;
                    Promoted = true;
                    PromotedCategory = Category4;

                    trigger OnAction()
                    var
                        ApprovalMgt: Codeunit "Approvals Mgmt.";
                    begin
                    end;
                }
            }
        }
    }

    var
        LoanManager: Codeunit "POST ATM Transactions";
        Txt000: label 'User ID:%1 has not been setup for posting, Contact System Administrator';
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";

    local procedure CheckRequiredFields()
    begin
        /*TESTFIELD("PI Code");
        TESTFIELD("PI Name");
        TESTFIELD("Colabotative Institution");
        TESTFIELD("PI Address");
        TESTFIELD("Amount to Disburse");
        TESTFIELD("Requested Amount");
        TESTFIELD("PI Telephone");
        TESTFIELD("Posting Date");
        TESTFIELD("Loan Disbursment Date");
        TESTFIELD("Repayment Start Date");
        TESTFIELD("Paying Bank");
        TESTFIELD("Paying Bank Name");
        TESTFIELD(Description);
        IF "Amount to Disburse">"Balance Outstanding" THEN
          ERROR('The Amount to Disburse:'+FORMAT("Amount to Disburse")+' cannot be more than the Loan Outstanding Balance:'+FORMAT("Balance Outstanding"));
          */

    end;
}

