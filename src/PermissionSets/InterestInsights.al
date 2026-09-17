permissionset 59085 "KRB INTEREST VIEW"
{
    Assignable = true;
    Caption = 'View interest income insights';
    Permissions =
        tabledata "G/L Entry" = R,
        tabledata "G/L Account" = R,
        tabledata "General Ledger Setup" = R,
        tabledata "Loan Products Setup" = R,
        table "Interest Contribution" = X,
        codeunit "Interest Insights Mgt." = X,
        page "Interest Contributions" = X,
        page "Interest Income Overview" = X,
        page "Loan Performance Chart" = X,
        page "General Ledger Entries" = X;
}
