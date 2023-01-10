table 50095 "Loan Group"
{
    DataClassification = CustomerContent;
    Caption = 'Loan Group';
    LookupPageId = "Loan Groups";
    DrillDownPageId = "Loan Groups";
    fields
    {
        field(1; "Code"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(21; Description; Text[100])
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Code")
        {
            Clustered = true;
        }
    }
    var
        RenameRestrictedErr: Label 'You can''t rename the code';

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin
        Error(RenameRestrictedErr);
    end;

    trigger OnRename()
    begin

    end;

}