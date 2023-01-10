table 50083 "Gratuity Formula"
{
    DataClassification = CustomerContent;
    Caption = 'Gratuity Formula';
    DrillDownPageId = "Gratuity Formula";
    LookupPageId = "Gratuity Formula";
    fields
    {
        field(1; "Earning Code"; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Earning Code';
            TableRelation = Earning;
        }
        field(2; "Reason Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Reason Code';
            TableRelation = "Reason Code";
        }
        field(3; "To Days"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'To Days';
        }
        field(21; "Days Upto"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Days Upto';
            trigger OnValidate()
            begin
                if "Days Upto" > "To Days" then
                    Error(DaysUptoCantExeedErr, FieldCaption("Days Upto"), "To Days");
            end;
        }
        field(22; "No. of Days"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'No. of Days';
        }
    }

    keys
    {
        key(PK; "Earning Code", "Reason Code", "To Days", "Days Upto")
        {
            Clustered = true;
        }
    }

    var
        DaysUptoCantExeedErr: Label '%1 can''t exceed %2';

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