table 50135 AT_ExcelHelperSetupTBL
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; ExportType; Enum AT_ExportTypeEnum)
        {
            DataClassification = ToBeClassified;

        }
    }

    keys
    {
        key(Key1; ExportType)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}