table 50058 "Employee Asset Type"
{
    DataClassification = CustomerContent;
    Caption = 'Employee Asset Type';
    LookupPageId = "Employee Asset Types";

    fields
    {
        field(1; "Asset Type Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Asset Code';
        }
        field(2; "Description"; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Description';
        }
    }

    keys
    {
        key(PK; "Asset Type Code")
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