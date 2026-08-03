namespace System.Automation;

using System.Security.User;

page 52026 "Leave Requests to Approve"
{
    ApplicationArea = Suite;
    Caption = 'Leave Requests to Approve';
    Editable = false;
    PageType = List;
    RefreshOnActivate = true;
    UsageCategory = Lists;

    SourceTable = "Approval Entry";
    SourceTableView =
        sorting("Approver ID", Status, "Due Date", "Date-Time Sent for Approval")
        order(ascending)
        where("Table ID" = const(Database::"Leave Application"));

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;

                // ===== Leave Application Details =====
                field("Application No."; ApplicationNo)
                {
                    ApplicationArea = Suite;
                }
                field("Application Date"; ApplicationDate)
                {
                    ApplicationArea = Suite;
                }
                field("Employee No."; EmployeeNo)
                {
                    ApplicationArea = Suite;
                }
                field("Employee Name"; EmployeeName)
                {
                    ApplicationArea = Suite;
                }
                field("Days Applied"; DaysApplied)
                {
                    ApplicationArea = Suite;
                }
                field("Start Date"; StartDate)
                {
                    ApplicationArea = Suite;
                }
                field("End Date"; EndDate)
                {
                    ApplicationArea = Suite;
                }
                field("Leave Period"; LeavePeriod)
                {
                    ApplicationArea = Suite;
                }
                field("Leave Status"; LeaveStatus)
                {
                    ApplicationArea = Suite;
                }

                // ===== Standard Approval Fields =====
                field(ToApprove; Rec.RecordCaption())
                {
                    ApplicationArea = Suite;
                    Caption = 'To Approve';
                    Width = 30;
                }
                field(Comment; Rec.Comment)
                {
                    ApplicationArea = Suite;
                    HideValue = not Rec.Comment;
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
                field("Due Date"; Rec."Due Date")
                {
                    ApplicationArea = Suite;
                    StyleExpr = DateStyle;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Suite;
                    Visible = ShowAllEntries;
                }
            }
        }

        area(factboxes)
        {
            part(CommentsFactBox; "Approval Comments FactBox")
            {
                ApplicationArea = Suite;
                Visible = ShowCommentFactbox;
            }
            part(Change; "Workflow Change List FactBox")
            {
                ApplicationArea = Suite;
                Editable = false;
                Enabled = false;
                ShowFilter = false;
                UpdatePropagation = SubPart;
                Visible = ShowChangeFactBox;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Show)
            {
                Caption = 'Show';
                Image = View;

                action("Open Record")
                {
                    ApplicationArea = Suite;
                    Image = Document;
                    Enabled = ShowRecCommentsEnabled;
                    Scope = Repeater;

                    trigger OnAction()
                    begin
                        Rec.ShowRecord();
                    end;
                }

                action(Comments)
                {
                    ApplicationArea = Suite;
                    Image = ViewComments;
                    Enabled = ShowRecCommentsEnabled;
                    Scope = Repeater;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                        RecRef: RecordRef;
                    begin
                        RecRef.Get(Rec."Record ID to Approve");
                        ApprovalsMgmt.GetApprovalCommentForWorkflowStepInstanceID(
                            RecRef, Rec."Workflow Step Instance ID");
                    end;
                }
            }
        }

        area(processing)
        {
            action(Approve)
            {
                ApplicationArea = Suite;
                Image = Approve;
                Scope = Repeater;

                trigger OnAction()
                var
                    ApprovalEntry: Record "Approval Entry";
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    CurrPage.SetSelectionFilter(ApprovalEntry);
                    ApprovalsMgmt.ApproveApprovalRequests(ApprovalEntry);
                end;
            }

            action(Reject)
            {
                ApplicationArea = Suite;
                Image = Reject;
                Scope = Repeater;

                trigger OnAction()
                var
                    ApprovalEntry: Record "Approval Entry";
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    CurrPage.SetSelectionFilter(ApprovalEntry);
                    ApprovalsMgmt.RejectApprovalRequests(ApprovalEntry);
                end;
            }

            action(Delegate)
            {
                ApplicationArea = Suite;
                Image = Delegate;
                Scope = Repeater;

                trigger OnAction()
                var
                    ApprovalEntry: Record "Approval Entry";
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    CurrPage.SetSelectionFilter(ApprovalEntry);
                    ApprovalsMgmt.DelegateApprovalRequests(ApprovalEntry);
                end;
            }

            group(View)
            {
                Caption = 'View';

                action(OpenRequests)
                {
                    ApplicationArea = Suite;
                    Image = Approvals;

                    trigger OnAction()
                    begin
                        Rec.SetRange(Status, Rec.Status::Open);
                        ShowAllEntries := false;
                    end;
                }

                action(AllRequests)
                {
                    ApplicationArea = Suite;
                    Image = AllLines;

                    trigger OnAction()
                    begin
                        Rec.SetRange(Status);
                        ShowAllEntries := true;
                    end;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.FilterGroup(2);
        Rec.SetRange("Approver ID", UserId);
        Rec.FilterGroup(0);
        Rec.SetRange(Status, Rec.Status::Open);
    end;

    trigger OnAfterGetCurrRecord()
    var
        RecRef: RecordRef;
    begin
        ShowChangeFactBox := CurrPage.Change.PAGE.SetFilterFromApprovalEntry(Rec);
        ShowCommentFactbox := CurrPage.CommentsFactBox.PAGE.SetFilterFromApprovalEntry(Rec);
        ShowRecCommentsEnabled := RecRef.Get(Rec."Record ID to Approve");
    end;

    trigger OnAfterGetRecord()
    begin
        SetDateStyle();
        LoadLeaveApplication();
    end;

    var
        // UI control
        DateStyle: Text;
        ShowAllEntries: Boolean;
        ShowChangeFactBox: Boolean;
        ShowCommentFactbox: Boolean;
        ShowRecCommentsEnabled: Boolean;

        // Leave fields
        ApplicationNo: Code[20];
        ApplicationDate: Date;
        EmployeeNo: Code[20];
        EmployeeName: Text[100];
        DaysApplied: Decimal;
        StartDate: Date;
        EndDate: Date;
        LeavePeriod: Code[20];
        LeaveStatus: Option "Being Processed",Approved,Rejected,Canceled;

    local procedure SetDateStyle()
    begin
        DateStyle := '';
        if Rec.IsOverdue() then
            DateStyle := 'Attention';
    end;

    local procedure LoadLeaveApplication()
    var
        LeaveApp: Record "Leave Application";
        RecRef: RecordRef;
    begin
        Clear(ApplicationNo);
        Clear(ApplicationDate);
        Clear(EmployeeNo);
        Clear(EmployeeName);
        Clear(DaysApplied);
        Clear(StartDate);
        Clear(EndDate);
        Clear(LeavePeriod);
        Clear(LeaveStatus);

        if not RecRef.Get(Rec."Record ID to Approve") then
            exit;

        if RecRef.Number <> Database::"Leave Application" then
            exit;

        RecRef.SetTable(LeaveApp);

        ApplicationNo := LeaveApp."Application No";
        ApplicationDate := LeaveApp."Application Date";
        EmployeeNo := LeaveApp."Employee No";
        EmployeeName := LeaveApp."Employee Name";
        LeaveApp.CalcFields("Days Applied", "Start Date", "End Date");
        DaysApplied := LeaveApp."Days Applied";
        StartDate := LeaveApp."Start Date";
        EndDate := LeaveApp."End Date";
        LeavePeriod := LeaveApp."Leave Period";
        LeaveStatus := LeaveApp."Leave Status";
    end;
}
