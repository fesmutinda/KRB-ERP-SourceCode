namespace System.Automation;

using System.Security.User;
using Microsoft.Sales.Customer;

page 59059 "Custom Requests to Approve"
{
    ApplicationArea = Suite;
    Caption = 'Requests to Approve';
    Editable = false;
    PageType = List;
    RefreshOnActivate = true;
    SourceTable = "Approval Entry";
    SourceTableView = sorting("Approver ID", Status, "Due Date", "Date-Time Sent for Approval")
                      order(ascending);
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;

                field(LoanNo; LoanNo)
                {
                    ApplicationArea = Suite;
                    Caption = 'Loan No.';
                    ToolTip = 'Specifies the loan number.';
                }
                field(CustomerName; CustomerName)
                {
                    ApplicationArea = Suite;
                    Caption = 'Customer Name';
                    ToolTip = 'Specifies the name of the customer/borrower.';
                }
                field(LoanAmount; LoanAmount)
                {
                    ApplicationArea = Suite;
                    Caption = 'Loan Amount';
                    ToolTip = 'Specifies the loan amount.';
                }
                field(LoanType; LoanType)
                {
                    ApplicationArea = Suite;
                    Caption = 'Loan Type';
                    ToolTip = 'Specifies the type of loan.';
                }
                field(LoanStatus; LoanStatus)
                {
                    ApplicationArea = Suite;
                    Caption = 'Loan Status';
                    ToolTip = 'Specifies the current status of the loan.';
                }
                field(ToApprove; Rec.RecordCaption())
                {
                    ApplicationArea = Suite;
                    Caption = 'To Approve';
                    ToolTip = 'Specifies the record that you are requested to approve. On the Home tab, in the Process group, choose Record to view the record on a new page where you can also act on the approval request.';
                    Width = 30;
                }
                field(Details; Rec.RecordDetails())
                {
                    ApplicationArea = Suite;
                    Caption = 'Details';
                    ToolTip = 'Specifies details about the approval request, such as what and who the request is about.';
                    Width = 50;
                    Visible = false;
                }
                field(Comment; Rec.Comment)
                {
                    ApplicationArea = Suite;
                    HideValue = not Rec.Comment;
                    ToolTip = 'Specifies whether there are comments relating to the approval of the record. If you want to read the comments, choose the field to open the Approval Comment Sheet window.';
                }
                field("Sender ID"; Rec."Sender ID")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the ID of the user who sent the approval request for the document to be approved.';

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
                    ToolTip = 'Specifies when the record must be approved, by one or more approvers.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the approval status for the entry:';
                    Visible = ShowAllEntries;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the total amount (excl. VAT) on the document awaiting approval.';
                    Visible = false;
                }
                field("Amount (LCY)"; Rec."Amount (LCY)")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the total amount in LCY (excl. VAT) on the document awaiting approval.';
                    Visible = false;
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
                    ToolTip = 'Open the document, journal line, or card that the approval is requested for.';

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
                    ToolTip = 'View or add comments for the record.';

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
                ToolTip = 'Approve the requested changes.';

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
                ToolTip = 'Reject the approval request.';

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
                ToolTip = 'Delegate the approval to a substitute approver.';

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
                    ToolTip = 'Open the approval requests that remain to be approved or rejected.';

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
                    ToolTip = 'View all approval requests that are assigned to you.';

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
        GetLoanRegisterDetails();
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

        // New variables for loan register details
        LoanNo: Code[20];
        CustomerName: Text[100];
        LoanAmount: Decimal;
        LoanType: Text[50];
        LoanStatus: Text[50];
        ApplicationDate: Date;

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

    local procedure GetLoanRegisterDetails()
    var
        LoanRegister: Record "Loans Register";
        Customer: Record Customer;
        RecRef: RecordRef;
    begin
        // Clear variables
        Clear(LoanNo);
        Clear(CustomerName);
        Clear(LoanAmount);
        Clear(LoanType);
        Clear(LoanStatus);
        Clear(ApplicationDate);

        if not RecRef.Get(Rec."Record ID to Approve") then
            exit;

        if RecRef.Number = Database::"Loans Register" then begin
            RecRef.SetTable(LoanRegister);

            // Populate loan fields
            LoanNo := LoanRegister."Loan  No.";
            LoanAmount := LoanRegister."Approved Amount";
            LoanType := Format(LoanRegister."Loan Product Type Name");
            LoanStatus := Format(LoanRegister."Loan Status");
            ApplicationDate := LoanRegister."Application Date";


            if Customer.Get(LoanRegister."Client Code") then
                CustomerName := Customer.Name;
        end;
    end;
}