tableextension 52052 EmployeeExt extends Employee
{
    fields
    {
        field(52016; "Leave Period Filter"; Code[20])
        {
            TableRelation = "Leave Period"."Leave Period Code";
            Caption = 'Leave Period Filter';
            FieldClass = FlowFilter;
        }
        field(52017; "Leave Type Filter"; Code[20])
        {
            Caption = 'Leave Type Filter';
            TableRelation = "Leave Type".Code;
            FieldClass = FlowFilter;
        }

        field(52152; "Leave Adjustment"; Decimal)
        {
            //CalcFormula = lookup("Leave Type".Days where(Code = field("Leave Type Filter")));
            CalcFormula = sum("HR Leave Ledger Entries"."No. of days" where("Staff No." = field("No."),
                                                                            "Transaction Type" = filter("Leave Adjustment"),
                                                                            "Leave Type" = field("Leave Type Filter"),
                                                                            "Leave Period Code" = field("Leave Period Filter")));
            Caption = 'Leave Adjustment';
            Editable = false;
            FieldClass = FlowField;
        }
        field(52120; "Employment Type"; Enum "Employment Type")
        {
            DataClassification = CustomerContent;
            Caption = 'Employment Type';
        }
        field(52121; "Area"; Code[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Area';
        }
        field(50001; "Responsibility Center"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Responsibility Center";
            Caption = 'Responsibility Center';
        }
        field(52061; "Leave Entitlement"; Decimal)
        {
            //CalcFormula = lookup("Leave Type".Days where(Code = field("Leave Type Filter")));
            CalcFormula = sum("HR Leave Ledger Entries"."No. of days" where("Staff No." = field("No."),
                                                                            "Transaction Type" = filter("Leave Allocation"),
                                                                            "Leave Type" = field("Leave Type Filter"),
                                                                            "Leave Period Code" = field("Leave Period Filter")));
            Caption = 'Leave Entitlement';
            Editable = false;
            FieldClass = FlowField;
        }

        field(52033; "Salary Scale"; Code[30])
        {
            DataClassification = CustomerContent;
            TableRelation = "Salary Scale".Scale;
            Caption = 'Salary Grade';

            trigger OnValidate()
            begin
                TestField("Date Of Join");

                Scale.Get("Salary Scale")
                //  Halt := Scale."Maximum Pointer";

                // "Previous Salary Scale" := xrec."Salary Scale";
            end;
        }
        field(52001; "Nature of Employment"; Text[50])
        {
            DataClassification = CustomerContent;
            TableRelation = "Employment Contract".Code;
            Caption = 'Nature of Employment';

            trigger OnValidate()
            begin
                if EmpContract.Get("Nature of Employment") then
                    "Employee Type" := EmpContract."Employee Type"
            end;
        }
        field(52117; "Employee Type"; Option)
        {
            DataClassification = CustomerContent;
            OptionCaption = 'Permanent,Partime,Locum,Casual,Contract,Board Member,Attachee,Intern';
            OptionMembers = Permanent,Partime,Locum,Casual,Contract,"Board Member",Attachee,Intern;
            Caption = 'Employee Type';
        }
        field(52014; "Job Position"; Code[10])
        {
            DataClassification = CustomerContent;
            TableRelation = "Company Job";
            Caption = 'Job Position';

            trigger OnValidate()
            begin
                if Jobs.Get("Job Position") then
                    "Job Position Title" := Jobs."Job Description";
            end;
        }
        field(52143; "Leave Recall Days"; Decimal)
        {
            CalcFormula = sum("HR Leave Ledger Entries"."No. of days" where("Staff No." = field("No."),
                                                                                         "Transaction Type" = filter("Leave Recall"),
                                                                                         "Leave Type" = field("Leave Type Filter"),
                                                                                         "Leave Period Code" = field("Leave Period Filter")));
            FieldClass = FlowField;
            Caption = 'Leave Recall Days';
            Editable = false;
        }
        field(52144; "Days Absent"; Decimal)
        {
            CalcFormula = sum("Employee Absence".Quantity where("Employee No." = field("No."),
                                                                 "Affects Leave" = filter(true)));
            FieldClass = FlowField;
            Caption = 'Days Absent';
        }
        field(52112; Name; Text[60])
        {
            DataClassification = CustomerContent;
            Caption = 'Name';
        }
        field(52054; "Contract Type"; Code[30])
        {
            DataClassification = CustomerContent;
            TableRelation = "Employment Contract".Code;
            Caption = 'Contract Type';
        }
        field(52135; "Leave Balance"; Decimal)
        {
            FieldClass = FlowField;
            Editable = false;
            Description = 'With Flowfilters';
            CalcFormula = sum("HR Leave Ledger Entries"."No. of days" where("Staff No." = field("No."),
                                                                            "Leave Period Code" = field("Leave Period Filter"),
                                                                            "Leave Type" = field("Leave Type Filter")));
            Caption = 'Leave Balance';
        }
        field(52015; "Job Position Title"; Text[250])
        {
            Caption = 'Job Position Title';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Company Job"."Job Description" where("Job ID" = field("Job Position")));
        }
        field(52066; "Date Of Leaving"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Date Of Leaving';
        }
        field(52155; "Employee Category"; Code[20])
        {
            Caption = 'Employee Category';
            DataClassification = CustomerContent;
            TableRelation = "Employee Category".Code;
        }

        field(52139; "Leave Days Taken"; Decimal)
        {
            FieldClass = FlowField;
            Editable = false;
            Description = 'With Flowfilters';
            CalcFormula = - sum("HR Leave Ledger Entries"."No. of days" where("Staff No." = field("No."),
                                                                            "Leave Period Code" = field("Leave Period Filter"),
                                                                            "Leave Type" = field("Leave Type Filter"),
                                                                            "Leave Entry Type" = const(Negative)));
            Caption = 'Leave Days Taken';
        }
        field(52142; "Leave Balance Brought Forward"; Decimal)
        {
            CalcFormula = sum("HR Leave Ledger Entries"."No. of days" where("Staff No." = field("No."),
                                                                                         "Transaction Type" = filter("Leave B/F"),
                                                                                         "Leave Type" = field("Leave Type Filter"),
                                                                                         "Leave Period Code" = field("Leave Period Filter")));
            FieldClass = FlowField;
            Caption = 'Leave Balance Brought Forward';
            Editable = false;
        }
        field(52156; "Base Calendar"; Code[10])
        {
            Caption = 'Base Calendar';
            DataClassification = CustomerContent;
            TableRelation = "Base Calendar".Code;
        }
        field(52063; "End Of Probation Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'End Of Probation Date';
        }
        field(52080; "Incremental Month"; Text[30])
        {
            DataClassification = CustomerContent;
            Caption = 'Anniversary Month';
        }
        field(52062; "Date Of Join"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Date Of Join';

            trigger OnValidate()
            var
                CurrentYear: Integer;
                JoinMonth: Integer;
            begin
                JoinMonth := 0;
                CurrentYear := 0;

                if "Date Of Join" <> 0D then begin
                    if "Date Of Join" > Today then
                        Error('Date of join can not be in the future');

                    if "End Of Probation Date" = 0D then begin
                        HumanResSetup.Get();
                        HumanResSetup.TestField("Probation Period");
                        "End Of Probation Date" := CalcDate(HumanResSetup."Probation Period", "Date Of Join") - 1;
                    end;

                    //"Employment Date - Age" := HRDates.DetermineAge("Date Of Join", Today);

                    if "Incremental Month" = '' then begin
                        JoinMonth := Date2DMY("Date Of Join", 2);
                        Evaluate("Incremental Month", Format(JoinMonth));
                    end;

                    CurrentYear := Date2DMY(Today(), 3);

                    //Check employee who joins in current year - push increment to next year
                    // if "Next Increment Date" = 0D then
                    //     if Date2DMY("Date Of Join", 3) = CurrentYear then
                    //         "Next Increment Date" := DMY2Date(1, Date2DMY("Date Of Join", 2), CurrentYear + 1)
                    //     else
                    //         //Else increment to this year
                    //         if not Payroll.CheckIfIncrementEffectedInCurrentYear(Rec, CurrentYear) then
                    //             "Next Increment Date" := DMY2Date(1, Date2DMY("Date Of Join", 2), CurrentYear)
                    //         else
                    //             "Next Increment Date" := DMY2Date(1, Date2DMY("Date Of Join", 2), (CurrentYear + 1));
                end;
            end;

        }

        // Add changes to keys here
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    var
        HumanResSetup: Record "Human Resources Setup";
        jobs: Record "Company Job";
        Scale: Record "Salary Scale";
        EmpContract: Record "Employment Contract";



}