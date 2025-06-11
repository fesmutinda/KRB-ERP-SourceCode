namespace KRBERPSourceCode.KRBERPSourceCode;

using Microsoft.Finance.GeneralLedger.Account;
using Microsoft.Sales.Receivables;
using Microsoft.Foundation.Company;
using Microsoft.Finance.GeneralLedger.Ledger;
using Microsoft.Sales.Customer;

report 59056 "Member Savings Report"
{
    ApplicationArea = All;
    Caption = 'Member Savings Report';
    UsageCategory = ReportsAndAnalysis;

    DefaultLayout = RDLC;
    RDLCLayout = './Layout/KRBMemberSavingsReport2.rdl';

    dataset
    {
        dataitem(GLAccount; "G/L Account")
        {
            column(No_GLAccount; "No.")
            {
            }
            column(Name_GLAccount; Name)
            {
            }
            column(AccountCategory; "Account Category")
            {
            }
            column(AccountType; "Account Type")
            {
            }
            column(BalanceatDate; "Balance at Date")
            {
            }
            column(DebitCredit; "Debit/Credit")
            {
            }
            column(DateCreated; "Date Created")
            {
            }
            column(NetChange; "Net Change")
            {
            }
            column(IncomeBalance; "Income/Balance")
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

            dataitem("G/L Entry"; "G/L Entry")
            {
                DataItemLink = "G/L Account No." = FIELD("No.");
                DataItemTableView = SORTING("G/L Account No.", "Posting Date");

                column(G_L_Account_No_; "G/L Account No.") { }
                column(G_L_Account_Name; "G/L Account Name") { }
                column(PostingDate; "Posting Date") { }
                column(DocumentNo; "Document No.") { }
                column(SourceNo; "Source No.") { }
                column(CustomerName; GetCustomerName("Source No.")) { }
                column(Description; Description) { }
                column(Amount; Amount) { }
                column(Transaction_No_; "Transaction No.") { }
                column(Customer; CustomerCode) { }
                column(Opening; OpeningBalance) { }
                column(Deposit; Deposits) { }
                column(Balance; CurrentBalance) { }

                column(Credit_Amount; "Credit Amount") { }

                column(Debit_Amount; "Debit Amount") { }

                column(Reversed_Entry_No_; "Reversed Entry No.") { }
                column(Reversed; Reversed) { }
                column(Reversed_Amount; ReversedAmount) { }
                column(Normal_Amount; NormalAmount) { }

                dataitem("Cust. Ledger Entry"; "Cust. Ledger Entry")
                {
                    DataItemLink = "Customer No." = field("Source No."),
                                  "Document No." = field("Document No."),
                                  "Posting Date" = field("Posting Date");
                    DataItemTableView = sorting("Customer No.", "Document No.", "Posting Date");

                    column(Transaction_Type; "Transaction Type") { }
                }

                trigger OnPreDataItem()
                begin
                    SetRange("Posting Date", StartDate, EndDate);
                end;

                trigger OnAfterGetRecord()
                begin
                    CustomerCode := "Source No.";
                    OpeningBalance := 0;
                    Reversed := false;
                    ReversedAmount := 0;
                    NormalAmount := 0;

                    // Check if this is a reversed entry
                    if "Reversed Entry No." <> 0 then begin
                        Reversed := true;
                        ReversedAmount := Amount;
                    end else begin
                        // Check if this entry has been reversed
                        TempGLEntry.Reset();
                        TempGLEntry.SetRange("Reversed Entry No.", "Entry No.");
                        if not TempGLEntry.IsEmpty() then begin
                            Reversed := true;
                            ReversedAmount := Amount;
                        end else begin
                            NormalAmount := Amount;
                        end;
                    end;

                    // Calculate opening balance — all entries before the start date
                    TempGLEntry.Reset();
                    TempGLEntry.SetRange("G/L Account No.", "G/L Account No.");
                    TempGLEntry.SetRange("Source No.", CustomerCode);
                    TempGLEntry.SetFilter("Posting Date", '..%1', StartDate - 1);
                    if TempGLEntry.FindSet() then begin
                        repeat
                            OpeningBalance += TempGLEntry.Amount;
                        until TempGLEntry.Next() = 0;
                    end;
                end;
            }

            trigger OnPreDataItem()
            begin
                // Set filter based on selection or default to all four accounts
                case SelectedGLAccount of
                    SelectedGLAccount::"2231":
                        SetRange("No.", '2231');
                    SelectedGLAccount::"2232":
                        SetRange("No.", '2232');
                    SelectedGLAccount::"2233":
                        SetRange("No.", '2233');
                    SelectedGLAccount::"3101":
                        SetRange("No.", '2310');
                    else begin
                        // If no selection made, include all four accounts
                        SetFilter("No.", '%1|%2|%3|%4', '2231', '2232', '2233', '3101');
                    end;
                end;
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
                    field(StartDateField; StartDate)
                    {
                        ApplicationArea = All;
                        Caption = 'Start Date';
                    }
                    field(EndDateField; EndDate)
                    {
                        ApplicationArea = All;
                        Caption = 'End Date';
                    }
                }

                group("G/L Account Selection")
                {
                    Caption = 'Select Account';

                    field(SelectedGLAccount; SelectedGLAccount)
                    {
                        ApplicationArea = All;
                        Caption = 'G/L Account';
                        OptionCaption = ' ,2231 - Children Savings,2232 - Withdrawable Savings,2233 - Members Deposits,2310 - Share Capital';
                    }
                }
            }
        }
    }

    trigger OnPreReport()
    begin
        CompanyInfo.Get();
        CompanyInfo.CalcFields(CompanyInfo.Picture);

        if EndDate = 0D then
            EndDate := WorkDate();

        if StartDate = 0D then
            StartDate := CalcDate('<-CY>', EndDate);

        RunningTotal := 0;
    end;

    var
        StartDate: Date;
        EndDate: Date;
        CompanyInfo: Record "Company Information";
        AccountTotal: Decimal;
        RunningTotal: Decimal;
        OpeningBalance: Decimal;
        Deposits: Decimal;
        CurrentBalance: Decimal;
        TempGLEntry: Record "G/L Entry";
        CustomerCode: Code[20];
        SelectedGLAccount: Option " ","2231","2232","2233","3101";

        Reversed: Boolean;
        ReversedAmount: Decimal;
        NormalAmount: Decimal;

    procedure GetCustomerName(CustomerNo: Code[20]): Text[100]
    var
        CustomerRec: Record Customer;
    begin
        if CustomerRec.Get(CustomerNo) then
            exit(CustomerRec.Name);
        exit('');
    end;

    procedure CalculateAccountTotal(GLAccountNo: Code[20]; FromDate: Date; ToDate: Date): Decimal
    var
        GLEntryRec: Record "G/L Entry";
        TotalAmount: Decimal;
    begin
        GLEntryRec.SetRange("G/L Account No.", GLAccountNo);
        GLEntryRec.SetRange("Posting Date", FromDate, ToDate);

        if GLEntryRec.FindSet() then
            repeat
                TotalAmount += GLEntryRec.Amount;
            until GLEntryRec.Next() = 0;

        exit(TotalAmount);
    end;
}