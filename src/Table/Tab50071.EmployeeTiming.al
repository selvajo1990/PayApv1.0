table 50071 "Employee Timing"
{
    DataClassification = CustomerContent;
    Caption = 'Employee Timing';
    fields
    {
        field(1; "Employee No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Employee No.';
            TableRelation = Employee;

        }
        field(2; "From Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'From Date';
        }
        field(21; "Calendar ID"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Calendar ID';
        }
        field(22; "Week Day"; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Week Day';
        }
        field(23; "First Half Duration"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'First Half Duration';
        }
        field(24; "First Half Status"; Text[20])
        {
            DataClassification = CustomerContent;
            Caption = 'First Half Status';
        }
        field(25; "Second Half Duration"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Second Half Duration';
            Editable = false;
        }
        field(26; "Second Half Status"; Text[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Second Half Status';
        }
        field(27; "Break 1 Duration"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Break 1 Duration';
        }
        field(28; "Break 2 Duration"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Break 2 Duration';
        }
        field(29; "Break 3 Duration"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Break 3 Duration';
        }
        field(30; "Actual In-Time"; Time)
        {
            DataClassification = CustomerContent;
            Caption = 'Actual In-Time';
            trigger OnValidate()
            begin
                "Actual Out-Time" := 0T;
                "Actal Hours Worked" := 0;
            end;
        }
        field(31; "Actual Out-Time"; Time)
        {
            DataClassification = CustomerContent;
            Caption = 'Actual Out-Time';
            trigger OnValidate()
            begin
                TestField("Actual In-Time");
                "Actal Hours Worked" := ("Actual Out-Time" - "Actual In-Time");
            end;
        }
        field(32; "Actal Hours Worked"; Duration)
        {
            DataClassification = CustomerContent;
        }
        field(33; "Total Hours"; Duration)
        {
            DataClassification = CustomerContent;
            Caption = 'Total hours';
        }
        field(34; "OT Hours"; Duration)
        {
            DataClassification = CustomerContent;
            Caption = 'OT Hours';
        }

    }

    keys
    {
        key(PK; "Employee No.", "From Date")
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

}
