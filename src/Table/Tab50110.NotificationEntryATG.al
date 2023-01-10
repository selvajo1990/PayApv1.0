table 50110 "Notification Entry ATG"
{
    DataClassification = CustomerContent;
    Caption = 'Notification Entry ATG';

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
        field(24; "Error Message ATG"; Text[2048])
        {
            DataClassification = CustomerContent;
            Caption = 'Error Message';
        }
        field(28; "Created Date-Time ATG"; DateTime)
        {
            DataClassification = CustomerContent;
            Caption = 'Created Date-Time';
        }
        field(29; "Created By ATG"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Created By';
        }
    }

    keys
    {
        key(PK; "ID ATG")
        {
            Clustered = true;
        }
    }

    var
        DataTypeManagement: Codeunit "Data Type Management";

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

    procedure CreateNew("Recipient Employee No.": Code[20]; NewRecord: Variant; "NewLinkTargetPage": Integer)
    var
        NotificationSchedule: Record "Notification Schedule ATG";
        ApprovalEntry: Record "Approval Entry ATG";
        NewRecRef: RecordRef;
        CreatedBy: Code[20];
    begin
        if not DataTypeManagement.GetRecordRef(NewRecord, NewRecRef) then
            exit;

        case NewRecRef.Number() of
            Database::"Approval Entry ATG":
                begin
                    NewRecRef.SetTable(ApprovalEntry);
                    CreatedBy := ApprovalEntry."Sender ID";
                end;
        end;

        Clear(Rec);
        "Recipient Employee No. ATG" := "Recipient Employee No.";
        "Triggered By Record ATG" := NewRecRef.RecordId();
        "Link Target Page ATG" := NewLinkTargetPage;
        "Created Date-Time ATG" := ROUNDDATETIME(CurrentDateTime(), 60000);
        "Created By ATG" := CreatedBy;
        Insert(true);
        NotificationSchedule.ScheduleNotification(Rec);
    end;
}