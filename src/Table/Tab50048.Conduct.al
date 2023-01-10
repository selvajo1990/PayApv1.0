table 50048 "Conduct"
{
    DataClassification = CustomerContent;
    Caption = 'Conduct';
    LookupPageId = "Conduct List";
    fields
    {
        field(1; "Conduct Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Conduct Code';
        }
        field(2; "Conduct Description"; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Conduct Description';
        }
    }

    keys
    {
        key(PK; "Conduct Code")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
        fieldgroup(Dropdown; "Conduct Code", "Conduct Description")
        {

        }
        fieldgroup(Brick; "Conduct Code", "Conduct Description")
        {

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