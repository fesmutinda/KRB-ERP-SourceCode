permissionset 59088 "KRB LOANS CHART"
{
    Assignable = true;
    Caption = 'View applied loan trends';
    Permissions =
        tabledata "Loans Register" = R,
        tabledata "Loan Products Setup" = R,
        page "Loans Applied Chart" = X,
        page "Loans Applied Overview" = X,
        page "Loans  List All" = X;
}
