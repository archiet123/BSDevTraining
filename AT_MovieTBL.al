table 50149 AT_MovieTBL
{
    DataClassification = ToBeClassified;
    DrillDownPageId = AT_MovieListPGE;

    //No.: Code[20]
    // Title: Text[50]
    // Year: Integer
    // Genre: Text[50]
    // Actors: Text[250]
    // Production: Text[50]
    // Description: Text[250]
    // Score: Decimal
    // Image: Media

    fields
    {
        field(1; "No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Movie Number';
        }
        field(2; "Title"; Text[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'Title';
        }
        field(3; "Year"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Year';
        }
        field(4; Genre; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Actors"; Text[250])
        {
            DataClassification = ToBeClassified;
            Caption = 'Actors';
        }
        field(6; Production; Text[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'Production';
        }
        field(7; Description; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(8; Score; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Score';
        }
        field(9; Image; Media)
        {
            DataClassification = ToBeClassified;
            Caption = 'Image';
        }
        field(10; MovieImage; Blob)
        {
            DataClassification = ToBeClassified;
            Caption = 'Image';
        }
        field(11; JsonData; Text[2048])
        {
            DataClassification = ToBeClassified;
            Caption = 'JsonData';
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(Brick; Image, Title, Description, Score)
        {

        }
    }

    procedure ImportFromDevice(var ImageNo: Code[20])
    var
        FromFilter: Text;
        NVInStream: InStream;
    begin

        UploadIntoStream(FromFilter, NVInStream);  //uploading stream
        rec.image.ImportStream(NVInStream, rec.Description); //importing stream
        rec.Modify(); //modifying record

    end;


    procedure GetMovie()
    var
        ImageURL: text;//Image URL
        ImageHTTP: HttpClient;
        ImageResponse: HttpResponseMessage;
        Instr: InStream;
        TitleList: Text;
        count: Integer;
        JsonBuffer: Record "JSON Buffer" temporary;
        JsonText: Text;
        GoogleJsonToken, GoogleResultToken : JsonToken; GoogleHttpClient: HttpClient;
        omdbapiResponse: HttpResponseMessage;
        omdbapi: Label 'http://www.omdbapi.com/?apikey=f64d383a&s=Matrix';//'http://www.omdbapi.com/?apikey=f64d383a&s=Matrix' working
        WebserviceReturnedErr: Label 'The Google Maps web service returned an error message:\\Status code: %1\Description: %2', Comment = '%1 = Status Code.';
    begin

        if not GoogleHttpClient.Get(StrSubstNo(omdbapi), omdbapiResponse) then begin
            SendErrorNotification('The call to the Google Maps web service failed.');

        end;

        if not omdbapiResponse.IsSuccessStatusCode() then begin

            SendErrorNotification(StrSubstNo(WebserviceReturnedErr, omdbapiResponse.HttpStatusCode(), omdbapiResponse.ReasonPhrase()));
        end;


        omdbapiResponse.Content().ReadAs(JsonText);
        // JsonResult := omdbapiResponse;

        if not GoogleJsonToken.ReadFrom(JsonText) then begin
            SendErrorNotification('Invalid response from the Google Maps web service. Invalid JSON object.');
        end;

        // if not GoogleJsonToken.SelectToken('$.Search[*]', GoogleResultToken) then begin
        //     SendErrorNotification('bad route.');
        //     exit(0);
        // end;

        if not GoogleResultToken.IsValue() then begin
            SendErrorNotification('No valid route found via the Google Maps web service.');
        end;

        //exit(Round((GoogleResultToken.AsValue().AsText()), 1, '='));

        // Message(Format(JsonText));
        Clear(JsonBuffer);
        Clear(count);
        Clear(TitleList);
        Clear(NoSeries);
        JsonBuffer.ReadFromText(JsonText);
        JsonBuffer.SetFilter("Token type", 'String');
        // page.Run(page::AT_JsonBufferPGE, JsonBuffer);
        if JsonBuffer.FindSet() then begin
            // repeat

            Clear(rec);
            Clear(Instr);

            //This should filter ITEM No Series and get next available no.
            NoSeries.SetFilter("Series Code", 'ITEM');
            if NoSeries.FindFirst() then begin
                rec."No." := NoSeriesMan.GetNextNo(NoSeries."Series Code", NoSeries."Last Date Used", true)

            end;
            // rec."No." := NoSeries."Last No. Used";
            rec.Title := JsonBuffer.Value;


            // TitleList.Add(JsonBuffer.Value);
            // TitleList += JsonBuffer.Value + ',';
            //build up a list of IDs

            JsonBuffer.Next();
            //year
            JsonBuffer.Next();
            //ID
            JsonBuffer.Next();
            //MOVIE
            JsonBuffer.Next();
            //image string
            ImageURL := JsonBuffer.Value;

            ImageHTTP.Get(ImageURL, ImageResponse);
            omdbapiResponse.Content.ReadAs(InStr);
            rec.MovieImage.CreateInStream(InStr);
            rec.Insert();
            // rec.Modify();


            // until JsonBuffer.Next() = 0;
            // Clear(JsonBuffer);

            // count := Dialog.StrMenu(TitleList, 0, 'Movie Results');
            //get the index of movie selected
            //crossreference this to list of IDs
            //create new GET request to fetch movie ID only
            //insert results into table
            //save string path of image, this needs to be set as record
        end;
    end;

    procedure DownloadImage()
    var
        ImageURL: Label 'https://m.media-amazon.com/images/M/MV5BNzQzOTk3OTAtNDQ0Zi00ZTVkLWI0MTEtMDllZjNkYzNjNTc4L2ltYWdlXkEyXkFqcGdeQXVyNjU0OTQ0OTY@._V1_SX300.jpg';//Image URL
        ImageURL2: Label 'https://m.media-amazon.com/images/M/MV5BNWM3MDU2MWQtYjdlNC00NDBlLTkyNGMtNjdhYjdlNTdiNTFlXkEyXkFqcGdeQXVyNTEwNDY2MjU@._V1_SX300.jpg';
        ImageHTTP: HttpClient;
        ImageResponse: HttpResponseMessage;
        Instr: InStream;
    begin

        // if not ImageHTTP.Get(StrSubstNo(omdbapi), omdbapiResponse) then begin
        //     SendErrorNotification('Cannot Download Image');

        ImageHTTP.Get(ImageURL2, ImageResponse);
        ImageResponse.Content.ReadAs(InStr);
        Clear(Rec.Image);
        rec.Image.ImportStream(InStr, 'Demo picture for item ' + Format(rec."No."));
        rec.Modify(true);

    end;



    local procedure SendErrorNotification(Message: Text)
    var
        ErrorNotification: Notification;
    begin
        ErrorNotification.Scope(NotificationScope::LocalScope);
        ErrorNotification.Message(Message);
        ErrorNotification.Send();
    end;


    var
        compinfo: page "Company Information";
        MovieID: text;
        NoSeries: Record "No. Series Line";
        NoSeriesMan: Codeunit 396;
}