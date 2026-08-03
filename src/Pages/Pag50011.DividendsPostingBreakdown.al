page 50012 "Dividends Posting Breakdown"
{
    ApplicationArea = All;
    Caption = 'Dividends Posting Breakdown';
    PageType = List;
    SourceTable = "Dividends Posting Breakdown";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(Entry; Rec.Entry)
                {
                    ToolTip = 'Specifies the value of the Entry field.', Comment = '%';
                }
                field("Member Number"; Rec."Member Number")
                {
                    ToolTip = 'Specifies the value of the Member Number field.', Comment = '%';
                }
                field("Payroll Number"; Rec."Payroll Number")
                {
                    ToolTip = 'Specifies the value of the Payroll Number field.', Comment = '%';
                }
                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies the value of the Name field.', Comment = '%';
                }
                field("Qualifying Shares"; Rec."Qualifying Shares")
                {
                    ToolTip = 'Specifies the value of the Qualifying Shares field.', Comment = '%';
                }
                field("Qualifying Deposits"; Rec."Qualifying Deposits")
                {
                    ToolTip = 'Specifies the value of the Qualifying Deposits field.', Comment = '%';
                }
                field("Dividends On Shares"; Rec."Dividends On Shares")
                {
                    ToolTip = 'Specifies the value of the Dividends On Shares field.', Comment = '%';
                }
                field("Interest on Deposits"; Rec."Interest on Deposits")
                {
                    ToolTip = 'Specifies the value of the Interest on Deposits field.', Comment = '%';
                }
                field("Total Earnings"; Rec."Total Earnings")
                {
                    ToolTip = 'Specifies the value of the Total Earnings field.', Comment = '%';
                }
                field("Processing Fee"; Rec."Processing Fee")
                {
                    ToolTip = 'Specifies the value of the Processing Fee field.', Comment = '%';
                }
                field("Withholding Tax"; Rec."Withholding Tax")
                {
                    ToolTip = 'Specifies the value of the Withholding Tax field.', Comment = '%';
                }
                field("Loan Arrears Recovered"; Rec."Loan Arrears Recovered")
                {
                    ToolTip = 'Specifies the value of the Loan Arrears Recovered field.', Comment = '%';
                }
                field("Net Paid to Wallets"; Rec."Net Paid to Wallets")
                {
                    ToolTip = 'Specifies the value of the Net Paid to Wallets field.', Comment = '%';
                }
                field(ShareCapitalization; Rec.ShareCapitalization) { }
            }
        }
    }
}
