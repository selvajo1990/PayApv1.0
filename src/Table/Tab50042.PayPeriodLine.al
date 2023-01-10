table 50042 "Pay Period Line"
{
    DataClassification = CustomerContent;
    Caption = 'Pay Period Line';
    LookupPageId = "Pay Cycle Line List";
    fields
    {
        field(1; "Pay Cycle"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Pay Cycle';
        }
        field(2; "Pay Period"; Code[30])
        {
            DataClassification = CustomerContent;
            Caption = 'Pay Period';
        }
        field(21; "Period Start Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Period Start Date';
        }
        field(22; "Period End Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Period End Date';
        }

        field(23; Status; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = "Open","Closed";
            OptionCaption = 'Open,Close';
            Caption = 'Status';
        }
        field(24; "Comments"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Comments';
        }
        field(25; "No. of Period"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'No. of Period';
        }

    }

    keys
    {
        key(PK; "Pay Cycle", "Pay Period")
        {
            Clustered = true;
        }
        key(SK; "Period Start Date", "Period End Date")
        {

        }
    }
    fieldgroups
    {
        fieldgroup(DropDown; "Pay Period", "Period Start Date", "Period End Date")
        {

        }
        fieldgroup(Brick; "Pay Period", "Period Start Date", "Period End Date")
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
        TestField(Status, Status::Open);
    end;

    trigger OnRename()
    begin

    end;

}