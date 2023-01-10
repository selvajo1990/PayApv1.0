table 50112 "Notification Schedule ATG"
{
    DataClassification = CustomerContent;
    Caption = 'Notification Schedule ATG';

    fields
    {
        field(1; "Employee No ATG"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Employee No.';
            TableRelation = "Employee ATG";
        }
        field(21; "Recurrence ATG"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = Instantly,Daily,Weekly,Monthly;
            OptionCaption = 'Instantly,Daily,Weekly,Monthly';
            Caption = 'Recurrence';
        }
        field(22; "Time ATG"; Time)
        {
            DataClassification = CustomerContent;
            Caption = 'Time';
        }
        field(23; "Daily Frequency ATG"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = Weekday,Daily;
            OptionCaption = 'Weekday,Daily';
            Caption = 'Daily Frequency';
        }
        field(24; "Monday ATG"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Monday';
        }
        field(25; "Tuesday ATG"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Tuesday';
        }
        field(26; "Wednesday ATG"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Wednesday';
        }
        field(27; "Thursday ATG"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Thursday';
        }
        field(28; "Friday ATG"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Friday';
        }
        field(29; "Saturday ATG"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Saturday';
        }
        field(30; "Sunday ATG"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Sunday';
        }
        field(31; "Date of Month ATG"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Date of Month';
            MinValue = 1;
            MaxValue = 31;
        }
        field(32; "Monthly Notification Date ATG"; Option)
        {
            DataClassification = CustomerContent;
            Caption = 'Monthly Notification Date';
            OptionMembers = "First Workday","Last Workday",Custom;
            OptionCaption = 'First Workday,Last Workday,Custom';
        }
        field(33; "Last Scheduled Job ATG"; Guid)
        {
            DataClassification = CustomerContent;
            Caption = 'Last Scheduled Job';
        }
    }

    keys
    {
        key(PK; "Employee No ATG")
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

    procedure ScheduleNotification(NotificationEntry: Record "Notification Entry ATG")
    begin

    end;

}