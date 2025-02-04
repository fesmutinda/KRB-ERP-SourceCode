#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
page 50485 "Posted Checkoff Proc. Header-D"
{
    DeleteAllowed = false;
    Editable = false;
    PageType = Card;
    SourceTable = "Checkoff Header-Distributed";
    SourceTableView = where(Posted = const(true));

    layout
    {
        area(content)
        {
            group(General)
            {
                field(No; Rec.No)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Entered By"; Rec."Entered By")
                {
                    ApplicationArea = Basic;
                    Enabled = false;
                }
                field("Date Entered"; Rec."Date Entered")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Posting date"; Rec."Posting date")
                {
                    ApplicationArea = Basic;
                    Editable = true;
                }
                field("Loan CutOff Date"; Rec."Loan CutOff Date")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(Remarks; Rec.Remarks)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Total Count"; Rec."Total Count")
                {
                    ApplicationArea = Basic;
                    Enabled = false;
                    Importance = Promoted;
                    Style = Favorable;
                    StyleExpr = true;
                }
                field("Posted By"; Rec."Posted By")
                {
                    ApplicationArea = Basic;
                }
                field("Account Type"; Rec."Account Type")
                {
                    ApplicationArea = Basic;
                }
                field("Account No"; Rec."Account No")
                {
                    ApplicationArea = Basic;
                }
                field("Employer Name"; Rec."Employer Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Employer Code"; Rec."Employer Code")
                {
                    ApplicationArea = Basic;
                }
                field("Document No"; Rec."Document No")
                {
                    ApplicationArea = Basic;
                    Caption = 'Document No./ Cheque No.';
                }
                field(Posted; Rec.Posted)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = Basic;
                }
                field("CheckOff Period"; Rec."CheckOff Period")
                {
                    ApplicationArea = Basic;
                }
                field("Total Scheduled"; Rec."Total Scheduled")
                {
                    ApplicationArea = Basic;
                    Enabled = false;
                    Importance = Promoted;
                    Style = Strong;
                    StyleExpr = true;
                }
            }
            part("Checkoff Lines-Distributed"; "Checkoff Processing Lines-D")
            {
                Caption = 'Checkoff Lines-Distributed';
                SubPageLink = "Receipt Header No" = field(No);
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Import Checkoff Distributed")
            {
                ApplicationArea = Basic;
                Caption = 'Import Checkoff';
                Enabled = ActionEnabled;
                Image = Import;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                // RunObject = XMLport 51516003;
            }
            group(ActionGroup1102755021)
            {
            }
            action("Validate Checkoff")
            {
                ApplicationArea = Basic;
                Caption = 'Validate Checkoff';
                Enabled = ActionEnabled;
                Image = ViewCheck;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;

                trigger OnAction()
                begin
                    /*TESTFIELD("Document No");
                    TESTFIELD(Amount);
                    
                    BATCH_TEMPLATE:='GENERAL';
                    BATCH_NAME:='CHECKOFF';
                    DOCUMENT_NO:=Remarks;
                    GenJournalLine.RESET;
                    GenJournalLine.SETRANGE("Journal Template Name",BATCH_TEMPLATE);
                    GenJournalLine.SETRANGE("Journal Batch Name",BATCH_NAME);
                    GenJournalLine.DELETEALL;
                    
                    MembLedg.RESET;
                    MembLedg.SETRANGE(MembLedg."Document No.","Document No");
                    IF MembLedg.FIND('-')= TRUE THEN
                    ERROR('Sorry,You have already posted this Document. Validation not Allowed.');
                    ReceiptLine.RESET;
                    //ReceiptLine.SETRANGE(ReceiptLine."Staff Not Found",No);
                    IF ReceiptLine.FINDSET(TRUE,TRUE) THEN
                      BEGIN
                        REPEAT
                         // ReceiptLine."No Repayment":='';
                          //ReceiptLine.Amount:='';
                          //ReceiptLine."Employer Code":=0;
                          ReceiptLine.MODIFY;
                      UNTIL ReceiptLine.NEXT=0;
                      END;
                    
                    ReceiptLine.RESET;
                    ReceiptLine.SETRANGE(ReceiptLine."Staff Not Found",No);
                    IF ReceiptLine.FIND('-') THEN BEGIN
                      REPEAT
                        Memb.RESET;
                        Memb.SETRANGE("Personal No",ReceiptLine."Staff/Payroll No");
                        IF Memb.FIND('-') THEN BEGIN
                          ReceiptLine."No Repayment":=Memb."No.";
                          ReceiptLine.Amount:=Memb.Name;
                          ReceiptLine."Employer Code":=ReceiptLine."Date Filter"+ReceiptLine."Transaction Date"+ReceiptLine."Entry No"+ReceiptLine.Generated+ReceiptLine."Payment No"+ReceiptLine.Posted+ReceiptLine."Multiple Receipts"+ReceiptLine.Name+ReceiptLine.
                    Wrong Expression
                          ReceiptLine."Early Remitance Amount"+ReceiptLine."Loan No."+ReceiptLine.Posted+ReceiptLine."Multiple Receipts"+ReceiptLine."Member No."+ReceiptLine.DEPT+ReceiptLine.Interest+ReceiptLine."Expected Amount"+ReceiptLine."FOSA Account"+ReceiptLine
                    W"Utility Type"+ReceiptLine."Transaction Type"+
                          ReceiptLine.Reference+ReceiptLine."Account type"+ReceiptLine.Variance;
                          ReceiptLine.MODIFY;
                          END;
                      UNTIL ReceiptLine.NEXT=0;
                    END;
                    MESSAGE('Validation was successfully completed');*/

                end;
            }
            action("Unallocated Funds")
            {
                ApplicationArea = Basic;
                Promoted = true;
                PromotedCategory = "Report";
                Visible = false;

                trigger OnAction()
                begin
                    ReptProcHeader.Reset;
                    ReptProcHeader.SetRange(ReptProcHeader.No, Rec.No);
                    if ReptProcHeader.Find('-') then
                        Report.Run(51516542, true, false, ReptProcHeader);
                end;
            }
            group(ActionGroup1102755019)
            {
            }
            action("Process Checkoff Distributed")
            {
                ApplicationArea = Basic;
                Caption = 'Process Checkoff';
                Enabled = ActionEnabled;
                Image = Apply;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;

                trigger OnAction()
                begin
                    /*IF CONFIRM('Are you sure you want to Transfer this Checkoff to Journals ?')=TRUE THEN BEGIN
                    TESTFIELD("Document No");
                    TESTFIELD(Amount);
                    IF Amount<>"Total Scheduled" THEN
                      ERROR('Scheduled Amount must be equal to the Cheque Amount');
                    
                    BATCH_TEMPLATE:='GENERAL';
                    BATCH_NAME:='CHECKOFF';
                    DOCUMENT_NO:=Remarks;
                    GenJournalLine.RESET;
                    GenJournalLine.SETRANGE("Journal Template Name",BATCH_TEMPLATE);
                    GenJournalLine.SETRANGE("Journal Batch Name",BATCH_NAME);
                    GenJournalLine.DELETEALL;
                    LineNo:=0;
                    ReceiptLine.RESET;
                    ReceiptLine.SETRANGE("Staff Not Found",No);
                    IF ReceiptLine.FIND('-') THEN BEGIN
                      REPEAT
                        IF ReceiptLine."No Repayment"<>'' THEN BEGIN
                        //----------------------------1. DEPOSITS----------------------------------------------------------------
                        LineNo:=LineNo+10000;
                        SFactory.FnCreateGnlJournalLine(BATCH_TEMPLATE,BATCH_NAME,DOCUMENT_NO,LineNo,GenJournalLine."Transaction Type"::"Interest Paid",
                        GenJournalLine."Account Type"::Employee,ReceiptLine."No Repayment","Posting date",ReceiptLine."Date Filter"* -1,'BOSA',"Document No",
                        FORMAT(GenJournalLine."Transaction Type"::"Interest Paid"),'');
                    
                    
                        //----------------------------2. NORM_P------------------------------------------------------------------
                        IF FnCheckLoanErrors('NORM',ReceiptLine."Transaction Date",ReceiptLine."No Repayment") THEN BEGIN
                            LineNo:=LineNo+10000;
                            SFactory.FnCreateGnlJournalLine(BATCH_TEMPLATE,BATCH_NAME,DOCUMENT_NO,LineNo,GenJournalLine."Transaction Type"::"Interest Paid",
                            GenJournalLine."Account Type"::Employee,ReceiptLine."No Repayment","Posting date",(ReceiptLine."Transaction Date"+ReceiptLine."Entry No")*-1,'BOSA',"Document No",
                            FORMAT(GenJournalLine."Transaction Type"::"Interest Paid"),'');
                        END ELSE
                        BEGIN
                        LineNo:=LineNo+10000;
                        SFactory.FnCreateGnlJournalLine(BATCH_TEMPLATE,BATCH_NAME,DOCUMENT_NO,LineNo,GenJournalLine."Transaction Type"::"Interest Due",
                        GenJournalLine."Account Type"::Employee,ReceiptLine."No Repayment","Posting date",ReceiptLine."Transaction Date"*-1,'BOSA',"Document No",
                        FORMAT(GenJournalLine."Transaction Type"::"Interest Due"),FnGetLoanNumber(ReceiptLine."No Repayment",'NORM'));
                        //----------------------------3. NORM_I------------------------------------------------------------------
                        LineNo:=LineNo+10000;
                        SFactory.FnCreateGnlJournalLine(BATCH_TEMPLATE,BATCH_NAME,DOCUMENT_NO,LineNo,GenJournalLine."Transaction Type"::Repayment,
                        GenJournalLine."Account Type"::Employee,ReceiptLine."No Repayment","Posting date",ReceiptLine."Entry No"*-1,'BOSA',"Document No",
                        FORMAT(GenJournalLine."Transaction Type"::Repayment),FnGetLoanNumber(ReceiptLine."No Repayment",'NORM'));
                        END;
                    
                    
                        //----------------------------4. REFIN_P------------------------------------------------------------------
                        IF FnCheckLoanErrors('REFIN',ReceiptLine.Generated,ReceiptLine."No Repayment") THEN BEGIN
                            LineNo:=LineNo+10000;
                            SFactory.FnCreateGnlJournalLine(BATCH_TEMPLATE,BATCH_NAME,DOCUMENT_NO,LineNo,GenJournalLine."Transaction Type"::"Interest Paid",
                            GenJournalLine."Account Type"::Employee,ReceiptLine."No Repayment","Posting date",(ReceiptLine.Generated+ReceiptLine."Payment No")*-1,'BOSA',"Document No",
                            FORMAT(GenJournalLine."Transaction Type"::"Interest Paid"),'');
                        END ELSE
                        BEGIN
                        LineNo:=LineNo+10000;
                        SFactory.FnCreateGnlJournalLine(BATCH_TEMPLATE,BATCH_NAME,DOCUMENT_NO,LineNo,GenJournalLine."Transaction Type"::"Interest Due",
                        GenJournalLine."Account Type"::Employee,ReceiptLine."No Repayment","Posting date",ReceiptLine.Generated*-1,'BOSA',"Document No",
                        FORMAT(GenJournalLine."Transaction Type"::"Interest Due"),FnGetLoanNumber(ReceiptLine."No Repayment",'REFIN'));
                        //----------------------------5. REFIN_I------------------------------------------------------------------
                        LineNo:=LineNo+10000;
                        SFactory.FnCreateGnlJournalLine(BATCH_TEMPLATE,BATCH_NAME,DOCUMENT_NO,LineNo,GenJournalLine."Transaction Type"::Repayment,
                        GenJournalLine."Account Type"::Employee,ReceiptLine."No Repayment","Posting date",ReceiptLine."Payment No"*-1,'BOSA',"Document No",
                        FORMAT(GenJournalLine."Transaction Type"::Repayment),FnGetLoanNumber(ReceiptLine."No Repayment",'REFIN'));
                        END;
                    
                    
                        //----------------------------6. EMER_P------------------------------------------------------------------
                         IF FnCheckLoanErrors('EMER',ReceiptLine.Posted,ReceiptLine."No Repayment") THEN BEGIN
                            LineNo:=LineNo+10000;
                            SFactory.FnCreateGnlJournalLine(BATCH_TEMPLATE,BATCH_NAME,DOCUMENT_NO,LineNo,GenJournalLine."Transaction Type"::"Interest Paid",
                            GenJournalLine."Account Type"::Employee,ReceiptLine."No Repayment","Posting date",(ReceiptLine.Posted+ReceiptLine."Multiple Receipts")*-1,'BOSA',"Document No",
                            FORMAT(GenJournalLine."Transaction Type"::"Interest Paid"),'');
                        END ELSE
                        BEGIN
                            LineNo:=LineNo+10000;
                            SFactory.FnCreateGnlJournalLine(BATCH_TEMPLATE,BATCH_NAME,DOCUMENT_NO,LineNo,GenJournalLine."Transaction Type"::"Interest Due",
                            GenJournalLine."Account Type"::Employee,ReceiptLine."No Repayment","Posting date",ReceiptLine.Posted*-1,'BOSA',"Document No",
                            FORMAT(GenJournalLine."Transaction Type"::"Interest Due"),FnGetLoanNumber(ReceiptLine."No Repayment",'EMER'));
                            //----------------------------7. EMER_I------------------------------------------------------------------
                            LineNo:=LineNo+10000;
                            SFactory.FnCreateGnlJournalLine(BATCH_TEMPLATE,BATCH_NAME,DOCUMENT_NO,LineNo,GenJournalLine."Transaction Type"::Repayment,
                            GenJournalLine."Account Type"::Employee,ReceiptLine."No Repayment","Posting date",ReceiptLine."Multiple Receipts"*-1,'BOSA',"Document No",
                            FORMAT(GenJournalLine."Transaction Type"::Repayment),FnGetLoanNumber(ReceiptLine."No Repayment",'EMER'));
                        END;
                    
                    
                        //----------------------------8. SCHOOL_P------------------------------------------------------------------
                         IF FnCheckLoanErrors('SCH LOAN',ReceiptLine.Name,ReceiptLine."No Repayment") THEN BEGIN
                            LineNo:=LineNo+10000;
                            SFactory.FnCreateGnlJournalLine(BATCH_TEMPLATE,BATCH_NAME,DOCUMENT_NO,LineNo,GenJournalLine."Transaction Type"::"Interest Paid",
                            GenJournalLine."Account Type"::Employee,ReceiptLine."No Repayment","Posting date",(ReceiptLine.Name+ReceiptLine."Early Remitances")*-1,'BOSA',"Document No",
                            FORMAT(GenJournalLine."Transaction Type"::"Interest Paid"),'');
                        END ELSE
                        BEGIN
                        LineNo:=LineNo+10000;
                        SFactory.FnCreateGnlJournalLine(BATCH_TEMPLATE,BATCH_NAME,DOCUMENT_NO,LineNo,GenJournalLine."Transaction Type"::"Interest Due",
                        GenJournalLine."Account Type"::Employee,ReceiptLine."No Repayment","Posting date",ReceiptLine.Name*-1,'BOSA',"Document No",
                        FORMAT(GenJournalLine."Transaction Type"::"Interest Due"),FnGetLoanNumber(ReceiptLine."No Repayment",'SCH LOAN'));
                        //----------------------------9. SCHOOL_I------------------------------------------------------------------
                        LineNo:=LineNo+10000;
                        SFactory.FnCreateGnlJournalLine(BATCH_TEMPLATE,BATCH_NAME,DOCUMENT_NO,LineNo,GenJournalLine."Transaction Type"::Repayment,
                        GenJournalLine."Account Type"::Employee,ReceiptLine."No Repayment","Posting date",ReceiptLine."Early Remitances"*-1,'BOSA',"Document No",
                        FORMAT(GenJournalLine."Transaction Type"::Repayment),FnGetLoanNumber(ReceiptLine."No Repayment",'SCH LOAN'));
                        END;
                    
                    
                        //----------------------------10. SPECIAL_P------------------------------------------------------------------
                         IF FnCheckLoanErrors('SP',ReceiptLine."Early Remitance Amount",ReceiptLine."No Repayment") THEN BEGIN
                            LineNo:=LineNo+10000;
                            SFactory.FnCreateGnlJournalLine(BATCH_TEMPLATE,BATCH_NAME,DOCUMENT_NO,LineNo,GenJournalLine."Transaction Type"::"Interest Paid",
                            GenJournalLine."Account Type"::Employee,ReceiptLine."No Repayment","Posting date",(ReceiptLine."Early Remitance Amount"+ReceiptLine."Loan No.")*-1,'BOSA',"Document No",
                            FORMAT(GenJournalLine."Transaction Type"::"Interest Paid"),'');
                        END ELSE
                        BEGIN
                          FnCheckLoanErrors('SP',ReceiptLine."Early Remitance Amount",ReceiptLine."No Repayment");
                          LineNo:=LineNo+10000;
                          SFactory.FnCreateGnlJournalLine(BATCH_TEMPLATE,BATCH_NAME,DOCUMENT_NO,LineNo,GenJournalLine."Transaction Type"::"Interest Due",
                          GenJournalLine."Account Type"::Employee,ReceiptLine."No Repayment","Posting date",ReceiptLine."Early Remitance Amount"*-1,'BOSA',"Document No",
                          FORMAT(GenJournalLine."Transaction Type"::"Interest Due"),FnGetLoanNumber(ReceiptLine."No Repayment",'SP'));
                          //----------------------------11. SPECIAL_I------------------------------------------------------------------
                          LineNo:=LineNo+10000;
                          SFactory.FnCreateGnlJournalLine(BATCH_TEMPLATE,BATCH_NAME,DOCUMENT_NO,LineNo,GenJournalLine."Transaction Type"::Repayment,
                          GenJournalLine."Account Type"::Employee,ReceiptLine."No Repayment","Posting date",ReceiptLine."Loan No."*-1,'BOSA',"Document No",
                          FORMAT(GenJournalLine."Transaction Type"::Repayment),FnGetLoanNumber(ReceiptLine."No Repayment",'SP'));
                        END;
                    
                    
                        //----------------------------12.INSURANCE-------------------------------------------------------------------
                    
                        LineNo:=LineNo+10000;
                        SFactory.FnCreateGnlJournalLine(BATCH_TEMPLATE,BATCH_NAME,DOCUMENT_NO,LineNo,GenJournalLine."Transaction Type"::"Deposit Contribution",
                        GenJournalLine."Account Type"::Employee,ReceiptLine."No Repayment","Posting date",ReceiptLine."Member No."* -1,'BOSA',"Document No",
                        FORMAT(GenJournalLine."Transaction Type"::"Deposit Contribution"),'');
                    
                        //----------------------------13.GOLDSAVE-------------------------------------------------------------------
                        LineNo:=LineNo+10000;
                        SFactory.FnCreateGnlJournalLine(BATCH_TEMPLATE,BATCH_NAME,DOCUMENT_NO,LineNo,GenJournalLine."Transaction Type"::" ",
                        GenJournalLine."Account Type"::Vendor,FnGetFosaAccountNo(ReceiptLine."No Repayment",'GOLDSAVE'),"Posting date",ReceiptLine.Interest*-1,'BOSA',"Document No",
                        'Gold Save','');
                    
                        //----------------------------15.THIRDPARTY------------------------------------------------------------------
                         IF FnCheckLoanErrors('GUR',ReceiptLine."Loan Type",ReceiptLine."No Repayment") THEN BEGIN
                            LineNo:=LineNo+10000;
                            SFactory.FnCreateGnlJournalLine(BATCH_TEMPLATE,BATCH_NAME,DOCUMENT_NO,LineNo,GenJournalLine."Transaction Type"::"Interest Paid",
                            GenJournalLine."Account Type"::Employee,ReceiptLine."No Repayment","Posting date",(ReceiptLine."Loan Type")*-1,'BOSA',"Document No",
                            FORMAT(GenJournalLine."Transaction Type"::"Interest Paid"),'');
                        END ELSE
                        BEGIN
                          LineNo:=LineNo+10000;
                          SFactory.FnCreateGnlJournalLine(BATCH_TEMPLATE,BATCH_NAME,DOCUMENT_NO,LineNo,GenJournalLine."Transaction Type"::"Interest Due",
                          GenJournalLine."Account Type"::Employee,ReceiptLine."No Repayment","Posting date",ReceiptLine."Loan Type"*-1,'BOSA',"Document No",
                          FORMAT(GenJournalLine."Transaction Type"::"Interest Due"),FnGetLoanNumber(ReceiptLine."No Repayment",'GUR'));
                        END;
                        //---------------------------16.BENEVOLENT------------------------------------------------------------------
                        LineNo:=LineNo+10000;
                        SFactory.FnCreateGnlJournalLine(BATCH_TEMPLATE,BATCH_NAME,DOCUMENT_NO,LineNo,GenJournalLine."transaction type"::"Share Capital",
                        GenJournalLine."Account Type"::Employee,ReceiptLine."No Repayment","Posting date",ReceiptLine.DEPT* -1,'BOSA',"Document No",
                        FORMAT(GenJournalLine."transaction type"::"Share Capital"),'');
                    
                    
                        //----------------------------17.ADVANCE_P------------------------------------------------------------------
                         IF FnCheckLoanErrors('SAL ADV',ReceiptLine."Expected Amount",ReceiptLine."No Repayment") THEN BEGIN
                            LineNo:=LineNo+10000;
                            SFactory.FnCreateGnlJournalLine(BATCH_TEMPLATE,BATCH_NAME,DOCUMENT_NO,LineNo,GenJournalLine."Transaction Type"::"Interest Paid",
                            GenJournalLine."Account Type"::Employee,ReceiptLine."No Repayment","Posting date",(ReceiptLine."Expected Amount"+ReceiptLine."FOSA Account")*-1,'BOSA',"Document No",
                            FORMAT(GenJournalLine."Transaction Type"::"Interest Paid"),'');
                        END ELSE
                        BEGIN
                          LineNo:=LineNo+10000;
                          SFactory.FnCreateGnlJournalLine(BATCH_TEMPLATE,BATCH_NAME,DOCUMENT_NO,LineNo,GenJournalLine."Transaction Type"::"Interest Due",
                          GenJournalLine."Account Type"::Employee,ReceiptLine."No Repayment","Posting date",ReceiptLine."Expected Amount"*-1,'BOSA',"Document No",
                          FORMAT(GenJournalLine."Transaction Type"::"Interest Due"),FnGetLoanNumber(ReceiptLine."No Repayment",'SAL ADV'));
                          //----------------------------18.ADVANCE_I------------------------------------------------------------------
                          LineNo:=LineNo+10000;
                          SFactory.FnCreateGnlJournalLine(BATCH_TEMPLATE,BATCH_NAME,DOCUMENT_NO,LineNo,GenJournalLine."Transaction Type"::Repayment,
                          GenJournalLine."Account Type"::Employee,ReceiptLine."No Repayment","Posting date",ReceiptLine."FOSA Account"*-1,'BOSA',"Document No",
                          FORMAT(GenJournalLine."Transaction Type"::Repayment),FnGetLoanNumber(ReceiptLine."No Repayment",'SAL ADV'));
                        END;
                        //17.PHONE_P
                        //18.PHONE_I
                    
                        //----------------------------19.ADVANCENSE_P------------------------------------------------------------------
                         IF FnCheckLoanErrors('NSE',ReceiptLine.Reference,ReceiptLine."No Repayment") THEN BEGIN
                            LineNo:=LineNo+10000;
                            SFactory.FnCreateGnlJournalLine(BATCH_TEMPLATE,BATCH_NAME,DOCUMENT_NO,LineNo,GenJournalLine."Transaction Type"::"Interest Paid",
                            GenJournalLine."Account Type"::Employee,ReceiptLine."No Repayment","Posting date",(ReceiptLine.Reference+ReceiptLine."Account type")*-1,'BOSA',"Document No",
                            FORMAT(GenJournalLine."Transaction Type"::"Interest Paid"),'');
                        END ELSE
                        BEGIN
                            LineNo:=LineNo+10000;
                            SFactory.FnCreateGnlJournalLine(BATCH_TEMPLATE,BATCH_NAME,DOCUMENT_NO,LineNo,GenJournalLine."Transaction Type"::"Interest Due",
                            GenJournalLine."Account Type"::Employee,ReceiptLine."No Repayment","Posting date",ReceiptLine.Reference*-1,'BOSA',"Document No",
                            FORMAT(GenJournalLine."Transaction Type"::"Interest Due"),FnGetLoanNumber(ReceiptLine."No Repayment",'NSE'));
                    
                            //----------------------------20.ADVANCENSE_I------------------------------------------------------------------
                            LineNo:=LineNo+10000;
                            SFactory.FnCreateGnlJournalLine(BATCH_TEMPLATE,BATCH_NAME,DOCUMENT_NO,LineNo,GenJournalLine."Transaction Type"::Repayment,
                            GenJournalLine."Account Type"::Employee,ReceiptLine."No Repayment","Posting date",ReceiptLine."Account type"*-1,'BOSA',"Document No",
                            FORMAT(GenJournalLine."Transaction Type"::Repayment),FnGetLoanNumber(ReceiptLine."No Repayment",'NSE'));
                        END;
                        //-----------------------------21.SHARES--------------------------------------------------------------------
                        LineNo:=LineNo+10000;
                        SFactory.FnCreateGnlJournalLine(BATCH_TEMPLATE,BATCH_NAME,DOCUMENT_NO,LineNo,GenJournalLine."Transaction Type"::Loan,
                        GenJournalLine."Account Type"::Employee,ReceiptLine."No Repayment","Posting date",ReceiptLine.Variance* -1,'BOSA',"Document No",
                        FORMAT(GenJournalLine."Transaction Type"::Loan),'');
                        END;
                      UNTIL ReceiptLine.NEXT=0;
                    END;
                       //Balancing Journal Entry
                        LineNo:=LineNo+10000;
                        SFactory.FnCreateGnlJournalLine(BATCH_TEMPLATE,BATCH_NAME,DOCUMENT_NO,LineNo,GenJournalLine."Transaction Type"::" ",
                        "Account Type","Account No","Posting date",Amount,'BOSA',"Document No",
                        Remarks,'');
                    
                    
                    
                    MESSAGE('Checkoff successfully Generated Jouranls ready for posting');
                    END;
                    */

                end;
            }
            action("Process Checkoff Unallocated")
            {
                ApplicationArea = Basic;
                Visible = false;

                trigger OnAction()
                begin
                    MembLedg.Reset;
                    MembLedg.SetRange(MembLedg."Document No.", Rec.Remarks);
                    if MembLedg.Find('-') = false then begin
                        Error('You Can Only do this process on Already Posted Checkoffs')
                    end;
                    ReceiptLine.Reset;
                    //ReceiptLine.SETRANGE(ReceiptLine."Receipt Header No",No);
                    //IF ReceiptLine.FIND('-') THEN
                    //REPORT.RUN(51516543,TRUE,FALSE,ReceiptLine);
                end;
            }
            action("Process Annual Charge")
            {
                ApplicationArea = Basic;
                Image = AuthorizeCreditCard;
                Promoted = true;
                PromotedCategory = Process;
                Visible = false;

                trigger OnAction()
                begin
                    Rec.TestField("Document No");
                    Rec.TestField(Amount);
                    ReceiptLine.Reset;
                    //ReceiptLine.SETRANGE(ReceiptLine."Receipt Header No",No);
                    //IF ReceiptLine.FIND('-') THEN
                    //REPORT.RUN(50100,TRUE,FALSE,ReceiptLine);
                end;
            }
            action("Mark as Posted")
            {
                ApplicationArea = Basic;
                Enabled = false;
                Image = PostBatch;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;

                trigger OnAction()
                begin
                    if Confirm('Are you sure you want to mark this Checkoff as Posted ?', false) = true then begin
                        MembLedg.Reset;
                        MembLedg.SetRange(MembLedg."Document No.", Rec.Remarks);
                        if MembLedg.Find('-') = false then
                            Error('Sorry,You can only do this process on already posted Checkoffs');
                        Rec.Posted := true;
                        Rec."Posted By" := UserId;
                        Rec."Posting date" := Today;
                        Rec.Modify;
                    end;
                end;
            }
            action("Print Preview")
            {
                ApplicationArea = Basic;
                Caption = 'Print Preview';
                Image = PrintReport;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    ReptProcHeader.Reset;
                    ReptProcHeader.SetRange(ReptProcHeader.No, Rec.No);
                    if ReptProcHeader.Find('-') then
                        Report.Run(51516972, true, false, ReptProcHeader)
                end;
            }
            action("Mark as Reversed")
            {
                ApplicationArea = Basic;
                Caption = 'Mark as Reversed';
                Image = Return;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    if Confirm('Are you sure  this Loan is Reversed?', true) = false then
                        exit;
                    Rec.Reversed := Rec.Reversed = true;
                    Rec.Modify;
                end;
            }
            action("Unmark Reversed")
            {
                ApplicationArea = Basic;
                Caption = 'Unmark Reversed';
                Image = UnApply;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    if Confirm('Are you sure  you want to Unmark this Loan?', true) = false then
                        exit;
                    Rec.Reversed := Rec.Reversed = true;
                    Rec.Modify;
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        MembLedg.Reset;
        MembLedg.SetRange(MembLedg."Document No.", Rec.Remarks);
        if MembLedg.Find('-') = true then
            ActionEnabled := false;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Rec."Posting date" := Today;
        Rec."Date Entered" := Today;
    end;

    var
        Gnljnline: Record "Gen. Journal Line";
        PDate: Date;
        DocNo: Code[20];
        RunBal: Decimal;
        ReceiptsProcessingLines: Record "Checkoff Lines-Distributed";
        LineNo: Integer;
        LBatches: Record "Loan Disburesment-Batching";
        Jtemplate: Code[30];
        JBatch: Code[30];
        "Cheque No.": Code[20];
        DActivityBOSA: Code[20];
        DBranchBOSA: Code[20];
        ReptProcHeader: Record "Checkoff Header-Distributed";
        Cust: Record Customer;
        MembPostGroup: Record "Customer Posting Group";
        Loantable: Record "Loans Register";
        LRepayment: Decimal;
        RcptBufLines: Record "Checkoff Lines-Distributed";
        LoanType: Record "Loan Products Setup";
        LoanApp: Record "Loans Register";
        Interest: Decimal;
        LineN: Integer;
        TotalRepay: Decimal;
        MultipleLoan: Integer;
        LType: Text;
        MonthlyAmount: Decimal;
        ShRec: Decimal;
        SHARESCAP: Decimal;
        DIFF: Decimal;
        DIFFPAID: Decimal;
        genstup: Record "Sacco General Set-Up";
        Memb: Record Customer;
        INSURANCE: Decimal;
        GenBatches: Record "Gen. Journal Batch";
        Datefilter: Text[50];
        ReceiptLine: Record "Checkoff Lines-Distributed";
        MembLedg: Record "Cust. Ledger Entry";
        SFactory: Codeunit "Swizzsoft Factory.";
        BATCH_NAME: Code[50];
        BATCH_TEMPLATE: Code[50];
        DOCUMENT_NO: Code[40];
        GenJournalLine: Record "Gen. Journal Line";
        ActionEnabled: Boolean;

    local procedure FnGetLoanNumber(MemberNo: Code[40]; "Loan Product Code": Code[100]): Code[100]
    var
        ObjLoans: Record 51371;
    begin
        ObjLoans.Reset;
        ObjLoans.SetRange("Client Code", MemberNo);
        ObjLoans.SetRange("Loan Product Type", "Loan Product Code");
        if ObjLoans.FindFirst then
            exit(ObjLoans."Loan  No.");
    end;

    local procedure FnGetFosaAccountNo(BosaAccountNo: Code[40]; "Product Code": Code[100]): Code[100]
    var
        ObjVendor: Record Vendor;
    begin
        ObjVendor.Reset;
        ObjVendor.SetRange("BOSA Account No", BosaAccountNo);
        ObjVendor.SetRange("Account Type", "Product Code");
        if ObjVendor.Find('-') then
            exit(ObjVendor."No.");
    end;

    local procedure FnCheckLoanErrors(LoanProduct: Code[100]; Amount: Decimal; MemberNo: Code[40]): Boolean
    var
        ObjLoans: Record 51371;
    begin
        if Amount > 0 then begin
            ObjLoans.Reset;
            ObjLoans.SetRange("Client Code", MemberNo);
            ObjLoans.SetRange("Loan Product Type", LoanProduct);
            if ObjLoans.FindFirst = false then
                exit(true);
        end;
    end;
}

