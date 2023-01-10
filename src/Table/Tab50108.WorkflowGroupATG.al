table 50108 "Workflow Group ATG"
{
    DataClassification = CustomerContent;
    Caption = 'Workflow Group ATG';
    LookupPageId = 60019;
    DrillDownPageId = 60019;
    fields
    {
        field(1; Code; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Code';
        }
        field(21; Description; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Description';
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
        WorkflowGroupMember: Record "Workflow Group Member ATG";

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin
        WorkflowGroupMember.SetRange("Workflow Group Code", Code);
        WorkflowGroupMember.DeleteAll(true);
    end;

    trigger OnRename()
    begin

    end;

}