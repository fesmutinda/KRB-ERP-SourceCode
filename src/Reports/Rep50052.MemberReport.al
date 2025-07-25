Report 50052 MemberReport
{
    ApplicationArea = All;
    Caption = 'Member Report';
    RDLCLayout = './Layouts/MembersReport.rdl';
    UsageCategory = ReportsAndAnalysis;
    dataset
    {
        dataitem(Customer; Customer)
        {
            DataItemTableView = sorting("No.") order(descending);
            RequestFilterFields = "No.", "Date Filter", Status;
            // TbMembRegister.CalcFields("Current Shares", "Shares Retained", "Outstanding Balance");
            column(CompanyName; CompanyInfo.Name)
            {
            }
            column(CompanyAddress; CompanyInfo.Address)
            {
            }

            column(CompanyPhone; CompanyInfo."Phone No.")
            {
            }
            column(Company_Address_2; CompanyInfo."Address 2") { }
            column(CompanyPic; CompanyInfo.Picture)
            {
            }
            column(CompanyEmail; CompanyInfo."E-Mail")
            {
            }
            column(No; "No.")
            {
            }
            column(Name; Name)
            { }
            column(ID_No_; "ID No.")
            { }
            column(EntryNo; EntryNo)
            { }
            column(Monthly_Contribution; "Monthly Contribution")
            { }
            column(Deposits; "Current Shares") { }
            column(ShareCapital; "Shares Retained") { }
            column(LoanBalance; LoanBalance) { }
            column(OutstandingBalance; "Outstanding Balance") { }
            column(Status; Status) { }
            column(Address; Address) { }
            column(Mobile_Phone_No; "Mobile Phone No") { }

            trigger OnPreDataItem()
            var
                myInt: Integer;
            begin
                Deposits := 0;
            end;

            trigger OnAfterGetRecord();
            var
            begin
                // TbMembRegister.CalcFields("Current Shares", "Shares Retained", "Outstanding Balance");
                // TbMembRegister.SetFilter(TbMembRegister."Date Filter", Datefilter);
                if TbMembRegister.get(TbMembRegister."No.") then begin
                    //repeat
                    TbMembRegister.CalcFields("Current Shares", "Shares Retained", "Outstanding Balance");
                    //until TbMembRegister.NEXT = 0;
                    TbMembRegister.SetAutoCalcFields(TbMembRegister."Current Shares");
                    TbMembRegister.CalcFields("Current Shares", "Shares Retained", "Outstanding Balance");
                    Deposits := TbMembRegister."Current Shares";
                    ShareCapital := TbMembRegister."Shares Retained";
                    LoanBalance := TbMembRegister."Outstanding Balance";
                end;


                EntryNo := EntryNo + 1;
            end;

        }
    }
    requestpage
    {
        layout
        {
            area(content)
            {
                group(GroupName)
                {
                }
            }
        }
        actions
        {
            area(processing)
            {
            }
        }
    }
    trigger OnPreReport()
    begin
        CompanyInfo.Get();
        CompanyInfo.CALCFIELDS(CompanyInfo.Picture);

        Datefilter := TbMembRegister.GetFilter("Date Filter");

        repeat
            TbMembRegister.CalcFields("Current Shares", "Shares Retained", "Outstanding Balance");
        until TbMembRegister.NEXT = 0;
    end;

    var
        CompanyInfo: Record "Company Information";
        EntryNo: Integer;
        LoanBalance: Decimal;
        ShareCapital: Decimal;
        Deposits: Decimal;
        Datefilter: Text[100];
        TbMembRegister: Record Customer;
}
