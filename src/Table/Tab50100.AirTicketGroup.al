table 50100 "Air Ticket Group"
{
    DataClassification = CustomerContent;
    Caption = 'Air Ticket Group';
    DrillDownPageId = "Air Ticket Groups";
    LookupPageId = "Air Ticket Groups";
    fields
    {
        field(1; "Air Ticket Group Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Air Ticket Group Code';
        }
        field(21; Description; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Description';
        }
        field(22; "Dependent Allowed"; Option)
        {
            DataClassification = CustomerContent;
            Caption = 'Dependents Allowed';
            OptionMembers = Zero,One,Two,Three,Four,Five,Six,Seven,Eight;
            OptionCaption = '0,1,2,3,4,5,6,7,8';
        }
        field(23; "Class Type"; Option)
        {
            DataClassification = CustomerContent;
            Caption = 'Class Type';
            OptionMembers = Economy,First,Business;
            OptionCaption = 'Economy,First,Business';
        }
        field(24; Accrual; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Accrual';
        }
        field(25; "Accruing Type"; Option)
        {
            DataClassification = CustomerContent;
            Caption = 'Accruing Type';
            OptionMembers = Amount,Ticket;
            OptionCaption = 'Amount,Ticket';
        }
        field(26; Provision; Integer)
        {
            DataClassification = CustomerContent;
            MinValue = 365;
            Caption = 'Provision';
            trigger OnValidate()
            begin
                "Accrual Expiry Days" := 0;
            end;
        }
        field(27; "Days Between"; Integer)
        {
            DataClassification = CustomerContent;
            MinValue = 0;
            Caption = 'Days Between';
        }
        field(28; "Accrual Expiry Days"; Integer)
        {
            DataClassification = CustomerContent;
            MinValue = 0;
            Caption = 'Accrual Expiry Days';
            trigger OnValidate()
            var
                DateErr: Label '%1 can''t be earlier than %2';
            begin
                if "Accrual Expiry Days" > 0 then begin
                    TestField(Provision);
                    if "Accrual Expiry Days" < Provision then
                        Error(DateErr, FieldCaption("Accrual Expiry Days"), FieldCaption(Provision));
                end;
            end;
        }
        field(29; "Minimum Tenure (In days)"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Minimum Tenure (In days)';
            MinValue = 0;
        }
    }

    keys
    {
        key(PK; "Air Ticket Group Code")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
        fieldgroup(DropDown; "Air Ticket Group Code", Description)
        {

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