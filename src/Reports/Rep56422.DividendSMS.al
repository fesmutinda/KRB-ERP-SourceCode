#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 56422 "Dividend SMS"
{
    ProcessingOnly = true;
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem(Dividends_Posting_Breakdown; "Dividends Posting Breakdown")
        {
            column(Member_Number; "Member Number") { }
            column(Net_Paid_to_Wallets; "Net Paid to Wallets") { }
            trigger OnAfterGetRecord()
            var
                membersTable: Record Customer;
                loansRecovered: Decimal;
            begin
                loansRecovered := Dividends_Posting_Breakdown."Loan Arrears Recovered";

                if membersTable.Status = membersTable.Status::Withdrawal then begin
                    SMSBody := 'Your Net(Interest & Dividend less 5% w/tax) Amt for the year 2025 of Kshs ' + Format(Dividends_Posting_Breakdown."Net Paid to Wallets") + ' has been posted.';
                end else begin
                    if loansRecovered > 0 then begin
                        SMSBody := 'Your Net(Interest & Dividend less 5% w/tax) Amt for the year 2025 has been processed. '
                                    + 'Recoveries of Kshs.' + Format(loansRecovered) + ' has been used to repay your loan Arrears. '
                                    + 'and the Net Amt of Kshs ' + Format(Dividends_Posting_Breakdown."Net Paid to Wallets") + ' has been posted to your M-Wallet Account';
                    end else begin
                        SMSBody := 'Your Net(Interest & Dividend less 5% w/tax) Amt for the year 2025 of Kshs ' + Format(Dividends_Posting_Breakdown."Net Paid to Wallets") + ' has been posted to your M-Wallet Account';
                    end;
                end;
                //send the Message
                // SFactory.FnSendSMS('DIVIDEND', SMSBody, Dividends_Posting_Breakdown."Member Number", SFactory.FnGetMemberMobileNo(Dividends_Posting_Breakdown."Member Number"));

            end;

            trigger OnPreDataItem()
            begin
                GenSet.Get();
                prorateRate := GenSet."Dividend (%)";
            end;

            trigger OnPostDataItem()
            begin
                Message('Dividend SMS Messages have been successfuly sent');
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

    trigger OnPostReport()
    begin
        Message('Dividend SMS Sent Successfully.');
    end;

    var
        SMSMessage: Record "SMS Messages";
        prorateRate: Decimal;
        GenSet: Record "Sacco General Set-Up";
        StrTel: Text[100];
        MessageFailed: Boolean;
        iEntryNo: Integer;
        Vend: Record Vendor;
        SMSBody: text[1000];
        Gnljnline: Record "Gen. Journal Line";
        SFactory: Codeunit "SWIZZSOFT Factory";
}

