// Codeunit 51111 "Custom Workflow Events New"
// {

//     trigger OnRun()
//     begin
//         AddEventsToLib();
//     end;

//     procedure AddEventsToLib()
//     begin
//         //Member Application
//         WFHandler.AddEventToLibrary(RunWorkflowOnSendMemberApplicationForApprovalCode,
//                             Database::"Membership Applications", 'Approval of Member Application is Requested.', 0, false);
//         WFHandler.AddEventToLibrary(RunWorkflowOnCancelMemberApplicationApprovalRequestCode,
//                                     Database::"Membership Applications", 'An Approval request for  Member Application is canceled.', 0, false);
//         //
//     end;
//     //A)Member Applications
//     procedure RunWorkflowOnSendMemberApplicationForApprovalCode(): Code[128]//
//     begin
//         exit(UpperCase('RunWorkflowOnSendMemberApplicationForApproval'));
//     end;


//     procedure RunWorkflowOnCancelMemberApplicationApprovalRequestCode(): Code[128]
//     begin
//         exit(UpperCase('RunWorkflowOnCancelMemberApplicationApprovalRequest'));
//     end;

//     [EventSubscriber(ObjectType::Codeunit, Codeunit::"ApprovalsCodeUnit New", 'FnOnSendMemberApplicationForApproval', '', false, false)]

//     procedure RunWorkflowOnSendMemberApplicationForApproval(var MemberApplication: Record "Membership Applications")
//     begin
//         WorkflowManagement.HandleEvent(RunWorkflowOnSendMemberApplicationForApprovalCode, MemberApplication);
//     end;

//     [EventSubscriber(ObjectType::Codeunit, Codeunit::"ApprovalsCodeUnit New", 'FnOnCancelMemberApplicationApprovalRequest', '', false, false)]

//     procedure RunWorkflowOnCancelMemberApplicationApprovalRequest(var MemberApplication: Record "Membership Applications")
//     begin
//         WorkflowManagement.HandleEvent(RunWorkflowOnCancelMemberApplicationApprovalRequestCode, MemberApplication);
//     end;
//     //........................................................................
//     var
//         WFHandler: Codeunit "Workflow Event Handling";
//         WorkflowManagement: Codeunit "Workflow Management";
//         WFEventHandler: Codeunit "Workflow Event Handling";
//         SwizzsoftWFEvents: Codeunit "Custom Workflow Events";
//         WFResponseHandler: Codeunit "Workflow Response Handling";
// }