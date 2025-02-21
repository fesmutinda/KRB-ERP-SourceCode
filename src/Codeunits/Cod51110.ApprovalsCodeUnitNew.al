// Codeunit 51110 "ApprovalsCodeUnit New"
// {

//     trigger OnRun()
//     begin

//     end;

//     procedure SendMemberApplicationsRequestForApproval(MemberApplicationNo: Code[40]; var "HR Member Application": Record "Membership Applications")
//     begin
//         if FnCheckIfMemberApplicationApprovalsWorkflowEnabled("HR Member Application") then begin
//             FnOnSendMemberApplicationForApproval("HR Member Application");
//         end;
//     end;

//     local procedure FnCheckIfMemberApplicationApprovalsWorkflowEnabled(var "HR Member Application": Record "Membership Applications"): Boolean;
//     begin
//         if not IsMemberApplicationApprovalsWorkflowEnabled("HR Member Application") then
//             Error(NoWorkflowEnabledErr);
//         exit(true);
//     end;

//     //.
//     procedure CancelMemberApplicationsRequestForApproval(MemberApplicationNo: Code[40]; var "HR Member Application": Record "Membership Applications")
//     begin
//         FnOnCancelMemberApplicationApprovalRequest("HR Member Application");
//     end;


//     local procedure IsMemberApplicationApprovalsWorkflowEnabled(var MemberApplication: Record "Membership Applications"): Boolean
//     begin
//         exit(WorkflowManagement.CanExecuteWorkflow(MemberApplication, Psalmkitswfevents.RunWorkflowOnSendMemberApplicationForApprovalCode));
//     end;


//     [IntegrationEvent(false, false)]

//     procedure FnOnSendMemberApplicationForApproval(var MemberApplication: Record "Membership Applications")
//     begin
//     end;

//     [IntegrationEvent(false, false)]

//     procedure FnOnCancelMemberApplicationApprovalRequest(var MemberApplication: Record "Membership Applications")
//     begin
//     end;

//     var
//         NoWorkflowEnabledErr: Label 'No Approval workflow for this record type is enabled';
//         WorkflowManagement: Codeunit "Workflow Management";
//         Psalmkitswfevents: Codeunit "Custom Workflow Events New";

// }