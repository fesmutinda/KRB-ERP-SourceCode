pagecustomization "Treasury Financial Management" customizes "Finance Role Center"
{
    actions
    {
        modify(FundsTranfer)
        {
            Visible = false;
        }
        modify("Finance Statements")
        {
            Visible = false;
        }
        modify(TreasuryFinancialStatements)
        {
            Visible = true;
        }
        modify(BosaManagement)
        {
            Visible = false;
        }
        modify(SaccoLoansManagement)
        {
            Visible = false;
        }
        modify(TreasuryCreditManagement)
        {
            Visible = true;
        }
        modify("SASRA Reports")
        {
            Visible = false;
        }
        modify("Mkopo Reports")
        {
            Visible = false;
        }
        modify("Other Financials")
        {
            Visible = false;
        }
    }
}
