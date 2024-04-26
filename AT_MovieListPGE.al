page 50149 AT_MovieListPGE
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = AT_MovieTBL;
    Caption = 'Movie List';
    CardPageId = AT_MovieCard;
    Editable = false;

    layout
    {

        area(Content)
        {
            group(testing)
            {
                part(TestPage; AT_JsonTestPage) { ApplicationArea = all; }
            }
            repeater(General)
            {
                field("No."; rec."No.")
                {
                    ApplicationArea = All;

                }
                field("title"; rec."Title")
                {
                    ApplicationArea = All;

                }
                field("Year"; rec."Year")
                {
                    ApplicationArea = All;

                }
                field("Genre"; rec."Genre")
                {
                    ApplicationArea = All;

                }
                field("Actors"; rec."Production")
                {
                    ApplicationArea = All;

                }
                field("Description"; rec."Description")
                {
                    ApplicationArea = All;

                }
                field(Score; rec.Score)
                {
                    ApplicationArea = All;
                }
            }
        }
        area(Factboxes)
        {

        }


    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin

                end;
            }

            action("Get Details")
            {
                ApplicationArea = All;
                image = Suggest;
                Caption = 'Get Details';
                ToolTip = 'Get the details from Json Placeholder';

                trigger OnAction()
                var
                    JsonPlaceholderHttpClient: HttpClient;
                    JsonPlaceholderHttpResponseMessage: HttpResponseMessage;
                    Url: Text;
                    UrlTok: Label 'http://jsonplaceholder.typicode.com/users/%1', Comment = '%1 = User Id', Locked = true;
                begin
                    // Url := StrSubstNo(UrlTok, UserId);
                    // if not JsonPlaceholderHttpClient.Get(Url, JsonPlaceholderHttpResponseMessage) then Error('No connection to %1', Url);
                    // if not JsonPlaceholderHttpResponseMessage.IsSuccessStatusCode() then
                    //     Error('Error: %1 - Reason: %2', JsonPlaceholderHttpResponseMessage.HttpStatusCode(),
                    //     JsonPlaceholderHttpResponseMessage.ReasonPhrase());
                    // JsonPlaceholderHttpResponseMessage.Content().ReadAs(JsonResult);


                    rec.GetMovie();
                end;
            }
            action("Download Image")
            {
                trigger OnAction()
                begin
                    rec.DownloadImage();
                end;
            }
        }
    }
    var
        JsonResult: Text;
}