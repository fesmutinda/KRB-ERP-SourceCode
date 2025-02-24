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
            Database::"Loans Register":
                begin
                    RecRef.SetTable(LoansRegister);
                    LoansRegister.Validate("Approval Status", LoansRegister."Approval Status"::Pending);
                    LoansRegister.Validate("loan status", LoansRegister."loan status"::Appraisal);
                    LoansRegister.Modify(true);
                    IsHandled := true;
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

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnExecuteWorkflowResponse', '', true, true)]
    local procedure SetRecStatusToPendingApproval(var Variant: Variant)
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
                    Variant := MemberReapplication;
                end;
            //Membership Exit
            Database::"Membership Exist":
                begin
                    RecRef.SetTable(MembershipExist);
                    MembershipExist.Validate(Status, MembershipExist.Status::Pending);
                    MembershipExist.Modify(true);
                    Variant := MembershipExist;
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
            //Leave Application
            // Database::"HR Leave Application":
            //     begin
            //         RecRef.SetTable(LeaveApplication);
            //         LeaveApplication.Validate(Status, LeaveApplication.Status::"Pending Approval");
            //         LeaveApplication.Modify(true);
            //         Variant := LeaveApplication;
            //     end;
            //Membership Application
            Database::"Membership Applications":
                begin
                    RecRef.SetTable(MembershipApplication);
                    MembershipApplication.Validate(Status, MembershipApplication.Status::"Pending Approval");
                    MembershipApplication.Modify(true);
                    Variant := MembershipApplication;
                end;
            //----------------------FOSA Product Application
            Database::"Accounts Applications Details":
                begin
                    RecRef.SetTable(FOSAProductApplication);
                    FOSAProductApplication.Validate(Status, FOSAProductApplication.Status::Pending);
                    FOSAProductApplication.Modify(true);
                    Variant := FOSAProductApplication;
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
                    BOSATransfers.Validate(status, BOSATransfers.Status::"Pending Approval");
                    BOSATransfers.Modify(true);
                    Variant := BOSATransfers;
                end;
            //Loan Batch Disbursements
            Database::"Loan Disburesment-Batching":
                begin
                    RecRef.SetTable(LoanBatchDisbursements);
                    LoanBatchDisbursements.Validate(status, LoanBatchDisbursements.Status::"Pending Approval");
                    LoanBatchDisbursements.Modify(true);
                    Variant := LoanBatchDisbursements;
                end;
            //Loan TopUp
            Database::"Loan Top Up.":
                begin
                    RecRef.SetTable(LoanTopUp);
                    LoanTopUp.Validate(status, LoanTopUp.Status::Pending);
                    LoanTopUp.Modify(true);
                    Variant := LoanTopUp;
                end;
            //Change Request
            Database::"Change Request":
                begin
                    RecRef.SetTable(ChangeRequest);
                    ChangeRequest.Validate(status, ChangeRequest.Status::Pending);
                    ChangeRequest.Modify(true);
                    Variant := ChangeRequest;
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


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnReleaseDocument', '', true, true)]
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

}

