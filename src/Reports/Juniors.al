report 59069 "Juniors Report"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = './Layout/JuniorsReport.rdlc';

    dataset
    {
        // Main dataitem - Members Register (Guardian)
        dataitem("Members Register"; Customer)
        {
            RequestFilterFields = "No.", "Date Filter";

            column(GuardianNo; "Members Register"."No.")
            {
            }
            column(GuardianName; "Members Register".Name)
            {
            }
            column(CompanyName; CompanyInfo.Name)
            {
            }
            column(ReportTitle; 'Juniors Report')
            {
            }
            column(DateFilter; DateFilterText)
            {
            }

            // FIXED: Enhanced Junior Savings Section - Individual Junior Accounts
            dataitem(JuniorAccountsList; Customer)
            {
                DataItemLink = "Guardian No." = field("No.");

                column(JuniorAccountNo; JuniorAccountsList."No.")
                {
                }
                column(JuniorMemberName9; JuniorAccountsList.Name)
                {
                }
                column(JuniorGuardianNo; JuniorAccountsList."Guardian No.")
                {
                }
                column(JuniorAccountOpeningBalance; JuniorAccountOpeningBalance)
                {
                    DecimalPlaces = 2 : 2;
                }
                column(JuniorAccountClosingBalance; JuniorAccountClosingBalance)
                {
                    DecimalPlaces = 2 : 2;
                }
                column(JuniorIDNo; JuniorAccountsList."ID No.")
                {
                }
                column(JuniorRegistrationDate; JuniorAccountsList."Registration Date")
                {
                }

                // Individual Junior Savings Transactions for each junior account
                dataitem(JuniorTransactions; "Cust. Ledger Entry")
                {
                    DataItemLink = "Customer No." = field("No."), "Posting Date" = field("Date Filter");
                    DataItemTableView = sorting("Posting Date") where("Transaction Type" = filter("Junior Savings"), Reversed = const(false));

                    column(PostingDate_JuniorTrans; JuniorTransactions."Posting Date")
                    {
                    }
                    column(DocumentNo_JuniorTrans; JuniorTransactions."Document No.")
                    {
                    }
                    column(Description_JuniorTrans; JuniorTransactions.Description)
                    {
                    }
                    column(Amount_JuniorTrans; JuniorTransactions."Amount Posted")
                    {
                        DecimalPlaces = 2 : 2;
                    }
                    column(UserID_JuniorTrans; JuniorTransactions."User ID")
                    {
                    }
                    column(DebitAmount_JuniorTrans; DebitAmount)
                    {
                        DecimalPlaces = 2 : 2;
                    }
                    column(CreditAmount_JuniorTrans; CreditAmount)
                    {
                        DecimalPlaces = 2 : 2;
                    }
                    column(TransactionType_JuniorTrans; JuniorTransactions."Transaction Type")
                    {
                    }
                    column(RunningBalance_JuniorTrans; JuniorRunningBalance)
                    {
                        DecimalPlaces = 2 : 2;
                    }
                    // FIXED: These are the fields you need - populate them from the parent record
                    column(CurrentJuniorAccountNo; CurrentJuniorAccountNo)
                    {
                    }
                    column(CurrentJuniorMemberName; CurrentJuniorMemberName)
                    {
                    }
                    // Additional fields for RDLC compatibility
                    column(JuniorMemberNo; CurrentJuniorAccountNo)
                    {
                    }
                    column(JuniorMemberName; CurrentJuniorMemberName)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        // FIXED: Set the current junior account information for each transaction
                        CurrentJuniorAccountNo := JuniorAccountsList."No.";
                        CurrentJuniorMemberName := JuniorAccountsList.Name;

                        // Calculate debit/credit amounts properly
                        CreditAmount := 0;
                        DebitAmount := 0;
                        if JuniorTransactions."Amount Posted" > 0 then begin
                            DebitAmount := JuniorTransactions."Amount Posted";
                        end else
                            if JuniorTransactions."Amount Posted" < 0 then begin
                                CreditAmount := Abs(JuniorTransactions."Amount Posted");
                            end;

                        // Update running balance
                        JuniorRunningBalance := JuniorRunningBalance + (JuniorTransactions."Amount Posted" * -1);
                    end;

                    trigger OnPreDataItem()
                    begin
                        // Initialize running balance with the opening balance for this specific junior account
                        JuniorRunningBalance := JuniorAccountOpeningBalance;

                        // Apply date filter if exists
                        if "Members Register".GetFilter("Date Filter") <> '' then
                            JuniorTransactions.SetFilter("Posting Date", "Members Register".GetFilter("Date Filter"));
                    end;

                    trigger OnPostDataItem()
                    begin
                        // Set closing balance for this junior account
                        JuniorAccountClosingBalance := JuniorRunningBalance;
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    // Calculate opening balance for this specific junior account
                    JuniorAccountOpeningBalance := CalculateJuniorAccountOpeningBalance(JuniorAccountsList."No.", DateFilterBF);

                    // Initialize closing balance with opening balance
                    JuniorAccountClosingBalance := JuniorAccountOpeningBalance;
                end;

                trigger OnPreDataItem()
                begin
                    // Filter for junior accounts where this member is the guardian
                    JuniorAccountsList.SetRange("Guardian No.", "Members Register"."No.");

                    // Apply date filter if exists
                    if "Members Register".GetFilter("Date Filter") <> '' then
                        JuniorAccountsList.SetFilter("Date Filter", "Members Register".GetFilter("Date Filter"));
                end;
            }

            trigger OnPreDataItem()
            begin
                // Initialize company information
                CompanyInfo.Get();

                // Set date filter text for display
                if "Members Register".GetFilter("Date Filter") <> '' then
                    DateFilterText := 'Period: ' + "Members Register".GetFilter("Date Filter")
                else
                    DateFilterText := 'Period: All Dates';
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(Options)
                {
                    Caption = 'Options';

                    field(ShowDetails; ShowDetails)
                    {
                        Caption = 'Show Transaction Details';
                        ApplicationArea = All;
                        ToolTip = 'Show detailed transactions for each junior account';
                    }
                }
            }
        }
    }

    // FIXED: Add these variables to your var section
    var
        CompanyInfo: Record "Company Information";
        CurrentJuniorAccountNo: Code[20];
        CurrentJuniorMemberName: Text[100];
        JuniorAccountOpeningBalance: Decimal;
        JuniorAccountClosingBalance: Decimal;
        JuniorRunningBalance: Decimal;
        DebitAmount: Decimal;
        CreditAmount: Decimal;
        DateFilterBF: Date;
        DateFilterText: Text[100];
        ShowDetails: Boolean;

    // Add your custom procedures here
    local procedure CalculateJuniorAccountOpeningBalance(AccountNo: Code[20]; AsOfDate: Date): Decimal
    var
        CustLedgerEntry: Record "Cust. Ledger Entry";
        OpeningBalance: Decimal;
    begin
        OpeningBalance := 0;

        CustLedgerEntry.SetRange("Customer No.", AccountNo);
        CustLedgerEntry.SetRange("Transaction Type", CustLedgerEntry."Transaction Type"::"Junior Savings");
        CustLedgerEntry.SetRange(Reversed, false);

        if AsOfDate <> 0D then
            CustLedgerEntry.SetRange("Posting Date", 0D, AsOfDate);

        if CustLedgerEntry.FindSet() then
            repeat
                OpeningBalance := OpeningBalance + (CustLedgerEntry."Amount Posted" * -1);
            until CustLedgerEntry.Next() = 0;

        exit(OpeningBalance);
    end;
}