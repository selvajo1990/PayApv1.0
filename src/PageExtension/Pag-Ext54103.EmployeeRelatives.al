pageextension 54103 "Employee Relatives" extends "Employee Relatives"
{
    layout
    {
        addbefore(Comment)
        {
            field("Emergency Contact"; Rec."Emergency Contact")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Emergency Contact';
            }
            field(Dependent; Rec.Dependent)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Dependent';
            }
            field("Air Ticket"; Rec."Air Ticket")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Air Ticket';
            }
            field("Passport No"; "Passport No")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Passport No';
            }
            field("Passport Expiry"; "Passport Expiry")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Passport Expiry';
            }
            field("Visa No"; "Visa No")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Visa No';
            }
            field("Visa Expiry"; "Visa Expiry")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Visa Expiry';
            }
            field("Policy No"; "Policy No")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Visa Expiration';
            }
            field("Policy Expiration"; "Policy Expiration")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Policy Expiration';
            }
            field("Visa Cost"; "Visa Cost")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Visa Cost';
            }
            field("Air Fare"; "Air Fare")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Air Fare';
            }
            field("Insurance Cost"; "Insurance Cost")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Insurance Cost';
            }
        }
        addbefore("Birth Date")
        {
            field(Gender; Rec.Gender)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Gender';
            }
        }
        addafter("Birth Date")
        {
            field("Age Group"; Rec."Age Group")
            {
                ApplicationArea = All;
                Visible = false;
                ToolTip = 'Specifies the value of the Age Group';
            }
        }
        modify(Comment)
        {
            Visible = false;
        }
    }

    actions
    {

    }

}