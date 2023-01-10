table 50051 "Computation"
{
    DataClassification = CustomerContent;
    Caption = 'Computation';
    LookupPageId = "Computation List";

    fields
    {
        field(1; "Computation Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Computation Code';
        }
        field(2; Description; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Description';
        }
    }
    keys
    {
        key(PK; "Computation Code")
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
    var
        ComputationLineL: Record "Computation Line Detail";
    begin
        ComputationLineL.SetRange("Computation Code", "Computation Code");
        ComputationLineL.DeleteAll();
    end;

    trigger OnRename()
    var
        RenamedRestrictedErr: Label 'You cannot rename the code';
    begin
        Error(RenamedRestrictedErr);
    end;
}
