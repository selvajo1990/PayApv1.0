table 50055 "Age Group"
{
    DataClassification = CustomerContent;
    Caption = 'Age Group';
    LookupPageId = "Age Group";
    fields
    {
        field(1; "Age Group Code"; Code[20])
        {
            Caption = 'Age Group Code';
            DataClassification = CustomerContent;
        }
        field(2; "Description"; Text[50])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(3; "From Age"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'From Days';
            MinValue = 1;
            trigger OnValidate()
            var
                AgeGroupL: Record "Age Group";
            begin
                Age := 0;
                "To Age" := 0;
                AgeGroupL.SetCurrentKey("From Age");
                if AgeGroupL.FindLast() and ("From Age" < AgeGroupL."From Age") then
                    Error(FromDayShouldBeGreaterErr, FieldCaption("From Age"), AgeGroupL."To Age");
            end;
        }
        field(4; "To Age"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'To Days';
            MinValue = 1;
            trigger OnValidate()
            begin
                TestField("From Age");
                if "From Age" > "To Age" then
                    Error(FromDayValidateErr, FieldCaption("From Age"), FieldCaption("To Age"));
                Age := ("To Age" - "From Age" + 1) / 365;
            end;
        }
        field(5; "Age"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Age';
            Editable = false;
        }

    }

    keys
    {
        key(PK; "Age Group Code")
        {
            Clustered = true;
        }
    }
    var
        FromDayValidateErr: Label '%1 can''t be greater than %2';
        FromDayShouldBeGreaterErr: Label '%1 should be greater than %2';

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