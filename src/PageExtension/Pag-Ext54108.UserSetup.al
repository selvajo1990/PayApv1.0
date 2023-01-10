pageextension 54108 "User Setup" extends "User Setup"
{
    layout
    {
        addafter(PhoneNo)
        {

            field("Is ESS User"; Rec."Is ESS User")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Is ESS User field.';
            }
        }
    }
}
