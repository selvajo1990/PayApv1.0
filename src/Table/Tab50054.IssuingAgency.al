table 50054 "Issuing Agency"
{
    DataClassification = CustomerContent;
    Caption = 'Issuing Agency';
    LookupPageId = "Issuing Agency";
    fields
    {
        field(1; "Issuing Agency Code"; Code[20])
        {
            Caption = 'Issuing Agency Code';
            DataClassification = CustomerContent;
        }
        field(2; "Description"; Text[50])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(3; Notes; Text[250])
        {
            Caption = 'Notes';
            DataClassification = CustomerContent;
        }
        field(4; "Contact No."; Text[20])
        {
            Caption = 'Contact No.';
            DataClassification = CustomerContent;
            ExtendedDatatype = PhoneNo;
        }
        field(5; "Contact Email"; Text[50])
        {
            Caption = 'Contact Email';
            DataClassification = CustomerContent;
            ExtendedDatatype = EMail;
        }
        field(6; Website; Text[50])
        {
            Caption = 'Website URL';
            DataClassification = CustomerContent;
            ExtendedDatatype = URL;
        }

    }

    keys
    {
        key(PK; "Issuing Agency Code")
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