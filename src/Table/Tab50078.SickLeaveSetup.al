table 50078 "Sick Leave Setup"
{
    DataClassification = CustomerContent;
    Caption = 'Sick leave Setup';

    fields
    {
        field(1; "Absence Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Absence Code';
            TableRelation = Absence;
        }
        field(2; "Line No."; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Line No.';
        }
        field(21; "From Days"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'From Days';
            MinValue = 0;
            trigger OnValidate()
            var
                SickLeaveSetupL: Record "Sick Leave Setup";
            begin
                if "From Days" = 0 then begin
                    "To Days" := 0;
                    "No. of Days" := 0;
                end;
                SickLeaveSetupL.SetRange("Absence Code", "Absence Code"); // Check Line No filter also required else Delayed Insert.
                if SickLeaveSetupL.FindLast() and ("From Days" <= SickLeaveSetupL."To Days") and ("From Days" > 0) then
                    Error(FromDaysShouldBeGreaterErr, FieldCaption("From Days"), SickLeaveSetupL."To Days");
            end;
        }
        field(22; "To Days"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'To Days';
            MinValue = 0;
            trigger OnValidate()
            begin
                if ("To Days" < "From Days") and ("To Days" > 0) then
                    Error(ToDaysCantBeLesserErr, FieldCaption("To Days"), FieldCaption("From Days"));
                if "To Days" = 0 then
                    "No. of Days" := 0
                else
                    "No. of Days" := "To Days" - "From Days" + 1;
            end;
        }
        field(23; "No. of Days"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'No. of Days';
            Editable = false;
        }
        field(24; Percentage; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Percentage';
            MinValue = 0;
            MaxValue = 100;
        }
    }

    keys
    {
        key(PK; "Absence Code", "Line No.")
        {
            Clustered = true;
        }
    }

    var
        ToDaysCantBeLesserErr: Label '%1 can''t be lesser than %2';
        FromDaysShouldBeGreaterErr: Label '%1 should be greater than %2';

    trigger OnInsert()
    begin
        if "Line No." = 0 then
            "Line No." := GetNextLineNo();
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

    procedure GetNextLineNo(): Integer
    var
        SickLeaveSetupL: Record "Sick Leave Setup";
    begin
        SickLeaveSetupL.SetRange("Absence Code", "Absence Code");
        if SickLeaveSetupL.FindLast() then
            exit(SickLeaveSetupL."Line No." + 10000);
        exit(10000);
    end;

}