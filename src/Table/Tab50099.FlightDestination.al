table 50099 "Flight Destination"
{
    DataClassification = CustomerContent;
    Caption = 'Flight Destination';
    DrillDownPageId = "Flight Destinations";
    LookupPageId = "Flight Destinations";
    fields
    {
        field(1; "Flight Destination Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Flight Destination Code';
        }
        field(2; "Country Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Country Code';
            TableRelation = "Country/Region";
            trigger OnValidate()
            var
                Country: Record "Country/Region";
            begin
                if Country.Get("Country Code") then;
                Rec.Country := Country.Name;
            end;
        }
        field(21; "City"; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'City';
        }
        field(22; "Country"; text[30])
        {
            DataClassification = CustomerContent;
            Caption = 'Country';
            Editable = false;
        }
    }

    keys
    {
        key(PK; "Flight Destination Code")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
        fieldgroup(DropDown; "Flight Destination Code", City, Country)
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