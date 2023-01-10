table 50113 "Sent Notification Entry ATG"
{
    DataClassification = CustomerContent;
    Caption = 'Sent Notification Entry ATG';

    fields
    {
        field(1; "ID ATG"; Integer)
        {
            DataClassification = CustomerContent;
            AutoIncrement = true;
            Caption = 'ID';
        }
        field(21; "Recipient Employee No. ATG"; Code[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Recipient Employee No.';
        }
        field(22; "Triggered By Record ATG"; RecordId)
        {
            DataClassification = CustomerContent;
            Caption = 'Triggered By Record';
        }
        field(23; "Link Target Page ATG"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Link Target Page';
        }
        field(24; "Created Date-Time ATG"; DateTime)
        {
            DataClassification = CustomerContent;
            Caption = 'Created Date-Time';
        }
        field(25; "Created By ATG"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Created By';
        }
        field(26; "Sent Date-Time ATG"; DateTime)
        {
            DataClassification = CustomerContent;
            Caption = 'Sent Date-Time';
        }
        field(27; "Notification Content ATG"; Blob)
        {
            DataClassification = CustomerContent;
            Caption = 'Notification Content';
        }
        field(28; "Notification Method ATG"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = Email,Note;
            OptionCaption = 'Email,Note';
            Caption = 'Notification Method';
        }
        field(29; "Aggregated with Entry ATG"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Aggregated with Entry';
            TableRelation = "Sent Notification Entry ATG";
        }
    }

    keys
    {
        key(PK; "ID ATG")
        {
            Clustered = true;
        }
    }

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

    procedure NewRecord(NotificationEntry: Record "Notification Entry ATG"; NotificationContent: Text; NotificationMethod: Option)
    var
        SentNotificationEntry: Record "Sent Notification Entry ATG";
        OutStream: OutStream;
    begin
        Clear(Rec);
        IF SentNotificationEntry.FindLast() then;
        "ID ATG" := SentNotificationEntry."ID ATG" + 1;
        "Created By ATG" := NotificationEntry."Created By ATG";
        "Recipient Employee No. ATG" := NotificationEntry."Recipient Employee No. ATG";
        "Created Date-Time ATG" := NotificationEntry."Created Date-Time ATG";
        "Notification Content ATG".CreateOutStream(OutStream);
        OutStream.WRITETEXT(NotificationContent);
        "Notification Method ATG" := NotificationMethod;
        "Sent Date-Time ATG" := CurrentDateTime();
        Insert(true);
    end;
}