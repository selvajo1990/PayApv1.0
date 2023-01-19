table 50130 "Attendance Entry"
{
    Caption = 'Attendance Entry';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Employee ID"; Code[20])
        {
            Caption = 'Employee ID';
            DataClassification = CustomerContent;
        }
        field(2; "Entry Date"; Date)
        {
            Caption = 'Entry Date';
            DataClassification = CustomerContent;
        }
        field(3; Location; Text[100])
        {
            DataClassification = CustomerContent;
        }
        field(20; "Location Name"; Text[100])
        {
            DataClassification = CustomerContent;
        }
        field(21; "Start Time"; Time)
        {
            Caption = 'Start Time';
            DataClassification = CustomerContent;
        }
        field(22; "End Time"; Time)
        {
            Caption = 'End Time';
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(PK; "Employee ID", "Entry Date")
        {
            Clustered = true;
        }
    }
}
