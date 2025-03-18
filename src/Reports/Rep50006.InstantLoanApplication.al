namespace KRBERPSourceCode.KRBERPSourceCode;

report 50006 "Instant LoanApplication"
{
    ApplicationArea = All;
    Caption = 'Instant LoanApplication';
    UsageCategory = ReportsAndAnalysis;
    // DefaultLayout = RDLC;
    // RDLCLayout = './Layouts/InstantLoanApplication.rdlc';
    PreviewMode = PrintLayout;
    dataset
    {
        dataitem(LoansRegister; "Loans Register")
        {
            // column(1stNotice; "1st Notice")
            // {
            // }
            // column(1stTimeLoanee; "1st Time Loanee")
            // {
            // }
            // column(2ndNotice; "2nd Notice")
            // {
            // }
            // column(4Bridging; "4 % Bridging")
            // {
            // }
            column(AccountNo; "Account No")
            {
            }
            column(AdjtedRepayment; "Adjted Repayment")
            {
            }
            column(Adjustment; Adjustment)
            {
            }
            column(AdministrativeFee; "Administrative Fee")
            {
            }
            column(AdvanceLoanNo; "Advance Loan No")
            {
            }
            column(AdvanceToRecover; "Advance To Recover")
            {
            }
            column(Advice; Advice)
            {
            }
            column(AdviceDate; "Advice Date")
            {
            }
            column(AdviceType; "Advice Type")
            {
            }
            column(AffidavitEstimatedValue1; "Affidavit - Estimated Value 1")
            {
            }
            column(AffidavitEstimatedValue2; "Affidavit - Estimated Value 2")
            {
            }
            column(AffidavitEstimatedValue3; "Affidavit - Estimated Value 3")
            {
            }
            column(AffidavitEstimatedValue4; "Affidavit - Estimated Value 4")
            {
            }
            column(AffidavitEstimatedValue5; "Affidavit - Estimated Value 5")
            {
            }
            column(AffidavitItem1Details; "Affidavit - Item 1 Details")
            {
            }
            column(AffidavitItem2Details; "Affidavit - Item 2 Details")
            {
            }
            column(AffidavitItem3Details; "Affidavit - Item 3 Details")
            {
            }
            column(AffidavitItem5Details; "Affidavit - Item 5 Details")
            {
            }
            column(AffidavitSigned; "Affidavit Signed?")
            {
            }
            column(AmortizationInterestRate; "Amortization Interest Rate")
            {
            }
            column(AmountDisburse; "Amount Disburse")
            {
            }
            column(AmountDisbursed; "Amount Disbursed")
            {
            }
            column(AmountOfTranche; "Amount Of Tranche")
            {
            }
            column(AmountPayedOff; "Amount Payed Off")
            {
            }
            column(AmountToDisburse; "Amount To Disburse")
            {
            }
            column(AmountinArrears; "Amount in Arrears")
            {
            }
            column(AmounttoDisburseonTranch1; "Amount to Disburse on Tranch 1")
            {
            }
            column(AppealAmount; "Appeal Amount")
            {
            }
            column(AppealPosted; "Appeal Posted")
            {
            }
            column(ApplicationDate; "Application Date")
            {
            }
            column(ApplicationFeePaid; "Application Fee Paid")
            {
            }
            column(ApplnbetweenCurrencies; "Appln. between Currencies")
            {
            }
            column(AppraisalFeePaid; "Appraisal Fee Paid")
            {
            }
            column(AppraisalStatus; "Appraisal Status")
            {
            }
            column(Appraised; Appraised)
            {
            }
            column(ApprovalStatus; "Approval Status")
            {
            }
            column(Approvalremarks; "Approval remarks")
            {
            }
            column(ApprovedAmount; "Approved Amount")
            {
            }
            column(ApprovedBy; "Approved By")
            {
            }
            column(ApprovedRepayment; "Approved Repayment")
            {
            }
            column(ArmotizationFactor; "Armotization Factor")
            {
            }
            column(AssetValuationCost; "Asset Valuation Cost")
            {
            }
            column(Attached; Attached)
            {
            }
            column(AttachedAmount; "Attached Amount")
            {
            }
            column(AttachementDate; "Attachement Date")
            {
            }
            column(BLAClearanceLoan; "BLA Clearance Loan")
            {
            }
            column(BOSADeposits; "BOSA Deposits")
            {
            }
            column(BOSALoanAmount; "BOSA Loan Amount")
            {
            }
            column(BOSALoanNo; "BOSA Loan No.")
            {
            }
            column(BOSANo; "BOSA No")
            {
            }
            column(BSExpensesEducation; "BSExpenses Education")
            {
            }
            column(BSExpensesFood; "BSExpenses Food")
            {
            }
            column(BSExpensesOthers; "BSExpenses Others")
            {
            }
            column(BSExpensesRent; "BSExpenses Rent")
            {
            }
            column(BSExpensesTransport; "BSExpenses Transport")
            {
            }
            column(BSExpensesUtilities; "BSExpenses Utilities")
            {
            }
            column(BalanceBF; "Balance BF")
            {
            }
            column(BankAccount; "Bank Account")
            {
            }
            column(BankBranch; "Bank Branch")
            {
            }
            column(BankBridgeAmount; "Bank Bridge Amount")
            {
            }
            column(BankCharges; "Bank Charges")
            {
            }
            column(BankName; "Bank Name")
            {
            }
            column(BankStatementAvarageCredits; "Bank Statement Avarage Credits")
            {
            }
            column(BankStatementAvarageDebits; "Bank Statement Avarage Debits")
            {
            }
            column(BankStatementNetIncome; "Bank Statement Net Income")
            {
            }
            column(Bankcode; "Bank code")
            {
            }
            column(BasicPay; "Basic Pay")
            {
            }
            column(BasicPayH; "Basic Pay H")
            {
            }
            column(BatchNo; "Batch No.")
            {
            }
            column(BelaBranch; "Bela Branch")
            {
            }
            column(BoardApprovalComment; "Board Approval Comment")
            {
            }
            column(BoardApprovalStatus; "Board Approval Status")
            {
            }
            column(BoardApprovedBy; "Board Approved By")
            {
            }
            column(BoostthisLoan; "Boost this Loan")
            {
            }
            column(BoostedAmount; "Boosted Amount")
            {
            }
            column(BoostedAmountInterest; "Boosted Amount Interest")
            {
            }
            column(BoosterLoanNo; "Booster Loan No")
            {
            }
            column(BoostingCommision; "Boosting Commision")
            {
            }
            column(BranchCode; "Branch Code")
            {
            }
            column(BridgeAmountRelease; "Bridge Amount Release")
            {
            }
            column(Bridged; Bridged)
            {
            }
            column(Bridging; Bridging)
            {
            }
            column(BridgingLoanPosted; "Bridging Loan Posted")
            {
            }
            column(BridgingPostingDate; "Bridging Posting Date")
            {
            }
            column(CapitalizedCharges; "Capitalized Charges")
            {
            }
            column(CapturedBy; "Captured By")
            {
            }
            column(CashierBranch; "Cashier Branch")
            {
            }
            column(ChargeablePay; "Chargeable Pay")
            {
            }
            column(CheckUtility; "Check Utility")
            {
            }
            column(CheckedBy; "Checked By")
            {
            }
            column(ChequeDate; "Cheque Date")
            {
            }
            column(ChequeNo; "Cheque No.")
            {
            }
            column(ChequeNumber; "Cheque Number")
            {
            }
            column(ClearedEffects; "Cleared Effects")
            {
            }
            column(ClientCode; "Client Code")
            {
            }
            column(ClientCycle; "Client Cycle")
            {
            }
            column(ClientName; "Client Name")
            {
            }
            column(CommitementsOffset; "Commitements Offset")
            {
            }
            column(CompoundBalance; "Compound Balance")
            {
            }
            column(Consolidation; Consolidation)
            {
            }
            column(ContraAccount; "Contra Account")
            {
            }
            column(Contract; Contract)
            {
            }
            column(ContractualShares; "Contractual Shares")
            {
            }
            column(CopyofID; "Copy of ID")
            {
            }
            column(CreditOfficer; "Credit Officer")
            {
            }
            column(CurrentInterestPaid; "Current Interest Paid")
            {
            }
            column(CurrentLocation; "Current Location")
            {
            }
            column(CurrentRepayment; "Current Repayment")
            {
            }
            column(CurrentShares; "Current Shares")
            {
            }
            column(DailyInterestDue; "Daily Interest Due")
            {
            }
            column(DateApproved; "Date Approved")
            {
            }
            column(DateRescheduled; "Date Rescheduled")
            {
            }
            column(DateforAffidavit; "Date for Affidavit")
            {
            }
            column(DatepaymentProcessed; "Date payment Processed")
            {
            }
            column(DaysInArrears; "Days In Arrears")
            {
            }
            column(DeboostAmount; "Deboost Amount")
            {
            }
            column(DeboostCommision; "Deboost Commision")
            {
            }
            column(DeboostLoanApplied; "Deboost Loan Applied")
            {
            }
            column(DebtCollectiondateAssigned; "Debt Collection date Assigned")
            {
            }
            column(DebtCollectorName; "Debt Collector Name")
            {
            }
            column(Deductible; Deductible)
            {
            }
            column(Defaulted; Defaulted)
            {
            }
            column(Defaulter; Defaulter)
            {
            }
            column(DefaulterOveride; "Defaulter Overide")
            {
            }
            column(DefaulterOverideReasons; "Defaulter Overide Reasons")
            {
            }
            column(DefaulterInfo; DefaulterInfo)
            {
            }
            column(DepositReinstatement; "Deposit Reinstatement")
            {
            }
            column(Dimension; Dimension)
            {
            }
            column(Disabled; Disabled)
            {
            }
            column(DisburesmentType; "Disburesment Type")
            {
            }
            column(DisbursedAmt; "Disbursed Amt")
            {
            }
            column(DisbursedBy; "Disbursed By")
            {
            }
            column(DisbursementStatus; "Disbursement Status")
            {
            }
            column(Discard; Discard)
            {
            }
            column(DiscountedAmount; "Discounted Amount")
            {
            }
            column(DocNoUsed; "Doc No Used")
            {
            }
            column(DoublicateLoans; "Doublicate Loans")
            {
            }
            column(Doubtful; Doubtful)
            {
            }
            column(EditInterestCalculationMeth; "Edit Interest Calculation Meth")
            {
            }
            column(EditInterestRate; "Edit Interest Rate")
            {
            }
            column(EmployerCode; "Employer Code")
            {
            }
            column(EmployerName; "Employer Name")
            {
            }
            column(EstimatedYearstoRetire; "Estimated Years to Retire")
            {
            }
            column(ExemptFromPayrollDeduction; "Exempt From Payroll Deduction")
            {
            }
            column(ExisitingLoansRepayments; "Exisiting Loans Repayments")
            {
            }
            column(ExistingLoan; "Existing Loan")
            {
            }
            column(ExistingLoanRepayments; "Existing Loan Repayments")
            {
            }
            column(ExpRepay; "Exp Repay")
            {
            }
            column(ExpectedDateofCompletion; "Expected Date of Completion")
            {
            }
            column(ExternalEFT; "External EFT")
            {
            }
            column(FieldOffice; "Field Office")
            {
            }
            column(FinalNotice; "Final Notice")
            {
            }
            column(FlatRatePrincipal; "Flat Rate Principal")
            {
            }
            column(FlatrateInterest; "Flat rate Interest")
            {
            }
            column(FullyDisbursed; "Fully Disbursed")
            {
            }
            column(GLAccount; "G/L Account")
            {
            }
            column(Gender; Gender)
            {
            }
            column(GlobalDimension1Code; "Global Dimension 1 Code")
            {
            }
            column(GlobalDimension2Code; "Global Dimension 2 Code")
            {
            }
            column(GracePeriod; "Grace Period")
            {
            }
            column(GracePeriodInterestM; "Grace Period - Interest (M)")
            {
            }
            column(GracePeriodPrincipleM; "Grace Period - Principle (M)")
            {
            }
            column(GrossPay; "Gross Pay")
            {
            }
            column(GroupAccount; "Group Account")
            {
            }
            column(GroupCode; "Group Code")
            {
            }
            column(GroupShares; "Group Shares")
            {
            }
            column(GuarantorAmount; "Guarantor Amount")
            {
            }
            column(GuarantorShipLiability; "GuarantorShip Liability")
            {
            }
            column(HisaAllocation; "Hisa Allocation")
            {
            }
            column(HisaBoostingCommission; "Hisa Boosting Commission")
            {
            }
            column(HisaCommission; "Hisa Commission")
            {
            }
            column(HouseAllowance; "House Allowance")
            {
            }
            column(HouseAllowanceH; "House AllowanceH")
            {
            }
            column(IDNO; "ID NO")
            {
            }
            column(InDueAttached; InDueAttached)
            {
            }
            column(IncomeType; "Income Type")
            {
            }
            column(InitialTrunch; "Initial Trunch")
            {
            }
            column(InsiderEmployee; "Insider-Employee")
            {
            }
            column(Insiderboard; "Insider-board")
            {
            }
            column(InstallmentIncludingGrace; "Installment Including Grace")
            {
            }
            column(Installments; Installments)
            {
            }
            column(InstalmentPeriod; "Instalment Period")
            {
            }
            column(Insurance; "Loan Insurance")
            {
            }
            column(Insurance025; "Insurance 0.25")
            {
            }
            column(InsuranceOnShares; "Insurance On Shares")
            {
            }
            column(InsurancePayoff; "Insurance Payoff")
            {
            }
            column(InsuranceUpfront; "Insurance Upfront")
            {
            }
            column(Interest; Interest)
            {
            }
            column(InterestCalculationMethod; "Interest Calculation Method")
            {
            }
            column(InterestDebit; "Interest Debit")
            {
            }
            column(InterestDue; "Interest Due")
            {
            }
            column(InterestInArrears; "Interest In Arrears")
            {
            }
            column(InterestPaid; "Interest Paid")
            {
            }
            column(InterestToDate; "Interest To Date")
            {
            }
            column(InterestUpfront; "Interest Upfront")
            {
            }
            column(InterestUpfrontAmount; "Interest Upfront Amount")
            {
            }
            column(Interesttobepaid; "Interest to be paid")
            {
            }
            column(IntersetInArreas; IntersetInArreas)
            {
            }
            column(IsBLA; "Is BLA")
            {
            }
            column(IsTopUp; "Is Top Up")
            {
            }
            column(IssuedDate; "Issued Date")
            {
            }
            column(JazaDeposits; "Jaza Deposits")
            {
            }
            column(KRAPinNo; "KRA Pin No.")
            {
            }
            column(LastAdviceDate; "Last Advice Date")
            {
            }
            column(LastDateDefaulterSMS; "Last Date Defaulter SMS")
            {
            }
            column(LastIntDate; "Last Int Date")
            {
            }
            column(LastInterestDueDate; "Last Interest Due Date")
            {
            }
            column(LastInterestPayDate; "Last Interest Pay Date")
            {
            }
            column(LastLoanIssueDate; "Last Loan Issue Date")
            {
            }
            column(LastPayDate; "Last Pay Date")
            {
            }
            column(Lastloan; "Last loan")
            {
            }
            column(LeastRetainedAmount; "Least Retained Amount")
            {
            }
            column(LegalCost; "Legal Cost")
            {
            }
            column(LegalFees; "Legal Fees")
            {
            }
            column(LevyOnJazaDeposits; "Levy On Jaza Deposits")
            {
            }
            column(LifeInsurance; "Life Insurance")
            {
            }
            column(LoanCashCleared; "Loan  Cash Cleared")
            {
            }
            column(LoanNo; "Loan  No.")
            {
            }
            column(LoanAccountNo; "Loan Account No")
            {
            }
            column(LoanAmount; "Loan Amount")
            {
            }
            column(LoanAppeal; "Loan Appeal")
            {
            }
            column(LoanAppraisalFee; "Loan Appraisal Fee")
            {
            }
            column(LoanBalanceatRescheduling; "Loan Balance at Rescheduling")
            {
            }
            column(LoanCalcOffsetLoan; "Loan Calc. Offset Loan")
            {
            }
            column(LoanCashClearancefee; "Loan Cash Clearance fee")
            {
            }
            column(LoanCount; "Loan Count")
            {
            }
            column(LoanCycle; "Loan Cycle")
            {
            }
            column(LoanDebtCollector; "Loan Debt Collector")
            {
            }
            column(LoanDebtCollectorInterest; "Loan Debt Collector Interest %")
            {
            }
            column(LoanDeductions; "Loan Deductions")
            {
            }
            column(LoanDepositMultiplier; "Loan Deposit Multiplier")
            {
            }
            column(LoanDirbusementFee; "Loan Dirbusement Fee")
            {
            }
            column(LoanDisbursedAmount; "Loan Disbursed Amount")
            {
            }
            column(LoanDisbursementDate; "Loan Disbursement Date")
            {
            }
            column(LoanDue; "Loan Due")
            {
            }
            column(LoanGLInsurance; "Loan GL Insurance")
            {
            }
            column(LoanInsurance; "Loan Insurance")
            {
            }
            column(LoanInsuranceCharged; "Loan Insurance Charged")
            {
            }
            column(LoanInsurancePaid; "Loan Insurance Paid")
            {
            }
            column(LoanInterestRepayment; "Loan Interest Repayment")
            {
            }
            column(LoanLastPayDate; "Loan Last Pay Date")
            {
            }
            column(LoanLastPaydate2009Nav; "Loan Last Pay date 2009Nav")
            {
            }
            column(LoanNoFound; "Loan No Found")
            {
            }
            column(LoanPrincipleRepayment; "Loan Principle Repayment")
            {
            }
            column(LoanProcessing; "Loan Processing")
            {
            }
            column(LoanProcessingFee; "Loan Processing Fee")
            {
            }
            column(LoanProductType; "Loan Product Type")
            {
            }
            column(LoanProductTypeName; "Loan Product Type Name")
            {
            }
            column(LoanPurpose; "Loan Purpose")
            {
            }
            column(LoanReceived; "Loan Received")
            {
            }
            column(LoanRepayment; "Loan Repayment")
            {
            }
            column(LoanReschedule; "Loan Reschedule")
            {
            }
            column(LoanRescheduleInstalments; "Loan Reschedule Instalments")
            {
            }
            column(LoanRescheduledBy; "Loan Rescheduled By")
            {
            }
            column(LoanRescheduledDate; "Loan Rescheduled Date")
            {
            }
            column(LoanSMSFee; "Loan SMS Fee")
            {
            }
            column(LoanSeriesCount; "Loan Series Count")
            {
            }
            column(LoanStatus; "Loan Status")
            {
            }
            column(LoanTransferFee; "Loan Transfer Fee")
            {
            }
            column(LoanUnderDebtCollection; "Loan Under Debt Collection")
            {
            }
            column(LoantoReschedule; "Loan to Reschedule")
            {
            }
            column(LoantoShareRatio; "Loan to Share Ratio")
            {
            }
            column(LoansCategory; "Loans Category")
            {
            }
            column(LoansCategoryPreviousYear; "Loans Category Previous Year")
            {
            }
            column(LoansCategorySASRA; "Loans Category-SASRA")
            {
            }
            column(LoansInsurance; "Loans Insurance")
            {
            }
            column(LstLN1; "Lst LN1")
            {
            }
            column(LstLN2; "Lst LN2")
            {
            }
            column(LumpsumAmountCharge; "Lumpsum Amount Charge")
            {
            }
            column(MagistrateName; "Magistrate Name")
            {
            }
            column(MainSector; "Main-Sector")
            {
            }
            column(MaxInstallments; "Max. Installments")
            {
            }
            column(MaxLoanAmount; "Max. Loan Amount")
            {
            }
            column(MedicalAllowanceH; "Medical AllowanceH")
            {
            }
            column(MedicalInsurance; "Medical Insurance")
            {
            }
            column(MemberAccountCategory; "Member Account Category")
            {
            }
            column(MemberCategory; "Member Category")
            {
            }
            column(MemberDeposits; "Member Deposits")
            {
            }
            column(MemberFound; "Member Found")
            {
            }
            column(MemberGroup; "Member Group")
            {
            }
            column(MemberGroupName; "Member Group Name")
            {
            }
            column(MemberHouseGroup; "Member House Group")
            {
            }
            column(MemberHouseGroupName; "Member House Group Name")
            {
            }
            column(MemberNotFound; "Member Not Found")
            {
            }
            column(MemberShareCapital; "Member Share Capital")
            {
            }
            column(MembershipDurationYears; "Membership Duration(Years)")
            {
            }
            column(MileageAllowance; "Mileage Allowance")
            {
            }
            column(MinDepositAsPerTier; "Min Deposit As Per Tier")
            {
            }
            column(ModeofDisbursement; "Mode of Disbursement")
            {
            }
            column(MonthlyContribution; "Monthly Contribution")
            {
            }
            column(MonthlySharesCont; "Monthly Shares Cont")
            {
            }
            column(NHIF; NHIF)
            {
            }
            column(NSSF; NSSF)
            {
            }
            column(NetAmount; "Net Amount")
            {
            }
            column(NetIncome; "Net Income")
            {
            }
            column(NetPaymenttoFOSA; "Net Payment to FOSA")
            {
            }
            column(NetUtilizableAmount; "Net Utilizable Amount")
            {
            }
            column(NettakeHome; "Net take Home")
            {
            }
            column(Nettakehome2; "Net take home 2")
            {
            }
            column(NewGracePeriod; "New Grace Period")
            {
            }
            column(NewInterestRate; "New Interest Rate")
            {
            }
            column(NewNoofInstalment; "New No. of Instalment")
            {
            }
            column(NewRegularInstalment; "New Regular Instalment")
            {
            }
            column(NewRepaymentPeriod; "New Repayment Period")
            {
            }
            column(Nextdisbursementdate; Nextdisbursementdate)
            {
            }
            column(NoLoaninMB; "No Loan in MB")
            {
            }
            column(NoofActiveLoans; "No of Active Loans")
            {
            }
            column(NoofDaysinArrears; "No of Days in Arrears")
            {
            }
            column(NoofGurantorsFOSA; "No of Gurantors FOSA")
            {
            }
            column(NoofMonthsinArrears; "No of Months in Arrears")
            {
            }
            column(NoofTranchDisbursment; "No of Tranch Disbursment")
            {
            }
            column(NoOfGuarantors; "No. Of Guarantors")
            {
            }
            column(NoOfGuarantorsFOSA; "No. Of Guarantors-FOSA")
            {
            }
            column(NoSeries; "No. Series")
            {
            }
            column(NonPayrollPayments; "Non Payroll Payments")
            {
            }
            column(NotifyGuarantorSMS; "Notify Guarantor SMS")
            {
            }
            column(OldAccountNo; "Old Account No.")
            {
            }
            column(OldVendorNo; "Old Vendor No")
            {
            }
            column(OriginalApprovedAmount; "Original Approved Amount")
            {
            }
            column(OriginalApprovedUpdated; "Original Approved Updated")
            {
            }
            column(OriginalLoan; "Original Loan")
            {
            }
            column(OtherAllowance; "Other Allowance")
            {
            }
            column(OtherBenefits; "Other Benefits")
            {
            }
            column(OtherCommitmentsClearance; "Other Commitments Clearance")
            {
            }
            column(OtherIncome; "Other Income")
            {
            }
            column(OtherLiabilities; "Other Liabilities")
            {
            }
            column(OtherLoansRepayments; "Other Loans Repayments")
            {
            }
            column(OtherNonTaxable; "Other Non-Taxable")
            {
            }
            column(OtherTaxRelief; "Other Tax Relief")
            {
            }
            column(OustandingInterest; "Oustanding Interest")
            {
            }
            column(OustandingInteresttoDate; "Oustanding Interest to Date")
            {
            }
            column(OutstandingBalance; "Outstanding Balance")
            {
            }
            column(OutstandingBalancetoDate; "Outstanding Balance to Date")
            {
            }
            column(OutstandingBalanceCapitalize; "Outstanding Balance-Capitalize")
            {
            }
            column(OutstandingInsurance; "Outstanding Insurance")
            {
            }
            column(OutstandingLoan; "Outstanding BAlance")
            {
            }
            column(OutstandingLoan2; "Outstanding Loan2")
            {
            }
            column(OutstandingPenalty; "Outstanding Penalty")
            {
            }
            column(OverdraftInstallements; "Overdraft Installements")
            {
            }
            column(PAYE; PAYE)
            {
            }
            column(PartialDisbursedAmountDue; "Partial Disbursed(Amount Due)")
            {
            }
            column(Partialdisbursedamount; Partialdisbursedamount)
            {
            }
            column(PayingBankAccountNo; "Paying Bank Account No")
            {
            }
            column(PaymentDueDate; "Payment Due Date")
            {
            }
            column(PayrollCodeB; "Payroll CodeB")
            {
            }
            column(PaysInterestDuringGP; "Pays Interest During GP")
            {
            }
            column(Payslip; Payslip)
            {
            }
            column(Penalty; Penalty)
            {
            }
            column(PenaltyAmount; "Penalty Amount")
            {
            }
            column(PenaltyCharged; "Penalty Charged")
            {
            }
            column(PenaltyPaid; "Penalty Paid")
            {
            }
            column(PenaltyAttached; PenaltyAttached)
            {
            }
            column(Pension; Pension)
            {
            }
            column(PensionNo; "Pension No")
            {
            }
            column(PensionScheme; "Pension Scheme")
            {
            }
            column(PercentRepayments; "Percent Repayments")
            {
            }
            column(Performing; Performing)
            {
            }
            column(PersonalLoanOffset; "Personal Loan Off-set")
            {
            }
            column(Posted; Posted)
            {
            }
            column(PostedBy; "Posted By")
            {
            }
            column(PreviousRepayment; "Previous Repayment")
            {
            }
            column(PreviousYearsDividend; "Previous Years Dividend")
            {
            }
            column(PrincipalInArrears; "Principal In Arrears")
            {
            }
            column(PrincipalPaid; "Principal Paid")
            {
            }
            column(PrivateMember; "Private Member")
            {
            }
            column(ProcessedPayment; "Processed Payment")
            {
            }
            column(ProductCode; "Product Code")
            {
            }
            column(ProductCurrencyCode; "Product Currency Code")
            {
            }
            column(ProjectAccountNo; "Project Account No")
            {
            }
            column(ProjectAmount; "Project Amount")
            {
            }
            column(ProvidentFund; "Provident Fund")
            {
            }
            column(ProvidentFundSelf; "Provident Fund (Self)")
            {
            }
            column(RAmount; RAmount)
            {
            }
            column(ReasonForLoanReschedule; "Reason For Loan Reschedule")
            {
            }
            column(ReceivedCopiesofPayslip; "Received Copies of Payslip")
            {
            }
            column(ReceivedCopyOfID; "Received Copy Of ID")
            {
            }
            column(ReceivedPayslipBankStatemen; "Received Payslip/Bank Statemen")
            {
            }
            column(RecommendedAmount; "Recommended Amount")
            {
            }
            column(ReconIssue; "Recon Issue")
            {
            }
            column(Reconciled; Reconciled)
            {
            }
            column(RecoveredBalance; "Recovered Balance")
            {
            }
            column(RecoveredFromGuarantor; "Recovered From Guarantor")
            {
            }
            column(RecoveredLoan; "Recovered Loan")
            {
            }
            column(RecoveryMode; "Recovery Mode")
            {
            }
            column(Refinancing; Refinancing)
            {
            }
            column(RegistrationDate; "Registration Date")
            {
            }
            column(RejectedBy; "Rejected By")
            {
            }
            column(RejectionRemark; "Rejection  Remark")
            {
            }
            column(ReleasedBy; "Released By")
            {
            }
            column(ReleasedByAuditor; "Released By Auditor")
            {
            }
            column(Remarks; Remarks)
            {
            }
            column(RepayCount; "Repay Count")
            {
            }
            column(Repayment; Repayment)
            {
            }
            column(RepaymentDatesRescheduled; "Repayment Dates Rescheduled")
            {
            }
            column(RepaymentDatesRescheduledBy; "Repayment Dates Rescheduled By")
            {
            }
            column(RepaymentDatesRescheduledOn; "Repayment Dates Rescheduled On")
            {
            }
            column(RepaymentFrequency; "Repayment Frequency")
            {
            }
            column(RepaymentMethod; "Repayment Method")
            {
            }
            column(RepaymentRate; "Repayment Rate")
            {
            }
            column(RepaymentStartDate; "Repayment Start Date")
            {
            }
            column(RepaymentsBF; "Repayments BF")
            {
            }
            column(RequestedAmount; "Requested Amount")
            {
            }
            column(Rescheduleby; "Reschedule by")
            {
            }
            column(Rescheduled; Rescheduled)
            {
            }
            column(Reversed; Reversed)
            {
            }
            column(RiskMGT; "Risk MGT")
            {
            }
            column(SaccoDeductions; "Sacco Deductions")
            {
            }
            column(SaccoInterest; "Sacco Interest")
            {
            }
            column(SalaryNetUtilizable; "Salary Net Utilizable")
            {
            }
            column(SalaryTotalIncome; "Salary Total Income")
            {
            }
            column(Savings; Savings)
            {
            }
            column(Sceduled; Sceduled)
            {
            }
            column(ScheduleInstallments; "Schedule Installments")
            {
            }
            column(ScheduleInterest; "Schedule Interest")
            {
            }
            column(ScheduleInteresttoDate; "Schedule Interest to Date")
            {
            }
            column(ScheduleLoanAmountIssued; "Schedule Loan Amount Issued")
            {
            }
            column(ScheduleRepayment; "Schedule Repayment")
            {
            }
            column(ScheduleRepayments; "Schedule Repayments")
            {
            }
            column(ScheduledInterestPayments; "Scheduled Interest Payments")
            {
            }
            column(ScheduledPrincipaltoDate; "Scheduled Principal to Date")
            {
            }
            column(ScheduledPrinciplePayments; "Scheduled Principle Payments")
            {
            }
            column(SelfGuarantorShipLiability; "Self GuarantorShip Liability")
            {
            }
            column(ShareBoostingComission; "Share Boosting Comission")
            {
            }
            column(ShareCapitalDue; "Share Capital Due")
            {
            }
            column(SharePurchase; "Share Purchase")
            {
            }
            column(SharesBalance; "Shares Balance")
            {
            }
            column(SharesBoosted; "Shares Boosted")
            {
            }
            column(SharestoBoost; "Shares to Boost")
            {
            }
            column(Signature; Signature)
            {
            }
            column(Source; Source)
            {
            }
            column(SourceofFunds; "Source of Funds")
            {
            }
            column(SpecialLoanAmount; "Special Loan Amount")
            {
            }
            column(SpecificSector; "Specific-Sector")
            {
            }
            column(Staff; Staff)
            {
            }
            column(StaffAssement; "Staff Assement")
            {
            }
            column(StaffNo; "Staff No")
            {
            }
            column(StaffUnionContribution; "Staff Union Contribution")
            {
            }
            column(StatementAccount; "Statement Account")
            {
            }
            column(Subsector; "Sub-sector")
            {
            }
            column(Substandard; Substandard)
            {
            }
            column(SystemCreated; "System Created")
            {
            }
            column(SystemCreatedAt; SystemCreatedAt)
            {
            }
            column(SystemCreatedBy; SystemCreatedBy)
            {
            }
            column(SystemId; SystemId)
            {
            }
            column(SystemModifiedAt; SystemModifiedAt)
            {
            }
            column(SystemModifiedBy; SystemModifiedBy)
            {
            }
            column(TopUpAmount; "Top Up Amount")
            {
            }
            column(TopupCommission; "Topup Commission")
            {
            }
            column(TopupLoanNo; "Topup Loan No")
            {
            }
            column(TopupiNTEREST; "Topup iNTEREST")
            {
            }
            column(TotalChargesandCommissions; "Total Charges and Commissions")
            {
            }
            column(TotalDeductions; "Total Deductions")
            {
            }
            column(TotalDeductionsSalary; "Total Deductions(Salary)")
            {
            }
            column(TotalDeductionsH; "Total DeductionsH")
            {
            }
            column(TotalDisbursmenttoDate; "Total Disbursment to Date")
            {
            }
            column(TotalEarningsSalary; "Total Earnings(Salary)")
            {
            }
            column(TotalInsurancePaid; "Total Insurance Paid")
            {
            }
            column(TotalInterest; "Total Interest")
            {
            }
            column(TotalInterestPaid; "Total Interest Paid")
            {
            }
            column(TotalLoan; "Total Loan")
            {
            }
            column(TotalLoanGuaranted; "Total Loan Guaranted")
            {
            }
            column(TotalLoanInterest; "Total Loan Interest")
            {
            }
            column(TotalLoanRepayment; "Total Loan Repayment")
            {
            }
            column(TotalLoansOutstanding; "Total Loans Outstanding")
            {
            }
            column(TotalOutstandingLoanBAL; "Total Outstanding Loan BAL")
            {
            }
            column(TotalPenaltyPaid; "Total Penalty Paid")
            {
            }
            column(TotalRepayment; "Total Repayment")
            {
            }
            column(TotalRepayments; "Total Repayments")
            {
            }
            column(TotalScheduleRepayment; "Total Schedule Repayment")
            {
            }
            column(TotalTopUpCommission; "Total TopUp Commission")
            {
            }
            column(TotalTopupAmount; "Total Topup Amount")
            {
            }
            column(TotalloanOutstanding; "Total loan Outstanding")
            {
            }
            column(TotalsLoanOutstanding; "Totals Loan Outstanding")
            {
            }
            column(TranchAmountDisbursed; "Tranch Amount Disbursed")
            {
            }
            column(TrancheNumber; "Tranche Number")
            {
            }
            column(TransactingBranch; "Transacting Branch")
            {
            }
            column(TransportAllowance; "Transport Allowance")
            {
            }
            column(TransportBusFare; "Transport/Bus Fare")
            {
            }
            column(TypeOfLoanDuration; "Type Of Loan Duration")
            {
            }
            column(Upfronts; Upfronts)
            {
            }
            column(Upraised; Upraised)
            {
            }
            column(UtilityAccount; "Utility Account")
            {
            }
            column(UtilizableAmount; "Utilizable Amount")
            {
            }
            column(ValuationCost; "Valuation Cost")
            {
            }
            column(VoluntaryDeductions; "Voluntary Deductions")
            {
            }
            column(loanInterest; "loan  Interest")
            {
            }
            column(loss; loss)
            {
            }
            column(partiallyBridged; "partially Bridged")
            {
            }
            column(topfee; "top fee")
            {
            }
            column(watch; watch)
            {
            }
        }
    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                }
            }
        }
        actions
        {
            area(Processing)
            {
            }
        }
    }
}
