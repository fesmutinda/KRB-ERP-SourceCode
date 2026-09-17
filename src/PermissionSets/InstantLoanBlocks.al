permissionset 59081 "KRB INSTANT BLOCKS"
{
    Assignable = true;
    Caption = 'Maintain instant loan blocks';
    Permissions =
        tabledata Customer = R,
        tabledata "Instant Loan Member Block" = RIM,
        tabledata "Instant Loan Block History" = Ri,
        table "Instant Loan Member Block" = X,
        table "Instant Loan Block History" = X,
        table "Instant Loan Block Buffer" = X,
        table "Instant Loan Block Cue" = X,
        codeunit "Instant Loan Block Mgt." = X,
        page "Instant Loan Member Blocks" = X,
        page "Instant Loan Block History" = X,
        page "Instant Loan Block Cue" = X,
        page "Finance Role Center" = X;
}

permissionset 59082 "KRB INSTANT READ"
{
    Assignable = true;
    Caption = 'Read instant loan blocks';
    Permissions =
        tabledata "Instant Loan Member Block" = R,
        table "Instant Loan Member Block" = X,
        codeunit "Instant Loan Block Mgt." = X;
}
