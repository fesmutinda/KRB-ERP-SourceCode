namespace System.Automation;

using System.Security.User;
using Microsoft.Sales.Customer;

page 59070 "MemberApp Requests to Approve"
{
    ApplicationArea = Suite;
    Caption = ' MemberApp Requests to Approve';
    Editable = false;
    PageType = List;
    RefreshOnActivate = true;
    SourceTable = "Approval Entry";
    SourceTableView = sorting("Approver ID", Status, "Due Date", "Date-Time Sent for Approval")
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

                field("No."; "No.")
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
                    Caption = 'Member Status';
                }
                field(ToApprove; Rec.RecordCaption())
                {
                    ApplicationArea = Suite;
                    Caption = 'To Approve';
                    Width = 30;
                }
                field(Details; Rec.RecordDetails())
                {
                    ApplicationArea = Suite;
                    Caption = 'Details';
                    Width = 50;
                    Visible = false;
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


                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the code of the currency of the amounts on the sales or purchase lines.';
                    Visible = false;
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
            systempart(Control1900383207; Links)
            {
                ApplicationArea = RecordLinks;
                Visible = false;
            }
            systempart(Control1905767507; Notes)
            {
                ApplicationArea = Notes;
                Visible = false;
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
                action("Record")
                {
                    ApplicationArea = Suite;
                    Caption = 'Open Record';
                    Enabled = ShowRecCommentsEnabled;
                    Image = Document;
                    Scope = Repeater;

                    trigger OnAction()
                    begin
                        Rec.ShowRecord();
                    end;
                }
                action(Comments)
                {
                    ApplicationArea = Suite;
                    Caption = 'Comments';
                    Enabled = ShowRecCommentsEnabled;
                    Image = ViewComments;
                    Scope = Repeater;

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
            }
        }
        area(processing)
        {
            action(Approve)
            {
                ApplicationArea = Suite;
                Caption = 'Approve';
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
                Caption = 'Reject';
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
                Caption = 'Delegate';
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
                    Caption = 'Open Requests';
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
                    Caption = 'All Requests';
                    Image = AllLines;

                    trigger OnAction()
                    begin
                        Rec.SetRange(Status);
                        ShowAllEntries := true;
                    end;
                }
            }
        }
        area(Promoted)
        {
            group(Category_Process)
            {
                Caption = 'Process', Comment = 'Generated from the PromotedActionCategories property index 1.';

                actionref(Record_Promoted; Record)
                {
                }
                actionref(Approve_Promoted; Approve)
                {
                }
                actionref(Reject_Promoted; Reject)
                {
                }
                actionref(Delegate_Promoted; Delegate)
                {
                }
                actionref(Comments_Promoted; Comments)
                {
                }
                group(Category_View)
                {
                    Caption = 'View';

                    actionref(AllRequests_Promoted; AllRequests)
                    {
                    }
                    actionref(OpenRequests_Promoted; OpenRequests)
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
        ShowCommentFactbox := CurrPage.CommentsFactBox.PAGE.SetFilterFromApprovalEntry(Rec);
        ShowRecCommentsEnabled := RecRef.Get(Rec."Record ID to Approve");
    end;

    trigger OnAfterGetRecord()
    begin
        SetDateStyle();
        GetMemberAppDetails();
    end;

    trigger OnOpenPage()
    begin
        Rec.FilterGroup(2);
        Rec.SetRange("Approver ID", UserId);
        OnOpenPageOnAfterSetUserIdFilter(Rec);
        Rec.FilterGroup(0);
        Rec.SetRange(Status, Rec.Status::Open);
    end;

    var
        DateStyle: Text;
        ShowAllEntries: Boolean;
        ShowChangeFactBox: Boolean;
        ShowRecCommentsEnabled: Boolean;
        ShowCommentFactbox: Boolean;

        // New variables for Member details
        "No.": Code[20];
        Name: Text[100];
        PhoneNumber: Code[20];
        MaritalStatus: Text[50];
        Status: Text[50];


    local procedure SetDateStyle()
    begin
        DateStyle := '';
        if Rec.IsOverdue() then
            DateStyle := 'Attention';
    end;

    [IntegrationEvent(false, false)]
    local procedure OnOpenPageOnAfterSetUserIdFilter(var ApprovalEntry: Record "Approval Entry")
    begin
    end;

    local procedure GetMemberAppDetails()
    var
        MemberApp: Record "Membership Applications";
        Customer: Record Customer;
        RecRef: RecordRef;
    begin
        // Clear variables
        Clear("No.");
        Clear(Name);
        Clear(PhoneNumber);
        Clear(MaritalStatus);
        Clear(Status);

        if not RecRef.Get(Rec."Record ID to Approve") then
            exit;

        if RecRef.Number = Database::"Membership Applications" then begin
            RecRef.SetTable(MemberApp);

            // Populate Member fields
            "No." := MemberApp."No.";
            Name := MemberApp.Name;
            PhoneNumber := MemberApp."Mobile Phone No";
            MaritalStatus := Format(MemberApp."Marital Status");
            Status := Format(MemberApp.Status);



            if Customer.Get(MemberApp.Name) then
                Name := MemberApp.Name;
        end;
    end;
}