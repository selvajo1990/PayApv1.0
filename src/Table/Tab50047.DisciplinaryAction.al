table 50047 "Disciplinary Action"
{
    DataClassification = CustomerContent;
    Caption = 'Disciplinary Action';
    LookupPageId = "Disciplinary Action List";
    fields
    {
        field(1; "Reason Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Reason Code';
            TableRelation = "Reason Code";
            trigger OnValidate()
            var
                ReasonCodeL: Record "Reason Code";
            begin
                if ReasonCodeL.Get("Reason Code") then;
                "Reason Description" := ReasonCodeL."Description";
            end;
        }
        field(3; "Reason Description"; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Reason Description';
            Editable = false;
        }
        field(2; "Disciplinary Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Disciplinary Code';
        }
        field(4; "Notes"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Notes';
        }

        field(6; "No. of Days"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'No. of Days';
        }
        field(7; "Date"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Date';
        }

    }

    keys
    {
        key(PK; "Reason Code", "Disciplinary Code")
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