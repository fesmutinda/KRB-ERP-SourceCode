namespace KRBERPSourceCode.KRBERPSourceCode;

page 50002 "System Log Trails List"
{
    ApplicationArea = All;
    Caption = 'System Log Trails List';
    PageType = List;
    SourceTable = "System Log Trails";
    UsageCategory = Administration;
    Editable = false;
    DeleteAllowed = false;
    InsertAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Entry No"; Rec."Entry No")
                {
                    ToolTip = 'Specifies the value of the Entry No field.', Comment = '%';
                }
                field("Account ID"; Rec."Account ID")
                {
                    ToolTip = 'Specifies the value of the Account ID field.', Comment = '%';
                }
                field("Account Type ID"; Rec."Account Type ID")
                {
                    ToolTip = 'Specifies the value of the Account Type ID field.', Comment = '%';
                }
                field("Approval Action"; Rec."Approval Action")
                {
                    ToolTip = 'Specifies the value of the Approval Action field.', Comment = '%';
                }
                field("Approval Action Description"; Rec."Approval Action Description")
                {
                    ToolTip = 'Specifies the value of the Approval Action Description field.', Comment = '%';
                }
                field("Authorized By"; Rec."Authorized By")
                {
                    ToolTip = 'Specifies the value of the Authorized By field.', Comment = '%';
                }
                field("Database Name"; Rec."Database Name")
                {
                    ToolTip = 'Specifies the value of the Database Name field.', Comment = '%';
                }
                field("Event Date/Time"; Rec."Event Date/Time")
                {
                    ToolTip = 'Specifies the value of the Event Date/Time field.', Comment = '%';
                }
                field("Log In Computer Name"; Rec."Log In Computer Name")
                {
                    ToolTip = 'Specifies the value of the Log In Computer Name field.', Comment = '%';
                }
                field("Log In Time"; Rec."Log In Time")
                {
                    ToolTip = 'Specifies the value of the Log In Time field.', Comment = '%';
                }
                field("Log out Time"; Rec."Log out Time")
                {
                    ToolTip = 'Specifies the value of the Log out Time field.', Comment = '%';
                }
                field("Minutes Logged In"; Rec."Minutes Logged In")
                {
                    ToolTip = 'Specifies the value of the Minutes Logged In field.', Comment = '%';
                }
                field("Page Viewed"; Rec."Page Viewed")
                {
                    ToolTip = 'Specifies the value of the Page Viewed field.', Comment = '%';
                }
                field("Server Instance"; Rec."Server Instance")
                {
                    ToolTip = 'Specifies the value of the Server Instance field.', Comment = '%';
                }
                field("Session ID"; Rec."Session ID")
                {
                    ToolTip = 'Specifies the value of the Session ID field.', Comment = '%';
                }
                field("Session Type"; Rec."Session Type")
                {
                    ToolTip = 'Specifies the value of the Session Type field.', Comment = '%';
                }
                field("Transacting Branch ID"; Rec."Transacting Branch ID")
                {
                    ToolTip = 'Specifies the value of the Transacting Branch ID field.', Comment = '%';
                }
                field("Transaction Amount"; Rec."Transaction Amount")
                {
                    ToolTip = 'Specifies the value of the Transaction Amount field.', Comment = '%';
                }
                field("Transaction Date"; Rec."Transaction Date")
                {
                    ToolTip = 'Specifies the value of the Transaction Date field.', Comment = '%';
                }
                field("Transaction Description"; Rec."Transaction Description")
                {
                    ToolTip = 'Specifies the value of the Transaction Description field.', Comment = '%';
                }
                field("Transaction ID"; Rec."Transaction ID")
                {
                    ToolTip = 'Specifies the value of the Transaction ID field.', Comment = '%';
                }
                field("Transaction Time"; Rec."Transaction Time")
                {
                    ToolTip = 'Specifies the value of the Transaction Time field.', Comment = '%';
                }
                field("Transaction Type"; Rec."Transaction Type")
                {
                    ToolTip = 'Specifies the value of the Transaction Type field.', Comment = '%';
                }
                field("Transaction Type ID"; Rec."Transaction Type ID")
                {
                    ToolTip = 'Specifies the value of the Transaction Type ID field.', Comment = '%';
                }
                field("User ID"; Rec."User ID")
                {
                    ToolTip = 'Specifies the value of the User ID field.', Comment = '%';
                }
            }
        }
    }
}
