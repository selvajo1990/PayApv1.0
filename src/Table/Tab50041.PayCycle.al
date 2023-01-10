table 50041 "Pay Cycle"
{
    DataClassification = CustomerContent;
    Caption = 'Pay Cycle';
    LookupPageId = "Pay Cycle List";
    fields
    {
        field(1; "Pay Cycle"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Pay Cycle';
        }
        field(2; Description; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Description';
        }
        field(3; "Pay Cycle Frequency"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = "Monthly";
            OptionCaption = 'Monthly';
            Caption = 'Pay Cycle Frequency';
        }
    }

    keys
    {
        key(PK; "Pay Cycle")
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