#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 56027 "Member List"
{
    ApplicationArea = Basic;
    Caption = 'Member List';
    CardPageID = "Member Account Card";
    Editable = false;
    DeleteAllowed = true;
    PageType = List;
    SourceTable = Customer;
    SourceTableView = sorting("No.")
                      order(ascending)
                      where("Customer Type" = filter(Member),
                            "Customer Posting Group" = filter('MEMBER'));
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = Basic;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = Basic;
                    Style = StrongAccent;
                }
                field(SecondName; Rec."Name 2")
                {
                    ApplicationArea = Basic;
                    Style = StrongAccent;
                }
                // field(LastName; Rec.Surname)
                // {
                //     ApplicationArea = Basic;
                //     Style = StrongAccent;
                // }

                field("ID No."; Rec."ID No.")
                {
                    ApplicationArea = Basic;
                }

                field("Phone No."; Rec."Phone No.")
                {
                    ApplicationArea = Basic;
                    Caption = 'Mobile Phone';

                }
                field("Payroll No"; Rec."Payroll/Staff No")
                {
                    Caption = 'Payroll No';
                    ApplicationArea = basic;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = basic;
                }
                field("Date of Birth"; Rec."Date of Birth")
                {
                    ApplicationArea = Basic;
                }
                field("Shares Retained"; Rec."Shares Retained")
                {
                    ApplicationArea = Basic;
                    Caption = 'Share Capital';
                }
                field("Current Shares"; Rec."Current Shares")
                {
                    Caption = 'Non-withdrawable Deposits';
                    Style = StrongAccent;
                    ApplicationArea = Basic;
                }
                field("Outstanding Balance"; Rec."Outstanding Balance")
                {
                    Style = StrongAccent;
                    Caption = 'Oustanding Loan Balance';
                    ApplicationArea = Basic;
                }
                field("Outstanding Interest"; Rec."Outstanding Interest")
                {
                    Style = StrongAccent;
                    Caption = 'Oustanding Loan Interest';
                    ApplicationArea = Basic;
                }
                // field("Likizo Contribution"; Rec."Likizo Contribution")
                // {
                //     ApplicationArea = all;
                //     Caption = 'Holiday Contribution';
                // }
                // field("Alpha Savings"; Rec."Alpha Savings")
                // {
                //     ApplicationArea = all;
                // }
                field("Un-allocated Funds"; Rec."Un-allocated Funds")
                {
                    ApplicationArea = all;
                }
                // field("Junior Savings One"; Rec."Junior Savings One")
                // {
                //     ApplicationArea = all;
                // }

            }
        }
        area(factboxes)
        {
            part("Member Statistics FactBox"; "Member Statistics FactBox")
            {
                SubPageLink = "No." = field("No.");
                Visible = true;
                ApplicationArea = all;
            }
        }

    }

    actions
    {
        area(Processing)
        {
            // group(ActionGroup1102755024)
            // {
            //     // action("Account Page")
            //     // {
            //     //     ApplicationArea = Basic;
            //     //     Image = Planning;
            //     //     Caption = 'FOSA Account Page';
            //     //     Promoted = true;
            //     //     PromotedCategory = Process;
            //     //     RunObject = Page "Account Card";
            //     //     RunPageLink = "No." = field("FOSA Account");
            //     // }
            // }
            group(ActionGroup1102755007)
            {
                action(DetailedStatement)
                {
                    ApplicationArea = Basic;
                    Caption = 'Detailed Statement';
                    Image = Customer;
                    Promoted = true;
                    PromotedCategory = "process";

                    trigger OnAction()
                    begin
                        Cust.Reset;
                        Cust.SetRange(Cust."No.", Rec."No.");
                        if Cust.Find('-') then
                            Report.Run(50223, true, false, Cust);
                    end;
                }
                action(GStatement)
                {
                    ApplicationArea = Basic;
                    Caption = 'Loans Guaranteed';
                    Image = Customer;
                    Promoted = true;
                    PromotedCategory = "process";

                    trigger OnAction()
                    begin
                        Cust.Reset;
                        Cust.SetRange(Cust."No.", Rec."No.");
                        if Cust.Find('-') then
                            Report.Run(50226, true, false, Cust);
                    end;
                }
                action("Shares Statement")
                {
                    ApplicationArea = Basic;
                    Image = "Report";
                    Promoted = true;
                    visible = false;
                    PromotedCategory = "Report";

                    trigger OnAction()
                    begin
                        Cust.Reset;
                        Cust.SetRange(Cust."No.", Rec."No.");
                        if Cust.Find('-') then
                            Report.Run(50302, true, false, Cust);
                    end;
                }
                action("Loans Statement")
                {
                    ApplicationArea = Basic;
                    Image = "Report";
                    Promoted = true;
                    visible = false;
                    PromotedCategory = "Report";

                    trigger OnAction()
                    begin
                        Cust.Reset;
                        Cust.SetRange(Cust."No.", Rec."No.");
                        if Cust.Find('-') then
                            Report.Run(50608, true, false, Cust);
                    end;
                }
                action("Shares Certificate")
                {
                    ApplicationArea = Basic;
                    Promoted = true;
                    //visible = false;
                    PromotedCategory = "Report";

                    trigger OnAction()
                    begin
                        Cust.Reset;
                        Cust.SetRange(Cust."No.", Rec."No.");
                        if Cust.Find('-') then
                            Report.Run(50303, true, false, Cust);
                    end;
                }
                action(Statement)
                {
                    ApplicationArea = Basic;
                    Promoted = true;
                    //visible = false;
                    Caption = 'Member Statement';
                    PromotedCategory = "Report";

                    trigger OnAction()
                    begin
                        Cust.Reset;
                        Cust.SetRange(Cust."No.", Rec."No.");
                        if Cust.Find('-') then
                            Report.Run(50223, true, false, Cust);
                    end;
                }
            }
        }
    }
    trigger OnAfterGetRecord()
    begin

    end;

    // trigger OnOpenPage()
    // var
    //     EmailBody: Text[700];
    //     EmailSubject: Text[100];
    //     Emailaddress: Text[100];
    // begin
    //     Emailaddress := ;
    //     EmailSubject := 'wee wacha';
    //     EMailBody := 'Dear <b>' + '</b>,</br></br>'+
    //         'On behalf of KRB Sacco am pleased to inform you that your application for membership has been accepted.' +'<br></br>'+
    //         'Congratulations';
    //     SwizzsoftFactory.SendMail(Emailaddress, EmailSubject, EmailBody);
    // end;

    var
        SwizzsoftFactory: Codeunit "swizzsoft Factory";
        Cust: Record Customer;
        GeneralSetup: Record "Sacco General Set-Up";
        Gnljnline: Record "Gen. Journal Line";
        TotalRecovered: Decimal;
        TotalAvailable: Integer;
        Loans: Record "Loans Register";
        TotalFOSALoan: Decimal;
        TotalOustanding: Decimal;
        Vend: Record Vendor;
        TotalDefaulterR: Decimal;
        Value2: Decimal;
        AvailableShares: Decimal;
        Value1: Decimal;
        Interest: Decimal;
        LineN: Integer;
        LRepayment: Decimal;
        RoundingDiff: Decimal;
        DActivity: Code[20];
        DBranch: Code[20];
        LoansR: Record "Loans Register";
        LoanAllocation: Decimal;
        LGurantors: Record "Loans Guarantee Details";
}

