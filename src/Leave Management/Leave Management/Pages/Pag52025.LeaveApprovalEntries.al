page 52025 "Leave Approval Entries"
{
    PageType = List;
    SourceTable = "Approval Entry";
    ApplicationArea = Suite;
    UsageCategory = Lists;
    Editable = false;
    Caption = 'Leave Approval Entries';

    SourceTableView =
        sorting("Table ID", "Document Type", "Document No.", "Date-Time Sent for Approval")
        order(ascending)
        where("Table ID" = const(Database::"Leave Application"));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                ShowCaption = false;

                // ===== Leave Application Fields =====
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
                field(Status; LeaveStatus)
                {
                    ApplicationArea = Suite;
                    Caption = 'Leave Status';
                }

                // ===== Standard Approval Fields =====
                field("Approver ID"; Rec."Approver ID")
                {
                    ApplicationArea = Suite;
                }
                field("Sender ID"; Rec."Sender ID")
                {
                    ApplicationArea = Suite;
                }
                field("Approval Status"; Rec.Status)
                {
                    ApplicationArea = Suite;
                }
                field("Date-Time Sent for Approval"; Rec."Date-Time Sent for Approval")
                {
                    ApplicationArea = Suite;
                }
                field("Due Date"; Rec."Due Date")
                {
                    ApplicationArea = Suite;
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
            }
            systempart(Notes; Notes)
            {
                ApplicationArea = Notes;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Show")
            {
                action("View Leave Application")
                {
                    ApplicationArea = Suite;
                    Image = Document;
                    Enabled = ShowRecordEnabled;

                    trigger OnAction()
                    var
                        LeaveApp: Record "Leave Application";
                    begin
                        if LeaveApp.Get(ApplicationNo) then
                            Page.Run(Page::"Leave Application Card", LeaveApp);
                    end;
                }

                action(Comments)
                {
                    ApplicationArea = Suite;
                    Image = ViewComments;

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
            action("&Delegate")
            {
                ApplicationArea = Suite;
                Image = Delegate;
                Enabled = DelegateEnabled;

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
    }

    trigger OnOpenPage()
    begin
        Rec.MarkAllWhereUserisApproverOrSender();
    end;

    trigger OnAfterGetCurrRecord()
    var
        RecRef: RecordRef;
    begin
        DelegateEnabled := Rec.CanCurrentUserEdit();
        ShowRecordEnabled := RecRef.Get(Rec."Record ID to Approve");
    end;

    trigger OnAfterGetRecord()
    begin
        ClearLeaveVariables();
        LoadLeaveApplication();
    end;

    var
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

        // Page control
        DelegateEnabled: Boolean;
        ShowRecordEnabled: Boolean;

    local procedure ClearLeaveVariables()
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
    end;

    local procedure LoadLeaveApplication()
    var
        LeaveApp: Record "Leave Application";
        RecRef: RecordRef;
    begin
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
