table 50059 "Accommodation"
{
    DataClassification = CustomerContent;
    Caption = 'Accommodation';
    LookupPageId = Accommodations;
    fields
    {
        field(1; "Accommodation Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Accommodation Code';
        }
        field(2; Description; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Description';
        }
        field(3; "Notes"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Notes';
        }
    }

    keys
    {
        key(PK; "Accommodation Code")
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