table 50105 "Approval Setup ATG"
{
    DataClassification = CustomerContent;
    Caption = 'Approval Setup ATG';
    fields
    {
        field(1; "Approval Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Approval Code';
        }
        field(21; "Description"; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Description';
        }
        field(22; "Approver Type"; Option)
        {
            OptionMembers = " ",Approver,"Workflow User Group";
            OptionCaption = ' ,Approver,Workflow User Group';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                if xRec."Approver Type" <> "Approver Type" then begin
                    Clear("Approver Limit Type");
                    Clear("Workflow User Group Code");
                end;
            end;
        }
        field(23; "Approver Limit Type"; Option)
        {
            OptionMembers = "Approver Chain","Direct Approver","First Qualified Approver","Specific Approver";
            DataClassification = CustomerContent;
            OptionCaption = 'Approver Chain,Direct Approver,First Qualified Approver,Specific Approver';
            Caption = 'Approver Limit Type';
        }
        field(24; "Workflow User Group Code"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Workflow Group ATG";
            Caption = 'Workflow Group Code';
        }

    }

    keys
    {
        key(PK; "Approval Code")
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