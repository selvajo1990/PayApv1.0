table 50025 "Employee Level Identification"
{
    DataClassification = CustomerContent;
    LookupPageId = "Employee Level Identification";
    Caption = 'Employee Level Identification';

    fields
    {
        field(1; "Employee No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Employee No.';
        }
        field(2; Code; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Code';
            TableRelation = Identification;

            trigger OnValidate()
            var
                IdentificationL: Record Identification;
            begin
                if IdentificationL.Get(Code) then;
                Description := IdentificationL.Description;
                "Issuing Agency" := IdentificationL."Issuing Agency";
            end;
        }
        field(3; "Line No"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Line No.';
        }
        field(21; Description; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Description';
        }
        field(22; "Issuing Agency"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Issuing Agency';
            TableRelation = "Issuing Agency";
        }
        field(23; "Issued Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Issued Date';
        }
        field(24; "Expiry Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Expiry Date';
        }
        field(25; "Amount"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Amount';
        }
        field(26; "Serial No."; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Serial No.';
        }
        field(27; "Employee Name"; Text[50])
        {
            Caption = 'Employee Name';
            FieldClass = FlowField;
            CalcFormula = lookup(Employee."First Name" where("No." = field("Employee No.")));
        }
    }
    keys
    {
        key(PK; "Employee No.", Code, "Line No")
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
