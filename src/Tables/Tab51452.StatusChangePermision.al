#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Table 51452 "Status Change Permision"
{

    fields
    {
        field(1; "User Id"; Code[50])
        {
            TableRelation = "User Setup"."User ID";
        }
        field(2; "Function"; Option)
        {
            NotBlank = false;
            //OptionCaption = 'Account Status,Standing Order,Discounting Cheque,Inter Teller Approval,Discounting Loan,Nominee,Cashier Report,Discounting Dividends,Loan External EFT,Overide Defaulters,BOSA Account Status,Fosa Loan Approval,PV Approval,PV Verify,PV Cancel,ATM Approval,Petty Cash Approval,Bosa Loan Approval,Bosa Loan Appraisal,Atm card ready,Audit Approval,Finance Approval,Replace Guarantors,Account Opening,Mpesa Change,Edit,NameEdit,Reverse,Disable ATM';
            OptionMembers = "Account Status","Can Appeal Loans","Standing Order","Discounting Cheque","Inter Teller Approval","Discounting Loan",Nominee,"Cashier Report","Discounting Dividends","Loan External EFT","Overide Defaulters","BOSA Account Status","Fosa Loan Approval","PV Approval","PV Verify","PV Cancel","ATM Approval","Petty Cash Approval","Bosa Loan Approval","Bosa Loan Appraisal","Atm card ready","Audit Approval","Finance Approval","Replace Guarantors","Account Opening","Mpesa Change",Edit,NameEdit,Reverse,"Disable ATM","Can View Paybill Logs",Smobile,SmobileApp;
        }
    }

    keys
    {
        key(Key1; "Function", "User ID")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        UserMgt: Codeunit "User Setup Management";
}

