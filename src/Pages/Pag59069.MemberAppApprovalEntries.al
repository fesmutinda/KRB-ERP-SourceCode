page 59069 "MemberApp Approval Entries"
{
    ApplicationArea = Suite;
    Caption = 'MemberApp Approval Entries';
    Editable = false;
    PageType = List;
    SourceTable = "Approval Entry";
    SourceTableView = sorting("Table ID", "Document Type", "Document No.", "Date-Time Sent for Approval")
    order(ascending)
                      where("Table ID" = filter(DATABASE::"Membership Applications"));
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;

                // New fields for member register details
                field(No; No)
                {
                    ApplicationArea = Suite;
                    Caption = 'No.';
                }
                field(Name; Name)
                {
                    ApplicationArea = Suite;
                    Caption = 'Name';

                }
                field(PhoneNumber; PhoneNumber)
                {
                    ApplicationArea = Suite;
                    Caption = 'Phone Number';

                }
                field(MaritalStatus; MaritalStatus)
                {
                    ApplicationArea = Suite;
                    Caption = 'Marital Status';

                }
                field(Status5; Status)
                {
                    ApplicationArea = Suite;
                    Caption = 'Status';
                }

                field(Overdue; Overdue)
                {
                    ApplicationArea = Suite;
                    Caption = 'Overdue';
                    Editable = false;
                }
                field("Table ID"; Rec."Table ID")
                {
                    ApplicationArea = Suite;
                    Visible = false;
                }
                field("Limit Type"; Rec."Limit Type")
                {
                    ApplicationArea = Suite;
                    Visible = false;
                }
                field("Approval Type"; Rec."Approval Type")
                {
                    ApplicationArea = Suite;
                    Visible = false;
                }
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = Suite;
                    Visible = false;
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = Suite;
                    Visible = false;
                }
                field(RecordIDText; RecordIDText)
                {
                    ApplicationArea = Suite;
                    Visible = false;
                    Caption = 'To Approve';
                }
                field(Details; Rec.RecordDetails())
                {
                    ApplicationArea = Suite;
                    Visible = false;
                    Caption = 'Details';
                }
                field("Sequence No."; Rec."Sequence No.")
                {
                    ApplicationArea = Suite;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Suite;
                    Visible = false;
                }
                field("Sender ID"; Rec."Sender ID")
                {
                    ApplicationArea = Suite;

                    trigger OnDrillDown()
                    var
                        UserMgt: Codeunit "User Management";
                    begin
                        UserMgt.DisplayUserInformation(Rec."Sender ID");
                    end;
                }
                field("Salespers./Purch. Code"; Rec."Salespers./Purch. Code")
                {
                    ApplicationArea = Suite;
                    Visible = false;
                }
                field("Approver ID"; Rec."Approver ID")
                {
                    ApplicationArea = Suite;

                    trigger OnDrillDown()
                    var
                        UserMgt: Codeunit "User Management";
                    begin
                        UserMgt.DisplayUserInformation(Rec."Approver ID");
                    end;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = Suite;
                    Visible = false;
                }
                field("Amount (LCY)"; Rec."Amount (LCY)")
                {
                    ApplicationArea = Suite;
                    Visible = false;
                }
                field("Available Credit Limit (LCY)"; Rec."Available Credit Limit (LCY)")
                {
                    ApplicationArea = Suite;
                    Visible = false;
                }
                field("Date-Time Sent for Approval"; Rec."Date-Time Sent for Approval")
                {
                    ApplicationArea = Suite;
                }
                field("Last Date-Time Modified"; Rec."Last Date-Time Modified")
                {
                    ApplicationArea = Suite;
                }
                field("Last Modified By User ID"; Rec."Last Modified By User ID")
                {
                    ApplicationArea = Suite;
                    //ToolTip = 'Specifies the ID of the user who last modified the approval entry. If, for example, the document approval is canceled, this field will be updated accordingly.';

                    trigger OnDrillDown()
                    var
                        UserMgt: Codeunit "User Management";
                    begin
                        UserMgt.DisplayUserInformation(Rec."Last Modified By User ID");
                    end;
                }
                field(Comment; Rec.Comment)
                {
                    ApplicationArea = Suite;
                    // ToolTip = 'Specifies whether there are comments relating to the approval of the record. If you want to read the comments, choose the field to open the Approval Comment Sheet window.';
                }
                field("Due Date"; Rec."Due Date")
                {
                    ApplicationArea = Suite;
                    // ToolTip = 'Specifies when the record must be approved, by one or more approvers.';
                }
            }
        }
        area(factboxes)
        {
            part(Change; "Workflow Change List FactBox")
            {
                ApplicationArea = Suite;
                Editable = false;
                Enabled = false;
                ShowFilter = false;
                UpdatePropagation = SubPart;
                Visible = ShowChangeFactBox;
            }
            systempart(Control5; Links)
            {
                ApplicationArea = RecordLinks;
                Visible = false;
            }
            systempart(Control4; Notes)
            {
                ApplicationArea = Notes;
                Visible = true;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Show")
            {
                Caption = '&Show';
                Image = View;
                action("Record")
                {
                    ApplicationArea = Suite;
                    Caption = 'Record';
                    Enabled = ShowRecCommentsEnabled;
                    Image = Document;
                    //ToolTip = 'Open the document, journal line, or card that the approval request is for.';

                    trigger OnAction()
                    begin
                        Rec.ShowRecord();
                    end;
                }
                action("View Member")
                {
                    ApplicationArea = Suite;
                    Caption = 'View Member';
                    Visible = false;
                    Enabled = ShowRecCommentsEnabled;
                    Image = Document;
                    // ToolTip = 'Open the member record for this approval.';

                    trigger OnAction()
                    var
                        MembershipApp: Record "Membership Applications";
                    begin
                        if No <> '' then
                            if MembershipApp.Get(No) then
                                PAGE.Run(PAGE::"Member Application Card", MembershipApp);
                    end;
                }
                action(Comments)
                {
                    ApplicationArea = Suite;
                    Caption = 'Comments';
                    Enabled = ShowRecCommentsEnabled;
                    Image = ViewComments;
                    // ToolTip = 'View or add comments for the record.';

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                        RecRef: RecordRef;
                    begin
                        RecRef.Get(Rec."Record ID to Approve");
                        Clear(ApprovalsMgmt);
                        ApprovalsMgmt.GetApprovalCommentForWorkflowStepInstanceID(RecRef, Rec."Workflow Step Instance ID");
                    end;
                }
                action("O&verdue Entries")
                {
                    ApplicationArea = Suite;
                    Caption = 'O&verdue Entries';
                    Image = OverdueEntries;
                    // ToolTip = 'View approval requests that are overdue.';

                    trigger OnAction()
                    begin
                        Rec.SetFilter(Status, '%1|%2', Rec.Status::Created, Rec.Status::Open);
                        Rec.SetFilter("Due Date", '<%1', Today);
                    end;
                }
                action("All Entries")
                {
                    ApplicationArea = Suite;
                    Caption = 'All members Entries';
                    Image = Entries;

                    trigger OnAction()
                    begin
                        Rec.SetRange(Status);
                        Rec.SetRange("Due Date");
                        Rec.SetRange("Document No.");
                    end;
                }
                action("Pending Entries")
                {
                    ApplicationArea = Suite;
                    Caption = 'Pending Entries';
                    Image = Entries;


                    trigger OnAction()
                    begin
                        Rec.SetRange(Status);
                        Rec.SetRange("Due Date");
                        Rec.SetFilter(Status, '%1|%2', Rec.Status::Created, Rec.Status::Open);
                    end;
                }
            }
        }
        area(processing)
        {
            action("&Delegate")
            {
                ApplicationArea = Suite;
                Caption = '&Delegate';
                Enabled = DelegateEnable;
                Image = Delegate;
                //ToolTip = 'Delegate the approval request to another approver that has been set up as your substitute approver.';

                trigger OnAction()
                var
                    ApprovalEntry: Record "Approval Entry";
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    CurrPage.SetSelectionFilter(ApprovalEntry);
                    ApprovalsMgmt.DelegateApprovalRequests(ApprovalEntry);
                end;
            }
        }
        area(Promoted)
        {
            group(Category_Process)
            {
                Caption = 'Process', Comment = 'Generated from the PromotedActionCategories property index 1.';

                actionref("&Delegate_Promoted"; "&Delegate")
                {
                }
                actionref("View member_Promoted"; "View member")
                {
                }
                actionref(Record_Promoted; Record)
                {
                }
                actionref(Comments_Promoted; Comments)
                {
                }
                group(Category_Show)
                {
                    Caption = 'Show';

                    actionref("All Entries_Promoted"; "All Entries")
                    {
                    }
                    actionref("Pending Entries_Promoted"; "Pending Entries")
                    {
                    }
                    actionref("O&verdue Entries_Promoted"; "O&verdue Entries")
                    {
                    }
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    var
        RecRef: RecordRef;
    begin
        ShowChangeFactBox := CurrPage.Change.PAGE.SetFilterFromApprovalEntry(Rec);
        DelegateEnable := Rec.CanCurrentUserEdit();
        ShowRecCommentsEnabled := RecRef.Get(Rec."Record ID to Approve");
    end;

    trigger OnAfterGetRecord()
    begin
        Overdue := Overdue::" ";
        if FormatField(Rec) then
            Overdue := Overdue::Yes;

        RecordIDText := Format(Rec."Record ID to Approve", 0, 1);

        // Populate members details
        GetMemberAppDetails()
    end;

    trigger OnOpenPage()
    begin
        // Mark all entries where user is approver or sender
        Rec.MarkAllWhereUserisApproverOrSender();

        // Set permanent filter for members only
        Rec.FilterGroup(2);
        Rec.SetRange("Table ID", DATABASE::"Membership Applications");
        Rec.FilterGroup(0);

        // Update page caption
        CurrPage.Caption := 'Member Approval Entries';
    end;

    var
        Overdue: Option Yes," ";
        RecordIDText: Text;
        ShowChangeFactBox: Boolean;
        DelegateEnable: Boolean;
        ShowRecCommentsEnabled: Boolean;

        // Variables for membership application details
        No: Code[20];
        Name: Text[100];
        PhoneNumber: Code[10];
        MaritalStatus: Text[50];
        Status: Text[50];
        ApplicationDate: Date;

    procedure SetRecordFilters(TableId: Integer; DocumentType: Enum "Approval Document Type"; DocumentNo: Code[20])
    begin
        if TableId <> 0 then begin
            Rec.FilterGroup(2);
            Rec.SetCurrentKey("Table ID", "Document Type", "Document No.", "Date-Time Sent for Approval");
            Rec.SetRange("Table ID", TableId);

            // For memeber, we mainly filter by document number (member number)
            if DocumentNo <> '' then
                Rec.SetRange("Document No.", DocumentNo);

            // Only set document type if it's not blank
            if DocumentType <> "Approval Document Type"::" " then
                Rec.SetRange("Document Type", DocumentType);

            Rec.FilterGroup(0);
        end;
    end;

    procedure SetmemberFilter(No: Code[20])
    begin
        if No <> '' then begin
            Rec.FilterGroup(2);
            // Filter to show only approvals for this specific member
            Rec.SetRange("Document No.", No);
            Rec.FilterGroup(0);

            // Update page caption to show specific member
            CurrPage.Caption := 'Member Approval Entries - ' + No;
        end;
    end;

    procedure SetMemberRecordFilter(MemberRecordID: RecordID)
    begin
        if MemberRecordID.TableNo <> 0 then begin
            Rec.FilterGroup(2);
            Rec.SetRange("Record ID to Approve", MemberRecordID);
            Rec.FilterGroup(0);
        end;
    end;

    local procedure FormatField(ApprovalEntry: Record "Approval Entry"): Boolean
    begin
        if Rec.Status in [Rec.Status::Created, Rec.Status::Open] then begin
            if ApprovalEntry."Due Date" < Today then
                exit(true);

            exit(false);
        end;
    end;

    procedure CalledFrom()
    begin
        Overdue := Overdue::" ";
    end;

    local procedure GetMemberAppDetails()
    var
        MembershipApp: Record "Membership Applications";
        Customer: Record Customer;
        RecRef: RecordRef;
    begin
        // Clear variables
        Clear(No);
        Clear(Name);
        Clear(PhoneNumber);
        Clear(MaritalStatus);
        Clear(Status);


        if not RecRef.Get(Rec."Record ID to Approve") then
            exit;

        if RecRef.Number = Database::"Membership Applications" then begin
            RecRef.SetTable(MembershipApp);

            // Populate member fields
            No := MembershipApp."No.";
            Name := MembershipApp.Name;
            PhoneNumber := MembershipApp."Mobile Phone No";
            MaritalStatus := Format(MembershipApp."Marital Status");
            Status := Format(MembershipApp.Status);
            //ApplicationDate := MembershipApp."Application Date";

            if Customer.Get(MembershipApp.Name) then
                Name := MembershipApp.Name;
        end;
    end;
}