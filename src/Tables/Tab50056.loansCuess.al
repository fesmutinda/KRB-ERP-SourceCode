#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
table 50056 "loans Cuess"
{

    fields
    {
        field(1; "Primary Key"; Code[20])
        {
        }
        field(2; "Applied Loans"; Integer)
        {
            CalcFormula = COUNT("Loans Register" WHERE("Approval Status" = CONST(Open), "Approved Amount" = filter(> 0), "Loan Status" = const(Application), Source = const(BOSA)));
            FieldClass = FlowField;

        }
        field(3; "Active Loans"; Integer)
        {
            CalcFormula = count("Loans Register" where("Approval Status" = const(Approved), "Outstanding Balance" = filter(> 0), "Loan Status" = const(Issued), Source = const(BOSA)));
            FieldClass = FlowField;
        }
        field(4; "Pending Loans"; Integer)
        {
            CalcFormula = count("Loans Register" where("Approval Status" = const(Pending), "Approved Amount" = filter(> 0), "Outstanding Balance" = filter(> 0), Source = const(BOSA)));
            FieldClass = FlowField;
        }


        field(8; "DEVELOPMENT LOAN 2"; Integer)
        {
            CalcFormula = COUNT("Loans Register" WHERE("Approval Status" = CONST(Approved), "Outstanding Balance" = filter(> 0), "Loan Status" = const(Issued), "Loan Product Type" = filter('LT001')));
            FieldClass = FlowField;

        }
        field(9; "DEVELOPMENT LOAN 1"; Integer)
        {
            CalcFormula = count("Loans Register" where("Approval Status" = const(Approved), "Outstanding Balance" = filter(> 0), "Loan Status" = const(Issued), "Loan Product Type" = const('LT001')));
            FieldClass = FlowField;
        }
        field(10; "DEBOOSTER"; Integer)
        {
            CalcFormula = count("Loans Register" where("Approval Status" = const(Approved), "Outstanding Balance" = filter(> 0), "Loan Status" = const(Issued), "Loan Product Type" = const('DEBOOSTER')));
            FieldClass = FlowField;

        }
        field(11; "EMERGENCY LOAN"; Integer)
        {
            CalcFormula = count("Loans Register" where("Approval Status" = const(Approved), "Loan Status" = const(Issued), "Outstanding Balance" = filter(> 0), "Loan Product Type" = const('LT005')));
            FieldClass = FlowField;
        }
        field(12; "FURNITURE"; Integer)
        {
            CalcFormula = count("Loans Register" where("Approval Status" = const(Approved), "Loan Status" = const(Issued), "Outstanding Balance" = filter(> 0), "Loan Product Type" = const('FURNITURE')));
            FieldClass = FlowField;
        }
        field(13; "HOUSEHOLD"; Integer)
        {
            CalcFormula = count("Loans Register" where("Approval Status" = const(Approved), "Loan Status" = const(Issued), "Outstanding Balance" = filter(> 0), "Loan Product Type" = const('HOUSEHOLD')));
            FieldClass = FlowField;
        }
        field(14; "IPF"; Integer)
        {
            CalcFormula = count("Loans Register" where("Approval Status" = const(Approved), "Approved Amount" = filter(> 0), "Outstanding Balance" = filter(> 0), "Loan Product Type" = const('IPF')));
            FieldClass = FlowField;
        }
        field(15; "FLEXI LOAN"; Integer)
        {
            CalcFormula = count("Loans Register" where("Approval Status" = const(Approved), "Approved Amount" = filter(> 0), "Outstanding Balance" = filter(> 0), "Loan Product Type" = const('LT006')));
            FieldClass = FlowField;
        }
        field(16; "INSTANT LOAN"; Integer)
        {
            CalcFormula = count("Loans Register" where("Approval Status" = const(Approved), "Approved Amount" = filter(> 0), "Outstanding Balance" = filter(> 0), "Loan Product Type" = const('LT007')));
            FieldClass = FlowField;
        }
        field(17; "SHERIA COMPLIANT LOANS"; Integer)
        {
            CalcFormula = count("Loans Register" where("Approval Status" = const(Approved), "Approved Amount" = filter(> 0), "Outstanding Balance" = filter(> 0), "Loan Product Type" = const('LT008')));
            FieldClass = FlowField;
        }
        field(18; "DEVELOPMENT LOAN 2 14%"; Integer)
        {
            CalcFormula = count("Loans Register" where("Approval Status" = const(Approved), "Approved Amount" = filter(> 0), "Outstanding Balance" = filter(> 0), "Loan Product Type" = const('LT009')));
            FieldClass = FlowField;
        }
        field(20; "INVESTMENT LOAN"; Integer)
        {
            CalcFormula = count("Loans Register" where("Approval Status" = const(Approved), "Approved Amount" = filter(> 0), "Outstanding Balance" = filter(> 0), "Loan Product Type" = const('LT003')));
            FieldClass = FlowField;
        }
        field(21; "SCHOOL FEES"; Integer)
        {
            CalcFormula = count("Loans Register" where("Approval Status" = const(Approved), "Approved Amount" = filter(> 0), "Outstanding Balance" = filter(> 0), "Loan Product Type" = const('LT004')));
            FieldClass = FlowField;
        }
        field(22; "Cleared Loans"; Integer)
        {
            CalcFormula = count("Loans Register" where("Approval Status" = const(Approved), "Outstanding Balance" = filter(<= 0), "Loan Status" = const(Issued), Source = const(BOSA)));
            FieldClass = FlowField;
        }
        
    }

    keys
    {
        key(Key1; "Primary Key")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}


