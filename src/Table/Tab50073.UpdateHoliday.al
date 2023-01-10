table 50073 "Update Holiday"
{
    DataClassification = CustomerContent;
    Caption = 'Update Holiday';
    fields
    {
        field(1; "Calendar ID"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Calendar ID';
        }
        field(2; "Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Date';
            trigger OnValidate()
            var
                TimingL: Record Timing;
            begin
                "Week Day" := '';
                if "Date" > 0D then
                    "Week Day" := TimingL.GetDayAsText("Date");
            end;
        }
        field(21; "Week Day"; Text[30])
        {
            DataClassification = CustomerContent;
            Caption = 'Week Day';
            Editable = false;
        }
        field(22; Description; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Description';
        }
        field(23; "Day Type"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = "Working Day","Week Off","Public Holiday";
            OptionCaption = 'Working Day,Week Off,Public Holiday';
        }

    }

    keys
    {
        key(PK; "Calendar ID", Date)
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