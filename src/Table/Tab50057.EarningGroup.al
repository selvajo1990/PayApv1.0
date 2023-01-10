table 50057 "Earning Group"
{
    DataClassification = CustomerContent;
    Caption = 'Earning Group';
    LookupPageId = "Earning Group List";

    fields
    {
        field(1; "Earning Group Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Earning Group Code';
        }
        field(2; "Description"; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Description';
        }
    }

    keys
    {
        key(PK; "Earning Group Code")
        {
            Clustered = true;
        }
    }
    var
        EarningGroupLineG: Record "Earning Group Line";

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin
        EarningGroupLineG.SetRange("Group Code", "Earning Group Code");
        EarningGroupLineG.DeleteAll();
    end;

    trigger OnRename()
    begin

    end;

}