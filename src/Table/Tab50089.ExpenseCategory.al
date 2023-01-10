table 50089 "Expense Category"
{
    DataClassification = CustomerContent;
    Caption = 'Expense Category';
    LookupPageId = 50134;
    DrillDownPageId = 50134;
    fields
    {
        field(1; "Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Code';
        }
        field(21; "Description"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Description';
        }
        field(22; "Travel Payment Type"; Option)
        {
            OptionMembers = "Per Day","Hourly","Fixed Amount","Actuals/ As per Bill","Per Kilometer";
            OptionCaption = 'Per Day,Hourly,Fixed Amount,Actuals/ As per Bill,Per Kilometer';
            DataClassification = CustomerContent;
            Caption = 'Travel Payment Type';

        }
        field(24; "Main Account"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Main Account';
            TableRelation = "G/L Account";
        }
        field(25; "Sub Account"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Sub Account';
            TableRelation = "G/L Account";
        }
        field(26; "Attachment Required"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Attachment Required';
        }
        field(27; "Travel Type"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = Advance,Claim;
            OptionCaption = 'Advance,Claim';
            Caption = 'Expense Type';
        }
    }

    keys
    {
        key(PK; Code)
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