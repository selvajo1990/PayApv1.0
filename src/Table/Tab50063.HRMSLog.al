table 50063 "HRMS Log"
{
    DataClassification = CustomerContent;
    Caption = 'HRMS Log';

    fields
    {
        field(1; "Entry No."; Integer)
        {
            DataClassification = CustomerContent;
            AutoIncrement = true;
            Caption = 'Entry No.';
        }
        field(2; "Record ID"; RecordId)
        {
            DataClassification = CustomerContent;
            Caption = 'Record ID';
        }
        field(21; "Field Name"; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Field Name';
        }
        field(22; "Field Value"; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Field Value';
        }
        field(23; "From Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'From Date';
        }
        field(24; "To Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'To Date';
        }
    }

    keys
    {
        key(PK; "Entry No.")
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

    procedure InsertLog(RecordIdP: RecordId; FieldNameP: Text; FieldValueP: Text)
    begin
        SetRange("Record ID", RecordIdP);
        SetRange("Field Name", FieldNameP);
        if FindLast() then begin
            "To Date" := Today();
            Modify();
        end;
        Init();
        "Entry No." := 0;
        "Record ID" := RecordIdP;
        "Field Name" := CopyStr(FieldNameP, 1, 50);
        "Field Value" := CopyStr(FieldValueP, 1, 50);
        "From Date" := Today();
        Insert();
    end;

}