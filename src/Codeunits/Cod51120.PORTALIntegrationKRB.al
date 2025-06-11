#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 51120 "PORTALIntegration KRB"
{
    trigger OnRun()
    begin

    end;

    var
        i: Integer;
        Rschedule: Record "Loan Repayment Schedule";
        Lperiod: Integer;
        LastPayDate: Date;
        objMember: Record Customer;
        Vendor: Record Vendor;
        VendorLedgEntry: Record "Vendor Ledger Entry";
        FILESPATH: label 'D:\Kentours Revised\KENTOURS\Kentours\Kentours\Downloads\';
        objLoanRegister: Record "Loans Register";
        objRegMember: Record "Membership Applications";
        objNextKin: Record "Members Next Kin Details";
        GenSetup: Record "Sacco General Set-Up";
        FreeShares: Decimal;
        glamount: Decimal;
        LoansGuaranteeDetails: Record "Loans Guarantee Details";
        objStandingOrders: Record "Standing Orders";
        freq: DateFormula;
        dur: DateFormula;
        phoneNumber: Code[20];
        SMSMessages: Record "SMS Messages";
        iEntryNo: Integer;
        FAccNo: Text[250];
        sms: Text[250];
        objLoanApplication: Record "Main Sector";
        ClientName: Code[20];
        Loansetup: Record "Loan Products Setup";
        feedback: Record Portal;
        LoansPurpose: Record "Loans Purpose";
        ObjLoansregister: Record "Loans Register";
        LPrincipal: Decimal;
        LInterest: Decimal;
        Amount: Decimal;
        LBalance: Decimal;
        LoansRec: Record "Loans Register";
        TotalMRepay: Decimal;
        InterestRate: Decimal;
        Date: Date;
        FormNo: Code[40];
        PortaLuPS: Record PortalUps;
        Loanperiod: Integer;
        Questinnaires: Record Questionnaire;
        LastFieldNo: Integer;
        FooterPrinted: Boolean;
        Cust: Record customer;
        StartDate: Date;
        DateFilter: Text[100];
        FromDate: Date;
        ToDate: Date;
        FromDateS: Text[100];
        ToDateS: Text[100];
        DivTotal: Decimal;
        CDeposits: Decimal;
        CustDiv: Record customer;
        DivProg: Record "Dividends Progression";
        CDiv: Decimal;
        BDate: Date;
        CustR: Record customer;
        CapDiv: Decimal;
        DivCapTotal: Decimal;
        RunningPeriod: Code[10];
        LineNo: Integer;
        Gnjlline: Record "Gen. Journal Line";
        PostingDate: Date;
        "W/Tax": Decimal;
        CommDiv: Decimal;
        DivInTotal: Decimal;
        WTaxInTotal: Decimal;
        CapTotal: Decimal;
        Period: Code[20];
        WTaxShareCap: Decimal;
        CloudPesaLive: Codeunit SwizzKashMobile;
        Online: Record "Online Users";
        SaccoSetup: Record "Sacco No. Series";
        NoSeriesMgmt: Codeunit NoSeriesManagement;
        ObjLoanApplications: Record "Online Loan Application";
        LoanProductType: Record "Loan Products Setup";
        ReturnList: Text;
        source: Text;
        OnlineLoanGuarantors: Record "Online Loan Guarantors";
        NewApplicationNumber: Integer;
        ReturnDecimal: Decimal;
        LoanBalancing: Decimal;
        InstallmentCounts: Integer;


    procedure fnUpdatePassword(MemberNo: Code[50]; idNo: Code[50]; NewPassword: Text; smsport: Text) emailAddress: Boolean
    var
        OutStream: OutStream;
    begin
        sms := smsport + NewPassword;
        objMember.Reset;
        objMember.SetRange(objMember."No.", MemberNo);
        objMember.SetRange(objMember."ID No.", idNo);
        if objMember.Find('-') then begin

            phoneNumber := objMember."Mobile Phone No";
            FAccNo := objMember."No.";
            Online.Reset;
            Online.SetRange("User Name", MemberNo);
            if Online.Find('-') then begin
                //Online.INIT;
                Online."User Name" := objMember."No.";
                Online.MobileNumber := objMember."Mobile Phone No";
                Online.IdNumber := idNo;
                Online.Password := NewPassword;
                Online.Modify;
                FnSMSMessage(FAccNo, phoneNumber, sms);
                emailAddress := true;
            end
            else begin
                Online.Init;
                Online."User Name" := objMember."No.";
                Online.MobileNumber := objMember."Mobile Phone No";
                Online.Email := objMember."E-Mail";
                Online."Date Created" := Today;
                Online.IdNumber := idNo;
                Online.Password := NewPassword;
                // NewPassword := EncryptionManagement.Encrypt(NewPassword);
                // Online.Password.CREATEOUTSTREAM(OutStream);
                // OutStream.WRITE(NewPassword);
                Online.Insert;
                //  ;
                //  ;

                FnSMSMessage(FAccNo, phoneNumber, sms);
                emailAddress := true;
            end;

        end;
    end;


    procedure MiniStatement(MemberNo: Text[100]) MiniStmt: Text
    var
        minimunCount: Integer;
        amount: Decimal;
        fosano: Code[100];
    begin
        begin
            MiniStmt := '';
            objMember.Reset;
            objMember.SetRange("No.", MemberNo);
            if objMember.Find('-') then begin
                fosano := objMember."FOSA Account No.";

                Vendor.Reset;
                Vendor.SetFilter("Account Type", '<>511');
                Vendor.SetRange("No.", fosano);
                if Vendor.Find('-') then
                    minimunCount := 1;
                Vendor.CalcFields(Vendor.Balance);
                VendorLedgEntry.SetCurrentkey(VendorLedgEntry."Entry No.");
                VendorLedgEntry.Ascending(false);
                VendorLedgEntry.SetRange(VendorLedgEntry."Vendor No.", fosano);
                VendorLedgEntry.SetRange(VendorLedgEntry.Reversed, false);
                if VendorLedgEntry.FindSet then begin
                    MiniStmt := '';
                    repeat
                        VendorLedgEntry.CalcFields(Amount);
                        amount := VendorLedgEntry.Amount;
                        if amount < 1 then amount := amount * -1;
                        MiniStmt := MiniStmt + Format(VendorLedgEntry."Posting Date") + ':::' + CopyStr(Format(VendorLedgEntry.Description), 1, 25) + ':::' +
                        Format(amount) + '::::';
                        minimunCount := minimunCount + 1;
                        if minimunCount > 20 then begin
                            exit(MiniStmt);
                        end
                    until VendorLedgEntry.Next = 0;
                end;

            end;

        end;
        exit(MiniStmt);
    end;

    procedure MiniStatement_Json(MemberNo: Text[100]) MiniStmt: Text
    var
        minimunCount: Integer;
        amount: Decimal;
        fosano: Code[100];
        minText: Text;
    begin
        begin
            MiniStmt := '';
            minText := '';
            objMember.Reset;
            objMember.SetRange("No.", MemberNo);
            if objMember.Find('-') then begin
                fosano := objMember."FOSA Account No.";

                Vendor.Reset;
                Vendor.SetFilter("Account Type", '<>511');
                Vendor.SetRange("No.", fosano);
                if Vendor.Find('-') then
                    minimunCount := 1;
                Vendor.CalcFields(Vendor.Balance);
                VendorLedgEntry.SetCurrentkey(VendorLedgEntry."Entry No.");
                VendorLedgEntry.Ascending(false);
                VendorLedgEntry.SetRange(VendorLedgEntry."Vendor No.", fosano);
                VendorLedgEntry.SetRange(VendorLedgEntry.Reversed, false);
                if VendorLedgEntry.FindSet then begin
                    MiniStmt := '';
                    repeat
                        VendorLedgEntry.CalcFields(Amount);
                        amount := VendorLedgEntry.Amount;
                        if amount < 1 then amount := amount * -1;
                        if minText = '' then begin
                            minText := '"Date":"' + Format(VendorLedgEntry."Posting Date") + '"'
                                                                + '"Description":"' + CopyStr(Format(VendorLedgEntry.Description), 1, 25) + '"'
                                                                + '"Amount":"' + Format(amount) + '"';
                        end else begin
                            minText := minText + ',"Date":"' + Format(VendorLedgEntry."Posting Date") + '"'
                                                                + '"Description":"' + CopyStr(Format(VendorLedgEntry.Description), 1, 25) + '"'
                                                                + '"Amount":"' + Format(amount) + '"';
                        end;

                        MiniStmt := MiniStmt + Format(VendorLedgEntry."Posting Date") + ':::' + CopyStr(Format(VendorLedgEntry.Description), 1, 25) + ':::' +
                        Format(amount) + '::::';
                        minimunCount := minimunCount + 1;
                        if minimunCount > 20 then begin
                            exit(minText);
                        end
                    until VendorLedgEntry.Next = 0;
                end;

            end;

        end;
        exit(minText);
    end;


    procedure fnMemberStatement(MemberNo: Code[50]; "filter": Text; var BigText: BigText) exitString: Text
    var
        Filename: Text[100];
        Outputstream: OutStream;
        RecRef: RecordRef;
        TempBlob: Codeunit "Temp Blob";
        Outstr: OutStream;
        Instr: InStream;
        Base64Convert: Codeunit "Base64 Convert";
    begin
        objMember.Reset;
        objMember.SetRange(objMember."No.", MemberNo);
        if objMember.Find('-') then begin
            RecRef.GetTable(objMember);
            Clear(TempBlob);
            TempBlob.CreateOutStream(Outstr);
            TempBlob.CreateInStream(Instr);
            if Report.SaveAs(Report::"Member Account Statement(Ver1)", '', ReportFormat::Pdf, Outstr, RecRef) then begin
                exitString := Base64Convert.ToBase64(Instr);
                exit;
            end;
        end;
    end;


    procedure FnMemberDefaultStatement(MemberNo: Code[50]; var BigText: BigText) exitString: Text
    var
        Filename: Text[100];
        Outputstream: OutStream;
        RecRef: RecordRef;
        TempBlob: Codeunit "Temp Blob";
        Outstr: OutStream;
        Instr: InStream;
        Base64Convert: Codeunit "Base64 Convert";
    begin
        objMember.Reset;
        objMember.SetRange(objMember."No.", MemberNo);
        if objMember.Find('-') then begin
            RecRef.GetTable(objMember);
            Clear(TempBlob);
            TempBlob.CreateOutStream(Outstr);
            TempBlob.CreateInStream(Instr);
            if Report.SaveAs(Report::"Member Account Statement(Ver1)", '', ReportFormat::Pdf, Outstr, RecRef) then begin
                exitString := Base64Convert.ToBase64(Instr);
                exit;
            end;
        end;
    end;

    procedure fndividentstatement(No: Code[50]; Path: Text[100]) exitString: Text
    var
        filename: Text;
        "Member No": Code[50];
    begin
        objMember.Reset;
        objMember.SetRange(objMember."No.", No);

        if objMember.Find('-') then begin

        end;
    end;

    procedure FnGetLoanProductDetails(productType: Text) response: Text
    begin
        BEGIN

            Loansetup.RESET;
            Loansetup.SETRANGE(Code, productType);
            IF Loansetup.FIND('-') THEN BEGIN
                response := FORMAT(Loansetup."Min. Loan Amount") + ':::' + FORMAT(Loansetup."Max. Loan Amount") + ':::' + FORMAT(Loansetup."Interest rate") + ':::' + FORMAT(Loansetup."No of Installment");
            END;
        END;
    end;

    procedure FnGetLoanProductJson(productType: Text) response: Text
    var
        loansData: Text;
    begin
        BEGIN
            loansData := '';
            Loansetup.RESET;
            Loansetup.SETRANGE(Code, productType);
            IF Loansetup.FIND('-') THEN BEGIN
                loansData := '"MinLoanAmount":"' + FORMAT(Loansetup."Min. Loan Amount") + '"'
                            + '"MaxLoanAmount":"' + FORMAT(Loansetup."Max. Loan Amount") + '"'
                            + '"InterestRate":"' + FORMAT(Loansetup."Interest rate") + '"'
                            + '"Installment":"' + FORMAT(Loansetup."No of Installment") + '"';
                response := loansData;
            END;
        END;
    end;

    procedure FnGetMonthlyDeduction(MemberNo: Code[20]) Amount: Decimal
    begin
        Amount := 0;
        objMember.RESET();
        objMember.SETRANGE(objMember."No.", MemberNo);
        IF objMember.FIND('-') THEN BEGIN
            Amount += objMember."Monthly Contribution";

            objLoanRegister.RESET();
            objLoanRegister.SETRANGE("Client Code", objMember."No.");
            objLoanRegister.SETFILTER("Outstanding Balance", '>%1', 0);
            IF objLoanRegister.FINDSET() THEN BEGIN
                REPEAT
                    Amount += objLoanRegister.Repayment;
                UNTIL objLoanRegister.NEXT = 0;
            END;
            EXIT(Amount);
        END;
    end;

    procedure GetLastContribution(MemberNo: Code[20]) Amount: Decimal
    var
        CustomerLedgerEntry: Record 21;
    begin
        Amount := 0;
        CustomerLedgerEntry.Reset();
        CustomerLedgerEntry.SetRange("Customer No.", MemberNo);
        CustomerLedgerEntry.SetFilter(CustomerLedgerEntry.Description, '<>%1', 'Opening Balance');
        CustomerLedgerEntry.SetFilter(CustomerLedgerEntry.Description, '<>%1', 'INTEREST TO LOAN');
        CustomerLedgerEntry.SetCurrentKey(CustomerLedgerEntry."Posting Date");
        //  CustomerLedgerEntry.SetAscending("Posting Date", false);
        CustomerLedgerEntry.SetFilter(CustomerLedgerEntry."Credit Amount", '>%1', 0);
        if (CustomerLedgerEntry.FindLast) then begin
            CustomerLedgerEntry.CalcFields(CustomerLedgerEntry."Credit Amount");
            Amount := CustomerLedgerEntry."Credit Amount";
        end;

    end;

    procedure GetMonthlyContribution(MemberNo: Code[20]) Amount: Decimal
    var
        CustomerLedgerEntry: Record 21;
    begin
        Amount := 0;
        objMember.Reset();
        objMember.SetRange("No.", MemberNo);
        if (objMember.find('-')) then begin//si calcfield
            //objMember.CalcFields(objMember."Monthly Contribution");
            Amount := objMember."Monthly Contribution";
        end;
        // Amount := 0;


    end;

    procedure fnLoanGuranteed(MemberNo: Code[50]; "filter": Text; BigText: BigText) exitString: Text
    var
        Filename: Text[100];
        Outputstream: OutStream;
        RecRef: RecordRef;
        TempBlob: Codeunit "Temp Blob";
        Outstr: OutStream;
        Instr: InStream;
        Base64Convert: Codeunit "Base64 Convert";
    begin

        objMember.Reset;
        objMember.SetRange(objMember."No.", MemberNo);
        if objMember.Find('-') then begin
            RecRef.GetTable(objMember);
            Clear(TempBlob);
            TempBlob.CreateOutStream(Outstr);
            TempBlob.CreateInStream(Instr);
            if Report.SaveAs(Report::"Loans Guaranteed", '', ReportFormat::Pdf, Outstr, RecRef) then begin
                exitString := Base64Convert.ToBase64(Instr);
                exit;
            end;
        end;
    end;


    procedure fnLoanRepaymentShedule("Loan No": Code[50]; path: Text[100])
    var
        "Member No": Code[100];
        filename: Text[250];
    begin
        filename := FILESPATH + path;
        objLoanRegister.Reset;
        objLoanRegister.SetRange(objLoanRegister."Loan  No.", "Loan No");

        if objLoanRegister.Find('-') then begin

        end;
    end;


    procedure fnMemberDepositStatement(MemberNo: Code[50]; "filter": Text) exitString: Text
    var
        Filename: Text[100];
        Outputstream: OutStream;
        RecRef: RecordRef;
        TempBlob: Codeunit "Temp Blob";
        Outstr: OutStream;
        Instr: InStream;
        Base64Convert: Codeunit "Base64 Convert";
    begin

        objMember.Reset;
        objMember.SetRange(objMember."No.", MemberNo);
        if objMember.Find('-') then begin
            RecRef.GetTable(objMember);
            Clear(TempBlob);
            TempBlob.CreateOutStream(Outstr);
            TempBlob.CreateInStream(Instr);
            if Report.SaveAs(Report::"Members Deposits Statement", '', ReportFormat::Pdf, Outstr, RecRef) then begin
                exitString := Base64Convert.ToBase64(Instr);
                exit;
            end;
        end;
    end;


    procedure fnLoanGurantorsReport(MemberNo: Code[50]; "filter": Text; BigText: BigText) exitString: Text
    var
        Filename: Text[100];
        Outputstream: OutStream;
        RecRef: RecordRef;
        TempBlob: Codeunit "Temp Blob";
        Outstr: OutStream;
        Instr: InStream;
        Base64Convert: Codeunit "Base64 Convert";
    begin


        objMember.Reset;
        objMember.SetRange(objMember."No.", MemberNo);
        if objMember.Find('-') then begin
            RecRef.GetTable(objMember);
            Clear(TempBlob);
            TempBlob.CreateOutStream(Outstr);
            TempBlob.CreateInStream(Instr);
            if Report.SaveAs(Report::"Loans Guaranteed", '', ReportFormat::Pdf, Outstr, RecRef) then begin
                exitString := Base64Convert.ToBase64(Instr);
                exit;
            end;
        end;
    end;



    procedure fnChangePassword(memberNumber: Code[100]; currentPass: Text; newPass: Text) updated: Boolean
    var
        InStream: InStream;
        PasswordText: Text;
        OutStream: OutStream;
        DecryptPassword: Text;
    begin
        sms := 'You have successfully updated your password. Your new password is: ' + newPass;
        Online.Reset;
        Online.SetRange("User Name", memberNumber);
        Online.SetRange(Password, currentPass);
        if Online.Find('-') then begin
            Online.Password := newPass;
            Online.Modify;
            updated := true;
        end
        else begin
            Error('Previous password is not correct');
        end;
    end;


    procedure fnTotalRepaidGraph(Mno: Code[10]; year: Code[10]) total: Decimal
    begin
        objMember.Reset;
        objMember.SetRange("No.", Mno);
        if objMember.Find('-') then begin

            objMember.SetFilter("Date Filter", '0101' + year + '..1231' + year);
            //objMember.CALCFIELDS("Current Shares");
            total := objMember."Total Repayments";
            Message('current repaid is %1', total);
        end;
    end;


    procedure fnCurrentShareGraph(Mno: Code[10]; year: Code[10]) total: Decimal
    begin
        objMember.Reset;
        objMember.SetRange("No.", Mno);
        if objMember.Find('-') then begin

            objMember.SetFilter("Date Filter", '0101' + year + '..1231' + year);
            objMember.CalcFields("Current Shares");
            total := objMember."Current Shares";
            Message('current shares is %1', total);
        end;
    end;


    procedure fnTotalDepositsGraph(Mno: Code[10]; year: Code[10]) total: Decimal
    begin
        objMember.Reset;
        objMember.SetRange("No.", Mno);
        if objMember.Find('-') then begin

            objMember.SetFilter("Date Filter", '0101' + year + '..1231' + year);
            objMember.CalcFields("Shares Retained");
            total := objMember."Shares Retained";
            Message('current deposits is %1', total);
        end;
    end;


    procedure FnRegisterKin("Full Names": Text; Relationship: Text; "ID Number": Code[10]; "Phone Contact": Code[10]; Address: Text; Idnomemberapp: Code[10])
    begin
        begin
            objRegMember.Reset;
            objNextKin.Reset;
            objNextKin.Init();
            objRegMember.SetRange("ID No.", Idnomemberapp);
            if objRegMember.Find('-') then begin
                objNextKin."Account No" := objRegMember."No.";
                objNextKin.Name := "Full Names";
                objNextKin.Relationship := Relationship;
                objNextKin."Id No." := "ID Number";
                objNextKin.Telephone := "Phone Contact";
                objNextKin.Insert(true);
            end;
        end;
    end;


    procedure FnMemberApply("First Name": Code[30]; "Mid Name": Code[30]; "Last Name": Code[30]; "PO Box": Text; Residence: Code[30]; "Postal Code": Text; Town: Code[30]; "Phone Number": Code[30]; Email: Text; "ID Number": Code[30]; "Branch Code": Code[30]; "Branch Name": Code[30]; "Account Number": Code[30]; Gender: Option; "Marital Status": Option; "Account Category": Option; "Application Category": Option; "Customer Group": Code[30]; "Employer Name": Code[30]; "Date of Birth": Date) num: Text
    begin
        begin

            objRegMember.Reset;
            objRegMember.SetRange("ID No.", "ID Number");
            if objRegMember.Find('-') then begin
                Message('already registered');
            end
            else begin
                objRegMember.Init;
                objRegMember.Name := "First Name" + ' ' + "Mid Name" + ' ' + "Last Name";
                objRegMember.Address := "PO Box";
                objRegMember."Address 2" := Residence;
                objRegMember."Postal Code" := "Postal Code";
                objRegMember.Town := Town;
                objRegMember."Phone No." := "Phone Number";
                objRegMember."E-Mail (Personal)" := Email;
                objRegMember."Date of Birth" := "Date of Birth";
                objRegMember."ID No." := "ID Number";
                objRegMember."Bank Code" := "Branch Code";
                objRegMember."Bank Name" := "Branch Name";
                objRegMember."Bank Account No" := "Account Number";
                objRegMember.Gender := Gender;
                objRegMember."Created By" := UserId;
                objRegMember."Global Dimension 1 Code" := 'BOSA';
                objRegMember."Date of Registration" := Today;
                objRegMember.Status := objRegMember.Status::Open;
                objRegMember."Application Category" := "Application Category";
                objRegMember."Account Category" := "Account Category";
                objRegMember."Marital Status" := "Marital Status";
                objRegMember."Employer Name" := "Employer Name";
                objRegMember."Customer Posting Group" := "Customer Group";
                objRegMember.Insert(true);
            end;
        end;
    end;

    local procedure FnFreeShares("Member No": Text) Shares: Text
    begin
        begin
            begin
                GenSetup.Get();
                FreeShares := 0;
                glamount := 0;

                objMember.Reset;
                objMember.SetRange(objMember."No.", "Member No");
                if objMember.Find('-') then begin
                    objMember.CalcFields("Current Shares");
                    LoansGuaranteeDetails.Reset;
                    LoansGuaranteeDetails.SetRange(LoansGuaranteeDetails."Member No", objMember."No.");
                    LoansGuaranteeDetails.SetRange(LoansGuaranteeDetails.Substituted, false);
                    if LoansGuaranteeDetails.Find('-') then begin
                        repeat
                            glamount := glamount + LoansGuaranteeDetails."Amont Guaranteed";
                        //MESSAGE('Member No %1 Account no %2',Members."No.",glamount);
                        until LoansGuaranteeDetails.Next = 0;
                    end;
                    FreeShares := (objMember."Current Shares" * GenSetup."Contactual Shares (%)") - glamount;
                    Shares := Format(FreeShares, 0, '<Precision,2:2><Integer><Decimals>');
                end;
            end;
        end;
    end;


    procedure FnStandingOrders(BosaAcNo: Code[30]; SourceAcc: Code[50]; frequency: Text; Duration: Text; DestAccNo: Code[30]; StartDate: Date; Amount: Decimal; DestAccType: Option)
    begin
        objStandingOrders.Init();
        objStandingOrders."BOSA Account No." := BosaAcNo;
        objStandingOrders."Source Account No." := SourceAcc;
        objStandingOrders.Validate(objStandingOrders."Source Account No.");
        if Format(freq) = '' then
            Evaluate(freq, frequency);
        objStandingOrders.Frequency := freq;
        if Format(dur) = '' then
            Evaluate(dur, Duration);
        objStandingOrders.Duration := dur;
        objStandingOrders."Destination Account No." := DestAccNo;
        objStandingOrders.Validate(objStandingOrders."Destination Account No.");
        objStandingOrders."Destination Account Type" := DestAccType;
        objStandingOrders.Amount := Amount;
        objStandingOrders."Effective/Start Date" := StartDate;
        objStandingOrders.Validate(objStandingOrders.Duration);
        objStandingOrders.Status := objStandingOrders.Status::Open;
        objStandingOrders.Insert(true);
        objMember.Reset;
        objMember.SetRange(objMember."No.", BosaAcNo);
        if objMember.Find('-') then begin
            phoneNumber := objMember."Phone No.";
            sms := 'You have created a standing order of amount : ' + Format(Amount) + ' from Account ' + SourceAcc + ' start date: '
                  + Format(StartDate) + '. Thanks for using POLYTECh SACCO Portal.';
            FnSMSMessage(SourceAcc, phoneNumber, sms);
            //MESSAGE('All Cool');
        end
    end;

    procedure fnAccountInfo2(Memberno: Code[20]) info: Text
    begin
        objMember.RESET;
        objMember.SETRANGE(objMember."No.", Memberno);

        IF objMember.FIND('-') THEN BEGIN

            // FOSAbal:=FNFosaBalance(objMember."FOSA Account No.");
            objMember.CALCFIELDS(objMember."Shares Retained");// "Total Committed Shares");
            objMember.CALCFIELDS(objMember."Current Shares");
            //objMember.CALCFIELDS("Demand Savings");
            objMember.CALCFIELDS(objMember."Shares Retained");
            info := FORMAT(objMember."Current Shares") + ':' + FORMAT(objMember."Shares Retained") + ':' + FORMAT(objMember."Risk Fund") + ':' + FORMAT(objMember."Dividend Amount") + ':' + FORMAT(objMember."FOSA Account No.")
            + ':' + FORMAT(objMember."Current Shares" - objMember."Shares Retained");
        END;
    end;

    procedure fnLoans(MemberNo: Code[20]) loans: Text
    begin
        objLoanRegister.RESET;
        objLoanRegister.SETRANGE(objLoanRegister."BOSA No", MemberNo);
        objLoanRegister.SETFILTER(objLoanRegister.Posted, '%1', TRUE);
        objLoanRegister.SETFILTER(objLoanRegister."Outstanding Balance", '>%1', 0);
        //IF (objLoanRegister."Outstanding Balance">0)OR(objLoanRegister."Oustanding Interest">0) THEN BEGIN
        IF objLoanRegister.FIND('-') THEN BEGIN
            // objLoanRegister.SETCURRENTKEY("Application Date");
            objLoanRegister.ASCENDING(TRUE);

            REPEAT
                objLoanRegister.CALCFIELDS("Total Loans Outstanding", objLoanRegister."Outstanding Balance");
                loans := loans + objLoanRegister."Loan Product Type" + ':' + FORMAT(objLoanRegister."Outstanding Balance") + ':' + FORMAT(objLoanRegister."Loans Category-SASRA") + ':' + FORMAT(objLoanRegister.Installments) + ':'
                + FORMAT(objLoanRegister.Installments - Loanperiod) + ':' + FORMAT(objLoanRegister."Outstanding Balance") + ':' + FORMAT(objLoanRegister."Requested Amount") + ':' + FORMAT(objLoanRegister."Loan  No.") + ':' + FORMAT(objLoanRegister."Approval Status")
                + ':' + FORMAT(objLoanRegister."Amount Disbursed") + ':' + FORMAT(objLoanRegister."Approved Amount") + '::'

            UNTIL
            objLoanRegister.NEXT = 0;
            // END;
        END;
    end;

    procedure fnLoanBalancesJson(MemberNo: Code[20]) loans: Text
    var
        balancesText: Text;
    begin
        balancesText := '';
        objLoanRegister.RESET;
        objLoanRegister.SETRANGE(objLoanRegister."BOSA No", MemberNo);
        objLoanRegister.SETFILTER(objLoanRegister.Posted, '%1', TRUE);
        objLoanRegister.SETFILTER(objLoanRegister."Outstanding Balance", '>%1', 0);
        //IF (objLoanRegister."Outstanding Balance">0)OR(objLoanRegister."Oustanding Interest">0) THEN BEGIN
        IF objLoanRegister.FIND('-') THEN BEGIN
            // objLoanRegister.SETCURRENTKEY("Application Date");
            objLoanRegister.ASCENDING(TRUE);

            REPEAT
                objLoanRegister.CALCFIELDS("Total Loans Outstanding", objLoanRegister."Outstanding Balance");
                if balancesText = '' then begin
                    balancesText := '"LoanNo":"' + FORMAT(objLoanRegister."Loan  No.") + '"'
                    + '"LoanProductType":"' + objLoanRegister."Loan Product Type" + '"'
                    + '"Installments":"' + FORMAT(objLoanRegister.Installments) + '"'
                    + '"RemainingPeriod":"' + FORMAT(objLoanRegister.Installments - Loanperiod) + '"'
                    + '"RequestedAmount":"' + FORMAT(objLoanRegister."Requested Amount") + '"'
                    + '"ApprovalStatus":"' + FORMAT(objLoanRegister."Approval Status") + '"';
                end else begin
                    balancesText := balancesText + '"LoanNo":"' + FORMAT(objLoanRegister."Loan  No.") + '"'
                + '"LoanProductType":"' + objLoanRegister."Loan Product Type" + '"'
                + '"Installments":"' + FORMAT(objLoanRegister.Installments) + '"'
                + '"RemainingPeriod":"' + FORMAT(objLoanRegister.Installments - Loanperiod) + '"'
                + '"RequestedAmount":"' + FORMAT(objLoanRegister."Requested Amount") + '"'
                + '"ApprovalStatus":"' + FORMAT(objLoanRegister."Approval Status") + '"';
                end;
            // loans := loans + objLoanRegister."Loan Product Type" + ':' + FORMAT(objLoanRegister."Outstanding Balance") + ':' + FORMAT(objLoanRegister."Loans Category-SASRA") + ':' + FORMAT(objLoanRegister.Installments) + ':'
            // + FORMAT(objLoanRegister.Installments - Loanperiod) + ':' + FORMAT(objLoanRegister."Outstanding Balance") + ':' + FORMAT(objLoanRegister."Requested Amount") + ':' + FORMAT(objLoanRegister."Loan  No.") + ':' + FORMAT(objLoanRegister."Approval Status")
            // + ':' + FORMAT(objLoanRegister."Amount Disbursed") + ':' + FORMAT(objLoanRegister."Approved Amount") + '::'

            UNTIL
            objLoanRegister.NEXT = 0;
            loans := balancesText;
        END;
    end;

    procedure FnGetMemberProfile(MemberNo: Code[30]) info: Text
    begin
        objMember.RESET;
        objMember.SETRANGE(objMember."No.", MemberNo);
        IF objMember.FIND('-') THEN BEGIN
            info := objMember."No." + ':' + objMember.Name + ':' + objMember."E-Mail" + ':' + FORMAT(objMember.Status) + ':' + objMember."Mobile Phone No"
             + ':' + objMember."ID No." + ':' + FORMAT(objMember."Date of Birth") + ':' + FORMAT(objMember."Payroll/Staff No") + ':' + FORMAT(objMember.Gender) + ':' + FORMAT(objMember.Pin) + ':'
             + FORMAT(objMember."Country/Region Code") + ':' + FORMAT(objMember.City) + ':' + FORMAT(objMember."Registration Date") + ':' + FORMAT(objMember."Bank Code") + ':'
             + FORMAT(objMember."Bank Code") + ':' + FORMAT(objMember."Bank Branch Code") + ':' + FORMAT(objMember."Bank Branch Code") + ':' + FORMAT(objMember."Bank Account No.");
        END;
    end;

    procedure fnLoanDetails(Loancode: Code[20]) loandetail: Text
    begin
        Loansetup.RESET;
        Loansetup.SETRANGE(Code, Loancode);
        IF Loansetup.FIND('-') THEN BEGIN
            REPEAT
                loandetail := loandetail + Loansetup."Product Description" + '!!' + FORMAT(Loansetup."Repayment Method") + '!!' + FORMAT(Loansetup."Max. Loan Amount") + '!!' + FORMAT(Loansetup."Instalment Period") + '!!' + FORMAT(Loansetup."Interest rate") + '!!'
                + FORMAT(Loansetup."Repayment Frequency") + '??';
            UNTIL Loansetup.NEXT = 0;
        END;
    end;

    procedure fnOnlineLoans(MemberNo: Code[20]) loans: Text
    begin
        //  onlineloans.RESET;
        //  onlineloans."Member No":=MemberNo;
        //  onlineloans.VALIDATE(onlineloans."Member No");
        //  
        // onlineloans.RESET;
        // onlineloans.SETRANGE(onlineloans."Member No", MemberNo);
        // IF onlineloans.FIND('-') THEN BEGIN
        //     onlineloans.ASCENDING(TRUE);
        //     REPEAT
        //         loans := loans + onlineloans."Loan Product Type" + ':' + FORMAT(onlineloans.Installments) + ':' + FORMAT(onlineloans."Principle Repayment") + ':' + FORMAT(onlineloans."Interest Repayment") + ':'
        //         + FORMAT(onlineloans."Total Monthly Repayment") + ':' + FORMAT(onlineloans."Product Description") + ':' + FORMAT(onlineloans."Interest rate") + ':' + FORMAT(onlineloans."Repayment Method") + ':' + FORMAT(onlineloans."Requested Amount")
        //         + ':'//+FORMAT(onlineloans."Document No")+'::'

        //     UNTIL
        //     onlineloans.NEXT = 0;
        // END;
    end;

    procedure FnGetNOKProfile(MemberNo: Code[20]) info: Text
    var
        accountsList: Text;
    begin
        accountsList := '';
        objMember.RESET;
        objMember.SETRANGE(objMember."No.", MemberNo);
        IF objMember.FIND('-') THEN BEGIN
            objNextKin.RESET();
            objNextKin.SETRANGE("Account No", objMember."No.");
            IF objNextKin.FIND('-') THEN BEGIN
                REPEAT
                    // info := info + FORMAT(objNextKin.Name) + ':' + FORMAT(objNextKin."Date of Birth") + ':' + FORMAT(objNextKin."%Allocation") + ':' + FORMAT(objNextKin.Relationship) + '::';
                    info := '';
                    IF accountsList = '' THEN BEGIN
                        accountsList := '{ "KinName":"' + FORMAT(objNextKin.Name) + '","DateofBirth":"' + FORMAT(objNextKin."Date of Birth") + '","Allocation":"' + FORMAT(objNextKin."%Allocation") + '","Relationship":"' + FORMAT(objNextKin.Relationship) + '" }';
                    END ELSE BEGIN
                        accountsList += ',{ "KinName":"' + FORMAT(objNextKin.Name) + '","DateofBirth":"' + FORMAT(objNextKin."Date of Birth") + '","Allocation":"' + FORMAT(objNextKin."%Allocation") + '","Relationship":"' + FORMAT(objNextKin.Relationship) + '" }';
                    END;
                UNTIL objNextKin.NEXT() = 0;
            END;
            info := accountsList;
        END;
    end;

    procedure FnUpdateMonthlyContrib("Member No": Code[30]; "Updated Fig": Decimal)
    begin
        objMember.Reset;
        objMember.SetRange(objMember."No.", "Member No");

        if objMember.Find('-') then begin
            phoneNumber := objMember."Phone No.";
            FAccNo := objMember."FOSA Account No.";
            objMember."Monthly Contribution" := "Updated Fig";
            objMember.Modify;
            sms := 'You have adjusted your monthly contributions to: ' + Format("Updated Fig") + ' account number ' + FAccNo +
                  '. Thank you for using SURESTEP Sacco Portal';
            FnSMSMessage(FAccNo, phoneNumber, sms);

            //MESSAGE('Updated');
        end
    end;


    procedure FnSMSMessage(accfrom: Text[30]; phone: Text[20]; message: Text[250])
    begin

        SMSMessages.Reset;
        if SMSMessages.Find('+') then begin
            iEntryNo := SMSMessages."Entry No";
            iEntryNo := iEntryNo + 1;
        end
        else begin
            iEntryNo := 1;
        end;
        SMSMessages.Init;
        SMSMessages."Entry No" := iEntryNo;
        //SMSMessages."Batch No":=documentNo;
        //SMSMessages."Document No":=documentNo;
        SMSMessages."Account No" := accfrom;
        SMSMessages."Date Entered" := Today;
        SMSMessages."Time Entered" := Time;
        SMSMessages.Source := 'WEBPORTAL';
        SMSMessages."Entered By" := UserId;
        SMSMessages."Sent To Server" := SMSMessages."sent to server"::No;// PENDING;
        SMSMessages."SMS Message" := message;
        SMSMessages."Telephone No" := phone;
        if SMSMessages."Telephone No" <> '' then
            SMSMessages.Insert;
    end;


    procedure FnLoanApplication(Member: Code[30]; LoanProductType: Code[10]; AmountApplied: Decimal; LoanPurpose: Code[30]; RepaymentFrequency: Integer) Result: Boolean
    begin
        objMember.Reset;
        objMember.SetRange(objMember."No.", Member);
        if objMember.Find('-') then begin
            Loansetup.Reset;
            if Loansetup.Get(LoanProductType) then begin
                objLoanRegister.Source := Loansetup.Source;
                // source=Loansetup.Source;
            end;

            objLoanRegister.Init;
            Message('test');
            objLoanRegister."Client Code" := Member;
            objLoanRegister."Loan Product Type" := LoanProductType;
            // objLoanRegister.VALIDATE("Loan Product Type");
            objLoanRegister.Installments := RepaymentFrequency;
            // objLoanRegister.VALIDATE(Installments);
            objLoanRegister."Requested Amount" := AmountApplied;
            // objLoanRegister.VALIDATE("Requested Amount");
            objLoanRegister."Captured By" := UserId;
            objLoanRegister."Loan Purpose" := LoanPurpose;
            objLoanRegister."Loan Status" := objLoanRegister."loan status"::Application;
            Message('test');
            objLoanRegister.Insert;
            Message('test');
            Result := true;
            phoneNumber := objMember."Mobile Phone No";
            ClientName := objMember."FOSA Account No.";
            sms := 'We have received your ' + LoanProductType + ' loan application of  amount : ' + Format(AmountApplied) +
            '. We are processing your loan, you will hear from us soon. Thanks for using POLYTECh SACCO  Portal.';
            FnSMSMessage(ClientName, phoneNumber, sms);
            PortaLuPS.Init;
            // PortaLuPS.INSERT(TRUE);
            objLoanRegister.Reset;
            objLoanRegister.SetRange("Client Code", Member);
            objLoanRegister.SetCurrentkey("Application Date");
            objLoanRegister.Ascending(true);
            if objLoanRegister.FindLast
              then
                PortaLuPS.LaonNo := objLoanRegister."Loan  No.";
            PortaLuPS.RequestedAmount := AmountApplied;
            PortaLuPS.Insert;
            //MESSAGE('All Cool');
            //MESSAGE('Am just cool');
        end;
    end;


    procedure FnDepositsStatement("Account No": Code[30]; path: Text[100]) exitString: Text
    var
        Filename: Text[100];
        Outputstream: OutStream;
        RecRef: RecordRef;
        TempBlob: Codeunit "Temp Blob";
        Outstr: OutStream;
        Instr: InStream;
        Base64Convert: Codeunit "Base64 Convert";
    begin
        objMember.Reset;
        objMember.SetRange(objMember."No.", "Account No");
        if objMember.Find('-') then begin
            RecRef.GetTable(objMember);
            Clear(TempBlob);
            TempBlob.CreateOutStream(Outstr);
            TempBlob.CreateInStream(Instr);
            if Report.SaveAs(Report::"Members Deposits Statement", '', ReportFormat::Pdf, Outstr, RecRef) then begin
                exitString := Base64Convert.ToBase64(Instr);
                exit;
            end;
        end;
    end;


    procedure FnLoanStatement(MemberNo: Code[50]; "filter": Text; var BigText: BigText) exitString: Text
    var
        Filename: Text[100];
        Outputstream: OutStream;
        RecRef: RecordRef;
        TempBlob: Codeunit "Temp Blob";
        Outstr: OutStream;
        Instr: InStream;
        Base64Convert: Codeunit "Base64 Convert";
    begin
        objMember.Reset;
        objMember.SetRange(objMember."No.", MemberNo);
        if objMember.Find('-') then begin
            RecRef.GetTable(objMember);
            Clear(TempBlob);
            TempBlob.CreateOutStream(Outstr);
            TempBlob.CreateInStream(Instr);
            if Report.SaveAs(Report::"Member Loans Statement", '', ReportFormat::Pdf, Outstr, RecRef) then begin
                exitString := Base64Convert.ToBase64(Instr);
                exit;
            end;
        end;
    end;


    procedure FnLoanStatementFosa(MemberNo: Code[50]; "filter": Text; BigText: BigText) exitString: Text
    var
        Filename: Text[100];
        Outputstream: OutStream;
        RecRef: RecordRef;
        TempBlob: Codeunit "Temp Blob";
        Outstr: OutStream;
        Instr: InStream;
        Base64Convert: Codeunit "Base64 Convert";
    begin
        objMember.Reset;
        objMember.SetRange(objMember."No.", MemberNo);
        if objMember.Find('-') then begin
            RecRef.GetTable(objMember);
            Clear(TempBlob);
            TempBlob.CreateOutStream(Outstr);
            TempBlob.CreateInStream(Instr);
            if Report.SaveAs(Report::"Member Loans Statement", '', ReportFormat::Pdf, Outstr, RecRef) then begin
                exitString := Base64Convert.ToBase64(Instr);
                exit;
            end;
        end;
    end;


    procedure Fnlogin(username: Code[50]; password: Text) status: Boolean
    var
        InStream: InStream;
        PasswordText: Text;
        DecrypText: Text;
        ObjLog: Record "Portal Logs";
        ObjMember: Record customer;
    begin
        Online.Reset;
        Online.SetRange("User Name", username);
        Online.SetRange(Password, password);
        if Online.Find('-') then begin
            status := true;
            ObjLog.Reset;
            ObjLog.Init;
            ObjLog."Member No" := username;
            ObjLog.Date := Today;
            ObjLog.Time := Time;
            ObjLog."Login Status" := ObjLog."login status"::Successfull;
            ObjMember.Reset;
            if ObjMember.Get(username) then begin
                ObjLog."Member Name" := ObjMember.Name;
            end;
            ObjLog.Insert;
        end else begin
            status := false;
            ObjLog.Reset;
            ObjLog.Init;
            ObjLog."Member No" := username;
            ObjLog.Date := Today;
            ObjLog.Time := Time;
            ObjLog."Login Status" := ObjLog."login status"::Failed;
            ObjMember.Reset;
            if ObjMember.Get(username) then begin
                ObjLog."Member Name" := ObjMember.Name;
            end;
            ObjLog.Insert
        end;
    end;


    procedure FnmemberInfo(MemberNo: Code[20]) info: Text
    begin
        objMember.Reset;
        objMember.SetRange(objMember."No.", MemberNo);
        if objMember.Find('-') then begin
            info := objMember."No." + '.' + ':' + objMember.Name + '.' + ':' + objMember."E-Mail" + '.' + ':' + Format(objMember.Status) + '.' + ':' + Format(objMember."Account Category") + '.' + ':' + objMember."Mobile Phone No"
            + '.' + ':' + objMember."ID No." + '.' + ':' + objMember."FOSA Account No.";
        end
        else
            objMember.Reset;
        objMember.SetRange(objMember."ID No.", MemberNo);
        if objMember.Find('-') then begin
            info := objMember."No." + '.' + ':' + objMember.Name + '.' + ':' + objMember."E-Mail" + '.' + ':' + objMember."Employer Name" + '.' + ':' + Format(objMember."Account Category") + '.' + ':' + objMember."Mobile Phone No"
            + '.' + ':' + objMember."Bank Code" + '.' + ':' + objMember."Bank Account No." + '.' + ':' + objMember."FOSA Account No.";

        end;
    end;


    procedure MemberAccountDetails(MemberNo: Code[20]) info: Text
    begin
        objMember.Reset;
        objMember.SetRange(objMember."No.", MemberNo);
        if objMember.Find('-') then begin

            info := '{ "MemberNumber":"' + objMember."No." +
                      '","MemberName":"' + objMember.Name +
                      '","EmailAddress":"' + FORMAT(objMember."E-Mail") +
                      '","AccountStatus":"' + FORMAT(objMember.Status) +
                      '","MobileNumber":"' + FORMAT(objMember."Mobile Phone No") +
                      '","IdNumber":"' + FORMAT(objMember."ID No.") +
                      '","AccountCategory":"' + FORMAT(objMember."Account Category") +
                      '","FosaAccount":"' + FORMAT(objMember."FOSA Account No.") +
                      '","DateofBirth":"' + Format(objMember."Date of Birth") +
                      '","Gender":"' + FORMAT(objMember.Gender) + '" }';
        end;
    end;

    procedure MemberAccountStatistics(MemberNo: Code[20]) info: Text
    begin
        objMember.Reset;
        objMember.SetRange(objMember."No.", MemberNo);
        if objMember.Find('-') then begin

            objMember.CalcFields("Current Shares");
            objMember.CalcFields("Shares Retained");
            objMember.CalcFields("Withdrawable Savings");

            objMember.CalcFields("Junior Savings");
            objMember.CalcFields("Outstanding Interest");
            // objMember.CalcFields("Outstanding Balance", "Outstanding Interest FOSA");


            info := '{ "MemberNumber":"' + objMember."No." +
                      '","MemberDeposits":"' + FORMAT(objMember."Current Shares") +
                      '","ShareCapital":"' + FORMAT(objMember."Shares Retained") +
                      '","M_WalletBalance":"' + FORMAT(objMember."Withdrawable Savings") +
                      '","FosaAccountBalance":"' + FORMAT(objMember."Junior Savings") +
                      '","OutstandingLoanBalance":"' + FORMAT(objMember."Outstanding Balance") +
                      '","OutstandingInterest":"' + FORMAT(objMember."Outstanding Interest") +
                      '","M_Walletccount":"' + FORMAT(objMember."FOSA Account No.") + '" }';
        end;
    end;


    procedure fnAccountInfo(Memberno: Code[20]) info: Text
    var
        FOSAbal: Text;
        AccountTypes: Record "Account Types-Saving Products";
        miniBalance: Decimal;
        accBalance: Decimal;
    begin
        objMember.Reset;
        objMember.SetRange(objMember."No.", Memberno);
        objMember.Get(objMember."FOSA Account No.");
        if objMember.Find('-') then begin
            Vendor.Reset;
            Vendor.SetRange("No.", objMember."FOSA Account No.");
            if Vendor.FindFirst then begin
                repeat
                    AccountTypes.Reset;
                    AccountTypes.SetRange(AccountTypes.Code, Vendor."Account Type");
                    if AccountTypes.Find('-') then begin
                        miniBalance := AccountTypes."Minimum Balance";
                    end;
                    Vendor.CalcFields(Vendor."Balance (LCY)");
                    Vendor.CalcFields(Vendor."ATM Transactions");
                    Vendor.CalcFields(Vendor."Uncleared Cheques");
                    Vendor.CalcFields(Vendor."EFT Transactions");
                    accBalance := accBalance + (Vendor."Balance (LCY)" - (Vendor."ATM Transactions" + Vendor."Uncleared Cheques" + Vendor."EFT Transactions" + miniBalance));

                    FOSAbal := Format(accBalance);
                    Message('bal%1', FOSAbal);
                until Vendor.Next = 0;
            end;

            // FOSAbal:=FNFosaBalance(objMember."FOSA Account No.");
            objMember.CalcFields("Current Shares");
            objMember.CalcFields("Dividend Amount");
            objMember.CalcFields("Shares Retained", "FOSA Account Bal");
            info := Format(objMember."Shares Retained") + ':' + Format(objMember."Shares Retained") + ':' + Format(objMember."Current Shares") + ':' + Format(FOSAbal)
            + ':' + Format(objMember."FOSA Account Bal", 0, '<Precision,2:2><Integer><Decimals>') + ':' + Format(objMember."Dividend Amount", 0, '<Precision,2:2><Integer><Decimals>');
        end;
    end;


    procedure fnloaninfo(Memberno: Code[20]) info: Text
    begin
        objMember.Reset;
        objMember.SetRange(objMember."No.", Memberno);
        // objMember.Get(objMember."FOSA Account No.");
        if objMember.Find('-') then begin
            // Message('fosa %1', objMember."FOSA Account No.");
            objMember.CalcFields("Outstanding Balance");
            objMember.CalcFields("Outstanding Interest");
            // objMember.CalcFields("Outstanding Loan FOSA", "Outstanding Interest FOSA");
            info := Format(objMember."Outstanding Balance") + ':' + Format(objMember."Outstanding Interest");// + ':' + Format(200) + ':' + Format(objMember."FOSA Oustanding Interest")
        end;
    end;


    procedure fnLoans2(MemberNo: Code[20]) loans: Text
    begin
        objLoanRegister.Reset;
        objLoanRegister.SetRange("Client Code", MemberNo);
        //objLoanRegister.SETFILTER("Loan Product Type Name",'');
        objLoanRegister.SetCurrentkey("Outstanding Balance");
        objLoanRegister.Ascending(false);
        if objLoanRegister.Find('-') then begin
            repeat

                LastPayDate := objLoanRegister."Issued Date";
                Rschedule.Reset;
                Rschedule.SetRange("Loan No.", objLoanRegister."Loan  No.");
                Rschedule.SetFilter(Rschedule."Repayment Date", '.. %1', Today);
                if Rschedule.FindFirst then begin
                    Lperiod := Rschedule.Count;
                    i := objLoanRegister.Installments - Lperiod;
                end;
                objLoanRegister.CalcFields("Outstanding Balance");
                if objLoanRegister."Outstanding Balance" > 0 then
                    loans := loans + objLoanRegister."Loan Product Type Name" + ':' + Format(objLoanRegister."Outstanding Balance") + ':' + Format(objLoanRegister."Loan Status") + ':' + Format(objLoanRegister.Installments) + ':'
                    + Format(i) + ':' + Format(objLoanRegister."Outstanding Balance") + ':' + Format(objLoanRegister."Requested Amount") + '::';

            until
              objLoanRegister.Next = 0;

        end;
    end;


    procedure FnloanCalc(LoanAmount: Decimal; RepayPeriod: Integer; LoanCode: Code[30]) text: Text
    begin
        //....................................................................................................................
        Loansetup.Reset;
        Loansetup.SetRange(Code, LoanCode);

        if Loansetup.Find('-') then begin
            if Loansetup."Repayment Method" = Loansetup."repayment method"::Amortised then begin
                Date := Today;
                InstallmentCounts := 0;
                LBalance := LoanAmount;
                repeat
                    TotalMRepay := ROUND((Loansetup."Interest rate" / 12 / 100) / (1 - Power((1 + (Loansetup."Interest rate" / 12 / 100)), -(RepayPeriod))) * (LoanAmount), 0.05, '>');
                    LInterest := ROUND(LBalance / 100 / 12 * InterestRate, 0.05, '>');//Interest repayment
                    LPrincipal := TotalMRepay - LInterest;//principal repayment
                    InstallmentCounts := InstallmentCounts + 1;
                    if InstallmentCounts = 1 then begin
                        LBalance := LoanAmount;
                    end else begin
                        LBalance := LBalance - LPrincipal;
                    end;
                    Date := CalcDate('+1M', Date);
                    text := text + Format(Date) + '!!' + Format(ROUND(LPrincipal)) + '!!' + Format(ROUND(LInterest)) + '!!' + Format(ROUND(TotalMRepay)) + '!!' + Format(ROUND(LoanAmount)) + '!!' + Format(ROUND(LBalance)) + '??';
                until InstallmentCounts = RepayPeriod;
            end;
            //........................................................................................................
            if Loansetup."Repayment Method" = Loansetup."repayment method"::"Straight Line" then begin
                Date := Today;
                InstallmentCounts := 0;
                LBalance := LoanAmount;
                repeat
                    LPrincipal := ROUND(LoanAmount / RepayPeriod, 0.05, '>');
                    LInterest := ROUND((Loansetup."Interest rate" / 12 / 100) * LoanAmount, 0.05, '>');
                    TotalMRepay := LPrincipal + LInterest;
                    InstallmentCounts := InstallmentCounts + 1;
                    if InstallmentCounts = 1 then begin
                        LBalance := LoanAmount;
                    end else begin
                        LBalance := LBalance - LPrincipal;
                    end;
                    Date := CalcDate('+1M', Date);
                    text := text + Format(Date) + '!!' + Format(ROUND(LPrincipal)) + '!!' + Format(ROUND(LInterest)) + '!!' + Format(ROUND(TotalMRepay)) + '!!' + Format(ROUND(LoanAmount)) + '!!' + Format(ROUND(LBalance)) + '??';
                until InstallmentCounts = RepayPeriod;
            end;
            //-----------------------------------------------------------------------------------------------------------
            if Loansetup."Repayment Method" = Loansetup."repayment method"::"Reducing Balance" then begin
                Date := Today;
                InstallmentCounts := 0;
                LBalance := LoanAmount;
                repeat
                    LPrincipal := ROUND(LoanAmount / RepayPeriod, 0.05, '>');
                    LInterest := ROUND((Loansetup."Interest rate" / 12 / 100) * LoanAmount, 0.05, '>');
                    TotalMRepay := LPrincipal + LInterest;
                    InstallmentCounts := InstallmentCounts + 1;
                    if InstallmentCounts = 1 then begin
                        LBalance := LoanAmount;
                    end else begin
                        LBalance := LBalance - LPrincipal;
                    end;
                    Date := CalcDate('+1M', Date);
                    text := text + Format(Date) + '!!' + Format(ROUND(LPrincipal)) + '!!' + Format(ROUND(LInterest)) + '!!' + Format(ROUND(TotalMRepay)) + '!!' + Format(ROUND(LoanAmount)) + '!!' + Format(ROUND(LBalance)) + '??';
                until InstallmentCounts = RepayPeriod;
            end;

            //---------------------------------------------------------------------------------------------------------
            if Loansetup."Repayment Method" = Loansetup."repayment method"::Constants then begin
                Date := Today;
                InstallmentCounts := 0;
                LBalance := LoanAmount;
                repeat
                    LPrincipal := ROUND(LoanAmount / RepayPeriod, 0.05, '>');
                    LInterest := ROUND((Loansetup."Interest rate" / 12 / 100) * LoanAmount, 0.05, '>');
                    TotalMRepay := LPrincipal + LInterest;
                    InstallmentCounts := InstallmentCounts + 1;
                    if InstallmentCounts = 1 then begin
                        LBalance := LoanAmount;
                    end else begin
                        LBalance := LBalance - LPrincipal;
                    end;
                    Date := CalcDate('+1M', Date);
                    text := text + Format(Date) + '!!' + Format(ROUND(LPrincipal)) + '!!' + Format(ROUND(LInterest)) + '!!' + Format(ROUND(TotalMRepay)) + '!!' + Format(ROUND(LoanAmount)) + '!!' + Format(ROUND(LBalance)) + '??';
                until InstallmentCounts = RepayPeriod;
            end;
        end;
    end;


    procedure FnloansProducts() loanType: Text
    begin
        Loansetup.Reset;
        //Loansetup.SETRANGE(Source, Loansetup.Source::FOSA);
        Loansetup.SetRange(Loansetup."Show On Portal", true);
        if Loansetup.Find('-') then begin
            //loanType:='';
            repeat
                loanType := Format(Loansetup.Code) + ':' + Loansetup."Product Description" + ':::' + loanType;
            //   loanType:=loanType+Loansetup."Product Description"+'!!'+ FORMAT(Loansetup."Repayment Method")+'!!'+FORMAT(Loansetup."Max. Loan Amount")+'!!'+FORMAT(Loansetup."Instalment Period")+'!!'+FORMAT(Loansetup."Interest rate")+'!!'
            //  +FORMAT(Loansetup."Repayment Frequency")+'??';
            until Loansetup.Next = 0;
        end;
    end;


    procedure Fnloanssetup() loanType: Text
    begin
        Loansetup.Reset;
        Loansetup.SETRANGE(Source, Loansetup.Source::BOSA);
        // Loansetup.SetRange(Loansetup."Show On Portal", true);
        if Loansetup.Find('-') then begin
            //loanType:='';
            repeat
                loanType := Format(Loansetup.Code) + ':' + Loansetup."Product Description" + ':::' + loanType;
            //   loanType:=loanType+Loansetup."Product Description"+'!!'+ FORMAT(Loansetup."Repayment Method")+'!!'+FORMAT(Loansetup."Max. Loan Amount")+'!!'+FORMAT(Loansetup."Instalment Period")+'!!'+FORMAT(Loansetup."Interest rate")+'!!'
            //  +FORMAT(Loansetup."Repayment Frequency")+'??';
            until Loansetup.Next = 0;
        end;
    end;


    procedure fnLoanDetails2(Loancode: Code[20]) loandetail: Text
    begin
        Loansetup.Reset;
        Loansetup.SETRANGE(Source, Loansetup.Source::BOSA);
        if Loansetup.Find('-') then begin
            repeat
                loandetail := loandetail + Loansetup."Product Description" + '!!' + Format(Loansetup."Repayment Method") + '!!' + Format(Loansetup."Max. Loan Amount") + '!!' + Format(Loansetup."Instalment Period") + '!!' + Format(Loansetup."Interest rate") + '!!'
                + Format(Loansetup."Repayment Frequency") + '??';
            until Loansetup.Next = 0;
        end;
    end;


    procedure fnFeedback(No: Code[20]; Subject: Text; Comment: Text[200]; Inquiry: Option)
    begin
        /*
         objMember.RESET;
         objMember.SETRANGE("No.", No);
         IF objMember.FIND('-') THEN BEGIN
          IF feedback.FIND('+') THEN
          feedback.Entry:=feedback.Entry+1
          ELSE
          feedback.Entry:=1;
          feedback.INIT;
          feedback.No:=No;
          feedback.Portalfeedback:=Comment;
          feedback.Inquiry:=Inquiry;
          feedback.DatePosted:=TODAY;
          feedback.INSERT(TRUE)
        
        
         END
         ELSE
         EXIT;
         */

    end;


    procedure fnLoansPurposes() LoanType: Text
    begin
        LoansPurpose.Reset;
        begin
            LoanType := '';
            repeat
                LoanType := Format(LoansPurpose.Code) + ':' + LoansPurpose.Description + ':::' + LoanType;
            until LoansPurpose.Next = 0;
        end;
    end;


    procedure fnReplys(No: Code[20]) text: Text
    begin
        feedback.Reset;
        feedback.SetRange(No, No);
        feedback.SetCurrentkey(Entry);
        feedback.Ascending(false);
        if feedback.Find('-') then begin
            repeat
                if (feedback.Reply = '') then begin

                end else
                    text := text + Format(feedback.DatePosted) + '!!' + feedback.Portalfeedback + '!!' + feedback.Reply + '??';
            until feedback.Next = 0;
        end;
    end;


    procedure FnNotifications("Member No": Code[10]; path: Text) text: Text
    var
        Filename: Text[100];
    begin
    end;


    procedure fnGuarantorsPortal(Member: Code[40]; Number: Code[40]; LoanNo: Code[40]; Message: Text[100])
    begin
        objMember.Reset;
        objMember.SetRange("No.", Member);
        if objMember.Find('-') then begin
            if feedback.Find('+') then
                feedback.Entry := feedback.Entry + 1
            else
                feedback.Entry := 1;
            feedback.No := Member;
            feedback.LoanNo := LoanNo;
            // feedback.Portalfeedback:=Message;
            feedback.DatePosted := Today;
            feedback.Guarantor := Number;

            //feedback.LoanNo:=objLoanRegister."Loan  No.";
            feedback.Accepted := 0;
            feedback.Rejected := 0;
            feedback.Insert(true)


        end
        else
            exit;
    end;


    procedure FnApproveGurarantors(Approval: Integer; Number: Code[40]; LoanNo: Integer; reply: Text; Amount: Decimal)
    begin
        feedback.Init;
        if (Approval = 0) then begin
            feedback.SetRange(Entry, LoanNo);
            feedback.SetRange(Guarantor, Number);
            if feedback.Find('-') then begin


                feedback.Accepted := 0;
                feedback.Rejected := 1;
                feedback.Modify;
            end;
        end

        else
            if Approval = 1 then begin
                feedback.Reset;

                feedback.SetRange(Entry, LoanNo);
                feedback.SetRange(Guarantor, Number);
                if feedback.Find('-') then begin


                    feedback.Accepted := 1;
                    feedback.Rejected := 0;
                    feedback.Amount := Amount;
                    objMember.SetRange("No.", Number);
                    if objMember.Find('-') then
                        reply := objMember.Name + ' ' + 'Has accepted to quarantee your loan';

                    objLoanRegister.Reset;
                    objLoanRegister.SetRange("Loan  No.", feedback.LoanNo);
                    Message(feedback.LoanNo);
                    if objLoanRegister.Find('-') then
                        reply := reply + 'of amount ' + Format(objLoanRegister."Requested Amount");
                    LoansGuaranteeDetails.Init;
                    LoansGuaranteeDetails.CalcFields("Loanees  No");

                    LoansGuaranteeDetails."Member No" := Number;
                    LoansGuaranteeDetails.Validate("Member No");
                    LoansGuaranteeDetails.Validate("Substituted Guarantor");
                    LoansGuaranteeDetails."Loan No" := feedback.LoanNo;
                    LoansGuaranteeDetails.Validate("Loan No");
                    LoansGuaranteeDetails."Amont Guaranteed" := Amount;
                    LoansGuaranteeDetails.Validate("Amont Guaranteed");
                    PortaLuPS.SetRange(LaonNo, feedback.LoanNo);
                    if PortaLuPS.Find('-') then begin
                        // PortaLuPS.INIT;
                        PortaLuPS.TotalGuaranteed := PortaLuPS.TotalGuaranteed + Amount;
                        PortaLuPS.Modify;

                        //LoansGuaranteeDetails.VALIDATE("Amont Guaranteed");
                        //LoansGuaranteeDetails."Loanees  No":=feedback.No;

                        //LoansGuaranteeDetails.VALIDATE("Loanees  No");
                        feedback.Reply := reply;
                        feedback.Modify;
                        LoansGuaranteeDetails.Insert;
                    end;
                end;
            end;
    end;


    procedure FNAppraisalLoans(Member: Code[10]) loans: Text
    begin
        objLoanRegister.Reset;
        objLoanRegister.SetRange("Client Code", Member);
        if objLoanRegister.Find('-') then begin
            objLoanRegister.SetCurrentkey("Application Date");

            // objLoanRegister.ASCENDING(FALSE);
            objLoanRegister.SetFilter("Loan Status", '=%1', objLoanRegister."loan status"::Application);
            objLoanRegister.SetFilter("Requested Amount", '>%1', 0);
            // objLoanRegister."Loan Status"::Appraisal;
            repeat
                objLoanRegister.CalcFields("Total Loans Outstanding");
                loans := loans + objLoanRegister."Loan  No." + ':' + objLoanRegister."Loan Product Type" + ':' + Format(objLoanRegister."Requested Amount") + '::';
            until
              objLoanRegister.Next = 0;
        end;
    end;


    procedure FnGetLoansForGuarantee(Member: Code[40]) Guarantee: Text
    begin

        OnlineLoanGuarantors.Reset;
        OnlineLoanGuarantors.SetRange("Member No", Member);
        OnlineLoanGuarantors.SetFilter(Approved, '%1', OnlineLoanGuarantors.Approved::Pending);
        if OnlineLoanGuarantors.FindFirst then begin
            ObjLoanApplications.Reset;
            ObjLoanApplications.SetRange("Application No", OnlineLoanGuarantors."Loan Application No");
            if ObjLoanApplications.FindFirst then begin
                repeat
                    Guarantee := Format(OnlineLoanGuarantors."Loan Application No") + '::' + ObjLoanApplications."Loan Type" + '::' + OnlineLoanGuarantors.ApplicantNo + '::' + OnlineLoanGuarantors.ApplicantName
                    + '::' + Format(ObjLoanApplications."Loan Amount") + '::' + Guarantee;
                until OnlineLoanGuarantors.Next = 0;
            end;
        end;

    end;


    procedure FnEditableLoans(MemberNo: Code[10]; Loan: Code[20]) Edit: Text
    var
        Loantpe: Text;
        Loanpurpose: Text;
    begin
        LoansGuaranteeDetails.Reset;
        LoansGuaranteeDetails.SetRange("Member No", MemberNo);
        LoansGuaranteeDetails.SetRange("Loan No", Loan);

        if LoansGuaranteeDetails.Find('-') then begin
            repeat
                Edit := Edit + LoansGuaranteeDetails."Loan No" + LoansGuaranteeDetails."Loanees  Name" + Format(LoansGuaranteeDetails."Amont Guaranteed");
            until LoansGuaranteeDetails.Next = 0;

        end;
    end;


    procedure fnedtitloan(Amount: Decimal; Loan: Code[20]; Repaymperiod: Integer; LoanPurpose: Code[20]; LoanType: Code[20])
    begin
        objLoanRegister.Reset;
        //objLoanRegister.SETRANGE("Client Code", Member);
        objLoanRegister.SetRange("Loan  No.", Loan);
        if objLoanRegister.Find('-') then begin
            objLoanRegister.Init;
            objLoanRegister."Requested Amount" := Amount;
            objLoanRegister.Validate("Requested Amount");
            objLoanRegister.Installments := Repaymperiod;
            // objLoanRegister.VALIDATE(Installments);
            objLoanRegister."Loan Product Type" := LoanType;
            objLoanRegister.Validate("Loan Product Type");
            objLoanRegister."Loan Purpose" := LoanPurpose;
            objLoanRegister.Validate("Loan Purpose");
            objLoanRegister.Modify;
        end;
    end;


    procedure FnApprovedGuarantors(Member: Code[40]; Loan: Code[40]) Guarantee: Text
    begin
        feedback.Reset;
        feedback.SetRange(No, Member);
        feedback.SetRange(Accepted, 1);
        feedback.SetRange(Rejected, 0);
        feedback.SetRange(LoanNo, Loan);

        if feedback.Find('-') then begin

            repeat
                objMember.SetRange("No.", feedback.Guarantor);
                if objMember.Find('-') then
                    FAccNo := objMember.Name;
                phoneNumber := objMember."Phone No.";
                objLoanRegister.SetRange("Loan  No.", feedback.LoanNo);
                if objLoanRegister.Find('-') then
                    Amount := objLoanRegister."Requested Amount";
                Guarantee := Guarantee + Format(feedback.Entry) + ':' + FAccNo + ':' + Format(phoneNumber) + '>>' + ':' + Format(feedback.Amount) + '::';

            until feedback.Next = 0;
        end;
    end;


    procedure FnPendingGuarantors(Member: Code[40]; Loan: Code[40]) Guarantee: Text
    begin
        feedback.Reset;
        feedback.SetRange(No, Member);
        feedback.SetRange(Accepted, 1);
        feedback.SetRange(Rejected, 0);
        feedback.SetRange(LoanNo, Loan);

        if feedback.Find('-') then begin

            repeat
                objMember.SetRange("No.", feedback.Guarantor);
                if objMember.Find('-') then
                    FAccNo := objMember.Name;
                phoneNumber := objMember."Phone No.";
                objLoanRegister.SetRange("Loan  No.", feedback.LoanNo);
                if objLoanRegister.Find('-') then
                    Amount := objLoanRegister."Requested Amount";
                Guarantee := Guarantee + Format(feedback.Entry) + ':' + FAccNo + ':' + Format(phoneNumber) + '>>' + ':' + Format(Amount) + '::';

            until feedback.Next = 0;
        end;
    end;


    procedure FnrejectedGuarantors(Member: Code[40]; Loan: Code[40]) Guarantee: Text
    begin
        feedback.Reset;
        feedback.SetRange(No, Member);
        feedback.SetRange(Accepted, 0);
        feedback.SetRange(Rejected, 1);
        feedback.SetRange(LoanNo, Loan);

        if feedback.Find('-') then begin

            repeat
                objMember.SetRange("No.", feedback.Guarantor);
                if objMember.Find('-') then
                    FAccNo := objMember.Name;
                phoneNumber := objMember."Phone No.";
                objLoanRegister.SetRange("Loan  No.", feedback.LoanNo);
                if objLoanRegister.Find('-') then
                    Amount := objLoanRegister."Requested Amount";
                Guarantee := Guarantee + Format(feedback.Entry) + ':' + FAccNo + ':' + Format(phoneNumber) + '>>' + '::';

            until feedback.Next = 0;
        end;
    end;


    procedure FnApplytoAppraise(LoanNo: Code[20])
    begin
        objLoanRegister.Reset;
        objLoanRegister.SetRange("Loan  No.", LoanNo);
        if objLoanRegister.Find('-') then begin
            // objLoanRegister.INIT;
            objLoanRegister."Loan Status" := objLoanRegister."loan status"::Appraisal;
            objLoanRegister.Modify;
        end;
    end;


    procedure fnTotalLoanAm(Loan: Code[10]) amount: Decimal
    begin
        PortaLuPS.Reset;
        PortaLuPS.SetRange(LaonNo, Loan);
        if PortaLuPS.Find('-') then begin
            amount := (PortaLuPS.RequestedAmount - PortaLuPS.TotalGuaranteed);

        end;
    end;


    procedure Fnquestionaire(Member: Code[20]; reason: Text; time: Text; Leastimpressed: Text; Mostimpressed: Text; suggestion: Text; accounts: Option; customercare: Option; atmosphere: Option; serveby: Text)
    begin
        Questinnaires.Init;
        if Questinnaires.Find('+') then
            Questinnaires.Entry := Questinnaires.Entry + 1

        else
            //Questinnaires.INSERT;
            Questinnaires.Entry := 1;
        Questinnaires.Member := Member;
        Questinnaires.ReasonForVisit := reason;
        Questinnaires.LeastImpressedWIth := Leastimpressed;
        Questinnaires.MostImpressedwith := Mostimpressed;
        Questinnaires.Suggestions := suggestion;
        Questinnaires.Accounts := accounts;
        Questinnaires.Customercare := customercare;
        Questinnaires.OfficeAtmosphere := atmosphere;
        Questinnaires.ServedBy := serveby;
        Questinnaires.Insert;
    end;

    procedure FnSendFeedback(MemberNo: Code[20]; Body: Text) Sent: Boolean
    var
    // smtpsetup: Record "O365 Email Setup";
    // smtp: Codeunit smtp mail
    begin
        Sent := FALSE;
        Questinnaires.Init;
        if Questinnaires.Find('+') then
            Questinnaires.Entry := Questinnaires.Entry + 1

        else
            Questinnaires.Entry := 1;
        Questinnaires.Member := MemberNo;
        Questinnaires.Suggestions := Body;
        Questinnaires.Insert;
        Sent := TRUE;
        EXIT(Sent);


    end;

    procedure fnLoanApplicationform("Member No": Code[50]; start: Date; peroid: Code[10])
    begin

        // DivProg.RESET;
        // DivProg.SETRANGE(DivProg."Member No","Member No");
        // IF DivProg.FIND('-') THEN
        // DivProg.DELETEALL;
        // StartDate:=start;
        // RunningPeriod:=peroid;
        // IF StartDate = 0D THEN
        // ERROR('You must specify start Date.');
        //
        // IF RunningPeriod='' THEN ERROR('Running Period Must be inserted');
        //
        // DivTotal:=0;
        // DivCapTotal:=0;
        // GenSetup.GET(0);
        //
        //
        //
        //
        //
        // //1st Month(Opening bal.....)
        // EVALUATE(BDate,'01/01/05');
        // FromDate:=BDate;
        // ToDate:=CALCDATE('-1D',StartDate);
        // EVALUATE(FromDateS,FORMAT(FromDate));
        // EVALUATE(ToDateS,FORMAT(ToDate));
        //
        // IF Cust.FIND('-') THEN BEGIN
        // Cust.CALCFIELDS(Cust."Current Shares",Cust."Shares Retained");
        // //IF Cust."Current Shares" <> 0 THEN BEGIN
        // CDiv:=(GenSetup."Interest on Deposits (%)"/100)*(Cust."Current Shares"*-1)*(12/12);
        // CapDiv:=(GenSetup."Dividend (%)"/100*(Cust."Shares Retained"*-1))*(12/12);
        //
        // DivTotal:=CDiv;
        // DivCapTotal:=CapDiv;
        //
        //
        //
        // DivProg.INIT;
        // DivProg."Member No":="Member No" ;
        // DivProg.Date:=ToDate;
        // DivProg."Gross Dividends":=CDiv;
        // DivProg."Witholding Tax":=CDiv*(GenSetup."Withholding Tax (%)"/100);
        // DivProg."Net Dividends":=DivProg."Gross Dividends"-DivProg."Witholding Tax";
        // DivProg."Qualifying Shares":=(Cust."Current Shares"*-1)*(12/12);
        // DivProg.Shares:=Cust."Current Shares"*-1;
        // DivProg."Share Capital":=Cust."Shares Retained"*-1;
        // DivProg."Gross  Share cap Dividend":=CapDiv;
        // DivProg."Qualifying Share Capital":=(Cust."Shares Retained"*-1)*(12/12);
        // DivProg."Wtax Share Cap Dividend":=CapDiv*(GenSetup."Withholding Tax (%)"/100);
        // DivProg."Net Share Cap Dividend":=DivProg."Gross  Share cap Dividend"-DivProg."Wtax Share Cap Dividend";
        // DivProg.Period:=RunningPeriod;
        // DivProg.INSERT;
        // END;
        // //END;
        // //previous Year End(Opening Bal......)
        //
        //
        //
        //
        //
        // DateFilter:=FromDateS+'..'+ToDateS;
        // Cust.RESET;
        // Cust.SETCURRENTKEY("No.");
        // Cust.SETRANGE(Cust."No.","Member No");
        // Cust.SETFILTER(Cust."Date Filter",DateFilter);
        //
        // //1
        // EVALUATE(BDate,'01/01/16');
        // FromDate:=BDate;//StartDate;
        // ToDate:=CALCDATE('-1D',CALCDATE('1M',StartDate));
        // EVALUATE(FromDateS,FORMAT(FromDate));
        // EVALUATE(ToDateS,FORMAT(ToDate));
        //
        // DateFilter:=FromDateS+'..'+ToDateS;
        // Cust.RESET;
        // Cust.SETRANGE(Cust."No.","Member No");
        // Cust.SETFILTER(Cust."Date Filter",DateFilter);
        // IF Cust.FIND('-') THEN BEGIN
        // Cust.CALCFIELDS(Cust."Current Shares",Cust."Shares Retained");
        // //IF Cust."Current Shares" <> 0 THEN BEGIN
        // CDiv:=(GenSetup."Interest on Deposits (%)"/100)*(Cust."Current Shares"*-1)*(12/12);
        // CapDiv:=(GenSetup."Dividend (%)"/100*(Cust."Shares Retained"*-1))*(12/12);
        //
        // DivTotal:=CDiv;
        // DivCapTotal:=CapDiv;
        //
        //
        //
        // DivProg.INIT;
        // DivProg."Member No":="Member No";
        // DivProg.Date:=ToDate;
        // DivProg."Gross Dividends":=CDiv;
        // DivProg."Witholding Tax":=CDiv*(GenSetup."Withholding Tax (%)"/100);
        // DivProg."Net Dividends":=DivProg."Gross Dividends"-DivProg."Witholding Tax";
        // DivProg."Qualifying Shares":=(Cust."Current Shares"*-1)*(12/12);
        // DivProg.Shares:=Cust."Current Shares"*-1;
        // DivProg."Share Capital":=Cust."Shares Retained"*-1;
        // DivProg."Gross  Share cap Dividend":=CapDiv;
        // DivProg."Qualifying Share Capital":=(Cust."Shares Retained"*-1)*(12/12);
        // DivProg."Wtax Share Cap Dividend":=CapDiv*(GenSetup."Withholding Tax (%)"/100);
        // DivProg."Net Share Cap Dividend":=DivProg."Gross  Share cap Dividend"-DivProg."Wtax Share Cap Dividend";
        // DivProg.Period:=RunningPeriod;
        // DivProg.INSERT;
        // END;
        // //END ELSE
        // //DivTotal:=0;
        // //END;
        //
        //
        //
        //
        //
        //
        // //2
        // FromDate:=CALCDATE('1M',StartDate);
        // ToDate:=CALCDATE('-1D',CALCDATE('2M',StartDate));
        // EVALUATE(FromDateS,FORMAT(FromDate));
        // EVALUATE(ToDateS,FORMAT(ToDate));
        //
        // DateFilter:=FromDateS+'..'+ToDateS;
        // Cust.RESET;
        // Cust.SETRANGE(Cust."No.","Member No");
        // Cust.SETFILTER(Cust."Date Filter",DateFilter);
        // IF Cust.FIND('-') THEN BEGIN
        // Cust.CALCFIELDS(Cust."Current Shares",Cust."Shares Retained");
        // //IF Cust."Current Shares" <> 0 THEN BEGIN
        // CDiv:=(GenSetup."Interest on Deposits (%)"/100)*(Cust."Current Shares"*-1)*(11/12);
        // CapDiv:=(GenSetup."Dividend (%)"/100*(Cust."Shares Retained"*-1))*(11/12);
        //
        // DivTotal:=CDiv;
        // DivCapTotal:=CapDiv;
        //
        // DivProg.INIT;
        // DivProg."Member No":="Member No";
        // DivProg.Date:=ToDate;
        // DivProg."Gross Dividends":=CDiv;
        // DivProg."Witholding Tax":=CDiv*(GenSetup."Withholding Tax (%)"/100);
        // DivProg."Net Dividends":=DivProg."Gross Dividends"-DivProg."Witholding Tax";
        // DivProg."Qualifying Shares":=(Cust."Current Shares"*-1)*(11/12);
        // DivProg.Shares:=Cust."Current Shares"*-1;
        // DivProg."Share Capital":=Cust."Shares Retained"*-1;
        // DivProg."Gross  Share cap Dividend":=CapDiv;
        // DivProg."Qualifying Share Capital":=(Cust."Shares Retained"*-1)*(11/12);
        // DivProg."Wtax Share Cap Dividend":=CapDiv*(GenSetup."Withholding Tax (%)"/100);
        // DivProg."Net Share Cap Dividend":=DivProg."Gross  Share cap Dividend"-DivProg."Wtax Share Cap Dividend";
        // DivProg.Period:=RunningPeriod;
        // DivProg.INSERT
        //
        // END;
        // //END;
        //
        //
        //
        //
        //
        // //3
        // FromDate:=CALCDATE('2M',StartDate);
        // ToDate:=CALCDATE('-1D',CALCDATE('3M',StartDate));
        // EVALUATE(FromDateS,FORMAT(FromDate));
        // EVALUATE(ToDateS,FORMAT(ToDate));
        //
        // DateFilter:=FromDateS+'..'+ToDateS;
        // Cust.RESET;
        // Cust.SETRANGE(Cust."No.","Member No");
        // Cust.SETFILTER(Cust."Date Filter",DateFilter);
        // IF Cust.FIND('-') THEN BEGIN
        // Cust.CALCFIELDS(Cust."Current Shares",Cust."Shares Retained");
        // //IF Cust."Current Shares" <> 0 THEN BEGIN
        //
        // CDiv:=(GenSetup."Interest on Deposits (%)"/100)*(Cust."Current Shares"*-1)*(10/12);
        // CapDiv:=(GenSetup."Dividend (%)"/100*(Cust."Shares Retained"*-1))*(10/12);
        //
        // DivTotal:=CDiv;
        // DivCapTotal:=CapDiv;
        //
        // DivProg.INIT;
        // DivProg."Member No":="Member No";
        // DivProg.Date:=ToDate;
        // DivProg."Gross Dividends":=CDiv;
        // DivProg."Witholding Tax":=CDiv*(GenSetup."Withholding Tax (%)"/100);
        // DivProg."Net Dividends":=DivProg."Gross Dividends"-DivProg."Witholding Tax";
        // DivProg."Qualifying Shares":=(Cust."Current Shares"*-1)*(10/12);
        // DivProg.Shares:=Cust."Current Shares"*-1;
        // DivProg."Share Capital":=Cust."Shares Retained"*-1;
        // DivProg."Gross  Share cap Dividend":=CapDiv;
        // DivProg."Qualifying Share Capital":=(Cust."Shares Retained"*-1)*(10/12);
        // DivProg."Wtax Share Cap Dividend":=CapDiv*(GenSetup."Withholding Tax (%)"/100);
        // DivProg."Net Share Cap Dividend":=DivProg."Gross  Share cap Dividend"-DivProg."Wtax Share Cap Dividend";
        // DivProg.Period:=RunningPeriod;
        // DivProg.INSERT
        //
        // END;
        // //END;
        //
        //
        //
        //
        // //4
        // FromDate:=CALCDATE('3M',StartDate);
        // ToDate:=CALCDATE('-1D',CALCDATE('4M',StartDate));
        // EVALUATE(FromDateS,FORMAT(FromDate));
        // EVALUATE(ToDateS,FORMAT(ToDate));
        //
        // DateFilter:=FromDateS+'..'+ToDateS;
        // Cust.RESET;
        // Cust.SETRANGE(Cust."No.","Member No");
        // Cust.SETFILTER(Cust."Date Filter",DateFilter);
        // IF Cust.FIND('-') THEN BEGIN
        // Cust.CALCFIELDS(Cust."Current Shares",Cust."Shares Retained");
        // //IF Cust."Current Shares" <> 0 THEN BEGIN
        //
        // CDiv:=(GenSetup."Interest on Deposits (%)"/100)*(Cust."Current Shares"*-1)*(9/12);
        // CapDiv:=(GenSetup."Dividend (%)"/100*(Cust."Shares Retained"*-1))*(9/12);
        //
        // DivTotal:=CDiv;
        // DivCapTotal:=CapDiv;
        //
        // DivProg.INIT;
        // DivProg."Member No":="Member No";
        // DivProg.Date:=ToDate;
        // DivProg."Gross Dividends":=CDiv;
        // DivProg."Witholding Tax":=CDiv*(GenSetup."Withholding Tax (%)"/100);
        // DivProg."Net Dividends":=DivProg."Gross Dividends"-DivProg."Witholding Tax";
        // DivProg."Qualifying Shares":=(Cust."Current Shares"*-1)*(9/12);
        // DivProg.Shares:=Cust."Current Shares"*-1;
        // DivProg."Share Capital":=Cust."Shares Retained"*-1;
        // DivProg."Gross  Share cap Dividend":=CapDiv;
        // DivProg."Qualifying Share Capital":=(Cust."Shares Retained"*-1)*(9/12);
        // DivProg."Wtax Share Cap Dividend":=CapDiv*(GenSetup."Withholding Tax (%)"/100);
        // DivProg."Net Share Cap Dividend":=DivProg."Gross  Share cap Dividend"-DivProg."Wtax Share Cap Dividend";
        // DivProg.Period:=RunningPeriod;
        // DivProg.INSERT
        //
        // END;
        // //END;
        //
        //
        //
        //
        // //5
        // FromDate:=CALCDATE('4M',StartDate);
        // ToDate:=CALCDATE('-1D',CALCDATE('5M',StartDate));
        // EVALUATE(FromDateS,FORMAT(FromDate));
        // EVALUATE(ToDateS,FORMAT(ToDate));
        //
        // DateFilter:=FromDateS+'..'+ToDateS;
        // Cust.RESET;
        // Cust.SETRANGE(Cust."No.","Member No");
        // Cust.SETFILTER(Cust."Date Filter",DateFilter);
        // IF Cust.FIND('-') THEN BEGIN
        // Cust.CALCFIELDS(Cust."Current Shares",Cust."Shares Retained");
        // //IF Cust."Current Shares" <> 0 THEN BEGIN
        //
        // CDiv:=(GenSetup."Interest on Deposits (%)"/100)*(Cust."Current Shares"*-1)*(8/12);
        // CapDiv:=(GenSetup."Dividend (%)"/100*(Cust."Shares Retained"*-1))*(8/12);
        //
        // DivTotal:=CDiv;
        // DivCapTotal:=CapDiv;
        //
        // DivProg.INIT;
        // DivProg."Member No":="Member No";
        // DivProg.Date:=ToDate;
        // DivProg."Gross Dividends":=CDiv;
        // DivProg."Witholding Tax":=CDiv*(GenSetup."Withholding Tax (%)"/100);
        // DivProg."Net Dividends":=DivProg."Gross Dividends"-DivProg."Witholding Tax";
        // DivProg."Qualifying Shares":=(Cust."Current Shares"*-1)*(8/12);
        // DivProg.Shares:=Cust."Current Shares"*-1;
        // DivProg."Share Capital":=Cust."Shares Retained"*-1;
        // DivProg."Gross  Share cap Dividend":=CapDiv;
        // DivProg."Qualifying Share Capital":=(Cust."Shares Retained"*-1)*(8/12);
        // DivProg."Wtax Share Cap Dividend":=CapDiv*(GenSetup."Withholding Tax (%)"/100);
        // DivProg."Net Share Cap Dividend":=DivProg."Gross  Share cap Dividend"-DivProg."Wtax Share Cap Dividend";
        // DivProg.Period:=RunningPeriod;
        // DivProg.INSERT
        // END;
        // //END;
        //
        //
        //
        //
        // //6
        // FromDate:=CALCDATE('5M',StartDate);
        // ToDate:=CALCDATE('-1D',CALCDATE('6M',StartDate));
        // EVALUATE(FromDateS,FORMAT(FromDate));
        // EVALUATE(ToDateS,FORMAT(ToDate));
        //
        // DateFilter:=FromDateS+'..'+ToDateS;
        // Cust.RESET;
        // Cust.SETRANGE(Cust."No.","Member No");
        // Cust.SETFILTER(Cust."Date Filter",DateFilter);
        // IF Cust.FIND('-') THEN BEGIN
        // Cust.CALCFIELDS(Cust."Current Shares",Cust."Shares Retained");
        // //IF Cust."Current Shares" <> 0 THEN BEGIN
        //
        //
        // CDiv:=(GenSetup."Interest on Deposits (%)"/100)*(Cust."Current Shares"*-1)*(7/12);
        // CapDiv:=(GenSetup."Dividend (%)"/100*(Cust."Shares Retained"*-1))*(7/12);
        //
        // DivTotal:=CDiv;
        // DivCapTotal:=CapDiv;;
        //
        // DivProg.INIT;
        // DivProg."Member No":="Member No";
        // DivProg.Date:=ToDate;
        // DivProg."Gross Dividends":=CDiv;
        // DivProg."Witholding Tax":=CDiv*(GenSetup."Withholding Tax (%)"/100);
        // DivProg."Net Dividends":=DivProg."Gross Dividends"-DivProg."Witholding Tax";
        // DivProg."Qualifying Shares":=(Cust."Current Shares"*-1)*(7/12);
        // DivProg.Shares:=Cust."Current Shares"*-1;
        // DivProg."Share Capital":=Cust."Shares Retained"*-1;
        // DivProg."Gross  Share cap Dividend":=CapDiv;
        // DivProg."Qualifying Share Capital":=(Cust."Shares Retained"*-1)*(7/12);
        // DivProg."Wtax Share Cap Dividend":=CapDiv*(GenSetup."Withholding Tax (%)"/100);
        // DivProg."Net Share Cap Dividend":=DivProg."Gross  Share cap Dividend"-DivProg."Wtax Share Cap Dividend";
        // DivProg.Period:=RunningPeriod;
        // DivProg.INSERT
        //
        // END;
        // //END;
        //
        //
        //
        //
        //
        // //7
        // FromDate:=CALCDATE('6M',StartDate);
        // ToDate:=CALCDATE('-1D',CALCDATE('7M',StartDate));
        // EVALUATE(FromDateS,FORMAT(FromDate));
        // EVALUATE(ToDateS,FORMAT(ToDate));
        //
        // DateFilter:=FromDateS+'..'+ToDateS;
        // Cust.RESET;
        // Cust.SETRANGE(Cust."No.","Member No");
        // Cust.SETFILTER(Cust."Date Filter",DateFilter);
        // IF Cust.FIND('-') THEN BEGIN
        // Cust.CALCFIELDS(Cust."Current Shares",Cust."Shares Retained");
        // //IF Cust."Current Shares" <> 0 THEN BEGIN
        //
        //
        // CDiv:=(GenSetup."Interest on Deposits (%)"/100)*(Cust."Current Shares"*-1)*(6/12);
        // CapDiv:=(GenSetup."Dividend (%)"/100*(Cust."Shares Retained"*-1))*(6/12);
        //
        // DivTotal:=CDiv;
        // DivCapTotal:=CapDiv;
        //
        // DivProg.INIT;
        // DivProg."Member No":="Member No";
        // DivProg.Date:=ToDate;
        // DivProg."Gross Dividends":=CDiv;
        // DivProg."Witholding Tax":=CDiv*(GenSetup."Withholding Tax (%)"/100);
        // DivProg."Net Dividends":=DivProg."Gross Dividends"-DivProg."Witholding Tax";
        // DivProg."Qualifying Shares":=(Cust."Current Shares"*-1)*(6/12);
        // DivProg.Shares:=Cust."Current Shares"*-1;
        // DivProg."Share Capital":=Cust."Shares Retained"*-1;
        // DivProg."Gross  Share cap Dividend":=CapDiv;
        // DivProg."Qualifying Share Capital":=(Cust."Shares Retained"*-1)*(6/12);
        // DivProg."Wtax Share Cap Dividend":=CapDiv*(GenSetup."Withholding Tax (%)"/100);
        // DivProg."Net Share Cap Dividend":=DivProg."Gross  Share cap Dividend"-DivProg."Wtax Share Cap Dividend";
        // DivProg.Period:=RunningPeriod;
        // DivProg.INSERT
        //
        // END;
        // //END;
        //
        //
        //
        //
        //
        // //8
        // FromDate:=CALCDATE('7M',StartDate);
        // ToDate:=CALCDATE('-1D',CALCDATE('8M',StartDate));
        // EVALUATE(FromDateS,FORMAT(FromDate));
        // EVALUATE(ToDateS,FORMAT(ToDate));
        //
        // DateFilter:=FromDateS+'..'+ToDateS;
        // Cust.RESET;
        // Cust.SETRANGE(Cust."No.","Member No");
        // Cust.SETFILTER(Cust."Date Filter",DateFilter);
        // IF Cust.FIND('-') THEN BEGIN
        // Cust.CALCFIELDS(Cust."Current Shares",Cust."Shares Retained");
        // //IF Cust."Current Shares" <> 0 THEN BEGIN
        //
        //
        // CDiv:=(GenSetup."Interest on Deposits (%)"/100)*(Cust."Current Shares"*-1)*(5/12);
        // CapDiv:=(GenSetup."Dividend (%)"/100*(Cust."Shares Retained"*-1))*(5/12);
        //
        // DivTotal:=CDiv;
        // DivCapTotal:=CapDiv;
        //
        // DivProg.INIT;
        // DivProg."Member No":="Member No";
        // DivProg.Date:=ToDate;
        // DivProg."Gross Dividends":=CDiv;
        // DivProg."Witholding Tax":=CDiv*(GenSetup."Withholding Tax (%)"/100);
        // DivProg."Net Dividends":=DivProg."Gross Dividends"-DivProg."Witholding Tax";
        // DivProg."Qualifying Shares":=(Cust."Current Shares"*-1)*(5/12);
        // DivProg.Shares:=Cust."Current Shares"*-1;
        // DivProg."Share Capital":=Cust."Shares Retained"*-1;
        // DivProg."Gross  Share cap Dividend":=CapDiv;
        // DivProg."Qualifying Share Capital":=(Cust."Shares Retained"*-1)*(5/12);
        // DivProg."Wtax Share Cap Dividend":=CapDiv*(GenSetup."Withholding Tax (%)"/100);
        // DivProg."Net Share Cap Dividend":=DivProg."Gross  Share cap Dividend"-DivProg."Wtax Share Cap Dividend";
        // DivProg.Period:=RunningPeriod;
        // DivProg.INSERT
        //
        // END;
        // //END;
        //
        //
        //
        //
        //
        // //9
        // FromDate:=CALCDATE('8M',StartDate);
        // ToDate:=CALCDATE('-1D',CALCDATE('9M',StartDate));
        // EVALUATE(FromDateS,FORMAT(FromDate));
        // EVALUATE(ToDateS,FORMAT(ToDate));
        //
        // DateFilter:=FromDateS+'..'+ToDateS;
        // Cust.RESET;
        // Cust.SETRANGE(Cust."No.","Member No");
        // Cust.SETFILTER(Cust."Date Filter",DateFilter);
        // IF Cust.FIND('-') THEN BEGIN
        // Cust.CALCFIELDS(Cust."Current Shares",Cust."Shares Retained");
        // //IF Cust."Current Shares" <> 0 THEN BEGIN
        //
        //
        // CDiv:=(GenSetup."Interest on Deposits (%)"/100)*(Cust."Current Shares"*-1)*(4/12);
        // CapDiv:=(GenSetup."Dividend (%)"/100*(Cust."Shares Retained"*-1))*(4/12);
        //
        // DivTotal:=CDiv;
        // DivCapTotal:=CapDiv;
        //
        // DivProg.INIT;
        // DivProg."Member No":="Member No";
        // DivProg.Date:=ToDate;
        // DivProg."Gross Dividends":=CDiv;
        // DivProg."Witholding Tax":=CDiv*(GenSetup."Withholding Tax (%)"/100);
        // DivProg."Net Dividends":=DivProg."Gross Dividends"-DivProg."Witholding Tax";
        // DivProg."Qualifying Shares":=(Cust."Current Shares"*-1)*(4/12);
        // DivProg.Shares:=Cust."Current Shares"*-1;
        // DivProg."Share Capital":=Cust."Shares Retained"*-1;
        // DivProg."Gross  Share cap Dividend":=CapDiv;
        // DivProg."Qualifying Share Capital":=(Cust."Shares Retained"*-1)*(4/12);
        // DivProg."Wtax Share Cap Dividend":=CapDiv*(GenSetup."Withholding Tax (%)"/100);
        // DivProg."Net Share Cap Dividend":=DivProg."Gross  Share cap Dividend"-DivProg."Wtax Share Cap Dividend";
        // DivProg.Period:=RunningPeriod;
        // DivProg.INSERT
        // END;
        // //END;
        //
        //
        //
        //
        //
        // //10
        // FromDate:=CALCDATE('9M',StartDate);
        // ToDate:=CALCDATE('-1D',CALCDATE('10M',StartDate));
        // EVALUATE(FromDateS,FORMAT(FromDate));
        // EVALUATE(ToDateS,FORMAT(ToDate));
        //
        // DateFilter:=FromDateS+'..'+ToDateS;
        // Cust.RESET;
        // Cust.SETRANGE(Cust."No.","Member No");
        // Cust.SETFILTER(Cust."Date Filter",DateFilter);
        // IF Cust.FIND('-') THEN BEGIN
        // Cust.CALCFIELDS(Cust."Current Shares",Cust."Shares Retained");
        // //IF Cust."Current Shares" <> 0 THEN BEGIN
        //
        //
        // CDiv:=(GenSetup."Interest on Deposits (%)"/100)*(Cust."Current Shares"*-1)*(3/12);
        // CapDiv:=(GenSetup."Dividend (%)"/100*(Cust."Shares Retained"*-1))*(3/12);
        //
        // DivTotal:=CDiv;
        // DivCapTotal:=CapDiv;
        //
        // DivProg.INIT;
        // DivProg."Member No":="Member No";
        // DivProg.Date:=ToDate;
        // DivProg."Gross Dividends":=CDiv;
        // DivProg."Witholding Tax":=CDiv*(GenSetup."Withholding Tax (%)"/100);
        // DivProg."Net Dividends":=DivProg."Gross Dividends"-DivProg."Witholding Tax";
        // DivProg."Qualifying Shares":=(Cust."Current Shares"*-1)*(3/12);
        // DivProg.Shares:=Cust."Current Shares"*-1;
        // DivProg."Share Capital":=Cust."Shares Retained"*-1;
        // DivProg."Gross  Share cap Dividend":=CapDiv;
        // DivProg."Qualifying Share Capital":=(Cust."Shares Retained"*-1)*(3/12);
        // DivProg."Wtax Share Cap Dividend":=CapDiv*(GenSetup."Withholding Tax (%)"/100);
        // DivProg."Net Share Cap Dividend":=DivProg."Gross  Share cap Dividend"-DivProg."Wtax Share Cap Dividend";
        // DivProg.Period:=RunningPeriod;
        // DivProg.INSERT
        // END;
        // //END;
        //
        //
        //
        //
        //
        // //11
        // FromDate:=CALCDATE('10M',StartDate);
        // ToDate:=CALCDATE('-1D',CALCDATE('11M',StartDate));
        // EVALUATE(FromDateS,FORMAT(FromDate));
        // EVALUATE(ToDateS,FORMAT(ToDate));
        //
        // DateFilter:=FromDateS+'..'+ToDateS;
        // Cust.RESET;
        // Cust.SETRANGE(Cust."No.","Member No");
        // Cust.SETFILTER(Cust."Date Filter",DateFilter);
        // IF Cust.FIND('-') THEN BEGIN
        // Cust.CALCFIELDS(Cust."Current Shares",Cust."Shares Retained");
        // //IF Cust."Current Shares" <> 0 THEN BEGIN
        //
        //
        // CDiv:=(GenSetup."Interest on Deposits (%)"/100)*(Cust."Current Shares"*-1)*(2/12);
        // CapDiv:=(GenSetup."Dividend (%)"/100*(Cust."Shares Retained"*-1))*(2/12);
        //
        // DivTotal:=CDiv;
        // DivCapTotal:=CapDiv;
        //
        // DivProg.INIT;
        // DivProg."Member No":="Member No";
        // DivProg.Date:=ToDate;
        // DivProg."Gross Dividends":=CDiv;
        // DivProg."Witholding Tax":=CDiv*(GenSetup."Withholding Tax (%)"/100);
        // DivProg."Net Dividends":=DivProg."Gross Dividends"-DivProg."Witholding Tax";
        // DivProg."Qualifying Shares":=(Cust."Current Shares"*-1)*(2/12);
        // DivProg.Shares:=Cust."Current Shares"*-1;
        // DivProg."Share Capital":=Cust."Shares Retained"*-1;
        // DivProg."Gross  Share cap Dividend":=CapDiv;
        // DivProg."Qualifying Share Capital":=(Cust."Shares Retained"*-1)*(2/12);
        // DivProg."Wtax Share Cap Dividend":=CapDiv*(GenSetup."Withholding Tax (%)"/100);
        // DivProg."Net Share Cap Dividend":=DivProg."Gross  Share cap Dividend"-DivProg."Wtax Share Cap Dividend";
        // DivProg.Period:=RunningPeriod;
        // DivProg.INSERT
        // END;
        // //END;
        //
        //
        //
        //
        //
        // //12
        // FromDate:=CALCDATE('11M',StartDate);
        // ToDate:=CALCDATE('-1D',CALCDATE('12M',StartDate));
        // EVALUATE(FromDateS,FORMAT(FromDate));
        // EVALUATE(ToDateS,FORMAT(ToDate));
        //
        // DateFilter:=FromDateS+'..'+ToDateS;
        // Cust.RESET;
        // Cust.SETRANGE(Cust."No.","Member No");
        // Cust.SETFILTER(Cust."Date Filter",DateFilter);
        // IF Cust.FIND('-') THEN BEGIN
        // Cust.CALCFIELDS(Cust."Current Shares",Cust."Shares Retained");
        // //IF Cust."Current Shares" <> 0 THEN BEGIN
        //
        //
        // CDiv:=(GenSetup."Interest on Deposits (%)"/100)*(Cust."Current Shares"*-1)*(1/12);
        // CapDiv:=(GenSetup."Dividend (%)"/100*(Cust."Shares Retained"*-1))*(1/12);
        //
        // DivTotal:=CDiv;
        // DivCapTotal:=CapDiv;
        //
        // DivProg.INIT;
        // DivProg."Member No":="Member No";
        // DivProg.Date:=ToDate;
        // DivProg."Gross Dividends":=CDiv;
        // DivProg."Witholding Tax":=CDiv*(GenSetup."Withholding Tax (%)"/100);
        // DivProg."Net Dividends":=DivProg."Gross Dividends"-DivProg."Witholding Tax";
        // DivProg."Qualifying Shares":=(Cust."Current Shares"*-1)*(1/12);
        // DivProg.Shares:=Cust."Current Shares"*-1;
        // DivProg."Share Capital":=Cust."Shares Retained"*-1;
        // DivProg."Gross  Share cap Dividend":=CapDiv;
        // DivProg."Qualifying Share Capital":=(Cust."Shares Retained"*-1)*(1/12);
        // DivProg."Wtax Share Cap Dividend":=CapDiv*(GenSetup."Withholding Tax (%)"/100);
        // DivProg."Net Share Cap Dividend":=DivProg."Gross  Share cap Dividend"-DivProg."Wtax Share Cap Dividend";
        // DivProg.Period:=RunningPeriod;
        // DivProg.INSERT
        // END;
    end;


    procedure FnLoanfo(MemberNo: Code[20]) dividend: Text
    begin
        DivProg.Reset;
        DivProg.SetRange("Member No", MemberNo);
        if DivProg.Find('-') then begin
            repeat
                dividend := dividend + Format(DivProg.Date) + ':::' + Format(DivProg."Gross Dividends") + ':::' + Format(DivProg."Witholding Tax") + ':::' + Format(DivProg."Net Dividends") + ':::' + Format(DivProg."Qualifying Shares") + ':::'
                + Format(DivProg.Shares) + '::::';
            until DivProg.Next = 0;
        end;
    end;


    procedure fnGetFosaAccounts(BosaNo: Code[20]) fosas: Text
    begin
        /*
        objMember.RESET;
        objMember.SETRANGE("No.",BosaNo);
        IF objMember.FIND('-') THEN BEGIN
        */

        Vendor.Reset;
        Vendor.SetRange("BOSA Account No", BosaNo);
        Vendor.SetRange("Creditor Type", Vendor."creditor type"::Account);
        //Vendor.SETFILTER("Account Type",'501|502|503|504|505|506|507|508|509');
        if Vendor.Find('-') then begin
            repeat
                fosas := fosas + Vendor."No." + '>' + Vendor."Account Type" + ':::';
            until Vendor.Next = 0;
        end;
        //  END;

    end;


    // procedure fnGetAtms(idnumber: Code[30]) return: Text
    // begin
    //     objAtmapplication.Reset;
    //     objAtmapplication.SetRange("Customer ID", idnumber);
    //     if objAtmapplication.Find('-') then begin
    //         repeat
    //             return := objAtmapplication."No." + ':::' + Format(objAtmapplication."Application Date") + ':::' + Format(objAtmapplication.Status) + ':::' + Format(objAtmapplication.Limit) + '::::' + return;
    //         until
    //           objAtmapplication.Next = 0;
    //     end;
    // end;


    procedure fnGetNextofkin(MemberNumber: Code[20]) return: Text
    begin
        objNextKin.Reset;
        objNextKin.SetRange("Account No", MemberNumber);
        if objNextKin.Find('-') then begin
            repeat
                return := return + objNextKin.Name + ':::' + objNextKin.Relationship + ':::' + objNextKin.Email + ':::' + Format(objNextKin."%Allocation") + '::::';
            until objNextKin.Next = 0;
        end;
    end;

    procedure fnGetNextofkin2(MemberNumber: Code[20]) return: Text
    begin
        objNextKin.Reset;
        objNextKin.SetRange("Account No", MemberNumber);
        if objNextKin.Find('-') then begin
            repeat
                return := return + objNextKin.Name + ':::' + objNextKin.Relationship + ':::' + objNextKin.Email + ':::' + Format(objNextKin."%Allocation") + '::::';
            until objNextKin.Next = 0;
        end;
    end;

    procedure FNFosaBalance(Acc: Code[30]) Bal: Text[1024]
    var
        AccountTypes: Record "Account Types-Saving Products";
        miniBalance: Decimal;
        accBalance: Decimal;
    begin

        accBalance := 0;
        Vendor.Reset;
        Vendor.SetRange(Vendor."No.", Acc);
        if Vendor.Find('-') then begin
            repeat
                AccountTypes.Reset;
                AccountTypes.SetRange(AccountTypes.Code, Vendor."Account Type");
                if AccountTypes.Find('-') then begin
                    miniBalance := AccountTypes."Minimum Balance";
                end;
                Vendor.CalcFields(Vendor."Balance (LCY)");
                Vendor.CalcFields(Vendor."ATM Transactions");
                Vendor.CalcFields(Vendor."Uncleared Cheques");
                Vendor.CalcFields(Vendor."EFT Transactions");
                accBalance := accBalance + (Vendor."Balance (LCY)" - (Vendor."ATM Transactions" + Vendor."Uncleared Cheques" + Vendor."EFT Transactions" + miniBalance));
                Bal := Format(accBalance);
            until Vendor.Next = 0;
        end;
    end;


    procedure FnAuditTrail(MemberNo: Code[30]; Accessed: Text)
    var
        ObjLog: Record "Portal Logs";
        ObjMember: Record 18;//customer;
    begin
        ObjLog.Reset;
        ObjLog.Init;
        ObjLog."Member No" := MemberNo;
        ObjLog.Date := Today;
        ObjLog.Time := Time;
        ObjLog."Accessed Page" := Accessed;
        ObjMember.Reset;
        if ObjMember.Get(MemberNo) then begin
            ObjLog."Member Name" := ObjMember.Name;
        end;
        ObjLog.Insert;
    end;


    procedure OnlineLoanApplication(BosaNo: Code[30]; LoanType: Code[30]; LoanAmount: Decimal; loanpurpose: Text; repaymentPeriod: Integer) GeneratedApplicationNo: Code[20]
    var
        ObjLoanApplications: Record "Online Loan Application";
    begin
        ObjLoanApplications.Reset;

        LoanProductType.Get(LoanType);

        objMember.Reset;
        objMember.SetRange(objMember."No.", BosaNo);
        if objMember.Find('-') then begin

            // ObjLoanApplications."Application No" := NewApplicationNo;
            ObjLoanApplications."Application Date" := Date;
            ObjLoanApplications."Id No" := objMember."ID No.";
            ObjLoanApplications."BOSA No" := objMember."No.";
            ObjLoanApplications."Employment No" := objMember."Payroll/Staff No";
            ObjLoanApplications."Member Names" := objMember.Name;
            ObjLoanApplications.Email := objMember."E-Mail";
            ObjLoanApplications."Date of Birth" := objMember."Date of Birth";
            ObjLoanApplications."Membership No" := objMember."No.";
            ObjLoanApplications.Telephone := objMember."Mobile Phone No";
            ObjLoanApplications."Loan Type" := LoanType;
            // ObjLoanApplications."FOSA Account No" := objMember."FOSA Account";
            ObjLoanApplications."Home Address" := objMember.Address;
            ObjLoanApplications.Station := objMember."Station/Department";
            ObjLoanApplications."Loan Amount" := LoanAmount;
            ObjLoanApplications."Repayment Period" := repaymentPeriod;
            ObjLoanApplications.Source := LoanProductType.Source;
            ObjLoanApplications."Interest Rate" := LoanProductType."Interest rate";
            // ObjLoanApplications."Min No Of Guarantors" := LoanProductType."Min No. Of Guarantors";
            ObjLoanApplications."Loan Purpose" := loanpurpose;
            ObjLoanApplications."Sent To Bosa Loans" := false;
            ObjLoanApplications.submitted := false;
            ObjLoanApplications.Posted := false;
            ObjLoanApplications.Refno := '0';
            ObjLoanApplications."Loan No" := '0';
            //objLoanApplications."Payment Mode" :=disbursementMode;
            ObjLoanApplications.Insert(true);

            GeneratedApplicationNo := ObjLoanApplications."Application No";
            // if LoanType = '' then SubmitLoan(ObjLoanApplications."Membership No", NewApplicationNo);
        end;
    end;


    // procedure SubmitLoan(MemberNo: Text; LoanNo: Code[20])
    // begin
    //     if objMember.Get(MemberNo) then begin

    //         ObjLoanApplications.Reset;
    //         ObjLoanApplications.SetRange(ObjLoanApplications."Application No", LoanNo);
    //         ObjLoanApplications.SetRange("BOSA No", MemberNo);
    //         if ObjLoanApplications.Find('-') then begin
    //             ObjLoanApplications.submitted := true;
    //             ObjLoanApplications.Modify;

    //             //send sms to member
    //             ReturnList := 'Dear Member, you have submitted Loan,' + 'No,' + Format(ObjLoanApplications."Application No") + 'for loan type' + ObjLoanApplications."Loan Type" + 'your  loan application for appraisal.';
    //             if (objMember."Phone No." <> '') then
    //                 FnSMSMessage(ClientName, objMember."Phone No.", ReturnList);
    //             // SMSMessage('PORTALTRAN',FAccNo,objMember."Phone No.",ReturnList);
    //             Message('test');
    //             if (objMember."Mobile Phone No" <> '') then
    //                 // SMSMessage('PORTALTRAN',FAccNo,objMember."Phone No.",ReturnList);
    //                 FnSMSMessage(ClientName, objMember."Mobile Phone No", ReturnList);
    //             Message('test');
    //             ReturnList := 'Dear Loans Officer,' + objMember.Name + 'member no,' + objMember."No." + 'has Applied Loan amount,' + Format(ObjLoanApplications."Loan Amount") + 'Application No,' + Format(ObjLoanApplications."Application No") + 'Login to navision to check';
    //             //  FnSMSMessage(ClientName,objMember.,ReturnList);
    //             // SMSMessage('PORTALTRAN',FAccNo,'0727548586',ReturnList);
    //             Message('test');
    //         end;
    //     end;
    // end;

    procedure SubmitLoan(memberNumber: Code[20]; loanNumber: Code[20]) response: text;
    var
        localsms: Text;
    begin
        response := 'Failed, Please try again Later';
        if objMember.Get(memberNumber) then begin

            ObjLoanApplications.Reset;
            ObjLoanApplications.SetRange(ObjLoanApplications."Application No", loanNumber);
            ObjLoanApplications.SetRange("BOSA No", memberNumber);
            if ObjLoanApplications.Find('-') then begin

                if ObjLoanApplications."Submitted" = true then begin
                    response := 'Failed, This loan has already been submitted';
                    exit;
                end;
                OnlineLoanGuarantors.Reset();
                OnlineLoanGuarantors.SetRange(OnlineLoanGuarantors."Loan Application No", loanNumber);
                if OnlineLoanGuarantors.Find('-') then begin
                    repeat
                        //check Guarantor Approvals...
                        if OnlineLoanGuarantors.Approved <> OnlineLoanGuarantors.Approved::Approved then begin
                            response := 'Failed, You cannot submit the loan untill all the Guarantors have Accepted your Request';
                            exit;
                        end;
                    // submitGuarantors(OnlineLoanGuarantors."Member No", ObjLoansregister."Loan  No.");
                    until OnlineLoanGuarantors.Next = 0;
                end;
                ObjLoansregister.Reset();
                ObjLoansregister.Init();

                ObjLoansregister."BOSA No" := ObjLoanApplications."BOSA No";
                ObjLoansregister.Source := ObjLoansregister.Source::BOSA;
                ObjLoansregister."Application Date" := ObjLoanApplications."Application Date";
                ObjLoansregister."Loan Product Type" := ObjLoanApplications."Loan Type";
                ObjLoansregister."Loan Status" := ObjLoansregister."Loan Status"::Application;
                ObjLoansregister.Validate(ObjLoansregister."BOSA No");
                ObjLoansregister.Validate(ObjLoansregister."Loan Product Type");

                ObjLoansregister.Installments := ObjLoanApplications."Repayment Period";
                ObjLoansregister."Requested Amount" := ObjLoanApplications."Loan Amount";
                if ObjLoansregister.Insert() then begin
                    ObjLoanApplications."Sent To Bosa Loans" := true;
                    ObjLoanApplications.submitted := true;
                    ObjLoanApplications."Submitted" := true;
                    ObjLoanApplications.Posted := true;
                    ObjLoanApplications.Modify;

                    //Submitt Guarantors
                    OnlineLoanGuarantors.Reset();
                    OnlineLoanGuarantors.SetRange(OnlineLoanGuarantors."Loan Application No", loanNumber);
                    OnlineLoanGuarantors.SetRange(OnlineLoanGuarantors.Approved, OnlineLoanGuarantors.Approved::Approved);
                    if OnlineLoanGuarantors.Find('-') then begin
                        repeat
                            submitGuarantors(OnlineLoanGuarantors."Member No", ObjLoansregister."Loan  No.");
                        until OnlineLoanGuarantors.Next = 0;
                    end;
                    localsms := 'Dear Member, you have submitted Loan,' + 'No,' + Format(ObjLoanApplications."Application No") + 'for loan type' + ObjLoanApplications."Loan Type" + 'your  loan application for appraisal.';
                    if (objMember."Phone No." <> '') then
                        FnSMSMessage(ClientName, objMember."Phone No.", localsms);
                    response := 'Success, your loan has been submitted to Credit for Appraisal';
                end else begin
                    response := 'Failed, Please contact the office for assistance';
                end;
            end;
        end;
    end;


    procedure submitGuarantors(memberNumber: Code[20]; loanNumber: Code[20])
    var
        loanGuarantors: Record "Loans Guarantee Details";
    begin
        OnlineLoanGuarantors.Reset();
        OnlineLoanGuarantors.SetRange(OnlineLoanGuarantors."Loan Application No", loanNumber);
        if OnlineLoanGuarantors.Find('-') then begin
            loanGuarantors.Init();
            loanGuarantors."Loan No" := loanNumber;
            loanGuarantors."Account No." := OnlineLoanGuarantors."Member No";
            loanGuarantors."Member No" := OnlineLoanGuarantors."Member No";
            loanGuarantors."Amont Guaranteed" := OnlineLoanGuarantors.Amount;
            loanGuarantors.Validate(loanGuarantors."Member No");
            loanGuarantors.Validate(loanGuarantors."Amont Guaranteed");
            loanGuarantors.Insert();

            // OnlineLoanGuarantors
        end;

    end;



    procedure FnRequestGuarantorship(BosaNo: Code[30]; AppNo: Code[20]) guaranteed: Boolean
    begin
        guaranteed := false;
        ObjLoanApplications.Reset;
        ObjLoanApplications.SetRange("Application No", AppNo);
        if ObjLoanApplications.Find('-') then begin
            OnlineLoanGuarantors.Reset;
            if OnlineLoanGuarantors.FindLast then
                NewApplicationNumber := OnlineLoanGuarantors."Entry No" + 1
            else
                NewApplicationNumber := 1;
            //create in online gurantors table
            objMember.Reset;
            objMember.SetRange(objMember."No.", BosaNo);
            objMember.SetFilter(Status, '%1', objMember.Status::Active);
            Message('test1');
            if objMember.Find('-') then begin
                OnlineLoanGuarantors.Init;
                OnlineLoanGuarantors."Entry No" := NewApplicationNumber;
                OnlineLoanGuarantors."Loan Application No" := AppNo;
                OnlineLoanGuarantors."Member No" := objMember."No.";
                OnlineLoanGuarantors.Names := objMember.Name;
                OnlineLoanGuarantors."Email Address" := objMember."E-Mail";
                OnlineLoanGuarantors."ID No" := objMember."ID No.";
                OnlineLoanGuarantors.Telephone := objMember."Mobile Phone No";
                OnlineLoanGuarantors.ApplicantNo := objMember."No.";
                OnlineLoanGuarantors.ApplicantName := ObjLoanApplications."Member Names";
                ;
                OnlineLoanGuarantors."Applicant Mobile" := ObjLoanApplications.Telephone;
                OnlineLoanGuarantors.Approved := OnlineLoanGuarantors.Approved::Pending;
                OnlineLoanGuarantors."Approval Status" := false;
                OnlineLoanGuarantors.Insert;
                guaranteed := true;
                Message('test3');

                ObjLoanApplications.Get(AppNo);
                //send sms to guarantor
                ReturnList := 'Dear Member, ' + ObjLoanApplications."Member Names" + ' has requested loan Guarantorship,' + 'of.' + Format(ObjLoanApplications."Loan Amount") + 'Kindly login to the portal to accept or reject the request';
                // SMSMessage('PORTALTRAN',FAccNo,objMember."Phone No.",ReturnList);
                FnSMSMessage('PORTAL', objMember."Mobile Phone No", ReturnList);


            end;

        end;
    end;


    procedure GuaranteeingPower(idNo: Code[30]; MemberNo: Code[30]; LoanType: Code[30]) GPower: Boolean
    begin
    end;


    procedure GuaranteeLoan(LoanNo: Integer; MemberNo: Text): Text
    begin
        // OnlineLoanGuarantors.Reset;
        // OnlineLoanGuarantors.SetRange(OnlineLoanGuarantors."Loan Application No", LoanNo);
        // OnlineLoanGuarantors.SetRange(OnlineLoanGuarantors."Member No", MemberNo);
        // if OnlineLoanGuarantors.Find('-') then begin
        //     OnlineLoanGuarantors.Approved := OnlineLoanGuarantors.Approved::Rejected;
        //     OnlineLoanGuarantors."Approval Status" := true;
        //     OnlineLoanGuarantors.Modify;

        //     //send sms/email to loanee
        //     objMember.Get(OnlineLoanGuarantors.ApplicantNo);
        //     if OnlineLoanGuarantors.Approved = OnlineLoanGuarantors.Approved::Rejected then
        //         ReturnList := 'Dear Member, your loan guarantorship have been rejected. Login to member portal for details';
        //     //SMSMessage('PORTALTRAN',FAccNo,objMember."Phone No.",ReturnList);
        //     FnSMSMessage('PORTAL', objMember."Mobile Phone No", ReturnList);
        //     //send sms/email to guarantor
        //     objMember.Get(MemberNo);
        //     if OnlineLoanGuarantors.Approved = OnlineLoanGuarantors.Approved::Rejected then
        //         ReturnList := 'Dear Member, you have rejected loan Guarantorship.';
        //     //SMSMessage('PORTALTRAN',FAccNo,objMember."Phone No.",ReturnList);
        //     FnSMSMessage('PORTAL', objMember."Mobile Phone No", ReturnList);
        // end;

    end;


    procedure ApproveGuarantorship(MemberNo: Text; LoanNo: Code[20]; Amount: Decimal): Text
    begin
        OnlineLoanGuarantors.Reset;
        OnlineLoanGuarantors.SetRange(OnlineLoanGuarantors."Loan Application No", LoanNo);
        OnlineLoanGuarantors.SetRange(OnlineLoanGuarantors."Member No", MemberNo);
        if OnlineLoanGuarantors.Find('-') then begin
            OnlineLoanGuarantors.Approved := OnlineLoanGuarantors.Approved::Approved;
            OnlineLoanGuarantors.Amount := Amount;
            OnlineLoanGuarantors."Approval Status" := true;
            OnlineLoanGuarantors.Modify;

            //send sms/email to loanee
            objMember.Get(OnlineLoanGuarantors.ApplicantNo);
            ReturnList := 'Dear Member, your loan guarantorship have been approved by,' + OnlineLoanGuarantors.Names + '. Login to   members portal to Submit for appraisal ';
            //SMSMessage('PORTALTRAN',FAccNo,objMember."Phone No.",ReturnList);
            FnSMSMessage('PORTAL', objMember."Mobile Phone No", ReturnList);
            if OnlineLoanGuarantors.Approved = OnlineLoanGuarantors.Approved::Rejected then
                ReturnList := 'Dear Member, your loan guarantorship have been rejected. Login to member portal for details';
            //SMSMessage('PORTALTRAN',FAccNo,objMember."Phone No.",ReturnList);
            FnSMSMessage('PORTAL', objMember."Mobile Phone No", ReturnList);

            //SEND sms to member


            //send sms/email to guarantor
            objMember.Get(MemberNo);
            ReturnList := 'Dear Member, you have approved loan Guarantorship.' + 'for,' + OnlineLoanGuarantors.ApplicantName;
            //SMSMessage('PORTALTRAN',FAccNo,OnlineLoanGuarantors.Telephone,ReturnList);
            FnSMSMessage('PORTAL', objMember."Mobile Phone No", ReturnList);
            if OnlineLoanGuarantors.Approved = OnlineLoanGuarantors.Approved::Rejected then
                ReturnList := 'Dear Member, you have rejected loan Guarantorship.';
            FnSMSMessage('PORTAL', objMember."Mobile Phone No", ReturnList);
            //SMSMessage('PORTALTRAN',FAccNo,objMember."Phone No.",ReturnList);
        end;

    end;


    procedure FnGetLoanNo(No: Text; LoanType: Text) Text: Text
    begin
        /*ObjLoanApplications.RESET;
        ObjLoanApplications.SETRANGE("Membership No",No);
        ObjLoanApplications.SETRANGE("Loan Type",LoanType);
        IF objAtmapplication.FIND('-') THEN BEGIN
          Text:=
          END;*/

    end;


    procedure FnGetLoanTypeBalance(LoanType: Code[30]; MemberNo: Code[30]): Decimal
    begin
        ReturnDecimal := 0;

        objLoanRegister.Reset;
        objLoanRegister.SetRange(objLoanRegister."Loan Product Type", LoanType);
        objLoanRegister.SetRange(objLoanRegister."BOSA No", MemberNo);

        if objLoanRegister.Find('-') then begin
            repeat
                objLoanRegister.CalcFields(objLoanRegister."Outstanding Balance");
                // IF (Loan."Outstanding Balance" >0) THEN
                begin
                    ReturnDecimal := ReturnDecimal + objLoanRegister."Outstanding Balance";//+objLoanRegister.Interest;
                end

            until objLoanRegister.Next = 0;
        end;
        exit(ReturnDecimal)
    end;


    procedure GetLoanQualification(BosaNo: Code[30]; LoanProdType: Text): Decimal
    var
        Deposits: Decimal;
        DepositsM: Decimal;
        GuaranteedT: Decimal;
        TotalLoans: Decimal;
        Multiplier: Decimal;
    begin
        ReturnDecimal := 0;
        objMember.Reset;
        objMember.SetRange(objMember."No.", BosaNo);
        if objMember.Find('-') then begin

            if LoanProductType.Get(LoanProdType) then begin
                Message('test2 %1', LoanProdType);
                Deposits := FnGetMemberTotalDeposits(BosaNo);
                Message('test3 %1', Deposits);
                DepositsM := Deposits * LoanProductType."Deposits Multiplier";
                Message('test %4', DepositsM);
                TotalLoans := FnGetLoanBalance(BosaNo);
                Message('test %5', TotalLoans);
                ReturnDecimal := DepositsM - TotalLoans;
                Message('test%6', ReturnDecimal);
                if ReturnDecimal < 0 then ReturnDecimal := 0;
            end;
        end;
        exit(ReturnDecimal);
    end;


    procedure FnGetMemberTotalDeposits(MemberNo: Code[30]): Decimal
    begin
        ReturnDecimal := 0;
        objMember.Reset;
        objMember.SetRange(objMember."No.", MemberNo);
        if objMember.Find('-') then begin
            objMember.CalcFields("Current Shares");
            ReturnDecimal := ReturnDecimal + Abs(objMember."Current Shares");
            Message('test%1', ReturnDecimal);
            exit(ReturnDecimal);
        end;
    end;


    procedure FnGetLoanBalance(MemberNo: Code[30]): Decimal
    begin
        ReturnDecimal := 0;
        objLoanRegister.Reset;
        objLoanRegister.SetRange(objLoanRegister."BOSA No", MemberNo);
        objLoanRegister.SetRange(objLoanRegister.Posted, true);
        if objLoanRegister.Find('-') then begin
            repeat
                objLoanRegister.CalcFields(objLoanRegister."Outstanding Balance");
                begin
                    ReturnDecimal := ReturnDecimal + objLoanRegister."Outstanding Balance";
                end

            until objLoanRegister.Next = 0;
        end;
        exit(ReturnDecimal);
    end;


    procedure FnGetGuarantors(LoanNo: Code[20]) text: Text
    var
        OnlineLoanGuarantors: Record "Online Loan Guarantors";
    begin
        OnlineLoanGuarantors.Reset;
        OnlineLoanGuarantors.SetRange("Loan Application No", LoanNo);
        if OnlineLoanGuarantors.FindFirst then begin
            repeat
                text := OnlineLoanGuarantors."Member No" + '.' + ':' + OnlineLoanGuarantors.Names + '.' + ':' + OnlineLoanGuarantors."Email Address" + '.' + ':' + OnlineLoanGuarantors.Telephone
                + '.' + ':' + Format(OnlineLoanGuarantors.Amount) + '.' + ':' + Format(OnlineLoanGuarantors.Approved) + '.' + ':' + text
          until OnlineLoanGuarantors.Next = 0;
        end;
    end;


    procedure FnGetOnlineLoans(MemberNo: Code[30]) text: Text
    begin
        ObjLoanApplications.Reset;
        ObjLoanApplications.SetRange("BOSA No", MemberNo);
        if ObjLoanApplications.Find('-') then begin
            repeat
                text := Format(ObjLoanApplications."Application No") + '.' + ':' + ObjLoanApplications."Loan Type" + '.' + ':' + Format(ObjLoanApplications."Loan Amount")
                + '.' + ':' + Format(ObjLoanApplications."Application Date") + '.' + ':' + Format(ObjLoanApplications.submitted) + '.' + ':' + text;
            until ObjLoanApplications.Next = 0;
        end;
    end;


    procedure FnEditOnlineLoan(LoanNo: Code[30]) loan: Text
    begin
        ObjLoanApplications.Reset;
        ObjLoanApplications.SetRange("Loan No", LoanNo);
        if ObjLoanApplications.FindFirst then begin

            loan := ObjLoanApplications."Loan Type" + '.' + ':' + ObjLoanApplications."Loan Purpose" + '.' + ':' + Format(ObjLoanApplications."Loan Amount")
             + '.' + ':' + Format(ObjLoanApplications."Interest Rate");

        end;
    end;


    procedure fnSharesCertificate(MemberNo: Code[50]) exitString: Text
    var
        Filename: Text[100];
        Outputstream: OutStream;
        RecRef: RecordRef;
        TempBlob: Codeunit "Temp Blob";
        Outstr: OutStream;
        Instr: InStream;
        Base64Convert: Codeunit "Base64 Convert";
    begin
        objMember.Reset;
        objMember.SetRange(objMember."No.", MemberNo);
        if objMember.Find('-') then begin
            RecRef.GetTable(objMember);
            Clear(TempBlob);
            TempBlob.CreateOutStream(Outstr);
            TempBlob.CreateInStream(Instr);
            if Report.SaveAs(Report::"Member Shares Certificate", '', ReportFormat::Pdf, Outstr, RecRef) then begin
                exitString := Base64Convert.ToBase64(Instr);
                exit;
            end;
        end;
    end;



}


