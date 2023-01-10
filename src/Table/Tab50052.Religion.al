table 50052 "Religion"
{
    DataClassification = CustomerContent;
    Caption = 'Religion';
    LookupPageId = Religions;
    fields
    {
        field(1; "Religion Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Religion Code';
        }
        field(2; Description; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Description';
        }
    }

    keys
    {
        key(PK; "Religion Code")
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