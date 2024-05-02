page 50126 AT_ExcelHelperSetupPGE
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = AT_ExcelHelperSetupTBL;

    layout
    {
        area(Content)
        {
            group(Setup)
            {
                field(ExportType; rec.ExportType)
                {
                    ApplicationArea = All;
                    // FieldPropertyName = FieldPropertyValue;
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