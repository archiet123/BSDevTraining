page 50148 AT_MovieCard
{
    PageType = Card;
    ApplicationArea = All;
    // Caption = 'Movie';
    SourceTable = AT_MovieTBL;


    layout
    {
        area(Content)
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
        area(Factboxes)
        {
            part(MoviePicture; AT_MovieImage)
            {
                ApplicationArea = All;
                Caption = 'Picture';
                SubPageLink = "No." = field("No.");
            }
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


        }
    }



    trigger OnOpenPage()
    begin
        Caption := rec.Title;
    end;

    var
        item: page "Item Card";

}