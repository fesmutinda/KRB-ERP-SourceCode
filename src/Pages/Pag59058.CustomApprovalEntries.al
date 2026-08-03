page 59058 "Custom Approval Entries"
{
    ApplicationArea = Suite;
    Caption = 'Loan Approval Entries';
    Editable = false;
    DeleteAllowed = false;
    PageType = List;
    SourceTable = "Approval Entry";
    SourceTableView = sorting("Table ID", "Document Type", "Document No.", "Date-Time Sent for Approval")
    order(ascending)
                      where("Table ID" = filter(DATABASE::"Loans Register"));
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;

                // New fields for loan register details
                field(LoanNo; LoanNo)
                {
                    ApplicationArea = Suite;
                    Caption = 'Loan No.';
                }
                field(CustomerName; CustomerName)
                {
                    ApplicationArea = Suite;
                    Caption = 'Customer Name';
                }
                field(LoanAmount; LoanAmount)
                {
                    ApplicationArea = Suite;
                    Caption = 'Loan Amount';
                }
                field(LoanType; LoanType)
                {
                    ApplicationArea = Suite;
                    Caption = 'Loan Type';
                }
                field(LoanStatus; LoanStatus)
                {
                    ApplicationArea = Suite;
                    Caption = 'Loan Status';

                }

                field(LoanRescheduleDate; LoanRescheduleDate)
                {
                    ApplicationArea = Suite;
                    Caption = 'Reschedule Date';

                }
                field(ApplicationDate; ApplicationDate)
                {
                    ApplicationArea = Suite;
                    Caption = 'Application Date';
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
                    ToolTip = 'Specifies the type of limit that applies to the approval template:';
                }
                field("Approval Type"; Rec."Approval Type")
                {
                    ApplicationArea = Suite;
                    Visible = false;
                    ToolTip = 'Specifies which approvers apply to this approval template:';
                }
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the type of document that an approval entry has been created for. Approval entries can be created for six different types of sales or purchase documents:';
                    Visible = false;
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = Suite;
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
                    ToolTip = 'Specifies the code for the salesperson or purchaser that was in the document to be approved. It is not a mandatory field, but is useful if a salesperson or a purchaser responsible for the customer/vendor needs to approve the document before it is processed.';
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
                    trigger OnAction()
                    begin
                        Rec.ShowRecord();
                    end;
                }
                action("View Loan")
                {
                    ApplicationArea = Suite;
                    Caption = 'View Loan';
                    Visible = false;
                    Enabled = ShowRecCommentsEnabled;
                    Image = Document;

                    trigger OnAction()
                    var
                        LoansRegister: Record "Loans Register";
                    begin
                        if LoanNo <> '' then
                            if LoansRegister.Get(LoanNo) then
                                PAGE.Run(PAGE::"Loan Application Card", LoansRegister);
                    end;
                }
                action(Comments)
                {
                    ApplicationArea = Suite;
                    Caption = 'Comments';
                    Enabled = ShowRecCommentsEnabled;
                    Image = ViewComments;

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

                    trigger OnAction()
                    begin
                        Rec.SetFilter(Status, '%1|%2', Rec.Status::Created, Rec.Status::Open);
                        Rec.SetFilter("Due Date", '<%1', Today);
                    end;
                }
                action("All Entries")
                {
                    ApplicationArea = Suite;
                    Caption = 'All Loan Entries';
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
                actionref("View Loan_Promoted"; "View Loan")
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

        // Populate loan register details
        GetLoanRegisterDetails()
    end;

    trigger OnOpenPage()
    begin
        // Mark all entries where user is approver or sender
        Rec.MarkAllWhereUserisApproverOrSender();

        // Set permanent filter for loans only
        Rec.FilterGroup(2);
        Rec.SetRange("Table ID", DATABASE::"Loans Register");
        Rec.FilterGroup(0);

        // Update page caption
        CurrPage.Caption := 'Loan Approval Entries';
    end;

    var
        Overdue: Option Yes," ";
        RecordIDText: Text;
        ShowChangeFactBox: Boolean;
        DelegateEnable: Boolean;
        ShowRecCommentsEnabled: Boolean;

        // Variables for loan register details
        LoanNo: Code[20];
        CustomerName: Text[100];
        LoanAmount: Decimal;
        LoanType: Text[50];
        LoanStatus: Text[50];
        ApplicationDate: Date;

        LoanRescheduleDate: Date;

    procedure SetRecordFilters(TableId: Integer; DocumentType: Enum "Approval Document Type"; DocumentNo: Code[20])
    begin
        if TableId <> 0 then begin
            Rec.FilterGroup(2);
            Rec.SetCurrentKey("Table ID", "Document Type", "Document No.", "Date-Time Sent for Approval");
            Rec.SetRange("Table ID", TableId);

            // For loans, we mainly filter by document number (loan number)
            if DocumentNo <> '' then
                Rec.SetRange("Document No.", DocumentNo);

            // Only set document type if it's not blank
            if DocumentType <> "Approval Document Type"::" " then
                Rec.SetRange("Document Type", DocumentType);

            Rec.FilterGroup(0);
        end;
    end;

    procedure SetLoanFilter(LoanNo: Code[20])
    begin
        if LoanNo <> '' then begin
            Rec.FilterGroup(2);
            // Filter to show only approvals for this specific loan
            Rec.SetRange("Document No.", LoanNo);
            Rec.FilterGroup(0);

            // Update page caption to show specific loan
            CurrPage.Caption := 'Loan Approval Entries - ' + LoanNo;
        end;
    end;

    procedure SetLoanRecordFilter(LoanRecordID: RecordID)
    begin
        if LoanRecordID.TableNo <> 0 then begin
            Rec.FilterGroup(2);
            Rec.SetRange("Record ID to Approve", LoanRecordID);
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
        Clear(LoanRescheduleDate);

        if not RecRef.Get(Rec."Record ID to Approve") then
            exit;

        if RecRef.Number = Database::"Loans Register" then begin


            RecRef.SetTable(LoanRegister);

            LoanRegister.SetFilter("Approved Amount", '>0');

            // Populate loan fields
            LoanNo := LoanRegister."Loan  No.";
            LoanAmount := LoanRegister."Approved Amount";
            LoanType := Format(LoanRegister."Loan Product Type Name");
            LoanStatus := Format(LoanRegister."Loan Status");
            ApplicationDate := LoanRegister."Application Date";
            LoanRescheduleDate := LoanRegister."Loan Rescheduled Date";

            if Customer.Get(LoanRegister."Client Code") then
                CustomerName := Customer.Name;
        end;
    end;
}