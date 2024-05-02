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

            action("Backup Movie")
            {
                ApplicationArea = All;

                trigger OnAction()
                var
                    AddressProvider: Interface IMovieBackup;
                begin
                    AddressproviderFactory(AddressProvider);
                    Message(AddressProvider.GetAddress(rec."No."));
                end;
            }

            action("Set XML")
            {
                ApplicationArea = All;

                trigger OnAction()
                begin
                    sendTo := sendTo::xml;
                end;
            }

            action("Set Json")
            {
                ApplicationArea = All;

                trigger OnAction()
                begin
                    sendTo := sendTo::json;
                end;
            }
        }


    }
    procedure AddressproviderFactory(var iAddressProvider: Interface IMovieBackup)
    begin
        iAddressProvider := sendTo;
    end;

    var
        JsonResult: Text;
        sendTo: enum SendTo;

}

interface "IMovieBackup"
{
    procedure GetAddress(var "No.": Code[20]): Text
}

codeunit 50129 BackupXML implements IMovieBackup
{

    procedure GetAddress(var "No.": Code[20]): Text
    var
        // ExampleAddressLbl: Label 'XML';
        Text: Text[250];
        Data: BigText;
        ins: InStream;
        outs: OutStream;
        TempBLOB: codeunit "Temp Blob";
        filename: Text;
    begin
        Text := 'XML ' + "No.";

        Data.AddText('Hello World');
        TempBLOB.CreateOutStream(outs);
        Data.Write(outs);
        TempBLOB.CreateInStream(ins);
        filename := "No." + '.XML';
        DownloadFromStream(
            ins,  // InStream to save
            '',   // Not used in cloud
            '',   // Not used in cloud
            '',   // Not used in cloud
            filename); // Filename is browser download folder
        exit(Text);
    end;
}

codeunit 50128 BackupJSON implements IMovieBackup
{

    procedure GetAddress(var "No.": Code[20]): Text
    var
        // ExampleAddressLbl: Label 'JSON';
        Text: Text[250];
        Data: BigText;
        ins: InStream;
        outs: OutStream;
        TempBLOB: codeunit "Temp Blob";
        filename: Text;

    begin
        Text := 'JSON ' + "No.";
        Data.AddText('Hello World');
        TempBLOB.CreateOutStream(outs);
        Data.Write(outs);
        TempBLOB.CreateInStream(ins);
        filename := "No." + '.JSON';
        DownloadFromStream(
            ins,  // InStream to save
            '',   // Not used in cloud
            '',   // Not used in cloud
            '',   // Not used in cloud
            filename); // Filename is browser download folder
        exit(Text);
        exit(Text);
    end;
}


//this enum chooses what codeunit runs
//i need a codeunit for every type of backup type there is
enum 50127 SendTo implements IMovieBackup
{
    Extensible = true;

    value(0; xml)
    {
        Implementation = IMovieBackup = BackupXML;
    }

    value(1; json)
    {
        Implementation = IMovieBackup = BackupJSON;
    }
}

interface IMovie
{
    procedure BackupMovie("No.": Code[20]);
}


