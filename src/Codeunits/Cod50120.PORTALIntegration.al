#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 50120 PORTALIntegration
{

    trigger OnRun()
    begin


        //MESSAGE(FORMAT(fnChangePassword('cemmmanuell@gmail.com', '','1234' )));
        // Message(Format(fnUpdatePassword('KS00402', '23787101', '1234', '')));
    end;

    var
        objMember: Record Customer;
        Vendor: Record Vendor;
        VendorLedgEntry: Record "Cust. Ledger Entry";
        FILESPATH: label 'D:\Kentours Revised\KENTOURS\Kentours\Kentours\Downloads\';
        objLoanRegister: Record 51371;
        objAtmapplication: Record 51464;
        objRegMember: Record 51360;
        objNextKin: Record 51366;
        GenSetup: Record 51398;
        FreeShares: Decimal;
        glamount: Decimal;
        LoansGuaranteeDetails: Record 51372;
        objStandingOrders: Record 51449;
        freq: DateFormula;
        dur: DateFormula;
        phoneNumber: Code[20];
        SMSMessages: Record 51471;
        iEntryNo: Integer;
        FAccNo: Text[250];
        sms: Text[250];
        objLoanApplication: Record 51562;
        ClientName: Code[20];
        Loansetup: Record 51381;
        feedback: Record 51910;
        LoansPurpose: Record 51378;
        ObjLoansregister: Record 51371;
        LPrincipal: Decimal;
        LInterest: Decimal;
        Amount: Decimal;
        LBalance: Decimal;
        LoansRec: Record 51371;
        TotalMRepay: Decimal;
        InterestRate: Decimal;
        Date: Date;
        FormNo: Code[40];
        PortaLuPS: Record 51913;
        Loanperiod: Integer;
        Questinnaires: Record 51912;
        LastFieldNo: Integer;
        FooterPrinted: Boolean;
        Cust: Record Customer;
        StartDate: Date;
        DateFilter: Text[100];
        FromDate: Date;
        ToDate: Date;
        FromDateS: Text[100];
        ToDateS: Text[100];
        DivTotal: Decimal;
        CDeposits: Decimal;
        CustDiv: Record Customer;
        DivProg: Record 51393;
        CDiv: Decimal;
        BDate: Date;
        CustR: Record Customer;
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
        ENtry: Integer;
        Online: Record 51489;
        MemberApplication: Record 51360;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        SalesSetup: Record 51399;


    // procedure fnUpdatePassword(MemberNo: Code[50]; idNo: Code[10]; NewPassword: Text; smsport: Text) emailAddress: Boolean
    // var
    //     EncryptionManagement: Codeunit "Cryptography Management";
    //     OutStream: OutStream;
    // begin
    //     sms := smsport + NewPassword;
    //     objMember.Reset;
    //     objMember.SetRange(objMember."No.", MemberNo);
    //     objMember.SetRange(objMember."ID No.", idNo);
    //     if objMember.Find('-') then begin

    //         phoneNumber := objMember."Mobile Phone No";
    //         FAccNo := objMember."No.";
    //         Online.Reset;
    //         Online.SetRange("User Name", MemberNo);
    //         if Online.Find('-') then begin
    //             // ERROR('You had already sign up for Kentours sacco portal services please click on forgot password to recover your password');
    //             //Online.INIT;
    //             Online."User Name" := objMember."No.";
    //             Online.MobileNumber := objMember."Mobile Phone No";
    //             Online.IdNumber := idNo;
    //             NewPassword := EncryptionManagement.Encrypt(NewPassword);
    //             Online.Password.CreateOutstream(OutStream);
    //             OutStream.Write(NewPassword);
    //             Online.Modify;
    //             FnSMSMessage(FAccNo, phoneNumber, sms);
    //             emailAddress := true;
    //         end
    //         else begin
    //             Online.Init;
    //             Online."User Name" := objMember."No.";
    //             Online.MobileNumber := objMember."Mobile Phone No";
    //             Online.Email := objMember."E-Mail";
    //             Online."Date Created" := Today;
    //             Online.IdNumber := idNo;
    //             NewPassword := EncryptionManagement.EncryptText(NewPassword);
    //             Online.Password.CreateOutstream(OutStream);
    //             OutStream.Write(NewPassword);
    //             Online.Insert;
    //             //  ;
    //             //  ;

    //             FnSMSMessage(FAccNo, phoneNumber, sms);
    //             emailAddress := true;
    //         end;

    //     end;





    //     // objMember.RESET;
    //     // objMember.SETRANGE(objMember."No.",MemberNo);
    //     // objMember.SETRANGE(objMember."ID No.",idNo);
    //     // IF objMember.FIND('-') THEN BEGIN
    //     //
    //     //   phoneNumber:= objMember."Mobile Phone No";
    //     //   FAccNo := objMember."No.";
    //     //  objMember.Password:=NewPassword;
    //     //
    //     //  objMember.MODIFY;
    //     //  FnSMSMessage(FAccNo,phoneNumber,sms);
    //     //  ;
    //     //  END
    //     //  ELSE BEGIN
    //     // objMember.RESET;
    //     // objMember.SETRANGE(objMember."Old Account No.",MemberNo);
    //     // objMember.SETRANGE(objMember."ID No.",idNo);
    //     // IF objMember.FIND('-') THEN BEGIN
    //     //
    //     //    phoneNumber:= objMember."Mobile Phone No";
    //     //   FAccNo := objMember."FOSA Account No.";
    //     //  objMember.Password:=NewPassword;
    //     //  objMember.MODIFY;
    //     //  FnSMSMessage(FAccNo,phoneNumber,sms);
    //     //  emailAddress:=TRUE;
    //     //  END
    //     //  ELSE BEGIN
    //     //    objMember.RESET;
    //     // objMember.SETRANGE(objMember."Personal No",MemberNo);
    //     // objMember.SETRANGE(objMember."ID No.",idNo);
    //     // IF objMember.FIND('-') THEN BEGIN
    //     //
    //     //    phoneNumber:= objMember."Mobile Phone No";
    //     //   FAccNo := objMember."FOSA Account No.";
    //     //  objMember.Password:=NewPassword;
    //     //  objMember.MODIFY;
    //     //  FnSMSMessage(FAccNo,phoneNumber,sms);
    //     //  emailAddress:=TRUE;
    //     //  END
    //     //  END
    //     // END;
    //     //  EXIT(emailAddress);
    // end;


    // procedure MiniStatement(MemberNo: Text[100]) MiniStmt: Text
    // var
    //     minimunCount: Integer;
    //     amount: Decimal;
    // begin
    //     begin
    //         MiniStmt := '';
    //         objMember.Reset;
    //         objMember.SetRange("No.", MemberNo);

    //         if objMember.Find('-') then begin

    //             minimunCount := 1;
    //             //Vendor.CALCFIELDS(Vendor.Balance);
    //             VendorLedgEntry.SetCurrentkey(VendorLedgEntry."Entry No.");
    //             VendorLedgEntry.Ascending(false);
    //             VendorLedgEntry.SetRange(VendorLedgEntry."Customer No.", MemberNo);
    //             VendorLedgEntry.SetRange(VendorLedgEntry.Reversed, false);
    //             if VendorLedgEntry.FindSet then begin
    //                 MiniStmt := '';
    //                 repeat
    //                     amount := VendorLedgEntry.Amount;
    //                     if amount < 1 then amount := amount * -1;
    //                     MiniStmt := MiniStmt + Format(VendorLedgEntry."Posting Date") + ':::' + CopyStr(Format(VendorLedgEntry."Transaction Type"), 1, 25) + ':::' +
    //                     Format(amount) + '::::';
    //                     minimunCount := minimunCount + 1;
    //                     if minimunCount > 5 then begin
    //                         exit(MiniStmt);
    //                     end
    //                 until VendorLedgEntry.Next = 0;
    //             end;

    //         end;

    //     end;
    //     exit(MiniStmt);
    // end;


    // procedure fnMemberStatement(MemberNo: Code[50]; "filter": Text; var BigText: BigText) exitString: Text
    // var
    //     Filename: Text[100];
    //     Convert: dotnet Convert;
    //     Path: dotnet Path;
    //     _File: dotnet File;
    //     FileAccess: dotnet FileAccess;
    //     FileMode: dotnet FileMode;
    //     MemoryStream: dotnet MemoryStream;
    //     FileStream: dotnet FileStream;
    //     Outputstream: OutStream;
    // begin

    //     objMember.Reset;
    //     objMember.SetRange(objMember."No.", MemberNo);


    //     if objMember.Find('-') then begin
    //         // objMember.SETFILTER("Date Filter", filter);
    //         Filename := Path.GetTempPath() + Path.GetRandomFileName();
    //         Report.SaveAsPdf(51516886, Filename, objMember);

    //         FileMode := 4;
    //         FileAccess := 1;

    //         FileStream := _File.Open(Filename, FileMode, FileAccess);

    //         MemoryStream := MemoryStream.MemoryStream();

    //         MemoryStream.SetLength(FileStream.Length);
    //         FileStream.Read(MemoryStream.GetBuffer(), 0, FileStream.Length);

    //         BigText.AddText((Convert.ToBase64String(MemoryStream.GetBuffer())));
    //         Message(Format(BigText));
    //         // exitString:=BigText;
    //         //MESSAGE(exitString);
    //         MemoryStream.Close();
    //         MemoryStream.Dispose();
    //         FileStream.Close();
    //         FileStream.Dispose();
    //         _File.Delete(Filename);

    //     end;
    // end;


    // procedure fnFosaStatement("Account No": Code[50]; path: Text[100])
    // var
    //     Filename: Text[100];
    // begin

    //     /*Filename := FILESPATH+path;
    //     IF EXISTS(Filename) THEN

    //       ERASE(Filename);*/
    //     Vendor.Reset;
    //     Vendor.SetRange(Vendor."No.", "Account No");

    //     if Vendor.Find('-') then begin
    //         //REPORT.SAVEASPDF(23,Filename,Vendor);
    //         Page.Run(26, Vendor);
    //     end;

    // end;


    // procedure fndividentstatement(No: Code[50]; Path: Text[100])
    // var
    //     filename: Text;
    //     "Member No": Code[50];
    // begin
    //     filename := FILESPATH + Path;
    //     if Exists(filename) then
    //         Erase(filename);
    //     objMember.Reset;
    //     objMember.SetRange(objMember."No.", No);

    //     if objMember.Find('-') then begin
    //         Report.SaveAsPdf(51516241, filename, objMember);

    //     end;
    // end;


    // procedure fnLoanGuranteed(MemberNo: Code[50]; var BigText: BigText)
    // var
    //     Filename: Text[100];
    //     Convert: dotnet Convert;
    //     Path: dotnet Path;
    //     _File: dotnet File;
    //     FileAccess: dotnet FileAccess;
    //     FileMode: dotnet FileMode;
    //     MemoryStream: dotnet MemoryStream;
    //     FileStream: dotnet FileStream;
    //     Outputstream: OutStream;
    // begin
    //     objMember.Reset;
    //     objMember.SetRange(objMember."No.", MemberNo);


    //     if objMember.Find('-') then begin
    //         //  objMember.SETFILTER("Date Filter", filter);
    //         Filename := Path.GetTempPath() + Path.GetRandomFileName();
    //         Report.SaveAsPdf(51516503, Filename, objMember);

    //         FileMode := 4;
    //         FileAccess := 1;

    //         FileStream := _File.Open(Filename, FileMode, FileAccess);

    //         MemoryStream := MemoryStream.MemoryStream();

    //         MemoryStream.SetLength(FileStream.Length);
    //         FileStream.Read(MemoryStream.GetBuffer(), 0, FileStream.Length);

    //         BigText.AddText((Convert.ToBase64String(MemoryStream.GetBuffer())));
    //         Message(Format(BigText));
    //         // exitString:=BigText;
    //         //MESSAGE(exitString);
    //         MemoryStream.Close();
    //         MemoryStream.Dispose();
    //         FileStream.Close();
    //         FileStream.Dispose();
    //         _File.Delete(Filename);

    //     end;
    // end;


    // procedure fnLoanRepaymentShedule("Loan No": Code[50]; path: Text[100])
    // var
    //     "Member No": Code[100];
    //     filename: Text[250];
    // begin
    //     filename := FILESPATH + path;
    //     if Exists(filename) then
    //         Erase(filename);
    //     objLoanRegister.Reset;
    //     objLoanRegister.SetRange(objLoanRegister."Loan  No.", "Loan No");

    //     if objLoanRegister.Find('-') then begin
    //         Report.SaveAsPdf(51516477, filename, objLoanRegister);
    //         Message(FILESPATH);
    //     end;
    // end;


    // procedure fnLoanGurantorsReport(MemberNo: Code[50]; var BigText: BigText)
    // var
    //     Filename: Text[100];
    //     Convert: dotnet Convert;
    //     Path: dotnet Path;
    //     _File: dotnet File;
    //     FileAccess: dotnet FileAccess;
    //     FileMode: dotnet FileMode;
    //     MemoryStream: dotnet MemoryStream;
    //     FileStream: dotnet FileStream;
    //     Outputstream: OutStream;
    // begin
    //     objMember.Reset;
    //     objMember.SetRange(objMember."No.", MemberNo);


    //     if LoansGuaranteeDetails.Find('-') then begin
    //         //  objMember.SETFILTER("Date Filter", filter);
    //         Filename := Path.GetTempPath() + Path.GetRandomFileName();
    //         Report.SaveAsPdf(51516504, Filename, objMember);
    //         FileMode := 4;
    //         FileAccess := 1;

    //         FileStream := _File.Open(Filename, FileMode, FileAccess);

    //         MemoryStream := MemoryStream.MemoryStream();

    //         MemoryStream.SetLength(FileStream.Length);
    //         FileStream.Read(MemoryStream.GetBuffer(), 0, FileStream.Length);

    //         BigText.AddText((Convert.ToBase64String(MemoryStream.GetBuffer())));
    //         Message(Format(BigText));
    //         // exitString:=BigText;
    //         //MESSAGE(exitString);
    //         MemoryStream.Close();
    //         MemoryStream.Dispose();
    //         FileStream.Close();
    //         FileStream.Dispose();
    //         _File.Delete(Filename);

    //     end;
    // end;


    // procedure fnAtmApplications(Account: Code[100])
    // begin
    //     // objAtmapplication.INIT;
    //     // objAtmapplication.Name:=Account;
    //     // objAtmapplication."Maximun Allocation %":=TODAY;
    //     // objAtmapplication."Total Allocation":=objAtmapplication."Total Allocation"::"0";
    //     // objAtmapplication."Date Created":=objAtmapplication."Date Created"::"0";
    //     // objAtmapplication.VALIDATE(objAtmapplication.Name);
    //     // objAtmapplication.INSERT;
    // end;


    // procedure fnAtmBlocking(Account: Code[100]; ReasonForBlock: Text[250])
    // begin
    //     // objAtmapplication.RESET;
    //     // objAtmapplication.SETRANGE(objAtmapplication.Name,Account);
    //     // IF objAtmapplication.FIND('-') THEN BEGIN
    //     // objAtmapplication."Date Created":=objAtmapplication."Date Created"::"2";
    //     // objAtmapplication."Document No":=ReasonForBlock;
    //     // objAtmapplication.MODIFY;
    //     // END;
    // end;


    // procedure fnChangePassword(memberNumber: Code[100]; currentPass: Text; newPass: Text) updated: Boolean
    // var
    //     EncryptionManagement: Codeunit "Cryptography Management";
    //     InStream: InStream;
    //     PasswordText: Text;
    //     OutStream: OutStream;
    //     DecryptPassword: Text;
    // begin
    //     sms := 'You have successfully updated your password. Your new password is: ' + newPass;
    //     // updated:=FALSE;
    //     // objMember.RESET;
    //     // objMember.SETRANGE(objMember."No.", memberNumber);
    //     // objMember.SETRANGE(objMember.Password, currentPass);
    //     // IF objMember.FIND('-') THEN
    //     //  objMember.Password :=newPass;
    //     //  phoneNumber:= objMember."Phone No.";
    //     //   FAccNo := objMember."FOSA Account No.";
    //     // updated := objMember.MODIFY;
    //     // MESSAGE('Successful pass change');
    //     // FnSMSMessage(FAccNo,phoneNumber,sms);
    //     // EXIT(updated);
    //     Online.Reset;
    //     Online.SetRange("User Name", memberNumber);
    //     if Online.Find('-') then begin
    //         Online.CalcFields(Online.Password);
    //         Online.Password.CreateInstream(InStream);
    //         InStream.Read(PasswordText);
    //         if EncryptionManagement.IsEncryptionPossible then
    //             DecryptPassword := Decrypt(PasswordText);

    //         if DecryptPassword = currentPass then begin
    //             Online."User Name" := Online."User Name";
    //             if EncryptionManagement.IsEncryptionPossible then
    //                 newPass := EncryptionManagement.Encrypt(newPass);
    //             Online.Password.CreateOutstream(OutStream);
    //             OutStream.Write(newPass);
    //             Online.Modify;
    //             updated := true;
    //         end
    //         else begin
    //             Error('Previous password is not correct');
    //         end;
    //     end;
    // end;


    // procedure fnTotalRepaidGraph(Mno: Code[10]; year: Code[10]) total: Decimal
    // begin
    //     objMember.Reset;
    //     objMember.SetRange("No.", Mno);
    //     if objMember.Find('-') then begin

    //         objMember.SetFilter("Date Filter", '0101' + year + '..1231' + year);
    //         //objMember.CALCFIELDS("Current Shares");
    //         total := objMember."Total Repayments";
    //         Message('current repaid is %1', total);
    //     end;
    // end;


    // procedure fnCurrentShareGraph(Mno: Code[10]; year: Code[10]) total: Decimal
    // begin
    //     objMember.Reset;
    //     objMember.SetRange("No.", Mno);
    //     if objMember.Find('-') then begin

    //         objMember.SetFilter("Date Filter", '0101' + year + '..1231' + year);
    //         objMember.CalcFields("Current Shares");
    //         total := objMember."Current Shares";
    //         Message('current shares is %1', total);
    //     end;
    // end;


    // procedure fnTotalDepositsGraph(Mno: Code[10]; year: Code[10]) total: Decimal
    // begin
    //     // objMember.RESET;
    //     // objMember.SETRANGE("No.", Mno);
    //     // IF objMember.FIND('-') THEN BEGIN
    //     //
    //     // objMember.SETFILTER("Date Filter",'0101'+year+'..1231'+year);
    //     // objMember.CALCFIELDS("Share Cap");
    //     // total:=objMember."Share Cap";
    //     // MESSAGE ('current deposits is %1', total);
    //     // END;
    // end;


    // procedure FnRegisterKin("Full Names": Text; Relationship: Text; "ID Number": Code[10]; "Phone Contact": Code[10]; Address: Text; Idnomemberapp: Code[10])
    // begin
    //     begin
    //         objRegMember.Reset;
    //         objNextKin.Reset;
    //         objNextKin.Init();
    //         objRegMember.SetRange("ID No.", Idnomemberapp);
    //         if objRegMember.Find('-') then begin
    //             objNextKin."Account No" := objRegMember."No.";
    //             objNextKin.Name := "Full Names";
    //             objNextKin.Relationship := Relationship;
    //             objNextKin."ID No." := "ID Number";
    //             objNextKin.Telephone := "Phone Contact";
    //             objNextKin.Address := Address;
    //             objNextKin.Insert(true);
    //         end;
    //     end;
    // end;


    // procedure FnMemberApply("First Name": Code[30]; "Mid Name": Code[30]; "Last Name": Code[30]; "PO Box": Text; Residence: Code[30]; "Postal Code": Text; Town: Code[30]; "Phone Number": Code[30]; Email: Text; "ID Number": Code[30]; "Branch Code": Code[30]; "Branch Name": Code[30]; "Account Number": Code[30]; Gender: Option; "Marital Status": Option; "Account Category": Option; "Application Category": Option; "Customer Group": Code[30]; "Employer Name": Code[30]; "Date of Birth": Date) num: Text
    // begin
    //     begin

    //         objRegMember.Reset;
    //         objRegMember.SetRange("ID No.", "ID Number");
    //         if objRegMember.Find('-') then begin
    //             Message('already registered');
    //         end
    //         else begin
    //             objRegMember.Init;
    //             objRegMember.Name := "First Name" + ' ' + "Mid Name" + ' ' + "Last Name";
    //             objRegMember.Address := "PO Box";
    //             objRegMember."Address 2" := Residence;
    //             objRegMember."Postal Code" := "Postal Code";
    //             objRegMember.Town := Town;
    //             objRegMember."Mobile Phone No" := "Phone Number";
    //             objRegMember."E-Mail (Personal)" := Email;
    //             objRegMember."Date of Birth" := "Date of Birth";
    //             objRegMember."ID No." := "ID Number";
    //             objRegMember."Bank Code" := "Branch Code";
    //             objRegMember."Bank Name" := "Branch Name";
    //             objRegMember."Bank Account No" := "Account Number";
    //             objRegMember.Gender := Gender;
    //             objRegMember."Created By" := UserId;
    //             objRegMember."Global Dimension 1 Code" := 'BOSA';
    //             objRegMember."Date of Registration" := Today;
    //             objRegMember.Status := objRegMember.Status::Open;
    //             objRegMember."Application Category" := "Application Category";
    //             objRegMember."Account Category" := "Account Category";
    //             objRegMember."Marital Status" := "Marital Status";
    //             objRegMember."Employer Name" := "Employer Name";
    //             objRegMember."Customer Posting Group" := "Customer Group";
    //             objRegMember.Insert(true);
    //         end;


    //         //FnRegisterKin('','','','','');
    //     end;
    // end;

    // local procedure FnFreeShares("Member No": Text) Shares: Text
    // begin
    //     begin
    //         begin
    //             GenSetup.Get();
    //             FreeShares := 0;
    //             glamount := 0;

    //             objMember.Reset;
    //             objMember.SetRange(objMember."No.", "Member No");
    //             if objMember.Find('-') then begin
    //                 objMember.CalcFields("Current Shares");
    //                 LoansGuaranteeDetails.Reset;
    //                 LoansGuaranteeDetails.SetRange(LoansGuaranteeDetails."Member No", objMember."No.");
    //                 LoansGuaranteeDetails.SetRange(LoansGuaranteeDetails.Substituted, false);
    //                 if LoansGuaranteeDetails.Find('-') then begin
    //                     repeat
    //                         glamount := glamount + LoansGuaranteeDetails."Amont Guaranteed";
    //                     //MESSAGE('Member No %1 Account no %2',Members."No.",glamount);
    //                     until LoansGuaranteeDetails.Next = 0;
    //                 end;
    //                 FreeShares := (objMember."Current Shares" * GenSetup."Contactual Shares (%)") - glamount;
    //                 Shares := Format(FreeShares, 0, '<Precision,2:2><Integer><Decimals>');
    //             end;
    //         end;
    //     end;
    // end;


    // procedure FnStandingOrders(BosaAcNo: Code[30]; SourceAcc: Code[50]; frequency: Text; Duration: Text; DestAccNo: Code[30]; StartDate: Date; Amount: Decimal; DestAccType: Option)
    // begin
    //     objStandingOrders.Init();
    //     objStandingOrders."BOSA Account No." := BosaAcNo;
    //     objStandingOrders."Source Account No." := SourceAcc;
    //     objStandingOrders.Validate(objStandingOrders."Source Account No.");
    //     if Format(freq) = '' then
    //         Evaluate(freq, frequency);
    //     objStandingOrders.Frequency := freq;
    //     if Format(dur) = '' then
    //         Evaluate(dur, Duration);
    //     objStandingOrders.Duration := dur;
    //     objStandingOrders."Destination Account No." := DestAccNo;
    //     objStandingOrders.Validate(objStandingOrders."Destination Account No.");
    //     objStandingOrders."Destination Account Type" := DestAccType;
    //     objStandingOrders.Amount := Amount;
    //     objStandingOrders."Effective/Start Date" := StartDate;
    //     objStandingOrders.Validate(objStandingOrders.Duration);
    //     objStandingOrders.Status := objStandingOrders.Status::Open;
    //     objStandingOrders.Insert(true);
    //     objMember.Reset;
    //     objMember.SetRange(objMember."No.", BosaAcNo);
    //     if objMember.Find('-') then begin
    //         phoneNumber := objMember."Phone No.";
    //         sms := 'You have created a standing order of amount : ' + Format(Amount) + ' from Account ' + SourceAcc + ' start date: '
    //               + Format(StartDate) + '. Thanks for using Swizzsoft SACCO Portal.';
    //         FnSMSMessage(SourceAcc, phoneNumber, sms);
    //         //MESSAGE('All Cool');
    //     end
    // end;


    // procedure FnUpdateMonthlyContrib("Member No": Code[30]; "Updated Fig": Decimal)
    // begin
    //     objMember.Reset;
    //     objMember.SetRange(objMember."No.", "Member No");

    //     if objMember.Find('-') then begin
    //         phoneNumber := objMember."Phone No.";
    //         FAccNo := objMember."FOSA Account No.";
    //         objMember."Monthly Contribution" := "Updated Fig";
    //         objMember.Modify;
    //         sms := 'You have adjusted your monthly contributions to: ' + Format("Updated Fig") + ' account number ' + FAccNo +
    //               '. Thank you for using Swizzsoft Sacco Portal';
    //         FnSMSMessage(FAccNo, phoneNumber, sms);

    //         //MESSAGE('Updated');
    //     end
    // end;


    // procedure FnSMSMessage(accfrom: Text[30]; phone: Text[20]; message: Text[250])
    // begin

    //     SMSMessages.Reset;
    //     if SMSMessages.Find('+') then begin
    //         iEntryNo := SMSMessages."Entry No";
    //         iEntryNo := iEntryNo + 1;
    //     end
    //     else begin
    //         iEntryNo := 1;
    //     end;
    //     SMSMessages.Init;
    //     SMSMessages."Entry No" := iEntryNo;
    //     //SMSMessages."Batch No":=documentNo;
    //     //SMSMessages."Document No":=documentNo;
    //     SMSMessages."Account No" := accfrom;
    //     SMSMessages."Date Entered" := Today;
    //     SMSMessages."Time Entered" := Time;
    //     SMSMessages.Source := 'WEBPORTAL';
    //     SMSMessages."Entered By" := UserId;
    //     SMSMessages."Sent To Server" := SMSMessages."sent to server"::No;
    //     SMSMessages."SMS Message" := message;
    //     SMSMessages."Telephone No" := phone;
    //     if SMSMessages."Telephone No" <> '' then
    //         SMSMessages.Insert;
    // end;


    // procedure FnLoanApplication(Member: Code[30]; LoanProductType: Code[10]; AmountApplied: Decimal; LoanPurpose: Code[30]; RepaymentFrequency: Integer; LoanConsolidation: Boolean; LoanBridging: Boolean; LoanRefinancing: Boolean) Result: Boolean
    // begin
    //     // objMember.RESET;
    //     // objMember.SETRANGE(objMember."No.", Member);
    //     // IF objMember.FIND('-') THEN BEGIN
    //     //
    //     //   objLoanApplication.RESET;
    //     //   objLoanApplication.INIT;
    //     //
    //     //   objLoanApplication.Type:=objLoanApplication.Type::"Loan Form";
    //     //    objLoanApplication.INSERT(TRUE);
    //     //   objLoanApplication."Account No":=Member;
    //     //   objLoanApplication.VALIDATE(objLoanApplication."Account No");
    //     //   objLoanApplication.VALIDATE(No);
    //     //
    //     //   objLoanApplication."Loan Type" :=LoanProductType;
    //     //
    //     //   objLoanApplication."Captured by":=USERID;
    //     //   objLoanApplication.Amount:=AmountApplied;
    //     //   objLoanApplication."Purpose of loan":=LoanPurpose;
    //     //   objLoanApplication."Repayment Period":=RepaymentFrequency;
    //     //   MESSAGE(objAtmapplication."Form No");
    //     //   objLoanApplication.VALIDATE("Loan Product Type");
    //     //   objLoanApplication."Loan Bridging":=LoanBridging;
    //     //   objLoanApplication."Loan Consolidation":=LoanConsolidation;
    //     //   objLoanApplication."Loan Refinancing":=LoanRefinancing;
    //     //   objLoanApplication.VALIDATE("Repayment Period");
    //     //   //objLoanApplication.VALIDATE("Loan Bridging");
    //     //   //objLoanApplication.VALIDATE("Loan Consolidation");
    //     //  // objLoanApplication.VALIDATE("Loan Refinancing");
    //     //   objLoanApplication.Submited:=TRUE;
    //     //   // objLoanApplication.INSERT(TRUE);
    //     //  objLoanApplication.MODIFY;
    //     //
    //     //
    //     // END;
    //     //
    //     // //***********insert******************//
    //     // objLoanApplication.RESET;
    //     // objLoanApplication.SETRANGE(objLoanApplication."Account No", Member);
    //     // objLoanApplication.SETRANGE(objLoanApplication.Type,objLoanApplication.Type::"Loan Form");
    //     // //objLoanApplication.SETCURRENTKEY("Capture Date");
    //     // IF objLoanApplication.FINDLAST THEN
    //     //   FormNo:=objLoanApplication.No;
    //     //   objLoanApplication.SETRANGE(objLoanApplication.No,FormNo);
    //     //   IF objLoanApplication.FIND('-') THEN
    //     //     BEGIN
    //     //       objLoanRegister.INIT;
    //     //   MESSAGE(FormNo);
    //     //        objLoanRegister.INSERT(TRUE);
    //     //       objLoanRegister.Source:=objLoanRegister.Source::BOSA;
    //     //       //objLoanRegister.Installments:=RepaymentFrequency;
    //     //       MESSAGE(FORMAT(RepaymentFrequency));
    //     //       objLoanRegister."Captured By":=USERID;
    //     //       objLoanRegister."Select From Forms":=FormNo;
    //     //
    //     //      MESSAGE(objLoanRegister."Loan  No.");
    //     //       objLoanRegister.VALIDATE("Select From Forms");
    //     //      // objLoanRegister."Original Loan":=TRUE;
    //     //        objLoanRegister.VALIDATE("Requested Amount");
    //     //       objLoanRegister."Loan Status":=objLoanRegister."Loan Status"::Application;
    //     //      objLoanRegister.MODIFY;
    //     //       MESSAGE('here');
    //     //        Result:=TRUE;
    //     //        phoneNumber:=objMember."Phone No.";
    //     //        ClientName := objMember."FOSA Account No.";
    //     //        sms:='We have received your '+LoanProductType+' loan application of  amount : ' +FORMAT(AmountApplied)+
    //     //        '. We are processing your loan, you will hear from us soon. Thanks for using KENTOURS SACCO  Portal.';
    //     //        FnSMSMessage(ClientName,phoneNumber,sms);
    //     //        PortaLuPS.INIT;
    //     //       // PortaLuPS.INSERT(TRUE);
    //     //       objLoanRegister.RESET;
    //     //       objLoanRegister.SETRANGE("Client Code", Member);
    //     //       objLoanRegister.SETCURRENTKEY("Application Date");
    //     //       objLoanRegister.ASCENDING(TRUE);
    //     //       IF objLoanRegister.FINDLAST
    //     //         THEN
    //     //
    //     //          PortaLuPS.LaonNo:=objLoanRegister."Loan  No.";
    //     //        PortaLuPS.RequestedAmount:=AmountApplied;
    //     //        PortaLuPS.INSERT;
    //     //        //MESSAGE('All Cool');
    //     //      //MESSAGE('Am just cool');
    //     // END;
    // end;


    // procedure FnDepositsStatement("Account No": Code[30]; path: Text[100])
    // var
    //     Filename: Text[100];
    // begin
    //     Filename := FILESPATH + path;
    //     Message(FILESPATH);
    //     if Exists(Filename) then
    //         Erase(Filename);
    //     objMember.Reset;
    //     objMember.SetRange(objMember."No.", "Account No");

    //     if objMember.Find('-') then begin
    //         Report.SaveAsPdf(51516354, Filename, objMember);
    //     end;
    // end;


    // procedure FnLoanStatement(MemberNo: Code[50]; var BigText: BigText)
    // var
    //     Filename: Text[100];
    //     Convert: dotnet Convert;
    //     Path: dotnet Path;
    //     _File: dotnet File;
    //     FileAccess: dotnet FileAccess;
    //     FileMode: dotnet FileMode;
    //     MemoryStream: dotnet MemoryStream;
    //     FileStream: dotnet FileStream;
    //     Outputstream: OutStream;
    // begin
    //     objMember.Reset;
    //     objMember.SetRange(objMember."No.", MemberNo);


    //     if objMember.Find('-') then begin
    //         //  objMember.SETFILTER("Date Filter", filter);
    //         Filename := Path.GetTempPath() + Path.GetRandomFileName();
    //         Report.SaveAsPdf(50014, Filename, objMember);

    //         FileMode := 4;
    //         FileAccess := 1;

    //         FileStream := _File.Open(Filename, FileMode, FileAccess);

    //         MemoryStream := MemoryStream.MemoryStream();

    //         MemoryStream.SetLength(FileStream.Length);
    //         FileStream.Read(MemoryStream.GetBuffer(), 0, FileStream.Length);

    //         BigText.AddText((Convert.ToBase64String(MemoryStream.GetBuffer())));
    //         Message(Format(BigText));
    //         // exitString:=BigText;
    //         //MESSAGE(exitString);
    //         MemoryStream.Close();
    //         MemoryStream.Dispose();
    //         FileStream.Close();
    //         FileStream.Dispose();
    //         _File.Delete(Filename);

    //     end;
    // end;


    // procedure Fnlogin(username: Code[20]; password: Text) status: Boolean
    // var
    //     EncryptionManagement: Codeunit "Cryptography Management";
    //     InStream: InStream;
    //     PasswordText: Text;
    //     DecrypText: Text;
    // begin

    //     Online.Reset;
    //     Online.SetRange("User Name", username);
    //     // Online.SETRANGE("User Type", 'USER');
    //     if Online.Find('-') then begin

    //         Online.CalcFields(Password);
    //         Online.Password.CreateInstream(InStream);
    //         InStream.Read(PasswordText);
    //         if EncryptionManagement.IsEncryptionPossible then
    //             DecrypText := Decrypt(PasswordText);
    //         //EXIT(PasswordText);
    //         Message(DecrypText);
    //         if DecrypText = password then
    //             status := true
    //         else
    //             status := true;
    //     end;
    // end;


    // procedure FnmemberInfo(MemberNo: Code[20]) info: Text
    // begin
    //     objMember.Reset;
    //     objMember.SetRange(objMember."No.", MemberNo);
    //     if objMember.Find('-') then begin
    //         info := objMember."No." + '.' + ':' + objMember.Name + '.' + ':' + objMember."E-Mail (Personal)" + '.' + ':' + objMember."Employer Name" + '.' + ':' + Format(objMember."Account Category") + '.' + ':' + objMember."Mobile Phone No"
    //         + '.' + ':' + objMember."ID No." + '.' + ':' + objMember."ID No." + ':' + objMember."ID No." + ':' + objMember."Bank Branch Code";
    //     end
    //     else
    //         objMember.Reset;
    //     objMember.SetRange(objMember."ID No.", MemberNo);
    //     if objMember.Find('-') then begin
    //         info := objMember."No." + '.' + ':' + objMember.Name + '.' + ':' + objMember."E-Mail" + '.' + ':' + objMember."Employer Name" + '.' + ':' + Format(objMember."Account Category") + '.' + ':' + objMember."Mobile Phone No"
    //         + '.' + ':' + objMember."Bank Code" + '.' + ':' + objMember."Bank Account No." + '.' + ':' + objMember."ID No." + '.' + ':' + objMember."Bank Branch Code";

    //     end;
    // end;


    // procedure fnAccountInfo(Memberno: Code[20]) info: Text
    // begin
    //     objMember.Reset;
    //     objMember.SetRange(objMember."No.", Memberno);

    //     if objMember.Find('-') then begin
    //         objMember.CalcFields("Shares Retained", "Total Committed Shares");
    //         objMember.CalcFields("Current Shares", "Share Capital B Class", "Jiokoe Savings");
    //         //objMember.CALCFIELDS("Demand Savings", "Insurance Fund", Stocks);
    //         //objMember.CALCFIELDS("Share Cap", "Dividend Amount", "Un-allocated Funds");
    //         info := Format(ROUND(objMember."Current Savings", 0.01, '>')) + ':' + Format(ROUND(objMember."Shares Retained", 0.01, '>')) + ':' + Format(ROUND(objMember."Current Shares", 0.01, '>')) + ':' + Format(ROUND(objMember."Jiokoe Savings", 0.01, '>')) + ':'
    //         + Format(ROUND(objMember."Dividend Amount", 0.01, '>'))
    //         + ':' + Format(ROUND(objMember."Current Shares" - objMember."Total Committed Shares", 0.01, '>')) + ':'
    //         + Format(ROUND(objMember."Dividend Amount", 0.01, '>')) + ':' + Format(ROUND(objMember."Insurance Fund", 0.01, '>')) + ':'
    //         + Format(ROUND(objMember."Outstanding Balance", 0.01, '>'));
    //     end;
    // end;


    // procedure fnloaninfo(Memberno: Code[20]) info: Text
    // begin
    //     objMember.Reset;
    //     objMember.SetRange(objMember."No.", Memberno);
    //     if objMember.Find('-') then begin
    //         objMember.CalcFields("Outstanding Balance");
    //         objMember.CalcFields("Outstanding Interest");
    //         info := Format(objMember."Outstanding Balance") + ':' + Format(objMember."Outstanding Interest");
    //     end;
    // end;


    // procedure fnLoans(MemberNo: Code[20]) loans: Text
    // begin
    //     objLoanRegister.Reset;
    //     objLoanRegister.SetRange("Client Code", MemberNo);
    //     //objLoanRegister.SETRANGE("Loan Status",objLoanRegister."Loan Status"::Appraisal);
    //     //objLoanRegister.SETRANGE("Loan Status",objLoanRegister."Loan Status"::Approval1);
    //     //objLoanRegister.SETRANGE("Loan Status",objLoanRegister."Loan Status"::Approved);
    //     //objLoanRegister.SETRANGE("Loan Status",objLoanRegister."Loan Status"::"Being Repaid");
    //     objLoanRegister.SetFilter("Loan Product Type Name", '');
    //     objLoanRegister.SetCurrentkey("Outstanding Balance");
    //     objLoanRegister.Ascending(false);
    //     if objLoanRegister.Find('-') then begin


    //         repeat

    //             // Loanperiod:=Kentoursfactory.KnGetCurrentPeriodForLoan(objLoanRegister."Loan  No.");

    //             objLoanRegister.CalcFields("Outstanding Balance");
    //             loans := loans + objLoanRegister."Loan Product Type Name" + ':' + Format(objLoanRegister."Outstanding Balance") + ':' + Format(objLoanRegister."Loan Status") + ':' + Format(objLoanRegister.Installments) + ':'
    //             + Format(objLoanRegister.Installments - Loanperiod) + ':' + Format(objLoanRegister."Balance BF") + ':' + Format(objLoanRegister."Requested Amount") + '::';

    //         until
    //           objLoanRegister.Next = 0;

    //     end;
    // end;


    // procedure FnloanCalc(LoanAmount: Decimal; RepayPeriod: Integer; LoanCode: Code[30]) text: Text
    // begin
    //     Loansetup.Reset;
    //     Loansetup.SetRange(Code, LoanCode);

    //     if Loansetup.Find('-') then begin

    //         if Loansetup."Repayment Method" = Loansetup."repayment method"::Amortised then begin
    //             // LoansRec.TESTFIELD(LoansRec.Interest);
    //             // LoansRec.TESTFIELD(LoansRec.Installments);
    //             TotalMRepay := ROUND((Loansetup."Interest rate" / 12 / 100) / (1 - Power((1 + (Loansetup."Interest rate" / 12 / 100)), -(RepayPeriod))) * (LoanAmount), 0.0001, '>');
    //             LInterest := ROUND(LBalance / 100 / 12 * InterestRate, 0.0001, '>');
    //             LPrincipal := TotalMRepay - LInterest;
    //         end;

    //         if Loansetup."Repayment Method" = Loansetup."repayment method"::"Straight Line" then begin
    //             LoansRec.TestField(LoansRec.Interest);
    //             LoansRec.TestField(LoansRec.Installments);
    //             LPrincipal := LoanAmount / RepayPeriod;
    //             LInterest := (Loansetup."Interest rate" / 12 / 100) * LoanAmount / RepayPeriod;
    //         end;

    //         if Loansetup."Repayment Method" = Loansetup."repayment method"::"Reducing Balance" then begin
    //             //LoansRec.TESTFIELD(LoansRec.Interest);
    //             //LoansRec.TESTFIELD(LoansRec.Installments);
    //             Message('type is %1', LoanCode);
    //             Date := Today;
    //             //IF RepayPeriod>Loansetup."Band I Maximum" THEN BEGIN
    //             Message('HERE');
    //             TotalMRepay := ROUND((Loansetup."Interest rate" / 12 / 100) / (1 - Power((1 + (Loansetup."Interest rate" / 12 / 100)), -(RepayPeriod))) * (LoanAmount), 0.0001, '>');
    //             repeat
    //                 LInterest := ROUND(LoanAmount * Loansetup."Interest rate" / 12 / 100, 0.0001, '>');
    //                 LPrincipal := TotalMRepay - LInterest;
    //                 LoanAmount := LoanAmount - LPrincipal;
    //                 RepayPeriod := RepayPeriod - 1;

    //                 text := text + Format(Date) + '!!' + Format(ROUND(LPrincipal)) + '!!' + Format(ROUND(LInterest)) + '!!' + Format(ROUND(TotalMRepay)) + '!!' + Format(ROUND(LoanAmount)) + '??';
    //                 Date := CalcDate('+1M', Date);

    //             until RepayPeriod = 0;
    //         end
    //         //
    //     end;
    //     if Loansetup."Repayment Method" = Loansetup."repayment method"::Constants then begin
    //         LoansRec.TestField(LoansRec.Repayment);
    //         if LBalance < LoansRec.Repayment then
    //             LPrincipal := LBalance
    //         else
    //             LPrincipal := LoansRec.Repayment;
    //         LInterest := LoansRec.Interest;
    //     end;



    //     //END;

    //     //EXIT(Amount);
    //     //END;
    //     //END;
    // end;


    // procedure Fnloanssetup() loanType: Text
    // begin
    //     Loansetup.Reset;
    //     begin
    //         loanType := '';
    //         repeat
    //             loanType := Format(Loansetup.Code) + ':' + Loansetup."Product Description" + ':::' + loanType;
    //         until Loansetup.Next = 0;
    //     end;
    // end;


    // procedure fnLoanDetails(Loancode: Code[20]) loandetail: Text
    // begin
    //     Loansetup.Reset;
    //     //Loansetup.SETRANGE(Code, Loancode);
    //     if Loansetup.Find('-') then begin
    //         repeat
    //             loandetail := loandetail + Loansetup."Product Description" + '!!' + Format(Loansetup."Repayment Method") + '!!' + Format(Loansetup."Max. Loan Amount") + '!!' + Format(Loansetup."Instalment Period") + '!!' + Format(Loansetup."Interest rate") + '!!'
    //             + Format(Loansetup."Repayment Frequency") + '??';
    //         until Loansetup.Next = 0;
    //     end;
    // end;


    // procedure fnFeedback(No: Code[20]; Comment: Text[200])
    // begin
    //     //
    // end;


    // procedure fnLoansPurposes() LoanType: Text
    // begin
    //     LoansPurpose.Reset;
    //     begin
    //         LoanType := '';
    //         repeat
    //             LoanType := Format(LoansPurpose.Code) + ':' + LoansPurpose.Description + ':::' + LoanType;
    //         until LoansPurpose.Next = 0;
    //     end;
    // end;


    // procedure fnReplys(No: Code[20]) text: Text
    // begin
    //     // feedback.RESET;
    //     // feedback.SETRANGE(No, No);
    //     // feedback.SETCURRENTKEY(Entry);
    //     // feedback.ASCENDING(FALSE);
    //     // IF feedback.FIND('-') THEN BEGIN
    //     //   REPEAT
    //     //      IF(feedback.Reply ='') THEN BEGIN
    //     //
    //     //  END ELSE
    //     //     text:=text+FORMAT(feedback.DatePosted)+'!!'+feedback.Portalfeedback+'!!'+ feedback.Reply+'??';
    //     // UNTIL feedback.NEXT=0;
    //     // END;
    // end;


    // procedure FnLoanfo(MemberNo: Code[20]) dividend: Text
    // begin
    //     DivProg.Reset;
    //     DivProg.SetRange("Member No", MemberNo);
    //     if DivProg.Find('-') then begin
    //         repeat
    //             if DivProg."Gross Dividends" < 1 then DivProg."Gross Dividends" := -1 * DivProg."Gross Dividends";
    //             if DivProg."Net Dividends" < 1 then DivProg."Net Dividends" := -1 * DivProg."Net Dividends";
    //             if DivProg."Witholding Tax" < 1 then DivProg."Witholding Tax" := -1 * DivProg."Witholding Tax";
    //             if DivProg."Qualifying Shares" < 1 then DivProg."Qualifying Shares" := -1 * DivProg."Qualifying Shares";
    //             if DivProg.Shares < 1 then DivProg.Shares := -1 * DivProg.Shares;
    //             dividend := dividend + Format(DivProg.Date) + ':::' + Format(DivProg."Gross Dividends") + ':::' + Format(DivProg."Witholding Tax") + ':::' + Format(DivProg."Net Dividends") + ':::' + Format(DivProg."Qualifying Shares") + ':::'
    //             + Format(DivProg.Shares) + '::::';
    //         until DivProg.Next = 0;
    //     end;
    // end;


    // procedure fnGetAtms(Idnumber: Code[20]) return: Text
    // begin
    //     // Vendor.RESET;
    //     // objAtmapplication.SETRANGE("ID No.", Idnumber);
    //     // IF objAtmapplication.FIND('-') THEN BEGIN
    //     //  REPEAT
    //     //    return:=objAtmapplication."No."+':::'+return;
    //     //    UNTIL
    //     //    objAtmapplication.NEXT=0;
    //     //    END;
    // end;


    // procedure fnInserBiodata(FirstName: Text; MiddleName: Text; LastName: Text; Gender: Integer; NextOfKInR: Boolean; IdNumber: Code[50]; shares: Decimal; NextofkinID: Code[50]; NextofkinRelationship: Text; NextofkinPhone: Code[50]; Nextofkinemail: Text; NextofkinDob: Date)
    // var
    //     NextOfKin: Record 51361;
    // begin
    //     if (NextOfKInR <> true) then begin
    //         MemberApplication.Init;
    //         MemberApplication."No." := NoSeriesMgt.GetNextNo('MEMBERSHIP', 0D, true);
    //         //MemberApplication.VALIDATE("No.");

    //         MemberApplication."First Name" := FirstName;
    //         MemberApplication."Middle Name" := MiddleName;
    //         MemberApplication."Last Name" := LastName;
    //         MemberApplication.Name := FirstName + ' ' + MiddleName + ' ' + LastName;
    //         MemberApplication.Validate(Name);

    //         MemberApplication.Gender := Gender;
    //         MemberApplication."ID No." := IdNumber;
    //         //MemberApplication.MODIFY;
    //         MemberApplication.Insert;
    //     end
    //     else begin

    //         MemberApplication.Reset;
    //         MemberApplication.SetRange("ID No.", IdNumber);
    //         if MemberApplication.Find('-') then begin
    //             NextOfKin.Init;
    //             NextOfKin."Account No" := MemberApplication."No.";
    //             NextOfKin.Name := FirstName;
    //             NextOfKin."ID No." := NextofkinID;
    //             NextOfKin."%Allocation" := shares;
    //             NextOfKin.Relationship := NextofkinRelationship;
    //             NextOfKin.Telephone := NextofkinPhone;
    //             NextOfKin.Email := Nextofkinemail;
    //             NextOfKin."Date of Birth" := NextofkinDob;
    //             NextOfKin.Insert;
    //         end;
    //     end;
    // end;


    // procedure fnInsertCommunicationDetails(email: Text; phone: Text; telePhone: Text; NextofKin: Boolean; IdNumber: Code[50])
    // begin
    //     MemberApplication.Reset;
    //     MemberApplication.SetRange("ID No.", IdNumber);
    //     if MemberApplication.Find('-') then begin
    //         if MemberApplication.Get(MemberApplication."No.") then
    //             //MemberApplication."No.":=MemberApplication."No.";
    //             MemberApplication."E-Mail (Personal)" := email;
    //         MemberApplication."Phone No." := phone;
    //         MemberApplication."Mobile Phone No" := telePhone;
    //         MemberApplication.Modify;
    //     end;
    // end;


    // procedure fnInsertWitness()
    // begin
    // end;


    // procedure fnInsertNxtofKin()
    // begin
    // end;


    // procedure fnInsertBankDetails(BankCode: Code[60]; BankBranch: Code[60]; BankAccountNo: Code[60]; idnumber: Code[40])
    // begin
    //     MemberApplication.Reset;
    //     MemberApplication.SetRange("ID No.", idnumber);
    //     if MemberApplication.Find('-') then begin
    //         MemberApplication."Bank Code" := BankCode;
    //         MemberApplication.Validate("Bank Code");
    //         MemberApplication."Bank Branch" := BankBranch;
    //         MemberApplication."Bank Account No" := BankAccountNo;
    //         MemberApplication.Modify;
    //     end;
    // end;


    // procedure fnInsertHistory(IdNo: Text; MaritalStatus: Option; Dob: Date; Nextofkin: Boolean; AccountIdnumber: Integer; krapin: Code[100])
    // begin
    //     MemberApplication.Reset;
    //     MemberApplication.SetRange("ID No.", IdNo);
    //     if MemberApplication.Find('-') then begin
    //         MemberApplication."ID No." := IdNo;
    //         MemberApplication."Marital Status" := MaritalStatus;
    //         MemberApplication."Date of Birth" := Dob;
    //         MemberApplication."KRA PIN" := krapin;
    //         MemberApplication.Validate("Date of Birth");
    //         MemberApplication.Modify;
    //     end;
    // end;


    // procedure fnInsertAddress(Town: Text; County: Text; PostalCode: Text; Address: Text; Employer: Boolean; AccountIdNumber: Code[60]; EmployerName: Code[80]; PayrollNumber: Code[60])
    // begin
    //     if Employer <> true then begin
    //         MemberApplication.Reset;
    //         MemberApplication.SetRange("ID No.", AccountIdNumber);
    //         if MemberApplication.Find('-') then begin
    //             MemberApplication.Town := Town;
    //             MemberApplication.County := County;
    //             MemberApplication."Postal Code" := PostalCode;
    //             MemberApplication.Validate("Postal Code");
    //             MemberApplication.Address := Address;

    //             MemberApplication.Modify;
    //         end;
    //     end

    //     else begin
    //         MemberApplication.Reset;
    //         MemberApplication.SetRange("ID No.", AccountIdNumber);
    //         if MemberApplication.Find('-') then begin
    //             MemberApplication."Employer Code" := EmployerName;
    //             MemberApplication.Validate("Employer Code");
    //             MemberApplication."Payroll No" := PayrollNumber;
    //             MemberApplication."Address 2" := Address;
    //             MemberApplication."Postal Code 2" := PostalCode;
    //             MemberApplication.Modify;
    //         end;
    //     end;
    // end;

    // local procedure fnInsertPosts(title: Text; Descritption: Text; Entry: Integer)
    // var
    //     Posts: Record 51973;
    // begin
    //     Posts.Init;
    //     Posts.Title := title;
    //     Posts.Description := Descritption;
    //     Posts.DateEntered := Today;
    //     Posts.Insert;

    //     if Entry <> -1 then
    //         Posts.Entry := Entry;
    //     Posts.Title := title;
    //     Posts.Description := Descritption;
    //     Posts.DateModified := Today;
    //     Posts.Modify;
    // end;

    // local procedure fnInsertEmploymentdetails()
    // begin
    // end;


    // procedure fnApplicationForm(MemberNo: Code[50]; "filter": Text; var BigText: BigText) exitString: Text
    // var
    //     Filename: Text[100];
    //     Convert: dotnet Convert;
    //     Path: dotnet Path;
    //     _File: dotnet File;
    //     FileAccess: dotnet FileAccess;
    //     FileMode: dotnet FileMode;
    //     MemoryStream: dotnet MemoryStream;
    //     FileStream: dotnet FileStream;
    //     Outputstream: OutStream;
    // begin

    //     MemberApplication.Reset;
    //     MemberApplication.SetRange("ID No.", MemberNo);


    //     if MemberApplication.Find('-') then begin
    //         // objMember.SETFILTER("Date Filter", filter);
    //         Filename := Path.GetTempPath() + Path.GetRandomFileName();
    //         Report.SaveAsPdf(51516507, Filename, MemberApplication);

    //         FileMode := 4;
    //         FileAccess := 1;

    //         FileStream := _File.Open(Filename, FileMode, FileAccess);

    //         MemoryStream := MemoryStream.MemoryStream();

    //         MemoryStream.SetLength(FileStream.Length);
    //         FileStream.Read(MemoryStream.GetBuffer(), 0, FileStream.Length);

    //         BigText.AddText((Convert.ToBase64String(MemoryStream.GetBuffer())));
    //         Message(Format(BigText));
    //         // exitString:=BigText;
    //         //MESSAGE(exitString);
    //         MemoryStream.Close();
    //         MemoryStream.Dispose();
    //         FileStream.Close();
    //         FileStream.Dispose();
    //         _File.Delete(Filename);

    //     end;
    // end;


    // procedure fnGetNextofkin(MemberNumber: Code[20]) return: Text
    // begin
    //     objNextKin.Reset;
    //     objNextKin.SetRange("Account No", MemberNumber);
    //     if objNextKin.Find('-') then begin
    //         repeat
    //             return := return + objNextKin.Name + ':' + objNextKin.Relationship + ':' + '.' + objNextKin.Address + ':' + '.' + Format(objNextKin."%Allocation") + '.' + ':' + Format(objNextKin."Entry No") + '::';
    //         until objNextKin.Next = 0;
    //     end;
    // end;


    // procedure fninsertchangeRequest(No: Code[80]; email: Text; phone: Code[40]; idnumber: Code[50]; mobile: Code[40]; name: Text; Change: Boolean; RequstNO: Code[60])
    // var
    //     ChangeReuqest: Record 51552;
    // begin
    //     if Change = false then begin
    //         ChangeReuqest.Init;
    //         ChangeReuqest.No := NoSeriesMgt.GetNextNo('CHANGEREQ', 0D, true);
    //         ChangeReuqest.Validate(No);
    //         ChangeReuqest.Type := ChangeReuqest.Type::"Backoffice Change";
    //         ChangeReuqest."Account No" := No;
    //         ChangeReuqest."Capture Date" := Today;
    //         ChangeReuqest.Validate("Account No");
    //         ChangeReuqest."Name(New Value)" := name;
    //         ChangeReuqest."Phone No.(New)" := phone;
    //         ChangeReuqest."ID No(New Value)" := idnumber;
    //         ChangeReuqest."Mobile No(New Value)" := mobile;
    //         ChangeReuqest."Email(New Value)" := email;
    //         ChangeReuqest.Insert;
    //     end;

    //     if Change = true then begin
    //         ChangeReuqest.Reset;
    //         ChangeReuqest.SetRange(No, RequstNO);
    //         if ChangeReuqest.Find('-') then begin
    //             ChangeReuqest."Email(New Value)" := email;
    //             ChangeReuqest."Name(New Value)" := name;
    //             ChangeReuqest."ID No(New Value)" := idnumber;
    //             ChangeReuqest."Phone No.(New)" := phone;
    //             ChangeReuqest."Mobile No(New Value)" := mobile;
    //             ChangeReuqest.Modify;
    //         end;
    //     end;

    // end;


    // procedure fnInsertChangrequestNOKModify(ReqNo: Integer; Modify: Boolean; Name: Text; RelationShip: Text; email: Text; idnumber: Code[100]; "%Allocation": Decimal; MemberNo: Code[100]; Dob: Date; Addnew: Boolean; NokNO: Integer)
    // var
    //     NokChangeRequest: Record 51940;
    //     NokLines: Record 51464;
    //     NokKinDetails: Record 51366;
    // begin
    //     if Addnew = true then begin

    //         if Modify = false then begin
    //             NokChangeRequest.Init;
    //             NokChangeRequest."Document No" := NoSeriesMgt.GetNextNo('NOKC', 0D, true);
    //             NokChangeRequest."Member No" := MemberNo;
    //             NokChangeRequest.Validate("Member No");
    //             NokChangeRequest."Captured On" := Today;
    //             NokChangeRequest.Insert;


    //             NokLines."Add New" := true;
    //             NokLines."Document No" := NokChangeRequest."Document No";
    //             NokLines."Account No" := MemberNo;
    //             NokLines."%Allocation(New)" := "%Allocation";
    //             NokLines.Name := Name;
    //             NokLines."Email(New)" := email;
    //             NokLines."Relationship(New)" := RelationShip;
    //             NokLines."ID No.(New)" := idnumber;
    //             NokLines.Insert;
    //         end
    //         else begin
    //             // NokChangeRequest.SETRANGE("Document No", ReqNo);
    //             //  IF NokChangeRequest.FIND('-') THEN BEGIN
    //             // //NokChangeRequest."Document No":=NoSeriesMgt.GetNextNo('NOKC',0D,TRUE);
    //             //
    //             //
    //             // //NokLines."Add New":=TRUE;
    //             // NokLines."Document No":=NokChangeRequest."Document No";
    //             // NokLines."Account No":=MemberNo;
    //             // NokLines."%Allocation(New)":="%Allocation";
    //             // NokLines.Name:=Name;
    //             // NokLines."Email(New)":=email;
    //             // NokLines."Relationship(New)":=RelationShip;
    //             // NokLines."ID No.(New)":=idnumber;
    //             // NokLines.MODIFY;
    //         end;
    //         //END;
    //     end
    //     else begin
    //         if Modify = false then begin
    //             NokChangeRequest.Init;
    //             NokChangeRequest."Document No" := NoSeriesMgt.GetNextNo('NOKC', 0D, true);
    //             NokChangeRequest."Member No" := MemberNo;
    //             NokChangeRequest.Validate("Member No");
    //             NokChangeRequest."Captured On" := Today;
    //             NokChangeRequest.Insert;
    //             NokKinDetails.Reset;
    //             NokKinDetails.SetRange("Entry No", NokNO);
    //             if NokKinDetails.Find('-') then begin

    //                 NokLines.Name := Name;
    //                 NokLines.Relationship := NokKinDetails.Relationship;
    //                 NokLines."%Allocation" := NokKinDetails."%Allocation";
    //                 NokLines.Address := NokKinDetails.Address;
    //                 NokLines.Email := NokKinDetails.Email;
    //                 NokLines.Beneficiary := NokKinDetails.Beneficiary;
    //                 NokLines."ID No." := NokKinDetails."ID No.";
    //                 //NokLines."Add New":=TRUE;
    //                 NokLines."Document No" := NokChangeRequest."Document No";
    //                 NokLines."Account No" := MemberNo;
    //                 NokLines."%Allocation(New)" := "%Allocation";
    //                 NokLines.Name := Name;
    //                 NokLines."Email(New)" := email;
    //                 NokLines."Relationship(New)" := RelationShip;
    //                 NokLines."ID No.(New)" := idnumber;
    //                 NokLines.Insert;
    //             end;
    //         end
    //         else begin

    //             NokLines.Reset;
    //             NokLines.SetRange("Entry No", ReqNo);
    //             if NokLines.Find('-') then begin
    //                 //NokLines."Add New":=TRUE;
    //                 //NokLines."Document No":=NokChangeRequest."Document No";
    //                 NokLines."Account No" := MemberNo;
    //                 NokLines."%Allocation(New)" := "%Allocation";
    //                 NokLines.Name := Name;
    //                 NokLines."Email(New)" := email;
    //                 NokLines."Relationship(New)" := RelationShip;
    //                 NokLines."ID No.(New)" := idnumber;
    //                 NokLines.Modify;
    //             end;
    //         end;
    //     end;
    // end;


    // procedure FnAdminlogin(username: Code[100]; password: Text) status: Boolean
    // var
    //     EncryptionManagement: Codeunit "Cryptography Management";
    //     InStream: InStream;
    //     PasswordText: Text;
    //     DecrypText: Text;
    // begin

    //     Online.Reset;
    //     Online.SetRange("User Name", username);
    //     Online.SetRange("User Type", 'ADMIN');
    //     if Online.Find('-') then begin

    //         Online.CalcFields(Password);
    //         Online.Password.CreateInstream(InStream);
    //         InStream.Read(PasswordText);
    //         if EncryptionManagement.IsEncryptionPossible then
    //             DecrypText := Decrypt(PasswordText);
    //         //EXIT(PasswordText);
    //         Message(DecrypText);
    //         if DecrypText = password then
    //             status := true
    //         else
    //             status := true;
    //     end;
    // end;
}

