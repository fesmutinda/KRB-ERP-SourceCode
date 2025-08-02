codeunit 50041 "Custom Workflow Responses"
{

    trigger OnRun()
    begin
    end;

    var
        WFEventHandler: Codeunit "Workflow Event Handling";
        WFResponseHandler: Codeunit "Workflow Response Handling";
        MsgToSend: Text[250];
        CompanyInfo: Record "Company Information";
        SwizzsoftWFEvents: Codeunit "Custom Workflow Events";

    [EventSubscriber(ObjectType::Codeunit, 1521, 'OnAddWorkflowResponsePredecessorsToLibrary', '', false, false)]

    procedure OnAddWorkflowResponsePredecessorsToLibrary()
    begin
        //Membership Application
        WFResponseHandler.AddResponsePredecessor(WFResponseHandler.SetStatusToPendingApprovalCode,
                                                 SwizzsoftWFEvents.RunWorkflowOnSendMembershipApplicationForApprovalCode);
        WFResponseHandler.AddResponsePredecessor(WFResponseHandler.CreateApprovalRequestsCode,
                                                 SwizzsoftWFEvents.RunWorkflowOnSendMembershipApplicationForApprovalCode);
        WFResponseHandler.AddResponsePredecessor(WFResponseHandler.SendApprovalRequestForApprovalCode,
                                                 SwizzsoftWFEvents.RunWorkflowOnSendMembershipApplicationForApprovalCode);
        WFResponseHandler.AddResponsePredecessor(WFResponseHandler.OpenDocumentCode,
                                                 SwizzsoftWFEvents.RunWorkflowOnCancelMembershipApplicationApprovalRequestCode);
        WFResponseHandler.AddResponsePredecessor(WFResponseHandler.CancelAllApprovalRequestsCode,
                                                 SwizzsoftWFEvents.RunWorkflowOnCancelMembershipApplicationApprovalRequestCode);
        //InstantLoan Application
        WFResponseHandler.AddResponsePredecessor(WFResponseHandler.SetStatusToPendingApprovalCode,
                                                 SwizzsoftWFEvents.RunWorkflowOnSendInstantLoanApplicationForApprovalCode);
        WFResponseHandler.AddResponsePredecessor(WFResponseHandler.CreateApprovalRequestsCode,
                                                 SwizzsoftWFEvents.RunWorkflowOnSendInstantLoanApplicationForApprovalCode);
        WFResponseHandler.AddResponsePredecessor(WFResponseHandler.SendApprovalRequestForApprovalCode,
                                                 SwizzsoftWFEvents.RunWorkflowOnSendInstantLoanApplicationForApprovalCode);
        WFResponseHandler.AddResponsePredecessor(WFResponseHandler.OpenDocumentCode,
                                                 SwizzsoftWFEvents.RunWorkflowOnCancelInstantLoanApplicationApprovalRequestCode);
        WFResponseHandler.AddResponsePredecessor(WFResponseHandler.CancelAllApprovalRequestsCode,
                                                 SwizzsoftWFEvents.RunWorkflowOnCancelInstantLoanApplicationApprovalRequestCode);

        //BOSA Loan Application

        WFResponseHandler.AddResponsePredecessor(WFResponseHandler.SetStatusToPendingApprovalCode,
                                               SwizzsoftWFEvents.RunWorkflowOnSendLoanApplicationForApprovalCode);
        WFResponseHandler.AddResponsePredecessor(WFResponseHandler.CreateApprovalRequestsCode,
                                                 SwizzsoftWFEvents.RunWorkflowOnSendLoanApplicationForApprovalCode);
        WFResponseHandler.AddResponsePredecessor(WFResponseHandler.SendApprovalRequestForApprovalCode,
                                                 SwizzsoftWFEvents.RunWorkflowOnSendLoanApplicationForApprovalCode);
        WFResponseHandler.AddResponsePredecessor(WFResponseHandler.OpenDocumentCode,
                                                 SwizzsoftWFEvents.RunWorkflowOnCancelLoanApplicationApprovalRequestCode);
        WFResponseHandler.AddResponsePredecessor(WFResponseHandler.CancelAllApprovalRequestsCode,
                                                 SwizzsoftWFEvents.RunWorkflowOnCancelLoanApplicationApprovalRequestCode);

        //-----------------------------End AddOn--------------------------------------------------------------------------------------
    end;

    /*
        [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnExecuteWorkflowResponse', '', true, true)]
         procedure SetStatusToPendingApproval(var Variant: Variant)
        var
            RecRef: RecordRef;
            IsHandled: Boolean;
            MembershipApplication: Record "Membership Applications";
            LoansRegister: Record "Loans Register";
            BOSATransfers: Record "BOSA Transfers";
            LoanBatchDisbursements: Record "Loan Disburesment-Batching";
            LoanTopUp: Record "Loan Top Up.";
            ChangeRequest: Record "Change Request";
            // LeaveApplication: Record "HR Leave Application";
            GuarantorSubstitution: Record "Guarantorship Substitution H";
            PaymentVoucher: Record "Payment Header";
            PettyCashReimbersement: Record "Funds Transfer Header";
            FOSAProductApplication: Record "Accounts Applications Details";
            LoanRecoveryApplication: Record "Loan Recovery Header";
            CEEPChangeRequest: Record "CEEP Change Request";
            MembershipExit: Record "Membership Exist";
            MemberReapplication: Record "Member Reapplication";
        begin
            case RecRef.Number of
                //Membership Reapplication
                Database::"Member Reapplication":
                    begin
                        RecRef.SetTable(MemberReapplication);
                        MemberReapplication.Validate(Status, MemberReapplication.Status::Pending);
                        MemberReapplication.Modify(true);
                        Variant := MemberReapplication;
                    end;
                //Member Exit
                Database::"Membership Exist":
                    begin
                        RecRef.SetTable(MembershipExit);
                        MembershipExit.Validate(Status, MembershipExit.Status::Pending);
                        MembershipExit.Modify(true);
                        Variant := MembershipExit;
                    end;
                //PettyCash Reimbursement
                Database::"Funds Transfer Header":
                    begin
                        RecRef.SetTable(PettyCashReimbersement);
                        PettyCashReimbersement.Validate(Status, PettyCashReimbersement.Status::"Pending Approval");
                        PettyCashReimbersement.Modify(true);
                        Variant := PettyCashReimbersement;
                    end;
                //Payment Voucher
                Database::"Payment Header":
                    begin
                        RecRef.SetTable(PaymentVoucher);
                        PaymentVoucher.Validate(Status, PaymentVoucher.Status::"Pending Approval");
                        PaymentVoucher.Modify(true);
                        Variant := PaymentVoucher;
                    end;
                //Guarantor Substitution
                Database::"Guarantorship Substitution H":
                    begin
                        RecRef.SetTable(GuarantorSubstitution);
                        GuarantorSubstitution.Validate(Status, GuarantorSubstitution.Status::Pending);
                        GuarantorSubstitution.Modify(true);
                        Variant := GuarantorSubstitution;
                    end;

                //Membership Application
                Database::"Membership Applications":
                    begin
                        RecRef.SetTable(MembershipApplication);
                        MembershipApplication.Validate(Status, MembershipApplication.Status::"Pending Approval");
                        MembershipApplication.Modify(true);
                        Variant := MembershipApplication;
                    end;
                //Loan Application
                Database::"Loans Register":
                    begin
                        RecRef.SetTable(LoansRegister);
                        LoansRegister.Validate("Approval Status", LoansRegister."Approval Status"::Pending);
                        LoansRegister.Validate("loan status", LoansRegister."loan status"::Appraisal);
                        LoansRegister.Modify(true);
                        Variant := LoansRegister;
                    end;
                //BOSA Transfers
                Database::"BOSA Transfers":
                    begin
                        RecRef.SetTable(BOSATransfers);
                        BOSATransfers.Validate(status, BOSATransfers.status::"Pending Approval");
                        BOSATransfers.Modify(true);
                        Variant := BOSATransfers;
                    end;
                //Loan Batch Disbursements
                Database::"Loan Disburesment-Batching":
                    begin
                        RecRef.SetTable(LoanBatchDisbursements);
                        LoanBatchDisbursements.Validate(status, LoanBatchDisbursements.status::"Pending Approval");
                        LoanBatchDisbursements.Modify(true);
                        Variant := LoanBatchDisbursements;
                    end;
                //Loan TopUp
                Database::"Loan Top Up.":
                    begin
                        RecRef.SetTable(LoanTopUp);
                        LoanTopUp.Validate(status, LoanTopUp.status::Pending);
                        LoanTopUp.Modify(true);
                        Variant := LoanTopUp;
                    end;

                //CEEP Change Request
                Database::"CEEP Change Request":
                    begin
                        RecRef.SetTable(CEEPChangeRequest);
                        CEEPChangeRequest.Validate(status, CEEPChangeRequest.Status::Pending);
                        CEEPChangeRequest.Modify(true);
                        Variant := CEEPChangeRequest;
                    end;
                //Change Request
                Database::"Change Request":
                    begin
                        RecRef.SetTable(ChangeRequest);
                        ChangeRequest.Validate(status, ChangeRequest.Status::Pending);
                        ChangeRequest.Modify(true);
                        Variant := ChangeRequest;
                    end;
                //FOSA Product Application
                Database::"Accounts Applications Details":
                    begin
                        RecRef.SetTable(FOSAProductApplication);
                        FOSAProductApplication.Validate(Status, FOSAProductApplication.Status::Pending);
                        FOSAProductApplication.Modify(true);
                        Variant := FOSAProductApplication;
                    end;
                //Loan Recovery Application
                Database::"Loan Recovery Header":
                    begin
                        RecRef.SetTable(LoanRecoveryApplication);
                        LoanRecoveryApplication.Validate(Status, LoanRecoveryApplication.Status::Pending);
                        LoanRecoveryApplication.Modify(true);
                        Variant := LoanRecoveryApplication;
                    end;

            end;
        end;
        */

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnOpenDocument', '', true, true)]
    local procedure OnOpenDocument(RecRef: RecordRef; var Handled: Boolean)
    var
        MembershipApplication: Record "Membership Applications";
        LoansRegister: Record "Loans Register";
        BOSATransfers: Record "BOSA Transfers";
        LoanBatchDisbursements: Record "Loan Disburesment-Batching";
        LoanTopUp: Record "Loan Top Up.";
        ChangeRequest: Record "Change Request";
        // LeaveApplication: Record "HR Leave Application";
        GuarantorSubstitution: Record "Guarantorship Substitution H";
        PaymentVoucher: Record "Payment Header";
        PettyCashReimbersement: Record "Funds Transfer Header";
        FOSAProductApplication: Record "Accounts Applications Details";
        LoanRecoveryApplication: Record "Loan Recovery Header";
        MembershipExist: Record "Membership Exist";
        MemberReapplication: Record "Member Reapplication";

    begin
        case RecRef.Number of
            //Member Reapplication
            Database::"Member Reapplication":
                begin
                    RecRef.SetTable(MemberReapplication);
                    MemberReapplication.Validate(Status, MemberReapplication.Status::open);
                    MemberReapplication.Modify(true);
                    Handled := true;
                end;
            //Member Exit
            Database::"Membership Exist":
                begin
                    RecRef.SetTable(MembershipExist);
                    MembershipExist.Validate(Status, MembershipExist.Status::open);
                    MembershipExist.Modify(true);
                    Handled := true;
                end;
            //Pettycash payment
            DATABASE::"Funds Transfer Header":
                begin
                    RecRef.SetTable(PettyCashReimbersement);
                    PettyCashReimbersement.Status := PettyCashReimbersement.Status::Open;
                    PettyCashReimbersement.Modify(true);
                    Handled := true;
                end;
            //Payment Voucher
            DATABASE::"Payment Header":
                begin
                    RecRef.SetTable(PaymentVoucher);
                    PaymentVoucher.Status := PaymentVoucher.Status::New;
                    PaymentVoucher.Modify(true);
                    Handled := true;
                end;
            //Guarantor Substitution
            DATABASE::"Guarantorship Substitution H":
                begin
                    RecRef.SetTable(GuarantorSubstitution);
                    GuarantorSubstitution.Status := GuarantorSubstitution.Status::Open;
                    GuarantorSubstitution.Modify(true);
                    Handled := true;
                end;
            //Leave Application
            // DATABASE::"HR Leave Application":
            //     begin
            //         RecRef.SetTable(LeaveApplication);
            //         LeaveApplication.Status := LeaveApplication.Status::New;
            //         LeaveApplication.Modify(true);
            //         Handled := true;
            //     end;
            //Membership Application
            DATABASE::"Membership Applications":
                begin
                    RecRef.SetTable(MembershipApplication);
                    MembershipApplication.Status := MembershipApplication.Status::Open;
                    MembershipApplication.Modify(true);
                    Handled := true;
                end;
            //Loan Application
            Database::"Loans Register":
                begin
                    RecRef.SetTable(LoansRegister);
                    LoansRegister."Approval Status" := LoansRegister."Approval Status"::Open;
                    LoansRegister.Validate("loan status", LoansRegister."loan status"::Application);
                    LoansRegister.Modify(true);
                    Handled := true;
                end;
            //BOSA Transfers
            Database::"BOSA Transfers":
                begin
                    RecRef.SetTable(BOSATransfers);
                    BOSATransfers.Status := BOSATransfers.Status::Open;
                    BOSATransfers.Modify(true);
                    Handled := true;
                end;
            //Loan Batch Disbursements
            Database::"Loan Disburesment-Batching":
                begin
                    RecRef.SetTable(LoanBatchDisbursements);
                    LoanBatchDisbursements.status := LoanBatchDisbursements.status::Open;
                    LoanBatchDisbursements.Modify(true);
                    Handled := true;
                end;
            //Loan TopUp
            Database::"Loan Top Up.":
                begin
                    RecRef.SetTable(LoanTopUp);
                    LoanTopUp.status := LoanTopUp.status::Open;
                    LoanTopUp.Modify(true);
                    Handled := true;
                end;
            //Change Request
            Database::"Change Request":
                begin
                    RecRef.SetTable(ChangeRequest);
                    ChangeRequest.status := ChangeRequest.status::Open;
                    ChangeRequest.Modify(true);
                    Handled := true;
                end;
            //FOSA Product Application
            DATABASE::"Accounts Applications Details":
                begin
                    RecRef.SetTable(FOSAProductApplication);
                    FOSAProductApplication.Status := FOSAProductApplication.Status::Open;
                    FOSAProductApplication.Modify(true);
                    Handled := true;
                end;
            //Loan Recovery Application
            DATABASE::"Loan Recovery Header":
                begin
                    RecRef.SetTable(LoanRecoveryApplication);
                    LoanRecoveryApplication.Status := LoanRecoveryApplication.Status::Open;
                    LoanRecoveryApplication.Modify(true);
                    Handled := true;
                end;

        end

    end;

    [EventSubscriber(ObjectType::Codeunit, codeunit::"Approvals Mgmt.", 'OnSetStatusToPendingApproval', '', false, false)]
    procedure OnSetStatusToPendingApproval(RecRef: RecordRef; var Variant: Variant; var IsHandled: Boolean)
    var
        MembershipApplication: Record "Membership Applications";
        LoansRegister: Record "Loans Register";
        BOSATransfers: Record "BOSA Transfers";
        LoanBatchDisbursements: Record "Loan Disburesment-Batching";
        LoanTopUp: Record "Loan Top Up.";
        ChangeRequest: Record "Change Request";
        // LeaveApplication: Record "HR Leave Application";
        GuarantorSubstitution: Record "Guarantorship Substitution H";
        PaymentVoucher: Record "Payment Header";
        PettyCashReimbersement: Record "Funds Transfer Header";
        FOSAProductApplication: Record "Accounts Applications Details";
        LoanRecoveryApplication: Record "Loan Recovery Header";
        MembershipExist: Record "Membership Exist";
        MemberReapplication: Record "Member Reapplication";
    begin
        RecRef.GetTable(Variant);
        case RecRef.Number of
            //Membership Reapplication
            Database::"Member Reapplication":
                begin
                    RecRef.SetTable(MemberReapplication);
                    MemberReapplication.Validate(Status, MemberReapplication.Status::Pending);
                    MemberReapplication.Modify(true);
                    IsHandled := true;
                end;
            //Membership exit
            Database::"Membership Exist":
                begin
                    RecRef.SetTable(MembershipExist);
                    MembershipExist.Validate(Status, MembershipExist.Status::Pending);
                    MembershipExist.Modify(true);
                    IsHandled := true;
                end;
            //PettyCash Reimbursement
            Database::"Funds Transfer Header":
                begin
                    RecRef.SetTable(PettyCashReimbersement);
                    PettyCashReimbersement.Validate(Status, PettyCashReimbersement.Status::"Pending Approval");
                    PettyCashReimbersement.Modify(true);
                    IsHandled := true;
                end;
            //Payment Voucher
            Database::"Payment Header":
                begin
                    RecRef.SetTable(PaymentVoucher);
                    PaymentVoucher.Validate(Status, PaymentVoucher.Status::"Pending Approval");
                    PaymentVoucher.Modify(true);
                    IsHandled := true;
                end;
            //Guarantor Substitution
            Database::"Guarantorship Substitution H":
                begin
                    RecRef.SetTable(GuarantorSubstitution);
                    GuarantorSubstitution.Validate(Status, GuarantorSubstitution.Status::Pending);
                    GuarantorSubstitution.Modify(true);
                    IsHandled := true;
                end;
            //Leave Application
            // Database::"HR Leave Application":
            //     begin
            //         RecRef.SetTable(LeaveApplication);
            //         LeaveApplication.Validate(Status, LeaveApplication.Status::"Pending Approval");
            //         LeaveApplication.Modify(true);
            //         IsHandled := true;
            //     end;
            //Membership Application
            Database::"Membership Applications":
                begin
                    RecRef.SetTable(MembershipApplication);
                    MembershipApplication.Validate(Status, MembershipApplication.Status::"Pending Approval");
                    MembershipApplication.Modify(true);
                    IsHandled := true;
                end;
            //FOSA Product Application
            Database::"Accounts Applications Details":
                begin
                    RecRef.SetTable(FOSAProductApplication);
                    FOSAProductApplication.Validate(Status, FOSAProductApplication.Status::Pending);
                    FOSAProductApplication.Modify(true);
                    IsHandled := true;
                end;

            //Loan Application
            // Database::"Loans Register":
            //     begin
            //         RecRef.SetTable(LoansRegister);
            //         LoansRegister.Validate("Approval Status", LoansRegister."Approval Status"::Pending);
            //         LoansRegister.Validate("loan status", LoansRegister."loan status"::Appraisal);
            //         LoansRegister.Modify(true);
            //         IsHandled := true;
            //     end;

            // Loan Application
            Database::"Loans Register":
                begin
                    RecRef.SetTable(LoansRegister);
                    if LoansRegister.Get(LoansRegister."Loan  No.") then begin
                        LoansRegister.Validate("Approval Status", LoansRegister."Approval Status"::Pending);
                        LoansRegister.Validate("loan status", LoansRegister."loan status"::Appraisal);
                        LoansRegister.Modify(true);  // Ensure record is not outdated
                        //Variant := LoansRegister;
                        IsHandled := true;
                    end;
                end;



            //BOSA Transfers
            Database::"BOSA Transfers":
                begin
                    RecRef.SetTable(BOSATransfers);
                    BOSATransfers.Validate(Status, BOSATransfers.Status::"Pending Approval");
                    BOSATransfers.Modify(true);
                    IsHandled := true;
                end;
            //Loan Batch Disbursements
            Database::"Loan Disburesment-Batching":
                begin
                    RecRef.SetTable(LoanBatchDisbursements);
                    LoanBatchDisbursements.Validate(Status, LoanBatchDisbursements.Status::"Pending Approval");
                    LoanBatchDisbursements.Modify(true);
                    IsHandled := true;
                end;
            //Loan TopUp
            Database::"Loan Top Up.":
                begin
                    RecRef.SetTable(LoanTopUp);
                    LoanTopUp.Validate(Status, LoanTopUp.Status::Pending);
                    LoanTopUp.Modify(true);
                    IsHandled := true;
                end;
            //Change Request
            Database::"Change Request":
                begin
                    RecRef.SetTable(ChangeRequest);
                    ChangeRequest.Validate(Status, ChangeRequest.Status::Pending);
                    ChangeRequest.Modify(true);
                    IsHandled := true;
                end;
            //Loan Recovery Application
            Database::"Loan Recovery Header":
                begin
                    RecRef.SetTable(LoanRecoveryApplication);
                    LoanRecoveryApplication.Validate(Status, LoanRecoveryApplication.Status::Pending);
                    LoanRecoveryApplication.Modify(true);
                    IsHandled := true;
                end;

        end;
    end;




    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnReleaseDocument', '', false, false)]
    local procedure OnReleaseDocument(RecRef: RecordRef; var Handled: Boolean)
    var
        MemberShipApp: Record "Membership Applications";
        LoansRegister: Record "Loans Register";
        BOSATransfers: Record "BOSA Transfers";
        LoanBatchDisbursements: Record "Loan Disburesment-Batching";
        LoanTopUp: Record "Loan Top Up.";
        ChangeRequest: Record "Change Request";
        GuarantorSubstitution: Record "Guarantorship Substitution H";
        PaymentVoucher: Record "Payment Header";
        PettyCashReimbersement: Record "Funds Transfer Header";
        FOSAProductApplication: Record "Accounts Applications Details";
        LoanRecoveryApplication: Record "Loan Recovery Header";
        MembershipExist: Record "Membership Exist";
        MemberReapplication: Record "Member Reapplication";
        instantLoanApplications: Record "Loans Register";
    begin
        case RecRef.Number of
            //Membership Reapplication
            DATABASE::"Member Reapplication":
                begin
                    RecRef.SetTable(MemberReapplication);
                    MemberReapplication.Status := MemberReapplication.Status::Approved;
                    MemberReapplication.Modify(true);
                    Handled := true;
                end;
            //Membership Exit
            DATABASE::"Membership Exist":
                begin
                    RecRef.SetTable(MembershipExist);
                    MembershipExist.Status := MembershipExist.Status::Approved;
                    MembershipExist.Modify(true);
                    Handled := true;
                end;
            //Petty Cash Reimbursement
            DATABASE::"Funds Transfer Header":
                begin
                    RecRef.SetTable(PettyCashReimbersement);
                    PettyCashReimbersement.Status := PettyCashReimbersement.Status::Approved;
                    PettyCashReimbersement.Modify(true);
                    Handled := true;
                end;
            //"Payment Header"
            DATABASE::"Payment Header":
                begin
                    RecRef.SetTable(PaymentVoucher);
                    PaymentVoucher.Status := PaymentVoucher.Status::Approved;
                    PaymentVoucher.Modify(true);
                    Handled := true;
                end;
            //"Guarantorship Substitution H"
            DATABASE::"Guarantorship Substitution H":
                begin
                    RecRef.SetTable(GuarantorSubstitution);
                    GuarantorSubstitution.Status := GuarantorSubstitution.Status::Approved;
                    GuarantorSubstitution.Modify(true);
                    Handled := true;
                end;

            //Membership applications
            DATABASE::"Membership Applications":
                begin
                    RecRef.SetTable(MemberShipApp);
                    MemberShipApp.Status := MemberShipApp.Status::Approved;
                    MemberShipApp.Modify(true);
                    Handled := true;
                end;
            //FOSA Product applications
            DATABASE::"Accounts Applications Details":
                begin
                    RecRef.SetTable(FOSAProductApplication);
                    FOSAProductApplication.Status := FOSAProductApplication.Status::Approved;
                    FOSAProductApplication.Modify(true);
                    Handled := true;
                end;
            //Loans Applications
            DATABASE::"Loans Register":

                begin
                    RecRef.SetTable(LoansRegister);
                    LoansRegister."Approval Status" := LoansRegister."Approval Status"::Approved;
                    LoansRegister.Validate("loan status", LoansRegister."loan status"::Approved);
                    LoansRegister.Modify(true);
                    Handled := true;
                end;
            // //Loans Applications
            // DATABASE::"Loans Register" and LoansRegister."Loan Product Type" == 'LT007':
            //     begin
            //         RecRef.SetTable(LoansRegister);
            //         LoansRegister."Approval Status" := LoansRegister."Approval Status"::Approved;
            //         LoansRegister.Validate("loan status", LoansRegister."loan status"::Approved);
            //         LoansRegister.Modify(true);
            //         Handled := true;
            //     end;
            //BOSA Transfers
            DATABASE::"BOSA Transfers":
                begin
                    RecRef.SetTable(BOSATransfers);
                    BOSATransfers.Status := BOSATransfers.Status::Approved;
                    BOSATransfers."Approved By" := UserId;
                    BOSATransfers.Modify(true);
                    Handled := true;
                end;
            //Loan Batching
            DATABASE::"Loan Disburesment-Batching":
                begin
                    RecRef.SetTable(LoanBatchDisbursements);
                    LoanBatchDisbursements.Status := LoanBatchDisbursements.Status::Approved;
                    LoanBatchDisbursements.Modify(true);
                    Handled := true;
                end;
            //Loan TopUp
            DATABASE::"Loan Top Up.":
                begin
                    RecRef.SetTable(LoanTopUp);
                    LoanTopUp.Status := LoanTopUp.Status::Approved;
                    LoanTopUp.Modify(true);
                    Handled := true;
                end;
            //Change Request
            DATABASE::"Change Request":
                begin
                    RecRef.SetTable(ChangeRequest);
                    ChangeRequest.Status := ChangeRequest.Status::Approved;
                    ChangeRequest.Modify(true);
                    Handled := true;
                end;
            //Loan Recovery applications
            DATABASE::"Loan Recovery Header":
                begin
                    RecRef.SetTable(LoanRecoveryApplication);
                    LoanRecoveryApplication.Status := LoanRecoveryApplication.Status::Approved;
                    LoanRecoveryApplication.Modify(true);
                    Handled := true;
                end;
        end;

    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnApproveApprovalRequest', '', false, false)]
    local procedure OnAfterLoanApproval(var ApprovalEntry: Record "Approval Entry")
    var
        LoansRegister: Record "Loans Register";
        ApprovalEntry2: Record "Approval Entry";
        RecRef: RecordRef;
    begin
        if ApprovalEntry."Table ID" = Database::"Loans Register" then begin
            // Check if ALL approval entries for this document are approved
            ApprovalEntry2.SetRange("Table ID", Database::"Loans Register");
            ApprovalEntry2.SetRange("Record ID to Approve", ApprovalEntry."Record ID to Approve");
            ApprovalEntry2.SetFilter(Status, '<>%1', ApprovalEntry2.Status::Approved);


            // if ApprovalEntry2.Find() and (ApprovalEntry2."Sequence No." = 1) and (ApprovalEntry2."Pending Approvals" > 0) then begin
            //     ApprovalEntry2.Reset();
            //     ApprovalEntry2.SetRange("Document Type", ApprovalEntry2."Document Type");
            //     ApprovalEntry2.SetRange("Document No.", ApprovalEntry2."Document No.");
            //     ApprovalEntry2.SetRange("Sequence No.", 1);
            //     ApprovalEntry2.SetRange(Status, ApprovalEntry2.Status::Open);

            //     if ApprovalEntry2.FindSet() then
            //         repeat
            //             ApprovalEntry2.Status := ApprovalEntry2.Status::Approved;
            //             ApprovalEntry2.Modify();
            //         until ApprovalEntry2.Next() = 0;
            // end;


            // If no pending approvals remain, update loan status
            if ApprovalEntry2.IsEmpty then begin
                RecRef.Get(ApprovalEntry."Record ID to Approve");
                RecRef.SetTable(LoansRegister);

                LoansRegister."Loan Status" := LoansRegister."Loan Status"::Approved;
                LoansRegister."Approval Status" := LoansRegister."Approval Status"::Approved;
                LoansRegister.Modify(true);
            end
        end;
    end;

    [EventSubscriber(ObjectType::Report, Report::"Notification Email", 'OnSetReportFieldPlaceholders', '', false, false)]
    local procedure OnSetLoanReportFieldPlaceholders(RecRef: RecordRef; var Field1Label: Text; var Field1Value: Text; var Field2Label: Text; var Field2Value: Text; var Field3Label: Text; var Field3Value: Text; var DetailsLabel: Text; var DetailsValue: Text; NotificationEntry: Record "Notification Entry")
    var
        LoansRegister: Record "Loans Register";
    begin
        if RecRef.Number = Database::"Loans Register" then begin
            RecRef.SetTable(LoansRegister);


            // Customize the field labels and values
            Field1Label := 'Applicant Name';
            Field1Value := LoansRegister."Client Name";

            Field2Label := 'Applied Amount';
            Field2Value := Format(LoansRegister."Approved Amount");

            Field3Label := 'Loan Type';
            Field3Value := LoansRegister."Loan Product Type Name";

            DetailsLabel := 'Loan Type';
            DetailsValue := LoansRegister."Loan Product Type Name"
        end;

    end;


    [EventSubscriber(ObjectType::Report, Report::"Notification Email", 'OnSetReportFieldPlaceholdersOnAfterGetDocumentURL', '', false, false)]
    local procedure OnSetReportFieldPlaceholdersOnAfterGetLoanDocumentURL(var DocumentURL: Text; var NotificationEntry: Record "Notification Entry")
    var
        RecRef: RecordRef;
    begin
        RecRef.Get(NotificationEntry."Triggered By Record");
        if RecRef.Number = Database::"Loans Register" then begin
            DocumentURL := ''; // Remove the custom link completely

        end;
    end;


    [EventSubscriber(ObjectType::Report, Report::"Notification Email", 'OnBeforeGetDocumentTypeAndNumber', '', false, false)]
    local procedure OnBeforeGetDocumentTypeAndNumberForLoan(var NotificationEntry: Record "Notification Entry"; var RecRef: RecordRef; var DocumentType: Text; var DocumentNo: Text; var IsHandled: Boolean)
    var
        LoansRegister: Record "Loans Register";
    begin
        if RecRef.Number = Database::"Loans Register" then begin
            RecRef.SetTable(LoansRegister);
            DocumentType := 'Loan Application' + LoansRegister."Loan Account No";
            DocumentNo := LoansRegister."Loan Account No";
            IsHandled := true;
        end;
    end;

    [EventSubscriber(ObjectType::Report, Report::"Notification Email", 'OnAfterSetReportLinePlaceholders', '', false, false)]
    local procedure OnAfterSetLoanReportLinePlaceholders(ReceipientUser: Record User; CompanyInformation: Record "Company Information"; var Line1: Text; var Line2: Text)
    begin
        // Customize header lines for loan notifications
        Line1 := '';
        Line2 := 'Dear ' + ReceipientUser."User Name" + ', you have a loan application pending approval.';
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Notification Management", 'OnBeforeGetActionTextFor', '', false, false)]
    local procedure OnBeforeGetLoanActionText(var NotificationEntry: Record "Notification Entry"; var CustomText: Text; var IsHandled: Boolean)
    var
        RecRef: RecordRef;
    begin
        RecRef.Get(NotificationEntry."Triggered By Record");
        if RecRef.Number = Database::"Loans Register" then begin
            CustomText := ''; // Remove action text completely
            IsHandled := true;
            NotificationEntry.Text := '';

        end;
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnBeforeCreateApprovalEntryNotification', '', false, false)]
    local procedure OnBeforeCreateLoanApprovalNotification(ApprovalEntry: Record "Approval Entry"; var IsHandled: Boolean; WorkflowStepInstance: Record "Workflow Step Instance")
    var
        WorkflowStepArgument: Record "Workflow Step Argument";
        NotificationEntry: Record "Notification Entry";
    begin
        if ApprovalEntry."Table ID" = Database::"Loans Register" then begin
            WorkflowStepArgument.Get(WorkflowStepInstance.Argument);

            NotificationEntry.CreateNotificationEntry(
                NotificationEntry.Type::Approval,
                ApprovalEntry."Approver ID",
                ApprovalEntry,
                WorkflowStepArgument."Link Target Page",
                '', // Empty string removes custom link
                CopyStr(UserId(), 1, 50)
            );

            IsHandled := true;
        end;
    end;


    [EventSubscriber(ObjectType::Table, Database::"Approval Entry", 'OnBeforeShowRecord', '', false, false)]
    local procedure OnBeforeShowLoanRecord(ApprovalEntry: Record "Approval Entry"; var IsHandled: Boolean)
    var
        LoansRegister: Record "Loans Register";
        RecRef: RecordRef;
        LoanCardPage: Page "Loan Application Card";
    begin
        if ApprovalEntry."Table ID" = Database::"Loans Register" then begin
            RecRef.Get(ApprovalEntry."Record ID to Approve");
            RecRef.SetTable(LoansRegister);


            LoanCardPage.SetRecord(LoansRegister);
            LoanCardPage.SetViewOnlyMode(true);
            LoanCardPage.RunModal;

            IsHandled := true;
        end;
    end;



}

