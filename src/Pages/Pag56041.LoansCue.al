#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 56041 "Loans Cue"
{

    PageType = CardPart;
    SourceTable = "loans Cuess";
    UsageCategory = Lists;
    ApplicationArea = Basic;

    layout
    {
        area(content)
        {
            cuegroup(Group1)
            {
                Caption = 'BOSA LOANS ';
                field("New Applied Loans"; Rec."Applied Loans")
                {
                    ApplicationArea = Basic;
                    Image = none;
                    Style = Favorable;
                    StyleExpr = true;
                    DrillDownPageId = "Loans  List All";
                }

                field("Active Loans"; Rec."Active Loans")
                {
                    ApplicationArea = Basic;
                    Image = none;
                    Style = Favorable;
                    StyleExpr = true;
                    DrillDownPageId = "Loans Posted List";
                }
                field("Cleared Loans"; Rec."Cleared Loans")
                {
                    ApplicationArea = Basic;
                    Image = none;
                    Style = Favorable;
                    StyleExpr = true;
                    DrillDownPageId = "Loans Posted List";
                }

                field("Pending Loans"; Rec."Pending Loans")
                {
                    ApplicationArea = Basic;
                    Image = none;
                    Style = Favorable;
                    StyleExpr = true;
                    DrillDownPageId = "Loan List";
                }
                field("DEVELOPMENT LOAN 2"; Rec."DEVELOPMENT LOAN 2")
                {
                    ApplicationArea = Basic;
                    Image = none;
                    Style = Favorable;
                    StyleExpr = true;
                    DrillDownPageId = "Loans Posted List";
                }
                field("SUPER EMERGENCY LOAN"; Rec."DEVELOPMENT LOAN 1")
                {
                    ApplicationArea = Basic;
                    Image = none;
                    Style = Favorable;
                    StyleExpr = true;
                    DrillDownPageId = "Loans Posted List";
                }
                field("QUICK LOAN"; Rec."INVESTMENT LOAN")
                {
                    ApplicationArea = Basic;
                    Image = none;
                    Style = Favorable;
                    StyleExpr = true;
                    DrillDownPageId = "Loans Posted List";
                }
                field("SUPER QUICK"; Rec."SCHOOL FEES")
                {
                    ApplicationArea = Basic;
                    Caption = 'SCHOOL FEES';
                    Image = none;
                    Style = Favorable;
                    StyleExpr = true;
                    DrillDownPageId = "Loans Posted List";
                }
                field("EMERGENCY LOAN"; Rec."EMERGENCY LOAN")
                {
                    ApplicationArea = Basic;
                    Image = none;
                    Style = Favorable;
                    StyleExpr = true;
                    DrillDownPageId = "Loans Posted List";
                }



                field("FLEXI LOAN"; Rec."FLEXI LOAN")
                {
                    ApplicationArea = Basic;
                    Image = none;
                    Visible = false;
                    Style = Favorable;
                    StyleExpr = true;
                    DrillDownPageId = "Loans Posted List";
                }
                field("INSTANT LOAN"; Rec."INSTANT LOAN")
                {
                    ApplicationArea = Basic;
                    Image = none;
                    Style = Favorable;
                    StyleExpr = true;
                    DrillDownPageId = "Loans Posted List";
                }
                field("SHERIA COMPLIANT LOANS"; Rec."SHERIA COMPLIANT LOANS")
                {
                    ApplicationArea = Basic;
                    Image = none;
                    Style = Favorable;
                    StyleExpr = true;
                    DrillDownPageId = "Loans Posted List";

                }
                field("DEVELOPMENT LOAN 2 14%"; Rec."DEVELOPMENT LOAN 2 14%")
                {
                    ApplicationArea = Basic;
                    Image = none;
                    Style = Favorable;
                    StyleExpr = true;
                    DrillDownPageId = "Loans Posted List";
                }



            }

            // cuegroup(Group2)
            // {
            //     Caption = 'FOSA LOANS ';
            //     field("Applied Bosa Loans"; "Applied Fosa Loans")
            //     {
            //         ApplicationArea = Basic;
            //         Image = none;
            //         Style = Favorable;
            //         StyleExpr = true;
            //     }
            //     field("Pending FOSA Loans"; "Pending Fosa Loans")
            //     {
            //         ApplicationArea = Basic;
            //         Image = none;
            //         Style = Favorable;
            //         StyleExpr = true;
            //     }
            //     field("Approved FOSA Loans"; "Active FOSA Loans")
            //     {
            //         ApplicationArea = Basic;
            //         Image = none;
            //         Style = Favorable;
            //         StyleExpr = true;
            //     }

            // }


            // cuegroup(Group3)
            // {
            //     Caption = 'MICRO LOANS ';
            //     field("Applied Micro Loans"; "Applied Micro Loans")
            //     {
            //         ApplicationArea = Basic;
            //         Image = none;
            //         Style = Favorable;
            //         StyleExpr = true;
            //     }
            //     field("Pending Micro Loans"; "Pending Micro Loans")
            //     {
            //         ApplicationArea = Basic;
            //         Image = none;
            //         Style = Favorable;
            //         StyleExpr = true;
            //     }
            //     field("Approved Micro Loans"; "Active Micro Loans")
            //     {
            //         ApplicationArea = Basic;
            //         Image = none;
            //         Style = Favorable;
            //         StyleExpr = true;
            //     }

            // }
        }
    }

    actions
    {
    }
    trigger OnOpenPage()
    begin
        if not Rec.Get(Rec."Primary Key") then begin
            Rec.Init;
            Rec."Primary Key" := Rec."Primary Key";
            Rec.Insert;
        end;
    end;
}

