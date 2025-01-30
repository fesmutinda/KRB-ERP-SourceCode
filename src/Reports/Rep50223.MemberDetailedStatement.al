#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 50223 "Member Detailed Statement"
{
    ApplicationArea = All;
    RDLCLayout = './Layouts/MemberDetailedStatement.rdl';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem(Customer; Customer)
        {
            RequestFilterFields = "No.", "Loan Product Filter", "Outstanding Balance", "Date Filter";
            column(Payroll_Staff_No; "Payroll/Staff No")
            {
            }
            column(Employer_Name; "Employer Name")
            {
            }
            column(PayrollStaffNo_Members; Customer."Payroll/Staff No")
            {
            }
            column(No_Members; Customer."No.")
            {
            }
            column(MobilePhoneNo_MembersRegister; Customer."Mobile Phone No")
            {
            }
            column(Name_Members; Customer.Name)
            {
            }
            column(EmployerCode_Members; Customer."Employer Code")
            {
            }
            column(EmployerName; EmployerName)
            {
            }
            column(PageNo_Members; CurrReport.PageNo)
            {
            }
            column(Shares_Retained; Customer."Shares Retained")
            {
            }
            column(ShareCapBF; ShareCapBF)
            {
            }
            column(IDNo_Members; Customer."ID No.")
            {
            }
            column(Registration_Date; "Registration Date")
            {

            }
            column(GlobalDimension2Code_Members; Customer."Global Dimension 2 Code")
            {
            }
            column(Company_Name; Company.Name)
            {
            }
            column(Company_Address; Company.Address)
            {
            }
            column(Company_Picture; Company.Picture)
            {
            }
            column(Company_Phone; Company."Phone No.")
            {
            }
            column(Company_SMS; Company."Phone No.")
            {
            }
            column(Company_Email; Company."E-Mail")
            {
            }
            column(Outstanding_Balance; "Outstanding Balance") { }
            column(Outstanding_Interest; "Outstanding Interest") { }
            column(Current_Shares; "Current Shares") { }
            dataitem(Loans; "Loans Register")
            {
                DataItemLink = "Client Code" = field("No."), "Loan Product Type" = field("Loan Product Filter"), "Date filter" = field("Date Filter");
                DataItemTableView = sorting("Loan  No.") where(Posted = const(true), "Loan  No." = filter(<> ''));//, "Outstanding Balance" = filter(> 0));
                ;

                column(PrincipleBF; PrincipleBF)
                {
                }
                column(LoanNumber; Loans."Loan  No.")
                {
                }
                column(ProductType; LoanName)
                {
                }
                column(RequestedAmount; Loans."Requested Amount")
                {
                }
                column(Interest; Loans.Interest)
                {
                }
                column(Installments; Loans.Installments)
                {
                }
                column(LoanPrincipleRepayment; Loans."Loan Principle Repayment")
                {
                }
                column(ApprovedAmount_Loans; Loans."Approved Amount")
                {
                }
                column(LoanProductTypeName_Loans; Loans."Loan Product Type Name")
                {
                }
                column(Repayment_Loans; Loans.Repayment)
                {
                }
                column(ModeofDisbursement_Loans; Loans."Mode of Disbursement")
                {
                }
                dataitem(loan; "Cust. Ledger Entry")
                {
                    DataItemLink = "Customer No." = field("Client Code"), "Loan No" = field("Loan  No."), "Posting Date" = field("Date filter");
                    DataItemTableView = sorting("Posting Date") where("Transaction Type" = filter(Loan | "Loan Repayment"), "Loan No" = filter(<> ''), Reversed = filter(false));
                    column(PostingDate_loan; loan."Posting Date")
                    {
                    }
                    column(DocumentNo_loan; loan."Document No.")
                    {
                    }
                    column(Description_loan; loan.Description)
                    {
                    }
                    column(DebitAmount_Loan; loan."Debit Amount")
                    {
                    }
                    column(CreditAmount_Loan; loan."Credit Amount")
                    {
                    }
                    column(Amount_Loan; loan."Amount to Apply") //Amount posted
                    {
                    }
                    column(openBalance_loan; OpenBalanceLoan)
                    {
                    }
                    column(CLosingBalance_loan; ClosingBalanceLoan * -1)
                    {
                    }
                    column(TransactionType_loan; loan."Transaction Type")
                    {
                    }
                    column(LoanNo; loan."Loan No")
                    {
                    }
                    column(PrincipleBF_loans; PrincipleBF)
                    {
                    }
                    column(LoanType_loan; loan."Loan Type")
                    {
                    }
                    column(Loan_Description; loan.Description)
                    {
                    }
                    column(BalAccountNo_loan; loan."Bal. Account No.")
                    {
                    }
                    column(BankCodeLoan; BankCodeLoan)
                    {
                    }
                    column(User7; loan."User ID")
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        ClosingBalanceLoan := ClosingBalanceLoan - loan.Amount;
                        BankCodeLoan := GetBankCode(loan);
                        //.................................
                        if loan.Amount < 0 then begin
                            loan."Credit Amount" := (loan.Amount * -1);
                        end else
                            if loan.Amount > 0 then begin
                                loan."Debit Amount" := (loan.Amount);
                            end

                    end;

                    trigger OnPreDataItem()
                    begin
                        ClosingBalanceLoan := PrincipleBF;
                        OpenBalanceLoan := PrincipleBF;
                        OpeningBalInt := InterestBF;
                    end;
                }
                dataitem(Interests; "Cust. Ledger Entry")
                {
                    DataItemLink = "Customer No." = field("Client Code"), "Loan No" = field("Loan  No."), "Posting Date" = field("Date filter");
                    DataItemTableView = sorting("Posting Date") where("Transaction Type" = filter("Interest Due" | "Interest Paid"), "Loan No" = filter(<> ''), Reversed = filter(false));

                    column(PostingDate_Interest; Interests."Posting Date")
                    {
                    }

                    column(DocumentNo_Interest; Interests."Document No.")
                    {
                    }
                    column(Description_Interest; Interests.Description)
                    {
                    }
                    column(DebitAmount_Interest; Interests."Debit Amount")
                    {
                    }
                    column(CreditAmount_Interest; Interests."Credit Amount")
                    {
                    }
                    column(Amount_Interest; Interests.Amount)
                    {
                    }
                    column(OpeningBalInt; OpeningBalInt)
                    {
                    }
                    column(ClosingBalInt; ClosingBalInt)
                    {
                    }
                    column(TransactionType_Interest; Interests."Transaction Type")
                    {
                    }
                    column(LoanNo_Interest; Interests."Loan No")
                    {
                    }
                    column(InterestBF; InterestBF)
                    {
                    }
                    column(BalAccountNo_Interest; Interests."Bal. Account No.")
                    {
                    }
                    column(BankCodeInterest; BankCodeInterest)
                    {
                    }
                    column(User8; Interests."User ID")
                    {
                    }
                    column(LoanNo_ApprovedAMount; ApprovedAmount_Interest)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        ClosingBalInt := ClosingBalInt + Interests.Amount;
                        BankCodeInterest := GetBankCode(Interests);
                        //...................Get TotalInterestDue
                        ApprovedAmount_Interest := 0;

                        LonRepaymentSchedule.Reset();
                        LonRepaymentSchedule.SetRange(LonRepaymentSchedule."Loan No.", Interests."Loan No");
                        if LoansR.find('-') then begin
                            repeat
                                ApprovedAmount_Interest += LonRepaymentSchedule."Monthly Interest";
                            until LonRepaymentSchedule.Next = 0;
                        end;
                        //..................
                        if Interests.Amount < 0 then begin
                            Interests."Credit Amount" := (Interests.Amount * -1);
                        end else
                            if Interests.Amount > 0 then begin
                                Interests."Debit Amount" := (Interests.Amount);
                            end
                    end;

                    trigger OnPreDataItem()
                    begin
                        ClosingBalInt := InterestBF;
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    if LoanSetup.Get(Loans."Loan Product Type") then
                        LoanName := LoanSetup."Product Description";
                    if DateFilterBF <> '' then begin
                        LoansR.Reset;
                        LoansR.SetRange(LoansR."Loan  No.", "Loan  No.");
                        LoansR.SetFilter(LoansR."Date filter", DateFilterBF);
                        if LoansR.Find('-') then begin
                            LoansR.CalcFields(LoansR."Outstanding Balance");
                            LoansR.CalcFields(LoansR."Oustanding Interest");
                            PrincipleBF := LoansR."Outstanding Balance";
                            InterestBF := LoansR."Oustanding Interest";
                        end;
                    end;
                end;

                trigger OnPreDataItem()
                begin
                    //Loans.CALCFIELDS("Outstanding Balance");
                    //Loans.SETFILTER("Outstanding Balance",'<>%1',0);

                    Loans.SetFilter(Loans."Date filter", Customer.GetFilter(Customer."Date Filter"));
                end;
            }

            dataitem(Share; "Cust. Ledger Entry")
            {
                DataItemLink = "Customer No." = field("No."), "Posting Date" = field("Date Filter");
                DataItemTableView = sorting("Posting Date") where("Transaction Type" = const("Shares Capital"), Reversed = filter(false));
                column(openBalances; OpenBalance)
                {
                }
                column(CLosingBalances; CLosingBalance)
                {
                }
                column(Description_Shares; Share.Description)
                {
                }
                column(DocumentNo_Shares; Share."Document No.")
                {
                }
                column(PostingDate_Shares; Share."Posting Date")
                {
                }
                column(CreditAmount_Shares; Share."Credit Amount")
                {
                }
                column(DebitAmount_Shares; Share."Debit Amount")
                {
                }
                column(Amount_Shares; Share.Amount)
                {
                }
                column(TransactionType_Shares; Share."Transaction Type")
                {
                }
                column(Shares_Description; Share.Description)
                {
                }
                column(BalAccountNo_Shares; Share."Bal. Account No.")
                {
                }
                column(BankCodeShares; BankCodeShares)
                {
                }
                column(USER1; Share."User ID")
                {
                }

                trigger OnAfterGetRecord()
                begin
                    CLosingBalance := CLosingBalance - Share.Amount;
                    BankCodeShares := GetBankCode(Share);
                    //...................................
                    if Share.Amount < 0 then begin
                        Share."Credit Amount" := (Share.Amount * -1);
                    end else
                        if Share.Amount > 0 then begin
                            Share."Debit Amount" := (Share.Amount);
                        end;

                    MembLedgerEntry.Reset();
                    MembLedgerEntry.SetRange("Customer No.", TbMembReg."No.");
                    if MembLedgerEntry.Find('-') then
                        if MembLedgerEntry.IsEmpty() then begin
                            CurrReport.Skip();
                        end;
                end;

                trigger OnPreDataItem()
                begin
                    CLosingBalance := ShareCapBF;
                    OpenBalance := ShareCapBF;
                end;
            }

            dataitem(HousingShares; "Cust. Ledger Entry")
            {
                DataItemLink = "Customer No." = field("No."), "Posting Date" = field("Date Filter");
                DataItemTableView = sorting("Transaction Type", "Loan No", "Posting Date") where("Transaction Type" = const("Benevolent Fund"), Reversed = filter(false)); //"Benevolent Fund" from Investment

                column(OpenBalancesHousingShares; OpenBalancesHousingShares)
                {
                }
                column(CLosingBalancesHousingShares; ClosingBalanceHousingShares)
                {
                }
                column(Description_HousingShares; HousingShares.Description)
                {
                }
                column(DocumentNo_HousingShares; HousingShares."Document No.")
                {
                }
                column(PostingDate_HousingShares; HousingShares."Posting Date")
                {
                }
                column(CreditAmount_HousingShares; HousingShares."Credit Amount")
                {
                }
                column(DebitAmount_HousingShares; HousingShares."Debit Amount")
                {
                }
                column(Amount_HousingShares; HousingShares.Amount)
                {
                }
                column(TransactionType_HousingShares; HousingShares."Transaction Type")
                {
                }
                column(BalAccountNo_HousingShares; HousingShares."Bal. Account No.")
                {
                }
                column(BankCodeHousingShares; BankCodeHousingShares)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    ClosingBalanceHousingShares := ClosingBalanceHousingShares - HousingShares.Amount;
                    BankCodeHousingShares := GetBankCode(HousingShares);
                    //............................................................
                    if HousingShares.Amount < 0 then begin
                        HousingShares."Credit Amount" := (HousingShares.Amount * -1);
                    end else
                        if HousingShares.Amount > 0 then begin
                            HousingShares."Debit Amount" := (HousingShares.Amount);
                        end
                end;

                trigger OnPreDataItem()
                begin
                    // ClosingBalancePepeaShares := PepeaSharesBF;
                    // OpenBalancePepeaShares := PepeaSharesBF * -1;
                end;
            }

            // dataitem(PepeaShares; "Cust. Ledger Entry")//
            // {
            //     DataItemLink = "Customer No." = field("No."), "Posting Date" = field("Date Filter");
            //     DataItemTableView = sorting("Transaction Type", "Loan No", "Posting Date") where("Transaction Type" = const("pepea Shares"), Reversed = filter(false));

            //     column(OpenBalancesPepeaShares; OpenBalancesPepeaShares)
            //     {
            //     }
            //     column(CLosingBalancesPepeaShares; ClosingBalancePepeaShares)
            //     {
            //     }
            //     column(Description_PepeaShares; PepeaShares.Description)
            //     {
            //     }
            //     column(DocumentNo_PepeaShares; PepeaShares."Document No.")
            //     {
            //     }
            //     column(PostingDate_PepeaShares; PepeaShares."Posting Date")
            //     {
            //     }
            //     column(CreditAmount_PepeaShares; PepeaShares."Credit Amount")
            //     {
            //     }
            //     column(DebitAmount_PepeaShares; PepeaShares."Debit Amount")
            //     {
            //     }
            //     column(Amount_PepeaShares; PepeaShares.Amount)
            //     {
            //     }
            //     column(TransactionType_PepeaShares; PepeaShares."Transaction Type")
            //     {
            //     }
            //     column(BalAccountNo_PepeaShares; PepeaShares."Bal. Account No.")
            //     {
            //     }
            //     column(BankCodePepeaShares; BankCodePepeaShares)
            //     {
            //     }

            //     trigger OnAfterGetRecord()
            //     begin
            //         ClosingBalancePepeaShares := ClosingBalancePepeaShares - PepeaShares.Amount;
            //         BankCodePepeaShares := GetBankCode(PepeaShares);
            //         //............................................................
            //         if PepeaShares.Amount < 0 then begin
            //             PepeaShares."Credit Amount" := (PepeaShares.Amount * -1);
            //         end else
            //             if PepeaShares.Amount > 0 then begin
            //                 PepeaShares."Debit Amount" := (PepeaShares.Amount);
            //             end
            //     end;

            //     trigger OnPreDataItem()
            //     begin
            //         // ClosingBalancePepeaShares := PepeaSharesBF;
            //         // OpenBalancePepeaShares := PepeaSharesBF * -1;
            //     end;
            // }

            // dataitem(FOSAShares; "Cust. Ledger Entry")//
            // {
            //     DataItemLink = "Customer No." = field("No."), "Posting Date" = field("Date Filter");
            //     DataItemTableView = sorting("Transaction Type", "Loan No", "Posting Date") where("Transaction Type" = const("FOSA Shares"), Reversed = filter(false));

            //     column(OpenBalancesFOSAShares; OpenBalanceFOSAShares)
            //     {
            //     }
            //     column(CLosingBalancesFOSAShares; ClosingBalanceFOSAShares)
            //     {
            //     }
            //     column(Description_FOSAShares; FOSAShares.Description)
            //     {
            //     }
            //     column(DocumentNo_FOSAShares; FOSAShares."Document No.")
            //     {
            //     }
            //     column(PostingDate_FOSAShares; FOSAShares."Posting Date")
            //     {
            //     }
            //     column(CreditAmount_FOSAShares; FOSAShares."Credit Amount")
            //     {
            //     }
            //     column(DebitAmount_FOSAShares; FOSAShares."Debit Amount")
            //     {
            //     }
            //     column(Amount_FOSAShares; FOSAShares.Amount)
            //     {
            //     }
            //     column(TransactionType_FOSAShares; FOSAShares."Transaction Type")
            //     {
            //     }
            //     column(BalAccountNo_FOSAShares; FOSAShares."Bal. Account No.")
            //     {
            //     }
            //     column(BankCodeFOSAShares; BankCodeFOSAShares)
            //     {
            //     }

            //     trigger OnAfterGetRecord()
            //     begin
            //         ClosingBalanceFOSAShares := ClosingBalanceFOSAShares - FOSAShares.Amount;
            //         BankCodeFOSAShares := GetBankCode(FOSAShares);
            //         //............................................................
            //         if FOSAShares.Amount < 0 then begin
            //             FOSAShares."Credit Amount" := (FOSAShares.Amount * -1);
            //         end else
            //             if FOSAShares.Amount > 0 then begin
            //                 FOSAShares."Debit Amount" := (FOSAShares.Amount);
            //             end
            //     end;

            //     trigger OnPreDataItem()
            //     begin
            //         ClosingBalanceDividend := DividendBF;
            //         OpenBalanceDividend := DividendBF * -1;
            //     end;
            // }

            dataitem(Deposits; "Cust. Ledger Entry")
            {
                DataItemLink = "Customer No." = field("No."), "Posting Date" = field("Date Filter");
                DataItemTableView = sorting("Posting Date") where("Transaction Type" = const("Deposit Contribution"), Reversed = filter(false));
                column(OpeningBal; OpeningBal)
                {
                }
                column(ClosingBal; ClosingBal)
                {
                }
                column(TransactionType_Deposits; Deposits."Transaction Type")
                {
                }
                column(Amount_Deposits; Deposits.Amount)
                {
                }
                column(Description_Deposits; Deposits.Description)
                {
                }
                column(DocumentNo_Deposits; Deposits."Document No.")
                {
                }
                column(PostingDate_Deposits; Deposits."Posting Date")
                {
                }
                column(DebitAmount_Deposits; Deposits."Debit Amount")
                {
                }
                column(CreditAmount_Deposits; Deposits."Credit Amount")
                {
                }
                column(Deposits_Description; Deposits.Description)
                {
                }
                column(BalAccountNo_Deposits; Deposits."Bal. Account No.")
                {
                }
                column(BankCodeDeposits; BankCodeDeposits)
                {
                }
                column(USER2; Deposits."User ID")
                {
                }

                trigger OnAfterGetRecord()
                begin

                    ClosingBal := ClosingBal - Deposits.Amount;
                    BankCodeDeposits := GetBankCode(Deposits);
                    //........................
                    if Deposits.Amount < 0 then begin
                        Deposits."Credit Amount" := (Deposits.Amount * -1);
                    end else
                        if Deposits.Amount > 0 then begin
                            Deposits."Debit Amount" := (Deposits.Amount);
                        end
                end;

                trigger OnPreDataItem()
                begin
                    ClosingBal := SharesBF;
                    OpeningBal := SharesBF;
                end;
            }
            dataitem(Dividend; "Cust. Ledger Entry")//
            {
                DataItemLink = "Customer No." = field("No."), "Posting Date" = field("Date Filter");
                DataItemTableView = sorting("Transaction Type", "Loan No", "Posting Date") where("Transaction Type" = const(dividend), Reversed = filter(false));
                column(ReportForNavId_1102755055; 1102755055)
                {
                }
                column(OpenBalancesDividend; OpenBalanceDividend)
                {
                }
                column(CLosingBalancesDividend; ClosingBalanceDividend)
                {
                }
                column(Description_Dividend; Dividend.Description)
                {
                }
                column(DocumentNo_Dividend; Dividend."Document No.")
                {
                }
                column(PostingDate_Dividend; Dividend."Posting Date")
                {
                }
                column(CreditAmount_Dividend; Dividend."Credit Amount")
                {
                }
                column(DebitAmount_Dividend; Dividend."Debit Amount")
                {
                }
                column(Amount_Dividend; Dividend.Amount)
                {
                }
                column(TransactionType_Dividend; Dividend."Transaction Type")
                {
                }
                column(BalAccountNo_Dividend; Dividend."Bal. Account No.")
                {
                }
                column(BankCodeDividend; BankCodeDividend)
                {
                }
                column(USER3; Dividend."User ID")
                {
                }

                trigger OnAfterGetRecord()
                begin
                    ClosingBalanceDividend := ClosingBalanceDividend - Dividend.Amount;
                    BankCodeDividend := GetBankCode(Dividend);
                end;

                trigger OnPreDataItem()
                begin
                    ClosingBalanceDividend := DividendBF;
                    OpenBalanceDividend := DividendBF * -1;
                end;
            }


            dataitem("Loans Guarantee Details"; "Loans Guarantee Details")
            {
                DataItemLink = "Member No" = field("No.");
                column(ReportForNavId_1000000042; 1000000042)
                {
                }
                column(LoanNumb; "Loans Guarantee Details"."Loan No")
                {
                }
                column(MembersNo; "Loans Guarantee Details"."Member No")
                {
                }
                column(Name; "Loans Guarantee Details".Name)
                {
                }
                column(LBalance; "Loans Guarantee Details"."Loans Outstanding")
                {
                }
                column(Shares; "Loans Guarantee Details".Shares)
                {
                }
                column(LoansGuaranteed; "Loans Guarantee Details"."No Of Loans Guaranteed")
                {
                }
                column(Substituted; "Loans Guarantee Details".Substituted)
                {
                }
            }

            trigger OnAfterGetRecord()
            begin
                SaccoEmp.Reset;
                SaccoEmp.SetRange(SaccoEmp.Code, Customer."Employer Code");
                if SaccoEmp.Find('-') then
                    EmployerName := SaccoEmp.Description;

                HolidayBF := 0;
                SharesBF := 0;
                InsuranceBF := 0;
                ShareCapBF := 0;
                RiskBF := 0;
                HseBF := 0;
                Dep1BF := 0;
                Dep2BF := 0;
                if DateFilterBF <> '' then begin
                    Cust.Reset;
                    Cust.SetRange(Cust."Customer No.", "No.");
                    //ABEL COMMENT
                    Cust.SetFilter(Cust."Date Filter", DateFilterBF);
                    //ABEL COMMENT
                    if Cust.Find('-') then begin
                        // Cust.CalcFields(Cust.sha, Cust."Current Shares", Cust."Insurance Fund", Cust."Holiday Savings");
                        // SharesBF := Cust."Current Shares";
                        // ShareCapBF := Cust."Shares Retained";
                        // RiskBF := Cust."Insurance Fund";
                        // HolidayBF := Cust."Holiday Savings";
                    end;
                end;
            end;

            trigger OnPreDataItem()
            begin
                /*
                IF Customer.GETFILTER(Customer."Date Filter") <> '' THEN
                DateFilterBF:='..'+ FORMAT(CALCDATE('-1D',Customer.GETRANGEMIN(Customer."Date Filter")));
                */

                if Customer.GetFilter(Customer."Date Filter") <> '' then
                    DateFilterBF := '..' + Format(CalcDate('-1D', Customer.GetRangeMin(Customer."Date Filter")));
                //DateFilterBF:='..'+ FORMAT(Customer.GETRANGEMIN(Customer."Date Filter"));

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

    trigger OnPreReport()
    begin
        Company.Get();
        Company.CalcFields(Company.Picture);
    end;

    var
        OpenBalance: Decimal;
        CLosingBalance: Decimal;
        OpenBalanceXmas: Decimal;
        CLosingBalanceXmas: Decimal;
        Cust: Record "Cust. Ledger Entry";
        OpeningBal: Decimal;
        ClosingBal: Decimal;
        FirstRec: Boolean;
        PrevBal: Integer;
        BalBF: Decimal;
        LoansR: Record "Loans Register";
        DateFilterBF: Text[150];
        SharesBF: Decimal;
        InsuranceBF: Decimal;
        LoanBF: Decimal;
        PrincipleBF: Decimal;
        InterestBF: Decimal;
        ShowZeroBal: Boolean;
        ClosingBalSHCAP: Decimal;
        ShareCapBF: Decimal;
        RiskBF: Decimal;
        DividendBF: Decimal;
        Company: Record "Company Information";
        OpenBalanceHse: Decimal;
        CLosingBalanceHse: Decimal;
        OpenBalanceDep1: Decimal;
        CLosingBalanceDep1: Decimal;
        OpenBalanceDep2: Decimal;
        CLosingBalanceDep2: Decimal;
        HseBF: Decimal;
        Dep1BF: Decimal;
        Dep2BF: Decimal;
        OpeningBalInt: Decimal;
        ClosingBalInt: Decimal;
        InterestPaid: Decimal;
        SumInterestPaid: Decimal;
        OpenBalanceRisk: Decimal;
        CLosingBalanceRisk: Decimal;
        OpenBalanceDividend: Decimal;
        ClosingBalanceDividend: Decimal;
        OpenBalanceHoliday: Decimal;
        ClosingBalanceHoliday: Decimal;
        LoanSetup: Record "Loan Products Setup";
        LoanName: Text[50];
        SaccoEmp: Record "Sacco Employers";
        EmployerName: Text[100];
        OpenBalanceLoan: Decimal;
        ClosingBalanceLoan: Decimal;
        BankCodeShares: Text;
        BankCodeDeposits: Text;
        BankCodeDividend: Text;
        BankCodeRisk: Text;
        BankCodeInsurance: Text;
        BankCodeLoan: Text;
        BankCodeInterest: Text;
        HolidayBF: Decimal;
        BankCodeHoliday: Code[50];
        ClosingBalHoliday: Decimal;
        OpeningBalHoliday: Decimal;
        BankCodeFOSAShares: Code[50];
        ClosingBalanceFOSAShares: Decimal;
        OpenBalanceFOSAShares: Decimal;
        OpenBalancesPepeaShares: Decimal;
        ClosingBalancePepeaShares: Decimal;
        BankCodePepeaShares: Code[50];
        OpenBalancesHousingShares: Decimal;
        ClosingBalanceHousingShares: Decimal;
        BankCodeHousingShares: Code[50];
        ApprovedAmount_Interest: Decimal;
        LonRepaymentSchedule: Record "Loan Repayment Schedule";

        MembLedgerEntry: Record "Cust. Ledger Entry";
        TbMembReg: Record Customer;


    local procedure GetBankCode(MembLedger: Record "Cust. Ledger Entry"): Text
    var
        BankLedger: Record "Bank Account Ledger Entry";
    begin
        BankLedger.Reset;
        BankLedger.SetRange("Posting Date", MembLedger."Posting Date");
        BankLedger.SetRange("Document No.", MembLedger."Document No.");
        if BankLedger.FindFirst then
            exit(BankLedger."Bank Account No.");
        exit('');
    end;
}

