table 50128 "Legacy Data"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'SI.No.';
        }
        field(2; Date; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Employee Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Employee Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(5; "MOL Code"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Employee Bank Name"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(7; IBAN; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(8; Attendance; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(9; "Cost Center"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(10; Basic; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(11; HRA; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(12; "Additional Allownace"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(13; Incentive; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(14; Cell; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(15; Transport; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(16; Total; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(17; "Advance Deduction"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(18; "Loan Deduction"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(19; "Other Deduction"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(20; "Other Addition"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(21; "Net Payable"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(22; "WPS Fixed"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(23; "WPS Variable"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(24; "NET WPS"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
    }


    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;

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
