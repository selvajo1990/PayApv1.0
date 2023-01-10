table 50111 "Notification Setup ATG"
{
    DataClassification = CustomerContent;
    Caption = 'Notification Setup ATG';
    fields
    {
        field(1; "Employee No. ATG"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Employee No.';
            TableRelation = "Employee ATG";
        }
        field(21; "Notification Method ATG"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = Email,Note;
            OptionCaption = 'Email,Note';
        }
        field(22; "Schedule"; Option)
        {
            OptionMembers = Instantly,Daily,Weekly,Monthly;
            OptionCaption = 'Instantly,Daily,Weekly,Monthly';
            FieldClass = FlowField;
        }

    }

    keys
    {
        key(PK; "Employee No. ATG")
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

    procedure GetNotificationSetupForUser(RecipientEmployeeNo: Code[20])
    var
        NotificationSetup: Record "Notification Setup ATG";
    begin
        if Get(RecipientEmployeeNo) then
            exit;

        if Get('') then
            exit;

        NotificationSetup.Init();
        NotificationSetup.Validate("Notification Method ATG", NotificationSetup."Notification Method ATG"::Email);
        NotificationSetup.Schedule := NotificationSetup.Schedule::Instantly;
        NotificationSetup.Insert(true);

        if Get('') then
            exit;
    end;

}