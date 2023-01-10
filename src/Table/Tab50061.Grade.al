table 50061 "Grade"
{
    DataClassification = CustomerContent;
    Caption = 'Grade';
    LookupPageId = Grades;

    fields
    {
        field(1; "Grade Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Level Code';
        }
        field(2; "Description"; Text[60])
        {
            DataClassification = CustomerContent;
            Caption = 'Description';
        }
    }

    keys
    {
        key(PK; "Grade Code")
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