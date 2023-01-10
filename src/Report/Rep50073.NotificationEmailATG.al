report 50073 "Notification Email ATG"
{
    WordLayout = './res/Notification Email ATG.docx';
    Caption = 'Notification Email';
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = Word;

    dataset
    {
        dataitem("Integer"; "Integer")
        {
            DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
            column(Line1; Line1)
            {
            }
            column(Line2; Line2)
            {
            }
            column(Line3; Line3Lbl)
            {
            }
            column(Line4; Line4Lbl)
            {
            }
            column(Settings_UrlText; SettingsLbl)
            {
            }
            column(Settings_Url; SettingsURL)
            {
            }
            column(SettingsWin_UrlText; SettingsWinLbl)
            {
            }
            column(SettingsWin_Url; SettingsWinURL)
            {
            }
            dataitem("Notification Entry"; "Notification Entry ATG")
            {
                DataItemTableView = sorting("ID ATG");
                column(UserName; ReceipientUser."Name ATG")
                {
                }
                column(DocumentType; DocumentType)
                {
                }
                column(DocumentNo; DocumentNo)
                {
                }
                column(Document_UrlText; DocumentName)
                {
                }
                column(Document_Url; DocumentURL)
                {
                }
                column(CustomLink_UrlText; CustomLinkLbl)
                {
                }
                column(ActionText; ActionText)
                {
                }
                column(Field1Label; Field1Label)
                {
                }
                column(Field1Value; Field1Value)
                {
                }
                column(Field2Label; Field2Label)
                {
                }
                column(Field2Value; Field2Value)
                {
                }
                column(Field3Label; Field3Label)
                {
                }
                column(Field3Value; Field3Value)
                {
                }
                column(DetailsLabel; DetailsLabel)
                {
                }
                column(DetailsValue; DetailsValue)
                {
                }

                trigger OnAfterGetRecord()
                var
                    RecRef: RecordRef;
                begin
                    FindReceipientUser();
                    CreateSettingsLink();
                    NotificationSetup.GetNotificationSetupForUser("Recipient Employee No. ATG");
                    DataTypeManagement.GetRecordRef("Triggered By Record ATG", RecRef);
                    SetDocumentTypeAndNumber(RecRef);
                    SetActionText();
                    SetReportFieldPlaceholders(RecRef);
                    SetReportLinePlaceholders();
                end;
            }
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        CompanyInformation.Get();
    end;

    var
        NotificationSetup: Record "Notification Setup ATG";
        CompanyInformation: Record "Company Information";
        ReceipientUser: Record "Employee ATG";
        PageManagement: Codeunit "Page Management";
        DataTypeManagement: Codeunit "Data Type Management";
        NotificationManagement: Codeunit "Notification Dispatcher ATG";
        SettingsURL: Text;
        SettingsWinURL: Text;
        DocumentType: Text;
        DocumentNo: Text;
        DocumentName: Text;
        DocumentURL: Text;
        ActionText: Text;
        Field1Label: Text;
        Field1Value: Text;
        Field2Label: Text;
        Field2Value: Text;
        Field3Label: Text;
        Field3Value: Text;
        SettingsLbl: Label 'Notification Settings';
        SettingsWinLbl: Label '(Windows Client)';
        CustomLinkLbl: Label '(Custom Link)';
        Line1Lbl: Label 'Hello %1,', Comment = '%1 = User Name';
        Line2Lbl: Label 'You are registered to receive notifications related to %1.', Comment = '%1 = Company Name';
        Line3Lbl: Label 'This is a message to notify you that:';
        Line4Lbl: Label 'Notification messages are sent automatically and cannot be replied to. But you can change when and how you receive notifications:';
        DetailsLabel: Text;
        DetailsValue: Text;
        Line1: Text;
        Line2: Text;
        DetailsLbl: Label 'Details';

    local procedure FindReceipientUser()
    begin
        ReceipientUser.SetRange("No. ATG", "Notification Entry"."Recipient Employee No. ATG");
        if not ReceipientUser.FindFirst() then
            ReceipientUser.Init();
    end;

    local procedure CreateSettingsLink()
    var
        RecRef: RecordRef;
        PageID: Integer;
    begin
        if SettingsURL <> '' then
            exit;

        NotificationSetup.SetRange("Employee No. ATG", ReceipientUser."No. ATG");
        DataTypeManagement.GetRecordRef(NotificationSetup, RecRef);
        PageID := PageManagement.GetPageID(RecRef);
        SettingsURL := PageManagement.GetWebUrl(RecRef, PageID);
        SettingsWinURL := ''; // no more RTC
    end;

    local procedure SetDocumentTypeAndNumber(SourceRecRef: RecordRef)
    var
        NotificationManagementStd: Codeunit "Notification Management";
        RecRef: RecordRef;
    begin
        GetTargetRecRef(SourceRecRef, RecRef);
        NotificationManagementStd.GetDocumentTypeAndNumber(RecRef, DocumentType, DocumentNo);
        DocumentName := DocumentType + ' ' + DocumentNo;
    end;

    local procedure SetActionText()
    begin
        ActionText := NotificationManagement.GetActionTextFor("Notification Entry");
    end;

    local procedure SetReportFieldPlaceholders(SourceRecRef: RecordRef)
    var
        Employee: Record "Employee ATG";
        LeaveRequest: Record "Leave Request";
        ApprovalEntry: Record "Approval Entry ATG";
        RecRef: RecordRef;
        // RecordDetails: Text; TBD
        HasApprovalEntryAmount: Boolean;
    begin
        Clear(Field1Label);
        Clear(Field1Value);
        Clear(Field2Label);
        Clear(Field2Value);
        Clear(Field3Label);
        Clear(Field3Value);
        Clear(DetailsLabel);
        Clear(DetailsValue);

        DetailsLabel := DetailsLbl;
        DetailsValue := "Notification Entry".FieldCaption("Created By ATG") + ' ';

        Employee.SetRange("No. ATG", "Notification Entry"."Created By ATG");
        if Employee.FindFirst() and (Employee."Name ATG" <> '') then
            DetailsValue += Employee."Name ATG"
        else
            DetailsValue += "Notification Entry"."Created By ATG";

        if SourceRecRef.Number() = DATABASE::"Approval Entry ATG" then begin
            HasApprovalEntryAmount := true;
            SourceRecRef.SetTable(ApprovalEntry);
        end;

        GetTargetRecRef(SourceRecRef, RecRef);

        case RecRef.Number() of
            Database::"Leave Request":
                begin
                    RecRef.SetTable(LeaveRequest);
                    Field1Label := LeaveRequest.FieldCaption("Leave Days");
                    Field1Value := format(ApprovalEntry."Approval Value");
                    Field2Label := Employee.TableCaption();
                    Field2Value := Employee."Name ATG" + ' (#' + Format(Employee."No. ATG") + ')';
                    Field3Label := ApprovalEntry.FieldCaption("Sender ID");
                    Field3Value := ApprovalEntry."Sender ID";

                end;
        end;
        DocumentURL := PageManagement.GetWebUrl(RecRef, "Notification Entry"."Link Target Page ATG");
    end;

    local procedure SetReportLinePlaceholders()
    begin
        Line1 := StrSubstNo(Line1Lbl, ReceipientUser."Name ATG");
        Line2 := StrSubstNo(Line2Lbl, CompanyInformation.Name);
    end;

    local procedure GetTargetRecRef(RecRef: RecordRef; var TargetRecRefOut: RecordRef)
    var
        ApprovalEntry: Record "Approval Entry ATG";
    begin
        RecRef.SetTable(ApprovalEntry);
        TargetRecRefOut.Get(ApprovalEntry."Record ID to Approve");
    end;

    local procedure FormatAmount(Amount: Decimal): Text
    begin
        exit(Format(Amount, 0, '<Precision,2><Standard Format,0>'));
    end;

    [IntegrationEvent(false, false)]
    local procedure OnSetReportFieldPlaceholders(RecRef: RecordRef; var Field1Label: Text; var Field1Value: Text; var Field2Label: Text; var Field2Value: Text)
    begin
    end;


}

