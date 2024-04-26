page 50137 AT_JsonBufferPGE
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "JSON Buffer";
    SourceTableTemporary = true;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Entry No."; rec."Entry No.")
                {
                    ApplicationArea = All;

                }
                field("depth"; rec."Depth")
                {
                    ApplicationArea = All;

                }
                field("Token type"; rec."Token type")
                {
                    ApplicationArea = All;

                }
                field("Value"; rec."Value")
                {
                    ApplicationArea = All;

                }
                field("Token Value"; rec."Value Type")
                {
                    ApplicationArea = All;

                }
                field("path"; rec.Path)
                {

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
        }
    }
}