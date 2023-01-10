table 50085 "Destination"
{
    DataClassification = CustomerContent;
    Caption = 'Destination';
    LookupPageId = 50128;
    DrillDownPageId = 50128;
    fields
    {
        field(1; Code; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Code';
        }
        field(21; City; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'City';
        }
        field(22; "Destination Type Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Destination Type Code';
            TableRelation = "Destination Type";
            trigger OnValidate()
            var
                DestinationType: Record "Destination Type";

            begin
                if DestinationType.Get("Destination Type Code") then;
                "Destination Type Description" := DestinationType.Description;
            end;
        }
        field(23; "Destination Type Description"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Destination Type Description';
        }
    }

    keys
    {
        key(PK; Code)
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
        fieldgroup(DropDown; Code, City, "Destination Type Description")
        {

        }
        fieldgroup(Brick; Code, City, "Destination Type Description")
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