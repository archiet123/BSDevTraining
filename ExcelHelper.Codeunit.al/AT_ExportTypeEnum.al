enum 50134 AT_ExportTypeEnum implements IExportType
{
    Extensible = true;

    value(0; Excel)
    {
        Implementation = IExportType = SendToExcel;
    }
}