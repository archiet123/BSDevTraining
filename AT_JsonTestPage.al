page 50138 AT_JsonTestPage
{
    PageType = CardPart;
    ApplicationArea = All;
    SourceTable = AT_MovieTBL;

    layout
    {
        area(Content)
        {
            field(JsonData; rec.jsonData)
            {
                ApplicationArea = All;
            }
        }

    }

}


