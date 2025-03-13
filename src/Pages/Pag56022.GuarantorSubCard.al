#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0424, AW0006 // ForNAV settings
Page 56022 "Guarantor Sub Card"
{
    DeleteAllowed = false;
    PageType = Card;
    SourceTable = "Guarantorship Substitution H";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Document No"; Rec."Document No")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Application Date"; Rec."Application Date")
                {
                    ApplicationArea = Basic;
                }
                field("Loanee Member No"; Rec."Loanee Member No")
                {
                    ApplicationArea = Basic;
                    Editable = LoaneeNoEditable;
                }
                field("Loanee Name"; Rec."Loanee Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Loan Guaranteed"; Rec."Loan Guaranteed")
                {
                    ApplicationArea = Basic;
                    Editable = LoanGuaranteedEditable;
                }
                field("Substituting Member"; Rec."Substituting Member")
                {
                    ApplicationArea = Basic;
                    Caption = 'Member to be substuted';
                    Editable = SubMemberEditable;
                }
                field("Substituting Member Name"; Rec."Substituting Member Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                    Editable = true;
                }
                field("Created By"; Rec."Created By")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Substituted; Rec.Substituted)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Date Substituted"; Rec."Date Substituted")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Substituted By"; Rec."Substituted By")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
            }
            part(Control1000000014; "Guarantor Sub Subform")
            {
                SubPageLink = "Document No" = field("Document No"),
                              "Member No" = field("Substituting Member"),
                              "Loan No." = field("Loan Guaranteed");
            }
        }
    }

    actions
    {

        area(navigation)
        {
            group(Approvals)
            {
                action("Send Approval Request")
                {
                    ApplicationArea = Basic;
                    Caption = 'Send Approval Request';
                    Image = SendApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Process;
                    Enabled = SendApproval;

                    trigger OnAction()
                    var
                        SwizzApprovalsCodeUnit: Codeunit SwizzsoftApprovalsCodeUnit;
                        text001: label 'This batch is already pending approval';
                        GuarantorshipSubstitutionL: Record "Guarantorship Substitution L";
                    begin
                        if Rec.Status <> Rec.Status::Open then
                            Error('Status must be open.');

                        Rec.TestField("Loanee Member No");
                        Rec.TestField("Loan Guaranteed");

                        GuarantorshipSubstitutionL.Reset;
                        GuarantorshipSubstitutionL.SetRange("Document No", Rec."Document No");
                        GuarantorshipSubstitutionL.FindFirst;


                        LGuarantor.Reset;
                        LGuarantor.SetRange(LGuarantor."Loan No", Rec."Loan Guaranteed");
                        LGuarantor.SetRange(LGuarantor."Member No", Rec."Substituting Member");
                        if LGuarantor.FindSet then begin
                            //Add All Replaced Amounts
                            TotalReplaced := 0;
                            GSubLine.Reset;
                            GSubLine.SetRange(GSubLine."Document No", Rec."Document No");
                            GSubLine.SetRange(GSubLine."Member No", Rec."Substituting Member");
                            if GSubLine.FindSet then begin
                                repeat
                                    TotalReplaced := TotalReplaced + GSubLine."Sub Amount Guaranteed";
                                until GSubLine.Next = 0;
                            end;
                            //End Add All Replaced Amounts
                            Commited := LGuarantor."Amont Guaranteed";
                            if TotalReplaced < Commited then
                                Error('Guarantors replaced do not cover the whole amount');
                        end;

                        //Approval code  here
                        if Confirm('Send Approval Request?', false) = true then begin
                            SwizzApprovalsCodeUnit.SendGuarantorSubRequestForApproval(rec."Document No", Rec);
                        end;
                        //...................
                    end;
                }

                action("Cancel Approval Request")
                {
                    ApplicationArea = Basic;
                    Caption = 'Cancel Approval Request';
                    Image = CancelApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Process;
                    Enabled = CancelApproval;

                    trigger OnAction()
                    var
                        text001: label 'This batch is already pending approval';
                        SwizzApprovalsCodeUnit: Codeunit SwizzsoftApprovalsCodeUnit;
                    begin
                        if Rec.Status <> Rec.Status::Pending then
                            Error(text001);
                        //Approval here
                        if Confirm('Cancel Approval Request?', false) = true then begin
                            SwizzApprovalsCodeUnit.CancelGuarantorSubRequestForApproval(Rec."Document No", Rec);
                        end;
                    end;
                }


                action("Process Substitution")
                {
                    ApplicationArea = Basic;
                    Image = Apply;
                    Promoted = true;
                    PromotedCategory = Process;
                    Enabled = AllowPosting;

                    trigger OnAction()
                    begin

                        Rec.TestField(Status, Rec.Status::Approved);
                        if Rec."Created By" <> UserId then begin
                            Error('Restricted! you can only process a record you created!');
                        end;
                        LGuarantor.Reset;
                        LGuarantor.SetRange(LGuarantor."Loan No", Rec."Loan Guaranteed");
                        LGuarantor.SetRange(LGuarantor."Member No", Rec."Substituting Member");
                        if LGuarantor.FindSet then begin
                            //Add All Replaced Amounts
                            if LGuarantor.Substituted = true then begin
                                Error('The Guarantor has already being Substituted');
                            end;

                            TotalReplaced := 0;
                            GSubLine.Reset;
                            GSubLine.SetRange(GSubLine."Document No", Rec."Document No");
                            GSubLine.SetRange(GSubLine."Member No", Rec."Substituting Member");
                            if GSubLine.FindSet then begin
                                repeat
                                    TotalReplaced := TotalReplaced + GSubLine."Sub Amount Guaranteed";
                                until GSubLine.Next = 0;
                            end;
                            //End Add All Replaced Amounts

                            //Compare with committed shares
                            Commited := LGuarantor."Amont Guaranteed";
                            if TotalReplaced < Commited then
                                Message('Guarantors replaced do not cover the whole amount');
                            //End Compare with committed Shares

                            //Create Lines
                            GSubLine.Reset;
                            GSubLine.SetRange(GSubLine."Document No", Rec."Document No");
                            GSubLine.SetRange(GSubLine."Member No", Rec."Substituting Member");
                            if GSubLine.FindSet then begin
                                repeat
                                    NewLGuar.Init;
                                    NewLGuar."Loan No" := Rec."Loan Guaranteed";
                                    NewLGuar."Member No" := GSubLine."Substitute Member";
                                    NewLGuar.Validate(NewLGuar."Member No");
                                    NewLGuar.Name := GSubLine."Substitute Member Name";
                                    NewLGuar."Amont Guaranteed" := CalculateAmountGuaranteed(GSubLine."Sub Amount Guaranteed", TotalReplaced, GSubLine."Amount Guaranteed");
                                    NewLGuar."Substituted Guarantor" := GSubLine."Member No";
                                    NewLGuar.Shares := GSubLine."Substitute Member Deposits";

                                    NewLGuar.Insert();
                                until GSubLine.Next = 0;
                            end;
                            //End Create Lines

                            LGuarantor.Substituted := true;

                            Rec.Substituted := true;
                            Rec."Date Substituted" := Today;
                            Rec."Substituted By" := UserId;
                            Rec.Status := Rec.Status::Closed;
                            if Rec.Modify() = true then begin
                                Message('Guarantor Substituted Succesfully');
                            end;

                            LGuarantor.Modify;
                        end;
                    end;
                }
            }

        }
    }


    trigger OnAfterGetCurrRecord()
    begin
        FNAddRecordRestriction();
        Controls();
    end;

    trigger OnAfterGetRecord()
    begin
        FNAddRecordRestriction();
        Controls();
    end;

    trigger OnOpenPage()
    begin
        Rec."Application Date" := Today;
        Controls();
    end;

    var
        LGuarantor: Record "Loans Guarantee Details";
        GSubLine: Record "Guarantorship Substitution L";
        LoaneeNoEditable: Boolean;
        LoanGuaranteedEditable: Boolean;
        SubMemberEditable: Boolean;
        TotalReplaced: Decimal;
        Commited: Decimal;
        SendApproval: Boolean;
        AllowPosting: Boolean;
        CancelApproval: Boolean;
        NewLGuar: Record "Loans Guarantee Details";

    local procedure FNAddRecordRestriction()
    begin
        if Rec.Status = Rec.Status::Open then begin
            LoaneeNoEditable := true;
            LoanGuaranteedEditable := true;
            SubMemberEditable := true

        end else
            if Rec.Status = Rec.Status::Pending then begin
                LoaneeNoEditable := false;
                LoanGuaranteedEditable := false;
                SubMemberEditable := false
            end else
                if Rec.Status = Rec.Status::Approved then begin
                    LoaneeNoEditable := false;
                    LoanGuaranteedEditable := false;
                    SubMemberEditable := false;
                end;
    end;

    local procedure CalculateAmountGuaranteed(AmountReplaced: Decimal; TotalAmount: Decimal; AmountGuaranteed: Decimal) AmtGuar: Decimal
    begin
        AmtGuar := ((AmountReplaced / TotalAmount) * AmountGuaranteed);

        exit(AmtGuar);
    end;

    local procedure Controls()
    begin
        if Rec.Status = Rec.Status::Open THEN begin
            AllowPosting := false;
            CancelApproval := false;
            SendApproval := true;
        end ELSE
            if Rec.Status = Rec.Status::Pending THEN begin
                AllowPosting := false;
                CancelApproval := true;
                SendApproval := false;
            end ELSE
                if Rec.Status = Rec.Status::Approved THEN begin
                    AllowPosting := true;
                    CancelApproval := false;
                    SendApproval := false;
                end
                ELSE
                    if Rec.Status = Rec.Status::Closed THEN begin
                        AllowPosting := false;
                        CancelApproval := false;
                        SendApproval := false;
                    end;
    end;
}

