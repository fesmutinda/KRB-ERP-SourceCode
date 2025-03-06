#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
XmlPort 50016 MpesaTransImport
{
    Format = VariableText;

    schema
    {
        textelement(Root)
        {
            tableelement("CloudPESA Paybill Buffer"; "CloudPESA Paybill Buffer")
            {
                AutoUpdate = true;
                XmlName = 'CloudPEsaTRansactions';
                fieldelement(A; "CloudPESA Paybill Buffer"."Receipt No.")
                {
                }
                fieldelement(B; "CloudPESA Paybill Buffer"."Completion Time")
                {
                }
                fieldelement(C; "CloudPESA Paybill Buffer"."Initiation Time")
                {
                }
                fieldelement(D; "CloudPESA Paybill Buffer".Details)
                {
                }
                fieldelement(E; "CloudPESA Paybill Buffer"."Transaction Status")
                {
                }
                fieldelement(F; "CloudPESA Paybill Buffer"."Paid In")
                {
                }
                fieldelement(G; "CloudPESA Paybill Buffer".Withdrawn)
                {
                }
                fieldelement(H; "CloudPESA Paybill Buffer".Balance)
                {
                }
                fieldelement(I; "CloudPESA Paybill Buffer"."Balance Confirmed")
                {
                }
                fieldelement(J; "CloudPESA Paybill Buffer"."Reason Type")
                {
                }
                fieldelement(K; "CloudPESA Paybill Buffer"."Other Party Info")
                {
                }
                fieldelement(L; "CloudPESA Paybill Buffer"."Linked Transaction ID")
                {
                }
                fieldelement(M; "CloudPESA Paybill Buffer"."A/C No.")
                {
                }
            }
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }
}

