#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 50179 "Check Off Advice"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Check Off Advice.rdlc';

    dataset
    {
        dataitem("Members Register"; Customer)
        {
            DataItemTableView = where(Status = filter(Active));
            RequestFilterFields = "No.", "Employer Code", "Date Filter";
            column(ReportForNavId_1; 1)
            {
            }
            column(MonthlyContribution_MembersRegister; "Members Register"."Monthly Contribution")
            {
            }
            column(No_MembersRegister; "Members Register"."No.")
            {
            }
            column(Name_MembersRegister; "Members Register".Name)
            {
            }
            column(EmployerCode_MembersRegister; "Members Register"."Employer Code")
            {
            }
            column(Total_Loan_Repayment; TRepayment)
            {
            }
            column(MonthlyAdvice; MonthlyAdvice)
            {
            }
            column(mothlcommitment; "Members Register"."Monthly Contribution")
            {
            }

            column(Share_Capital; scapital)
            {
            }

            column(Deposit_Contribution; DEPOSIT)
            {
            }
            column(Interest_Repayment; interest)
            {
            }
            column(Principle_Repayment; principle)
            {
            }
            column(EmployerName; LoansRec."Employer Name")
            {
            }
            column(Employercode; LoansRec."Employer Code")
            {
            }
            column(DOCNAME; DOCNAME)
            {
            }
            column(Employer_Name; employername)
            {
            }

            column(Development1; Development1)
            {

            }

            column(Development2; Development2)
            {

            }

            column(Development214; Development214)
            {

            }

            column(Investment; Investment)
            {

            }

            column(Schoolfees; Schoolfees)
            {

            }

            column(Emergency; Emergency)
            {

            }

            column(Instant; Instant)
            {

            }

            column(Company_Name; CompanyInfo.Name)
            {
            }
            column(Company_Address; CompanyInfo.Address)
            {
            }
            column(Company_Address_2; CompanyInfo."Address 2")
            {
            }
            column(Company_Phone_No; CompanyInfo."Phone No.")
            {
            }
            column(Company_Fax_No; CompanyInfo."Fax No.")
            {
            }
            column(Company_Picture; CompanyInfo.Picture)
            {
            }
            column(Company_Email; CompanyInfo."E-Mail")
            {
            }


            column(Junior_Monthly_Contribution; "Junior Monthly Contribution") { }

            trigger OnPreDataItem()
            begin


            end;

            trigger OnAfterGetRecord()
            begin
                DOCNAME := 'EMPLOYER CHECKOFF ADVICE';
                Prepayment := 0;
                IntRepayment := 0;
                AlphaSavings := 0;
                TRepayment := 0;
                PrincipalInterest := 0;
                MonthlyAdvice := 0;
                Juniorcontribution := 0;
                Likizo := 0;
                normloan := 0;
                College := 0;
                AssetL := 0;
                scfee := 0;
                emmerg := 0;
                Quick := 0;
                karibu := 0;
                Makeover := 0;
                Premium := 0;
                HOUSING := 0;
                DEPOSIT := 0;
                Development1 := 0;
                Development2 := 0;
                Development214 := 0;
                Emergency := 0;
                Flexi := 0;
                Schoolfees := 0;
                Investment := 0;
                Instant := 0;
                Children := 0;


                loans.Reset;
                loans.SetRange("Client Code", "Members Register"."No.");
                loans.SetRange("Recovery Mode", loans."Recovery Mode"::"Payroll Deduction");
                loans.SetFilter("Outstanding Balance", '>0');
                loans.SetFilter("Loan Disbursement Date", '>=%1', DMY2Date(1, 8, 2025));
                loans.SetRange(Posted, true);
                HasPayrollLoans := loans.FindFirst();

                if not HasPayrollLoans then
                    CurrReport.Skip();



                Cust.Reset;
                Cust.SetRange(Cust."No.", "Members Register"."No.");
                Cust.SetRange(Cust."Employer Code", "Members Register"."Employer Code");
                if Cust.Find('-') then begin
                    Gsetup.Get();
                    Cust.CalcFields(Cust."Shares Retained");
                    if Cust."Shares Retained" < Gsetup."Retained Shares" then
                        scapital := cust."Monthly ShareCap Cont.";
                    Likizo := Cust."Withdrawable Savings";
                    AlphaSavings := cust."Alpha Monthly Contribution";
                    Juniorcontribution := Cust."Junior Monthly Contribution";
                    HOUSING := Cust."Investment Monthly Cont";
                    DEPOSIT := Cust."Monthly Contribution" + cust."Monthly ShareCap Cont.";

                    //development loan 1
                    TRepayment := 0;

                    loans.Reset;
                    loans.SetRange(loans."Client Code", "Members Register"."No.");
                    //loans.SetRange(loans."Recovery Mode", loans."Recovery Mode");
                    loans.SetRange(loans."Loan Product Type", 'LT002');
                    loans.SetFilter(loans."Outstanding Balance", '>0');
                    loans.SetRange("Recovery Mode", loans."Recovery Mode"::"Payroll Deduction");
                    loans.SetAutocalcFields(loans."Outstanding Balance", loans."Oustanding Interest");
                    loans.SetRange(loans.Posted, true);
                    if loans.Find('-') then begin
                        repeat
                            TRepayment := Loans."Oustanding Interest" + Loans."Outstanding Balance";
                            if TRepayment < Loans.Repayment then begin
                                Development1 := TRepayment
                            end else begin
                                Development1 := loans.Repayment;
                            end;
                            Development1 := Development1;//
                        until loans.Next = 0;
                    end;
                    //END
                    //LCount:=LCount+1;
                    //Development2
                    TRepayment := 0;
                    loans.Reset;
                    loans.SetRange(loans."Client Code", "Members Register"."No.");
                    loans.SetRange(loans."Loan Product Type", 'LT001');
                    loans.SetFilter(loans."Outstanding Balance", '>0');
                    loans.SetAutocalcFields(loans."Outstanding Balance", loans."Oustanding Interest");
                    loans.SetRange(loans.Posted, true);
                    if loans.Find('-') then begin
                        repeat
                            TRepayment := Loans."Oustanding Interest" + Loans."Outstanding Balance";
                            if TRepayment < Loans.Repayment then begin
                                Development2 := TRepayment
                            end else Begin
                                Development2 += loans.Repayment;
                            End;

                            Development2 := Development2;//
                        until loans.Next = 0;
                    end;

                    //Investment
                    TRepayment := 0;
                    loans.Reset;
                    loans.SetRange(loans."Client Code", "Members Register"."No.");
                    loans.SetRange(loans."Loan Product Type", 'LT003');
                    loans.SetFilter(loans."Outstanding Balance", '>0');
                    loans.SetAutocalcFields(loans."Outstanding Balance", loans."Oustanding Interest");
                    loans.SetRange(loans.Posted, true);
                    if loans.Find('-') then begin
                        repeat
                            TRepayment := Loans."Oustanding Interest" + Loans."Outstanding Balance";
                            if TRepayment < Loans.Repayment then begin
                                Investment := TRepayment;
                            end else begin
                                Investment := loans.Repayment;
                            end;

                            Investment := Investment;//
                        until loans.Next = 0;
                    end;

                    //Schoolfees
                    TRepayment := 0;
                    loans.Reset;
                    loans.SetRange(loans."Client Code", "Members Register"."No.");
                    loans.SetRange(loans."Loan Product Type", 'LT004');
                    loans.SetRange("Recovery Mode", loans."Recovery Mode"::"Payroll Deduction");
                    loans.SetFilter(loans."Outstanding Balance", '>0');
                    loans.SetAutocalcFields(loans."Outstanding Balance", loans."Oustanding Interest");
                    loans.SetRange(loans.Posted, true);
                    if loans.Find('-') then begin
                        repeat
                            TRepayment := Loans."Oustanding Interest" + Loans."Outstanding Balance";
                            if TRepayment < Loans.Repayment then begin
                                Schoolfees := TRepayment;
                            end else begin
                                Schoolfees := loans.Repayment;
                            end;
                            Schoolfees := Schoolfees;//
                        until loans.Next = 0;
                    end;

                    //Emergency
                    TRepayment := 0;
                    loans.Reset;
                    loans.SetRange(loans."Client Code", "Members Register"."No.");
                    loans.SetRange(loans."Loan Product Type", 'LT005');
                    loans.SetFilter(loans."Outstanding Balance", '>0');
                    loans.SetRange("Recovery Mode", loans."Recovery Mode"::"Payroll Deduction");
                    loans.SetAutocalcFields(loans."Outstanding Balance", loans."Oustanding Interest");
                    loans.SetRange(loans.Posted, true);
                    if loans.Find('-') then begin
                        repeat
                            TRepayment := Loans."Oustanding Interest" + Loans."Outstanding Balance";
                            if TRepayment < Loans.Repayment then begin
                                Emergency := TRepayment;
                            end else begin
                                Emergency := loans.Repayment;
                            end;
                            Emergency := Emergency;//
                        until loans.Next = 0;
                    end;

                    //Instant
                    TRepayment := 0;
                    loans.Reset;
                    loans.SetRange(loans."Client Code", "Members Register"."No.");
                    loans.SetRange(loans."Loan Product Type", 'LT007');
                    loans.SetFilter(loans."Outstanding Balance", '>0');
                    loans.SetRange("Recovery Mode", loans."Recovery Mode"::"Payroll Deduction");
                    loans.SetAutocalcFields(loans."Outstanding Balance", loans."Oustanding Interest");
                    loans.SetRange(loans.Posted, true);
                    if loans.Find('-') then begin
                        repeat
                            TRepayment := Loans."Oustanding Interest" + Loans."Outstanding Balance";
                            if TRepayment < Loans.Repayment then begin
                                Instant := TRepayment;
                            end else begin
                                Instant := loans.Repayment;
                            end;
                            Instant := Instant;//
                        until loans.Next = 0;
                    end;

                    //Development214
                    TRepayment := 0;
                    loans.Reset;
                    loans.SetRange(loans."Client Code", "Members Register"."No.");
                    loans.SetRange(loans."Loan Product Type", 'LT009');
                    loans.SetFilter(loans."Outstanding Balance", '>0');
                    loans.SetRange("Recovery Mode", loans."Recovery Mode"::"Payroll Deduction");
                    loans.SetAutocalcFields(loans."Outstanding Balance", loans."Oustanding Interest");
                    loans.SetRange(loans.Posted, true);
                    if loans.Find('-') then begin
                        repeat
                            TRepayment := Loans."Oustanding Interest" + Loans."Outstanding Balance";
                            if TRepayment < Loans.Repayment then begin
                                Development214 := TRepayment;
                            end else begin
                                Development214 := loans.Repayment;
                            end;
                            Development214 := Development214;//
                        until loans.Next = 0;
                    end;

                    MonthlyAdvice := Juniorcontribution + DEPOSIT + Development1 + Investment + Emergency + Schoolfees + Instant;


                end;

            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnInitReport()
    begin
        CompanyInfo.Get();
        CompanyInfo.CalcFields(Picture);
    end;

    var
        LoansRec: Record "Loans Register";
        Prepayment: Decimal;
        IntRepayment: Decimal;
        TRepayment: Decimal;
        PrincipalInterest: Decimal;
        MonthlyAdvice: Decimal;
        Juniorcontribution: Decimal;
        DOCNAME: Text[30];
        CompanyInfo: Record "Company Information";
        Gsetup: Record "Sacco General Set-Up";
        Insurance: Decimal;
        insuranceContribution: Decimal;
        scapital: Decimal;
        minbal: Decimal;
        DEPOSIT: Decimal;
        AlphaSavings: Decimal;
        Likizo: Decimal;
        HOUSING: Decimal;
        interest: Decimal;
        principle: Decimal;
        loans: Record "Loans Register";
        maxscap: Decimal;
        Cust: Record customer;
        employername: Text;
        member: Record "Sacco Employers";
        normloan: Decimal;
        College: Decimal;
        scfee: Decimal;
        emmerg: Decimal;
        Quick: Decimal;
        karibu: Decimal;
        AssetL: Decimal;
        Makeover: Decimal;
        Premium: Decimal;

        Development1: Decimal;

        Development2: Decimal;

        Development214: Decimal;

        Instant: Decimal;

        Emergency: Decimal;

        Schoolfees: Decimal;

        Investment: Decimal;

        Children: Decimal;

        Flexi: Decimal;

        HasPayrollLoans: Boolean;

}

