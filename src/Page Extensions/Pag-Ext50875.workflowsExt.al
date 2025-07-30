pageextension 50875 "workflowsExt" extends Workflows
{
    trigger OnOpenPage()
    var
        CustomWorkFlowEvents: Codeunit "Custom Workflow Events";
        WorkflowRepsonse: Codeunit "Custom Workflow Responses";
    begin
        CustomWorkFlowEvents.OnAddWorkflowEventsToLibrary();//();
        WorkflowRepsonse.OnAddWorkflowResponsePredecessorsToLibrary();//();
        //Message('done');
    end;
}
