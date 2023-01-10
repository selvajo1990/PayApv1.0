table 50119 "Types Of Insurance"
{
    DataClassification = CustomerContent;
    LookupPageId = "Insurance Type List";
    fields
    {
        field(1; Code; Code[10])
        {
            DataClassification = CustomerContent;

        }
        field(2; Description; text[50])
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; Code)
        {
            Clustered = true;
        }
    }

    var
        InsInfo: record "Insurance Information";

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin
        InsInfo.Reset();
        InsInfo.SetRange("Type of Insurance Code", Code);
        if InsInfo.FindSet() then
            error('Related records are available , So you cannot Delete the record');
    end;

    trigger OnRename()
    begin

    end;

}