codeunit 59082 "Instant Loan Block Tests"
{
    Subtype = Test;

    [Test]
    procedure BlockOnlyAppliesToInstantProducts()
    begin
        CreateMember();
        BlockMgt.SetBlocked(MemberNo, true, false);
        if not BlockMgt.IsBlocked(MemberNo, 'LT006') then
            Error('LT006 must be blocked.');
        if not BlockMgt.IsBlocked(MemberNo, 'LT007') then
            Error('LT007 must be blocked.');
        BlockMgt.CheckAvailable(MemberNo, 'LT001');
        BlockMgt.CheckAvailable('UNBLOCKED-MEMBER', 'LT007');
        asserterror BlockMgt.CheckAvailable(MemberNo, 'LT007');
        AssertUnavailableError();
    end;

    [Test]
    procedure UnblockRestoresAccessAndKeepsHistory()
    var
        History: Record "Instant Loan Block History";
        MemberBlock: Record "Instant Loan Member Block";
    begin
        CreateMember();
        BlockMgt.SetBlocked(MemberNo, true, false);
        BlockMgt.SetBlocked(MemberNo, false, true);
        BlockMgt.CheckAvailable(MemberNo, 'LT006');
        BlockMgt.CheckAvailable(MemberNo, 'LT007');
        MemberBlock.Get(MemberNo);
        if MemberBlock.Blocked then
            Error('Member must be unblocked.');
        History.SetRange("Member No.", MemberNo);
        if History.Count() <> 2 then
            Error('Both changes must remain in history.');
        History.FindLast();
        if History.Blocked or (History."Changed By" <> UserId()) or (History."Changed At" = 0DT) then
            Error('Unblock audit details are incorrect.');
    end;

    [Test]
    procedure StaleCheckboxDoesNotOverwriteNewStatus()
    begin
        CreateMember();
        BlockMgt.SetBlocked(MemberNo, true, false);
        asserterror BlockMgt.SetBlocked(MemberNo, false, false);
        if not BlockMgt.IsBlocked(MemberNo, 'LT007') then
            Error('Stale update must leave the member blocked.');
    end;

    [Test]
    procedure CreationAndQualificationRejectBlockedMember()
    var
        Applications: Record "Online Loan Application";
        BeforeCount: Integer;
        Qualification: Decimal;
        Applied: Boolean;
    begin
        CreateMember();
        BlockMgt.SetBlocked(MemberNo, true, false);
        BeforeCount := Applications.Count();
        AssertUnavailable(Portal.OnlineLoanApplication(MemberNo, 'LT006', 1000, '', 1, 0, 0, '', 0));
        AssertUnavailable(Portal.OnlineLoanApplication(MemberNo, 'LT007', 1000, '', 1, 0, 0, '', 0));
        if Applications.Count() <> BeforeCount then
            Error('Blocked creation must not insert an application.');
        asserterror Qualification := Portal.GetLoanQualification(MemberNo, 'LT007');
        AssertUnavailableError();
        asserterror Applied := Portal.FnLoanApplication(MemberNo, 'LT006', 1000, '', 0);
        AssertUnavailableError();
    end;

    [Test]
    procedure OldDraftCannotBeSubmittedOrEditedAfterBlocking()
    var
        Loans: Record "Loans Register";
        BeforeCount: Integer;
    begin
        CreateMember();
        CreateDraft('LT007');
        BeforeCount := Loans.Count();
        BlockMgt.SetBlocked(MemberNo, true, false);
        AssertUnavailable(Portal.SubmitLoan(MemberNo, ApplicationNo));
        AssertUnavailable(Portal.editOnlineLoan(ApplicationNo, MemberNo, 2000, 'LT007', 2));
        Draft.Get(ApplicationNo);
        if Draft.submitted or (Draft."Application Status" <> Draft."Application Status"::Application) then
            Error('Rejected submission must leave the draft unchanged.');
        if Draft."Loan Amount" <> 1000 then
            Error('Rejected edit must leave the amount unchanged.');
        if Loans.Count() <> BeforeCount then
            Error('Rejected submission must not create a loan.');
    end;

    [Test]
    procedure SwitchingOtherDraftToInstantIsRejected()
    begin
        CreateMember();
        CreateDraft('LT001');
        BlockMgt.SetBlocked(MemberNo, true, false);
        AssertUnavailable(Portal.editOnlineLoan(ApplicationNo, MemberNo, 2000, 'LT006', 2));
        Draft.Get(ApplicationNo);
        if Draft."Loan Type" <> 'LT001' then
            Error('Rejected product change must leave the draft unchanged.');
    end;

    [Test]
    procedure GuarantorConversionAndRefinancingAreRejected()
    var
        Response: Text;
        Applied: Boolean;
    begin
        CreateMember();
        CreateDraft('LT006');
        BlockMgt.SetBlocked(MemberNo, true, false);
        AssertUnavailable(Portal.ApproveGuarantorship('GUARANTOR', ApplicationNo, 0));
        if Portal.FnRequestGuarantorship('GUARANTOR', ApplicationNo, Response) then
            Error('Guarantor request must be rejected.');
        AssertUnavailable(Response);
        asserterror Applied := Portal.OnlineLoanRefinancing(MemberNo, ApplicationNo, 'OLD-LOAN', 'LT001', 100);
        AssertUnavailableError();
        asserterror Portal.submitGuarantors('GUARANTOR', ApplicationNo, '');
        AssertUnavailableError();
    end;

    [Test]
    procedure LegacyLoanPathsRejectBeforeMutation()
    var
        Loan: Record "Loans Register";
    begin
        CreateMember();
        Loan.Init();
        Loan."Loan  No." := MemberNo;
        Loan."Client Code" := MemberNo;
        Loan."Loan Product Type" := 'LT007';
        Loan."Loan Status" := Loan."Loan Status"::Application;
        Loan."Requested Amount" := 1000;
        Loan.Insert(false);
        BlockMgt.SetBlocked(MemberNo, true, false);
        asserterror Portal.fnedtitloan(2000, Loan."Loan  No.", 2, '', 'LT007');
        AssertUnavailableError();
        asserterror Portal.FnApplytoAppraise(Loan."Loan  No.");
        AssertUnavailableError();
        asserterror Portal.fnGuarantorsPortal(MemberNo, 'GUARANTOR', Loan."Loan  No.", '');
        AssertUnavailableError();
        Loan.Get(MemberNo);
        if (Loan."Requested Amount" <> 1000) or (Loan."Loan Status" <> Loan."Loan Status"::Application) then
            Error('Blocked legacy calls must leave the loan unchanged.');
    end;

    local procedure CreateMember()
    var
        Member: Record Customer;
    begin
        MemberNo := CopyStr(DelChr(Format(CreateGuid()), '=', '{}-'), 1, 20);
        Member.Init();
        Member."No." := MemberNo;
        Member.Name := 'Instant loan block test';
        Member.Insert(false);
    end;

    local procedure CreateDraft(ProductCode: Code[20])
    begin
        ApplicationNo := MemberNo;
        Draft.Init();
        Draft."Application No" := ApplicationNo;
        Draft."BOSA No" := MemberNo;
        Draft."Membership No" := MemberNo;
        Draft."Loan Type" := ProductCode;
        Draft."Loan Amount" := 1000;
        Draft."Application Status" := Draft."Application Status"::Application;
        Draft.Insert(false);
    end;

    local procedure AssertUnavailable(Response: Text)
    begin
        if Response <> 'Loan not available' then
            Error('Unexpected response: %1', Response);
    end;

    local procedure AssertUnavailableError()
    begin
        AssertUnavailable(GetLastErrorText());
    end;

    var
        BlockMgt: Codeunit "Instant Loan Block Mgt.";
        Portal: Codeunit "PORTALIntegration MFS";
        Draft: Record "Online Loan Application";
        MemberNo: Code[20];
        ApplicationNo: Code[20];
}
