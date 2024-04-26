page 50146 AT_MovieAPIPGE
{
    PageType = API;
    ApplicationArea = All;
    SourceTable = AT_MovieTBL;
    APIVersion = 'v2.0';
    EntityCaption = 'AT_MovieAPIPGE';
    EntitySetCaption = 'AT_MovieAPIPGE';
    EntityName = 'AT_MovieAPIPGE';
    EntitySetName = 'AT_MovieAPIPGE';
    ChangeTrackingAllowed = true;
    DelayedInsert = true;
    APIPublisher = 'AT';
    APIGroup = 'AT';

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("No"; rec."No.")
                {
                    ApplicationArea = All;
                    Caption = 'No.';
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
    }


}