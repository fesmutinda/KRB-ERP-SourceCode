page 56049 "Custom Headline"
{
    // NOTE: If you are making changes to this page you might want to make changes to all the other Headline RC pages

    Caption = '';
    PageType = HeadlinePart;
    RefreshOnActivate = true;

    layout
    {
        area(content)
        {
            group(Control1)
            {
                ShowCaption = false;
                Visible = UserGreetingVisible;
                field(GreetingText; RCHeadlinesPageCommon.GetGreetingText())
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Greeting headline';
                    Editable = false;
                }


            }
            // group(Control2)
            // {
            //     ShowCaption = false;
            //     Visible = DefaultFieldsVisible;
            //     field(DocumentationText; RCHeadlinesPageCommon.GetDocumentationText())
            //     {
            //         ApplicationArea = Basic, Suite;
            //         Caption = 'Documentation headline';
            //         DrillDown = true;
            //         Editable = false;

            //         trigger OnDrillDown()
            //         begin
            //             HyperLink(RCHeadlinesPageCommon.DocumentationUrlTxt());
            //         end;
            //     }
            // }
        }
    }

    trigger OnOpenPage()
    begin
        RCHeadlinesPageCommon.HeadlineOnOpenPage(Page::"Headline RC Accountant");
        DefaultFieldsVisible := RCHeadlinesPageCommon.AreDefaultFieldsVisible();
        UserGreetingVisible := RCHeadlinesPageCommon.IsUserGreetingVisible();
    end;

    var
        [InDataSet]
        DefaultFieldsVisible: Boolean;
        [InDataSet]
        UserGreetingVisible: Boolean;
        RCHeadlinesPageCommon: Codeunit "RC Headlines Page Common";
}

