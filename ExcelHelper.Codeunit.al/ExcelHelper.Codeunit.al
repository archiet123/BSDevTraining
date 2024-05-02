#pragma warning disable LC0015, AA0228, AA0215
codeunit 50101 "Excel Helper" implements IExportType
{
    Access = Internal;
    SingleInstance = true;

    procedure ExportAllUserRecordsToExcel()
    var
        TempExcelBuffer: Record "Excel Buffer" temporary;
    begin
        CreateExcelHeaders(TempExcelBuffer);
        ExportAllUserRecordsToExcel(TempExcelBuffer);
        CloseExcelFile('Users', TempExcelBuffer);
    end;

    local procedure ExportAllUserRecordsToExcel(var TempExcelBuffer: Record "Excel Buffer" temporary)
    var
        User: Record User;
    begin
        if User.FindSet() then
            repeat
                ExportRecordToExcel(User, TempExcelBuffer);
            until User.Next() = 0;
    end;

    local procedure CreateExcelHeaders(var TempExcelBuffer: Record "Excel Buffer" temporary)
    begin
        TempExcelBuffer.NewRow();
        CreateExcelColumnHeader('First Name', TempExcelBuffer);
        CreateExcelColumnHeader('Last Name', TempExcelBuffer);
        CreateExcelColumnHeader('Email', TempExcelBuffer);
    end;

    local procedure ExportRecordToExcel(User: Record User; var TempExcelBuffer: Record "Excel Buffer" temporary)
    var
    begin
        TempExcelBuffer.NewRow();
        CreateExcelColumn(User."User Security ID", TempExcelBuffer);
        CreateExcelColumn(User."User Name", TempExcelBuffer);
        CreateExcelColumn(User."Full Name", TempExcelBuffer);
        CreateExcelColumn(User."Contact Email", TempExcelBuffer);
        CreateExcelColumn(Format(User."License Type"), TempExcelBuffer);
    end;

    local procedure CreateExcelColumnHeader(TextValue: Text; var TempExcelBuffer: Record "Excel Buffer" temporary)
    begin
        CreateExcelColumn(TextValue, true, TempExcelBuffer."Cell Type"::"Text", TempExcelBuffer);
    end;

    local procedure CreateExcelColumn(NumberValue: Integer; var TempExcelBuffer: Record "Excel Buffer" temporary)
    begin
        CreateExcelColumn(NumberValue, false, TempExcelBuffer."Cell Type"::"Number", TempExcelBuffer);
    end;

    local procedure CreateExcelColumn(TextValue: Text; var TempExcelBuffer: Record "Excel Buffer" temporary)
    begin
        CreateExcelColumn(TextValue, false, TempExcelBuffer."Cell Type"::"Text", TempExcelBuffer);
    end;

    local procedure CreateExcelColumn(VariantValue: Variant; IsBold: Boolean; CellType: Option "Number","Text","Date","Time";
                                      var TempExcelBuffer: Record "Excel Buffer" temporary)
    begin
        TempExcelBuffer.AddColumn(VariantValue, false, '', IsBold, false, false, '', CellType);
    end;

    local procedure CloseExcelFile(Name: Text[250]; var TempExcelBuffer: Record "Excel Buffer" temporary)
    var
        FileNameTok: Label 'Business Central Booster %1', Locked = true, Comment = '%1 = Name of the set';
        FileNameWithExtensionTok: Label 'Business Central Booster %1.xlsx', Locked = true;
        FileName: Text;
    begin
        TempExcelBuffer.CreateNewBook(Name);
        TempExcelBuffer.WriteSheet(Name, CompanyName, UserId());
        TempExcelBuffer.CloseBook();

        // Use Direct Download if you want to download the file directly to the user's browser
        FileName := StrSubstNo(FileNameTok, Name);
        DirectDownload(Name, TempExcelBuffer);

        // Use SaveToStream if you want to save the file to an OutStream and then do something with it
        FileName := StrSubstNo(FileNameWithExtensionTok, Name);
        SaveToStream(FileName, TempExcelBuffer);
    end;

    local procedure DirectDownload(FileName: Text; var TempExcelBuffer: Record "Excel Buffer" temporary)
    begin
        TempExcelBuffer.SetFriendlyFilename(FileName);
        TempExcelBuffer.OpenExcel();
    end;

    local procedure SaveToStream(FileName: Text; var TempExcelBuffer: Record "Excel Buffer" temporary)
    var
        TempBlob: Codeunit "Temp Blob";
        ExcelOutStream: OutStream;
    begin
        TempBlob.CreateOutStream(ExcelOutStream);
        TempExcelBuffer.SaveToStream(ExcelOutStream, true);

        // Download the file to the user's browser
        DownloadToUsersBrowser(FileName, TempBlob);

        // Or send the file to an email
        SendExcelAsEmail(FileName, TempBlob);

        // Or send the file to an http endpoint
        SendExcelAsHttp(FileName, TempBlob);
    end;

    local procedure DownloadToUsersBrowser(FileName: Text; var TempBlob: Codeunit "Temp Blob")
    var
        ExcelInStream: InStream;
        ExcelFilterLbl: Label 'Excel Files (*.xlsx)|*.xlsx', Locked = true;
    begin
        TempBlob.CreateInStream(ExcelInStream);

        DownloadFromStream(ExcelInStream, 'Download Excel File', '', ExcelFilterLbl, FileName);
    end;

    local procedure SendExcelAsEmail(FileName: Text; var TempBlob: Codeunit "Temp Blob")
    var
        EmailMessage: Codeunit "Email Message";
        Email: Codeunit Email;
        ExcelInStream: InStream;
        ContentType: Text;
    begin
        TempBlob.CreateInStream(ExcelInStream);

        ContentType := GetContentType(FileName);

        EmailMessage.Create('info@someone.com', 'Business Central Users', 'Attached is the list of users');
        EmailMessage.AddAttachment(CopyStr(FileName, 1, 250), CopyStr(ContentType, 1, 250), ExcelInStream);
        Email.Send(EmailMessage);
    end;

    local procedure SendExcelAsHttp(FileName: Text; var TempBlob: Codeunit "Temp Blob")
    var
        ExcelHttpClient: HttpClient;
        ExcelHttpResponseMessage: HttpResponseMessage;
        ExcelHttpContent: HttpContent;
        ServiceUrl: Text;
        CallToWebserviceFailedErr: Label 'Call to webservice failed.';
        WebserviceReturnedErr: Label 'Webservice returned an error. Description: %1', Comment = '%1 = Error description';
    begin
        ServiceUrl := 'https://www.test.com/uploadexcel';

        SetHttpContentAndHeaders(FileName, TempBlob, ExcelHttpContent);

        if not (ExcelHttpClient.Post(ServiceUrl, ExcelHttpContent, ExcelHttpResponseMessage)) then
            Error(CallToWebserviceFailedErr);

        if not (ExcelHttpResponseMessage.IsSuccessStatusCode()) then
            Error(WebserviceReturnedErr, ExcelHttpResponseMessage.ReasonPhrase);

        // Handle the response from the webservice               
    end;

    local procedure SetHttpContentAndHeaders(FileName: Text; var TempBlob: Codeunit "Temp Blob";
                                             var ExcelHttpContent: HttpContent)
    var
        ContentHeaders: HttpHeaders;
        ExcelInStream: InStream;
        ContentType: Text;
    begin
        TempBlob.CreateInStream(ExcelInStream);

        ContentType := GetContentType(FileName);

        ExcelHttpContent.WriteFrom(ExcelInStream);
        ExcelHttpContent.GetHeaders(ContentHeaders);
        if ContentHeaders.Contains('Content-Type') then
            ContentHeaders.Remove('Content-Type');
        ContentHeaders.Add('Content-Type', ContentType);
    end;

    local procedure GetContentType(FileName: Text): Text
    var
        FileManagement: Codeunit "File Management";
    begin
        exit(FileManagement.GetFileNameMimeType(FileName));
    end;

    procedure SetExportType()
}

