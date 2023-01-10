table 50056 "Absence Group"
{
    DataClassification = CustomerContent;
    Caption = 'Absence Group';
    LookupPageId = "Absence Group List";

    fields
    {
        field(1; "Absence Group Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Absence Group Code';
        }
        field(2; "Description"; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Description';
        }
    }

    keys
    {
        key(PK; "Absence Group Code")
        {
            Clustered = true;
        }
    }
    var
        AbsenceGroupLineG: Record "Absence Group Line";
        DeleteNotPossibleErr: Label 'The group is assigned to employee(s). You can''t delete the group.';

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    var
        EmployeeL: Record Employee;
    begin
        EmployeeL.SetRange("Absence Group", "Absence Group Code");
        if not EmployeeL.IsEmpty() then
            Error(DeleteNotPossibleErr);
        AbsenceGroupLineG.SetRange("Absence Group Code", "Absence Group Code");
        AbsenceGroupLineG.DeleteAll();
    end;

    trigger OnRename()
    begin

    end;

}