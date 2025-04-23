namespace KRBERPSourceCode.KRBERPSourceCode;

using Microsoft.Sales.Receivables;
using Microsoft.Foundation.Company;
using Microsoft.Sales.Customer;
using Microsoft.Finance.GeneralLedger.Account;
using Microsoft.Finance.GeneralLedger.Ledger;

report 59055 "KRBAccountActivity"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;

    RDLCLayout = './Layout/KRBAccountActivity.rdl';

    dataset
    {
        dataitem("G/L Account"; "G/L Account")
        {
            DataItemTableView = SORTING("No.") WHERE("Account Type" = CONST(Posting));
            PrintOnlyIfDetail = true;

            column(RunningTotal; RunningTotal)
            {
            }


            column(No_GLAccount; "No.")
            {
            }
            column(Name_GLAccount; Name)
            {
            }
            column(AccountCategory; "Account Category")
            {
            }
            column(StartDateFilter; Format(StartDate))
            {
            }
            column(EndDateFilter; Format(EndDate))
            {
            }
            column(AccountTotal; AccountTotal)
            {
            }

            //    column(RunningTotal; RunningTotal)
            // {
            // }

            column(Company_Name; Company.Name)
            {
            }
            column(Company_Address; Company.Address)
            {
            }
            column(Company_Address_2; Company."Address 2")
            {
            }
            column(Company_Phone_No; Company."Phone No.")
            {
            }
            column(Company_Fax_No; Company."Fax No.")
            {
            }
            column(Company_Picture; Company.Picture)
            {
            }
            column(Company_Email; Company."E-Mail")
            {
            }

            dataitem("G/L Entry"; "G/L Entry")
            {
                DataItemLink = "G/L Account No." = FIELD("No.");
                DataItemTableView = SORTING("G/L Account No.", "Posting Date");


                column(PostingDate; "Posting Date")
                {
                }
                column(DocumentNo; "Document No.")
                {
                }
                column(SourceNo; "Source No.")
                {
                }
                column(CustomerName; GetCustomerName("Source No."))
                {
                }
                column(Description; Description)
                {
                }
                column(Amount; Amount)
                {
                }

                column(Transaction_No_; "Transaction No.")
                { }

                column(Debit_Amount; "Debit Amount")
                {

                }

                column(Credit_Amount; "Credit Amount")
                {

                }


                trigger OnPreDataItem()
                begin
                    SetRange("Posting Date", StartDate, EndDate);
                    //SetRange("Source Type", "Source Type"::Customer);
                end;

                trigger OnAfterGetRecord()
                begin
                    // Update running total after each entry
                    RunningTotal := RunningTotal + Amount;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                AccountTotal := CalculateAccountTotal("No.", StartDate, EndDate);

                //RunningTotal := RunningTotal + AccountTotal;
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
            }
        }
    }

    trigger OnPreReport()
    begin
        Company.Get();
        Company.CalcFields(Company.Picture);

        if EndDate = 0D then
            EndDate := WorkDate();

        if StartDate = 0D then
            StartDate := CalcDate('<-CY>', EndDate);

        RunningTotal := 0;
    end;

    var
        StartDate: Date;
        EndDate: Date;
        Company: Record "Company Information";
        AccountTotal: Decimal;

        RunningTotal: Decimal;

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
        //GLEntryRec.SetRange("Source Type", GLEntryRec."Source Type"::Customer);

        if GLEntryRec.FindSet() then
            repeat
                TotalAmount += GLEntryRec.Amount;
            until GLEntryRec.Next() = 0;

        exit(TotalAmount);
    end;
}