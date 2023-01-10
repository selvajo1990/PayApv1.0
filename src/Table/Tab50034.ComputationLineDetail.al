table 50034 "Computation Line Detail"
{
    DataClassification = CustomerContent;
    Caption = 'Computation Line Details';
    LookupPageId = "Computation List";

    fields
    {
        field(1; "Computation Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Computation Code';
        }
        field(2; "Line No."; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Line No.';
        }
        field(3; "Earning Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Earning Code';
            TableRelation = Earning;
            trigger OnValidate()
            var
                EarningL: Record Earning;
            begin
                if EarningL.Get("Earning Code") then;
                "Earning Description" := EarningL.Description;
            end;
        }
        field(4; "Earning Description"; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Earning Description';
        }
        field(5; Percentage; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Percentage';
            MinValue = 0;
        }
        field(6; "Pay Amount"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Pay Amount';
            Editable = false;
        }
    }
    keys
    {
        key(PK; "Computation Code", "Line No.")
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
