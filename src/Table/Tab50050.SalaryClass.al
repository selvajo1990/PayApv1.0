table 50050 "Salary Class"
{
    DataClassification = CustomerContent;
    Caption = 'Salary Class';
    LookupPageId = "Salary Class List";
    fields
    {
        field(1; "Salary Class Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Salary Class';
        }
        field(2; Description; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Description';
        }
    }

    keys
    {
        key(PK; "Salary Class Code")
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