table 50109 "Workflow Group Member ATG"
{
    DataClassification = CustomerContent;
    Caption = 'Workflow Group Member ATG';

    fields
    {
        field(1; "Workflow Group Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Workflow Group Code';
            TableRelation = "Workflow Group ATG".Code;
        }
        field(2; "Employee No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Employee ATG";
            Caption = 'Employee No.';
            trigger OnValidate()
            begin
                Employee.Get("Employee No.");

                if "Sequence No." = 0 then begin
                    SequenceNo := 1;
                    WorkflowGroupMember.SetCurrentKey("Workflow Group Code", "Sequence No.");
                    WorkflowGroupMember.SetRange("Workflow Group Code", "Workflow Group Code");
                    if WorkflowGroupMember.FindLast() then
                        SequenceNo := WorkflowGroupMember."Sequence No." + 1;
                    Validate("Sequence No.", SequenceNo);
                end;
            end;
        }
        field(21; "Sequence No."; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Sequence No.';
            MinValue = 1;
        }
    }

    keys
    {
        key(PK; "Workflow Group Code", "Employee No.")
        {
            Clustered = true;
        }
    }
    var
        Employee: Record "Employee ATG";
        WorkflowGroupMember: Record "Workflow Group Member ATG";
        SequenceNo: Integer;

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