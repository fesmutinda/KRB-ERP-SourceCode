namespace KRBERPSourceCode.KRBERPSourceCode;

using System.Security.User;
using System.Device;
using System.Security.AccessControl;

page 59068 "SignatureDocument"
{
    ApplicationArea = All;
    Caption = 'SignatureDocument';
    PageType = CardPart;
    SourceTable = "User Setup";

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                /*  field("Digital Signature"; Rec."Digital Signature")
                 {

                     ApplicationArea = All;
                     ShowCaption = false;
                     ToolTip = 'Specifies the value of the Digital Signature field.';
                     ShowMandatory = true;
                 }
                 field("Signature Date"; Rec."Signature Date")
                 {
                     ToolTip = 'Specifies the value of the Signature Upload Date field.', Comment = '%';
                 }
                 field("Signature File Name"; Rec."Signature File Name")
                 {
                     ToolTip = 'Specifies the value of the Signature File Name field.', Comment = '%';
                 } */
            }
        }
    }


    actions
    {
        area(processing)
        {
            action(ImportPicture)
            {
                ApplicationArea = All;
                Caption = 'Import';
                Image = Import;
                ToolTip = 'Import Document file.';
                Enabled = RecordIsOpen;

                trigger OnAction()
                var
                    DialogTittle: Label 'Select The Media File...';
                    FileName: Text;
                    InstreamFile: InStream;
                //................................................................
                begin
                    Rec.TestField(Rec."User ID");
                    if UploadIntoStream(DialogTittle, '', 'All Files (*.*)|*.*', FileName, InstreamFile) then begin
                        //  if Rec."Digital Signature".HasValue() then
                        begin
                            if Confirm(OverrideImageQst, false) = false then begin
                                exit;
                            end else begin
                                //  Clear(REC."Digital Signature");
                                rec.Modify();
                            end;
                        end;
                        //  rec."Digital Signature".ImportStream(InstreamFile, FileName);
                        if not Rec.Modify(true) then
                            Rec.Insert(true);
                    end;
                end;
            }
            action(DeletePicture)
            {
                ApplicationArea = All;
                Caption = 'Delete';
                Enabled = DeleteExportEnabled and RecordIsOpen;
                ;
                Image = Delete;
                ToolTip = 'Delete Document.';

                trigger OnAction()
                begin
                    Rec.TestField(Rec."User ID");

                    if not Confirm(DeleteImageQst) then
                        exit;

                    // Clear(Rec."Digital Signature");
                    Rec.Modify(true);
                end;
            }
        }
    }



    trigger OnAfterGetCurrRecord()
    begin
        SetEditableOnPictureActions();
        // if (rec."Approval Status" = rec."Approval Status"::Open) then begin
        //     RecordIsOpen := true;
        // end;
        RecordIsOpen := true;
    end;

    trigger OnOpenPage()
    begin
        CameraAvailable := Camera.IsAvailable();
    end;

    var
        Camera: Codeunit Camera;
        RecordIsOpen: Boolean;
        CameraAvailable: Boolean;
        OverrideImageQst: Label 'The existing Passport picture will be replaced. Do you want to continue?';
        DeleteImageQst: Label 'Are you sure you want to delete the picture?';
        SelectPictureTxt: Label 'Select a picture to upload';
        DeleteExportEnabled: Boolean;
        MimeTypeTok: Label 'image/jpeg', Locked = true;
        DownloadImageTxt: label 'Download image';


    local procedure SetEditableOnPictureActions()
    begin
        // DeleteExportEnabled := Rec."Digital Signature".HasValue;
    end;



}
