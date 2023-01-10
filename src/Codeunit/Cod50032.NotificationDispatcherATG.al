codeunit 50032 "Notification Dispatcher ATG"
{
    TableNo = "Job Queue Entry";
    trigger OnRun()
    begin
        if "Parameter String" > '' then
            DispatchNotificationTypeForUser("Parameter String")
        else
            DispatchInstantNotifications();
    end;

    local procedure DispatchInstantNotifications()
    var
        Employee: Record "Employee ATG";
        EmployeeByNotificationType: Query "Employee by Notification Type";
        UserIdWithError: Code[20];

    begin
        EmployeeByNotificationType.Open();
        while EmployeeByNotificationType.Read() do
            if not Employee.Get(EmployeeByNotificationType.Recipient_Employee_No__ATG) then
                UserIdWithError := EmployeeByNotificationType.Recipient_Employee_No__ATG
            else
                if ScheduledInstantly(Employee."No. ATG") then
                    DispatchForNotificationType(Employee);

    end;

    local procedure ScheduledInstantly(RecipientEmployeeNo: Code[20]): Boolean
    var
        NotificationSchedule: Record "Notification Schedule ATG";
    begin
        if not NotificationSchedule.Get(RecipientEmployeeNo) then
            exit(true);
        exit(NotificationSchedule."Recurrence ATG" = NotificationSchedule."Recurrence ATG"::Instantly);
    end;

    procedure DispatchNotificationTypeForUser(Parameter: Text)
    var
        Employee: Record "Employee ATG";
        NotificationEntry: Record "Notification Entry ATG";

    begin
        NotificationEntry.SetView(Parameter);
        Employee.Get(NotificationEntry.GetRangeMax("Recipient Employee No. ATG"));
        DispatchForNotificationType(Employee);
    end;

    procedure DispatchForNotificationType(Employee: Record "Employee ATG")
    var
        NotificationEntry: Record "Notification Entry ATG";
        NotificationSetup: Record "Notification Setup ATG";
    begin
        NotificationEntry.SetRange("Recipient Employee No. ATG", Employee."No. ATG");

        if not NotificationEntry.FindFirst() then
            exit;

        FilterToActiveNotificationEntries(NotificationEntry);

        NotificationSetup.GetNotificationSetupForUser(NotificationEntry."Recipient Employee No. ATG");

        case NotificationSetup."Notification Method ATG" of
            NotificationSetup."Notification Method ATG"::Email:
                CreateMailAndDispatch(NotificationEntry, Employee."Email ID ATG");
            NotificationSetup."Notification Method ATG"::Note:
                Error('Work in Progress');
        end;
    end;

    procedure CreateMailAndDispatch(var NotificationEntry: Record "Notification Entry ATG"; Email: Text)
    var
        NotificationSetup: Record "Notification Setup ATG";
        Employee: Record "Employee ATG";
        DocumentMailing: Codeunit "Document-Mailing";
        TempBlob: Codeunit "Temp Blob";
        MailInStream: InStream;
        MailOutStream: OutStream;
        ReportFilterTxt: Label '<?xml version="1.0" standalone="yes"?><ReportParameters name="Notification Email1" id="50001"><DataItems><DataItem name="Integer">VERSION(1) SORTING(Field1)</DataItem><DataItem name="Notification Entry">VERSION(1) SORTING(Field1) WHERE(Field1=1(%1))</DataItem></DataItems></ReportParameters>', Comment = '%1';
    begin
        Clear(TempBlob);
        TempBlob.CreateOutStream(MailOutStream, TEXTENCODING::UTF8);

        if not Report.SaveAs(54200, StrSubstNo(ReportFilterTxt, NotificationEntry."ID ATG"), ReportFormat::Html, MailOutStream) then
            exit;

        TempBlob.CreateInStream(MailInStream);
        Employee.Get(NotificationEntry."Recipient Employee No. ATG");
        Employee.TestField("Email ID ATG");
        if DocumentMailing.EmailHtmlFromStream(MailInStream, Employee."Email ID ATG", 'Notification overview', true, 0) then
            MoveNotificationEntryToSentNotificationEntries(NotificationEntry, 'BodyText', TRUE, NotificationSetup."Notification Method ATG"::Email)
        // BodyText = to be checked
        else begin
            NotificationEntry."Error Message ATG" := CopyStr(GetLastErrorText(), 1, 2048);
            ClearLastError();
            NotificationEntry.Modify(true);
        end;

    end;

    procedure MoveNotificationEntryToSentNotificationEntries(var NotificationEntry: Record "Notification Entry ATG"; NotificationBody: text; AggregatedNotifications: Boolean; NotificationMethod: Option)
    var
        SentNotificationEntry: Record "Sent Notification Entry ATG";
        InitialSentNotificationEntry: Record "Sent Notification Entry ATG";
    begin
        if AggregatedNotifications then begin
            if NotificationEntry.FindSet() then begin
                InitialSentNotificationEntry.NewRecord(NotificationEntry, NotificationBody, NotificationMethod);
                while NotificationEntry.Next() <> 0 do begin
                    SentNotificationEntry.NewRecord(NotificationEntry, NotificationBody, NotificationMethod);
                    SentNotificationEntry.VALIDATE("Aggregated with Entry ATG", InitialSentNotificationEntry."ID ATG");
                    SentNotificationEntry.Modify(true)
                end;
            end;
            NotificationEntry.DeleteAll(true);
        end else begin
            SentNotificationEntry.NewRecord(NotificationEntry, NotificationBody, NotificationMethod);
            NotificationEntry.Delete(true);
        end;
    end;

    procedure FilterToActiveNotificationEntries(var NotificationEntry: Record "Notification Entry ATG")
    begin
        repeat
            NotificationEntry.Mark(true);
        until NotificationEntry.Next() = 0;
        NotificationEntry.MarkedOnly(true);
        NotificationEntry.FindSet();
    end;

    procedure GetActionTextFor(VAR NotificationEntry: Record "Notification Entry ATG"): Text
    var
        ApprovalEntry: Record "Approval Entry ATG";
        DataTypeManagement: Codeunit "Data Type Management";
        RecRef: RecordRef;
    begin
        DataTypeManagement.GetRecordRef(NotificationEntry."Triggered By Record ATG", RecRef);
        RecRef.SETTABLE(ApprovalEntry);
        case ApprovalEntry.Status of
            ApprovalEntry.Status::Open:
                exit(ActionApproveTxt);
            ApprovalEntry.Status::Canceled:
                exit(ActionApprovalCanceledTxt);
            ApprovalEntry.Status::Rejected:
                exit(ActionApprovalRejectedTxt);
            ApprovalEntry.Status::Created:
                exit(ActionApprovalCreatedTxt);
            ApprovalEntry.Status::Approved:
                exit(ActionApprovedTxt);
        end;
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Notification Management", 'OnGetDocumentTypeAndNumber', '', false, false)]
    local procedure OnGetDocumentTypeAndNumber(var RecRef: RecordRef; var DocumentType: Text; var DocumentNo: Text; var IsHandled: Boolean)
    begin
        case RecRef.Number() of
            Database::"Leave Request":
                begin
                    DocumentType := RecRef.Caption();
                    DocumentNo := format(RecRef.Field(1));
                    IsHandled := true;
                end;
        end;
    end;

    var

        ActionApproveTxt: Label 'requires your approval.';
        ActionApprovalCanceledTxt: Label 'approval request has been canceled.';
        ActionApprovalRejectedTxt: Label 'approval has been rejected.';
        ActionApprovalCreatedTxt: Label 'approval request has been created.';
        ActionApprovedTxt: Label 'has been approved.';
}