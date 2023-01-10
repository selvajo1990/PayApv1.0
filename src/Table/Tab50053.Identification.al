table 50053 "Identification"
{
    DataClassification = CustomerContent;
    LookupPageId = Identification;
    Caption = 'Identification';
    fields
    {
        field(1; "Identification Code"; Code[20])
        {
            Caption = 'Code';
            DataClassification = CustomerContent;
        }
        field(21; "Description"; Text[50])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(22; "Issuing Agency"; Code[20])
        {
            Caption = 'Issuing Agency';
            DataClassification = CustomerContent;
            TableRelation = "Issuing Agency";
        }
        field(23; "Alert Formula"; DateFormula)
        {
            Caption = 'Alert Formula';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Identification Code")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
        fieldgroup(Dropdown; "Identification Code", Description)
        {

        }
        fieldgroup(Brick; "Identification Code", Description)
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