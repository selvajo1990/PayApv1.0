
table 50023 "Employee Bank Account Master"
{
    DataClassification = CustomerContent;
    Caption = 'Employee Bank Account Master';
    LookupPageId = "Bank Account Master";
    fields
    {
        field(1; Code; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Bank Short Code';
        }
        field(2; "Bank Name"; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Bank Name';
        }
        field(3; "Swift Code"; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Swift Code';
        }
        field(4; "Branch Name"; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Branch Name';
        }
        field(5; "Branch Address"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Branch Address';
        }
        field(6; "Contact Person"; Text[30])
        {
            DataClassification = CustomerContent;
            Caption = 'Contact Person';
        }
        field(7; "Contact No."; Text[30])
        {
            DataClassification = CustomerContent;
            Caption = 'Contact No.';
            ExtendedDatatype = PhoneNo;
        }
        field(8; "Contact Email"; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Contact Email';
            ExtendedDatatype = EMail;
        }
        field(9; "Website"; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Website URL';
            ExtendedDatatype = URL;
        }
    }

    keys
    {
        key(PK; Code)
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
        fieldgroup(DropDown; Code, "Bank Name")
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