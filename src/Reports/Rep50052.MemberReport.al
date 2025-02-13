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
            column(CompanyName; CompanyInfo.Name)
            {
            }
            column(CompanyAddress; CompanyInfo.Address)
            {
            }
            column(CompanyPhone; CompanyInfo."Phone No.")
            {
            }
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
            column(Deposits; Deposits) { }
            column(ShareCapital; ShareCapital) { }
            column(LoanBalance; LoanBalance) { }
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
                // TbMembRegister.SetFilter(TbMembRegister."Date Filter", Datefilter);

                TbMembRegister.SetAutoCalcFields(TbMembRegister."Current Shares");
                Deposits := TbMembRegister."Current Shares";
                //ShareCapital := TbMembRegister."Shares Capital";
                LoanBalance := TbMembRegister."Outstanding Balance";

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
