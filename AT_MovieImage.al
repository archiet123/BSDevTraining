page 50147 AT_MovieImage
{
    PageType = CardPart;
    ApplicationArea = All;
    // UsageCategory = Lists;
    SourceTable = AT_MovieTBL;

    layout
    {
        area(content)
        {
            field(Image; Rec.Image)
            {
                ApplicationArea = Invoicing, Basic, Suite;
                ShowCaption = false;
                ToolTip = 'Specifies the Image that has been inserted for the Movie.';
            }
            field(Image2; Rec.MovieImage)
            {
                ApplicationArea = Invoicing, Basic, Suite;
                ShowCaption = false;
                ToolTip = 'Specifies the Image that has been inserted for the Movie.';
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(ImportPicture)
            {
                ApplicationArea = All;
                Caption = 'Import';
                Image = Import;
                ToolTip = 'Import a picture file.';
                // Visible = HideActions = FALSE;

                trigger OnAction()


                var
                    FromFilter: Text;
                    NVInStream: InStream;
                begin
                    rec.ImportFromDevice(rec."No.");
                end;

            }
        }
    }
    var
        comp: Record "Company Information";
}