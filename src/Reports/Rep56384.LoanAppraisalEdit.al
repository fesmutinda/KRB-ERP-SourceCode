#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 56384 "Loan Appraisal Edit"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Loan Appraisal.rdlc';

    dataset
    {
        dataitem("Loans Register"; "Loans Register")
        {
            DataItemTableView = sorting("Loan  No.");
            RequestFilterFields = "Loan  No.";
            column(TotalTopUpDeductions; TotalTopUpDeductions)
            {
            }
            column(total_fees_and_commisions; Upfronts)
            {

            }
            column(total_deductions; total_deductions)
            {

            }
            column(Approved_Amount; "Approved Amount")
            {
            }
            column(NHIF; NHIF)
            {
            }
            column(Sacco_Deductions; "Sacco Deductions")
            {
            }
            column(FORMAT_TODAY_0_4_; Format(Today, 0, 4))
            {
            }
            column(CurrReport_PAGENO; CurrReport.PageNo)
            {
            }
            column(USERID; UserId)
            {
            }
            column(COMPANYNAME; COMPANYNAME)
            {
            }
            column(CompanyInfo_Address; CompanyInfo.Address)
            {
            }
            column(CompanyInfo__Phone_No__; CompanyInfo."Phone No.")
            {
            }
            column(CompanyInfo__E_Mail_; CompanyInfo."E-Mail")
            {
            }
            column(CompanyInfo_City; CompanyInfo.City)
            {
            }
            column(CompanyInfo_Picture; CompanyInfo.Picture)
            {
            }
            column(Loans__Application_Date_; "Application Date")
            {
            }
            column(JazaDeposits; "Jaza Deposits")
            {
            }
            column(DepositReinstatement; "Deposit Reinstatement")
            {
            }
            column(ExciseDutyAppraisal; ExciseDutyAppraisal)
            {
            }
            column(LoanProcessingFee; LPFcharge)
            {
            }
            column(TscInt; TscInt)
            {
            }
            column(AccruedInt; AccruedInt)
            {
            }
            column(ProcessingFee; ProcessingFee)
            {
            }
            column(LoanFormFee; LoanFormFee)
            {
            }
            column(LAppraisalFee; LAppraisalFee)
            {
            }
            column(SaccoInt; SaccoInt)
            {
            }
            column(TotalLoanBal; TotalLoanBal)
            {
            }
            column(Netdisbursed; Netdisbursed)
            {
            }
            column(StatDeductions; StatDeductions)
            {
            }
            column(TotLoans; TotLoans)
            {
            }
            column(LoanCashCleared_LoansRegister; "Loans Register"."Loan  Cash Cleared")
            {
            }
            column(LoanCashClearancefee_LoansRegister; "Loans Register"."Loan Cash Clearance fees")
            {
            }
            column(PrincipleRepayment; "Loans Register"."Loan Principle Repayment")
            {
            }
            column(InterestRepayment; "Loans Register"."Loan Interest Repayment")
            {
            }
            column(Loans__Loan__No__; "Loan  No.")
            {
            }
            column(Loans__Loan_Product_Type_; "Loan Product Type")
            {
            }
            column(Loans_Loans__Client_Code_; "Loans Register"."Client Code")
            {
            }
            column(LoansApprovedAmount; "Loans Register"."Approved Amount")
            {
            }
            column(ShareCapitalDue_LoansRegister; "Loans Register"."Share Capital Due")
            {
            }
            column(LoanInsurance; "Loans Register"."Loan Insurance")
            {
            }
            column(Cust_Name; Cust.Name)
            {
            }
            column(Loans__Requested_Amount_; "Requested Amount")
            {
            }
            column(Loans__Staff_No_; "Staff No")
            {
            }
            column(NetSalary; NetSalary)
            {
            }
            column(CollateralAmount; CollateralAmount)
            {
            }
            column(Approved_Amounts; "Approved Amount")
            {
            }
            column(Reccom_Amount; Recomm)
            {
            }
            column(LOANBALANCE; LOANBALANCE)
            {
            }
            column(Loans_Installments; Installments)
            {
            }
            column(Loans__No__Of_Guarantors_; "No. Of Guarantors")
            {
            }
            column(TotalBridgeAmount; TotalBridgeAmount)
            {
            }
            column(Cshares_3; Cshares * 3)
            {
            }
            column(Cshares_3__LOANBALANCE_BRIDGEBAL_LOANBALANCEFOSASEC; (Cshares * 3) - LOANBALANCE + BRIDGEBAL - LOANBALANCEFOSASEC)
            {
            }
            column(Cshares; Cshares)
            {
            }
            column(LOANBALANCE_BRIDGEBAL; TotalLoanBal - BRIDGEBAL)
            {
            }
            column(Loans__Transport_Allowance_; "Transport Allowance")
            {
            }
            column(Loans__Employer_Code_; "Employer Code")
            {
            }
            column(Loans__Loan_Product_Type_Name_; "Loan Product Type Name")
            {
            }
            column(Loans__Loan__No___Control1102760138; "Loan  No.")
            {
            }
            column(Loans__Application_Date__Control1102760139; "Application Date")
            {
            }
            column(Loans__Loan_Product_Type__Control1102760140; "Loan Product Type")
            {
            }
            column(Loans_Loans__Client_Code__Control1102760141; "Loans Register"."Client Code")
            {
            }
            column(Cust_Name_Control1102760142; Cust.Name)
            {
            }
            column(Loans__Staff_No__Control1102760144; "Staff No")
            {
            }
            column(Loans_Installments_Control1102760145; Installments)
            {
            }
            column(Loans__No__Of_Guarantors__Control1102760146; "No. Of Guarantors")
            {
            }
            column(Loans__Requested_Amount__Control1102760143; "Requested Amount")
            {
            }
            column(Loans_Repayment; Repayment)
            {
            }
            column(Loans__Employer_Code__Control1102755075; "Employer Code")
            {
            }
            column(MAXAvailable; MAXAvailable)
            {
            }
            column(Cshares_Control1102760156; Cshares)
            {
            }
            column(BRIDGEBAL; BRIDGEBAL)
            {
            }
            column(LOANBALANCE_BRIDGEBAL_Control1102755006; LOANBALANCE - BRIDGEBAL)
            {
            }
            column(DEpMultiplier; DEpMultiplier)
            {
            }
            column(DefaultInfo; DefaultInfo)
            {
            }
            column(RecomRemark; RecomRemark)
            {
            }
            column(Recomm; Recomm)
            {
            }
            column(BasicEarnings; BasicEarnings)
            {
            }
            column(GShares; GShares)
            {
            }
            column(GShares_TGuaranteedAmount; GShares - TGuaranteedAmount)
            {
            }
            column(Msalary; Msalary)
            {
            }
            column(MAXAvailable_Control1102755031; MAXAvailable)
            {
            }
            column(Recomm_TOTALBRIDGED; Recomm - TOTALBRIDGED)
            {
            }
            column(GuarantorQualification; GuarantorQualification)
            {
            }
            column(Requested_Amount__MAXAvailable; "Requested Amount" - MAXAvailable)
            {
            }
            column(Requested_Amount__Msalary; "Requested Amount" - Msalary)
            {
            }
            column(Requested_Amount__GShares; "Requested Amount" - GShares)
            {
            }
            column(Loan_Appraisal_AnalysisCaption; Loan_Appraisal_AnalysisCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Loan_Application_DetailsCaption; Loan_Application_DetailsCaptionLbl)
            {
            }
            column(Loans__Application_Date_Caption; FieldCaption("Application Date"))
            {
            }
            column(Loans__Loan__No__Caption; FieldCaption("Loan  No."))
            {
            }
            column(Loan_TypeCaption; Loan_TypeCaptionLbl)
            {
            }
            column(MemberCaption; MemberCaptionLbl)
            {
            }
            column(Amount_AppliedCaption; Amount_AppliedCaptionLbl)
            {
            }
            column(Loans__Staff_No_Caption; FieldCaption("Staff No"))
            {
            }
            column(Loans_InstallmentsCaption; FieldCaption(Installments))
            {
            }
            column(Deposits__3Caption; Deposits__3CaptionLbl)
            {
            }
            column(Eligibility_DetailsCaption; Eligibility_DetailsCaptionLbl)
            {
            }
            column(Maxim__Amount_Avail__for_the_LoanCaption; Maxim__Amount_Avail__for_the_LoanCaptionLbl)
            {
            }
            column(Outstanding_LoanCaption; Outstanding_LoanCaptionLbl)
            {
            }
            column(Member_DepositsCaption; Member_DepositsCaptionLbl)
            {
            }
            column(Loans__No__Of_Guarantors_Caption; FieldCaption("No. Of Guarantors"))
            {
            }
            column(Loans__Transport_Allowance_Caption; FieldCaption("Transport Allowance"))
            {
            }
            column(Loans__Employer_Code_Caption; FieldCaption("Employer Code"))
            {
            }
            column(Loans__No__Of_Guarantors__Control1102760146Caption; FieldCaption("No. Of Guarantors"))
            {
            }
            column(Loans_Installments_Control1102760145Caption; FieldCaption(Installments))
            {
            }
            column(Loans__Staff_No__Control1102760144Caption; FieldCaption("Staff No"))
            {
            }
            column(Amount_AppliedCaption_Control1102760132; Amount_AppliedCaption_Control1102760132Lbl)
            {
            }
            column(MemberCaption_Control1102760133; MemberCaption_Control1102760133Lbl)
            {
            }
            column(Loan_TypeCaption_Control1102760134; Loan_TypeCaption_Control1102760134Lbl)
            {
            }
            column(Loans__Application_Date__Control1102760139Caption; FieldCaption("Application Date"))
            {
            }
            column(Loans__Loan__No___Control1102760138Caption; FieldCaption("Loan  No."))
            {
            }
            column(Loan_Application_DetailsCaption_Control1102760151; Loan_Application_DetailsCaption_Control1102760151Lbl)
            {
            }
            column(RepaymentCaption; RepaymentCaptionLbl)
            {
            }
            column(Loans__Employer_Code__Control1102755075Caption; FieldCaption("Employer Code"))
            {
            }
            column(Maxim__Amount_Avail__for_the_LoanCaption_Control1102760150; Maxim__Amount_Avail__for_the_LoanCaption_Control1102760150Lbl)
            {
            }
            column(Total_Outstand__Loan_BalanceCaption; Total_Outstand__Loan_BalanceCaptionLbl)
            {
            }
            column(Deposits___MulitiplierCaption; Deposits___MulitiplierCaptionLbl)
            {
            }
            column(Member_DepositsCaption_Control1102760148; Member_DepositsCaption_Control1102760148Lbl)
            {
            }
            column(Deposits_AnalysisCaption; Deposits_AnalysisCaptionLbl)
            {
            }
            column(Bridged_AmountCaption; Bridged_AmountCaptionLbl)
            {
            }
            column(Out__Balance_After_Top_upCaption; Out__Balance_After_Top_upCaptionLbl)
            {
            }
            column(Recommended_AmountCaption; Recommended_AmountCaptionLbl)
            {
            }
            column(Net_Loan_Disbursement_Caption; Net_Loan_Disbursement_CaptionLbl)
            {
            }
            column(V3__Qualification_as_per_GuarantorsCaption; V3__Qualification_as_per_GuarantorsCaptionLbl)
            {
            }
            column(Defaulter_Info_Caption; Defaulter_Info_CaptionLbl)
            {
            }
            column(V2__Qualification_as_per_SalaryCaption; V2__Qualification_as_per_SalaryCaptionLbl)
            {
            }
            column(V1__Qualification_as_per_SharesCaption; V1__Qualification_as_per_SharesCaptionLbl)
            {
            }
            column(QUALIFICATIONCaption; QUALIFICATIONCaptionLbl)
            {
            }
            column(Insufficient_Deposits_to_cover_the_loan_applied__RiskCaption; Insufficient_Deposits_to_cover_the_loan_applied__RiskCaptionLbl)
            {
            }
            column(WARNING_Caption; WARNING_CaptionLbl)
            {
            }
            column(Salary_is_Insufficient_to_cover_the_loan_applied__RiskCaption; Salary_is_Insufficient_to_cover_the_loan_applied__RiskCaptionLbl)
            {
            }
            column(WARNING_Caption_Control1000000140; WARNING_Caption_Control1000000140Lbl)
            {
            }
            column(WARNING_Caption_Control1000000141; WARNING_Caption_Control1000000141Lbl)
            {
            }
            column(Guarantors_do_not_sufficiently_cover_the_loan__RiskCaption; Guarantors_do_not_sufficiently_cover_the_loan__RiskCaptionLbl)
            {
            }
            column(WARNING_Caption_Control1000000020; WARNING_Caption_Control1000000020Lbl)
            {
            }
            column(Shares_Deposits_BoostedCaption; Shares_Deposits_BoostedCaptionLbl)
            {
            }
            column(DepX; DEpMultiplier)
            {
            }
            column(TwoThird; TwoThirds)
            {
            }
            column(LPrincipal; LPrincipal)
            {
            }
            column(LInterest; LInterest)
            {
            }
            column(LNumber; LNumber)
            {
            }
            column(TotalLoanDeductions; TotalLoanDeductions)
            {
            }
            column(MinDepositAsPerTier_Loans; "Min Deposit As Per Tier")
            {
            }
            column(TotalRepayments; TotalRepayments)
            {
            }
            column(Totalinterest; Totalinterest)
            {
            }
            column(Band; Band)
            {
            }
            column(NtTakeHome; NtTakeHome)
            {
            }
            column(BridgedRepayment; BridgedRepayment)
            {
            }
            column(BRIGEDAMOUNT; BRIGEDAMOUNT)
            {
            }
            column(BasicPay; BasicPay)
            {
            }
            column(HouseAllowance; HouseAllowance)
            {
            }
            column(TransportAll; TransportAll)
            {
            }
            column(MedicalAll; MedicalAll)
            {
            }
            column(OtherIncomes; OtherIncomes)
            {
            }
            column(GrossP; GrossP)
            {
            }
            column(NETTAKEHOME; NETTAKEHOME)
            {
            }
            column(MonthlyCont; MonthlyCont)
            {
            }
            column(PAYE; PAYE)
            {
            }
            column(Risk; Risk)
            {
            }
            column(LifeInsurance; LifeInsurance)
            {
            }
            column(OtherLiabilities; OtherLiabilities)
            {
            }
            column(SaccoDed; SaccoDed)
            {
            }
            column(ShareBoostComm; ShareBoostComm)
            {
            }
            // column(LoanInsurance; LoanInsurance)
            // {
            // }
            column(AccruedinterestVisible; AccruedinterestVisible)
            {
            }
            column(Exciseduty; Exciseduty)
            {
            }
            column(AppraisalFeeVisible; AppraisalFeeVisible)
            {
            }
            column(SMSFEE; SMSFEE)
            {
            }
            column(LPFcharge; LPFcharge)
            {
            }
            column(HisaARREAR; HisaARREAR)
            {
            }
            column(ShareBoostCommHISA; ShareBoostCommHISA)
            {
            }
            column(BoostedAmountHISA; BoostedAmountHISA)
            {
            }
            column(ShareBoostCommHISAFOSA; ShareBoostCommHISAFOSA)
            {
            }
            column(LoanTransferFee; LoanTransferFee)
            {
            }
            column(LoanDisbursedAmount_LoansRegister; "Loans Register"."Loan Disbursed Amount")
            {
            }
            column(BasicPayH_LoansRegister; "Loans Register"."Basic Pay H")
            {
            }
            column(MedicalAllowanceH_LoansRegister; "Loans Register"."Medical AllowanceH")
            {
            }
            column(HouseAllowanceH_LoansRegister; "Loans Register"."House AllowanceH")
            {
            }
            column(StaffAssement_LoansRegister; "Loans Register"."Staff Assement")
            {
            }
            column(Pension_LoansRegister; "Loans Register".Pension)
            {
            }
            column(MedicalInsurance_LoansRegister; "Loans Register"."Medical Insurance")
            {
            }
            column(LifeInsurance_LoansRegister; "Loans Register"."Life Insurance")
            {
            }
            column(OtherLiabilities_LoansRegister; "Loans Register"."Other Liabilities")
            {
            }
            column(TransportBusFare_LoansRegister; "Loans Register"."Transport/Bus Fare")
            {
            }
            column(OtherIncome_LoansRegister; "Loans Register"."Other Income")
            {
            }
            column(PensionScheme_LoansRegister; "Loans Register"."Pension Scheme")
            {
            }
            column(OtherNonTaxable_LoansRegister; "Loans Register"."Other Non-Taxable")
            {
            }
            column(MonthlyContribution_LoansRegister; "Loans Register"."Monthly Contribution")
            {
            }
            column(SaccoDeductions_LoansRegister; "Loans Register"."Sacco Deductions")
            {
            }
            column(OtherTaxRelief_LoansRegister; "Loans Register"."Other Tax Relief")
            {
            }
            column(NHIF_LoansRegister; "Loans Register".NHIF)
            {
            }
            column(NSSF_LoansRegister; "Loans Register".NSSF)
            {
            }
            column(PAYE_LoansRegister; "Loans Register".PAYE)
            {
            }
            column(RiskMGT_LoansRegister; "Loans Register"."Risk MGT")
            {
            }
            column(OtherLoansRepayments_LoansRegister; "Loans Register"."Other Loans Repayments")
            {
            }
            column(BridgeAmountRelease_LoansRegister; "Loans Register"."Bridge Amount Release")
            {
            }
            column(Staff_LoansRegister; "Loans Register".Staff)
            {
            }
            column(Disabled_LoansRegister; "Loans Register".Disabled)
            {
            }
            column(StaffUnionContribution_LoansRegister; "Loans Register"."Staff Union Contribution")
            {
            }
            column(NonPayrollPayments_LoansRegister; "Loans Register"."Non Payroll Payments")
            {
            }
            column(GrossPay_LoansRegister; "Loans Register"."Gross Pay")
            {
            }
            column(TotalDeductionsH_LoansRegister; "Loans Register"."Total DeductionsH")
            {
            }
            column(UtilizableAmount_LoansRegister; "Loans Register"."Utilizable Amount")
            {
            }
            column(NetUtilizableAmount_LoansRegister; "Loans Register"."Net Utilizable")
            {
            }
            column(NettakeHome_LoansRegister; "Loans Register"."Net take Home")
            {
            }
            column(InterestInArrears_LoansRegister; "Loans Register"."Interest In Arrears")
            {
            }
            column(RecommendedAmount_LoansRegister; "Loans Register"."Recommended Amount")
            {
            }
            column(ApprovedAmount_LoansRegister; "Loans Register"."Approved Amount")
            {
            }
            column(TotalOffsetCharge; TotalOffsetCharge)
            {
            }
            dataitem("Loans Guarantee Details"; "Loans Guarantee Details")
            {
                DataItemLink = "Loan No" = field("Loan  No.");
                column(ReportForNavId_5140; 5140)
                {
                }
                column(Amont_Guarant; "Loan No")
                {
                }
                column(Name; Name)
                {
                }
                column(AmontGuaranteed_LoansGuaranteeDetails; "Loans Guarantee Details"."Amont Guaranteed")
                {
                }
                column(Guarantor_Memb_No; "Loans Guarantee Details"."Member No")
                {
                }
                column(G_Shares; "Loans Guarantee Details".Shares)
                {
                }
                column(Loan_Guarant; "Loan No")
                {
                }
                column(Guarantor_Outstanding; "Guarantor Outstanding")
                {
                }
                column(Employer_code; "Employer Code")
                {
                }

                trigger OnAfterGetRecord()
                var
                    GenSetUp: Record "Sacco General Set-Up";
                    Msg: Text;
                    SFactory: codeunit "SURESTEP Factory";
                    Loan: Record "Loans Register";
                begin
                    LoanG.Reset;
                    LoanG.SetRange(LoanG."Member No", "Member No");
                    if LoanG.Find('-') then begin
                        repeat
                            LoanG.CalcFields(LoanG."Guarantor Outstanding");
                            if LoanG."Outstanding Balance" > 0 then begin
                                GuaranteedAmount := GuaranteedAmount + LoanG."Amont Guaranteed";
                                GuarOutstanding := LoanG."Guarantor Outstanding";
                            end;

                        until LoanG.Next = 0;
                    end;
                    TGuaranteedAmount := TGuaranteedAmount + GuaranteedAmount;
                end;
            }
            dataitem("Loan Collateral Details"; "Loan Collateral Details")
            {
                column(ReportForNavId_1000000099; 1000000099)
                {
                }
                column(LoanNo_LoanCollateralDetails; "Loan Collateral Details"."Loan No")
                {
                }
                column(Type_LoanCollateralDetails; "Loan Collateral Details".Type)
                {
                }
                column(SecurityDetails_LoanCollateralDetails; "Loan Collateral Details"."Security Details")
                {
                }
                column(Remarks_LoanCollateralDetails; "Loan Collateral Details".Remarks)
                {
                }
                column(LoanType_LoanCollateralDetails; "Loan Collateral Details"."Loan Type")
                {
                }
                column(Value_LoanCollateralDetails; "Loan Collateral Details".Value)
                {
                }
                column(GuaranteeValue_LoanCollateralDetails; "Loan Collateral Details"."Guarantee Value")
                {
                }
                column(Code_LoanCollateralDetails; "Loan Collateral Details".Code)
                {
                }
                column(Category_LoanCollateralDetails; "Loan Collateral Details".Category)
                {
                }
                column(CollateralMultiplier_LoanCollateralDetails; "Loan Collateral Details"."Collateral Multiplier")
                {
                }
                column(ViewDocument_LoanCollateralDetails; "Loan Collateral Details"."View Document")
                {
                }
                column(AssesmentDone_LoanCollateralDetails; "Loan Collateral Details"."Assesment Done")
                {
                }
                column(AccountNo_LoanCollateralDetails; "Loan Collateral Details"."Account No")
                {
                }
            }
            dataitem("Loan Offset Details"; "Loan Offset Details")
            {
                DataItemLink = "Loan No." = field("Loan  No.");
                DataItemTableView = where("Principle Top Up" = filter(> 0));
                column(ReportForNavId_4717; 4717)
                {
                }
                column(Loans_Top_up__Principle_Top_Up_; "Principle Top Up")
                {
                }
                column(Loans_Top_up__Loan_Type_; "Loan Type")
                {
                }
                column(Loans_Top_up__Client_Code_; "Client Code")
                {
                }
                column(Loans_Top_up__Loan_No__; "Loan No.")
                {
                }
                column(Loans_Top_up__Total_Top_Up_; "Total Top Up")
                {
                }
                column(Loans_Top_up__Interest_Top_Up_; "Interest Top Up")
                {
                }
                column(Loan_Type; "Loan Offset Details"."Loan Type")
                {
                }
                column(Loans_Top_up_Commision; Commision)
                {
                }
                column(Loans_Top_up__Principle_Top_Up__Control1102760116; "Principle Top Up")
                {
                }
                column(BrTopUpCom; BrTopUpCom)
                {
                }
                column(TOTALBRIDGED; TOTALBRIDGED)
                {
                }
                column(Loans_Top_up__Total_Top_Up__Control1102755050; "Total Top Up")
                {
                }
                column(Loans_Top_up_Commision_Control1102755053; Commision)
                {
                }
                column(Loans_Top_up__Interest_Top_Up__Control1102755055; "Interest Top Up")
                {
                }
                column(Total_TopupsCaption; Total_TopupsCaptionLbl)
                {
                }
                column(Bridged_LoansCaption; Bridged_LoansCaptionLbl)
                {
                }
                column(Loan_No_Caption; Loan_No_CaptionLbl)
                {
                }
                column(Loans_Top_up_CommisionCaption; FieldCaption(Commision))
                {
                }
                column(Principal_Top_UpCaption; Principal_Top_UpCaptionLbl)
                {
                }
                column(Loans_Top_up__Interest_Top_Up_Caption; FieldCaption("Interest Top Up"))
                {
                }
                column(Client_CodeCaption; Client_CodeCaptionLbl)
                {
                }
                column(Loan_TypeCaption_Control1102755059; Loan_TypeCaption_Control1102755059Lbl)
                {
                }
                column(TotalsCaption; TotalsCaptionLbl)
                {
                }
                column(Total_Amount_BridgedCaption; Total_Amount_BridgedCaptionLbl)
                {
                }
                column(Bridging_total_higher_than_the_qualifing_amountCaption; Bridging_total_higher_than_the_qualifing_amountCaptionLbl)
                {
                }
                column(WARNING_Caption_Control1102755044; WARNING_Caption_Control1102755044Lbl)
                {
                }
                column(Loans_Top_up_Loan_Top_Up; "Loan Top Up")
                {
                }
                column(WarnBridged; WarnBridged)
                {
                }
                column(WarnSalary; WarnSalary)
                {
                }
                column(WarnDeposits; WarnDeposits)
                {
                }
                column(WarnGuarantor; WarnGuarantor)
                {
                }
                column(WarnShare; WarnShare)
                {
                }
                column(LoanDefaultInfo; DefaultInfo)
                {
                }
                column(Riskamount; Riskamount)
                {
                }
                column(RiskDeposits; RiskDeposits)
                {
                }
                column(RiskGshares; RiskGshares)
                {
                }
                column(LoanoffsetInterest; "Loan Offset Details".Commision)
                {
                }

                trigger OnAfterGetRecord()
                begin

                    TotalTopUp := ROUND((TotalTopUp + "Principle Top Up"), 0.05, '>');
                    TotalIntPayable := TotalIntPayable + "Monthly Repayment";
                    GTotals := GTotals + ("Principle Top Up" + "Monthly Repayment");
                    if "Loans Register".Get("Loan Offset Details"."Loan No.") then begin
                        if LoanType.Get("Loans Register"."Loan Product Type") then begin
                        end;
                    end;

                    TOTALBRIDGED := TOTALBRIDGED + "Loan Offset Details"."Total Top Up";//Total Offset Amount
                end;

                trigger OnPreDataItem()
                begin
                    BrTopUpCom := 0;
                    TOTALBRIDGED := 0;
                end;
            }

            dataitem("Loan Product Charges"; "Loan Product Charges")
            {
                DataItemLink = "Product Code" = field("Loan Product Type");
                column(Product_Code; "Product Code")
                {
                }
                column(FeesCharges; FeesCharges)
                {
                }
                column(Description; Description)
                {
                }
                trigger OnPreDataItem();

                begin

                end;

                trigger OnAfterGetRecord();
                var
                    LoanProductBeingAppraised: Code[50];
                    SaccoGenSetup: Record "Sacco General Set-Up";
                    initialcharge: Decimal;
                    TypeProductCharges: RECORD "Loan Product Charges";
                    LoansRegisterTable: RECORD "Loans register";
                    LoanProductSetUp: record "Loan Products Setup";
                begin
                    FeesCharges := 0;
                    TypeProductCharges.Reset();
                    TypeProductCharges.SetRange(TypeProductCharges."Product Code", "Loan Product Charges"."Product Code");
                    TypeProductCharges.SetRange(TypeProductCharges.Code, "Loan Product Charges".Code);
                    if TypeProductCharges.Find('-') then begin
                        repeat
                            if TypeProductCharges."Use Perc" = true then begin
                                if TypeProductCharges."Charge Excise" = false then begin
                                    if TypeProductCharges.Code <> 'SMSFEE' then
                                        FeesCharges := (Percentage / 100) * "Loans Register"."Recommended Amount" else
                                        if TypeProductCharges.Code = 'SMSFEE' then FeesCharges := (Percentage / 100) * "Loans Register"."Recommended Amount" * FnGuarantorsCount("Loans Register"."Loan  No.");
                                    if TypeProductCharges.Code = 'LINSURANCE' then FeesCharges := Round((Percentage / 100) * "Loans Register"."Recommended Amount" * "Loans Register".Installments / 12, 0.01, '=');

                                    if TypeProductCharges.Code = 'IMPORTCLEARANCE' then FeesCharges := Round((Percentage / 100) * "Loans Register"."Total Outstanding Loan BAL", 0.01, '=');
                                end else
                                    if TypeProductCharges."Charge Excise" = true then begin
                                        SaccoGenSetup.Get();
                                        initialcharge := (Percentage / 100) * "Loans Register"."Recommended Amount";
                                        if TypeProductCharges.Code = 'LINSURANCE' then initialcharge := Round((Percentage / 100) * "Loans Register"."Recommended Amount" * "Loans Register".Installments / 12, 0.01, '=');
                                        if TypeProductCharges.Code <> 'SMSFEE' then
                                            FeesCharges := (initialcharge) + ((SaccoGenSetup."Excise Duty(%)" / 100) * initialcharge) else
                                            if TypeProductCharges.Code = 'SMSFEE' then FeesCharges := (initialcharge) + ((SaccoGenSetup."Excise Duty(%)" / 100) * initialcharge) * FnGuarantorsCount("Loans Register"."Loan  No.");
                                        if TypeProductCharges.Code = 'IMPORTCLEARANCE' then FeesCharges := Round((Percentage / 100) * "Loans Register"."Total Outstanding Loan BAL", 0.01, '=');
                                        if "Loans Register"."Recommended Amount" <= 0 then FeesCharges := 0;
                                    end;
                            end else
                                if TypeProductCharges."Use Perc" = false then begin
                                    if TypeProductCharges."Charge Excise" = false then begin
                                        if TypeProductCharges.Code <> 'SMSFEE' then
                                            FeesCharges := TypeProductCharges.Amount else
                                            if TypeProductCharges.Code = 'SMSFEE' then FeesCharges := TypeProductCharges.Amount * FnGuarantorsCount("Loans Register"."Loan  No.");
                                        if TypeProductCharges.Code = 'LINSURANCE' then FeesCharges := Round(TypeProductCharges.Amount * "Loans Register".Installments / 12, 0.01, '=');
                                        if "Loans Register"."Recommended Amount" <= 0 then FeesCharges := 0;
                                    end
                                    else
                                        if TypeProductCharges."Charge Excise" = true then begin
                                            SaccoGenSetup.Get();
                                            initialcharge := TypeProductCharges.Amount;
                                            if TypeProductCharges.Code = 'LINSURANCE' then initialcharge := Round(TypeProductCharges.Amount * "Loans Register".Installments / 12, 0.01, '=');
                                            if TypeProductCharges.Code <> 'SMSFEE' then
                                                FeesCharges := (initialcharge) + ((SaccoGenSetup."Excise Duty(%)" / 100) * initialcharge) else
                                                if TypeProductCharges.Code = 'SMSFEE' then FeesCharges := (initialcharge) + ((SaccoGenSetup."Excise Duty(%)" / 100) * initialcharge) * FnGuarantorsCount("Loans Register"."Loan  No.");
                                            if "Loans Register"."Recommended Amount" <= 0 then FeesCharges := 0;
                                        end;
                                end;
                        until TypeProductCharges.Next = 0;
                    end;
                end;
            }
            trigger OnAfterGetRecord()
            var
                LoanOffsetDetails: Record "Loan Offset Details";
                GenSetUp: Record "Sacco General Set-Up";
                Msg: Text;
                SFactory: codeunit "SURESTEP Factory";
                LoanGuarantors: Record "Loans Guarantee Details";
            begin
                Cshares := 0;
                MAXAvailable := 0;
                LOANBALANCE := 0;
                TotalTopUp := 0;
                TotalIntPayable := 0;
                GTotals := 0;
                AmountGuaranteed := 0;
                TotLoans := 0;





                TestField("Loans Register"."Requested Amount");
                "Loans Register"."Approved Amount" := "Loans Register"."Requested Amount";
                "Loans Register"."Recommended Amount" := "Loans Register"."Requested Amount";
                "Loans Register".modify;

                GenSetUp.Get();
                //send Sms
                LoanGuarantors.Reset();
                LoanGuarantors.SetRange("Loan No", "Loans Register"."Loan  No.");
                if FindSet() then begin
                    repeat
                        IF GenSetUp."Send Loan Disbursement SMS" = TRUE THEN BEGIN
                            Msg := ('Dear Member,You have guaranteed ' + GetMemberName(LoanGuarantors."Loan No") + ' ' + GetProductType(LoanGuarantors."Loan No") + 'Loan at Swizzsoft DT Sacco Ltd. Call,0733402011/0734402011 if in dispute . Thank you for patronizing Swizzsoft DT Sacco');
                            // SFactory.FnSendSMS('GUARANTORSHIP', Msg, Get_GuarantorAcountNumber(LoanGuarantors."Member No"), SFactory.FnGetMemberMobileNo(LoanGuarantors."Member No"));
                        end;
                    until LoanGuarantors.Next = 0;
                end;

                TotalSec := 0;
                TShares := 0;
                TLoans := 0;
                Earnings := 0;
                Deductions := 0;
                NetSalary := 0;
                LoanPrincipal := 0;
                loanInterest := 0;
                TotalLoanBal := 0;
                TotalBand := 0;
                TotalRepay := 0;
                Upfronts := 0;
                DisbursementFee := 0;
                LegalFee := 0;
                total_deductions := 0;
                ValuationFee := 0;
                LoanInsurance := 0;
                //**********added************

                //  Deposits analysis
                if Cust.Get("Loans Register"."Client Code") then begin
                    Cust.CalcFields(Cust."Current Shares", Cust."Shares Retained");
                    Cshares := Cust."Current Shares";
                    ShareCap := Cust."Shares Retained";
                    if LoanType.Get("Loans Register"."Loan Product Type") then begin

                        RemainigDep := Cshares;
                        //.......................................................................QUALIFICATION AS PER DEPOSITS
                        if LoanType.Get("Loans Register"."Loan Product Type") then begin
                            if "1st Time Loanee" <> true then begin
                                DEpMultiplier := LoanType."Shares Multiplier" * RemainigDep;
                            end else
                                if "1st Time Loanee" = true then begin
                                    DEpMultiplier := LoanType."Shares Multiplier" * RemainigDep;
                                end;
                            DEpMultiplier := LoanType."Shares Multiplier" * RemainigDep;//Abel
                        end;
                        //.......................................................................QUALIFICATION AS PER DEPOSITS  
                    end;
                    //.......................................................................Get Member Total Active Loan Repayments
                    BridgedRepayment := 0;
                    TotalRepayments := 0;
                    LoanApp.Reset;
                    LoanApp.SetRange(LoanApp."Client Code", "Client Code");
                    LoanApp.SetRange(LoanApp.Source, LoanApp.Source::BOSA);
                    LoanApp.SetRange(LoanApp.Posted, true);
                    if LoanApp.Find('-') then begin
                        repeat
                            LoanApp.CalcFields(LoanApp."Outstanding Balance");
                            if LoanApp."Outstanding Balance" > 0 then begin
                                LOANBALANCE := LOANBALANCE + LoanApp."Outstanding Balance";
                                TotalRepayments := LoanApp.Repayment;//Monthly Loan Repayment
                            end;
                        until LoanApp.Next = 0;
                    end;
                    //.......................................................................Get Member Total Active Loan Repayments

                    //.......................................................................Get Member TopUp Repayments Repayments
                    //----------------TotalTopUpDeductions start
                    TotalTopUpDeductions := 0;
                    Upfronts := 0;
                    total_deductions := 0;

                    // Bridged_Amount := 0;
                    LoanTopUp.Reset;
                    LoanTopUp.SetRange(LoanTopUp."Loan No.", "Loans Register"."Loan  No.");
                    if LoanTopUp.Find('-') then begin
                        repeat
                            // Bridged_Amount+=
                            TotalTopUpDeductions += LoanTopUp."Principle Top Up" + loantopup."Interest Top Up" + LoanTopUp.Commision;
                        until LoanTopUp.Next = 0;
                    end;
                    //.................................TotalTopUpDeductions End

                    //imported Loan co
                    //.......................................................................Get Member TopUp Repayments Repayments
                    TotalOffsetCharge := 0;
                    LoanTopUp.Reset;
                    LoanTopUp.SetRange(LoanTopUp."Loan No.", "Loans Register"."Loan  No.");
                    LoanTopUp.SetRange(LoanTopUp."Client Code", "Loans Register"."Client Code");
                    if LoanTopUp.Find('-') then begin
                        repeat
                            TotalOffsetCharge := TotalOffsetCharge + LoanTopUp.Commision;
                            if LoanTopUp."Partial Bridged" = false then begin
                                BridgedRepayment := BridgedRepayment + LoanTopUp."Principle Top Up" + loantopup."Interest Top Up";
                                FinalInst := FinalInst + LoanTopUp."Finale Instalment";
                            end;
                        until LoanTopUp.Next = 0;
                    end;

                    TotalRepayments := TotalRepayments - BridgedRepayment;
                    if totalrepayments < 0 then begin
                        TotalRepayments := 0;
                    end;

                    TotalLoanBal := (LOANBALANCE + "Loans Register"."Approved Amount") - BRIGEDAMOUNT;

                    LBalance := LOANBALANCE - BRIGEDAMOUNT;

                    //Recommended Amount
                    //.............................................................................................................................
                    DepX := "Loans Register"."Requested Amount";

                    //.............................................................................................................................

                    if ("Loans Register".Source = "Loans Register".Source::BOSA) then begin
                        Recomm := ROUND(DepX);
                        if Recomm > DEpMultiplier then
                            Recomm := ROUND(DEpMultiplier, 100, '<');
                        if Recomm > "Loans Register"."Requested Amount" then
                            Recomm := "Loans Register"."Requested Amount";
                        //END ELSE IF Recomm <
                        if Recomm <= 0 then begin
                            Recomm := 0;
                        end;

                        if Recomm > (DEpMultiplier) then
                            Recomm := ROUND((DEpMultiplier), 100, '<');

                        if Recomm > "Loans Register"."Requested Amount" then
                            Recomm := ROUND("Loans Register"."Requested Amount", 100, '<');
                        if Recomm < 0 then begin
                            Recomm := ROUND(Recomm, 100, '<');
                        end;

                        if Recomm > 0 then
                            "Recommended Amount" := Recomm;
                        if Recomm < 0 then
                            "Recommended Amount" := 0;

                        "Loans Register"."Approved Amount" := Recomm;
                        "Loans Register"."Recommended Amount" := Recomm;
                        "Loans Register".Modify;
                        //Recommended Amount

                        //Compute monthly Repayments based on repay method

                        TotalMRepay := 0;
                        LPrincipal := 0;
                        LInterest := 0;
                        LoanAmount := 0;
                        InterestRate := Interest;
                        LoanAmount := "Approved Amount";
                        RepayPeriod := Installments;
                        LBalance := "Approved Amount";

                        "Loans Guarantee Details".Reset;
                        "Loans Guarantee Details".SetRange("Loans Guarantee Details"."Loan No", "Loans Register"."Loan  No.");
                        if "Loans Guarantee Details".Find('-') then begin
                            "Loans Guarantee Details".CalcSums("Loans Guarantee Details"."Amont Guaranteed");
                            TGAmount := "Loans Guarantee Details"."Amont Guaranteed";
                        end;
                    end;


                    TotalMRepay := 0;
                    LPrincipal := 0;
                    LInterest := 0;
                    InterestRate := "Loans Register".Interest;
                    LoanAmount := "Loans Register"."Approved Amount";
                    RepayPeriod := "Loans Register".Installments;
                    LBalance := "Loans Register"."Approved Amount";

                    //..................................................................
                    if "Loans Register"."Repayment Method" = "Loans Register"."repayment method"::Amortised
                       then begin
                        "Loans Register".TestField("Loans Register".Installments);
                        "Loans Register".TestField("Loans Register".Interest);
                        "Loans Register".repayment := ROUND(("Loans Register".Interest / 12 / 100) / (1 - Power((1 + ("Loans Register".Interest / 12 / 100)), -"Loans Register".Installments)) * "Loans Register"."Approved Amount", 1, '>');
                        //"Loans Register"."Loan Interest Repayment" := ("Loans Register".Interest / 12 / 100) / (1 - Power((1 + ("Loans Register".Interest / 12 / 100)), -"Loans Register".Installments)) * "Loans Register"."Approved Amount";
                        "Loans Register"."Loan Interest Repayment" := ROUND("Loans Register"."Approved Amount" / 100 / 12 * "Loans Register".Interest, 0.05, '>');//Interest repayment
                        "Loans Register"."Loan Principle Repayment" := "Loans Register".repayment - "Loans Register"."Loan Interest Repayment";
                    end;

                    if "Loans Register"."Repayment Method" = "Loans Register"."repayment method"::"Straight Line" then begin
                        "Loans Register".TestField("Loans Register".Installments);
                        "Loans Register"."Loan Principle Repayment" := ROUND("Loans Register"."Approved Amount" / "Loans Register".Installments, 1, '>');
                        "Loans Register"."Loan Interest Repayment" := ROUND(("Loans Register".Interest / 1200) * "Loans Register"."Approved Amount", 1, '>');

                        "Loans Register".Repayment := "Loans Register"."Loan Principle Repayment" + "Loans Register"."Loan Interest Repayment";
                        "Loans Register"."Loan Principle Repayment" := "Loans Register"."Loan Principle Repayment";
                        "Loans Register"."Loan Interest Repayment" := "Loans Register"."Loan Interest Repayment";
                        "Loans Register".Modify;
                    end;

                    if "Loans Register"."Repayment Method" = "Loans Register"."repayment method"::"Reducing Balance" then begin
                        "Loans Register".TestField("Loans Register".Interest);
                        "Loans Register".TestField("Loans Register".Installments);//2828
                        "Loans Register"."Loan Principle Repayment" := ROUND("Loans Register"."Approved Amount" / "Loans Register".Installments, 1, '>');
                        "Loans Register"."Loan Interest Repayment" := ROUND(("Loans Register".Interest / 12 / 100) * "Loans Register"."Approved Amount", 1, '>');
                        "Loans Register".repayment := "Loans Register"."Loan Interest Repayment" + "Loans Register"."Loan Principle Repayment";
                    end;
                    if "Loans Register"."Repayment Method" = "Loans Register"."repayment method"::Constants then begin
                        "Loans Register".Repayment := "Loans Register"."Approved Amount" / "Loans Register".Installments;
                        "Loans Register".Modify(true);
                        "Loans Register".TestField("Loans Register".Repayment);
                        if "Loans Register"."Approved Amount" < "Loans Register".Repayment then
                            "Loans Register"."Loan Principle Repayment" := "Loans Register"."Approved Amount"
                        else
                            "Loans Register"."Loan Principle Repayment" := "Loans Register".Repayment;

                        "Loans Register"."Loan Interest Repayment" := "Loans Register".Interest;
                        "Loans Register".repayment := "Loans Register"."Loan Interest Repayment" + "Loans Register"."Loan Principle Repayment";

                    end;
                    //...................................................................

                    "Loans Register".Modify();

                    if "Approved Amount" > 0 then begin
                        //LOAN Charges
                        LegalFee := "Loans Register"."Legal Cost";
                        ValuationFee := "Loans Register"."Valuation Cost";
                        LoanInsurance := "Loans Register".Insurance;

                        LoanProcessingFee := SFactory.FnGetChargeFee("Loans Register"."Loan Product Type", "Loans Register"."Approved Amount", 'PROCESSING');
                        DisbursementFee := SFactory.FnGetChargeFee("Loans Register"."Loan Product Type", Netdisbursed, 'DISBURSEMENT');

                        Upfronts := LoanProcessingFee + LegalFee + DisbursementFee + "Deboost Commision" + "Deboost Amount" + ValuationFee;

                        total_deductions := Upfronts + TotalTopUpDeductions + LoanInsurance;
                        Netdisbursed := ("Approved Amount" - total_deductions);
                        Appraised := true;
                        Modify;
                    end
                end;

            end;

            trigger OnPreDataItem()
            begin

                CompanyInfo.Get();
                CompanyInfo.CalcFields(CompanyInfo.Picture);
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
        if GenSetUp.Get(0) then
            CompanyInfo.Get;
    end;

    local procedure GetMemberName(LoanNumber: code[60]): Text
    var
        LoanRecord: Record "Loans Register";
    begin
        LoanRecord.Reset();
        LoanRecord.SetRange(LoanRecord."Loan  No.", LoanNumber);
        if LoanRecord.FindFirst() then begin
            exit(LoanRecord."Client Name")
        end;
    end;

    local procedure Get_GuarantorAcountNumber(MemberNo: Code[30]): Text
    var
        Cust: Record Customer;
    begin
        Cust.Reset();
        Cust.SetRange(Cust."No.", MemberNo);
        if Cust.FindFirst() then begin
            exit(cust."FOSA Account No.");
        end;
    end;

    local procedure GetAmountApplied(LoanNo: code[60]; MemberNo: text): Decimal
    var
        LoanRecord: Record "Loans Register";
        Guarantors: Record "Loans Guarantee Details";
    begin
        Guarantors.Reset();
        Guarantors.SetRange("Member No", MemberNo);
        Guarantors.SetRange(Guarantors."Loan No", LoanNo);
        if Guarantors.FindFirst() then begin
            exit(Guarantors."Amont Guaranteed")
        end;
    end;

    local procedure GetProductType(LoanNo: code[60]): Text
    var
        LoanRecord: Record "Loans Register";
    begin
        LoanRecord.Reset();
        LoanRecord.SetRange(LoanRecord."Loan  No.", LoanNo);
        if LoanRecord.FindFirst() then begin
            exit(LoanRecord."Loan Product Type")
        end;
    end;


    local procedure FnGuarantorsCount(LoanNo: code[50]): Integer
    var
        LoanGuarantors: record "Loans Guarantee Details";
        Counts: Integer;
    begin
        Counts := 0;
        LoanGuarantors.Reset();
        LoanGuarantors.SetRange(LoanGuarantors."Loan No", LoanNo);
        if LoanGuarantors.find('-') then begin
            Counts := LoanGuarantors.count();
        end;
        exit(Counts);
    end;

    var
        CustRec: Record Customer;
        LoanProcessingFee: Decimal;
        GenSetUp: Record "Sacco General Set-Up";
        Cust: Record Customer;
        CustRecord: Record Customer;
        TShares: Decimal;
        TLoans: Decimal;
        LoanApp: Record "Loans Register";
        ExciseDutyAppraisal: Decimal;
        LoanShareRatio: Decimal;
        Eligibility: Decimal;
        TotalSec: Decimal;
        saccded: Decimal;
        saccded2: Decimal;
        grosspay: Decimal;
        Tdeduct: Decimal;
        Cshares: Decimal;
        "Cshares*3": Decimal;
        "Cshares*4": Decimal;
        QUALIFY_SHARES: Decimal;
        LoanG: Record "Loans Guarantee Details";
        GShares: Decimal;
        Recomm: Decimal;
        GShares1: Decimal;
        ValuationFee: Decimal;
        NETTAKEHOME: Decimal;
        Msalary: Decimal;
        RecPeriod: Integer;
        FOSARecomm: Decimal;
        FOSARecoPRD: Integer;
        "Asset Value": Decimal;
        InterestRate: Decimal;
        RepayPeriod: Decimal;
        LBalance: Decimal;
        TotalMRepay: Decimal;
        LInterest: Decimal;
        LPrincipal: Decimal;
        SecuredSal: Decimal;
        Linterest1: Integer;
        LOANBALANCE: Decimal;
        BRIDGEDLOANS: Record "Loan Offset Details";
        BRIDGEBAL: Decimal;
        LOANBALANCEFOSASEC: Decimal;
        TotalTopUp: Decimal;
        TotalIntPayable: Decimal;
        GTotals: Decimal;
        TempVal: Decimal;
        TempVal2: Decimal;
        "TempCshares*4": Decimal;
        "TempCshares*3": Decimal;
        InstallP: Decimal;
        RecomRemark: Text[150];
        InstallRecom: Decimal;
        TopUpComm: Decimal;
        LegalFee: Decimal;
        total_deductions: Decimal;
        TotalTopupComm: Decimal;
        LoanTopUp: Record "Loan Offset Details";
        "Interest Payable": Decimal;
        LoanType: Record "Loan Products Setup";
        "general set-up": Record "Sacco General Set-Up";
        Days: Integer;
        EndMonthInt: Decimal;
        BRIDGEBAL2: Decimal;
        DefaultInfo: Text[80];
        TOTALBRIDGED: Decimal;
        DEpMultiplier: Decimal;
        MAXAvailable: Decimal;
        SalDetails: Record "Loan Appraisal Salary Details";
        Earnings: Decimal;
        Deductions: Decimal;
        BrTopUpCom: Decimal;
        LoanAmount: Decimal;
        CompanyInfo: Record "Company Information";
        CompanyAddress: Code[20];
        CompanyEmail: Text[30];
        CompanyTel: Code[20];
        CurrentAsset: Decimal;
        FeesCharges: Decimal;
        CurrentLiability: Decimal;
        FixedAsset: Decimal;
        Equity: Decimal;
        Sales: Decimal;
        SalesOnCredit: Decimal;
        AppraiseDeposits: Boolean;
        AppraiseShares: Boolean;
        AppraiseSalary: Boolean;
        AppraiseGuarantors: Boolean;
        AppraiseBusiness: Boolean;
        TLoan: Decimal;
        LoanBal: Decimal;
        GuaranteedAmount: Decimal;
        RunBal: Decimal;
        TGuaranteedAmount: Decimal;
        TotalTopUpDeductions: decimal;
        GuarantorQualification: Boolean;
        Loan_Appraisal_AnalysisCaptionLbl: label 'Loan Appraisal Analysis';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        Loan_Application_DetailsCaptionLbl: label 'Loan Application Details';
        Loan_TypeCaptionLbl: label 'Loan Type';
        MemberCaptionLbl: label 'Member';
        Amount_AppliedCaptionLbl: label 'Amount Applied';
        Deposits__3CaptionLbl: label 'Deposits* 3';
        Eligibility_DetailsCaptionLbl: label 'Eligibility Details';
        Maxim__Amount_Avail__for_the_LoanCaptionLbl: label 'Maxim. Amount Avail. for the Loan';
        Outstanding_LoanCaptionLbl: label 'Outstanding Loan';
        Member_DepositsCaptionLbl: label 'Member Deposits';
        Amount_AppliedCaption_Control1102760132Lbl: label 'Amount Applied';
        MemberCaption_Control1102760133Lbl: label 'Member';
        Loan_TypeCaption_Control1102760134Lbl: label 'Loan Type';
        Loan_Application_DetailsCaption_Control1102760151Lbl: label 'Loan Application Details';
        RepaymentCaptionLbl: label 'Repayment';
        Maxim__Amount_Avail__for_the_LoanCaption_Control1102760150Lbl: label 'Maxim. Amount Avail. for the Loan';
        Total_Outstand__Loan_BalanceCaptionLbl: label 'Total Outstand. Loan Balance';
        Deposits___MulitiplierCaptionLbl: label 'Deposits * Mulitiplier';
        Member_DepositsCaption_Control1102760148Lbl: label 'Member Deposits';
        Deposits_AnalysisCaptionLbl: label 'Deposits Analysis';
        Bridged_AmountCaptionLbl: label 'Bridged Amount';
        Out__Balance_After_Top_upCaptionLbl: label 'Out. Balance After Top-up';
        Recommended_AmountCaptionLbl: label 'Recommended Amount';
        Net_Loan_Disbursement_CaptionLbl: label 'Net Loan Disbursement:';
        V3__Qualification_as_per_GuarantorsCaptionLbl: label '3. Qualification as per Guarantors';
        Defaulter_Info_CaptionLbl: label 'Defaulter Info:';
        V2__Qualification_as_per_SalaryCaptionLbl: label '2. Qualification as per Salary';
        V1__Qualification_as_per_SharesCaptionLbl: label '1. Qualification as per Shares';
        QUALIFICATIONCaptionLbl: label 'QUALIFICATION';
        Insufficient_Deposits_to_cover_the_loan_applied__RiskCaptionLbl: label 'Insufficient Deposits to cover the loan applied: Risk';
        WARNING_CaptionLbl: label 'WARNING:';
        Salary_is_Insufficient_to_cover_the_loan_applied__RiskCaptionLbl: label 'Salary is Insufficient to cover the loan applied: Risk';
        WARNING_Caption_Control1000000140Lbl: label 'WARNING:';
        WARNING_Caption_Control1000000141Lbl: label 'WARNING:';
        Guarantors_do_not_sufficiently_cover_the_loan__RiskCaptionLbl: label 'Guarantors do not sufficiently cover the loan: Risk';
        WARNING_Caption_Control1000000020Lbl: label 'WARNING:';
        Shares_Deposits_BoostedCaptionLbl: label 'Shares/Deposits Boosted';
        I_Certify_that_the_foregoing_details_and_member_information_is_true_statement_of_the_account_maintained_CaptionLbl: label 'I Certify that the foregoing details and member information is true statement of the account maintained.';
        Loans_Asst__Officer______________________CaptionLbl: label 'Loans Asst. Officer:_____________________';
        Signature__________________CaptionLbl: label 'Signature:_________________';
        Date___________________CaptionLbl: label 'Date:__________________';
        General_Manger______________________CaptionLbl: label 'General Manger:_____________________';
        Signature__________________Caption_Control1102760039Lbl: label 'Signature:_________________';
        Date___________________Caption_Control1102760040Lbl: label 'Date:__________________';
        Signature__________________Caption_Control1102755017Lbl: label 'Signature:_________________';
        Date___________________Caption_Control1102755018Lbl: label 'Date:__________________';
        Loans_Officer______________________CaptionLbl: label 'Loans Officer:_____________________';
        Chairman_Signature______________________CaptionLbl: label 'Chairman Signature:_____________________';
        Secretary_s_Signature__________________CaptionLbl: label 'Secretary''s Signature:_________________';
        Members_Signature______________________CaptionLbl: label 'Members Signature:_____________________';
        Credit_Committe_Minute_No______________________CaptionLbl: label 'Credit Committe Minute No._____________________';
        Date___________________Caption_Control1102755074Lbl: label 'Date:__________________';
        Comment______________________________________________________________________________________CaptionLbl: label 'Comment :____________________________________________________________________________________';
        Amount_Approved______________________CaptionLbl: label 'Amount Approved:_____________________';
        Signatory_1__________________CaptionLbl: label 'Signatory 1:_________________';
        Signatory_2__________________CaptionLbl: label 'Signatory 2:_________________';
        Signatory_3__________________CaptionLbl: label 'Signatory 3:_________________';
        FOSA_SIGNATORIES_CaptionLbl: label 'FOSA SIGNATORIES:';
        //Comment______________________________________________________________________________________Caption_Control1102755070Lbl: label 'Comment :____________________________________________________________________________________';
        FINANCE_CaptionLbl: label 'FINANCE:';
        Disbursed_By__________________CaptionLbl: label 'Disbursed By:_________________';
        Signature__________________Caption_Control1102755081Lbl: label 'Signature:_________________';
        Date___________________Caption_Control1102755082Lbl: label 'Date:__________________';
        Salary_Details_AnalysisCaptionLbl: label 'Salary Details Analysis';
        Total_EarningsCaptionLbl: label 'Total Earnings';
        Total_DeductionsCaptionLbl: label 'Total Deductions';
        Net_SalaryCaptionLbl: label 'Net Salary';
        Qualification_as_per_SalaryCaptionLbl: label 'Qualification as per Salary';
        V1_3_of_Gross_PayCaptionLbl: label '1/3 of Gross Pay';
        Amount_GuaranteedCaptionLbl: label 'Amount Guaranteed';
        Loan_GuarantorsCaptionLbl: label 'Loan Guarantors';
        RatioCaptionLbl: label 'Ratio';
        Total_Amount_GuaranteedCaptionLbl: label 'Total Amount Guaranteed';
        Total_TopupsCaptionLbl: label 'Total Topups';
        Bridged_LoansCaptionLbl: label 'Bridged Loans';
        Loan_No_CaptionLbl: label 'Loan No.';
        Principal_Top_UpCaptionLbl: label 'Principal Top Up';
        Client_CodeCaptionLbl: label 'Client Code';
        Loan_TypeCaption_Control1102755059Lbl: label 'Loan Type';
        TotalsCaptionLbl: label 'Totals';
        Total_Amount_BridgedCaptionLbl: label 'Total Amount Bridged';
        Bridging_total_higher_than_the_qualifing_amountCaptionLbl: label 'Bridging total higher than the qualifing amount';
        WARNING_Caption_Control1102755044Lbl: label 'WARNING:';
        TotalLoanBalance: Decimal;
        TGAmount: Decimal;
        NetSalary: Decimal;
        Riskamount: Decimal;
        WarnBridged: Text;
        WarnSalary: Text;
        WarnDeposits: Text;
        WarnGuarantor: Text;
        WarnShare: Text;
        RiskGshares: Decimal;
        RiskDeposits: Decimal;
        BasicEarnings: Decimal;
        DepX: Decimal;
        LoanPrincipal: Decimal;
        loanInterest: Decimal;
        AmountGuaranteed: Decimal;
        StatDeductions: Decimal;
        GuarOutstanding: Decimal;
        TwoThirds: Decimal;
        Bridged_AmountCaption: Integer;
        LNumber: Code[20];
        TotalLoanDeductions: Decimal;
        TotalRepayments: Decimal;
        Totalinterest: Decimal;
        Band: Decimal;
        TotalOutstanding: Decimal;
        BANDING: Record "Deposit Tier Setup";
        NtTakeHome: Decimal;
        LoanApss: Record "Loans Register";
        TotalLoanBal: Decimal;
        TotalBand: Decimal;
        LoanAp: Record "Loans Register";
        TotalRepay: Decimal;
        TotalInt: Decimal;
        LastFieldNo: Integer;
        TotLoans: Decimal;
        JazaLevy: Decimal;
        BridgeLevy: Decimal;
        Upfronts: Decimal;
        DisbursementFee: Decimal;
        Netdisbursed: Decimal;
        TotalLRepayments: Decimal;
        BridgedRepayment: Decimal;
        OutstandingLrepay: Decimal;
        Loantop: Record "Loan Offset Details";
        BRIGEDAMOUNT: Decimal;
        TOTALBRIGEDAMOUNT: Decimal;
        FinalInst: Decimal;
        NonRec: Decimal;
        OTHERDEDUCTIONS: Decimal;
        StartDate: Date;
        DateFilter: Text[100];
        FromDate: Date;
        ToDate: Date;
        FromDateS: Text[100];
        ToDateS: Text[100];
        DivTotal: Decimal;
        CDeposits: Decimal;
        CustDiv: Record Customer;
        DivProg: Record "Dividends Progression";
        CDiv: Decimal;
        BDate: Date;
        CustR: Record Customer;
        BasicPay: Decimal;
        HouseAllowance: Decimal;
        TransportAll: Decimal;
        MedicalAll: Decimal;
        OtherIncomes: Decimal;
        GrossP: Decimal;
        MonthlyCont: Decimal;
        NHIF: Decimal;
        PAYE: Decimal;
        Risk: Decimal;
        LifeInsurance: Decimal;
        OtherLiabilities: Decimal;
        SaccoDed: Decimal;
        ProductCharges: Record "Loan Product Charges";
        LoanInsurance: Decimal;
        CustLeg: Record "Cust. Ledger Entry";
        BoostedAmount2: Decimal;
        ShareBoostComm: Decimal;
        currentshare: Decimal;
        SMSFEE: Decimal;
        HisaARREAR: Decimal;
        ShareBoostCommHISA: Decimal;
        BoostedAmountHISA: Decimal;
        Loans: Record "Loans Register";
        ShareBoostCommHISAFOSA: Decimal;
        LoanTransferFee: Decimal;
        RemainingDays: Integer;
        IARR: Decimal;
        TotalBridgeAmount: Decimal;
        LoanCashClearedFee: Decimal;
        Collateral: Record "Loan Collateral Details";
        CollateralAmount: Decimal;
        ShareCap: Decimal;
        LPFcharge: Decimal;
        LAppraisalFee: Decimal;
        LAppraisalFeeAccount: Code[20];
        TscInt: Decimal;
        AccruedInt: Decimal;
        ProcessingFee: Decimal;
        LoanFormFee: Decimal;
        SaccoInt: Decimal;
        ArmotizationFactor: Decimal;
        ArmotizationFInstalment: Decimal;
        SaccoIntRelief: Decimal;
        SuperLoanBal: Decimal;
        QualifyingDep: Decimal;
        RemainigDep: Decimal;
        Totalhomeloan: Decimal;
        Exciseduty: Decimal;
        AccruedinterestVisible: Decimal;
        AppraisalFeeVisible: Decimal;
        TotalOffsetCharge: Decimal;


    procedure ComputeTax()
    begin
    end;
}

