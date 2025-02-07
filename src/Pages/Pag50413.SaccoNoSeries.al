#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
page 50413 "Sacco No. Series"
{
    ApplicationArea = Basic;
    DeleteAllowed = false;
    InsertAllowed = false;
    Editable = true;
    SourceTable = "Sacco No. Series";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';

                field("SMS Request Series"; Rec."SMS Request Series")
                {
                    ApplicationArea = Basic;
                }
            }
            group(BOSA)
            {
                Caption = 'BOSA';
                field("Member Application Nos"; Rec."Member Application Nos")
                {
                    ApplicationArea = Basic;
                }
                field("Top Up Loan Nos"; Rec."Top Up Loan Nos")
                {
                    ApplicationArea = Basic;
                }
                field("Loan Appeal Numbers"; Rec."Loan Appeal Numbers")
                {
                    ApplicationArea = Basic;
                }
                field("Guarantor Sub No."; Rec."Guarantor Sub No.")
                {
                    ApplicationArea = Basic;
                }
                field("Members Nos"; Rec."Members Nos")
                {
                    ApplicationArea = Basic;
                }
                field("Junior Account No."; Rec."Junior Account No.")
                {
                    ApplicationArea = Basic;
                }
                field("BOSA Loans Nos"; Rec."BOSA Loans Nos")
                {
                    ApplicationArea = Basic;
                }
                field("Loans Batch Nos"; Rec."Loans Batch Nos")
                {
                    ApplicationArea = Basic;
                }
                field("BOSA Receipts Nos"; Rec."BOSA Receipts Nos")
                {
                    ApplicationArea = Basic;
                }
                field("BOSA Transfer Nos"; Rec."BOSA Transfer Nos")
                {
                    ApplicationArea = Basic;
                }
                field("Closure  Nos"; Rec."Closure  Nos")
                {
                    ApplicationArea = Basic;
                }
                field("Share Capital Transfer No.s"; Rec."Share Capital Transfer No.s")
                {
                    ApplicationArea = Basic;
                }

                field("Bosa Transaction Nos"; Rec."Bosa Transaction Nos")
                {
                    ApplicationArea = Basic;
                }
                field("Micro Transactions"; Rec."Micro Transactions")
                {
                    ApplicationArea = Basic;
                }
                field("Micro Finance Transactions"; Rec."Micro Finance Transactions")
                {
                    ApplicationArea = Basic;
                }
                field("Micro Group Nos."; Rec."Micro Group Nos.")
                {
                    ApplicationArea = Basic;
                }
                field("Teller Bulk Trans Nos."; Rec."Teller Bulk Trans Nos.")
                {
                    ApplicationArea = Basic;
                }
                field("Paybill Processing"; Rec."Paybill Processing")
                {
                    ApplicationArea = Basic;
                }
                field(BosaNumber; Rec.BosaNumber)
                {
                    ApplicationArea = Basic;
                    Caption = 'Bosa member Number';
                    Visible = false;
                }
                field("Member Re-Application No.s"; Rec."Member Re-Application No.s")
                {
                    ApplicationArea = Basic;
                }
                field("Checkoff-Proc Distributed Nos"; Rec."Checkoff-Proc Distributed Nos")
                {
                    ApplicationArea = Basic;
                }
                field("Tracker no"; Rec."Tracker no")
                {
                    ApplicationArea = Basic;
                }
                field("Activation Nos"; Rec."Activation Nos")
                {
                    ApplicationArea = Basic;
                }
                field("Top Up Nos"; Rec."Top Up Nos")
                {
                    ApplicationArea = Basic;
                }
                field("OVerdraft Nos"; Rec."OVerdraft Nos")
                {
                    ApplicationArea = Basic;
                }
                field("Last Memb No."; Rec."Last Memb No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;

                }
                field("Loan Recovery Nos"; Rec."Loan Recovery Nos")
                {
                    ApplicationArea = Basic;
                }
                field("Change Request No"; Rec."Change Request No")
                {
                    ApplicationArea = Basic;
                }
            }
            group(FOSA)
            {
                Caption = 'FOSA';
                Visible = false;
                field("FOSA Loans Nos"; Rec."FOSA Loans Nos")
                {
                    ApplicationArea = Basic;
                }
                // field("Member Periodics Nos"; Rec."Member Periodics Nos")
                // {
                //     ApplicationArea = Basic;
                // }
                // field("Okoa No."; Rec."Okoa No.")
                // {
                //     ApplicationArea = Basic;
                // }
                field("Transaction Nos."; Rec."Transaction Nos.")
                {
                    ApplicationArea = Basic;
                }
                field("Treasury Nos."; Rec."Treasury Nos.")
                {
                    ApplicationArea = Basic;
                }
                field("Standing Orders Nos."; Rec."Standing Orders Nos.")
                {
                    ApplicationArea = Basic;
                }
                field("FOSA Current Account"; Rec."FOSA Current Account")
                {
                    ApplicationArea = Basic;
                }
                field("BOSA Current Account"; Rec."BOSA Current Account")
                {
                    ApplicationArea = Basic;
                }
                field("Teller Transactions No"; Rec."Teller Transactions No")
                {
                    ApplicationArea = Basic;
                }
                field("Treasury Transactions No"; Rec."Treasury Transactions No")
                {
                    ApplicationArea = Basic;
                }
                field("Applicants Nos."; Rec."Applicants Nos.")
                {
                    ApplicationArea = Basic;
                }
                field("STO Register No"; Rec."STO Register No")
                {
                    ApplicationArea = Basic;
                }
                field("EFT Header Nos."; Rec."EFT Header Nos.")
                {
                    ApplicationArea = Basic;
                }
                field("EFT Details Nos."; Rec."EFT Details Nos.")
                {
                    ApplicationArea = Basic;
                }
                field("Salaries Nos."; Rec."Salaries Nos.")
                {
                    ApplicationArea = Basic;
                }
                field("ATM Applications"; Rec."ATM Applications")
                {
                    ApplicationArea = Basic;
                }
                // field("Banking Shares Nos"; Rec."Banking Shares Nos")
                // {
                //     ApplicationArea = Basic;
                // }
                field("Cheque Application Nos"; Rec."Cheque Application Nos")
                {
                    ApplicationArea = Basic;
                }
                field("Cheque Receipts Nos"; Rec."Cheque Receipts Nos")
                {
                    ApplicationArea = Basic;
                }

                field("Receipts Nos"; Rec."Receipts Nos")
                {
                    ApplicationArea = all;
                }
                field("Member Agent/NOK Change"; Rec."Member Agent/NOK Change")
                {
                    ApplicationArea = Basic;
                }
                field("Agent Serial Nos"; Rec."Agent Serial Nos")
                {
                    ApplicationArea = Basic;
                }
            }
            group(Others)
            {
                Caption = 'Others';
                field("Requisition No"; Rec."Requisition No")
                {
                    ApplicationArea = Basic;
                }
                field("Internal Requisition No."; Rec."Internal Requisition No.")
                {
                    ApplicationArea = Basic;
                }
                field("Internal Purchase No."; Rec."Internal Purchase No.")
                {
                    ApplicationArea = Basic;
                }
                field("Quatation Request No"; Rec."Quatation Request No")
                {
                    ApplicationArea = Basic;
                }
                field("Stores Requisition No"; Rec."Stores Requisition No")
                {
                    ApplicationArea = Basic;
                }
                field("Requisition Default Vendor"; Rec."Requisition Default Vendor")
                {
                    ApplicationArea = Basic;
                }
                field("Use Procurement limits"; Rec."Use Procurement limits")
                {
                    ApplicationArea = Basic;
                }
                field("Request for Quotation Nos"; Rec."Request for Quotation Nos")
                {
                    ApplicationArea = Basic;
                }
                field("Investors Nos"; Rec."Investors Nos")
                {
                    ApplicationArea = Basic;
                }
                field("Property Nos"; Rec."Property Nos")
                {
                    ApplicationArea = Basic;
                }
                field("Investment Project Nos"; Rec."Investment Project Nos")
                {
                    ApplicationArea = Basic;
                }
                field("Withholding Tax %"; Rec."Withholding Tax %")
                {
                    ApplicationArea = Basic;
                }
                field("Withholding Tax Account"; Rec."Withholding Tax Account")
                {
                    ApplicationArea = Basic;
                }
                field("VAT %"; Rec."VAT %")
                {
                    ApplicationArea = Basic;
                }
                field("VAT Account"; Rec."VAT Account")
                {
                    ApplicationArea = Basic;
                }
            }
            group(Investor)
            {
                Visible = false;
                Caption = 'Investor';
                field("Investor Application Nos"; Rec."Investor Application Nos")
                {
                    ApplicationArea = Basic;
                }
                field("Investor Nos"; Rec."Investor Nos")
                {
                    ApplicationArea = Basic;
                }
            }
            group("S-PESA")
            {
                Caption = 'S-PESA';
                Visible = false;
                field("MPESA Change Nos"; Rec."MPESA Change Nos")
                {
                    ApplicationArea = Basic;
                }
                field("MPESA Application Nos"; Rec."MPESA Application Nos")
                {
                    ApplicationArea = Basic;
                }
                field("Change MPESA PIN Nos"; Rec."Change MPESA PIN Nos")
                {
                    ApplicationArea = Basic;
                }
                field("Change MPESA Application Nos"; Rec."Change MPESA Application Nos")
                {
                    ApplicationArea = Basic;
                }
                field("SurePESA Registration Nos"; Rec."SwizzKash Reg No.")
                {
                    ApplicationArea = all;
                }
            }
        }
    }

    trigger OnInit()

    begin
        if Rec.IsEmpty() then
            Rec.Insert();
    end;
}

