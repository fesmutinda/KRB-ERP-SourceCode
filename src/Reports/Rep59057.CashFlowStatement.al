report 59057 "Cash Flow Statement"
{
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;
    RDLCLayout = './Layout/CashFlow.rdl';

    dataset
    {
        dataitem(Header; "Company Information")
        {
            column(CompanyName; Name) { }
            column(ReportDate; Format(Today, 0, '<Month,2>/<Day,2>/<Year4>')) { }
        }

        dataitem(Categories; Integer)
        {
            DataItemTableView = SORTING(Number) WHERE(Number = FILTER(1 .. 3));

            column(CategoryName; CategoryName) { }
            column(Amount; CategoryAmount) { }

            trigger OnPreDataItem()
            begin
                SetRange(Number, 1, 3);
            end;

            trigger OnAfterGetRecord()
            begin
                case Number of
                    1:
                        begin
                            CategoryName := 'Operating Activities';
                            CategoryAmount := CalculateOperating();
                        end;
                    2:
                        begin
                            CategoryName := 'Investing Activities';
                            CategoryAmount := CalculateInvesting();
                        end;
                    3:
                        begin
                            CategoryName := 'Financing Activities';
                            CategoryAmount := CalculateFinancing();
                        end;
                end;
            end;
        }

        dataitem(CashSummary; Integer)
        {
            column(NetCashFlow; NetCashFlow) { }
            column(BeginningCash; BeginningCash) { }
            column(EndingCash; EndingCash) { }
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
                    field(StartDate; StartDate) { Caption = 'Start Date'; }
                    field(EndDate; EndDate) { Caption = 'End Date'; }
                }
            }
        }
    }

    var
        StartDate: Date;
        EndDate: Date;
        CategoryName: Text;
        CategoryAmount: Decimal;
        NetCashFlow: Decimal;
        BeginningCash: Decimal;
        EndingCash: Decimal;

    trigger OnPreReport()
    begin
        if EndDate = 0D then EndDate := WorkDate();
        if StartDate = 0D then StartDate := CalcDate('<-CM>', EndDate);
        //CalculateCashBalances();
    end;


    local procedure CalculateOperating(): Decimal
    var
        GLAccount: Record "G/L Account";
        TotalAmount: Decimal;
    begin
        GLAccount.Reset();
        GLAccount.SetRange("Cash Flow Category", GLAccount."Cash Flow Category"::Operating);
        GLAccount.SetRange("Date Filter", StartDate, EndDate);

        if GLAccount.FindSet() then
            repeat
                GLAccount.CalcFields("Net Change");
                TotalAmount += GLAccount."Net Change";
            until GLAccount.Next() = 0;

        exit(TotalAmount);
    end;

    local procedure CalculateInvesting(): Decimal
    var
        GLAccount: Record "G/L Account";
        TotalAmount: Decimal;
    begin
        GLAccount.Reset();
        GLAccount.SetRange("Cash Flow Category", GLAccount."Cash Flow Category"::Investing);
        GLAccount.SetRange("Date Filter", StartDate, EndDate);

        if GLAccount.FindSet() then
            repeat
                GLAccount.CalcFields("Net Change");
                TotalAmount += GLAccount."Net Change";
            until GLAccount.Next() = 0;

        exit(TotalAmount);
    end;


    local procedure CalculateFinancing(): Decimal
    var
        GLAccount: Record "G/L Account";
        TotalAmount: Decimal;
    begin
        GLAccount.Reset();
        GLAccount.SetRange("Cash Flow Category", GLAccount."Cash Flow Category"::Financing);
        GLAccount.SetRange("Date Filter", StartDate, EndDate);

        if GLAccount.FindSet() then
            repeat
                GLAccount.CalcFields("Net Change");
                TotalAmount += GLAccount."Net Change";
            until GLAccount.Next() = 0;

        exit(TotalAmount);
    end;


    local procedure CalculateCashBalances()
    var
        GLAccount: Record "G/L Account";
    begin
        // Beginning balance (before start date)
        GLAccount.Get('1221'); // Cash account - replace with your actual cash account
        GLAccount.SetRange("Date Filter", 0D, StartDate - 1);
        GLAccount.CalcFields("Balance at Date");
        BeginningCash := GLAccount."Balance at Date";

        // Ending balance
        GLAccount.Get('1221'); // Must re-get the account to clear previous filters
        GLAccount.SetRange("Date Filter", 0D, EndDate);
        GLAccount.CalcFields("Balance at Date");
        EndingCash := GLAccount."Balance at Date";

        NetCashFlow := EndingCash - BeginningCash;
    end;
}